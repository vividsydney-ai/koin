import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const migrationPath = resolve(
  __dirname,
  "../../supabase/migrations/20260804010000_expand_liquid_idx_catalogue.sql",
);

describe("liquid IDX Paper Trading catalogue migration", () => {
  it("adds a curated liquid equity and official ETF learning universe", () => {
    const sql = readFileSync(migrationPath, "utf8");
    for (const symbol of [
      "ADRO",
      "AKRA",
      "AMMN",
      "ANTM",
      "ASII",
      "BRIS",
      "BUMI",
      "BRMS",
      "CPIN",
      "MDKA",
      "PGAS",
      "PTBA",
      "PANI",
      "TINS",
      "WIFI",
      "XBES",
      "XBLQ",
      "XISI",
      "XMLF",
      "XPIN",
    ]) {
      expect(sql).toContain(`('${symbol}',`);
    }
  });

  it("provides two explicitly simulated starter EOD points for every new symbol", () => {
    const sql = readFileSync(migrationPath, "utf8");
    expect(sql).toContain("CURRENT_DATE - 2");
    expect(sql).toContain("CURRENT_DATE - 1");
    expect(sql).toContain("is_simulated");
    expect(sql).toContain("TRUE");
  });

  it("keeps the official IDX lists as the catalogue source", () => {
    const sql = readFileSync(migrationPath, "utf8");
    expect(sql).toContain("exchange-traded-fund-etf-list");
    expect(sql).toContain("most-active-stocks-by-total-trading-volume");
  });
});
