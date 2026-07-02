-- Migration 008: Streak check-in RPC
-- Atomically processes a daily check-in, applying freeze or break rules.

CREATE OR REPLACE FUNCTION check_in_streak(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_record streaks%ROWTYPE;
  v_today DATE := CURRENT_DATE;
  v_last DATE;
  v_gap INTEGER;
  v_used_freeze BOOLEAN := false;
  v_broken BOOLEAN := false;
  v_already_checked_in BOOLEAN := false;
BEGIN
  SELECT * INTO v_record FROM streaks WHERE user_id = p_user_id FOR UPDATE;

  IF NOT FOUND THEN
    INSERT INTO streaks (user_id, current_streak_days, longest_streak_days, streak_freezes_available, last_completed_on, streak_status)
    VALUES (p_user_id, 1, 1, 1, v_today, 'active');

    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'preserved', 1);

    RETURN jsonb_build_object(
      'current_streak_days', 1,
      'longest_streak_days', 1,
      'streak_status', 'active',
      'used_freeze', false,
      'broken', false,
      'already_checked_in', false
    );
  END IF;

  v_last := v_record.last_completed_on;

  IF v_last = v_today THEN
    RETURN jsonb_build_object(
      'current_streak_days', v_record.current_streak_days,
      'longest_streak_days', v_record.longest_streak_days,
      'streak_status', v_record.streak_status,
      'used_freeze', false,
      'broken', false,
      'already_checked_in', true
    );
  END IF;

  v_gap := v_today - v_last;

  IF v_gap = 1 THEN
    v_record.current_streak_days := v_record.current_streak_days + 1;
    v_record.streak_status := 'active';
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'preserved', v_record.current_streak_days);
  ELSIF v_gap > 1 AND v_record.streak_freezes_available > 0 THEN
    v_record.streak_freezes_available := v_record.streak_freezes_available - 1;
    v_record.streak_status := 'frozen';
    v_used_freeze := true;
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'freeze_used', v_record.current_streak_days);
  ELSE
    v_record.current_streak_days := 1;
    v_record.streak_status := 'broken';
    v_broken := true;
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'broken', 1);
  END IF;

  v_record.last_completed_on := v_today;

  IF v_record.current_streak_days > v_record.longest_streak_days THEN
    v_record.longest_streak_days := v_record.current_streak_days;
  END IF;

  UPDATE streaks
  SET current_streak_days = v_record.current_streak_days,
      longest_streak_days = v_record.longest_streak_days,
      streak_freezes_available = v_record.streak_freezes_available,
      last_completed_on = v_record.last_completed_on,
      streak_status = v_record.streak_status
  WHERE user_id = p_user_id;

  RETURN jsonb_build_object(
    'current_streak_days', v_record.current_streak_days,
    'longest_streak_days', v_record.longest_streak_days,
    'streak_status', v_record.streak_status,
    'used_freeze', v_used_freeze,
    'broken', v_broken,
    'already_checked_in', false
  );
END;
$$;

COMMENT ON FUNCTION check_in_streak(UUID) IS 'Process a daily streak check-in for a user, applying freeze/break rules atomically.';

-- Helper to recompute streak_status for users who have not checked in today.
-- Called by a nightly job or on-demand; does not mutate streak days, only status.
CREATE OR REPLACE FUNCTION recompute_streak_status(p_user_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_record streaks%ROWTYPE;
  v_today DATE := CURRENT_DATE;
  v_gap INTEGER;
BEGIN
  SELECT * INTO v_record FROM streaks WHERE user_id = p_user_id FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('status', 'missing');
  END IF;

  IF v_record.last_completed_on = v_today THEN
    IF v_record.streak_status <> 'active' THEN
      UPDATE streaks SET streak_status = 'active' WHERE user_id = p_user_id;
    END IF;
    RETURN jsonb_build_object('status', 'active');
  END IF;

  v_gap := v_today - v_record.last_completed_on;

  IF v_gap = 1 THEN
    IF v_record.streak_status <> 'at_risk' THEN
      UPDATE streaks SET streak_status = 'at_risk' WHERE user_id = p_user_id;
    END IF;
    RETURN jsonb_build_object('status', 'at_risk');
  END IF;

  -- Gap > 1 means the streak is already broken unless a freeze was used today.
  -- check_in_streak handles the break/freeze decision, so here we just mark broken
  -- if it is not already frozen/broken and no freeze remains.
  IF v_record.streak_status NOT IN ('broken', 'frozen') AND v_record.streak_freezes_available = 0 THEN
    UPDATE streaks SET streak_status = 'broken' WHERE user_id = p_user_id;
    INSERT INTO streak_events (user_id, event_type, streak_days_at_event)
    VALUES (p_user_id, 'broken', v_record.current_streak_days)
    ON CONFLICT DO NOTHING;
    RETURN jsonb_build_object('status', 'broken');
  END IF;

  RETURN jsonb_build_object('status', v_record.streak_status);
END;
$$;

COMMENT ON FUNCTION recompute_streak_status(UUID) IS 'Recompute the visual streak status for a user based on the current date without changing streak days.';
