-- KO-436: repair published lessons that depended on the blocked OJK planning PDF.
-- The source remains in the catalogue for editorial traceability, but runtime
-- selection must prefer an accessible approved source at the same trust tier.
BEGIN;

UPDATE public.sources
SET status = 'needs_review',
    last_checked_at = NOW(),
    trust_notes = CONCAT(
      COALESCE(trust_notes, ''),
      CASE WHEN COALESCE(trust_notes, '') = '' THEN '' ELSE ' ' END,
      'KO-436 live check: automated request returned HTTP 403; do not present as an accessible link.'
    )
WHERE source_code = 'FZ-OJK-PLANNING';

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.sources WHERE source_code = 'OJK-001' AND source_tier = 1 AND url IS NOT NULL) THEN
    RAISE EXCEPTION 'KO-436 requires accessible Tier 1 fallback OJK-001';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.sources WHERE source_code = 'OJK-003' AND source_tier = 1 AND url IS NOT NULL) THEN
    RAISE EXCEPTION 'KO-436 requires accessible Tier 1 fallback OJK-003';
  END IF;
END $$;

WITH fallback_sources(source_code, relevance_type, citation_label, display_order) AS (
  VALUES
    ('OJK-001', 'supporting', 'OJK: financial-literacy strategy', 20),
    ('OJK-003', 'supporting', 'OJK: publications portal', 30)
)
INSERT INTO public.lesson_sources (
  lesson_id, source_id, relevance_type, citation_label, is_primary, display_order
)
SELECT lesson.id, source.id, fallback.relevance_type, fallback.citation_label, FALSE, fallback.display_order
FROM public.lesson_sources AS existing_link
JOIN public.lessons AS lesson ON lesson.id = existing_link.lesson_id
JOIN public.sources AS existing_source ON existing_source.id = existing_link.source_id
CROSS JOIN fallback_sources AS fallback
JOIN public.sources AS source ON source.source_code = fallback.source_code
WHERE existing_source.source_code = 'FZ-OJK-PLANNING'
  AND lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = FALSE,
  display_order = EXCLUDED.display_order;

DO $$
DECLARE
  affected_lessons INTEGER;
  fallback_links INTEGER;
BEGIN
  SELECT COUNT(DISTINCT existing_link.lesson_id) INTO affected_lessons
  FROM public.lesson_sources AS existing_link
  JOIN public.lessons AS lesson ON lesson.id = existing_link.lesson_id
  JOIN public.sources AS source ON source.id = existing_link.source_id
  WHERE source.source_code = 'FZ-OJK-PLANNING' AND lesson.is_published = TRUE;

  SELECT COUNT(*) INTO fallback_links
  FROM public.lesson_sources AS link
  JOIN public.lessons AS lesson ON lesson.id = link.lesson_id
  JOIN public.sources AS source ON source.id = link.source_id
  WHERE source.source_code IN ('OJK-001', 'OJK-003')
    AND lesson.is_published = TRUE
    AND EXISTS (
      SELECT 1
      FROM public.lesson_sources AS blocked_link
      JOIN public.sources AS blocked_source ON blocked_source.id = blocked_link.source_id
      WHERE blocked_link.lesson_id = lesson.id
        AND blocked_source.source_code = 'FZ-OJK-PLANNING'
    );

  IF affected_lessons <> 17 THEN
    RAISE EXCEPTION 'KO-436 expected 17 lessons using FZ-OJK-PLANNING, found %', affected_lessons;
  END IF;
  IF fallback_links <> affected_lessons * 2 THEN
    RAISE EXCEPTION 'KO-436 expected 2 fallback links per affected lesson, found %', fallback_links;
  END IF;
END $$;

COMMIT;
