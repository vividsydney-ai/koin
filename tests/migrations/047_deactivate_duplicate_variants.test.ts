import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260718000047_deactivate_duplicate_variants.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 047: deactivate duplicate content variants", () => {
  it("targets content_variants table", () => {
    expect(sql).toContain("content_variants");
  });

  it("sets is_active to false for duplicates", () => {
    expect(sql).toContain("SET is_active = false");
  });

  it("partitions duplicates by lesson_id, variant_type, and body text", () => {
    expect(sql).toContain("PARTITION BY");
    expect(sql).toContain("lesson_id");
    expect(sql).toContain("variant_type");
  });

  it("uses example body text for deduplication", () => {
    expect(sql).toContain("body ->> 'text'");
  });

  it("uses question body text for deduplication", () => {
    expect(sql).toContain("body ->> 'question'");
  });

  it("keeps the first (oldest) variant active via ROW_NUMBER", () => {
    expect(sql).toContain("ROW_NUMBER()");
    expect(sql).toContain("ORDER BY created_at ASC, id ASC");
    expect(sql).toContain("rn > 1");
  });

  it("ignores empty text variants", () => {
    expect(sql).toContain("NULLIF(TRIM(body ->> 'text'), '') IS NOT NULL");
    expect(sql).toContain("NULLIF(TRIM(body ->> 'question'), '') IS NOT NULL");
  });
});
