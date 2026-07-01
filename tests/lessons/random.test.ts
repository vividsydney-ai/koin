import { describe, it, expect } from "vitest";
import { seededIndex, seededShuffle, seededInt, mulberry32 } from "@/lib/lessons/random";

describe("random", () => {
  describe("seededIndex", () => {
    it("returns 0 for length 0 or 1", () => {
      expect(seededIndex("abc", 0)).toBe(0);
      expect(seededIndex("abc", 1)).toBe(0);
    });

    it("is deterministic for the same seed", () => {
      expect(seededIndex("user:lesson:2026-7-1", 10)).toBe(seededIndex("user:lesson:2026-7-1", 10));
    });

    it("returns values within range", () => {
      for (let i = 0; i < 50; i++) {
        const value = seededIndex(`seed-${i}`, 20);
        expect(value).toBeGreaterThanOrEqual(0);
        expect(value).toBeLessThan(20);
      }
    });
  });

  describe("seededShuffle", () => {
    it("returns a permutation of the original array", () => {
      const input = ["a", "b", "c", "d", "e"];
      const shuffled = seededShuffle("seed", input);
      expect(shuffled).toHaveLength(input.length);
      expect(shuffled.slice().sort()).toEqual(input.slice().sort());
    });

    it("is deterministic for the same seed", () => {
      const input = [1, 2, 3, 4, 5, 6, 7, 8];
      expect(seededShuffle("x", input)).toEqual(seededShuffle("x", input));
    });

    it("produces different orders for different seeds", () => {
      const input = [1, 2, 3, 4, 5, 6, 7, 8];
      const a = seededShuffle("seed-a", input);
      const b = seededShuffle("seed-b", input);
      expect(a).not.toEqual(b);
    });
  });

  describe("seededInt", () => {
    it("returns integers within bounds", () => {
      for (let i = 0; i < 50; i++) {
        const value = seededInt(`seed-${i}`, 10, 20);
        expect(value).toBeGreaterThanOrEqual(10);
        expect(value).toBeLessThanOrEqual(20);
        expect(Number.isInteger(value)).toBe(true);
      }
    });
  });

  describe("mulberry32", () => {
    it("produces numbers in [0, 1)", () => {
      const rng = mulberry32("seed");
      for (let i = 0; i < 20; i++) {
        const value = rng();
        expect(value).toBeGreaterThanOrEqual(0);
        expect(value).toBeLessThan(1);
      }
    });
  });
});
