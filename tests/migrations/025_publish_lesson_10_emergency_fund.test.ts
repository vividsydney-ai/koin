import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260715000025_publish_lesson_10_emergency_fund.sql"
);

const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf-8") : "";

describe("Migration 025: publish lesson 10 as emergency fund 101", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("repurposes the existing placeholder row by immutable uuid", () => {
    expect(sql).toContain("5a257fa8-d3b9-4907-95d0-a35af52033c8");
  });

  it("updates slug to emergency-fund-101", () => {
    expect(sql).toContain("'emergency-fund-101'");
  });

  it("sets the Indonesian beginner title", () => {
    expect(sql).toContain("Dana Darurat: Siapkan Sebelum Investasi");
  });

  it("sets difficulty to beginner", () => {
    expect(sql).toContain("'beginner'");
  });

  it("keeps lesson_number as 10", () => {
    expect(sql).toContain("lesson_number = 10");
  });

  it("sets xp_reward and estimated_minutes", () => {
    expect(sql).toContain("xp_reward = 75");
    expect(sql).toContain("estimated_minutes = 8");
  });

  it("publishes the lesson", () => {
    expect(sql).toContain("is_published = TRUE");
  });

  it("populates required content fields", () => {
    expect(sql).toContain("summary =");
    expect(sql).toContain("concept_body =");
    expect(sql).toContain("indonesian_example =");
    expect(sql).toContain("why_this_matters =");
    expect(sql).toContain("common_mistake =");
  });

  it("contains 3 quiz questions in quiz_data", () => {
    expect(sql).toContain("quiz_data = jsonb_build_array(");
    expect(sql).toContain("'multiple_choice'");
    expect(sql).toContain("'true_false'");
  });

  it("links OJK-003 as primary and OJK-006 as supporting source", () => {
    expect(sql).toContain("source_code = 'OJK-003'");
    expect(sql).toContain("source_code = 'OJK-006'");
    expect(sql).toContain("is_primary, display_order");
    expect(sql).toContain("'primary'");
    expect(sql).toContain("'supporting'");
  });

  it("inserts beginner content variants", () => {
    expect(sql).toContain("INSERT INTO content_variants");
    expect(sql).toContain("'example'");
    expect(sql).toContain("'explanation'");
    expect(sql).toContain("'question'");
  });

  it("inserts the required variant counts idempotently", () => {
    expect(sql).toContain("existing_examples < 3");
    expect(sql).toContain("existing_explanations < 2");
    expect(sql).toContain("existing_questions < 5");
  });

  it("inserts an approved lesson review", () => {
    expect(sql).toContain("INSERT INTO lesson_reviews");
    expect(sql).toContain("'Koin Content Reviewer'");
    expect(sql).toContain("'content_lead'");
    expect(sql).toContain("'pass'");
    expect(sql).toContain("'Approved for launch'");
    expect(sql).toMatch(/approved_to_publish\b/);
    expect(sql).toContain("TRUE");
  });

  it("is idempotent on lesson_sources and lesson_reviews", () => {
    expect(sql).toContain("ON CONFLICT (lesson_id, source_id) DO NOTHING");
    expect(sql).toContain("ON CONFLICT (lesson_id) DO UPDATE SET");
  });
});
