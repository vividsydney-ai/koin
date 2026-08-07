import { describe, expect, it } from "vitest";
import fs from "node:fs";
import path from "node:path";

const migration = fs.readFileSync(
  path.resolve(
    process.cwd(),
    "supabase/migrations/20260805180000_ko274_market_data_history_rpc.sql",
  ),
  "utf8",
);

describe("KO-274 market data history RPC migration", () => {
  it("uses a read-only security-definer function scoped to active instruments", () => {
    expect(migration).toContain("CREATE OR REPLACE FUNCTION public.get_market_data_history");
    expect(migration).toContain("SECURITY DEFINER");
    expect(migration).toContain("i.is_active = TRUE");
    expect(migration).toContain("UPPER(TRIM(p_symbol))");
  });

  it("bounds the requested history and grants only execution access", () => {
    expect(migration).toContain("LEAST(GREATEST(COALESCE(p_days, 30), 1), 365)");
    expect(migration).toContain("TO authenticated, anon");
    expect(migration).not.toContain("GRANT SELECT ON TABLE public.market_data");
  });
});
