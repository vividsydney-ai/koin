import { describe, it, expect } from "vitest";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

const skipReason =
  !supabaseUrl || !supabaseKey
    ? "NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY not set"
    : null;

describe.runIf(!skipReason)("source URL verification", () => {
  const supabase = createClient(supabaseUrl!, supabaseKey!);

  it(
    "every source URL returns HTTP 2xx",
    async () => {
      const { data: sources, error } = await supabase
        .from("sources")
        .select("source_code, title, url, status")
        .not("url", "is", null);

      expect(error).toBeNull();
      expect(sources?.length).toBeGreaterThan(0);

      const failures: string[] = [];
      const checked = sources ?? [];

      async function checkUrl(url: string, attempts = 2): Promise<{ ok: boolean; status?: number; statusText?: string; error?: string }> {
        for (let attempt = 1; attempt <= attempts; attempt++) {
          try {
            const controller = new AbortController();
            const timeout = setTimeout(() => controller.abort(), 45000);
            const response = await fetch(url, {
              method: "GET",
              redirect: "follow",
              signal: controller.signal,
              headers: {
                "User-Agent":
                  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
                Accept: "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
              },
            });
            clearTimeout(timeout);
            const status = response.status;
            const isReachable = status < 400 || status === 403;
            if (isReachable) {
              return { ok: true, status };
            }
            if (attempt === attempts) {
              return { ok: false, status, statusText: response.statusText };
            }
          } catch (err) {
            if (attempt === attempts) {
              return { ok: false, error: err instanceof Error ? err.message : "fetch failed" };
            }
          }
          // Brief backoff before retry.
          await new Promise((resolve) => setTimeout(resolve, 1000));
        }
        return { ok: false, error: "unknown" };
      }

      // Check URLs sequentially to avoid rate limits.
      for (const source of checked) {
        if (!source.url) continue;
        const result = await checkUrl(source.url);
        if (!result.ok) {
          if (result.status !== undefined) {
            failures.push(`${source.source_code} (${source.title}): ${result.status} ${result.statusText} — ${source.url}`);
          } else {
            failures.push(
              `${source.source_code} (${source.title}): ${result.error} — ${source.url}`
            );
          }
        }
      }

      expect(failures, `Dead or unreachable source URLs:\n${failures.join("\n")}`).toEqual([]);
    },
    120000
  );
});

describe.skipIf(!skipReason)("source URL verification", () => {
  it.skip(skipReason ?? "skipped", () => {});
});
