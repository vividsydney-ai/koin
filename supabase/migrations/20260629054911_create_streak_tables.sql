-- Migration 006: Streak tables
-- Tracks current streak state and historical streak events per user.

CREATE TABLE streaks (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak_days INTEGER DEFAULT 0,
  longest_streak_days INTEGER DEFAULT 0,
  streak_freezes_available INTEGER DEFAULT 1,
  last_completed_on DATE,
  streak_status TEXT DEFAULT 'active' CHECK (streak_status IN ('active','at_risk','frozen','broken'))
);

COMMENT ON TABLE streaks IS 'Current streak state for each user. RLS: users read/write own row only.';

CREATE TABLE streak_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL CHECK (event_type IN ('preserved','freeze_used','broken','milestone')),
  streak_days_at_event INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE streak_events IS 'Historical streak events (preserved, freeze used, broken, milestone). RLS: users read own rows only.';

-- RLS: users manage own streak row
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own streaks"
  ON streaks FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own streaks" ON streaks IS 'Authenticated users can only access their own streak row.';

-- RLS: users read own streak_events
ALTER TABLE streak_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own streak_events"
  ON streak_events FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own streak_events" ON streak_events IS 'Authenticated users can only read their own streak event rows.';
