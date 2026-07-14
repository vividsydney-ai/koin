-- Migration: KO-44 deactivate low-quality, repeated, and duplicate lesson variants
-- Scope: 5 beginner launch lessons only. Behavioral lessons are left untouched.
-- Idempotency: UPDATE filters on is_active = TRUE, so re-running has no effect.

BEGIN;

WITH launch_lessons AS (
  SELECT id
  FROM lessons
  WHERE slug IN (
    'money-basics-101',
    'inflation-101',
    'budgeting-101',
    'risk-return-101',
    'idx-basics-101'
  )
)
UPDATE content_variants cv
SET is_active = FALSE
WHERE cv.is_active = TRUE
  AND cv.lesson_id IN (SELECT id FROM launch_lessons)
  AND (
    -- 1. Templated example pattern: "Example: ... This illustrates how..."
    (
      cv.variant_type = 'example'
      AND cv.body->>'text' ILIKE 'Example:%'
      AND cv.body->>'text' ILIKE '%This illustrates how%'
    )
    -- 2. Templated explanation pattern: "... is a fundamental concept ... every financially literate person ..."
    OR (
      cv.variant_type = 'explanation'
      AND cv.body->>'text' ILIKE '%is a fundamental concept in%'
      AND cv.body->>'text' ILIKE '%every financially literate person should understand%'
    )
    -- 3a. Garbage answer: "Check OJK license" on questions unrelated to OJK
    OR (
      cv.variant_type = 'question'
      AND cv.body->>'answer' = 'Check OJK license'
      AND cv.body->>'question' NOT ILIKE '%OJK%'
    )
    -- 3b. Garbage answer: "Possible loss of capital" on questions unrelated to risk
    OR (
      cv.variant_type = 'question'
      AND cv.body->>'answer' = 'Possible loss of capital'
      AND cv.body->>'question' NOT ILIKE '%risk%'
    )
    -- 3c. Garbage answer: "A fundamental financial concept"
    OR (
      cv.variant_type = 'question'
      AND cv.body->>'answer' = 'A fundamental financial concept'
    )
    -- 3d. Garbage answer: "Everyone managing money"
    OR (
      cv.variant_type = 'question'
      AND cv.body->>'answer' = 'Everyone managing money'
    )
    -- 4. Lottery-ticket distractor present in options
    OR (
      cv.variant_type = 'question'
      AND cv.body->'options' @> '["Buying lottery tickets"]'::jsonb
    )
    -- 5. Generic true/false explanations without substantive teaching
    OR (
      cv.variant_type = 'question'
      AND cv.body->>'explanation' IN ('This statement is correct.', 'This statement is incorrect.')
    )
    -- 6. Exact duplicate question text per lesson (keep the lowest id, deactivate the rest)
    OR cv.id IN (
      SELECT id
      FROM (
        SELECT
          id,
          ROW_NUMBER() OVER (
            PARTITION BY lesson_id, body->>'question'
            ORDER BY id
          ) AS rn
        FROM content_variants
        WHERE variant_type = 'question'
          AND is_active = TRUE
          AND lesson_id IN (SELECT id FROM launch_lessons)
      ) sub
      WHERE rn > 1
    )
  );

COMMIT;
