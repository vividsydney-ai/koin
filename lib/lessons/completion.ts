import { supabase } from "@/lib/auth/client";
import * as lessonService from "@/lib/services/lessons";
import { getLessonStatus } from "@/lib/lessons/client";

export interface CompletionInput {
  userId: string;
  lessonId: string;
  score: number;
  maxScore: number;
  answersJson: unknown;
  timeSpentSeconds: number;
  quizCorrect: boolean;
  lessonNumber?: number;
}

export interface EarnedBadge {
  slug: string;
  name: string;
  icon: string;
}

export interface CompletionResult {
  xpEarned: number;
  lessonXp: number;
  quizBonus: number;
  streakDays: number;
  streakStatus: "active" | "at_risk" | "frozen" | "broken";
  badgesEarned: EarnedBadge[];
  nextLessonSlug: string | null;
  alreadyCompleted: boolean;
}

export async function completeLesson(input: CompletionInput): Promise<CompletionResult | null> {
  const result = await lessonService.completeLesson(input);
  if (result.ok) {
    return result.data;
  }

  console.error("completeLesson error:", result.error.message);

  // Defensive check: the RPC may have succeeded server-side but the response
  // was lost (network timeout / edge hiccup). If the lesson is now completed,
  // treat it as a successful replay so the UI does not block the learner.
  let status: Awaited<ReturnType<typeof getLessonStatus>> = null;
  try {
    status = await getLessonStatus(input.userId, input.lessonId);
  } catch (e) {
    console.error("completeLesson: could not verify lesson status after RPC error", e);
  }
  if (status === "completed") {
    const nextSlug = await getNextLessonSlug(input.lessonNumber ?? 0);
    return {
      xpEarned: 0,
      lessonXp: 0,
      quizBonus: 0,
      streakDays: 0,
      streakStatus: "active",
      badgesEarned: [],
      nextLessonSlug: nextSlug,
      alreadyCompleted: true,
    };
  }

  return null;
}

export async function getNextLessonSlug(currentLessonNumber: number): Promise<string | null> {
  const { data, error } = await supabase
    .from("lessons")
    .select("slug")
    .gt("lesson_number", currentLessonNumber)
    .eq("is_published", true)
    .order("lesson_number", { ascending: true })
    .limit(1)
    .single();

  if (error || !data) return null;
  return data.slug;
}
