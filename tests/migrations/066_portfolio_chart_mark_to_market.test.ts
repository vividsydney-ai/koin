import { describe, expect, it } from "vitest";
import fs from "node:fs";

const migration = fs.readFileSync(
  "supabase/migrations/20260806100000_portfolio_chart_mark_to_market.sql",
  "utf8",
);
const rangeMigration = fs.readFileSync(
  "supabase/migrations/20260806110000_portfolio_chart_delayed_range_anchor.sql",
  "utf8",
);

describe("KO-274 portfolio chart mark-to-market migration", () => {
  it("values positions from trades and available market closes", () => {
    expect(migration).toContain("SUM(CASE WHEN t.trade_type = 'buy' THEN t.shares ELSE -t.shares END)");
    expect(migration).toContain("md.trade_date <= d.snapshot_date");
    expect(migration).toContain("t.created_at::date <= d.snapshot_date");
    expect(migration).toContain("calculated_cash + cv.calculated_holdings");
    expect(rangeMigration).toContain("v_reference_date");
    expect(rangeMigration).toContain("CASE WHEN p_days = 1 THEN 2 ELSE p_days END");
  });

  it("keeps the portfolio history owner-scoped", () => {
    expect(migration).toContain("auth.uid() <> p_user_id");
    expect(migration).toContain("REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) FROM PUBLIC, anon");
    expect(migration).toContain("GRANT EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER) TO authenticated");
  });

  it("keeps daily movement visible when data is delayed", () => {
    const oneDayMigration = fs.readFileSync(
      "supabase/migrations/20260806120000_portfolio_chart_one_day_window.sql",
      "utf8",
    );
    expect(oneDayMigration).toContain("get_portfolio_value_history_marked");
    expect(oneDayMigration).toContain("p_days = 1");
    expect(oneDayMigration).toContain("LIMIT 2");
  });
});
