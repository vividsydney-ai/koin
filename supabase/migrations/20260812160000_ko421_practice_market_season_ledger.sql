-- KO-421: server-authoritative Koin Practice Market Season ledger.
--
-- This is a new, explicitly simulated product boundary. It does not read,
-- write, restore, or grant access to KO-417's archived legacy Paper Trading
-- tables. Authored future prices and event cards stay private until the
-- database-owned Jakarta session transition publishes them.

BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE TABLE public.practice_market_seasons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE CHECK (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  version SMALLINT NOT NULL DEFAULT 1 CHECK (version > 0),
  state TEXT NOT NULL DEFAULT 'draft'
    CHECK (state IN ('draft', 'preparing', 'active', 'closed', 'archived')),
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  source_pack_id TEXT NOT NULL,
  source_pack_checksum TEXT NOT NULL,
  disclosure_version TEXT NOT NULL,
  enrollment_opens_at TIMESTAMPTZ NOT NULL,
  enrollment_closes_at TIMESTAMPTZ NOT NULL,
  rank_entry_closes_at TIMESTAMPTZ,
  starting_cash NUMERIC(14,2) NOT NULL DEFAULT 10000000.00 CHECK (starting_cash > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (enrollment_closes_at > enrollment_opens_at),
  CHECK (rank_entry_closes_at IS NULL OR rank_entry_closes_at >= enrollment_opens_at)
);

CREATE TABLE public.practice_market_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  season_id UUID NOT NULL REFERENCES public.practice_market_seasons(id) ON DELETE CASCADE,
  session_number SMALLINT NOT NULL CHECK (session_number BETWEEN 1 AND 10),
  market_opens_at TIMESTAMPTZ NOT NULL,
  market_closes_at TIMESTAMPTZ NOT NULL,
  planning_desk_opens_at TIMESTAMPTZ NOT NULL,
  state TEXT NOT NULL DEFAULT 'scheduled'
    CHECK (state IN ('scheduled', 'open', 'locked', 'settled', 'cancelled')),
  opened_at TIMESTAMPTZ,
  locked_at TIMESTAMPTZ,
  settled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (season_id, session_number),
  CHECK (market_closes_at > market_opens_at),
  CHECK (planning_desk_opens_at >= market_closes_at)
);

CREATE TABLE public.practice_market_instruments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  season_id UUID NOT NULL REFERENCES public.practice_market_seasons(id) ON DELETE CASCADE,
  ticker TEXT NOT NULL CHECK (ticker = UPPER(ticker) AND ticker ~ '^[A-Z0-9]{2,8}$'),
  issuer_name TEXT NOT NULL,
  sector TEXT NOT NULL,
  listing_date DATE NOT NULL,
  listing_eligibility_reference TEXT NOT NULL,
  source_pack_reference TEXT NOT NULL,
  lot_size INTEGER NOT NULL DEFAULT 100 CHECK (lot_size = 100),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (season_id, ticker)
);

CREATE TABLE public.practice_market_price_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.practice_market_sessions(id) ON DELETE CASCADE,
  instrument_id UUID NOT NULL REFERENCES public.practice_market_instruments(id) ON DELETE CASCADE,
  point_kind TEXT NOT NULL CHECK (point_kind IN ('open', 'eod_close')),
  simulated_price NUMERIC(14,2) NOT NULL CHECK (simulated_price > 0),
  scenario_version TEXT NOT NULL,
  author_name TEXT NOT NULL,
  reviewer_name TEXT,
  reviewed_at TIMESTAMPTZ,
  publication_state TEXT NOT NULL DEFAULT 'draft'
    CHECK (publication_state IN ('draft', 'approved', 'published')),
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (session_id, instrument_id, point_kind),
  CHECK ((publication_state IN ('approved', 'published') AND reviewer_name IS NOT NULL AND reviewed_at IS NOT NULL)
    OR publication_state = 'draft'),
  CHECK ((publication_state = 'published' AND published_at IS NOT NULL)
    OR publication_state IN ('draft', 'approved'))
);

CREATE TABLE public.practice_market_event_cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  season_id UUID NOT NULL REFERENCES public.practice_market_seasons(id) ON DELETE CASCADE,
  session_id UUID NOT NULL REFERENCES public.practice_market_sessions(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  title_id TEXT NOT NULL,
  content JSONB NOT NULL,
  evidence_references JSONB NOT NULL DEFAULT '[]'::JSONB,
  non_advice_disclosure TEXT NOT NULL,
  reveal_at TIMESTAMPTZ NOT NULL,
  publication_state TEXT NOT NULL DEFAULT 'draft'
    CHECK (publication_state IN ('draft', 'approved', 'published')),
  published_at TIMESTAMPTZ,
  author_name TEXT NOT NULL,
  reviewer_name TEXT,
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (jsonb_typeof(content) = 'object'),
  CHECK (jsonb_typeof(evidence_references) = 'array'),
  CHECK ((publication_state IN ('approved', 'published') AND reviewer_name IS NOT NULL AND reviewed_at IS NOT NULL)
    OR publication_state = 'draft'),
  CHECK ((publication_state = 'published' AND published_at IS NOT NULL)
    OR publication_state IN ('draft', 'approved'))
);

CREATE TABLE public.practice_market_onboarding_completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  disclosure_version TEXT NOT NULL,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  acknowledgment JSONB NOT NULL DEFAULT '{"simulated":true,"noInvestmentAdvice":true}'::JSONB,
  UNIQUE (user_id, disclosure_version),
  CHECK (jsonb_typeof(acknowledgment) = 'object')
);

CREATE TABLE public.practice_market_memberships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  season_id UUID NOT NULL REFERENCES public.practice_market_seasons(id) ON DELETE RESTRICT,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  onboarding_completion_id UUID NOT NULL REFERENCES public.practice_market_onboarding_completions(id) ON DELETE RESTRICT,
  chapter_08_completed_at TIMESTAMPTZ NOT NULL,
  entry_session_number SMALLINT NOT NULL CHECK (entry_session_number BETWEEN 1 AND 10),
  rank_eligible BOOLEAN NOT NULL DEFAULT FALSE,
  leaderboard_opted_in BOOLEAN NOT NULL DEFAULT FALSE,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'withdrawn', 'suspended')),
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (season_id, user_id)
);

CREATE TABLE public.practice_market_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  membership_id UUID NOT NULL UNIQUE REFERENCES public.practice_market_memberships(id) ON DELETE RESTRICT,
  starting_cash NUMERIC(14,2) NOT NULL CHECK (starting_cash > 0),
  cash_balance NUMERIC(14,2) NOT NULL CHECK (cash_balance >= 0),
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'locked', 'closed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.practice_market_positions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.practice_market_accounts(id) ON DELETE RESTRICT,
  instrument_id UUID NOT NULL REFERENCES public.practice_market_instruments(id) ON DELETE RESTRICT,
  share_quantity BIGINT NOT NULL DEFAULT 0 CHECK (share_quantity >= 0),
  weighted_average_cost NUMERIC(14,6) NOT NULL DEFAULT 0 CHECK (weighted_average_cost >= 0),
  last_mark_price NUMERIC(14,2),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (account_id, instrument_id)
);

CREATE TABLE public.practice_market_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  membership_id UUID NOT NULL REFERENCES public.practice_market_memberships(id) ON DELETE RESTRICT,
  account_id UUID NOT NULL REFERENCES public.practice_market_accounts(id) ON DELETE RESTRICT,
  session_id UUID NOT NULL REFERENCES public.practice_market_sessions(id) ON DELETE RESTRICT,
  instrument_id UUID NOT NULL REFERENCES public.practice_market_instruments(id) ON DELETE RESTRICT,
  client_order_id UUID NOT NULL,
  side TEXT NOT NULL CHECK (side IN ('buy', 'sell')),
  order_type TEXT NOT NULL DEFAULT 'market' CHECK (order_type = 'market'),
  lot_count INTEGER NOT NULL CHECK (lot_count BETWEEN 1 AND 100000),
  share_quantity BIGINT NOT NULL CHECK (share_quantity > 0),
  status TEXT NOT NULL CHECK (status IN ('executed', 'rejected')),
  executed_price NUMERIC(14,2),
  gross_amount NUMERIC(16,2),
  rejection_code TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  executed_at TIMESTAMPTZ,
  UNIQUE (membership_id, client_order_id),
  CHECK (
    (status = 'executed' AND executed_price IS NOT NULL AND gross_amount IS NOT NULL
      AND rejection_code IS NULL AND executed_at IS NOT NULL)
    OR
    (status = 'rejected' AND executed_price IS NULL AND gross_amount IS NULL
      AND rejection_code IS NOT NULL AND executed_at IS NULL)
  )
);

CREATE TABLE public.practice_market_account_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.practice_market_accounts(id) ON DELETE RESTRICT,
  order_id UUID UNIQUE REFERENCES public.practice_market_orders(id) ON DELETE RESTRICT,
  entry_type TEXT NOT NULL CHECK (entry_type IN ('opening_balance', 'buy_debit', 'sell_credit')),
  amount NUMERIC(16,2) NOT NULL CHECK (amount <> 0),
  cash_balance_after NUMERIC(14,2) NOT NULL CHECK (cash_balance_after >= 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (
    (entry_type = 'opening_balance' AND order_id IS NULL AND amount > 0)
    OR (entry_type = 'buy_debit' AND order_id IS NOT NULL AND amount < 0)
    OR (entry_type = 'sell_credit' AND order_id IS NOT NULL AND amount > 0)
  )
);

CREATE UNIQUE INDEX practice_market_account_entries_one_opening_balance_idx
  ON public.practice_market_account_entries(account_id)
  WHERE entry_type = 'opening_balance';

CREATE TABLE public.practice_market_valuations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES public.practice_market_accounts(id) ON DELETE RESTRICT,
  session_id UUID NOT NULL REFERENCES public.practice_market_sessions(id) ON DELETE RESTRICT,
  cash_balance NUMERIC(14,2) NOT NULL CHECK (cash_balance >= 0),
  holdings_value NUMERIC(16,2) NOT NULL CHECK (holdings_value >= 0),
  total_value NUMERIC(16,2) NOT NULL CHECK (total_value >= 0),
  position_snapshot JSONB NOT NULL DEFAULT '[]'::JSONB,
  valued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (account_id, session_id),
  CHECK (total_value = cash_balance + holdings_value),
  CHECK (jsonb_typeof(position_snapshot) = 'array')
);

CREATE TABLE public.practice_market_decisions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  membership_id UUID NOT NULL REFERENCES public.practice_market_memberships(id) ON DELETE RESTRICT,
  session_id UUID NOT NULL REFERENCES public.practice_market_sessions(id) ON DELETE RESTRICT,
  instrument_id UUID REFERENCES public.practice_market_instruments(id) ON DELETE RESTRICT,
  client_decision_id UUID NOT NULL,
  planned_action TEXT NOT NULL CHECK (planned_action IN ('buy', 'sell', 'hold', 'observe')),
  rationale TEXT NOT NULL CHECK (char_length(trim(rationale)) BETWEEN 1 AND 1000),
  evidence JSONB NOT NULL DEFAULT '{}'::JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (membership_id, client_decision_id),
  CHECK (jsonb_typeof(evidence) = 'object')
);

CREATE TABLE public.practice_market_operation_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  operation_key TEXT NOT NULL UNIQUE,
  season_id UUID NOT NULL REFERENCES public.practice_market_seasons(id) ON DELETE RESTRICT,
  session_id UUID NOT NULL REFERENCES public.practice_market_sessions(id) ON DELETE RESTRICT,
  operation_type TEXT NOT NULL CHECK (operation_type IN ('open', 'lock', 'settle', 'reconcile', 'publish_event')),
  trigger_source TEXT NOT NULL CHECK (trigger_source IN ('cron', 'service', 'recovery')),
  result JSONB NOT NULL DEFAULT '{}'::JSONB,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CHECK (jsonb_typeof(result) = 'object')
);

CREATE INDEX practice_market_sessions_due_idx
  ON public.practice_market_sessions(season_id, state, market_opens_at, market_closes_at);
CREATE INDEX practice_market_price_points_publication_idx
  ON public.practice_market_price_points(session_id, publication_state, point_kind);
CREATE INDEX practice_market_memberships_user_idx
  ON public.practice_market_memberships(user_id, season_id);
CREATE INDEX practice_market_orders_account_created_idx
  ON public.practice_market_orders(account_id, created_at DESC);
CREATE INDEX practice_market_valuations_account_session_idx
  ON public.practice_market_valuations(account_id, session_id);
CREATE UNIQUE INDEX practice_market_operation_runs_exactly_once_session_idx
  ON public.practice_market_operation_runs(season_id, session_id, operation_type)
  WHERE operation_type IN ('open', 'lock', 'settle');

ALTER TABLE public.practice_market_seasons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_instruments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_price_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_event_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_onboarding_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_positions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_account_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_valuations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_decisions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_market_operation_runs ENABLE ROW LEVEL SECURITY;

-- Learners may inspect their own immutable ledger rows. There are deliberately
-- no direct INSERT/UPDATE/DELETE policies: all mutations go through RPCs.
CREATE POLICY "Practice Market members read own membership"
  ON public.practice_market_memberships FOR SELECT TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "Practice Market learners read own onboarding evidence"
  ON public.practice_market_onboarding_completions FOR SELECT TO authenticated
  USING (user_id = auth.uid());
CREATE POLICY "Practice Market learners read own account"
  ON public.practice_market_accounts FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.practice_market_memberships m
    WHERE m.id = practice_market_accounts.membership_id AND m.user_id = auth.uid()
  ));
CREATE POLICY "Practice Market learners read own positions"
  ON public.practice_market_positions FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1
    FROM public.practice_market_accounts a
    JOIN public.practice_market_memberships m ON m.id = a.membership_id
    WHERE a.id = practice_market_positions.account_id AND m.user_id = auth.uid()
  ));
CREATE POLICY "Practice Market learners read own orders"
  ON public.practice_market_orders FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.practice_market_memberships m
    WHERE m.id = practice_market_orders.membership_id AND m.user_id = auth.uid()
  ));
CREATE POLICY "Practice Market learners read own cash ledger"
  ON public.practice_market_account_entries FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1
    FROM public.practice_market_accounts a
    JOIN public.practice_market_memberships m ON m.id = a.membership_id
    WHERE a.id = practice_market_account_entries.account_id AND m.user_id = auth.uid()
  ));
CREATE POLICY "Practice Market learners read own valuations"
  ON public.practice_market_valuations FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1
    FROM public.practice_market_accounts a
    JOIN public.practice_market_memberships m ON m.id = a.membership_id
    WHERE a.id = practice_market_valuations.account_id AND m.user_id = auth.uid()
  ));
CREATE POLICY "Practice Market learners read own decisions"
  ON public.practice_market_decisions FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM public.practice_market_memberships m
    WHERE m.id = practice_market_decisions.membership_id AND m.user_id = auth.uid()
  ));

COMMENT ON POLICY "Practice Market members read own membership" ON public.practice_market_memberships IS
  'Learners can read only their own Season enrolment; account creation remains server-owned.';
COMMENT ON POLICY "Practice Market learners read own onboarding evidence" ON public.practice_market_onboarding_completions IS
  'Learners can inspect their own Before the Bell acknowledgement but cannot write it directly.';
COMMENT ON POLICY "Practice Market learners read own account" ON public.practice_market_accounts IS
  'Learners can inspect their own simulated cash account; browser writes are forbidden.';
COMMENT ON POLICY "Practice Market learners read own positions" ON public.practice_market_positions IS
  'Learners can inspect only positions belonging to their own Season account.';
COMMENT ON POLICY "Practice Market learners read own orders" ON public.practice_market_orders IS
  'Learners can inspect only their own immutable order receipts.';
COMMENT ON POLICY "Practice Market learners read own cash ledger" ON public.practice_market_account_entries IS
  'Learners can inspect only their own immutable cash ledger.';
COMMENT ON POLICY "Practice Market learners read own valuations" ON public.practice_market_valuations IS
  'Learners can inspect only their own session-close valuation ledger.';
COMMENT ON POLICY "Practice Market learners read own decisions" ON public.practice_market_decisions IS
  'Learners can inspect only their own private decision evidence.';

REVOKE ALL ON TABLE
  public.practice_market_seasons,
  public.practice_market_sessions,
  public.practice_market_instruments,
  public.practice_market_price_points,
  public.practice_market_event_cards,
  public.practice_market_onboarding_completions,
  public.practice_market_memberships,
  public.practice_market_accounts,
  public.practice_market_positions,
  public.practice_market_orders,
  public.practice_market_account_entries,
  public.practice_market_valuations,
  public.practice_market_decisions,
  public.practice_market_operation_runs
FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.practice_market_reject_revealed_content_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.publication_state = 'published' THEN
      RAISE EXCEPTION 'Practice Market content must be approved before the scheduler publishes it';
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    IF OLD.publication_state = 'published' THEN
      RAISE EXCEPTION 'Published Practice Market content is immutable';
    END IF;
    RETURN OLD;
  END IF;

  IF OLD.publication_state = 'published' THEN
    RAISE EXCEPTION 'Published Practice Market content is immutable';
  END IF;

  IF NEW.publication_state = 'published' AND OLD.publication_state <> 'approved' THEN
    RAISE EXCEPTION 'Only approved Practice Market content can be published';
  END IF;

  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_market_reject_ledger_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  RAISE EXCEPTION 'Practice Market ledger rows are immutable';
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_market_validate_scope()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_expected_user UUID;
  v_expected_season UUID;
  v_row JSONB := to_jsonb(NEW);
BEGIN
  IF TG_TABLE_NAME = 'practice_market_memberships' THEN
    SELECT user_id INTO v_expected_user
    FROM public.practice_market_onboarding_completions
    WHERE id = (v_row ->> 'onboarding_completion_id')::UUID;
    IF v_expected_user IS DISTINCT FROM (v_row ->> 'user_id')::UUID THEN
      RAISE EXCEPTION 'Practice Market onboarding evidence belongs to a different learner';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_price_points' THEN
    SELECT session.season_id INTO v_expected_season
    FROM public.practice_market_sessions session WHERE session.id = (v_row ->> 'session_id')::UUID;
    IF v_expected_season IS DISTINCT FROM (
      SELECT instrument.season_id FROM public.practice_market_instruments instrument WHERE instrument.id = (v_row ->> 'instrument_id')::UUID
    ) THEN
      RAISE EXCEPTION 'Practice Market price point instrument must belong to its session Season';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_event_cards' THEN
    SELECT season_id INTO v_expected_season FROM public.practice_market_sessions WHERE id = (v_row ->> 'session_id')::UUID;
    IF v_expected_season IS DISTINCT FROM (v_row ->> 'season_id')::UUID THEN
      RAISE EXCEPTION 'Practice Market event card session must belong to its Season';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_positions' THEN
    SELECT membership.season_id INTO v_expected_season
    FROM public.practice_market_accounts account
    JOIN public.practice_market_memberships membership ON membership.id = account.membership_id
    WHERE account.id = (v_row ->> 'account_id')::UUID;
    IF v_expected_season IS DISTINCT FROM (
      SELECT instrument.season_id FROM public.practice_market_instruments instrument WHERE instrument.id = (v_row ->> 'instrument_id')::UUID
    ) THEN
      RAISE EXCEPTION 'Practice Market position instrument must belong to its account Season';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_orders' THEN
    SELECT membership.season_id INTO v_expected_season
    FROM public.practice_market_memberships membership
    WHERE membership.id = (v_row ->> 'membership_id')::UUID;
    IF (v_row ->> 'account_id')::UUID IS DISTINCT FROM (
      SELECT account.id FROM public.practice_market_accounts account WHERE account.membership_id = (v_row ->> 'membership_id')::UUID
    ) OR v_expected_season IS DISTINCT FROM (
      SELECT session.season_id FROM public.practice_market_sessions session WHERE session.id = (v_row ->> 'session_id')::UUID
    ) OR v_expected_season IS DISTINCT FROM (
      SELECT instrument.season_id FROM public.practice_market_instruments instrument WHERE instrument.id = (v_row ->> 'instrument_id')::UUID
    ) THEN
      RAISE EXCEPTION 'Practice Market order references must belong to the same membership and Season';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_account_entries' AND (v_row ->> 'order_id') IS NOT NULL THEN
    IF (v_row ->> 'account_id')::UUID IS DISTINCT FROM (
      SELECT account_id FROM public.practice_market_orders WHERE id = (v_row ->> 'order_id')::UUID
    ) THEN
      RAISE EXCEPTION 'Practice Market account entry must belong to its order account';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_valuations' THEN
    SELECT membership.season_id INTO v_expected_season
    FROM public.practice_market_accounts account
    JOIN public.practice_market_memberships membership ON membership.id = account.membership_id
    WHERE account.id = (v_row ->> 'account_id')::UUID;
    IF v_expected_season IS DISTINCT FROM (
      SELECT season_id FROM public.practice_market_sessions WHERE id = (v_row ->> 'session_id')::UUID
    ) THEN
      RAISE EXCEPTION 'Practice Market valuation account and session must belong to the same Season';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_decisions' THEN
    SELECT season_id INTO v_expected_season FROM public.practice_market_memberships WHERE id = (v_row ->> 'membership_id')::UUID;
    IF v_expected_season IS DISTINCT FROM (
      SELECT season_id FROM public.practice_market_sessions WHERE id = (v_row ->> 'session_id')::UUID
    ) OR ((v_row ->> 'instrument_id') IS NOT NULL AND v_expected_season IS DISTINCT FROM (
      SELECT season_id FROM public.practice_market_instruments WHERE id = (v_row ->> 'instrument_id')::UUID
    )) THEN
      RAISE EXCEPTION 'Practice Market decision references must belong to the same Season';
    END IF;
  ELSIF TG_TABLE_NAME = 'practice_market_operation_runs' THEN
    SELECT season_id INTO v_expected_season FROM public.practice_market_sessions WHERE id = (v_row ->> 'session_id')::UUID;
    IF v_expected_season IS DISTINCT FROM (v_row ->> 'season_id')::UUID THEN
      RAISE EXCEPTION 'Practice Market operation must reference a session in its Season';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER practice_market_price_points_immutable_after_publish
  BEFORE INSERT OR UPDATE OR DELETE ON public.practice_market_price_points
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_revealed_content_mutation();
CREATE TRIGGER practice_market_event_cards_immutable_after_publish
  BEFORE INSERT OR UPDATE OR DELETE ON public.practice_market_event_cards
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_revealed_content_mutation();
CREATE TRIGGER practice_market_orders_immutable
  BEFORE UPDATE OR DELETE ON public.practice_market_orders
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_ledger_mutation();
CREATE TRIGGER practice_market_account_entries_immutable
  BEFORE UPDATE OR DELETE ON public.practice_market_account_entries
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_ledger_mutation();
CREATE TRIGGER practice_market_valuations_immutable
  BEFORE UPDATE OR DELETE ON public.practice_market_valuations
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_ledger_mutation();
CREATE TRIGGER practice_market_decisions_immutable
  BEFORE UPDATE OR DELETE ON public.practice_market_decisions
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_ledger_mutation();
CREATE TRIGGER practice_market_operation_runs_immutable
  BEFORE UPDATE OR DELETE ON public.practice_market_operation_runs
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_reject_ledger_mutation();
CREATE TRIGGER practice_market_memberships_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_memberships
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_price_points_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_price_points
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_event_cards_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_event_cards
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_positions_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_positions
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_orders_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_orders
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_account_entries_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_account_entries
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_valuations_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_valuations
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_decisions_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_decisions
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();
CREATE TRIGGER practice_market_operation_runs_validate_scope
  BEFORE INSERT OR UPDATE ON public.practice_market_operation_runs
  FOR EACH ROW EXECUTE FUNCTION public.practice_market_validate_scope();

CREATE OR REPLACE FUNCTION public.practice_market_access_is_enabled()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
  SELECT COALESCE((
    SELECT season_access_enabled
    FROM public.practice_market_cutover_state
    WHERE id = TRUE
  ), FALSE)
$$;

CREATE OR REPLACE FUNCTION public.complete_practice_market_onboarding(
  p_disclosure_version TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_completion public.practice_market_onboarding_completions%ROWTYPE;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF NOT public.practice_market_access_is_enabled() THEN
    RAISE EXCEPTION 'Practice Market is currently unavailable';
  END IF;

  IF p_disclosure_version IS NULL OR char_length(trim(p_disclosure_version)) = 0 THEN
    RAISE EXCEPTION 'A Practice Market disclosure version is required';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.practice_market_seasons s
    WHERE s.disclosure_version = p_disclosure_version
      AND s.state IN ('preparing', 'active')
  ) THEN
    RAISE EXCEPTION 'Practice Market onboarding is not available for this disclosure version';
  END IF;

  INSERT INTO public.practice_market_onboarding_completions (user_id, disclosure_version)
  VALUES (v_user_id, p_disclosure_version)
  ON CONFLICT (user_id, disclosure_version) DO NOTHING
  RETURNING * INTO v_completion;

  IF v_completion.id IS NULL THEN
    SELECT * INTO v_completion
    FROM public.practice_market_onboarding_completions
    WHERE user_id = v_user_id AND disclosure_version = p_disclosure_version;
  END IF;

  RETURN jsonb_build_object(
    'completed', TRUE,
    'disclosure_version', v_completion.disclosure_version,
    'completed_at', v_completion.completed_at
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.claim_practice_market_membership(
  p_season_slug TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_season public.practice_market_seasons%ROWTYPE;
  v_membership public.practice_market_memberships%ROWTYPE;
  v_account public.practice_market_accounts%ROWTYPE;
  v_onboarding public.practice_market_onboarding_completions%ROWTYPE;
  v_required_count INTEGER;
  v_completed_at TIMESTAMPTZ;
  v_entry_session SMALLINT;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;

  SELECT s.* INTO v_season
  FROM public.practice_market_seasons s
  JOIN public.practice_market_cutover_state cutover ON cutover.id = TRUE
  WHERE s.slug = p_season_slug
    AND s.state IN ('preparing', 'active')
    AND cutover.season_access_enabled = TRUE
  FOR UPDATE;

  IF v_season.id IS NULL THEN
    RAISE EXCEPTION 'Practice Market Season is not available';
  END IF;

  IF NOW() < v_season.enrollment_opens_at OR NOW() > v_season.enrollment_closes_at THEN
    RAISE EXCEPTION 'Season enrolment is closed';
  END IF;

  SELECT COUNT(*) INTO v_required_count
  FROM public.lessons l
  JOIN public.topics t ON t.id = l.topic_id
  WHERE l.is_published = TRUE AND t.chapter = 'Investing in Indonesia';

  SELECT MAX(lp.first_completed_at) INTO v_completed_at
  FROM public.lesson_progress lp
  JOIN public.lessons l ON l.id = lp.lesson_id
  JOIN public.topics t ON t.id = l.topic_id
  WHERE lp.user_id = v_user_id
    AND lp.status = 'completed'
    AND l.is_published = TRUE
    AND t.chapter = 'Investing in Indonesia';

  IF v_required_count = 0 OR (
    SELECT COUNT(DISTINCT lp.lesson_id)
    FROM public.lesson_progress lp
    JOIN public.lessons l ON l.id = lp.lesson_id
    JOIN public.topics t ON t.id = l.topic_id
    WHERE lp.user_id = v_user_id
      AND lp.status = 'completed'
      AND l.is_published = TRUE
      AND t.chapter = 'Investing in Indonesia'
  ) <> v_required_count THEN
    RAISE EXCEPTION 'Complete Chapter 08 — Investing in Indonesia before joining Practice Market';
  END IF;

  SELECT * INTO v_onboarding
  FROM public.practice_market_onboarding_completions
  WHERE user_id = v_user_id AND disclosure_version = v_season.disclosure_version;

  IF v_onboarding.id IS NULL THEN
    RAISE EXCEPTION 'Complete Before the Bell onboarding before joining Practice Market';
  END IF;

  SELECT * INTO v_membership
  FROM public.practice_market_memberships
  WHERE season_id = v_season.id AND user_id = v_user_id
  FOR UPDATE;

  IF v_membership.id IS NOT NULL THEN
    SELECT * INTO v_account FROM public.practice_market_accounts WHERE membership_id = v_membership.id;
    RETURN jsonb_build_object(
      'joined', TRUE,
      'membership_id', v_membership.id,
      'account_id', v_account.id,
      'cash_balance', v_account.cash_balance,
      'idempotent', TRUE
    );
  END IF;

  SELECT COALESCE(MAX(session_number) FILTER (WHERE market_opens_at <= NOW()), 1)
  INTO v_entry_session
  FROM public.practice_market_sessions
  WHERE season_id = v_season.id;

  INSERT INTO public.practice_market_memberships (
    season_id,
    user_id,
    onboarding_completion_id,
    chapter_08_completed_at,
    entry_session_number,
    rank_eligible
  ) VALUES (
    v_season.id,
    v_user_id,
    v_onboarding.id,
    COALESCE(v_completed_at, NOW()),
    v_entry_session,
    v_season.rank_entry_closes_at IS NULL OR NOW() <= v_season.rank_entry_closes_at
  ) RETURNING * INTO v_membership;

  INSERT INTO public.practice_market_accounts (membership_id, starting_cash, cash_balance)
  VALUES (v_membership.id, v_season.starting_cash, v_season.starting_cash)
  RETURNING * INTO v_account;

  INSERT INTO public.practice_market_account_entries (
    account_id, entry_type, amount, cash_balance_after
  ) VALUES (
    v_account.id, 'opening_balance', v_account.starting_cash, v_account.cash_balance
  );

  RETURN jsonb_build_object(
    'joined', TRUE,
    'membership_id', v_membership.id,
    'account_id', v_account.id,
    'cash_balance', v_account.cash_balance,
    'idempotent', FALSE
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.record_practice_market_decision(
  p_season_slug TEXT,
  p_session_number SMALLINT,
  p_ticker TEXT,
  p_planned_action TEXT,
  p_rationale TEXT,
  p_evidence JSONB,
  p_client_decision_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_membership public.practice_market_memberships%ROWTYPE;
  v_session public.practice_market_sessions%ROWTYPE;
  v_instrument_id UUID;
  v_decision public.practice_market_decisions%ROWTYPE;
  v_idempotent BOOLEAN := FALSE;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF NOT public.practice_market_access_is_enabled() THEN
    RAISE EXCEPTION 'Practice Market is currently unavailable';
  END IF;
  IF p_planned_action NOT IN ('buy', 'sell', 'hold', 'observe') THEN
    RAISE EXCEPTION 'Invalid planned action';
  END IF;
  IF p_rationale IS NULL OR char_length(trim(p_rationale)) NOT BETWEEN 1 AND 1000 THEN
    RAISE EXCEPTION 'A concise decision rationale is required';
  END IF;
  IF p_evidence IS NULL OR jsonb_typeof(p_evidence) <> 'object' THEN
    RAISE EXCEPTION 'Decision evidence must be an object';
  END IF;

  SELECT m.* INTO v_membership
  FROM public.practice_market_memberships m
  JOIN public.practice_market_seasons s ON s.id = m.season_id
  WHERE m.user_id = v_user_id AND m.status = 'active' AND s.slug = p_season_slug;
  IF v_membership.id IS NULL THEN
    RAISE EXCEPTION 'Join the Practice Market Season before recording a decision';
  END IF;

  SELECT * INTO v_session
  FROM public.practice_market_sessions
  WHERE season_id = v_membership.season_id AND session_number = p_session_number
    AND state = 'open' AND NOW() >= market_opens_at AND NOW() < market_closes_at;
  IF v_session.id IS NULL THEN
    RAISE EXCEPTION 'Decision evidence can only be recorded during an open session';
  END IF;

  IF p_ticker IS NOT NULL THEN
    SELECT id INTO v_instrument_id
    FROM public.practice_market_instruments
    WHERE season_id = v_membership.season_id AND ticker = UPPER(p_ticker) AND is_active = TRUE;
    IF v_instrument_id IS NULL THEN
      RAISE EXCEPTION 'Instrument is not available in this Practice Market Season';
    END IF;
  END IF;

  INSERT INTO public.practice_market_decisions (
    membership_id, session_id, instrument_id, client_decision_id, planned_action, rationale, evidence
  ) VALUES (
    v_membership.id, v_session.id, v_instrument_id, p_client_decision_id,
    p_planned_action, trim(p_rationale), p_evidence
  ) ON CONFLICT (membership_id, client_decision_id) DO NOTHING
  RETURNING * INTO v_decision;

  IF v_decision.id IS NULL THEN
    SELECT * INTO v_decision
    FROM public.practice_market_decisions
    WHERE membership_id = v_membership.id AND client_decision_id = p_client_decision_id;
    v_idempotent := TRUE;
  END IF;

  RETURN jsonb_build_object('decision_id', v_decision.id, 'idempotent', v_idempotent);
END;
$$;

CREATE OR REPLACE FUNCTION public.place_practice_market_order(
  p_season_slug TEXT,
  p_ticker TEXT,
  p_side TEXT,
  p_lot_count INTEGER,
  p_client_order_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_membership public.practice_market_memberships%ROWTYPE;
  v_account public.practice_market_accounts%ROWTYPE;
  v_session public.practice_market_sessions%ROWTYPE;
  v_instrument public.practice_market_instruments%ROWTYPE;
  v_position public.practice_market_positions%ROWTYPE;
  v_order public.practice_market_orders%ROWTYPE;
  v_price NUMERIC(14,2);
  v_share_quantity BIGINT;
  v_gross_amount NUMERIC(16,2);
  v_new_cash NUMERIC(14,2);
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF NOT public.practice_market_access_is_enabled() THEN
    RAISE EXCEPTION 'Practice Market is currently unavailable';
  END IF;
  IF p_side NOT IN ('buy', 'sell') THEN
    RAISE EXCEPTION 'Invalid order side';
  END IF;
  IF p_lot_count IS NULL OR p_lot_count NOT BETWEEN 1 AND 100000 THEN
    RAISE EXCEPTION 'Lot count must be between 1 and 100000';
  END IF;
  IF p_client_order_id IS NULL THEN
    RAISE EXCEPTION 'A client order id is required';
  END IF;

  SELECT m.* INTO v_membership
  FROM public.practice_market_memberships m
  JOIN public.practice_market_seasons s ON s.id = m.season_id
  WHERE m.user_id = v_user_id AND m.status = 'active' AND s.slug = p_season_slug;
  IF v_membership.id IS NULL THEN
    RAISE EXCEPTION 'Join the Practice Market Season before placing an order';
  END IF;

  SELECT * INTO v_account
  FROM public.practice_market_accounts
  WHERE membership_id = v_membership.id AND status = 'active'
  FOR UPDATE;
  IF v_account.id IS NULL THEN
    RAISE EXCEPTION 'Practice Market account is not active';
  END IF;

  SELECT * INTO v_order
  FROM public.practice_market_orders
  WHERE membership_id = v_membership.id AND client_order_id = p_client_order_id;
  IF v_order.id IS NOT NULL THEN
    RETURN jsonb_build_object(
      'order_id', v_order.id,
      'status', v_order.status,
      'ticker', p_ticker,
      'side', v_order.side,
      'lot_count', v_order.lot_count,
      'executed_price', v_order.executed_price,
      'gross_amount', v_order.gross_amount,
      'rejection_code', v_order.rejection_code,
      'cash_balance', v_account.cash_balance,
      'idempotent', TRUE
    );
  END IF;

  SELECT * INTO v_session
  FROM public.practice_market_sessions
  WHERE season_id = v_membership.season_id
    AND state = 'open'
    AND NOW() >= market_opens_at
    AND NOW() < market_closes_at
  ORDER BY session_number DESC
  LIMIT 1
  FOR UPDATE;
  IF v_session.id IS NULL THEN
    RAISE EXCEPTION 'Practice Market is currently closed';
  END IF;

  SELECT * INTO v_instrument
  FROM public.practice_market_instruments
  WHERE season_id = v_membership.season_id
    AND ticker = UPPER(p_ticker)
    AND is_active = TRUE;
  IF v_instrument.id IS NULL THEN
    RAISE EXCEPTION 'Instrument is not available in this Practice Market Season';
  END IF;

  SELECT simulated_price INTO v_price
  FROM public.practice_market_price_points
  WHERE session_id = v_session.id
    AND instrument_id = v_instrument.id
    AND point_kind = 'open'
    AND publication_state = 'published'
    AND published_at <= NOW();
  IF v_price IS NULL THEN
    RAISE EXCEPTION 'The simulated market open is not available yet';
  END IF;

  v_share_quantity := p_lot_count::BIGINT * v_instrument.lot_size;
  v_gross_amount := v_share_quantity * v_price;

  SELECT * INTO v_position
  FROM public.practice_market_positions
  WHERE account_id = v_account.id AND instrument_id = v_instrument.id
  FOR UPDATE;

  IF p_side = 'buy' AND v_account.cash_balance < v_gross_amount THEN
    INSERT INTO public.practice_market_orders (
      membership_id, account_id, session_id, instrument_id, client_order_id,
      side, lot_count, share_quantity, status, rejection_code
    ) VALUES (
      v_membership.id, v_account.id, v_session.id, v_instrument.id, p_client_order_id,
      p_side, p_lot_count, v_share_quantity, 'rejected', 'insufficient_cash'
    ) RETURNING * INTO v_order;
    RETURN jsonb_build_object(
      'order_id', v_order.id, 'status', 'rejected', 'rejection_code', v_order.rejection_code,
      'cash_balance', v_account.cash_balance, 'idempotent', FALSE
    );
  END IF;

  IF p_side = 'sell' AND (v_position.id IS NULL OR v_position.share_quantity < v_share_quantity) THEN
    INSERT INTO public.practice_market_orders (
      membership_id, account_id, session_id, instrument_id, client_order_id,
      side, lot_count, share_quantity, status, rejection_code
    ) VALUES (
      v_membership.id, v_account.id, v_session.id, v_instrument.id, p_client_order_id,
      p_side, p_lot_count, v_share_quantity, 'rejected', 'insufficient_shares'
    ) RETURNING * INTO v_order;
    RETURN jsonb_build_object(
      'order_id', v_order.id, 'status', 'rejected', 'rejection_code', v_order.rejection_code,
      'cash_balance', v_account.cash_balance, 'idempotent', FALSE
    );
  END IF;

  INSERT INTO public.practice_market_orders (
    membership_id, account_id, session_id, instrument_id, client_order_id,
    side, lot_count, share_quantity, status, executed_price, gross_amount, executed_at
  ) VALUES (
    v_membership.id, v_account.id, v_session.id, v_instrument.id, p_client_order_id,
    p_side, p_lot_count, v_share_quantity, 'executed', v_price, v_gross_amount, NOW()
  ) RETURNING * INTO v_order;

  IF p_side = 'buy' THEN
    v_new_cash := v_account.cash_balance - v_gross_amount;
    IF v_position.id IS NULL THEN
      INSERT INTO public.practice_market_positions (
        account_id, instrument_id, share_quantity, weighted_average_cost, last_mark_price
      ) VALUES (
        v_account.id, v_instrument.id, v_share_quantity, v_price, v_price
      );
    ELSE
      UPDATE public.practice_market_positions
      SET share_quantity = share_quantity + v_share_quantity,
          weighted_average_cost = ((share_quantity * weighted_average_cost) + (v_share_quantity * v_price))
            / (share_quantity + v_share_quantity),
          last_mark_price = v_price,
          updated_at = NOW()
      WHERE id = v_position.id;
    END IF;
    UPDATE public.practice_market_accounts
    SET cash_balance = v_new_cash, updated_at = NOW()
    WHERE id = v_account.id;
    INSERT INTO public.practice_market_account_entries (
      account_id, order_id, entry_type, amount, cash_balance_after
    ) VALUES (
      v_account.id, v_order.id, 'buy_debit', -v_gross_amount, v_new_cash
    );
  ELSE
    v_new_cash := v_account.cash_balance + v_gross_amount;
    UPDATE public.practice_market_positions
    SET share_quantity = share_quantity - v_share_quantity,
        last_mark_price = v_price,
        updated_at = NOW()
    WHERE id = v_position.id;
    UPDATE public.practice_market_accounts
    SET cash_balance = v_new_cash, updated_at = NOW()
    WHERE id = v_account.id;
    INSERT INTO public.practice_market_account_entries (
      account_id, order_id, entry_type, amount, cash_balance_after
    ) VALUES (
      v_account.id, v_order.id, 'sell_credit', v_gross_amount, v_new_cash
    );
  END IF;

  RETURN jsonb_build_object(
    'order_id', v_order.id,
    'status', 'executed',
    'ticker', v_instrument.ticker,
    'side', v_order.side,
    'lot_count', v_order.lot_count,
    'share_quantity', v_order.share_quantity,
    'executed_price', v_order.executed_price,
    'gross_amount', v_order.gross_amount,
    'cash_balance', v_new_cash,
    'idempotent', FALSE
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_market_open_session(
  p_session_id UUID,
  p_trigger_source TEXT DEFAULT 'cron'
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_session public.practice_market_sessions%ROWTYPE;
  v_expected_points INTEGER;
  v_actual_points INTEGER;
BEGIN
  IF p_trigger_source NOT IN ('cron', 'service', 'recovery') THEN
    RAISE EXCEPTION 'Invalid Practice Market operation source';
  END IF;

  SELECT * INTO v_session
  FROM public.practice_market_sessions
  WHERE id = p_session_id
  FOR UPDATE;
  IF v_session.id IS NULL OR v_session.state <> 'scheduled' OR NOW() < v_session.market_opens_at THEN
    RETURN FALSE;
  END IF;

  SELECT COUNT(*) INTO v_expected_points
  FROM public.practice_market_instruments
  WHERE season_id = v_session.season_id AND is_active = TRUE;
  SELECT COUNT(*) INTO v_actual_points
  FROM public.practice_market_price_points
  WHERE session_id = v_session.id
    AND point_kind = 'open'
    AND publication_state = 'approved';
  IF v_expected_points = 0 OR v_actual_points <> v_expected_points THEN
    RAISE EXCEPTION 'Session % cannot open without approved simulated open prices', v_session.session_number;
  END IF;

  UPDATE public.practice_market_price_points
  SET publication_state = 'published', published_at = NOW()
  WHERE session_id = v_session.id AND point_kind = 'open' AND publication_state = 'approved';
  UPDATE public.practice_market_sessions
  SET state = 'open', opened_at = NOW()
  WHERE id = v_session.id;
  INSERT INTO public.practice_market_operation_runs (
    operation_key, season_id, session_id, operation_type, trigger_source, result
  ) VALUES (
    'open:' || v_session.id::TEXT,
    v_session.season_id,
    v_session.id,
    'open',
    p_trigger_source,
    jsonb_build_object('session_number', v_session.session_number, 'published_open_prices', v_actual_points)
  ) ON CONFLICT (operation_key) DO NOTHING;
  RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_market_settle_session(
  p_session_id UUID,
  p_trigger_source TEXT DEFAULT 'cron'
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_session public.practice_market_sessions%ROWTYPE;
  v_expected_points INTEGER;
  v_actual_points INTEGER;
  v_expected_accounts INTEGER;
  v_valuations_written INTEGER;
BEGIN
  IF p_trigger_source NOT IN ('cron', 'service', 'recovery') THEN
    RAISE EXCEPTION 'Invalid Practice Market operation source';
  END IF;

  SELECT * INTO v_session
  FROM public.practice_market_sessions
  WHERE id = p_session_id
  FOR UPDATE;
  IF v_session.id IS NULL OR v_session.state <> 'open' OR NOW() < v_session.market_closes_at THEN
    RETURN FALSE;
  END IF;

  SELECT COUNT(*) INTO v_expected_points
  FROM public.practice_market_instruments
  WHERE season_id = v_session.season_id AND is_active = TRUE;
  SELECT COUNT(*) INTO v_actual_points
  FROM public.practice_market_price_points
  WHERE session_id = v_session.id
    AND point_kind = 'eod_close'
    AND publication_state = 'approved';
  IF v_expected_points = 0 OR v_actual_points <> v_expected_points THEN
    RAISE EXCEPTION 'Session % cannot settle without approved simulated EOD prices', v_session.session_number;
  END IF;

  UPDATE public.practice_market_sessions
  SET state = 'locked', locked_at = NOW()
  WHERE id = v_session.id;
  INSERT INTO public.practice_market_operation_runs (
    operation_key, season_id, session_id, operation_type, trigger_source, result
  ) VALUES (
    'lock:' || v_session.id::TEXT,
    v_session.season_id,
    v_session.id,
    'lock',
    p_trigger_source,
    jsonb_build_object('session_number', v_session.session_number, 'locked_at', NOW())
  ) ON CONFLICT (operation_key) DO NOTHING;

  UPDATE public.practice_market_price_points
  SET publication_state = 'published', published_at = NOW()
  WHERE session_id = v_session.id AND point_kind = 'eod_close' AND publication_state = 'approved';
  UPDATE public.practice_market_positions p
  SET last_mark_price = point.simulated_price,
      updated_at = NOW()
  FROM public.practice_market_accounts a,
       public.practice_market_memberships m,
       public.practice_market_price_points point
  WHERE p.account_id = a.id
    AND m.id = a.membership_id
    AND point.instrument_id = p.instrument_id
    AND point.session_id = v_session.id
    AND point.point_kind = 'eod_close'
    AND point.publication_state = 'published'
    AND m.season_id = v_session.season_id
    AND m.status = 'active';

  SELECT COUNT(*) INTO v_expected_accounts
  FROM public.practice_market_accounts a
  JOIN public.practice_market_memberships m ON m.id = a.membership_id
  WHERE m.season_id = v_session.season_id AND m.status = 'active' AND a.status = 'active';

  INSERT INTO public.practice_market_valuations (
    account_id, session_id, cash_balance, holdings_value, total_value, position_snapshot
  )
  SELECT
    a.id,
    v_session.id,
    a.cash_balance,
    COALESCE(SUM(p.share_quantity * point.simulated_price) FILTER (WHERE p.share_quantity > 0), 0),
    a.cash_balance + COALESCE(SUM(p.share_quantity * point.simulated_price) FILTER (WHERE p.share_quantity > 0), 0),
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'ticker', i.ticker,
          'shares', p.share_quantity,
          'eod_close', point.simulated_price,
          'value', p.share_quantity * point.simulated_price
        ) ORDER BY i.ticker
      ) FILTER (WHERE p.share_quantity > 0),
      '[]'::JSONB
    )
  FROM public.practice_market_accounts a
  JOIN public.practice_market_memberships m ON m.id = a.membership_id
  LEFT JOIN public.practice_market_positions p ON p.account_id = a.id
  LEFT JOIN public.practice_market_instruments i ON i.id = p.instrument_id
  LEFT JOIN public.practice_market_price_points point
    ON point.instrument_id = p.instrument_id
   AND point.session_id = v_session.id
   AND point.point_kind = 'eod_close'
   AND point.publication_state = 'published'
  WHERE m.season_id = v_session.season_id AND m.status = 'active' AND a.status = 'active'
  GROUP BY a.id, a.cash_balance;
  GET DIAGNOSTICS v_valuations_written = ROW_COUNT;
  IF v_valuations_written <> v_expected_accounts THEN
    RAISE EXCEPTION 'Settlement valuation count mismatch: expected %, wrote %', v_expected_accounts, v_valuations_written;
  END IF;

  UPDATE public.practice_market_sessions
  SET state = 'settled', settled_at = NOW()
  WHERE id = v_session.id;
  INSERT INTO public.practice_market_operation_runs (
    operation_key, season_id, session_id, operation_type, trigger_source, result
  ) VALUES (
    'settle:' || v_session.id::TEXT,
    v_session.season_id,
    v_session.id,
    'settle',
    p_trigger_source,
    jsonb_build_object(
      'session_number', v_session.session_number,
      'published_eod_prices', v_actual_points,
      'valuations_written', v_valuations_written
    )
  ) ON CONFLICT (operation_key) DO NOTHING;
  RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_market_publish_due_event_cards(
  p_session_id UUID,
  p_trigger_source TEXT DEFAULT 'cron'
)
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_session public.practice_market_sessions%ROWTYPE;
  v_event RECORD;
  v_published INTEGER := 0;
BEGIN
  IF p_trigger_source NOT IN ('cron', 'service', 'recovery') THEN
    RAISE EXCEPTION 'Invalid Practice Market operation source';
  END IF;

  SELECT * INTO v_session
  FROM public.practice_market_sessions
  WHERE id = p_session_id
  FOR UPDATE;
  IF v_session.id IS NULL OR v_session.state <> 'open' THEN
    RETURN 0;
  END IF;

  FOR v_event IN
    UPDATE public.practice_market_event_cards
    SET publication_state = 'published', published_at = NOW()
    WHERE session_id = v_session.id
      AND publication_state = 'approved'
      AND reveal_at <= NOW()
    RETURNING id, title
  LOOP
    INSERT INTO public.practice_market_operation_runs (
      operation_key, season_id, session_id, operation_type, trigger_source, result
    ) VALUES (
      'publish_event:' || v_event.id::TEXT,
      v_session.season_id,
      v_session.id,
      'publish_event',
      p_trigger_source,
      jsonb_build_object('event_card_id', v_event.id, 'title', v_event.title)
    ) ON CONFLICT (operation_key) DO NOTHING;
    v_published := v_published + 1;
  END LOOP;

  RETURN v_published;
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_market_tick(
  p_trigger_source TEXT DEFAULT 'cron'
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_session RECORD;
  v_opened INTEGER := 0;
  v_events_published INTEGER := 0;
  v_settled INTEGER := 0;
BEGIN
  IF p_trigger_source NOT IN ('cron', 'service', 'recovery') THEN
    RAISE EXCEPTION 'Invalid Practice Market operation source';
  END IF;

  FOR v_session IN
    SELECT session.id
    FROM public.practice_market_sessions session
    JOIN public.practice_market_seasons season ON season.id = session.season_id
    WHERE season.state = 'active'
      AND session.state = 'scheduled'
      AND session.market_opens_at <= NOW()
    ORDER BY session.market_opens_at ASC
  LOOP
    IF public.practice_market_open_session(v_session.id, p_trigger_source) THEN
      v_opened := v_opened + 1;
    END IF;
  END LOOP;

  FOR v_session IN
    SELECT session.id
    FROM public.practice_market_sessions session
    JOIN public.practice_market_seasons season ON season.id = session.season_id
    WHERE season.state = 'active'
      AND session.state = 'open'
  LOOP
    v_events_published := v_events_published
      + public.practice_market_publish_due_event_cards(v_session.id, p_trigger_source);
  END LOOP;

  FOR v_session IN
    SELECT session.id
    FROM public.practice_market_sessions session
    JOIN public.practice_market_seasons season ON season.id = session.season_id
    WHERE season.state = 'active'
      AND session.state = 'open'
      AND session.market_closes_at <= NOW()
    ORDER BY session.market_closes_at ASC
  LOOP
    IF public.practice_market_settle_session(v_session.id, p_trigger_source) THEN
      v_settled := v_settled + 1;
    END IF;
  END LOOP;

  RETURN jsonb_build_object(
    'opened', v_opened,
    'events_published', v_events_published,
    'settled', v_settled,
    'jakarta_now', timezone('Asia/Jakarta', NOW())
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_practice_market_event_cards(
  p_season_slug TEXT
)
RETURNS TABLE (
  session_number SMALLINT,
  revealed_at TIMESTAMPTZ,
  title TEXT,
  title_id TEXT,
  content JSONB,
  evidence_references JSONB,
  non_advice_disclosure TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_season_id UUID;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF NOT public.practice_market_access_is_enabled() THEN
    RAISE EXCEPTION 'Practice Market is currently unavailable';
  END IF;

  SELECT membership.season_id INTO v_season_id
  FROM public.practice_market_memberships membership
  JOIN public.practice_market_seasons season ON season.id = membership.season_id
  WHERE membership.user_id = v_user_id
    AND membership.status = 'active'
    AND season.slug = p_season_slug;
  IF v_season_id IS NULL THEN
    RAISE EXCEPTION 'Join the Practice Market Season before viewing event cards';
  END IF;

  RETURN QUERY
  SELECT
    session.session_number,
    event_card.published_at,
    event_card.title,
    event_card.title_id,
    event_card.content,
    event_card.evidence_references,
    event_card.non_advice_disclosure
  FROM public.practice_market_event_cards event_card
  JOIN public.practice_market_sessions session ON session.id = event_card.session_id
  WHERE event_card.season_id = v_season_id
    AND event_card.publication_state = 'published'
    AND event_card.published_at <= NOW()
  ORDER BY session.session_number, event_card.published_at;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_practice_market_trade_board(
  p_season_slug TEXT
)
RETURNS TABLE (
  session_number SMALLINT,
  session_state TEXT,
  market_opens_at TIMESTAMPTZ,
  market_closes_at TIMESTAMPTZ,
  ticker TEXT,
  issuer_name TEXT,
  sector TEXT,
  open_price NUMERIC,
  eod_close_price NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
  v_season_id UUID;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF NOT public.practice_market_access_is_enabled() THEN
    RAISE EXCEPTION 'Practice Market is currently unavailable';
  END IF;

  SELECT m.season_id INTO v_season_id
  FROM public.practice_market_memberships m
  JOIN public.practice_market_seasons s ON s.id = m.season_id
  WHERE m.user_id = v_user_id AND m.status = 'active' AND s.slug = p_season_slug;
  IF v_season_id IS NULL THEN
    RAISE EXCEPTION 'Join the Practice Market Season before viewing the trade board';
  END IF;

  RETURN QUERY
  SELECT
    session.session_number,
    session.state,
    session.market_opens_at,
    session.market_closes_at,
    instrument.ticker,
    instrument.issuer_name,
    instrument.sector,
    MAX(point.simulated_price) FILTER (WHERE point.point_kind = 'open') AS open_price,
    MAX(point.simulated_price) FILTER (WHERE point.point_kind = 'eod_close') AS eod_close_price
  FROM public.practice_market_sessions session
  JOIN public.practice_market_instruments instrument
    ON instrument.season_id = session.season_id AND instrument.is_active = TRUE
  JOIN public.practice_market_price_points point
    ON point.session_id = session.id
   AND point.instrument_id = instrument.id
   AND point.publication_state = 'published'
   AND point.published_at <= NOW()
  WHERE session.season_id = v_season_id
    AND session.state IN ('open', 'locked', 'settled')
  GROUP BY
    session.session_number, session.state, session.market_opens_at, session.market_closes_at,
    instrument.ticker, instrument.issuer_name, instrument.sector
  ORDER BY session.session_number, instrument.ticker;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_practice_market_valuation_history(
  p_season_slug TEXT
)
RETURNS TABLE (
  session_number SMALLINT,
  valued_at TIMESTAMPTZ,
  cash_balance NUMERIC,
  holdings_value NUMERIC,
  total_value NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  v_user_id UUID := auth.uid();
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Not authorized' USING ERRCODE = 'insufficient_privilege';
  END IF;
  IF NOT public.practice_market_access_is_enabled() THEN
    RAISE EXCEPTION 'Practice Market is currently unavailable';
  END IF;

  RETURN QUERY
  SELECT session.session_number, valuation.valued_at,
    valuation.cash_balance, valuation.holdings_value, valuation.total_value
  FROM public.practice_market_valuations valuation
  JOIN public.practice_market_accounts account ON account.id = valuation.account_id
  JOIN public.practice_market_memberships membership ON membership.id = account.membership_id
  JOIN public.practice_market_seasons season ON season.id = membership.season_id
  JOIN public.practice_market_sessions session ON session.id = valuation.session_id
  WHERE membership.user_id = v_user_id
    AND membership.status = 'active'
    AND season.slug = p_season_slug
  ORDER BY session.session_number;
END;
$$;

CREATE OR REPLACE VIEW public.practice_market_operations_health AS
SELECT
  season.slug AS season_slug,
  session.session_number,
  session.state AS session_state,
  session.market_opens_at,
  session.market_closes_at,
  session.settled_at,
  COUNT(DISTINCT account.id) FILTER (WHERE membership.status = 'active' AND account.status = 'active') AS active_account_count,
  COUNT(DISTINCT valuation.id) AS valuation_count,
  MAX(run.completed_at) FILTER (WHERE run.operation_type = 'settle') AS latest_settlement_at,
  season.source_pack_checksum
FROM public.practice_market_seasons season
JOIN public.practice_market_sessions session ON session.season_id = season.id
LEFT JOIN public.practice_market_memberships membership ON membership.season_id = season.id
LEFT JOIN public.practice_market_accounts account ON account.membership_id = membership.id
LEFT JOIN public.practice_market_valuations valuation
  ON valuation.account_id = account.id AND valuation.session_id = session.id
LEFT JOIN public.practice_market_operation_runs run ON run.session_id = session.id
GROUP BY season.slug, season.source_pack_checksum, session.id;

REVOKE ALL ON TABLE public.practice_market_operations_health FROM PUBLIC, anon, authenticated;

REVOKE ALL ON FUNCTION public.complete_practice_market_onboarding(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.practice_market_access_is_enabled() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.claim_practice_market_membership(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.record_practice_market_decision(TEXT, SMALLINT, TEXT, TEXT, TEXT, JSONB, UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.place_practice_market_order(TEXT, TEXT, TEXT, INTEGER, UUID) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_practice_market_event_cards(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_practice_market_trade_board(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.get_practice_market_valuation_history(TEXT) FROM PUBLIC, anon;
REVOKE ALL ON FUNCTION public.practice_market_open_session(UUID, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.practice_market_settle_session(UUID, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.practice_market_publish_due_event_cards(UUID, TEXT) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.practice_market_tick(TEXT) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.complete_practice_market_onboarding(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.claim_practice_market_membership(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.record_practice_market_decision(TEXT, SMALLINT, TEXT, TEXT, TEXT, JSONB, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.place_practice_market_order(TEXT, TEXT, TEXT, INTEGER, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_practice_market_event_cards(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_practice_market_trade_board(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_practice_market_valuation_history(TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.practice_market_open_session(UUID, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.practice_market_settle_session(UUID, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.practice_market_publish_due_event_cards(UUID, TEXT) TO service_role;
GRANT EXECUTE ON FUNCTION public.practice_market_tick(TEXT) TO service_role;

DO $$
DECLARE
  v_job_id BIGINT;
BEGIN
  SELECT jobid INTO v_job_id
  FROM cron.job
  WHERE jobname = 'koin-practice-market-tick';
  IF v_job_id IS NOT NULL THEN
    PERFORM cron.unschedule(v_job_id);
  END IF;
  PERFORM cron.schedule(
    'koin-practice-market-tick',
    '*/5 * * * *',
    $cron$SELECT public.practice_market_tick('cron');$cron$
  );
END;
$$;

COMMENT ON TABLE public.practice_market_seasons IS
  'KO-421 immutable-versioned metadata for an explicitly simulated Koin Practice Market Season.';
COMMENT ON TABLE public.practice_market_price_points IS
  'KO-421 private authored simulated prices. Only the database transition publishes due open/EOD points.';
COMMENT ON TABLE public.practice_market_accounts IS
  'KO-421 server-owned simulated cash account. Learners cannot directly mutate cash.';
COMMENT ON TABLE public.practice_market_orders IS
  'KO-421 immutable executed/rejected market-order ledger with learner idempotency receipts.';
COMMENT ON TABLE public.practice_market_valuations IS
  'KO-421 immutable per-account EOD valuation ledger; the Season chart must read this table only.';
COMMENT ON TABLE public.practice_market_operation_runs IS
  'KO-421 exactly-once open/lock/settlement audit records for pg_cron and recovery execution.';
COMMENT ON FUNCTION public.practice_market_tick(TEXT) IS
  'KO-421 service/pg_cron-only Jakarta-time reconciliation. Vercel may monitor or recover but is never settlement authority.';
COMMENT ON FUNCTION public.place_practice_market_order(TEXT, TEXT, TEXT, INTEGER, UUID) IS
  'KO-421 learner-safe market-order RPC. It validates gate, membership, open window, price visibility, lots, cash/positions and idempotency.';

COMMIT;
