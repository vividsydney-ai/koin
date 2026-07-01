import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260702000000_complete_lesson.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 015: complete_lesson RPC", () => {
  it("creates the complete_lesson function", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION complete_lesson");
  });

  it("is marked SECURITY DEFINER", () => {
    expect(sql).toContain("SECURITY DEFINER");
  });

  it("checks auth.uid() matches p_user_id", () => {
    expect(sql).toContain("auth.uid()");
    expect(sql).toContain("p_user_id");
  });

  it("writes to lesson_attempts", () => {
    expect(sql).toContain("INSERT INTO lesson_attempts");
  });

  it("upserts lesson_progress", () => {
    expect(sql).toContain("INSERT INTO lesson_progress");
    expect(sql).toContain("ON CONFLICT (user_id, lesson_id)");
  });

  it("inserts xp_events", () => {
    expect(sql).toContain("INSERT INTO xp_events");
  });

  it("updates daily_checkins", () => {
    expect(sql).toContain("INSERT INTO daily_checkins");
  });

  it("maintains streaks", () => {
    expect(sql).toContain("INSERT INTO streaks");
    expect(sql).toContain("UPDATE streaks");
  });

  it("inserts streak_events", () => {
    expect(sql).toContain("INSERT INTO streak_events");
  });

  it("upserts user_mastery", () => {
    expect(sql).toContain("INSERT INTO user_mastery");
    expect(sql).toContain("ON CONFLICT (user_id, topic_id)");
  });

  it("awards user_badges", () => {
    expect(sql).toContain("INSERT INTO user_badges");
  });

  it("grants execute to authenticated", () => {
    expect(sql).toContain("GRANT EXECUTE ON FUNCTION complete_lesson");
  });
});
