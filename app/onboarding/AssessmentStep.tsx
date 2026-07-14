"use client";

import { useState, useCallback } from "react";
import {
  scoreAssessment,
  type DiagnosticQuestion,
  type Difficulty,
} from "@/lib/onboarding/diagnosticQuestions";

interface AssessmentStepProps {
  questions: DiagnosticQuestion[];
  onComplete: (level: Difficulty) => void;
  onSkip?: () => void;
}

export default function AssessmentStep({
  questions,
  onComplete,
  onSkip,
}: AssessmentStepProps) {
  const [index, setIndex] = useState(0);
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [answers, setAnswers] = useState<Record<string, boolean>>({});

  const current = questions[index];
  const isLast = index === questions.length - 1;
  const progressText = `Soal ${index + 1} dari ${questions.length}`;

  const handleSelect = useCallback((value: string) => {
    if (showFeedback) return;
    setSelected(value);
    setShowFeedback(true);

    const isCorrect = value === current.answer;
    setAnswers((prev) => ({ ...prev, [current.id]: isCorrect }));
  }, [current, showFeedback]);

  const handleNext = useCallback(() => {
    if (!isLast) {
      setIndex((prev) => prev + 1);
      setSelected(null);
      setShowFeedback(false);
      return;
    }

    const { level } = scoreAssessment(answers);
    onComplete(level);
  }, [answers, isLast, onComplete]);

  const isCorrect = selected === current.answer;

  return (
    <div className="flex flex-col">
      <div className="mb-5 flex items-center justify-between">
        <h2 className="font-display text-2xl font-bold tracking-tight text-foreground">
          Cek literasimu
        </h2>
        <span className="text-sm font-medium text-muted-foreground">
          {progressText}
        </span>
      </div>

      <p className="text-sm text-muted-foreground">
        Jawab 5 soal singkat agar kami bisa menyesuaikan jalur belajarmu.
      </p>

      <div className="mt-5 space-y-4">
        <p className="text-base font-semibold leading-relaxed text-foreground">
          {current.question}
        </p>

        <div className="space-y-2.5" role="radiogroup" aria-label={`Soal ${index + 1}`}>
          {current.options.map((option, optionIndex) => {
            const answered = selected !== null;
            const isSelected = selected === option.value;
            const isAnswer = option.value === current.answer;
            const letter = String.fromCharCode(65 + optionIndex);

            let stateClasses =
              "border-border bg-surface hover:border-primary-300 hover:bg-surface-raised";
            if (answered && isAnswer) {
              stateClasses = "border-success bg-success/10";
            } else if (answered && isSelected && !isAnswer) {
              stateClasses = "border-danger bg-danger/10";
            } else if (answered) {
              stateClasses = "border-border bg-surface opacity-70";
            } else if (isSelected) {
              stateClasses = "border-primary bg-primary-50";
            }

            return (
              <button
                key={option.value}
                type="button"
                role="radio"
                aria-checked={isSelected}
                disabled={answered}
                onClick={() => handleSelect(option.value)}
                className={`flex w-full items-start gap-3 rounded-xl border-[1.5px] p-4 text-left transition-all ${stateClasses} ${
                  answered ? "cursor-default" : "cursor-pointer active:scale-[0.99]"
                }`}
              >
                <span
                  className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-full border text-xs font-bold ${
                    answered && isAnswer
                      ? "border-success bg-success text-white"
                      : answered && isSelected
                        ? "border-danger bg-danger text-white"
                        : "border-border-strong bg-surface text-muted-foreground"
                  }`}
                >
                  {answered && isAnswer ? "✓" : answered && isSelected ? "✕" : letter}
                </span>
                <span
                  className={`text-sm leading-relaxed ${
                    answered && isAnswer
                      ? "font-semibold text-success"
                      : answered && isSelected
                        ? "font-semibold text-danger"
                        : "text-foreground"
                  }`}
                >
                  {option.label}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {showFeedback && (
        <div
          className={`mt-5 rounded-xl border p-4 ${
            isCorrect
              ? "border-success/30 bg-success/10"
              : "border-danger/30 bg-danger/10"
          }`}
        >
          <p
            className={`text-sm font-semibold ${
              isCorrect ? "text-success" : "text-danger"
            }`}
          >
            {isCorrect ? "Jawaban benar" : "Jawaban kurang tepat"}
          </p>
          <p className="mt-1 text-sm leading-relaxed text-foreground">
            {current.explanation}
          </p>
        </div>
      )}

      <button
        onClick={handleNext}
        disabled={!showFeedback}
        className="mt-8 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md disabled:translate-y-0 disabled:scale-100 disabled:cursor-not-allowed disabled:bg-primary-200 disabled:text-primary-400 disabled:shadow-none"
      >
        {isLast ? "Lihat hasil" : "Lanjut"}
      </button>

      {onSkip && (
        <button
          type="button"
          onClick={onSkip}
          className="mt-3 w-full text-center text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
        >
          Lewati untuk sekarang
        </button>
      )}
    </div>
  );
}
