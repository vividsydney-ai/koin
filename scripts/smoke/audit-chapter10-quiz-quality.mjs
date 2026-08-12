#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const legacyPrompts = new Set([
  "Which price tells you where the period ended?",
  "Which candle closes above its open?",
  "A hammer has a small body and a long wick in which direction?",
  "What does the upper wick show?",
]);

async function main() {
  const { data: topic, error: topicError } = await supabase
    .from("topics")
    .select("id")
    .eq("chapter", "Reading Trading Charts")
    .single();
  if (topicError) throw topicError;

  const { data: lessons, error: lessonError } = await supabase
    .from("lessons")
    .select("id, slug")
    .eq("topic_id", topic.id)
    .eq("is_published", true)
    .order("lesson_number");
  if (lessonError) throw lessonError;

  const { data: variants, error: variantError } = await supabase
    .from("content_variants")
    .select("lesson_id, body, body_id")
    .in("lesson_id", (lessons ?? []).map((lesson) => lesson.id))
    .eq("variant_type", "question")
    .eq("topic_tag", "visual_applied")
    .eq("is_active", true);
  if (variantError) throw variantError;

  const failures = [];
  if ((lessons ?? []).length !== 8) failures.push(`expected 8 lessons, found ${(lessons ?? []).length}`);
  if ((variants ?? []).length !== 24) failures.push(`expected 24 active variants, found ${(variants ?? []).length}`);

  for (const variant of variants ?? []) {
    for (const [locale, body] of [["en", variant.body], ["id", variant.body_id]]) {
      const options = Array.isArray(body?.options) ? body.options : [];
      const answer = String(body?.answer ?? "");
      if (body?.type !== "multiple_choice") failures.push(`${locale}: non-multiple-choice payload`);
      if (options.length !== 4 || new Set(options).size !== 4) failures.push(`${locale}: expected four unique options`);
      if (!options.includes(answer)) failures.push(`${locale}: answer is not a visible option`);
      if (body?.difficulty !== "intermediate") failures.push(`${locale}: difficulty is not intermediate`);
      if (!body?.chart) failures.push(`${locale}: chart payload missing`);
      if (locale === "en" && legacyPrompts.has(body?.question)) failures.push(`legacy giveaway prompt remains: ${body.question}`);
    }
  }

  if (failures.length) {
    console.error("Chapter 10 quiz-quality audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Chapter 10 quiz-quality audit passed for ${(lessons ?? []).length} lessons and ${(variants ?? []).length} bilingual variants.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
