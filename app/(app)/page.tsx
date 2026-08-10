"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import {
  getStreak,
  getXpSummary,
  getKoinPointsBalance,
  getRecentBadge,
  getContinueLesson,
  getPortfolioSnapshot,
  getLeaderboardSnippet,
  type StreakSummary,
  type XpSummary,
  type KoinPointsSummary,
  type RecentBadge,
  type ContinueDestination,
  type PortfolioSnapshot,
  type LeaderboardEntry,
} from "@/lib/home/client";
import { ProgressCardModal } from "@/components/ProgressCard";
import { EmptyState } from "@/components/EmptyState";
import { StatCard, type StatCardTone } from "@/components/StatCard";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import {
  getLessonRecommendations,
  checkAdaptiveTriggers,
  dismissRecommendation,
  type LessonRecommendation,
} from "@/lib/adaptive/client";
import { getDailyFocusChallenge, getLocalTimeZone, type DailyFocusState } from "@/lib/focus/client";
import {
  getDueLessonRecallPrompt,
  submitLessonRecallAnswer,
  type LessonRecallPrompt,
} from "@/lib/lessons/recall";

export default function Home() {
  const { user, profile, loading: authLoading } = useAuth(true);
  const pathname = usePathname();
  const { locale, t } = useLocale();
  const [streak, setStreak] = useState<StreakSummary | null>(null);
  const [xp, setXp] = useState<XpSummary | null>(null);
  const [koinPoints, setKoinPoints] = useState<KoinPointsSummary | null>(null);
  const [recentBadge, setRecentBadge] = useState<RecentBadge | null>(null);
  const [continueLesson, setContinueLesson] = useState<ContinueDestination | null>(null);
  const [portfolio, setPortfolio] = useState<PortfolioSnapshot | null>(null);
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [recommendations, setRecommendations] = useState<LessonRecommendation[]>([]);
  const [dailyFocus, setDailyFocus] = useState<DailyFocusState | null>(null);
  const [recallPrompt, setRecallPrompt] = useState<LessonRecallPrompt | null>(null);
  const [loading, setLoading] = useState(true);
  const [showProgressCard, setShowProgressCard] = useState(false);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user) return;
      setLoading(true);
      const [streakData, xpData, kpData, badgeData, lessonData, portfolioData, leaderboardData, focusData, recallData] = await Promise.all([
        getStreak(user.id),
        getXpSummary(user.id),
        getKoinPointsBalance(user.id),
        getRecentBadge(user.id),
        getContinueLesson(user.id),
        getPortfolioSnapshot(user.id),
        getLeaderboardSnippet(user.id),
        getDailyFocusChallenge(getLocalTimeZone()),
        getDueLessonRecallPrompt(locale),
      ]);

      // Refresh adaptive recommendations in the background (inactivity / drawdown checks).
      await checkAdaptiveTriggers();
      const recommendationData = await getLessonRecommendations(user.id, locale);

      if (!mounted) return;
      setStreak(streakData);
      setXp(xpData);
      setKoinPoints(kpData);
      setRecentBadge(badgeData);
      setContinueLesson(lessonData);
      setPortfolio(portfolioData);
      setLeaderboard(leaderboardData);
      setDailyFocus(focusData);
      setRecallPrompt(recallData);
      setRecommendations(recommendationData);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [user, pathname, locale]);

  const isLoading = authLoading || loading;

  return (
    <div className="min-h-screen bg-background p-5 pb-28">
      <header className="mb-6 flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <p className="text-sm text-muted-foreground">{t("home.greeting")}</p>
          <h1 className="break-words text-xl font-bold leading-tight tracking-tight text-foreground text-balance sm:text-2xl">
            {profile?.display_name ?? "Learner"}
          </h1>
        </div>
        <button
          onClick={() => setShowProgressCard(true)}
          className="shrink-0 rounded-md bg-primary px-3 py-1.5 text-xs font-semibold text-primary-foreground active:opacity-90"
          aria-label={t("home.share")}
        >
          {t("home.share")}
        </button>
      </header>

      {isLoading ? (
        <div className="space-y-3">
          <div className="h-24 animate-pulse rounded-card bg-surface-inset" />
          <div className="h-32 animate-pulse rounded-card bg-surface-inset" />
          <div className="h-24 animate-pulse rounded-card bg-surface-inset" />
        </div>
      ) : (
        <div className="space-y-4 lg:grid lg:grid-cols-3 lg:gap-4 lg:space-y-0">
          <div className="space-y-4 lg:col-span-2">
            <StreakCard streak={streak} />
            <ContinueLessonCard lesson={continueLesson} />
            <DailyFocusCard focus={dailyFocus} />
            <LessonRecallCard prompt={recallPrompt} locale={locale} onComplete={() => setRecallPrompt(null)} />
            <RecommendationsCard
              recommendations={recommendations}
              portfolio={portfolio}
              missionOutstanding={continueLesson?.kind === "mission"}
              onDismiss={async (id) => {
                await dismissRecommendation(id);
                setRecommendations((prev) => prev.filter((r) => r.id !== id));
              }}
            />
            <XpLevelCard xp={xp} />
            <PortfolioCard portfolio={portfolio} />
          </div>
          <div className="space-y-4">
            <div className="grid grid-cols-2 gap-3 lg:grid-cols-1">
              <KoinPointsCard koinPoints={koinPoints} />
              <RecentBadgeCard badge={recentBadge} />
            </div>
            <LeaderboardCard entries={leaderboard} />
          </div>
        </div>
      )}

      {showProgressCard && (
        <ProgressCardModal
          data={{
            displayName: profile?.display_name ?? "Learner",
            levelName: xp?.currentLevel?.name ?? "Newbie",
            totalXp: xp?.totalXp ?? 0,
            streakDays: streak?.currentStreakDays ?? 0,
            koinPoints: koinPoints?.currentBalance ?? 0,
            portfolioReturnPct: portfolio?.totalReturnPct ?? 0,
          }}
          onClose={() => setShowProgressCard(false)}
        />
      )}
    </div>
  );
}

function LessonRecallCard({
  prompt,
  locale,
  onComplete,
}: {
  prompt: LessonRecallPrompt | null;
  locale: "en" | "id";
  onComplete: () => void;
}) {
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<{ correct: boolean; explanation: string } | null>(null);
  if (!prompt) return null;

  const copy = locale === "id"
    ? {
        kicker: "Latihan ingatan · opsional",
        title: "Mari ingat kembali",
        body: "Coba jawab tanpa membuka pelajaran. Ini tidak memengaruhi XP atau progresmu.",
        correct: "Tepat.",
        retry: "Belum tepat — coba lagi.",
        done: "Selesai",
      }
    : {
        kicker: "Recall practice · optional",
        title: "A quick check-in",
        body: "Try this without reopening the lesson. It does not affect XP or progress.",
        correct: "That’s right.",
        retry: "Not quite — try again.",
        done: "Done",
      };

  const answer = async (optionId: string) => {
    setSubmitting(true);
    const submission = await submitLessonRecallAnswer(prompt.id, optionId, locale);
    setSubmitting(false);
    if (!submission) return;
    setResult({ correct: submission.correct, explanation: submission.explanation });
  };

  return (
    <article className="rounded-card border border-[var(--rup-gold-200)] bg-[var(--rup-gold-50)] p-5 shadow-sm">
      <span className="inline-flex rounded-full bg-[var(--rup-gold-100)] px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-[var(--rup-gold-700)]">{copy.kicker}</span>
      <h3 className="mt-3 font-display text-xl font-bold text-foreground">{copy.title}</h3>
      <p className="mt-1 text-sm leading-5 text-muted-foreground">{copy.body}</p>
      <p className="mt-4 text-base font-semibold leading-snug text-foreground">{prompt.question}</p>
      <div className="mt-3 grid gap-2">
        {prompt.options.map((option) => (
          <button
            key={option.id}
            type="button"
            disabled={submitting || result?.correct === true}
            onClick={() => answer(option.id)}
            className="min-h-11 rounded-lg border border-[var(--rup-gold-200)] bg-surface px-3 py-2 text-left text-sm font-semibold text-foreground transition-colors hover:border-[var(--rup-gold-400)] hover:bg-[var(--rup-gold-50)] disabled:cursor-default disabled:opacity-70 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
          >
            {option.label}
          </button>
        ))}
      </div>
      {result && (
        <div className={`mt-3 rounded-lg px-3 py-3 text-sm ${result.correct ? "bg-success/10 text-success" : "bg-surface text-foreground"}`}>
          <p className="font-bold">{result.correct ? copy.correct : copy.retry}</p>
          {result.explanation && <p className="mt-1 leading-snug">{result.explanation}</p>}
        </div>
      )}
      {result?.correct && (
        <button type="button" onClick={onComplete} className="mt-3 min-h-11 rounded-lg bg-primary px-4 text-sm font-bold text-primary-foreground">{copy.done}</button>
      )}
    </article>
  );
}

function DailyFocusCard({ focus }: { focus: DailyFocusState | null }) {
  if (!focus) return null;

  const isCompleted = focus.status === "completed";
  const isExhausted = focus.status === "exhausted";
  const progressLabel = isCompleted
    ? "Completed for today"
    : isExhausted
      ? "Focus spent for today"
      : `Question ${Math.min(focus.questionsAnswered + 1, 5)} of 5`;

  return (
    <Link href="/focus" className="block">
      <article className="rounded-card border border-primary/20 bg-[color-mix(in_srgb,var(--color-primary)_6%,var(--color-surface))] p-5 shadow-sm transition-colors hover:bg-[color-mix(in_srgb,var(--color-primary)_9%,var(--color-surface))]">
        <div className="flex items-start justify-between gap-4">
          <div className="min-w-0">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
              <FocusIcon className="h-3.5 w-3.5" /> Optional daily practice
            </span>
            <h3 className="mt-3 font-display text-xl font-bold text-foreground">Daily Focus</h3>
            <p className="mt-1 text-sm leading-5 text-muted-foreground">
              {isCompleted
                ? "Five money checks done. +20 Koin Points earned."
                : isExhausted
                  ? "Refill once with 50 Koin Points, or return tomorrow."
                  : "Five quick checks. A wrong answer uses one Focus — never lesson progress."}
            </p>
          </div>
          <FocusPips remaining={focus.focusRemaining} max={focus.maxFocus} />
        </div>
        <div className="mt-4 flex items-center justify-between gap-3 text-xs font-bold">
          <span className={isCompleted ? "text-success" : isExhausted ? "text-danger" : "text-primary"}>{progressLabel}</span>
          <span className="text-warning">{focus.fourthFocusUnlocked ? "4 Focus unlocked" : `${focus.missionsCompletedThisWeek}/5 missions`}</span>
        </div>
      </article>
    </Link>
  );
}

function FocusPips({ remaining, max }: { remaining: number; max: number }) {
  return (
    <div className="flex shrink-0 gap-1" aria-label={`${remaining} of ${max} Focus remaining`}>
      {Array.from({ length: max }, (_, index) => (
        <span key={index} className={`flex h-7 w-7 items-center justify-center rounded-md border ${index < remaining ? "border-primary/30 bg-primary text-primary-foreground" : "border-muted bg-surface text-muted-foreground"}`}>
          <FocusIcon className="h-3.5 w-3.5" />
        </span>
      ))}
    </div>
  );
}

function StreakCard({ streak }: { streak: StreakSummary | null }) {
  const { t } = useLocale();
  const days = streak?.currentStreakDays ?? 0;
  const status = streak?.streakStatus ?? "active";
  const atRisk = status === "at_risk";
  const frozen = status === "frozen";
  const broken = status === "broken";

  let statusText = t("home.streak.keepLearning");
  if (broken) statusText = t("home.streak.broken");
  else if (frozen) statusText = t("home.streak.frozen");
  else if (atRisk) statusText = t("home.streak.atRisk");

  const tone: StatCardTone = broken ? "danger" : atRisk ? "warning" : frozen ? "info" : "streak";
  const statusColor = atRisk || broken ? "text-danger" : frozen ? "text-info" : "text-muted-foreground";

  return (
    <StatCard
      label={t("home.streak.label")}
      value={`${days} day${days === 1 ? "" : "s"}`}
      tone={tone}
      icon={
        broken ? (
          <BrokenHeartIcon className="h-6 w-6" />
        ) : atRisk ? (
          <WarningIcon className="h-6 w-6" />
        ) : frozen ? (
          <SnowflakeIcon className="h-6 w-6" />
        ) : (
          <FlameIcon className="h-6 w-6" />
        )
      }
      sublabel={
        <p className={`mt-1 text-xs font-medium ${statusColor}`}>{statusText}</p>
      }
    />
  );
}

function ContinueLessonCard({ lesson }: { lesson: ContinueDestination | null }) {
  const { t, locale } = useLocale();
  if (!lesson) {
    return (
      <EmptyState
        icon="📚"
        title={t("home.allLessonsCompleted")}
        description={t("home.allLessonsCompletedBody")}
        action={{ label: t("home.browseLibrary"), href: "/library" }}
      />
    );
  }

  if (lesson.kind === "mission") {
    return (
      <Link href={`/learn/mission/${lesson.chapterNumber}`} className="block">
        <article
          className="relative overflow-hidden rounded-card border border-primary/30 p-5 shadow-sm transition-colors hover:bg-[color-mix(in_srgb,var(--color-primary)_5%,var(--color-surface))]"
          style={{ background: "color-mix(in srgb, var(--color-primary) 6%, var(--color-surface))" }}
        >
          <div className="relative flex items-center justify-between gap-4">
            <div className="min-w-0">
              <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
                <PlayIcon className="h-3.5 w-3.5" />
                {t("home.moneyMission")}
              </span>
              <h3 className="mt-3 font-display text-xl font-bold text-foreground">
                {t("home.chapterMission").replace("{chapterNumber}", String(lesson.chapterNumber).padStart(2, "0"))}
              </h3>
              <p className="mt-1 text-sm text-muted-foreground">{lesson.chapterTitle}</p>
            </div>
            <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-sm">
              <ArrowRightIcon className="h-5 w-5" />
            </span>
          </div>
        </article>
      </Link>
    );
  }

  const label = lesson.status === "in_progress" ? t("home.continueLesson") : t("home.startTodaysLesson");
  const title = locale === "id" && lesson.titleId ? lesson.titleId : lesson.title;

  return (
    <Link href={`/learn/${lesson.slug}`} className="block">
      <article
        className="relative overflow-hidden rounded-card border border-primary/30 p-5 shadow-sm transition-colors hover:bg-[color-mix(in_srgb,var(--color-primary)_5%,var(--color-surface))]"
        style={{ background: "color-mix(in srgb, var(--color-primary) 6%, var(--color-surface))" }}
      >
        <div className="relative flex items-center justify-between gap-4">
          <div className="min-w-0">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
              <PlayIcon className="h-3.5 w-3.5" />
              {label}
            </span>
            <h3 className="mt-3 font-display text-xl font-bold text-foreground">{title}</h3>
            <p className="mt-1 text-sm text-muted-foreground">
              {lesson.chapterNumber !== null && lesson.chapterLessonNumber !== null
                ? t("home.chapterLessonLabel")
                    .replace("{chapterNumber}", String(lesson.chapterNumber).padStart(2, "0"))
                    .replace("{lessonNumber}", String(lesson.chapterLessonNumber))
                : `${t("lesson.lessonWord")} ${lesson.lessonNumber}`}
            </p>
          </div>
          <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-sm">
            <ArrowRightIcon className="h-5 w-5" />
          </span>
        </div>
      </article>
    </Link>
  );
}

function XpLevelCard({ xp }: { xp: XpSummary | null }) {
  const { t, locale } = useLocale();
  const current = xp?.currentLevel;
  const next = xp?.nextLevel;
  const progress = xp && xp.xpToNextLevel ? Math.min(100, Math.round((xp.xpIntoLevel / xp.xpToNextLevel) * 100)) : 0;
  const currentName = current ? (locale === "id" && current.nameId ? current.nameId : current.name) : t("home.level");
  const nextName = next ? (locale === "id" && next.nameId ? next.nameId : next.name) : null;

  return (
    <StatCard
      label={t("home.level")}
      value={currentName}
      tone="xp"
      sublabel={
        <p className="mt-1 text-xs font-medium text-muted-foreground">
          {t("home.totalXp").replace("{xp}", String(xp?.totalXp ?? 0))}
        </p>
      }
      aside={
        nextName ? (
          <div className="shrink-0 text-right">
            <p className="text-xs text-muted-foreground">{t("home.nextLevel").replace("{name}", nextName)}</p>
            <p className="text-xs font-semibold text-xp">
              {t("home.xpProgress")
                .replace("{current}", String(xp?.xpIntoLevel ?? 0))
                .replace("{target}", String(xp?.xpToNextLevel ?? 0))}
            </p>
          </div>
        ) : undefined
      }
      progress={next ? { percent: progress } : undefined}
    >
      {current?.description && <p className="mt-2 text-xs italic text-muted-foreground">{current.description}</p>}
    </StatCard>
  );
}

function KoinPointsCard({ koinPoints }: { koinPoints: KoinPointsSummary | null }) {
  const { t } = useLocale();
  const balance = koinPoints?.currentBalance ?? 0;

  return (
    <StatCard
      label={t("home.koinPoints")}
      value={balance.toLocaleString("id-ID")}
      tone="koin-points"
      sublabel={
        <p className="mt-1 text-xs font-medium text-muted-foreground">{t("home.koinPointsBody")}</p>
      }
    />
  );
}

function RecentBadgeCard({ badge }: { badge: RecentBadge | null }) {
  const { t } = useLocale();
  if (!badge) {
    return (
      <EmptyState
        icon="🏅"
        title={t("home.noBadges")}
        description={t("home.noBadgesBody")}
        action={{ label: t("home.startLearning"), href: "/learn" }}
      />
    );
  }

  return (
    <article className="rounded-card border border-border/60 bg-surface p-4 shadow-sm">
      <span className="inline-flex items-center gap-1.5 rounded-full bg-koin-points/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-koin-points">
        <MedalIcon className="h-3.5 w-3.5" />
        {t("home.latestBadge")}
      </span>
      <div className="mt-3 flex items-center gap-3">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[color-mix(in_srgb,var(--color-koin-points)_12%,var(--color-surface))] text-koin-points">
          <MedalIcon className="h-5 w-5" />
        </div>
        <p className="text-sm font-semibold text-foreground">{badge.name}</p>
      </div>
    </article>
  );
}

function PortfolioCard({ portfolio }: { portfolio: PortfolioSnapshot | null }) {
  const { t } = useLocale();
  if (!portfolio) {
    return (
      <EmptyState
        icon="📈"
        title={t("home.startPaperTrading")}
        description={t("home.portfolioEmptyBody")}
        action={{ label: t("home.goToTrade"), href: "/trade" }}
      />
    );
  }

  const positive = portfolio.totalReturnAmount >= 0;
  const cashPct = portfolio.totalValue > 0 ? (portfolio.cashBalance / portfolio.totalValue) * 100 : 0;
  const updatedAt = new Intl.DateTimeFormat(undefined, { day: "numeric", month: "short" }).format(
    new Date(portfolio.updatedAt)
  );

  return (
    <Link href="/trade" className="block">
      <article className="rounded-card border border-muted bg-surface p-4 shadow-sm transition-colors hover:bg-muted/20">
        <div className="flex items-start justify-between gap-4">
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              {t("home.portfolioPulse")}
            </p>
            <p className="mt-1 text-2xl font-bold tracking-tight text-foreground">
              Rp {portfolio.totalValue.toLocaleString("id-ID")}
            </p>
            <p className={`mt-1 text-xs font-semibold ${positive ? "text-success" : "text-danger"}`}>
              {positive ? "+" : ""}Rp {Math.abs(portfolio.totalReturnAmount).toLocaleString("id-ID")} ({positive ? "+" : ""}{portfolio.totalReturnPct.toFixed(1)}%)
            </p>
          </div>
          <div className="text-right">
            <p className="text-xs text-muted-foreground">{t("home.updated")}</p>
            <p className="text-sm font-semibold text-foreground">{updatedAt}</p>
          </div>
        </div>
        <div className="mt-4 grid grid-cols-2 gap-4 border-t border-muted pt-3 text-sm">
          <div>
            <p className="text-xs text-muted-foreground">{t("home.cash")}</p>
            <p className="mt-0.5 font-semibold text-foreground">Rp {portfolio.cashBalance.toLocaleString("id-ID")}</p>
            <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-muted" aria-label={`${cashPct.toFixed(0)}% cash`}>
              <div className="h-full rounded-full bg-primary" style={{ width: `${cashPct}%` }} />
            </div>
          </div>
          <div>
            <p className="text-xs text-muted-foreground">{t("home.topHolding")}</p>
            <p className="mt-0.5 font-semibold text-foreground">{portfolio.topHolding?.symbol ?? "—"}</p>
            <p className="mt-1 text-xs text-muted-foreground">
              {portfolio.topHoldingPct === null ? "—" : `${portfolio.topHoldingPct.toFixed(0)}% ${t("home.ofPortfolio")}`}
            </p>
          </div>
        </div>
      </article>
    </Link>
  );
}

// Top-3 rank tints — color-mix against surface per DESIGN.md (never raw -50 backgrounds).
const RANK_TIER_STYLES: Record<number, { badge: string; label: string }> = {
  1: {
    badge:
      "bg-[color-mix(in_srgb,var(--rup-gold-500)_22%,var(--color-surface))] text-[var(--rup-gold-700)]",
    label: "gold",
  },
  2: {
    badge:
      "bg-[color-mix(in_srgb,var(--rup-grey-500)_18%,var(--color-surface))] text-[var(--rup-grey-700)]",
    label: "silver",
  },
  3: {
    badge:
      "bg-[color-mix(in_srgb,var(--rup-brown-400)_24%,var(--color-surface))] text-[var(--rup-brown-700)]",
    label: "bronze",
  },
};

function LeaderboardCard({ entries }: { entries: LeaderboardEntry[] }) {
  const { t } = useLocale();
  if (entries.length === 0) {
    return (
      <EmptyState
        icon="🏆"
        title={t("home.noFriendsOnBoard")}
        description={t("home.inviteFriendsBody")}
        action={{ label: t("home.inviteFriends"), href: "/friends" }}
      />
    );
  }

  return (
    <article className="rounded-card border border-muted bg-surface p-4 shadow-sm">
      <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
        <TrophyIcon className="h-3.5 w-3.5" />
        {t("home.weeklyLeaderboard")}
      </span>
      <ol className="mt-3 space-y-1">
        {entries.map((entry) => {
          const tier = RANK_TIER_STYLES[entry.rank];
          return (
            <li
              key={entry.displayName + entry.rank}
              data-rank={entry.rank}
              data-tier={tier?.label}
              data-current-user={entry.isCurrentUser || undefined}
              className={`flex min-h-11 items-center gap-3 rounded-md px-2 py-1.5 ${
                entry.isCurrentUser
                  ? "bg-[color-mix(in_srgb,var(--color-primary)_8%,var(--color-surface))]"
                  : ""
              }`}
            >
              <span
                className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-xs font-bold ${
                  tier ? tier.badge : "bg-muted text-muted-foreground"
                }`}
                aria-label={`Rank ${entry.rank}`}
              >
                {entry.rank}
              </span>
              <span
                aria-hidden="true"
                className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[color-mix(in_srgb,var(--color-primary)_10%,var(--color-surface))] text-xs font-bold text-primary"
              >
                {initials(entry.displayName)}
              </span>
              <span className="flex-1 truncate text-sm font-semibold text-foreground">
                {entry.displayName}
                {entry.isCurrentUser && (
                  <span className="ml-1.5 text-xs font-medium text-primary">{t("friends.you")}</span>
                )}
              </span>
              <span className="text-sm font-semibold tabular-nums text-xp">
                {entry.xpThisWeek.toLocaleString("id-ID")} {t("home.weeklyXp")}
              </span>
            </li>
          );
        })}
      </ol>
    </article>
  );
}

function RecommendationsCard({
  recommendations,
  portfolio,
  missionOutstanding,
  onDismiss,
}: {
  recommendations: LessonRecommendation[];
  portfolio: PortfolioSnapshot | null;
  missionOutstanding: boolean;
  onDismiss: (id: string) => void;
}) {
  const { t } = useLocale();
  if (missionOutstanding) return null;

  const recommendation = recommendations.find((candidate) => {
    if (candidate.trigger?.type !== "portfolio_event") return true;
    const threshold = candidate.trigger.thresholdPct ?? 10;
    if (candidate.trigger.event === "drawdown") return Boolean(portfolio && portfolio.totalReturnPct <= -threshold);
    if (candidate.trigger.event === "concentrated_holding") return Boolean(portfolio?.topHoldingPct && portfolio.topHoldingPct > threshold);
    return true;
  });

  if (!recommendation) return null;
  const isPortfolioAction = recommendation.trigger?.type === "portfolio_event";
  const href = isPortfolioAction ? "/trade" : `/learn/${recommendation.slug}`;
  const actionLabel = isPortfolioAction ? t("home.reviewPortfolio") : t("learn.startLesson");

  return (
    <article className="rounded-card border border-muted bg-surface p-5 shadow-sm">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
            <SparkleIcon className="h-3.5 w-3.5" />
            {t("home.recommendedForYou")}
          </span>
          <h4 className="mt-3 font-display text-base font-bold text-foreground">{recommendation.title}</h4>
          <p className="mt-1 text-sm leading-relaxed text-muted-foreground">{recommendation.reason}</p>
          <Link href={href} className="mt-3 inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline">
            {actionLabel} <ArrowRightIcon className="h-4 w-4" />
          </Link>
        </div>
        <button
          onClick={() => onDismiss(recommendation.id)}
          className="shrink-0 rounded-md p-2 text-muted-foreground transition-colors hover:bg-muted/30 hover:text-foreground"
          aria-label={t("home.dismissRecommendation")}
        >
          <XIcon className="h-4 w-4" />
        </button>
      </div>
    </article>
  );
}

function initials(name: string): string {
  return (
    name
      .split(" ")
      .map((n) => n[0])
      .join("")
      .slice(0, 2)
      .toUpperCase() || "?"
  );
}

function ArrowRightIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  );
}

function PlayIcon({ className = "h-5 w-5" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor">
      <path d="M8 5v14l11-7z" />
    </svg>
  );
}

function SparkleIcon({ className = "h-5 w-5" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 2 14.5 9.5H22l-6 4.5 2.5 7.5-6.5-5-6.5 5 2.5-7.5-6-4.5h7.5z" />
    </svg>
  );
}

function FocusIcon({ className = "h-5 w-5" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="m12 3 2.25 6.75L21 12l-6.75 2.25L12 21l-2.25-6.75L3 12l6.75-2.25L12 3Z" />
      <circle cx="12" cy="12" r="1.5" fill="currentColor" stroke="none" />
    </svg>
  );
}

function XIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="M18 6 6 18" />
      <path d="m6 6 12 12" />
    </svg>
  );
}

function TrophyIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="M6 9H4a2 2 0 0 1-2-2V5h6" />
      <path d="M18 9h2a2 2 0 0 0 2-2V5h-6" />
      <path d="M6 9v7a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V9" />
      <path d="M12 18v3" />
      <path d="M9 21h6" />
    </svg>
  );
}

function MedalIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="m8 3 2.5 7.5H18L13.5 13 16 20.5 11 16.5 6 20.5 8.5 13 4 10.5h5.5z" />
      <circle cx="12" cy="14" r="3" />
    </svg>
  );
}

function FlameIcon({ className = "h-5 w-5" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 2c0 4-3.5 6.5-3.5 10.5 0 2.5 1.5 4.5 3.5 4.5s3.5-2 3.5-4.5C15.5 8.5 12 6 12 2Zm0 13c-1.1 0-2-.9-2-2 0-1.2.8-2 2-3.3 1.2 1.3 2 2.1 2 3.3 0 1.1-.9 2-2 2Z" />
    </svg>
  );
}

function WarningIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="m12 5 8.7 14.5H3.3L12 5Z" />
      <path d="M12 10v4" />
      <path d="M12 17h.01" />
    </svg>
  );
}

function SnowflakeIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="M12 3v18" />
      <path d="M5 6l14 12" />
      <path d="M19 6 5 18" />
      <path d="M5 12h14" />
      <path d="m8 9 4 3-4 3" />
      <path d="m16 9-4 3 4 3" />
    </svg>
  );
}

function BrokenHeartIcon({ className = "h-5 w-5" }: { className?: string }) {
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
      <path d="M12 21s-6.7-4.3-9-8.5C.7 7.5 4.3 2 9 2c1.4 0 2.7.5 3 1 .3-.5 1.6-1 3-1 4.7 0 8.3 5.5 6 10.5C18.7 16.7 12 21 12 21Z" />
      <path d="m12 7-2 4h3l-2 4" />
    </svg>
  );
}
