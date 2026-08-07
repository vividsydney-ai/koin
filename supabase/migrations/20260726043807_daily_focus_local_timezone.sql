-- KO-172: Daily Focus follows the learner's browser-reported IANA timezone.
-- We validate the supplied timezone against PostgreSQL's timezone catalogue;
-- the browser never controls challenge state, points, or answer verification.

BEGIN;

ALTER TABLE focus_profiles
  ADD COLUMN IF NOT EXISTS time_zone TEXT NOT NULL DEFAULT 'Asia/Jakarta';

ALTER TABLE daily_focus_challenges
  ADD COLUMN IF NOT EXISTS time_zone TEXT NOT NULL DEFAULT 'Asia/Jakarta';

CREATE OR REPLACE FUNCTION assert_focus_time_zone(p_time_zone TEXT)
RETURNS TEXT
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
BEGIN
  IF p_time_zone IS NULL
    OR NOT EXISTS (SELECT 1 FROM pg_timezone_names WHERE name = p_time_zone)
  THEN
    RAISE EXCEPTION 'Invalid timezone' USING ERRCODE = 'check_violation';
  END IF;

  RETURN p_time_zone;
END;
$$;

CREATE OR REPLACE FUNCTION focus_week_start(
  p_timestamp TIMESTAMPTZ,
  p_time_zone TEXT
)
RETURNS DATE
LANGUAGE SQL
STABLE
SET search_path = public
AS $$
  SELECT date_trunc('week', p_timestamp AT TIME ZONE assert_focus_time_zone(p_time_zone))::DATE;
$$;

CREATE OR REPLACE FUNCTION ensure_daily_focus_challenge(
  p_user_id UUID,
  p_time_zone TEXT
)
RETURNS daily_focus_challenges
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_today DATE := (NOW() AT TIME ZONE v_time_zone)::DATE;
  v_profile focus_profiles;
  v_questions JSONB;
  v_challenge daily_focus_challenges;
BEGIN
  INSERT INTO focus_profiles (user_id, time_zone)
  VALUES (p_user_id, v_time_zone)
  ON CONFLICT (user_id) DO NOTHING;

  SELECT * INTO v_profile
  FROM focus_profiles
  WHERE user_id = p_user_id
  FOR UPDATE;

  UPDATE focus_profiles
  SET time_zone = v_time_zone,
      updated_at = NOW()
  WHERE user_id = p_user_id
  RETURNING * INTO v_profile;

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
    user_id, challenge_date, time_zone, max_focus, focus_remaining, questions
  ) VALUES (
    p_user_id, v_today, v_time_zone, v_profile.max_focus, v_profile.max_focus, v_questions
  )
  ON CONFLICT (user_id, challenge_date) DO NOTHING;

  SELECT * INTO v_challenge
  FROM daily_focus_challenges
  WHERE user_id = p_user_id AND challenge_date = v_today;

  RETURN v_challenge;
END;
$$;

CREATE OR REPLACE FUNCTION get_daily_focus_challenge(p_time_zone TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_challenge daily_focus_challenges;
  v_profile focus_profiles;
  v_week_start DATE := focus_week_start(NOW(), v_time_zone);
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  v_challenge := ensure_daily_focus_challenge(v_user_id, v_time_zone);
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = v_user_id FOR UPDATE;

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
  p_answer JSONB,
  p_time_zone TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_today DATE := (NOW() AT TIME ZONE v_time_zone)::DATE;
  v_challenge daily_focus_challenges;
  v_profile focus_profiles;
  v_question JSONB;
  v_is_correct BOOLEAN;
  v_next_answered INTEGER;
  v_next_focus INTEGER;
  v_week_start DATE := focus_week_start(NOW(), v_time_zone);
  v_missions INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF p_question_index IS NULL OR p_question_index < 0 OR p_answer IS NULL THEN
    RAISE EXCEPTION 'Invalid Daily Focus answer' USING ERRCODE = 'check_violation';
  END IF;

  PERFORM ensure_daily_focus_challenge(v_user_id, v_time_zone);
  SELECT * INTO v_challenge FROM daily_focus_challenges
  WHERE user_id = v_user_id AND challenge_date = v_today FOR UPDATE;
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = v_user_id FOR UPDATE;

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
  v_next_focus := CASE WHEN v_is_correct THEN v_challenge.focus_remaining ELSE GREATEST(v_challenge.focus_remaining - 1, 0) END;

  UPDATE daily_focus_challenges
  SET questions_answered = v_next_answered,
      correct_answers = correct_answers + CASE WHEN v_is_correct THEN 1 ELSE 0 END,
      focus_remaining = v_next_focus,
      status = CASE WHEN v_next_focus = 0 THEN 'exhausted' WHEN v_next_answered = 5 THEN 'completed' ELSE 'active' END,
      completed_at = CASE WHEN v_next_focus > 0 AND v_next_answered = 5 THEN NOW() ELSE completed_at END,
      updated_at = NOW()
  WHERE id = v_challenge.id
  RETURNING * INTO v_challenge;

  IF v_challenge.status = 'completed' AND v_challenge.completed_at IS NOT NULL THEN
    PERFORM award_koin_points(v_user_id, 20, 'reward', v_challenge.id, 'Daily Focus completed');
    IF v_profile.mission_week_start IS DISTINCT FROM v_week_start THEN
      v_missions := 1;
    ELSE
      v_missions := LEAST(v_profile.missions_completed_this_week + 1, 5);
    END IF;
    UPDATE focus_profiles
    SET mission_week_start = v_week_start,
        missions_completed_this_week = v_missions,
        max_focus = CASE WHEN max_focus = 3 AND v_missions = 5 THEN 4 ELSE max_focus END,
        fourth_focus_unlocked_at = CASE WHEN max_focus = 3 AND v_missions = 5 THEN NOW() ELSE fourth_focus_unlocked_at END,
        updated_at = NOW()
    WHERE user_id = v_user_id
    RETURNING * INTO v_profile;
  END IF;

  RETURN daily_focus_response(v_challenge, v_profile, v_is_correct, v_question->>'explanation', v_question->'answer');
END;
$$;

CREATE OR REPLACE FUNCTION refill_daily_focus(p_time_zone TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_today DATE := (NOW() AT TIME ZONE v_time_zone)::DATE;
  v_challenge daily_focus_challenges;
  v_profile focus_profiles;
  v_balance INTEGER;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  PERFORM ensure_daily_focus_challenge(v_user_id, v_time_zone);
  SELECT * INTO v_challenge FROM daily_focus_challenges
  WHERE user_id = v_user_id AND challenge_date = v_today FOR UPDATE;
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = v_user_id FOR UPDATE;

  IF v_challenge.status = 'completed' THEN RAISE EXCEPTION 'Completed Daily Focus challenges cannot be refilled' USING ERRCODE = 'check_violation'; END IF;
  IF v_challenge.refill_used THEN RAISE EXCEPTION 'Daily Focus refill already used today' USING ERRCODE = 'check_violation'; END IF;
  IF v_challenge.focus_remaining >= v_challenge.max_focus THEN RAISE EXCEPTION 'Daily Focus is already full' USING ERRCODE = 'check_violation'; END IF;

  UPDATE koin_point_balances
  SET current_balance = current_balance - 50, updated_at = NOW()
  WHERE user_id = v_user_id AND current_balance >= 50
  RETURNING current_balance INTO v_balance;
  IF v_balance IS NULL THEN RAISE EXCEPTION 'You need 50 Koin Points for a Focus refill' USING ERRCODE = 'check_violation'; END IF;

  INSERT INTO koin_point_transactions (user_id, amount, source_type, description)
  VALUES (v_user_id, -50, 'reward', 'Daily Focus refill');
  UPDATE daily_focus_challenges
  SET focus_remaining = max_focus, refill_used = TRUE, status = 'active', updated_at = NOW()
  WHERE id = v_challenge.id
  RETURNING * INTO v_challenge;

  RETURN daily_focus_response(v_challenge, v_profile);
END;
$$;

COMMENT ON FUNCTION focus_week_start(TIMESTAMPTZ, TEXT) IS 'Returns the Monday-starting local week used for Daily Focus Money Missions.';
COMMENT ON FUNCTION get_daily_focus_challenge(TEXT) IS 'Returns a sanitized Daily Focus challenge for the authenticated user local calendar.';
COMMENT ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB, TEXT) IS 'Verifies one current Daily Focus answer using the learner local calendar.';
COMMENT ON FUNCTION refill_daily_focus(TEXT) IS 'Spends 50 Koin Points once per learner-local day to restore Daily Focus pips.';

REVOKE ALL ON FUNCTION assert_focus_time_zone(TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION focus_week_start(TIMESTAMPTZ, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION ensure_daily_focus_challenge(UUID, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION get_daily_focus_challenge() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION refill_daily_focus() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION get_daily_focus_challenge(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB, TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION refill_daily_focus(TEXT) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION get_daily_focus_challenge(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION refill_daily_focus(TEXT) TO authenticated;

COMMIT;
