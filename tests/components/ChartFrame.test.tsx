import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { ContextualHelpProvider } from "@/components/ContextualHelp";

vi.mock("@/lib/auth/client", () => ({
  supabase: {},
}));

vi.mock("@/lib/trading/client", () => ({
  getPortfolioValueHistory: vi.fn(),
}));

import {
  getPortfolioValueHistory,
  type PortfolioValueSnapshot,
} from "@/lib/trading/client";
import ChartFrame from "@/components/ChartFrame";

const mockGetHistory = getPortfolioValueHistory as ReturnType<typeof vi.fn>;

function renderChartFrame(element: React.ReactElement) {
  return render(<ContextualHelpProvider>{element}</ContextualHelpProvider>);
}

const rising: PortfolioValueSnapshot[] = [
  { date: "2026-07-01", cashBalance: 5_000_000, holdingsValue: 5_000_000, totalValue: 10_000_000 },
  { date: "2026-07-15", cashBalance: 5_000_000, holdingsValue: 5_500_000, totalValue: 10_500_000 },
  { date: "2026-07-31", cashBalance: 5_000_000, holdingsValue: 5_750_000, totalValue: 10_750_000 },
];

const falling: PortfolioValueSnapshot[] = [
  { date: "2025-07-01", cashBalance: 5_000_000, holdingsValue: 6_000_000, totalValue: 11_000_000 },
  { date: "2026-01-01", cashBalance: 5_000_000, holdingsValue: 5_500_000, totalValue: 10_500_000 },
  { date: "2026-07-31", cashBalance: 5_000_000, holdingsValue: 5_000_000, totalValue: 10_000_000 },
];

beforeEach(() => {
  mockGetHistory.mockReset();
  Object.defineProperty(window, "matchMedia", {
    configurable: true,
    value: vi.fn().mockReturnValue({
      matches: false,
      addListener: vi.fn(),
      removeListener: vi.fn(),
      addEventListener: vi.fn(),
      removeEventListener: vi.fn(),
    }),
  });
});

describe("ChartFrame", () => {
  it("shows a loading message before the independent history fetch resolves", () => {
    mockGetHistory.mockReturnValue(new Promise(() => {}));

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    expect(screen.getByText(/loading your portfolio story/i)).toBeInTheDocument();
  });

  it("renders the Simulated badge verbatim when dataSource is simulated", async () => {
    mockGetHistory.mockResolvedValue(rising);

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    expect(await screen.findByText("Simulated")).toBeInTheDocument();
  });

  it("renders the IDX EOD badge verbatim when dataSource is idx_eod", async () => {
    mockGetHistory.mockResolvedValue(rising);

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="idx_eod" />);

    expect(await screen.findByText("IDX EOD")).toBeInTheDocument();
  });

  it("shows a factual rose-by insight sentence for a rising period", async () => {
    mockGetHistory.mockResolvedValue(rising);

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    const insight = await screen.findByTestId("insight-card");
    expect(insight).toHaveTextContent(/rose by/i);
    expect(insight).toHaveTextContent("Rp 750.000");
  });

  it("shows a factual fell-by insight sentence for a falling period", async () => {
    mockGetHistory.mockResolvedValue([
      { date: "2026-07-01", cashBalance: 5_000_000, holdingsValue: 5_500_000, totalValue: 10_500_000 },
      { date: "2026-07-31", cashBalance: 5_000_000, holdingsValue: 5_000_000, totalValue: 10_000_000 },
    ]);

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_000_000} dataSource="simulated" />);

    const insight = await screen.findByTestId("insight-card");
    expect(insight).toHaveTextContent(/fell by/i);
  });

  it("shows the empty state when there is no history yet", async () => {
    mockGetHistory.mockResolvedValue([]);

    renderChartFrame(<ChartFrame userId="u1" totalValue={0} dataSource="simulated" />);

    expect(await screen.findByText(/no history yet/i)).toBeInTheDocument();
  });

  it("shows an error state with a retry action when the fetch fails, and recovers on retry", async () => {
    // PortfolioChart (rendered as an untouched sibling inside ChartFrame) calls
    // the same client function independently, so both initial calls must fail
    // deterministically before the retry switches the mock to succeed.
    // No tab is clicked in this test, so `range` never changes and the
    // range-triggered refetch path below doesn't interact with this flow.
    mockGetHistory.mockRejectedValue(new Error("network down"));

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    const retry = await screen.findByRole("button", { name: /try again/i });
    mockGetHistory.mockResolvedValue(rising);
    fireEvent.click(retry);

    expect(await screen.findByTestId("insight-card")).toBeInTheDocument();
  });

  it("shows the exact value and date for a tooltip point on focus", async () => {
    mockGetHistory.mockResolvedValue(rising);

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    const points = await screen.findAllByRole("button", { name: /see exact value for/i });
    fireEvent.focus(points[0]);

    expect(await screen.findByText(/Rp 10\.000\.000/)).toBeInTheDocument();
  });

  it("follows PortfolioChart's active range tab: badge/insight/status stay in sync", async () => {
    // Two calls happen on mount (ChartFrame's own effect + PortfolioChart's
    // own nested effect, both requesting "1M"); switching tabs triggers two
    // more calls (same pair, now requesting "1Y").
    mockGetHistory
      .mockResolvedValueOnce(rising)
      .mockResolvedValueOnce(rising)
      .mockResolvedValueOnce(falling)
      .mockResolvedValueOnce(falling);

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    const initialInsight = await screen.findByTestId("insight-card");
    expect(initialInsight).toHaveTextContent(/rose by/i);
    expect(screen.getByRole("status")).toHaveTextContent(/trending upward/i);

    fireEvent.click(screen.getByRole("tab", { name: "1Y" }));

    await waitFor(() => {
      expect(mockGetHistory).toHaveBeenCalledWith("u1", "1Y");
    });

    const updatedInsight = await screen.findByTestId("insight-card");
    await waitFor(() => expect(updatedInsight).toHaveTextContent(/fell by/i));
    expect(updatedInsight).toHaveTextContent(/over the last year/i);
    expect(screen.getByRole("status")).toHaveTextContent(/trending downward/i);
  });

  it("keeps the previous insight visible (no loading flash) while a range switch is still fetching", async () => {
    mockGetHistory
      .mockResolvedValueOnce(rising)
      .mockResolvedValueOnce(rising)
      .mockReturnValue(new Promise(() => {}));

    renderChartFrame(<ChartFrame userId="u1" totalValue={10_750_000} dataSource="simulated" />);

    await screen.findByTestId("insight-card");

    fireEvent.click(screen.getByRole("tab", { name: "1D" }));

    await waitFor(() => {
      expect(mockGetHistory).toHaveBeenCalledWith("u1", "1D");
    });

    expect(screen.getByTestId("insight-card")).toHaveTextContent(/rose by/i);
    expect(screen.queryByText(/loading your portfolio story/i)).not.toBeInTheDocument();
  });
});
