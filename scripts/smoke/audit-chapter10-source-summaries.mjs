#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

function hasText(value) {
  return typeof value === "string" && value.trim().length > 0;
}

function hasSynopsis(source, locale) {
  if (locale === "id") return hasText(source.synopsis_id);
  return hasText(source.synopsis);
}

function hasRelevance(source, locale) {
  if (locale === "id") return hasText(source.relevance_blurb_id);
  return hasText(source.relevance_blurb);
}

async function main() {
  const { data: lessons, error: lessonError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number, topics!inner(chapter)")
    .eq("is_published", true)
    .eq("topics.chapter", "Reading Trading Charts")
    .order("lesson_number");
  if (lessonError) throw lessonError;

  const { data: links, error: linkError } = await supabase
    .from("lesson_sources")
    .select("lesson_id, source_id, citation_label, is_primary, relevance_type, sources(source_code, title, url, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)")
    .in("lesson_id", lessons.map((lesson) => lesson.id));
  if (linkError) throw linkError;

  const failures = [];
  const rows = lessons.map((lesson) => {
    const lessonLinks = (links ?? []).filter((link) => link.lesson_id === lesson.id);
    if (lessonLinks.length === 0) {
      failures.push(`${lesson.slug}: no lesson_sources link`);
    }
    const missing = lessonLinks.flatMap((link) => {
      const source = link.sources;
      if (!source) return [`${lesson.slug}/${link.source_id}: missing source row`];
      const errors = [];
      if (!/^https?:\/\//i.test(String(source.url ?? ""))) errors.push("missing read-source URL");
      if (!hasSynopsis(source, "en")) errors.push("missing English synopsis");
      if (!hasSynopsis(source, "id")) errors.push("missing Indonesian synopsis");
      if (!hasRelevance(source, "en")) errors.push("missing English relevance");
      if (!hasRelevance(source, "id")) errors.push("missing Indonesian relevance");
      return errors.length > 0 ? [`${lesson.slug}/${source.source_code}: ${errors.join(", ")}`] : [];
    });
    failures.push(...missing);
    return {
      lessonNumber: lesson.lesson_number,
      slug: lesson.slug,
      sourceCount: lessonLinks.length,
      completeSourceCount: lessonLinks.length - missing.length,
    };
  });

  console.table(rows);
  if (failures.length > 0) {
    console.error("Chapter 10 source-summary audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Chapter 10 source-summary audit passed for ${lessons.length} published lessons and ${(links ?? []).length} source links.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
