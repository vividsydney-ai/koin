-- Migration 005: Learning activity tables
-- Tracks lesson attempts, progress, per-topic mastery, and daily check-ins.
-- All tables are user-private: users can only access their own rows.

CREATE TABLE lesson_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id),
  attempt_number INTEGER DEFAULT 1,
  score INTEGER,
  max_score INTEGER,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  answers_json JSONB,
  ai_help_used_count INTEGER DEFAULT 0,
  time_spent_seconds INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_attempts IS 'Each quiz/lesson attempt by a user. RLS: users read/write own rows only.';

CREATE INDEX idx_lesson_attempts_user_lesson ON lesson_attempts(user_id, lesson_id);

CREATE TABLE lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id),
  status TEXT DEFAULT 'locked' CHECK (status IN ('locked','available','in_progress','completed')),
  best_score INTEGER,
  attempts_count INTEGER DEFAULT 0,
  first_completed_at TIMESTAMPTZ,
  last_attempted_at TIMESTAMPTZ,
  UNIQUE(user_id, lesson_id)
);

COMMENT ON TABLE lesson_progress IS 'Per-user lesson state (locked/available/in_progress/completed). RLS: users read/write own rows only.';

CREATE TABLE user_mastery (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  topic_id UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  mastery_score INTEGER DEFAULT 0 CHECK (mastery_score BETWEEN 0 AND 100),
  lessons_completed INTEGER DEFAULT 0,
  total_lessons INTEGER DEFAULT 0,
  last_updated TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, topic_id)
);

COMMENT ON TABLE user_mastery IS 'Per-topic mastery summary per user. RLS: users read/write own rows only.';

CREATE TABLE daily_checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  checkin_date DATE NOT NULL DEFAULT CURRENT_DATE,
  xp_earned INTEGER DEFAULT 0,
  koin_points_earned INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, checkin_date)
);

COMMENT ON TABLE daily_checkins IS 'Daily learning check-ins per user. RLS: users read/write own rows only.';

-- RLS: users manage own lesson_attempts
ALTER TABLE lesson_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own lesson_attempts"
  ON lesson_attempts FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own lesson_attempts" ON lesson_attempts IS 'Authenticated users can only access their own lesson attempt rows.';

-- RLS: users manage own lesson_progress
ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own lesson_progress"
  ON lesson_progress FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own lesson_progress" ON lesson_progress IS 'Authenticated users can only access their own lesson progress rows.';

-- RLS: users manage own user_mastery
ALTER TABLE user_mastery ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own user_mastery"
  ON user_mastery FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own user_mastery" ON user_mastery IS 'Authenticated users can only access their own mastery rows.';

-- RLS: users manage own daily_checkins
ALTER TABLE daily_checkins ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own daily_checkins"
  ON daily_checkins FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own daily_checkins" ON daily_checkins IS 'Authenticated users can only access their own daily check-in rows.';
