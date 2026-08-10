-- KO-377: `parameters` is reserved for numeric substitution specs in the
-- lesson validator. Earlier visual metadata stored a string at parameters.visual,
-- making every affected quiz payload invalid at runtime.

BEGIN;

UPDATE public.content_variants AS variant
SET
  body = jsonb_set(variant.body, '{parameters}', (variant.body -> 'parameters') - 'visual'),
  body_id = CASE
    WHEN variant.body_id IS NULL THEN NULL
    ELSE jsonb_set(variant.body_id, '{parameters}', (variant.body_id -> 'parameters') - 'visual')
  END
FROM public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'retirement-planning-start-early-compounding'
  AND lesson.is_published = TRUE
  AND variant.variant_type = 'question'
  AND jsonb_typeof(variant.body -> 'parameters' -> 'visual') = 'string';

UPDATE public.lessons AS lesson
SET
  quiz_data = (
    SELECT jsonb_agg(question - 'parameters' ORDER BY position)
    FROM jsonb_array_elements(lesson.quiz_data) WITH ORDINALITY AS questions(question, position)
  ),
  quiz_data_id = (
    SELECT jsonb_agg(question - 'parameters' ORDER BY position)
    FROM jsonb_array_elements(lesson.quiz_data_id) WITH ORDINALITY AS questions(question, position)
  ),
  updated_at = NOW()
WHERE lesson.slug = 'retirement-planning-start-early-compounding'
  AND lesson.is_published = TRUE
  AND EXISTS (
    SELECT 1
    FROM jsonb_array_elements(lesson.quiz_data) AS questions(question)
    WHERE jsonb_typeof(question -> 'parameters' -> 'visual') = 'string'
  );

COMMIT;
