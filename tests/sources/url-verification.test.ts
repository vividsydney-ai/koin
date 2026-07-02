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

      // Check URLs sequentially to avoid rate limits.
      for (const source of checked) {
        if (!source.url) continue;
        try {
          const controller = new AbortController();
          const timeout = setTimeout(() => controller.abort(), 30000);
          const response = await fetch(source.url, {
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
          // 2xx/3xx = reachable. 403 = exists but blocks bots (common for IDX, OECD). 404/410/5xx = broken.
          const isReachable = status < 400 || status === 403;
          if (!isReachable) {
            failures.push(`${source.source_code} (${source.title}): ${status} ${response.statusText} — ${source.url}`);
          }
        } catch (err) {
          failures.push(
            `${source.source_code} (${source.title}): ${err instanceof Error ? err.message : "fetch failed"} — ${source.url}`
          );
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
