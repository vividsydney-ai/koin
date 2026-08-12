export interface SourceWithTier {
  id: string;
  sourceTier: number;
}

export interface SourceFallbackSelection<T extends SourceWithTier> {
  sources: T[];
  bestTier: number | null;
  usedFallback: boolean;
}

/** Select one accessible trust tier, preferring the highest available tier. */
export function selectBestAccessibleSources<T extends SourceWithTier>(
  sources: T[],
  availability: Map<string, boolean>,
): SourceFallbackSelection<T> {
  const accessible = sources.filter((source) => availability.get(source.id) === true);
  const bestTier = accessible.length > 0
    ? Math.min(...accessible.map((source) => source.sourceTier))
    : null;

  return {
    sources: bestTier === null
      ? []
      : accessible.filter((source) => source.sourceTier === bestTier),
    bestTier,
    usedFallback: bestTier !== null && sources.some((source) => source.sourceTier < bestTier),
  };
}
