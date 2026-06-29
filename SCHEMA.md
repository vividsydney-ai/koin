# SCHEMA.md — Koin Full Database Schema (v2)
# Canonical source of truth. Migrations must match this exactly.
# v2 adds paper trading, Koin Points, graduation, and adaptive lesson triggers.

## Seed order (strict)
topics → levels → badges → sources → lessons → lesson_sources → lesson_reviews →
market_data → brokerage_recommendations → dev users → portfolios → holdings → trades →
koin_point_balances → koin_point_transactions → user_risk_profiles → lesson_triggers →
friendships → cohorts → cohort_memberships → weekly_leaderboard_snapshots

## RLS pattern (apply to ALL user-sensitive tables)
```sql
ALTER TABLE <table> ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users manage own <table>"
  ON <table> FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
```

## Core tables

### profiles
```sql
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
-- RLS: users read/update their own row only
```

### user_settings
```sql
CREATE TABLE user_settings (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  notifications_enabled BOOLEAN DEFAULT TRUE,
  streak_reminder_time TIME DEFAULT '19:00:00',
  weekly_report_enabled BOOLEAN DEFAULT TRUE,
  show_on_leaderboard BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read/update their own row only
```

### topics
```sql
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
-- Public read. No RLS needed (no user data).
```

### levels
```sql
CREATE TABLE levels (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  name_id TEXT NOT NULL,
  xp_required INTEGER NOT NULL,
  badge_icon TEXT,
  description TEXT
);
-- Public read.
```

### badges
```sql
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
-- Public read.
```

### sources
```sql
CREATE TABLE sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_code TEXT UNIQUE NOT NULL,        -- e.g. OJK-001
  title TEXT NOT NULL,
  local_title TEXT,                        -- Indonesian title
  source_tier INTEGER NOT NULL CHECK (source_tier IN (1,2,3)),
  source_type TEXT NOT NULL,               -- report, guide, website, video, book, social
  organization TEXT NOT NULL,             -- OJK, Bank Indonesia, IDX, etc.
  url TEXT,
  isbn TEXT,
  language TEXT DEFAULT 'id',
  publication_year INTEGER,
  trust_notes TEXT,
  localization_notes TEXT,                 -- required if tier = 2 or 3 with non-ID examples
  last_checked_at TIMESTAMPTZ,
  status TEXT DEFAULT 'needs_review' CHECK (status IN ('verified','needs_review','use_carefully','deprecated')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Public read.
```

### lessons
```sql
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
  quiz_data JSONB,                         -- array of {question, type, options, answer, explanation}
  ai_assist_context TEXT,                  -- scoped context for AI helper
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
-- Public read WHERE is_published = true
```

### lesson_sources
```sql
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
-- Public read.
```

### lesson_reviews
```sql
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
-- Admin only. No public read.
```

### content_variants
```sql
CREATE TABLE content_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  variant_type TEXT NOT NULL CHECK (variant_type IN ('example','question','explanation')),
  body JSONB NOT NULL,
  -- body shape depends on variant_type:
  -- example: {text, image_url, source_ids}
  -- question: {type, difficulty, question, options, answer, explanation, parameters}
  -- explanation: {text, ai_assist_context}
  difficulty TEXT CHECK (difficulty IN ('beginner','intermediate','advanced')),
  topic_tag TEXT,
  usage_count INTEGER DEFAULT 0,
  last_used_at TIMESTAMPTZ,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Public read WHERE is_active = true and parent lesson is_published = true.
```

### lesson_attempts
```sql
CREATE TABLE lesson_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES lessons(id),
  attempt_number INTEGER DEFAULT 1,
  score INTEGER,
  max_score INTEGER,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  answers_json JSONB,                        -- array of {variant_id, response, correct, time_spent_seconds}
  ai_help_used_count INTEGER DEFAULT 0,
  time_spent_seconds INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read/write own rows only
```

### lesson_progress
```sql
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
-- RLS: users read/write own rows only
```

### streaks
```sql
CREATE TABLE streaks (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  current_streak_days INTEGER DEFAULT 0,
  longest_streak_days INTEGER DEFAULT 0,
  streak_freezes_available INTEGER DEFAULT 1,
  last_completed_on DATE,
  streak_status TEXT DEFAULT 'active' CHECK (streak_status IN ('active','at_risk','frozen','broken'))
);
-- RLS: users read/write own row only
```

### streak_events
```sql
CREATE TABLE streak_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL CHECK (event_type IN ('preserved','freeze_used','broken','milestone')),
  streak_days_at_event INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read own rows only
```

### xp_events
```sql
CREATE TABLE xp_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  source_type TEXT NOT NULL CHECK (source_type IN ('lesson_complete','quiz_bonus','streak_milestone','badge','social','first_trade','graduation')),
  source_id UUID,
  xp_amount INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read own rows only
```

### user_badges
```sql
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badges(id),
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, badge_id)
);
-- RLS: users read own rows only
```

## Paper trading tables

### market_data
```sql
CREATE TABLE market_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol TEXT NOT NULL,                    -- e.g. BBCA
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
-- Public read. Updated by backend job or seeded for MVP.
```

### portfolios
```sql
CREATE TABLE portfolios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  starting_cash NUMERIC(12,2) NOT NULL DEFAULT 10000000,  -- Rp 10.000.000
  cash_balance NUMERIC(12,2) NOT NULL DEFAULT 10000000,
  total_value NUMERIC(12,2) NOT NULL DEFAULT 10000000,     -- cash + holdings at last price
  graduation_multiplier NUMERIC(4,2),                      -- e.g. 3.00 or 5.00
  graduated_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active' CHECK (status IN ('active','graduated')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read/update own row only
```

### holdings
```sql
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
-- RLS: users read/update via portfolio ownership
```

### trades
```sql
CREATE TABLE trades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id UUID NOT NULL REFERENCES portfolios(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  trade_type TEXT NOT NULL CHECK (trade_type IN ('buy','sell')),
  shares INTEGER NOT NULL,
  price NUMERIC(12,2) NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL,
  lot_count INTEGER NOT NULL,              -- shares / 100
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read own rows only
```

### watchlists
```sql
CREATE TABLE watchlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, symbol)
);
-- RLS: users read/update own rows only
```

## Koin Points tables

### koin_point_balances
```sql
CREATE TABLE koin_point_balances (
  user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  current_balance INTEGER NOT NULL DEFAULT 0,
  lifetime_earned INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read own row only
```

### koin_point_transactions
```sql
CREATE TABLE koin_point_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL,                 -- positive = earn, negative = spend
  source_type TEXT NOT NULL CHECK (source_type IN ('leaderboard','streak_milestone','graduation','lesson_complete','trade_milestone','reward')),
  source_id UUID,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read own rows only
```

## Graduation and recommendations

### certificates
```sql
CREATE TABLE certificates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  certificate_code TEXT UNIQUE NOT NULL,
  portfolio_value_at_graduation NUMERIC(12,2) NOT NULL,
  multiplier_achieved NUMERIC(4,2) NOT NULL,
  issued_at TIMESTAMPTZ DEFAULT NOW(),
  share_public_id TEXT UNIQUE              -- for public share links
);
-- RLS: users read own row; public read allowed via share_public_id only
```

### brokerage_recommendations
```sql
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
-- Public read.
```

### user_risk_profiles
```sql
CREATE TABLE user_risk_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  risk_score INTEGER CHECK (risk_score BETWEEN 1 AND 10),
  risk_label TEXT CHECK (risk_label IN ('conservative','moderate','growth','aggressive')),
  traits_json JSONB,                       -- summary of answers/behavior
  recommended_lesson_ids UUID[],
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read/update own row only
```

## Adaptive learning tables

### lesson_triggers
```sql
CREATE TABLE lesson_triggers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  trigger_type TEXT NOT NULL CHECK (trigger_type IN ('trade_behavior','inactivity','milestone','risk_score','portfolio_event')),
  condition_json JSONB NOT NULL,           -- e.g. {"event": "panic_sell", "drawdown_pct": 10}
  priority INTEGER DEFAULT 0,
  max_times_triggered INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Public read.
```

### user_lesson_recommendations
```sql
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
-- RLS: users read/update own rows only
```

## Social tables

### friendships
```sql
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
-- RLS: users see rows where they are requester OR addressee
```

### friend_invites
```sql
CREATE TABLE friend_invites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  inviter_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  invite_code TEXT UNIQUE NOT NULL DEFAULT substr(md5(random()::text), 1, 8),
  uses_count INTEGER DEFAULT 0,
  max_uses INTEGER DEFAULT 10,
  expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '30 days',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users read/create own invite codes only
```

### cohorts
```sql
CREATE TABLE cohorts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  invite_code TEXT UNIQUE NOT NULL,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- Public read for invite-code lookup.
```

### cohort_memberships
```sql
CREATE TABLE cohort_memberships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cohort_id UUID NOT NULL REFERENCES cohorts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(cohort_id, user_id)
);
-- RLS: users read own memberships
```

### weekly_leaderboard_snapshots
```sql
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
-- RLS: users read own rows. Public read for leaderboard view via safe view.
```

## Analytics / ops tables

### analytics_events
```sql
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  event_name TEXT NOT NULL,
  properties JSONB,
  session_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
-- RLS: users insert own rows. No user read. Admin only.
```

### notifications_queue
```sql
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
-- RLS: users read own rows only
```

### content_flags
```sql
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
-- RLS: users read flags they created; admin read all
```

## Indexes and helpers
- `idx_market_data_symbol_date` on market_data(symbol, trade_date DESC)
- `idx_trades_portfolio_created` on trades(portfolio_id, created_at DESC)
- `idx_holdings_portfolio` on holdings(portfolio_id)
- `idx_lesson_attempts_user_lesson` on lesson_attempts(user_id, lesson_id)
- `idx_xp_events_user_created` on xp_events(user_id, created_at DESC)
- `idx_koin_point_tx_user_created` on koin_point_transactions(user_id, created_at DESC)
- `idx_content_variants_lesson_active` on content_variants(lesson_id, variant_type, is_active)
- `idx_content_variants_difficulty` on content_variants(difficulty, is_active)

## RLS summary
- User-private tables (read/write own): profiles, user_settings, lesson_attempts, lesson_progress, streaks, streak_events, xp_events, user_badges, portfolios, holdings, trades, watchlists, koin_point_balances, koin_point_transactions, user_risk_profiles, user_lesson_recommendations, friendships (as requester/addressee), friend_invites, cohort_memberships, weekly_leaderboard_snapshots, notifications_queue, content_flags (own)
- Public read: topics, levels, badges, sources, lessons (WHERE is_published = true), lesson_sources, content_variants (WHERE is_active = true), market_data, brokerage_recommendations, lesson_triggers, cohorts
- Admin only: lesson_reviews, analytics_events
- Special: certificates are public only via share_public_id; users can read their own row
