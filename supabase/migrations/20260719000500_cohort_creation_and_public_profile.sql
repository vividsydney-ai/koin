-- Migration 050: Cohort creation + public profile lookup + subscription tier
-- Adds the ability for users to create cohorts (1 free, Pro for more) and exposes
-- a safe public-profile RPC so friend-invite deep links can show a user card.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Subscription tier on profiles (used for Pro gating)
-- ---------------------------------------------------------------------------
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS subscription_tier TEXT NOT NULL DEFAULT 'free'
CHECK (subscription_tier IN ('free', 'pro'));

COMMENT ON COLUMN profiles.subscription_tier IS 'Subscription tier: free or pro. Used to gate cohort creation and future premium features.';

-- ---------------------------------------------------------------------------
-- 2. Public profile lookup RPC (safe, no private fields)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_public_profile(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_profile RECORD;
BEGIN
  SELECT id, display_name, avatar_url, subscription_tier INTO v_profile
  FROM profiles
  WHERE id = p_user_id;

  IF v_profile IS NULL THEN
    RETURN NULL;
  END IF;

  RETURN jsonb_build_object(
    'id', v_profile.id,
    'display_name', v_profile.display_name,
    'avatar_url', v_profile.avatar_url,
    'subscription_tier', v_profile.subscription_tier
  );
END;
$$;

COMMENT ON FUNCTION get_public_profile(UUID) IS 'Return a small public profile for invite cards and deep-link accept pages.';

GRANT EXECUTE ON FUNCTION get_public_profile(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_public_profile(UUID) TO anon;

-- ---------------------------------------------------------------------------
-- 3. Cohort creation RPC (1 free, Pro for more)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_cohort(p_user_id UUID, p_name TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_creator RECORD;
  v_created_count INTEGER;
  v_invite_code TEXT;
  v_cohort_id UUID;
  v_membership_id UUID;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF p_name IS NULL OR length(trim(p_name)) = 0 THEN
    RAISE EXCEPTION 'Cohort name is required' USING ERRCODE = 'check_violation';
  END IF;

  SELECT subscription_tier INTO v_creator
  FROM profiles
  WHERE id = p_user_id;

  IF v_creator IS NULL THEN
    RAISE EXCEPTION 'User not found' USING ERRCODE = 'foreign_key_violation';
  END IF;

  -- Free users can create 1 cohort; Pro users can create up to 50.
  SELECT COUNT(*) INTO v_created_count
  FROM cohorts
  WHERE created_by = p_user_id;

  IF v_created_count >= 1 AND v_creator.subscription_tier <> 'pro' THEN
    RAISE EXCEPTION 'Free users can create only 1 cohort. Upgrade to Pro to create more.' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF v_created_count >= 50 THEN
    RAISE EXCEPTION 'Cohort limit reached' USING ERRCODE = 'insufficient_privilege';
  END IF;

  -- Generate a unique 8-character invite code.
  LOOP
    v_invite_code := upper(substr(md5(random()::text), 1, 8));
    EXIT WHEN NOT EXISTS (SELECT 1 FROM cohorts WHERE invite_code = v_invite_code);
  END LOOP;

  INSERT INTO cohorts (name, invite_code, created_by)
  VALUES (trim(p_name), v_invite_code, p_user_id)
  RETURNING id INTO v_cohort_id;

  INSERT INTO cohort_memberships (cohort_id, user_id)
  VALUES (v_cohort_id, p_user_id)
  RETURNING id INTO v_membership_id;

  RETURN jsonb_build_object(
    'cohort_id', v_cohort_id,
    'name', trim(p_name),
    'invite_code', v_invite_code,
    'membership_id', v_membership_id
  );
END;
$$;

COMMENT ON FUNCTION create_cohort(UUID, TEXT) IS 'Create a new cohort. Free users can create 1; Pro users up to 50. Creator is auto-added as member.';

GRANT EXECUTE ON FUNCTION create_cohort(UUID, TEXT) TO authenticated;

-- Allow creators to read/update their own cohorts (join code lookup already public).
CREATE POLICY "Users manage own cohorts"
  ON cohorts FOR ALL
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

COMMENT ON POLICY "Users manage own cohorts" ON cohorts IS 'Authenticated users can read/update/delete cohorts they created.';

COMMIT;
