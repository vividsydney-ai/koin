import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260714000023_add_financial_literacy_assessment.sql"
);

const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf-8") : "";

describe("Migration 023: add financial literacy assessment fields", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("adds financial_literacy_level to profiles", () => {
    expect(sql).toContain("ALTER TABLE profiles");
    expect(sql).toContain("ADD COLUMN IF NOT EXISTS financial_literacy_level");
  });

  it("adds onboarding_assessment_completed to profiles", () => {
    expect(sql).toContain("ADD COLUMN IF NOT EXISTS onboarding_assessment_completed");
  });

  it("has a CHECK constraint for the three literacy levels", () => {
    expect(sql).toMatch(/CHECK\s*\(\s*financial_literacy_level\s+IN\s+\('beginner',\s*'intermediate',\s*'advanced'\)\)/i);
  });

  it("is idempotent", () => {
    expect(sql).toContain("ADD COLUMN IF NOT EXISTS");
  });

  it("documents both columns with comments", () => {
    expect(sql).toContain("COMMENT ON COLUMN profiles.financial_literacy_level");
    expect(sql).toContain("COMMENT ON COLUMN profiles.onboarding_assessment_completed");
  });
});
