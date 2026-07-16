import { supabase } from "@/lib/auth/client";

export interface LessonRecommendation {
  id: string;
  lessonId: string;
  slug: string;
  title: string;
  reason: string;
  dismissed: boolean;
  createdAt: string;
}

export async function getLessonRecommendations(userId: string): Promise<LessonRecommendation[]> {
  const { data, error } = await supabase
    .from("user_lesson_recommendations")
    .select(
      "id, lesson_id, reason, dismissed, created_at, lessons(slug, title)"
    )
    .eq("user_id", userId)
    .eq("dismissed", false)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("getLessonRecommendations error:", error.message);
    return [];
  }

  return (
    (data as Record<string, unknown>[])?.map((row) => {
      const lesson = (row.lessons as Record<string, unknown>) ?? {};
      return {
        id: String(row.id ?? ""),
        lessonId: String(row.lesson_id ?? ""),
        slug: String(lesson.slug ?? ""),
        title: String(lesson.title ?? "Recommended lesson"),
        reason: String(row.reason ?? ""),
        dismissed: Boolean(row.dismissed ?? false),
        createdAt: String(row.created_at ?? new Date().toISOString()),
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
