import { describe, it, expect, vi, beforeEach } from "vitest";

const fromMock = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: fromMock,
  },
}));

import { getStreak } from "@/lib/home/client";

describe("home client", () => {
  beforeEach(() => {
    fromMock.mockClear();
  });

  it("returns streak data when a row exists", async () => {
    const singleMock = vi.fn().mockResolvedValue({
      data: { current_streak_days: 3, longest_streak_days: 5, streak_status: "active" },
      error: null,
    });
    fromMock.mockReturnValue({
      select: vi.fn().mockReturnValue({ eq: vi.fn().mockReturnValue({ maybeSingle: singleMock }) }),
    });

    const result = await getStreak("user-1");

    expect(result).toEqual({ currentStreakDays: 3, longestStreakDays: 5, streakStatus: "active" });
  });

  it("returns default streak data when no row exists", async () => {
    const singleMock = vi.fn().mockResolvedValue({ data: null, error: null });
    fromMock.mockReturnValue({
      select: vi.fn().mockReturnValue({ eq: vi.fn().mockReturnValue({ maybeSingle: singleMock }) }),
    });

    const result = await getStreak("user-1");

    expect(result).toEqual({ currentStreakDays: 0, longestStreakDays: 0, streakStatus: "active" });
  });

  it("returns null and logs on unexpected error", async () => {
    const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const singleMock = vi.fn().mockResolvedValue({ data: null, error: { message: "boom" } });
    fromMock.mockReturnValue({
      select: vi.fn().mockReturnValue({ eq: vi.fn().mockReturnValue({ maybeSingle: singleMock }) }),
    });

    const result = await getStreak("user-1");

    expect(result).toBeNull();
    expect(consoleSpy).toHaveBeenCalledWith("getStreak error:", "boom");
    consoleSpy.mockRestore();
  });
});
