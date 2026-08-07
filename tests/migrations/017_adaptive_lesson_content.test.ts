import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260706000017_adaptive_lesson_content.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 017: adaptive lesson content", () => {
  it("inserts the behavioral_finance topic", () => {
    expect(sql).toContain("INSERT INTO topics");
    expect(sql).toContain("'behavioral_finance'");
  });

  it("inserts 4 adaptive lessons", () => {
    expect(sql).toContain("'loss-aversion-101'");
    expect(sql).toContain("'diversification-101'");
    expect(sql).toContain("'confidence-101'");
    expect(sql).toContain("'volatility-101'");
  });

  it("publishes lessons with approved reviews", () => {
    expect(sql).toContain("is_published");
    expect(sql).toContain("TRUE");
    expect(sql).toContain("INSERT INTO lesson_reviews");
    expect(sql).toContain("approved_to_publish");
  });

  it("links lessons to real Tier 1 sources", () => {
    expect(sql).toContain("INSERT INTO lesson_sources");
    expect(sql).toMatch(/'OJK-001'|'OJK-006'|'IDX-001'|'IDX-007'|'BI-002'/);
  });

  it("seeds content_variants for adaptive lessons", () => {
    expect(sql).toContain("INSERT INTO content_variants");
    expect(sql).toContain("'example'");
    expect(sql).toContain("'question'");
  });

  it("uses varied question types", () => {
    expect(sql).toContain("'multiple_choice'");
    expect(sql).toContain("'true_false'");
    expect(sql).toContain("'fill_blank'");
    expect(sql).toContain("'word_bank'");
    expect(sql).toContain("'ordering'");
  });

  it("is idempotent", () => {
    expect(sql).toContain("WHERE NOT EXISTS");
    expect(sql).toContain("ON CONFLICT");
  });
});
