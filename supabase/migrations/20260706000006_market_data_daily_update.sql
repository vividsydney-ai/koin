-- Migration 024: Market data seed expansion and daily price update architecture
-- Adds more historical seed rows and a helper to generate the next trading day's prices.

-- Insert additional historical seed data for the 5 MVP symbols.
-- Uses CURRENT_DATE so the latest rows are always recent for fresh installs.
INSERT INTO market_data (symbol, company_name, trade_date, open_price, high_price, low_price, close_price, volume, source_url) VALUES
('BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '5 days', 8350.00, 8500.00, 8300.00, 8450.00, 42000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '4 days', 8450.00, 8620.00, 8400.00, 8550.00, 45000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '2 days', 8550.00, 8720.00, 8500.00, 8650.00, 48000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '5 days', 4020.00, 4150.00, 4000.00, 4100.00, 60000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 4120.00, 4190.00, 4080.00, 4150.00, 62000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '2 days', 4160.00, 4250.00, 4130.00, 4200.00, 58000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '5 days', 3600.00, 3720.00, 3580.00, 3680.00, 34000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 3680.00, 3750.00, 3650.00, 3720.00, 35000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '2 days', 3730.00, 3780.00, 3700.00, 3750.00, 33000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '5 days', 98.00, 106.00, 96.00, 102.00, 1100000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '4 days', 102.00, 108.00, 100.00, 105.00, 1200000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '2 days', 106.00, 112.00, 104.00, 110.00, 1350000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '5 days', 6350.00, 6480.00, 6300.00, 6420.00, 17000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 6450.00, 6520.00, 6400.00, 6480.00, 18000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
('UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '2 days', 6500.00, 6580.00, 6450.00, 6550.00, 19000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/');

-- Helper function to generate the next trading day's market data.
-- In production this would be replaced by a real data feed; for the MVP it
-- simulates realistic daily price movement around the previous close.
CREATE OR REPLACE FUNCTION seed_next_market_data(
  p_trade_date DATE DEFAULT CURRENT_DATE
) RETURNS TABLE(symbol TEXT, close_price NUMERIC(12,2))
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_latest RECORD;
  v_change_pct NUMERIC(5,4);
  v_new_close NUMERIC(12,2);
  v_new_open NUMERIC(12,2);
  v_new_high NUMERIC(12,2);
  v_new_low NUMERIC(12,2);
BEGIN
  FOR v_latest IN
    SELECT DISTINCT ON (m.symbol)
      m.symbol,
      m.company_name,
      m.close_price,
      m.volume
    FROM market_data m
    ORDER BY m.symbol, m.trade_date DESC
  LOOP
    -- Skip if we already have data for this date.
    IF EXISTS (SELECT 1 FROM market_data WHERE market_data.symbol = v_latest.symbol AND market_data.trade_date = p_trade_date) THEN
      CONTINUE;
    END IF;

    -- Random daily change between -3% and +3% using a deterministic-ish seed.
    v_change_pct := ((random() * 0.06) - 0.03);
    v_new_close := ROUND(v_latest.close_price * (1 + v_change_pct));
    v_new_open := ROUND(v_latest.close_price * (1 + ((random() * 0.02) - 0.01)));
    v_new_high := GREATEST(v_new_open, v_new_close) * (1 + (random() * 0.01));
    v_new_low := LEAST(v_new_open, v_new_close) * (1 - (random() * 0.01));

    INSERT INTO market_data (symbol, company_name, trade_date, open_price, high_price, low_price, close_price, volume, source_url)
    VALUES (
      v_latest.symbol,
      v_latest.company_name,
      p_trade_date,
      v_new_open,
      ROUND(v_new_high),
      ROUND(v_new_low),
      v_new_close,
      v_latest.volume,
      'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'
    );

    symbol := v_latest.symbol;
    close_price := v_new_close;
    RETURN NEXT;
  END LOOP;
END;
$$;

GRANT EXECUTE ON FUNCTION seed_next_market_data(DATE) TO authenticated, anon;
