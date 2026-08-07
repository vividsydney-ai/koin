import { describe, it, expect } from "vitest";
import { readFileSync } from "fs";
import { resolve } from "path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260706000018_adaptive_trigger_engine.sql"
);
const sql = readFileSync(migrationPath, "utf-8");

describe("Migration 018: adaptive trigger engine", () => {
  it("inserts trigger rules for the 4 adaptive lessons", () => {
    expect(sql).toContain("INSERT INTO lesson_triggers");
    expect(sql).toContain("'loss-aversion-101'");
    expect(sql).toContain("'diversification-101'");
    expect(sql).toContain("'confidence-101'");
    expect(sql).toContain("'volatility-101'");
  });

  it("covers panic sell, concentration, inactivity, and drawdown events", () => {
    expect(sql).toContain('"event":"panic_sell"');
    expect(sql).toContain('"event":"concentrated_holding"');
    expect(sql).toContain('"event":"no_trade"');
    expect(sql).toContain('"event":"drawdown"');
  });

  it("creates the evaluate_adaptive_triggers function", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION evaluate_adaptive_triggers");
    expect(sql).toContain("SECURITY DEFINER");
  });

  it("creates an authenticated RPC wrapper", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION check_adaptive_triggers");
    expect(sql).toContain("auth.uid()");
    expect(sql).toContain("GRANT EXECUTE ON FUNCTION check_adaptive_triggers");
  });

  it("creates an after-insert trigger on trades", () => {
    expect(sql).toContain("CREATE OR REPLACE FUNCTION trg_evaluate_adaptive_triggers_after_trade");
    expect(sql).toContain("AFTER INSERT ON trades");
    expect(sql).toContain("CREATE TRIGGER evaluate_adaptive_triggers_after_trade");
  });

  it("skips already-completed lessons", () => {
    expect(sql).toContain("lesson_progress");
    expect(sql).toContain("status = 'completed'");
  });

  it("respects max_times_triggered", () => {
    expect(sql).toContain("max_times_triggered");
    expect(sql).toContain("COUNT(*)");
    expect(sql).toContain("user_lesson_recommendations");
  });
});
