import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";
import { GradientIcon } from "@/components/GradientIcon";

describe("GradientIcon", () => {
  it("renders a plain muted icon when inactive (no gradient tile)", () => {
    const { container } = render(<GradientIcon icon="home" active={false} />);

    const svg = container.querySelector("svg");
    expect(svg).toBeInTheDocument();
    expect(svg).toHaveAttribute("aria-hidden", "true");
    expect(svg).toHaveAttribute("stroke", "currentColor");
    // Inactive: no gradient tile wrapper
    expect(container.querySelector(".bg-brand")).not.toBeInTheDocument();
    expect(container.firstChild).toBe(svg);
  });

  it("renders a gradient tile with a white icon when active", () => {
    const { container } = render(<GradientIcon icon="trade" active />);

    const tile = container.querySelector(".bg-brand");
    expect(tile).toBeInTheDocument();
    expect(tile).toHaveClass("text-primary-foreground");
    expect(tile?.querySelector("svg")).toBeInTheDocument();
  });

  it("defaults to the inactive state", () => {
    const { container } = render(<GradientIcon icon="profile" />);

    expect(container.querySelector(".bg-brand")).not.toBeInTheDocument();
  });

  it("renders every nav icon name", () => {
    const names = ["home", "learn", "trade", "friends", "library", "profile"] as const;

    for (const name of names) {
      const { container, unmount } = render(<GradientIcon icon={name} />);
      const svg = container.querySelector("svg");
      expect(svg).toBeInTheDocument();
      expect(svg?.querySelector("path, circle")).not.toBeNull();
      unmount();
    }
  });
});
