-- KO-164: Optional Daily Focus retention loop.
--
-- Daily Focus is intentionally separate from lessons: lesson quizzes remain
-- unlimited. The server stores answer keys and only returns sanitized question
-- payloads, so a client cannot read correct answers or directly alter Focus,
-- Koin Points, or mission progress.

BEGIN;

CREATE TABLE focus_profiles (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  max_focus INTEGER NOT NULL DEFAULT 3 CHECK (max_focus BETWEEN 3 AND 4),
  mission_week_start DATE,
  missions_completed_this_week INTEGER NOT NULL DEFAULT 0 CHECK (missions_completed_this_week BETWEEN 0 AND 5),
  fourth_focus_unlocked_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE focus_profiles IS 'Private Daily Focus progression. Access is mediated by authenticated Focus RPCs so mission progression cannot be edited from the browser.';

CREATE TABLE daily_focus_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  challenge_date DATE NOT NULL,
  max_focus INTEGER NOT NULL CHECK (max_focus BETWEEN 3 AND 4),
  focus_remaining INTEGER NOT NULL CHECK (focus_remaining BETWEEN 0 AND 4),
  questions JSONB NOT NULL CHECK (jsonb_typeof(questions) = 'array' AND jsonb_array_length(questions) = 5),
  questions_answered INTEGER NOT NULL DEFAULT 0 CHECK (questions_answered BETWEEN 0 AND 5),
  correct_answers INTEGER NOT NULL DEFAULT 0 CHECK (correct_answers BETWEEN 0 AND 5),
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'exhausted')),
  refill_used BOOLEAN NOT NULL DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, challenge_date)
);

CREATE INDEX idx_daily_focus_challenges_user_date
  ON daily_focus_challenges(user_id, challenge_date DESC);

COMMENT ON TABLE daily_focus_challenges IS 'Private server-authored Daily Focus state. Stored question JSON includes answer keys and is never readable through table policies.';

ALTER TABLE focus_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_focus_challenges ENABLE ROW LEVEL SECURITY;

-- Direct profile reads are deliberately denied: authenticated RPCs return only
-- the display-safe state needed by the challenge UI.
CREATE POLICY "Direct Focus profile reads stay private"
  ON focus_profiles FOR SELECT TO authenticated
  USING (FALSE);

COMMENT ON POLICY "Direct Focus profile reads stay private" ON focus_profiles IS 'Focus progression is read only through ownership-checked RPCs, avoiding direct client writes.';

-- Direct challenge reads are deliberately denied because rows contain answer
-- keys. The RPC strips answer fields before returning questions to the user.
CREATE POLICY "Direct Daily Focus reads stay private"
  ON daily_focus_challenges FOR SELECT TO authenticated
  USING (FALSE);

COMMENT ON POLICY "Direct Daily Focus reads stay private" ON daily_focus_challenges IS 'Challenge rows contain answer keys and can only be read through sanitized ownership-checked RPCs.';

CREATE OR REPLACE FUNCTION focus_week_start(p_timestamp TIMESTAMPTZ DEFAULT NOW())
RETURNS DATE
LANGUAGE SQL
STABLE
SET search_path = public
AS $$
  SELECT date_trunc('week', p_timestamp AT TIME ZONE 'Asia/Jakarta')::DATE;
$$;

COMMENT ON FUNCTION focus_week_start(TIMESTAMPTZ) IS 'Returns the Monday-starting Jakarta week used for Daily Focus Money Missions.';

CREATE OR REPLACE FUNCTION ensure_daily_focus_challenge(p_user_id UUID)
RETURNS daily_focus_challenges
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_today DATE := (NOW() AT TIME ZONE 'Asia/Jakarta')::DATE;
  v_profile focus_profiles;
  v_questions JSONB;
  v_challenge daily_focus_challenges;
BEGIN
  INSERT INTO focus_profiles (user_id)
  VALUES (p_user_id)
  ON CONFLICT (user_id) DO NOTHING;

  SELECT * INTO v_profile
  FROM focus_profiles
  WHERE user_id = p_user_id
  FOR UPDATE;

  SELECT COALESCE(jsonb_agg(question_body), '[]'::JSONB)
  INTO v_questions
  FROM (
    SELECT cv.body AS question_body
    FROM content_variants AS cv
    JOIN lessons AS lesson ON lesson.id = cv.lesson_id
    WHERE cv.variant_type = 'question'
      AND cv.is_active = TRUE
      AND lesson.is_published = TRUE
      AND cv.body->>'type' IN ('multiple_choice', 'true_false', 'swipe_yes_no')
      AND cv.body ? 'question'
      AND cv.body ? 'answer'
    ORDER BY md5(cv.id::TEXT || p_user_id::TEXT || v_today::TEXT)
    LIMIT 5
  ) AS selectable_questions;

  IF jsonb_array_length(v_questions) <> 5 THEN
    RAISE EXCEPTION 'Daily Focus needs at least five active binary or multiple-choice question variants';
  END IF;

  INSERT INTO daily_focus_challenges (
    user_id,
    challenge_date,
    max_focus,
    focus_remaining,
    questions
  ) VALUES (
    p_user_id,
    v_today,
    v_profile.max_focus,
    v_profile.max_focus,
    v_questions
  )
  ON CONFLICT (user_id, challenge_date) DO NOTHING;

  SELECT * INTO v_challenge
  FROM daily_focus_challenges
  WHERE user_id = p_user_id AND challenge_date = v_today;

  RETURN v_challenge;
END;
$$;

CREATE OR REPLACE FUNCTION daily_focus_response(
  p_challenge daily_focus_challenges,
  p_profile focus_profiles,
  p_answer_correct BOOLEAN DEFAULT NULL,
  p_explanation TEXT DEFAULT NULL,
  p_correct_answer JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE SQL
STABLE
SET search_path = public
AS $$
  SELECT jsonb_build_object(
    'challenge_date', p_challenge.challenge_date,
    'max_focus', p_challenge.max_focus,
    'focus_remaining', p_challenge.focus_remaining,
    'questions_answered', p_challenge.questions_answered,
    'correct_answers', p_challenge.correct_answers,
    'status', p_challenge.status,
    'refill_used', p_challenge.refill_used,
    'missions_completed_this_week', p_profile.missions_completed_this_week,
    'mission_goal', 5,
    'fourth_focus_unlocked', p_profile.max_focus = 4,
    'questions', (
      SELECT COALESCE(jsonb_agg(question - 'answer' - 'explanation' ORDER BY ordinality), '[]'::JSONB)
      FROM jsonb_array_elements(p_challenge.questions) WITH ORDINALITY AS question(question, ordinality)
    ),
    'answer_correct', p_answer_correct,
    'explanation', p_explanation,
    'correct_answer', p_correct_answer
  );
$$;

CREATE OR REPLACE FUNCTION get_daily_focus_challenge()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_challenge daily_focus_challenges;
  v_profile focus_profiles;
  v_week_start DATE := focus_week_start();
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  v_challenge := ensure_daily_focus_challenge(v_user_id);
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = v_user_id FOR UPDATE;

  -- Weekly mission counters are meaningful only for the current Jakarta week.
  -- Reset before returning state so Monday never displays last week's progress.
  IF v_profile.mission_week_start IS DISTINCT FROM v_week_start THEN
    UPDATE focus_profiles
    SET mission_week_start = v_week_start,
        missions_completed_this_week = 0,
        updated_at = NOW()
    WHERE user_id = v_user_id
    RETURNING * INTO v_profile;
  END IF;

  RETURN daily_focus_response(v_challenge, v_profile);
END;
$$;

CREATE OR REPLACE FUNCTION submit_daily_focus_answer(
  p_question_index INTEGER,
  p_answer JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_challenge daily_focus_challenges;
  v_profile focus_profiles;
  v_question JSONB;
  v_is_correct BOOLEAN;
  v_next_answered INTEGER;
  v_next_focus INTEGER;
  v_week_start DATE := focus_week_start();
  v_missions INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF p_question_index IS NULL OR p_question_index < 0 OR p_answer IS NULL THEN
    RAISE EXCEPTION 'Invalid Daily Focus answer' USING ERRCODE = 'check_violation';
  END IF;

  PERFORM ensure_daily_focus_challenge(v_user_id);

  SELECT * INTO v_challenge
  FROM daily_focus_challenges
  WHERE user_id = v_user_id
    AND challenge_date = (NOW() AT TIME ZONE 'Asia/Jakarta')::DATE
  FOR UPDATE;

  SELECT * INTO v_profile
  FROM focus_profiles
  WHERE user_id = v_user_id
  FOR UPDATE;

  IF v_challenge.status <> 'active' THEN
    RAISE EXCEPTION 'Daily Focus is no longer active' USING ERRCODE = 'check_violation';
  END IF;

  IF p_question_index <> v_challenge.questions_answered THEN
    RAISE EXCEPTION 'Answer the current Daily Focus question first' USING ERRCODE = 'check_violation';
  END IF;

  v_question := v_challenge.questions -> p_question_index;
  IF v_question IS NULL THEN
    RAISE EXCEPTION 'Daily Focus question not found' USING ERRCODE = 'check_violation';
  END IF;

  v_is_correct := (v_question->'answer') = p_answer;
  v_next_answered := v_challenge.questions_answered + 1;
  v_next_focus := CASE
    WHEN v_is_correct THEN v_challenge.focus_remaining
    ELSE GREATEST(v_challenge.focus_remaining - 1, 0)
  END;

  UPDATE daily_focus_challenges
  SET questions_answered = v_next_answered,
      correct_answers = correct_answers + CASE WHEN v_is_correct THEN 1 ELSE 0 END,
      focus_remaining = v_next_focus,
      status = CASE
        WHEN v_next_focus = 0 THEN 'exhausted'
        WHEN v_next_answered = 5 THEN 'completed'
        ELSE 'active'
      END,
      completed_at = CASE
        WHEN v_next_focus > 0 AND v_next_answered = 5 THEN NOW()
        ELSE completed_at
      END,
      updated_at = NOW()
  WHERE id = v_challenge.id
  RETURNING * INTO v_challenge;

  IF v_challenge.status = 'completed' AND v_challenge.completed_at IS NOT NULL THEN
    -- completed_at is set only by this first transition while the row lock is held.
    PERFORM award_koin_points(
      v_user_id,
      20,
      'reward',
      v_challenge.id,
      'Daily Focus completed'
    );

    IF v_profile.mission_week_start IS DISTINCT FROM v_week_start THEN
      v_missions := 1;
    ELSE
      v_missions := LEAST(v_profile.missions_completed_this_week + 1, 5);
    END IF;

    UPDATE focus_profiles
    SET mission_week_start = v_week_start,
        missions_completed_this_week = v_missions,
        max_focus = CASE WHEN max_focus = 3 AND v_missions = 5 THEN 4 ELSE max_focus END,
        fourth_focus_unlocked_at = CASE
          WHEN max_focus = 3 AND v_missions = 5 THEN NOW()
          ELSE fourth_focus_unlocked_at
        END,
        updated_at = NOW()
    WHERE user_id = v_user_id
    RETURNING * INTO v_profile;
  END IF;

  RETURN daily_focus_response(
    v_challenge,
    v_profile,
    v_is_correct,
    v_question->>'explanation',
    v_question->'answer'
  );
END;
$$;

CREATE OR REPLACE FUNCTION refill_daily_focus()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_challenge daily_focus_challenges;
  v_profile focus_profiles;
  v_balance INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  PERFORM ensure_daily_focus_challenge(v_user_id);

  SELECT * INTO v_challenge
  FROM daily_focus_challenges
  WHERE user_id = v_user_id
    AND challenge_date = (NOW() AT TIME ZONE 'Asia/Jakarta')::DATE
  FOR UPDATE;

  SELECT * INTO v_profile
  FROM focus_profiles
  WHERE user_id = v_user_id
  FOR UPDATE;

  IF v_challenge.status = 'completed' THEN
    RAISE EXCEPTION 'Completed Daily Focus challenges cannot be refilled' USING ERRCODE = 'check_violation';
  END IF;

  IF v_challenge.refill_used THEN
    RAISE EXCEPTION 'Daily Focus refill already used today' USING ERRCODE = 'check_violation';
  END IF;

  IF v_challenge.focus_remaining >= v_challenge.max_focus THEN
    RAISE EXCEPTION 'Daily Focus is already full' USING ERRCODE = 'check_violation';
  END IF;

  UPDATE koin_point_balances
  SET current_balance = current_balance - 50,
      updated_at = NOW()
  WHERE user_id = v_user_id
    AND current_balance >= 50
  RETURNING current_balance INTO v_balance;

  IF v_balance IS NULL THEN
    RAISE EXCEPTION 'You need 50 Koin Points for a Focus refill' USING ERRCODE = 'check_violation';
  END IF;

  INSERT INTO koin_point_transactions (user_id, amount, source_type, description)
  VALUES (v_user_id, -50, 'reward', 'Daily Focus refill');

  UPDATE daily_focus_challenges
  SET focus_remaining = max_focus,
      refill_used = TRUE,
      status = 'active',
      updated_at = NOW()
  WHERE id = v_challenge.id
  RETURNING * INTO v_challenge;

  RETURN daily_focus_response(v_challenge, v_profile);
END;
$$;

COMMENT ON FUNCTION get_daily_focus_challenge() IS 'Returns sanitized server-selected Daily Focus questions for the authenticated user.';
COMMENT ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB) IS 'Verifies one current Daily Focus answer and atomically updates Focus, rewards, and weekly Money Missions.';
COMMENT ON FUNCTION refill_daily_focus() IS 'Spends 50 Koin Points once per Jakarta day to restore the authenticated user Daily Focus pips.';

REVOKE ALL ON FUNCTION ensure_daily_focus_challenge(UUID) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION daily_focus_response(daily_focus_challenges, focus_profiles, BOOLEAN, TEXT, JSONB) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION focus_week_start(TIMESTAMPTZ) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION get_daily_focus_challenge() FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION refill_daily_focus() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION get_daily_focus_challenge() TO authenticated;
GRANT EXECUTE ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB) TO authenticated;
GRANT EXECUTE ON FUNCTION refill_daily_focus() TO authenticated;

COMMIT;
