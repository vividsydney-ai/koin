import { beforeEach, describe, expect, it, vi } from "vitest";

const { rpc } = vi.hoisted(() => ({ rpc: vi.fn() }));

vi.mock("@/lib/auth/client", () => ({ supabase: { rpc } }));

import {
  getPracticeMarketValuationHistory,
  PRACTICE_MARKET_SEASON_ONE_SLUG,
} from "@/lib/practice-market/valuation-history";

describe("getPracticeMarketValuationHistory", () => {
  beforeEach(() => {
    rpc.mockReset();
  });

  it("uses only the KO-421 ledger history RPC and preserves returned ledger values", async () => {
    rpc.mockResolvedValue({
      data: [
        {
          session_number: 2,
          valued_at: "2026-08-30T08:00:00.000Z",
          cash_balance: "9500000.00",
          holdings_value: "750000.00",
          total_value: "10250000.00",
        },
      ],
      error: null,
    });

    const valuations = await getPracticeMarketValuationHistory();

    expect(rpc).toHaveBeenCalledTimes(1);
    expect(rpc).toHaveBeenCalledWith("get_practice_market_valuation_history", {
      p_season_slug: PRACTICE_MARKET_SEASON_ONE_SLUG,
    });
    expect(valuations).toEqual([
      {
        sessionNumber: 2,
        valuedAt: "2026-08-30T08:00:00.000Z",
        cashBalance: 9_500_000,
        holdingsValue: 750_000,
        totalValue: 10_250_000,
      },
    ]);
  });

  it("shares an in-flight request instead of issuing a duplicate history read", async () => {
    let resolveRpc: (value: { data: unknown[]; error: null }) => void = () => undefined;
    rpc.mockReturnValue(
      new Promise((resolve) => {
        resolveRpc = resolve;
      }),
    );

    const first = getPracticeMarketValuationHistory();
    const second = getPracticeMarketValuationHistory();
    resolveRpc({ data: [], error: null });

    await expect(Promise.all([first, second])).resolves.toEqual([[], []]);
    expect(rpc).toHaveBeenCalledTimes(1);
  });
});
