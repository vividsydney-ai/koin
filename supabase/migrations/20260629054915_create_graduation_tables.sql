-- Migration 010: Graduation tables
-- Certificates, brokerage recommendations, and user risk profiles.

CREATE TABLE certificates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  certificate_code TEXT UNIQUE NOT NULL,
  portfolio_value_at_graduation NUMERIC(12,2) NOT NULL,
  multiplier_achieved NUMERIC(4,2) NOT NULL,
  issued_at TIMESTAMPTZ DEFAULT NOW(),
  share_public_id TEXT UNIQUE
);

COMMENT ON TABLE certificates IS 'Graduation certificates issued to users. Users read own row; public read allowed via share_public_id only.';

CREATE TABLE brokerage_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  url TEXT NOT NULL,
  logo_url TEXT,
  risk_level TEXT CHECK (risk_level IN ('beginner','intermediate','advanced')),
  ojk_registered BOOLEAN DEFAULT TRUE,
  product_types TEXT[],
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE brokerage_recommendations IS 'Curated brokerage recommendations for graduated users. Public read.';

CREATE TABLE user_risk_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  risk_score INTEGER CHECK (risk_score BETWEEN 1 AND 10),
  risk_label TEXT CHECK (risk_label IN ('conservative','moderate','growth','aggressive')),
  traits_json JSONB,
  recommended_lesson_ids UUID[],
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE user_risk_profiles IS 'User risk tolerance profile and recommended lessons. RLS: users read/update own row only.';

-- RLS: certificates - users read own; public read via share_public_id
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own certificates"
  ON certificates FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own certificates" ON certificates IS 'Authenticated users can read their own certificate row.';

CREATE POLICY "Public read certificates by share id"
  ON certificates FOR SELECT
  USING (share_public_id IS NOT NULL);

COMMENT ON POLICY "Public read certificates by share id" ON certificates IS 'Anyone can read a certificate that has a public share id.';

-- RLS: user_risk_profiles
ALTER TABLE user_risk_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own user_risk_profiles"
  ON user_risk_profiles FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own user_risk_profiles" ON user_risk_profiles IS 'Authenticated users can only access their own risk profile row.';
