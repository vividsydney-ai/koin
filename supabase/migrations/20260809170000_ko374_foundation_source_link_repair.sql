-- KO-374: restore the required Tier 1 primary source for a published
-- Foundation lesson. This is idempotent and preserves any existing link.

INSERT INTO public.lesson_sources (
  lesson_id,
  source_id,
  relevance_type,
  citation_label,
  is_primary,
  display_order
)
SELECT
  lesson.id,
  source.id,
  'primary',
  'OJK: financial planning guide',
  TRUE,
  5
FROM public.lessons AS lesson
JOIN public.sources AS source ON source.source_code = 'FZ-OJK-PLANNING'
WHERE lesson.slug = 'fz-income-vs-wealth'
  AND lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;
