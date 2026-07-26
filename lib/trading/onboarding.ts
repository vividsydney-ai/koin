import { supabase } from "@/lib/auth/client";
import { ensurePortfolio } from "@/lib/trading/client";

export const PAPER_TRADING_UNLOCK_LESSON_NUMBER = 8;

export interface TradeOnboardingStatus {
  requiredLessonsCompleted: boolean;
  completedLessonSlugs: string[];
  onboardingCompleted: boolean;
  canTrade: boolean;
}

export interface RiskProfile {
  riskScore: number;
  riskLabel: "conservative" | "moderate" | "growth" | "aggressive";
}

export async function getTradeOnboardingStatus(userId: string): Promise<TradeOnboardingStatus> {
  const [{ data: progress, error: progressError }, { data: settings, error: settingsError }] =
    await Promise.all([
      supabase
        .from("lesson_progress")
        .select("status, lessons!inner(slug, lesson_number, is_published)")
        .eq("user_id", userId)
        .eq("status", "completed"),
      supabase
        .from("user_settings")
        .select("trade_onboarding_completed")
        .eq("user_id", userId)
        .single(),
    ]);

  if (progressError) {
    console.error("getTradeOnboardingStatus progress error:", progressError.message);
  }
  if (settingsError) {
    console.error("getTradeOnboardingStatus settings error:", settingsError.message);
  }

  const completedLessonSlugs = (progress ?? []).flatMap((row: Record<string, unknown>) => {
    const lesson = row.lessons as Record<string, unknown> | null;
    if (
      lesson?.lesson_number === PAPER_TRADING_UNLOCK_LESSON_NUMBER &&
      lesson.is_published === true &&
      typeof lesson.slug === "string"
    ) {
      return [lesson.slug];
    }
    return [];
  });

  const requiredLessonsCompleted = completedLessonSlugs.length > 0;
  const onboardingCompleted = settings?.trade_onboarding_completed ?? false;

  return {
    requiredLessonsCompleted,
    completedLessonSlugs,
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

  await ensurePortfolio(userId);
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
