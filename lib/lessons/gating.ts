import { curriculumChapterNumber } from "./curriculum";
import { requiresChapterMission } from "./mastery";

export type LessonStatus = "locked" | "available" | "in_progress" | "completed";

export interface GatingLesson {
  id: string;
  chapter?: string | null;
}

/**
 * Convert the assessment's stored lesson marker into a chapter-level core
 * entry point. The marker is kept for backwards compatibility with existing
 * onboarding data; callers must never use it as an in-chapter shortcut.
 */
export function getCoreStartIndex<T extends GatingLesson>(
  lessons: T[],
  startingLessonId: string | null
): number {
  const configuredStartIndex = startingLessonId
    ? lessons.findIndex((lesson) => lesson.id === startingLessonId)
    : 0;
  if (configuredStartIndex === -1) return -1;

  const configuredChapter = lessons[configuredStartIndex]?.chapter;
  if (!configuredChapter) return configuredStartIndex;

  return lessons.findIndex((lesson) => lesson.chapter === configuredChapter);
}

/**
 * Derive the visible status of each lesson based on the user's saved progress
 * and the onboarding assessment starting point.
 *
 * Rules:
 * - A diagnostic selects an entry chapter, never an in-chapter shortcut.
 * - Earlier chapters are optional review: all of their lessons are available,
 *   but they do not gate the learner's assigned core path.
 * - The first lesson of the entry chapter and the lesson immediately after any
 *   core-path completion are available.
 * - Saved "in_progress" and "completed" statuses are preserved.
 * - Any other lesson is locked until the previous lesson is completed.
 */
export function deriveLessonStatuses<T extends GatingLesson>(
  lessons: T[],
  progressMap: Record<string, LessonStatus>,
  startingLessonId: string | null,
  passedChapterMissions: ReadonlySet<number> = new Set()
): Record<string, LessonStatus> {
  const configuredStartIndex = startingLessonId ? lessons.findIndex((l) => l.id === startingLessonId) : 0;

  // If a starting lesson was explicitly configured but cannot be found in the
  // provided list, do not silently fall back to the first lesson. Lock
  // everything so the user never sees an unintended entry point.
  if (startingLessonId && configuredStartIndex === -1) {
    return Object.fromEntries(lessons.map((lesson) => [lesson.id, "locked"]));
  }

  // A diagnostic may select a suitable chapter, but it must never skip the
  // chapter's own sequence. Earlier chapters remain optional review.
  const hasChapterContext = Boolean(lessons[configuredStartIndex]?.chapter);
  const coreStartIndex = getCoreStartIndex(lessons, startingLessonId);

  const derived: Record<string, LessonStatus> = {};
  for (let i = 0; i < lessons.length; i++) {
    const lesson = lessons[i];
    const saved = progressMap[lesson.id];

    if (saved === "completed" || saved === "in_progress") {
      derived[lesson.id] = saved;
      continue;
    }

    if (hasChapterContext && i < coreStartIndex) {
      derived[lesson.id] = "available";
      continue;
    }

    const previousLesson = lessons[i - 1];
    const previousChapter = curriculumChapterNumber(previousLesson?.chapter ?? null);
    const crossesMissionBoundary =
      previousLesson?.chapter !== lesson.chapter &&
      requiresChapterMission(previousChapter) &&
      !passedChapterMissions.has(previousChapter!);

    if (
      i === coreStartIndex ||
      (derived[previousLesson?.id] === "completed" && !crossesMissionBoundary)
    ) {
      derived[lesson.id] = saved ?? "available";
      continue;
    }

    derived[lesson.id] = "locked";
  }

  return derived;
}
