import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen } from "@testing-library/react";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: pushMock, replace: vi.fn() }),
}));

vi.mock("@/lib/auth/client", () => ({
  signOut: vi.fn(),
}));

vi.mock("@/lib/i18n/LocaleProvider", () => ({
  useLocale: () => ({
    t: (key: string) => {
      const dict: Record<string, string> = {
        "profile.logout": "Log out",
        "profile.replayOnboarding": "Replay onboarding",
      };
      return dict[key] ?? key;
    },
    locale: "en",
  }),
}));

import AccountPage from "@/app/(app)/profile/account/page";

describe("Account page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders a replay onboarding link", () => {
    render(<AccountPage />);

    const replayLink = screen.getByRole("link", { name: /replay onboarding/i });
    expect(replayLink).toBeInTheDocument();
    expect(replayLink).toHaveAttribute("href", "/onboarding?replay=1");
  });
});
