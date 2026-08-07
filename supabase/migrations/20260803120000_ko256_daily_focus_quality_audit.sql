-- KO-256: operational quality checks and service-only observability for Daily Focus.

BEGIN;

CREATE OR REPLACE VIEW daily_focus_content_audit
WITH (security_invoker = true)
AS
SELECT
  COUNT(*) FILTER (WHERE is_active) AS active_questions,
  COUNT(*) FILTER (
    WHERE is_active AND (
      NOT (body ? 'locales') OR NOT (body->'locales' ? 'en') OR NOT (body->'locales' ? 'id')
    )
  ) AS missing_locale_variants,
  COUNT(*) FILTER (
    WHERE is_active AND type NOT IN ('multiple_choice','true_false','swipe_yes_no','fill_blank','select_all','word_bank','ordering','matching')
  ) AS unsupported_types,
  COUNT(*) FILTER (WHERE is_active AND (NOT (body ? 'question') OR NOT (body ? 'answer'))) AS malformed_root_payloads
FROM daily_focus_questions;

CREATE OR REPLACE VIEW daily_focus_operational_metrics
WITH (security_invoker = true)
AS
WITH daily_challenges AS (
  SELECT challenge_date,
    COUNT(*) AS challenges_started,
    COUNT(*) FILTER (WHERE status = 'completed') AS challenges_completed,
    COUNT(*) FILTER (WHERE status = 'exhausted') AS challenges_exhausted,
    COUNT(DISTINCT user_id) AS active_learners
  FROM daily_focus_challenges
  GROUP BY challenge_date
), daily_answers AS (
  SELECT (shown_at AT TIME ZONE 'Asia/Jakarta')::date AS activity_date,
    COUNT(*) AS questions_shown,
    COUNT(*) FILTER (WHERE answered_at IS NOT NULL) AS questions_answered,
    COUNT(*) FILTER (WHERE was_correct) AS correct_answers,
    COUNT(*) FILTER (WHERE was_correct = FALSE) AS incorrect_answers,
    COUNT(*) FILTER (WHERE prior_shown_at IS NOT NULL) AS repeated_question_exposures
  FROM (
    SELECT h.*,
      lag(shown_at) OVER (PARTITION BY user_id, question_id ORDER BY shown_at) AS prior_shown_at
    FROM daily_focus_question_history h
  ) history_with_repeats
  GROUP BY (shown_at AT TIME ZONE 'Asia/Jakarta')::date
)
SELECT COALESCE(c.challenge_date, a.activity_date) AS activity_date,
  COALESCE(c.challenges_started, 0) AS challenges_started,
  COALESCE(c.challenges_completed, 0) AS challenges_completed,
  COALESCE(c.challenges_exhausted, 0) AS challenges_exhausted,
  COALESCE(c.active_learners, 0) AS active_learners,
  COALESCE(a.questions_shown, 0) AS questions_shown,
  COALESCE(a.questions_answered, 0) AS questions_answered,
  COALESCE(a.correct_answers, 0) AS correct_answers,
  COALESCE(a.incorrect_answers, 0) AS incorrect_answers,
  COALESCE(a.repeated_question_exposures, 0) AS repeated_question_exposures,
  CASE WHEN COALESCE(a.questions_answered, 0) = 0 THEN NULL
    ELSE ROUND(a.correct_answers::numeric / a.questions_answered, 4) END AS correctness_rate,
  CASE WHEN COALESCE(c.challenges_started, 0) = 0 THEN NULL
    ELSE ROUND(c.challenges_completed::numeric / c.challenges_started, 4) END AS completion_rate
FROM daily_challenges c
FULL OUTER JOIN daily_answers a ON a.activity_date = c.challenge_date;

REVOKE ALL ON daily_focus_content_audit FROM PUBLIC, anon, authenticated;
REVOKE ALL ON daily_focus_operational_metrics FROM PUBLIC, anon, authenticated;

DO $$
DECLARE
  v_missing_locale_variants BIGINT;
  v_unsupported_types BIGINT;
  v_malformed_root_payloads BIGINT;
BEGIN
  SELECT missing_locale_variants, unsupported_types, malformed_root_payloads
  INTO v_missing_locale_variants, v_unsupported_types, v_malformed_root_payloads
  FROM daily_focus_content_audit;

  IF v_missing_locale_variants <> 0 OR v_unsupported_types <> 0 OR v_malformed_root_payloads <> 0 THEN
    RAISE EXCEPTION 'KO-256 Daily Focus audit failed (missing locales %, unsupported types %, malformed roots %)',
      v_missing_locale_variants, v_unsupported_types, v_malformed_root_payloads;
  END IF;
END;
$$;

COMMIT;
