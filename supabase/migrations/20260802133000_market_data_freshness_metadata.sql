-- KO-261: expose authoritative source and ingestion metadata for each latest quote.
-- market_data remains public-readable reference data; the SECURITY DEFINER
-- function only selects existing public rows and returns no user data.

BEGIN;

DROP FUNCTION IF EXISTS get_latest_market_data();

CREATE FUNCTION get_latest_market_data()
RETURNS TABLE (
  id UUID,
  symbol TEXT,
  company_name TEXT,
  trade_date DATE,
  close_price NUMERIC(12,2),
  volume BIGINT,
  is_simulated BOOLEAN,
  source_url TEXT,
  recorded_at TIMESTAMPTZ
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT DISTINCT ON (m.symbol)
    m.id,
    m.symbol,
    m.company_name,
    m.trade_date,
    m.close_price,
    m.volume,
    m.is_simulated,
    m.source_url,
    m.created_at AS recorded_at
  FROM market_data m
  ORDER BY m.symbol, m.trade_date DESC, m.created_at DESC;
$$;

COMMENT ON FUNCTION get_latest_market_data() IS
  'Latest quote per symbol with source URL, EOD date, ingestion timestamp, and simulated-data flag for paper-trading freshness disclosure.';

GRANT EXECUTE ON FUNCTION get_latest_market_data() TO authenticated, anon;

COMMIT;
