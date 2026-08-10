-- KO-353-C: keep Daily Focus interactive payloads answerable.
-- Older challenge snapshots can outlive a question-bank correction. Enrich a
-- response from the private source row, while keeping answer keys server-only.

BEGIN;

CREATE OR REPLACE FUNCTION public.daily_focus_payload_is_renderable(
  p_type TEXT,
  p_payload JSONB
)
RETURNS BOOLEAN
LANGUAGE SQL
IMMUTABLE
SET search_path = public
AS $$
  SELECT COALESCE(
    jsonb_typeof(p_payload) = 'object'
    AND jsonb_typeof(p_payload->'question') = 'string'
    AND length(trim(p_payload->>'question')) > 0
    AND CASE
      WHEN p_type IN ('multiple_choice', 'select_all', 'word_bank', 'ordering', 'fill_blank') THEN
        jsonb_typeof(p_payload->'options') = 'array'
        AND jsonb_array_length(p_payload->'options') >= 2
        AND NOT EXISTS (
          SELECT 1
          FROM jsonb_array_elements(p_payload->'options') option
          WHERE jsonb_typeof(option) <> 'string' OR length(trim(option #>> '{}')) = 0
        )
      WHEN p_type = 'matching' THEN
        jsonb_typeof(p_payload->'pairs') = 'array'
        AND jsonb_array_length(p_payload->'pairs') >= 2
        AND NOT EXISTS (
          SELECT 1
          FROM jsonb_array_elements(p_payload->'pairs') pair
          WHERE jsonb_typeof(pair) <> 'array'
            OR jsonb_array_length(pair) <> 2
            OR jsonb_typeof(pair->0) <> 'string'
            OR jsonb_typeof(pair->1) <> 'string'
            OR length(trim(pair->>0)) = 0
            OR length(trim(pair->>1)) = 0
        )
      WHEN p_type IN ('true_false', 'swipe_yes_no') THEN TRUE
      ELSE FALSE
    END,
    FALSE
  );
$$;

-- Fail the migration if an active source question is itself malformed. This
-- catches future seed/locale regressions before they can create a new snapshot.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.daily_focus_questions AS question
    CROSS JOIN LATERAL jsonb_each(question.body->'locales') AS locale(name, payload)
    WHERE question.is_active
      AND locale.name IN ('en', 'id')
      AND NOT public.daily_focus_payload_is_renderable(question.type, locale.payload)
  ) THEN
    RAISE EXCEPTION 'Active Daily Focus question has an invalid localized interactive payload';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.daily_focus_response(
  p_challenge public.daily_focus_challenges,
  p_profile public.focus_profiles,
  p_answer_correct BOOLEAN DEFAULT NULL,
  p_explanation TEXT DEFAULT NULL,
  p_correct_answer JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE SQL
STABLE
SET search_path = public
AS $$
  WITH sanitized_questions AS (
    SELECT
      (
        raw.question - 'answer' - 'explanation' - 'question_id'
      )
      || CASE
        WHEN raw.question->>'type' = 'matching'
          AND NOT public.daily_focus_payload_is_renderable(raw.question->>'type', raw.question)
          AND public.daily_focus_payload_is_renderable(source.type, localized.payload)
        THEN jsonb_build_object('pairs', localized.payload->'pairs')
        WHEN raw.question->>'type' IN ('multiple_choice', 'select_all', 'word_bank', 'ordering', 'fill_blank')
          AND NOT public.daily_focus_payload_is_renderable(raw.question->>'type', raw.question)
          AND public.daily_focus_payload_is_renderable(source.type, localized.payload)
        THEN jsonb_build_object('options', localized.payload->'options')
        ELSE '{}'::JSONB
      END AS question,
      raw.ordinality
    FROM jsonb_array_elements(p_challenge.questions) WITH ORDINALITY AS raw(question, ordinality)
    LEFT JOIN public.daily_focus_questions AS source
      ON source.id = raw.question->>'question_id'
    LEFT JOIN LATERAL (
      SELECT CASE
        WHEN source.body->'locales'->'id'->>'question' = raw.question->>'question'
          THEN source.body->'locales'->'id'
        WHEN source.body->'locales'->'en' IS NOT NULL
          THEN source.body->'locales'->'en'
        ELSE source.body
      END AS payload
    ) AS localized ON TRUE
  )
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
      SELECT COALESCE(jsonb_agg(question ORDER BY ordinality), '[]'::JSONB)
      FROM sanitized_questions
    ),
    'answer_correct', p_answer_correct,
    'explanation', p_explanation,
    'correct_answer', p_correct_answer
  );
$$;

REVOKE ALL ON FUNCTION public.daily_focus_payload_is_renderable(TEXT, JSONB) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.daily_focus_response(public.daily_focus_challenges, public.focus_profiles, BOOLEAN, TEXT, JSONB) FROM PUBLIC;

COMMIT;
