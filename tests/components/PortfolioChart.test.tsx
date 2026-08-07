import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { ContextualHelpProvider } from "@/components/ContextualHelp";

vi.mock("@/lib/trading/client", () => ({
  getPortfolioValueHistory: vi.fn(),
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

  it.each(["1D", "1M", "1Y", "All"] as const)(
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

    const dayTab = await screen.findByRole("tab", { name: "1D" });
    fireEvent.click(dayTab);

    expect(dayTab).toHaveAttribute("aria-selected", "true");
  });
});
