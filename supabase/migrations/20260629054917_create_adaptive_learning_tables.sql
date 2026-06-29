-- Migration 012: Adaptive learning tables
-- Lesson triggers and per-user adaptive recommendations.

CREATE TABLE lesson_triggers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  trigger_type TEXT NOT NULL CHECK (trigger_type IN ('trade_behavior','inactivity','milestone','risk_score','portfolio_event')),
  condition_json JSONB NOT NULL,
  priority INTEGER DEFAULT 0,
  max_times_triggered INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_triggers IS 'Rules that trigger adaptive lesson recommendations based on user behavior. Public read.';

CREATE TABLE user_lesson_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id),
  trigger_id UUID REFERENCES lesson_triggers(id),
  reason TEXT NOT NULL,
  dismissed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, lesson_id)
);

COMMENT ON TABLE user_lesson_recommendations IS 'Adaptive lesson recommendations generated for each user. RLS: users read/update own rows only.';

-- RLS: user_lesson_recommendations
ALTER TABLE user_lesson_recommendations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own user_lesson_recommendations"
  ON user_lesson_recommendations FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own user_lesson_recommendations" ON user_lesson_recommendations IS 'Authenticated users can only access their own adaptive lesson recommendations.';
