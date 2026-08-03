import { describe, expect, it } from "vitest";
import { fireEvent, render, screen } from "@testing-library/react";
import {
  ContextualHelp,
  ContextualHelpProvider,
} from "@/components/ContextualHelp";

describe("ContextualHelp", () => {
  it("opens on click and keeps only one explanation open", () => {
    render(
      <ContextualHelpProvider>
        <ContextualHelp label="Buying power">
          Virtual cash available for orders.
        </ContextualHelp>
        <ContextualHelp label="Market order">
          Uses the latest available close.
        </ContextualHelp>
      </ContextualHelpProvider>,
    );

    const buyingPower = screen.getByRole("button", {
      name: "More information about Buying power",
    });
    const marketOrder = screen.getByRole("button", {
      name: "More information about Market order",
    });

    fireEvent.click(buyingPower);
    expect(
      screen.getByRole("dialog", { name: "Buying power explanation" }),
    ).toBeInTheDocument();
    expect(buyingPower).toHaveAttribute("aria-expanded", "true");

    fireEvent.click(marketOrder);
    expect(
      screen.queryByRole("dialog", { name: "Buying power explanation" }),
    ).not.toBeInTheDocument();
    expect(
      screen.getByRole("dialog", { name: "Market order explanation" }),
    ).toBeInTheDocument();
  });

  it("closes with Escape", () => {
    render(
      <ContextualHelpProvider>
        <ContextualHelp label="Lots">
          One IDX lot equals 100 shares.
        </ContextualHelp>
      </ContextualHelpProvider>,
    );

    const button = screen.getByRole("button", {
      name: "More information about Lots",
    });
    fireEvent.click(button);
    fireEvent.keyDown(button, { key: "Escape" });

    expect(
      screen.queryByRole("dialog", { name: "Lots explanation" }),
    ).not.toBeInTheDocument();
    expect(button).toHaveAttribute("aria-expanded", "false");
  });
});
