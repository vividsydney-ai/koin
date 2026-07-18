-- Migration 050: Add locale preference to user_settings
--
-- Backs the global English/Indonesian language picker. The LocaleProvider
-- reads and upserts this column; default is English.

ALTER TABLE user_settings
  ADD COLUMN IF NOT EXISTS locale TEXT NOT NULL DEFAULT 'en';

ALTER TABLE user_settings
  DROP CONSTRAINT IF EXISTS user_settings_locale_check;

ALTER TABLE user_settings
  ADD CONSTRAINT user_settings_locale_check CHECK (locale IN ('en', 'id'));

COMMENT ON COLUMN user_settings.locale IS 'UI locale preference: en (English) or id (Bahasa Indonesia).';
