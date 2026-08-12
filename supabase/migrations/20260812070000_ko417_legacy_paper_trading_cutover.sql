-- KO-417: retire the legacy Paper Trading product without deleting beta history.
--
-- The new Practice Market ledger is deliberately out of scope for this migration
-- (KO-421). This migration only establishes a fail-closed boundary: legacy rows
-- are marked and catalogued for staff, while learner clients lose all access.

BEGIN;

CREATE TABLE IF NOT EXISTS public.practice_market_cutover_state (
  id BOOLEAN PRIMARY KEY DEFAULT TRUE CHECK (id = TRUE),
  legacy_archived_at TIMESTAMPTZ NOT NULL,
  season_access_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  notice TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.practice_market_legacy_archive_manifest (
  archive_key TEXT PRIMARY KEY,
  archived_at TIMESTAMPTZ NOT NULL,
  row_counts JSONB NOT NULL,
  market_data_summary JSONB NOT NULL,
  notes TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.practice_market_cutover_state ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_legacy_archive_manifest ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.practice_market_cutover_state, public.practice_market_legacy_archive_manifest
  FROM PUBLIC, anon, authenticated;

INSERT INTO public.practice_market_cutover_state (
  id,
  legacy_archived_at,
  season_access_enabled,
  notice
)
VALUES (
  TRUE,
  NOW(),
  FALSE,
  'Season 1 is being prepared. Complete Chapter 08 and Before the Bell onboarding to be ready.'
)
ON CONFLICT (id) DO NOTHING;

ALTER TABLE public.portfolios
  ADD COLUMN IF NOT EXISTS legacy_archived_at TIMESTAMPTZ;
ALTER TABLE public.holdings
  ADD COLUMN IF NOT EXISTS legacy_archived_at TIMESTAMPTZ;
ALTER TABLE public.trades
  ADD COLUMN IF NOT EXISTS legacy_archived_at TIMESTAMPTZ;
ALTER TABLE public.watchlists
  ADD COLUMN IF NOT EXISTS legacy_archived_at TIMESTAMPTZ;
ALTER TABLE public.portfolio_value_snapshots
  ADD COLUMN IF NOT EXISTS legacy_archived_at TIMESTAMPTZ;
ALTER TABLE public.certificates
  ADD COLUMN IF NOT EXISTS legacy_archived_at TIMESTAMPTZ;

UPDATE public.portfolios AS legacy
SET legacy_archived_at = cutover.legacy_archived_at
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
  AND legacy.legacy_archived_at IS NULL;

UPDATE public.holdings AS legacy
SET legacy_archived_at = cutover.legacy_archived_at
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
  AND legacy.legacy_archived_at IS NULL;

UPDATE public.trades AS legacy
SET legacy_archived_at = cutover.legacy_archived_at
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
  AND legacy.legacy_archived_at IS NULL;

UPDATE public.watchlists AS legacy
SET legacy_archived_at = cutover.legacy_archived_at
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
  AND legacy.legacy_archived_at IS NULL;

UPDATE public.portfolio_value_snapshots AS legacy
SET legacy_archived_at = cutover.legacy_archived_at
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
  AND legacy.legacy_archived_at IS NULL;

UPDATE public.certificates AS legacy
SET legacy_archived_at = cutover.legacy_archived_at
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
  AND legacy.legacy_archived_at IS NULL;

INSERT INTO public.practice_market_legacy_archive_manifest (
  archive_key,
  archived_at,
  row_counts,
  market_data_summary,
  notes
)
SELECT
  'legacy-paper-trading-v1',
  cutover.legacy_archived_at,
  jsonb_build_object(
    'portfolios', (SELECT COUNT(*) FROM public.portfolios),
    'holdings', (SELECT COUNT(*) FROM public.holdings),
    'trades', (SELECT COUNT(*) FROM public.trades),
    'watchlists', (SELECT COUNT(*) FROM public.watchlists),
    'portfolio_value_snapshots', (SELECT COUNT(*) FROM public.portfolio_value_snapshots),
    'certificates', (SELECT COUNT(*) FROM public.certificates)
  ),
  jsonb_build_object(
    'rows', (SELECT COUNT(*) FROM public.market_data),
    'first_trade_date', (SELECT MIN(trade_date) FROM public.market_data),
    'last_trade_date', (SELECT MAX(trade_date) FROM public.market_data),
    'simulated_rows', (SELECT COUNT(*) FROM public.market_data WHERE is_simulated = TRUE)
  ),
  'Archived in place for staff-only retention. No learner balance, position, P&L, chart, certificate, or legacy market-data feed carries into Practice Market Season 1.'
FROM public.practice_market_cutover_state AS cutover
WHERE cutover.id = TRUE
ON CONFLICT (archive_key) DO NOTHING;

-- There must be no permissive legacy policy left to re-expose archived rows.
DO $$
DECLARE
  legacy_table TEXT;
  legacy_policy RECORD;
BEGIN
  FOREACH legacy_table IN ARRAY ARRAY[
    'portfolios',
    'holdings',
    'trades',
    'watchlists',
    'portfolio_value_snapshots',
    'certificates'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', legacy_table);
    FOR legacy_policy IN
      SELECT policyname
      FROM pg_policies
      WHERE schemaname = 'public'
        AND tablename = legacy_table
    LOOP
      EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', legacy_policy.policyname, legacy_table);
    END LOOP;
  END LOOP;
END
$$;

REVOKE ALL ON TABLE public.portfolios, public.holdings, public.trades, public.watchlists, public.portfolio_value_snapshots, public.certificates
  FROM PUBLIC, anon, authenticated;

-- Revoke both learner and service-key execution so no old app path can create,
-- value, read, trade, or graduate a legacy portfolio after this boundary.
REVOKE EXECUTE ON FUNCTION public.claim_paper_portfolio(UUID)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE EXECUTE ON FUNCTION public.execute_trade(UUID, TEXT, TEXT, INTEGER)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history_marked(UUID, INTEGER)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE EXECUTE ON FUNCTION public.record_paper_portfolio_snapshot(UUID, DATE)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE EXECUTE ON FUNCTION public.refresh_paper_portfolio_values(DATE)
  FROM PUBLIC, anon, authenticated, service_role;
REVOKE EXECUTE ON FUNCTION public.check_graduation(UUID)
  FROM PUBLIC, anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION public.get_practice_market_cutover_status()
RETURNS TABLE (
  season_access_enabled BOOLEAN,
  legacy_archived BOOLEAN,
  notice TEXT
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    cutover.season_access_enabled,
    TRUE AS legacy_archived,
    cutover.notice
  FROM public.practice_market_cutover_state AS cutover
  WHERE cutover.id = TRUE
$$;

REVOKE EXECUTE ON FUNCTION public.get_practice_market_cutover_status() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_practice_market_cutover_status() TO authenticated;

COMMENT ON TABLE public.practice_market_legacy_archive_manifest IS
  'KO-417 staff-only immutable snapshot of the legacy Paper Trading cutover; retained without deletion.';
COMMENT ON FUNCTION public.get_practice_market_cutover_status() IS
  'KO-417 learner-safe status projection. This does not create or expose a Practice Market account.';

COMMIT;
