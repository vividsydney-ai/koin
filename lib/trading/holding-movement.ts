import type { MarketDataPoint } from "@/lib/trading/client";

export type HoldingMovement = {
  latestPrice: number | null;
  previousPrice: number | null;
  change: number | null;
  changePercent: number | null;
  tradeDate: string | null;
  isSimulated: boolean;
};

export function getHoldingMovement(
  history: MarketDataPoint[],
): HoldingMovement {
  const latest = history.at(-1);
  const previous = history.at(-2);
  if (!latest) {
    return {
      latestPrice: null,
      previousPrice: null,
      change: null,
      changePercent: null,
      tradeDate: null,
      isSimulated: false,
    };
  }

  const previousPrice = previous?.close ?? null;
  const change = previousPrice === null ? null : latest.close - previousPrice;
  return {
    latestPrice: latest.close,
    previousPrice,
    change,
    changePercent:
      change === null || previousPrice === null || previousPrice === 0
        ? null
        : (change / previousPrice) * 100,
    tradeDate: latest.date,
    isSimulated: latest.isSimulated,
  };
}
