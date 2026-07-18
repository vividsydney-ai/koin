import { describe, it, expect, vi, beforeEach } from "vitest";

const TEST_USER_ID = "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11";
const TEST_LESSON_ID = "b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22";

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
  beforeEach(() => {
    vi.clearAllMocks();
  });

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
      userId: TEST_USER_ID,
      lessonId: TEST_LESSON_ID,
      score: 1,
      maxScore: 1,
      answersJson: [{ variant_id: "variant-1", correct: true }],
      timeSpentSeconds: 45,
      quizCorrect: true,
    });

    expect(rpc).toHaveBeenCalledWith("complete_lesson", {
      p_user_id: TEST_USER_ID,
      p_lesson_id: TEST_LESSON_ID,
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
      alreadyCompleted: false,
    });
  });

  it("returns the service error when the RPC fails", async () => {
    rpc
      .mockResolvedValueOnce({ data: null, error: { message: "boom" } })
      .mockResolvedValueOnce({ data: null, error: { message: "boom" } });

    const result = await completeLesson({
      userId: TEST_USER_ID,
      lessonId: TEST_LESSON_ID,
      score: 0,
      maxScore: 1,
      answersJson: [],
      timeSpentSeconds: 10,
      quizCorrect: false,
    });

    expect(result).toEqual({ code: "rpc_error", message: "boom" });
    expect(rpc).toHaveBeenCalledTimes(2);
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
