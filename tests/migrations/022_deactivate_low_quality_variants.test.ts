import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260714000022_deactivate_low_quality_variants.sql"
);

const sql = existsSync(migrationPath)
  ? readFileSync(migrationPath, "utf-8")
  : "";

describe("Migration 022: deactivate low-quality variants", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("uses a transaction", () => {
    expect(sql).toContain("BEGIN;");
    expect(sql).toContain("COMMIT;");
  });

  it("deactivates rows by setting is_active = FALSE", () => {
    expect(sql).toContain("SET is_active = FALSE");
  });

  it("does not delete any rows", () => {
    expect(sql).not.toMatch(/\bDELETE\b/i);
  });

  it("filters on currently active variants for idempotency", () => {
    expect(sql).toContain("cv.is_active = TRUE");
  });

  it("targets only the 5 beginner launch lesson slugs", () => {
    expect(sql).toContain("'money-basics-101'");
    expect(sql).toContain("'inflation-101'");
    expect(sql).toContain("'budgeting-101'");
    expect(sql).toContain("'risk-return-101'");
    expect(sql).toContain("'idx-basics-101'");
  });

  it("does not touch behavioral lessons", () => {
    const behavioralSlugs = [
      "loss-aversion-101",
      "diversification-101",
      "confidence-101",
      "volatility-101",
    ];
    for (const slug of behavioralSlugs) {
      expect(sql).not.toContain(`'${slug}'`);
    }
  });

  it("deactivates templated example patterns", () => {
    expect(sql).toContain("cv.variant_type = 'example'");
    expect(sql).toContain("ILIKE 'Example:%'");
    expect(sql).toContain("ILIKE '%This illustrates how%'");
  });

  it("deactivates templated explanation patterns", () => {
    expect(sql).toContain("cv.variant_type = 'explanation'");
    expect(sql).toContain("ILIKE '%is a fundamental concept in%'");
    expect(sql).toContain(
      "ILIKE '%every financially literate person should understand%'"
    );
  });

  it("deactivates garbage answer variants", () => {
    expect(sql).toContain("'Check OJK license'");
    expect(sql).toContain("'Possible loss of capital'");
    expect(sql).toContain("'A fundamental financial concept'");
    expect(sql).toContain("'Everyone managing money'");
  });

  it("deactivates lottery-ticket distractor variants", () => {
    expect(sql).toContain('["Buying lottery tickets"]');
  });

  it("deactivates generic true/false explanations", () => {
    expect(sql).toContain("'This statement is correct.'");
    expect(sql).toContain("'This statement is incorrect.'");
  });

  it("deactivates exact duplicate question text per lesson keeping the lowest id", () => {
    expect(sql).toContain("ROW_NUMBER() OVER");
    expect(sql).toContain("PARTITION BY lesson_id, body->>'question'");
    expect(sql).toContain("ORDER BY id");
    expect(sql).toContain("WHERE rn > 1");
  });
});
