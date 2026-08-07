-- KO-281: expand the Paper Trading learning universe with liquid IDX names.
-- Catalogue references:
--   https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume
--   https://www.idx.co.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list
--
-- The starter prices below are deliberately simulated. They give a newly
-- listed catalogue symbol two visible EOD points until the server-side IDX
-- ingestion replaces them with official delayed closes. The UI labels them
-- accordingly; no simulated row is presented as an IDX quote.

BEGIN;

INSERT INTO instruments (symbol, name, instrument_type, source_url)
VALUES
  ('ADRO', 'Alamtri Resources Indonesia Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('AKRA', 'AKR Corporindo Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('AMMN', 'Amman Mineral Internasional Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('ANTM', 'Aneka Tambang Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('ASII', 'Astra International Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('BRIS', 'Bank Syariah Indonesia Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('BUMI', 'Bumi Resources Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('BRMS', 'Bumi Resources Minerals Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('CPIN', 'Charoen Pokphand Indonesia Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('MDKA', 'Merdeka Copper Gold Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('PGAS', 'Perusahaan Gas Negara Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('PTBA', 'Bukit Asam Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('PANI', 'Pantai Indah Kapuk Dua Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('TINS', 'Timah Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('WIFI', 'Solusi Sinergi Digital Tbk', 'stock', 'https://www.idx.co.id/en/market-data/statistical-reports/digital-statistic/monthly/biggest-market-capitalization-most-active-stocks/most-active-stocks-by-total-trading-volume'),
  ('XBES', 'BNI-AM ETF MSCI ESG Leaders Indonesia', 'etf', 'https://www.idx.co.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list'),
  ('XBLQ', 'Batavia Smart Liquid ETF', 'etf', 'https://www.idx.co.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list'),
  ('XISI', 'Premier ETF SMinfra18', 'etf', 'https://www.idx.co.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list'),
  ('XMLF', 'Mandiri ETF LQ45', 'etf', 'https://www.idx.co.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list'),
  ('XPIN', 'Bahana ETF Pefindo I-Grade', 'etf', 'https://www.idx.co.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list')
ON CONFLICT (symbol) DO UPDATE
SET name = EXCLUDED.name,
    instrument_type = EXCLUDED.instrument_type,
    source_url = EXCLUDED.source_url,
    is_active = TRUE,
    updated_at = NOW();

INSERT INTO market_data (
  symbol,
  company_name,
  trade_date,
  close_price,
  volume,
  source_url,
  is_simulated
)
VALUES
  ('ADRO', 'Alamtri Resources Indonesia Tbk', CURRENT_DATE - 2, 2050, 0, 'simulated-catalogue-seed', TRUE),
  ('ADRO', 'Alamtri Resources Indonesia Tbk', CURRENT_DATE - 1, 2100, 0, 'simulated-catalogue-seed', TRUE),
  ('AKRA', 'AKR Corporindo Tbk', CURRENT_DATE - 2, 1375, 0, 'simulated-catalogue-seed', TRUE),
  ('AKRA', 'AKR Corporindo Tbk', CURRENT_DATE - 1, 1390, 0, 'simulated-catalogue-seed', TRUE),
  ('AMMN', 'Amman Mineral Internasional Tbk', CURRENT_DATE - 2, 6300, 0, 'simulated-catalogue-seed', TRUE),
  ('AMMN', 'Amman Mineral Internasional Tbk', CURRENT_DATE - 1, 6200, 0, 'simulated-catalogue-seed', TRUE),
  ('ANTM', 'Aneka Tambang Tbk', CURRENT_DATE - 2, 3020, 0, 'simulated-catalogue-seed', TRUE),
  ('ANTM', 'Aneka Tambang Tbk', CURRENT_DATE - 1, 3070, 0, 'simulated-catalogue-seed', TRUE),
  ('ASII', 'Astra International Tbk', CURRENT_DATE - 2, 4650, 0, 'simulated-catalogue-seed', TRUE),
  ('ASII', 'Astra International Tbk', CURRENT_DATE - 1, 4700, 0, 'simulated-catalogue-seed', TRUE),
  ('BRIS', 'Bank Syariah Indonesia Tbk', CURRENT_DATE - 2, 2640, 0, 'simulated-catalogue-seed', TRUE),
  ('BRIS', 'Bank Syariah Indonesia Tbk', CURRENT_DATE - 1, 2590, 0, 'simulated-catalogue-seed', TRUE),
  ('BUMI', 'Bumi Resources Tbk', CURRENT_DATE - 2, 130, 0, 'simulated-catalogue-seed', TRUE),
  ('BUMI', 'Bumi Resources Tbk', CURRENT_DATE - 1, 134, 0, 'simulated-catalogue-seed', TRUE),
  ('BRMS', 'Bumi Resources Minerals Tbk', CURRENT_DATE - 2, 400, 0, 'simulated-catalogue-seed', TRUE),
  ('BRMS', 'Bumi Resources Minerals Tbk', CURRENT_DATE - 1, 392, 0, 'simulated-catalogue-seed', TRUE),
  ('CPIN', 'Charoen Pokphand Indonesia Tbk', CURRENT_DATE - 2, 5150, 0, 'simulated-catalogue-seed', TRUE),
  ('CPIN', 'Charoen Pokphand Indonesia Tbk', CURRENT_DATE - 1, 5200, 0, 'simulated-catalogue-seed', TRUE),
  ('MDKA', 'Merdeka Copper Gold Tbk', CURRENT_DATE - 2, 2200, 0, 'simulated-catalogue-seed', TRUE),
  ('MDKA', 'Merdeka Copper Gold Tbk', CURRENT_DATE - 1, 2250, 0, 'simulated-catalogue-seed', TRUE),
  ('PGAS', 'Perusahaan Gas Negara Tbk', CURRENT_DATE - 2, 1600, 0, 'simulated-catalogue-seed', TRUE),
  ('PGAS', 'Perusahaan Gas Negara Tbk', CURRENT_DATE - 1, 1575, 0, 'simulated-catalogue-seed', TRUE),
  ('PTBA', 'Bukit Asam Tbk', CURRENT_DATE - 2, 2950, 0, 'simulated-catalogue-seed', TRUE),
  ('PTBA', 'Bukit Asam Tbk', CURRENT_DATE - 1, 3000, 0, 'simulated-catalogue-seed', TRUE),
  ('PANI', 'Pantai Indah Kapuk Dua Tbk', CURRENT_DATE - 2, 15400, 0, 'simulated-catalogue-seed', TRUE),
  ('PANI', 'Pantai Indah Kapuk Dua Tbk', CURRENT_DATE - 1, 15100, 0, 'simulated-catalogue-seed', TRUE),
  ('TINS', 'Timah Tbk', CURRENT_DATE - 2, 1480, 0, 'simulated-catalogue-seed', TRUE),
  ('TINS', 'Timah Tbk', CURRENT_DATE - 1, 1530, 0, 'simulated-catalogue-seed', TRUE),
  ('WIFI', 'Solusi Sinergi Digital Tbk', CURRENT_DATE - 2, 2900, 0, 'simulated-catalogue-seed', TRUE),
  ('WIFI', 'Solusi Sinergi Digital Tbk', CURRENT_DATE - 1, 2950, 0, 'simulated-catalogue-seed', TRUE),
  ('XBES', 'BNI-AM ETF MSCI ESG Leaders Indonesia', CURRENT_DATE - 2, 550, 0, 'simulated-catalogue-seed', TRUE),
  ('XBES', 'BNI-AM ETF MSCI ESG Leaders Indonesia', CURRENT_DATE - 1, 558, 0, 'simulated-catalogue-seed', TRUE),
  ('XBLQ', 'Batavia Smart Liquid ETF', CURRENT_DATE - 2, 490, 0, 'simulated-catalogue-seed', TRUE),
  ('XBLQ', 'Batavia Smart Liquid ETF', CURRENT_DATE - 1, 489, 0, 'simulated-catalogue-seed', TRUE),
  ('XISI', 'Premier ETF SMinfra18', CURRENT_DATE - 2, 344, 0, 'simulated-catalogue-seed', TRUE),
  ('XISI', 'Premier ETF SMinfra18', CURRENT_DATE - 1, 339, 0, 'simulated-catalogue-seed', TRUE),
  ('XMLF', 'Mandiri ETF LQ45', CURRENT_DATE - 2, 880, 0, 'simulated-catalogue-seed', TRUE),
  ('XMLF', 'Mandiri ETF LQ45', CURRENT_DATE - 1, 876, 0, 'simulated-catalogue-seed', TRUE),
  ('XPIN', 'Bahana ETF Pefindo I-Grade', CURRENT_DATE - 2, 570, 0, 'simulated-catalogue-seed', TRUE),
  ('XPIN', 'Bahana ETF Pefindo I-Grade', CURRENT_DATE - 1, 568, 0, 'simulated-catalogue-seed', TRUE)
ON CONFLICT (symbol, trade_date) DO NOTHING;

COMMIT;
