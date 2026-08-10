import { supabase } from "@/lib/auth/client";
import { z } from "zod";
import type { Locale } from "@/lib/i18n/types";

export type DailyFocusStatus = "active" | "completed" | "exhausted";

export interface DailyFocusQuestion {
  type: "multiple_choice" | "true_false" | "swipe_yes_no" | "fill_blank" | "select_all" | "word_bank" | "ordering" | "matching";
  question: string;
  options?: string[];
  pairs?: [string, string][];
}

const supportedQuestionTypes = new Set<DailyFocusQuestion["type"]>([
  "multiple_choice",
  "true_false",
  "swipe_yes_no",
  "fill_blank",
  "select_all",
  "word_bank",
  "ordering",
  "matching",
]);

export interface DailyFocusState {
  challengeDate: string;
  maxFocus: number;
  focusRemaining: number;
  questionsAnswered: number;
  correctAnswers: number;
  status: DailyFocusStatus;
  refillUsed: boolean;
  missionsCompletedThisWeek: number;
  missionGoal: number;
  fourthFocusUnlocked: boolean;
  questions: DailyFocusQuestion[];
  answerCorrect: boolean | null;
  explanation: string | null;
  correctAnswer: string | boolean | string[] | Record<string, string> | null;
}

const dailyFocusAnswerSchema = z.object({
  questionIndex: z.number().int().min(0).max(4),
  answer: z.union([
    z.string().min(1),
    z.boolean(),
    z.array(z.string().min(1)).min(1),
    z.record(z.string(), z.string()),
  ]),
  timeZone: z.string().min(1).max(100),
});

/** The browser's IANA timezone is the reliable source for a learner's local calendar. */
export function getLocalTimeZone(): string {
  try {
    return Intl.DateTimeFormat().resolvedOptions().timeZone || "UTC";
  } catch {
    return "UTC";
  }
}

function parseState(raw: unknown): DailyFocusState | null {
  if (!raw || typeof raw !== "object") return null;
  const value = raw as Record<string, unknown>;
  const parsedQuestions = Array.isArray(value.questions)
    ? value.questions.map(parseQuestion)
    : [];

  // A question with no choices cannot be answered safely. Do not filter it
  // out: that would shift question indexes away from the server snapshot.
  if (parsedQuestions.length !== 5 || parsedQuestions.some((question) => question === null)) return null;
  const questions = parsedQuestions.filter((question): question is DailyFocusQuestion => question !== null);

  const status = value.status;
  if (status !== "active" && status !== "completed" && status !== "exhausted") return null;

  return {
    challengeDate: String(value.challenge_date ?? ""),
    maxFocus: Number(value.max_focus ?? 3),
    focusRemaining: Number(value.focus_remaining ?? 0),
    questionsAnswered: Number(value.questions_answered ?? 0),
    correctAnswers: Number(value.correct_answers ?? 0),
    status,
    refillUsed: Boolean(value.refill_used),
    missionsCompletedThisWeek: Number(value.missions_completed_this_week ?? 0),
    missionGoal: Number(value.mission_goal ?? 5),
    fourthFocusUnlocked: Boolean(value.fourth_focus_unlocked),
    questions,
    answerCorrect: typeof value.answer_correct === "boolean" ? value.answer_correct : null,
    explanation: typeof value.explanation === "string" ? value.explanation : null,
    correctAnswer:
      typeof value.correct_answer === "string" || typeof value.correct_answer === "boolean" || Array.isArray(value.correct_answer) || (typeof value.correct_answer === "object" && value.correct_answer !== null)
        ? (value.correct_answer as string | boolean | string[] | Record<string, string>)
        : null,
  };
}

function parseQuestion(raw: unknown): DailyFocusQuestion | null {
  if (!raw || typeof raw !== "object") return null;
  const value = raw as Record<string, unknown>;
  const type = String(value.type) as DailyFocusQuestion["type"];
  if (!supportedQuestionTypes.has(type) || typeof value.question !== "string" || !value.question.trim()) return null;

  if (["multiple_choice", "select_all", "word_bank", "ordering", "fill_blank"].includes(type)) {
    if (!hasStringOptions(value.options)) return null;
    return { type, question: value.question, options: value.options };
  }

  if (type === "matching") {
    if (!hasPairs(value.pairs)) return null;
    return { type, question: value.question, pairs: value.pairs };
  }

  return { type, question: value.question };
}

function hasStringOptions(value: unknown): value is string[] {
  return Array.isArray(value) && value.length >= 2 && value.every((option) => typeof option === "string" && option.trim().length > 0);
}

function hasPairs(value: unknown): value is [string, string][] {
  return Array.isArray(value) && value.length >= 2 && value.every(
    (pair) => Array.isArray(pair) && pair.length === 2 && pair.every((item) => typeof item === "string" && item.trim().length > 0)
  );
}

export async function getDailyFocusChallenge(timeZone = getLocalTimeZone(), locale: Locale = "en"): Promise<DailyFocusState | null> {
  const { data, error } = await supabase.rpc("get_daily_focus_challenge", {
    p_time_zone: timeZone,
    p_locale: locale,
  });
  if (error) {
    console.error("getDailyFocusChallenge error:", error.message);
    return null;
  }
  return parseState(data);
}

export async function submitDailyFocusAnswer(
  questionIndex: number,
  answer: string | boolean | string[] | Record<string, string>,
  timeZone = getLocalTimeZone(),
  locale: Locale = "en"
): Promise<{ state: DailyFocusState | null; error: string | null }> {
  const parsed = dailyFocusAnswerSchema.safeParse({ questionIndex, answer, timeZone });
  if (!parsed.success) {
    return { state: null, error: "That Focus answer was not valid." };
  }

  const { data, error } = await supabase.rpc("submit_daily_focus_answer", {
    p_question_index: parsed.data.questionIndex,
    p_answer: parsed.data.answer,
    p_time_zone: parsed.data.timeZone,
    p_locale: locale,
  });

  if (error) return { state: null, error: error.message };
  return { state: parseState(data), error: null };
}

export async function refillDailyFocus(timeZone = getLocalTimeZone(), locale: Locale = "en"): Promise<{ state: DailyFocusState | null; error: string | null }> {
  const { data, error } = await supabase.rpc("refill_daily_focus", {
    p_time_zone: timeZone,
    p_locale: locale,
  });
  if (error) return { state: null, error: error.message };
  return { state: parseState(data), error: null };
}
