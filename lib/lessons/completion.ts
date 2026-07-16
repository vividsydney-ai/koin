import { supabase } from "@/lib/auth/client";
import * as lessonService from "@/lib/services/lessons";

export interface CompletionInput {
  userId: string;
  lessonId: string;
  score: number;
  maxScore: number;
  answersJson: unknown;
  timeSpentSeconds: number;
  quizCorrect: boolean;
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
}

export async function completeLesson(input: CompletionInput): Promise<CompletionResult | null> {
  const result = await lessonService.completeLesson(input);
  if (!result.ok) {
    console.error("completeLesson error:", result.error.message);
    return null;
  }
  return result.data;
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
