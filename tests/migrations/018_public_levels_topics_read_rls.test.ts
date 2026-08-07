import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260705000000_public_levels_topics_read_rls.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 018: public levels and topics read RLS", () => {
  it("enables RLS on levels", () => {
    expect(sql).toContain("ALTER TABLE levels ENABLE ROW LEVEL SECURITY");
  });

  it("enables RLS on topics", () => {
    expect(sql).toContain("ALTER TABLE topics ENABLE ROW LEVEL SECURITY");
  });

  it("creates authenticated read policy for levels", () => {
    expect(sql).toContain('CREATE POLICY "Authenticated users can read levels"');
    expect(sql).toContain("ON levels FOR SELECT");
  });

  it("creates authenticated read policy for topics", () => {
    expect(sql).toContain('CREATE POLICY "Authenticated users can read topics"');
    expect(sql).toContain("ON topics FOR SELECT");
  });
});
