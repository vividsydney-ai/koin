#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

function normalizeAnswer(value) {
  return String(value)
    .toLowerCase()
    .replace(/[.,!?;:]/g, "")
    .trim();
}

function checkPayload(payload, label) {
  if (!payload || typeof payload !== "object") return [];
  const body = payload;
  const failures = [];
  const type = typeof body.type === "string" ? body.type : "";

  if (["multiple_choice", "scenario", "comparison", "sentence_completion", "image_interpretation", "decision_tree"].includes(type)) {
    const options = Array.isArray(body.options) ? body.options.filter((option) => typeof option === "string") : [];
    const answer = typeof body.answer === "string" ? body.answer : "";
    if (!options.some((option) => normalizeAnswer(option) === normalizeAnswer(answer))) {
      failures.push(`${label}: ${type} answer is not one of its options; answer=${JSON.stringify(answer)} options=${JSON.stringify(options)}`);
    }
  }

  if (type === "case_study" && body.followUp && typeof body.followUp === "object") {
    const options = Array.isArray(body.followUp.options) ? body.followUp.options.filter((option) => typeof option === "string") : [];
    const answer = typeof body.followUp.answer === "string" ? body.followUp.answer : "";
    if (!options.some((option) => normalizeAnswer(option) === normalizeAnswer(answer))) {
      failures.push(`${label}: case_study followUp answer is not one of its options; answer=${JSON.stringify(answer)} options=${JSON.stringify(options)}`);
    }
  }

  if (type === "chart_interpretation") {
    const ids = Array.isArray(body.options)
      ? body.options.map((option) => option && typeof option.id === "string" ? option.id : null).filter(Boolean)
      : [];
    if (typeof body.answer !== "string" || !ids.includes(body.answer)) {
      failures.push(`${label}: chart_interpretation answer id is not one of its option ids`);
    }
  }

  if (["word_bank", "ordering"].includes(type)) {
    const options = new Set(Array.isArray(body.options) ? body.options : []);
    const answers = Array.isArray(body.answer) ? body.answer : [];
    const missing = answers.filter((answer) => !options.has(answer));
    if (missing.length > 0) failures.push(`${label}: ${type} answer contains values absent from options: ${JSON.stringify(missing)}`);
  }

  return failures;
}

async function main() {
  const { data: lessons, error: lessonError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number")
    .eq("is_published", true)
    .order("lesson_number");
  if (lessonError) throw lessonError;

  const lessonIds = (lessons ?? []).map((lesson) => lesson.id);
  const { data: variants, error: variantError } = await supabase
    .from("content_variants")
    .select("id, lesson_id, variant_type, body, body_id, is_active")
    .in("lesson_id", lessonIds)
    .eq("variant_type", "question")
    .eq("is_active", true);
  if (variantError) throw variantError;

  const slugById = new Map((lessons ?? []).map((lesson) => [lesson.id, lesson.slug]));
  const failures = [];
  let payloadsAudited = 0;
  for (const variant of variants ?? []) {
    for (const [locale, payload] of [["en", variant.body], ["id", variant.body_id]]) {
      payloadsAudited += 1;
      failures.push(...checkPayload(payload, `${slugById.get(variant.lesson_id) ?? variant.lesson_id}/${variant.id}/${locale}`));
    }
  }

  console.log(JSON.stringify({
    publishedLessons: lessons?.length ?? 0,
    activeQuestionVariants: variants?.length ?? 0,
    payloadsAudited,
    failures: failures.length,
  }, null, 2));
  if (failures.length > 0) {
    console.error("Question answer-integrity audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }
  console.log("Question answer-integrity audit passed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
