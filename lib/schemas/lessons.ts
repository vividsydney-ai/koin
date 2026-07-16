import { z } from "zod";

export const completeLessonSchema = z.object({
  userId: z.string().uuid("Invalid user ID"),
  lessonId: z.string().uuid("Invalid lesson ID"),
  score: z.number().int().min(0, "Score cannot be negative"),
  maxScore: z.number().int().positive("Max score must be greater than 0"),
  answersJson: z.unknown().default({}),
  timeSpentSeconds: z.number().int().min(0, "Time spent cannot be negative"),
  quizCorrect: z.boolean(),
});

export type CompleteLessonInput = z.infer<typeof completeLessonSchema>;
