-- Deactivate duplicate content variants that share the same body text within a
-- lesson and variant type. Keeps the oldest variant active. This fixes the
-- "Lihat contoh lain" bug where the button stayed visible because duplicate IDs
-- pointed to the same example text.
--
-- Affected lessons from production audit:
--   - What Is Money? (Foundation 0)
--   - What Is Inflation?
--   - What Is Interest?

WITH ranked AS (
  SELECT
    id,
    ROW_NUMBER() OVER (
      PARTITION BY
        lesson_id,
        variant_type,
        CASE variant_type
          WHEN 'example' THEN body ->> 'text'
          WHEN 'explanation' THEN body ->> 'text'
          WHEN 'question' THEN body ->> 'question'
          ELSE body::text
        END
      ORDER BY created_at ASC, id ASC
    ) AS rn
  FROM content_variants
  WHERE is_active = true
    AND (
      (variant_type IN ('example', 'explanation') AND NULLIF(TRIM(body ->> 'text'), '') IS NOT NULL)
      OR (variant_type = 'question' AND NULLIF(TRIM(body ->> 'question'), '') IS NOT NULL)
    )
)
UPDATE content_variants
SET is_active = false
WHERE id IN (
  SELECT id FROM ranked WHERE rn > 1
);
