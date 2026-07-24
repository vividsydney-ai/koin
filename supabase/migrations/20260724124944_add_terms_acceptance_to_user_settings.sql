-- Migration: add terms/privacy acceptance tracking to user_settings
-- Existing users are grandfathered (NULL == accepted before tracking existed).

ALTER TABLE user_settings
  ADD COLUMN IF NOT EXISTS terms_accepted_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS privacy_accepted_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS terms_version TEXT,
  ADD COLUMN IF NOT EXISTS privacy_version TEXT;

COMMENT ON COLUMN user_settings.terms_accepted_at IS 'Timestamp when the user accepted the Terms of Service.';
COMMENT ON COLUMN user_settings.privacy_accepted_at IS 'Timestamp when the user accepted the Privacy Policy.';
COMMENT ON COLUMN user_settings.terms_version IS 'Version/date identifier of the accepted Terms of Service.';
COMMENT ON COLUMN user_settings.privacy_version IS 'Version/date identifier of the accepted Privacy Policy.';

-- Update the new-user trigger to persist legal acceptance from signup metadata.
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_terms_accepted BOOLEAN;
BEGIN
  v_terms_accepted := COALESCE((NEW.raw_user_meta_data->>'terms_accepted')::boolean, false);

  INSERT INTO public.profiles (id, display_name, preferred_language)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email), 'id');

  INSERT INTO public.user_settings (
    user_id,
    terms_accepted_at,
    privacy_accepted_at,
    terms_version,
    privacy_version
  )
  VALUES (
    NEW.id,
    CASE WHEN v_terms_accepted THEN NOW() ELSE NULL END,
    CASE WHEN v_terms_accepted THEN NOW() ELSE NULL END,
    CASE WHEN v_terms_accepted THEN COALESCE(NEW.raw_user_meta_data->>'terms_version', '2026-07-24') ELSE NULL END,
    CASE WHEN v_terms_accepted THEN COALESCE(NEW.raw_user_meta_data->>'privacy_version', '2026-07-24') ELSE NULL END
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
