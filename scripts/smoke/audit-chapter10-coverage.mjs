#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

async function main() {
  const { data: topic, error: topicError } = await supabase
    .from("topics")
    .select("id")
    .eq("chapter", "Reading Trading Charts")
    .single();
  if (topicError) throw topicError;

  const { data: lessons, error: lessonError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number")
    .eq("is_published", true)
    .eq("topic_id", topic.id)
    .order("lesson_number");
  if (lessonError) throw lessonError;

  const lessonIds = lessons.map((l) => l.id);

  const [{ data: blocks }, { data: questions }, { data: recalls }, { data: links }] = await Promise.all([
    supabase.from("lesson_visual_blocks").select("lesson_id, block_type, is_published").in("lesson_id", lessonIds).eq("is_published", true),
    supabase.from("content_variants").select("lesson_id, topic_tag, is_active").in("lesson_id", lessonIds).eq("variant_type", "question").eq("topic_tag", "visual_applied").eq("is_active", true),
    supabase.from("lesson_recall_questions").select("lesson_id, is_active").in("lesson_id", lessonIds).eq("is_active", true),
    supabase.from("lesson_sources").select("lesson_id, source_id, is_primary, sources(source_code, url, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)").in("lesson_id", lessonIds).eq("is_primary", true),
  ]);

  const rows = lessons.map((lesson) => {
    const blockCount = (blocks ?? []).filter((b) => b.lesson_id === lesson.id).length;
    const questionCount = (questions ?? []).filter((q) => q.lesson_id === lesson.id).length;
    const recallCount = (recalls ?? []).filter((r) => r.lesson_id === lesson.id).length;
    const source = (links ?? []).find((l) => l.lesson_id === lesson.id)?.sources;
    const sourceOk = source && /^https?:\/\//i.test(source.url) && source.synopsis && source.synopsis_id && source.relevance_blurb && source.relevance_blurb_id;
    return {
      lessonNumber: lesson.lesson_number,
      slug: lesson.slug,
      blocks: blockCount,
      visualApplied: questionCount,
      recall: recallCount,
      sourceOk: sourceOk ? "yes" : "no",
    };
  });

  console.table(rows);

  const failures = [];
  rows.forEach((row) => {
    if (row.blocks < 1) failures.push(`${row.slug}: missing published visual block`);
    if (row.visualApplied < 3) failures.push(`${row.slug}: expected 3 visual_applied questions, found ${row.visualApplied}`);
    if (row.recall < 1) failures.push(`${row.slug}: missing active recall question`);
    if (row.sourceOk !== "yes") failures.push(`${row.slug}: primary source summary incomplete`);
  });

  if (failures.length > 0) {
    console.error("Chapter 10 coverage audit failed:");
    failures.forEach((f) => console.error(`- ${f}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Chapter 10 coverage audit passed for ${lessons.length} published lessons.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
