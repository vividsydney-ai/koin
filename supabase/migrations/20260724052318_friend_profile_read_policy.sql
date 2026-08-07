-- Migration: Allow users to read the profiles of their friends.
--
-- The base profiles table only allowed a user to read their own row. When the
-- friend list embedded the other user's profile via the friendships foreign
-- keys, RLS blocked the read and the UI fell back to "Unknown". This policy
-- lets a user read the id, display_name, and avatar_url of anyone they are
-- connected to through a friendship row (requester or addressee).

CREATE POLICY "Users can read friend profiles"
  ON profiles FOR SELECT
  USING (
    auth.uid() = id
    OR EXISTS (
      SELECT 1 FROM friendships
      WHERE (
        (requester_id = auth.uid() AND addressee_id = profiles.id)
        OR (addressee_id = auth.uid() AND requester_id = profiles.id)
      )
    )
  );

COMMENT ON POLICY "Users can read friend profiles" ON profiles IS 'Authenticated users can read the profiles of users they are friends with.';
