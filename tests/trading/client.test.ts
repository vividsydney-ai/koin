import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    rpc: vi.fn(),
  },
}));

import { supabase } from "@/lib/auth/client";
import { getMarketData, __resetMarketDataCache } from "@/lib/trading/client";

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
});
