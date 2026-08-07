-- Migration: KO-ANALYTICS-001 Analytics instrumentation + SQL views
-- Scope: index analytics_events, record signup_completed from auth trigger,
-- and create admin-only SQL views for MVP metrics.

BEGIN;

-- 1. Performance indexes for analytics queries.
CREATE INDEX IF NOT EXISTS idx_analytics_events_user_created
  ON analytics_events (user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_analytics_events_name_created
  ON analytics_events (event_name, created_at DESC);

-- 2. Automatically record signup_completed when a new auth user is created.
-- This avoids relying on the client, where email confirmation means no session yet.
CREATE OR REPLACE FUNCTION public.track_signup_completed()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.analytics_events (user_id, event_name, properties)
  VALUES (NEW.id, 'signup_completed', jsonb_build_object('source', 'auth_trigger'));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.track_signup_completed() IS 'Records analytics signup_completed for every new Supabase Auth user.';

DROP TRIGGER IF EXISTS on_auth_user_signup_analytics ON auth.users;
CREATE TRIGGER on_auth_user_signup_analytics
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.track_signup_completed();

-- 3. Daily Active Users (North Star: learning or trading activity).
-- Active = any event that demonstrates product usage beyond passive login.
CREATE OR REPLACE VIEW analytics_dau AS
SELECT
  DATE_TRUNC('day', created_at)::DATE AS day,
  COUNT(DISTINCT user_id) AS active_users
FROM analytics_events
WHERE event_name IN (
  'lesson_started',
  'lesson_completed',
  'quiz_completed',
  'trade_executed',
  'first_trade',
  'share_progress'
)
GROUP BY day
ORDER BY day DESC;

COMMENT ON VIEW analytics_dau IS 'Daily active users based on learning/trading/sharing events.';

-- 4. Activation: signed-up users who started their first lesson within 24 hours.
CREATE OR REPLACE VIEW analytics_activation AS
WITH first_lesson_start AS (
  SELECT
    user_id,
    MIN(created_at) AS first_started_at
  FROM analytics_events
  WHERE event_name = 'lesson_started'
  GROUP BY user_id
)
SELECT
  p.id AS user_id,
  p.created_at::DATE AS signup_date,
  COALESCE(fl.first_started_at, NULL) AS first_lesson_started_at,
  CASE
    WHEN fl.first_started_at IS NOT NULL
      AND fl.first_started_at <= p.created_at + INTERVAL '24 hours'
    THEN TRUE
    ELSE FALSE
  END AS activated_24h,
  CASE
    WHEN fl.first_started_at IS NOT NULL
      AND fl.first_started_at <= p.created_at + INTERVAL '7 days'
    THEN TRUE
    ELSE FALSE
  END AS activated_7d
FROM profiles p
LEFT JOIN first_lesson_start fl ON fl.user_id = p.id;

COMMENT ON VIEW analytics_activation IS 'Per-user activation: started a lesson within 24h or 7d of signup.';

-- 5. D7 / D30 retention cohorts.
CREATE OR REPLACE VIEW analytics_retention AS
WITH signup_events AS (
  SELECT
    user_id,
    MIN(created_at) AS signup_at
  FROM analytics_events
  WHERE event_name = 'signup_completed'
  GROUP BY user_id
),
active_days AS (
  SELECT DISTINCT
    user_id,
    DATE_TRUNC('day', created_at)::DATE AS active_day
  FROM analytics_events
  WHERE event_name IN (
    'lesson_started',
    'lesson_completed',
    'quiz_completed',
    'trade_executed',
    'first_trade',
    'share_progress'
  )
)
SELECT
  DATE_TRUNC('week', se.signup_at)::DATE AS cohort_week,
  COUNT(DISTINCT se.user_id) AS cohort_size,
  COUNT(DISTINCT CASE WHEN ad.active_day = DATE_TRUNC('day', se.signup_at)::DATE + INTERVAL '6 days' THEN se.user_id END) AS d7_active_users,
  COUNT(DISTINCT CASE WHEN ad.active_day = DATE_TRUNC('day', se.signup_at)::DATE + INTERVAL '29 days' THEN se.user_id END) AS d30_active_users,
  ROUND(
    COUNT(DISTINCT CASE WHEN ad.active_day = DATE_TRUNC('day', se.signup_at)::DATE + INTERVAL '6 days' THEN se.user_id END)::NUMERIC
    / NULLIF(COUNT(DISTINCT se.user_id), 0) * 100,
    2
  ) AS d7_retention_pct,
  ROUND(
    COUNT(DISTINCT CASE WHEN ad.active_day = DATE_TRUNC('day', se.signup_at)::DATE + INTERVAL '29 days' THEN se.user_id END)::NUMERIC
    / NULLIF(COUNT(DISTINCT se.user_id), 0) * 100,
    2
  ) AS d30_retention_pct
FROM signup_events se
LEFT JOIN active_days ad ON ad.user_id = se.user_id
GROUP BY cohort_week
ORDER BY cohort_week DESC;

COMMENT ON VIEW analytics_retention IS 'Weekly cohort retention: % of signups active on day 7 and day 30.';

-- 6. Lesson completion funnel by day.
CREATE OR REPLACE VIEW analytics_lesson_completion AS
SELECT
  DATE_TRUNC('day', created_at)::DATE AS day,
  COUNT(*) FILTER (WHERE event_name = 'lesson_started') AS lessons_started,
  COUNT(*) FILTER (WHERE event_name = 'lesson_completed') AS lessons_completed,
  COUNT(DISTINCT user_id) FILTER (WHERE event_name = 'lesson_completed') AS unique_users_completed
FROM analytics_events
WHERE event_name IN ('lesson_started', 'lesson_completed')
GROUP BY day
ORDER BY day DESC;

COMMENT ON VIEW analytics_lesson_completion IS 'Daily lesson started vs completed counts.';

-- 7. First trade latency per user.
CREATE OR REPLACE VIEW analytics_first_trade AS
WITH first_trade_event AS (
  SELECT
    user_id,
    MIN(created_at) AS first_trade_at
  FROM analytics_events
  WHERE event_name = 'first_trade'
  GROUP BY user_id
)
SELECT
  p.id AS user_id,
  p.created_at::DATE AS signup_date,
  ft.first_trade_at,
  EXTRACT(EPOCH FROM (ft.first_trade_at - p.created_at)) / 3600.0 AS hours_to_first_trade
FROM profiles p
LEFT JOIN first_trade_event ft ON ft.user_id = p.id;

COMMENT ON VIEW analytics_first_trade IS 'Time from signup to first paper trade per user.';

COMMIT;
