#!/usr/bin/env node

import { config } from "dotenv";
import { createClient } from "@supabase/supabase-js";

config({ path: ".env.local" });

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
);

const VALID_POSITIONS = new Set([
  "high",
  "low",
  "open",
  "close",
  "bodyTop",
  "bodyBottom",
  "bodyCenter",
]);

function getCandlesAndMarkers(payload, blockType) {
  if (!payload || typeof payload !== "object") return [];

  if (blockType === "annotated_data") {
    const chart = payload.chart;
    if (!chart || !Array.isArray(chart.candles)) return [];
    return [{ candles: chart.candles, markers: chart.markers ?? [] }];
  }

  if (blockType === "process") {
    const chart = payload.chart;
    if (!chart || !Array.isArray(chart.candles)) return [];
    return [{ candles: chart.candles, markers: chart.markers ?? [] }];
  }

  if (blockType === "comparison" && Array.isArray(payload.items)) {
    return payload.items
      .map((item) => item.chart)
      .filter((chart) => chart && Array.isArray(chart.candles))
      .map((chart) => ({ candles: chart.candles, markers: chart.markers ?? [] }));
  }

  return [];
}

function auditBlock(lessonSlug, blockType, content) {
  const failures = [];
  const locales = ["en", "id"];

  for (const locale of locales) {
    const copy = content?.[locale];
    if (!copy || typeof copy !== "object") {
      failures.push(`${lessonSlug}/${locale}: missing locale copy`);
      continue;
    }

    const payload = copy.payload;
    const annotations = Array.isArray(payload?.annotations) ? payload.annotations : [];
    if (annotations.length === 0) continue;

    const annotationNumbers = annotations.map((a) => a.number);
    const charts = getCandlesAndMarkers(payload, blockType);

    if (charts.length === 0) {
      failures.push(`${lessonSlug}/${locale}/${blockType}: has ${annotations.length} annotation(s) but no chart to mark`);
      continue;
    }

    const allMarkers = charts.flatMap((chart) => chart.markers);
    const markerNumbers = new Set(allMarkers.map((m) => m.number));

    for (const number of annotationNumbers) {
      if (!markerNumbers.has(number)) {
        failures.push(`${lessonSlug}/${locale}: annotation ${number} has no matching chart marker`);
      }
    }

    for (const [index, marker] of allMarkers.entries()) {
      const markerLabel = marker.number ?? `#${index}`;
      if (!Number.isInteger(marker.candleIndex) || marker.candleIndex < 0) {
        failures.push(`${lessonSlug}/${locale}: marker ${markerLabel} has invalid candleIndex ${marker.candleIndex}`);
        continue;
      }
      const candleCount = Math.max(...charts.map((c) => c.candles.length));
      const matchingChart = charts.find((c) => marker.candleIndex < c.candles.length);
      if (!matchingChart) {
        failures.push(`${lessonSlug}/${locale}: marker ${markerLabel} points to candleIndex ${marker.candleIndex} but max available is ${candleCount - 1}`);
      }
      if (!VALID_POSITIONS.has(marker.position)) {
        failures.push(`${lessonSlug}/${locale}: marker ${markerLabel} has invalid position "${marker.position}"`);
      }
    }
  }

  return failures;
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
  const { data: blocks, error: blockError } = await supabase
    .from("lesson_visual_blocks")
    .select("lesson_id, block_type, content")
    .in("lesson_id", lessonIds)
    .eq("is_published", true);
  if (blockError) throw blockError;

  const slugById = new Map(lessons.map((lesson) => [lesson.id, lesson.slug]));
  const failures = [];
  const rows = [];

  for (const block of blocks ?? []) {
    const slug = slugById.get(block.lesson_id) ?? block.lesson_id;
    const blockFailures = auditBlock(slug, block.block_type, block.content);
    failures.push(...blockFailures);
    rows.push({
      slug,
      blockType: block.block_type,
      annotationsEn: Array.isArray(block.content?.en?.payload?.annotations)
        ? block.content.en.payload.annotations.length
        : 0,
      annotationsId: Array.isArray(block.content?.id?.payload?.annotations)
        ? block.content.id.payload.annotations.length
        : 0,
      markersEn: getCandlesAndMarkers(block.content?.en?.payload, block.block_type)
        .reduce((sum, chart) => sum + chart.markers.length, 0),
      markersId: getCandlesAndMarkers(block.content?.id?.payload, block.block_type)
        .reduce((sum, chart) => sum + chart.markers.length, 0),
      failures: blockFailures.length,
    });
  }

  console.table(rows);

  if (failures.length > 0) {
    console.error("Chapter 10 visual-marker audit failed:");
    failures.forEach((failure) => console.error(`- ${failure}`));
    process.exitCode = 1;
    return;
  }

  console.log(`Chapter 10 visual-marker audit passed for ${rows.length} published visual blocks.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
