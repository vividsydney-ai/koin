-- KO-274: a delayed 1D view needs the latest two available closes so the
-- chart can show the daily movement used by the Holdings card.

ALTER FUNCTION public.get_portfolio_value_history(UUID, INTEGER)
  RENAME TO get_portfolio_value_history_marked;

CREATE OR REPLACE FUNCTION public.get_portfolio_value_history(
  p_user_id UUID,
  p_days INTEGER DEFAULT NULL
)
RETURNS TABLE (
  snapshot_date DATE,
  cash_balance NUMERIC(12,2),
  holdings_value NUMERIC(12,2),
  total_value NUMERIC(12,2)
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF p_days = 1 THEN
    RETURN QUERY
    SELECT latest.snapshot_date, latest.cash_balance, latest.holdings_value, latest.total_value
    FROM (
      SELECT *
      FROM public.get_portfolio_value_history_marked(p_user_id, 8)
      ORDER BY snapshot_date DESC
      LIMIT 2
    ) AS latest
    ORDER BY latest.snapshot_date ASC;
    RETURN;
  END IF;

  RETURN QUERY
  SELECT history.snapshot_date, history.cash_balance, history.holdings_value, history.total_value
  FROM public.get_portfolio_value_history_marked(p_user_id, p_days) AS history
  ORDER BY history.snapshot_date ASC;
END;
$$;

COMMENT ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) IS
  'Returns owner-scoped delayed/simulated mark-to-market history; 1D includes the latest two available closes to show daily movement.';

REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history_marked(UUID, INTEGER) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) TO authenticated;
