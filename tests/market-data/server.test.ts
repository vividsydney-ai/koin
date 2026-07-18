import { describe, it, expect, vi, beforeEach } from "vitest";

const fromMock = vi.hoisted(() => vi.fn());
const rpcMock = vi.hoisted(() => vi.fn());
const upsertMock = vi.hoisted(() => vi.fn());

vi.mock("@supabase/supabase-js", () => ({
  createClient: vi.fn(() => ({
    from: fromMock,
    rpc: rpcMock,
  })),
}));

const SUPABASE_URL = "https://test.supabase.co";
const SERVICE_ROLE_KEY = "test-service-role-key";

process.env.NEXT_PUBLIC_SUPABASE_URL = SUPABASE_URL;
process.env.SUPABASE_SERVICE_ROLE_KEY = SERVICE_ROLE_KEY;

import { fetchIdxEodPrices, updateMarketData } from "@/lib/market-data/server";

describe("market data server", () => {
  beforeEach(() => {
    vi.restoreAllMocks();
    fromMock.mockReturnValue({ upsert: upsertMock });
    upsertMock.mockResolvedValue({ error: null });
    rpcMock.mockResolvedValue({ data: [], error: null });
  });

  describe("fetchIdxEodPrices", () => {
    it("parses IDX response and filters MVP symbols", async () => {
      global.fetch = vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({
          data: [
            { Code: "BBCA", Name: "Bank Central Asia Tbk", ClosePrice: "8500", Volume: "42000000" },
            { Code: "BBRI", Name: "Bank Rakyat Indonesia Tbk", ClosePrice: "4150", Volume: "60000000" },
            { Code: "ASII", Name: "Astra International Tbk", ClosePrice: "5750", Volume: "10000000" },
          ],
        }),
      });

      const rows = await fetchIdxEodPrices("2026-07-17");

      expect(rows).toHaveLength(2);
      expect(rows.find((r) => r.symbol === "BBCA")?.closePrice).toBe(8500);
      expect(rows.find((r) => r.symbol === "BBRI")?.volume).toBe(60000000);
      expect(rows.some((r) => r.symbol === "ASII")).toBe(false);
    });

    it("throws when IDX response is not ok", async () => {
      global.fetch = vi.fn().mockResolvedValue({
        ok: false,
        status: 503,
        statusText: "Service Unavailable",
      });

      await expect(fetchIdxEodPrices("2026-07-17")).rejects.toThrow("IDX fetch failed: 503 Service Unavailable");
    });
  });

  describe("updateMarketData", () => {
    it("upserts real IDX rows and skips synthetic fallback when all symbols present", async () => {
      global.fetch = vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({
          data: [
            { Code: "BBCA", ClosePrice: "8500", Volume: "42000000" },
            { Code: "BBRI", ClosePrice: "4150", Volume: "60000000" },
            { Code: "TLKM", ClosePrice: "3720", Volume: "35000000" },
            { Code: "GOTO", ClosePrice: "105", Volume: "1200000000" },
            { Code: "UNVR", ClosePrice: "6480", Volume: "18000000" },
          ],
        }),
      });

      const result = await updateMarketData("2026-07-17");

      expect(result.tradeDate).toBe("2026-07-17");
      expect(result.inserted).toBe(5);
      expect(result.simulated).toBe(0);
      expect(upsertMock).toHaveBeenCalledTimes(5);
      expect(rpcMock).not.toHaveBeenCalled();
    });

    it("falls back to synthetic drift for missing symbols when IDX fetch succeeds", async () => {
      global.fetch = vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({
          data: [{ Code: "BBCA", ClosePrice: "8500", Volume: "42000000" }],
        }),
      });

      rpcMock.mockResolvedValue({
        data: [{ symbol: "BBRI" }, { symbol: "TLKM" }, { symbol: "GOTO" }, { symbol: "UNVR" }],
        error: null,
      });

      const result = await updateMarketData("2026-07-17");

      expect(result.inserted).toBe(1);
      expect(result.simulated).toBe(4);
      expect(result.errors).toContain("Missing symbols, will synthesize: BBRI, TLKM, GOTO, UNVR");
    });

    it("falls back entirely to synthetic drift when IDX fetch fails", async () => {
      global.fetch = vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
        statusText: "Internal Server Error",
      });

      rpcMock.mockResolvedValue({
        data: [{ symbol: "BBCA" }, { symbol: "BBRI" }, { symbol: "TLKM" }, { symbol: "GOTO" }, { symbol: "UNVR" }],
        error: null,
      });

      const result = await updateMarketData("2026-07-17");

      expect(result.inserted).toBe(0);
      expect(result.simulated).toBe(5);
      expect(result.errors.some((e) => e.includes("IDX fetch error"))).toBe(true);
    });

    it("records upsert errors without crashing", async () => {
      global.fetch = vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({
          data: [{ Code: "BBCA", ClosePrice: "8500", Volume: "42000000" }],
        }),
      });

      upsertMock.mockResolvedValue({ error: { message: "unique constraint" } });
      rpcMock.mockResolvedValue({
        data: [{ symbol: "BBRI" }],
        error: null,
      });

      const result = await updateMarketData("2026-07-17");

      expect(result.errors).toContain("Upsert BBCA: unique constraint");
    });
  });
});
