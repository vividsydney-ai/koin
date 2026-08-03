-- KO-253 / KO-254 / KO-255: progression-aware, diverse Daily Focus selection
-- with private, server-side question history. Existing challenges remain valid.

BEGIN;

CREATE TABLE IF NOT EXISTS daily_focus_chapter_map (
  chapter TEXT PRIMARY KEY,
  chapter_number INTEGER NOT NULL CHECK (chapter_number >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO daily_focus_chapter_map (chapter, chapter_number) VALUES
  ('Foundation', 0), ('Foundation 0', 0), ('Money Basics', 1),
  ('Money Life Skills', 2), ('Plan Your Money', 3),
  ('Let''s Talk About Debt', 4), ('Protect Yourself', 5),
  ('Grow Your Money', 6), ('Investing in Indonesia', 7),
  ('Cryptocurrency 101', 8), ('Reading Trading Charts', 10),
  ('Decision Analysis Lab', 11), ('Decision Quality Under Uncertainty', 12),
  ('Personal Finance Operations', 13),
  ('Evidence-Based Investing Decisions', 14),
  ('Ownership, Enterprise & Income Quality', 15),
  ('Bias-Resistant Decisions & Resilience', 16)
ON CONFLICT (chapter) DO UPDATE SET chapter_number = EXCLUDED.chapter_number;

CREATE TABLE IF NOT EXISTS daily_focus_question_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES daily_focus_challenges(id) ON DELETE CASCADE,
  question_id TEXT NOT NULL REFERENCES daily_focus_questions(id) ON DELETE CASCADE,
  topic TEXT NOT NULL,
  shown_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  answered_at TIMESTAMPTZ,
  was_correct BOOLEAN,
  UNIQUE (challenge_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_daily_focus_history_user_recent
  ON daily_focus_question_history (user_id, shown_at DESC);
CREATE INDEX IF NOT EXISTS idx_daily_focus_history_user_topic
  ON daily_focus_question_history (user_id, topic, shown_at DESC);

ALTER TABLE daily_focus_question_history ENABLE ROW LEVEL SECURITY;
-- Intentionally no user policy: answer keys and learning history remain behind
-- security-definer RPCs, as do the existing challenge snapshots.

CREATE OR REPLACE FUNCTION daily_focus_response(
  p_challenge daily_focus_challenges,
  p_profile focus_profiles,
  p_answer_correct BOOLEAN DEFAULT NULL,
  p_explanation TEXT DEFAULT NULL,
  p_correct_answer JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE SQL STABLE SET search_path = public AS $$
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
      SELECT COALESCE(jsonb_agg(question - 'answer' - 'explanation' - 'question_id' ORDER BY ordinality), '[]'::JSONB)
      FROM jsonb_array_elements(p_challenge.questions) WITH ORDINALITY AS question(question, ordinality)
    ),
    'answer_correct', p_answer_correct,
    'explanation', p_explanation,
    'correct_answer', p_correct_answer
  );
$$;

CREATE OR REPLACE FUNCTION ensure_daily_focus_challenge(p_user_id UUID, p_time_zone TEXT, p_locale TEXT)
RETURNS daily_focus_challenges
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
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
  VALUES (p_user_id, v_time_zone) ON CONFLICT (user_id) DO NOTHING;
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = p_user_id FOR UPDATE;
  UPDATE focus_profiles SET time_zone = v_time_zone, updated_at = NOW()
  WHERE user_id = p_user_id RETURNING * INTO v_profile;

  SELECT COALESCE(financial_literacy_level, 'beginner') INTO v_level
  FROM profiles WHERE id = p_user_id;
  v_level := COALESCE(v_level, 'beginner');
  CASE v_level
    WHEN 'advanced' THEN v_beginner_target := 0; v_intermediate_target := 2; v_advanced_target := 3;
    WHEN 'intermediate' THEN v_beginner_target := 1; v_intermediate_target := 3; v_advanced_target := 1;
    ELSE v_beginner_target := 3; v_intermediate_target := 2; v_advanced_target := 0;
  END CASE;

  -- A learner sees completed material plus only the immediate next chapter.
  SELECT LEAST(COALESCE(MAX(cm.chapter_number), -1) + 1, 16) INTO v_unlocked_chapter
  FROM lesson_progress lp
  JOIN lessons l ON l.id = lp.lesson_id AND l.is_published
  JOIN topics t ON t.id = l.topic_id
  JOIN daily_focus_chapter_map cm ON cm.chapter = t.chapter
  WHERE lp.user_id = p_user_id AND lp.status = 'completed';
  v_unlocked_chapter := GREATEST(COALESCE(v_unlocked_chapter, 0), 0);

  SELECT COALESCE(jsonb_agg(selected.question_body ORDER BY selected.selection_order), '[]'::jsonb)
  INTO v_questions
  FROM (
    WITH raw_candidates AS (
      SELECT dfq.id, dfq.topic, dfq.difficulty,
        jsonb_build_object('question_id', dfq.id) || (dfq.body->'locales'->v_locale) AS question_body,
        md5(dfq.id || p_user_id::text || v_today::text || v_locale) AS stable_order,
        COALESCE((SELECT COUNT(*) FROM daily_focus_question_history h
          WHERE h.user_id = p_user_id AND h.topic = dfq.topic
            AND h.was_correct = FALSE AND h.shown_at >= NOW() - INTERVAL '30 days'), 0) AS weak_score
      FROM daily_focus_questions dfq
      JOIN daily_focus_chapter_map cm ON cm.chapter = dfq.chapter
      WHERE dfq.is_active
        AND cm.chapter_number <= v_unlocked_chapter
        AND dfq.type IN ('multiple_choice','true_false','swipe_yes_no','fill_blank','select_all','word_bank','ordering','matching')
        AND dfq.body->'locales' ? v_locale
    ), cooldown_candidates AS (
      SELECT r.* FROM raw_candidates r
      WHERE NOT EXISTS (
        SELECT 1 FROM daily_focus_question_history h
        WHERE h.user_id = p_user_id AND h.question_id = r.id
          AND h.shown_at >= NOW() - INTERVAL '14 days'
      )
    ), candidates AS (
      SELECT * FROM cooldown_candidates
      UNION ALL
      SELECT r.* FROM raw_candidates r
      WHERE (SELECT COUNT(*) FROM cooldown_candidates) < 5
        AND NOT EXISTS (SELECT 1 FROM cooldown_candidates c WHERE c.id = r.id)
    ), difficulty_ranked AS (
      SELECT c.*, row_number() OVER (PARTITION BY c.difficulty ORDER BY c.stable_order) AS difficulty_rank
      FROM candidates c
    ), target_pool AS (
      SELECT * FROM difficulty_ranked
      WHERE (difficulty = 'beginner' AND difficulty_rank <= v_beginner_target)
         OR (difficulty = 'intermediate' AND difficulty_rank <= v_intermediate_target)
         OR (difficulty = 'advanced' AND difficulty_rank <= v_advanced_target)
    ), weak_pick AS (
      SELECT * FROM candidates WHERE weak_score > 0 ORDER BY weak_score DESC, stable_order LIMIT 1
    ), prioritised AS (
      SELECT 0 AS source_priority, * FROM weak_pick
      UNION ALL SELECT 1 AS source_priority, * FROM target_pool
      UNION ALL SELECT 2 AS source_priority, * FROM candidates
    ), unique_questions AS (
      SELECT *, row_number() OVER (PARTITION BY id ORDER BY source_priority, stable_order) AS question_rank
      FROM prioritised
    ), unique_topics AS (
      SELECT *, row_number() OVER (PARTITION BY topic ORDER BY source_priority, weak_score DESC, stable_order) AS topic_rank
      FROM unique_questions WHERE question_rank = 1
    ), ordered AS (
      SELECT *, row_number() OVER (ORDER BY source_priority, weak_score DESC, stable_order) AS selection_order
      FROM unique_topics WHERE topic_rank = 1
    )
    SELECT * FROM ordered ORDER BY selection_order LIMIT 5
  ) selected;

  IF jsonb_array_length(v_questions) <> 5 THEN
    RAISE EXCEPTION 'Daily Focus needs at least five eligible questions for this learner';
  END IF;

  INSERT INTO daily_focus_challenges (user_id, challenge_date, time_zone, max_focus, focus_remaining, questions)
  VALUES (p_user_id, v_today, v_time_zone, v_profile.max_focus, v_profile.max_focus, v_questions)
  ON CONFLICT (user_id, challenge_date) DO NOTHING;
  SELECT * INTO v_challenge FROM daily_focus_challenges
  WHERE user_id = p_user_id AND challenge_date = v_today;

  INSERT INTO daily_focus_question_history (user_id, challenge_id, question_id, topic)
  SELECT p_user_id, v_challenge.id, q->>'question_id', dfq.topic
  FROM jsonb_array_elements(v_challenge.questions) q
  JOIN daily_focus_questions dfq ON dfq.id = q->>'question_id'
  WHERE q ? 'question_id'
  ON CONFLICT (challenge_id, question_id) DO NOTHING;

  RETURN v_challenge;
END;
$$;

CREATE OR REPLACE FUNCTION submit_daily_focus_answer(p_question_index INTEGER, p_answer JSONB, p_time_zone TEXT, p_locale TEXT)
RETURNS JSONB
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_today DATE := (NOW() AT TIME ZONE v_time_zone)::DATE;
  v_challenge daily_focus_challenges; v_profile focus_profiles; v_question JSONB;
  v_question_type TEXT; v_correct_answer JSONB; v_is_correct BOOLEAN;
  v_next_answered INTEGER; v_next_focus INTEGER;
  v_week_start DATE := focus_week_start(NOW(), v_time_zone); v_missions INTEGER;
BEGIN
  IF v_user_id IS NULL THEN RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege'; END IF;
  IF p_question_index IS NULL OR p_question_index < 0 OR p_answer IS NULL THEN RAISE EXCEPTION 'Invalid Daily Focus answer' USING ERRCODE = 'check_violation'; END IF;
  PERFORM ensure_daily_focus_challenge(v_user_id, v_time_zone, p_locale);
  SELECT * INTO v_challenge FROM daily_focus_challenges WHERE user_id = v_user_id AND challenge_date = v_today FOR UPDATE;
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id = v_user_id FOR UPDATE;
  IF v_challenge.status <> 'active' THEN RAISE EXCEPTION 'Daily Focus is no longer active' USING ERRCODE = 'check_violation'; END IF;
  IF p_question_index <> v_challenge.questions_answered THEN RAISE EXCEPTION 'Answer the current Daily Focus question first' USING ERRCODE = 'check_violation'; END IF;
  v_question := v_challenge.questions -> p_question_index;
  IF v_question IS NULL THEN RAISE EXCEPTION 'Daily Focus question not found' USING ERRCODE = 'check_violation'; END IF;
  v_question_type := v_question->>'type'; v_correct_answer := v_question->'answer';
  IF v_question_type = 'fill_blank' THEN
    v_is_correct := lower(trim(both from (v_correct_answer #>> '{}')::TEXT)) = lower(trim(both from (p_answer #>> '{}')::TEXT));
  ELSIF v_question_type = 'select_all' THEN
    v_is_correct := (SELECT array_agg(x ORDER BY x) FROM jsonb_array_elements_text(v_correct_answer) x) = (SELECT array_agg(x ORDER BY x) FROM jsonb_array_elements_text(p_answer) x);
  ELSE v_is_correct := v_correct_answer = p_answer;
  END IF;
  v_next_answered := v_challenge.questions_answered + 1;
  v_next_focus := CASE WHEN v_is_correct THEN v_challenge.focus_remaining ELSE GREATEST(v_challenge.focus_remaining - 1, 0) END;
  UPDATE daily_focus_challenges SET questions_answered=v_next_answered, correct_answers=correct_answers + CASE WHEN v_is_correct THEN 1 ELSE 0 END,
    focus_remaining=v_next_focus, status=CASE WHEN v_next_focus=0 THEN 'exhausted' WHEN v_next_answered=5 THEN 'completed' ELSE 'active' END,
    completed_at=CASE WHEN v_next_focus>0 AND v_next_answered=5 THEN NOW() ELSE completed_at END, updated_at=NOW()
  WHERE id=v_challenge.id RETURNING * INTO v_challenge;
  UPDATE daily_focus_question_history SET answered_at=NOW(), was_correct=v_is_correct
  WHERE challenge_id=v_challenge.id AND question_id=v_question->>'question_id' AND answered_at IS NULL;
  IF v_challenge.status='completed' AND v_challenge.completed_at IS NOT NULL THEN
    PERFORM award_koin_points(v_user_id,20,'reward',v_challenge.id,'Daily Focus completed');
    IF v_profile.mission_week_start IS DISTINCT FROM v_week_start THEN v_missions:=1; ELSE v_missions:=LEAST(v_profile.missions_completed_this_week+1,5); END IF;
    UPDATE focus_profiles SET mission_week_start=v_week_start, missions_completed_this_week=v_missions,
      max_focus=CASE WHEN max_focus=3 AND v_missions=5 THEN 4 ELSE max_focus END,
      fourth_focus_unlocked_at=CASE WHEN max_focus=3 AND v_missions=5 THEN NOW() ELSE fourth_focus_unlocked_at END, updated_at=NOW()
    WHERE user_id=v_user_id RETURNING * INTO v_profile;
  END IF;
  RETURN daily_focus_response(v_challenge,v_profile,v_is_correct,v_question->>'explanation',v_question->'answer');
END;
$$;

REVOKE ALL ON TABLE daily_focus_question_history FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION ensure_daily_focus_challenge(UUID, TEXT, TEXT) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION get_daily_focus_challenge(TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION submit_daily_focus_answer(INTEGER, JSONB, TEXT, TEXT) TO authenticated;

COMMIT;
