import { describe, expect, it } from "vitest";
import { selectBestAccessibleSources } from "@/lib/sources/fallback";

const sources = [
  { id: "tier-1", sourceTier: 1 },
  { id: "tier-2", sourceTier: 2 },
  { id: "tier-3", sourceTier: 3 },
];

describe("selectBestAccessibleSources", () => {
  it("keeps all accessible Tier 1 sources and hides lower tiers", () => {
    const result = selectBestAccessibleSources(sources, new Map([
      ["tier-1", true],
      ["tier-2", true],
      ["tier-3", true],
    ]));

    expect(result.sources.map((source) => source.id)).toEqual(["tier-1"]);
    expect(result.bestTier).toBe(1);
    expect(result.usedFallback).toBe(false);
  });

  it("falls back to Tier 2, then Tier 3 when higher tiers are unavailable", () => {
    expect(selectBestAccessibleSources(sources, new Map([
      ["tier-1", false],
      ["tier-2", true],
      ["tier-3", true],
    ])).sources.map((source) => source.id)).toEqual(["tier-2"]);

    const tier3 = selectBestAccessibleSources(sources, new Map([
      ["tier-1", false],
      ["tier-2", false],
      ["tier-3", true],
    ]));
    expect(tier3.sources.map((source) => source.id)).toEqual(["tier-3"]);
    expect(tier3.usedFallback).toBe(true);
  });

  it("returns no source when every approved URL is unavailable", () => {
    const result = selectBestAccessibleSources(sources, new Map([
      ["tier-1", false],
      ["tier-2", false],
      ["tier-3", false],
    ]));

    expect(result.sources).toEqual([]);
    expect(result.bestTier).toBeNull();
  });
});
