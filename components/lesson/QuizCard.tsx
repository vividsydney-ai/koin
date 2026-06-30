"use client";

import { useState } from "react";

interface QuizOption {
  label: string;
  value: string;
}

interface QuizCardProps {
  question: string;
  options: QuizOption[];
  correctValue: string;
  explanation: string;
  onComplete?: (correct: boolean) => void;
}

export function QuizCard({ question, options, correctValue, explanation, onComplete }: QuizCardProps) {
  const [selected, setSelected] = useState<string | null>(null);
  const [showResult, setShowResult] = useState(false);

  const handleSelect = (value: string) => {
    if (showResult) return;
    setSelected(value);
    setShowResult(true);
    onComplete?.(value === correctValue);
  };

  const isCorrect = selected === correctValue;

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold leading-snug text-foreground">{question}</h3>

      <div className="grid gap-2">
        {options.map((option) => {
          const status =
            showResult && option.value === correctValue
              ? "correct"
              : showResult && option.value === selected
                ? "wrong"
                : "neutral";

          return (
            <button
              key={option.value}
              onClick={() => handleSelect(option.value)}
              disabled={showResult}
              className={`rounded-radius-md border px-4 py-3 text-left text-sm font-medium transition-all duration-200 ${
                status === "correct"
                  ? "border-success bg-success/10 text-success"
                  : status === "wrong"
                    ? "border-danger bg-danger/5 text-danger"
                    : "border-muted bg-surface text-foreground hover:border-primary/40 hover:bg-primary/5"
              }`}
            >
              <span className="flex items-center gap-3">
                <span
                  className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border text-xs ${
                    status === "correct"
                      ? "border-success bg-success text-white"
                      : status === "wrong"
                        ? "border-danger bg-danger text-white"
                        : "border-muted-foreground/30"
                  }`}
                >
                  {status === "correct" ? "✓" : status === "wrong" ? "✕" : ""}
                </span>
                {option.label}
              </span>
            </button>
          );
        })}
      </div>

      {showResult && (
        <div
          className={`rounded-radius-md border px-4 py-3 text-sm ${
            isCorrect ? "border-success/30 bg-success/5 text-success" : "border-danger/30 bg-danger/5 text-danger"
          }`}
        >
          {explanation}
        </div>
      )}
    </div>
  );
}
