-- KO-253 corrective migration: align adaptive-selector CTE union columns.

BEGIN;

CREATE OR REPLACE FUNCTION ensure_daily_focus_challenge(p_user_id UUID, p_time_zone TEXT, p_locale TEXT)
RETURNS daily_focus_challenges
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_time_zone TEXT := assert_focus_time_zone(p_time_zone);
  v_locale TEXT := lower(COALESCE(p_locale, 'en'));
  v_today DATE := (NOW() AT TIME ZONE v_time_zone)::DATE;
  v_profile focus_profiles; v_questions JSONB; v_challenge daily_focus_challenges;
  v_level TEXT; v_unlocked_chapter INTEGER;
  v_beginner_target INTEGER; v_intermediate_target INTEGER; v_advanced_target INTEGER;
BEGIN
  IF v_locale NOT IN ('en', 'id') THEN RAISE EXCEPTION 'Invalid locale' USING ERRCODE = 'check_violation'; END IF;
  INSERT INTO focus_profiles (user_id, time_zone) VALUES (p_user_id, v_time_zone) ON CONFLICT (user_id) DO NOTHING;
  SELECT * INTO v_profile FROM focus_profiles WHERE user_id=p_user_id FOR UPDATE;
  UPDATE focus_profiles SET time_zone=v_time_zone, updated_at=NOW() WHERE user_id=p_user_id RETURNING * INTO v_profile;
  SELECT COALESCE(financial_literacy_level,'beginner') INTO v_level FROM profiles WHERE id=p_user_id;
  CASE COALESCE(v_level,'beginner')
    WHEN 'advanced' THEN v_beginner_target:=0; v_intermediate_target:=2; v_advanced_target:=3;
    WHEN 'intermediate' THEN v_beginner_target:=1; v_intermediate_target:=3; v_advanced_target:=1;
    ELSE v_beginner_target:=3; v_intermediate_target:=2; v_advanced_target:=0;
  END CASE;
  SELECT LEAST(COALESCE(MAX(cm.chapter_number),-1)+1,16) INTO v_unlocked_chapter
  FROM lesson_progress lp JOIN lessons l ON l.id=lp.lesson_id AND l.is_published
  JOIN topics t ON t.id=l.topic_id JOIN daily_focus_chapter_map cm ON cm.chapter=t.chapter
  WHERE lp.user_id=p_user_id AND lp.status='completed';
  v_unlocked_chapter:=GREATEST(COALESCE(v_unlocked_chapter,0),0);

  SELECT COALESCE(jsonb_agg(question_body ORDER BY selection_order),'[]'::jsonb) INTO v_questions
  FROM (
    WITH raw_candidates AS (
      SELECT dfq.id,dfq.topic,dfq.difficulty,
        jsonb_build_object('question_id',dfq.id) || (dfq.body->'locales'->v_locale) AS question_body,
        md5(dfq.id || p_user_id::text || v_today::text || v_locale) AS stable_order,
        (SELECT COUNT(*) FROM daily_focus_question_history h WHERE h.user_id=p_user_id AND h.topic=dfq.topic AND h.was_correct=FALSE AND h.shown_at>=NOW()-INTERVAL '30 days') AS weak_score
      FROM daily_focus_questions dfq JOIN daily_focus_chapter_map cm ON cm.chapter=dfq.chapter
      WHERE dfq.is_active AND cm.chapter_number<=v_unlocked_chapter
        AND dfq.type IN ('multiple_choice','true_false','swipe_yes_no','fill_blank','select_all','word_bank','ordering','matching')
        AND dfq.body->'locales' ? v_locale
    ), cooldown_candidates AS (
      SELECT r.* FROM raw_candidates r WHERE NOT EXISTS (
        SELECT 1 FROM daily_focus_question_history h WHERE h.user_id=p_user_id AND h.question_id=r.id AND h.shown_at>=NOW()-INTERVAL '14 days'
      )
    ), candidates AS (
      SELECT * FROM cooldown_candidates
      UNION ALL
      SELECT r.* FROM raw_candidates r WHERE (SELECT COUNT(*) FROM cooldown_candidates)<5
        AND NOT EXISTS (SELECT 1 FROM cooldown_candidates c WHERE c.id=r.id)
    ), difficulty_ranked AS (
      SELECT c.*,row_number() OVER (PARTITION BY c.difficulty ORDER BY c.stable_order) AS difficulty_rank FROM candidates c
    ), target_pool AS (
      SELECT * FROM difficulty_ranked WHERE (difficulty='beginner' AND difficulty_rank<=v_beginner_target)
        OR (difficulty='intermediate' AND difficulty_rank<=v_intermediate_target)
        OR (difficulty='advanced' AND difficulty_rank<=v_advanced_target)
    ), weak_pick AS (
      SELECT * FROM candidates WHERE weak_score>0 ORDER BY weak_score DESC,stable_order LIMIT 1
    ), prioritised AS (
      SELECT 0 AS source_priority,id,topic,difficulty,question_body,stable_order,weak_score FROM weak_pick
      UNION ALL SELECT 1,id,topic,difficulty,question_body,stable_order,weak_score FROM target_pool
      UNION ALL SELECT 2,id,topic,difficulty,question_body,stable_order,weak_score FROM candidates
    ), unique_questions AS (
      SELECT *,row_number() OVER (PARTITION BY id ORDER BY source_priority,stable_order) AS question_rank FROM prioritised
    ), unique_topics AS (
      SELECT *,row_number() OVER (PARTITION BY topic ORDER BY source_priority,weak_score DESC,stable_order) AS topic_rank
      FROM unique_questions WHERE question_rank=1
    )
    SELECT *,row_number() OVER (ORDER BY source_priority,weak_score DESC,stable_order) AS selection_order
    FROM unique_topics WHERE topic_rank=1 ORDER BY source_priority,weak_score DESC,stable_order LIMIT 5
  ) selected;
  IF jsonb_array_length(v_questions)<>5 THEN RAISE EXCEPTION 'Daily Focus needs at least five eligible questions for this learner'; END IF;
  INSERT INTO daily_focus_challenges (user_id,challenge_date,time_zone,max_focus,focus_remaining,questions)
  VALUES (p_user_id,v_today,v_time_zone,v_profile.max_focus,v_profile.max_focus,v_questions)
  ON CONFLICT (user_id,challenge_date) DO NOTHING;
  SELECT * INTO v_challenge FROM daily_focus_challenges WHERE user_id=p_user_id AND challenge_date=v_today;
  INSERT INTO daily_focus_question_history (user_id,challenge_id,question_id,topic)
  SELECT p_user_id,v_challenge.id,q->>'question_id',dfq.topic FROM jsonb_array_elements(v_challenge.questions) q
  JOIN daily_focus_questions dfq ON dfq.id=q->>'question_id' WHERE q ? 'question_id'
  ON CONFLICT (challenge_id,question_id) DO NOTHING;
  RETURN v_challenge;
END;
$$;

COMMIT;
