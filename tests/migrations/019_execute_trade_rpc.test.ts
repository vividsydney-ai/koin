import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260706000000_execute_trade_rpc.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 019: execute_trade RPC", () => {
  it("creates the execute_trade function", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION execute_trade");
  });

  it("is marked SECURITY DEFINER", () => {
    expect(sql).toContain("SECURITY DEFINER");
  });

  it("checks auth.uid() matches p_user_id", () => {
    expect(sql).toContain("auth.uid()");
    expect(sql).toContain("p_user_id");
  });

  it("validates trade type and lot count", () => {
    expect(sql).toContain("'buy', 'sell'");
    expect(sql).toContain("Lot count must be greater than 0");
  });

  it("creates a portfolio if missing", () => {
    expect(sql).toContain("INSERT INTO portfolios");
    expect(sql).toContain("starting_cash");
    expect(sql).toContain("cash_balance");
  });

  it("reads latest market data for pricing", () => {
    expect(sql).toContain("FROM market_data");
    expect(sql).toContain("close_price");
  });

  it("converts lot count to shares", () => {
    expect(sql).toContain("* 100");
  });

  it("validates sufficient cash for buys", () => {
    expect(sql).toContain("Insufficient cash balance");
  });

  it("validates sufficient shares for sells", () => {
    expect(sql).toContain("Insufficient shares to sell");
  });

  it("updates portfolio cash and total value", () => {
    expect(sql).toContain("UPDATE portfolios");
    expect(sql).toContain("cash_balance");
    expect(sql).toContain("total_value");
  });

  it("updates holdings", () => {
    expect(sql).toContain("INSERT INTO holdings");
    expect(sql).toContain("UPDATE holdings");
    expect(sql).toContain("DELETE FROM holdings");
  });

  it("records executed trades", () => {
    expect(sql).toContain("INSERT INTO trades");
  });

  it("awards first_trade badge and XP", () => {
    expect(sql).toContain("'first_trade'");
    expect(sql).toContain("INSERT INTO user_badges");
    expect(sql).toContain("INSERT INTO xp_events");
  });

  it("grants execute to authenticated", () => {
    expect(sql).toContain("GRANT EXECUTE ON FUNCTION execute_trade");
  });
});
