import { describe, it, expect, vi } from "vitest";

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: vi.fn().mockReturnValue({
      select: vi.fn().mockReturnValue({
        order: vi.fn().mockReturnValue({
          order: vi.fn().mockResolvedValue({
            data: [
              {
                id: "s-1",
                source_code: "OJK-001",
                title: "National Strategy",
                local_title: "Strategi Nasional",
                source_tier: 1,
                source_type: "report",
                organization: "OJK",
                url: "https://ojk.go.id/example",
                isbn: null,
                language: "id",
                publication_year: 2021,
                status: "verified",
              },
            ],
            error: null,
          }),
        }),
      }),
    }),
  },
}));

import { getSources, type Source } from "@/lib/sources/client";

describe("sources client", () => {
  it("getSources maps rows to the Source interface", async () => {
    const sources = await getSources();

    expect(sources).toHaveLength(1);
    expect(sources[0]).toMatchObject<Partial<Source>>({
      id: "s-1",
      sourceCode: "OJK-001",
      title: "National Strategy",
      localTitle: "Strategi Nasional",
      sourceTier: 1,
      sourceType: "report",
      organization: "OJK",
      url: "https://ojk.go.id/example",
      language: "id",
      publicationYear: 2021,
      status: "verified",
    });
  });
});
