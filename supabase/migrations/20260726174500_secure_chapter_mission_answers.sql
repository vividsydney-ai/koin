-- KO-180 security repair: score chapter missions on the server. The browser
-- submits the selected answer for three known variants; it cannot attest a
-- score or unlock a chapter by calling an RPC with a forged result.

BEGIN;

DROP FUNCTION IF EXISTS complete_chapter_mission(SMALLINT, SMALLINT, SMALLINT);

CREATE OR REPLACE FUNCTION complete_chapter_mission(
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

  IF p_chapter_number NOT BETWEEN 7 AND 9 OR jsonb_typeof(p_answers) <> 'array' OR jsonb_array_length(p_answers) <> 3 THEN
    RAISE EXCEPTION 'A chapter mission needs exactly three answers';
  END IF;

  v_chapter_name := CASE p_chapter_number
    WHEN 7 THEN 'Grow Your Money'
    WHEN 8 THEN 'Investing in Indonesia'
    WHEN 9 THEN 'Cryptocurrency 101'
  END;

  IF EXISTS (
    SELECT 1
    FROM lessons AS l
    JOIN topics AS t ON t.id = l.topic_id
    LEFT JOIN lesson_progress AS lp ON lp.user_id = v_user_id AND lp.lesson_id = l.id
    WHERE l.is_published = TRUE
      AND t.chapter = v_chapter_name
      AND COALESCE(lp.status, 'locked') <> 'completed'
  ) THEN
    RAISE EXCEPTION 'Complete every chapter lesson before starting its Money Mission';
  END IF;

  WITH submitted AS (
    SELECT (entry->>'variant_id')::UUID AS variant_id, entry->'response' AS response
    FROM jsonb_array_elements(p_answers) AS entry
  ), eligible AS (
    SELECT cv.id, cv.body->'answer' AS answer
    FROM content_variants AS cv
    JOIN lessons AS l ON l.id = cv.lesson_id
    JOIN topics AS t ON t.id = l.topic_id
    WHERE cv.is_active = TRUE
      AND cv.variant_type = 'question'
      AND cv.body->>'type' IN ('multiple_choice', 'true_false')
      AND l.is_published = TRUE
      AND t.chapter = v_chapter_name
  )
  SELECT COUNT(*)::INTEGER,
         COUNT(*) FILTER (WHERE eligible.answer = submitted.response)::INTEGER
  INTO v_valid_answers, v_correct_answers
  FROM submitted
  JOIN eligible ON eligible.id = submitted.variant_id;

  IF v_valid_answers <> 3 OR (SELECT COUNT(DISTINCT entry->>'variant_id') FROM jsonb_array_elements(p_answers) AS entry) <> 3 THEN
    RAISE EXCEPTION 'Mission answers must be three distinct questions from this chapter';
  END IF;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_attempt_number
  FROM chapter_mission_attempts
  WHERE user_id = v_user_id AND chapter_number = p_chapter_number;

  v_passed := v_correct_answers = 3;

  INSERT INTO chapter_mission_attempts (
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

REVOKE ALL ON FUNCTION complete_chapter_mission(SMALLINT, JSONB) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION complete_chapter_mission(SMALLINT, JSONB) TO authenticated;

COMMIT;
