import { z } from "zod";
import { seededInt } from "./random";

export const questionTypes = [
  "multiple_choice",
  "true_false",
  "fill_blank",
  "word_bank",
  "ordering",
  "matching",
  "slider",
  "swipe_yes_no",
  "case_study",
] as const;

export type QuestionType = (typeof questionTypes)[number];

const parameterSpecSchema = z.object({
  min: z.number().int(),
  max: z.number().int(),
  step: z.number().int().default(1),
});

export type ParameterSpec = z.infer<typeof parameterSpecSchema>;

const baseQuestionSchema = z.object({
  type: z.enum(questionTypes),
  difficulty: z.enum(["beginner", "intermediate", "advanced"]).optional(),
  question: z.string().min(1),
  explanation: z.string().min(1),
  parameters: z.record(z.string(), parameterSpecSchema).default({}),
});

export const multipleChoiceSchema = baseQuestionSchema.extend({
  type: z.literal("multiple_choice"),
  options: z.array(z.string().min(1)).min(2),
  answer: z.string().min(1),
});

export const trueFalseSchema = baseQuestionSchema.extend({
  type: z.literal("true_false"),
  answer: z.boolean(),
});

export const fillBlankSchema = baseQuestionSchema.extend({
  type: z.literal("fill_blank"),
  answer: z.string().min(1),
});

export const wordBankSchema = baseQuestionSchema.extend({
  type: z.literal("word_bank"),
  options: z.array(z.string().min(1)).min(1),
  answer: z.array(z.string().min(1)).min(1),
});

export const orderingSchema = baseQuestionSchema.extend({
  type: z.literal("ordering"),
  options: z.array(z.string().min(1)).min(2),
  answer: z.array(z.string().min(1)).min(2),
});

// These types are declared so the engine can switch on them, but their full
// UI is not implemented in this slice.
export const matchingSchema = baseQuestionSchema.extend({
  type: z.literal("matching"),
  pairs: z.array(z.tuple([z.string(), z.string()])).min(2),
  answer: z.record(z.string(), z.string()),
});

export const sliderSchema = baseQuestionSchema.extend({
  type: z.literal("slider"),
  min: z.number(),
  max: z.number(),
  step: z.number().default(1),
  answer: z.number(),
});

export const swipeYesNoSchema = baseQuestionSchema.extend({
  type: z.literal("swipe_yes_no"),
  answer: z.boolean(),
});

export const caseStudySchema = baseQuestionSchema.extend({
  type: z.literal("case_study"),
  caseText: z.string().min(1),
  followUp: multipleChoiceSchema.omit({ type: true }),
  answer: z.string().min(1),
});

export const quizQuestionSchema = z.discriminatedUnion("type", [
  multipleChoiceSchema,
  trueFalseSchema,
  fillBlankSchema,
  wordBankSchema,
  orderingSchema,
  matchingSchema,
  sliderSchema,
  swipeYesNoSchema,
  caseStudySchema,
]);

export type QuizQuestion = z.infer<typeof quizQuestionSchema>;

export type MultipleChoiceQuestion = z.infer<typeof multipleChoiceSchema>;
export type TrueFalseQuestion = z.infer<typeof trueFalseSchema>;
export type FillBlankQuestion = z.infer<typeof fillBlankSchema>;
export type WordBankQuestion = z.infer<typeof wordBankSchema>;
export type OrderingQuestion = z.infer<typeof orderingSchema>;

export type ProcessedQuestion = QuizQuestion & { variantId?: string };

export function validateQuestion(body: unknown): QuizQuestion | null {
  const parsed = quizQuestionSchema.safeParse(body);
  if (!parsed.success) {
    console.error("validateQuestion error:", parsed.error.flatten());
    return null;
  }
  return parsed.data;
}

export function applyParameters(seed: string, question: QuizQuestion): QuizQuestion {
  const params = question.parameters ?? {};
  const keys = Object.keys(params);
  if (keys.length === 0) return question;

  const values: Record<string, number> = {};
  for (const key of keys) {
    const spec = params[key];
    const range = spec.max - spec.min;
    const steps = Math.floor(range / spec.step);
    const stepIndex = seededInt(`${seed}:param:${key}`, 0, Math.max(0, steps));
    values[key] = spec.min + stepIndex * spec.step;
  }

  const formatNumber = (n: number): string =>
    Math.round(n).toLocaleString("id-ID", { maximumFractionDigits: 0 });

  const substitute = (value: unknown): unknown => {
    if (typeof value === "string") {
      return value.replace(/\{\{([^}]+)\}\}/g, (_match, content) => {
        const key = content.trim();
        if (key in values) return formatNumber(values[key]);
        const evaluated = evaluateExpression(key, values);
        return evaluated !== null ? formatNumber(evaluated) : _match;
      });
    }
    if (Array.isArray(value)) {
      return value.map(substitute);
    }
    if (value && typeof value === "object") {
      return Object.fromEntries(
        Object.entries(value as Record<string, unknown>).map(([k, v]) => [k, substitute(v)])
      );
    }
    return value;
  };

  // Type cast after a structural clone with substitutions.
  return substitute(question) as QuizQuestion;
}

// Safe arithmetic evaluator for placeholder expressions like "amount * 12" or
// "amount * (1 + rate/100) ** years". Only numbers, identifiers, parentheses,
// and the operators + - * / ** are supported.
function evaluateExpression(expr: string, values: Record<string, number>): number | null {
  const tokens = tokenize(expr);
  if (!tokens) return null;
  try {
    const result = parseExpression(tokens, values);
    if (tokens.length !== 0) return null;
    return result;
  } catch {
    return null;
  }
}

function tokenize(expr: string): string[] | null {
  const tokens: string[] = [];
  let i = 0;
  while (i < expr.length) {
    const c = expr[i];
    if (/\s/.test(c)) {
      i++;
      continue;
    }
    if (/[0-9.]/.test(c)) {
      let num = "";
      while (i < expr.length && /[0-9.]/.test(expr[i])) {
        num += expr[i];
        i++;
      }
      if (!/^\d+(\.\d+)?$/.test(num)) return null;
      tokens.push(num);
      continue;
    }
    if (/[a-zA-Z_]/.test(c)) {
      let id = "";
      while (i < expr.length && /[a-zA-Z0-9_]/.test(expr[i])) {
        id += expr[i];
        i++;
      }
      tokens.push(id);
      continue;
    }
    if (expr.startsWith("**", i)) {
      tokens.push("**");
      i += 2;
      continue;
    }
    if (/[+\-*/()]/.test(c)) {
      tokens.push(c);
      i++;
      continue;
    }
    return null;
  }
  return tokens;
}

function parseExpression(tokens: string[], values: Record<string, number>): number {
  return parseAddSub(tokens, values);
}

function parseAddSub(tokens: string[], values: Record<string, number>): number {
  let left = parseMulDiv(tokens, values);
  while (tokens[0] === "+" || tokens[0] === "-") {
    const op = tokens.shift()!;
    const right = parseMulDiv(tokens, values);
    left = op === "+" ? left + right : left - right;
  }
  return left;
}

function parseMulDiv(tokens: string[], values: Record<string, number>): number {
  let left = parsePower(tokens, values);
  while (tokens[0] === "*" || tokens[0] === "/") {
    const op = tokens.shift()!;
    const right = parsePower(tokens, values);
    left = op === "*" ? left * right : left / right;
  }
  return left;
}

function parsePower(tokens: string[], values: Record<string, number>): number {
  let left = parsePrimary(tokens, values);
  while (tokens[0] === "**") {
    tokens.shift();
    const right = parsePrimary(tokens, values);
    left = Math.pow(left, right);
  }
  return left;
}

function parsePrimary(tokens: string[], values: Record<string, number>): number {
  const token = tokens.shift();
  if (token === undefined) throw new Error("Unexpected end of expression");
  if (token === "(") {
    const value = parseExpression(tokens, values);
    if (tokens.shift() !== ")") throw new Error("Expected closing parenthesis");
    return value;
  }
  if (/^\d+(\.\d+)?$/.test(token)) return parseFloat(token);
  if (token in values) return values[token];
  throw new Error(`Unknown identifier: ${token}`);
}

export function normalizeAnswer(value: string): string {
  return value
    .toLowerCase()
    .replace(/[.,!?;:]/g, "")
    .trim();
}
