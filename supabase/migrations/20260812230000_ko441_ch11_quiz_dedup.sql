-- KO-441: Remove duplicate active Chapter 11 applied checks.
-- The original KO-440 insert was replayed once; retain the earliest row for
-- each bilingual question and make the active contract exactly three rows per lesson.
BEGIN;

WITH ranked AS (
  SELECT
    v.id,
    ROW_NUMBER() OVER (
      PARTITION BY v.lesson_id, v.body->>'question', v.body_id->>'question'
      ORDER BY v.created_at ASC, v.id ASC
    ) AS row_number
  FROM public.content_variants v
  JOIN public.lessons l ON l.id=v.lesson_id
  JOIN public.topics t ON t.id=l.topic_id
  WHERE t.chapter='Decision Analysis Lab'
    AND l.is_published
    AND v.variant_type='question'
    AND v.topic_tag='visual_applied'
    AND v.is_active
)
UPDATE public.content_variants v
SET is_active=FALSE
FROM ranked r
WHERE v.id=r.id AND r.row_number>1;

DO $$
DECLARE invalid_count INT;
BEGIN
  SELECT COUNT(*) INTO invalid_count
  FROM (
    SELECT l.id
    FROM public.lessons l
    JOIN public.topics t ON t.id=l.topic_id
    LEFT JOIN public.content_variants v
      ON v.lesson_id=l.id
      AND v.variant_type='question'
      AND v.topic_tag='visual_applied'
      AND v.is_active
    WHERE t.chapter='Decision Analysis Lab' AND l.is_published
    GROUP BY l.id
    HAVING COUNT(v.id)<>3 OR COUNT(DISTINCT v.body->>'question')<>3 OR COUNT(DISTINCT v.body_id->>'question')<>3
  ) invalid;
  IF invalid_count<>0 THEN
    RAISE EXCEPTION 'KO-441 applied-check coverage mismatch: % lessons', invalid_count;
  END IF;
END $$;

COMMIT;
