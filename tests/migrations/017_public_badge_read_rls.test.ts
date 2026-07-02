import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260704000000_public_badge_read_rls.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 017: public badge read RLS", () => {
  it("enables RLS on badges", () => {
    expect(sql).toContain("ALTER TABLE badges ENABLE ROW LEVEL SECURITY");
  });

  it("creates authenticated read policy for badges", () => {
    expect(sql).toContain('CREATE POLICY "Authenticated users can read badges"');
    expect(sql).toContain("ON badges FOR SELECT");
    expect(sql).toContain("TO authenticated");
  });

  it("creates anon read policy for badges", () => {
    expect(sql).toContain('CREATE POLICY "Anon users can read badges"');
    expect(sql).toContain("TO anon");
  });
});
