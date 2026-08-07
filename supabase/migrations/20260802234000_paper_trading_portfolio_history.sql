-- KO-264 / KO-265: authoritative paper portfolio valuation history.
-- Snapshots are written only by security-definer functions during a claim,
-- executed trade, or server-side market refresh; the browser can only read its own.

BEGIN;

CREATE TABLE portfolio_value_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id UUID NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
  snapshot_date DATE NOT NULL,
  cash_balance NUMERIC(12,2) NOT NULL,
  holdings_value NUMERIC(12,2) NOT NULL,
  total_value NUMERIC(12,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(portfolio_id, snapshot_date)
);

COMMENT ON TABLE portfolio_value_snapshots IS 'Daily authoritative paper portfolio valuations. Users can read only snapshots for their own portfolio; server functions write them.';

CREATE INDEX idx_portfolio_value_snapshots_portfolio_date
  ON portfolio_value_snapshots (portfolio_id, snapshot_date DESC);

ALTER TABLE portfolio_value_snapshots ENABLE ROW LEVEL SECURITY;

-- Users can inspect their own performance history but cannot insert or alter a valuation.
CREATE POLICY "Users read own portfolio value snapshots"
  ON portfolio_value_snapshots FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM portfolios
      WHERE portfolios.id = portfolio_value_snapshots.portfolio_id
        AND portfolios.user_id = auth.uid()
    )
  );

COMMENT ON POLICY "Users read own portfolio value snapshots" ON portfolio_value_snapshots IS 'Authenticated users may read snapshots only for the portfolio they own.';

CREATE OR REPLACE FUNCTION record_paper_portfolio_snapshot(
  p_portfolio_id UUID,
  p_snapshot_date DATE DEFAULT CURRENT_DATE
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cash_balance NUMERIC(12,2);
  v_holdings_value NUMERIC(12,2);
BEGIN
  SELECT cash_balance INTO v_cash_balance
  FROM portfolios
  WHERE id = p_portfolio_id
  FOR UPDATE;

  IF v_cash_balance IS NULL THEN
    RAISE EXCEPTION 'Portfolio % does not exist', p_portfolio_id;
  END IF;

  WITH priced_holdings AS (
    SELECT
      h.id,
      h.shares,
      COALESCE(
        (
          SELECT md.close_price
          FROM market_data md
          WHERE md.symbol = h.symbol
            AND md.trade_date <= p_snapshot_date
          ORDER BY md.trade_date DESC
          LIMIT 1
        ),
        h.current_price,
        h.average_cost
      ) AS close_price
    FROM holdings h
    WHERE h.portfolio_id = p_portfolio_id
  ), updated_holdings AS (
    UPDATE holdings h
    SET current_price = ph.close_price,
        last_price_updated_at = NOW(),
        updated_at = NOW()
    FROM priced_holdings ph
    WHERE h.id = ph.id
    RETURNING ph.shares, ph.close_price
  )
  SELECT COALESCE(SUM(shares * close_price), 0)
  INTO v_holdings_value
  FROM updated_holdings;

  UPDATE portfolios
  SET total_value = v_cash_balance + v_holdings_value,
      updated_at = NOW()
  WHERE id = p_portfolio_id;

  INSERT INTO portfolio_value_snapshots (
    portfolio_id, snapshot_date, cash_balance, holdings_value, total_value
  ) VALUES (
    p_portfolio_id,
    p_snapshot_date,
    v_cash_balance,
    v_holdings_value,
    v_cash_balance + v_holdings_value
  )
  ON CONFLICT (portfolio_id, snapshot_date) DO UPDATE
  SET cash_balance = EXCLUDED.cash_balance,
      holdings_value = EXCLUDED.holdings_value,
      total_value = EXCLUDED.total_value,
      created_at = NOW();
END;
$$;

CREATE OR REPLACE FUNCTION refresh_paper_portfolio_values(
  p_snapshot_date DATE DEFAULT CURRENT_DATE
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_portfolio RECORD;
BEGIN
  FOR v_portfolio IN SELECT id FROM portfolios LOOP
    PERFORM record_paper_portfolio_snapshot(v_portfolio.id, p_snapshot_date);
  END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION get_portfolio_value_history(
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

  IF p_days IS NOT NULL AND (p_days < 1 OR p_days > 366) THEN
    RAISE EXCEPTION 'Snapshot range must be between 1 and 366 days.';
  END IF;

  RETURN QUERY
  SELECT s.snapshot_date, s.cash_balance, s.holdings_value, s.total_value
  FROM portfolio_value_snapshots s
  JOIN portfolios p ON p.id = s.portfolio_id
  WHERE p.user_id = p_user_id
    AND (p_days IS NULL OR s.snapshot_date >= CURRENT_DATE - (p_days - 1))
  ORDER BY s.snapshot_date ASC;
END;
$$;

CREATE OR REPLACE FUNCTION claim_paper_portfolio(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_portfolio portfolios%ROWTYPE;
  v_required_count INTEGER;
  v_completed_count INTEGER;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT COUNT(*) INTO v_required_count
  FROM lessons l JOIN topics t ON t.id = l.topic_id
  WHERE l.is_published = TRUE AND t.chapter = 'Investing in Indonesia';

  SELECT COUNT(DISTINCT lp.lesson_id) INTO v_completed_count
  FROM lesson_progress lp
  JOIN lessons l ON l.id = lp.lesson_id
  JOIN topics t ON t.id = l.topic_id
  WHERE lp.user_id = p_user_id AND lp.status = 'completed'
    AND l.is_published = TRUE AND t.chapter = 'Investing in Indonesia';

  IF v_required_count = 0 OR v_completed_count <> v_required_count THEN
    RAISE EXCEPTION 'Complete Chapter 08 before opening your paper portfolio.';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM user_settings
    WHERE user_id = p_user_id AND trade_onboarding_completed = TRUE
  ) THEN
    RAISE EXCEPTION 'Complete paper trading onboarding before opening your portfolio.';
  END IF;

  SELECT * INTO v_portfolio FROM portfolios WHERE user_id = p_user_id FOR UPDATE;

  IF v_portfolio.id IS NULL THEN
    INSERT INTO portfolios (user_id, starting_cash, cash_balance, total_value, status, unlock_claimed_at)
    VALUES (p_user_id, 10000000, 10000000, 10000000, 'active', NOW())
    RETURNING * INTO v_portfolio;
  ELSIF v_portfolio.unlock_claimed_at IS NULL THEN
    UPDATE portfolios SET unlock_claimed_at = NOW(), updated_at = NOW()
    WHERE id = v_portfolio.id
    RETURNING * INTO v_portfolio;
  END IF;

  PERFORM record_paper_portfolio_snapshot(v_portfolio.id, CURRENT_DATE);

  SELECT * INTO v_portfolio FROM portfolios WHERE id = v_portfolio.id;
  RETURN jsonb_build_object(
    'claimed', TRUE,
    'portfolio', jsonb_build_object(
      'id', v_portfolio.id, 'user_id', v_portfolio.user_id,
      'starting_cash', v_portfolio.starting_cash, 'cash_balance', v_portfolio.cash_balance,
      'total_value', v_portfolio.total_value, 'status', v_portfolio.status,
      'created_at', v_portfolio.created_at, 'updated_at', v_portfolio.updated_at,
      'unlock_claimed_at', v_portfolio.unlock_claimed_at
    )
  );
END;
$$;

CREATE OR REPLACE FUNCTION execute_trade(
  p_user_id UUID, p_symbol TEXT, p_trade_type TEXT, p_lot_count INTEGER
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_portfolio RECORD;
  v_holding RECORD;
  v_price NUMERIC(12,2);
  v_shares INTEGER;
  v_total_amount NUMERIC(12,2);
  v_latest_trade_date DATE;
  v_trade_record RECORD;
  v_badge_id UUID;
  v_first_trade INTEGER := 0;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege'; END IF;
  IF NOT EXISTS (SELECT 1 FROM lessons l JOIN topics t ON t.id = l.topic_id WHERE l.is_published = TRUE AND t.chapter = 'Investing in Indonesia')
    OR EXISTS (SELECT 1 FROM lessons l JOIN topics t ON t.id = l.topic_id WHERE l.is_published = TRUE AND t.chapter = 'Investing in Indonesia' AND NOT EXISTS (SELECT 1 FROM lesson_progress lp WHERE lp.user_id = p_user_id AND lp.lesson_id = l.id AND lp.status = 'completed')) THEN
    RAISE EXCEPTION 'Complete Chapter 08 — Investing in Indonesia before paper trading.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM user_settings WHERE user_id = p_user_id AND trade_onboarding_completed = TRUE) THEN RAISE EXCEPTION 'Complete trade onboarding before paper trading.'; END IF;
  IF p_trade_type NOT IN ('buy', 'sell') THEN RAISE EXCEPTION 'Invalid trade type. Must be buy or sell.'; END IF;
  IF p_lot_count IS NULL OR p_lot_count <= 0 THEN RAISE EXCEPTION 'Lot count must be greater than 0.'; END IF;

  SELECT * INTO v_portfolio FROM portfolios WHERE user_id = p_user_id FOR UPDATE;
  IF v_portfolio IS NULL THEN RAISE EXCEPTION 'Open your paper portfolio before placing an order.'; END IF;
  SELECT MAX(trade_date) INTO v_latest_trade_date FROM market_data WHERE symbol = p_symbol;
  SELECT close_price INTO v_price FROM market_data WHERE symbol = p_symbol AND trade_date = v_latest_trade_date;
  IF v_price IS NULL THEN RAISE EXCEPTION 'No market data available for symbol %', p_symbol; END IF;

  v_shares := p_lot_count * 100;
  v_total_amount := v_shares * v_price;
  SELECT * INTO v_holding FROM holdings WHERE portfolio_id = v_portfolio.id AND symbol = p_symbol FOR UPDATE;

  IF p_trade_type = 'buy' THEN
    IF v_portfolio.cash_balance < v_total_amount THEN RAISE EXCEPTION 'Insufficient cash balance. Available: %, Required: %', v_portfolio.cash_balance, v_total_amount; END IF;
    IF v_holding IS NULL THEN
      INSERT INTO holdings (portfolio_id, symbol, shares, average_cost, current_price, last_price_updated_at)
      VALUES (v_portfolio.id, p_symbol, v_shares, v_price, v_price, NOW());
    ELSE
      UPDATE holdings SET shares = shares + v_shares,
        average_cost = ((shares * average_cost) + (v_shares * v_price)) / (shares + v_shares),
        current_price = v_price, last_price_updated_at = NOW(), updated_at = NOW() WHERE id = v_holding.id;
    END IF;
    UPDATE portfolios SET cash_balance = cash_balance - v_total_amount, updated_at = NOW() WHERE id = v_portfolio.id;
  ELSE
    IF v_holding IS NULL OR v_holding.shares < v_shares THEN RAISE EXCEPTION 'Insufficient shares to sell. Owned: %, Requested: %', COALESCE(v_holding.shares, 0), v_shares; END IF;
    IF v_holding.shares = v_shares THEN DELETE FROM holdings WHERE id = v_holding.id;
    ELSE UPDATE holdings SET shares = shares - v_shares, current_price = v_price, last_price_updated_at = NOW(), updated_at = NOW() WHERE id = v_holding.id; END IF;
    UPDATE portfolios SET cash_balance = cash_balance + v_total_amount, updated_at = NOW() WHERE id = v_portfolio.id;
  END IF;

  INSERT INTO trades (portfolio_id, symbol, trade_type, shares, price, total_amount, lot_count)
  VALUES (v_portfolio.id, p_symbol, p_trade_type, v_shares, v_price, v_total_amount, p_lot_count)
  RETURNING * INTO v_trade_record;
  SELECT COUNT(*) INTO v_first_trade FROM trades WHERE portfolio_id = v_portfolio.id;
  IF v_first_trade = 1 THEN
    SELECT id INTO v_badge_id FROM badges WHERE slug = 'first_trade' LIMIT 1;
    IF v_badge_id IS NOT NULL THEN
      INSERT INTO user_badges (user_id, badge_id) VALUES (p_user_id, v_badge_id) ON CONFLICT (user_id, badge_id) DO NOTHING;
      INSERT INTO xp_events (user_id, source_type, source_id, xp_amount) VALUES (p_user_id, 'first_trade', v_trade_record.id, 50);
      PERFORM award_koin_points(p_user_id, 25, 'trade_milestone', v_trade_record.id, 'First trade');
    END IF;
  END IF;
  PERFORM record_paper_portfolio_snapshot(v_portfolio.id, CURRENT_DATE);
  PERFORM check_graduation(p_user_id);
  RETURN jsonb_build_object('trade_id', v_trade_record.id, 'symbol', v_trade_record.symbol, 'trade_type', v_trade_record.trade_type, 'shares', v_trade_record.shares, 'lot_count', v_trade_record.lot_count, 'price', v_trade_record.price, 'total_amount', v_trade_record.total_amount, 'cash_balance', (SELECT cash_balance FROM portfolios WHERE id = v_portfolio.id));
END;
$$;

-- Backfill a truthful current-day point for existing portfolios, then keep it
-- current whenever the ingestion job records a new IDX EOD close.
SELECT refresh_paper_portfolio_values(CURRENT_DATE);

REVOKE EXECUTE ON FUNCTION record_paper_portfolio_snapshot(UUID, DATE) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION refresh_paper_portfolio_values(DATE) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION get_portfolio_value_history(UUID, INTEGER) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION get_portfolio_value_history(UUID, INTEGER) TO authenticated;
REVOKE EXECUTE ON FUNCTION claim_paper_portfolio(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION claim_paper_portfolio(UUID) TO authenticated;
REVOKE EXECUTE ON FUNCTION execute_trade(UUID, TEXT, TEXT, INTEGER) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION execute_trade(UUID, TEXT, TEXT, INTEGER) TO authenticated;

COMMIT;
