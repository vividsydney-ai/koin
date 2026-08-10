import { beforeEach, describe, expect, it, vi } from "vitest";

const rpc = vi.hoisted(() => vi.fn());

vi.mock("@/lib/auth/client", () => ({
  supabase: { rpc },
}));

import { getDailyFocusChallenge } from "@/lib/focus/client";

describe("Daily Focus client", () => {
  beforeEach(() => {
    rpc.mockReset();
  });

  it("keeps every supported question type so the displayed item matches the submitted index", async () => {
    rpc.mockResolvedValue({
      data: {
        challenge_date: "2026-07-27",
        max_focus: 3,
        focus_remaining: 3,
        questions_answered: 2,
        correct_answers: 1,
        status: "active",
        refill_used: false,
        missions_completed_this_week: 0,
        mission_goal: 5,
        fourth_focus_unlocked: false,
        questions: [
          { type: "true_false", question: "Question one" },
          { type: "multiple_choice", question: "Question two", options: ["A", "B"] },
          { type: "select_all", question: "Question three", options: ["A", "B"] },
          { type: "fill_blank", question: "Question four", options: ["A", "B"] },
          { type: "true_false", question: "Question five" },
        ],
      },
      error: null,
    });

    const state = await getDailyFocusChallenge("Australia/Sydney");

    expect(state?.questions).toHaveLength(5);
    expect(state?.questions[2]).toMatchObject({ type: "select_all", question: "Question three" });
    expect(state?.questions[state?.questionsAnswered ?? 0]).toMatchObject({
      type: "select_all",
      question: "Question three",
    });
  });

  it("does not accept an ordering question when its choices are missing", async () => {
    rpc.mockResolvedValue({
      data: {
        challenge_date: "2026-08-09",
        max_focus: 3,
        focus_remaining: 3,
        questions_answered: 0,
        correct_answers: 0,
        status: "active",
        refill_used: false,
        missions_completed_this_week: 0,
        mission_goal: 5,
        fourth_focus_unlocked: false,
        questions: [
          { type: "ordering", question: "Order these from safest to riskiest." },
          { type: "true_false", question: "Question two" },
          { type: "true_false", question: "Question three" },
          { type: "true_false", question: "Question four" },
          { type: "true_false", question: "Question five" },
        ],
      },
      error: null,
    });

    const state = await getDailyFocusChallenge("Australia/Sydney");

    expect(state).toBeNull();
  });
});
