import { describe, it, expect } from "vitest";
import { deriveLessonStatuses, type LessonStatus } from "@/lib/lessons/gating";

function buildLessons(count: number) {
  return Array.from({ length: count }, (_, i) => ({ id: `lesson-${i + 1}` }));
}

describe("deriveLessonStatuses", () => {
  it("unlocks the first lesson when no starting lesson is set", () => {
    const lessons = buildLessons(3);
    const result = deriveLessonStatuses(lessons, {}, null);

    expect(result["lesson-1"]).toBe("available");
    expect(result["lesson-2"]).toBe("locked");
    expect(result["lesson-3"]).toBe("locked");
  });

  it("locks everything before the starting lesson", () => {
    const lessons = buildLessons(5);
    const result = deriveLessonStatuses(lessons, {}, "lesson-3");

    expect(result["lesson-1"]).toBe("locked");
    expect(result["lesson-2"]).toBe("locked");
    expect(result["lesson-3"]).toBe("available");
    expect(result["lesson-4"]).toBe("locked");
    expect(result["lesson-5"]).toBe("locked");
  });

  it("unlocks the next lesson when the previous one is completed", () => {
    const lessons = buildLessons(4);
    const progress: Record<string, LessonStatus> = {
      "lesson-1": "completed",
    };
    const result = deriveLessonStatuses(lessons, progress, null);

    expect(result["lesson-1"]).toBe("completed");
    expect(result["lesson-2"]).toBe("available");
    expect(result["lesson-3"]).toBe("locked");
    expect(result["lesson-4"]).toBe("locked");
  });

  it("preserves in_progress status even when the next lesson would otherwise be available", () => {
    const lessons = buildLessons(3);
    const progress: Record<string, LessonStatus> = {
      "lesson-1": "completed",
      "lesson-2": "in_progress",
    };
    const result = deriveLessonStatuses(lessons, progress, null);

    expect(result["lesson-1"]).toBe("completed");
    expect(result["lesson-2"]).toBe("in_progress");
    expect(result["lesson-3"]).toBe("locked");
  });

  it("ignores stale available rows that are ahead of the completion frontier", () => {
    const lessons = buildLessons(4);
    const progress: Record<string, LessonStatus> = {
      "lesson-1": "available",
      "lesson-3": "available",
    };
    const result = deriveLessonStatuses(lessons, progress, null);

    expect(result["lesson-1"]).toBe("available");
    expect(result["lesson-2"]).toBe("locked");
    expect(result["lesson-3"]).toBe("locked");
    expect(result["lesson-4"]).toBe("locked");
  });

  it("handles an unknown starting lesson id by starting at the beginning", () => {
    const lessons = buildLessons(3);
    const result = deriveLessonStatuses(lessons, {}, "missing-lesson");

    expect(result["lesson-1"]).toBe("available");
    expect(result["lesson-2"]).toBe("locked");
    expect(result["lesson-3"]).toBe("locked");
  });
});
