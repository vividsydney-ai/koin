import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import { EmptyState } from "@/components/EmptyState";

describe("EmptyState", () => {
  it("renders icon, title, and description", () => {
    render(<EmptyState icon="📚" title="Nothing here" description="Try again later." />);

    expect(screen.getByText("📚")).toBeInTheDocument();
    expect(screen.getByText("Nothing here")).toBeInTheDocument();
    expect(screen.getByText("Try again later.")).toBeInTheDocument();
  });

  it("renders a link action when href is provided", () => {
    render(<EmptyState icon="🏆" title="No friends" description="Invite one." action={{ label: "Invite", href: "/friends" }} />);

    const link = screen.getByRole("link", { name: "Invite" });
    expect(link).toHaveAttribute("href", "/friends");
  });

  it("renders a button action when onClick is provided", () => {
    const handleClick = vi.fn();
    render(<EmptyState icon="📝" title="No trades" description="Place one." action={{ label: "Trade", onClick: handleClick }} />);

    expect(screen.getByRole("button", { name: "Trade" })).toBeInTheDocument();
  });
});
