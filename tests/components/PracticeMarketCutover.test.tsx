import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import PracticeMarketCutover from "@/components/practice-market/PracticeMarketCutover";

describe("PracticeMarketCutover", () => {
  it("shows an honest Season 1 preparation state instead of a legacy portfolio", () => {
    render(<PracticeMarketCutover />);

    expect(
      screen.getByRole("heading", { name: /practice market/i }),
    ).toBeInTheDocument();
    expect(
      screen.getByText("Season 1 is being prepared", { exact: true }),
    ).toBeInTheDocument();
    expect(screen.getByText(/no real money is used/i)).toBeInTheDocument();
    expect(
      screen.getByText(/previous simulation portfolios are safely archived/i),
    ).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /continue learning/i })).toHaveAttribute(
      "href",
      "/learn",
    );
    expect(screen.queryByRole("button", { name: /buy|sell/i })).not.toBeInTheDocument();
    expect(screen.queryByText(/rp\s*10[.,]?000[.,]?000/i)).not.toBeInTheDocument();
  });
});
