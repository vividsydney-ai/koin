#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const slug = "why-pay-later-is-bad";
const requiredSourceFields = ["synopsis", "synopsis_id", "relevance_blurb", "relevance_blurb_id"];
const hasText = (value) => typeof value === "string" && value.trim().length > 0;
const isHttpUrl = (value) => /^https?:\/\//i.test(String(value ?? ""));
const linkedSources = (rows) => rows.flatMap((row) => Array.isArray(row.sources) ? row.sources : row.sources ? [row.sources] : []);
const validOptionSet = (payload) => Array.isArray(payload?.options)
  && payload.options.length >= 2
  && payload.options.every(hasText)
  && (typeof payload.answer === "boolean" || payload.options.some((option) => option === payload.answer));
const completeSource = (source) => isHttpUrl(source?.url) && requiredSourceFields.every((field) => hasText(source?.[field]));

function validateReceipt(content, locale, failures) {
  const copy = content?.[locale];
  if (!copy || !hasText(copy.title) || !hasText(copy.icon) || !hasText(copy.disclosure) || !hasText(copy.altText)) {
    failures.push(`${locale}: title, icon, disclosure, or alt text is missing`);
    return;
  }
  const payload = copy.payload;
  if (!hasText(payload?.quoteTitle) || !hasText(payload?.price) || !Array.isArray(payload?.fields) || payload.fields.length !== 5) {
    failures.push(`${locale}: receipt needs a title, checkout price, and exactly five fields`);
    return;
  }
  if (payload.fields.some((field) => !hasText(field?.label) || !hasText(field?.value) || !hasText(field?.note))) {
    failures.push(`${locale}: every receipt field needs label, value, and note`);
  }
  const labels = payload.fields.map((field) => field.label.toLowerCase()).join(" ");
  if (!/(due|jatuh tempo)/.test(labels) || !/(total|pembayaran)/.test(labels) || !/(late|keterlambatan)/.test(labels)) {
    failures.push(`${locale}: receipt must expose due dates, total payable, and late-payment terms`);
  }
  if (!Array.isArray(payload.annotations) || payload.annotations.length !== 4 || payload.annotations.some((annotation) => !Number.isInteger(annotation?.number) || !hasText(annotation?.label) || !hasText(annotation?.detail))) {
    failures.push(`${locale}: receipt needs exactly four complete legend annotations`);
  }
}

function validateAppliedQuestion(variant, index, failures) {
  const en = variant.body;
  const id = variant.body_id;
  if (!en || !id || !hasText(en.question) || !hasText(id.question)) {
    failures.push(`visual_applied #${index}: paired question copy is incomplete`);
    return;
  }
  if (en.type !== id.type || !["multiple_choice", "true_false"].includes(en.type)) {
    failures.push(`visual_applied #${index}: paired question type is unsupported or mismatched`);
  }
  if (!validOptionSet(en) || !validOptionSet(id)) {
    failures.push(`visual_applied #${index}: a selectable option does not exactly match its stored answer`);
  }
  if (!hasText(en.explanation) || !hasText(id.explanation)) {
    failures.push(`visual_applied #${index}: paired explanations are incomplete`);
  }
}

async function main() {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
    throw new Error("Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env.local.");
  }
  const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
  const { data: lesson, error: lessonError } = await supabase
    .from("lessons")
    .select("id,slug,is_published")
    .eq("slug", slug)
    .maybeSingle();
  if (lessonError) throw lessonError;

  const failures = [];
  if (!lesson?.is_published) failures.push(`${slug}: published lesson not found`);
  const lessonId = lesson?.id;
  if (!lessonId) {
    console.table([{ slug, receipt: 0, visualSources: 0, primarySources: 0, applied: 0, recall: 0 }]);
    throw new Error(failures.join("\n"));
  }

  const [blocksResult, variantsResult, recallsResult, lessonSourcesResult] = await Promise.all([
    supabase.from("lesson_visual_blocks").select("id,placement,block_type,display_order,data_status,is_published,content").eq("lesson_id", lessonId).eq("is_published", true),
    supabase.from("content_variants").select("id,body,body_id").eq("lesson_id", lessonId).eq("variant_type", "question").eq("topic_tag", "visual_applied").eq("is_active", true),
    supabase.from("lesson_recall_questions").select("id,question_en,question_id,options_en,options_id,correct_option,explanation_en,explanation_id").eq("lesson_id", lessonId).eq("is_active", true),
    supabase.from("lesson_sources").select("lesson_id,sources(url,synopsis,synopsis_id,relevance_blurb,relevance_blurb_id)").eq("lesson_id", lessonId).eq("is_primary", true),
  ]);
  const queryError = blocksResult.error || variantsResult.error || recallsResult.error || lessonSourcesResult.error;
  if (queryError) throw queryError;

  const blocks = blocksResult.data ?? [];
  const receipts = blocks.filter((block) => block.placement === "concept" && block.display_order === 10);
  const block = receipts[0];
  const visualSourcesResult = block
    ? await supabase.from("lesson_visual_block_sources").select("visual_block_id,sources(url)").eq("visual_block_id", block.id)
    : { data: [], error: null };
  if (visualSourcesResult.error) throw visualSourcesResult.error;

  if (receipts.length !== 1) failures.push(`expected exactly one published concept receipt at display order 10, found ${receipts.length}`);
  if (block?.block_type !== "annotated_data") failures.push("concept receipt must use annotated_data block_type");
  if (block?.data_status !== "illustrative") failures.push("concept receipt must have illustrative data_status");
  if (block) {
    validateReceipt(block.content, "en", failures);
    validateReceipt(block.content, "id", failures);
  }

  const visualSources = linkedSources(visualSourcesResult.data ?? []);
  const primarySources = linkedSources(lessonSourcesResult.data ?? []);
  if (!visualSources.some((source) => isHttpUrl(source?.url))) failures.push("visual-source junction with an HTTP(S) source is missing");
  if (!primarySources.some(completeSource)) failures.push("complete primary lesson source is missing");

  const variants = variantsResult.data ?? [];
  if (variants.length !== 3) failures.push(`expected exactly 3 active visual_applied questions, found ${variants.length}`);
  variants.forEach((variant, index) => validateAppliedQuestion(variant, index + 1, failures));

  const recalls = recallsResult.data ?? [];
  if (recalls.length !== 1) {
    failures.push(`expected exactly 1 active recall question, found ${recalls.length}`);
  } else {
    const recall = recalls[0];
    if (!hasText(recall.question_en) || !hasText(recall.question_id) || !Array.isArray(recall.options_en) || !Array.isArray(recall.options_id)
      || recall.options_en.length < 2 || recall.options_id.length < 2 || !recall.options_en.every(hasText) || !recall.options_id.every(hasText)) {
      failures.push("recall must include paired bilingual question and selectable options");
    }
    if (!recall.options_en.includes(recall.correct_option)) failures.push("recall correct_option must be present in English options");
    if (!hasText(recall.explanation_en) || !hasText(recall.explanation_id)) failures.push("recall explanations are incomplete");
  }

  console.table([{
    slug,
    receipt: receipts.length,
    visualSources: visualSources.length,
    primarySources: primarySources.length,
    applied: variants.length,
    recall: recalls.length,
  }]);
  if (failures.length) {
    console.error("PayLater commitment audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }
  console.log(`PayLater commitment audit passed for ${slug}.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
