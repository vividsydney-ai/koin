import { describe, it, expect, vi, beforeEach } from "vitest";

const TEST_USER_ID = "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11";
const TEST_LESSON_ID = "b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22";

const rpc = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({
  supabase: { rpc },
}));

import { completeLesson } from "@/lib/services/lessons";

describe("lessons service", () => {
  beforeEach(() => {
    rpc.mockClear();
  });

  it("returns a validation error for an invalid user id", async () => {
    const result = await completeLesson({
      userId: "not-a-uuid",
      lessonId: TEST_LESSON_ID,
      score: 1,
      maxScore: 1,
      answersJson: {},
      timeSpentSeconds: 45,
      quizCorrect: true,
    });

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.error.code).toBe("validation_error");
    }
  });

  it("passes an array answersJson through to the RPC unchanged", async () => {
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

    const answers = [{ variant_id: "variant-1", correct: true }];

    const result = await completeLesson({
      userId: TEST_USER_ID,
      lessonId: TEST_LESSON_ID,
      score: 1,
      maxScore: 1,
      answersJson: answers,
      timeSpentSeconds: 45,
      quizCorrect: true,
    });

    expect(result.ok).toBe(true);
    expect(rpc).toHaveBeenCalledWith(
      "complete_lesson",
      expect.objectContaining({
        p_user_id: TEST_USER_ID,
        p_lesson_id: TEST_LESSON_ID,
        p_answers_json: answers,
      })
    );

    if (result.ok) {
      expect(result.data).toMatchObject({
        xpEarned: 60,
        lessonXp: 50,
        quizBonus: 10,
        streakDays: 2,
        streakStatus: "active",
        badgesEarned: [{ slug: "first_lesson", name: "First Lesson", icon: "📚" }],
        nextLessonSlug: "budgeting-101",
      });
    }
  });

  it("sanitizes a non-array answersJson to an empty array before calling RPC", async () => {
    rpc.mockResolvedValueOnce({
      data: {
        xp_earned: 50,
        lesson_xp: 50,
        quiz_bonus: 0,
        streak_days: 1,
        streak_status: "active",
        badges_earned: [],
        next_lesson_slug: null,
      },
      error: null,
    });

    const result = await completeLesson({
      userId: TEST_USER_ID,
      lessonId: TEST_LESSON_ID,
      score: 2,
      maxScore: 2,
      answersJson: { q1: "a", q2: "b" },
      timeSpentSeconds: 30,
      quizCorrect: false,
    });

    expect(result.ok).toBe(true);
    expect(rpc).toHaveBeenCalledWith(
      "complete_lesson",
      expect.objectContaining({
        p_user_id: TEST_USER_ID,
        p_lesson_id: TEST_LESSON_ID,
        p_answers_json: [],
      })
    );
  });
});
