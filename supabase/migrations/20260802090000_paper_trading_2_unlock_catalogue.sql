-- KO-257 / KO-259 / KO-260: server-authoritative paper trading unlock and IDX catalogue.
-- The portfolio grant is deliberately kept behind one idempotent RPC.

BEGIN;

ALTER TABLE portfolios
  ADD COLUMN IF NOT EXISTS chest_viewed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS unlock_claimed_at TIMESTAMPTZ;

ALTER TABLE user_settings
  ADD COLUMN IF NOT EXISTS paper_chest_viewed_at TIMESTAMPTZ;

CREATE TABLE IF NOT EXISTS instruments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  instrument_type TEXT NOT NULL CHECK (instrument_type IN ('stock', 'etf')),
  exchange TEXT NOT NULL DEFAULT 'IDX',
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  lot_size INTEGER NOT NULL DEFAULT 100 CHECK (lot_size > 0),
  source_url TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_instruments_active_type_symbol
  ON instruments (is_active, instrument_type, symbol);

ALTER TABLE instruments ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Authenticated users can read active instruments" ON instruments;
CREATE POLICY "Authenticated users can read active instruments"
  ON instruments FOR SELECT TO authenticated
  USING (is_active = TRUE);

INSERT INTO instruments (symbol, name, instrument_type, source_url)
VALUES
  ('BBCA', 'Bank Central Asia Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('BBNI', 'Bank Negara Indonesia (Persero) Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('BBRI', 'Bank Rakyat Indonesia (Persero) Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('BMRI', 'Bank Mandiri (Persero) Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('GOTO', 'GoTo Gojek Tokopedia Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('ICBP', 'Indofood CBP Sukses Makmur Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('INDF', 'Indofood Sukses Makmur Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('TLKM', 'Telkom Indonesia (Persero) Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('UNVR', 'Unilever Indonesia Tbk', 'stock', 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/'),
  ('XISR', 'Reksa Dana Indeks Syariah Indonesia ETF', 'etf', 'https://www.idx.co.id/id/data-pasar/data-exchange-traded-fund-etf/daftar-exchange-traded-fund-etf/'),
  ('XIIT', 'Premier ETF Indonesia Financial', 'etf', 'https://www.idx.co.id/id/data-pasar/data-exchange-traded-fund-etf/daftar-exchange-traded-fund-etf/'),
  ('XISC', 'Premier ETF Indonesia Consumer', 'etf', 'https://www.idx.co.id/id/data-pasar/data-exchange-traded-fund-etf/daftar-exchange-traded-fund-etf/')
ON CONFLICT (symbol) DO UPDATE
SET name = EXCLUDED.name,
    instrument_type = EXCLUDED.instrument_type,
    source_url = EXCLUDED.source_url,
    updated_at = NOW();

-- Keep the learning MVP usable before the first cron ingestion. These are
-- clearly simulated seed closes; the ingestion job replaces them with IDX
-- EOD rows when official data is available.
INSERT INTO market_data (symbol, company_name, trade_date, close_price, volume, source_url, is_simulated)
VALUES
  ('BBNI', 'Bank Negara Indonesia (Persero) Tbk', CURRENT_DATE - 1, 5150, 0, 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/', TRUE),
  ('BMRI', 'Bank Mandiri (Persero) Tbk', CURRENT_DATE - 1, 5600, 0, 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/', TRUE),
  ('ICBP', 'Indofood CBP Sukses Makmur Tbk', CURRENT_DATE - 1, 11200, 0, 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/', TRUE),
  ('INDF', 'Indofood Sukses Makmur Tbk', CURRENT_DATE - 1, 7350, 0, 'https://www.idx.co.id/id/data-pasar/data-saham/daftar-saham/', TRUE),
  ('XISR', 'Reksa Dana Indeks Syariah Indonesia ETF', CURRENT_DATE - 1, 1020, 0, 'https://www.idx.co.id/id/data-pasar/data-exchange-traded-fund-etf/daftar-exchange-traded-fund-etf/', TRUE),
  ('XIIT', 'Premier ETF Indonesia Financial', CURRENT_DATE - 1, 1220, 0, 'https://www.idx.co.id/id/data-pasar/data-exchange-traded-fund-etf/daftar-exchange-traded-fund-etf/', TRUE),
  ('XISC', 'Premier ETF Indonesia Consumer', CURRENT_DATE - 1, 1080, 0, 'https://www.idx.co.id/id/data-pasar/data-exchange-traded-fund-etf/daftar-exchange-traded-fund-etf/', TRUE)
ON CONFLICT (symbol, trade_date) DO NOTHING;

CREATE OR REPLACE FUNCTION mark_paper_chest_viewed(p_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  UPDATE user_settings
  SET paper_chest_viewed_at = COALESCE(paper_chest_viewed_at, NOW()), updated_at = NOW()
  WHERE user_id = p_user_id;

  UPDATE portfolios
  SET chest_viewed_at = COALESCE(chest_viewed_at, NOW()), updated_at = NOW()
  WHERE user_id = p_user_id;
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
  FROM lessons l
  JOIN topics t ON t.id = l.topic_id
  WHERE l.is_published = TRUE AND t.chapter = 'Investing in Indonesia';

  SELECT COUNT(DISTINCT lp.lesson_id) INTO v_completed_count
  FROM lesson_progress lp
  JOIN lessons l ON l.id = lp.lesson_id
  JOIN topics t ON t.id = l.topic_id
  WHERE lp.user_id = p_user_id
    AND lp.status = 'completed'
    AND l.is_published = TRUE
    AND t.chapter = 'Investing in Indonesia';

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
    -- Legacy portfolios are already authoritative; never overwrite their balance.
    UPDATE portfolios SET unlock_claimed_at = NOW(), updated_at = NOW()
    WHERE id = v_portfolio.id
    RETURNING * INTO v_portfolio;
  END IF;

  RETURN jsonb_build_object(
    'claimed', TRUE,
    'portfolio', jsonb_build_object(
      'id', v_portfolio.id,
      'user_id', v_portfolio.user_id,
      'starting_cash', v_portfolio.starting_cash,
      'cash_balance', v_portfolio.cash_balance,
      'total_value', v_portfolio.total_value,
      'status', v_portfolio.status,
      'created_at', v_portfolio.created_at,
      'updated_at', v_portfolio.updated_at,
      'unlock_claimed_at', v_portfolio.unlock_claimed_at
    )
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION claim_paper_portfolio(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION claim_paper_portfolio(UUID) TO authenticated;
REVOKE EXECUTE ON FUNCTION mark_paper_chest_viewed(UUID) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION mark_paper_chest_viewed(UUID) TO authenticated;

COMMIT;
