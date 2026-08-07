import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260718000048_abuse_hardening.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 048: abuse hardening (KO-ABUSE-001)", () => {
  it("replaces complete_lesson with a hardened version", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION complete_lesson");
    expect(sql).toContain("SECURITY DEFINER");
    expect(sql).toContain("auth.uid()");
  });

  it("rejects completions faster than 30 seconds", () => {
    expect(sql).toContain("p_time_spent_seconds < 30");
    expect(sql).toContain("Lesson completed too quickly");
  });

  it("awards lesson XP only once per lesson via xp_events ledger check", () => {
    expect(sql).toContain("source_type = 'lesson_complete' AND source_id = p_lesson_id");
  });

  it("awards quiz bonus only on the first correct attempt", () => {
    expect(sql).toContain("source_type = 'quiz_bonus' AND source_id = p_lesson_id");
  });

  it("awards Koin Points for lesson completion only on first completion", () => {
    expect(sql).toContain("IF v_is_first_completion THEN");
    expect(sql).toContain("award_koin_points(p_user_id, 10, 'lesson_complete'");
  });

  it("limits streak milestone awards to once per day", () => {
    expect(sql).toContain("source_type = 'streak_milestone'");
    expect(sql).toContain("created_at >= v_today");
  });

  it("reports already_completed in the result", () => {
    expect(sql).toContain("'already_completed'");
  });

  it("revokes anon access from complete_lesson", () => {
    expect(sql).toContain("REVOKE EXECUTE ON FUNCTION complete_lesson(UUID, UUID, INTEGER, INTEGER, JSONB, INTEGER, BOOLEAN) FROM anon");
  });

  it("revokes direct access to award_koin_points (internal only)", () => {
    expect(sql).toContain("REVOKE EXECUTE ON FUNCTION award_koin_points(UUID, INTEGER, TEXT, UUID, TEXT) FROM authenticated, anon, PUBLIC");
  });

  it("revokes direct access to check_in_streak (internal only)", () => {
    expect(sql).toContain("REVOKE EXECUTE ON FUNCTION check_in_streak(UUID) FROM authenticated, anon, PUBLIC");
  });

  it("rate-limits add_friend_by_qr to 20 new friendships per day", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION add_friend_by_qr");
    expect(sql).toContain("v_adds_today >= 20");
    expect(sql).toContain("Daily friend-add limit reached");
  });
});
