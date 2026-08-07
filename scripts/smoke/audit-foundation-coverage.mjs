#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const requiredSlugs = [
  "fz-what-is-money", "fz-inflation", "fz-interest", "fz-income-vs-wealth",
  "fz-assets-vs-liabilities", "fz-risk", "fz-return", "fz-saving-vs-investing",
  "fz-emergency-fund", "fz-needs-vs-wants", "fz-debt", "fz-scam-red-flags",
];
const mascotExclusions = new Set(["fz-risk", "fz-debt", "fz-scam-red-flags"]);

function hasText(value) {
  return typeof value === "string" && value.trim().length > 0;
}

async function main() {
  const { data: lessons, error: lessonsError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number")
    .in("slug", requiredSlugs)
    .eq("is_published", true)
    .order("lesson_number");
  if (lessonsError) throw lessonsError;

  const lessonIds = lessons.map((lesson) => lesson.id);
  const [{ data: blocks, error: blockError }, { data: variants, error: variantError }, { data: recalls, error: recallError }, { data: links, error: linkError }] = await Promise.all([
    supabase.from("lesson_visual_blocks").select("lesson_id, content, is_published").in("lesson_id", lessonIds).eq("is_published", true),
    supabase.from("content_variants").select("lesson_id").in("lesson_id", lessonIds).eq("variant_type", "question").eq("topic_tag", "visual_applied").eq("is_active", true),
    supabase.from("lesson_recall_questions").select("lesson_id, is_active").in("lesson_id", lessonIds).eq("is_active", true),
    supabase.from("lesson_sources").select("lesson_id, is_primary, sources(url, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)").in("lesson_id", lessonIds).eq("is_primary", true),
  ]);
  if (blockError) throw blockError;
  if (variantError) throw variantError;
  if (recallError) throw recallError;
  if (linkError) throw linkError;

  const failures = [];
  if (lessons.length !== requiredSlugs.length) failures.push(`expected ${requiredSlugs.length} published Foundation lessons, found ${lessons.length}`);

  const mascotBlocks = (blocks ?? []).filter((block) => {
    const content = block.content;
    return content && typeof content === "object" && "en" in content && content.en?.mascot;
  });
  if (mascotBlocks.length !== 6) failures.push(`expected 6 mascot moments, found ${mascotBlocks.length}`);

  for (const lesson of lessons) {
    const lessonBlocks = (blocks ?? []).filter((block) => block.lesson_id === lesson.id);
    const visualApplied = (variants ?? []).filter((variant) => variant.lesson_id === lesson.id).length;
    const recall = (recalls ?? []).filter((item) => item.lesson_id === lesson.id).length;
    const source = (links ?? []).find((link) => link.lesson_id === lesson.id)?.sources;
    const content = lessonBlocks[0]?.content;
    const mascot = content && typeof content === "object" && "en" in content ? content.en?.mascot : null;
    const sourceComplete = source
      && /^https?:\/\//i.test(String(source.url ?? ""))
      && hasText(source.synopsis) && hasText(source.synopsis_id)
      && hasText(source.relevance_blurb) && hasText(source.relevance_blurb_id);

    if (lessonBlocks.length < 1) failures.push(`${lesson.slug}: missing published visual block`);
    if (visualApplied < 3) failures.push(`${lesson.slug}: expected at least 3 visual_applied questions, found ${visualApplied}`);
    if (recall < 1) failures.push(`${lesson.slug}: missing active recall question`);
    if (!sourceComplete) failures.push(`${lesson.slug}: primary source metadata incomplete`);
    if (mascotExclusions.has(lesson.slug) && mascot) failures.push(`${lesson.slug}: mascot is excluded for this sensitive lesson`);
  }

  if (failures.length > 0) {
    console.error("Foundation coverage audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Foundation coverage audit passed for ${lessons.length} lessons, ${(blocks ?? []).length} visuals, and ${mascotBlocks.length} mascot moments.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
