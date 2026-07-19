import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor, fireEvent } from "@testing-library/react";

const mockAddFriendByQr = vi.fn();
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
  addFriendByQr: (...args: unknown[]) => mockAddFriendByQr(...args),
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

describe("FriendsPage QR flow", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    (useAuth as ReturnType<typeof vi.fn>).mockReturnValue({
      user: mockUser,
      profile: mockProfile,
      loading: false,
    });
    mockGetFriends.mockResolvedValue([]);
    mockGetWeeklyLeaderboard.mockResolvedValue(null);
    mockGetCohorts.mockResolvedValue([]);
  });

  it("renders QR invite section", async () => {
    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByText("Invite friends")).toBeInTheDocument();
    });
    await waitFor(() => {
      expect(screen.getByLabelText("QR code for Budi")).toBeInTheDocument();
    });
    expect(screen.getByRole("button", { name: /Share/i })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /Scan QR/i })).toBeInTheDocument();
  });

  it("opens scanner when Scan QR is clicked", async () => {
    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByRole("button", { name: /Scan QR/i })).toBeInTheDocument();
    });

    fireEvent.click(screen.getByRole("button", { name: /Scan QR/i }));

    expect(screen.getByRole("dialog")).toBeInTheDocument();
    expect(screen.getByText("Scan friend's QR")).toBeInTheDocument();
    expect(screen.getByLabelText(/Or paste invite link/i)).toBeInTheDocument();
  });

  it("adds friend from manual user id input", async () => {
    mockAddFriendByQr.mockResolvedValue({ friendshipId: "friendship-1", status: "accepted" });

    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByRole("button", { name: /Scan QR/i })).toBeInTheDocument();
    });

    fireEvent.click(screen.getByRole("button", { name: /Scan QR/i }));

    const input = screen.getByLabelText(/Or paste invite link/i);
    fireEvent.change(input, { target: { value: "user-2" } });
    fireEvent.click(screen.getByRole("button", { name: /^Add$/i }));

    await waitFor(() => {
      expect(mockAddFriendByQr).toHaveBeenCalledWith("user-2");
    });
    expect(await screen.findByText("You're now friends!")).toBeInTheDocument();
  });

  it("shows error when manual add fails", async () => {
    mockAddFriendByQr.mockResolvedValue(null);

    render(<FriendsPage />);

    await waitFor(() => {
      expect(screen.getByRole("button", { name: /Scan QR/i })).toBeInTheDocument();
    });

    fireEvent.click(screen.getByRole("button", { name: /Scan QR/i }));

    const input = screen.getByLabelText(/Or paste invite link/i);
    fireEvent.change(input, { target: { value: "bad-id" } });
    fireEvent.submit(input.closest("form")!);

    expect(await screen.findByText(/User not found/i)).toBeInTheDocument();
  });
});
