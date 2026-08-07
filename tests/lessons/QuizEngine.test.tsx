import { describe, it, expect, vi } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";
import { QuizEngine } from "@/components/lesson/QuizEngine";
import type { ProcessedQuestion } from "@/lib/lessons/question";

describe("QuizEngine", () => {
  const base = { explanation: "Because.", parameters: {} };

  it("renders multiple_choice and reports correct answer", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "multiple_choice",
      question: "What is 2+2?",
      options: ["3", "4", "5"],
      answer: "4",
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="s1" onComplete={onComplete} />);

    fireEvent.click(screen.getByText("4"));
    expect(onComplete).toHaveBeenCalledWith(true);
    expect(screen.getByText("Because.")).toBeInTheDocument();
  });

  it("accepts a punctuation-only answer label difference without marking it wrong", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "multiple_choice",
      question: "Which channel should you verify?",
      options: ["The official channel", "A forwarded screenshot"],
      answer: "The official channel.",
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="normalised-answer" onComplete={onComplete} />);

    fireEvent.click(screen.getByText("The official channel"));

    expect(onComplete).toHaveBeenCalledWith(true);
    expect(screen.queryByText(/Correct answer/)).not.toBeInTheDocument();
  });

  it("renders true_false and reports incorrect answer", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "true_false",
      question: "Is the earth flat?",
      answer: false,
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="s2" onComplete={onComplete} />);

    fireEvent.click(screen.getByText("True"));
    expect(onComplete).toHaveBeenCalledWith(false);
  });

  it("renders fill_blank and accepts the correct text", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "fill_blank",
      question: "Capital of Indonesia?",
      answer: "Jakarta",
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="s3" onComplete={onComplete} />);

    fireEvent.click(screen.getByText("Jakarta"));
    fireEvent.click(screen.getByText("Check answer"));
    expect(onComplete).toHaveBeenCalledWith(true);
  });

  it("keeps generated fill-blank distractors in the learner's language", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "fill_blank",
      question: "Interest is the cost of borrowing ____. ",
      answer: "money",
    };
    render(<QuizEngine question={question} seed="locale" onComplete={vi.fn()} />);
    expect(screen.getByText("cash flow")).toBeInTheDocument();
    expect(screen.queryByText("arus kas")).not.toBeInTheDocument();
  });

  it("renders word_bank and checks ordered answer", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "word_bank",
      question: "Complete: ___ and ___.",
      options: ["kebutuhan", "keinginan"],
      answer: ["kebutuhan", "keinginan"],
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="s4" onComplete={onComplete} />);

    fireEvent.click(screen.getByText("kebutuhan"));
    fireEvent.click(screen.getByText("keinginan"));
    fireEvent.click(screen.getByText("Check answer"));
    expect(onComplete).toHaveBeenCalledWith(true);
  });

  it("renders ordering and checks rearranged order", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "ordering",
      question: "Order these.",
      options: ["B", "A", "C"],
      answer: ["A", "B", "C"],
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="quiz" onComplete={onComplete} />);

    // Initial order from seededShuffle("quiz:ord", ["B","A","C"]) is ["B","C","A"].
    const itemB = screen.getByText("B");
    const itemC = screen.getByText("C");

    // Swap B and C -> ["C","B","A"], then C and A -> ["A","B","C"].
    fireEvent.click(itemB);
    fireEvent.click(itemC);
    fireEvent.click(screen.getByText("C"));
    fireEvent.click(screen.getByText("A"));

    fireEvent.click(screen.getByText("Check answer"));
    expect(onComplete).toHaveBeenCalledWith(true);
  });

  it("uses matching pairs as a safe fallback when an answer map is incomplete", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "matching",
      question: "Match each goal.",
      pairs: [["Emergency fund", "Bank savings"], ["Long-term goal", "Stock fund"]],
      answer: {},
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="match" onComplete={onComplete} />);
    // Deliberately submit an incorrect pairing so the result panel renders
    // the canonical answer derived from `pairs` (even with an empty map).
    fireEvent.click(screen.getAllByText("Stock fund")[0]);
    fireEvent.click(screen.getByText("Bank savings"));
    fireEvent.click(screen.getByText("Check answer"));
    expect(screen.getByText(/Emergency fund: Bank savings/)).toBeInTheDocument();
    expect(onComplete).toHaveBeenCalledWith(false);
  });

  it("renders swipe_yes_no as a Yes / No binary choice", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "swipe_yes_no",
      question: "Is this a good habit?",
      answer: true,
    };
    const onComplete = vi.fn();
    render(<QuizEngine question={question} seed="s7" onComplete={onComplete} />);

    expect(screen.getByText("Yes / No")).toBeInTheDocument();
    fireEvent.click(screen.getByText("Yes"));
    expect(onComplete).toHaveBeenCalledWith(true);
  });

  it("shows unsupported message for unimplemented types", () => {
    const question: ProcessedQuestion = {
      ...base,
      type: "slider",
      question: "Pick a value.",
      min: 0,
      max: 100,
      step: 1,
      answer: 50,
    };
    render(<QuizEngine question={question} seed="s6" />);
    expect(screen.getByText(/slider/i)).toBeInTheDocument();
  });
});
