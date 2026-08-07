-- KO-305: replace Chapter 08 learner-facing source placeholders with reviewed
-- primary sources. Dynamic facts remain date-sensitive and are not embedded as
-- timeless lesson claims.

BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes
)
VALUES
  ('CH08-OJK-CAPITAL', 'OJK Capital Market portal', 'Portal Pasar Modal OJK', 1, 'website', 'OJK', 'https://ojk.go.id/id/kanal/pasar-modal', 'id', '2026-08-05', 'verified', 'Primary regulator portal for stable capital-market definitions and boundaries.', 'Use for Indonesian learner context; do not treat the landing page as support for a current product term.'),
  ('CH08-IDX-STOCKS', 'IDX Stocks product information', 'Informasi Produk Saham IDX', 1, 'website', 'IDX', 'https://www.idx.id/en/products/stocks/', 'en', '2026-08-05', 'verified', 'Primary exchange product page.', 'Pair with the Indonesian IDX page when a learner-facing source label is needed.'),
  ('CH08-IDX-TRADING', 'IDX Trading Hours and Mechanism', 'Jam dan Mekanisme Perdagangan IDX', 1, 'website', 'IDX', 'https://www.idx.id/en/products-services/trading-hours-and-mechanism/', 'en', '2026-08-05', 'verified', 'Primary exchange rules page; lot sizes, trading mechanism, and sessions can change.', 'Always show the reviewed date when a dynamic rule or session is used.'),
  ('CH08-IDX-ETF-OVERVIEW', 'IDX Exchange-Traded Fund overview', 'Ikhtisar Exchange-Traded Fund IDX', 1, 'website', 'IDX', 'https://www.idx.id/en/products/exchange-traded-fund-etf/', 'en', '2026-08-05', 'verified', 'Primary exchange ETF education and mechanics page.', 'Do not copy live-price or real-time wording into static lesson content without a dated snapshot.'),
  ('CH08-IDX-ETF-LIST', 'IDX Exchange-Traded Fund list', 'Daftar Exchange-Traded Fund IDX', 1, 'website', 'IDX', 'https://www.idx.id/en/market-data/exchanged-traded-fund-etf-data/exchange-traded-fund-etf-list', 'en', '2026-08-05', 'verified', 'Primary dynamic ETF catalogue.', 'Ticker, listing, price, dividend, manager, and dealer fields require retrieval dates.'),
  ('CH08-OJK-FIND', 'OJK Financial Institutions Directory', 'Direktori Lembaga Jasa Keuangan OJK', 1, 'website', 'OJK', 'https://find.ojk.go.id/', 'id', '2026-08-05', 'verified', 'Primary directory for checking licensed or registered financial institutions.', 'Teach verification behaviour; do not rank or recommend named providers.'),
  ('CH08-OJK-RDN', 'OJK electronic Securities and Customer Fund Account guidance', 'Pedoman Rekening Efek dan Rekening Dana Nasabah OJK', 1, 'regulation', 'OJK', 'https://ojk.go.id/id/regulasi/Documents/Pages/Pedoman-Pembukaan-Rekening-Efek-Nasabah-dan-Rekening-Dana-Nasabah-Secara-Elektronik-/seojk%206-2019.pdf', 'id', '2026-08-05', 'verified', 'Primary regulatory guidance for RDN terminology and account boundaries.', 'Regulatory text may change; no universal account-opening timeline is implied.'),
  ('CH08-KSEI-RDN', 'KSEI operating procedures', 'Ketentuan Pelaksanaan KSEI', 1, 'regulation', 'KSEI', 'https://web.ksei.co.id/regulations/operating-procedures?setLocale=id-ID', 'id', '2026-08-05', 'verified', 'Primary depository operating-procedure index, including RDN-related procedures.', 'Use for current operational safeguards only with a reviewed date.'),
  ('CH08-KEMENKEU-SBN', 'Kemenkeu SBN Ritel education', 'Edukasi SBN Ritel Kementerian Keuangan', 1, 'guide', 'Kementerian Keuangan', 'https://djpb.kemenkeu.go.id/kanwil/kaltara/id/data-publikasi/berita-terbaru/2940-gkm-mengenal-surat-berharga-negara-sbn-ritel-sebagai-instrumen-investasi.html', 'id', '2026-08-05', 'verified', 'Primary government explanation of SBN retail categories and characteristics.', 'Series-specific terms must be checked against the current DJPPR page.'),
  ('CH08-DJPPR-ORI', 'DJPPR Obligasi Negara Ritel', 'Obligasi Negara Ritel DJPPR', 1, 'website', 'DJPPR', 'https://djppr.kemenkeu.go.id/obligasinegararitel', 'id', '2026-08-05', 'verified', 'Primary issuer page for current ORI series, terms, tax, coupon, and holding-period facts.', 'Never copy a series-specific value into a timeless lesson visual.'),
  ('CH08-OJK-SBN-GUIDE', 'OJK Capital Market Pocketbook', 'Buku Saku Pasar Modal OJK', 1, 'guide', 'OJK', 'https://ojk.go.id/id/berita-dan-kegiatan/publikasi/Documents/Pages/Buku-Saku-Pasar-Modal/BUKU%20SAKU%20PSR%20MODAL%20OJK%202023.pdf', 'id', '2026-08-05', 'verified', 'Primary regulator education for bond terms, maturity, nominal value, and risk language.', 'Use general definitions; review any current product terms separately.'),
  ('CH08-DJP-SPT', 'DJP Annual Income Tax Return guidance', 'Panduan SPT Tahunan Pajak Penghasilan DJP', 1, 'website', 'DJP', 'https://pajak.go.id/index.php/id/pelaporan-spt-tahunan-pajak-penghasilan-0', 'id', '2026-08-05', 'verified', 'Primary tax authority explanation of SPT purpose and taxpayer reporting duties.', 'Tax process and terminology must be reviewed each tax year.'),
  ('CH08-DJP-SPT-INDIVIDUAL', 'DJP Individual Annual SPT service page', 'Layanan SPT Tahunan Orang Pribadi DJP', 1, 'website', 'DJP', 'https://www.pajak.go.id/panduan-layanan-pajak/konten/pelaporan/2025/orang-pribadi/spt/spt-tahunan-pph-wajib-pajak-orang-pribadi', 'id', '2026-08-05', 'verified', 'Primary service guidance for individual filing pathways.', 'The page is year-scoped; do not present form names or channels as permanent.'),
  ('CH08-DJP-DEADLINES', 'DJP reporting deadlines', 'Batas Waktu Lapor DJP', 1, 'website', 'DJP', 'https://pajak.go.id/id/batas-waktu-lapor', 'id', '2026-08-05', 'verified', 'Primary deadline reference.', 'Display the effective/review date and recheck before publishing each tax-year lesson.'),
  ('CH08-DJP-PPH21', 'DJP Income Tax Article 21 guidance', 'Panduan Pemotongan PPh Pasal 21 DJP', 1, 'website', 'DJP', 'https://pajak.go.id/id/pemotongan-pajak-penghasilan-pasal-21', 'id', '2026-08-05', 'verified', 'Primary tax authority guidance for high-level PPh 21 explanation.', 'Do not reuse old thresholds or sample calculations without a dated rule.'),
  ('CH08-BI-RATE', 'Bank Indonesia BI-Rate indicator', 'Indikator BI-Rate Bank Indonesia', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/statistik/indikator/bi-rate.aspx', 'id', '2026-08-05', 'verified', 'Primary current BI-Rate data page.', 'Every numeric value is a dated snapshot and must not be static lesson copy.'),
  ('CH08-BI-INFLATION', 'Bank Indonesia inflation education', 'Edukasi Inflasi Bank Indonesia', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/en/fungsi-utama/moneter/inflasi/default.aspx', 'en', '2026-08-05', 'verified', 'Primary inflation definition and explanatory channel.', 'Use a dated BPS/BI value for numeric examples; do not imply stock prediction.'),
  ('CH08-BI-JISDOR', 'Bank Indonesia JISDOR reference rate', 'Kurs Referensi JISDOR Bank Indonesia', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/en/statistik/informasi-kurs/jisdor/Default.aspx', 'en', '2026-08-05', 'verified', 'Primary exchange-rate reference page.', 'Every numeric value is a dated snapshot.' )
ON CONFLICT (source_code) DO UPDATE SET
  title = EXCLUDED.title,
  local_title = EXCLUDED.local_title,
  source_tier = EXCLUDED.source_tier,
  source_type = EXCLUDED.source_type,
  organization = EXCLUDED.organization,
  url = EXCLUDED.url,
  language = EXCLUDED.language,
  last_checked_at = EXCLUDED.last_checked_at,
  status = EXCLUDED.status,
  trust_notes = EXCLUDED.trust_notes,
  localization_notes = EXCLUDED.localization_notes;

-- Remove only stale/needs-review links from the learner-facing Chapter 08
-- source set. Existing verified general sources remain available as context.
DELETE FROM public.lesson_sources AS lesson_source
USING public.lessons AS lesson, public.topics AS topic, public.sources AS source
WHERE lesson_source.lesson_id = lesson.id
  AND lesson.topic_id = topic.id
  AND lesson_source.source_id = source.id
  AND topic.chapter = 'Investing in Indonesia'
  AND source.status = 'needs_review';

WITH chapter_sources(slug, source_code, relevance_type, citation_label, is_primary, display_order) AS (
  VALUES
    ('what-is-a-stock', 'CH08-OJK-CAPITAL', 'primary', 'OJK capital market portal', TRUE, 10),
    ('what-is-a-stock', 'CH08-IDX-STOCKS', 'supporting', 'IDX stocks', FALSE, 20),
    ('idx-basics-101', 'CH08-IDX-TRADING', 'primary', 'IDX trading hours and mechanism', TRUE, 10),
    ('idx-basics-101', 'CH08-OJK-FIND', 'supporting', 'OJK licence directory', FALSE, 20),
    ('reading-a-stock-page', 'CH08-IDX-STOCKS', 'primary', 'IDX stocks', TRUE, 10),
    ('reading-a-stock-page', 'CH08-OJK-CAPITAL', 'supporting', 'OJK capital market portal', FALSE, 20),
    ('portfolio-thinking', 'CH08-OJK-CAPITAL', 'primary', 'OJK capital market portal', TRUE, 10),
    ('taxes-on-returns', 'CH08-DJP-PPH21', 'primary', 'DJP PPh 21 guidance', TRUE, 10),
    ('macro-indicators', 'CH08-BI-RATE', 'primary', 'BI-Rate indicator', TRUE, 10),
    ('macro-indicators', 'CH08-BI-INFLATION', 'supporting', 'BI inflation education', FALSE, 20),
    ('macro-indicators', 'CH08-BI-JISDOR', 'supporting', 'BI JISDOR', FALSE, 30),
    ('etfs-investing-with-one-click', 'CH08-IDX-ETF-OVERVIEW', 'primary', 'IDX ETF overview', TRUE, 10),
    ('etfs-investing-with-one-click', 'CH08-IDX-ETF-LIST', 'supporting', 'IDX ETF list', FALSE, 20),
    ('etfs-investing-with-one-click', 'CH08-IDX-TRADING', 'supporting', 'IDX trading mechanism', FALSE, 30),
    ('bonds-sbn-safe-investing-with-the-government', 'CH08-KEMENKEU-SBN', 'primary', 'Kemenkeu SBN Ritel', TRUE, 10),
    ('bonds-sbn-safe-investing-with-the-government', 'CH08-DJPPR-ORI', 'supporting', 'DJPPR ORI', FALSE, 20),
    ('bonds-sbn-safe-investing-with-the-government', 'CH08-OJK-SBN-GUIDE', 'supporting', 'OJK Capital Market Pocketbook', FALSE, 30),
    ('tax-basics-npwp-pph-21-and-filing-taxes', 'CH08-DJP-SPT', 'primary', 'DJP annual SPT guidance', TRUE, 10),
    ('tax-basics-npwp-pph-21-and-filing-taxes', 'CH08-DJP-SPT-INDIVIDUAL', 'supporting', 'DJP individual SPT service', FALSE, 20),
    ('tax-basics-npwp-pph-21-and-filing-taxes', 'CH08-DJP-DEADLINES', 'supporting', 'DJP reporting deadlines', FALSE, 30),
    ('brokerage-account-setup-opening-your-rdn', 'CH08-OJK-RDN', 'primary', 'OJK RDN guidance', TRUE, 10),
    ('brokerage-account-setup-opening-your-rdn', 'CH08-OJK-FIND', 'supporting', 'OJK licence directory', FALSE, 20),
    ('brokerage-account-setup-opening-your-rdn', 'CH08-KSEI-RDN', 'supporting', 'KSEI operating procedures', FALSE, 30),
    ('stock-analysis-basics-fundamental-vs-technical', 'CH08-OJK-CAPITAL', 'primary', 'OJK capital market portal', TRUE, 10),
    ('stock-analysis-basics-fundamental-vs-technical', 'CH08-IDX-STOCKS', 'supporting', 'IDX stocks', FALSE, 20)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, chapter_sources.relevance_type, chapter_sources.citation_label,
       chapter_sources.is_primary, chapter_sources.display_order
FROM chapter_sources
JOIN public.lessons AS lesson ON lesson.slug = chapter_sources.slug
JOIN public.sources AS source ON source.source_code = chapter_sources.source_code
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

COMMIT;
