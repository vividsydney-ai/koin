import { describe, it, expect, vi, beforeEach } from "vitest";

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
      return {};
    }),
  },
}));

import { getProfile, getUserSettings, updateProfile, completeOnboarding } from "@/lib/profile/client";

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

  it("getUserSettings returns settings data", async () => {
    mocks.single.mockResolvedValueOnce({
      data: { user_id: "user-1", notifications_enabled: true },
      error: null,
    });

    const settings = await getUserSettings("user-1");
    expect(settings).toEqual({ user_id: "user-1", notifications_enabled: true });
  });

  it("updateProfile updates profile and settings", async () => {
    const result = await updateProfile({
      userId: "user-1",
      displayName: "Budi Updated",
      notificationsEnabled: false,
    });

    expect(result.error).toBeUndefined();
  });

  it("completeOnboarding updates profile and settings", async () => {
    const result = await completeOnboarding({
      userId: "user-1",
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing"],
      notificationsEnabled: true,
    });

    expect(result.error).toBeUndefined();
  });

  it("completeOnboarding accepts financialLiteracyLevel", async () => {
    const result = await completeOnboarding({
      userId: "user-1",
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing"],
      notificationsEnabled: true,
      financialLiteracyLevel: "intermediate",
    });

    expect(result.error).toBeUndefined();
  });

  it("completeOnboarding accepts multiple financial goals", async () => {
    const result = await completeOnboarding({
      userId: "user-1",
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing", "save_emergency", "avoid_scams"],
      notificationsEnabled: true,
    });

    expect(result.error).toBeUndefined();
  });
});
