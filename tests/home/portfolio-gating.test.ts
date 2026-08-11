import { beforeEach, describe, expect, it, vi } from "vitest";

const getTradeOnboardingStatusMock = vi.hoisted(() => vi.fn());
const getPortfolioMock = vi.hoisted(() => vi.fn());
const getHoldingsMock = vi.hoisted(() => vi.fn());
const getMarketDataMock = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({ supabase: {} }));
vi.mock("@/lib/trading/onboarding", () => ({ getTradeOnboardingStatus: getTradeOnboardingStatusMock }));
vi.mock("@/lib/trading/client", () => ({
  getPortfolio: getPortfolioMock,
  getHoldings: getHoldingsMock,
  getMarketData: getMarketDataMock,
}));

import { getPortfolioSnapshot } from "@/lib/home/client";

describe("getPortfolioSnapshot", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("hides the portfolio until paper trading is unlocked", async () => {
    getTradeOnboardingStatusMock.mockResolvedValue({ canTrade: false });

    await expect(getPortfolioSnapshot("user-1")).resolves.toBeNull();
    expect(getPortfolioMock).not.toHaveBeenCalled();
  });

  it("returns a portfolio snapshot after paper trading is unlocked", async () => {
    getTradeOnboardingStatusMock.mockResolvedValue({ canTrade: true });
    getPortfolioMock.mockResolvedValue({
      startingCash: 10_000_000,
      cashBalance: 10_000_000,
      updatedAt: "2026-08-11T00:00:00.000Z",
    });
    getHoldingsMock.mockResolvedValue([]);
    getMarketDataMock.mockResolvedValue([]);

    await expect(getPortfolioSnapshot("user-1")).resolves.toEqual({
      totalValue: 10_000_000,
      totalReturnAmount: 0,
      totalReturnPct: 0,
      cashBalance: 10_000_000,
      investedValue: 0,
      topHolding: null,
      topHoldingPct: null,
      updatedAt: "2026-08-11T00:00:00.000Z",
    });
  });
});
