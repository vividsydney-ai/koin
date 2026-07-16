import { describe, it, expect } from "vitest";
import { readFileSync, existsSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260716000031_deactivate_old_adaptive_lessons.sql"
);

const sql = existsSync(migrationPath) ? readFileSync(migrationPath, "utf-8") : "";

describe("Migration 031: deactivate old adaptive lessons", () => {
  it("migration file exists", () => {
    expect(existsSync(migrationPath)).toBe(true);
  });

  it("deactivates legacy adaptive slugs", () => {
    expect(sql.toLowerCase()).toContain("set is_published = false");
    expect(sql).toContain("'loss-aversion-101'");
    expect(sql).toContain("'confidence-101'");
    expect(sql).toContain("'volatility-101'");
  });
});
