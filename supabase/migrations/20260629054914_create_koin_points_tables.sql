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
