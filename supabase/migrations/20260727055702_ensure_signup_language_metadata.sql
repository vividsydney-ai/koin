-- Keep the profile locale aligned with the language selected before email
-- confirmation. The same value lives in auth user metadata for Supabase's
-- hosted confirmation template and survives auth.resend(type: 'signup').
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_terms_accepted BOOLEAN;
  v_preferred_language TEXT;
BEGIN
  v_terms_accepted := COALESCE((NEW.raw_user_meta_data->>'terms_accepted')::boolean, false);
  v_preferred_language := CASE NEW.raw_user_meta_data->>'preferred_language'
    WHEN 'id' THEN 'id'
    WHEN 'en' THEN 'en'
    ELSE 'en'
  END;

  INSERT INTO public.profiles (id, display_name, preferred_language)
  VALUES (
    NEW.id,
    COALESCE(NULLIF(BTRIM(NEW.raw_user_meta_data->>'display_name'), ''), NEW.email),
    v_preferred_language
  );

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

COMMENT ON FUNCTION public.handle_new_user() IS 'Creates a profile/settings row using validated signup metadata, including the selected confirmation-email language.';
