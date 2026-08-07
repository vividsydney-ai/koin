-- Migration 014: Graduation check RPC
-- Detects when a portfolio reaches 3x–5x starting value and issues a certificate.

CREATE OR REPLACE FUNCTION check_graduation(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_portfolio RECORD;
  v_total_value NUMERIC(12,2);
  v_multiplier NUMERIC(4,2);
  v_existing_certificate INTEGER;
  v_certificate_id UUID;
  v_certificate_code TEXT;
  v_share_id TEXT;
  v_badge_id UUID;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT * INTO v_portfolio FROM portfolios WHERE user_id = p_user_id;

  IF v_portfolio IS NULL OR v_portfolio.starting_cash <= 0 THEN
    RETURN jsonb_build_object('graduated', false, 'reason', 'no_portfolio');
  END IF;

  -- Compute total value: cash + holdings at latest market price.
  SELECT COALESCE(SUM(h.shares * md.close_price), 0) + v_portfolio.cash_balance
  INTO v_total_value
  FROM holdings h
  JOIN LATERAL (
    SELECT close_price
    FROM market_data
    WHERE symbol = h.symbol
    ORDER BY trade_date DESC
    LIMIT 1
  ) md ON TRUE
  WHERE h.portfolio_id = v_portfolio.id;

  v_multiplier := ROUND(v_total_value / v_portfolio.starting_cash, 2);

  IF v_multiplier < 3 THEN
    RETURN jsonb_build_object(
      'graduated', false,
      'multiplier', v_multiplier,
      'total_value', v_total_value
    );
  END IF;

  SELECT COUNT(*) INTO v_existing_certificate FROM certificates WHERE user_id = p_user_id;
  IF v_existing_certificate > 0 THEN
    RETURN jsonb_build_object(
      'graduated', true,
      'multiplier', v_multiplier,
      'total_value', v_total_value,
      'already_issued', true
    );
  END IF;

  v_certificate_code := 'KOIN-' || UPPER(substr(md5(random()::text), 1, 8));
  v_share_id := substr(md5(random()::text), 1, 12);

  INSERT INTO certificates (user_id, certificate_code, portfolio_value_at_graduation, multiplier_achieved, share_public_id)
  VALUES (p_user_id, v_certificate_code, v_total_value, v_multiplier, v_share_id)
  RETURNING id INTO v_certificate_id;

  UPDATE portfolios SET status = 'graduated', updated_at = NOW() WHERE id = v_portfolio.id;

  -- Award graduation badge.
  SELECT id INTO v_badge_id FROM badges WHERE slug = 'graduate' LIMIT 1;
  IF v_badge_id IS NOT NULL THEN
    INSERT INTO user_badges (user_id, badge_id)
    VALUES (p_user_id, v_badge_id)
    ON CONFLICT (user_id, badge_id) DO NOTHING;
  END IF;

  -- Award graduation XP and Koin Points.
  INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
  VALUES (p_user_id, 'graduation', v_certificate_id, 200);

  PERFORM award_koin_points(p_user_id, 500, 'graduation', v_certificate_id, 'Graduated from paper trading');

  RETURN jsonb_build_object(
    'graduated', true,
    'certificate_id', v_certificate_id,
    'certificate_code', v_certificate_code,
    'share_public_id', v_share_id,
    'multiplier', v_multiplier,
    'total_value', v_total_value
  );
END;
$$;

COMMENT ON FUNCTION check_graduation(UUID) IS 'Check if a user has graduated based on portfolio value and issue certificate/badge/rewards.';

GRANT EXECUTE ON FUNCTION check_graduation(UUID) TO authenticated;

-- Wire graduation check into trade execution.
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

  -- First-trade badge, XP, and Koin Points.
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

  -- Check for graduation after every trade.
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

GRANT EXECUTE ON FUNCTION execute_trade(UUID, TEXT, TEXT, INTEGER) TO authenticated;
