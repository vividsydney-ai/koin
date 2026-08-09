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

export const chapterMissionRouteSchema = z.coerce.number().int().min(6).max(10);

export const chapterMissionAnswerSchema = z.object({
  variantId: z.string().uuid(),
  response: z.union([z.string().min(1), z.boolean()]),
});

export const completeChapterMissionSchema = z.object({
  chapterNumber: chapterMissionRouteSchema,
  answers: z.array(chapterMissionAnswerSchema).length(3),
});

export type CompleteChapterMissionInput = z.infer<typeof completeChapterMissionSchema>;
