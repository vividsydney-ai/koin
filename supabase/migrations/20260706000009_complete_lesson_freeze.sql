-- Migration 009: Update complete_lesson to use check_in_streak (freeze logic)
-- and award XP for streak milestones.

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
  -- Auth guard: only the authenticated user may complete lessons for themselves.
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  -- Lesson must exist and be published.
  SELECT id, xp_reward, topic_id, lesson_number, slug
  INTO v_lesson
  FROM lessons
  WHERE id = p_lesson_id AND is_published = TRUE;

  IF v_lesson IS NULL THEN
    RAISE EXCEPTION 'Lesson not found or not published';
  END IF;

  v_topic_id := v_lesson.topic_id;
  v_xp := v_lesson.xp_reward;

  -- Determine attempt number.
  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_attempt_number
  FROM lesson_attempts
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  -- Record the attempt.
  INSERT INTO lesson_attempts (
    user_id, lesson_id, attempt_number, score, max_score,
    completed, completed_at, answers_json, time_spent_seconds
  ) VALUES (
    p_user_id, p_lesson_id, v_attempt_number, p_score, p_max_score,
    TRUE, NOW(), p_answers_json, p_time_spent_seconds
  );

  -- Existing progress for first-completion detection.
  SELECT status INTO v_existing_status
  FROM lesson_progress
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  v_is_first_completion := (v_existing_status IS DISTINCT FROM 'completed');

  -- Upsert progress.
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

  -- Award XP.
  INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
  VALUES (p_user_id, 'lesson_complete', p_lesson_id, v_xp);
  v_total_xp := v_xp;

  IF p_quiz_correct THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'quiz_bonus', p_lesson_id, 10);
    v_total_xp := v_total_xp + 10;
  END IF;

  -- Daily check-in.
  INSERT INTO daily_checkins (user_id, checkin_date, xp_earned)
  VALUES (p_user_id, v_today, v_total_xp)
  ON CONFLICT (user_id, checkin_date)
  DO UPDATE SET xp_earned = daily_checkins.xp_earned + v_total_xp;

  -- Streak maintenance via shared check-in RPC (handles freeze/break logic).
  v_checkin := check_in_streak(p_user_id);
  v_new_streak := (v_checkin->>'current_streak_days')::INTEGER;
  v_streak_status := v_checkin->>'streak_status';

  -- Streak milestone XP.
  IF v_new_streak IN (3, 7, 14, 30) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'streak_milestone', p_lesson_id, 25);
    v_total_xp := v_total_xp + 25;
  END IF;

  -- Topic mastery (only count unique lessons the first time they are completed).
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

  -- Award lesson-complete badges.
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

  -- Next published lesson for the CTA.
  SELECT slug INTO v_next_lesson_slug
  FROM lessons
  WHERE lesson_number > v_lesson.lesson_number AND is_published = TRUE
  ORDER BY lesson_number ASC
  LIMIT 1;

  v_result := jsonb_build_object(
    'xp_earned', v_total_xp,
    'lesson_xp', v_xp,
    'quiz_bonus', CASE WHEN p_quiz_correct THEN 10 ELSE 0 END,
    'streak_days', v_new_streak,
    'badges_earned', v_badges,
    'next_lesson_slug', v_next_lesson_slug,
    'streak_status', v_streak_status
  );

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) TO authenticated, anon;
