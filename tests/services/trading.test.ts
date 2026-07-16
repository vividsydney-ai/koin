import { describe, it, expect, vi, beforeEach } from "vitest";

const TEST_USER_ID = "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11";

const rpc = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({
  supabase: { rpc },
}));

import { executeTrade } from "@/lib/services/trading";

describe("trading service", () => {
  beforeEach(() => {
    rpc.mockClear();
  });

  it("returns a validation error when lot count is not positive", async () => {
    const result = await executeTrade({
      userId: TEST_USER_ID,
      symbol: "BBCA",
      tradeType: "buy",
      lotCount: 0,
    });

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.error.code).toBe("validation_error");
    }
  });

  it("executes a trade via RPC and maps the result", async () => {
    rpc.mockResolvedValueOnce({
      data: {
        trade_id: "trade-1",
        symbol: "BBCA",
        trade_type: "buy",
        shares: 100,
        lot_count: 1,
        price: 8650,
        total_amount: 865_000,
        cash_balance: 9_135_000,
      },
      error: null,
    });

    const result = await executeTrade({
      userId: TEST_USER_ID,
      symbol: "bbca",
      tradeType: "buy",
      lotCount: 1,
    });

    expect(result.ok).toBe(true);
    expect(rpc).toHaveBeenCalledWith("execute_trade", {
      p_user_id: TEST_USER_ID,
      p_symbol: "BBCA",
      p_trade_type: "buy",
      p_lot_count: 1,
    });

    if (result.ok) {
      expect(result.data).toMatchObject({
        tradeId: "trade-1",
        symbol: "BBCA",
        tradeType: "buy",
        shares: 100,
        lotCount: 1,
        price: 8650,
        totalAmount: 865_000,
        cashBalance: 9_135_000,
      });
    }
  });
});
