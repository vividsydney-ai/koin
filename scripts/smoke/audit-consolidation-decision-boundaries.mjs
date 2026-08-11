#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const slug = "debt-consolidation-when-and-how-to-combine-debts";
const sourceFields = ["synopsis", "synopsis_id", "relevance_blurb", "relevance_blurb_id"];
const hasText = (value) => typeof value === "string" && value.trim().length > 0;
const isHttpUrl = (value) => /^https?:\/\//i.test(String(value ?? ""));
const sourcesFrom = (rows) => rows.flatMap((row) => Array.isArray(row.sources) ? row.sources : row.sources ? [row.sources] : []);
const validOptions = (payload, locale) => {
  if (!Array.isArray(payload?.options) || payload.options.length < 2 || !payload.options.every(hasText)) return false;
  if (payload.type === "true_false") {
    const expected = locale === "id" ? ["Benar", "Salah"] : ["True", "False"];
    return typeof payload.answer === "boolean" && payload.options.length === 2 && payload.options.every((option, index) => option === expected[index]);
  }
  return payload.options.some((option) => option === payload.answer);
};

function validateBoundary(content, locale, failures) {
  const copy = content?.[locale];
  if (!copy || !hasText(copy.title) || !hasText(copy.icon) || !hasText(copy.disclosure) || !hasText(copy.altText)) {
    failures.push(`${locale}: title, icon, disclosure, or alt text is missing`);
    return;
  }
  const steps = copy.payload?.steps;
  if (!Array.isArray(steps) || steps.length !== 4 || steps.some((step) => !hasText(step?.title) || !hasText(step?.description))) {
    failures.push(`${locale}: boundary needs exactly four complete steps`);
    return;
  }
  const text = steps.map((step) => `${step.title} ${step.description}`).join(" ").toLowerCase();
  const expected = locale === "id"
    ? ["total pembayaran", "biaya", "tenor", "kelayakan", "kebutuhan pokok", "utang baru"]
    : ["total repayment", "fees", "term", "eligibility", "essentials", "new borrowing"];
  if (expected.some((term) => !text.includes(term))) failures.push(`${locale}: boundary must expose total cost, fees, term, eligibility, essentials, and no-new-borrowing`);
}

function validateQuestion(variant, index, failures) {
  const en = variant.body;
  const id = variant.body_id;
  if (!en || !id || en.type !== id.type || !hasText(en.question) || !hasText(id.question)) failures.push(`visual_applied #${index}: paired type or question copy is incomplete`);
  else {
    if (!validOptions(en, "en") || !validOptions(id, "id")) failures.push(`visual_applied #${index}: visible options do not map to stored answer`);
    if (!hasText(en.explanation) || !hasText(id.explanation)) failures.push(`visual_applied #${index}: bilingual explanation is incomplete`);
  }
}

async function main() {
  if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) throw new Error("Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env.local.");
  const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);
  const { data: lesson, error: lessonError } = await supabase.from("lessons").select("id,slug,is_published,concept_body,concept_body_id").eq("slug", slug).maybeSingle();
  if (lessonError) throw lessonError;
  const failures = [];
  if (!lesson?.is_published) failures.push(`${slug}: published lesson not found`);
  if (!lesson?.id) throw new Error(failures.join("\n"));
  if (!hasText(lesson.concept_body) || !hasText(lesson.concept_body_id) || /0\.88|BCA, Mandiri|balance transfer/i.test(`${lesson.concept_body} ${lesson.concept_body_id}`)) failures.push("lesson prose is missing, untranslated, or retains unscoped provider/rate claims");
  const [blocksResult, variantsResult, recallsResult, primarySourcesResult] = await Promise.all([
    supabase.from("lesson_visual_blocks").select("id,placement,block_type,display_order,data_status,is_published,content").eq("lesson_id", lesson.id).eq("is_published", true),
    supabase.from("content_variants").select("id,body,body_id").eq("lesson_id", lesson.id).eq("variant_type", "question").eq("topic_tag", "visual_applied").eq("is_active", true),
    supabase.from("lesson_recall_questions").select("question_en,question_id,options_en,options_id,correct_option,explanation_en,explanation_id").eq("lesson_id", lesson.id).eq("is_active", true),
    supabase.from("lesson_sources").select("sources(url,synopsis,synopsis_id,relevance_blurb,relevance_blurb_id,status,last_checked_at)").eq("lesson_id", lesson.id).eq("is_primary", true),
  ]);
  const error = blocksResult.error || variantsResult.error || recallsResult.error || primarySourcesResult.error;
  if (error) throw error;
  const boundaries = (blocksResult.data ?? []).filter((block) => block.placement === "concept" && block.display_order === 10);
  const boundary = boundaries[0];
  if (boundaries.length !== 1) failures.push(`expected exactly one published concept boundary at display order 10, found ${boundaries.length}`);
  if (boundary?.block_type !== "process" || boundary?.data_status !== "illustrative") failures.push("concept boundary must be an illustrative process block");
  if (boundary) { validateBoundary(boundary.content, "en", failures); validateBoundary(boundary.content, "id", failures); }
  const visualSourcesResult = boundary ? await supabase.from("lesson_visual_block_sources").select("sources(url)").eq("visual_block_id", boundary.id) : { data: [], error: null };
  if (visualSourcesResult.error) throw visualSourcesResult.error;
  const primarySources = sourcesFrom(primarySourcesResult.data ?? []);
  const visualSources = sourcesFrom(visualSourcesResult.data ?? []);
  if (!primarySources.some((source) => isHttpUrl(source?.url) && sourceFields.every((field) => hasText(source?.[field])) && hasText(source?.last_checked_at))) failures.push("complete freshness-marked primary lesson source is missing");
  if (!visualSources.some((source) => isHttpUrl(source?.url))) failures.push("visual-source junction with an HTTP(S) source is missing");
  const variants = variantsResult.data ?? [];
  if (variants.length !== 3) failures.push(`expected exactly 3 active visual_applied questions, found ${variants.length}`);
  variants.forEach((variant, index) => validateQuestion(variant, index + 1, failures));
  const recalls = recallsResult.data ?? [];
  if (recalls.length !== 1) failures.push(`expected exactly 1 active recall question, found ${recalls.length}`);
  else {
    const recall = recalls[0];
    if (!hasText(recall.question_en) || !hasText(recall.question_id) || !Array.isArray(recall.options_en) || !Array.isArray(recall.options_id) || !recall.options_en.includes(recall.correct_option) || !hasText(recall.explanation_en) || !hasText(recall.explanation_id)) failures.push("recall must have paired selectable bilingual copy and explanations");
  }
  console.table([{ slug, boundary: boundaries.length, visualSources: visualSources.length, primarySources: primarySources.length, applied: variants.length, recall: recalls.length }]);
  if (failures.length) { console.error("Consolidation decision-boundaries audit failed:"); failures.forEach((failure) => console.error(`- ${failure}`)); process.exitCode = 1; }
  else console.log(`Consolidation decision-boundaries audit passed for ${slug}.`);
}

main().catch((error) => { console.error(error); process.exitCode = 1; });
