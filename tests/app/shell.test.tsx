import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";

const usePathnameMock = vi.fn().mockReturnValue("/");

vi.mock("@/lib/auth/use-auth", () => ({
  useAuth: vi.fn().mockReturnValue({ loading: false }),
}));

vi.mock("next/navigation", () => ({
  usePathname: () => usePathnameMock(),
  useRouter: vi.fn().mockReturnValue({ push: vi.fn() }),
}));

import AppLayout from "@/app/(app)/layout";

describe("App shell", () => {
  it("renders bottom navigation with all tabs", () => {
    render(
      <AppLayout>
        <div>Child content</div>
      </AppLayout>
    );

    expect(screen.getByText("Home")).toBeInTheDocument();
    expect(screen.getByText("Learn")).toBeInTheDocument();
    expect(screen.getByText("Trade")).toBeInTheDocument();
    expect(screen.getByText("Friends")).toBeInTheDocument();
    expect(screen.getByText("Library")).toBeInTheDocument();
    expect(screen.getByText("Profile")).toBeInTheDocument();
    expect(screen.getByText("Child content")).toBeInTheDocument();
  });

  it("marks active tab", () => {
    usePathnameMock.mockReturnValue("/learn");

    render(
      <AppLayout>
        <div>Child content</div>
      </AppLayout>
    );

    const learnLink = screen.getByText("Learn").closest("a");
    expect(learnLink).toHaveAttribute("aria-current", "page");
  });
});
