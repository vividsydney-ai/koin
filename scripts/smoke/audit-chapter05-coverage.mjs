#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const requiredSlugs = [
  "emergency-fund-101",
  "goal-setting-101",
  "building-financial-plan",
  "retirement-planning-bpjs-dplk-and-starting-early",
  "retirement-planning-start-early-compounding",
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
    .eq("topics.chapter", "Plan Your Money")
    .order("lesson_number");
  if (lessonsError) throw lessonsError;

  const lessonIds = (lessons ?? []).map((lesson) => lesson.id);
  const [{ data: blocks, error: blockError }, { data: variants, error: variantError }, { data: recalls, error: recallError }, { data: links, error: linkError }] = await Promise.all([
    supabase.from("lesson_visual_blocks").select("id, lesson_id, block_type, display_order, data_status, content, is_published").in("lesson_id", lessonIds).eq("is_published", true),
    supabase.from("content_variants").select("lesson_id, body, body_id").in("lesson_id", lessonIds).eq("variant_type", "question").eq("topic_tag", "visual_applied").eq("is_active", true),
    supabase.from("lesson_recall_questions").select("lesson_id, question_en, question_id, options_en, options_id, is_active").in("lesson_id", lessonIds).eq("is_active", true),
    supabase.from("lesson_sources").select("lesson_id, is_primary, sources(url, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)").in("lesson_id", lessonIds).eq("is_primary", true),
  ]);
  if (blockError) throw blockError;
  if (variantError) throw variantError;
  if (recallError) throw recallError;
  if (linkError) throw linkError;

  const blockIds = (blocks ?? []).map((block) => block.id);
  const { data: visualLinks, error: visualLinkError } = blockIds.length > 0
    ? await supabase
      .from("lesson_visual_block_sources")
      .select("visual_block_id, sources(url)")
      .in("visual_block_id", blockIds)
    : { data: [], error: null };
  if (visualLinkError) throw visualLinkError;

  const failures = [];
  if (lessons.length !== requiredSlugs.length) failures.push(`expected ${requiredSlugs.length} published Chapter 05 lessons, found ${lessons.length}`);
  for (const slug of requiredSlugs) {
    if (!(lessons ?? []).some((lesson) => lesson.slug === slug)) failures.push(`${slug}: missing published lesson`);
  }

  for (const lesson of lessons ?? []) {
    const lessonBlocks = (blocks ?? []).filter((block) => block.lesson_id === lesson.id && block.display_order === 10);
    const visualApplied = (variants ?? []).filter((variant) => variant.lesson_id === lesson.id);
    const recall = (recalls ?? []).filter((item) => item.lesson_id === lesson.id);
    const primary = (links ?? []).filter((link) => link.lesson_id === lesson.id).flatMap((link) => Array.isArray(link.sources) ? link.sources : link.sources ? [link.sources] : []);
    const content = lessonBlocks[0]?.content;
    const visualSources = (visualLinks ?? [])
      .filter((link) => link.visual_block_id === lessonBlocks[0]?.id)
      .flatMap((link) => Array.isArray(link.sources) ? link.sources : link.sources ? [link.sources] : []);
    const sourceComplete = primary.some((source) => (
      /^https?:\/\//i.test(String(source?.url ?? ""))
      && hasText(source?.synopsis) && hasText(source?.synopsis_id)
      && hasText(source?.relevance_blurb) && hasText(source?.relevance_blurb_id)
    ));

    if (lessonBlocks.length !== 1) failures.push(`${lesson.slug}: expected exactly one published concept visual, found ${lessonBlocks.length}`);
    if (lessonBlocks[0] && (!completeCopy(content, "en") || !completeCopy(content, "id"))) failures.push(`${lesson.slug}: bilingual visual copy or fallback metadata incomplete`);
    if (lessonBlocks[0] && !hasText(lessonBlocks[0].data_status)) failures.push(`${lesson.slug}: visual data status missing`);
    if (lessonBlocks[0] && !visualSources.some((source) => /^https?:\/\//i.test(String(source?.url ?? "")))) failures.push(`${lesson.slug}: visual source linkage missing`);
    if (visualApplied.length < 3) failures.push(`${lesson.slug}: expected at least 3 visual_applied questions, found ${visualApplied.length}`);
    for (const variant of visualApplied) {
      if (!variant.body || !variant.body_id || variant.body.type !== variant.body_id.type || !hasText(variant.body.question) || !hasText(variant.body_id.question)) failures.push(`${lesson.slug}: applied question locale payload mismatch`);
    }
    if (recall.length !== 1 || !hasText(recall[0]?.question_en) || !hasText(recall[0]?.question_id) || !Array.isArray(recall[0]?.options_en) || !Array.isArray(recall[0]?.options_id)) failures.push(`${lesson.slug}: recall prompt incomplete`);
    if (!sourceComplete) failures.push(`${lesson.slug}: primary source metadata incomplete`);
  }

  console.table((lessons ?? []).map((lesson) => ({
    lessonNumber: lesson.lesson_number,
    slug: lesson.slug,
    visuals: (blocks ?? []).filter((block) => block.lesson_id === lesson.id && block.display_order === 10).length,
    visualSources: (visualLinks ?? []).filter((link) => link.visual_block_id === (blocks ?? []).find((block) => block.lesson_id === lesson.id && block.display_order === 10)?.id).length,
    visualApplied: (variants ?? []).filter((variant) => variant.lesson_id === lesson.id).length,
    recalls: (recalls ?? []).filter((item) => item.lesson_id === lesson.id).length,
  })));
  if (failures.length > 0) {
    console.error("Chapter 05 coverage audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }
  console.log(`Chapter 05 coverage audit passed for ${lessons.length} lessons.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
