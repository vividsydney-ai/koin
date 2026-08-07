import { describe, expect, it } from "vitest";
import { getLocalizedSourceUrl } from "@/lib/sources/localized-url";

describe("getLocalizedSourceUrl", () => {
  const source = {
    url: "https://id.wikipedia.org/wiki/Inflasi",
    title: "Inflation",
    localTitle: "Inflasi",
  };

  it("keeps a Wikipedia URL in English for English learners", () => {
    expect(getLocalizedSourceUrl(source, "en")).toBe("https://en.wikipedia.org/wiki/Inflation");
  });

  it("keeps a Wikipedia URL in Indonesian for Indonesian learners", () => {
    expect(getLocalizedSourceUrl(source, "id")).toBe("https://id.wikipedia.org/wiki/Inflasi");
  });

  it("does not rewrite non-Wikipedia sources", () => {
    expect(
      getLocalizedSourceUrl(
        { ...source, url: "https://www.ojk.go.id/example" },
        "en"
      )
    ).toBe("https://www.ojk.go.id/example");
  });
});
