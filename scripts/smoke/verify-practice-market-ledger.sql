-- Disposable local verification fixture for KO-421. Run only against
-- ko421_season_ledger_verify after applying the migration without its local
-- pg_cron bootstrap (the local cron worker is bound to the shared database).

DO $$
BEGIN
  IF current_database() <> 'ko421_season_ledger_verify' THEN
    RAISE EXCEPTION 'KO-421 smoke test must run only in the disposable ko421_season_ledger_verify database';
  END IF;
END;
$$;

ALTER TABLE public.topics ADD COLUMN IF NOT EXISTS chapter TEXT;
CREATE TABLE IF NOT EXISTS public.practice_market_cutover_state (
  id BOOLEAN PRIMARY KEY CHECK (id = TRUE),
  legacy_archived_at TIMESTAMPTZ NOT NULL,
  season_access_enabled BOOLEAN NOT NULL DEFAULT FALSE,
  notice TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO auth.users (
  id, aud, role, email, raw_app_meta_data, raw_user_meta_data, created_at, updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000421', 'authenticated', 'authenticated',
  'ko421-ledger@example.test', '{}'::JSONB, '{"display_name":"KO-421 test"}'::JSONB, NOW(), NOW()
) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.profiles (id, display_name)
VALUES ('00000000-0000-0000-0000-000000000421', 'KO-421 test')
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.practice_market_cutover_state (id, legacy_archived_at, season_access_enabled, notice)
VALUES (TRUE, NOW(), TRUE, 'KO-421 disposable verification')
ON CONFLICT (id) DO UPDATE SET season_access_enabled = TRUE;

INSERT INTO public.topics (id, slug, name, name_id, chapter)
VALUES ('00000000-0000-0000-0000-000000000801', 'ko421-ch08', 'Investing in Indonesia', 'Investasi di Indonesia', 'Investing in Indonesia')
ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lessons (id, slug, title, title_id, topic_id, lesson_number, difficulty, is_published)
VALUES (
  '00000000-0000-0000-0000-000000000802', 'ko421-ch08-gate', 'KO-421 Chapter Gate', 'Gerbang Bab KO-421',
  '00000000-0000-0000-0000-000000000801', 808021, 'beginner', TRUE
) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.lesson_progress (user_id, lesson_id, status, first_completed_at)
VALUES ('00000000-0000-0000-0000-000000000421', '00000000-0000-0000-0000-000000000802', 'completed', NOW())
ON CONFLICT (user_id, lesson_id) DO UPDATE SET status = 'completed', first_completed_at = NOW();

INSERT INTO public.practice_market_seasons (
  id, slug, state, title, title_id, source_pack_id, source_pack_checksum, disclosure_version,
  enrollment_opens_at, enrollment_closes_at, rank_entry_closes_at
) VALUES (
  '00000000-0000-0000-0000-000000000901', 'ko421-test-season', 'active', 'KO-421 test Season',
  'Musim uji KO-421', 'test-pack', 'test-checksum', 'ko421-v1',
  NOW() - INTERVAL '1 day', NOW() + INTERVAL '1 day', NOW() + INTERVAL '1 day'
);
INSERT INTO public.practice_market_sessions (
  id, season_id, session_number, market_opens_at, market_closes_at, planning_desk_opens_at
) VALUES
  ('00000000-0000-0000-0000-000000000902', '00000000-0000-0000-0000-000000000901', 1, NOW() - INTERVAL '15 minutes', NOW() + INTERVAL '15 minutes', NOW() + INTERVAL '15 minutes'),
  ('00000000-0000-0000-0000-000000000903', '00000000-0000-0000-0000-000000000901', 2, NOW() + INTERVAL '1 day', NOW() + INTERVAL '1 day 7 hours', NOW() + INTERVAL '1 day 7 hours');
INSERT INTO public.practice_market_instruments (
  id, season_id, ticker, issuer_name, sector, listing_date, listing_eligibility_reference, source_pack_reference
) VALUES (
  '00000000-0000-0000-0000-000000000904', '00000000-0000-0000-0000-000000000901', 'TEST',
  'KO-421 Test Issuer', 'Test', DATE '2020-01-01', 'test listing evidence', 'test source pack'
);
INSERT INTO public.practice_market_price_points (
  session_id, instrument_id, point_kind, simulated_price, scenario_version, author_name, reviewer_name, reviewed_at, publication_state
) VALUES
  ('00000000-0000-0000-0000-000000000902', '00000000-0000-0000-0000-000000000904', 'open', 1000, 'v1', 'test author', 'test reviewer', NOW(), 'approved'),
  ('00000000-0000-0000-0000-000000000902', '00000000-0000-0000-0000-000000000904', 'eod_close', 1000, 'v1', 'test author', 'test reviewer', NOW(), 'approved'),
  ('00000000-0000-0000-0000-000000000903', '00000000-0000-0000-0000-000000000904', 'open', 1200, 'v1', 'test author', 'test reviewer', NOW(), 'approved'),
  ('00000000-0000-0000-0000-000000000903', '00000000-0000-0000-0000-000000000904', 'eod_close', 1200, 'v1', 'test author', 'test reviewer', NOW(), 'approved');
INSERT INTO public.practice_market_event_cards (
  season_id, session_id, title, title_id, content, evidence_references, non_advice_disclosure,
  reveal_at, publication_state, author_name, reviewer_name, reviewed_at
) VALUES
  (
    '00000000-0000-0000-0000-000000000901', '00000000-0000-0000-0000-000000000902',
    'Current test event', 'Peristiwa uji saat ini', '{"kind":"current"}'::JSONB,
    '[]'::JSONB, 'Simulation only.', NOW() - INTERVAL '1 minute', 'approved',
    'test author', 'test reviewer', NOW()
  ),
  (
    '00000000-0000-0000-0000-000000000901', '00000000-0000-0000-0000-000000000903',
    'Future test event', 'Peristiwa uji mendatang', '{"kind":"future"}'::JSONB,
    '[]'::JSONB, 'Simulation only.', NOW() + INTERVAL '1 day', 'approved',
    'test author', 'test reviewer', NOW()
  );

SELECT public.practice_market_tick('service');

SET ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000421', FALSE);
SELECT set_config('request.jwt.claim.role', 'authenticated', FALSE);
SELECT public.complete_practice_market_onboarding('ko421-v1');
SELECT public.claim_practice_market_membership('ko421-test-season');
SELECT public.record_practice_market_decision(
  'ko421-test-season', 1::SMALLINT, 'TEST', 'buy', 'Small, documented simulated practice position.',
  '{"source":"test"}'::JSONB, '00000000-0000-0000-0000-000000000905'::UUID
);
SELECT public.place_practice_market_order(
  'ko421-test-season', 'TEST', 'buy', 1, '00000000-0000-0000-0000-000000000906'::UUID
);
SELECT public.place_practice_market_order(
  'ko421-test-season', 'TEST', 'buy', 1, '00000000-0000-0000-0000-000000000906'::UUID
);
SELECT public.place_practice_market_order(
  'ko421-test-season', 'TEST', 'sell', 2, '00000000-0000-0000-0000-000000000907'::UUID
);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.get_practice_market_trade_board('ko421-test-season')
    WHERE session_number = 1 AND eod_close_price IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'KO-421 test failure: EOD price leaked before settlement';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.get_practice_market_trade_board('ko421-test-season')
    WHERE session_number = 2
  ) THEN
    RAISE EXCEPTION 'KO-421 test failure: future session price leaked';
  END IF;
  IF (SELECT COUNT(*) FROM public.get_practice_market_event_cards('ko421-test-season')) <> 1 THEN
    RAISE EXCEPTION 'KO-421 test failure: published-event contract leaked or hid an event';
  END IF;
  BEGIN
    PERFORM simulated_price FROM public.practice_market_price_points LIMIT 1;
    RAISE EXCEPTION 'KO-421 test failure: direct future-price table read was allowed';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
  BEGIN
    INSERT INTO public.practice_market_accounts (membership_id, starting_cash, cash_balance)
    VALUES ('00000000-0000-0000-0000-000000000901', 1, 1);
    RAISE EXCEPTION 'KO-421 test failure: browser accounting write was allowed';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;
RESET ROLE;

UPDATE public.practice_market_sessions
SET market_closes_at = NOW() - INTERVAL '1 minute', planning_desk_opens_at = NOW() - INTERVAL '1 minute'
WHERE id = '00000000-0000-0000-0000-000000000902';
SELECT public.practice_market_tick('service');
SELECT public.practice_market_tick('recovery');

DO $$
DECLARE
  v_cash NUMERIC;
  v_holdings NUMERIC;
  v_total NUMERIC;
  v_executed INTEGER;
  v_rejected INTEGER;
  v_locks INTEGER;
  v_settles INTEGER;
BEGIN
  SELECT valuation.cash_balance, valuation.holdings_value, valuation.total_value
  INTO v_cash, v_holdings, v_total
  FROM public.practice_market_valuations valuation
  JOIN public.practice_market_accounts account ON account.id = valuation.account_id
  JOIN public.practice_market_memberships membership ON membership.id = account.membership_id
  WHERE membership.user_id = '00000000-0000-0000-0000-000000000421';
  IF v_cash <> 9900000 OR v_holdings <> 100000 OR v_total <> 10000000 THEN
    RAISE EXCEPTION 'KO-421 test failure: incorrect valuation %, %, %', v_cash, v_holdings, v_total;
  END IF;
  SELECT COUNT(*) INTO v_executed FROM public.practice_market_orders WHERE status = 'executed';
  SELECT COUNT(*) INTO v_rejected FROM public.practice_market_orders WHERE status = 'rejected';
  SELECT COUNT(*) INTO v_locks FROM public.practice_market_operation_runs WHERE operation_type = 'lock';
  SELECT COUNT(*) INTO v_settles FROM public.practice_market_operation_runs WHERE operation_type = 'settle';
  IF v_executed <> 1 OR v_rejected <> 1 OR v_locks <> 1 OR v_settles <> 1 THEN
    RAISE EXCEPTION 'KO-421 test failure: idempotency or operation invariant failed (% executed, % rejected, % locks, % settlements)', v_executed, v_rejected, v_locks, v_settles;
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.practice_market_price_points
    WHERE session_id = '00000000-0000-0000-0000-000000000903' AND publication_state = 'published'
  ) THEN
    RAISE EXCEPTION 'KO-421 test failure: tick published a future session';
  END IF;
END;
$$;

UPDATE public.practice_market_cutover_state
SET season_access_enabled = FALSE
WHERE id = TRUE;
SET ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000421', FALSE);
SELECT set_config('request.jwt.claim.role', 'authenticated', FALSE);
DO $$
BEGIN
  BEGIN
    PERFORM 1 FROM public.get_practice_market_trade_board('ko421-test-season');
    RAISE EXCEPTION 'KO-421 test failure: disabled feature gate still allowed a learner read';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM <> 'Practice Market is currently unavailable' THEN
      RAISE;
    END IF;
  END;
END;
$$;
RESET ROLE;

SELECT 'KO-421 ledger contract PASS' AS result;
