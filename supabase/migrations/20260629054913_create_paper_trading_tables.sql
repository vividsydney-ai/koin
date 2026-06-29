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
