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
    (data as any[])?.map((row) => {
      const lesson = row.lessons ?? {};
      return {
        id: row.id,
        lessonId: row.lesson_id,
        slug: lesson.slug ?? "",
        title: lesson.title ?? "Recommended lesson",
        reason: row.reason ?? "",
        dismissed: row.dismissed ?? false,
        createdAt: row.created_at ?? new Date().toISOString(),
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
