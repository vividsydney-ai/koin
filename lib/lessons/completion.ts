import * as lessonService from "@/lib/services/lessons";
import { getAllLessons, getLessonProgress, getLessonStatus, getPassedChapterMissions } from "@/lib/lessons/client";
import { curriculumChapterNumber } from "@/lib/lessons/curriculum";
import { requiresChapterMission } from "@/lib/lessons/mastery";
import type { ServiceError } from "@/lib/types/service-error";

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

export async function completeLesson(input: CompletionInput): Promise<CompletionResult | ServiceError> {
  const result = await lessonService.completeLesson(input);
  if (result.ok) {
    const nextLessonSlug = await getNextLessonSlug(input.lessonId, input.userId);
    return { ...result.data, nextLessonSlug };
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
    const nextSlug = await getNextLessonSlug(input.lessonId, input.userId);
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

  return result.error;
}

export async function getNextLessonSlug(currentLessonId: string, userId: string): Promise<string | null> {
  const [lessons, progress] = await Promise.all([getAllLessons(), getLessonProgress(userId)]);
  const currentIndex = lessons.findIndex((lesson) => lesson.id === currentLessonId);
  if (currentIndex === -1) return null;

  const followingLessons = lessons.slice(currentIndex + 1);
  if (followingLessons.length === 0) return null;

  const currentChapterNumber = curriculumChapterNumber(lessons[currentIndex].chapter ?? null);
  const currentChapterIsComplete = lessons
    .filter((lesson) => lesson.chapter === lessons[currentIndex].chapter)
    .every((lesson) => progress?.[lesson.id] === "completed");
  if (currentChapterIsComplete && requiresChapterMission(currentChapterNumber)) {
    const passedMissions = await getPassedChapterMissions(userId);
    if (!passedMissions.has(currentChapterNumber!)) return null;
  }

  return (
    followingLessons.find((lesson) => progress?.[lesson.id] !== "completed")?.slug ??
    followingLessons[0]?.slug ??
    null
  );
}
