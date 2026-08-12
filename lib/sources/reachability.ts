/**
 * Lightweight URL reachability check used at display time for source cards.
 * Mirrors the logic in tests/sources/url-verification.test.ts so the UI behaves
 * consistently with the verification suite.
 */
export interface ReachabilityResult {
  ok: boolean;
  status?: number;
  statusText?: string;
  error?: string;
}

const DEFAULT_TIMEOUT_MS = 15000;
const DEFAULT_ATTEMPTS = 2;

export async function checkUrlReachability(
  url: string,
  options: { timeoutMs?: number; attempts?: number } = {}
): Promise<ReachabilityResult> {
  const { timeoutMs = DEFAULT_TIMEOUT_MS, attempts = DEFAULT_ATTEMPTS } = options;

  for (let attempt = 1; attempt <= attempts; attempt++) {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), timeoutMs);

    try {
      const response = await fetch(url, {
        method: "HEAD",
        redirect: "follow",
        signal: controller.signal,
        headers: {
          "User-Agent":
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
        },
      });
      clearTimeout(timeout);

      const status = response.status;
      // A forbidden response is not a usable source link. Editorial trust does
      // not change whether a learner can open the source.
      if (status < 400) {
        return { ok: true, status };
      }
      if (attempt === attempts) {
        return { ok: false, status, statusText: response.statusText };
      }
    } catch (err) {
      clearTimeout(timeout);
      if (attempt === attempts) {
        return {
          ok: false,
          error: err instanceof Error ? err.message : "fetch failed",
        };
      }
    }

    // Brief backoff before retry.
    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  return { ok: false, error: "unknown" };
}
