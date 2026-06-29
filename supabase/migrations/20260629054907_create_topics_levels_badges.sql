-- Migration 002: Topics, levels, and badges
-- Public reference tables for curriculum structure and achievements.
-- No RLS required: these tables contain no user data and are globally readable.

CREATE TABLE topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  icon TEXT,
  color TEXT,
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE topics IS 'Curriculum topics (e.g. money basics, investing, risk). Public read.';

CREATE TABLE levels (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  xp_required INTEGER NOT NULL,
  badge_icon TEXT,
  description TEXT
);

COMMENT ON TABLE levels IS 'XP-based user levels. Public read.';

CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  description TEXT,
  description_id TEXT,
  icon TEXT NOT NULL,
  trigger_type TEXT NOT NULL,
  trigger_value JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE badges IS 'Achievement badges awarded for milestones. Public read.';
