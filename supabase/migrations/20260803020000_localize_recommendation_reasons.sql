-- KO-275: recommendation reasons are user-facing content, so retain both
-- locales instead of rendering Indonesian text in the English interface.

ALTER TABLE public.user_lesson_recommendations
  ADD COLUMN IF NOT EXISTS reason_id TEXT;

UPDATE public.user_lesson_recommendations
SET reason_id = CASE reason
  WHEN 'Pelajaran pengayaan berdasarkan hasil asesmen awal.'
    THEN 'An enrichment lesson based on your onboarding assessment.'
  WHEN 'Kamu baru-baru ini menjual saham dalam waktu singkat dengan kerugian. Pelajari bagaimana aversi rugi dan FOMO memengaruhi keputusan.'
    THEN 'You recently sold a stock at a loss after holding it for a short time. Learn how loss aversion and FOMO can influence decisions.'
  WHEN 'Portofoliomu terlalu terkonsentrasi pada satu saham. Diversifikasi bisa mengurangi risiko.'
    THEN 'Your portfolio is too concentrated in one stock. Diversification can reduce risk.'
  WHEN 'Sudah lama tidak bertransaksi? Yuk evaluasi kembali profil risiko dan kepercayaan dirimu.'
    THEN 'It has been a while since you traded. Revisit your risk profile and confidence before your next decision.'
  WHEN 'Portofoliomu turun lebih dari batas. Pelajari cara mengendalikan emosi saat volatilitas meningkat.'
    THEN 'Your portfolio has fallen past your limit. Learn how to manage emotions when volatility rises.'
  ELSE reason_id
END
WHERE reason_id IS NULL;

CREATE OR REPLACE FUNCTION public.evaluate_adaptive_triggers(p_user_id UUID)
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
    SELECT EXISTS (
      SELECT 1 FROM lesson_progress
      WHERE user_id = p_user_id
        AND lesson_id = v_trigger.lesson_id
        AND status = 'completed'
    ) INTO v_completed;

    IF v_completed THEN CONTINUE; END IF;

    SELECT COUNT(*) INTO v_count
    FROM user_lesson_recommendations
    WHERE user_id = p_user_id AND trigger_id = v_trigger.id;

    IF v_count >= v_trigger.max_times_triggered THEN CONTINUE; END IF;

    IF v_trigger.trigger_type = 'trade_behavior' AND v_trigger.condition_json->>'event' = 'panic_sell' THEN
      v_max_hold_days := COALESCE((v_trigger.condition_json->>'max_hold_days')::INTEGER, 7);
      v_loss_threshold_pct := COALESCE((v_trigger.condition_json->>'loss_threshold_pct')::NUMERIC, 5);
      IF EXISTS (
        SELECT 1 FROM trades t_sell JOIN portfolios p ON p.id = t_sell.portfolio_id
        WHERE p.user_id = p_user_id AND t_sell.trade_type = 'sell'
          AND t_sell.created_at >= NOW() - (v_max_hold_days || ' days')::INTERVAL
          AND EXISTS (
            SELECT 1 FROM trades t_buy
            WHERE t_buy.portfolio_id = t_sell.portfolio_id AND t_buy.symbol = t_sell.symbol
              AND t_buy.trade_type = 'buy' AND t_buy.created_at < t_sell.created_at
              AND t_buy.created_at >= t_sell.created_at - (v_max_hold_days || ' days')::INTERVAL
              AND t_sell.price <= t_buy.price * (1 - v_loss_threshold_pct / 100)
          )
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, reason_id, dismissed)
        VALUES (p_user_id, v_trigger.lesson_id, v_trigger.id,
          'Kamu baru-baru ini menjual saham dalam waktu singkat dengan kerugian. Pelajari bagaimana aversi rugi dan FOMO memengaruhi keputusan.',
          'You recently sold a stock at a loss after holding it for a short time. Learn how loss aversion and FOMO can influence decisions.', FALSE)
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;
    ELSIF v_trigger.trigger_type = 'portfolio_event' AND v_trigger.condition_json->>'event' = 'concentrated_holding' THEN
      v_threshold_pct := COALESCE((v_trigger.condition_json->>'threshold_pct')::NUMERIC, 50);
      IF EXISTS (
        SELECT 1 FROM holdings h JOIN portfolios p ON p.id = h.portfolio_id
        WHERE p.user_id = p_user_id AND p.total_value > 0
          AND (h.shares * COALESCE(h.current_price, 0)) > p.total_value * (v_threshold_pct / 100)
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, reason_id, dismissed)
        VALUES (p_user_id, v_trigger.lesson_id, v_trigger.id,
          'Portofoliomu terlalu terkonsentrasi pada satu saham. Diversifikasi bisa mengurangi risiko.',
          'Your portfolio is too concentrated in one stock. Diversification can reduce risk.', FALSE)
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;
    ELSIF v_trigger.trigger_type = 'inactivity' AND v_trigger.condition_json->>'event' = 'no_trade' THEN
      v_days := COALESCE((v_trigger.condition_json->>'days')::INTEGER, 14);
      IF EXISTS (
        SELECT 1 FROM portfolios p
        WHERE p.user_id = p_user_id AND EXISTS (SELECT 1 FROM trades t WHERE t.portfolio_id = p.id)
          AND NOT EXISTS (SELECT 1 FROM trades t WHERE t.portfolio_id = p.id AND t.created_at >= NOW() - (v_days || ' days')::INTERVAL)
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, reason_id, dismissed)
        VALUES (p_user_id, v_trigger.lesson_id, v_trigger.id,
          'Sudah lama tidak bertransaksi? Yuk evaluasi kembali profil risiko dan kepercayaan dirimu.',
          'It has been a while since you traded. Revisit your risk profile and confidence before your next decision.', FALSE)
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;
    ELSIF v_trigger.trigger_type = 'portfolio_event' AND v_trigger.condition_json->>'event' = 'drawdown' THEN
      v_threshold_pct := COALESCE((v_trigger.condition_json->>'threshold_pct')::NUMERIC, 10);
      IF EXISTS (
        SELECT 1 FROM portfolios p
        WHERE p.user_id = p_user_id AND p.total_value < p.starting_cash * (1 - v_threshold_pct / 100)
      ) THEN
        INSERT INTO user_lesson_recommendations (user_id, lesson_id, trigger_id, reason, reason_id, dismissed)
        VALUES (p_user_id, v_trigger.lesson_id, v_trigger.id,
          'Portofoliomu turun lebih dari batas. Pelajari cara mengendalikan emosi saat volatilitas meningkat.',
          'Your portfolio has fallen past your limit. Learn how to manage emotions when volatility rises.', FALSE)
        ON CONFLICT (user_id, lesson_id) DO NOTHING;
      END IF;
    END IF;
  END LOOP;
END;
$$;

GRANT EXECUTE ON FUNCTION public.evaluate_adaptive_triggers(UUID) TO authenticated;
