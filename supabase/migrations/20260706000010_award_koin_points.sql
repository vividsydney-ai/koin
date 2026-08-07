-- Migration 010: Koin Points award engine
-- Reusable function to credit Koin Points and update user balance atomically.

CREATE OR REPLACE FUNCTION award_koin_points(
  p_user_id UUID,
  p_amount INTEGER,
  p_source_type TEXT,
  p_source_id UUID DEFAULT NULL,
  p_description TEXT DEFAULT NULL
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_balance INTEGER;
  v_lifetime INTEGER;
  v_tx_id UUID;
BEGIN
  IF p_amount IS NULL OR p_amount <= 0 THEN
    RAISE EXCEPTION 'Koin Points amount must be greater than 0';
  END IF;

  IF p_source_type NOT IN ('leaderboard','streak_milestone','graduation','lesson_complete','trade_milestone','reward') THEN
    RAISE EXCEPTION 'Invalid Koin Points source type: %', p_source_type;
  END IF;

  INSERT INTO koin_point_transactions (user_id, amount, source_type, source_id, description)
  VALUES (p_user_id, p_amount, p_source_type, p_source_id, p_description)
  RETURNING id INTO v_tx_id;

  INSERT INTO koin_point_balances (user_id, current_balance, lifetime_earned, updated_at)
  VALUES (p_user_id, p_amount, p_amount, NOW())
  ON CONFLICT (user_id)
  DO UPDATE SET
    current_balance = koin_point_balances.current_balance + p_amount,
    lifetime_earned = koin_point_balances.lifetime_earned + p_amount,
    updated_at = NOW();

  SELECT current_balance, lifetime_earned
  INTO v_balance, v_lifetime
  FROM koin_point_balances
  WHERE user_id = p_user_id;

  RETURN jsonb_build_object(
    'transaction_id', v_tx_id,
    'amount', p_amount,
    'current_balance', v_balance,
    'lifetime_earned', v_lifetime
  );
END;
$$;

COMMENT ON FUNCTION award_koin_points(UUID, INTEGER, TEXT, UUID, TEXT) IS 'Credit Koin Points to a user and record the transaction.';

GRANT EXECUTE ON FUNCTION award_koin_points(UUID, INTEGER, TEXT, UUID, TEXT) TO authenticated, anon;
