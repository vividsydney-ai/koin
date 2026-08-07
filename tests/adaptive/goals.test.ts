import { describe, it, expect } from "vitest";
import {
  GOAL_TO_LESSON_SLUGS,
  getGoalBasedRecommendation,
} from "@/lib/adaptive/goals";

describe("adaptive goals", () => {
  it("maps known goals to lesson slugs", () => {
    expect(GOAL_TO_LESSON_SLUGS.start_investing).toEqual(["risk-return-101", "idx-basics-101"]);
    expect(GOAL_TO_LESSON_SLUGS.save_emergency).toEqual(["emergency-fund-101", "budgeting-101"]);
    expect(GOAL_TO_LESSON_SLUGS.avoid_scams).toEqual(["money-basics-101"]);
    expect(GOAL_TO_LESSON_SLUGS.budget_better).toEqual(["budgeting-101"]);
    expect(GOAL_TO_LESSON_SLUGS.understand_stocks).toEqual(["idx-basics-101"]);
  });

  it("recommends the first available incomplete slug for the first goal", () => {
    const recommended = getGoalBasedRecommendation(
      ["start_investing"],
      new Set(),
      new Set(["risk-return-101", "idx-basics-101"])
    );
    expect(recommended).toBe("risk-return-101");
  });

  it("skips completed slugs", () => {
    const recommended = getGoalBasedRecommendation(
      ["start_investing"],
      new Set(["risk-return-101"]),
      new Set(["risk-return-101", "idx-basics-101"])
    );
    expect(recommended).toBe("idx-basics-101");
  });

  it("falls back to the next goal when the first goal's slugs are completed", () => {
    const recommended = getGoalBasedRecommendation(
      ["start_investing", "save_emergency"],
      new Set(["risk-return-101", "idx-basics-101"]),
      new Set(["risk-return-101", "idx-basics-101", "emergency-fund-101"])
    );
    expect(recommended).toBe("emergency-fund-101");
  });

  it("returns null when no slugs are available", () => {
    const recommended = getGoalBasedRecommendation(
      ["start_investing"],
      new Set(),
      new Set(["budgeting-101"])
    );
    expect(recommended).toBeNull();
  });

  it("returns null when all goal slugs are completed", () => {
    const recommended = getGoalBasedRecommendation(
      ["avoid_scams"],
      new Set(["money-basics-101"]),
      new Set(["money-basics-101"])
    );
    expect(recommended).toBeNull();
  });

  it("returns null for empty goals", () => {
    const recommended = getGoalBasedRecommendation([], new Set(), new Set(["budgeting-101"]));
    expect(recommended).toBeNull();
  });

  it("ignores unknown goals", () => {
    const recommended = getGoalBasedRecommendation(
      ["unknown_goal"],
      new Set(),
      new Set(["budgeting-101"])
    );
    expect(recommended).toBeNull();
  });
});
