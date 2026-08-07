-- KO-180: Persist the late-curriculum Chapter Money Mission result.
-- Mission question content remains in the existing lesson-variant pools; this
-- records only private learner attempts and does not make a daily limit.

BEGIN;

CREATE TABLE IF NOT EXISTS chapter_mission_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  chapter_number SMALLINT NOT NULL CHECK (chapter_number BETWEEN 7 AND 9),
  attempt_number INTEGER NOT NULL,
  score SMALLINT NOT NULL CHECK (score >= 0),
  max_score SMALLINT NOT NULL CHECK (max_score >= 3),
  passed BOOLEAN NOT NULL,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, chapter_number, attempt_number)
);

CREATE INDEX IF NOT EXISTS chapter_mission_attempts_user_chapter_idx
  ON chapter_mission_attempts(user_id, chapter_number, created_at DESC);

ALTER TABLE chapter_mission_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own chapter mission attempts"
  ON chapter_mission_attempts FOR SELECT
  USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION complete_chapter_mission(
  p_chapter_number SMALLINT,
  p_score SMALLINT,
  p_max_score SMALLINT
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
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF p_chapter_number NOT BETWEEN 7 AND 9 OR p_max_score < 3 OR p_score < 0 OR p_score > p_max_score THEN
    RAISE EXCEPTION 'Invalid chapter mission result';
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
    LEFT JOIN lesson_progress AS lp
      ON lp.user_id = v_user_id AND lp.lesson_id = l.id
    WHERE l.is_published = TRUE
      AND t.chapter = v_chapter_name
      AND COALESCE(lp.status, 'locked') <> 'completed'
  ) THEN
    RAISE EXCEPTION 'Complete every chapter lesson before starting its Money Mission';
  END IF;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_attempt_number
  FROM chapter_mission_attempts
  WHERE user_id = v_user_id AND chapter_number = p_chapter_number;

  v_passed := p_score = p_max_score;

  INSERT INTO chapter_mission_attempts (
    user_id, chapter_number, attempt_number, score, max_score, passed, completed_at
  ) VALUES (
    v_user_id, p_chapter_number, v_attempt_number, p_score, p_max_score, v_passed,
    CASE WHEN v_passed THEN NOW() ELSE NULL END
  );

  RETURN jsonb_build_object(
    'attempt_number', v_attempt_number,
    'passed', v_passed,
    'score', p_score,
    'max_score', p_max_score
  );
END;
$$;

REVOKE ALL ON FUNCTION complete_chapter_mission(SMALLINT, SMALLINT, SMALLINT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION complete_chapter_mission(SMALLINT, SMALLINT, SMALLINT) TO authenticated;

COMMIT;
