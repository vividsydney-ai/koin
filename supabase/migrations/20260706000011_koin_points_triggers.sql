-- Migration 011: Wire Koin Points awards into lesson completion and first trade.

CREATE OR REPLACE FUNCTION complete_lesson(
  p_user_id UUID,
  p_lesson_id UUID,
  p_score INTEGER,
  p_max_score INTEGER,
  p_answers_json JSONB,
  p_time_spent_seconds INTEGER,
  p_quiz_correct BOOLEAN
) RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_today DATE := CURRENT_DATE;
  v_lesson RECORD;
  v_topic_id UUID;
  v_xp INTEGER;
  v_total_xp INTEGER;
  v_checkin JSONB;
  v_new_streak INTEGER;
  v_streak_status TEXT;
  v_badges JSONB := '[]'::jsonb;
  v_badge RECORD;
  v_completed_count INTEGER;
  v_total_lessons INTEGER;
  v_next_lesson_slug TEXT;
  v_attempt_number INTEGER;
  v_existing_status TEXT;
  v_is_first_completion BOOLEAN;
  v_result JSONB;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT id, xp_reward, topic_id, lesson_number, slug
  INTO v_lesson
  FROM lessons
  WHERE id = p_lesson_id AND is_published = TRUE;

  IF v_lesson IS NULL THEN
    RAISE EXCEPTION 'Lesson not found or not published';
  END IF;

  v_topic_id := v_lesson.topic_id;
  v_xp := v_lesson.xp_reward;

  SELECT COALESCE(MAX(attempt_number), 0) + 1
  INTO v_attempt_number
  FROM lesson_attempts
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  INSERT INTO lesson_attempts (
    user_id, lesson_id, attempt_number, score, max_score,
    completed, completed_at, answers_json, time_spent_seconds
  ) VALUES (
    p_user_id, p_lesson_id, v_attempt_number, p_score, p_max_score,
    TRUE, NOW(), p_answers_json, p_time_spent_seconds
  );

  SELECT status INTO v_existing_status
  FROM lesson_progress
  WHERE user_id = p_user_id AND lesson_id = p_lesson_id;

  v_is_first_completion := (v_existing_status IS DISTINCT FROM 'completed');

  INSERT INTO lesson_progress (
    user_id, lesson_id, status, best_score, attempts_count,
    first_completed_at, last_attempted_at
  ) VALUES (
    p_user_id, p_lesson_id, 'completed', p_score, 1, NOW(), NOW()
  )
  ON CONFLICT (user_id, lesson_id)
  DO UPDATE SET
    status = 'completed',
    best_score = GREATEST(lesson_progress.best_score, EXCLUDED.best_score),
    attempts_count = lesson_progress.attempts_count + 1,
    last_attempted_at = NOW(),
    first_completed_at = COALESCE(lesson_progress.first_completed_at, NOW());

  INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
  VALUES (p_user_id, 'lesson_complete', p_lesson_id, v_xp);
  v_total_xp := v_xp;

  IF p_quiz_correct THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'quiz_bonus', p_lesson_id, 10);
    v_total_xp := v_total_xp + 10;
  END IF;

  -- Daily check-in.
  INSERT INTO daily_checkins (user_id, checkin_date, xp_earned)
  VALUES (p_user_id, v_today, v_total_xp)
  ON CONFLICT (user_id, checkin_date)
  DO UPDATE SET xp_earned = daily_checkins.xp_earned + v_total_xp;

  -- Streak maintenance.
  v_checkin := check_in_streak(p_user_id);
  v_new_streak := (v_checkin->>'current_streak_days')::INTEGER;
  v_streak_status := v_checkin->>'streak_status';

  -- Streak milestone XP + Koin Points.
  IF v_new_streak IN (3, 7, 14, 30) THEN
    INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)
    VALUES (p_user_id, 'streak_milestone', p_lesson_id, 25);
    v_total_xp := v_total_xp + 25;

    PERFORM award_koin_points(p_user_id, 50, 'streak_milestone', p_lesson_id, format('%s-day streak milestone', v_new_streak));
  END IF;

  -- Koin Points for lesson completion.
  PERFORM award_koin_points(p_user_id, 10, 'lesson_complete', p_lesson_id, 'Lesson completed');

  IF v_is_first_completion THEN
    SELECT COUNT(*) INTO v_total_lessons
    FROM lessons
    WHERE topic_id = v_topic_id AND is_published = TRUE;

    IF v_total_lessons = 0 THEN
      v_total_lessons := 1;
    END IF;

    INSERT INTO user_mastery (user_id, topic_id, lessons_completed, total_lessons, mastery_score, last_updated)
    VALUES (p_user_id, v_topic_id, 1, v_total_lessons, (1.0 / v_total_lessons * 100)::INTEGER, NOW())
    ON CONFLICT (user_id, topic_id)
    DO UPDATE SET
      lessons_completed = LEAST(user_mastery.lessons_completed + 1, v_total_lessons),
      total_lessons = v_total_lessons,
      mastery_score = (LEAST(user_mastery.lessons_completed + 1, v_total_lessons)::FLOAT / v_total_lessons * 100)::INTEGER,
      last_updated = NOW();
  END IF;

  SELECT COUNT(*) INTO v_completed_count
  FROM lesson_progress
  WHERE user_id = p_user_id AND status = 'completed';

  FOR v_badge IN
    SELECT id, slug, name, icon, trigger_value
    FROM badges
    WHERE trigger_type = 'lesson_complete'
  LOOP
    IF (v_badge.trigger_value->>'count') IS NOT NULL THEN
      IF v_completed_count < (v_badge.trigger_value->>'count')::INTEGER THEN
        CONTINUE;
      END IF;
    ELSIF (v_badge.trigger_value->>'lesson_slug') IS NOT NULL THEN
      IF v_badge.trigger_value->>'lesson_slug' <> v_lesson.slug THEN
        CONTINUE;
      END IF;
    ELSE
      CONTINUE;
    END IF;

    INSERT INTO user_badges (user_id, badge_id)
    VALUES (p_user_id, v_badge.id)
    ON CONFLICT (user_id, badge_id) DO NOTHING;

    IF FOUND THEN
      v_badges := v_badges || jsonb_build_object(
        'slug', v_badge.slug,
        'name', v_badge.name,
        'icon', v_badge.icon
      );
    END IF;
  END LOOP;

  SELECT slug INTO v_next_lesson_slug
  FROM lessons
  WHERE lesson_number > v_lesson.lesson_number AND is_published = TRUE
  ORDER BY lesson_number ASC
  LIMIT 1;

  v_result := jsonb_build_object(
    'xp_earned', v_total_xp,
    'lesson_xp', v_xp,
    'quiz_bonus', CASE WHEN p_quiz_correct THEN 10 ELSE 0 END,
    'streak_days', v_new_streak,
    'streak_status', v_streak_status,
    'badges_earned', v_badges,
    'next_lesson_slug', v_next_lesson_slug
  );

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) TO authenticated, anon;

-- Update execute_trade to award Koin Points on first trade.
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
