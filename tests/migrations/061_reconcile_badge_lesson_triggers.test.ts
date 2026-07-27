import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";

const migration = readFileSync(
  resolve(
    process.cwd(),
    "supabase/migrations/20260727235000_reconcile_badge_lesson_triggers.sql",
  ),
  "utf8",
);

describe("KO-213 badge lesson trigger reconciliation", () => {
  it("guards every replacement against a published lesson", () => {
    expect(migration).toContain("slug = 'budgeting-101' AND is_published = TRUE");
    expect(migration).toContain("slug = 'risk-return-101' AND is_published = TRUE");
    expect(migration).toContain("slug = 'fz-scam-red-flags' AND is_published = TRUE");
  });

  it("maps the three legacy badge triggers to current lesson slugs", () => {
    expect(migration).toContain("WHERE slug = 'budget_beginner'");
    expect(migration).toContain("jsonb_build_object('lesson_slug', 'budgeting-101')");
    expect(migration).toContain("WHERE slug = 'compound_wizard'");
    expect(migration).toContain("jsonb_build_object('lesson_slug', 'risk-return-101')");
    expect(migration).toContain("WHERE slug = 'scam_spotter'");
    expect(migration).toContain("jsonb_build_object('lesson_slug', 'fz-scam-red-flags')");
  });

  it("keeps the badge identities and icons unchanged", () => {
    expect(migration).not.toContain("UPDATE public.badges SET slug");
    expect(migration).not.toContain("UPDATE public.badges SET icon");
  });
});
