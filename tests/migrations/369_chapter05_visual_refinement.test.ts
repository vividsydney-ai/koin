import { describe, expect, it } from "vitest";
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const migrationPath = resolve(__dirname, "../../supabase/migrations/20260809120000_ko369_chapter05_visual_refinement_repair.sql");
const curriculumPath = resolve(__dirname, "../../lib/lessons/curriculum.ts");
const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf8") : "";
const curriculum = readFileSync(curriculumPath, "utf8");

describe("KO-369 Chapter 05 visual-learning refinement", () => {
  it("keeps the repair migration and shared visual contract", () => {
    expect(existsSync(migrationPath)).toBe(true);
    expect(sql).toContain("lesson_visual_blocks");
    expect(sql).toContain("lesson_visual_block_sources");
    expect(sql).toContain("lesson_recall_questions");
    expect(sql).toContain("visual_applied");
    expect(sql).toContain("retirement-planning-start-early-compounding");
  });

  it("guards the source cleanup against a cartesian delete", () => {
    expect(sql).toContain("AND source.id = ls.source_id");
    expect(sql).toContain("source.url IS NULL");
  });

  it("requires paired bilingual visuals, applied practice, and recalls", () => {
    expect(sql).toContain('"en"');
    expect(sql).toContain('"id"');
    expect(sql).toContain("options_en");
    expect(sql).toContain("options_id");
    expect(sql).toContain("correct_option");
  });

  it("keeps Chapter 05 order explicit in the curriculum", () => {
    expect(curriculum).toContain('"Plan Your Money": [');
    expect(curriculum).toContain('"emergency-fund-101"');
    expect(curriculum).toContain('"retirement-planning-start-early-compounding"');
  });
});
