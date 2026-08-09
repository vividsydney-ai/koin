-- KO-363: close the remaining direct-table access gaps with least-privilege RLS.
-- Public content is readable only when active and attached to a published lesson.
-- Daily Focus source data, adaptive rules, and market data stay behind RPC/server
-- boundaries; no learner-facing policy can read answer keys or write reference data.

BEGIN;

ALTER TABLE public.brokerage_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_focus_chapter_map ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_focus_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_triggers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.market_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommended_resources ENABLE ROW LEVEL SECURITY;

-- Curated public content: the app may read active rows only. No client role gets
-- INSERT/UPDATE/DELETE privileges; publishing remains an admin/service action.
REVOKE ALL ON TABLE public.brokerage_recommendations, public.lesson_media, public.recommended_resources FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.brokerage_recommendations, public.lesson_media, public.recommended_resources TO anon, authenticated;

-- These existing published-content policies were missing matching client
-- SELECT grants in the migration history. Add the grants explicitly so the
-- policy layer is effective for the lesson player and source cards.
REVOKE ALL ON TABLE public.lessons, public.topics, public.sources,
  public.lesson_sources, public.content_variants FROM PUBLIC, anon, authenticated;
GRANT SELECT ON TABLE public.lessons, public.topics, public.sources,
  public.lesson_sources, public.content_variants TO anon, authenticated;

DROP POLICY IF EXISTS "Public read active brokerage recommendations" ON public.brokerage_recommendations;
CREATE POLICY "Public read active brokerage recommendations"
  ON public.brokerage_recommendations
  FOR SELECT
  TO anon, authenticated
  USING (is_active = TRUE);

DROP POLICY IF EXISTS "Public read active media for published lessons" ON public.lesson_media;
CREATE POLICY "Public read active media for published lessons"
  ON public.lesson_media
  FOR SELECT
  TO anon, authenticated
  USING (
    is_active = TRUE
    AND EXISTS (
      SELECT 1
      FROM public.lessons
      WHERE lessons.id = lesson_media.lesson_id
        AND lessons.is_published = TRUE
    )
  );

DROP POLICY IF EXISTS "Public read active resources for published lessons" ON public.recommended_resources;
CREATE POLICY "Public read active resources for published lessons"
  ON public.recommended_resources
  FOR SELECT
  TO anon, authenticated
  USING (
    is_active = TRUE
    AND EXISTS (
      SELECT 1
      FROM public.lessons
      WHERE lessons.id = recommended_resources.lesson_id
        AND lessons.is_published = TRUE
    )
  );

-- Sensitive/reference data: no direct client table access. Existing SECURITY
-- DEFINER RPCs and the server/service-role client remain the only access paths.
REVOKE ALL ON TABLE public.daily_focus_chapter_map, public.daily_focus_questions,
  public.lesson_triggers, public.market_data FROM PUBLIC, anon, authenticated;

-- seed_next_market_data writes reference data and must never be callable by a
-- browser. The cron/server admin client can still invoke it as service_role.
REVOKE ALL ON FUNCTION public.seed_next_market_data(DATE) FROM PUBLIC, anon, authenticated;

COMMENT ON TABLE public.brokerage_recommendations IS 'Curated brokerage recommendations. Public read is limited to active rows by RLS.';
COMMENT ON TABLE public.lesson_media IS 'Lesson media. Public read is limited to active media on published lessons by RLS.';
COMMENT ON TABLE public.recommended_resources IS 'Curated lesson resources. Public read is limited to active resources on published lessons by RLS.';
COMMENT ON TABLE public.daily_focus_questions IS 'Daily Focus source bank. Server/RPC access only; answer keys must not reach clients.';
COMMENT ON TABLE public.market_data IS 'Delayed/simulated market reference data. Server writes and safe read RPCs only.';

COMMIT;
