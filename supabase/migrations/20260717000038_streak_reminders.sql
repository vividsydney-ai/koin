-- Migration: KO-NOTIF-001 Streak reminder emails + in-app notification center
-- Scope: RPC to find candidates, RLS policy to mark notifications read.

BEGIN;

-- 1. Helper RPC: users due a streak reminder email right now.
CREATE OR REPLACE FUNCTION get_streak_reminder_candidates(p_current_time TIME)
RETURNS TABLE (
  user_id UUID,
  email TEXT,
  display_name TEXT,
  current_streak_days INTEGER,
  streak_status TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.id AS user_id,
    u.email::TEXT AS email,
    p.display_name::TEXT AS display_name,
    s.current_streak_days,
    s.streak_status::TEXT
  FROM profiles p
  JOIN auth.users u ON u.id = p.id
  JOIN streaks s ON s.user_id = p.id
  JOIN user_settings us ON us.user_id = p.id
  WHERE us.notifications_enabled = TRUE
    AND us.streak_reminder_time <= p_current_time
    AND s.current_streak_days > 0
    AND s.last_completed_on = CURRENT_DATE - 1
    AND s.streak_status NOT IN ('broken', 'frozen')
    AND NOT EXISTS (
      SELECT 1 FROM notifications_queue nq
      WHERE nq.user_id = p.id
        AND nq.notification_type = 'streak_reminder'
        AND nq.sent_at::DATE = CURRENT_DATE
    );
END;
$$;

COMMENT ON FUNCTION get_streak_reminder_candidates(TIME) IS 'Returns users who should receive a streak reminder email now.';

-- 2. Allow users to mark their own notifications as read.
CREATE POLICY "Users mark own notifications read"
  ON notifications_queue FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users mark own notifications read" ON notifications_queue IS 'Authenticated users can mark only their own notifications as read.';

COMMIT;
