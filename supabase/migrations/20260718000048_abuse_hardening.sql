-- Migration 048: Abuse hardening (KO-ABUSE-001)
--
-- Findings from RPC audit:
--   1. award_koin_points was granted to authenticated+anon with no auth guard:
--      any user could mint Koin Points directly via RPC.
--   2. complete_lesson awarded lesson XP, quiz bonus, Koin Points, and streak
--      milestone rewards on EVERY attempt, so replaying the RPC farmed XP/KP.
--   3. complete_lesson was granted to anon unnecessarily.
--   4. check_in_streak had no GRANT statement (executable by PUBLIC by default)
--      and no auth guard; it is only meant to be called internally.
--   5. No minimum time validation allowed completing lessons in 1 second.
--   6. add_friend_by_qr had no rate limit.
--
-- Fixes:
--   - complete_lesson: idempotent XP/KP via xp_events ledger checks; quiz bonus
--     once per lesson (first correct attempt); Koin Points only on first
--     completion; streak milestone at most once per day; 30s minimum time.
--   - award_koin_points: REVOKE from authenticated/anon/PUBLIC (internal only,
--     still callable from SECURITY DEFINER functions).
--   - check_in_streak: REVOKE from PUBLIC/authenticated/anon (internal only).
--   - complete_lesson: REVOKE from anon.
--   - add_friend_by_qr: max 20 new friendships per user per day.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. complete_lesson: hardened replacement (based on live 011 version)
-- ---------------------------------------------------------------------------

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

  -- Minimum time gate: a lesson cannot be meaningfully completed in under 30s.
  -- Blocks scripted full-catalog speedruns; the client measures real elapsed time.
  IF p_time_spent_seconds IS NULL OR p_time_spent_seconds < 30 THEN
    RAISE EXCEPTION 'Lesson completed too quickly' USING ERRCODE = 'check_violation';
  END IF;

  SELECT id, xp_reward, topic_id, lesson_number, slug
  INTO v_lesson
  FROM lessons
  WHERE id = p_lesson_id AND is_published = TRUE;

  IF v_lesson IS NULL THEN
    RAISE EXCEPTION 'Lesson not found or not published';
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

  SELECT status INTO v_existing_status
  FROM lesson_progress
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  v_is_first_completion := (v_existing_status IS DISTINCT FROM 'completed');

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

  -- Idempotent lesson XP: award only if this lesson never awarded XP before.
  IF NOT EXISTS (
    SELECT 1 FROM xp_events
    WHERE user_id = p_user_id AND source_type = 'lesson_complete' AND source_id = p_lesson_id
  ) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'lesson_complete', p_lesson_id, v_xp);
    v_lesson_xp_awarded := v_xp;
  END IF;

  -- Idempotent quiz bonus: award on the first correct attempt for this lesson.
  IF p_quiz_correct AND NOT EXISTS (
    SELECT 1 FROM xp_events
    WHERE user_id = p_user_id AND source_type = 'quiz_bonus' AND source_id = p_lesson_id
  ) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'quiz_bonus', p_lesson_id, 10);
    v_quiz_bonus_awarded := 10;
  END IF;

  v_total_xp := v_lesson_xp_awarded + v_quiz_bonus_awarded;

  -- Daily check-in (replays add 0 XP).
  INSERT INTO daily_checkins (user_id, checkin_date, xp_earned)
  VALUES (p_user_id, v_today, v_total_xp)
  ON CONFLICT (user_id, checkin_date)
  DO UPDATE SET xp_earned = daily_checkins.xp_earned + v_total_xp;

  -- Streak maintenance (same-day idempotent inside check_in_streak).
  v_checkin := check_in_streak(p_user_id);
  v_new_streak := (v_checkin->>'current_streak_days')::INTEGER;
  v_streak_status := v_checkin->>'streak_status';

  -- Streak milestone XP + Koin Points, at most once per day.
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

  -- Koin Points for lesson completion: first completion only.
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

-- Only authenticated users may complete lessons; anon is unnecessary.
REVOKE EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) FROM anon;
GRANT EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. award_koin_points: internal-only (called by SECURITY DEFINER functions)
-- ---------------------------------------------------------------------------

REVOKE EXECUTE ON FUNCTION award_koin_points(UUID, INTEGER, TEXT, UUID, TEXT) FROM authenticated, anon, PUBLIC;

-- ---------------------------------------------------------------------------
-- 3. check_in_streak: internal-only (called by complete_lesson)
-- ---------------------------------------------------------------------------

REVOKE EXECUTE ON FUNCTION check_in_streak(UUID) FROM authenticated, anon, PUBLIC;

-- ---------------------------------------------------------------------------
-- 4. add_friend_by_qr: daily rate limit (20 new friendships per day)
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION add_friend_by_qr(p_scanned_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_current_user_id UUID;
  v_friendship RECORD;
  v_adds_today INTEGER;
BEGIN
  v_current_user_id := auth.uid();

  IF v_current_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF p_scanned_user_id = v_current_user_id THEN
    RAISE EXCEPTION 'Cannot add yourself as a friend' USING ERRCODE = 'check_violation';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = p_scanned_user_id) THEN
    RAISE EXCEPTION 'User not found' USING ERRCODE = 'foreign_key_violation';
  END IF;

  -- Idempotent: return existing friendship in either direction.
  SELECT * INTO v_friendship
  FROM friendships
  WHERE (requester_id = v_current_user_id AND addressee_id = p_scanned_user_id)
     OR (requester_id = p_scanned_user_id AND addressee_id = v_current_user_id)
  LIMIT 1;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'friendship_id', v_friendship.id,
      'status', v_friendship.status
    );
  END IF;

  -- Rate limit: max 20 new friendships initiated per day.
  SELECT COUNT(*) INTO v_adds_today
  FROM friendships
  WHERE requester_id = v_current_user_id
    AND created_at >= CURRENT_DATE;

  IF v_adds_today >= 20 THEN
    RAISE EXCEPTION 'Daily friend-add limit reached' USING ERRCODE = 'check_violation';
  END IF;

  INSERT INTO friendships (requester_id, addressee_id, status)
  VALUES (v_current_user_id, p_scanned_user_id, 'accepted')
  RETURNING * INTO v_friendship;

  RETURN jsonb_build_object(
    'friendship_id', v_friendship.id,
    'status', v_friendship.status
  );
END;
$$;

COMMENT ON FUNCTION add_friend_by_qr(UUID) IS 'Create a mutual friendship after scanning another user''s QR code. Idempotent; no self-friend; max 20 new friendships per day.';

GRANT EXECUTE ON FUNCTION add_friend_by_qr(UUID) TO authenticated;

COMMIT;
