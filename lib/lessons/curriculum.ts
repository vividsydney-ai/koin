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
  slug?: string;
  lessonNumber: number;
  chapter: string | null;
};

/**
 * Chapter-local teaching order for lessons whose original global lesson
 * numbers no longer describe the pedagogical sequence. Keep this canonical
 * so Learn, lesson-player counters, and next-lesson navigation agree.
 */
export const CURRICULUM_LESSON_ORDER: Record<string, readonly string[]> = {
  "Investing in Indonesia": [
    "what-is-a-stock",
    "idx-basics-101",
    "brokerage-account-setup-opening-your-rdn",
    "reading-a-stock-page",
    "stock-analysis-basics-fundamental-vs-technical",
    "portfolio-thinking",
    "etfs-investing-with-one-click",
    "bonds-sbn-safe-investing-with-the-government",
    "macro-indicators",
    "tax-basics-npwp-pph-21-and-filing-taxes",
    "taxes-on-returns",
  ],
};

export function curriculumLessonRank(lesson: Pick<CurriculumLesson, "chapter" | "slug" | "lessonNumber">): number {
  const chapterOrder = lesson.chapter ? CURRICULUM_LESSON_ORDER[lesson.chapter] : undefined;
  const rank = lesson.slug && chapterOrder ? chapterOrder.indexOf(lesson.slug) : -1;
  return rank >= 0 ? rank : lesson.lessonNumber;
}

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
    return curriculumLessonRank(a) - curriculumLessonRank(b);
  });
}
