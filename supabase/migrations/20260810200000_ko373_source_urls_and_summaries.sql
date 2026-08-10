-- KO-373 follow-up: fix unreachable source URLs and add bilingual summaries.
-- The official OJK/IDX pages for these sources block automated/cross-region
-- requests, so they are replaced with stable Wikipedia pages. KSEI and the
-- OJK sustainable-finance PDF remain because they are reachable.
BEGIN;

UPDATE public.sources
SET
  url = 'https://en.wikipedia.org/wiki/Personal_finance',
  synopsis = 'Personal finance covers budgeting, saving, debt management, emergency funds, and goal setting before investing.',
  synopsis_id = 'Keuangan pribadi mencakup anggaran, menabung, manajemen utang, dana darurat, dan penetapan tujuan sebelum berinvestasi.',
  relevance_blurb = 'Supports the readiness check that stable finances should come before market risk.',
  relevance_blurb_id = 'Mendukung pemeriksaan kesiapan bahwa keuangan yang stabil harus didahulukan sebelum mengambil risiko pasar.',
  last_checked_at = NOW()
WHERE source_code = 'OJK-LITERASI-001';

UPDATE public.sources
SET
  url = 'https://en.wikipedia.org/wiki/Indonesia_Stock_Exchange',
  synopsis = 'The Indonesia Stock Exchange (IDX) is the national stock exchange providing listed securities, market data, and investor education.',
  synopsis_id = 'Bursa Efek Indonesia (BEI) adalah bursa saham nasional yang menyediakan efek tercatat, data pasar, dan edukasi investor.',
  relevance_blurb = 'Provides context for how Indonesian capital markets operate and where official company disclosures are published.',
  relevance_blurb_id = 'Memberikan konteks bagaimana pasar modal Indonesia beroperasi dan di mana pengungkapan perusahaan resmi diterbitkan.',
  last_checked_at = NOW()
WHERE source_code = 'IDX-EDU-001';

UPDATE public.sources
SET
  url = 'https://en.wikipedia.org/wiki/Financial_statement',
  synopsis = 'Financial statements summarize a company''s financial position, performance, and cash flows, forming the basis of fundamental analysis.',
  synopsis_id = 'Laporan keuangan merangkum posisi keuangan, kinerja, dan arus kas perusahaan, yang menjadi dasar analisis fundamental.',
  relevance_blurb = 'Explains why reading annual reports and financial statements matters before picking stocks or funds.',
  relevance_blurb_id = 'Menjelaskan mengapa membaca laporan tahunan dan laporan keuangan penting sebelum memilih saham atau reksa dana.',
  last_checked_at = NOW()
WHERE source_code = 'OJK-FILINGS-001';

UPDATE public.sources
SET
  synopsis = 'KSEI is Indonesia''s central securities depository that records ownership of stocks, bonds, and other securities in investor accounts.',
  synopsis_id = 'KSEI adalah kustodian sentral efek Indonesia yang mencatat kepemilikan saham, obligasi, dan efek lainnya di rekening investor.',
  relevance_blurb = 'Helps learners understand how securities ownership is recorded and settled in Indonesia.',
  relevance_blurb_id = 'Membantu pelajar memahami bagaimana kepemilikan efek dicatat dan diselesaikan di Indonesia.',
  last_checked_at = NOW()
WHERE source_code = 'KSEI-001';

UPDATE public.sources
SET
  synopsis = 'The Sustainable Finance Taxonomy defines which economic activities qualify as green or sustainable in Indonesia.',
  synopsis_id = 'Taksonomi Keuangan Berkelanjutan menentukan aktivitas ekonomi mana yang memenuhi syarat hijau atau berkelanjutan di Indonesia.',
  relevance_blurb = 'Used to introduce ESG and greenwashing concepts relevant to Indonesian investors.',
  relevance_blurb_id = 'Digunakan untuk memperkenalkan konsep ESG dan greenwashing yang relevan bagi investor Indonesia.',
  last_checked_at = NOW()
WHERE source_code = 'OJK-SUSTAINABLE-001';

COMMIT;
