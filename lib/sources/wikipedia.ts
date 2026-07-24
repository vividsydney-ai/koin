export interface WikipediaSummary {
  title: string;
  extract: string;
  url: string;
  thumbnailUrl?: string;
}

function encodeTitle(title: string): string {
  return encodeURIComponent(title.trim().replace(/\s+/g, "_"));
}

export function buildWikipediaSearchUrl(title: string, locale: "en" | "id" = "en"): string {
  const domain = locale === "id" ? "id.wikipedia.org" : "en.wikipedia.org";
  return `https://${domain}/wiki/${encodeTitle(title)}`;
}

/**
 * Fetch a short Wikipedia summary for a source topic.
 * Falls back to a plain search link if the API call fails.
 */
export async function fetchWikipediaSummary(
  title: string,
  locale: "en" | "id" = "en"
): Promise<WikipediaSummary> {
  const domain = locale === "id" ? "id.wikipedia.org" : "en.wikipedia.org";
  const url = `https://${domain}/api/rest_v1/page/summary/${encodeTitle(title)}`;

  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 8000);
    const response = await fetch(url, {
      signal: controller.signal,
      headers: { Accept: "application/json" },
    });
    clearTimeout(timeout);

    if (!response.ok) {
      throw new Error(`Wikipedia API returned ${response.status}`);
    }

    const data = (await response.json()) as {
      title?: string;
      extract?: string;
      content_urls?: { desktop?: { page?: string } };
      thumbnail?: { source?: string };
    };

    return {
      title: data.title ?? title,
      extract: data.extract ?? "",
      url: data.content_urls?.desktop?.page ?? buildWikipediaSearchUrl(title, locale),
      thumbnailUrl: data.thumbnail?.source,
    };
  } catch {
    return {
      title,
      extract: "",
      url: buildWikipediaSearchUrl(title, locale),
    };
  }
}
