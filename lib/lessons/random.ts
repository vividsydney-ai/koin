// Deterministic pseudo-random utilities for lesson variant selection.
// Same seed always produces the same sequence, which keeps sessions consistent
// for a given user/day but different across users.

export function mulberry32(seed: string) {
  let hash = 0;
  for (let i = 0; i < seed.length; i++) {
    hash = (hash << 5) - hash + seed.charCodeAt(i);
    hash |= 0;
  }
  let state = hash >>> 0;
  return function () {
    state = (state + 0x6d2b79f5) >>> 0;
    let t = state;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export function seededIndex(seed: string, length: number): number {
  if (length <= 1) return 0;
  return Math.abs(mulberry32(seed)()) % length;
}

export function seededShuffle<T>(seed: string, array: T[]): T[] {
  const rng = mulberry32(seed);
  const copy = [...array];
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

export function seededInt(seed: string, min: number, max: number): number {
  return Math.floor(mulberry32(seed)() * (max - min + 1)) + min;
}
