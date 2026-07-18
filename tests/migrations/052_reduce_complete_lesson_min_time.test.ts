import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260719000100_reduce_complete_lesson_min_time.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 052: reduce complete_lesson min-time gate", () => {
  it("keeps the first-completion minimum-time guard", () => {
    expect(sql).toContain("v_is_first_completion");
    expect(sql).toContain("p_time_spent_seconds < 10");
    expect(sql).toContain("Lesson completed too quickly");
  });

  it("still reports already_completed in the result", () => {
    expect(sql).toContain("'already_completed'");
  });

  it("grants execute to authenticated users only", () => {
    expect(sql).toContain(
      "GRANT EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) TO authenticated"
    );
  });
});
