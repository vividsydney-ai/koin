export const CURRICULUM_CHAPTER_ORDER = [
  "Foundation",
  "Money Basics",
  "Money Life Skills",
  "Protect Yourself",
  "Let's Talk About Debt",
  "Plan Your Money",
  "Grow Your Money",
  "Investing in Indonesia",
  "Cryptocurrency 101",
  "Reading Trading Charts",
  "Decision Analysis Lab",
] as const;

export type CurriculumLesson = {
  id: string;
  lessonNumber: number;
  chapter: string | null;
};

export function curriculumChapterNumber(chapter: string | null): number | null {
  if (!chapter) return null;
  const index = CURRICULUM_CHAPTER_ORDER.indexOf(chapter as (typeof CURRICULUM_CHAPTER_ORDER)[number]);
  return index === -1 ? null : index + 1;
}

export function orderCurriculumLessons<T extends CurriculumLesson>(lessons: T[]): T[] {
  return [...lessons].sort((a, b) => {
    const aChapter = curriculumChapterNumber(a.chapter) ?? Number.MAX_SAFE_INTEGER;
    const bChapter = curriculumChapterNumber(b.chapter) ?? Number.MAX_SAFE_INTEGER;
    if (aChapter !== bChapter) return aChapter - bChapter;
    return a.lessonNumber - b.lessonNumber;
  });
}
