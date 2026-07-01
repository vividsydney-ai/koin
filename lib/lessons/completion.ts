import { supabase } from "@/lib/auth/client";

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
  badgesEarned: EarnedBadge[];
  nextLessonSlug: string | null;
}

export async function completeLesson(input: CompletionInput): Promise<CompletionResult | null> {
  const { data, error } = await supabase.rpc("complete_lesson", {
    p_user_id: input.userId,
    p_lesson_id: input.lessonId,
    p_score: input.score,
    p_max_score: input.maxScore,
    p_answers_json: input.answersJson as Record<string, unknown>,
    p_time_spent_seconds: input.timeSpentSeconds,
    p_quiz_correct: input.quizCorrect,
  });

  if (error || !data) {
    console.error("completeLesson error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    xpEarned: Number(raw.xp_earned ?? 0),
    lessonXp: Number(raw.lesson_xp ?? 0),
    quizBonus: Number(raw.quiz_bonus ?? 0),
    streakDays: Number(raw.streak_days ?? 0),
    badgesEarned: Array.isArray(raw.badges_earned) ? (raw.badges_earned as EarnedBadge[]) : [],
    nextLessonSlug: typeof raw.next_lesson_slug === "string" ? raw.next_lesson_slug : null,
  };
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
