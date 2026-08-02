import { supabase } from "@/lib/auth/client";
import { ensurePortfolio, type Portfolio } from "@/lib/trading/client";

export const PAPER_TRADING_UNLOCK_CHAPTER = "Investing in Indonesia";
export const PAPER_TRADING_UNLOCK_CHAPTER_LABEL = "Chapter 08 — Investing in Indonesia";

export interface TradeOnboardingStatus {
  requiredLessonsCompleted: boolean;
  completedLessonSlugs: string[];
  requiredLessonCount: number;
  onboardingCompleted: boolean;
  canTrade: boolean;
}

export interface PaperPortfolioClaim {
  claimed: boolean;
  portfolio: Portfolio;
}

export interface RiskProfile {
  riskScore: number;
  riskLabel: "conservative" | "moderate" | "growth" | "aggressive";
}

export async function getTradeOnboardingStatus(userId: string): Promise<TradeOnboardingStatus> {
  const [
    { data: progress, error: progressError },
    { data: chapterLessons, error: chapterLessonsError },
    { data: settings, error: settingsError },
  ] =
    await Promise.all([
      supabase
        .from("lesson_progress")
        .select("status, lessons!inner(slug, is_published, topics!inner(chapter))")
        .eq("user_id", userId)
        .eq("status", "completed"),
      supabase
        .from("lessons")
        .select("slug, topics!inner(chapter)")
        .eq("is_published", true)
        .eq("topics.chapter", PAPER_TRADING_UNLOCK_CHAPTER),
      supabase
        .from("user_settings")
        .select("trade_onboarding_completed")
        .eq("user_id", userId)
        .single(),
    ]);

  if (progressError) {
    console.error("getTradeOnboardingStatus progress error:", progressError.message);
  }
  if (chapterLessonsError) {
    console.error("getTradeOnboardingStatus chapter lessons error:", chapterLessonsError.message);
  }
  if (settingsError) {
    console.error("getTradeOnboardingStatus settings error:", settingsError.message);
  }

  const requiredSlugs = new Set(
    (chapterLessons ?? []).flatMap((lesson: Record<string, unknown>) =>
      typeof lesson.slug === "string" ? [lesson.slug] : []
    )
  );
  const completedLessonSlugs = (progress ?? []).flatMap((row: Record<string, unknown>) => {
    const lesson = row.lessons as Record<string, unknown> | null;
    if (lesson?.is_published === true && typeof lesson.slug === "string" && requiredSlugs.has(lesson.slug)) {
      return [lesson.slug];
    }
    return [];
  });

  const requiredLessonCount = requiredSlugs.size;
  const requiredLessonsCompleted =
    requiredLessonCount > 0 && completedLessonSlugs.length === requiredLessonCount;
  const onboardingCompleted = settings?.trade_onboarding_completed ?? false;

  return {
    requiredLessonsCompleted,
    completedLessonSlugs,
    requiredLessonCount,
    onboardingCompleted,
    canTrade: requiredLessonsCompleted && onboardingCompleted,
  };
}

export async function completeTradeOnboarding(userId: string): Promise<void> {
  const { error } = await supabase.from("user_settings").upsert(
    {
      user_id: userId,
      trade_onboarding_completed: true,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id" }
  );

  if (error) {
    console.error("completeTradeOnboarding error:", error.message);
    throw new Error(error.message);
  }

  // Compatibility read for older callers. This function is now deliberately
  // non-mutating; a missing portfolio is expected until the chest is opened.
  await ensurePortfolio(userId).catch(() => undefined);

}

/**
 * Opens the one-time paper portfolio chest. The RPC is the only code path
 * allowed to create a portfolio or grant its starting balance.
 */
export async function claimPaperPortfolio(userId: string): Promise<PaperPortfolioClaim> {
  const { data, error } = await (supabase as unknown as {
    rpc: (name: string, args: Record<string, string>) => Promise<{
      data: { claimed: boolean; portfolio: Record<string, unknown> } | null;
      error: { message: string } | null;
    }>;
  }).rpc("claim_paper_portfolio", { p_user_id: userId });

  if (error || !data?.portfolio) {
    throw new Error(error?.message ?? "Your paper portfolio could not be opened");
  }

  const row = data.portfolio;
  return {
    claimed: data.claimed,
    portfolio: {
      id: String(row.id),
      userId: String(row.user_id),
      startingCash: Number(row.starting_cash),
      cashBalance: Number(row.cash_balance),
      totalValue: Number(row.total_value),
      status: row.status as Portfolio["status"],
      createdAt: String(row.created_at),
      updatedAt: String(row.updated_at),
    },
  };
}

export async function markPaperChestViewed(userId: string): Promise<void> {
  const { error } = await (supabase as unknown as {
    rpc: (name: string, args: Record<string, string>) => Promise<{ error: { message: string } | null }>;
  }).rpc("mark_paper_chest_viewed", { p_user_id: userId });

  if (error) throw new Error(error.message);
}

export async function saveRiskProfile(
  userId: string,
  profile: RiskProfile
): Promise<void> {
  const { error } = await supabase.from("user_risk_profiles").upsert(
    {
      user_id: userId,
      risk_score: profile.riskScore,
      risk_label: profile.riskLabel,
      updated_at: new Date().toISOString(),
    },
    { onConflict: "user_id" }
  );

  if (error) {
    console.error("saveRiskProfile error:", error.message);
    throw new Error(error.message);
  }
}

export async function getRiskProfile(userId: string): Promise<RiskProfile | null> {
  const { data, error } = await supabase
    .from("user_risk_profiles")
    .select("risk_score, risk_label")
    .eq("user_id", userId)
    .single();

  if (error || !data) {
    if (error && error.code !== "PGRST116") {
      console.error("getRiskProfile error:", error.message);
    }
    return null;
  }

  return {
    riskScore: data.risk_score,
    riskLabel: data.risk_label as RiskProfile["riskLabel"],
  };
}
