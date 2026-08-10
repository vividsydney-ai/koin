import { supabase } from "@/lib/auth/client";
import type { Locale } from "@/lib/i18n/types";

export interface LessonRecommendation {
  id: string;
  lessonId: string;
  slug: string;
  title: string;
  reason: string;
  dismissed: boolean;
  createdAt: string;
  trigger: {
    type: string;
    event: string | null;
    thresholdPct: number | null;
  } | null;
}

const ENGLISH_REASON_FALLBACK = "A lesson selected to support your learning journey.";

export async function getLessonRecommendations(
  userId: string,
  locale: Locale
): Promise<LessonRecommendation[]> {
  const { data, error } = await supabase
    .from("user_lesson_recommendations")
    .select(
      "id, lesson_id, reason, reason_id, dismissed, created_at, lessons!inner(slug, title, title_id, is_published), lesson_triggers(trigger_type, condition_json)"
    )
    .eq("user_id", userId)
    .eq("dismissed", false)
    .eq("lessons.is_published", true)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("getLessonRecommendations error:", error.message);
    return [];
  }

  return (
    (data as Record<string, unknown>[])?.map((row) => {
      const lesson = (row.lessons as Record<string, unknown>) ?? {};
      const trigger = Array.isArray(row.lesson_triggers)
        ? row.lesson_triggers[0] as Record<string, unknown> | undefined
        : row.lesson_triggers as Record<string, unknown> | null;
      const condition = (trigger?.condition_json as Record<string, unknown> | null) ?? null;
      const threshold = Number(condition?.threshold_pct);
      const englishReason = String(row.reason_id ?? "").trim();
      const englishTitle = String(lesson.title ?? "Recommended lesson");
      const indonesianTitle = String(lesson.title_id ?? "").trim();
      return {
        id: String(row.id ?? ""),
        lessonId: String(row.lesson_id ?? ""),
        slug: String(lesson.slug ?? ""),
        title: locale === "id" && indonesianTitle ? indonesianTitle : englishTitle,
        reason: locale === "id" ? String(row.reason ?? "") : englishReason || ENGLISH_REASON_FALLBACK,
        dismissed: Boolean(row.dismissed ?? false),
        createdAt: String(row.created_at ?? new Date().toISOString()),
        trigger: trigger
          ? {
              type: String(trigger.trigger_type ?? ""),
              event: typeof condition?.event === "string" ? condition.event : null,
              thresholdPct: Number.isFinite(threshold) ? threshold : null,
            }
          : null,
      };
    }) ?? []
  );
}

export async function dismissRecommendation(recommendationId: string): Promise<void> {
  const { error } = await supabase
    .from("user_lesson_recommendations")
    .update({ dismissed: true })
    .eq("id", recommendationId);

  if (error) {
    console.error("dismissRecommendation error:", error.message);
    throw new Error(error.message);
  }
}

export async function checkAdaptiveTriggers(): Promise<void> {
  const { error } = await supabase.rpc("check_adaptive_triggers");

  if (error) {
    console.error("checkAdaptiveTriggers error:", error.message);
    // Non-fatal: recommendations are best-effort.
    return;
  }
}
