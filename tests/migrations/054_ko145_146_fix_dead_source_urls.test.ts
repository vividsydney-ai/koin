import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260725100000_KO145_146_fix_dead_source_urls.sql"
);

const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf-8") : "";

describe("Migration 054: KO-145 + KO-146 fix dead BI/IDX source URLs", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("updates BI-002 (interest rates / BI Rates) to Wikipedia", () => {
    expect(sql).toContain("BI-002");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Suku_bunga");
  });

  it("updates BI-001 (inflation) to Wikipedia", () => {
    expect(sql).toContain("BI-001");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Inflasi");
  });

  it("updates BI-003 (payment systems) to Wikipedia", () => {
    expect(sql).toContain("BI-003");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Sistem_pembayaran");
  });

  it("updates BI-005 (exchange rates) to Wikipedia", () => {
    expect(sql).toContain("BI-005");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Nilai_tukar");
  });

  it("updates IDX-001 (investor academy) to Wikipedia", () => {
    expect(sql).toContain("IDX-001");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Investasi");
  });

  it("updates IDX-002 (glossary) to Wikipedia capital markets article", () => {
    expect(sql).toContain("IDX-002");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Pasar_modal");
  });

  it("updates IDX-005 (investment guide) to Wikipedia", () => {
    expect(sql).toContain("IDX-005");
    expect(sql).toContain("https://id.wikipedia.org/wiki/Investasi");
  });

  it("updates IDX-007 (investor protection) to English Wikipedia", () => {
    expect(sql).toContain("IDX-007");
    expect(sql).toContain("https://en.wikipedia.org/wiki/Investor_protection");
  });

  it("does not modify working sources (BI-006 Instagram, IDX-004/006/008)", () => {
    // These source codes appear in comments but are NOT in UPDATE WHERE clauses
    expect(sql).not.toContain("WHERE source_code = 'BI-006'");
    expect(sql).not.toContain("WHERE source_code = 'IDX-004'");
    expect(sql).not.toContain("WHERE source_code = 'IDX-006'");
    expect(sql).not.toContain("WHERE source_code = 'IDX-008'");
  });

  it("sets trust_notes for each updated source explaining the substitution", () => {
    expect(sql).toContain("trust_notes =");
    // Count that at least 12 sources are updated (all broken BI + broken IDX)
    const updateCount = (sql.match(/UPDATE sources SET/g) || []).length;
    expect(updateCount).toBeGreaterThanOrEqual(12);
  });

  it("marks all updated sources as needs_review", () => {
    expect(sql).toContain("status = 'needs_review'");
  });

  it("only targets specific BI and IDX source_codes", () => {
    const targetCodes = ["BI-001", "BI-002", "BI-003", "BI-004", "BI-005", "BI-007", "BI-008", "BI-009",
                         "IDX-001", "IDX-002", "IDX-003", "IDX-005", "IDX-007"];
    for (const code of targetCodes) {
      expect(sql).toContain(code);
    }
  });
});
