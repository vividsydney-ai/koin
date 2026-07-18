import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";

const mockGetFriends = vi.fn();
const mockGetWeeklyLeaderboard = vi.fn();
const mockGetCohorts = vi.fn();

vi.mock("qrcode", () => ({
  default: {
    toString: vi.fn().mockResolvedValue('<svg xmlns="http://www.w3.org/2000/svg"><rect width="10" height="10"/></svg>'),
  },
}));

vi.mock("jsqr", () => ({
  default: vi.fn(),
}));

vi.mock("@/lib/auth/use-auth", () => ({
  useAuth: vi.fn(),
}));

vi.mock("@/lib/friends/client", () => ({
  addFriendByQr: vi.fn(),
  getFriends: (...args: unknown[]) => mockGetFriends(...args),
}));

vi.mock("@/lib/home/client", () => ({
  getWeeklyLeaderboard: (...args: unknown[]) => mockGetWeeklyLeaderboard(...args),
}));

vi.mock("@/lib/cohorts/client", () => ({
  joinCohortByCode: vi.fn(),
  getCohorts: (...args: unknown[]) => mockGetCohorts(...args),
}));

vi.mock("next/navigation", () => ({
  usePathname: vi.fn().mockReturnValue("/friends"),
  useRouter: vi.fn().mockReturnValue({ push: vi.fn() }),
}));

import { useAuth } from "@/lib/auth/use-auth";
import FriendsPage from "@/app/(app)/friends/page";

const mockUser = { id: "user-1", email: "budi@example.com" };
const mockProfile = { display_name: "Budi" };

const mockLeaderboard = {
  weekStart: "2026-07-13",
  xp: [
    { rank: 1, displayName: "Dita Ramadhani", xpThisWeek: 3120, isCurrentUser: false },
    { rank: 2, displayName: "Budi", xpThisWeek: 2450, isCurrentUser: true },
    { rank: 3, displayName: "Fajar Pratama", xpThisWeek: 2290, isCurrentUser: false },
    { rank: 4, displayName: "Naya Salsabila", xpThisWeek: 1875, isCurrentUser: false },
  ],
  koinPoints: [
    { rank: 1, displayName: "Dita Ramadhani", koinPointsThisWeek: 420, isCurrentUser: false },
    { rank: 2, displayName: "Budi", koinPointsThisWeek: 350, isCurrentUser: true },
  ],
};

describe("FriendsPage leaderboard", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    (useAuth as ReturnType<typeof vi.fn>).mockReturnValue({
      user: mockUser,
      profile: mockProfile,
      loading: false,
    });
    mockGetFriends.mockResolvedValue([]);
    mockGetWeeklyLeaderboard.mockResolvedValue(mockLeaderboard);
    mockGetCohorts.mockResolvedValue([]);
  });

  it("renders both XP and Koin Points lists with rows and avatar-chip initials", async () => {
    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByText("XP")).toBeInTheDocument();
    });
    expect(screen.getByText("Koin Points")).toBeInTheDocument();

    // Rows render for every entry (Dita appears in both lists).
    expect(screen.getAllByText("Dita Ramadhani")).toHaveLength(2);
    expect(screen.getByText("Fajar Pratama")).toBeInTheDocument();
    expect(screen.getByText("Naya Salsabila")).toBeInTheDocument();

    // Avatar chips carry initials.
    expect(screen.getAllByText("DR")).toHaveLength(2);
    expect(screen.getByText("FP")).toBeInTheDocument();
    expect(screen.getByText("NS")).toBeInTheDocument();

    // Values formatted with id-ID locale (dot thousands separator).
    expect(screen.getByText("3.120")).toBeInTheDocument();
    expect(screen.getByText("2.450")).toBeInTheDocument();
  });

  it("applies gold/silver/bronze tiers to top 3 only", async () => {
    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByText("Naya Salsabila")).toBeInTheDocument();
    });

    const rows = screen.getAllByRole("listitem");
    const byName = (name: string) => rows.find((r) => r.textContent?.includes(name))!;

    expect(byName("Dita Ramadhani")).toHaveAttribute("data-tier", "gold");
    expect(byName("Fajar Pratama")).toHaveAttribute("data-tier", "bronze");
    // Rank-4 row has no tier hook.
    expect(byName("Naya Salsabila")).not.toHaveAttribute("data-tier");

    // Silver tier on the rank-2 row (which is also the current user in the XP list).
    const silverRows = rows.filter((r) => r.getAttribute("data-tier") === "silver");
    expect(silverRows.length).toBeGreaterThan(0);
    expect(silverRows[0]).toHaveTextContent("Budi");
  });

  it("highlights the current user's row with a primary color-mix tint", async () => {
    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByText("Naya Salsabila")).toBeInTheDocument();
    });

    const youRows = screen
      .getAllByRole("listitem")
      .filter((r) => r.getAttribute("data-current-user") === "true");

    // Current user appears in both XP and Koin Points lists.
    expect(youRows).toHaveLength(2);
    for (const row of youRows) {
      expect(row.className).toContain("color-mix(in_srgb,var(--color-primary)_8%,var(--color-surface))");
      expect(row).toHaveTextContent("Budi");
      expect(row).toHaveTextContent("You");
    }

    // Other rows are not highlighted.
    const otherRow = screen
      .getAllByRole("listitem")
      .find((r) => r.textContent?.includes("Naya Salsabila"))!;
    expect(otherRow).not.toHaveAttribute("data-current-user");
    expect(otherRow.className).not.toContain("color-mix");
  });
});
