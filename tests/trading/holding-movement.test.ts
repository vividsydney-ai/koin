import { describe, expect, it } from "vitest";
import { getHoldingMovement } from "@/lib/trading/holding-movement";

describe("getHoldingMovement", () => {
  it("calculates an accurate delayed EOD movement from the latest two closes", () => {
    expect(
      getHoldingMovement([
        { date: "2026-08-01", close: 8_500, isSimulated: false },
        { date: "2026-08-02", close: 8_650, isSimulated: false },
      ]),
    ).toMatchObject({
      latestPrice: 8_650,
      previousPrice: 8_500,
      change: 150,
      changePercent: 1.7647058823529411,
      tradeDate: "2026-08-02",
      isSimulated: false,
    });
  });

  it("does not manufacture movement before a prior EOD close exists", () => {
    expect(
      getHoldingMovement([
        { date: "2026-08-02", close: 8_650, isSimulated: true },
      ]),
    ).toMatchObject({
      latestPrice: 8_650,
      previousPrice: null,
      change: null,
      changePercent: null,
      isSimulated: true,
    });
  });
});
