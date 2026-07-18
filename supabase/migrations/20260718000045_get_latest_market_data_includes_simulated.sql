-- Migration 045: Include is_simulated flag in latest market data RPC.

BEGIN;

CREATE OR REPLACE FUNCTION get_latest_market_data()
RETURNS TABLE (
  id UUID,
  symbol TEXT,
  company_name TEXT,
  trade_date DATE,
  close_price NUMERIC(12,2),
  volume BIGINT,
  is_simulated BOOLEAN
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
    m.is_simulated
  FROM market_data m
  ORDER BY m.symbol, m.trade_date DESC;
$$;

GRANT EXECUTE ON FUNCTION get_latest_market_data() TO authenticated, anon;

COMMIT;
