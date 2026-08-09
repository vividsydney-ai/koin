-- Canonical curriculum reconciliation: every chapter number is zero-based.
-- Learner labels and persisted mission/Daily Focus identifiers now agree.

BEGIN;

-- Existing mission attempts use the former one-based identifiers. Shift them
-- before installing the zero-based constraint so completion history survives.
ALTER TABLE public.chapter_mission_attempts
  DROP CONSTRAINT IF EXISTS chapter_mission_attempts_chapter_number_check;

UPDATE public.chapter_mission_attempts
SET chapter_number = chapter_number - 1
WHERE chapter_number BETWEEN 7 AND 11;

ALTER TABLE public.chapter_mission_attempts
  ADD CONSTRAINT chapter_mission_attempts_chapter_number_check
  CHECK (chapter_number BETWEEN 6 AND 10);

-- Canonical displayed order, with aliases retained only for existing Daily
-- Focus question-bank rows that predate the title reconciliation.
WITH chapter_map(chapter, chapter_number) AS (
  VALUES
    ('Foundation', 0),
    ('Foundation 0', 0),
    ('Money Basics', 1),
    ('Money Life Skills', 2),
    ('Protect Yourself', 3),
    ('Let''s Talk About Debt', 4),
    ('Plan Your Money', 5),
    ('Grow Your Money', 6),
    ('Investing in Indonesia', 7),
    ('Cryptocurrency 101', 8),
    ('Reading Trading Charts', 9),
    ('Decision Analysis Lab', 10),
    ('Decision Analysis', 10),
    ('Decision Quality Under Uncertainty', 11),
    ('Personal Finance Operations', 12),
    ('Evidence-Based Investing Decisions', 13),
    ('Ownership, Enterprise & Income Quality', 14),
    ('Bias-Resistant Decisions & Resilience', 15)
)
INSERT INTO public.daily_focus_chapter_map (chapter, chapter_number)
SELECT chapter, chapter_number FROM chapter_map
ON CONFLICT (chapter) DO UPDATE SET chapter_number = EXCLUDED.chapter_number;

CREATE OR REPLACE FUNCTION public.complete_chapter_mission(
  p_chapter_number SMALLINT,
  p_answers JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_attempt_number INTEGER;
  v_passed BOOLEAN;
  v_chapter_name TEXT;
  v_valid_answers INTEGER;
  v_correct_answers INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;
  IF p_chapter_number NOT BETWEEN 6 AND 10
    OR jsonb_typeof(p_answers) <> 'array'
    OR jsonb_array_length(p_answers) <> 3 THEN
    RAISE EXCEPTION 'A chapter mission needs exactly three answers';
  END IF;

  v_chapter_name := CASE p_chapter_number
    WHEN 6 THEN 'Grow Your Money'
    WHEN 7 THEN 'Investing in Indonesia'
    WHEN 8 THEN 'Cryptocurrency 101'
    WHEN 9 THEN 'Reading Trading Charts'
    WHEN 10 THEN 'Decision Analysis Lab'
  END;

  IF EXISTS (
    SELECT 1
    FROM public.lessons AS lesson
    JOIN public.topics AS topic ON topic.id = lesson.topic_id
    LEFT JOIN public.lesson_progress AS progress
      ON progress.user_id = v_user_id AND progress.lesson_id = lesson.id
    WHERE lesson.is_published
      AND topic.chapter = v_chapter_name
      AND COALESCE(progress.status, 'locked') <> 'completed'
  ) THEN
    RAISE EXCEPTION 'Complete every chapter lesson before starting its Money Mission';
  END IF;

  WITH submitted AS (
    SELECT (entry->>'variant_id')::UUID AS variant_id, entry->'response' AS response
    FROM jsonb_array_elements(p_answers) AS entry
  ), eligible AS (
    SELECT variant.id, variant.body->'answer' AS answer
    FROM public.content_variants AS variant
    JOIN public.lessons AS lesson ON lesson.id = variant.lesson_id
    JOIN public.topics AS topic ON topic.id = lesson.topic_id
    WHERE variant.is_active
      AND variant.variant_type = 'question'
      AND variant.body->>'type' IN ('multiple_choice', 'true_false')
      AND lesson.is_published
      AND topic.chapter = v_chapter_name
  )
  SELECT COUNT(*)::INTEGER,
    COUNT(*) FILTER (WHERE eligible.answer = submitted.response)::INTEGER
  INTO v_valid_answers, v_correct_answers
  FROM submitted JOIN eligible ON eligible.id = submitted.variant_id;

  IF v_valid_answers <> 3
    OR (SELECT COUNT(DISTINCT entry->>'variant_id') FROM jsonb_array_elements(p_answers) AS entry) <> 3 THEN
    RAISE EXCEPTION 'Mission answers must be three distinct questions from this chapter';
  END IF;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_attempt_number
  FROM public.chapter_mission_attempts
  WHERE user_id = v_user_id AND chapter_number = p_chapter_number;

  v_passed := v_correct_answers = 3;
  INSERT INTO public.chapter_mission_attempts (
    user_id, chapter_number, attempt_number, score, max_score, passed, completed_at
  ) VALUES (
    v_user_id, p_chapter_number, v_attempt_number, v_correct_answers, 3, v_passed,
    CASE WHEN v_passed THEN NOW() ELSE NULL END
  );

  RETURN jsonb_build_object(
    'attempt_number', v_attempt_number,
    'passed', v_passed,
    'score', v_correct_answers,
    'max_score', 3
  );
END;
$$;

-- These functions already gate by the stable chapter title. Patch only their
-- user-facing canonical label and fail closed if an unexpected definition is live.
DO $$
DECLARE
  definition TEXT;
BEGIN
  SELECT pg_get_functiondef('public.claim_paper_portfolio(uuid)'::regprocedure) INTO definition;
  IF definition NOT LIKE '%Complete Chapter 08 before opening your paper portfolio.%' THEN
    RAISE EXCEPTION 'Unexpected claim_paper_portfolio definition; refusing label-only patch';
  END IF;
  EXECUTE replace(
    definition,
    'Complete Chapter 08 before opening your paper portfolio.',
    'Complete Chapter 07 before opening your paper portfolio.'
  );

  SELECT pg_get_functiondef('public.execute_trade(uuid,text,text,integer)'::regprocedure) INTO definition;
  IF definition NOT LIKE '%Complete Chapter 08 — Investing in Indonesia before paper trading.%' THEN
    RAISE EXCEPTION 'Unexpected execute_trade definition; refusing label-only patch';
  END IF;
  EXECUTE replace(
    definition,
    'Complete Chapter 08 — Investing in Indonesia before paper trading.',
    'Complete Chapter 07 — Investing in Indonesia before paper trading.'
  );
END;
$$;

-- Keep Daily Focus within the canonical 00–15 range.
CREATE OR REPLACE FUNCTION public.ensure_daily_focus_challenge(
  p_user_id UUID,
  p_time_zone TEXT,
  p_locale TEXT
)
RETURNS public.daily_focus_challenges
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_locale TEXT := lower(COALESCE(p_locale, 'en'));
  v_today DATE := (NOW() AT TIME ZONE v_time_zone)::DATE;
  v_profile focus_profiles;
  v_questions JSONB;
  v_challenge daily_focus_challenges;
  v_level TEXT;
  v_unlocked_chapter INTEGER;
  v_beginner_target INTEGER;
  v_intermediate_target INTEGER;
  v_advanced_target INTEGER;
BEGIN
  IF v_locale NOT IN ('en', 'id') THEN
    RAISE EXCEPTION 'Invalid locale' USING ERRCODE = 'check_violation';
  END IF;
  INSERT INTO focus_profiles (user_id, time_zone)
  VALUES (p_user_id, v_time_zone)
  ON CONFLICT (user_id) DO NOTHING;
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = p_user_id FOR UPDATE;
  UPDATE focus_profiles SET time_zone = v_time_zone, updated_at = NOW()
  WHERE user_id = p_user_id RETURNING * INTO v_profile;
  SELECT COALESCE(financial_literacy_level, 'beginner') INTO v_level
  FROM profiles WHERE id = p_user_id;
  CASE COALESCE(v_level, 'beginner')
    WHEN 'advanced' THEN v_beginner_target := 0; v_intermediate_target := 2; v_advanced_target := 3;
    WHEN 'intermediate' THEN v_beginner_target := 1; v_intermediate_target := 3; v_advanced_target := 1;
    ELSE v_beginner_target := 3; v_intermediate_target := 2; v_advanced_target := 0;
  END CASE;

  SELECT LEAST(COALESCE(MAX(map.chapter_number), -1) + 1, 15)
  INTO v_unlocked_chapter
  FROM lesson_progress AS progress
  JOIN lessons AS lesson ON lesson.id = progress.lesson_id AND lesson.is_published
  JOIN topics AS topic ON topic.id = lesson.topic_id
  JOIN daily_focus_chapter_map AS map ON map.chapter = topic.chapter
  WHERE progress.user_id = p_user_id AND progress.status = 'completed';
  v_unlocked_chapter := GREATEST(COALESCE(v_unlocked_chapter, 0), 0);

  SELECT COALESCE(jsonb_agg(question_body ORDER BY selection_order), '[]'::jsonb)
  INTO v_questions
  FROM (
    WITH raw_candidates AS (
      SELECT question.id, question.topic, question.difficulty,
        jsonb_build_object('question_id', question.id) || (question.body->'locales'->v_locale) AS question_body,
        md5(question.id || p_user_id::text || v_today::text || v_locale) AS stable_order,
        (SELECT COUNT(*) FROM daily_focus_question_history AS history WHERE history.user_id = p_user_id AND history.topic = question.topic AND history.was_correct = FALSE AND history.shown_at >= NOW() - INTERVAL '30 days') AS weak_score
      FROM daily_focus_questions AS question
      JOIN daily_focus_chapter_map AS map ON map.chapter = question.chapter
      WHERE question.is_active
        AND map.chapter_number <= v_unlocked_chapter
        AND question.type IN ('multiple_choice', 'true_false', 'swipe_yes_no', 'fill_blank', 'select_all', 'word_bank', 'ordering', 'matching')
        AND question.body->'locales' ? v_locale
    ), cooldown_candidates AS (
      SELECT candidate.* FROM raw_candidates AS candidate
      WHERE NOT EXISTS (SELECT 1 FROM daily_focus_question_history AS history WHERE history.user_id = p_user_id AND history.question_id = candidate.id AND history.shown_at >= NOW() - INTERVAL '14 days')
    ), candidates AS (
      SELECT * FROM cooldown_candidates
      UNION ALL
      SELECT candidate.* FROM raw_candidates AS candidate
      WHERE (SELECT COUNT(*) FROM cooldown_candidates) < 5
        AND NOT EXISTS (SELECT 1 FROM cooldown_candidates AS cooled WHERE cooled.id = candidate.id)
    ), difficulty_ranked AS (
      SELECT candidate.*, row_number() OVER (PARTITION BY candidate.difficulty ORDER BY candidate.stable_order) AS difficulty_rank FROM candidates AS candidate
    ), target_pool AS (
      SELECT * FROM difficulty_ranked
      WHERE (difficulty = 'beginner' AND difficulty_rank <= v_beginner_target)
        OR (difficulty = 'intermediate' AND difficulty_rank <= v_intermediate_target)
        OR (difficulty = 'advanced' AND difficulty_rank <= v_advanced_target)
    ), weak_pick AS (
      SELECT * FROM candidates WHERE weak_score > 0 ORDER BY weak_score DESC, stable_order LIMIT 1
    ), prioritised AS (
      SELECT 0 AS source_priority, id, topic, difficulty, question_body, stable_order, weak_score FROM weak_pick
      UNION ALL SELECT 1, id, topic, difficulty, question_body, stable_order, weak_score FROM target_pool
      UNION ALL SELECT 2, id, topic, difficulty, question_body, stable_order, weak_score FROM candidates
    ), unique_questions AS (
      SELECT *, row_number() OVER (PARTITION BY id ORDER BY source_priority, stable_order) AS question_rank FROM prioritised
    ), unique_topics AS (
      SELECT *, row_number() OVER (PARTITION BY topic ORDER BY source_priority, weak_score DESC, stable_order) AS topic_rank
      FROM unique_questions WHERE question_rank = 1
    )
    SELECT *, row_number() OVER (ORDER BY source_priority, weak_score DESC, stable_order) AS selection_order
    FROM unique_topics WHERE topic_rank = 1 ORDER BY source_priority, weak_score DESC, stable_order LIMIT 5
  ) AS selected;

  IF jsonb_array_length(v_questions) <> 5 THEN
    RAISE EXCEPTION 'Daily Focus needs at least five eligible questions for this learner';
  END IF;
  INSERT INTO daily_focus_challenges (user_id, challenge_date, time_zone, max_focus, focus_remaining, questions)
  VALUES (p_user_id, v_today, v_time_zone, v_profile.max_focus, v_profile.max_focus, v_questions)
  ON CONFLICT (user_id, challenge_date) DO NOTHING;
  SELECT * INTO v_challenge FROM daily_focus_challenges WHERE user_id = p_user_id AND challenge_date = v_today;
  INSERT INTO daily_focus_question_history (user_id, challenge_id, question_id, topic)
  SELECT p_user_id, v_challenge.id, entry->>'question_id', question.topic
  FROM jsonb_array_elements(v_challenge.questions) AS entry
  JOIN daily_focus_questions AS question ON question.id = entry->>'question_id'
  WHERE entry ? 'question_id'
  ON CONFLICT (challenge_id, question_id) DO NOTHING;
  RETURN v_challenge;
END;
$$;

COMMIT;
