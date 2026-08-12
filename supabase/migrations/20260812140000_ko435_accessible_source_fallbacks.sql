-- KO-435: keep lesson source links usable when a higher-tier URL is blocked.
-- Source tier remains editorial trust; runtime selection is based on reachability.
BEGIN;

UPDATE public.sources
SET status = 'needs_review',
    last_checked_at = NOW(),
    trust_notes = CONCAT(
      COALESCE(trust_notes, ''),
      CASE WHEN COALESCE(trust_notes, '') = '' THEN '' ELSE ' ' END,
      'KO-435 live check: automated request returned HTTP 403; do not present as an accessible link.'
    )
WHERE source_code = 'OJK-CHART-001';

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.sources WHERE source_code = 'CH08-OJK-CAPITAL' AND url IS NOT NULL) THEN
    RAISE EXCEPTION 'KO-435 requires accessible approved fallback source CH08-OJK-CAPITAL';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.sources WHERE source_code = 'CH08-IDX-STOCKS' AND url IS NOT NULL) THEN
    RAISE EXCEPTION 'KO-435 requires accessible approved fallback source CH08-IDX-STOCKS';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.sources WHERE source_code = 'IDX-EDU-001' AND url IS NOT NULL) THEN
    RAISE EXCEPTION 'KO-435 requires accessible fallback source IDX-EDU-001';
  END IF;
END $$;

WITH fallback_sources(source_code, relevance_type, citation_label, display_order) AS (
  VALUES
    ('CH08-OJK-CAPITAL', 'supporting', 'OJK: capital-market overview', 20),
    ('CH08-IDX-STOCKS', 'supporting', 'IDX: stocks overview', 30),
    ('IDX-EDU-001', 'further_reading', 'IDX: investor education', 40)
)
INSERT INTO public.lesson_sources (
  lesson_id, source_id, relevance_type, citation_label, is_primary, display_order
)
SELECT lesson.id, source.id, fallback.relevance_type, fallback.citation_label, FALSE, fallback.display_order
FROM public.lessons AS lesson
JOIN public.topics AS topic ON topic.id = lesson.topic_id
CROSS JOIN fallback_sources AS fallback
JOIN public.sources AS source ON source.source_code = fallback.source_code
WHERE topic.chapter = 'Reading Trading Charts'
  AND lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = FALSE,
  display_order = EXCLUDED.display_order;

DO $$
DECLARE
  lesson_count INTEGER;
  fallback_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO lesson_count
  FROM public.lessons AS lesson
  JOIN public.topics AS topic ON topic.id = lesson.topic_id
  WHERE topic.chapter = 'Reading Trading Charts' AND lesson.is_published = TRUE;

  SELECT COUNT(*) INTO fallback_count
  FROM public.lesson_sources AS link
  JOIN public.lessons AS lesson ON lesson.id = link.lesson_id
  JOIN public.topics AS topic ON topic.id = lesson.topic_id
  JOIN public.sources AS source ON source.id = link.source_id
  WHERE topic.chapter = 'Reading Trading Charts'
    AND lesson.is_published = TRUE
    AND source.source_code IN ('CH08-OJK-CAPITAL', 'CH08-IDX-STOCKS', 'IDX-EDU-001')
    AND source.url IS NOT NULL;

  IF lesson_count <> 8 THEN
    RAISE EXCEPTION 'KO-435 expected 8 published Chapter 10 lessons, found %', lesson_count;
  END IF;
  IF fallback_count <> lesson_count * 3 THEN
    RAISE EXCEPTION 'KO-435 expected 3 URL-bearing fallbacks per lesson, found %', fallback_count;
  END IF;
END $$;

COMMIT;
