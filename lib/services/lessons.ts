import { supabase } from "@/lib/auth/client";
import { ok, err, type Result } from "@/lib/types/result";
import { serviceError, type ServiceError } from "@/lib/types/service-error";
import { completeLessonSchema } from "@/lib/schemas/lessons";
import type { CompleteLessonInput } from "@/lib/schemas/lessons";
import type { CompletionResult } from "@/lib/lessons/completion";

export type { CompleteLessonInput } from "@/lib/schemas/lessons";

export async function completeLesson(
  input: CompleteLessonInput
): Promise<Result<CompletionResult, ServiceError>> {
  const parsed = completeLessonSchema.safeParse(input);
  if (!parsed.success) {
    return err(serviceError("validation_error", parsed.error.issues[0].message));
  }

  const { userId, lessonId, score, maxScore, answersJson, timeSpentSeconds, quizCorrect } =
    parsed.data;

  const sanitizedAnswers =
    answersJson && typeof answersJson === "object" && !Array.isArray(answersJson)
      ? (answersJson as Record<string, unknown>)
      : {};

  const { data, error } = await supabase.rpc("complete_lesson", {
    p_user_id: userId,
    p_lesson_id: lessonId,
    p_score: score,
    p_max_score: maxScore,
    p_answers_json: sanitizedAnswers,
    p_time_spent_seconds: timeSpentSeconds,
    p_quiz_correct: quizCorrect,
  });

  if (error || !data) {
    return err(serviceError("rpc_error", error?.message ?? "Failed to complete lesson"));
  }

  const raw = data as Record<string, unknown>;
  return ok({
    xpEarned: Number(raw.xp_earned ?? 0),
    lessonXp: Number(raw.lesson_xp ?? 0),
    quizBonus: Number(raw.quiz_bonus ?? 0),
    streakDays: Number(raw.streak_days ?? 0),
    streakStatus: (raw.streak_status as CompletionResult["streakStatus"]) ?? "active",
    badgesEarned: Array.isArray(raw.badges_earned)
      ? (raw.badges_earned as CompletionResult["badgesEarned"])
      : [],
    nextLessonSlug: typeof raw.next_lesson_slug === "string" ? raw.next_lesson_slug : null,
  });
}
