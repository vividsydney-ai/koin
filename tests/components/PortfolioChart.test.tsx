import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { ContextualHelpProvider } from "@/components/ContextualHelp";

vi.mock("@/lib/auth/client", () => ({
  supabase: {},
}));

import type { PortfolioValueSnapshot } from "@/lib/trading/client";
import PortfolioChart from "@/components/PortfolioChart";

const history: PortfolioValueSnapshot[] = [
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
];

function renderChart(element: React.ReactElement) {
  return render(<ContextualHelpProvider>{element}</ContextualHelpProvider>);
}

beforeEach(() => {
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

  class ResizeObserverMock {
    constructor(private readonly callback: ResizeObserverCallback) {}

    observe(target: Element) {
      this.callback(
        [
          {
            target,
            contentRect: {
              width: 640,
              height: 224,
            } as DOMRectReadOnly,
          } as ResizeObserverEntry,
        ],
        this as unknown as ResizeObserver,
      );
    }

    unobserve() {}

    disconnect() {}
  }

  vi.stubGlobal("ResizeObserver", ResizeObserverMock);
});

describe("PortfolioChart", () => {
  it("renders without crashing when onRangeChange is omitted", async () => {
    renderChart(<PortfolioChart snapshots={history} range="1M" />);

    expect(await screen.findAllByRole("tab")).toHaveLength(4);
  });

  it("renders one recorded portfolio-value area with a gradient, grid, and time axis", async () => {
    renderChart(<PortfolioChart snapshots={history} range="1M" />);

    const chart = await screen.findByTestId("portfolio-area-chart");
    expect(chart).toHaveAttribute("data-series", "portfolio-value");
    expect(chart.querySelector("linearGradient[id^='portfolio-area-fill']")).toBeInTheDocument();
    expect(chart.querySelector(".recharts-cartesian-grid-horizontal")).toBeInTheDocument();
    expect(screen.getByText("Jul W1")).toBeInTheDocument();
    expect(screen.getByText("Jul W3")).toBeInTheDocument();
  });

  it.each(["1M", "3M", "6M", "All"] as const)(
    "calls onRangeChange with %s when that tab is clicked, even if already active",
    async (rangeValue) => {
      const onRangeChange = vi.fn();
      renderChart(
        <PortfolioChart
          snapshots={history}
          range="1M"
          onRangeChange={onRangeChange}
        />,
      );

      fireEvent.click(await screen.findByRole("tab", { name: rangeValue }));

      expect(onRangeChange).toHaveBeenCalledWith(rangeValue);
    },
  );

  it("moves aria-selected to the clicked tab", async () => {
    renderChart(<PortfolioChart snapshots={history} range="1M" />);

    const monthTab = await screen.findByRole("tab", { name: "1M" });
    fireEvent.click(monthTab);

    expect(monthTab).toHaveAttribute("aria-selected", "true");
  });

  it("shows a tooltip with date, value and change from the start when hovering the chart", async () => {
    renderChart(<PortfolioChart snapshots={history} range="1M" />);

    const chart = await screen.findByRole("img", {
      name: /portfolio value chart/i,
    });
    chart.getBoundingClientRect = () =>
      ({ left: 0, top: 0, width: 200, height: 224 }) as DOMRect;

    fireEvent.mouseMove(chart, { clientX: 200, clientY: 30 });

    const tooltip = await screen.findByTestId("chart-tooltip");
    expect(tooltip).toHaveTextContent("15 Jul");
    expect(tooltip).toHaveTextContent("Rp 10.500.000");
    expect(tooltip).toHaveTextContent("+5,0% from starting point");
    expect(tooltip).toHaveTextContent("Simulated value, calculated once daily");

    fireEvent.mouseLeave(chart);
    await waitFor(() => {
      expect(screen.queryByTestId("chart-tooltip")).not.toBeInTheDocument();
    });
  });

  it("keeps a touch-selected point visible and uses a true CSS circle marker", async () => {
    renderChart(<PortfolioChart snapshots={history} range="3M" />);

    const chart = await screen.findByRole("img", { name: /portfolio value chart/i });
    chart.getBoundingClientRect = () =>
      ({ left: 0, top: 0, width: 200, height: 224 }) as DOMRect;

    fireEvent.pointerDown(chart, { clientX: 200, clientY: 30, pointerType: "touch" });
    fireEvent.pointerLeave(chart, { pointerType: "touch" });

    expect(await screen.findByTestId("chart-tooltip")).toHaveTextContent("15 Jul");
    expect(screen.getByTestId("chart-marker")).toHaveClass("rounded-full");
    expect(screen.getByTestId("chart-marker")).toHaveClass("size-3");
  });

  it("lets keyboard users inspect a recorded point and dismiss the selection", async () => {
    renderChart(<PortfolioChart snapshots={history} range="1M" />);

    const chart = await screen.findByRole("img", { name: /portfolio value chart/i });
    fireEvent.keyDown(chart, { key: "End" });

    expect(await screen.findByTestId("chart-tooltip")).toHaveTextContent("15 Jul");
    fireEvent.keyDown(chart, { key: "Escape" });
    await waitFor(() => {
      expect(screen.queryByTestId("chart-tooltip")).not.toBeInTheDocument();
    });
  });

  it("labels sparse history and separates Jakarta market date from the viewer timezone", async () => {
    renderChart(<PortfolioChart snapshots={history} range="6M" />);

    expect(await screen.findByText(/only 14 recorded days are available/i)).toBeInTheDocument();
    expect(screen.getByText(/market date.*jakarta/i)).toBeInTheDocument();
    expect(screen.getByText(/your local date.*australia\/sydney|your local date/i)).toBeInTheDocument();
  });

  it("uses recorded dates rather than inventing intermediate axis points", async () => {
    renderChart(
      <PortfolioChart
        snapshots={[
          history[0],
          { ...history[1], date: "2026-07-31" },
        ]}
        range="1M"
      />,
    );

    expect(await screen.findByText("Jul W1")).toBeInTheDocument();
    expect(screen.getAllByText("Jul W5").length).toBeGreaterThan(0);
    expect(screen.queryByText("Jul W3")).not.toBeInTheDocument();
  });

  it("uses only the authoritative snapshots it receives", async () => {
    renderChart(
      <PortfolioChart
        snapshots={[
          {
            date: "2026-08-02",
            cashBalance: 9_790_000,
            holdingsValue: 210_000,
            totalValue: 10_000_000,
          },
        ]}
        range="1M"
      />,
    );

    const chart = await screen.findByRole("img", {
      name: /portfolio value chart/i,
    });

    expect(chart).toHaveAttribute("aria-label", "1M portfolio value chart");
    expect(chart).toHaveAttribute("data-series", "portfolio-value");
    expect(screen.getByText("Rp 10.000.000")).toBeInTheDocument();
  });
});
