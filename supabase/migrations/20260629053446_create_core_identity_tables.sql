-- Migration 001: Core identity tables
-- Creates profiles and user_settings tables with RLS.
-- Profiles are linked to Supabase Auth users via auth.users(id).

CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE,
  display_name TEXT NOT NULL,
  avatar_url TEXT,
  age_range TEXT CHECK (age_range IN ('under_16','16_18','19_22','23_25','26_plus')),
  financial_goal TEXT,
  preferred_language TEXT DEFAULT 'id' CHECK (preferred_language IN ('id','en')),
  onboarding_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE profiles IS 'Public-facing user profile linked to Supabase Auth. One row per auth user.';

CREATE TABLE user_settings (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  notifications_enabled BOOLEAN DEFAULT TRUE,
  streak_reminder_time TIME DEFAULT '19:00:00',
  weekly_report_enabled BOOLEAN DEFAULT TRUE,
  show_on_leaderboard BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE user_settings IS 'Per-user app settings and notification preferences.';

-- RLS: users can read/update only their own profile
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

COMMENT ON POLICY "Users can read own profile" ON profiles IS 'Authenticated users can only read their own profile row.';
COMMENT ON POLICY "Users can update own profile" ON profiles IS 'Authenticated users can only update their own profile row.';

-- RLS: users can read/update only their own settings
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own settings"
  ON user_settings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own settings"
  ON user_settings FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users can read own settings" ON user_settings IS 'Authenticated users can only read their own settings row.';
COMMENT ON POLICY "Users can update own settings" ON user_settings IS 'Authenticated users can only update their own settings row.';

-- Trigger: create profile and settings row when a new auth user is created
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name, preferred_language)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email), 'id');

  INSERT INTO public.user_settings (user_id)
  VALUES (NEW.id);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.handle_new_user() IS 'Trigger function to create a profile and settings row for each new Supabase Auth user.';

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
