-- Migration 053: Make streak, daily check-in, weekly leaderboard, and streak-reminder
-- logic use Asia/Jakarta (WIB) time instead of the database default UTC.
--
-- Koinaku is Indonesian-first; learners expect "today" to mean WIB. Without this,
-- a lesson completed at 07:00 WIB is recorded as "yesterday" UTC, which makes
-- recompute_streak_status mark the streak at_risk/broken and breaks the daily
-- check-in counters.
--
-- Existing daily_checkins and streak rows store UTC dates from before this fix.
-- Those rows are left as-is; only new calculations use WIB.

BEGIN;

-- 1. complete_lesson: latest version (052) with WIB timezone.
CREATE OR REPLACE FUNCTION complete_lesson(
  p_user_id UUID,
  p_lesson_id UUID,
  p_score INTEGER,
  p_max_score INTEGER,
  p_answers_json JSONB,
  p_time_spent_seconds INTEGER,
  p_quiz_correct BOOLEAN
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
SET timezone = 'Asia/Jakarta'
AS $$
DECLARE
  v_today DATE := CURRENT_DATE;
  v_lesson RECORD;
  v_topic_id UUID;
  v_xp INTEGER;
  v_total_xp INTEGER;
  v_lesson_xp_awarded INTEGER := 0;
  v_quiz_bonus_awarded INTEGER := 0;
  v_checkin JSONB;
  v_new_streak INTEGER;
  v_streak_status TEXT;
  v_badges JSONB := '[]'::jsonb;
  v_badge RECORD;
  v_completed_count INTEGER;
  v_total_lessons INTEGER;
  v_next_lesson_slug TEXT;
  v_attempt_number INTEGER;
  v_existing_status TEXT;
  v_is_first_completion BOOLEAN;
  v_result JSONB;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT id, xp_reward, topic_id, lesson_number, slug
  INTO v_lesson
  FROM lessons
  WHERE id = p_lesson_id AND is_published = TRUE;

  IF v_lesson IS NULL THEN
    RAISE EXCEPTION 'Lesson not found or not published';
  END IF;

  SELECT status INTO v_existing_status
  FROM lesson_progress
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  v_is_first_completion := (v_existing_status IS DISTINCT FROM 'completed');

  IF v_is_first_completion AND (p_time_spent_seconds IS NULL OR p_time_spent_seconds < 10) THEN
    RAISE EXCEPTION 'Lesson completed too quickly' USING ERRCODE = 'check_violation';
  END IF;

  v_topic_id := v_lesson.topic_id;
  v_xp := v_lesson.xp_reward;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_attempt_number
  FROM lesson_attempts
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  INSERT INTO lesson_attempts (
    user_id, lesson_id, attempt_number, score, max_score,
    completed, completed_at, answers_json, time_spent_seconds
  ) VALUES (
    p_user_id, p_lesson_id, v_attempt_number, p_score, p_max_score,
    TRUE, NOW(), p_answers_json, p_time_spent_seconds
  );

  INSERT INTO lesson_progress (
    user_id, lesson_id, status, best_score, attempts_count,
    first_completed_at, last_attempted_at
  ) VALUES (
    p_user_id, p_lesson_id, 'completed', p_score, 1, NOW(), NOW()
  )
  ON CONFLICT (user_id, lesson_id)
  DO UPDATE SET
    status = 'completed',
    best_score = GREATEST(lesson_progress.best_score, EXCLUDED.best_score),
    attempts_count = lesson_progress.attempts_count + 1,
    last_attempted_at = NOW(),
    first_completed_at = COALESCE(lesson_progress.first_completed_at, NOW());

  IF NOT EXISTS (
    SELECT 1 FROM xp_events
    WHERE user_id = p_user_id AND source_type = 'lesson_complete' AND source_id = p_lesson_id
  ) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'lesson_complete', p_lesson_id, v_xp);
    v_lesson_xp_awarded := v_xp;
  END IF;

  IF p_quiz_correct AND NOT EXISTS (
    SELECT 1 FROM xp_events
    WHERE user_id = p_user_id AND source_type = 'quiz_bonus' AND source_id = p_lesson_id
  ) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'quiz_bonus', p_lesson_id, 10);
    v_quiz_bonus_awarded := 10;
  END IF;

  v_total_xp := v_lesson_xp_awarded + v_quiz_bonus_awarded;

  INSERT INTO daily_checkins (user_id, checkin_date, xp_earned)
  VALUES (p_user_id, v_today, v_total_xp)
  ON CONFLICT (user_id, checkin_date)
  DO UPDATE SET xp_earned = daily_checkins.xp_earned + v_total_xp;

  v_checkin := check_in_streak(p_user_id);
  v_new_streak := (v_checkin->>'current_streak_days')::INTEGER;
  v_streak_status := v_checkin->>'streak_status';

  IF v_new_streak IN (3, 7, 14, 30) AND NOT EXISTS (
    SELECT 1 FROM xp_events
    WHERE user_id = p_user_id
      AND source_type = 'streak_milestone'
      AND created_at >= v_today
  ) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'streak_milestone', p_lesson_id, 25);
    v_total_xp := v_total_xp + 25;

    PERFORM award_koin_points(p_user_id, 50, 'streak_milestone', p_lesson_id, format('%s-day streak milestone', v_new_streak));
  END IF;

  IF v_is_first_completion THEN
    PERFORM award_koin_points(p_user_id, 10, 'lesson_complete', p_lesson_id, 'Lesson completed');
  END IF;

  IF v_is_first_completion THEN
    SELECT COUNT(*) INTO v_total_lessons
    FROM lessons
    WHERE topic_id = v_topic_id AND is_published = TRUE;

    IF v_total_lessons = 0 THEN
      v_total_lessons := 1;
    END IF;

    INSERT INTO user_mastery (user_id, topic_id, lessons_completed, total_lessons, mastery_score, last_updated)
    VALUES (p_user_id, v_topic_id, 1, v_total_lessons, (1.0 / v_total_lessons * 100)::INTEGER, NOW())
    ON CONFLICT (user_id, topic_id)
    DO UPDATE SET
      lessons_completed = LEAST(user_mastery.lessons_completed + 1, v_total_lessons),
      total_lessons = v_total_lessons,
      mastery_score = (LEAST(user_mastery.lessons_completed + 1, v_total_lessons)::FLOAT / v_total_lessons * 100)::INTEGER,
      last_updated = NOW();
  END IF;

  SELECT COUNT(*) INTO v_completed_count
  FROM lesson_progress
  WHERE user_id = p_user_id AND status = 'completed';

  FOR v_badge IN
    SELECT id, slug, name, icon, trigger_value
    FROM badges
    WHERE trigger_type = 'lesson_complete'
  LOOP
    IF (v_badge.trigger_value->>'count') IS NOT NULL THEN
      IF v_completed_count < (v_badge.trigger_value->>'count')::INTEGER THEN
        CONTINUE;
      END IF;
    ELSIF (v_badge.trigger_value->>'lesson_slug') IS NOT NULL THEN
      IF v_badge.trigger_value->>'lesson_slug' <> v_lesson.slug THEN
        CONTINUE;
      END IF;
    ELSE
      CONTINUE;
    END IF;

    INSERT INTO user_badges (user_id, badge_id)
    VALUES (p_user_id, v_badge.id)
    ON CONFLICT (user_id, badge_id) DO NOTHING;

    IF FOUND THEN
      v_badges := v_badges || jsonb_build_object(
        'slug', v_badge.slug,
        'name', v_badge.name,
        'icon', v_badge.icon
      );
    END IF;
  END LOOP;

  SELECT slug INTO v_next_lesson_slug
  FROM lessons
  WHERE lesson_number > v_lesson.lesson_number AND is_published = TRUE
  ORDER BY lesson_number ASC
  LIMIT 1;

  v_result := jsonb_build_object(
    'xp_earned', v_total_xp,
    'lesson_xp', v_lesson_xp_awarded,
    'quiz_bonus', v_quiz_bonus_awarded,
    'streak_days', v_new_streak,
    'streak_status', v_streak_status,
    'badges_earned', v_badges,
    'next_lesson_slug', v_next_lesson_slug,
    'already_completed', NOT v_is_first_completion
  );

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) TO authenticated;

-- 2. check_in_streak and recompute_streak_status with WIB timezone.
CREATE OR REPLACE FUNCTION check_in_streak(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET timezone = 'Asia/Jakarta'
AS $$
DECLARE
  v_record streaks%ROWTYPE;
  v_today DATE := CURRENT_DATE;
  v_last DATE;
  v_gap INTEGER;
  v_used_freeze BOOLEAN := false;
  v_broken BOOLEAN := false;
  v_already_checked_in BOOLEAN := false;
BEGIN
  SELECT * INTO v_record FROM streaks WHERE user_id = p_user_id FOR UPDATE;

  IF NOT FOUND THEN
    INSERT INTO streaks (user_id, current_streak_days, longest_streak_days, streak_freezes_available, last_completed_on, streak_status)
    VALUES (p_user_id, 1, 1, 1, v_today, 'active');

    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'preserved', 1);

    RETURN jsonb_build_object(
      'current_streak_days', 1,
      'longest_streak_days', 1,
      'streak_status', 'active',
      'used_freeze', false,
      'broken', false,
      'already_checked_in', false
    );
  END IF;

  v_last := v_record.last_completed_on;

  IF v_last = v_today THEN
    RETURN jsonb_build_object(
      'current_streak_days', v_record.current_streak_days,
      'longest_streak_days', v_record.longest_streak_days,
      'streak_status', v_record.streak_status,
      'used_freeze', false,
      'broken', false,
      'already_checked_in', true
    );
  END IF;

  v_gap := v_today - v_last;

  IF v_gap = 1 THEN
    v_record.current_streak_days := v_record.current_streak_days + 1;
    v_record.streak_status := 'active';
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'preserved', v_record.current_streak_days);
  ELSIF v_gap > 1 AND v_record.streak_freezes_available > 0 THEN
    v_record.streak_freezes_available := v_record.streak_freezes_available - 1;
    v_record.streak_status := 'frozen';
    v_used_freeze := true;
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'freeze_used', v_record.current_streak_days);
  ELSE
    v_record.current_streak_days := 1;
    v_record.streak_status := 'active';
    v_broken := true;
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'broken', 1);
  END IF;

  v_record.last_completed_on := v_today;

  IF v_record.current_streak_days > v_record.longest_streak_days THEN
    v_record.longest_streak_days := v_record.current_streak_days;
  END IF;

  UPDATE streaks
  SET current_streak_days = v_record.current_streak_days,
      longest_streak_days = v_record.longest_streak_days,
      streak_freezes_available = v_record.streak_freezes_available,
      last_completed_on = v_record.last_completed_on,
      streak_status = v_record.streak_status
  WHERE user_id = p_user_id;

  RETURN jsonb_build_object(
    'current_streak_days', v_record.current_streak_days,
    'longest_streak_days', v_record.longest_streak_days,
    'streak_status', v_record.streak_status,
    'used_freeze', v_used_freeze,
    'broken', v_broken,
    'already_checked_in', false
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION check_in_streak(UUID) FROM authenticated, anon, PUBLIC;

CREATE OR REPLACE FUNCTION recompute_streak_status(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET timezone = 'Asia/Jakarta'
AS $$
DECLARE
  v_record streaks%ROWTYPE;
  v_today DATE := CURRENT_DATE;
  v_gap INTEGER;
BEGIN
  SELECT * INTO v_record FROM streaks WHERE user_id = p_user_id FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('status', 'missing');
  END IF;

  IF v_record.last_completed_on = v_today THEN
    IF v_record.streak_status <> 'active' THEN
      UPDATE streaks SET streak_status = 'active' WHERE user_id = p_user_id;
    END IF;
    RETURN jsonb_build_object('status', 'active');
  END IF;

  v_gap := v_today - v_record.last_completed_on;

  IF v_gap = 1 THEN
    IF v_record.streak_status <> 'at_risk' THEN
      UPDATE streaks SET streak_status = 'at_risk' WHERE user_id = p_user_id;
    END IF;
    RETURN jsonb_build_object('status', 'at_risk');
  END IF;

  IF v_record.streak_status NOT IN ('broken', 'frozen') AND v_record.streak_freezes_available = 0 THEN
    UPDATE streaks SET streak_status = 'broken' WHERE user_id = p_user_id;
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'broken', v_record.current_streak_days)
    ON CONFLICT DO NOTHING;
    RETURN jsonb_build_object('status', 'broken');
  END IF;

  RETURN jsonb_build_object('status', v_record.streak_status);
END;
$$;

GRANT EXECUTE ON FUNCTION recompute_streak_status(UUID) TO authenticated;

-- 3. Streak reminder candidates with WIB timezone.
CREATE OR REPLACE FUNCTION get_streak_reminder_candidates(p_current_time TIME)
RETURNS TABLE (
  user_id UUID,
  email TEXT,
  display_name TEXT,
  current_streak_days INTEGER,
  streak_status TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET timezone = 'Asia/Jakarta'
AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id AS user_id,
    u.email::TEXT AS email,
    p.display_name::TEXT AS display_name,
    s.current_streak_days,
    s.streak_status::TEXT
  FROM profiles p
  JOIN auth.users u ON u.id = p.id
  JOIN streaks s ON s.user_id = p.id
  JOIN user_settings us ON us.user_id = p.id
  WHERE us.notifications_enabled = TRUE
    AND us.streak_reminder_time <= p_current_time
    AND s.current_streak_days > 0
    AND s.last_completed_on = CURRENT_DATE - 1
    AND s.streak_status NOT IN ('broken', 'frozen')
    AND NOT EXISTS (
      SELECT 1 FROM notifications_queue nq
      WHERE nq.user_id = p.id
        AND nq.notification_type = 'streak_reminder'
        AND nq.sent_at::DATE = CURRENT_DATE
    );
END;
$$;

-- 4. Weekly leaderboard with WIB week start.
CREATE OR REPLACE FUNCTION get_weekly_leaderboard(p_user_id UUID, p_scope TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
SET timezone = 'Asia/Jakarta'
AS $$
DECLARE
  v_week_start DATE := DATE_TRUNC('week', CURRENT_DATE)::DATE;
  v_xp_json JSONB;
  v_kp_json JSONB;
BEGIN
  IF p_scope NOT IN ('global', 'friends') THEN
    RAISE EXCEPTION 'Invalid scope. Must be global or friends.';
  END IF;

  WITH eligible_users AS (
    SELECT p.id, COALESCE(p.display_name, 'Learner') AS display_name, p.created_at
    FROM profiles p
    WHERE p_scope = 'global'
       OR (p_scope = 'friends' AND (
         EXISTS (
           SELECT 1 FROM friendships f
           WHERE f.status = 'accepted'
             AND ((f.requester_id = p_user_id AND f.addressee_id = p.id) OR (f.requester_id = p.id AND f.addressee_id = p_user_id))
         )
         OR p.id = p_user_id
       ))
  ),
  xp_totals AS (
    SELECT x.user_id, COALESCE(SUM(x.xp_amount), 0)::INTEGER AS xp_this_week
    FROM xp_events x
    WHERE x.created_at >= v_week_start
    GROUP BY x.user_id
  ),
  ranked_xp AS (
    SELECT
      eu.id AS user_id,
      eu.display_name,
      COALESCE(xt.xp_this_week, 0) AS xp_this_week,
      ROW_NUMBER() OVER (ORDER BY COALESCE(xt.xp_this_week, 0) DESC, eu.created_at ASC) AS rank
    FROM eligible_users eu
    LEFT JOIN xp_totals xt ON xt.user_id = eu.id
  ),
  kp_totals AS (
    SELECT t.user_id, COALESCE(SUM(t.amount), 0)::INTEGER AS kp_this_week
    FROM koin_point_transactions t
    WHERE t.created_at >= v_week_start
    GROUP BY t.user_id
  ),
  ranked_kp AS (
    SELECT
      eu.id AS user_id,
      eu.display_name,
      COALESCE(kt.kp_this_week, 0) AS kp_this_week,
      ROW_NUMBER() OVER (ORDER BY COALESCE(kt.kp_this_week, 0) DESC, eu.created_at ASC) AS rank
    FROM eligible_users eu
    LEFT JOIN kp_totals kt ON kt.user_id = eu.id
  )
  SELECT
    COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'rank', rx.rank,
        'user_id', rx.user_id,
        'display_name', rx.display_name,
        'xp_this_week', rx.xp_this_week,
        'is_current_user', rx.user_id = p_user_id
      ) ORDER BY rx.rank)
      FROM ranked_xp rx
      WHERE rx.rank <= 10
    ), '[]'::jsonb),
    COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'rank', rk.rank,
        'user_id', rk.user_id,
        'display_name', rk.display_name,
        'koin_points_this_week', rk.kp_this_week,
        'is_current_user', rk.user_id = p_user_id
      ) ORDER BY rk.rank)
      FROM ranked_kp rk
      WHERE rk.rank <= 10
    ), '[]'::jsonb)
  INTO v_xp_json, v_kp_json;

  RETURN jsonb_build_object(
    'week_start', v_week_start,
    'xp', v_xp_json,
    'koin_points', v_kp_json
  );
END;
$$;

GRANT EXECUTE ON FUNCTION get_weekly_leaderboard(UUID, TEXT) TO authenticated;

COMMIT;
