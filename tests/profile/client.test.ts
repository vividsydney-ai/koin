import { describe, it, expect, vi, beforeEach } from "vitest";

const TEST_USER_ID = "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11";

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

import {
  getProfile,
  getUserSettings,
  getFinancialGoals,
  updateProfile,
  completeOnboarding,
} from "@/lib/profile/client";

describe("profile client", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("getProfile returns profile data", async () => {
    mocks.single.mockResolvedValueOnce({
      data: { id: TEST_USER_ID, onboarding_completed: false },
      error: null,
    });

    const profile = await getProfile(TEST_USER_ID);
    expect(profile).toEqual({ id: TEST_USER_ID, onboarding_completed: false });
  });

  it("getProfile returns null on error", async () => {
    mocks.single.mockResolvedValueOnce({
      data: null,
      error: { message: "not found" },
    });

    const profile = await getProfile(TEST_USER_ID);
    expect(profile).toBeNull();
  });

  it("getUserSettings returns settings data", async () => {
    mocks.single.mockResolvedValueOnce({
      data: { user_id: TEST_USER_ID, notifications_enabled: true },
      error: null,
    });

    const settings = await getUserSettings(TEST_USER_ID);
    expect(settings).toEqual({ user_id: TEST_USER_ID, notifications_enabled: true });
  });

  it("getFinancialGoals returns filtered string goals", async () => {
    mocks.single.mockResolvedValueOnce({
      data: { financial_goal: ["start_investing", "save_emergency"] },
      error: null,
    });

    const goals = await getFinancialGoals(TEST_USER_ID);
    expect(goals).toEqual(["start_investing", "save_emergency"]);
  });

  it("getFinancialGoals returns null on error", async () => {
    mocks.single.mockResolvedValueOnce({
      data: null,
      error: { message: "not found" },
    });

    const goals = await getFinancialGoals(TEST_USER_ID);
    expect(goals).toBeNull();
  });

  it("getFinancialGoals filters out non-string values", async () => {
    mocks.single.mockResolvedValueOnce({
      data: { financial_goal: ["start_investing", 123, null, "budget_better"] },
      error: null,
    });

    const goals = await getFinancialGoals(TEST_USER_ID);
    expect(goals).toEqual(["start_investing", "budget_better"]);
  });

  it("updateProfile updates profile and settings", async () => {
    const result = await updateProfile({
      userId: TEST_USER_ID,
      displayName: "Budi Updated",
      notificationsEnabled: false,
    });

    expect(result.error).toBeUndefined();
  });

  it("completeOnboarding updates profile and settings", async () => {
    const result = await completeOnboarding({
      userId: TEST_USER_ID,
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing"],
      notificationsEnabled: true,
    });

    expect(result.error).toBeUndefined();
  });

  it("completeOnboarding accepts financialLiteracyLevel", async () => {
    const result = await completeOnboarding({
      userId: TEST_USER_ID,
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
      userId: TEST_USER_ID,
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing", "save_emergency", "avoid_scams"],
      notificationsEnabled: true,
    });

    expect(result.error).toBeUndefined();
  });
});
