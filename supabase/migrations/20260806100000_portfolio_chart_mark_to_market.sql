-- KO-274: make the portfolio chart follow the same holding movement shown in
-- the Holdings card. The chart is still delayed EOD/simulated data, but it is
-- marked to each available close instead of waiting for one daily snapshot.

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
DECLARE
  v_portfolio_id UUID;
  v_start_date DATE;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF p_days IS NOT NULL AND (p_days < 1 OR p_days > 366) THEN
    RAISE EXCEPTION 'Snapshot range must be between 1 and 366 days.';
  END IF;

  SELECT p.id,
         GREATEST(
           p.created_at::date,
           COALESCE(
             CASE WHEN p_days IS NULL THEN NULL ELSE CURRENT_DATE - (p_days - 1) END,
             p.created_at::date
           )
         )
  INTO v_portfolio_id, v_start_date
  FROM public.portfolios AS p
  WHERE p.user_id = p_user_id;

  IF v_portfolio_id IS NULL THEN
    RETURN;
  END IF;

  RETURN QUERY
  WITH candidate_dates AS (
    SELECT s.snapshot_date
    FROM public.portfolio_value_snapshots AS s
    WHERE s.portfolio_id = v_portfolio_id
      AND s.snapshot_date >= v_start_date
      AND s.snapshot_date <= CURRENT_DATE

    UNION

    SELECT DISTINCT md.trade_date
    FROM public.market_data AS md
    WHERE md.trade_date >= v_start_date
      AND md.trade_date <= CURRENT_DATE
      AND EXISTS (
        SELECT 1
        FROM public.trades AS t
        WHERE t.portfolio_id = v_portfolio_id
          AND t.symbol = md.symbol
          AND t.created_at::date <= md.trade_date
      )

    UNION

    SELECT CURRENT_DATE
    WHERE CURRENT_DATE >= v_start_date
  ),
  calculated_values AS (
    SELECT
      d.snapshot_date,
      p.starting_cash - COALESCE((
        SELECT SUM(
          CASE WHEN t.trade_type = 'buy' THEN t.total_amount ELSE -t.total_amount END
        )
        FROM public.trades AS t
        WHERE t.portfolio_id = v_portfolio_id
          AND t.created_at::date <= d.snapshot_date
      ), 0) AS calculated_cash,
      COALESCE((
        SELECT SUM(position.shares * COALESCE(price.close_price, current_holding.average_cost, 0))
        FROM (
          SELECT
            t.symbol,
            SUM(CASE WHEN t.trade_type = 'buy' THEN t.shares ELSE -t.shares END) AS shares
          FROM public.trades AS t
          WHERE t.portfolio_id = v_portfolio_id
            AND t.created_at::date <= d.snapshot_date
          GROUP BY t.symbol
          HAVING SUM(CASE WHEN t.trade_type = 'buy' THEN t.shares ELSE -t.shares END) > 0
        ) AS position
        LEFT JOIN public.holdings AS current_holding
          ON current_holding.portfolio_id = v_portfolio_id
         AND current_holding.symbol = position.symbol
        LEFT JOIN LATERAL (
          SELECT md.close_price
          FROM public.market_data AS md
          WHERE md.symbol = position.symbol
            AND md.trade_date <= d.snapshot_date
          ORDER BY md.trade_date DESC
          LIMIT 1
        ) AS price ON TRUE
      ), 0) AS calculated_holdings
    FROM candidate_dates AS d
    CROSS JOIN public.portfolios AS p
    WHERE p.id = v_portfolio_id
  )
  SELECT
    cv.snapshot_date,
    ROUND(cv.calculated_cash, 2),
    ROUND(cv.calculated_holdings, 2),
    ROUND(cv.calculated_cash + cv.calculated_holdings, 2)
  FROM calculated_values AS cv
  ORDER BY cv.snapshot_date ASC;
END;
$$;

COMMENT ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) IS
  'Returns owner-scoped mark-to-market paper portfolio history using trade positions and the latest available delayed/simulated close for each available date.';

REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) TO authenticated;
