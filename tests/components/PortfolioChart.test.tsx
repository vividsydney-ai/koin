import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { ContextualHelpProvider } from "@/components/ContextualHelp";

vi.mock("@/lib/trading/client", () => ({
  getPortfolioValueHistory: vi.fn(),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {},
}));

import { getPortfolioValueHistory } from "@/lib/trading/client";
import PortfolioChart from "@/components/PortfolioChart";

const mockGetHistory = getPortfolioValueHistory as ReturnType<typeof vi.fn>;

function renderChart(element: React.ReactElement) {
  return render(<ContextualHelpProvider>{element}</ContextualHelpProvider>);
}

beforeEach(() => {
  mockGetHistory.mockReset();
  mockGetHistory.mockResolvedValue([]);
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

describe("PortfolioChart", () => {
  it("renders without crashing when onRangeChange is omitted", async () => {
    renderChart(<PortfolioChart userId="u1" totalValue={10_000_000} />);

    expect(await screen.findAllByRole("tab")).toHaveLength(4);
  });

  it.each(["1M", "3M", "6M", "All"] as const)(
    "calls onRangeChange with %s when that tab is clicked, even if already active",
    async (rangeValue) => {
      const onRangeChange = vi.fn();
      renderChart(
        <PortfolioChart
          userId="u1"
          totalValue={10_000_000}
          onRangeChange={onRangeChange}
        />,
      );

      fireEvent.click(await screen.findByRole("tab", { name: rangeValue }));

      expect(onRangeChange).toHaveBeenCalledWith(rangeValue);
    },
  );

  it("moves aria-selected to the clicked tab", async () => {
    renderChart(<PortfolioChart userId="u1" totalValue={10_000_000} />);

    const monthTab = await screen.findByRole("tab", { name: "1M" });
    fireEvent.click(monthTab);

    expect(monthTab).toHaveAttribute("aria-selected", "true");
  });

  it("shows a tooltip with date, value and change from the start when hovering the chart", async () => {
    mockGetHistory.mockResolvedValue([
      {
        date: "2026-07-01",
        cashBalance: 5_000_000,
        holdingsValue: 5_000_000,
        totalValue: 10_000_000,
      },
      {
        date: "2026-07-15",
        cashBalance: 5_000_000,
        holdingsValue: 5_500_000,
        totalValue: 10_500_000,
      },
    ]);

    renderChart(<PortfolioChart userId="u1" totalValue={10_500_000} />);

    const svg = await screen.findByRole("img", {
      name: /portfolio value chart/i,
    });
    svg.getBoundingClientRect = () =>
      ({ left: 0, top: 0, width: 100, height: 60 }) as DOMRect;

    fireEvent.mouseMove(svg, { clientX: 100, clientY: 30 });

    const tooltip = await screen.findByTestId("chart-tooltip");
    expect(tooltip).toHaveTextContent("15 Jul");
    expect(tooltip).toHaveTextContent("Rp 10.500.000");
    expect(tooltip).toHaveTextContent("+5,0% from starting point");
    expect(tooltip).toHaveTextContent("Simulated value, calculated once daily");

    fireEvent.mouseLeave(svg);
    await waitFor(() => {
      expect(screen.queryByTestId("chart-tooltip")).not.toBeInTheDocument();
    });
  });

  it("renders distributed month-week ticks below the chart", async () => {
    mockGetHistory.mockResolvedValue([
      {
        date: "2026-07-01",
        cashBalance: 5_000_000,
        holdingsValue: 5_000_000,
        totalValue: 10_000_000,
      },
      {
        date: "2026-07-15",
        cashBalance: 5_000_000,
        holdingsValue: 5_500_000,
        totalValue: 10_500_000,
      },
    ]);

    renderChart(<PortfolioChart userId="u1" totalValue={10_500_000} />);

    expect(await screen.findByText("Jul W1")).toBeInTheDocument();
    expect(screen.getByText("Jul W3")).toBeInTheDocument();
  });

  it("injects a prior-close point when history has only one snapshot so daily movement shows", async () => {
    mockGetHistory.mockResolvedValue([
      {
        date: "2026-08-02",
        cashBalance: 9_790_000,
        holdingsValue: 210_000,
        totalValue: 10_000_000,
      },
    ]);

    renderChart(
      <PortfolioChart
        userId="u1"
        totalValue={10_000_000}
        priorCloseSnapshot={{
          date: "2026-08-01",
          cashBalance: 9_790_000,
          holdingsValue: 205_000,
          totalValue: 9_995_000,
        }}
      />,
    );

    const svg = await screen.findByRole("img", {
      name: /portfolio value chart/i,
    });
    svg.getBoundingClientRect = () =>
      ({ left: 0, top: 0, width: 100, height: 60 }) as DOMRect;

    fireEvent.mouseMove(svg, { clientX: 100, clientY: 30 });

    const tooltip = await screen.findByTestId("chart-tooltip");
    expect(tooltip).toHaveTextContent("2 Agu");
    expect(tooltip).toHaveTextContent("Rp 10.000.000");
    expect(tooltip).toHaveTextContent("+0,1% from starting point");
  });
});
