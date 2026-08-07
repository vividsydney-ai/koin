import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260703000000_public_source_read_rls.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 016: public source read RLS", () => {
  it("enables RLS on sources", () => {
    expect(sql).toContain("ALTER TABLE sources ENABLE ROW LEVEL SECURITY");
  });

  it("enables RLS on lesson_sources", () => {
    expect(sql).toContain("ALTER TABLE lesson_sources ENABLE ROW LEVEL SECURITY");
  });

  it("creates authenticated read policy for sources", () => {
    expect(sql).toContain('CREATE POLICY "Authenticated users can read sources"');
    expect(sql).toContain("ON sources FOR SELECT");
    expect(sql).toContain("TO authenticated");
  });

  it("creates anon read policy for sources", () => {
    expect(sql).toContain('CREATE POLICY "Anon users can read sources"');
  });

  it("creates authenticated read policy for lesson_sources", () => {
    expect(sql).toContain('CREATE POLICY "Authenticated users can read lesson_sources"');
    expect(sql).toContain("ON lesson_sources FOR SELECT");
  });

  it("creates anon read policy for lesson_sources", () => {
    expect(sql).toContain('CREATE POLICY "Anon users can read lesson_sources"');
  });
});
