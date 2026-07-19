import { describe, it, expect, vi, beforeEach } from "vitest";
import { getRecentAttemptVariantIds } from "@/lib/lessons/client";

const rangeResult = { data: [] as Record<string, unknown>[], error: null };
const query = {
  select: vi.fn().mockReturnThis(),
  eq: vi.fn().mockReturnThis(),
  gte: vi.fn().mockReturnThis(),
  order: vi.fn().mockResolvedValue(rangeResult),
};

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: vi.fn(() => query),
  },
}));

describe("getRecentAttemptVariantIds (KO-REPLAY-001)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    rangeResult.data = [];
  });

  it("collects variant ids from array-shaped answers_json", async () => {
    rangeResult.data = [
      { answers_json: [{ variant_id: "a" }, { variant_id: "b" }] },
      { answers_json: [{ variant_id: "c" }] },
    ];

    const result = await getRecentAttemptVariantIds("user1", "lesson1");

    expect(result.ids).toEqual(new Set(["a", "b", "c"]));
    expect(result.lastVariantId).toBe("a");
  });

  it("does not throw on object-shaped answers_json (legacy rows)", async () => {
    rangeResult.data = [
      { answers_json: {} },
      { answers_json: [{ variant_id: "x" }] },
    ];

    const result = await getRecentAttemptVariantIds("user1", "lesson1");

    expect(result.ids).toEqual(new Set(["x"]));
    expect(result.lastVariantId).toBe("x");
  });

  it("handles null answers_json", async () => {
    rangeResult.data = [{ answers_json: null }];

    const result = await getRecentAttemptVariantIds("user1", "lesson1");

    expect(result.ids.size).toBe(0);
    expect(result.lastVariantId).toBeNull();
  });
});
