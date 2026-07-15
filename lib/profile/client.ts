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

export async function getUserSettings(userId: string): Promise<UserSettings | null> {
  const { data, error } = await supabase
    .from("user_settings")
    .select("*")
    .eq("user_id", userId)
    .single();

  if (error) {
    console.error("getUserSettings error:", error.message);
    return null;
  }

  return data;
}

export async function getFinancialLiteracyLevel(
  userId: string
): Promise<FinancialLiteracyLevel | null> {
  const { data, error } = await supabase
    .from("profiles")
    .select("financial_literacy_level")
    .eq("id", userId)
    .single();

  if (error) {
    console.error("getFinancialLiteracyLevel error:", error.message);
    return null;
  }

  const value = data?.financial_literacy_level;
  if (value === "beginner" || value === "intermediate" || value === "advanced") {
    return value;
  }
  return null;
}

export async function getFinancialGoals(userId: string): Promise<string[] | null> {
  const { data, error } = await supabase
    .from("profiles")
    .select("financial_goal")
    .eq("id", userId)
    .single();

  if (error) {
    console.error("getFinancialGoals error:", error.message);
    return null;
  }

  const value = data?.financial_goal;
  if (Array.isArray(value)) {
    return value.filter((g): g is string => typeof g === "string");
  }
  return null;
}

export async function updateProfile(input: {
  userId: string;
  displayName: string;
  notificationsEnabled: boolean;
}): Promise<{ error?: string }> {
  const now = new Date().toISOString();

  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      display_name: input.displayName,
      updated_at: now,
    })
    .eq("id", input.userId);

  if (profileError) {
    console.error("updateProfile profile error:", profileError.message);
    return { error: profileError.message };
  }

  const { error: settingsError } = await supabase
    .from("user_settings")
    .update({
      notifications_enabled: input.notificationsEnabled,
      updated_at: now,
    })
    .eq("user_id", input.userId);

  if (settingsError) {
    console.error("updateProfile settings error:", settingsError.message);
    return { error: settingsError.message };
  }

  return {};
}

export type FinancialLiteracyLevel = "beginner" | "intermediate" | "advanced";

export async function completeOnboarding(input: {
  userId: string;
  displayName: string;
  ageRange: string;
  financialGoals: string[];
  notificationsEnabled: boolean;
  financialLiteracyLevel?: FinancialLiteracyLevel;
}): Promise<{ error?: string }> {
  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      display_name: input.displayName,
      age_range: input.ageRange,
      financial_goal: input.financialGoals,
      financial_literacy_level: input.financialLiteracyLevel ?? "beginner",
      onboarding_assessment_completed: input.financialLiteracyLevel !== undefined,
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
