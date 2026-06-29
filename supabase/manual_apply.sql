-- Migration 002: Topics, levels, and badges
-- Public reference tables for curriculum structure and achievements.
-- No RLS required: these tables contain no user data and are globally readable.

CREATE TABLE topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  icon TEXT,
  color TEXT,
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE topics IS 'Curriculum topics (e.g. money basics, investing, risk). Public read.';

CREATE TABLE levels (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  xp_required INTEGER NOT NULL,
  badge_icon TEXT,
  description TEXT
);

COMMENT ON TABLE levels IS 'XP-based user levels. Public read.';

CREATE TABLE badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  description TEXT,
  description_id TEXT,
  icon TEXT NOT NULL,
  trigger_type TEXT NOT NULL,
  trigger_value JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE badges IS 'Achievement badges awarded for milestones. Public read.';
-- Migration 003: Content tables
-- Creates lessons, lesson versioning, sources, media, and recommended resources.
-- Lessons are public only when is_published = true; all other content tables are public read.

CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  topic_id UUID REFERENCES topics(id),
  lesson_number INTEGER UNIQUE NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner','intermediate','advanced')),
  xp_reward INTEGER NOT NULL DEFAULT 50,
  estimated_minutes INTEGER DEFAULT 5,
  summary TEXT,
  concept_body TEXT,
  indonesian_example TEXT,
  why_this_matters TEXT,
  common_mistake TEXT,
  quiz_data JSONB,
  ai_assist_context TEXT,
  review_status TEXT DEFAULT 'not_started'
    CHECK (review_status IN ('not_started','draft','needs_review','approved','live')),
  reviewed_by TEXT,
  reviewed_at TIMESTAMPTZ,
  is_published BOOLEAN DEFAULT FALSE,
  jurisdiction TEXT DEFAULT 'ID',
  prerequisite_lesson_id UUID REFERENCES lessons(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lessons IS 'Core lesson content. Public read only where is_published = true.';

CREATE TABLE lesson_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  summary TEXT,
  concept_body TEXT,
  indonesian_example TEXT,
  why_this_matters TEXT,
  common_mistake TEXT,
  quiz_data JSONB,
  ai_assist_context TEXT,
  review_status TEXT DEFAULT 'not_started'
    CHECK (review_status IN ('not_started','draft','needs_review','approved','live')),
  reviewed_by TEXT,
  reviewed_at TIMESTAMPTZ,
  is_published BOOLEAN DEFAULT FALSE,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lesson_id, version_number)
);

COMMENT ON TABLE lesson_versions IS 'Historical versions of lesson content for audit and rollback. Admin write; public read where published.';

CREATE TABLE sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_code TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  local_title TEXT,
  source_tier INTEGER NOT NULL CHECK (source_tier IN (1,2,3)),
  source_type TEXT NOT NULL,
  organization TEXT NOT NULL,
  url TEXT,
  isbn TEXT,
  language TEXT DEFAULT 'id',
  publication_year INTEGER,
  trust_notes TEXT,
  localization_notes TEXT,
  last_checked_at TIMESTAMPTZ,
  status TEXT DEFAULT 'needs_review' CHECK (status IN ('verified','needs_review','use_carefully','deprecated')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE sources IS 'External reference sources with tier and verification status. Public read.';

CREATE TABLE lesson_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  source_id UUID NOT NULL REFERENCES sources(id) ON DELETE CASCADE,
  relevance_type TEXT DEFAULT 'primary' CHECK (relevance_type IN ('primary','supporting','further_reading')),
  citation_label TEXT,
  is_primary BOOLEAN DEFAULT FALSE,
  display_order INTEGER DEFAULT 0,
  UNIQUE(lesson_id, source_id)
);

COMMENT ON TABLE lesson_sources IS 'Junction linking lessons to trusted sources. Public read.';

CREATE TABLE lesson_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  media_type TEXT NOT NULL CHECK (media_type IN ('image','video','audio','diagram')),
  url TEXT NOT NULL,
  alt_text TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_media IS 'Media attachments for lessons. Public read where is_active = true.';

CREATE TABLE recommended_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  resource_type TEXT NOT NULL CHECK (resource_type IN ('article','video','book','podcast','tool','website')),
  url TEXT,
  description TEXT,
  description_id TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE recommended_resources IS 'Curated further-reading resources per lesson. Public read where is_active = true.';

-- RLS: lessons are readable by anyone when published; only service/admin can write.
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read published lessons"
  ON lessons FOR SELECT
  USING (is_published = TRUE);

COMMENT ON POLICY "Public read published lessons" ON lessons IS 'Any user can read lessons that have been published.';

-- RLS: lesson_versions readable by anyone when published; admin/service writes.
ALTER TABLE lesson_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read published lesson versions"
  ON lesson_versions FOR SELECT
  USING (is_published = TRUE);

COMMENT ON POLICY "Public read published lesson versions" ON lesson_versions IS 'Any user can read published lesson versions.';
-- Migration 004: Lesson reviews
-- Editorial review workflow for lesson fact-checking and approval.
-- Admin only: normal users cannot read or write these rows.

CREATE TABLE lesson_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID UNIQUE NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  reviewer_name TEXT,
  reviewer_role TEXT,
  review_date DATE,
  factual_accuracy_status TEXT CHECK (factual_accuracy_status IN ('pass','issues','fail')),
  source_verification_status TEXT CHECK (source_verification_status IN ('pass','issues','fail')),
  indonesia_context_status TEXT CHECK (indonesia_context_status IN ('pass','issues','fail')),
  compliance_status TEXT CHECK (compliance_status IN ('pass','issues','fail')),
  notes TEXT,
  approved_to_publish BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_reviews IS 'Editorial review records for lessons. Admin only; no public read.';

-- RLS enabled with no policies: only service role / admin can access.
ALTER TABLE lesson_reviews ENABLE ROW LEVEL SECURITY;
-- Migration 005: Learning activity tables
-- Tracks lesson attempts, progress, per-topic mastery, and daily check-ins.
-- All tables are user-private: users can only access their own rows.

CREATE TABLE lesson_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id),
  attempt_number INTEGER DEFAULT 1,
  score INTEGER,
  max_score INTEGER,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  answers_json JSONB,
  ai_help_used_count INTEGER DEFAULT 0,
  time_spent_seconds INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE lesson_attempts IS 'Each quiz/lesson attempt by a user. RLS: users read/write own rows only.';

CREATE INDEX idx_lesson_attempts_user_lesson ON lesson_attempts(user_id, lesson_id);

CREATE TABLE lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id),
  status TEXT DEFAULT 'locked' CHECK (status IN ('locked','available','in_progress','completed')),
  best_score INTEGER,
  attempts_count INTEGER DEFAULT 0,
  first_completed_at TIMESTAMPTZ,
  last_attempted_at TIMESTAMPTZ,
  UNIQUE(user_id, lesson_id)
);

COMMENT ON TABLE lesson_progress IS 'Per-user lesson state (locked/available/in_progress/completed). RLS: users read/write own rows only.';

CREATE TABLE user_mastery (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  topic_id UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  mastery_score INTEGER DEFAULT 0 CHECK (mastery_score BETWEEN 0 AND 100),
  lessons_completed INTEGER DEFAULT 0,
  total_lessons INTEGER DEFAULT 0,
  last_updated TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, topic_id)
);

COMMENT ON TABLE user_mastery IS 'Per-topic mastery summary per user. RLS: users read/write own rows only.';

CREATE TABLE daily_checkins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  checkin_date DATE NOT NULL DEFAULT CURRENT_DATE,
  xp_earned INTEGER DEFAULT 0,
  koin_points_earned INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, checkin_date)
);

COMMENT ON TABLE daily_checkins IS 'Daily learning check-ins per user. RLS: users read/write own rows only.';

-- RLS: users manage own lesson_attempts
ALTER TABLE lesson_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own lesson_attempts"
  ON lesson_attempts FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own lesson_attempts" ON lesson_attempts IS 'Authenticated users can only access their own lesson attempt rows.';

-- RLS: users manage own lesson_progress
ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own lesson_progress"
  ON lesson_progress FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own lesson_progress" ON lesson_progress IS 'Authenticated users can only access their own lesson progress rows.';

-- RLS: users manage own user_mastery
ALTER TABLE user_mastery ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own user_mastery"
  ON user_mastery FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own user_mastery" ON user_mastery IS 'Authenticated users can only access their own mastery rows.';

-- RLS: users manage own daily_checkins
ALTER TABLE daily_checkins ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own daily_checkins"
  ON daily_checkins FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own daily_checkins" ON daily_checkins IS 'Authenticated users can only access their own daily check-in rows.';
-- Migration 006: Streak tables
-- Tracks current streak state and historical streak events per user.

CREATE TABLE streaks (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak_days INTEGER DEFAULT 0,
  longest_streak_days INTEGER DEFAULT 0,
  streak_freezes_available INTEGER DEFAULT 1,
  last_completed_on DATE,
  streak_status TEXT DEFAULT 'active' CHECK (streak_status IN ('active','at_risk','frozen','broken'))
);

COMMENT ON TABLE streaks IS 'Current streak state for each user. RLS: users read/write own row only.';

CREATE TABLE streak_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL CHECK (event_type IN ('preserved','freeze_used','broken','milestone')),
  streak_days_at_event INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE streak_events IS 'Historical streak events (preserved, freeze used, broken, milestone). RLS: users read own rows only.';

-- RLS: users manage own streak row
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own streaks"
  ON streaks FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own streaks" ON streaks IS 'Authenticated users can only access their own streak row.';

-- RLS: users read own streak_events
ALTER TABLE streak_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own streak_events"
  ON streak_events FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own streak_events" ON streak_events IS 'Authenticated users can only read their own streak event rows.';
-- Migration 007: Gamification tables
-- XP events and user badge awards.

CREATE TABLE xp_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  source_type TEXT NOT NULL CHECK (source_type IN ('lesson_complete','quiz_bonus','streak_milestone','badge','social','first_trade','graduation')),
  source_id UUID,
  xp_amount INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE xp_events IS 'Immutable log of XP awarded to users. RLS: users read own rows only.';

CREATE INDEX idx_xp_events_user_created ON xp_events(user_id, created_at DESC);

CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id),
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);

COMMENT ON TABLE user_badges IS 'Badges earned by each user. RLS: users read own rows only.';

-- RLS: users read own xp_events
ALTER TABLE xp_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own xp_events"
  ON xp_events FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own xp_events" ON xp_events IS 'Authenticated users can only read their own XP event rows.';

-- RLS: users read own user_badges
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own user_badges"
  ON user_badges FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own user_badges" ON user_badges IS 'Authenticated users can only read their own badge awards.';
-- Migration 008: Paper trading tables
-- Market data, portfolios, holdings, trades, and watchlists.

CREATE TABLE market_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol TEXT NOT NULL,
  company_name TEXT,
  trade_date DATE NOT NULL,
  open_price NUMERIC(12,2),
  high_price NUMERIC(12,2),
  low_price NUMERIC(12,2),
  close_price NUMERIC(12,2) NOT NULL,
  volume BIGINT,
  source_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(symbol, trade_date)
);

COMMENT ON TABLE market_data IS 'End-of-day market price data per symbol. Public read; updated by backend job.';

CREATE INDEX idx_market_data_symbol_date ON market_data(symbol, trade_date DESC);

CREATE TABLE portfolios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  starting_cash NUMERIC(12,2) NOT NULL DEFAULT 10000000,
  cash_balance NUMERIC(12,2) NOT NULL DEFAULT 10000000,
  total_value NUMERIC(12,2) NOT NULL DEFAULT 10000000,
  graduation_multiplier NUMERIC(4,2),
  graduated_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active' CHECK (status IN ('active','graduated')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE portfolios IS 'Paper trading portfolio per user. RLS: users read/update own row only.';

CREATE TABLE holdings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id UUID NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  shares INTEGER NOT NULL DEFAULT 0,
  average_cost NUMERIC(12,2) NOT NULL DEFAULT 0,
  current_price NUMERIC(12,2),
  last_price_updated_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(portfolio_id, symbol)
);

COMMENT ON TABLE holdings IS 'Stock holdings within a portfolio. RLS: users read/update via portfolio ownership.';

CREATE INDEX idx_holdings_portfolio ON holdings(portfolio_id);

CREATE TABLE trades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id UUID NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  trade_type TEXT NOT NULL CHECK (trade_type IN ('buy','sell')),
  shares INTEGER NOT NULL,
  price NUMERIC(12,2) NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL,
  lot_count INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE trades IS 'Executed paper trades. RLS: users read own rows only.';

CREATE INDEX idx_trades_portfolio_created ON trades(portfolio_id, created_at DESC);

CREATE TABLE watchlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, symbol)
);

COMMENT ON TABLE watchlists IS 'User watchlist symbols. RLS: users read/update own rows only.';

-- RLS: users manage own portfolios
ALTER TABLE portfolios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own portfolios"
  ON portfolios FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own portfolios" ON portfolios IS 'Authenticated users can only access their own portfolio row.';

-- RLS: users manage holdings via portfolio ownership
ALTER TABLE holdings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own holdings"
  ON holdings FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM portfolios
      WHERE portfolios.id = holdings.portfolio_id
        AND portfolios.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM portfolios
      WHERE portfolios.id = holdings.portfolio_id
        AND portfolios.user_id = auth.uid()
    )
  );

COMMENT ON POLICY "Users manage own holdings" ON holdings IS 'Authenticated users can only access holdings belonging to their own portfolio.';

-- RLS: users read own trades via portfolio ownership
ALTER TABLE trades ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own trades"
  ON trades FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM portfolios
      WHERE portfolios.id = trades.portfolio_id
        AND portfolios.user_id = auth.uid()
    )
  );

COMMENT ON POLICY "Users read own trades" ON trades IS 'Authenticated users can only read trades belonging to their own portfolio.';

-- RLS: users manage own watchlists
ALTER TABLE watchlists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own watchlists"
  ON watchlists FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users manage own watchlists" ON watchlists IS 'Authenticated users can only access their own watchlist rows.';
-- Migration 009: Koin Points tables
-- Tracks Koin Points balances and transaction history per user.

CREATE TABLE koin_point_balances (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  current_balance INTEGER NOT NULL DEFAULT 0,
  lifetime_earned INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE koin_point_balances IS 'Current Koin Points balance per user. RLS: users read own row only.';

CREATE TABLE koin_point_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,
  source_type TEXT NOT NULL CHECK (source_type IN ('leaderboard','streak_milestone','graduation','lesson_complete','trade_milestone','reward')),
  source_id UUID,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE koin_point_transactions IS 'Immutable log of Koin Points earned/spent. RLS: users read own rows only.';

CREATE INDEX idx_koin_point_tx_user_created ON koin_point_transactions(user_id, created_at DESC);

-- RLS: users read own balance
ALTER TABLE koin_point_balances ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own koin_point_balances"
  ON koin_point_balances FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own koin_point_balances" ON koin_point_balances IS 'Authenticated users can only read their own Koin Points balance row.';

-- RLS: users read own transactions
ALTER TABLE koin_point_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own koin_point_transactions"
  ON koin_point_transactions FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own koin_point_transactions" ON koin_point_transactions IS 'Authenticated users can only read their own Koin Points transaction rows.';
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
-- Migration 011: Social tables
-- Friendships, invites, cohorts, memberships, and weekly leaderboard snapshots.

CREATE TABLE friendships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  addressee_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','accepted','declined','blocked')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(requester_id, addressee_id),
  CHECK (requester_id != addressee_id)
);

COMMENT ON TABLE friendships IS 'Friend requests and friendships between users. RLS: users see rows where they are requester OR addressee.';

CREATE TABLE friend_invites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inviter_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  invite_code TEXT UNIQUE NOT NULL DEFAULT substr(md5(random()::text), 1, 8),
  uses_count INTEGER DEFAULT 0,
  max_uses INTEGER DEFAULT 10,
  expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '30 days',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE friend_invites IS 'Friend invite codes generated by users. RLS: users read/create own invite codes only.';

CREATE TABLE cohorts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  invite_code TEXT UNIQUE NOT NULL,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE cohorts IS 'Groups/cohorts users can join by invite code. Public read for invite-code lookup.';

CREATE TABLE cohort_memberships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cohort_id UUID NOT NULL REFERENCES cohorts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(cohort_id, user_id)
);

COMMENT ON TABLE cohort_memberships IS 'User memberships in cohorts. RLS: users read own memberships.';

CREATE TABLE weekly_leaderboard_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  week_start DATE NOT NULL,
  xp_this_week INTEGER DEFAULT 0,
  koin_points_this_week INTEGER DEFAULT 0,
  rank_global INTEGER,
  rank_friends INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, week_start)
);

COMMENT ON TABLE weekly_leaderboard_snapshots IS 'Weekly XP and Koin Points totals per user. RLS: users read own rows; public read via safe leaderboard view.';

-- RLS: friendships - users can see and manage rows they participate in
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own friendships"
  ON friendships FOR ALL
  USING (auth.uid() = requester_id OR auth.uid() = addressee_id)
  WITH CHECK (auth.uid() = requester_id OR auth.uid() = addressee_id);

COMMENT ON POLICY "Users manage own friendships" ON friendships IS 'Authenticated users can only access friendship rows where they are requester or addressee.';

-- RLS: friend_invites - users read/create own
ALTER TABLE friend_invites ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own friend_invites"
  ON friend_invites FOR SELECT
  USING (auth.uid() = inviter_id);

COMMENT ON POLICY "Users read own friend_invites" ON friend_invites IS 'Authenticated users can only read their own invite codes.';

CREATE POLICY "Users create own friend_invites"
  ON friend_invites FOR INSERT
  WITH CHECK (auth.uid() = inviter_id);

COMMENT ON POLICY "Users create own friend_invites" ON friend_invites IS 'Authenticated users can only create invite codes for themselves.';

-- RLS: cohorts - public read via SELECT policy (no user data restriction)
ALTER TABLE cohorts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read cohorts"
  ON cohorts FOR SELECT
  USING (TRUE);

COMMENT ON POLICY "Public read cohorts" ON cohorts IS 'Anyone can read cohorts for invite-code lookup.';

-- RLS: cohort_memberships - users read own
ALTER TABLE cohort_memberships ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own cohort_memberships"
  ON cohort_memberships FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own cohort_memberships" ON cohort_memberships IS 'Authenticated users can only read their own cohort membership rows.';

-- RLS: weekly_leaderboard_snapshots - users read own
ALTER TABLE weekly_leaderboard_snapshots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own weekly_leaderboard_snapshots"
  ON weekly_leaderboard_snapshots FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own weekly_leaderboard_snapshots" ON weekly_leaderboard_snapshots IS 'Authenticated users can only read their own weekly leaderboard snapshot rows. Public read is exposed through a safe view.';
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
-- Migration 013: Analytics and ops tables
-- Notifications queue, content flags, and analytics events.

CREATE TABLE notifications_queue (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data_json JSONB,
  scheduled_for TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE notifications_queue IS 'Outgoing notification queue per user. RLS: users read own rows only.';

CREATE TABLE content_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  source_id UUID REFERENCES sources(id) ON DELETE CASCADE,
  flagged_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  reason TEXT NOT NULL,
  status TEXT DEFAULT 'open' CHECK (status IN ('open','reviewing','resolved','rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE content_flags IS 'User-submitted flags on lessons or sources. RLS: users read flags they created; admin read all.';

CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  event_name TEXT NOT NULL,
  properties JSONB,
  session_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE analytics_events IS 'Client-side analytics event stream. RLS: users insert own rows; no user read; admin only.';

-- RLS: notifications_queue
ALTER TABLE notifications_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own notifications_queue"
  ON notifications_queue FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own notifications_queue" ON notifications_queue IS 'Authenticated users can only read their own notification rows.';

-- RLS: content_flags - users read flags they created; admin reads all via service role
ALTER TABLE content_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own content_flags"
  ON content_flags FOR SELECT
  USING (flagged_by = auth.uid());

COMMENT ON POLICY "Users read own content_flags" ON content_flags IS 'Authenticated users can read content flags they created. Admins bypass RLS.';

CREATE POLICY "Users create content_flags"
  ON content_flags FOR INSERT
  WITH CHECK (flagged_by = auth.uid());

COMMENT ON POLICY "Users create content_flags" ON content_flags IS 'Authenticated users can create content flags attributed to themselves.';

-- RLS: analytics_events - users insert own rows; no user read
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users insert own analytics_events"
  ON analytics_events FOR INSERT
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users insert own analytics_events" ON analytics_events IS 'Authenticated users can insert analytics events for themselves. Reads are admin-only via service role.';
-- Migration 014: Content variants
-- Pools of alternative examples, questions, and explanations used by the lesson player.
-- Public read where is_active = true and parent lesson is published.

CREATE TABLE content_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  variant_type TEXT NOT NULL CHECK (variant_type IN ('example','question','explanation')),
  body JSONB NOT NULL,
  difficulty TEXT CHECK (difficulty IN ('beginner','intermediate','advanced')),
  topic_tag TEXT,
  usage_count INTEGER DEFAULT 0,
  last_used_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE content_variants IS 'Alternative lesson content (examples, questions, explanations). Public read where is_active = true and parent lesson is_published = true.';

CREATE INDEX idx_content_variants_lesson_active ON content_variants(lesson_id, variant_type, is_active);
CREATE INDEX idx_content_variants_difficulty ON content_variants(difficulty, is_active);

-- RLS: public read only when active and parent lesson is published
ALTER TABLE content_variants ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read active content_variants for published lessons"
  ON content_variants FOR SELECT
  USING (
    is_active = TRUE
    AND EXISTS (
      SELECT 1 FROM lessons
      WHERE lessons.id = content_variants.lesson_id
        AND lessons.is_published = TRUE
    )
  );

COMMENT ON POLICY "Public read active content_variants for published lessons" ON content_variants IS 'Anyone can read active content variants whose parent lesson is published.';

-- Koin MVP Reference Seed Data
-- WARNING: This seed file intentionally skips profiles/users and dependent tables
-- because they require auth.users rows. Create dev users via the Supabase Auth Admin
-- API (or Supabase Dashboard) before seeding portfolios, holdings, trades, etc.
-- Seed order follows SCHEMA.md v2 dependency order.

-- 1. topics
INSERT INTO topics (id, slug, name, name_id, icon, color, display_order) VALUES
(gen_random_uuid(), 'money_basics', 'Money Basics', 'Dasar-Dasar Uang', 'wallet', '#10B981', 1),
(gen_random_uuid(), 'inflation', 'Inflation', 'Inflasi', 'trending-up', '#F59E0B', 2),
(gen_random_uuid(), 'budgeting', 'Budgeting', 'Anggaran', 'calculator', '#3B82F6', 3),
(gen_random_uuid(), 'risk_return', 'Risk & Return', 'Risiko dan Pengembalian', 'scale', '#8B5CF6', 4),
(gen_random_uuid(), 'idx_basics', 'IDX Basics', 'Dasar-Dasar IDX', 'chart-bar', '#EC4899', 5);

-- 2. levels
INSERT INTO levels (id, name, name_id, xp_required, badge_icon, description) VALUES
(1, 'Newbie', 'Pemula', 0, '🌱', 'Just getting started with money basics'),
(2, 'Apprentice', 'Pemula Lanjut', 100, '🪙', 'Completing first lessons and building habits'),
(3, 'Saver', 'Penabung', 250, '🐖', 'Understanding saving and inflation'),
(4, 'Budgeter', 'Perencana', 500, '📒', 'Building and sticking to a budget'),
(5, 'Investor', 'Investor', 900, '📈', 'Entering the world of risk and return'),
(6, 'Trader', 'Trader', 1500, '⚖️', 'Making informed paper trades'),
(7, 'Analyst', 'Analis', 2400, '🔍', 'Reading market data and sources critically'),
(8, 'Strategist', 'Strategis', 3700, '🧠', 'Diversifying and managing risk'),
(9, 'Mentor', 'Mentor', 5500, '🏆', 'Helping friends learn finance'),
(10, 'Master', 'Master', 8000, '👑', 'Graduated with a strong financial mindset');

-- 3. badges
INSERT INTO badges (id, slug, name, name_id, description, description_id, icon, trigger_type, trigger_value) VALUES
(gen_random_uuid(), 'first_lesson', 'First Lesson', 'Pelajaran Pertama', 'Complete your first lesson', 'Selesaikan pelajaran pertamamu', '📚', 'lesson_complete', '{"count": 1}'::jsonb),
(gen_random_uuid(), 'three_day_streak', '3-Day Streak', 'Streak 3 Hari', 'Learn for 3 days in a row', 'Belajar 3 hari berturut-turut', '🔥', 'streak', '{"days": 3}'::jsonb),
(gen_random_uuid(), 'seven_day_streak', '7-Day Streak', 'Streak 7 Hari', 'Learn for 7 days in a row', 'Belajar 7 hari berturut-turut', '🚀', 'streak', '{"days": 7}'::jsonb),
(gen_random_uuid(), 'budget_beginner', 'Budget Beginner', 'Pemula Anggaran', 'Complete the Budgeting lesson', 'Selesaikan pelajaran Anggaran', '📒', 'lesson_complete', '{"lesson_slug": "budgeting"}'::jsonb),
(gen_random_uuid(), 'scam_spotter', 'Scam Spotter', 'Pendeteksi Penipuan', 'Complete the Money Basics lesson on fraud awareness', 'Selesaikan pelajaran Dasar Uang tentang waspada penipuan', '🛡️', 'lesson_complete', '{"lesson_slug": "money_basics"}'::jsonb),
(gen_random_uuid(), 'compound_wizard', 'Compound Wizard', 'Ahli Bunga Majemuk', 'Complete the Risk & Return lesson', 'Selesaikan pelajaran Risiko dan Pengembalian', '🧙', 'lesson_complete', '{"lesson_slug": "risk_return"}'::jsonb),
(gen_random_uuid(), 'diversification_defender', 'Diversification Defender', 'Pembela Diversifikasi', 'Hold at least 3 different stocks in your portfolio', 'Miliki minimal 3 saham berbeda di portofoliomu', '🧺', 'trade', '{"min_symbols": 3}'::jsonb),
(gen_random_uuid(), 'first_trade', 'First Trade', 'Transaksi Pertama', 'Execute your first paper trade', 'Lakukan transaksi paper trading pertamamu', '💱', 'trade', '{"count": 1}'::jsonb),
(gen_random_uuid(), 'first_friend', 'First Friend', 'Teman Pertama', 'Have a friend accept your invite', 'Undang teman dan dapatkan persetujuan', '🤝', 'social', '{"event": "friend_accepted"}'::jsonb),
(gen_random_uuid(), 'graduate', 'Graduate', 'Lulusan', 'Graduate by reaching the portfolio target', 'Lulus dengan mencapai target portofolio', '🎓', 'portfolio', '{"status": "graduated"}'::jsonb);

-- 4. sources
-- TIER 1 — OJK
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, publication_year, status) VALUES
(gen_random_uuid(), 'OJK-001', 'National Strategy on Indonesian Financial Literacy (SNLKI) 2021-2025', 'Strategi Nasional Literasi Keuangan Indonesia 2021-2025', 1, 'report', 'OJK', 'https://ojk.go.id/en/berita-dan-kegiatan/publikasi/Pages/National-Strategy-on-Indonesian-Financial-Literacy-(SNLKI)-2021---2025.aspx', 2021, 'verified'),
(gen_random_uuid(), 'OJK-002', 'OJK National Survey on Financial Literacy & Inclusion (SNLIK) 2025', 'Survei Nasional Literasi dan Inklusi Keuangan (SNLIK) 2025', 1, 'survey', 'OJK', 'https://ojk.go.id/id/Fungsi-Utama/Perilaku-Pelaku-Usaha-Jasa-Keuangan/SNLIK/Pages/SNLIK-2025.aspx', 2025, 'verified'),
(gen_random_uuid(), 'OJK-003', 'OJK Pocket Guide: Personal Financial Management', 'Buku Saku Pengelolaan Keuangan Pribadi', 1, 'guide', 'OJK', 'https://ojk.go.id/id/berita-dan-kegiatan/publikasi/Documents/Pages/Buku-Saku-Pengelolaan-Keuangan-Pribadi/Buku-Saku-Pengelolaan-Keuangan-Pribadi.pdf', 2023, 'needs_review'),
(gen_random_uuid(), 'OJK-004', 'OJK Education Portal — Capital Markets Module', 'Portal Edukasi OJK — Modul Pasar Modal', 1, 'website', 'OJK', 'https://ojk.go.id/id/kanal/pasar-modal/Pages/Investasi.aspx', 2024, 'needs_review'),
(gen_random_uuid(), 'OJK-005', 'OJK Financial Literacy Month 2025 Campaign', 'Bulan Literasi Keuangan (BLK) 2025', 1, 'report', 'OJK', 'https://ojk.go.id/en/berita-dan-kegiatan/siaran-pers/Pages/Expanding-Financial-Education-OJK-Launches-the-2025-Financial-Literacy-Month.aspx', 2025, 'needs_review'),
(gen_random_uuid(), 'OJK-006', 'OJK Pocket Guide: Understanding Investment Products', 'Buku Saku Mengenal Produk Investasi', 1, 'guide', 'OJK', 'https://ojk.go.id/id/berita-dan-kegiatan/publikasi/Pages/Buku-Saku-Literasi-Keuangan.aspx', 2023, 'needs_review'),
(gen_random_uuid(), 'OJK-007', 'OJK Consumer Protection — Recognizing Investment Fraud', 'Waspadai Investasi Bodong', 1, 'website', 'OJK', 'https://www.ojk.go.id/id/kanal/perbankan/Pages/Perlindungan-Konsumen.aspx', 2024, 'needs_review'),
(gen_random_uuid(), 'OJK-008', 'OJK TikTok @ojkindonesia', 'TikTok Resmi OJK Indonesia', 1, 'social', 'OJK', 'https://www.tiktok.com/@ojkindonesia', 2025, 'verified');

-- TIER 1 — Bank Indonesia
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, publication_year, status) VALUES
(gen_random_uuid(), 'BI-001', 'Bank Indonesia — About Inflation', 'Bank Indonesia — Tentang Inflasi', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/moneter/inflasi/Default.aspx', 2024, 'verified'),
(gen_random_uuid(), 'BI-002', 'Bank Indonesia — BI Rate', 'Bank Indonesia — Suku Bunga BI', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/moneter/tingkat-suku-bunga/Default.aspx', 2025, 'verified'),
(gen_random_uuid(), 'BI-003', 'Bank Indonesia Digital Financial Literacy Program', 'Program Literasi Keuangan Digital Bank Indonesia', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/fungsi-utama/sistem-pembayaran/Default.aspx', 2025, 'needs_review'),
(gen_random_uuid(), 'BI-004', 'Bank Indonesia Financial System Stability Review', 'Tinjauan Stabilitas Sistem Keuangan Bank Indonesia', 1, 'report', 'Bank Indonesia', 'https://www.bi.go.id/id/publikasi/laporan/Default.aspx', 2025, 'needs_review'),
(gen_random_uuid(), 'BI-005', 'Bank Indonesia — Exchange Rate (Nilai Tukar Rupiah)', 'Bank Indonesia — Nilai Tukar Rupiah', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/statistik/informasi-kurs/Default.aspx', 2025, 'verified'),
(gen_random_uuid(), 'BI-006', 'Bank Indonesia Instagram @bankindonesia', 'Instagram Resmi Bank Indonesia', 1, 'social', 'Bank Indonesia', 'https://www.instagram.com/bankindonesia/', 2025, 'verified'),
(gen_random_uuid(), 'BI-007', 'Bank Indonesia — UMKM & Financial Inclusion Reports', 'Bank Indonesia — Laporan UMKM & Inklusi Keuangan', 1, 'report', 'Bank Indonesia', 'https://www.bi.go.id/id/publikasi/laporan/Default.aspx', 2024, 'needs_review');

-- TIER 1 — IDX
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, publication_year, status) VALUES
(gen_random_uuid(), 'IDX-001', 'IDX Academy — Investor Education Portal', 'Akademi Investor IDX', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/akademi-investor/', 2025, 'verified'),
(gen_random_uuid(), 'IDX-002', 'IDX Glossary of Capital Markets Terms', 'Glosarium Istilah Pasar Modal IDX', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/perusahaan-terdaftar/glossarium/', 2025, 'verified'),
(gen_random_uuid(), 'IDX-003', 'IDX Statistics — Market Data & Historical Prices', 'Statistik IDX — Data Pasar & Harga Historis', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/', 2026, 'verified'),
(gen_random_uuid(), 'IDX-004', 'IDX YouTube — Yuk Nabung Saham Series', 'YouTube IDX — Seri Yuk Nabung Saham', 1, 'video', 'IDX', 'https://www.youtube.com/c/IDXOfficial', 2025, 'verified'),
(gen_random_uuid(), 'IDX-005', 'IDX — Beginner Investment Guide', 'Panduan Investasi Pemula IDX', 1, 'guide', 'IDX', 'https://www.idx.co.id/id-id/investor/panduan-investasi/', 2024, 'needs_review'),
(gen_random_uuid(), 'IDX-006', 'New IDX Mobile App', 'Aplikasi New IDX Mobile', 1, 'website', 'IDX', 'https://apps.apple.com/app/new-idx-mobile/id1658695361', 2025, 'verified'),
(gen_random_uuid(), 'IDX-007', 'IDX Investor Protection — SIPF', 'Perlindungan Investor IDX — SIPF', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/investor/perlindungan-investor/', 2024, 'needs_review');

-- TIER 2 — Global Enrichment
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, isbn, publication_year, status, localization_notes) VALUES
(gen_random_uuid(), 'GLB-001', 'OECD PISA 2022 Financial Literacy Framework', 'OECD PISA 2022 Financial Literacy Framework', 2, 'report', 'OECD', 'https://www.oecd.org/pisa/publications/pisa-2022-results.htm', NULL, 2023, 'needs_review', 'Use IDR/Indonesian examples when citing'),
(gen_random_uuid(), 'GLB-002', 'World Bank Global Findex 2021 — Indonesia', 'World Bank Global Findex 2021 — Indonesia', 2, 'report', 'World Bank', 'https://globalfindex.worldbank.org/', NULL, 2021, 'needs_review', 'Localize to Indonesian banking context'),
(gen_random_uuid(), 'GLB-003', 'World Bank Indonesia Country Overview', 'World Bank Indonesia Country Overview', 2, 'report', 'World Bank', 'https://www.worldbank.org/en/country/indonesia/overview', NULL, 2023, 'needs_review', 'Localize to Indonesian macro context'),
(gen_random_uuid(), 'GLB-004', 'The Psychology of Money — Morgan Housel', 'The Psychology of Money — Morgan Housel', 2, 'book', 'Morgan Housel', NULL, '978-0857197689', 2020, 'needs_review', 'Replace USD examples with IDR equivalents'),
(gen_random_uuid(), 'GLB-005', 'I Will Teach You To Be Rich — Ramit Sethi', 'I Will Teach You To Be Rich — Ramit Sethi', 2, 'book', 'Ramit Sethi', NULL, '978-1523505746', 2019, 'needs_review', 'Adapt budgeting examples to Indonesian income levels'),
(gen_random_uuid(), 'GLB-006', 'Rich Dad Poor Dad — Kiyosaki (asset/liability concept ONLY)', 'Rich Dad Poor Dad — Kiyosaki (konsep aset/liabilitas)', 2, 'book', 'Robert Kiyosaki', NULL, '978-1612680194', 1997, 'needs_review', 'Use only asset/liability framing; localize to ID'),
(gen_random_uuid(), 'GLB-007', 'A Random Walk Down Wall Street — Malkiel', 'A Random Walk Down Wall Street — Malkiel', 2, 'book', 'Burton Malkiel', NULL, '978-0393358384', 2019, 'needs_review', 'Use IDX and Indonesian fund examples'),
(gen_random_uuid(), 'GLB-008', 'Tiny Habits — BJ Fogg (product design reference)', 'Tiny Habits — BJ Fogg', 2, 'book', 'BJ Fogg', NULL, '978-0358003328', 2019, 'needs_review', 'Apply habit-building to Indonesian financial routines'),
(gen_random_uuid(), 'GLB-009', 'Women''s World Banking — Indonesian Youth Financial Confidence', 'Women''s World Banking — Indonesian Youth Financial Confidence', 2, 'report', 'Women''s World Banking', 'https://www.womensworldbanking.org/', NULL, 2025, 'needs_review', 'Already Indonesia-focused; verify youth stats'),
(gen_random_uuid(), 'GLB-010', 'Frontiers in Education — Youth Financial Literacy Programs', 'Frontiers in Education — Youth Financial Literacy Programs', 2, 'report', 'Frontiers in Education', 'https://www.frontiersin.org/journals/education/articles/10.3389/feduc.2024.1397060/full', NULL, 2024, 'needs_review', 'Use Indonesian youth context when citing');

-- 5. lessons
INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction
) VALUES
(
  gen_random_uuid(),
  'money-basics-101',
  'Money Basics: Needs, Wants, and Fraud Alerts',
  'Dasar-Dasar Uang: Kebutuhan, Keinginan, dan Waspada Penipuan',
  (SELECT id FROM topics WHERE slug = 'money_basics'),
  1,
  'beginner',
  50,
  5,
  'Learn to separate needs from wants and spot common financial scams in Indonesia.',
  'Money is a tool for exchange. Before spending, ask: is this a need (kebutuhan) or a want (keinginan)? Scammers often promise guaranteed high returns with no risk. OJK warns the public to check licenses before investing.',
  'Budi receives Rp 500,000 pocket money. He needs Rp 200,000 for transport and lunch, but wants a new game skin for Rp 150,000. He also sees an Instagram ad promising "guaranteed 10% returns per week." Budi decides to cover needs first, save Rp 100,000, and reports the suspicious ad to OJK.',
  'Knowing needs vs. wants helps you avoid debt. Recognizing scams protects your savings and future.',
  'Thinking that all investments with high returns are safe. If it sounds too good to be true, it usually is.',
  '[
    {
      "question": "Which of these is a need (kebutuhan)?",
      "type": "multiple_choice",
      "options": ["New sneakers", "Daily lunch", "Latest smartphone", "Concert ticket"],
      "answer": "Daily lunch",
      "explanation": "Daily lunch is a basic need. The others are wants."
    },
    {
      "question": "An investment promises \"guaranteed\" 20% returns per month. What should you do first?",
      "type": "multiple_choice",
      "options": ["Invest immediately", "Check OJK registration/license", "Tell all friends", "Borrow money to invest more"],
      "answer": "Check OJK registration/license",
      "explanation": "OJK-regulated products must be licensed. Guaranteed high returns are a red flag for fraud."
    },
    {
      "question": "What is the safest first step before spending money?",
      "type": "multiple_choice",
      "options": ["Buy first, budget later", "Compare needs vs wants", "Use all savings", "Follow influencer advice"],
      "answer": "Compare needs vs wants",
      "explanation": "Separating needs from wants is the foundation of good money management."
    }
  ]'::jsonb,
  'Help the user understand needs vs wants and how to verify if an investment product is OJK-registered.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'budgeting-101',
  'Budgeting: The 50/30/20 Rule, Indonesian Style',
  'Anggaran: Aturan 50/30/20 ala Indonesia',
  (SELECT id FROM topics WHERE slug = 'budgeting'),
  2,
  'beginner',
  60,
  6,
  'Build a simple budget using the 50/30/20 framework adapted for Indonesian students.',
  'A budget is a plan for your money. The 50/30/20 rule suggests 50% for needs, 30% for wants, and 20% for savings and debt. In Indonesia, you might adjust this based on living costs and family contributions.',
  'Ani earns Rp 2,000,000 per month from part-time work. She allocates Rp 1,000,000 for needs (transport, food, phone), Rp 600,000 for wants (streaming, hangouts), and Rp 400,000 for savings and paying off a small debt to her brother.',
  'Budgeting turns vague anxiety into a clear plan. It helps you save for goals and avoid borrowing impulsively.',
  'Creating a perfect budget but never tracking actual spending. A budget only works if you review it.',
  '[
    {
      "question": "In the 50/30/20 budget, what does the 20% cover?",
      "type": "multiple_choice",
      "options": ["Needs", "Wants", "Savings and debt", "Investments only"],
      "answer": "Savings and debt",
      "explanation": "20% is for savings and paying off debt, while 50% covers needs and 30% covers wants."
    },
    {
      "question": "Ani earns Rp 2,000,000. How much should she aim to save or use for debt?",
      "type": "multiple_choice",
      "options": ["Rp 200,000", "Rp 400,000", "Rp 600,000", "Rp 1,000,000"],
      "answer": "Rp 400,000",
      "explanation": "20% of Rp 2,000,000 is Rp 400,000 for savings and debt."
    },
    {
      "question": "Why is tracking actual spending important?",
      "type": "multiple_choice",
      "options": ["It makes money grow automatically", "It shows if your budget matches reality", "It is required by OJK", "It replaces the need for savings"],
      "answer": "It shows if your budget matches reality",
      "explanation": "Tracking spending reveals whether your plan is realistic and where adjustments are needed."
    }
  ]'::jsonb,
  'Guide the user to build a realistic 50/30/20 budget using Indonesian rupiah examples and local costs.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'inflation-101',
  'Inflation: Why Your Rupiah Buys Less Over Time',
  'Inflasi: Mengapa Rupiahmu Membeli Lebih Sedikit dari Waktu ke Waktu',
  (SELECT id FROM topics WHERE slug = 'inflation'),
  3,
  'beginner',
  60,
  6,
  'Understand inflation, BI''s inflation target, and why saving alone may not protect purchasing power.',
  'Inflation is the general increase in prices over time. Bank Indonesia targets inflation around 2.5% ± 1%. If your savings earn less than inflation, your purchasing power falls.',
  'In 2020, a bowl of mie ayam cost Rp 12,000. In 2025, the same bowl costs Rp 16,000. If Rina kept her money in a savings account paying 2% while inflation averaged 4%, her money buys fewer mie ayam today.',
  'Inflation affects every financial decision. Understanding it helps you choose savings and investments that preserve value.',
  'Keeping all money in cash for long-term goals. Cash loses value when inflation is higher than interest.',
  '[
    {
      "question": "What is inflation?",
      "type": "multiple_choice",
      "options": ["A decrease in prices", "A general increase in prices over time", "A type of bank account", "A government tax"],
      "answer": "A general increase in prices over time",
      "explanation": "Inflation means prices rise and purchasing power falls."
    },
    {
      "question": "Bank Indonesia''s inflation target is roughly:",
      "type": "multiple_choice",
      "options": ["0%", "2.5% ± 1%", "10%", "50%"],
      "answer": "2.5% ± 1%",
      "explanation": "BI targets low and stable inflation around 2.5% ± 1%."
    },
    {
      "question": "If inflation is 4% and your savings account pays 2%, what happens to purchasing power?",
      "type": "multiple_choice",
      "options": ["It stays the same", "It grows by 6%", "It falls", "It doubles"],
      "answer": "It falls",
      "explanation": "When inflation exceeds your savings rate, your real purchasing power declines."
    }
  ]'::jsonb,
  'Explain inflation using BI''s target and Indonesian food/price examples. Avoid investment advice.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'risk-return-101',
  'Risk & Return: Time, Compounding, and Diversification',
  'Risiko dan Pengembalian: Waktu, Bunga Majemuk, dan Diversifikasi',
  (SELECT id FROM topics WHERE slug = 'risk_return'),
  4,
  'intermediate',
  75,
  8,
  'Explore the relationship between risk and return, the power of compounding, and the role of diversification.',
  'Higher potential returns usually come with higher risk. Compounding means earning returns on your returns. Diversification spreads risk across different assets so one loss does not wipe you out.',
  'Dewi invests Rp 1,000,000 in a diversified portfolio that averages 8% per year. After 10 years, compounding grows it to about Rp 2,160,000. Her friend Eko keeps the same amount in cash; it still buys less because of inflation.',
  'Time and diversification are the strongest tools for young investors. Starting early gives compounding more time to work.',
  'Chasing the highest-return asset without considering risk. All-in on one stock or crypto can lead to large losses.',
  '[
    {
      "question": "What is the general relationship between risk and return?",
      "type": "multiple_choice",
      "options": ["Higher risk usually means higher potential return", "Higher risk means guaranteed higher return", "Risk and return are unrelated", "Lower risk always beats inflation"],
      "answer": "Higher risk usually means higher potential return",
      "explanation": "Investors demand higher potential returns for taking on more risk."
    },
    {
      "question": "What is compounding?",
      "type": "multiple_choice",
      "options": ["Earning returns only on the original amount", "Earning returns on both original amount and past returns", "Paying fees every year", "A type of tax"],
      "answer": "Earning returns on both original amount and past returns",
      "explanation": "Compounding accelerates growth because you earn returns on accumulated returns."
    },
    {
      "question": "Why is diversification important?",
      "type": "multiple_choice",
      "options": ["It guarantees profit", "It eliminates all risk", "It reduces the impact of one investment failing", "It is required by BI"],
      "answer": "It reduces the impact of one investment failing",
      "explanation": "Diversification spreads investments across assets so a single loss has less impact."
    }
  ]'::jsonb,
  'Explain risk/return trade-offs, compounding, and diversification using Indonesian rupiah examples. No specific product recommendations.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'idx-basics-101',
  'IDX Basics: How the Indonesian Stock Market Works',
  'Dasar-Dasar IDX: Cara Kerja Pasar Saham Indonesia',
  (SELECT id FROM topics WHERE slug = 'idx_basics'),
  5,
  'intermediate',
  75,
  8,
  'Learn what IDX is, how stocks trade, and what protections exist for Indonesian retail investors.',
  'IDX (Bursa Efek Indonesia) is the national stock exchange. Companies list shares so investors can own a small part of them. Prices move based on supply and demand. SIPF provides investor protection for listed securities.',
  'PT Bank Central Asia (BBCA) is listed on IDX. When you buy 1 lot (100 shares) of BBCA, you become a partial owner of the bank. You can track the price daily on the IDX website or app.',
  'Understanding IDX helps young Indonesians invest in real companies rather than unregulated schemes.',
  'Confusing stock trading with gambling. Successful investing requires research, patience, and diversification.',
  '[
    {
      "question": "What does IDX stand for?",
      "type": "multiple_choice",
      "options": ["International Dollar Exchange", "Bursa Efek Indonesia", "Indonesian Debt Index", "Investment Development Xchange"],
      "answer": "Bursa Efek Indonesia",
      "explanation": "IDX is the Indonesia Stock Exchange, the country''s national stock exchange."
    },
    {
      "question": "How many shares are in 1 lot on IDX?",
      "type": "multiple_choice",
      "options": ["1 share", "10 shares", "100 shares", "1,000 shares"],
      "answer": "100 shares",
      "explanation": "On IDX, 1 lot equals 100 shares."
    },
    {
      "question": "Which organization helps protect investors on IDX?",
      "type": "multiple_choice",
      "options": ["SIPF", "BI Rate", "OJK Social Media", "World Bank"],
      "answer": "SIPF",
      "explanation": "The Securities Investor Protection Fund (SIPF) provides protection for investors in listed securities."
    }
  ]'::jsonb,
  'Introduce IDX, stock lots, and investor protection using IDX and OJK sources. Encourage research before trading.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
);

-- 6. lesson_sources
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order) VALUES
-- money_basics
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), (SELECT id FROM sources WHERE source_code = 'OJK-001'), 'primary', 'SNLKI 2021-2025', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), (SELECT id FROM sources WHERE source_code = 'OJK-003'), 'supporting', 'Buku Saku Pengelolaan Keuangan Pribadi', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), (SELECT id FROM sources WHERE source_code = 'OJK-007'), 'supporting', 'Waspadai Investasi Bodong', FALSE, 3),
-- budgeting
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'budgeting-101'), (SELECT id FROM sources WHERE source_code = 'OJK-003'), 'primary', 'Buku Saku Pengelolaan Keuangan Pribadi', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'budgeting-101'), (SELECT id FROM sources WHERE source_code = 'OJK-006'), 'supporting', 'Buku Saku Mengenal Produk Investasi', FALSE, 2),
-- inflation
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), (SELECT id FROM sources WHERE source_code = 'BI-001'), 'primary', 'Bank Indonesia — About Inflation', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), (SELECT id FROM sources WHERE source_code = 'BI-002'), 'supporting', 'Bank Indonesia — BI Rate', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), (SELECT id FROM sources WHERE source_code = 'BI-005'), 'supporting', 'Bank Indonesia — Exchange Rate', FALSE, 3),
-- risk_return
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), (SELECT id FROM sources WHERE source_code = 'OJK-006'), 'primary', 'Buku Saku Mengenal Produk Investasi', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), (SELECT id FROM sources WHERE source_code = 'GLB-004'), 'supporting', 'The Psychology of Money', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), (SELECT id FROM sources WHERE source_code = 'GLB-007'), 'further_reading', 'A Random Walk Down Wall Street', FALSE, 3),
-- idx_basics
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-001'), 'primary', 'IDX Academy', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-002'), 'supporting', 'IDX Glossary', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-005'), 'supporting', 'IDX Beginner Investment Guide', FALSE, 3),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-007'), 'supporting', 'IDX Investor Protection — SIPF', FALSE, 4);

-- 7. lesson_reviews
INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish) VALUES
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), 'Dewi Santoso', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Aligned with OJK SNLKI and consumer protection messaging.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'budgeting-101'), 'Dewi Santoso', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Uses Indonesian student income context; examples reviewed.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), 'Rizky Pratama', 'Financial Reviewer', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'BI inflation target and rupiah examples verified.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), 'Rizky Pratama', 'Financial Reviewer', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'No product recommendations; general education only.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), 'Aisha Wijaya', 'Compliance Reviewer', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'IDX and SIPF references verified; no forward-looking claims.', TRUE);

-- 8. market_data
INSERT INTO market_data (id, symbol, company_name, trade_date, open_price, high_price, low_price, close_price, volume, source_url) VALUES
(gen_random_uuid(), 'BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '4 days', 8450.00, 8620.00, 8400.00, 8550.00, 45000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '3 days', 8580.00, 8700.00, 8520.00, 8650.00, 48000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 4120.00, 4190.00, 4080.00, 4150.00, 62000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '3 days', 4160.00, 4220.00, 4130.00, 4200.00, 58000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 3680.00, 3750.00, 3650.00, 3720.00, 35000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '3 days', 3730.00, 3780.00, 3700.00, 3750.00, 33000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '4 days', 102.00, 108.00, 100.00, 105.00, 1200000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '3 days', 106.00, 112.00, 104.00, 110.00, 1350000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 6450.00, 6520.00, 6400.00, 6480.00, 18000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '3 days', 6500.00, 6580.00, 6450.00, 6550.00, 19000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/');

-- 9. brokerage_recommendations
INSERT INTO brokerage_recommendations (id, slug, name, description, url, logo_url, risk_level, ojk_registered, product_types, display_order, is_active) VALUES
(gen_random_uuid(), 'bibit', 'Bibit', 'Robo-advisor app for mutual funds and government bonds, beginner-friendly.', 'https://bibit.id', 'https://bibit.id/logo.png', 'beginner', TRUE, ARRAY['mutual_fund','government_bond','money_market'], 1, TRUE),
(gen_random_uuid(), 'ajaib', 'Ajaib', 'All-in-one stock and mutual fund investing platform.', 'https://ajaib.co.id', 'https://ajaib.co.id/logo.png', 'intermediate', TRUE, ARRAY['stock','mutual_fund','ETF'], 2, TRUE),
(gen_random_uuid(), 'stockbit', 'Stockbit', 'Social investing platform with IDX stock trading and community insights.', 'https://stockbit.com', 'https://stockbit.com/logo.png', 'intermediate', TRUE, ARRAY['stock','mutual_fund','ETF'], 3, TRUE),
(gen_random_uuid(), 'ipot', 'IPOT', 'Online trading platform from Indo Premier Sekuritas.', 'https://www.indopremier.com/ipot', 'https://www.indopremier.com/logo.png', 'intermediate', TRUE, ARRAY['stock','mutual_fund','bond'], 4, TRUE),
(gen_random_uuid(), 'bareksa', 'Bareksa', 'Indonesia''s largest mutual fund marketplace.', 'https://bareksa.com', 'https://bareksa.com/logo.png', 'beginner', TRUE, ARRAY['mutual_fund','government_bond','money_market'], 5, TRUE);
