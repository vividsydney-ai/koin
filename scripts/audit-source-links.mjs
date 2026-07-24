#!/usr/bin/env node
/**
 * Source-link auditor for Koinaku.
 * Reads published lessons + their linked sources from production Supabase,
 * checks each source URL for HTTP reachability, and writes a CSV report.
 *
 * Run from the repo root:
 *   node scripts/audit-source-links.mjs
 *
 * Environment variables (loaded via dotenv from .env.local):
 *   NEXT_PUBLIC_SUPABASE_URL
 *   NEXT_PUBLIC_SUPABASE_ANON_KEY
 */
import "dotenv/config";
import { createClient } from "@supabase/supabase-js";
import fs from "node:fs";
import path from "node:path";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error(
    "Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY"
  );
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

const DEFAULT_TIMEOUT_MS = 15000;
const DEFAULT_ATTEMPTS = 2;

async function checkUrlReachability(url, options = {}) {
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
      // 403 is treated as reachable because many Indonesian regulator sites block bots.
      if (status < 400 || status === 403) {
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

    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  return { ok: false, error: "unknown" };
}

function encodeTitle(title) {
  return encodeURIComponent(title.trim().replace(/\s+/g, "_"));
}

function buildWikipediaSearchUrl(title, locale = "en") {
  const domain = locale === "id" ? "id.wikipedia.org" : "en.wikipedia.org";
  return `https://${domain}/wiki/${encodeTitle(title)}`;
}

function csvEscape(value) {
  const str = value == null ? "" : String(value);
  if (str.includes(",") || str.includes('"') || str.includes("\n") || str.includes("\r")) {
    return `"${str.replace(/"/g, '""')}"`;
  }
  return str;
}

async function main() {
  console.log("Fetching published lessons and linked sources...");

  const { data: lessons, error: lessonsError } = await supabase
    .from("lessons")
    .select("id, slug, title")
    .eq("is_published", true)
    .order("slug", { ascending: true });

  if (lessonsError) {
    console.error("Failed to fetch lessons:", lessonsError.message);
    process.exit(1);
  }

  const lessonIds = lessons.map((l) => l.id);

  const { data: links, error: linksError } = await supabase
    .from("lesson_sources")
    .select("lesson_id, source_id, citation_label, display_order")
    .in("lesson_id", lessonIds);

  if (linksError) {
    console.error("Failed to fetch lesson_sources:", linksError.message);
    process.exit(1);
  }

  const sourceIds = [...new Set(links.map((l) => l.source_id))];

  const { data: sources, error: sourcesError } = await supabase
    .from("sources")
    .select("id, source_code, title, organization, url")
    .in("id", sourceIds);

  if (sourcesError) {
    console.error("Failed to fetch sources:", sourcesError.message);
    process.exit(1);
  }

  const sourceById = new Map(sources.map((s) => [s.id, s]));
  const lessonById = new Map(lessons.map((l) => [l.id, l]));

  // Build rows preserving lesson order and source display order.
  const rows = [];
  for (const lesson of lessons) {
    const lessonLinks = links
      .filter((l) => l.lesson_id === lesson.id)
      .sort((a, b) => (a.display_order ?? 0) - (b.display_order ?? 0));

    for (const link of lessonLinks) {
      const source = sourceById.get(link.source_id);
      if (!source) continue;
      rows.push({
        lesson,
        source,
        citationLabel: link.citation_label,
      });
    }
  }

  console.log(`Checking ${rows.length} source URLs...`);

  const results = [];
  for (let i = 0; i < rows.length; i++) {
    const { lesson, source } = rows[i];
    const url = source.url;

    process.stdout.write(`\r${i + 1}/${rows.length} ${source.source_code ?? ""}`.slice(0, 80));

    let result;
    if (!url) {
      result = { ok: false, error: "no url" };
    } else {
      result = await checkUrlReachability(url);
    }

    const urlStatus = result.ok ? "reachable" : "unreachable";
    const httpStatus = result.status ?? result.error ?? "";
    const wikiUrl = buildWikipediaSearchUrl(source.title, "en");

    results.push({
      lesson_slug: lesson.slug,
      lesson_title: lesson.title,
      source_code: source.source_code,
      source_title: source.title,
      source_organization: source.organization,
      source_url: url ?? "",
      url_status: urlStatus,
      http_status: httpStatus,
      wikipedia_fallback_url: wikiUrl,
    });
  }

  process.stdout.write("\n");

  const headers = [
    "lesson_slug",
    "lesson_title",
    "source_code",
    "source_title",
    "source_organization",
    "source_url",
    "url_status",
    "http_status",
    "wikipedia_fallback_url",
  ];

  const csvLines = [
    headers.join(","),
    ...results.map((r) =>
      headers.map((h) => csvEscape(r[h])).join(",")
    ),
  ];

  const outputDir = path.resolve("/Users/vividm4/Documents/Projects/Side-Gigs/Koin/_outputs");
  const outputPath = path.join(outputDir, "source_links_2026-07-24.csv");
  fs.writeFileSync(outputPath, csvLines.join("\n") + "\n", "utf-8");

  const total = results.length;
  const unreachable = results.filter((r) => r.url_status === "unreachable");
  const ojkUnreachable = unreachable.filter(
    (r) =>
      r.source_organization?.toLowerCase().includes("ojk") ||
      r.source_url?.toLowerCase().includes("ojk.go.id")
  );

  console.log("\n=== Source Link Audit Report ===");
  console.log(`CSV written to: ${outputPath}`);
  console.log(`Total sources checked: ${total}`);
  console.log(`Unreachable sources: ${unreachable.length}`);
  console.log(`Unreachable OJK sources: ${ojkUnreachable.length}`);

  if (ojkUnreachable.length > 0) {
    console.log("\n--- Broken OJK sources ---");
    for (const r of ojkUnreachable) {
      console.log(
        `- ${r.source_code} | ${r.lesson_slug} | ${r.http_status} | ${r.source_url}`
      );
    }
  }

  if (unreachable.length > 0) {
    console.log("\n--- All broken sources ---");
    for (const r of unreachable) {
      console.log(
        `- ${r.source_code} (${r.source_organization}) | ${r.lesson_slug} | ${r.http_status} | ${r.source_url}`
      );
    }
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
