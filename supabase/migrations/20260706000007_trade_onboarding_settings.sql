-- Migration 025: Add trade onboarding completion flag to user_settings

ALTER TABLE user_settings
ADD COLUMN IF NOT EXISTS trade_onboarding_completed BOOLEAN DEFAULT FALSE;

COMMENT ON COLUMN user_settings.trade_onboarding_completed IS 'Whether the user has completed the Trade tab onboarding flow.';
