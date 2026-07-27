import { describe, it, expect } from "vitest";
import {
  diagnosticQuestions,
  scoreAssessment,
  computeLearningPath,
  defaultLevel,
} from "@/lib/onboarding/diagnosticQuestions";

function buildAnswers(correctIds: string[]): Record<string, boolean> {
  return Object.fromEntries(
    diagnosticQuestions.map((q) => [q.id, correctIds.includes(q.id)])
  );
}

describe("diagnosticQuestions", () => {
  it("exports exactly 5 questions", () => {
    expect(diagnosticQuestions).toHaveLength(5);
  });

  it("has required fields on every question", () => {
    for (const q of diagnosticQuestions) {
      expect(q.id).toBeTruthy();
      expect(["beginner", "intermediate", "advanced"]).toContain(q.difficulty);
      expect(q.topic).toBeTruthy();
      expect(["multiple_choice", "true_false"]).toContain(q.type);
      expect(q.question).toBeTruthy();
      expect(q.options).toBeInstanceOf(Array);
      expect(q.options.length).toBeGreaterThanOrEqual(2);
      expect(q.answer).toBeTruthy();
      expect(q.explanation).toBeTruthy();

      // answer must match one of the option values
      const optionValues = q.options.map((o) => o.value);
      expect(optionValues).toContain(q.answer);
    }
  });

  it("contains 2 beginner, 2 intermediate, and 1 advanced question", () => {
    const counts = diagnosticQuestions.reduce(
      (acc, q) => {
        acc[q.difficulty] += 1;
        return acc;
      },
      { beginner: 0, intermediate: 0, advanced: 0 }
    );

    expect(counts.beginner).toBe(2);
    expect(counts.intermediate).toBe(2);
    expect(counts.advanced).toBe(1);
  });

  it("returns beginner when no intermediate/advanced questions are correct", () => {
    const answers = buildAnswers(["q1", "q2"]);
    const { level, correctByDifficulty } = scoreAssessment(answers);
    expect(level).toBe("beginner");
    expect(correctByDifficulty.beginner).toBe(2);
    expect(correctByDifficulty.intermediate).toBe(0);
    expect(correctByDifficulty.advanced).toBe(0);
  });

  it("returns beginner when only 1 intermediate/advanced question is correct", () => {
    const answers = buildAnswers(["q1", "q2", "q3"]);
    const { level, correctByDifficulty } = scoreAssessment(answers);
    expect(level).toBe("beginner");
    expect(correctByDifficulty.intermediate).toBe(1);
    expect(correctByDifficulty.advanced).toBe(0);
  });

  it("returns intermediate when 2 intermediate/advanced questions are correct", () => {
    const answers = buildAnswers(["q1", "q2", "q3", "q4"]);
    const { level, correctByDifficulty } = scoreAssessment(answers);
    expect(level).toBe("intermediate");
    expect(correctByDifficulty.intermediate).toBe(2);
    expect(correctByDifficulty.advanced).toBe(0);
  });

  it("returns advanced when all intermediate/advanced questions are correct", () => {
    const answers = buildAnswers(["q1", "q2", "q3", "q4", "q5"]);
    const { level, correctByDifficulty } = scoreAssessment(answers);
    expect(level).toBe("advanced");
    expect(correctByDifficulty.intermediate).toBe(2);
    expect(correctByDifficulty.advanced).toBe(1);
  });

  it("returns advanced when 4 intermediate/advanced questions are correct", () => {
    const answers = buildAnswers(["q1", "q3", "q4", "q5"]);
    const { level, correctByDifficulty } = scoreAssessment(answers);
    expect(level).toBe("advanced");
    expect(correctByDifficulty.intermediate).toBe(2);
    expect(correctByDifficulty.advanced).toBe(1);
  });

  it("returns advanced when all questions are correct", () => {
    const answers = buildAnswers(diagnosticQuestions.map((q) => q.id));
    const { level, correctByDifficulty } = scoreAssessment(answers);
    expect(level).toBe("advanced");
    expect(correctByDifficulty.beginner).toBe(2);
    expect(correctByDifficulty.intermediate).toBe(2);
    expect(correctByDifficulty.advanced).toBe(1);
  });

  it("defaultLevel is beginner", () => {
    expect(defaultLevel).toBe("beginner");
  });

  describe("computeLearningPath", () => {
    function resultWithScore(score: number) {
      return {
        level: "beginner" as const,
        score,
        maxScore: 5,
        correctByDifficulty: { beginner: 0, intermediate: 0, advanced: 0 },
        answers: {},
        wrongRemediationSlugs: [],
      };
    }

    it("sends 0-1 correct answers to the full Foundation 0 track", () => {
      const path0 = computeLearningPath(resultWithScore(0));
      const path1 = computeLearningPath(resultWithScore(1));

      expect(path0.foundationZeroRequired).toBe(true);
      expect(path0.startingLessonSlug).toBe("fz-what-is-money");
      expect(path1.foundationZeroRequired).toBe(true);
      expect(path1.startingLessonSlug).toBe("fz-what-is-money");
    });

    it("sends 2-3 correct answers to a shortened Foundation 0 track", () => {
      const path2 = computeLearningPath(resultWithScore(2));
      const path3 = computeLearningPath(resultWithScore(3));

      expect(path2.foundationZeroRequired).toBe(true);
      expect(path2.startingLessonSlug).toBe("fz-income-vs-wealth");
      expect(path3.foundationZeroRequired).toBe(true);
      expect(path3.startingLessonSlug).toBe("fz-income-vs-wealth");
    });

    it("sends 4-5 correct answers straight to the main track", () => {
      const path4 = computeLearningPath(resultWithScore(4));
      const path5 = computeLearningPath(resultWithScore(5));

      expect(path4.foundationZeroRequired).toBe(false);
      expect(path4.startingLessonSlug).toBe("needs-vs-wants-101");
      expect(path5.foundationZeroRequired).toBe(false);
      expect(path5.startingLessonSlug).toBe("needs-vs-wants-101");
    });
  });
});
