-- KO-447 follow-up: do not rely on Fidelity as the learner-facing fallback.
-- Some verification environments receive 403/HTTP2 failures from Fidelity.
BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'KO447-SCHWAB-STOCK-BASICS',
  'Stock investing basics',
  'Dasar-dasar investasi saham',
  2, 'website', 'Charles Schwab',
  'https://www.schwab.com/learn/story/stock-investing-basics',
  'en', '2026-08-13', 'verified',
  'Accessible educational companion for stock-market vocabulary and decision context; it is not a stock-specific recommendation.',
  'Bacaan edukasi pendamping yang dapat diakses tentang kosakata pasar saham dan konteks keputusan; bukan rekomendasi saham tertentu.',
  'Use this companion article to connect chart observations with the broader question being studied, without treating a pattern as a guarantee.',
  'Gunakan artikel pendamping ini untuk menghubungkan pengamatan grafik dengan pertanyaan yang lebih luas, tanpa menganggap pola sebagai jaminan.',
  'A resilient Tier-2 fallback when an official page or a specialist article is blocked by a browser or WAF.',
  'Fallback Tier-2 yang lebih tangguh saat halaman resmi atau artikel khusus terhalang browser atau WAF.'
)
ON CONFLICT (source_code) DO UPDATE SET
  title=EXCLUDED.title, local_title=EXCLUDED.local_title, source_tier=EXCLUDED.source_tier,
  source_type=EXCLUDED.source_type, organization=EXCLUDED.organization, url=EXCLUDED.url,
  language=EXCLUDED.language, last_checked_at=EXCLUDED.last_checked_at, status=EXCLUDED.status,
  trust_notes=EXCLUDED.trust_notes, localization_notes=EXCLUDED.localization_notes,
  synopsis=EXCLUDED.synopsis, synopsis_id=EXCLUDED.synopsis_id,
  relevance_blurb=EXCLUDED.relevance_blurb, relevance_blurb_id=EXCLUDED.relevance_blurb_id;

DELETE FROM public.lesson_sources link
USING public.lessons l, public.sources s, public.topics t
WHERE link.lesson_id=l.id AND link.source_id=s.id AND l.topic_id=t.id
  AND t.chapter='Decision Analysis Lab' AND l.is_published
  AND s.source_code='KO447-FIDELITY-TA-OVERVIEW';

INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT l.id, s.id, 'supporting', 'Schwab: stock investing basics', FALSE, 40
FROM public.lessons l
JOIN public.topics t ON t.id=l.topic_id AND t.chapter='Decision Analysis Lab'
JOIN public.sources s ON s.source_code='KO447-SCHWAB-STOCK-BASICS'
WHERE l.is_published
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type=EXCLUDED.relevance_type, citation_label=EXCLUDED.citation_label,
  is_primary=FALSE, display_order=EXCLUDED.display_order;

DO $$
DECLARE lesson_count INT; fallback_count INT; blocked_links INT;
BEGIN
  SELECT COUNT(*) INTO lesson_count
  FROM public.lessons l JOIN public.topics t ON t.id=l.topic_id
  WHERE t.chapter='Decision Analysis Lab' AND l.is_published;
  SELECT COUNT(DISTINCT l.id) INTO fallback_count
  FROM public.lesson_sources ls JOIN public.lessons l ON l.id=ls.lesson_id JOIN public.topics t ON t.id=l.topic_id JOIN public.sources s ON s.id=ls.source_id
  WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND ls.relevance_type='supporting'
    AND s.source_tier=2 AND s.status='verified' AND s.url IS NOT NULL;
  SELECT COUNT(*) INTO blocked_links
  FROM public.lesson_sources ls JOIN public.lessons l ON l.id=ls.lesson_id JOIN public.topics t ON t.id=l.topic_id JOIN public.sources s ON s.id=ls.source_id
  WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND s.source_code='KO447-FIDELITY-TA-OVERVIEW';
  IF lesson_count<>8 OR fallback_count<>8 OR blocked_links<>0 THEN
    RAISE EXCEPTION 'KO-447 fallback mismatch: lessons %, fallback lessons %, blocked links %', lesson_count, fallback_count, blocked_links;
  END IF;
END $$;

COMMIT;
