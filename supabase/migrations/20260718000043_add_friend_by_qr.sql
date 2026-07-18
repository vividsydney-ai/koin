-- Migration 043: Add friend by QR code
-- Replaces the invite-code flow with a scan-to-add mutual friendship RPC.

BEGIN;

CREATE OR REPLACE FUNCTION add_friend_by_qr(p_scanned_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_current_user_id UUID;
  v_friendship RECORD;
BEGIN
  v_current_user_id := auth.uid();

  IF v_current_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authenticated' USING ERRCODE = 'insufficient_privilege';
  END IF;

  IF p_scanned_user_id = v_current_user_id THEN
    RAISE EXCEPTION 'Cannot add yourself as a friend' USING ERRCODE = 'check_violation';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = p_scanned_user_id) THEN
    RAISE EXCEPTION 'User not found' USING ERRCODE = 'foreign_key_violation';
  END IF;

  -- Idempotent: return existing friendship in either direction.
  SELECT * INTO v_friendship
  FROM friendships
  WHERE (requester_id = v_current_user_id AND addressee_id = p_scanned_user_id)
     OR (requester_id = p_scanned_user_id AND addressee_id = v_current_user_id)
  LIMIT 1;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'friendship_id', v_friendship.id,
      'status', v_friendship.status
    );
  END IF;

  INSERT INTO friendships (requester_id, addressee_id, status)
  VALUES (v_current_user_id, p_scanned_user_id, 'accepted')
  RETURNING * INTO v_friendship;

  RETURN jsonb_build_object(
    'friendship_id', v_friendship.id,
    'status', v_friendship.status
  );
END;
$$;

COMMENT ON FUNCTION add_friend_by_qr(UUID) IS 'Create a mutual friendship after scanning another user''s QR code. Idempotent; no self-friend.';

GRANT EXECUTE ON FUNCTION add_friend_by_qr(UUID) TO authenticated;

COMMIT;
