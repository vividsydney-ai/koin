-- KO-369 repair: restore the reviewed Chapter 05 source links after the
-- recorded 20260809110000 cleanup migration removed the chapter junction rows.
BEGIN;

WITH links(slug, source_code, relevance_type, is_primary, display_order) AS (VALUES
  ('emergency-fund-101', 'OJK-003', 'primary', TRUE, 10),
  ('emergency-fund-101', 'OJK-004', 'supporting', FALSE, 20),
  ('goal-setting-101', 'OJK-002', 'primary', TRUE, 10),
  ('goal-setting-101', 'OJK-003', 'supporting', FALSE, 20),
  ('building-financial-plan', 'OJK-001', 'primary', TRUE, 10),
  ('building-financial-plan', 'OJK-002', 'supporting', FALSE, 20),
  ('retirement-planning-bpjs-dplk-and-starting-early', 'OJK-001', 'primary', TRUE, 10),
  ('retirement-planning-bpjs-dplk-and-starting-early', 'OJK-003', 'supporting', FALSE, 20),
  ('retirement-planning-start-early-compounding', 'OJK-001', 'primary', TRUE, 10),
  ('retirement-planning-start-early-compounding', 'OJK-003', 'supporting', FALSE, 20)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, links.relevance_type, links.source_code, links.is_primary, links.display_order
FROM links
JOIN public.lessons AS lesson ON lesson.slug = links.slug AND lesson.is_published = TRUE
JOIN public.sources AS source ON source.source_code = links.source_code AND source.url IS NOT NULL
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

COMMIT;
