import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";

const migration = readFileSync(
  resolve(
    process.cwd(),
    "supabase/migrations/20260728000001_lesson_quiz_retry_scoring.sql",
  ),
  "utf8",
);

describe("KO-210 lesson quiz retry scoring", () => {
  it("records wrong checks as incomplete attempts with no rewards", () => {
    expect(migration).toContain("IF NOT p_quiz_correct THEN");
    expect(migration).toContain("completed, completed_at, answers_json, time_spent_seconds");
    expect(migration).toContain("FALSE, NULL, p_answers_json, p_time_spent_seconds");
    expect(migration).toContain("'xp_earned', 0");
    expect(migration).toContain("'lesson_completed', FALSE");
    expect(migration).toContain("'retry_required', TRUE");
  });

  it("only enters the existing completion and reward path after a correct check", () => {
    expect(migration).toContain("IF NOT p_quiz_correct THEN");
    expect(migration).toContain("INSERT INTO lesson_progress");
    expect(migration).toContain("INSERT INTO xp_events (user_id, source_type, source_id, xp_amount)");
    expect(migration).toContain("'lesson_completed', TRUE");
  });
});
