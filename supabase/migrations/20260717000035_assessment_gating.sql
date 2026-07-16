-- Migration: KO-45 assessment gating
-- Scope: store onboarding assessment result and gate the learning path.

BEGIN;

-- 1. Add gating columns to user_settings.
ALTER TABLE user_settings
ADD COLUMN IF NOT EXISTS foundation_zero_required BOOLEAN DEFAULT NULL,
ADD COLUMN IF NOT EXISTS starting_lesson_id UUID REFERENCES lessons(id),
ADD COLUMN IF NOT EXISTS assessment_score INTEGER,
ADD COLUMN IF NOT EXISTS assessment_answers JSONB DEFAULT '[]'::jsonb;

COMMENT ON COLUMN user_settings.foundation_zero_required IS 'True if user must complete Foundation 0 before main track; false to skip Foundation 0.';
COMMENT ON COLUMN user_settings.starting_lesson_id IS 'First lesson shown to user after onboarding.';
COMMENT ON COLUMN user_settings.assessment_score IS 'Onboarding financial literacy assessment raw score.';
COMMENT ON COLUMN user_settings.assessment_answers IS 'Per-question answer correctness from onboarding assessment.';

-- 2. Grandfather existing users who already completed onboarding: default to Foundation 0.
UPDATE user_settings
SET foundation_zero_required = TRUE,
    starting_lesson_id = (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
    assessment_score = 0,
    assessment_answers = '[]'::jsonb
WHERE foundation_zero_required IS NULL
  AND EXISTS (
    SELECT 1 FROM profiles p
    WHERE p.id = user_settings.user_id
      AND p.onboarding_completed = TRUE
  );

-- 3. Ensure user_lesson_recommendations RLS policies exist.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_lesson_recommendations'
      AND policyname = 'Users read own lesson recommendations'
  ) THEN
    CREATE POLICY "Users read own lesson recommendations"
      ON user_lesson_recommendations FOR SELECT
      USING (auth.uid() = user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_lesson_recommendations'
      AND policyname = 'Users dismiss own lesson recommendations'
  ) THEN
    CREATE POLICY "Users dismiss own lesson recommendations"
      ON user_lesson_recommendations FOR UPDATE
      USING (auth.uid() = user_id)
      WITH CHECK (auth.uid() = user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_lesson_recommendations'
      AND policyname = 'Service role insert lesson recommendations'
  ) THEN
    CREATE POLICY "Service role insert lesson recommendations"
      ON user_lesson_recommendations FOR INSERT
      WITH CHECK (true);
  END IF;
END $$;

COMMIT;
