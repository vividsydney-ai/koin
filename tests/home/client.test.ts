import { describe, it, expect, vi, beforeEach } from "vitest";

const fromMock = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: fromMock,
  },
}));

import { getStreak, getContinueLesson } from "@/lib/home/client";

describe("home client", () => {
  beforeEach(() => {
    fromMock.mockClear();
  });

  it("returns streak data when a row exists", async () => {
    const singleMock = vi.fn().mockResolvedValue({
      data: { current_streak_days: 3, longest_streak_days: 5, streak_status: "active" },
      error: null,
    });
    fromMock.mockReturnValue({
      select: vi.fn().mockReturnValue({ eq: vi.fn().mockReturnValue({ maybeSingle: singleMock }) }),
    });

    const result = await getStreak("user-1");

    expect(result).toEqual({ currentStreakDays: 3, longestStreakDays: 5, streakStatus: "active" });
  });

  it("returns default streak data when no row exists", async () => {
    const singleMock = vi.fn().mockResolvedValue({ data: null, error: null });
    fromMock.mockReturnValue({
      select: vi.fn().mockReturnValue({ eq: vi.fn().mockReturnValue({ maybeSingle: singleMock }) }),
    });

    const result = await getStreak("user-1");

    expect(result).toEqual({ currentStreakDays: 0, longestStreakDays: 0, streakStatus: "active" });
  });

  it("returns null and logs on unexpected error", async () => {
    const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const singleMock = vi.fn().mockResolvedValue({ data: null, error: { message: "boom" } });
    fromMock.mockReturnValue({
      select: vi.fn().mockReturnValue({ eq: vi.fn().mockReturnValue({ maybeSingle: singleMock }) }),
    });

    const result = await getStreak("user-1");

    expect(result).toBeNull();
    expect(consoleSpy).toHaveBeenCalledWith("getStreak error:", "boom");
    consoleSpy.mockRestore();
  });

  describe("getContinueLesson", () => {
    function setupGetContinueLesson({
      lessons,
      progress = [],
      startingLessonId = null,
    }: {
      lessons: { id: string; slug: string; title: string; lesson_number: number }[];
      progress?: { lesson_id: string; status: string }[];
      startingLessonId?: string | null;
    }) {
      fromMock.mockImplementation((table: string) => {
        if (table === "lessons") {
          return {
            select: vi.fn().mockReturnValue({
              eq: vi.fn().mockReturnValue({
                order: vi.fn().mockResolvedValue({ data: lessons, error: null }),
              }),
            }),
          };
        }
        if (table === "lesson_progress") {
          return {
            select: vi.fn().mockReturnValue({
              eq: vi.fn().mockResolvedValue({ data: progress, error: null }),
            }),
          };
        }
        if (table === "user_settings") {
          return {
            select: vi.fn().mockReturnValue({
              eq: vi.fn().mockReturnValue({
                single: vi.fn().mockResolvedValue({
                  data: startingLessonId ? { starting_lesson_id: startingLessonId } : null,
                  error: null,
                }),
              }),
            }),
          };
        }
        return {};
      });
    }

    it("returns the first lesson for a new user", async () => {
      setupGetContinueLesson({
        lessons: [
          { id: "l1", slug: "lesson-1", title: "Lesson 1", lesson_number: 1 },
          { id: "l2", slug: "lesson-2", title: "Lesson 2", lesson_number: 2 },
        ],
      });

      const result = await getContinueLesson("user-1");

      expect(result).toMatchObject({ id: "l1", slug: "lesson-1", status: "available" });
    });

    it("falls back to lesson 1 when configured starting lesson is unpublished", async () => {
      setupGetContinueLesson({
        lessons: [
          { id: "l1", slug: "lesson-1", title: "Lesson 1", lesson_number: 1 },
          { id: "l2", slug: "lesson-2", title: "Lesson 2", lesson_number: 2 },
        ],
        startingLessonId: "old-unpublished-id",
      });

      const result = await getContinueLesson("user-1");

      expect(result).toMatchObject({ id: "l1", slug: "lesson-1", status: "available" });
    });

    it("returns null when all lessons are completed", async () => {
      setupGetContinueLesson({
        lessons: [
          { id: "l1", slug: "lesson-1", title: "Lesson 1", lesson_number: 1 },
          { id: "l2", slug: "lesson-2", title: "Lesson 2", lesson_number: 2 },
        ],
        progress: [
          { lesson_id: "l1", status: "completed" },
          { lesson_id: "l2", status: "completed" },
        ],
      });

      const result = await getContinueLesson("user-1");

      expect(result).toBeNull();
    });
  });
});
