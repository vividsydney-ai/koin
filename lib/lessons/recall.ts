import { z } from "zod";
import { supabase } from "@/lib/auth/client";
import type { Locale } from "@/lib/i18n/types";

const optionSchema = z.object({ id: z.string().min(1), label: z.string().min(1) });
const promptSchema = z.object({
  prompt_id: z.string().uuid(),
  lesson_id: z.string().uuid(),
  due_at: z.string(),
  question_en: z.string().min(1),
  question_id: z.string().min(1),
  options_en: z.array(optionSchema).min(2),
  options_id: z.array(optionSchema).min(2),
});

export type LessonRecallPrompt = {
  id: string;
  lessonId: string;
  dueAt: string;
  question: string;
  options: Array<{ id: string; label: string }>;
};

export type RecallSubmission = {
  correct: boolean;
  complete: boolean;
  attemptCount: number;
  explanation: string;
};

export async function getDueLessonRecallPrompt(locale: Locale): Promise<LessonRecallPrompt | null> {
  const { data, error } = await supabase.rpc("get_due_lesson_recall_prompt");
  if (error || !Array.isArray(data) || data.length === 0) return null;
  const parsed = promptSchema.safeParse(data[0]);
  if (!parsed.success) return null;
  const prompt = parsed.data;
  return {
    id: prompt.prompt_id,
    lessonId: prompt.lesson_id,
    dueAt: prompt.due_at,
    question: locale === "id" ? prompt.question_id : prompt.question_en,
    options: locale === "id" ? prompt.options_id : prompt.options_en,
  };
}

export async function submitLessonRecallAnswer(
  promptId: string,
  answer: string,
  locale: Locale
): Promise<RecallSubmission | null> {
  const validated = z.object({ promptId: z.string().uuid(), answer: z.string().min(1).max(120) }).safeParse({ promptId, answer });
  if (!validated.success) return null;
  const { data, error } = await supabase.rpc("submit_lesson_recall_answer", {
    p_prompt_id: validated.data.promptId,
    p_answer: validated.data.answer,
  });
  if (error || !data || typeof data !== "object") return null;
  const response = data as Record<string, unknown>;
  if (typeof response.correct !== "boolean" || typeof response.complete !== "boolean") return null;
  const explanation = locale === "id" ? response.explanation_id : response.explanation_en;
  return {
    correct: response.correct,
    complete: response.complete,
    attemptCount: Number(response.attempt_count ?? 0),
    explanation: typeof explanation === "string" ? explanation : "",
  };
}

export async function dismissLessonRecallPrompt(promptId: string): Promise<boolean> {
  const validated = z.string().uuid().safeParse(promptId);
  if (!validated.success) return false;
  const { error } = await supabase.rpc("dismiss_lesson_recall_prompt", { p_prompt_id: validated.data });
  return !error;
}
