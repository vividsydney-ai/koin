import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260629053446_create_core_identity_tables.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("RLS smoke: core identity tables", () => {
  it("enables row level security on profiles", () => {
    expect(sql).toContain("ALTER TABLE profiles ENABLE ROW LEVEL SECURITY");
  });

  it("enables row level security on user_settings", () => {
    expect(sql).toContain("ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY");
  });

  it("profiles policies are scoped to auth.uid()", () => {
    expect(sql).toContain("ON profiles FOR SELECT");
    expect(sql).toContain("ON profiles FOR UPDATE");
    expect(sql).toContain("auth.uid() = id");
  });

  it("user_settings policies are scoped to auth.uid()", () => {
    expect(sql).toContain("ON user_settings FOR SELECT");
    expect(sql).toContain("ON user_settings FOR UPDATE");
    expect(sql).toContain("auth.uid() = user_id");
  });
});
