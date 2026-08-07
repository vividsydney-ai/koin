-- Migration: Cohort Pro limit = 10 + invite accepted friends to cohort
-- The earlier 20260719000500 migration set Pro limit to 50. This migration
-- tightens it to 10 and adds a direct friend-invite RPC.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Tighten Pro cohort creation limit from 50 to 10
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

  -- Free users can create 1 cohort; Pro users can create up to 10.
  SELECT COUNT(*) INTO v_created_count
  FROM cohorts
  WHERE created_by = p_user_id;

  IF v_created_count >= 1 AND v_creator.subscription_tier <> 'pro' THEN
    RAISE EXCEPTION 'Free users can create only 1 cohort. Upgrade to Pro to create more.' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF v_created_count >= 10 THEN
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

COMMENT ON FUNCTION create_cohort(UUID, TEXT) IS 'Create a new cohort. Free users can create 1; Pro users up to 10. Creator is auto-added as member.';

GRANT EXECUTE ON FUNCTION create_cohort(UUID, TEXT) TO authenticated;

-- ---------------------------------------------------------------------------
-- 2. Invite an accepted friend directly into a cohort
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION invite_friend_to_cohort(
  p_user_id UUID,
  p_friend_id UUID,
  p_cohort_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cohort RECORD;
  v_friendship RECORD;
  v_membership_id UUID;
  v_already_member BOOLEAN := false;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  -- Only the cohort creator can invite friends directly.
  SELECT id, created_by INTO v_cohort
  FROM cohorts
  WHERE id = p_cohort_id;

  IF v_cohort IS NULL THEN
    RAISE EXCEPTION 'Cohort not found' USING ERRCODE = 'foreign_key_violation';
  END IF;

  IF v_cohort.created_by <> p_user_id THEN
    RAISE EXCEPTION 'Only the cohort creator can invite friends' USING ERRCODE = 'insufficient_privilege';
  END IF;

  -- Verify an accepted friendship exists between the two users.
  SELECT id INTO v_friendship
  FROM friendships
  WHERE status = 'accepted'
    AND (
      (requester_id = p_user_id AND addressee_id = p_friend_id)
      OR (requester_id = p_friend_id AND addressee_id = p_user_id)
    )
  LIMIT 1;

  IF v_friendship IS NULL THEN
    RAISE EXCEPTION 'You can only invite accepted friends' USING ERRCODE = 'insufficient_privilege';
  END IF;

  -- Idempotent add.
  SELECT id INTO v_membership_id
  FROM cohort_memberships
  WHERE cohort_id = p_cohort_id AND user_id = p_friend_id;

  IF v_membership_id IS NOT NULL THEN
    v_already_member := true;
  ELSE
    INSERT INTO cohort_memberships (cohort_id, user_id)
    VALUES (p_cohort_id, p_friend_id)
    RETURNING id INTO v_membership_id;
  END IF;

  RETURN jsonb_build_object(
    'membership_id', v_membership_id,
    'already_member', v_already_member
  );
END;
$$;

COMMENT ON FUNCTION invite_friend_to_cohort(UUID, UUID, UUID) IS 'Cohort creator invites an accepted friend to join their cohort. Idempotent.';

GRANT EXECUTE ON FUNCTION invite_friend_to_cohort(UUID, UUID, UUID) TO authenticated;

COMMIT;
