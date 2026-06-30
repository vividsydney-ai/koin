import { supabase } from "@/lib/auth/client";
import type { Database } from "@/types/supabase";

export type Profile = Database["public"]["Tables"]["profiles"]["Row"];
export type UserSettings = Database["public"]["Tables"]["user_settings"]["Row"];

export async function getProfile(userId: string): Promise<Profile | null> {
  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", userId)
    .single();

  if (error) {
    console.error("getProfile error:", error.message);
    return null;
  }

  return data;
}

export async function completeOnboarding(input: {
  userId: string;
  displayName: string;
  ageRange: string;
  financialGoal: string;
  notificationsEnabled: boolean;
}): Promise<{ error?: string }> {
  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      display_name: input.displayName,
      age_range: input.ageRange,
      financial_goal: input.financialGoal,
      onboarding_completed: true,
      updated_at: new Date().toISOString(),
    })
    .eq("id", input.userId);

  if (profileError) {
    console.error("completeOnboarding profile error:", profileError.message);
    return { error: profileError.message };
  }

  const { error: settingsError } = await supabase
    .from("user_settings")
    .update({
      notifications_enabled: input.notificationsEnabled,
      updated_at: new Date().toISOString(),
    })
    .eq("user_id", input.userId);

  if (settingsError) {
    console.error("completeOnboarding settings error:", settingsError.message);
    return { error: settingsError.message };
  }

  return {};
}
