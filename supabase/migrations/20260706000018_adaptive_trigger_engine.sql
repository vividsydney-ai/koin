-- Migration: Adaptive lesson trigger engine
-- Inserts trigger rules for the 4 behavioral lessons and creates functions/triggers
-- that generate user_lesson_recommendations based on trading behavior.

-- 1. Trigger rules (idempotent: only insert if no active trigger exists for the lesson)
INSERT INTO lesson_triggers (id, lesson_id, trigger_type, condition_json, priority, max_times_triggered, is_active)
SELECT gen_random_uuid(), l.id, 'trade_behavior', '{"event":"panic_sell","max_hold_days":7,"loss_threshold_pct":5}'::jsonb, 1, 1, TRUE
FROM lessons l
WHERE l.slug = 'loss-aversion-101'
  AND NOT EXISTS (SELECT 1 FROM lesson_triggers WHERE lesson_id = l.id);

INSERT INTO lesson_triggers (id, lesson_id, trigger_type, condition_json, priority, max_times_triggered, is_active)
SELECT gen_random_uuid(), l.id, 'portfolio_event', '{"event":"concentrated_holding","threshold_pct":50}'::jsonb, 2, 1, TRUE
FROM lessons l
WHERE l.slug = 'diversification-101'
  AND NOT EXISTS (SELECT 1 FROM lesson_triggers WHERE lesson_id = l.id);

INSERT INTO lesson_triggers (id, lesson_id, trigger_type, condition_json, priority, max_times_triggered, is_active)
SELECT gen_random_uuid(), l.id, 'inactivity', '{"event":"no_trade","days":14}'::jsonb, 3, 1, TRUE
FROM lessons l
WHERE l.slug = 'confidence-101'
  AND NOT EXISTS (SELECT 1 FROM lesson_triggers WHERE lesson_id = l.id);

INSERT INTO lesson_triggers (id, lesson_id, trigger_type, condition_json, priority, max_times_triggered, is_active)
SELECT gen_random_uuid(), l.id, 'portfolio_event', '{"event":"drawdown","threshold_pct":10}'::jsonb, 4, 1, TRUE
FROM lessons l
WHERE l.slug = 'volatility-101'
  AND NOT EXISTS (SELECT 1 FROM lesson_triggers WHERE lesson_id = l.id);

-- 2. Core evaluation function (internal, called by trigger and RPC wrapper)
CREATE OR REPLACE FUNCTION evaluate_adaptive_triggers(p_user_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_trigger RECORD;
  v_count INTEGER;
  v_completed BOOLEAN;
  v_threshold_pct NUMERIC;
  v_days INTEGER;
  v_max_hold_days INTEGER;
  v_loss_threshold_pct NUMERIC;
BEGIN
  FOR v_trigger IN
    SELECT *
    FROM lesson_triggers
    WHERE is_active = TRUE
    ORDER BY priority ASC, created_at ASC
  LOOP
    -- Skip if the user already completed the target lesson.
    SELECT EXISTS (
      SELECT 1 FROM lesson_progress
      WHERE user_id = p_user_id
        AND lesson_id = v_trigger.lesson_id
        AND status = 'completed'
    ) INTO v_completed;

    IF v_completed THEN
      CONTINUE;
    END IF;

    -- Skip if max times triggered already reached for this user + trigger.
    SELECT COUNT(*) INTO v_count
    FROM user_lesson_recommendations
    WHERE user_id = p_user_id AND trigger_id = v_trigger.id;

    IF v_count >= v_trigger.max_times_triggered THEN
      CONTINUE;
    END IF;

    IF v_trigger.trigger_type = 'trade_behavior' AND v_trigger.condition_json->>'event' = 'panic_sell' THEN
      v_max_hold_days := COALESCE((v_trigger.condition_json->>'max_hold_days')::INTEGER, 7);
      v_loss_threshold_pct := COALESCE((v_trigger.condition_json->>'loss_threshold_pct')::NUMERIC, 5);

      IF EXISTS (
        SELECT 1
        FROM trades t_sell
        JOIN portfolios p ON p.id = t_sell.portfolio_id
        WHERE p.user_id = p_user_id
          AND t_sell.trade_type = 'sell'
          AND t_sell.created_at >= NOW() - (v_max_hold_days || ' days')::INTERVAL
          AND EXISTS (
            SELECT 1
            FROM trades t_buy
            WHERE t_buy.portfolio_id = t_sell.portfolio_id
              AND t_buy.symbol = t_sell.symbol
              AND t_buy.trade_type = 'buy'
              AND t_buy.created_at < t_sell.created_at
              AND t_buy.created_at >= t_sell.created_at - (v_max_hold_days || ' days')::INTERVAL
              AND t_sell.price <= t_buy.price * (1 - v_loss_threshold_pct / 100)
          )
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, dismissed)
        VALUES (
          p_user_id,
          v_trigger.lesson_id,
          v_trigger.id,
          'Kamu baru-baru ini menjual saham dalam waktu singkat dengan kerugian. Pelajari bagaimana aversi rugi dan FOMO memengaruhi keputusan.',
          FALSE
        )
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;

    ELSIF v_trigger.trigger_type = 'portfolio_event' AND v_trigger.condition_json->>'event' = 'concentrated_holding' THEN
      v_threshold_pct := COALESCE((v_trigger.condition_json->>'threshold_pct')::NUMERIC, 50);

      IF EXISTS (
        SELECT 1
        FROM holdings h
        JOIN portfolios p ON p.id = h.portfolio_id
        WHERE p.user_id = p_user_id
          AND p.total_value > 0
          AND (h.shares * COALESCE(h.current_price, 0)) > p.total_value * (v_threshold_pct / 100)
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, dismissed)
        VALUES (
          p_user_id,
          v_trigger.lesson_id,
          v_trigger.id,
          'Portofoliomu terlalu terkonsentrasi pada satu saham. Diversifikasi bisa mengurangi risiko.',
          FALSE
        )
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;

    ELSIF v_trigger.trigger_type = 'inactivity' AND v_trigger.condition_json->>'event' = 'no_trade' THEN
      v_days := COALESCE((v_trigger.condition_json->>'days')::INTEGER, 14);

      IF EXISTS (
        SELECT 1
        FROM portfolios p
        WHERE p.user_id = p_user_id
          AND EXISTS (SELECT 1 FROM trades t WHERE t.portfolio_id = p.id)
          AND NOT EXISTS (
            SELECT 1 FROM trades t
            WHERE t.portfolio_id = p.id
              AND t.created_at >= NOW() - (v_days || ' days')::INTERVAL
          )
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, dismissed)
        VALUES (
          p_user_id,
          v_trigger.lesson_id,
          v_trigger.id,
          'Sudah lama tidak bertransaksi? Yuk evaluasi kembali profil risiko dan kepercayaan dirimu.',
          FALSE
        )
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;

    ELSIF v_trigger.trigger_type = 'portfolio_event' AND v_trigger.condition_json->>'event' = 'drawdown' THEN
      v_threshold_pct := COALESCE((v_trigger.condition_json->>'threshold_pct')::NUMERIC, 10);

      IF EXISTS (
        SELECT 1
        FROM portfolios p
        WHERE p.user_id = p_user_id
          AND p.total_value < p.starting_cash * (1 - v_threshold_pct / 100)
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, dismissed)
        VALUES (
          p_user_id,
          v_trigger.lesson_id,
          v_trigger.id,
          'Portofoliomu turun lebih dari batas. Pelajari cara mengendalikan emosi saat volatilitas meningkat.',
          FALSE
        )
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;
    END IF;
  END LOOP;
END;
$$;

-- 3. RPC wrapper with auth guard for client calls (Home page inactivity/drawdown checks)
CREATE OR REPLACE FUNCTION check_adaptive_triggers()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'Not authenticated' USING ERRCODE = 'insufficient_privilege';
  END IF;

  PERFORM evaluate_adaptive_triggers(auth.uid());
END;
$$;

GRANT EXECUTE ON FUNCTION check_adaptive_triggers() TO authenticated;

-- 4. After-insert trigger on trades to evaluate trade_behavior triggers immediately
CREATE OR REPLACE FUNCTION trg_evaluate_adaptive_triggers_after_trade()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_user_id UUID;
BEGIN
  SELECT user_id INTO v_user_id
  FROM portfolios
  WHERE id = NEW.portfolio_id;

  IF v_user_id IS NOT NULL THEN
    PERFORM evaluate_adaptive_triggers(v_user_id);
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS evaluate_adaptive_triggers_after_trade ON trades;
CREATE TRIGGER evaluate_adaptive_triggers_after_trade
  AFTER INSERT ON trades
  FOR EACH ROW
  EXECUTE FUNCTION trg_evaluate_adaptive_triggers_after_trade();
