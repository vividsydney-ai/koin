-- KO-376: complete the missing Tier 1 primary-source junctions for the
-- published Foundation lessons omitted by the earlier bulk source migration.

WITH links(slug, source_code, citation_label) AS (
  VALUES
    ('fz-assets-vs-liabilities', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-debt', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-emergency-fund', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-inflation', 'FZ-BI-INFLATION', 'Bank Indonesia: inflation explainer'),
    ('fz-interest', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-needs-vs-wants', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-return', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-risk', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-saving-vs-investing', 'FZ-OJK-PLANNING', 'OJK: financial planning guide'),
    ('fz-scam-red-flags', 'FZ-OJK-WASPADA', 'OJK: Waspada Investasi FAQ'),
    ('fz-what-is-money', 'FZ-OJK-PLANNING', 'OJK: financial planning guide')
)
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
  links.citation_label,
  TRUE,
  5
FROM links
JOIN public.lessons AS lesson ON lesson.slug = links.slug
JOIN public.sources AS source ON source.source_code = links.source_code
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;
