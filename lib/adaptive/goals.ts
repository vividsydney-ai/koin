export const GOAL_TO_LESSON_SLUGS: Record<string, string[]> = {
  start_investing: ["risk-return-101", "idx-basics-101"],
  save_emergency: ["emergency-fund-101", "budgeting-101"],
  avoid_scams: ["money-basics-101"],
  budget_better: ["budgeting-101"],
  understand_stocks: ["idx-basics-101"],
};

export function getGoalBasedRecommendation(
  goals: string[],
  completed: Set<string>,
  available: Set<string>
): string | null {
  for (const goal of goals) {
    const slugs = GOAL_TO_LESSON_SLUGS[goal] ?? [];
    for (const slug of slugs) {
      if (available.has(slug) && !completed.has(slug)) {
        return slug;
      }
    }
  }
  return null;
}
