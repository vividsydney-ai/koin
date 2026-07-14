-- Migration 023: Add onboarding assessment fields to profiles
-- Tracks financial literacy level and whether the onboarding diagnostic has been completed.

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS financial_literacy_level TEXT CHECK (financial_literacy_level IN ('beginner', 'intermediate', 'advanced')) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS onboarding_assessment_completed BOOLEAN DEFAULT FALSE;

COMMENT ON COLUMN profiles.financial_literacy_level IS 'Bucketed result of the onboarding financial literacy diagnostic: beginner, intermediate, or advanced.';
COMMENT ON COLUMN profiles.onboarding_assessment_completed IS 'Whether the user has completed the onboarding financial literacy assessment.';
