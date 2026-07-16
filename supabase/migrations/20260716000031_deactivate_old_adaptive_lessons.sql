-- Migration: KO-CURR-001 follow-up
-- Deactivate legacy adaptive lessons that are outside the v2.0 curriculum map.
-- These were replaced by foundation-first lessons and Pro teaser content.

UPDATE lessons
SET is_published = FALSE, review_status = 'draft', updated_at = NOW()
WHERE slug IN (
  'loss-aversion-101',
  'confidence-101',
  'volatility-101'
);
