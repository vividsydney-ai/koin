"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import { supabase, signOut } from "@/lib/auth/client";
import { getUserStats, type UserStats } from "@/lib/gamification/client";
import { getPortfolioSnapshot, type PortfolioSnapshot } from "@/lib/portfolio/client";

export default function ProfilePage() {
  const router = useRouter();
  const { user, profile, loading: authLoading } = useAuth(true);
  const [stats, setStats] = useState<UserStats | null>(null);
  const [portfolio, setPortfolio] = useState<PortfolioSnapshot | null>(null);
  const [dataLoading, setDataLoading] = useState(true);

  useEffect(() => {
    if (!user) return;

    let mounted = true;
    const load = async () => {
      setDataLoading(true);
      const [userStats, snapshot] = await Promise.all([
        getUserStats(user.id),
        getPortfolioSnapshot(user.id),
      ]);
      if (!mounted) return;
      setStats(userStats);
      setPortfolio(snapshot);
      setDataLoading(false);
    };

    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  const handleLogout = async () => {
    await signOut();
    router.replace("/login");
  };

  if (authLoading || dataLoading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center p-6">
        <div className="text-muted-foreground">Loading profile…</div>
      </div>
    );
  }

  const displayName = profile?.display_name ?? user?.email ?? "Koin Learner";
  const initials = displayName
    .split(" ")
    .map((n) => n[0])
    .slice(0, 2)
    .join("")
    .toUpperCase();

  return (
    <div className="mx-auto max-w-md p-6 pb-32">
      <header className="mb-8 flex items-center gap-4">
        <div className="flex h-20 w-20 items-center justify-center rounded-full bg-primary text-2xl font-bold text-primary-foreground">
          {initials}
        </div>
        <div>
          <h1 className="text-2xl font-display font-bold text-foreground">{displayName}</h1>
          <p className="text-sm text-muted-foreground">{user?.email}</p>
          {stats?.level && (
            <span className="mt-1 inline-block rounded-full bg-xp/10 px-3 py-1 text-xs font-semibold text-xp">
              Lvl {stats.level.id} · {stats.level.name}
            </span>
          )}
        </div>
      </header>

      <section className="mb-6 grid grid-cols-3 gap-3">
        <StatCard label="Streak" value={`${stats?.streakDays ?? 0}d`} tone="streak" />
        <StatCard label="XP" value={stats?.xp ?? 0} tone="xp" />
        <StatCard label="Koin" value={stats?.koinPoints ?? 0} tone="koin-points" />
      </section>

      <section className="mb-6 rounded-radius-lg border border-muted bg-surface p-5">
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          Paper Portfolio
        </h2>
        {portfolio ? (
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">Total value</span>
              <span className="text-lg font-bold">Rp {portfolio.totalValue.toLocaleString("id-ID")}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">Cash</span>
              <span>Rp {portfolio.cashBalance.toLocaleString("id-ID")}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">Return</span>
              <span className={portfolio.returnPct >= 0 ? "text-success" : "text-danger"}>
                {portfolio.returnPct >= 0 ? "+" : ""}
                {portfolio.returnPct.toFixed(2)}%
              </span>
            </div>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            No portfolio yet. Start paper trading from the Trade tab.
          </p>
        )}
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          Badges
        </h2>
        {stats?.badges && stats.badges.length > 0 ? (
          <div className="flex flex-wrap gap-2">
            {stats.badges.map((badge) => (
              <span
                key={badge.slug}
                title={badge.description ?? badge.name}
                className="inline-flex items-center gap-1 rounded-full bg-muted px-3 py-1.5 text-sm"
              >
                <span>{badge.icon}</span>
                <span>{badge.name}</span>
              </span>
            ))}
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            Complete lessons, hit streaks, and make your first trade to earn badges.
          </p>
        )}
      </section>

      <button
        onClick={handleLogout}
        className="w-full rounded-radius-md border border-danger/30 bg-surface py-3 font-semibold text-danger hover:bg-danger/5 touch-target"
      >
        Log out
      </button>
    </div>
  );
}

function StatCard({
  label,
  value,
  tone,
}: {
  label: string;
  value: string | number;
  tone: "streak" | "xp" | "koin-points";
}) {
  const toneClasses = {
    streak: "bg-streak/10 text-streak",
    xp: "bg-xp/10 text-xp",
    "koin-points": "bg-koin-points/10 text-koin-points",
  };

  return (
    <div className={`rounded-radius-lg p-4 text-center ${toneClasses[tone]}`}>
      <div className="text-xl font-bold">{value}</div>
      <div className="text-xs font-medium opacity-80">{label}</div>
    </div>
  );
}
