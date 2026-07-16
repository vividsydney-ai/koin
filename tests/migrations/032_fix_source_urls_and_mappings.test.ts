import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260716000032_fix_source_urls_and_mappings.sql"
);

const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf-8") : "";

describe("Migration 032: fix source URLs and mappings", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("deletes broken OJK-009..024 source rows", () => {
    expect(sql.toLowerCase()).toContain("delete from sources");
    expect(sql).toContain("BETWEEN 'OJK-009' AND 'OJK-024'");
  });

  it("deletes broken source lesson links first", () => {
    expect(sql.toLowerCase()).toContain("delete from lesson_sources");
  });

  it("remaps foundation/behavior/scam lessons to OJK-003", () => {
    expect(sql).toContain("s.source_code = 'OJK-003'");
    expect(sql).toContain("'money-basics-101'");
    expect(sql).toContain("'too-good-to-be-true'");
  });

  it("remaps wealth/investing lessons to OJK-006", () => {
    expect(sql).toContain("s.source_code = 'OJK-006'");
    expect(sql).toContain("'interest-101'");
    expect(sql).toContain("'portfolio-thinking'");
  });

  it("remaps pro teaser lessons to OJK-001", () => {
    expect(sql).toContain("s.source_code = 'OJK-001'");
    expect(sql).toContain("'taxes-on-returns'");
    expect(sql).toContain("'building-financial-plan'");
  });
});
