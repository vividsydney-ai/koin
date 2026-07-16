import { supabase } from "@/lib/auth/client";
import { ok, err, type Result } from "@/lib/types/result";
import { serviceError, type ServiceError } from "@/lib/types/service-error";
import { updateProfileSchema, completeOnboardingSchema } from "@/lib/schemas/profile";
import type { UpdateProfileInput, CompleteOnboardingInput } from "@/lib/schemas/profile";

export type { UpdateProfileInput, CompleteOnboardingInput } from "@/lib/schemas/profile";

export async function updateProfile(
  input: UpdateProfileInput
): Promise<Result<null, ServiceError>> {
  const parsed = updateProfileSchema.safeParse(input);
  if (!parsed.success) {
    return err(serviceError("validation_error", parsed.error.issues[0].message));
  }

  const { userId, displayName, notificationsEnabled } = parsed.data;
  const now = new Date().toISOString();

  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      display_name: displayName,
      updated_at: now,
    })
    .eq("id", userId);

  if (profileError) {
    return err(serviceError("rpc_error", profileError.message));
  }

  const { error: settingsError } = await supabase
    .from("user_settings")
    .update({
      notifications_enabled: notificationsEnabled,
      updated_at: now,
    })
    .eq("user_id", userId);

  if (settingsError) {
    return err(serviceError("rpc_error", settingsError.message));
  }

  return ok(null);
}

export async function completeOnboarding(
  input: CompleteOnboardingInput
): Promise<Result<null, ServiceError>> {
  const parsed = completeOnboardingSchema.safeParse(input);
  if (!parsed.success) {
    return err(serviceError("validation_error", parsed.error.issues[0].message));
  }

  const {
    userId,
    displayName,
    ageRange,
    financialGoals,
    notificationsEnabled,
    financialLiteracyLevel,
  } = parsed.data;

  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      display_name: displayName,
      age_range: ageRange,
      financial_goal: financialGoals,
      financial_literacy_level: financialLiteracyLevel ?? "beginner",
      onboarding_assessment_completed: financialLiteracyLevel !== undefined,
      onboarding_completed: true,
      updated_at: new Date().toISOString(),
    })
    .eq("id", userId);

  if (profileError) {
    return err(serviceError("rpc_error", profileError.message));
  }

  const { error: settingsError } = await supabase
    .from("user_settings")
    .update({
      notifications_enabled: notificationsEnabled,
      updated_at: new Date().toISOString(),
    })
    .eq("user_id", userId);

  if (settingsError) {
    return err(serviceError("rpc_error", settingsError.message));
  }

  return ok(null);
}
