import { describe, expect, it } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260805090000_ko225_229_bilingual_lesson_completeness.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("KO-225/KO-229 bilingual lesson completeness migration", () => {
  it("backfills missing bilingual lesson quiz pointers from active questions", () => {
    expect(sql).toContain("WITH first_question AS");
    expect(sql).toContain("quiz_data_id IS NULL");
    expect(sql).toContain("body_id IS NOT NULL");
  });

  it("corrects the audited duplicate locale payloads without deleting variants", () => {
    expect(sql).toContain("ffc442e9-929f-4aeb-b343-bd0e9e30b036");
    expect(sql).toContain("f4670b72-4212-454d-88e3-cadc7b03532e");
    expect(sql).toContain("jsonb_set(body, '{text}'");
    expect(sql).not.toContain("DELETE FROM public.content_variants");
    expect(sql).not.toContain("is_active = FALSE");
  });

  it("adds concise bilingual explanation fallbacks only when absent", () => {
    expect(sql).toContain("variant_type = 'explanation'");
    expect(sql).toContain("l.summary_id");
    expect(sql).toContain("NOT EXISTS");
  });

  it("adds authored bilingual examples only for the known missing-example lessons", () => {
    expect(sql).toContain("variant_type = 'example'");
    expect(sql).toContain("gold-investment-safe-haven-in-turbulent-times");
    expect(sql).toContain("sharia-investments-reksa-dana-syariah-and-sukuk");
    expect(sql).toContain("NOT EXISTS");
  });
});
