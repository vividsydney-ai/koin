import { describe, it, expect, vi } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { FilterChips, FilterChipGroup } from "@/components/FilterChips";

const GROUPS = [
  {
    label: "Tier",
    value: "1",
    onChange: vi.fn(),
    allLabel: "All tiers",
    options: [
      { value: "1", label: "Tier 1 — Regulator" },
      { value: "2", label: "Tier 2 — Enrichment" },
    ],
  },
  {
    label: "Language",
    value: "",
    onChange: vi.fn(),
    allLabel: "All languages",
    options: [{ value: "id", label: "id" }],
  },
];

describe("FilterChips", () => {
  it("renders every group with its label, All chip, and options", () => {
    render(<FilterChips groups={GROUPS} />);

    expect(screen.getByRole("group", { name: "Tier" })).toBeInTheDocument();
    expect(screen.getByRole("group", { name: "Language" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "All tiers" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Tier 1 — Regulator" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "All languages" })).toBeInTheDocument();
  });

  it("marks only the selected chip as pressed within each group", () => {
    render(<FilterChips groups={GROUPS} />);

    expect(screen.getByRole("button", { name: "Tier 1 — Regulator" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByRole("button", { name: "Tier 2 — Enrichment" })).toHaveAttribute("aria-pressed", "false");
    // No selection in the Language group -> its All chip is active.
    expect(screen.getByRole("button", { name: "All languages" })).toHaveAttribute("aria-pressed", "true");
    expect(screen.getByRole("button", { name: "All tiers" })).toHaveAttribute("aria-pressed", "false");
  });

  it("calls onChange with the option value when a chip is clicked", () => {
    const onChange = vi.fn();
    render(
      <FilterChipGroup
        label="Tier"
        value=""
        onChange={onChange}
        options={[{ value: "2", label: "Tier 2 — Enrichment" }]}
      />
    );

    fireEvent.click(screen.getByRole("button", { name: "Tier 2 — Enrichment" }));
    expect(onChange).toHaveBeenCalledWith("2");
  });

  it("calls onChange with an empty string when the All chip is clicked", () => {
    const onChange = vi.fn();
    render(
      <FilterChipGroup
        label="Tier"
        value="2"
        onChange={onChange}
        allLabel="All tiers"
        options={[{ value: "2", label: "Tier 2 — Enrichment" }]}
      />
    );

    fireEvent.click(screen.getByRole("button", { name: "All tiers" }));
    expect(onChange).toHaveBeenCalledWith("");
  });

  it("gives chips a 44px minimum touch target", () => {
    render(<FilterChips groups={GROUPS} />);
    const chip = screen.getByRole("button", { name: "Tier 1 — Regulator" });
    expect(chip.className).toContain("min-h-[44px]");
  });
});
