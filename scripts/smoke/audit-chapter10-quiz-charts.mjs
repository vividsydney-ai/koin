#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const PRICE_TERMS_EN = /\b(price|candle|body|wick|high|low|open|close|range)\b/i;
const PRICE_TERMS_ID = /\b(harga|candle|body|wick|high|low|open|close|rentang)\b/i;

function needsChart(question) {
  if (typeof question !== "string") return false;
  return PRICE_TERMS_EN.test(question) || PRICE_TERMS_ID.test(question);
}

function hasValidChart(payload) {
  if (!payload || typeof payload !== "object") return false;
  const chart = payload.chart;
  if (!chart || !Array.isArray(chart.candles) || chart.candles.length === 0) return false;
  return chart.candles.every((candle) =>
    typeof candle.open === "number" &&
    typeof candle.high === "number" &&
    typeof candle.low === "number" &&
    typeof candle.close === "number" &&
    candle.high >= Math.max(candle.open, candle.close) &&
    candle.low <= Math.min(candle.open, candle.close)
  );
}

async function main() {
  const { data: lessons, error: lessonError } = await supabase
    .from("lessons")
    .select("id, slug, lesson_number, topics!inner(chapter)")
    .eq("is_published", true)
    .eq("topics.chapter", "Reading Trading Charts")
    .order("lesson_number");
  if (lessonError) throw lessonError;

  const lessonIds = lessons.map((lesson) => lesson.id);
  const { data: variants, error: variantError } = await supabase
    .from("content_variants")
    .select("lesson_id, body, body_id, topic_tag, is_active")
    .in("lesson_id", lessonIds)
    .eq("variant_type", "question")
    .eq("topic_tag", "visual_applied")
    .eq("is_active", true);
  if (variantError) throw variantError;

  const slugById = new Map(lessons.map((lesson) => [lesson.id, lesson.slug]));
  const failures = [];
  const rows = [];

  for (const variant of variants ?? []) {
    const slug = slugById.get(variant.lesson_id) ?? variant.lesson_id;
    for (const [locale, payload] of [["en", variant.body], ["id", variant.body_id]]) {
      const question = payload?.question ?? "";
      const wantsChart = needsChart(question);
      const hasChart = hasValidChart(payload);

      rows.push({
        slug,
        locale,
        question: question.slice(0, 60),
        wantsChart: wantsChart ? "yes" : "no",
        hasChart: hasChart ? "yes" : "no",
      });

      if (wantsChart && !hasChart) {
        failures.push(`${slug}/${locale}: price-related question missing valid chart`);
      }
    }
  }

  console.table(rows);

  if (failures.length > 0) {
    console.error("Chapter 10 quiz-chart audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Chapter 10 quiz-chart audit passed for ${rows.length} bilingual question payloads.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
