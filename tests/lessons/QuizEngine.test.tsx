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

    const input = screen.getByLabelText("Answer");
    fireEvent.change(input, { target: { value: "jakarta" } });
    fireEvent.click(screen.getByText("Check answer"));
    expect(onComplete).toHaveBeenCalledWith(true);
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
    const itemA = screen.getByText("A");

    // Swap B and C -> ["C","B","A"], then C and A -> ["A","B","C"].
    fireEvent.click(itemB);
    fireEvent.click(itemC);
    fireEvent.click(screen.getByText("C"));
    fireEvent.click(screen.getByText("A"));

    fireEvent.click(screen.getByText("Check answer"));
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
