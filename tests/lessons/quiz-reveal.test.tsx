import { describe, it, expect, vi } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { QuizEngine } from "@/components/lesson/QuizEngine";
import type { ProcessedQuestion } from "@/lib/lessons/question";

vi.mock("@/lib/i18n/LocaleProvider", () => ({
  useLocale: () => ({ locale: "en", setLocale: vi.fn(), t: (k: string) => k }),
}));

const fillBlank: ProcessedQuestion = {
  type: "fill_blank",
  question: "Money that everyone accepts as payment is called a medium of ____.",
  answer: "exchange",
  explanation: "A medium of exchange is widely accepted in return for goods.",
  parameters: {},
  variantId: "fb1",
};

const trueFalseWrong: ProcessedQuestion = {
  type: "true_false",
  question: "Digital money in an e-wallet is still money.",
  answer: true,
  explanation: "E-wallet balances function as money.",
  parameters: {},
  variantId: "tf1",
};

describe("QuizEngine wrong-answer reveal (KO-REPLAY-002)", () => {
  it("shows the correct answer on a wrong fill_blank attempt", () => {
    render(<QuizEngine question={fillBlank} seed="s1" />);

    fireEvent.change(screen.getByLabelText("quiz.typeAnswer"), { target: { value: "saving" } });
    fireEvent.click(screen.getByRole("button", { name: /quiz\.checkAnswer/i }));

    const label = screen.getByText(/quiz\.correctAnswer/);
    expect(label.textContent).toContain("exchange");
  });

  it("does not show the correct-answer line on a correct attempt", () => {
    render(<QuizEngine question={fillBlank} seed="s1" />);

    fireEvent.change(screen.getByLabelText("quiz.typeAnswer"), { target: { value: "exchange" } });
    fireEvent.click(screen.getByRole("button", { name: /quiz\.checkAnswer/i }));

    expect(screen.queryByText(/quiz\.correctAnswer/)).not.toBeInTheDocument();
  });

  it("shows the correct answer on a wrong true_false attempt", () => {
    render(<QuizEngine question={trueFalseWrong} seed="s1" />);

    fireEvent.click(screen.getByRole("button", { name: "quiz.false" }));

    const label = screen.getByText(/quiz\.correctAnswer/);
    expect(label.textContent).toContain("quiz.true");
  });
});
