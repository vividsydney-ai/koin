import { describe, it, expect, vi } from "vitest";

const { from, select, eq, order } = vi.hoisted(() => ({
  from: vi.fn(),
  select: vi.fn(),
  eq: vi.fn(),
  order: vi.fn(),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from,
  },
}));

import { getLessonVariants, type ContentVariant } from "@/lib/lessons/client";

describe("lessons client", () => {
  function createQueryChain(rows: unknown[]) {
    const chain = {
      eq: vi.fn(() => chain),
      then: vi.fn((cb: (result: { data: unknown[]; error: null }) => void) =>
        cb({ data: rows, error: null })
      ),
    };
    return chain;
  }

  function mockVariantsResponse(rows: Partial<ContentVariant>[]) {
    from.mockReturnValueOnce({
      select: vi.fn(() => createQueryChain(rows)),
    });
  }

  it("returns all active variants when no preferred difficulty is provided", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation");
    expect(variants).toHaveLength(2);
  });

  it("filters variants by preferred difficulty", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
      { id: "v3", variantType: "explanation", body: {}, difficulty: null, topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "beginner");
    expect(variants.map((v) => v.id)).toEqual(["v1", "v3"]);
  });

  it("falls back to all variants when the filtered pool is empty", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "intermediate", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "beginner");
    expect(variants).toHaveLength(2);
  });

  it("does not filter when preferred difficulty is null", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", null);
    expect(variants).toHaveLength(2);
  });
});
