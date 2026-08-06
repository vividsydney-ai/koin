#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const VALID_TYPES = new Set([
  "multiple_choice",
  "true_false",
  "fill_blank",
  "word_bank",
  "ordering",
  "matching",
  "slider",
  "swipe_yes_no",
  "case_study",
  "chart_interpretation",
  "scenario",
  "comparison",
  "sentence_completion",
  "image_interpretation",
  "decision_tree",
  "calculation",
  "spot_mistake",
  "definition_match",
  "categorization",
]);

const EXPECTED_EXAMPLE_VISUALS = new Set([
  "etfs-investing-with-one-click-part-2",
  "bonds-sbn-safe-investing-with-the-government-part-2",
  "tax-basics-npwp-pph-21-and-filing-taxes-part-2",
  "brokerage-account-setup-opening-your-rdn-part-2",
]);

function isValidEnglishQuestion(body) {
  return Boolean(
    body &&
      typeof body === "object" &&
      typeof body.type === "string" &&
      VALID_TYPES.has(body.type) &&
      typeof body.question === "string" &&
      body.question.trim() &&
      typeof body.explanation === "string" &&
      body.explanation.trim(),
  );
}

async function main() {
  const { data: lessons, error: lessonError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number, topics!inner(chapter)")
    .eq("is_published", true)
    .eq("topics.chapter", "Investing in Indonesia")
    .order("lesson_number");
  if (lessonError) throw lessonError;

  const lessonIds = lessons.map((lesson) => lesson.id);
  const { data: variants, error: variantError } = await supabase
    .from("content_variants")
    .select("lesson_id, variant_type, topic_tag, body, body_id, is_active")
    .in("lesson_id", lessonIds)
    .eq("variant_type", "question")
    .eq("is_active", true);
  if (variantError) throw variantError;

  const { data: visualBlocks, error: visualError } = await supabase
    .from("lesson_visual_blocks")
    .select("lesson_id, placement, is_published")
    .in("lesson_id", lessonIds)
    .eq("is_published", true);
  if (visualError) throw visualError;

  const failures = [];
  const rows = lessons.map((lesson) => {
    const active = (variants ?? []).filter((variant) => variant.lesson_id === lesson.id);
    const validEnglish = active.filter((variant) => isValidEnglishQuestion(variant.body));
    const bilingual = active.filter((variant) => variant.body_id && typeof variant.body_id === "object");
    const applied = validEnglish.filter((variant) => variant.topic_tag === "visual_applied");
    const weakAppliedMultipleChoice = applied.filter(
      (variant) => variant.body.type === "multiple_choice" && (!Array.isArray(variant.body.options) || variant.body.options.length < 4),
    );
    const exampleVisuals = (visualBlocks ?? []).filter(
      (block) => block.lesson_id === lesson.id && block.placement === "example",
    );
    const row = {
      lessonNumber: lesson.lesson_number,
      slug: lesson.slug,
      activeQuestions: active.length,
      validEnglishQuestions: validEnglish.length,
      bilingualQuestions: bilingual.length,
      visualAppliedQuestions: applied.length,
      weakAppliedMultipleChoice: weakAppliedMultipleChoice.length,
      exampleVisuals: exampleVisuals.length,
    };
    if (validEnglish.length < 2) failures.push(`${lesson.slug}: needs at least 2 valid English questions; found ${validEnglish.length}`);
    if (applied.length < 3) failures.push(`${lesson.slug}: needs at least 3 visual-applied English questions; found ${applied.length}`);
    if (weakAppliedMultipleChoice.length > 0) failures.push(`${lesson.slug}: visual-applied multiple-choice question has fewer than 4 options`);
    if (EXPECTED_EXAMPLE_VISUALS.has(lesson.slug) && exampleVisuals.length === 0) failures.push(`${lesson.slug}: expected an example-step visual`);
    if (bilingual.length < validEnglish.length) failures.push(`${lesson.slug}: ${validEnglish.length - bilingual.length} English question(s) have no Indonesian payload`);
    return row;
  });

  console.table(rows);
  if (failures.length > 0) {
    console.error("Chapter 08 English audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Chapter 08 English audit passed for ${lessons.length} published lessons.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
