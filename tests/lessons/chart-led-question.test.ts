import { describe, expect, it } from "vitest";
import { validateQuestion } from "@/lib/lessons/question";

describe("chart-led advanced questions", () => {
  it("accepts an instructional price chart with visible volume context", () => {
    const question = validateQuestion({
      type: "multiple_choice",
      difficulty: "advanced",
      question: "What should you inspect next?",
      options: ["The close and volume together", "A guaranteed forecast"],
      answer: "The close and volume together",
      explanation: "Volume is context, not a guarantee.",
      chart: {
        candles: [
          { open: 100, high: 104, low: 98, close: 102, volume: 20, label: "Ordinary" },
          { open: 102, high: 108, low: 101, close: 107, volume: 80, label: "High activity" },
        ],
      },
    });

    expect(question?.type).toBe("multiple_choice");
    if (question?.type !== "multiple_choice") return;
    expect(question.chart?.candles[1].volume).toBe(80);
  });
});
