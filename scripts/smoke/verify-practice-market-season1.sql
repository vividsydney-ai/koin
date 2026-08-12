-- KO-422 repeatable audit. Run only after KO-421 and KO-422 have been applied.
-- The transaction never changes persisted data; the marker prevents accidental use.

BEGIN;
SELECT set_config('koin.ko422_smoke', 'true', FALSE);

DO $$
DECLARE
  v_season_id UUID;
  v_session_count INTEGER;
  v_instrument_count INTEGER;
  v_price_count INTEGER;
  v_event_count INTEGER;
BEGIN
  IF current_setting('koin.ko422_smoke', TRUE) <> 'true' THEN
    RAISE EXCEPTION 'KO-422 smoke audit requires an explicit session marker';
  END IF;

  SELECT id INTO v_season_id
  FROM public.practice_market_seasons
  WHERE slug = 'season-1-price-pressure-calm-choices'
    AND state = 'draft'
    AND source_pack_id = 'koin-practice-market-season-1-2022-context-v1'
    AND source_pack_checksum = '2a81c6dfd33972162aa4c3e69991af2256b1f17394cee469a6a2f09b8db978e6'
    AND disclosure_version = 'practice-market-s1-simulated-v1';

  IF v_season_id IS NULL THEN
    RAISE EXCEPTION 'KO-422 audit: expected immutable draft Season metadata is missing';
  END IF;

  SELECT COUNT(*) INTO v_session_count
  FROM public.practice_market_sessions
  WHERE season_id = v_season_id AND state = 'scheduled';
  SELECT COUNT(*) INTO v_instrument_count
  FROM public.practice_market_instruments
  WHERE season_id = v_season_id AND is_active;
  SELECT COUNT(*) INTO v_price_count
  FROM public.practice_market_price_points point
  JOIN public.practice_market_sessions session ON session.id = point.session_id
  WHERE session.season_id = v_season_id
    AND point.publication_state = 'approved'
    AND point.published_at IS NULL;
  SELECT COUNT(*) INTO v_event_count
  FROM public.practice_market_event_cards
  WHERE season_id = v_season_id
    AND publication_state = 'approved'
    AND published_at IS NULL;

  IF v_session_count <> 10 OR v_instrument_count <> 34
    OR v_price_count <> 680 OR v_event_count <> 10 THEN
    RAISE EXCEPTION 'KO-422 audit: cardinality mismatch sessions %, instruments %, price points %, event cards %',
      v_session_count, v_instrument_count, v_price_count, v_event_count;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.practice_market_price_points point
    JOIN public.practice_market_sessions session ON session.id = point.session_id
    WHERE session.season_id = v_season_id
      AND (point.simulated_price <= 0 OR point.scenario_version <> 'season-1-v1'
        OR point.author_name <> 'Koin Practice Market authoring pack'
        OR point.reviewer_name <> 'Independent KO-422 authoring review'
        OR point.reviewed_at IS NULL)
  ) THEN
    RAISE EXCEPTION 'KO-422 audit: price provenance, review, version, or positivity invariant failed';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.practice_market_sessions session
    JOIN public.practice_market_instruments instrument ON instrument.season_id = session.season_id
    LEFT JOIN public.practice_market_price_points point
      ON point.session_id = session.id AND point.instrument_id = instrument.id
    WHERE session.season_id = v_season_id
    GROUP BY session.id, instrument.id
    HAVING COUNT(*) <> 2
      OR COUNT(*) FILTER (WHERE point.point_kind = 'open') <> 1
      OR COUNT(*) FILTER (WHERE point.point_kind = 'eod_close') <> 1
  ) THEN
    RAISE EXCEPTION 'KO-422 audit: every session/instrument must have one open and one EOD point';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.practice_market_price_points point
    JOIN public.practice_market_sessions session ON session.id = point.session_id
    JOIN public.practice_market_sessions next_session
      ON next_session.season_id = session.season_id
      AND next_session.session_number = session.session_number + 1
    JOIN public.practice_market_price_points next_open
      ON next_open.session_id = next_session.id
      AND next_open.instrument_id = point.instrument_id
      AND next_open.point_kind = 'open'
    WHERE session.season_id = v_season_id
      AND point.point_kind = 'eod_close'
      AND next_open.simulated_price <> point.simulated_price
  ) THEN
    RAISE EXCEPTION 'KO-422 audit: next session open must equal prior EOD';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.practice_market_price_points point
    JOIN public.practice_market_sessions session ON session.id = point.session_id
    CROSS JOIN LATERAL (
      SELECT CASE
        WHEN point.simulated_price <= 200 THEN 1::NUMERIC
        WHEN point.simulated_price <= 500 THEN 2::NUMERIC
        ELSE 5::NUMERIC
      END AS grid
    ) grid
    WHERE session.season_id = v_season_id
      AND MOD(point.simulated_price, grid.grid) <> 0
  ) THEN
    RAISE EXCEPTION 'KO-422 audit: price is not aligned to the educational grid';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.practice_market_event_cards card
    WHERE card.season_id = v_season_id
      AND (
        card.reveal_at <> (
          SELECT session.planning_desk_opens_at
          FROM public.practice_market_sessions session
          WHERE session.id = card.session_id
        )
        OR card.content -> 'en' ->> 'body' IS NULL
        OR card.content -> 'en' ->> 'prompt' IS NULL
        OR card.content -> 'id' ->> 'body' IS NULL
        OR card.content -> 'id' ->> 'prompt' IS NULL
        OR jsonb_array_length(card.evidence_references) = 0
        OR card.non_advice_disclosure <> 'Koin Practice Market simulation — inspired by a historical Indonesian market context; not an actual IDX quote, market replay or investment recommendation.'
        OR card.content::TEXT ~* '\\m(live|delayed|actual idx|replay)\\M'
      )
  ) THEN
    RAISE EXCEPTION 'KO-422 audit: event-card bilingual, evidence, disclosure, or simulation-language invariant failed';
  END IF;

  IF (SELECT season_access_enabled FROM public.practice_market_cutover_state WHERE id = TRUE) IS DISTINCT FROM FALSE THEN
    RAISE EXCEPTION 'KO-422 audit: Practice Market cutover must remain disabled';
  END IF;

  BEGIN
    UPDATE public.practice_market_seasons
    SET state = 'preparing'
    WHERE id = v_season_id;
    RAISE EXCEPTION 'KO-422 audit: elapsed historical schedule was made available';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM NOT LIKE 'Practice Market Season schedule is historical-context only%' THEN
      RAISE;
    END IF;
  END;
END;
$$;

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000422', FALSE);
SELECT set_config('request.jwt.claim.role', 'authenticated', FALSE);
DO $$
BEGIN
  BEGIN
    PERFORM 1 FROM public.get_practice_market_trade_board('season-1-price-pressure-calm-choices');
    RAISE EXCEPTION 'KO-422 audit: disabled feature exposed learner trade board';
  EXCEPTION WHEN OTHERS THEN
    IF SQLERRM <> 'Practice Market is currently unavailable' THEN
      RAISE;
    END IF;
  END;

  BEGIN
    PERFORM simulated_price FROM public.practice_market_price_points LIMIT 1;
    RAISE EXCEPTION 'KO-422 audit: direct future-price read was allowed';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END;
$$;
RESET ROLE;

SELECT 'KO-422 Season 1 source-pack audit PASS' AS result;
ROLLBACK;
