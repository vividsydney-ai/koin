import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import { ContextualHelpProvider } from "@/components/ContextualHelp";
import {
  getDailyPortfolioChange,
  PortfolioBalances,
} from "@/components/PortfolioBalances";

describe("PortfolioBalances", () => {
  it("uses the latest recorded snapshot as the previous close", () => {
    expect(
      getDailyPortfolioChange(10_125_000, [
        {
          date: "2026-08-01",
          cashBalance: 6_000_000,
          holdingsValue: 4_000_000,
          totalValue: 10_000_000,
        },
        {
          date: "2026-08-02",
          cashBalance: 6_000_000,
          holdingsValue: 4_100_000,
          totalValue: 10_100_000,
        },
      ]),
    ).toBe(25_000);
  });

  it("returns null for daily change when there is no history", () => {
    expect(getDailyPortfolioChange(10_000_000, [])).toBeNull();
  });

  it("shows balances without repeating the starting grant as a primary metric", () => {
    render(
      <ContextualHelpProvider>
        <PortfolioBalances
          totalValue={10_100_000}
          cashBalance={2_000_000}
          startingCash={10_000_000}
          history={[
            {
              date: "2026-08-01",
              cashBalance: 2_000_000,
              holdingsValue: 8_000_000,
              totalValue: 10_000_000,
            },
            {
              date: "2026-08-02",
              cashBalance: 2_000_000,
              holdingsValue: 8_100_000,
              totalValue: 10_100_000,
            },
          ]}
        />
      </ContextualHelpProvider>,
    );

    expect(
      screen.getByRole("heading", { name: "Balances" }),
    ).toBeInTheDocument();
    expect(screen.getByText("Invested")).toBeInTheDocument();
    expect(screen.getByText("Daily change")).toBeInTheDocument();
    expect(
      screen.getByText(/one-time paper grant started at/i),
    ).toBeInTheDocument();
    expect(screen.queryByText("Starting portfolio")).not.toBeInTheDocument();
  });
});
