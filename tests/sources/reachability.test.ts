import { describe, it, expect, vi } from "vitest";
import { checkUrlReachability } from "@/lib/sources/reachability";

describe("checkUrlReachability", () => {
  it("returns ok=true for a 200 response", async () => {
    global.fetch = vi.fn().mockResolvedValue({
      status: 200,
      statusText: "OK",
    } as Response);

    const result = await checkUrlReachability("https://example.com", { attempts: 1 });
    expect(result.ok).toBe(true);
    expect(result.status).toBe(200);
  });

  it("treats 403 as reachable", async () => {
    global.fetch = vi.fn().mockResolvedValue({
      status: 403,
      statusText: "Forbidden",
    } as Response);

    const result = await checkUrlReachability("https://example.com", { attempts: 1 });
    expect(result.ok).toBe(true);
    expect(result.status).toBe(403);
  });

  it("returns ok=false for 404", async () => {
    global.fetch = vi.fn().mockResolvedValue({
      status: 404,
      statusText: "Not Found",
    } as Response);

    const result = await checkUrlReachability("https://example.com/missing", { attempts: 1 });
    expect(result.ok).toBe(false);
    expect(result.status).toBe(404);
  });

  it("returns ok=false for 503", async () => {
    global.fetch = vi.fn().mockResolvedValue({
      status: 503,
      statusText: "Service Unavailable",
    } as Response);

    const result = await checkUrlReachability("https://example.com/down", { attempts: 1 });
    expect(result.ok).toBe(false);
    expect(result.status).toBe(503);
  });

  it("retries on failure and reports the final status", async () => {
    global.fetch = vi
      .fn()
      .mockResolvedValueOnce({ status: 500, statusText: "Server Error" } as Response)
      .mockResolvedValueOnce({ status: 500, statusText: "Server Error" } as Response);

    const result = await checkUrlReachability("https://example.com/flaky", { attempts: 2 });
    expect(result.ok).toBe(false);
    expect(result.status).toBe(500);
    expect(global.fetch).toHaveBeenCalledTimes(2);
  });

  it("retries on network error and reports the error message", async () => {
    global.fetch = vi
      .fn()
      .mockRejectedValueOnce(new Error("network failure"))
      .mockRejectedValueOnce(new Error("network failure"));

    const result = await checkUrlReachability("https://example.com/fail", { attempts: 2 });
    expect(result.ok).toBe(false);
    expect(result.error).toBe("network failure");
    expect(global.fetch).toHaveBeenCalledTimes(2);
  });

  it("aborts fetch after the configured timeout", async () => {
    global.fetch = vi.fn().mockImplementation((_input: unknown, init?: RequestInit) => {
      return new Promise((_resolve, reject) => {
        const signal = init?.signal;
        if (signal?.aborted) {
          reject(new Error("AbortError"));
          return;
        }
        signal?.addEventListener("abort", () => {
          reject(new Error("AbortError"));
        });
      });
    });

    const result = await checkUrlReachability("https://example.com/slow", {
      timeoutMs: 50,
      attempts: 1,
    });
    expect(result.ok).toBe(false);
    expect(result.error).toMatch(/abort/i);
  });
});
