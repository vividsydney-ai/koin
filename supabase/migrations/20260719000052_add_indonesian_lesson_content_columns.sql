-- Migration 052: Add Indonesian-language content columns to lessons and lesson_versions.
-- This lets the app serve fully Indonesian lessons when the user selects locale "id".

BEGIN;

ALTER TABLE lessons
  ADD COLUMN IF NOT EXISTS summary_id TEXT,
  ADD COLUMN IF NOT EXISTS concept_body_id TEXT,
  ADD COLUMN IF NOT EXISTS why_this_matters_id TEXT,
  ADD COLUMN IF NOT EXISTS common_mistake_id TEXT,
  ADD COLUMN IF NOT EXISTS quiz_data_id JSONB;

ALTER TABLE lesson_versions
  ADD COLUMN IF NOT EXISTS summary_id TEXT,
  ADD COLUMN IF NOT EXISTS concept_body_id TEXT,
  ADD COLUMN IF NOT EXISTS why_this_matters_id TEXT,
  ADD COLUMN IF NOT EXISTS common_mistake_id TEXT,
  ADD COLUMN IF NOT EXISTS quiz_data_id JSONB;

COMMENT ON COLUMN lessons.summary_id IS 'Indonesian translation of summary.';
COMMENT ON COLUMN lessons.concept_body_id IS 'Indonesian translation of concept_body.';
COMMENT ON COLUMN lessons.why_this_matters_id IS 'Indonesian translation of why_this_matters.';
COMMENT ON COLUMN lessons.common_mistake_id IS 'Indonesian translation of common_mistake.';
COMMENT ON COLUMN lessons.quiz_data_id IS 'Indonesian translation of quiz_data (same shape).';

COMMIT;
