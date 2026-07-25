import { beforeEach, describe, expect, it, vi } from "vitest";

const upsertMock = vi.hoisted(() => vi.fn());
const fromMock = vi.hoisted(() => vi.fn());
const ensurePortfolioMock = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({
  supabase: { from: fromMock },
}));
vi.mock("@/lib/trading/client", () => ({ ensurePortfolio: ensurePortfolioMock }));

import { completeTradeOnboarding } from "@/lib/trading/onboarding";

describe("completeTradeOnboarding", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    fromMock.mockReturnValue({ upsert: upsertMock });
    upsertMock.mockResolvedValue({ error: null });
    ensurePortfolioMock.mockResolvedValue({});
  });

  it("creates the paper portfolio after unlocking trading", async () => {
    await completeTradeOnboarding("user-1");

    expect(upsertMock).toHaveBeenCalledWith(
      expect.objectContaining({ user_id: "user-1", trade_onboarding_completed: true }),
      { onConflict: "user_id" }
    );
    expect(ensurePortfolioMock).toHaveBeenCalledWith("user-1");
  });
});
