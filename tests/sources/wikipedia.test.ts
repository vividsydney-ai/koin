import { describe, it, expect, vi } from "vitest";
import { fetchWikipediaSummary, buildWikipediaSearchUrl } from "@/lib/sources/wikipedia";

describe("buildWikipediaSearchUrl", () => {
  it("builds English Wikipedia URL", () => {
    expect(buildWikipediaSearchUrl("Money", "en")).toBe("https://en.wikipedia.org/wiki/Money");
  });

  it("builds Indonesian Wikipedia URL", () => {
    expect(buildWikipediaSearchUrl("Uang", "id")).toBe("https://id.wikipedia.org/wiki/Uang");
  });

  it("encodes spaces as underscores", () => {
    expect(buildWikipediaSearchUrl("Compound interest", "en")).toBe(
      "https://en.wikipedia.org/wiki/Compound_interest"
    );
  });
});

describe("fetchWikipediaSummary", () => {
  it("returns summary fields on success", async () => {
    global.fetch = vi.fn().mockResolvedValueOnce({
      ok: true,
      json: async () => ({
        title: "Money",
        extract: "Money is any item or verifiable record...",
        content_urls: { desktop: { page: "https://en.wikipedia.org/wiki/Money" } },
        thumbnail: { source: "https://upload.wikimedia.org/money.png" },
      }),
    } as Response);

    const result = await fetchWikipediaSummary("Money", "en");
    expect(result.title).toBe("Money");
    expect(result.extract).toBe("Money is any item or verifiable record...");
    expect(result.url).toBe("https://en.wikipedia.org/wiki/Money");
    expect(result.thumbnailUrl).toBe("https://upload.wikimedia.org/money.png");
  });

  it("falls back to a search link when the API fails", async () => {
    global.fetch = vi.fn().mockResolvedValueOnce({
      ok: false,
      status: 404,
    } as Response);

    const result = await fetchWikipediaSummary("UnknownTopic", "en");
    expect(result.url).toBe("https://en.wikipedia.org/wiki/UnknownTopic");
    expect(result.extract).toBe("");
  });

  it("falls back to a search link on network error", async () => {
    global.fetch = vi.fn().mockRejectedValueOnce(new Error("network failure"));

    const result = await fetchWikipediaSummary("Inflation", "id");
    expect(result.url).toBe("https://id.wikipedia.org/wiki/Inflation");
    expect(result.extract).toBe("");
  });
});
