import { z } from "zod";

export const ageRanges = [
  "under_16",
  "16_18",
  "19_22",
  "23_25",
  "26_plus",
] as const;

export const financialGoals = [
  "start_investing",
  "save_emergency",
  "avoid_scams",
  "budget_better",
  "understand_stocks",
] as const;

export const financialLiteracyLevels = [
  "beginner",
  "intermediate",
  "advanced",
] as const;

export const updateProfileSchema = z.object({
  userId: z.string().uuid("Invalid user ID"),
  displayName: z.string().min(1, "Full name is required").max(100, "Full name is too long"),
  notificationsEnabled: z.boolean(),
});

export const completeOnboardingSchema = z.object({
  userId: z.string().uuid("Invalid user ID"),
  displayName: z.string().min(1, "Full name is required").max(100, "Full name is too long"),
  ageRange: z
    .string({ message: "Age range is required" })
    .refine((value) => ageRanges.includes(value as (typeof ageRanges)[number]), {
      message: "Please select a valid age range",
    }),
  financialGoals: z
    .array(z.string({ message: "Financial goal is required" }))
    .min(1, "Select at least one financial goal")
    .max(3, "Select up to 3 financial goals")
    .refine(
      (values) => values.every((value) => financialGoals.includes(value as (typeof financialGoals)[number])),
      { message: "One or more selected goals are invalid" }
    ),
  notificationsEnabled: z.boolean(),
  financialLiteracyLevel: z
    .string()
    .refine(
      (value) => !value || financialLiteracyLevels.includes(value as (typeof financialLiteracyLevels)[number]),
      { message: "Invalid financial literacy level" }
    )
    .optional(),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
export type CompleteOnboardingInput = z.infer<typeof completeOnboardingSchema>;
