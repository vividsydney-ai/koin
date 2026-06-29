-- Migration 007: Gamification tables
-- XP events and user badge awards.

CREATE TABLE xp_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  source_type TEXT NOT NULL CHECK (source_type IN ('lesson_complete','quiz_bonus','streak_milestone','badge','social','first_trade','graduation')),
  source_id UUID,
  xp_amount INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE xp_events IS 'Immutable log of XP awarded to users. RLS: users read own rows only.';

CREATE INDEX idx_xp_events_user_created ON xp_events(user_id, created_at DESC);

CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id),
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);

COMMENT ON TABLE user_badges IS 'Badges earned by each user. RLS: users read own rows only.';

-- RLS: users read own xp_events
ALTER TABLE xp_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own xp_events"
  ON xp_events FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own xp_events" ON xp_events IS 'Authenticated users can only read their own XP event rows.';

-- RLS: users read own user_badges
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own user_badges"
  ON user_badges FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own user_badges" ON user_badges IS 'Authenticated users can only read their own badge awards.';
