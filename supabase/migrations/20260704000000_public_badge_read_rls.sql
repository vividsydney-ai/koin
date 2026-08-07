-- Migration 017: Public read policies for badges
-- Badges are reference/achievement data with no user-specific fields.
-- Ensure authenticated users can read badge details when displaying earned badges.

ALTER TABLE badges ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users can read badges" ON badges;
DROP POLICY IF EXISTS "Anon users can read badges" ON badges;

CREATE POLICY "Authenticated users can read badges"
  ON badges FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Anon users can read badges"
  ON badges FOR SELECT
  TO anon
  USING (true);
