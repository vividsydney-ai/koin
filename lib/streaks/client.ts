import { supabase } from "@/lib/auth/client";

export interface CheckInResult {
  currentStreakDays: number;
  longestStreakDays: number;
  streakStatus: "active" | "at_risk" | "frozen" | "broken";
  usedFreeze: boolean;
  broken: boolean;
  alreadyCheckedIn: boolean;
}

export async function checkInStreak(userId: string): Promise<CheckInResult | null> {
  const { data, error } = await supabase.rpc("check_in_streak", {
    p_user_id: userId,
  });

  if (error) {
    console.error("checkInStreak error:", error.message);
    return null;
  }

  const result = data as {
    current_streak_days: number;
    longest_streak_days: number;
    streak_status: string;
    used_freeze: boolean;
    broken: boolean;
    already_checked_in: boolean;
  };

  return {
    currentStreakDays: result.current_streak_days,
    longestStreakDays: result.longest_streak_days,
    streakStatus: result.streak_status as CheckInResult["streakStatus"],
    usedFreeze: result.used_freeze,
    broken: result.broken,
    alreadyCheckedIn: result.already_checked_in,
  };
}

export async function recomputeStreakStatus(userId: string): Promise<string | null> {
  const { data, error } = await supabase.rpc("recompute_streak_status", {
    p_user_id: userId,
  });

  if (error) {
    console.error("recomputeStreakStatus error:", error.message);
    return null;
  }

  return (data as { status: string })?.status ?? null;
}
