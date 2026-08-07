-- Migration 020: Add INSERT RLS policy for user_settings
--
-- completeTradeOnboarding uses upsert on user_settings. The existing SELECT/UPDATE
-- policies are not enough when the row is missing and upsert falls back to INSERT.
-- This migration adds the missing INSERT policy so users can create their own
-- settings row when the trigger-created row is absent (e.g. legacy accounts or
-- trigger failures).

CREATE POLICY "Users can insert own settings"
  ON user_settings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users can insert own settings" ON user_settings IS 'Authenticated users can only insert their own settings row.';
