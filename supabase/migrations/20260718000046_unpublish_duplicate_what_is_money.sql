-- Migration 046: Unpublish the older duplicate "What Is Money?" lesson.
-- The Foundation 0 version (fz-what-is-money) remains as the canonical starting lesson.

BEGIN;

UPDATE lessons
SET is_published = FALSE,
    updated_at = NOW()
WHERE slug = 'money-basics-101'
  AND title = 'What Is Money?';

COMMIT;
