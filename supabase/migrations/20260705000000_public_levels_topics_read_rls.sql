-- Migration 018: Public read policies for levels and topics
-- Both are reference tables with no user-specific data and must be readable
-- by authenticated users (and anon during static generation).

ALTER TABLE levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE topics ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read levels" ON levels;
DROP POLICY IF EXISTS "Anon users can read levels" ON levels;
DROP POLICY IF EXISTS "Authenticated users can read topics" ON topics;
DROP POLICY IF EXISTS "Anon users can read topics" ON topics;

CREATE POLICY "Authenticated users can read levels"
  ON levels FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Anon users can read levels"
  ON levels FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Authenticated users can read topics"
  ON topics FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Anon users can read topics"
  ON topics FOR SELECT
  TO anon
  USING (true);
