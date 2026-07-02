import { supabase } from "@/lib/auth/client";
import { getPortfolio, getHoldings, getMarketData } from "@/lib/trading/client";

export interface StreakSummary {
  currentStreakDays: number;
  longestStreakDays: number;
  streakStatus: "active" | "at_risk" | "frozen" | "broken";
}

export interface XpSummary {
  totalXp: number;
  currentLevel: {
    id: number;
    name: string;
    nameId: string;
    xpRequired: number;
    description: string | null;
  } | null;
  nextLevel: {
    id: number;
    name: string;
    xpRequired: number;
  } | null;
  xpIntoLevel: number;
  xpToNextLevel: number | null;
}

export interface KoinPointsSummary {
  currentBalance: number;
  lifetimeEarned: number;
}

export interface RecentBadge {
  slug: string;
  name: string;
  icon: string;
  earnedAt: string;
}

export interface ContinueLesson {
  id: string;
  slug: string;
  title: string;
  lessonNumber: number;
  status: "available" | "in_progress" | "completed";
}

export interface PortfolioSnapshot {
  totalValue: number;
  totalReturnPct: number;
  topHolding: { symbol: string; value: number } | null;
}

export interface LeaderboardEntry {
  rank: number;
  displayName: string;
  xpThisWeek: number;
  isCurrentUser: boolean;
}

export async function getStreak(userId: string): Promise<StreakSummary | null> {
  const { data, error } = await supabase
    .from("streaks")
    .select("current_streak_days, longest_streak_days, streak_status")
    .eq("user_id", userId)
    .single();

  if (error) {
    console.error("getStreak error:", error.message);
    return null;
  }

  if (!data) return { currentStreakDays: 0, longestStreakDays: 0, streakStatus: "active" };

  return {
    currentStreakDays: data.current_streak_days ?? 0,
    longestStreakDays: data.longest_streak_days ?? 0,
    streakStatus: data.streak_status as StreakSummary["streakStatus"],
  };
}

export async function getXpSummary(userId: string): Promise<XpSummary> {
  const [{ data: xpData, error: xpError }, { data: levels, error: levelsError }] = await Promise.all([
    supabase.from("xp_events").select("xp_amount").eq("user_id", userId),
    supabase.from("levels").select("id, name, name_id, xp_required, description").order("xp_required", { ascending: true }),
  ]);

  if (xpError) console.error("getXpSummary xp error:", xpError.message);
  if (levelsError) console.error("getXpSummary levels error:", levelsError.message);

  const totalXp = (xpData ?? []).reduce((sum, e) => sum + (e.xp_amount ?? 0), 0);
  const sortedLevels = (levels ?? []).sort((a, b) => a.xp_required - b.xp_required);

  let currentLevel: XpSummary["currentLevel"] = null;
  let nextLevel: XpSummary["nextLevel"] = null;

  for (let i = 0; i < sortedLevels.length; i++) {
    const level = sortedLevels[i];
    if (totalXp >= level.xp_required) {
      currentLevel = {
        id: level.id,
        name: level.name,
        nameId: level.name_id,
        xpRequired: level.xp_required,
        description: level.description,
      };
      const next = sortedLevels[i + 1];
      if (next) {
        nextLevel = { id: next.id, name: next.name, xpRequired: next.xp_required };
      }
    }
  }

  // If no level matched, user is below level 1; next level is the first one.
  if (!currentLevel && sortedLevels.length > 0) {
    nextLevel = { id: sortedLevels[0].id, name: sortedLevels[0].name, xpRequired: sortedLevels[0].xp_required };
  }

  const currentLevelXp = currentLevel?.xpRequired ?? 0;
  const xpIntoLevel = totalXp - currentLevelXp;
  const xpToNextLevel = nextLevel ? nextLevel.xpRequired - currentLevelXp : null;

  return {
    totalXp,
    currentLevel,
    nextLevel,
    xpIntoLevel,
    xpToNextLevel,
  };
}

export async function getKoinPointsBalance(userId: string): Promise<KoinPointsSummary> {
  const { data, error } = await supabase
    .from("koin_point_balances")
    .select("current_balance, lifetime_earned")
    .eq("user_id", userId)
    .maybeSingle();

  if (error) {
    console.error("getKoinPointsBalance error:", error.message);
    return { currentBalance: 0, lifetimeEarned: 0 };
  }

  return {
    currentBalance: data?.current_balance ?? 0,
    lifetimeEarned: data?.lifetime_earned ?? 0,
  };
}

export async function getRecentBadge(userId: string): Promise<RecentBadge | null> {
  const { data, error } = await supabase
    .from("user_badges")
    .select("earned_at, badges(slug, name, icon)")
    .eq("user_id", userId)
    .order("earned_at", { ascending: false })
    .limit(1)
    .single();

  if (error || !data) {
    if (error && error.code !== "PGRST116") console.error("getRecentBadge error:", error.message);
    return null;
  }

  const badge = (data.badges as any) ?? {};
  return {
    slug: badge.slug ?? "",
    name: badge.name ?? "",
    icon: badge.icon ?? "🏅",
    earnedAt: data.earned_at ?? new Date().toISOString(),
  };
}

export async function getContinueLesson(userId: string): Promise<ContinueLesson | null> {
  const [{ data: lessons, error: lessonsError }, { data: progress, error: progressError }] = await Promise.all([
    supabase.from("lessons").select("id, slug, title, lesson_number").eq("is_published", true).order("lesson_number", { ascending: true }),
    supabase.from("lesson_progress").select("lesson_id, status").eq("user_id", userId),
  ]);

  if (lessonsError) {
    console.error("getContinueLesson lessons error:", lessonsError.message);
    return null;
  }
  if (progressError) {
    console.error("getContinueLesson progress error:", progressError.message);
  }

  const progressMap: Record<string, string> = {};
  for (const row of progress ?? []) {
    progressMap[row.lesson_id] = row.status;
  }

  // Find the first lesson that is in_progress or available (previous completed).
  for (let i = 0; i < (lessons ?? []).length; i++) {
    const lesson = lessons![i];
    const status = progressMap[lesson.id];
    const previousCompleted = i === 0 || progressMap[lessons![i - 1].id] === "completed";

    if (status === "in_progress") {
      return {
        id: lesson.id,
        slug: lesson.slug,
        title: lesson.title,
        lessonNumber: lesson.lesson_number,
        status: "in_progress",
      };
    }

    if (!status && previousCompleted) {
      return {
        id: lesson.id,
        slug: lesson.slug,
        title: lesson.title,
        lessonNumber: lesson.lesson_number,
        status: "available",
      };
    }
  }

  // All lessons completed.
  return null;
}

export async function getPortfolioSnapshot(userId: string): Promise<PortfolioSnapshot | null> {
  const [portfolio, holdings, marketData] = await Promise.all([
    getPortfolio(userId),
    getHoldings(userId),
    getMarketData(),
  ]);

  if (!portfolio) return null;

  let holdingsValue = 0;
  let topHolding: { symbol: string; value: number } | null = null;

  for (const h of holdings) {
    const price =
      marketData.find((m) => m.symbol === h.symbol)?.closePrice ??
      h.currentPrice ??
      h.averageCost;
    const value = h.shares * price;
    holdingsValue += value;

    if (!topHolding || value > topHolding.value) {
      topHolding = { symbol: h.symbol, value };
    }
  }

  const totalValue = portfolio.cashBalance + holdingsValue;
  const totalReturnPct =
    portfolio.startingCash > 0
      ? ((totalValue - portfolio.startingCash) / portfolio.startingCash) * 100
      : 0;

  return {
    totalValue,
    totalReturnPct,
    topHolding,
  };
}

export async function getLeaderboardSnippet(_userId: string): Promise<LeaderboardEntry[]> {
  // Placeholder until social leaderboard is built.
  return [];
}
