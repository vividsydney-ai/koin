"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
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
  type ContinueLesson,
  type PortfolioSnapshot,
  type LeaderboardEntry,
} from "@/lib/home/client";
import { ProgressCardModal, type ProgressCardData } from "@/components/ProgressCard";
import { EmptyState } from "@/components/EmptyState";
import {
  getLessonRecommendations,
  checkAdaptiveTriggers,
  dismissRecommendation,
  type LessonRecommendation,
} from "@/lib/adaptive/client";

export default function Home() {
  const { user, profile, loading: authLoading } = useAuth(true);
  const [streak, setStreak] = useState<StreakSummary | null>(null);
  const [xp, setXp] = useState<XpSummary | null>(null);
  const [koinPoints, setKoinPoints] = useState<KoinPointsSummary | null>(null);
  const [recentBadge, setRecentBadge] = useState<RecentBadge | null>(null);
  const [continueLesson, setContinueLesson] = useState<ContinueLesson | null>(null);
  const [portfolio, setPortfolio] = useState<PortfolioSnapshot | null>(null);
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [recommendations, setRecommendations] = useState<LessonRecommendation[]>([]);
  const [loading, setLoading] = useState(true);
  const [showProgressCard, setShowProgressCard] = useState(false);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user) return;
      setLoading(true);
      const [streakData, xpData, kpData, badgeData, lessonData, portfolioData, leaderboardData] = await Promise.all([
        getStreak(user.id),
        getXpSummary(user.id),
        getKoinPointsBalance(user.id),
        getRecentBadge(user.id),
        getContinueLesson(user.id),
        getPortfolioSnapshot(user.id),
        getLeaderboardSnippet(user.id),
      ]);

      // Refresh adaptive recommendations in the background (inactivity / drawdown checks).
      await checkAdaptiveTriggers();
      const recommendationData = await getLessonRecommendations(user.id);

      if (!mounted) return;
      setStreak(streakData);
      setXp(xpData);
      setKoinPoints(kpData);
      setRecentBadge(badgeData);
      setContinueLesson(lessonData);
      setPortfolio(portfolioData);
      setLeaderboard(leaderboardData);
      setRecommendations(recommendationData);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  const isLoading = authLoading || loading;

  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <header className="mb-6 flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <p className="text-sm text-muted-foreground">Good to see you,</p>
          <h1 className="break-words text-xl font-bold leading-tight tracking-tight text-foreground text-balance sm:text-2xl">
            {profile?.display_name ?? "Learner"}
          </h1>
        </div>
        <button
          onClick={() => setShowProgressCard(true)}
          className="shrink-0 rounded-radius-md bg-primary px-3 py-1.5 text-xs font-semibold text-primary-foreground active:opacity-90"
          aria-label="Share progress"
        >
          Share
        </button>
      </header>

      {isLoading ? (
        <div className="space-y-3">
          <div className="h-24 animate-pulse rounded-radius-lg bg-surface-inset" />
          <div className="h-32 animate-pulse rounded-radius-lg bg-surface-inset" />
          <div className="h-24 animate-pulse rounded-radius-lg bg-surface-inset" />
        </div>
      ) : (
        <div className="space-y-4">
          <StreakCard streak={streak} />
          <RecommendationsCard
            recommendations={recommendations}
            onDismiss={async (id) => {
              await dismissRecommendation(id);
              setRecommendations((prev) => prev.filter((r) => r.id !== id));
            }}
          />
          <ContinueLessonCard lesson={continueLesson} />
          <XpLevelCard xp={xp} />
          <div className="grid grid-cols-2 gap-3">
            <KoinPointsCard koinPoints={koinPoints} />
            <RecentBadgeCard badge={recentBadge} />
          </div>
          <PortfolioCard portfolio={portfolio} />
          <LeaderboardCard entries={leaderboard} />
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
    </main>
  );
}

function StreakCard({ streak }: { streak: StreakSummary | null }) {
  const days = streak?.currentStreakDays ?? 0;
  const status = streak?.streakStatus ?? "active";
  const atRisk = status === "at_risk";
  const frozen = status === "frozen";
  const broken = status === "broken";

  let statusText = "Keep learning daily to build it.";
  if (broken) statusText = "Streak lost. Start a new one today!";
  else if (frozen) statusText = "Freeze used — you're still in the game.";
  else if (atRisk) statusText = "Complete a lesson today to keep it alive.";

  return (
    <div className="rounded-radius-lg border border-border/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Streak</p>
          <p className="mt-1 text-2xl font-bold text-foreground">{days} day{days === 1 ? "" : "s"}</p>
          <p className={`text-xs ${atRisk || broken ? "text-danger" : frozen ? "text-warning" : "text-muted-foreground"}`}>{statusText}</p>
        </div>
        <div className={`flex h-14 w-14 items-center justify-center rounded-full text-2xl ${broken ? "bg-danger/10" : atRisk ? "bg-warning/10" : frozen ? "bg-secondary/10" : "bg-primary/10"}`}>
          {broken ? "💔" : atRisk ? "⚠️" : frozen ? "🧊" : "🔥"}
        </div>
      </div>
    </div>
  );
}

function ContinueLessonCard({ lesson }: { lesson: ContinueLesson | null }) {
  if (!lesson) {
    return (
      <EmptyState
        icon="📚"
        title="All lessons completed"
        description="You've finished every available lesson. Check the Library for more trusted sources, or replay a favorite lesson."
        action={{ label: "Browse Library", href: "/library" }}
      />
    );
  }

  const label = lesson.status === "in_progress" ? "Continue lesson" : "Start today's lesson";

  return (
    <Link href={`/learn/${lesson.slug}`} className="block">
      <div className="rounded-radius-lg border border-primary/30 bg-primary/5 p-4 shadow-sm transition-colors hover:bg-primary/10">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{label}</p>
            <p className="mt-1 font-semibold text-foreground">{lesson.title}</p>
            <p className="text-xs text-muted-foreground">Lesson {lesson.lessonNumber}</p>
          </div>
          <ArrowRightIcon />
        </div>
      </div>
    </Link>
  );
}

function XpLevelCard({ xp }: { xp: XpSummary | null }) {
  const current = xp?.currentLevel;
  const next = xp?.nextLevel;
  const progress = xp && xp.xpToNextLevel ? Math.min(100, Math.round((xp.xpIntoLevel / xp.xpToNextLevel) * 100)) : 0;

  return (
    <div className="rounded-radius-lg border border-border/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Level</p>
          <p className="mt-1 text-xl font-bold text-foreground">{current ? current.name : "Newbie"}</p>
          <p className="text-xs text-muted-foreground">{xp?.totalXp ?? 0} total XP</p>
        </div>
        {next && (
          <div className="text-right">
            <p className="text-xs text-muted-foreground">Next: {next.name}</p>
            <p className="text-xs font-medium text-secondary">{xp?.xpIntoLevel ?? 0} / {xp?.xpToNextLevel ?? 0} XP</p>
          </div>
        )}
      </div>
      {current?.description && (
        <p className="mt-2 text-xs italic text-muted-foreground">{current.description}</p>
      )}
      {next && (
        <div className="mt-3 h-2 w-full overflow-hidden rounded-full bg-surface-inset">
          <div className="h-full rounded-full bg-xp transition-all" style={{ width: `${progress}%` }} />
        </div>
      )}
    </div>
  );
}

function KoinPointsCard({ koinPoints }: { koinPoints: KoinPointsSummary | null }) {
  const balance = koinPoints?.currentBalance ?? 0;

  return (
    <div className="rounded-radius-lg border border-border/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Koin Points</p>
      <p className="mt-2 text-2xl font-bold text-foreground">{balance.toLocaleString("id-ID")}</p>
      <p className="text-xs text-muted-foreground">Earn more by ranking up.</p>
    </div>
  );
}

function RecentBadgeCard({ badge }: { badge: RecentBadge | null }) {
  if (!badge) {
    return (
      <EmptyState
        icon="🏅"
        title="No badges yet"
        description="Finish a lesson, hit a streak, or make your first trade to earn your first badge."
        action={{ label: "Start learning", href: "/learn" }}
      />
    );
  }

  return (
    <div className="rounded-radius-lg border border-border/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Latest badge</p>
      <div className="mt-2 flex items-center gap-2">
        <span className="text-2xl">{badge.icon}</span>
        <p className="text-sm font-semibold text-foreground">{badge.name}</p>
      </div>
    </div>
  );
}

function PortfolioCard({ portfolio }: { portfolio: PortfolioSnapshot | null }) {
  if (!portfolio) {
    return (
      <EmptyState
        icon="📈"
        title="Start paper trading"
        description="Your portfolio snapshot will appear here once you unlock paper trading from the Trade tab."
        action={{ label: "Go to Trade", href: "/trade" }}
      />
    );
  }

  const positive = portfolio.totalReturnPct >= 0;

  return (
    <div className="rounded-radius-lg border border-border/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Portfolio</p>
          <p className="mt-1 text-xl font-bold text-foreground">Rp {portfolio.totalValue.toLocaleString("id-ID")}</p>
          <p className={`text-xs font-medium ${positive ? "text-success" : "text-danger"}`}>
            {positive ? "+" : ""}{portfolio.totalReturnPct.toFixed(1)}%
          </p>
        </div>
        <div className="text-right">
          <p className="text-xs text-muted-foreground">Top holding</p>
          <p className="text-sm font-semibold text-foreground">{portfolio.topHolding?.symbol ?? "—"}</p>
        </div>
      </div>
    </div>
  );
}

function LeaderboardCard({ entries }: { entries: LeaderboardEntry[] }) {
  if (entries.length === 0) {
    return (
      <EmptyState
        icon="🏆"
        title="No friends on the board"
        description="Invite friends to see who tops the weekly XP and Koin Points boards."
        action={{ label: "Invite friends", href: "/friends" }}
      />
    );
  }

  return (
    <div className="rounded-radius-lg border border-border/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Weekly leaderboard</p>
      <div className="mt-3 space-y-2">
        {entries.map((entry) => (
          <div key={entry.displayName + entry.rank} className={`flex items-center justify-between rounded-radius-md px-3 py-2 ${entry.isCurrentUser ? "bg-primary/5" : "bg-background"}`}>
            <div className="flex items-center gap-3">
              <span className="flex h-6 w-6 items-center justify-center rounded-full bg-surface-inset text-xs font-bold text-muted-foreground">{entry.rank}</span>
              <span className="text-sm font-medium text-foreground">{entry.displayName}</span>
            </div>
            <span className="text-sm font-semibold text-secondary">{entry.xpThisWeek.toLocaleString("id-ID")} XP</span>
          </div>
        ))}
      </div>
    </div>
  );
}

function RecommendationsCard({
  recommendations,
  onDismiss,
}: {
  recommendations: LessonRecommendation[];
  onDismiss: (id: string) => void;
}) {
  if (recommendations.length === 0) return null;

  return (
    <div className="space-y-3">
      {recommendations.map((rec) => (
        <div
          key={rec.id}
          className="relative rounded-radius-lg border border-primary/30 bg-primary/5 p-4 shadow-sm"
        >
          <div className="flex items-start justify-between gap-3">
            <div className="min-w-0 flex-1">
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Recommended for you</p>
              <p className="mt-1 font-semibold text-foreground">{rec.title}</p>
              <p className="text-sm leading-relaxed text-muted-foreground">{rec.reason}</p>
              <Link
                href={`/learn/${rec.slug}`}
                className="mt-2 inline-flex items-center gap-1 text-sm font-medium text-primary"
              >
                Start lesson <ArrowRightIcon />
              </Link>
            </div>
            <button
              onClick={() => onDismiss(rec.id)}
              className="shrink-0 rounded-radius-md p-2 text-muted-foreground hover:bg-primary/10 hover:text-foreground"
              aria-label="Dismiss recommendation"
            >
              ✕
            </button>
          </div>
        </div>
      ))}
    </div>
  );
}

function ArrowRightIcon() {
  return (
    <svg className="h-5 w-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  );
}
