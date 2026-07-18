-- Migration 041: Ensure each lesson has at most one primary source.
-- Slice 1 follow-up: the deduplication migration re-pointed sources from
-- deprecated duplicates, which created lessons with multiple is_primary=TRUE rows.

BEGIN;

-- For each lesson with more than one primary source, keep the oldest primary
-- source (lowest source_tier, then earliest id) and demote the rest.
WITH ranked_primary AS (
  SELECT
    ls.id,
    ls.lesson_id,
    ROW_NUMBER() OVER (
      PARTITION BY ls.lesson_id
      ORDER BY s.source_tier ASC, ls.id ASC
    ) AS rnk
  FROM lesson_sources ls
  JOIN sources s ON s.id = ls.source_id
  WHERE ls.is_primary = TRUE
),
to_demote AS (
  SELECT id FROM ranked_primary WHERE rnk > 1
)
UPDATE lesson_sources
SET is_primary = FALSE,
    relevance_type = COALESCE(relevance_type, 'supporting')
WHERE id IN (SELECT id FROM to_demote);

COMMIT;
