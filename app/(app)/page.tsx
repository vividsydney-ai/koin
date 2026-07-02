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

export default function Home() {
  const { user, profile, loading: authLoading } = useAuth(true);
  const [streak, setStreak] = useState<StreakSummary | null>(null);
  const [xp, setXp] = useState<XpSummary | null>(null);
  const [koinPoints, setKoinPoints] = useState<KoinPointsSummary | null>(null);
  const [recentBadge, setRecentBadge] = useState<RecentBadge | null>(null);
  const [continueLesson, setContinueLesson] = useState<ContinueLesson | null>(null);
  const [portfolio, setPortfolio] = useState<PortfolioSnapshot | null>(null);
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);

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
      if (!mounted) return;
      setStreak(streakData);
      setXp(xpData);
      setKoinPoints(kpData);
      setRecentBadge(badgeData);
      setContinueLesson(lessonData);
      setPortfolio(portfolioData);
      setLeaderboard(leaderboardData);
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
      <header className="mb-6">
        <p className="text-sm text-muted-foreground">Good to see you,</p>
        <h1 className="text-2xl font-bold tracking-tight text-foreground">
          {profile?.display_name ?? "Learner"}
        </h1>
      </header>

      {isLoading ? (
        <div className="space-y-3">
          <div className="h-24 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-32 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-24 animate-pulse rounded-radius-lg bg-muted" />
        </div>
      ) : (
        <div className="space-y-4">
          <StreakCard streak={streak} />
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
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Streak</p>
          <p className="mt-1 text-2xl font-bold text-foreground">{days} day{days === 1 ? "" : "s"}</p>
          <p className={`text-xs ${atRisk || broken ? "text-danger" : frozen ? "text-warning" : "text-muted-foreground"}`}>{statusText}</p>
        </div>
        <div className={`flex h-14 w-14 items-center justify-center rounded-full text-2xl ${broken ? "bg-danger/10" : atRisk ? "bg-warning/10" : frozen ? "bg-info/10" : "bg-streak/10"}`}>
          {broken ? "💔" : atRisk ? "⚠️" : frozen ? "🧊" : "🔥"}
        </div>
      </div>
    </div>
  );
}

function ContinueLessonCard({ lesson }: { lesson: ContinueLesson | null }) {
  if (!lesson) {
    return (
      <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Today's lesson</p>
        <p className="mt-2 text-sm text-muted-foreground">You've completed all available lessons. Nice work!</p>
      </div>
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
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Level</p>
          <p className="mt-1 text-xl font-bold text-foreground">{current ? current.name : "Newbie"}</p>
          <p className="text-xs text-muted-foreground">{xp?.totalXp ?? 0} total XP</p>
        </div>
        {next && (
          <div className="text-right">
            <p className="text-xs text-muted-foreground">Next: {next.name}</p>
            <p className="text-xs font-medium text-xp">{xp?.xpIntoLevel ?? 0} / {xp?.xpToNextLevel ?? 0} XP</p>
          </div>
        )}
      </div>
      {current?.description && (
        <p className="mt-2 text-xs italic text-muted-foreground">{current.description}</p>
      )}
      {next && (
        <div className="mt-3 h-2 w-full overflow-hidden rounded-full bg-muted">
          <div className="h-full rounded-full bg-xp transition-all" style={{ width: `${progress}%` }} />
        </div>
      )}
    </div>
  );
}

function KoinPointsCard({ koinPoints }: { koinPoints: KoinPointsSummary | null }) {
  const balance = koinPoints?.currentBalance ?? 0;

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Koin Points</p>
      <p className="mt-2 text-2xl font-bold text-foreground">{balance.toLocaleString("id-ID")}</p>
      <p className="text-xs text-muted-foreground">Earn more by ranking up.</p>
    </div>
  );
}

function RecentBadgeCard({ badge }: { badge: RecentBadge | null }) {
  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Latest badge</p>
      {badge ? (
        <div className="mt-2 flex items-center gap-2">
          <span className="text-2xl">{badge.icon}</span>
          <p className="text-sm font-semibold text-foreground">{badge.name}</p>
        </div>
      ) : (
        <p className="mt-2 text-sm text-muted-foreground">No badges yet. Finish a lesson!</p>
      )}
    </div>
  );
}

function PortfolioCard({ portfolio }: { portfolio: PortfolioSnapshot | null }) {
  if (!portfolio) {
    return (
      <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-4">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Paper trading</p>
        <p className="mt-2 text-sm text-muted-foreground">Your portfolio snapshot will appear here once paper trading launches.</p>
      </div>
    );
  }

  const positive = portfolio.totalReturnPct >= 0;

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
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
      <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-4">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Leaderboard</p>
        <p className="mt-2 text-sm text-muted-foreground">Invite friends to see who tops the weekly XP board.</p>
      </div>
    );
  }

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Weekly leaderboard</p>
      <div className="mt-3 space-y-2">
        {entries.map((entry) => (
          <div key={entry.displayName + entry.rank} className={`flex items-center justify-between rounded-radius-md px-3 py-2 ${entry.isCurrentUser ? "bg-primary/5" : "bg-background"}`}>
            <div className="flex items-center gap-3">
              <span className="flex h-6 w-6 items-center justify-center rounded-full bg-muted text-xs font-bold text-muted-foreground">{entry.rank}</span>
              <span className="text-sm font-medium text-foreground">{entry.displayName}</span>
            </div>
            <span className="text-sm font-semibold text-xp">{entry.xpThisWeek.toLocaleString("id-ID")} XP</span>
          </div>
        ))}
      </div>
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
