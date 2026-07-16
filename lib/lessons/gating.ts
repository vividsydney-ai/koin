export type LessonStatus = "locked" | "available" | "in_progress" | "completed";

export interface GatingLesson {
  id: string;
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
  startingLessonId: string | null
): Record<string, LessonStatus> {
  const startIndex = startingLessonId ? Math.max(0, lessons.findIndex((l) => l.id === startingLessonId)) : 0;

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

    if (i === startIndex || derived[lessons[i - 1]?.id] === "completed") {
      derived[lesson.id] = saved ?? "available";
      continue;
    }

    derived[lesson.id] = "locked";
  }

  return derived;
}
