-- Migration 013: Weekly leaderboard RPC
-- Computes top 10 by XP and Koin Points for the current week.
-- Scope: 'global' for all users, 'friends' for accepted friendships.

CREATE OR REPLACE FUNCTION get_weekly_leaderboard(p_user_id UUID, p_scope TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_week_start DATE := DATE_TRUNC('week', CURRENT_DATE)::DATE;
  v_xp_json JSONB;
  v_kp_json JSONB;
BEGIN
  IF p_scope NOT IN ('global', 'friends') THEN
    RAISE EXCEPTION 'Invalid scope. Must be global or friends.';
  END IF;

  WITH eligible_users AS (
    SELECT p.id, COALESCE(p.display_name, 'Learner') AS display_name, p.created_at
    FROM profiles p
    WHERE p_scope = 'global'
       OR (p_scope = 'friends' AND (
         EXISTS (
           SELECT 1 FROM friendships f
           WHERE f.status = 'accepted'
             AND ((f.requester_id = p_user_id AND f.addressee_id = p.id) OR (f.requester_id = p.id AND f.addressee_id = p_user_id))
         )
         OR p.id = p_user_id
       ))
  ),
  xp_totals AS (
    SELECT x.user_id, COALESCE(SUM(x.xp_amount), 0)::INTEGER AS xp_this_week
    FROM xp_events x
    WHERE x.created_at >= v_week_start
    GROUP BY x.user_id
  ),
  ranked_xp AS (
    SELECT
      eu.id AS user_id,
      eu.display_name,
      COALESCE(xt.xp_this_week, 0) AS xp_this_week,
      ROW_NUMBER() OVER (ORDER BY COALESCE(xt.xp_this_week, 0) DESC, eu.created_at ASC) AS rank
    FROM eligible_users eu
    LEFT JOIN xp_totals xt ON xt.user_id = eu.id
  ),
  kp_totals AS (
    SELECT t.user_id, COALESCE(SUM(t.amount), 0)::INTEGER AS kp_this_week
    FROM koin_point_transactions t
    WHERE t.created_at >= v_week_start
    GROUP BY t.user_id
  ),
  ranked_kp AS (
    SELECT
      eu.id AS user_id,
      eu.display_name,
      COALESCE(kt.kp_this_week, 0) AS kp_this_week,
      ROW_NUMBER() OVER (ORDER BY COALESCE(kt.kp_this_week, 0) DESC, eu.created_at ASC) AS rank
    FROM eligible_users eu
    LEFT JOIN kp_totals kt ON kt.user_id = eu.id
  )
  SELECT
    COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'rank', rx.rank,
        'user_id', rx.user_id,
        'display_name', rx.display_name,
        'xp_this_week', rx.xp_this_week,
        'is_current_user', rx.user_id = p_user_id
      ) ORDER BY rx.rank)
      FROM ranked_xp rx
      WHERE rx.rank <= 10
    ), '[]'::jsonb),
    COALESCE((
      SELECT jsonb_agg(jsonb_build_object(
        'rank', rk.rank,
        'user_id', rk.user_id,
        'display_name', rk.display_name,
        'koin_points_this_week', rk.kp_this_week,
        'is_current_user', rk.user_id = p_user_id
      ) ORDER BY rk.rank)
      FROM ranked_kp rk
      WHERE rk.rank <= 10
    ), '[]'::jsonb)
  INTO v_xp_json, v_kp_json;

  RETURN jsonb_build_object(
    'week_start', v_week_start,
    'xp', v_xp_json,
    'koin_points', v_kp_json
  );
END;
$$;

COMMENT ON FUNCTION get_weekly_leaderboard(UUID, TEXT) IS 'Return top 10 weekly leaderboard by XP and Koin Points for global or friends scope.';

GRANT EXECUTE ON FUNCTION get_weekly_leaderboard(UUID, TEXT) TO authenticated;
