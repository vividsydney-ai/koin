import { describe, it, expect } from "vitest";
import { normalizeAuthError } from "@/lib/auth/errors";

describe("normalizeAuthError", () => {
  it("maps 429 status to rate_limit", () => {
    const result = normalizeAuthError({ status: 429, message: "Too many requests" });
    expect(result.code).toBe("rate_limit");
  });

  it("maps captcha protection failures to captcha_failed", () => {
    const result = normalizeAuthError({
      message: "captcha protection: request disallowed (no captcha_token found)",
    });
    expect(result.code).toBe("captcha_failed");
    expect(result.message).toContain("Human verification failed");
  });

  it("maps request disallowed to captcha_failed", () => {
    const result = normalizeAuthError({ message: "Request disallowed" });
    expect(result.code).toBe("captcha_failed");
  });

  it("preserves unknown messages when present", () => {
    const result = normalizeAuthError({ message: "Custom error" });
    expect(result.code).toBe("unknown");
    expect(result.message).toBe("Custom error");
  });

  it("falls back to a generic message when no message is provided", () => {
    const result = normalizeAuthError({});
    expect(result.code).toBe("unknown");
    expect(result.message).toBe("Something went wrong. Please try again.");
  });
});
