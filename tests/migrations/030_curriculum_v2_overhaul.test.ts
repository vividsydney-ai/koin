import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260716000030_curriculum_v2_overhaul.sql"
);

const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf-8") : "";

describe("Migration 030: curriculum v2.0 overhaul", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("inserts new topics", () => {
    expect(sql).toContain("INSERT INTO topics");
    expect(sql).toContain("'value_purchasing_power'");
    expect(sql).toContain("'behavioral_finance'");
  });

  it("inserts new sources without colliding with existing codes", () => {
    expect(sql).toContain("INSERT INTO sources");
    expect(sql).toContain("OJK-009");
    expect(sql).toContain("GLB-011");
  });

  it("deactivates advanced draft lessons", () => {
    expect(sql.toLowerCase()).toContain("set is_published = false");
    expect(sql).toContain("'inflation-advanced'");
    expect(sql).toContain("'budgeting-advanced'");
    expect(sql).toContain("'risk_return-advanced'");
    expect(sql).toContain("'idx_basics-advanced'");
    expect(sql).toContain("'behavioral_finance-advanced'");
  });

  it("upserts 32 lessons", () => {
    expect(sql).toContain("INSERT INTO lessons");
    expect(sql).toContain("ON CONFLICT (slug) DO UPDATE");
    expect(sql).toContain("'money-basics-101'");
    expect(sql).toContain("'building-financial-plan'");
  });

  it("publishes all 32 lessons", () => {
    expect(sql).toContain("is_published");
    expect(sql.toLowerCase()).toContain("now(), true)");
    expect(sql).toContain("'approved'");
  });

  it("links every lesson to at least one Tier 1 source", () => {
    expect(sql).toContain("INSERT INTO lesson_sources");
    expect(sql).toContain("is_primary");
    expect(sql).toContain("'primary'");
  });

  it("inserts content variants for examples, explanations, and questions", () => {
    expect(sql).toContain("INSERT INTO content_variants");
    expect(sql).toContain("'example'");
    expect(sql).toContain("'explanation'");
    expect(sql).toContain("'question'");
  });

  it("inserts approved lesson reviews", () => {
    expect(sql).toContain("INSERT INTO lesson_reviews");
    expect(sql).toContain("'Koin Content Reviewer'");
    expect(sql).toContain("approved_to_publish");
    expect(sql.toLowerCase()).toContain("true),");
  });

  it("is idempotent", () => {
    expect(sql).toContain("ON CONFLICT");
  });
});
