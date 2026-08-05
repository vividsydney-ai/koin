-- KO-274: expose delayed/simulated daily history through the same safe public
-- RPC boundary as latest market data. The market_data table itself is not a
-- client-readable table in the linked project.
CREATE OR REPLACE FUNCTION public.get_market_data_history(
  p_symbol TEXT,
  p_days INTEGER DEFAULT 30
)
RETURNS TABLE (
  trade_date DATE,
  close_price NUMERIC(12,2),
  is_simulated BOOLEAN
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT
    md.trade_date,
    md.close_price,
    md.is_simulated
  FROM public.market_data AS md
  INNER JOIN public.instruments AS i
    ON i.symbol = md.symbol
   AND i.is_active = TRUE
  WHERE md.symbol = UPPER(TRIM(p_symbol))
  ORDER BY md.trade_date DESC
  LIMIT LEAST(GREATEST(COALESCE(p_days, 30), 1), 365);
$$;

COMMENT ON FUNCTION public.get_market_data_history(TEXT, INTEGER) IS
  'Public delayed/simulated daily close history for one active IDX instrument; no user data is exposed.';

GRANT EXECUTE ON FUNCTION public.get_market_data_history(TEXT, INTEGER) TO authenticated, anon;
