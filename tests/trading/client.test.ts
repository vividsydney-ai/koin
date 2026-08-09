import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    rpc: vi.fn(),
  },
}));

import { supabase } from "@/lib/auth/client";
import {
  calculateLivePortfolioValue,
  getMarketData,
  __resetMarketDataCache,
} from "@/lib/trading/client";

const mockRow = {
  id: "md-1",
  symbol: "BBCA",
  company_name: "Bank Central Asia",
  trade_date: "2026-07-06",
  close_price: 8650,
  volume: 1000,
};

describe("trading client", () => {
  beforeEach(() => {
    __resetMarketDataCache();
    (supabase.rpc as ReturnType<typeof vi.fn>).mockReset();
  });

  it("getMarketData returns mapped rows", async () => {
    (supabase.rpc as ReturnType<typeof vi.fn>).mockResolvedValue({ data: [mockRow], error: null });

    const result = await getMarketData();

    expect(result).toHaveLength(1);
    expect(result[0]).toMatchObject({
      id: "md-1",
      symbol: "BBCA",
      companyName: "Bank Central Asia",
      closePrice: 8650,
      volume: 1000,
    });
    expect(supabase.rpc).toHaveBeenCalledTimes(1);
  });

  it("deduplicates concurrent in-flight requests", async () => {
    (supabase.rpc as ReturnType<typeof vi.fn>).mockResolvedValue({ data: [mockRow], error: null });

    const [a, b] = await Promise.all([getMarketData(), getMarketData()]);

    expect(a).toBe(b);
    expect(supabase.rpc).toHaveBeenCalledTimes(1);
  });

  it("returns cached data without a second network call within TTL", async () => {
    (supabase.rpc as ReturnType<typeof vi.fn>).mockResolvedValue({ data: [mockRow], error: null });

    const first = await getMarketData();
    const second = await getMarketData();

    expect(second).toBe(first);
    expect(supabase.rpc).toHaveBeenCalledTimes(1);
  });

  describe("calculateLivePortfolioValue", () => {
    it("values holdings from the latest market close", () => {
      const result = calculateLivePortfolioValue(
        { cashBalance: 6_000_000 },
        [
          {
            id: "h1",
            portfolioId: "p1",
            symbol: "BBCA",
            shares: 100,
            averageCost: 8_000,
            currentPrice: 8_100,
            lastPriceUpdatedAt: null,
            createdAt: "2026-08-01T00:00:00Z",
            updatedAt: "2026-08-01T00:00:00Z",
          },
        ],
        [{ id: "md-1", symbol: "BBCA", companyName: "BBCA", tradeDate: "2026-08-09", closePrice: 8_650, volume: 0, isSimulated: false, sourceUrl: null, recordedAt: null }],
      );

      expect(result.holdingsValue).toBe(865_000);
      expect(result.totalValue).toBe(6_865_000);
      expect(result.topHolding).toEqual({ symbol: "BBCA", value: 865_000 });
    });

    it("falls back to current price and then average cost when market data is missing", () => {
      const result = calculateLivePortfolioValue(
        { cashBalance: 10_000_000 },
        [
          {
            id: "h1",
            portfolioId: "p1",
            symbol: "BBRI",
            shares: 200,
            averageCost: 4_000,
            currentPrice: 4_100,
            lastPriceUpdatedAt: null,
            createdAt: "2026-08-01T00:00:00Z",
            updatedAt: "2026-08-01T00:00:00Z",
          },
        ],
        [],
      );

      expect(result.holdingsValue).toBe(820_000);
      expect(result.totalValue).toBe(10_820_000);
    });

    it("identifies the largest holding as the top holding", () => {
      const result = calculateLivePortfolioValue(
        { cashBalance: 1_000_000 },
        [
          {
            id: "h1",
            portfolioId: "p1",
            symbol: "BBCA",
            shares: 100,
            averageCost: 8_000,
            currentPrice: 8_000,
            lastPriceUpdatedAt: null,
            createdAt: "2026-08-01T00:00:00Z",
            updatedAt: "2026-08-01T00:00:00Z",
          },
          {
            id: "h2",
            portfolioId: "p1",
            symbol: "BBRI",
            shares: 500,
            averageCost: 4_000,
            currentPrice: 4_000,
            lastPriceUpdatedAt: null,
            createdAt: "2026-08-01T00:00:00Z",
            updatedAt: "2026-08-01T00:00:00Z",
          },
        ],
        [],
      );

      expect(result.topHolding).toEqual({ symbol: "BBRI", value: 2_000_000 });
    });
  });
});
