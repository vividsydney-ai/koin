import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const migration = readFileSync(
  resolve(
    process.cwd(),
    "supabase/migrations/20260812070000_ko417_legacy_paper_trading_cutover.sql",
  ),
  "utf8",
);

describe("KO-417 legacy Paper Trading cutover", () => {
  it("keeps a staff-only, idempotent archive manifest without deleting history", () => {
    expect(migration).toContain("practice_market_legacy_archive_manifest");
    expect(migration).toContain("ON CONFLICT (archive_key) DO NOTHING");
    expect(migration).toContain("legacy_archived_at");
    expect(migration).not.toMatch(/DELETE\s+FROM\s+public\.(portfolios|holdings|trades|watchlists)/i);
    expect(migration).not.toMatch(/DROP\s+TABLE\s+public\.(portfolios|holdings|trades|watchlists)/i);
  });

  it("revokes learner access to every legacy portfolio surface", () => {
    expect(migration).toContain("REVOKE ALL ON TABLE public.portfolios, public.holdings, public.trades, public.watchlists, public.portfolio_value_snapshots");
    expect(migration).toContain("DROP POLICY IF EXISTS");
    expect(migration).toContain("REVOKE EXECUTE ON FUNCTION public.claim_paper_portfolio(UUID)");
    expect(migration).toContain("REVOKE EXECUTE ON FUNCTION public.execute_trade(UUID, TEXT, TEXT, INTEGER)");
    expect(migration).toContain("REVOKE EXECUTE ON FUNCTION public.get_portfolio_value_history(UUID, INTEGER)");
  });

  it("keeps Season access behind a service-owned configuration boundary", () => {
    expect(migration).toContain("practice_market_cutover_state");
    expect(migration).toContain("ALTER TABLE public.practice_market_cutover_state ENABLE ROW LEVEL SECURITY");
    expect(migration).toContain("get_practice_market_cutover_status");
    expect(migration).toContain("GRANT EXECUTE ON FUNCTION public.get_practice_market_cutover_status() TO authenticated");
  });
});
