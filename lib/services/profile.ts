import { supabase } from "@/lib/auth/client";
import { ok, err, type Result } from "@/lib/types/result";
import { serviceError, type ServiceError } from "@/lib/types/service-error";
import { updateProfileSchema, completeOnboardingSchema } from "@/lib/schemas/profile";
import type { UpdateProfileInput, CompleteOnboardingInput } from "@/lib/schemas/profile";
import { computeLearningPath } from "@/lib/onboarding/diagnosticQuestions";

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
    assessmentResult,
  } = parsed.data;

  // Resolve the gated start lesson before persisting completion. This avoids a
  // partially completed onboarding record if curriculum data is misconfigured.
  const path = assessmentResult
    ? computeLearningPath(assessmentResult)
    : {
        foundationZeroRequired: true,
        startingLessonSlug: "fz-what-is-money",
      };

  const { data: startingLesson, error: startingLessonError } = await supabase
    .from("lessons")
    .select("id")
    .eq("slug", path.startingLessonSlug)
    .single();

  if (startingLessonError || !startingLesson) {
    return err(
      serviceError(
        "rpc_error",
        "We could not prepare your learning path. Please try again."
      )
    );
  }

  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      display_name: displayName,
      age_range: ageRange,
      financial_goal: financialGoals,
      financial_literacy_level: financialLiteracyLevel ?? "beginner",
      onboarding_assessment_completed: assessmentResult !== undefined,
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
      foundation_zero_required: path.foundationZeroRequired,
      starting_lesson_id: startingLesson.id,
      assessment_score: assessmentResult?.score ?? 0,
      assessment_answers: assessmentResult?.answers ?? {},
      updated_at: new Date().toISOString(),
    })
    .eq("user_id", userId);

  if (settingsError) {
    return err(serviceError("rpc_error", settingsError.message));
  }

  // Create remedial recommendations for wrong answers.
  const remediationSlugs = assessmentResult?.wrongRemediationSlugs ?? [];
  if (remediationSlugs.length > 0) {
    const { data: remediationLessons, error: remediationError } = await supabase
      .from("lessons")
      .select("id, slug")
      .in("slug", remediationSlugs);

    if (remediationError) {
      return err(serviceError("rpc_error", remediationError.message));
    }

    const recommendationRows = (remediationLessons ?? []).map((lesson) => ({
      user_id: userId,
      lesson_id: lesson.id,
      reason: "Pelajaran pengayaan berdasarkan hasil asesmen awal.",
      reason_id: "An enrichment lesson based on your onboarding assessment.",
    }));

    if (recommendationRows.length > 0) {
      const { error: recommendationError } = await supabase
        .from("user_lesson_recommendations")
        .upsert(recommendationRows, {
          onConflict: "user_id,lesson_id",
          ignoreDuplicates: false,
        });

      if (recommendationError) {
        return err(serviceError("rpc_error", recommendationError.message));
      }
    }
  }

  return ok(null);
}
