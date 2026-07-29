import type { Source } from "./client";
import { buildWikipediaSearchUrl } from "./wikipedia";

/** Keep Wikipedia links in the learner's locale when legacy rows have one shared URL. */
export function getLocalizedSourceUrl(
  source: Pick<Source, "url" | "title" | "localTitle">,
  locale: "en" | "id"
): string | null {
  if (!source.url) return null;
  if (!/(^|\.)wikipedia\.org\//i.test(source.url)) return source.url;

  const expectedHost = locale === "id" ? "id.wikipedia.org" : "en.wikipedia.org";
  if (source.url.includes(expectedHost)) return source.url;

  const title = locale === "id" ? source.localTitle ?? source.title : source.title;
  return buildWikipediaSearchUrl(title, locale);
}
