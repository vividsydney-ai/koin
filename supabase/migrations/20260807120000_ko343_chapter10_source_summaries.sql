-- KO-343: Chapter 10 source and freshness boundary.
--
-- Backfill bilingual synopsis/relevance metadata on the shared Chapter 10
-- primary source so every source card can render both Read source and
-- See summary. Refresh the last-checked date to the review date.

BEGIN;

UPDATE public.sources
SET
  synopsis = COALESCE(NULLIF(synopsis, ''), 'OJK''s higher-education capital-market primer covering market structure, instruments, and basic investor safeguards.'),
  synopsis_id = COALESCE(NULLIF(synopsis_id, ''), 'Buku saku pasar modal tingkat perguruan tinggi dari OJK yang mencakup struktur pasar, instrumen, dan perlindungan dasar investor.'),
  relevance_blurb = COALESCE(NULLIF(relevance_blurb, ''), 'Used for chart-reading fundamentals, candle anatomy, and the limits of price-based analysis.'),
  relevance_blurb_id = COALESCE(NULLIF(relevance_blurb_id, ''), 'Digunakan untuk dasar membaca grafik, anatomi candle, dan batasan analisis berbasis harga.'),
  last_checked_at = GREATEST(last_checked_at, '2026-08-07'::date)
WHERE source_code = 'OJK-CHART-001';

COMMIT;
