import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260706000019_adaptive_content_variants_expansion.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 019: adaptive content variant expansion", () => {
  it("targets the 4 behavioral lessons", () => {
    expect(sql).toContain("'loss-aversion-101'");
    expect(sql).toContain("'diversification-101'");
    expect(sql).toContain("'confidence-101'");
    expect(sql).toContain("'volatility-101'");
  });

  it("counts existing examples and questions per lesson", () => {
    expect(sql).toContain("variant_type = 'example'");
    expect(sql).toContain("variant_type = 'question'");
    expect(sql).toContain("COUNT(*)");
  });

  it("caps example variants at 10 per lesson", () => {
    expect(sql).toContain("LIMIT (10 - existing_examples)");
  });

  it("caps question variants at 11 per lesson", () => {
    expect(sql).toContain("LIMIT (11 - existing_questions)");
  });

  it("uses varied question types", () => {
    expect(sql).toContain("'multiple_choice'");
    expect(sql).toContain("'true_false'");
    expect(sql).toContain("'fill_blank'");
    expect(sql).toContain("'word_bank'");
    expect(sql).toContain("'ordering'");
  });

  it("references real Tier 1 sources only", () => {
    expect(sql).toContain("'OJK-001'");
    expect(sql).toContain("'OJK-006'");
    expect(sql).toContain("'IDX-001'");
    expect(sql).toContain("'IDX-007'");
    expect(sql).toContain("'BI-002'");
  });

  it("is idempotent", () => {
    expect(sql).toContain("IF existing_examples < 10 THEN");
    expect(sql).toContain("IF existing_questions < 11 THEN");
  });
});
