-- Migration: KO-FOUND-002 Publish Foundation 0 mini-track
-- Scope: make the 12 Money Dictionary micro-lessons visible now that assessment gating is wired.
-- Idempotency: unconditional UPDATE on the fz-% slug pattern.

BEGIN;

UPDATE lessons
SET is_published = TRUE,
    updated_at = NOW()
WHERE slug LIKE 'fz-%';

COMMIT;
