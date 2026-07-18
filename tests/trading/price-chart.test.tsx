import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen } from "@testing-library/react";

vi.mock("@/lib/trading/client", () => ({
  getMarketDataHistory: vi.fn(),
}));

import { getMarketDataHistory, type MarketDataPoint } from "@/lib/trading/client";
import PriceChart, { buildCandles } from "@/components/PriceChart";

const mockGetHistory = getMarketDataHistory as ReturnType<typeof vi.fn>;

const realSeries: MarketDataPoint[] = [
  { date: "2026-07-01", close: 100, isSimulated: false },
  { date: "2026-07-02", close: 110, isSimulated: false },
  { date: "2026-07-03", close: 99, isSimulated: false },
];

describe("buildCandles", () => {
  it("synthesizes open from prior close, with first day opening at its own close", () => {
    const candles = buildCandles(realSeries);

    expect(candles).toHaveLength(3);
    expect(candles[0]).toMatchObject({ open: 100, close: 100, high: 100, low: 100 });
    expect(candles[1]).toMatchObject({ open: 100, close: 110, high: 110, low: 100 });
    expect(candles[2]).toMatchObject({ open: 110, close: 99, high: 110, low: 99 });
  });

  it("carries the isSimulated flag through to each candle", () => {
    const candles = buildCandles([
      { date: "2026-07-01", close: 100, isSimulated: true },
      { date: "2026-07-02", close: 105, isSimulated: false },
    ]);

    expect(candles.map((c) => c.isSimulated)).toEqual([true, false]);
  });

  it("returns an empty array for empty input", () => {
    expect(buildCandles([])).toEqual([]);
  });
});

describe("PriceChart", () => {
  beforeEach(() => {
    mockGetHistory.mockReset();
  });

  it("shows an empty-data state when there is no price history", async () => {
    mockGetHistory.mockResolvedValue([]);

    render(<PriceChart symbol="BBCA" />);

    expect(await screen.findByText(/no price history yet/i)).toBeInTheDocument();
    expect(mockGetHistory).toHaveBeenCalledWith("BBCA");
  });

  it("shows the simulated-prices disclaimer when any point is simulated", async () => {
    mockGetHistory.mockResolvedValue([
      { date: "2026-07-01", close: 100, isSimulated: true },
      { date: "2026-07-02", close: 105, isSimulated: false },
    ]);

    render(<PriceChart symbol="BBCA" />);

    expect(await screen.findByText("Simulated prices")).toBeInTheDocument();
  });

  it("hides the disclaimer when all points are real", async () => {
    mockGetHistory.mockResolvedValue(realSeries);

    render(<PriceChart symbol="BBCA" />);

    // Wait for the chart to finish loading before asserting absence.
    expect(await screen.findByText("Rp 99")).toBeInTheDocument();
    expect(screen.queryByText("Simulated prices")).not.toBeInTheDocument();
  });

  it("shows the latest close and the day-over-day change", async () => {
    mockGetHistory.mockResolvedValue(realSeries);

    render(<PriceChart symbol="BBCA" />);

    expect(await screen.findByText("Rp 99")).toBeInTheDocument();
    expect(screen.getByText("-10.00%")).toBeInTheDocument();
  });
});
