import { describe, it, expect } from "vitest";
import { mulberry32, seededIndex, seededShuffle, seededInt } from "@/lib/lessons/random";

describe("random", () => {
  it("seededIndex returns the same value for the same seed", () => {
    expect(seededIndex("user-a:lesson-1:2024-1-1", 10)).toBe(
      seededIndex("user-a:lesson-1:2024-1-1", 10)
    );
  });

  it("seededIndex returns different values for different users", () => {
    const length = 10;
    const a = seededIndex("user-a:lesson-1:2024-1-1", length);
    const b = seededIndex("user-b:lesson-1:2024-1-1", length);
    expect(a).not.toBe(b);
  });

  it("seededIndex returns different values for different days", () => {
    const length = 10;
    const a = seededIndex("user-a:lesson-1:2024-1-1", length);
    const b = seededIndex("user-a:lesson-1:2024-1-2", length);
    expect(a).not.toBe(b);
  });

  it("seededShuffle produces different orders for different seeds", () => {
    const array = ["a", "b", "c", "d", "e"];
    const shuffledA = seededShuffle("seed-a", array);
    const shuffledB = seededShuffle("seed-b", array);
    expect(shuffledA).not.toEqual(shuffledB);
    expect(shuffledA).toEqual(expect.arrayContaining(array));
  });

  it("seededInt stays within range", () => {
    for (let i = 0; i < 100; i++) {
      const value = seededInt(`seed-${i}`, 5, 15);
      expect(value).toBeGreaterThanOrEqual(5);
      expect(value).toBeLessThanOrEqual(15);
    }
  });

  it("mulberry32 produces values between 0 and 1", () => {
    const rng = mulberry32("test");
    for (let i = 0; i < 100; i++) {
      const value = rng();
      expect(value).toBeGreaterThanOrEqual(0);
      expect(value).toBeLessThan(1);
    }
  });
});
