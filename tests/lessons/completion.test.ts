import { describe, it, expect, vi } from "vitest";

const { rpc, single, from } = vi.hoisted(() => ({
  rpc: vi.fn(),
  single: vi.fn(),
  from: vi.fn(),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    rpc,
    from,
  },
}));

import { completeLesson, getNextLessonSlug } from "@/lib/lessons/completion";

describe("completeLesson", () => {
  it("calls complete_lesson RPC with the right payload", async () => {
    rpc.mockResolvedValueOnce({
      data: {
        xp_earned: 60,
        lesson_xp: 50,
        quiz_bonus: 10,
        streak_days: 2,
        streak_status: "active",
        badges_earned: [{ slug: "first_lesson", name: "First Lesson", icon: "📚" }],
        next_lesson_slug: "budgeting-101",
      },
      error: null,
    });

    const result = await completeLesson({
      userId: "user-1",
      lessonId: "lesson-1",
      score: 1,
      maxScore: 1,
      answersJson: [{ variant_id: "variant-1", correct: true }],
      timeSpentSeconds: 45,
      quizCorrect: true,
    });

    expect(rpc).toHaveBeenCalledWith("complete_lesson", {
      p_user_id: "user-1",
      p_lesson_id: "lesson-1",
      p_score: 1,
      p_max_score: 1,
      p_answers_json: [{ variant_id: "variant-1", correct: true }],
      p_time_spent_seconds: 45,
      p_quiz_correct: true,
    });

    expect(result).toEqual({
      xpEarned: 60,
      lessonXp: 50,
      quizBonus: 10,
      streakDays: 2,
      streakStatus: "active",
      badgesEarned: [{ slug: "first_lesson", name: "First Lesson", icon: "📚" }],
      nextLessonSlug: "budgeting-101",
    });
  });

  it("returns null when the RPC fails", async () => {
    rpc.mockResolvedValueOnce({ data: null, error: { message: "boom" } });

    const result = await completeLesson({
      userId: "user-1",
      lessonId: "lesson-1",
      score: 0,
      maxScore: 1,
      answersJson: [],
      timeSpentSeconds: 10,
      quizCorrect: false,
    });

    expect(result).toBeNull();
  });
});

describe("getNextLessonSlug", () => {
  it("returns the next published lesson slug", async () => {
    const eq = vi.fn(() => ({ order: vi.fn(() => ({ limit: vi.fn(() => ({ single })) })) }));
    const gt = vi.fn(() => ({ eq }));
    const select = vi.fn(() => ({ gt }));
    from.mockReturnValueOnce({ select });
    single.mockResolvedValueOnce({ data: { slug: "budgeting-101" }, error: null });

    const slug = await getNextLessonSlug(1);
    expect(slug).toBe("budgeting-101");
    expect(from).toHaveBeenCalledWith("lessons");
    expect(select).toHaveBeenCalledWith("slug");
    expect(gt).toHaveBeenCalledWith("lesson_number", 1);
    expect(eq).toHaveBeenCalledWith("is_published", true);
  });

  it("returns null when there is no next lesson", async () => {
    const eq = vi.fn(() => ({ order: vi.fn(() => ({ limit: vi.fn(() => ({ single })) })) }));
    const gt = vi.fn(() => ({ eq }));
    const select = vi.fn(() => ({ gt }));
    from.mockReturnValueOnce({ select });
    single.mockResolvedValueOnce({ data: null, error: { message: "not found" } });

    const slug = await getNextLessonSlug(99);
    expect(slug).toBeNull();
  });
});
