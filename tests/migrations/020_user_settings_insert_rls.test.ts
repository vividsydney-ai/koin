import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260706000020_user_settings_insert_rls.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 020: user_settings INSERT RLS policy", () => {
  it("adds an INSERT policy on user_settings", () => {
    expect(sql).toContain("ON user_settings FOR INSERT");
  });

  it("restricts inserts to the authenticated user", () => {
    expect(sql).toContain("auth.uid() = user_id");
  });

  it("uses WITH CHECK for the insert policy", () => {
    expect(sql).toContain("WITH CHECK (auth.uid() = user_id)");
  });
});
