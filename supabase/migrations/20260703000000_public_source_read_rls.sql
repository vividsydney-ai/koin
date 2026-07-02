-- Migration 016: Public read policies for sources and lesson_sources
-- These tables are intentionally world-readable reference data, but RLS
-- may have been enabled without policies during earlier setup. This
-- migration ensures authenticated users can read source cards in the
-- lesson player while preserving the read-only intent.

-- Ensure RLS is enabled on both tables.
ALTER TABLE sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_sources ENABLE ROW LEVEL SECURITY;

-- Drop any existing policies with the same names before recreating.
DROP POLICY IF EXISTS "Authenticated users can read sources" ON sources;
DROP POLICY IF EXISTS "Anon users can read sources" ON sources;
DROP POLICY IF EXISTS "Authenticated users can read lesson_sources" ON lesson_sources;
DROP POLICY IF EXISTS "Anon users can read lesson_sources" ON lesson_sources;

-- Allow authenticated users to read all sources.
CREATE POLICY "Authenticated users can read sources"
  ON sources FOR SELECT
  TO authenticated
  USING (true);

-- Allow anon users to read all sources (used during static generation).
CREATE POLICY "Anon users can read sources"
  ON sources FOR SELECT
  TO anon
  USING (true);

-- Allow authenticated users to read lesson_source junction rows.
CREATE POLICY "Authenticated users can read lesson_sources"
  ON lesson_sources FOR SELECT
  TO authenticated
  USING (true);

-- Allow anon users to read lesson_source junction rows (used during static generation).
CREATE POLICY "Anon users can read lesson_sources"
  ON lesson_sources FOR SELECT
  TO anon
  USING (true);
