import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260718000043_add_friend_by_qr.sql"
);

const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 043: add friend by QR", () => {
  it("creates add_friend_by_qr RPC", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION add_friend_by_qr");
  });

  it("requires scanned_user_id parameter", () => {
    expect(sql).toContain("p_scanned_user_id UUID");
  });

  it("prevents self-friend", () => {
    expect(sql).toContain("Cannot add yourself as a friend");
  });

  it("checks the scanned user exists", () => {
    expect(sql).toContain("SELECT 1 FROM profiles WHERE id = p_scanned_user_id");
  });

  it("is idempotent by checking existing friendship", () => {
    expect(sql).toContain("FROM friendships");
    expect(sql).toContain("requester_id = v_current_user_id AND addressee_id = p_scanned_user_id");
    expect(sql).toContain("requester_id = p_scanned_user_id AND addressee_id = v_current_user_id");
  });

  it("creates accepted friendship", () => {
    expect(sql).toContain("INSERT INTO friendships");
    expect(sql).toContain("'accepted'");
  });

  it("grants execute to authenticated role", () => {
    expect(sql).toContain("GRANT EXECUTE ON FUNCTION add_friend_by_qr(UUID) TO authenticated");
  });
});
