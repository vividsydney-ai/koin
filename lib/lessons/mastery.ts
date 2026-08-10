/**
 * Learning requirements deliberately build by chapter without restricting when
 * a learner can study. Daily Focus has its own cadence and is not consulted
 * here.
 */
export function lessonCheckCount(chapterNumber: number | null | undefined): number {
  if (chapterNumber === null || chapterNumber === undefined || chapterNumber <= 2) return 1;
  return 2;
}

export function requiresChapterMission(chapterNumber: number | null | undefined): boolean {
  return chapterNumber !== null && chapterNumber !== undefined && chapterNumber >= 6 && chapterNumber <= 11;
}

export const CHAPTER_MISSION_QUESTION_COUNT = 3;
export const CHAPTER_MISSION_PASSING_SCORE = 3;

export function isChapterMissionPassed(score: number, maxScore: number): boolean {
  return maxScore >= CHAPTER_MISSION_QUESTION_COUNT && score >= CHAPTER_MISSION_PASSING_SCORE;
}
