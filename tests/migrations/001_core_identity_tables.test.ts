import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260629053446_create_core_identity_tables.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 001: core identity tables", () => {
  it("creates profiles table", () => {
    expect(sql).toContain("CREATE TABLE profiles");
  });

  it("creates user_settings table", () => {
    expect(sql).toContain("CREATE TABLE user_settings");
  });

  it("links profiles to auth.users", () => {
    expect(sql).toContain("REFERENCES auth.users(id)");
  });

  it("enables RLS on profiles", () => {
    expect(sql).toContain('ALTER TABLE profiles ENABLE ROW LEVEL SECURITY');
  });

  it("enables RLS on user_settings", () => {
    expect(sql).toContain('ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY');
  });

  it("has a policy restricting profiles to own rows", () => {
    expect(sql).toContain('ON profiles FOR SELECT');
    expect(sql).toContain('auth.uid() = id');
  });

  it("has a policy restricting user_settings to own rows", () => {
    expect(sql).toContain('ON user_settings FOR SELECT');
    expect(sql).toContain('auth.uid() = user_id');
  });

  it("creates trigger for new auth users", () => {
    expect(sql).toContain('CREATE TRIGGER on_auth_user_created');
    expect(sql).toContain('handle_new_user()');
  });
});
