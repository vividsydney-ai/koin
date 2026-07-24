import { describe, it, expect, beforeEach } from "vitest";
import { checkRateLimit, resetRateLimitStore } from "@/lib/rate-limit";

function makeRequest(ip = "1.2.3.4"): Request {
  return new Request("https://example.com/login", {
    headers: { "x-forwarded-for": ip },
  });
}

describe("checkRateLimit", () => {
  beforeEach(() => {
    resetRateLimitStore();
  });

  it("allows requests under the limit", () => {
    const rule = { windowMs: 60_000, maxRequests: 3 };
    const r1 = checkRateLimit(makeRequest(), rule, "auth");
    expect(r1.allowed).toBe(true);
    expect(r1.remaining).toBe(2);

    const r2 = checkRateLimit(makeRequest(), rule, "auth");
    expect(r2.allowed).toBe(true);
    expect(r2.remaining).toBe(1);
  });

  it("blocks requests over the limit", () => {
    const rule = { windowMs: 60_000, maxRequests: 2 };
    checkRateLimit(makeRequest(), rule, "auth");
    checkRateLimit(makeRequest(), rule, "auth");
    const r3 = checkRateLimit(makeRequest(), rule, "auth");
    expect(r3.allowed).toBe(false);
    expect(r3.remaining).toBe(0);
  });

  it("tracks different IPs independently", () => {
    const rule = { windowMs: 60_000, maxRequests: 1 };
    const a = checkRateLimit(makeRequest("1.1.1.1"), rule, "auth");
    const b = checkRateLimit(makeRequest("2.2.2.2"), rule, "auth");
    expect(a.allowed).toBe(true);
    expect(b.allowed).toBe(true);
  });

  it("tracks different suffixes independently for the same IP", () => {
    const rule = { windowMs: 60_000, maxRequests: 1 };
    const a = checkRateLimit(makeRequest(), rule, "auth");
    const b = checkRateLimit(makeRequest(), rule, "cron");
    expect(a.allowed).toBe(true);
    expect(b.allowed).toBe(true);
  });

  it("resets the bucket after the window expires", async () => {
    const rule = { windowMs: 50, maxRequests: 1 };
    checkRateLimit(makeRequest(), rule, "auth");
    await new Promise((resolve) => setTimeout(resolve, 60));
    const r2 = checkRateLimit(makeRequest(), rule, "auth");
    expect(r2.allowed).toBe(true);
    expect(r2.remaining).toBe(0);
  });
});
