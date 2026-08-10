import { describe, expect, it } from "vitest";
import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const migrationPath = resolve(__dirname, "../../supabase/migrations/20260809140000_ko372_retirement_visual_alignment.sql");
const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf8") : "";

describe("KO-372 retirement visual alignment", () => {
  it("keeps the visual, semantic fallback, and applied checks scoped to the two visible tools", () => {
    expect(existsSync(migrationPath)).toBe(true);
    expect(sql).toContain("Compare BPJS JHT and DPLK by role and terms");
    expect(sql).toContain("A two-column comparison");
    expect(sql).toContain("Perbandingan dua kolom");
    expect(sql).not.toContain("Personal investments");
  });

  it("links the correction to current primary sources and replaces the visual-applied set", () => {
    expect(sql).toContain("CH05-BPJS-JHT");
    expect(sql).toContain("CH05-OJK-DPLK");
    expect(sql).toContain("lesson_visual_block_sources");
    expect(sql).toContain("variant.topic_tag = 'visual_applied'");
    expect(sql).toContain("ON CONFLICT (visual_block_id, source_id)");
  });
});
