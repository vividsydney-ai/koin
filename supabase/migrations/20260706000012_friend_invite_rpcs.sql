-- Migration 012: Friend invite RPCs
-- Generate invite codes and accept them atomically.

CREATE OR REPLACE FUNCTION create_friend_invite(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_invite RECORD;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  INSERT INTO friend_invites (inviter_id)
  VALUES (p_user_id)
  RETURNING * INTO v_invite;

  RETURN jsonb_build_object(
    'invite_id', v_invite.id,
    'invite_code', v_invite.invite_code,
    'uses_count', v_invite.uses_count,
    'max_uses', v_invite.max_uses,
    'expires_at', v_invite.expires_at
  );
END;
$$;

COMMENT ON FUNCTION create_friend_invite(UUID) IS 'Create a new friend invite code for the authenticated user.';

CREATE OR REPLACE FUNCTION accept_friend_invite(p_user_id UUID, p_invite_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_invite RECORD;
  v_existing_friendship INTEGER;
  v_friendship_id UUID;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> p_user_id THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT * INTO v_invite
  FROM friend_invites
  WHERE invite_code = p_invite_code
  FOR UPDATE;

  IF v_invite IS NULL THEN
    RAISE EXCEPTION 'Invalid invite code';
  END IF;

  IF v_invite.inviter_id = p_user_id THEN
    RAISE EXCEPTION 'Cannot accept your own invite code';
  END IF;

  IF v_invite.expires_at < NOW() THEN
    RAISE EXCEPTION 'Invite code expired';
  END IF;

  IF v_invite.uses_count >= v_invite.max_uses THEN
    RAISE EXCEPTION 'Invite code has reached maximum uses';
  END IF;

  -- Check for existing friendship in either direction.
  SELECT COUNT(*) INTO v_existing_friendship
  FROM friendships
  WHERE (requester_id = p_user_id AND addressee_id = v_invite.inviter_id)
     OR (requester_id = v_invite.inviter_id AND addressee_id = p_user_id);

  IF v_existing_friendship > 0 THEN
    RAISE EXCEPTION 'You are already friends with this user';
  END IF;

  -- Create friendship.
  INSERT INTO friendships (requester_id, addressee_id, status)
  VALUES (v_invite.inviter_id, p_user_id, 'accepted')
  RETURNING id INTO v_friendship_id;

  -- Increment invite usage.
  UPDATE friend_invites
  SET uses_count = uses_count + 1
  WHERE id = v_invite.id;

  RETURN jsonb_build_object(
    'friendship_id', v_friendship_id,
    'inviter_id', v_invite.inviter_id,
    'status', 'accepted'
  );
END;
$$;

COMMENT ON FUNCTION accept_friend_invite(UUID, TEXT) IS 'Accept a friend invite code and create a friendship.';

GRANT EXECUTE ON FUNCTION create_friend_invite(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION accept_friend_invite(UUID, TEXT) TO authenticated;
