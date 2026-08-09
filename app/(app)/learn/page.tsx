"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import {
  getAllLessons,
  getLessonProgress,
  getPassedChapterMissions,
  ensureLessonProgressAvailable,
  getTopicsWithChapters,
  type Chapter,
  type ChapterLesson,
} from "@/lib/lessons/client";
import { useAuth } from "@/lib/auth/use-auth";
import type { Lesson } from "@/lib/lessons/client";
import { deriveLessonStatuses, getCoreStartIndex, type LessonStatus } from "@/lib/lessons/gating";
import { getUserLearningPath, getFinancialGoals, type UserLearningPath } from "@/lib/profile/client";
import {
  getLessonRecommendations,
  dismissRecommendation,
  type LessonRecommendation,
} from "@/lib/adaptive/client";
import { getGoalBasedRecommendation } from "@/lib/adaptive/goals";
import { useLocale } from "@/lib/i18n/LocaleProvider";

const CHAPTER_TITLE_KEY: Record<string, string> = {
  "Foundation": "chapter.foundation",
  "Money Basics": "chapter.moneyBasics",
  "Money Life Skills": "chapter.moneyLifeSkills",
  "Protect Yourself": "chapter.protectYourself",
  "Let's Talk About Debt": "chapter.letsTalkAboutDebt",
  "Plan Your Money": "chapter.planYourMoney",
  "Grow Your Money": "chapter.growYourMoney",
  "Investing in Indonesia": "chapter.investingInIndonesia",
  "Cryptocurrency 101": "chapter.cryptocurrency101",
  "Reading Trading Charts": "chapter.readingTradingCharts",
  "Decision Analysis Lab": "chapter.decisionAnalysisLab",
};

function localizedChapterTitle(title: string, t: (key: string) => string): string {
  const key = CHAPTER_TITLE_KEY[title];
  return key ? t(key) : title;
}

export default function LearnPage() {
  const { user } = useAuth(true);
  const { t, locale } = useLocale();
  const [lessons, setLessons] = useState<
    Pick<Lesson, "id" | "slug" | "title" | "titleId" | "lessonNumber" | "difficulty" | "xpReward" | "estimatedMinutes" | "summary" | "summaryId">[]
  >([]);
  const [chapters, setChapters] = useState<Chapter[]>([]);
  const [derivedProgress, setDerivedProgress] = useState<Record<string, LessonStatus> | null>(null);
  const [passedChapterMissions, setPassedChapterMissions] = useState<Set<number>>(new Set());
  const [recommendations, setRecommendations] = useState<LessonRecommendation[]>([]);
  const [learningPath, setLearningPath] = useState<UserLearningPath>({
    foundationZeroRequired: true,
    startingLessonId: null,
    assessmentScore: null,
  });
  const [financialGoals, setFinancialGoals] = useState<string[] | null>(null);
  const [loading, setLoading] = useState(true);
  const [expandedChapters, setExpandedChapters] = useState<Set<string>>(new Set());

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const [all, chapterData, userProgress, recs, path, goals, passedMissions] = await Promise.all([
        getAllLessons(),
        getTopicsWithChapters(),
        user ? getLessonProgress(user.id) : Promise.resolve(null),
        user ? getLessonRecommendations(user.id, locale) : Promise.resolve([]),
        user
          ? getUserLearningPath(user.id)
          : Promise.resolve({ foundationZeroRequired: true, startingLessonId: null, assessmentScore: null }),
        user ? getFinancialGoals(user.id) : Promise.resolve(null),
        user ? getPassedChapterMissions(user.id) : Promise.resolve(new Set<number>()),
      ]);

      if (!mounted) return;

      const progressMap = userProgress ?? {};
      const derived = deriveLessonStatuses(all, progressMap, path.startingLessonId, passedMissions);
      const coreStartIndex = getCoreStartIndex(all, path.startingLessonId);

      const firstUnlockedIncomplete = all.slice(Math.max(coreStartIndex, 0)).find((lesson) => {
        const status = derived[lesson.id];
        return status !== "locked" && status !== "completed";
      });

      if (user && firstUnlockedIncomplete) {
        await ensureLessonProgressAvailable(user.id, [firstUnlockedIncomplete.id]);
      }

      if (mounted) {
        setLessons(all);
        setChapters(chapterData);
        setDerivedProgress(derived);
        setPassedChapterMissions(passedMissions);
        setRecommendations(recs);
        setLearningPath(path);
        setFinancialGoals(goals);
        setLoading(false);

        // Expand the current lesson chapter, or the mission that is holding
        // the next chapter closed, by default.
        const currentChapter = firstUnlockedIncomplete
          ? chapterData.find((chapter) =>
            chapter.topics.some((topic) => topic.lessons.some((lesson) => lesson.id === firstUnlockedIncomplete.id))
          )
          : chapterData.find((chapter) => {
              const missionNumber = chapter.displayOrder + 1;
              return (
                missionNumber >= 7 &&
                missionNumber <= 9 &&
                !passedMissions.has(missionNumber) &&
                chapter.topics.flatMap((topic) => topic.lessons).every(
                  (lesson) => derived[lesson.id] === "completed"
                )
              );
            });
        if (currentChapter) {
          setExpandedChapters(new Set([currentChapter.title]));
        }
      }
    };

    load();
    return () => {
      mounted = false;
    };
  }, [user, locale]);

  const firstUnlockedIncomplete = loading
    ? null
    : lessons.slice(Math.max(getCoreStartIndex(lessons, learningPath.startingLessonId), 0)).find((lesson) => {
        const status = derivedProgress?.[lesson.id];
        return status !== "locked" && status !== "completed";
      });

  const completedSlugs = useMemo(
    () =>
      new Set<string>(
        lessons.filter((lesson) => derivedProgress?.[lesson.id] === "completed").map((lesson) => lesson.slug)
      ),
    [lessons, derivedProgress]
  );
  const availableSlugs = useMemo(
    () =>
      new Set<string>(
        lessons.filter((lesson) => derivedProgress?.[lesson.id] !== "locked").map((lesson) => lesson.slug)
      ),
    [lessons, derivedProgress]
  );
  const goalRecommendedSlug =
    !loading && financialGoals && financialGoals.length > 0
      ? getGoalBasedRecommendation(financialGoals, completedSlugs, availableSlugs)
      : null;
  const goalLesson = goalRecommendedSlug
    ? lessons.find((lesson) => lesson.slug === goalRecommendedSlug) ?? null
    : null;
  const showGoalCard = goalLesson && goalLesson.slug !== firstUnlockedIncomplete?.slug;

  const toggleChapter = (title: string) => {
    setExpandedChapters((prev) => {
      return prev.has(title) ? new Set() : new Set([title]);
    });
  };

  const localizedTitle = (lesson: { title: string; titleId: string | null }) =>
    locale === "id" && lesson.titleId ? lesson.titleId : lesson.title;

  return (
    <div className="p-5 pb-28">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-foreground">{t("learn.title")}</h1>
        <p className="mt-1 text-sm text-muted-foreground">{t("learn.subtitle")}</p>
      </header>

      {recommendations.length > 0 && !loading && (
        <div className="mb-4 space-y-3">
          {recommendations.map((rec) => (
            <div
              key={rec.id}
              className="relative rounded-lg border border-primary/30 bg-primary/5 p-4 shadow-sm"
            >
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("home.recommendedForYou")}</p>
                  <p className="mt-1 font-semibold text-foreground">{rec.title}</p>
                  <p className="text-sm leading-relaxed text-muted-foreground">{rec.reason}</p>
                  <Link
                    href={`/learn/${rec.slug}`}
                    className="mt-2 inline-flex items-center gap-1 text-sm font-medium text-primary"
                  >
                    {t("learn.startLesson")} <span aria-hidden>→</span>
                  </Link>
                </div>
                <button
                  onClick={async () => {
                    await dismissRecommendation(rec.id);
                    setRecommendations((prev) => prev.filter((r) => r.id !== rec.id));
                  }}
                  className="shrink-0 rounded-md p-2 text-muted-foreground hover:bg-primary/10 hover:text-foreground"
                  aria-label={t("home.dismissRecommendation")}
                >
                  ✕
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {learningPath.assessmentScore !== null && firstUnlockedIncomplete && !loading && (
        <div
          className={`mb-4 rounded-lg border p-4 shadow-sm ${
            learningPath.foundationZeroRequired
              ? "border-primary/30 bg-primary/5"
              : "border-success/30 bg-success/5"
          }`}
        >
          <p
            className={`text-[11px] font-semibold uppercase tracking-[0.14em] ${
              learningPath.foundationZeroRequired ? "text-primary" : "text-success"
            }`}
          >
            {learningPath.foundationZeroRequired ? t("learn.needFoundation") : t("learn.readyForMore")}
          </p>
          <p className="mt-1 font-semibold text-foreground">
            {t("learn.startFrom").replace("{title}", localizedTitle(firstUnlockedIncomplete))}
          </p>
          <p className="text-sm leading-relaxed text-muted-foreground">
            {learningPath.foundationZeroRequired ? t("learn.foundationPath") : t("learn.tailoredPath")}
          </p>
          <Link
            href={`/learn/${firstUnlockedIncomplete.slug}`}
            className={`mt-2 inline-flex items-center gap-1 text-sm font-medium ${
              learningPath.foundationZeroRequired ? "text-primary" : "text-success"
            }`}
          >
            {t("learn.startLesson")} <span aria-hidden>→</span>
          </Link>
        </div>
      )}

      {showGoalCard && goalLesson && !loading && (
        <div className="mb-5 rounded-lg border border-warning/30 bg-warning/5 p-4 shadow-sm">
          <div className="flex items-start gap-3">
            <div className="mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-warning/10 text-warning">
              <QuestIcon />
            </div>
            <div className="min-w-0 flex-1">
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-warning">{t("learn.sideQuest")}</p>
              <p className="mt-1 font-semibold text-foreground">{localizedTitle(goalLesson)}</p>
              <p className="text-sm leading-relaxed text-muted-foreground">{t("learn.goalBody")}</p>
              <Link
                href={`/learn/${goalLesson.slug}`}
                className="mt-2 inline-flex items-center gap-1 text-sm font-medium text-warning"
              >
                {t("learn.startSideQuest")} <span aria-hidden>→</span>
              </Link>
            </div>
          </div>
        </div>
      )}

      {loading ? (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="h-16 animate-pulse rounded-lg bg-muted" />
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3" role="list" aria-label="Chapters">
          {chapters.map((chapter) => (
            <ChapterCard
              key={chapter.title}
              chapter={chapter}
              derivedProgress={derivedProgress}
              missionPassed={passedChapterMissions.has(chapter.displayOrder + 1)}
              isExpanded={expandedChapters.has(chapter.title)}
              onToggle={() => toggleChapter(chapter.title)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function ChapterCard({
  chapter,
  derivedProgress,
  missionPassed,
  isExpanded,
  onToggle,
}: {
  chapter: Chapter;
  derivedProgress: Record<string, LessonStatus> | null;
  missionPassed: boolean;
  isExpanded: boolean;
  onToggle: () => void;
}) {
  const { t } = useLocale();
  const completedCount = chapter.topics.reduce(
    (count, topic) =>
      count + topic.lessons.filter((lesson) => derivedProgress?.[lesson.id] === "completed").length,
    0
  );
  const isComplete = completedCount === chapter.lessonCount && chapter.lessonCount > 0;
  const displayNumber = chapter.displayOrder;
  const missionNumber = displayNumber + 1;
  const isAdvancedTrack = missionNumber >= 11;
  const needsMission = missionNumber >= 7 && missionNumber <= 11;
  const isMastered = isComplete && (!needsMission || missionPassed);
  const isLocked = chapter.topics
    .flatMap((topic) => topic.lessons)
    .every((lesson) => derivedProgress?.[lesson.id] === "locked");

  return (
    <div
      className={`overflow-hidden rounded-lg border bg-surface shadow-sm ${isAdvancedTrack ? "border-secondary/30" : "border-muted/60"}`}
      role="listitem"
    >
      <button
        onClick={isLocked ? undefined : onToggle}
        disabled={isLocked}
        className={`flex w-full items-center justify-between gap-3 p-4 text-left transition-colors ${
          isLocked ? "cursor-not-allowed" : "hover:bg-muted/20"
        }`}
        aria-expanded={isLocked ? undefined : isExpanded}
        aria-controls={isLocked ? undefined : `chapter-${chapter.title}-lessons`}
        aria-label={isLocked ? `${localizedChapterTitle(chapter.title, t)} is locked` : undefined}
      >
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2">
            <h2 className="font-semibold text-foreground">
              <span className={isAdvancedTrack ? "text-secondary" : undefined}>{String(displayNumber).padStart(2, "0")}</span> - {localizedChapterTitle(chapter.title, t)}
            </h2>
            {isMastered && <CheckIconMini className="h-4 w-4 text-success" />}
          </div>
          <p className="mt-0.5 text-xs text-muted-foreground">
            {t("learn.completedOf")
              .replace("{completed}", String(completedCount))
              .replace("{total}", String(chapter.lessonCount))}
          </p>
          {isComplete && needsMission && !missionPassed && (
            <p className="mt-1 text-xs font-medium text-warning">{t("learn.missionRequired")}</p>
          )}
        </div>
        <div className="flex shrink-0 items-center gap-2">
          <span
            className="h-1.5 w-1.5 rounded-full"
            style={{
              background: `conic-gradient(${isAdvancedTrack ? "var(--color-secondary)" : "var(--color-success)"} ${(completedCount / Math.max(1, chapter.lessonCount)) * 360}deg, var(--color-muted) 0deg)`,
            }}
          />
          {isLocked ? (
            <LockIcon className="h-4 w-4 text-muted-foreground" />
          ) : (
            <span aria-hidden="true" className="text-xl font-medium leading-none text-muted-foreground">
              {isExpanded ? "−" : "+"}
            </span>
          )}
        </div>
      </button>

      {isExpanded && (
        <div id={`chapter-${chapter.title}-lessons`} className="border-t border-muted/60">
          <div className="space-y-1 p-2">
            {chapter.topics.map((topic) =>
              topic.lessons.map((lesson) => (
                <LessonRow
                  key={lesson.id}
                  lesson={lesson}
                  status={derivedProgress?.[lesson.id] ?? "locked"}
                />
              ))
            )}
            {isComplete && needsMission && (
              <Link
                href={`/learn/mission/${chapter.displayOrder + 1}`}
                className={`mt-2 flex items-center justify-between rounded-md border px-3 py-3 text-sm font-semibold transition-colors ${
                  missionPassed
                    ? "border-success/30 bg-success/5 text-success"
                    : "border-warning/30 bg-warning/5 text-warning hover:bg-warning/10"
                }`}
              >
                <span>{missionPassed ? t("learn.missionComplete") : t("learn.startMission")}</span>
                <span aria-hidden>{missionPassed ? "✓" : "→"}</span>
              </Link>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

function LessonRow({
  lesson,
  status,
}: {
  lesson: ChapterLesson;
  status: "locked" | "available" | "in_progress" | "completed";
}) {
  const { t, locale } = useLocale();
  const isCompleted = status === "completed";
  const isLocked = status === "locked";
  const title = locale === "id" && lesson.titleId ? lesson.titleId : lesson.title;

  const content = (
    <div
      className={`flex items-center gap-3 rounded-md p-3 transition-colors ${
        isLocked ? "opacity-60" : "hover:bg-muted/30"
      }`}
    >
      <span
        className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-xs font-bold ${
          isCompleted
            ? "bg-success text-white"
            : isLocked
              ? "bg-muted text-muted-foreground"
              : "bg-primary/10 text-primary"
        }`}
      >
        {isCompleted ? "✓" : <BookIcon className="h-3.5 w-3.5" />}
      </span>

      <div className="min-w-0 flex-1">
        <h3 className={`truncate text-sm font-medium ${isLocked ? "text-muted-foreground" : "text-foreground"}`}>
          {title}
        </h3>
        <div className="mt-0.5 flex items-center gap-2 text-xs text-muted-foreground">
          <span>{lesson.estimatedMinutes} {t("learn.minutesShort")}</span>
          <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
          <span className="text-xp">{lesson.xpReward} XP</span>
        </div>
      </div>

      {isLocked && (
        <LockIcon className="h-4 w-4 shrink-0 text-muted-foreground" />
      )}
    </div>
  );

  if (isLocked) {
    return <div className="touch-target">{content}</div>;
  }

  return (
    <Link href={`/learn/${lesson.slug}`} className="block touch-target">
      {content}
    </Link>
  );
}

function BookIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
      <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
    </svg>
  );
}

function LockIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
      <path d="M7 11V7a5 5 0 0 1 10 0v4" />
    </svg>
  );
}

function CheckIconMini({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="3"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="m20 6-9 9-5-5" />
    </svg>
  );
}

function QuestIcon() {
  return (
    <svg
      className="h-5 w-5"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <circle cx="12" cy="12" r="10" />
      <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3" />
      <path d="M12 17h.01" />
    </svg>
  );
}
