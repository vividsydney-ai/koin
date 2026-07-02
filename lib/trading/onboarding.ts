import { supabase } from "@/lib/auth/client";

const REQUIRED_LESSON_SLUGS = ["money-basics-101", "budgeting-101", "inflation-101"];

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
        .select("status, lessons!inner(slug)")
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

  const completedSlugs = new Set(
    (progress ?? []).map((row: any) => row.lessons?.slug).filter(Boolean)
  );

  const completedLessonSlugs: string[] = [];
  for (const slug of REQUIRED_LESSON_SLUGS) {
    if (completedSlugs.has(slug)) {
      completedLessonSlugs.push(slug);
    }
  }

  const requiredLessonsCompleted = completedLessonSlugs.length === REQUIRED_LESSON_SLUGS.length;
  const onboardingCompleted = settings?.trade_onboarding_completed ?? false;

  return {
    requiredLessonsCompleted,
    completedLessonSlugs,
    onboardingCompleted,
    canTrade: requiredLessonsCompleted && onboardingCompleted,
  };
}

export async function completeTradeOnboarding(userId: string): Promise<void> {
  const { error } = await supabase
    .from("user_settings")
    .update({ trade_onboarding_completed: true })
    .eq("user_id", userId);

  if (error) {
    console.error("completeTradeOnboarding error:", error.message);
    throw new Error(error.message);
  }
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
