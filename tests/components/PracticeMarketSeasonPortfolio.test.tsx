import { describe, expect, it, beforeEach, vi } from "vitest";
import { fireEvent, render, screen, waitFor } from "@testing-library/react";

const { getPracticeMarketValuationHistory } = vi.hoisted(() => ({
  getPracticeMarketValuationHistory: vi.fn(),
}));

vi.mock("@/lib/practice-market/valuation-history", () => ({
  PRACTICE_MARKET_SEASON_ONE_SLUG: "season-1-price-pressure-calm-choices",
  getPracticeMarketValuationHistory,
}));

import PracticeMarketSeasonPortfolio, {
  SeasonPortfolioChart,
  type PracticeMarketValuation,
} from "@/components/practice-market/PracticeMarketSeasonPortfolio";

const valuations: PracticeMarketValuation[] = [
  {
    sessionNumber: 1,
    valuedAt: "2026-08-29T08:00:00.000Z",
    cashBalance: 10_000_000,
    holdingsValue: 0,
    totalValue: 10_000_000,
  },
  {
    sessionNumber: 2,
    valuedAt: "2026-08-30T08:00:00.000Z",
    cashBalance: 9_500_000,
    holdingsValue: 750_000,
    totalValue: 10_250_000,
  },
  {
    sessionNumber: 3,
    valuedAt: "2026-08-31T08:00:00.000Z",
    cashBalance: 9_500_000,
    holdingsValue: 600_000,
    totalValue: 10_100_000,
  },
];

beforeEach(() => {
  getPracticeMarketValuationHistory.mockReset();
  Object.defineProperty(window, "matchMedia", {
    configurable: true,
    value: vi.fn().mockReturnValue({
      matches: false,
      addEventListener: vi.fn(),
      removeEventListener: vi.fn(),
    }),
  });

  class ResizeObserverMock {
    constructor(private readonly callback: ResizeObserverCallback) {}
    observe(target: Element) {
      this.callback(
        [{ target, contentRect: { width: 640, height: 280 } as DOMRectReadOnly } as ResizeObserverEntry],
        this as unknown as ResizeObserver,
      );
    }
    unobserve() {}
    disconnect() {}
  }

  vi.stubGlobal("ResizeObserver", ResizeObserverMock);
});

describe("PracticeMarketSeasonPortfolio", () => {
  it("renders one ledger-backed area series with the Season axis and gradient", async () => {
    render(<SeasonPortfolioChart valuations={valuations} />);

    const chart = await screen.findByTestId("season-valuation-chart");
    expect(chart).toHaveAttribute("data-series", "season-valuation-ledger");
    expect(chart.querySelector("linearGradient[id^='season-valuation-fill']")).toBeInTheDocument();
    expect(chart.querySelector(".recharts-cartesian-grid-horizontal")).toBeInTheDocument();
    expect(screen.getByText("S1")).toBeInTheDocument();
    expect(screen.getByText("S3")).toBeInTheDocument();
    expect(screen.getByText(/simulation · season 1/i)).toBeInTheDocument();
  });

  it("uses the same authoritative session record for headline, tooltip, and summary", async () => {
    render(<SeasonPortfolioChart valuations={valuations} />);

    expect(await screen.findByText("Rp 10.100.000")).toBeInTheDocument();
    const chart = screen.getByRole("img", { name: /season portfolio valuation/i });
    chart.getBoundingClientRect = () => ({ left: 0, top: 0, width: 300, height: 280 }) as DOMRect;
    fireEvent.mouseMove(chart, { clientX: 300, clientY: 20 });

    const tooltip = await screen.findByTestId("season-chart-tooltip");
    expect(tooltip).toHaveTextContent("Session 3");
    expect(tooltip).toHaveTextContent("Rp 10.100.000");
    expect(screen.getByText(/latest released valuation is session 3/i)).toBeInTheDocument();
  });

  it("keeps touch inspection visible with a true CSS circle marker", async () => {
    render(<SeasonPortfolioChart valuations={valuations} />);

    const chart = await screen.findByRole("img", { name: /season portfolio valuation/i });
    chart.getBoundingClientRect = () => ({ left: 0, top: 0, width: 300, height: 280 }) as DOMRect;
    fireEvent.pointerDown(chart, { clientX: 300, clientY: 20, pointerType: "touch" });
    fireEvent.pointerLeave(chart, { pointerType: "touch" });

    expect(await screen.findByTestId("season-chart-tooltip")).toHaveTextContent("Session 3");
    expect(screen.getByTestId("season-chart-marker")).toHaveClass("rounded-full");
    expect(screen.getByTestId("season-chart-marker")).toHaveClass("size-3");
  });

  it("does not reveal unavailable future sessions in Session and Week ranges", async () => {
    render(<SeasonPortfolioChart valuations={valuations} />);

    fireEvent.click(await screen.findByRole("tab", { name: "Session" }));
    expect(screen.getByText(/latest released valuation is session 3/i)).toBeInTheDocument();
    expect(screen.queryByText("S1")).not.toBeInTheDocument();

    fireEvent.click(screen.getByRole("tab", { name: "Week" }));
    expect(screen.getByText(/only 3 of 10 season sessions are available/i)).toBeInTheDocument();
    expect(screen.queryByText(/session 4/i)).not.toBeInTheDocument();
  });

  it("fetches the authorised valuation history exactly once and has honest loading, empty, and retry states", async () => {
    getPracticeMarketValuationHistory.mockRejectedValueOnce(new Error("offline"));
    getPracticeMarketValuationHistory.mockResolvedValueOnce([]);

    render(<PracticeMarketSeasonPortfolio />);

    expect(screen.getByText(/loading your released session valuations/i)).toBeInTheDocument();
    expect(await screen.findByText(/couldn't load your season valuations/i)).toBeInTheDocument();
    expect(getPracticeMarketValuationHistory).toHaveBeenCalledTimes(1);

    fireEvent.click(screen.getByRole("button", { name: /try again/i }));
    expect(await screen.findByText(/no session-close valuation has been recorded yet/i)).toBeInTheDocument();
    await waitFor(() => expect(getPracticeMarketValuationHistory).toHaveBeenCalledTimes(2));
  });
});
