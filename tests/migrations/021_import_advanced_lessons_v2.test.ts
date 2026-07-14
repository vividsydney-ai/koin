import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260714000021_import_advanced_lessons_v2.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 021: import advanced lessons v2 content", () => {
  it("inserts 6 advanced lessons (10-15)", () => {
    expect(sql).toContain("'money_basics-advanced'");
    expect(sql).toContain("'inflation-advanced'");
    expect(sql).toContain("'budgeting-advanced'");
    expect(sql).toContain("'risk_return-advanced'");
    expect(sql).toContain("'idx_basics-advanced'");
    expect(sql).toContain("'behavioral_finance-advanced'");
  });

  it("resolves topic and prerequisite IDs by slug", () => {
    expect(sql).toContain("(SELECT id FROM topics WHERE slug = '");
    expect(sql).toContain("(SELECT id FROM lessons WHERE slug = 'money-basics-101')");
    expect(sql).toContain("(SELECT id FROM lessons WHERE slug = 'inflation-101')");
    expect(sql).toContain("(SELECT id FROM lessons WHERE slug = 'budgeting-101')");
    expect(sql).toContain("(SELECT id FROM lessons WHERE slug = 'risk-return-101')");
    expect(sql).toContain("(SELECT id FROM lessons WHERE slug = 'idx-basics-101')");
    expect(sql).toContain("(SELECT id FROM lessons WHERE slug = 'volatility-101')");
  });

  it("keeps new lessons as draft / unpublished", () => {
    expect(sql).toContain("'draft'");
    expect(sql).toContain("false, 'ID'");
  });

  it("imports content variants for all 5 launch lessons", () => {
    expect(sql).toContain("'money-basics-101'");
    expect(sql).toContain("'inflation-101'");
    expect(sql).toContain("'budgeting-101'");
    expect(sql).toContain("'risk-return-101'");
    expect(sql).toContain("'idx-basics-101'");
    expect(sql).toContain("INSERT INTO content_variants");
  });

  it("uses valid PostgreSQL booleans", () => {
    expect(sql).not.toMatch(/,\s*True\s*,/);
    expect(sql).not.toMatch(/,\s*False\s*,/);
    expect(sql).toMatch(/,\s*true\s*,/);
    expect(sql).toMatch(/,\s*false\s*,/);
  });

  it("inserts recommended resources linked to advanced lessons", () => {
    expect(sql).toContain("INSERT INTO recommended_resources");
    expect(sql).toContain("JOIN lessons l ON l.id = r.lesson_id::uuid");
    expect(sql).toContain("FALSE");
  });

  it("inserts lesson media placeholders kept inactive", () => {
    expect(sql).toContain("INSERT INTO lesson_media");
    expect(sql).toContain("JOIN lessons l ON l.id = m.lesson_id::uuid");
  });

  it("is idempotent on lesson ids", () => {
    expect(sql).toContain("ON CONFLICT (id) DO NOTHING");
  });
});
