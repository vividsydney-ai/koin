"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import { signOut } from "@/lib/auth/client";
import { getUserStats, type UserStats } from "@/lib/gamification/client";
import { getPortfolioSnapshot, type PortfolioSnapshot } from "@/lib/portfolio/client";
import { EmptyState } from "@/components/EmptyState";
import { StatCard } from "@/components/StatCard";
import { BadgeGrid } from "@/components/BadgeGrid";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import type { Locale } from "@/lib/i18n/types";
import EditProfileModal from "./EditProfileModal";

const LANGUAGE_OPTIONS: { value: Locale; label: string }[] = [
  { value: "en", label: "English" },
  { value: "id", label: "Bahasa Indonesia" },
];

export default function ProfilePage() {
  const router = useRouter();
  const { user, profile, loading: authLoading } = useAuth(true);
  const { locale, setLocale, t } = useLocale();
  const [stats, setStats] = useState<UserStats | null>(null);
  const [portfolio, setPortfolio] = useState<PortfolioSnapshot | null>(null);
  const [dataLoading, setDataLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [displayNameOverride, setDisplayNameOverride] = useState<string | null>(null);
  const displayName = displayNameOverride ?? profile?.display_name ?? user?.email ?? "Koin Learner";

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
        <div className="text-muted-foreground">{t("profile.loading")}</div>
      </div>
    );
  }

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
        <div className="min-w-0 flex-1">
          <h1 className="break-words text-2xl font-display font-bold leading-tight text-foreground text-balance">
            {displayName}
          </h1>
          <p className="text-sm text-muted-foreground">{user?.email}</p>
          {stats?.level && (
            <span className="mt-1 inline-block rounded-full bg-xp/10 px-3 py-1 text-xs font-semibold text-xp">
              Lvl {stats.level.id} · {stats.level.name}
            </span>
          )}
        </div>
        <button
          onClick={() => setIsEditing(true)}
          className="shrink-0 rounded-radius-md border border-muted bg-surface px-3 py-2 text-sm font-semibold text-foreground transition-colors hover:bg-muted/10 touch-target"
          aria-label={t("profile.edit")}
        >
          {t("profile.edit")}
        </button>
      </header>

      <section className="mb-6 grid grid-cols-3 gap-3">
        <StatCard variant="tile" label={t("profile.streak")} value={`${stats?.streakDays ?? 0}d`} tone="streak" />
        <StatCard variant="tile" label="XP" value={stats?.xp ?? 0} tone="xp" />
        <StatCard variant="tile" label="Koin" value={stats?.koinPoints ?? 0} tone="koin-points" />
      </section>

      <section className="mb-6 rounded-radius-lg border border-muted bg-surface p-5">
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          {t("profile.paperPortfolio")}
        </h2>
        {portfolio ? (
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">{t("profile.totalValue")}</span>
              <span className="text-lg font-bold">Rp {portfolio.totalValue.toLocaleString("id-ID")}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">{t("profile.cash")}</span>
              <span>Rp {portfolio.cashBalance.toLocaleString("id-ID")}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">{t("profile.return")}</span>
              <span className={portfolio.returnPct >= 0 ? "text-success" : "text-danger"}>
                {portfolio.returnPct >= 0 ? "+" : ""}
                {portfolio.returnPct.toFixed(2)}%
              </span>
            </div>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            {t("profile.noPortfolio")}
          </p>
        )}
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          {t("profile.badges")}
        </h2>
        {stats?.badges && stats.badges.length > 0 ? (
          <BadgeGrid badges={stats.badges} />
        ) : (
          <EmptyState
            icon="🏅"
            title="No badges yet"
            description="Complete lessons, hit streaks, and make your first trade to earn badges."
            action={{ label: "Start learning", href: "/learn" }}
          />
        )}
      </section>

      <section className="mb-8 rounded-radius-lg border border-muted bg-surface p-5">
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
          {t("settings.title")}
        </h2>
        <div className="flex items-center justify-between gap-3">
          <span className="text-sm font-medium text-foreground">{t("settings.language")}</span>
          <div
            role="group"
            aria-label={t("settings.language")}
            className="flex rounded-radius-md border border-muted bg-background p-1"
          >
            {LANGUAGE_OPTIONS.map((option) => (
              <button
                key={option.value}
                onClick={() => setLocale(option.value)}
                aria-pressed={locale === option.value}
                className={`min-h-[44px] rounded-radius-sm px-4 text-sm font-semibold transition-colors ${
                  locale === option.value
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                {option.label}
              </button>
            ))}
          </div>
        </div>
      </section>

      <button
        onClick={handleLogout}
        className="w-full rounded-radius-md border border-danger/30 bg-surface py-3 font-semibold text-danger hover:bg-danger/5 touch-target"
      >
        {t("profile.logout")}
      </button>

      {isEditing && user && (
        <EditProfileModal
          userId={user.id}
          currentDisplayName={displayName}
          onClose={() => setIsEditing(false)}
          onSaved={(newDisplayName) => {
            setDisplayNameOverride(newDisplayName);
            setIsEditing(false);
          }}
        />
      )}
    </div>
  );
}
