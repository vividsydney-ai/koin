-- Migration 015: Cohort join-by-code RPC

CREATE OR REPLACE FUNCTION join_cohort_by_code(p_user_id UUID, p_invite_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cohort RECORD;
  v_membership_id UUID;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT * INTO v_cohort FROM cohorts WHERE invite_code = p_invite_code;

  IF v_cohort IS NULL THEN
    RAISE EXCEPTION 'Cohort not found';
  END IF;

  INSERT INTO cohort_memberships (cohort_id, user_id)
  VALUES (v_cohort.id, p_user_id)
  ON CONFLICT (cohort_id, user_id) DO NOTHING
  RETURNING id INTO v_membership_id;

  IF v_membership_id IS NULL THEN
    -- User was already a member.
    SELECT id INTO v_membership_id
    FROM cohort_memberships
    WHERE cohort_id = v_cohort.id AND user_id = p_user_id;
  END IF;

  RETURN jsonb_build_object(
    'membership_id', v_membership_id,
    'cohort_id', v_cohort.id,
    'cohort_name', v_cohort.name,
    'already_member', v_membership_id IS NOT NULL
  );
END;
$$;

COMMENT ON FUNCTION join_cohort_by_code(UUID, TEXT) IS 'Join a cohort by invite code.';

GRANT EXECUTE ON FUNCTION join_cohort_by_code(UUID, TEXT) TO authenticated;
