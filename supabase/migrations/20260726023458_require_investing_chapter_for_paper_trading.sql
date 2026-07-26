-- KO-160 correction: paper trading unlocks only after all published lessons
-- in Chapter 08, Investing in Indonesia, and the existing onboarding.

CREATE OR REPLACE FUNCTION execute_trade(
  p_user_id UUID,
  p_symbol TEXT,
  p_trade_type TEXT,
  p_lot_count INTEGER
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
  v_result JSONB;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM lessons l
    JOIN topics t ON t.id = l.topic_id
    WHERE l.is_published = TRUE
      AND t.chapter = 'Investing in Indonesia'
  ) OR EXISTS (
    SELECT 1
    FROM lessons l
    JOIN topics t ON t.id = l.topic_id
    WHERE l.is_published = TRUE
      AND t.chapter = 'Investing in Indonesia'
      AND NOT EXISTS (
        SELECT 1
        FROM lesson_progress lp
        WHERE lp.user_id = p_user_id
          AND lp.lesson_id = l.id
          AND lp.status = 'completed'
      )
  ) THEN
    RAISE EXCEPTION 'Complete Chapter 08 — Investing in Indonesia before paper trading.';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM user_settings
    WHERE user_id = p_user_id
      AND trade_onboarding_completed = TRUE
  ) THEN
    RAISE EXCEPTION 'Complete trade onboarding before paper trading.';
  END IF;

  IF p_trade_type NOT IN ('buy', 'sell') THEN
    RAISE EXCEPTION 'Invalid trade type. Must be buy or sell.';
  END IF;

  IF p_lot_count IS NULL OR p_lot_count <= 0 THEN
    RAISE EXCEPTION 'Lot count must be greater than 0.';
  END IF;

  SELECT * INTO v_portfolio FROM portfolios WHERE user_id = p_user_id;
  IF v_portfolio IS NULL THEN
    INSERT INTO portfolios (user_id, starting_cash, cash_balance, total_value)
    VALUES (p_user_id, 10000000, 10000000, 10000000)
    RETURNING * INTO v_portfolio;
  END IF;

  SELECT MAX(trade_date) INTO v_latest_trade_date
  FROM market_data WHERE symbol = p_symbol;

  SELECT close_price INTO v_price
  FROM market_data
  WHERE symbol = p_symbol AND trade_date = v_latest_trade_date;

  IF v_price IS NULL THEN
    RAISE EXCEPTION 'No market data available for symbol %', p_symbol;
  END IF;

  v_shares := p_lot_count * 100;
  v_total_amount := v_shares * v_price;

  SELECT * INTO v_holding
  FROM holdings
  WHERE portfolio_id = v_portfolio.id AND symbol = p_symbol;

  IF p_trade_type = 'buy' THEN
    IF v_portfolio.cash_balance < v_total_amount THEN
      RAISE EXCEPTION 'Insufficient cash balance. Available: %, Required: %', v_portfolio.cash_balance, v_total_amount;
    END IF;

    UPDATE portfolios
    SET cash_balance = cash_balance - v_total_amount,
        total_value = cash_balance - v_total_amount + COALESCE((
          SELECT SUM(h.shares * v_price)
          FROM holdings h
          WHERE h.portfolio_id = v_portfolio.id
        ), 0),
        updated_at = NOW()
    WHERE id = v_portfolio.id;

    IF v_holding IS NULL THEN
      INSERT INTO holdings (portfolio_id, symbol, shares, average_cost, current_price, last_price_updated_at)
      VALUES (v_portfolio.id, p_symbol, v_shares, v_price, v_price, NOW());
    ELSE
      UPDATE holdings
      SET shares = shares + v_shares,
          average_cost = ((shares * average_cost) + (v_shares * v_price)) / (shares + v_shares),
          current_price = v_price,
          last_price_updated_at = NOW(),
          updated_at = NOW()
      WHERE id = v_holding.id;
    END IF;
  ELSE
    IF v_holding IS NULL OR v_holding.shares < v_shares THEN
      RAISE EXCEPTION 'Insufficient shares to sell. Owned: %, Requested: %', COALESCE(v_holding.shares, 0), v_shares;
    END IF;

    UPDATE portfolios
    SET cash_balance = cash_balance + v_total_amount,
        total_value = cash_balance + v_total_amount + COALESCE((
          SELECT SUM(h.shares * v_price)
          FROM holdings h
          WHERE h.portfolio_id = v_portfolio.id AND h.symbol <> p_symbol
        ), 0) + ((COALESCE(v_holding.shares, 0) - v_shares) * v_price),
        updated_at = NOW()
    WHERE id = v_portfolio.id;

    IF v_holding.shares = v_shares THEN
      DELETE FROM holdings WHERE id = v_holding.id;
    ELSE
      UPDATE holdings
      SET shares = shares - v_shares,
          current_price = v_price,
          last_price_updated_at = NOW(),
          updated_at = NOW()
      WHERE id = v_holding.id;
    END IF;
  END IF;

  INSERT INTO trades (portfolio_id, symbol, trade_type, shares, price, total_amount, lot_count)
  VALUES (v_portfolio.id, p_symbol, p_trade_type, v_shares, v_price, v_total_amount, p_lot_count)
  RETURNING * INTO v_trade_record;

  SELECT COUNT(*) INTO v_first_trade FROM trades WHERE portfolio_id = v_portfolio.id;
  IF v_first_trade = 1 THEN
    SELECT id INTO v_badge_id FROM badges WHERE slug = 'first_trade' LIMIT 1;
    IF v_badge_id IS NOT NULL THEN
      INSERT INTO user_badges (user_id, badge_id)
      VALUES (p_user_id, v_badge_id)
      ON CONFLICT (user_id, badge_id) DO NOTHING;

      INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
      VALUES (p_user_id, 'first_trade', v_trade_record.id, 50);

      PERFORM award_koin_points(p_user_id, 25, 'trade_milestone', v_trade_record.id, 'First trade');
    END IF;
  END IF;

  PERFORM check_graduation(p_user_id);

  v_result := jsonb_build_object(
    'trade_id', v_trade_record.id,
    'symbol', v_trade_record.symbol,
    'trade_type', v_trade_record.trade_type,
    'shares', v_trade_record.shares,
    'lot_count', v_trade_record.lot_count,
    'price', v_trade_record.price,
    'total_amount', v_trade_record.total_amount,
    'cash_balance', (SELECT cash_balance FROM portfolios WHERE id = v_portfolio.id)
  );

  RETURN v_result;
END;
$$;

REVOKE EXECUTE ON FUNCTION execute_trade(UUID, TEXT, TEXT, INTEGER) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION execute_trade(UUID, TEXT, TEXT, INTEGER) TO authenticated;
