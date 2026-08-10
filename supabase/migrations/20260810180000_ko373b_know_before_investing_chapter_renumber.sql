-- KO-373b: insert Know Before Investing chapter before Investing in Indonesia
-- Shifts chapter numbers from Investing in Indonesia onward by +1 and updates
-- all DB functions/constraints that depend on the canonical numbering.
--
-- Idempotent: re-running after the chapter has been inserted is a no-op.

BEGIN;

-- Only renumber if the new chapter is not already present.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.daily_focus_chapter_map WHERE chapter = 'Know Before Investing') THEN
    RETURN;
  END IF;

  -- Shift daily focus chapter map for everything from Investing in Indonesia onward.
  UPDATE public.daily_focus_chapter_map
  SET chapter_number = chapter_number + 1
  WHERE chapter_number >= 7;

  -- Insert the new chapter in the gap.
  INSERT INTO public.daily_focus_chapter_map (chapter, chapter_number)
  VALUES ('Know Before Investing', 7);

  -- Keep existing mission attempts attached to the same chapter titles after renumbering.
  UPDATE public.chapter_mission_attempts
  SET chapter_number = chapter_number + 1
  WHERE chapter_number BETWEEN 7 AND 10;
END $$;

-- Bump the Daily Focus unlocked-chapter cap so the new last chapter (16) stays reachable.
DO $$
DECLARE
  definition TEXT;
BEGIN
  SELECT pg_get_functiondef('public.ensure_daily_focus_challenge(uuid,text,text)'::regprocedure) INTO definition;
  IF definition LIKE '%LEAST(COALESCE(MAX(map.chapter_number), -1) + 1, 16)%' THEN
    RETURN;
  END IF;
  IF definition NOT LIKE '%LEAST(COALESCE(MAX(map.chapter_number), -1) + 1, 15)%' THEN
    RAISE EXCEPTION 'Unexpected ensure_daily_focus_challenge definition; refusing cap patch';
  END IF;
  EXECUTE replace(
    definition,
    'LEAST(COALESCE(MAX(map.chapter_number), -1) + 1, 15)',
    'LEAST(COALESCE(MAX(map.chapter_number), -1) + 1, 16)'
  );
END $$;

-- Recreate complete_chapter_mission with the new 6-11 range and remapped chapter names.
CREATE OR REPLACE FUNCTION public.complete_chapter_mission(
  p_chapter_number SMALLINT,
  p_answers JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
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
  IF p_chapter_number NOT BETWEEN 6 AND 11
    OR jsonb_typeof(p_answers) <> 'array'
    OR jsonb_array_length(p_answers) <> 3 THEN
    RAISE EXCEPTION 'A chapter mission needs exactly three answers';
  END IF;

  v_chapter_name := CASE p_chapter_number
    WHEN 6 THEN 'Grow Your Money'
    WHEN 7 THEN 'Know Before Investing'
    WHEN 8 THEN 'Investing in Indonesia'
    WHEN 9 THEN 'Cryptocurrency 101'
    WHEN 10 THEN 'Reading Trading Charts'
    WHEN 11 THEN 'Decision Analysis Lab'
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

-- Allow chapter mission attempts up to the new Decision Analysis Lab number.
ALTER TABLE public.chapter_mission_attempts
  DROP CONSTRAINT IF EXISTS chapter_mission_attempts_chapter_number_check;

ALTER TABLE public.chapter_mission_attempts
  ADD CONSTRAINT chapter_mission_attempts_chapter_number_check
  CHECK (chapter_number BETWEEN 6 AND 11);

-- Patch user-facing paper-trading labels: Investing in Indonesia is now Chapter 08.
DO $$
DECLARE
  definition TEXT;
BEGIN
  SELECT pg_get_functiondef('public.claim_paper_portfolio(uuid)'::regprocedure) INTO definition;
  IF definition LIKE '%Complete Chapter 08 before opening your paper portfolio.%' THEN
    -- already patched
    NULL;
  ELSIF definition LIKE '%Complete Chapter 07 before opening your paper portfolio.%' THEN
    EXECUTE replace(
      definition,
      'Complete Chapter 07 before opening your paper portfolio.',
      'Complete Chapter 08 before opening your paper portfolio.'
    );
  ELSE
    RAISE EXCEPTION 'Unexpected claim_paper_portfolio definition; refusing label patch';
  END IF;

  SELECT pg_get_functiondef('public.execute_trade(uuid,text,text,integer)'::regprocedure) INTO definition;
  IF definition LIKE '%Complete Chapter 08 — Investing in Indonesia before paper trading.%' THEN
    -- already patched
    NULL;
  ELSIF definition LIKE '%Complete Chapter 07 — Investing in Indonesia before paper trading.%' THEN
    EXECUTE replace(
      definition,
      'Complete Chapter 07 — Investing in Indonesia before paper trading.',
      'Complete Chapter 08 — Investing in Indonesia before paper trading.'
    );
  ELSE
    RAISE EXCEPTION 'Unexpected execute_trade definition; refusing label patch';
  END IF;
END $$;

COMMIT;
