import { describe, it, expect, vi } from "vitest";

const mocks = {
  single: vi.fn(),
  eq: vi.fn().mockResolvedValue({ error: null }),
  select: vi.fn().mockReturnThis(),
};

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: vi.fn().mockImplementation((table: string) => {
      if (table === "profiles") {
        return {
          select: mocks.select.mockImplementation(() => ({
            eq: mocks.eq.mockImplementation(() => ({
              single: mocks.single,
            })),
          })),
          update: vi.fn().mockImplementation(() => ({
            eq: mocks.eq,
          })),
        };
      }
      if (table === "user_settings") {
        return {
          update: vi.fn().mockImplementation(() => ({
            eq: mocks.eq,
          })),
        };
      }
      return {};
    }),
  },
}));

import { getProfile, completeOnboarding } from "@/lib/profile/client";

describe("profile client", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("getProfile returns profile data", async () => {
    mocks.single.mockResolvedValueOnce({
      data: { id: "user-1", onboarding_completed: false },
      error: null,
    });

    const profile = await getProfile("user-1");
    expect(profile).toEqual({ id: "user-1", onboarding_completed: false });
  });

  it("getProfile returns null on error", async () => {
    mocks.single.mockResolvedValueOnce({
      data: null,
      error: { message: "not found" },
    });

    const profile = await getProfile("user-1");
    expect(profile).toBeNull();
  });

  it("completeOnboarding updates profile and settings", async () => {
    const result = await completeOnboarding({
      userId: "user-1",
      displayName: "Budi",
      ageRange: "19_22",
      financialGoal: "start_investing",
      notificationsEnabled: true,
    });

    expect(result.error).toBeUndefined();
  });
});
