import { describe, it, expect } from "vitest";
import {
  validateQuestion,
  applyParameters,
  normalizeAnswer,
  quizQuestionSchema,
  type QuizQuestion,
} from "@/lib/lessons/question";

describe("question", () => {
  describe("validateQuestion", () => {
    it("normalizes legacy scenario and matching payloads into supported mechanics", () => {
      expect(validateQuestion({
        type: "scenario",
        question: "Which approach is safer?",
        options: ["A", "B"],
        answer: "B",
        explanation: "B.",
        parameters: {},
      })?.type).toBe("multiple_choice");
      expect(validateQuestion({
        type: "definition_match",
        question: "Match terms.",
        answer: { Asset: "Something owned", Liability: "Something owed" },
        options: { terms: ["Asset", "Liability"], definitions: ["Something owned", "Something owed"] },
        explanation: "Match them.",
        parameters: {},
      })?.type).toBe("matching");
    });

    it("accepts a valid multiple_choice question", () => {
      const body: QuizQuestion = {
        type: "multiple_choice",
        question: "What is 2+2?",
        options: ["3", "4", "5"],
        answer: "4",
        explanation: "Two plus two equals four.",
        parameters: {},
      };
      expect(validateQuestion(body)).toEqual(body);
    });

    it("accepts a valid true_false question", () => {
      const body: QuizQuestion = {
        type: "true_false",
        question: "The sky is blue.",
        answer: true,
        explanation: "Yes.",
        parameters: {},
      };
      expect(validateQuestion(body)).toEqual(body);
    });

    it("accepts a valid word_bank question", () => {
      const body: QuizQuestion = {
        type: "word_bank",
        question: "Fill the blanks.",
        options: ["a", "b"],
        answer: ["a", "b"],
        explanation: "Order matters.",
        parameters: {},
      };
      expect(validateQuestion(body)).toEqual(body);
    });

    it("accepts an instructional chart interpretation question", () => {
      const body: QuizQuestion = {
        type: "chart_interpretation",
        question: "Which option shows a candle that closed higher than it opened?",
        chart: [{ open: 10, high: 14, low: 8, close: 12, label: "Example" }],
        options: [
          { id: "up", label: "Closed higher", chart: [{ open: 10, high: 14, low: 9, close: 13 }] },
          { id: "down", label: "Closed lower", chart: [{ open: 13, high: 14, low: 9, close: 10 }] },
        ],
        answer: "up",
        explanation: "A higher close than open is an up candle.",
        parameters: {},
      };
      expect(validateQuestion(body)).toEqual(body);
    });

    it("rejects a chart candle whose high and low do not contain the body", () => {
      expect(validateQuestion({
        type: "chart_interpretation",
        question: "Invalid candle",
        chart: [{ open: 10, high: 9, low: 8, close: 12 }],
        options: [
          { id: "a", label: "A", chart: [{ open: 10, high: 12, low: 9, close: 11 }] },
          { id: "b", label: "B", chart: [{ open: 11, high: 12, low: 9, close: 10 }] },
        ],
        answer: "a",
        explanation: "Invalid candle should fail.",
        parameters: {},
      })).toBeNull();
    });

    it("rejects a multiple_choice question with no options", () => {
      const body = {
        type: "multiple_choice" as const,
        question: "What?",
        options: [] as string[],
        answer: "x",
        explanation: "No options.",
        parameters: {},
      };
      expect(validateQuestion(body)).toBeNull();
    });

    it("rejects a multiple-choice answer that is not selectable", () => {
      expect(validateQuestion({
        type: "multiple_choice",
        question: "Which channel should you verify?",
        options: ["The official channel", "A forwarded screenshot"],
        answer: "The official receiving account and current provider instructions",
        explanation: "Verify the official channel.",
        parameters: {},
      })).toBeNull();
    });

    it("rejects an unknown question type", () => {
      const body = {
        type: "unknown" as const,
        question: "What?",
        answer: "x",
        explanation: "Bad type.",
        parameters: {},
      };
      expect(validateQuestion(body)).toBeNull();
    });
  });

  describe("applyParameters", () => {
    it("returns the question unchanged when there are no parameters", () => {
      const q: QuizQuestion = {
        type: "multiple_choice",
        question: "What is 2+2?",
        options: ["3", "4"],
        answer: "4",
        explanation: "Math.",
        parameters: {},
      };
      expect(applyParameters("seed", q)).toEqual(q);
    });

    it("replaces simple parameter placeholders", () => {
      const q: QuizQuestion = {
        type: "fill_blank",
        question: "Target inflation is around {{target}} percent.",
        answer: "{{target}}",
        explanation: "BI target is {{target}}%.",
        parameters: { target: { min: 2, max: 4, step: 1 } },
      };
      const result = applyParameters("seed", q);
      expect(result.question).not.toContain("{{target}}");
      expect(result.answer).toMatch(/^\d[\d.]*$/);
      expect(result.explanation).not.toContain("{{target}}");
    });

    it("evaluates arithmetic expressions in placeholders", () => {
      const q: QuizQuestion = {
        type: "multiple_choice",
        question: "Value after one year?",
        options: [
          "Rp {{amount * (1 + rate/100)}}",
          "Rp {{amount + rate}}",
          "Rp {{amount}}",
          "Rp {{amount * rate}}",
        ],
        answer: "Rp {{amount * (1 + rate/100)}}",
        explanation: "Compound: amount × (1 + rate).",
        parameters: {
          amount: { min: 1000000, max: 1000000, step: 1 },
          rate: { min: 10, max: 10, step: 1 },
        },
      };
      const result = applyParameters("seed", q);
      expect(result.answer).toBe("Rp 1.100.000");
      if (result.type !== "multiple_choice") throw new Error("expected multiple_choice");
      expect(result.options).toContain("Rp 1.100.000");
    });

    it("is deterministic for the same seed", () => {
      const q: QuizQuestion = {
        type: "fill_blank",
        question: "Amount: {{amount}}",
        answer: "{{amount}}",
        explanation: "Amount.",
        parameters: { amount: { min: 1000, max: 9999, step: 1 } },
      };
      expect(applyParameters("same-seed", q)).toEqual(applyParameters("same-seed", q));
    });
  });

  describe("normalizeAnswer", () => {
    it("lower-cases, trims punctuation and whitespace", () => {
      expect(normalizeAnswer("  OJK. ")).toBe("ojk");
      expect(normalizeAnswer("2,5%")).toBe("25%");
    });
  });

  describe("quizQuestionSchema", () => {
    it("strips extra fields", () => {
      const result = quizQuestionSchema.parse({
        type: "true_false",
        question: "Sky blue?",
        answer: true,
        explanation: "Yes.",
        parameters: {},
        extra: "ignored",
      });
      expect(result).not.toHaveProperty("extra");
    });
  });
});
