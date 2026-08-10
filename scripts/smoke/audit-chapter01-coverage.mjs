#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const requiredSlugs = [
  "value-and-purchasing-power",
  "inflation-101",
  "understanding-risk",
  "time-value-of-money",
  "net-worth-know-your-financial-position",
  "net-worth-know-your-financial-position-part-2",
];

const hasText = (value) => typeof value === "string" && value.trim().length > 0;

function completeCopy(content, locale) {
  const copy = content?.[locale];
  return Boolean(copy && hasText(copy.title) && hasText(copy.altText) && hasText(copy.icon) && copy.payload);
}

async function main() {
  const { data: lessons, error: lessonsError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number, topics!inner(chapter)")
    .eq("is_published", true)
    .eq("topics.chapter", "Money Basics")
    .order("lesson_number");
  if (lessonsError) throw lessonsError;

  const lessonIds = (lessons ?? []).map((lesson) => lesson.id);
  const [{ data: blocks, error: blockError }, { data: variants, error: variantError }, { data: recalls, error: recallError }, { data: links, error: linkError }] = await Promise.all([
    supabase.from("lesson_visual_blocks").select("id, lesson_id, data_status, content, display_order").in("lesson_id", lessonIds).eq("is_published", true),
    supabase.from("content_variants").select("lesson_id, body, body_id").in("lesson_id", lessonIds).eq("variant_type", "question").eq("topic_tag", "visual_applied").eq("is_active", true),
    supabase.from("lesson_recall_questions").select("lesson_id, question_en, question_id, options_en, options_id, is_active").in("lesson_id", lessonIds).eq("is_active", true),
    supabase.from("lesson_sources").select("lesson_id, is_primary, sources(url, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)").in("lesson_id", lessonIds).eq("is_primary", true),
  ]);
  if (blockError || variantError || recallError || linkError) throw blockError || variantError || recallError || linkError;

  const blockIds = (blocks ?? []).map((block) => block.id);
  const { data: visualLinks, error: visualLinkError } = await supabase
    .from("lesson_visual_block_sources")
    .select("visual_block_id, sources(url)")
    .in("visual_block_id", blockIds);
  if (visualLinkError) throw visualLinkError;

  const failures = [];
  if (lessons.length !== requiredSlugs.length) failures.push(`expected ${requiredSlugs.length} published Chapter 01 lessons, found ${lessons.length}`);

  for (const lesson of lessons ?? []) {
    const block = (blocks ?? []).find((item) => item.lesson_id === lesson.id && item.display_order === 10);
    const applied = (variants ?? []).filter((item) => item.lesson_id === lesson.id);
    const recall = (recalls ?? []).filter((item) => item.lesson_id === lesson.id);
    const primary = (links ?? []).filter((item) => item.lesson_id === lesson.id).flatMap((item) => Array.isArray(item.sources) ? item.sources : item.sources ? [item.sources] : []);
    const visualSources = (visualLinks ?? []).filter((item) => item.visual_block_id === block?.id).flatMap((item) => Array.isArray(item.sources) ? item.sources : item.sources ? [item.sources] : []);

    if (!block) failures.push(`${lesson.slug}: missing concept visual`);
    if (block && (!completeCopy(block.content, "en") || !completeCopy(block.content, "id") || !hasText(block.data_status))) failures.push(`${lesson.slug}: visual contract incomplete`);
    if (block && !visualSources.some((source) => /^https?:\/\//i.test(String(source?.url ?? "")))) failures.push(`${lesson.slug}: visual source link missing`);
    if (!primary.some((source) => /^https?:\/\//i.test(String(source?.url ?? "")) && hasText(source?.synopsis) && hasText(source?.synopsis_id) && hasText(source?.relevance_blurb) && hasText(source?.relevance_blurb_id))) failures.push(`${lesson.slug}: complete primary source missing`);
    if (applied.length < 3 || applied.some((item) => !item.body || !item.body_id || item.body.type !== item.body_id.type || !hasText(item.body.question) || !hasText(item.body_id.question))) failures.push(`${lesson.slug}: visual-applied practice incomplete`);
    if (recall.length !== 1 || !hasText(recall[0]?.question_en) || !hasText(recall[0]?.question_id) || !Array.isArray(recall[0]?.options_en) || !Array.isArray(recall[0]?.options_id)) failures.push(`${lesson.slug}: five-day recall incomplete`);
  }

  console.table((lessons ?? []).map((lesson) => ({
    lessonNumber: lesson.lesson_number,
    slug: lesson.slug,
    visual: Boolean((blocks ?? []).find((item) => item.lesson_id === lesson.id && item.display_order === 10)),
    applied: (variants ?? []).filter((item) => item.lesson_id === lesson.id).length,
    recall: (recalls ?? []).filter((item) => item.lesson_id === lesson.id).length,
  })));
  if (failures.length > 0) {
    console.error("Chapter 01 coverage audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }
  console.log(`Chapter 01 coverage audit passed for ${lessons.length} lessons.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
