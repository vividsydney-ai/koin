-- KO-422: draft-only Season 1 authored source pack.
--
-- All numbers below are deterministic Koin simulation values. They are not
-- ingested, delayed, live, or replayed IDX prices. The historical calendar is
-- context only; the activation guard below requires a later release to rebase
-- this schedule before learner access may be enabled.

BEGIN;

CREATE OR REPLACE FUNCTION public.practice_market_reject_elapsed_season_availability()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.state IN ('preparing', 'active')
    AND OLD.state NOT IN ('preparing', 'active')
    AND EXISTS (
      SELECT 1
      FROM public.practice_market_sessions session
      WHERE session.season_id = NEW.id
        AND session.market_opens_at <= NOW()
    ) THEN
    RAISE EXCEPTION
      'Practice Market Season schedule is historical-context only; rebase all sessions before making it available';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS practice_market_season_reject_elapsed_availability
  ON public.practice_market_seasons;

CREATE TRIGGER practice_market_season_reject_elapsed_availability
  BEFORE UPDATE OF state ON public.practice_market_seasons
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_elapsed_season_availability();

INSERT INTO public.practice_market_seasons (
  slug,
  version,
  state,
  title,
  title_id,
  source_pack_id,
  source_pack_checksum,
  disclosure_version,
  enrollment_opens_at,
  enrollment_closes_at,
  rank_entry_closes_at,
  starting_cash
) VALUES (
  'season-1-price-pressure-calm-choices',
  1,
  'draft',
  'Price Pressure, Calm Choices',
  'Tekanan Harga, Pilihan Tenang',
  'koin-practice-market-season-1-2022-context-v1',
  '2a81c6dfd33972162aa4c3e69991af2256b1f17394cee469a6a2f09b8db978e6',
  'practice-market-s1-simulated-v1',
  TIMESTAMPTZ '2022-08-22 09:00:00+07',
  TIMESTAMPTZ '2022-08-28 23:59:00+07',
  TIMESTAMPTZ '2022-08-28 23:59:00+07',
  10000000.00
)
ON CONFLICT (slug) DO NOTHING;

DO $$
DECLARE
  v_season public.practice_market_seasons%ROWTYPE;
BEGIN
  SELECT * INTO v_season
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices';

  IF v_season.id IS NULL
    OR v_season.state <> 'draft'
    OR v_season.source_pack_id <> 'koin-practice-market-season-1-2022-context-v1'
    OR v_season.source_pack_checksum <> '2a81c6dfd33972162aa4c3e69991af2256b1f17394cee469a6a2f09b8db978e6'
    OR v_season.disclosure_version <> 'practice-market-s1-simulated-v1' THEN
    RAISE EXCEPTION 'KO-422 Season 1 seed conflicts with existing Season metadata';
  END IF;
END;
$$;

WITH season AS (
  SELECT id
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices'
), session_seed (
  session_number,
  market_opens_at,
  market_closes_at,
  planning_desk_opens_at
) AS (
  VALUES
    (1::SMALLINT, TIMESTAMPTZ '2022-08-29 09:00:00+07', TIMESTAMPTZ '2022-08-29 15:00:00+07', TIMESTAMPTZ '2022-08-29 16:15:00+07'),
    (2::SMALLINT, TIMESTAMPTZ '2022-08-30 09:00:00+07', TIMESTAMPTZ '2022-08-30 15:00:00+07', TIMESTAMPTZ '2022-08-30 16:15:00+07'),
    (3::SMALLINT, TIMESTAMPTZ '2022-08-31 09:00:00+07', TIMESTAMPTZ '2022-08-31 15:00:00+07', TIMESTAMPTZ '2022-08-31 16:15:00+07'),
    (4::SMALLINT, TIMESTAMPTZ '2022-09-01 09:00:00+07', TIMESTAMPTZ '2022-09-01 15:00:00+07', TIMESTAMPTZ '2022-09-01 16:15:00+07'),
    (5::SMALLINT, TIMESTAMPTZ '2022-09-02 09:00:00+07', TIMESTAMPTZ '2022-09-02 15:00:00+07', TIMESTAMPTZ '2022-09-02 16:15:00+07'),
    (6::SMALLINT, TIMESTAMPTZ '2022-09-05 09:00:00+07', TIMESTAMPTZ '2022-09-05 15:00:00+07', TIMESTAMPTZ '2022-09-05 16:15:00+07'),
    (7::SMALLINT, TIMESTAMPTZ '2022-09-06 09:00:00+07', TIMESTAMPTZ '2022-09-06 15:00:00+07', TIMESTAMPTZ '2022-09-06 16:15:00+07'),
    (8::SMALLINT, TIMESTAMPTZ '2022-09-07 09:00:00+07', TIMESTAMPTZ '2022-09-07 15:00:00+07', TIMESTAMPTZ '2022-09-07 16:15:00+07'),
    (9::SMALLINT, TIMESTAMPTZ '2022-09-08 09:00:00+07', TIMESTAMPTZ '2022-09-08 15:00:00+07', TIMESTAMPTZ '2022-09-08 16:15:00+07'),
    (10::SMALLINT, TIMESTAMPTZ '2022-09-09 09:00:00+07', TIMESTAMPTZ '2022-09-09 15:00:00+07', TIMESTAMPTZ '2022-09-09 16:15:00+07')
)
INSERT INTO public.practice_market_sessions (
  season_id,
  session_number,
  market_opens_at,
  market_closes_at,
  planning_desk_opens_at,
  state
)
SELECT season.id, session_seed.session_number, session_seed.market_opens_at,
  session_seed.market_closes_at, session_seed.planning_desk_opens_at, 'scheduled'
FROM season
CROSS JOIN session_seed
ON CONFLICT (season_id, session_number) DO NOTHING;

WITH season AS (
  SELECT id
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices'
), roster (
  ticker,
  issuer_name,
  sector,
  listing_date,
  listing_eligibility_reference,
  source_pack_reference
) AS (
  VALUES
    ('ACES', 'Aspirasi Hidup Indonesia Tbk', 'Consumer / home-improvement retail', DATE '2007-11-06', 'S1-IDX-LISTING-2022-08-26/ACES', 'S1-IDX-LISTING-2022-08-26/ACES'),
    ('ADRO', 'Alamtri Resources Indonesia Tbk', 'Energy / coal', DATE '2008-07-16', 'S1-IDX-LISTING-2022-08-26/ADRO', 'S1-IDX-LISTING-2022-08-26/ADRO'),
    ('AKRA', 'AKR Corporindo Tbk', 'Energy / distribution and logistics', DATE '1994-10-03', 'S1-IDX-LISTING-2022-08-26/AKRA', 'S1-IDX-LISTING-2022-08-26/AKRA'),
    ('ANTM', 'Aneka Tambang Tbk', 'Mining / metals', DATE '1997-11-27', 'S1-IDX-LISTING-2022-08-26/ANTM', 'S1-IDX-LISTING-2022-08-26/ANTM'),
    ('ASII', 'Astra International Tbk', 'Industrial / mobility conglomerate', DATE '1990-04-04', 'S1-IDX-LISTING-2022-08-26/ASII', 'S1-IDX-LISTING-2022-08-26/ASII'),
    ('BBCA', 'Bank Central Asia Tbk', 'Financials / private banking', DATE '2000-05-31', 'S1-IDX-LISTING-2022-08-26/BBCA', 'S1-IDX-LISTING-2022-08-26/BBCA'),
    ('BBNI', 'Bank Negara Indonesia (Persero) Tbk', 'Financials / state-owned banking', DATE '1996-11-25', 'S1-IDX-LISTING-2022-08-26/BBNI', 'S1-IDX-LISTING-2022-08-26/BBNI'),
    ('BBRI', 'Bank Rakyat Indonesia (Persero) Tbk', 'Financials / banking inclusion', DATE '2003-11-10', 'S1-IDX-LISTING-2022-08-26/BBRI', 'S1-IDX-LISTING-2022-08-26/BBRI'),
    ('BMRI', 'Bank Mandiri (Persero) Tbk', 'Financials / state-owned banking', DATE '2003-07-14', 'S1-IDX-LISTING-2022-08-26/BMRI', 'S1-IDX-LISTING-2022-08-26/BMRI'),
    ('BRIS', 'Bank Syariah Indonesia Tbk', 'Financials / Islamic banking', DATE '2018-05-09', 'S1-IDX-LISTING-2022-08-26/BRIS', 'S1-IDX-LISTING-2022-08-26/BRIS'),
    ('BRMS', 'Bumi Resources Minerals Tbk', 'Mining / gold and minerals', DATE '2010-12-09', 'S1-IDX-LISTING-2022-08-26/BRMS', 'S1-IDX-LISTING-2022-08-26/BRMS'),
    ('BUMI', 'Bumi Resources Tbk', 'Energy / coal', DATE '1990-07-30', 'S1-IDX-LISTING-2022-08-26/BUMI', 'S1-IDX-LISTING-2022-08-26/BUMI'),
    ('CPIN', 'Charoen Pokphand Indonesia Tbk', 'Consumer / food and poultry', DATE '1991-03-18', 'S1-IDX-LISTING-2022-08-26/CPIN', 'S1-IDX-LISTING-2022-08-26/CPIN'),
    ('ERAA', 'Erajaya Swasembada Tbk', 'Consumer / electronics retail', DATE '2011-12-14', 'S1-IDX-LISTING-2022-08-26/ERAA', 'S1-IDX-LISTING-2022-08-26/ERAA'),
    ('EXCL', 'XL Axiata Tbk', 'Telecom / communications', DATE '2005-09-29', 'S1-IDX-LISTING-2022-08-26/EXCL', 'S1-IDX-LISTING-2022-08-26/EXCL'),
    ('GOTO', 'GoTo Gojek Tokopedia Tbk', 'Digital / platform economy', DATE '2022-04-11', 'S1-IDX-LISTING-2022-08-26/GOTO', 'S1-IDX-LISTING-2022-08-26/GOTO'),
    ('HMSP', 'Hanjaya Mandala Sampoerna Tbk', 'Consumer / goods', DATE '1990-08-15', 'S1-IDX-LISTING-2022-08-26/HMSP', 'S1-IDX-LISTING-2022-08-26/HMSP'),
    ('ICBP', 'Indofood CBP Sukses Makmur Tbk', 'Consumer / staples', DATE '2010-10-07', 'S1-IDX-LISTING-2022-08-26/ICBP', 'S1-IDX-LISTING-2022-08-26/ICBP'),
    ('INCO', 'Vale Indonesia Tbk', 'Mining / nickel', DATE '1990-05-16', 'S1-IDX-LISTING-2022-08-26/INCO', 'S1-IDX-LISTING-2022-08-26/INCO'),
    ('INDF', 'Indofood Sukses Makmur Tbk', 'Consumer / staples', DATE '1994-07-14', 'S1-IDX-LISTING-2022-08-26/INDF', 'S1-IDX-LISTING-2022-08-26/INDF'),
    ('ITMG', 'Indo Tambangraya Megah Tbk', 'Energy / coal', DATE '2007-12-18', 'S1-IDX-LISTING-2022-08-26/ITMG', 'S1-IDX-LISTING-2022-08-26/ITMG'),
    ('JPFA', 'Japfa Comfeed Indonesia Tbk', 'Consumer / food and poultry', DATE '1989-10-23', 'S1-IDX-LISTING-2022-08-26/JPFA', 'S1-IDX-LISTING-2022-08-26/JPFA'),
    ('KLBF', 'Kalbe Farma Tbk', 'Health / consumer health', DATE '1991-07-30', 'S1-IDX-LISTING-2022-08-26/KLBF', 'S1-IDX-LISTING-2022-08-26/KLBF'),
    ('MDKA', 'Merdeka Copper Gold Tbk', 'Mining / metals', DATE '2015-06-19', 'S1-IDX-LISTING-2022-08-26/MDKA', 'S1-IDX-LISTING-2022-08-26/MDKA'),
    ('MEDC', 'Medco Energi Internasional Tbk', 'Energy / oil and gas', DATE '1994-10-12', 'S1-IDX-LISTING-2022-08-26/MEDC', 'S1-IDX-LISTING-2022-08-26/MEDC'),
    ('PANI', 'Pantai Indah Kapuk Dua Tbk', 'Property', DATE '2018-09-18', 'S1-IDX-LISTING-2022-08-26/PANI', 'S1-IDX-LISTING-2022-08-26/PANI'),
    ('PGAS', 'Perusahaan Gas Negara Tbk', 'Energy / gas infrastructure', DATE '2003-12-15', 'S1-IDX-LISTING-2022-08-26/PGAS', 'S1-IDX-LISTING-2022-08-26/PGAS'),
    ('PTBA', 'Bukit Asam Tbk', 'Energy / coal', DATE '2002-12-23', 'S1-IDX-LISTING-2022-08-26/PTBA', 'S1-IDX-LISTING-2022-08-26/PTBA'),
    ('SMGR', 'Semen Indonesia (Persero) Tbk', 'Mining-materials / cement', DATE '1991-07-08', 'S1-IDX-LISTING-2022-08-26/SMGR', 'S1-IDX-LISTING-2022-08-26/SMGR'),
    ('TINS', 'Timah Tbk', 'Mining / tin', DATE '1995-10-19', 'S1-IDX-LISTING-2022-08-26/TINS', 'S1-IDX-LISTING-2022-08-26/TINS'),
    ('TLKM', 'Telkom Indonesia (Persero) Tbk', 'Telecom / communications', DATE '1995-11-14', 'S1-IDX-LISTING-2022-08-26/TLKM', 'S1-IDX-LISTING-2022-08-26/TLKM'),
    ('TOWR', 'Sarana Menara Nusantara Tbk', 'Telecom / tower infrastructure', DATE '2010-03-08', 'S1-IDX-LISTING-2022-08-26/TOWR', 'S1-IDX-LISTING-2022-08-26/TOWR'),
    ('UNVR', 'Unilever Indonesia Tbk', 'Consumer / staples', DATE '1982-01-11', 'S1-IDX-LISTING-2022-08-26/UNVR', 'S1-IDX-LISTING-2022-08-26/UNVR'),
    ('WIFI', 'Solusi Sinergi Digital Tbk', 'Telecom / network infrastructure', DATE '2020-12-30', 'S1-IDX-LISTING-2022-08-26/WIFI', 'S1-IDX-LISTING-2022-08-26/WIFI')
)
INSERT INTO public.practice_market_instruments (
  season_id,
  ticker,
  issuer_name,
  sector,
  listing_date,
  listing_eligibility_reference,
  source_pack_reference,
  lot_size,
  is_active
)
SELECT season.id, roster.ticker, roster.issuer_name, roster.sector,
  roster.listing_date, roster.listing_eligibility_reference,
  roster.source_pack_reference, 100, TRUE
FROM season
CROSS JOIN roster
ON CONFLICT (season_id, ticker) DO NOTHING;

WITH RECURSIVE season AS (
  SELECT id
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices'
), roster (ticker, anchor_price, sector_key, issuer_offset_bps) AS (
  VALUES
    ('ACES', 510::NUMERIC, 'consumer', -7), ('ADRO', 2940::NUMERIC, 'energy', 11),
    ('AKRA', 1370::NUMERIC, 'energy', -3), ('ANTM', 1920::NUMERIC, 'mining-materials', 9),
    ('ASII', 5640::NUMERIC, 'industrial-digital', 4), ('BBCA', 8170::NUMERIC, 'financials', 8),
    ('BBNI', 8940::NUMERIC, 'financials', -6), ('BBRI', 4430::NUMERIC, 'financials', 2),
    ('BMRI', 7710::NUMERIC, 'financials', 5), ('BRIS', 1760::NUMERIC, 'financials', -9),
    ('BRMS', 166::NUMERIC, 'mining-materials', 13), ('BUMI', 154::NUMERIC, 'energy', -12),
    ('CPIN', 5360::NUMERIC, 'consumer', 3), ('ERAA', 486::NUMERIC, 'consumer', -5),
    ('EXCL', 2260::NUMERIC, 'telecom-infrastructure', 4), ('GOTO', 286::NUMERIC, 'industrial-digital', -11),
    ('HMSP', 870::NUMERIC, 'consumer', -8), ('ICBP', 9580::NUMERIC, 'consumer', 7),
    ('INCO', 6420::NUMERIC, 'mining-materials', 6), ('INDF', 6580::NUMERIC, 'consumer', 2),
    ('ITMG', 33450::NUMERIC, 'energy', 10), ('JPFA', 1420::NUMERIC, 'consumer', -4),
    ('KLBF', 1640::NUMERIC, 'health', 5), ('MDKA', 3960::NUMERIC, 'mining-materials', -2),
    ('MEDC', 670::NUMERIC, 'energy', 3), ('PANI', 242::NUMERIC, 'property', -10),
    ('PGAS', 1760::NUMERIC, 'energy', -1), ('PTBA', 3620::NUMERIC, 'energy', 8),
    ('SMGR', 6240::NUMERIC, 'mining-materials', -5), ('TINS', 1190::NUMERIC, 'mining-materials', 1),
    ('TLKM', 3940::NUMERIC, 'telecom-infrastructure', 6), ('TOWR', 1060::NUMERIC, 'telecom-infrastructure', -2),
    ('UNVR', 4480::NUMERIC, 'consumer', 1), ('WIFI', 492::NUMERIC, 'telecom-infrastructure', -6)
), market_pulse (session_number, bps) AS (
  VALUES (1::SMALLINT, -55), (2::SMALLINT, 25), (3::SMALLINT, -85), (4::SMALLINT, 20),
    (5::SMALLINT, -75), (6::SMALLINT, 35), (7::SMALLINT, -45), (8::SMALLINT, -110),
    (9::SMALLINT, 55), (10::SMALLINT, 30)
), sector_pulse (sector_key, session_number, bps) AS (
  VALUES
    ('financials', 1::SMALLINT, -35), ('financials', 2::SMALLINT, 10), ('financials', 3::SMALLINT, -45), ('financials', 4::SMALLINT, 10), ('financials', 5::SMALLINT, -35), ('financials', 6::SMALLINT, 15), ('financials', 7::SMALLINT, -20), ('financials', 8::SMALLINT, -55), ('financials', 9::SMALLINT, 25), ('financials', 10::SMALLINT, 20),
    ('consumer', 1::SMALLINT, -20), ('consumer', 2::SMALLINT, 5), ('consumer', 3::SMALLINT, -35), ('consumer', 4::SMALLINT, -10), ('consumer', 5::SMALLINT, -30), ('consumer', 6::SMALLINT, 10), ('consumer', 7::SMALLINT, -15), ('consumer', 8::SMALLINT, -30), ('consumer', 9::SMALLINT, 15), ('consumer', 10::SMALLINT, 10),
    ('energy', 1::SMALLINT, 35), ('energy', 2::SMALLINT, -10), ('energy', 3::SMALLINT, 45), ('energy', 4::SMALLINT, 10), ('energy', 5::SMALLINT, 35), ('energy', 6::SMALLINT, -15), ('energy', 7::SMALLINT, 20), ('energy', 8::SMALLINT, 45), ('energy', 9::SMALLINT, -10), ('energy', 10::SMALLINT, -5),
    ('mining-materials', 1::SMALLINT, 30), ('mining-materials', 2::SMALLINT, -20), ('mining-materials', 3::SMALLINT, 55), ('mining-materials', 4::SMALLINT, 5), ('mining-materials', 5::SMALLINT, 30), ('mining-materials', 6::SMALLINT, -10), ('mining-materials', 7::SMALLINT, 15), ('mining-materials', 8::SMALLINT, 55), ('mining-materials', 9::SMALLINT, -15), ('mining-materials', 10::SMALLINT, -10),
    ('industrial-digital', 1::SMALLINT, -30), ('industrial-digital', 2::SMALLINT, 15), ('industrial-digital', 3::SMALLINT, -40), ('industrial-digital', 4::SMALLINT, 10), ('industrial-digital', 5::SMALLINT, -30), ('industrial-digital', 6::SMALLINT, 15), ('industrial-digital', 7::SMALLINT, -20), ('industrial-digital', 8::SMALLINT, -40), ('industrial-digital', 9::SMALLINT, 20), ('industrial-digital', 10::SMALLINT, 15),
    ('telecom-infrastructure', 1::SMALLINT, -15), ('telecom-infrastructure', 2::SMALLINT, 5), ('telecom-infrastructure', 3::SMALLINT, -20), ('telecom-infrastructure', 4::SMALLINT, 15), ('telecom-infrastructure', 5::SMALLINT, -15), ('telecom-infrastructure', 6::SMALLINT, 10), ('telecom-infrastructure', 7::SMALLINT, -10), ('telecom-infrastructure', 8::SMALLINT, -20), ('telecom-infrastructure', 9::SMALLINT, 15), ('telecom-infrastructure', 10::SMALLINT, 10),
    ('property', 1::SMALLINT, -45), ('property', 2::SMALLINT, 15), ('property', 3::SMALLINT, -55), ('property', 4::SMALLINT, 5), ('property', 5::SMALLINT, -45), ('property', 6::SMALLINT, 20), ('property', 7::SMALLINT, -30), ('property', 8::SMALLINT, -55), ('property', 9::SMALLINT, 30), ('property', 10::SMALLINT, 20),
    ('health', 1::SMALLINT, -10), ('health', 2::SMALLINT, 10), ('health', 3::SMALLINT, -15), ('health', 4::SMALLINT, 20), ('health', 5::SMALLINT, -10), ('health', 6::SMALLINT, 15), ('health', 7::SMALLINT, -5), ('health', 8::SMALLINT, -15), ('health', 9::SMALLINT, 10), ('health', 10::SMALLINT, 10)
), paths (ticker, sector_key, issuer_offset_bps, session_number, open_price, eod_price) AS (
  SELECT roster.ticker, roster.sector_key, roster.issuer_offset_bps, 1::SMALLINT,
    roster.anchor_price,
    GREATEST(grid.grid, ROUND(raw.raw_price / grid.grid) * grid.grid)
  FROM roster
  JOIN market_pulse market ON market.session_number = 1
  JOIN sector_pulse sector ON sector.sector_key = roster.sector_key AND sector.session_number = 1
  CROSS JOIN LATERAL (
    SELECT roster.anchor_price * (1 + ((market.bps + sector.bps + roster.issuer_offset_bps)::NUMERIC / 10000)) AS raw_price
  ) raw
  CROSS JOIN LATERAL (
    SELECT CASE
      WHEN raw.raw_price <= 200 THEN 1::NUMERIC
      WHEN raw.raw_price <= 500 THEN 2::NUMERIC
      ELSE 5::NUMERIC
    END AS grid
  ) grid

  UNION ALL

  SELECT paths.ticker, paths.sector_key, paths.issuer_offset_bps,
    (paths.session_number + 1)::SMALLINT,
    paths.eod_price,
    GREATEST(grid.grid, ROUND(raw.raw_price / grid.grid) * grid.grid)
  FROM paths
  JOIN market_pulse market ON market.session_number = paths.session_number + 1
  JOIN sector_pulse sector ON sector.sector_key = paths.sector_key AND sector.session_number = paths.session_number + 1
  CROSS JOIN LATERAL (
    SELECT paths.eod_price * (1 + ((market.bps + sector.bps + paths.issuer_offset_bps)::NUMERIC / 10000)) AS raw_price
  ) raw
  CROSS JOIN LATERAL (
    SELECT CASE
      WHEN raw.raw_price <= 200 THEN 1::NUMERIC
      WHEN raw.raw_price <= 500 THEN 2::NUMERIC
      ELSE 5::NUMERIC
    END AS grid
  ) grid
  WHERE paths.session_number < 10
), point_seed AS (
  SELECT paths.session_number, paths.ticker, 'open'::TEXT AS point_kind, paths.open_price AS simulated_price
  FROM paths
  UNION ALL
  SELECT paths.session_number, paths.ticker, 'eod_close'::TEXT AS point_kind, paths.eod_price AS simulated_price
  FROM paths
)
INSERT INTO public.practice_market_price_points (
  session_id,
  instrument_id,
  point_kind,
  simulated_price,
  scenario_version,
  author_name,
  reviewer_name,
  reviewed_at,
  publication_state
)
SELECT session.id, instrument.id, point_seed.point_kind, point_seed.simulated_price,
  'season-1-v1', 'Koin Practice Market authoring pack',
  'Independent KO-422 authoring review', TIMESTAMPTZ '2026-08-12 00:00:00+00', 'approved'
FROM point_seed
JOIN season ON TRUE
JOIN public.practice_market_sessions session
  ON session.season_id = season.id AND session.session_number = point_seed.session_number
JOIN public.practice_market_instruments instrument
  ON instrument.season_id = season.id AND instrument.ticker = point_seed.ticker
ON CONFLICT (session_id, instrument_id, point_kind) DO NOTHING;

WITH season AS (
  SELECT id
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices'
), event_seed (session_number, title, title_id, content, evidence_references) AS (
  VALUES
    (1::SMALLINT, 'Start with uncertainty, not a prediction', 'Mulai dari ketidakpastian, bukan prediksi',
      $$ {"en":{"eyebrow":"Session 1 · Set your rule","body":"Price-pressure and commodity uncertainty can affect businesses differently. A headline is not enough to know the next move.","prompt":"Before you act, write one thing you know, one thing you do not know, and the maximum part of your virtual cash you are willing to risk."},"id":{"eyebrow":"Sesi 1 · Tetapkan aturannya","body":"Tekanan harga dan ketidakpastian komoditas dapat memengaruhi bisnis secara berbeda. Satu berita belum cukup untuk mengetahui langkah berikutnya.","prompt":"Sebelum bertindak, tulis satu hal yang kamu tahu, satu hal yang belum kamu tahu, dan batas bagian uang virtual yang rela kamu risikokan."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-BI-Q2-2022')),
    (2::SMALLINT, 'A price move is information, not an instruction', 'Pergerakan harga adalah informasi, bukan instruksi',
      $$ {"en":{"eyebrow":"Session 2 · Pause before reacting","body":"A simulated move can invite a question, but it does not command a trade.","prompt":"Compare today with your written rule. Is there new evidence, or only a new feeling? Choosing to observe is a valid decision."},"id":{"eyebrow":"Sesi 2 · Berhenti sejenak sebelum bereaksi","body":"Pergerakan simulasi dapat mengundang pertanyaan, tetapi tidak memerintahkan transaksi.","prompt":"Bandingkan hari ini dengan aturan yang sudah kamu tulis. Ada bukti baru, atau hanya perasaan baru? Memilih mengamati tetap keputusan yang valid."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-SIMULATION-METHODOLOGY-V1')),
    (3::SMALLINT, 'Household costs can affect businesses differently', 'Biaya rumah tangga dapat memengaruhi bisnis secara berbeda',
      $$ {"en":{"eyebrow":"Session 3 · Compare exposure","body":"When household costs rise, a business may face different customers, costs, and supply pressures. Similar sectors can still carry different exposure.","prompt":"Pick two instruments from different learning roles. What is one possible difference in their exposure? Write it as a hypothesis, not a forecast."},"id":{"eyebrow":"Sesi 3 · Bandingkan eksposur","body":"Saat biaya rumah tangga naik, bisnis dapat menghadapi pelanggan, biaya, dan tekanan pasokan yang berbeda. Sektor yang mirip pun dapat memiliki eksposur berbeda.","prompt":"Pilih dua instrumen dari peran pembelajaran yang berbeda. Apa satu kemungkinan perbedaan eksposurnya? Tulis sebagai hipotesis, bukan ramalan."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-BI-Q2-2022')),
    (4::SMALLINT, 'Check concentration before adding risk', 'Periksa konsentrasi sebelum menambah risiko',
      $$ {"en":{"eyebrow":"Session 4 · Look beneath the tickers","body":"Owning several names can still mean relying on one shared driver.","prompt":"If you add an instrument today, which existing holding would make your exposure more concentrated? If you cannot name it, pause and inspect first."},"id":{"eyebrow":"Sesi 4 · Lihat di balik tickernya","body":"Memiliki beberapa nama tetap bisa berarti bergantung pada satu penggerak yang sama.","prompt":"Jika kamu menambah instrumen hari ini, kepemilikan mana yang membuat eksposurmu makin terkonsentrasi? Jika belum bisa menyebutkannya, berhenti dan periksa dulu."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-SIMULATION-METHODOLOGY-V1')),
    (5::SMALLINT, 'Policy context is not a price promise', 'Konteks kebijakan bukan janji harga',
      $$ {"en":{"eyebrow":"Session 5 · Context, not certainty","body":"The Season draws on a period of Indonesian price-pressure context. Context can help you frame questions; it cannot promise one company outcome.","prompt":"Write one assumption that would have to be true for your plan to make sense. Then name one observation that could weaken that assumption."},"id":{"eyebrow":"Sesi 5 · Konteks, bukan kepastian","body":"Musim ini mengambil konteks periode tekanan harga di Indonesia. Konteks membantu menyusun pertanyaan; konteks tidak dapat menjanjikan hasil satu perusahaan.","prompt":"Tulis satu asumsi yang harus benar agar rencanamu masuk akal. Lalu sebutkan satu pengamatan yang dapat melemahkan asumsi tersebut."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-BI-Q2-2022')),
    (6::SMALLINT, 'Write what would change your mind', 'Tulis apa yang dapat mengubah pandanganmu',
      $$ {"en":{"eyebrow":"Session 6 · Make a review trigger","body":"A decision becomes easier to review when you define what could change your mind before the result is known.","prompt":"Set one review trigger for a holding or a no-trade choice. Use an observable fact, not “I will know when it feels right.”"},"id":{"eyebrow":"Sesi 6 · Buat pemicu tinjauan","body":"Keputusan lebih mudah ditinjau ketika kamu menentukan hal yang dapat mengubah pikiran sebelum hasilnya diketahui.","prompt":"Tetapkan satu pemicu tinjauan untuk kepemilikan atau pilihan tidak bertransaksi. Gunakan fakta yang dapat diamati, bukan “saya akan tahu saat terasa tepat.”"}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-SIMULATION-METHODOLOGY-V1')),
    (7::SMALLINT, 'One headline, mixed exposures', 'Satu berita, eksposur berbeda',
      $$ {"en":{"eyebrow":"Session 7 · Avoid one-story thinking","body":"A shared context can coexist with different simulated movement across learning roles. That difference is a prompt to investigate, not proof that one choice is better.","prompt":"Name one reason two instruments could react differently to the same context. What information would you need before treating that reason as evidence?"},"id":{"eyebrow":"Sesi 7 · Hindari berpikir satu cerita","body":"Konteks yang sama dapat berjalan bersama pergerakan simulasi yang berbeda antarperan pembelajaran. Perbedaan itu adalah ajakan untuk menyelidiki, bukan bukti bahwa satu pilihan lebih baik.","prompt":"Sebutkan satu alasan dua instrumen dapat bereaksi berbeda pada konteks yang sama. Informasi apa yang kamu perlukan sebelum menganggap alasan itu sebagai bukti?"}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-BI-Q2-2022')),
    (8::SMALLINT, 'Slow down before reacting to a drawdown', 'Perlambat sebelum bereaksi pada penurunan',
      $$ {"en":{"eyebrow":"Session 8 · Protect the process","body":"A drawdown can make urgency feel persuasive. Urgency is not the same as evidence.","prompt":"Before changing anything, check your position size, your original reason, and what information is still missing. You may reduce risk, hold, or observe—state why."},"id":{"eyebrow":"Sesi 8 · Lindungi prosesnya","body":"Penurunan dapat membuat rasa mendesak terasa meyakinkan. Rasa mendesak tidak sama dengan bukti.","prompt":"Sebelum mengubah apa pun, periksa ukuran posisi, alasan awal, dan informasi yang masih kurang. Kamu dapat mengurangi risiko, menahan, atau mengamati—jelaskan alasannya."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-SIMULATION-METHODOLOGY-V1')),
    (9::SMALLINT, 'Review the reason, not only the result', 'Tinjau alasan, bukan hanya hasil',
      $$ {"en":{"eyebrow":"Session 9 · Separate process from outcome","body":"A favourable result can come from a weak reason, and an unfavourable result can follow a thoughtful process.","prompt":"Read your earliest note. Did you follow your own rule? Identify one thing to keep and one thing to improve before the Season debrief."},"id":{"eyebrow":"Sesi 9 · Tinjau alasan, bukan hanya hasil","body":"Hasil yang baik dapat datang dari alasan yang lemah, dan hasil yang tidak baik dapat mengikuti proses yang matang.","prompt":"Baca catatan awalmu. Apakah kamu mengikuti aturannya sendiri? Sebutkan satu hal yang perlu dipertahankan dan satu hal yang perlu diperbaiki sebelum debrief Musim."}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-SIMULATION-METHODOLOGY-V1')),
    (10::SMALLINT, 'Debrief with the full context', 'Lakukan debrief dengan konteks lengkap',
      $$ {"en":{"eyebrow":"Session 10 · Finish the review","body":"The later official inflation releases provide context for the period, not a scorecard for a single trade. Your Season result is one input; your process is the lesson.","prompt":"Review concentration, turnover, evidence use, and your review triggers. What would you carry into the next Season even if the simulated P&L had been different?"},"id":{"eyebrow":"Sesi 10 · Selesaikan tinjauannya","body":"Rilis inflasi resmi yang terbit setelah periode ini memberi konteks, bukan rapor untuk satu transaksi. Hasil Musimmu adalah satu masukan; prosesmu adalah pelajarannya.","prompt":"Tinjau konsentrasi, frekuensi transaksi, penggunaan bukti, dan pemicu tinjauanmu. Apa yang tetap akan kamu bawa ke Musim berikutnya walau P&L simulasi berbeda?"}} $$::JSONB,
      JSONB_BUILD_ARRAY('S1-BPS-CPI-2022-09', 'S1-BPS-WPI-2022-09'))
)
INSERT INTO public.practice_market_event_cards (
  season_id,
  session_id,
  title,
  title_id,
  content,
  evidence_references,
  non_advice_disclosure,
  reveal_at,
  publication_state,
  author_name,
  reviewer_name,
  reviewed_at
)
SELECT season.id, session.id, event_seed.title, event_seed.title_id,
  event_seed.content, event_seed.evidence_references,
  'Koin Practice Market simulation — inspired by a historical Indonesian market context; not an actual IDX quote, market replay or investment recommendation.',
  session.planning_desk_opens_at, 'approved',
  'Koin Practice Market authoring pack',
  'Independent KO-422 authoring review', TIMESTAMPTZ '2026-08-12 00:00:00+00'
FROM season
JOIN event_seed ON TRUE
JOIN public.practice_market_sessions session
  ON session.season_id = season.id AND session.session_number = event_seed.session_number
ON CONFLICT DO NOTHING;

DO $$
DECLARE
  v_season_id UUID;
  v_session_count INTEGER;
  v_instrument_count INTEGER;
  v_price_count INTEGER;
  v_event_count INTEGER;
BEGIN
  SELECT id INTO v_season_id
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices';

  SELECT COUNT(*) INTO v_session_count
  FROM public.practice_market_sessions
  WHERE season_id = v_season_id AND state = 'scheduled';

  SELECT COUNT(*) INTO v_instrument_count
  FROM public.practice_market_instruments
  WHERE season_id = v_season_id AND is_active;

  SELECT COUNT(*) INTO v_price_count
  FROM public.practice_market_price_points point
  JOIN public.practice_market_sessions session ON session.id = point.session_id
  WHERE session.season_id = v_season_id
    AND point.publication_state = 'approved'
    AND point.published_at IS NULL;

  SELECT COUNT(*) INTO v_event_count
  FROM public.practice_market_event_cards
  WHERE season_id = v_season_id
    AND publication_state = 'approved'
    AND published_at IS NULL;

  IF v_session_count <> 10 OR v_instrument_count <> 34
    OR v_price_count <> 680 OR v_event_count <> 10 THEN
    RAISE EXCEPTION
      'KO-422 seed cardinality mismatch: sessions %, instruments %, price points %, event cards %',
      v_session_count, v_instrument_count, v_price_count, v_event_count;
  END IF;
END;
$$;

COMMENT ON FUNCTION public.practice_market_reject_elapsed_season_availability() IS
  'KO-422 prevents historical-context session schedules from becoming learner-available before a later release rebases them.';

COMMIT;
