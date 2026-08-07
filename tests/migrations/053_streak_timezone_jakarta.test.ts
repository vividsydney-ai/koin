import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260720000000_streak_timezone_jakarta.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 053: streak timezone Jakarta", () => {
  it("sets Asia/Jakarta timezone on complete_lesson", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION complete_lesson(");
    expect(sql).toContain("SET timezone = 'Asia/Jakarta'");
  });

  it("sets Asia/Jakarta timezone on check_in_streak", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION check_in_streak(p_user_id UUID)");
    expect(sql).toContain("SET timezone = 'Asia/Jakarta'");
  });

  it("sets Asia/Jakarta timezone on recompute_streak_status", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION recompute_streak_status(p_user_id UUID)");
    expect(sql).toContain("SET timezone = 'Asia/Jakarta'");
  });

  it("sets Asia/Jakarta timezone on get_streak_reminder_candidates", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION get_streak_reminder_candidates(p_current_time TIME)");
    expect(sql).toContain("SET timezone = 'Asia/Jakarta'");
  });

  it("sets Asia/Jakarta timezone on get_weekly_leaderboard", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION get_weekly_leaderboard(p_user_id UUID, p_scope TEXT)");
    expect(sql).toContain("SET timezone = 'Asia/Jakarta'");
  });

  it("revokes direct check_in_streak access", () => {
    expect(sql).toContain("REVOKE EXECUTE ON FUNCTION check_in_streak(UUID) FROM authenticated, anon, PUBLIC");
  });
});
