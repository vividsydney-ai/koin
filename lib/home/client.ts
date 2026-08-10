import { supabase } from "@/lib/auth/client";
import { getPortfolio, getHoldings, getMarketData } from "@/lib/trading/client";
import { getTradeOnboardingStatus } from "@/lib/trading/onboarding";
import { curriculumChapterNumber, orderCurriculumLessons } from "@/lib/lessons/curriculum";
import { getCoreStartIndex } from "@/lib/lessons/gating";
import { requiresChapterMission } from "@/lib/lessons/mastery";

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
    nameId: string | null;
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
  kind?: "lesson";
  id: string;
  slug: string;
  title: string;
  titleId: string | null;
  lessonNumber: number;
  chapterNumber: number | null;
  chapterLessonNumber: number | null;
  status: "available" | "in_progress" | "completed";
}

export interface ContinueMission {
  kind: "mission";
  chapterNumber: number;
  chapterTitle: string;
}

export type ContinueDestination = ContinueLesson | ContinueMission;

type ContinueLessonRow = {
  id: string;
  slug: string;
  title: string;
  title_id: string | null;
  lesson_number: number;
  topics: { chapter: string | null } | { chapter: string | null }[] | null;
};

function chapterForLesson(lesson: ContinueLessonRow): string | null {
  const topic = Array.isArray(lesson.topics) ? lesson.topics[0] : lesson.topics;
  return topic?.chapter?.trim() || null;
}

function getChapterPosition(lessons: ContinueLessonRow[], lesson: ContinueLessonRow) {
  const chapter = chapterForLesson(lesson);
  if (!chapter) return { chapterNumber: null, chapterLessonNumber: null };
  const chapterLessons = lessons
    .filter((candidate) => chapterForLesson(candidate) === chapter)
    .sort((a, b) => a.lesson_number - b.lesson_number);

  return {
    chapterNumber: curriculumChapterNumber(chapter),
    chapterLessonNumber: chapterLessons.findIndex((candidate) => candidate.id === lesson.id) + 1,
  };
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

export interface KoinPointsLeaderboardEntry {
  rank: number;
  displayName: string;
  koinPointsThisWeek: number;
  isCurrentUser: boolean;
}

export interface WeeklyLeaderboard {
  weekStart: string;
  xp: LeaderboardEntry[];
  koinPoints: KoinPointsLeaderboardEntry[];
}

export async function getStreak(userId: string): Promise<StreakSummary | null> {
  const { data, error } = await supabase
    .from("streaks")
    .select("current_streak_days, longest_streak_days, streak_status")
    .eq("user_id", userId)
    .maybeSingle();

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
        nextLevel = { id: next.id, name: next.name, nameId: next.name_id ?? null, xpRequired: next.xp_required };
      }
    }
  }

  // If no level matched, user is below level 1; next level is the first one.
  if (!currentLevel && sortedLevels.length > 0) {
    nextLevel = { id: sortedLevels[0].id, name: sortedLevels[0].name, nameId: sortedLevels[0].name_id ?? null, xpRequired: sortedLevels[0].xp_required };
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
    .maybeSingle();

  if (error) {
    console.error("getRecentBadge error:", error.message);
    return null;
  }

  if (!data) return null;

  const badges = (data.badges as Record<string, unknown>[]) ?? [];
  const badge = badges[0] ?? {};
  return {
    slug: String(badge.slug ?? ""),
    name: String(badge.name ?? ""),
    icon: String(badge.icon ?? "🏅"),
    earnedAt: data.earned_at ?? new Date().toISOString(),
  };
}

export async function getContinueLesson(userId: string): Promise<ContinueDestination | null> {
  const [{ data: lessons, error: lessonsError }, { data: progress, error: progressError }, { data: settings, error: settingsError }] = await Promise.all([
    supabase.from("lessons").select("id, slug, title, title_id, lesson_number, topics(chapter)").eq("is_published", true).order("lesson_number", { ascending: true }),
    supabase.from("lesson_progress").select("lesson_id, status").eq("user_id", userId),
    supabase.from("user_settings").select("starting_lesson_id").eq("user_id", userId).maybeSingle(),
  ]);

  if (lessonsError) {
    console.error("getContinueLesson lessons error:", lessonsError.message);
    return null;
  }
  if (progressError) {
    console.error("getContinueLesson progress error:", progressError.message);
  }
  if (settingsError) {
    console.error("getContinueLesson settings error:", settingsError.message);
  }

  const progressMap: Record<string, string> = {};
  for (const row of progress ?? []) {
    progressMap[row.lesson_id] = row.status;
  }

  const publishedLessons = orderCurriculumLessons(
    ((lessons ?? []) as ContinueLessonRow[]).map((lesson) => ({
      ...lesson,
      lessonNumber: lesson.lesson_number,
      chapter: chapterForLesson(lesson),
    }))
  );
  const startingLessonId = settings?.starting_lesson_id;
  let startIndex = getCoreStartIndex(publishedLessons, startingLessonId);

  // If the user's configured starting lesson is no longer published (e.g.
  // removed during content cleanup), fall back to the first published lesson
  // rather than showing "all completed".
  if (startingLessonId && startIndex === -1) {
    startIndex = 0;
  }

  let passedChapterMissions: Set<number> | null = null;

  const hasPassedMission = async (chapterNumber: number) => {
    if (!passedChapterMissions) {
      const { data, error } = await supabase
        .from("chapter_mission_attempts")
        .select("chapter_number")
        .eq("user_id", userId)
        .eq("passed", true);
      if (error) {
        console.error("getContinueLesson missions error:", error.message);
        passedChapterMissions = new Set();
      } else {
        passedChapterMissions = new Set((data ?? []).map((row) => Number(row.chapter_number)));
      }
    }
    return passedChapterMissions.has(chapterNumber);
  };

  const missionDestination = (chapterNumber: number, chapterTitle: string): ContinueMission => ({
    kind: "mission",
    chapterNumber,
    chapterTitle,
  });

  const isChapterComplete = (chapter: string | null) =>
    Boolean(chapter) &&
    publishedLessons
      .filter((lesson) => chapterForLesson(lesson) === chapter)
      .every((lesson) => progressMap[lesson.id] === "completed");

  // Find the first lesson at or after the user's starting point that is in_progress or available.
  for (let i = startIndex; i < publishedLessons.length; i++) {
    const lesson = publishedLessons[i];
    const status = progressMap[lesson.id];
    const previousLesson = publishedLessons[i - 1];
    const previousChapter = curriculumChapterNumber(previousLesson?.chapter ?? null);
    const crossesMissionBoundary = previousLesson?.chapter !== lesson.chapter && requiresChapterMission(previousChapter);
    const missionBlocksProgress =
      crossesMissionBoundary &&
      isChapterComplete(previousLesson?.chapter ?? null) &&
      !(await hasPassedMission(previousChapter!));

    if (missionBlocksProgress) {
      return missionDestination(previousChapter!, previousLesson!.chapter!);
    }
    const previousCompleted =
      !missionBlocksProgress &&
      (i === startIndex || progressMap[previousLesson?.id ?? ""] === "completed");

    if (status === "in_progress" && !missionBlocksProgress) {
      return {
        id: lesson.id,
        slug: lesson.slug,
        title: lesson.title,
        titleId: lesson.title_id ?? null,
        lessonNumber: lesson.lesson_number,
        ...getChapterPosition(publishedLessons, lesson),
        status: "in_progress",
      };
    }

    if (previousCompleted && status !== "completed") {
      return {
        id: lesson.id,
        slug: lesson.slug,
        title: lesson.title,
        titleId: lesson.title_id ?? null,
        lessonNumber: lesson.lesson_number,
        ...getChapterPosition(publishedLessons, lesson),
        status: (status as ContinueLesson["status"]) || "available",
      };
    }
  }

  // A mission can also be the final required step in the published sequence.
  // Never report completion while that milestone is still outstanding.
  const finalLesson = publishedLessons.at(-1);
  const finalChapterNumber = curriculumChapterNumber(finalLesson?.chapter ?? null);
  if (
    finalLesson?.chapter &&
    isChapterComplete(finalLesson.chapter) &&
    requiresChapterMission(finalChapterNumber) &&
    !(await hasPassedMission(finalChapterNumber!))
  ) {
    return missionDestination(finalChapterNumber!, finalLesson.chapter);
  }

  // All lessons completed.
  return null;
}

export async function getPortfolioSnapshot(userId: string): Promise<PortfolioSnapshot | null> {
  const tradeOnboarding = await getTradeOnboardingStatus(userId);
  if (!tradeOnboarding.canTrade) return null;

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

export async function getLeaderboardSnippet(userId: string): Promise<LeaderboardEntry[]> {
  const { data, error } = await supabase.rpc("get_weekly_leaderboard", {
    p_user_id: userId,
    p_scope: "friends",
  });

  if (error || !data) {
    console.error("getLeaderboardSnippet error:", error?.message);
    return [];
  }

  const raw = data as {
    week_start: string;
    xp: { rank: number; display_name: string; xp_this_week: number; is_current_user: boolean }[];
    koin_points: { rank: number; display_name: string; koin_points_this_week: number; is_current_user: boolean }[];
  };

  return (raw.xp ?? []).map((entry) => ({
    rank: entry.rank,
    displayName: entry.display_name,
    xpThisWeek: entry.xp_this_week,
    isCurrentUser: entry.is_current_user,
  }));
}

export async function getWeeklyLeaderboard(userId: string, scope: "global" | "friends"): Promise<WeeklyLeaderboard | null> {
  const { data, error } = await supabase.rpc("get_weekly_leaderboard", {
    p_user_id: userId,
    p_scope: scope,
  });

  if (error || !data) {
    console.error("getWeeklyLeaderboard error:", error?.message);
    return null;
  }

  const raw = data as {
    week_start: string;
    xp: { rank: number; display_name: string; xp_this_week: number; is_current_user: boolean }[];
    koin_points: { rank: number; display_name: string; koin_points_this_week: number; is_current_user: boolean }[];
  };

  return {
    weekStart: raw.week_start,
    xp: (raw.xp ?? []).map((entry) => ({
      rank: entry.rank,
      displayName: entry.display_name,
      xpThisWeek: entry.xp_this_week,
      isCurrentUser: entry.is_current_user,
    })),
    koinPoints: (raw.koin_points ?? []).map((entry) => ({
      rank: entry.rank,
      displayName: entry.display_name,
      koinPointsThisWeek: entry.koin_points_this_week,
      isCurrentUser: entry.is_current_user,
    })),
  };
}
