import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const migration = readFileSync(
  resolve(process.cwd(), "supabase/migrations/20260809100000_ko363_rls_hardening.sql"),
  "utf8",
);

describe("KO-363 RLS hardening migration", () => {
  it("enables RLS on every table from the local security advisory", () => {
    for (const table of [
      "brokerage_recommendations",
      "daily_focus_chapter_map",
      "daily_focus_questions",
      "lesson_media",
      "lesson_triggers",
      "market_data",
      "recommended_resources",
    ]) {
      expect(migration).toContain(`ALTER TABLE public.${table} ENABLE ROW LEVEL SECURITY`);
    }
  });

  it("limits public content to active, published-safe reads", () => {
    expect(migration).toContain('CREATE POLICY "Public read active brokerage recommendations"');
    expect(migration).toContain('CREATE POLICY "Public read active media for published lessons"');
    expect(migration).toContain('CREATE POLICY "Public read active resources for published lessons"');
    expect(migration).toContain("is_active = TRUE");
    expect(migration).toContain("lessons.is_published = TRUE");
    expect(migration).toContain("GRANT SELECT ON TABLE public.brokerage_recommendations, public.lesson_media, public.recommended_resources TO anon, authenticated");
  });

  it("keeps Daily Focus and raw market data out of direct client access", () => {
    expect(migration).toContain("REVOKE ALL ON TABLE public.daily_focus_chapter_map, public.daily_focus_questions,");
    expect(migration).toContain("public.lesson_triggers, public.market_data FROM PUBLIC, anon, authenticated");
    expect(migration).toContain("REVOKE ALL ON FUNCTION public.seed_next_market_data(DATE) FROM PUBLIC, anon, authenticated");
    expect(migration).not.toContain("GRANT SELECT ON TABLE public.market_data");
  });

  it("restores explicit read grants for existing published-content RLS policies", () => {
    expect(migration).toContain("GRANT SELECT ON TABLE public.lessons, public.topics, public.sources,");
    expect(migration).toContain("public.lesson_sources, public.content_variants TO anon, authenticated");
  });
});
