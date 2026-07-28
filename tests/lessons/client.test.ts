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

import {
  getLessonVariants,
  isLikelyIndonesianOnlyVariant,
  type ContentVariant,
} from "@/lib/lessons/client";

describe("lessons client", () => {
  it("detects an ID-only legacy variant without rejecting normal English finance terms", () => {
    expect(
      isLikelyIndonesianOnlyVariant({
        text: "Diversifikasi menyebarkan risiko sehingga kerugian satu aset lebih kecil.",
      })
    ).toBe(true);
    expect(
      isLikelyIndonesianOnlyVariant({
        text: "Diversification spreads risk so one asset's loss has less impact.",
      })
    ).toBe(false);
  });

  it("hides an ID-only legacy variant from English while keeping it for Indonesian", async () => {
    mockVariantsResponse([
      {
        id: "id-only",
        variantType: "example",
        body: { text: "Dana darurat adalah uang untuk kebutuhan mendesak." },
        bodyId: { text: "Dana darurat adalah uang untuk kebutuhan mendesak." },
        difficulty: "beginner",
        topicTag: null,
      },
      {
        id: "english",
        variantType: "example",
        body: { text: "An emergency fund covers urgent costs." },
        bodyId: { text: "Dana darurat menutup biaya mendesak." },
        difficulty: "beginner",
        topicTag: null,
      },
    ]);
    const english = await getLessonVariants("lesson-1", "example", null, "en");
    expect(english.map((variant) => variant.id)).toEqual(["english"]);

    mockVariantsResponse([
      {
        id: "id-only",
        variantType: "example",
        body: { text: "Dana darurat adalah uang untuk kebutuhan mendesak." },
        bodyId: { text: "Dana darurat adalah uang untuk kebutuhan mendesak." },
        difficulty: "beginner",
        topicTag: null,
      },
    ]);
    const indonesian = await getLessonVariants("lesson-1", "example", null, "id");
    expect(indonesian.map((variant) => variant.id)).toEqual(["id-only"]);
  });

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

  it("falls back to the next lower difficulty when the preferred pool is empty", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "intermediate", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "beginner");
    expect(variants.map((v) => v.id)).toEqual(["v2"]);
  });

  it("does not filter when preferred difficulty is null", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", null);
    expect(variants).toHaveLength(2);
  });

  it("prefers the exact difficulty when available before falling back", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "intermediate", topicTag: null },
      { id: "v3", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "advanced");
    expect(variants.map((v) => v.id)).toEqual(["v3"]);
  });

  it("falls back to the next lower difficulty before a higher one", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v2", variantType: "explanation", body: {}, difficulty: "intermediate", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "advanced");
    expect(variants.map((v) => v.id)).toEqual(["v2"]);
  });

  it("falls back through multiple lower difficulties when needed", async () => {
    mockVariantsResponse([
      { id: "v1", variantType: "explanation", body: {}, difficulty: "beginner", topicTag: null },
      { id: "v3", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "intermediate");
    expect(variants.map((v) => v.id)).toEqual(["v1"]);
  });

  it("steps up to a higher difficulty only when no lower variant exists", async () => {
    mockVariantsResponse([
      { id: "v2", variantType: "explanation", body: {}, difficulty: "intermediate", topicTag: null },
      { id: "v3", variantType: "explanation", body: {}, difficulty: "advanced", topicTag: null },
    ]);

    const variants = await getLessonVariants("lesson-1", "explanation", "beginner");
    expect(variants.map((v) => v.id)).toEqual(["v2"]);
  });
});
