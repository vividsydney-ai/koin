import { curriculumChapterNumber } from "./curriculum";
import { requiresChapterMission } from "./mastery";

export type LessonStatus = "locked" | "available" | "in_progress" | "completed";

export interface GatingLesson {
  id: string;
  chapter?: string | null;
}

/**
 * Derive the visible status of each lesson based on the user's saved progress
 * and the onboarding assessment starting point.
 *
 * Rules:
 * - Lessons before the starting lesson are locked.
 * - The starting lesson and the lesson immediately after any completed lesson are available.
 * - Saved "in_progress" and "completed" statuses are preserved.
 * - Any other lesson is locked until the previous lesson is completed.
 */
export function deriveLessonStatuses<T extends GatingLesson>(
  lessons: T[],
  progressMap: Record<string, LessonStatus>,
  startingLessonId: string | null,
  passedChapterMissions: ReadonlySet<number> = new Set()
): Record<string, LessonStatus> {
  const startIndex = startingLessonId ? lessons.findIndex((l) => l.id === startingLessonId) : 0;

  // If a starting lesson was explicitly configured but cannot be found in the
  // provided list, do not silently fall back to the first lesson. Lock
  // everything so the user never sees an unintended entry point.
  if (startingLessonId && startIndex === -1) {
    return Object.fromEntries(lessons.map((lesson) => [lesson.id, "locked"]));
  }

  const derived: Record<string, LessonStatus> = {};
  for (let i = 0; i < lessons.length; i++) {
    const lesson = lessons[i];
    const saved = progressMap[lesson.id];

    if (saved === "completed" || saved === "in_progress") {
      derived[lesson.id] = saved;
      continue;
    }

    if (i < startIndex) {
      derived[lesson.id] = "locked";
      continue;
    }

    const previousLesson = lessons[i - 1];
    const previousChapter = curriculumChapterNumber(previousLesson?.chapter ?? null);
    const crossesMissionBoundary =
      previousLesson?.chapter !== lesson.chapter &&
      requiresChapterMission(previousChapter) &&
      !passedChapterMissions.has(previousChapter!);

    if (
      i === startIndex ||
      (derived[previousLesson?.id] === "completed" && !crossesMissionBoundary)
    ) {
      derived[lesson.id] = saved ?? "available";
      continue;
    }

    derived[lesson.id] = "locked";
  }

  return derived;
}
