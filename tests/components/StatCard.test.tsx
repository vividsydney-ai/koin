import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { StatCard, toneTint } from "@/components/StatCard";

describe("toneTint", () => {
  it("builds a color-mix tint against the surface token", () => {
    expect(toneTint("streak")).toBe(
      "color-mix(in srgb, var(--color-streak) 8%, var(--color-surface))"
    );
    expect(toneTint("primary", 12)).toBe(
      "color-mix(in srgb, var(--color-primary) 12%, var(--color-surface))"
    );
  });
});

describe("StatCard (card variant)", () => {
  it("renders label, value, and sublabel", () => {
    render(
      <StatCard
        label="Koin Points"
        value="1,250"
        tone="koin-points"
        sublabel={<p>Earn more by ranking up.</p>}
      />
    );

    expect(screen.getByText("Koin Points")).toBeInTheDocument();
    expect(screen.getByText("1,250")).toBeInTheDocument();
    expect(screen.getByText("Earn more by ranking up.")).toBeInTheDocument();
  });

  it("renders the icon tile when icon is provided", () => {
    render(<StatCard label="Streak" value="5 days" tone="streak" icon="🔥" />);
    expect(screen.getByText("🔥")).toBeInTheDocument();
  });

  it("renders aside content when no icon is provided", () => {
    render(
      <StatCard label="Portfolio" value="Rp 1.000" aside={<p>Top holding</p>} />
    );
    expect(screen.getByText("Top holding")).toBeInTheDocument();
  });

  it("renders an accessible progress bar and clamps the percent", () => {
    render(<StatCard label="Level" value="Newbie" tone="xp" progress={{ percent: 140 }} />);

    const bar = screen.getByRole("progressbar");
    expect(bar).toHaveAttribute("aria-valuenow", "100");
    expect(bar).toHaveAttribute("aria-valuemin", "0");
    expect(bar).toHaveAttribute("aria-valuemax", "100");
    expect(bar.firstChild).toHaveStyle({ width: "100%" });
  });

  it("omits the progress bar when progress is not provided", () => {
    render(<StatCard label="Level" value="Newbie" />);
    expect(screen.queryByRole("progressbar")).not.toBeInTheDocument();
  });
});

describe("StatCard (tile variant)", () => {
  it("renders value and label with a tone-tinted surface", () => {
    const { container } = render(
      <StatCard variant="tile" label="Streak" value="7d" tone="streak" />
    );

    expect(screen.getByText("7d")).toBeInTheDocument();
    expect(screen.getByText("Streak")).toBeInTheDocument();
    // Inline style carries the color-mix tint, not a raw -50 token.
    expect(container.firstChild).toHaveStyle({
      background: "color-mix(in srgb, var(--color-streak) 8%, var(--color-surface))",
    });
  });
});
