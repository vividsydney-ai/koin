import { describe, expect, it } from "vitest";
import {
  formatRupiah,
  formatRupiahChange,
  getChangeTone,
} from "@/lib/formatters/rupiah";

describe("Paper Trading Rupiah formatting", () => {
  it("uses the Koinaku Rp-space convention", () => {
    expect(formatRupiah(1_442_000)).toBe("Rp 1.442.000");
  });

  it("keeps zero changes neutral and omits a misleading positive sign", () => {
    expect(formatRupiahChange(0)).toBe("Rp 0");
    expect(getChangeTone(0)).toBe("neutral");
  });

  it("adds a spaced sign only to non-zero changes", () => {
    expect(formatRupiahChange(8_000)).toBe("+ Rp 8.000");
    expect(formatRupiahChange(-8_000)).toBe("- Rp 8.000");
    expect(getChangeTone(-8_000)).toBe("negative");
  });
});
