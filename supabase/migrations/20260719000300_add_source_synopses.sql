-- KO-LESSON-004: Add short tl;dr synopses + relevance blurbs to sources.
ALTER TABLE sources
  ADD COLUMN IF NOT EXISTS synopsis TEXT,
  ADD COLUMN IF NOT EXISTS synopsis_id TEXT,
  ADD COLUMN IF NOT EXISTS relevance_blurb TEXT,
  ADD COLUMN IF NOT EXISTS relevance_blurb_id TEXT;
