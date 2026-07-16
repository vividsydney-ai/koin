import { describe, it, expect, vi, beforeEach } from "vitest";

const TEST_USER_ID = "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11";

const mocks = vi.hoisted(() => ({
  from: vi.fn(),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: mocks.from,
  },
}));

import { updateProfile, completeOnboarding } from "@/lib/services/profile";

describe("profile service", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.from.mockImplementation((table: string) => {
      const emptyEq = vi.fn().mockReturnValue({ error: null });
      const base = {
        update: vi.fn().mockReturnValue({ eq: emptyEq }),
        upsert: vi.fn().mockReturnValue({ eq: emptyEq }),
        select: vi.fn().mockReturnThis(),
        eq: vi.fn().mockReturnThis(),
        single: vi.fn().mockReturnValue({ data: null, error: null }),
      };

      if (table === "lessons") {
        base.select = vi.fn().mockImplementation(() => ({
          eq: vi.fn().mockImplementation(() => ({
            single: vi.fn().mockReturnValue({ data: { id: "lesson-id-1" }, error: null }),
          })),
        }));
      }

      return base;
    });
  });

  it("returns a validation error for an invalid user id", async () => {
    const result = await updateProfile({
      userId: "not-a-uuid",
      displayName: "Budi",
      notificationsEnabled: true,
    });

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.error.code).toBe("validation_error");
    }
  });

  it("updates profile and settings successfully", async () => {
    const result = await updateProfile({
      userId: TEST_USER_ID,
      displayName: "Budi Updated",
      notificationsEnabled: false,
    });

    expect(result.ok).toBe(true);
    expect(mocks.from).toHaveBeenCalledWith("profiles");
    expect(mocks.from).toHaveBeenCalledWith("user_settings");
  });

  it("returns a validation error during onboarding for an invalid user id", async () => {
    const result = await completeOnboarding({
      userId: "not-a-uuid",
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing"],
      notificationsEnabled: true,
    });

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.error.code).toBe("validation_error");
    }
  });

  it("completes onboarding successfully", async () => {
    const result = await completeOnboarding({
      userId: TEST_USER_ID,
      displayName: "Budi",
      ageRange: "19_22",
      financialGoals: ["start_investing", "save_emergency"],
      notificationsEnabled: true,
      financialLiteracyLevel: "intermediate",
    });

    expect(result.ok).toBe(true);
    expect(mocks.from).toHaveBeenCalledWith("profiles");
    expect(mocks.from).toHaveBeenCalledWith("user_settings");
  });
});
