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
  "Decision Quality Under Uncertainty",
  "Personal Finance Operations",
  "Evidence-Based Investing Decisions",
  "Ownership, Enterprise & Income Quality",
  "Bias-Resistant Decisions & Resilience",
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
  "Money Basics": [
    "value-and-purchasing-power",
    "inflation-101",
    "understanding-risk",
    "time-value-of-money",
    "net-worth-know-your-financial-position",
    "net-worth-know-your-financial-position-part-2",
  ],
  "Money Life Skills": [
    "budgeting-101",
    "pay-yourself-first",
    "spending-traps",
    "behavioral-bias-intro",
    "banking-basics-choosing-the-right-account",
    "banking-basics-choosing-the-right-account-part-2",
    "digital-wallets-qris-safe-and-smart-usage",
    "digital-wallets-qris-safe-and-smart-usage-part-2",
  ],
  "Protect Yourself": [
    "too-good-to-be-true",
    "check-ojk-license",
    "phishing-social-engineering",
    "mlm-pyramid-red-flags",
    "insurance-basics-bpjs-vs-private-insurance",
    "insurance-basics-bpjs-vs-private-insurance-part-2",
  ],
  "Plan Your Money": [
    "emergency-fund-101",
    "goal-setting-101",
    "building-financial-plan",
    "retirement-planning-bpjs-dplk-and-starting-early",
    "retirement-planning-start-early-compounding",
  ],
  "Investing in Indonesia": [
    "what-is-a-stock",
    "idx-basics-101",
    "brokerage-account-setup-opening-your-rdn",
    "brokerage-account-setup-opening-your-rdn-part-2",
    "reading-a-stock-page",
    "stock-analysis-basics-fundamental-vs-technical",
    "stock-analysis-basics-fundamental-vs-technical-part-2",
    "portfolio-thinking",
    "etfs-investing-with-one-click",
    "etfs-investing-with-one-click-part-2",
    "bonds-sbn-safe-investing-with-the-government",
    "bonds-sbn-safe-investing-with-the-government-part-2",
    "macro-indicators",
    "tax-basics-npwp-pph-21-and-filing-taxes",
    "tax-basics-npwp-pph-21-and-filing-taxes-part-2",
    "taxes-on-returns",
  ],
};

export function curriculumLessonRank(lesson: Pick<CurriculumLesson, "chapter" | "slug" | "lessonNumber">): number {
  const chapterOrder = lesson.chapter ? CURRICULUM_LESSON_ORDER[lesson.chapter] : undefined;
  const rank = lesson.slug && chapterOrder ? chapterOrder.indexOf(lesson.slug) : -1;
  return rank >= 0 ? rank : lesson.lessonNumber;
}

/** Canonical zero-based chapter number: Foundation is 00 and Bias is 15. */
export function curriculumChapterNumber(chapter: string | null): number | null {
  if (!chapter) return null;
  const index = CURRICULUM_CHAPTER_ORDER.indexOf(chapter as (typeof CURRICULUM_CHAPTER_ORDER)[number]);
  return index === -1 ? null : index;
}

export const curriculumChapterDisplayNumber = curriculumChapterNumber;

export function orderCurriculumLessons<T extends CurriculumLesson>(lessons: T[]): T[] {
  return [...lessons].sort((a, b) => {
    const aChapter = curriculumChapterNumber(a.chapter) ?? Number.MAX_SAFE_INTEGER;
    const bChapter = curriculumChapterNumber(b.chapter) ?? Number.MAX_SAFE_INTEGER;
    if (aChapter !== bChapter) return aChapter - bChapter;
    return curriculumLessonRank(a) - curriculumLessonRank(b);
  });
}
