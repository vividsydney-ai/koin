"use client";

import { useState } from "react";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { normalizeAnswer } from "@/lib/lessons/question";
import { CandlestickChart } from "@/components/charts/CandlestickChart";
import type { ChartMarker } from "@/components/charts/CandlestickChart";

interface QuizOption {
  label: string;
  value: string;
}

interface QuizChart {
  candles: { open: number; high: number; low: number; close: number; label?: string }[];
  markers?: ChartMarker[];
}

export interface MultipleChoiceContentProps {
  question: string;
  options: QuizOption[];
  correctValue: string;
  explanation: string;
  onComplete?: (correct: boolean, response?: string) => void;
  kicker?: string;
  chart?: QuizChart;
}

function ListIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      width="13"
      height="13"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <line x1="8" y1="6" x2="21" y2="6" />
      <line x1="8" y1="12" x2="21" y2="12" />
      <line x1="8" y1="18" x2="21" y2="18" />
      <line x1="3" y1="6" x2="3.01" y2="6" />
      <line x1="3" y1="12" x2="3.01" y2="12" />
      <line x1="3" y1="18" x2="3.01" y2="18" />
    </svg>
  );
}

export function MultipleChoiceContent({
  question,
  options,
  correctValue,
  explanation,
  onComplete,
  kicker = "Multiple choice",
  chart,
}: MultipleChoiceContentProps) {
  const { locale } = useLocale();
  const [selected, setSelected] = useState<string | null>(null);
  const [showResult, setShowResult] = useState(false);
  const canonicalCorrectOption = options.find(
    (option) => normalizeAnswer(option.value) === normalizeAnswer(correctValue),
  );
  const canonicalCorrectValue = canonicalCorrectOption?.value ?? correctValue;

  const handleSelect = (value: string) => {
    if (showResult) return;
    setSelected(value);
    setShowResult(true);
    onComplete?.(normalizeAnswer(value) === normalizeAnswer(correctValue), value);
  };

  const isCorrect = selected !== null && normalizeAnswer(selected) === normalizeAnswer(correctValue);

  return (
    <>
      {kicker && (
        <span className="inline-flex items-center gap-1.5 rounded-full bg-warning/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-warning">
          <ListIcon />
          {kicker}
        </span>
      )}
      <h3 className={`text-lg font-semibold leading-snug text-foreground ${kicker ? "mt-3" : ""}`}>{question}</h3>

      {chart && (
        <div className="mt-4">
          <CandlestickChart
            candles={chart.candles}
            label={locale === "id" ? "Grafik latihan" : "Practice chart"}
            caption={locale === "id" ? "Harga ilustratif untuk pembelajaran saja." : "Illustrative prices for learning only."}
            accent="core"
            compact={false}
            markers={chart.markers}
          />
        </div>
      )}

      <div className="mt-4 grid gap-3">
        {options.map((option) => {
          const status =
            showResult && normalizeAnswer(option.value) === normalizeAnswer(correctValue)
              ? "correct"
              : showResult && option.value === selected
                ? "wrong"
                : "neutral";

          return (
            <button
              key={option.value}
              onClick={() => handleSelect(option.value)}
              disabled={showResult}
              className={`flex w-full items-center gap-3 rounded-md border px-4 py-3.5 text-left text-sm font-semibold transition-all active:scale-[0.98] disabled:cursor-default ${
                status === "correct"
                  ? "border-success bg-success/10 text-success"
                  : status === "wrong"
                    ? "border-danger bg-danger/5 text-danger"
                    : "border-muted bg-surface text-foreground hover:border-primary/40 hover:bg-primary/5"
              }`}
            >
              <span
                className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border text-xs ${
                  status === "correct"
                    ? "border-success bg-success text-white"
                    : status === "wrong"
                      ? "border-danger bg-danger text-white"
                      : "border-muted-foreground/30"
                }`}
                aria-hidden="true"
              >
                {status === "correct" ? "✓" : status === "wrong" ? "✕" : ""}
              </span>
              {option.label}
            </button>
          );
        })}
      </div>

      {showResult && (
        <Explanation isCorrect={isCorrect} text={explanation} correctAnswer={canonicalCorrectValue} />
      )}
    </>
  );
}

function Explanation({
  isCorrect,
  text,
  correctAnswer,
}: {
  isCorrect: boolean;
  text: string;
  correctAnswer?: string;
}) {
  const { t } = useLocale();
  return (
    <div className="mt-4 rounded-md bg-muted p-3 text-sm font-medium text-foreground">
      {!isCorrect && correctAnswer && (
        <p className="mb-1 font-bold">
          {t("quiz.correctAnswer")} {correctAnswer}
        </p>
      )}
      <p>{text}</p>
    </div>
  );
}

type QuizCardProps = MultipleChoiceContentProps;

export function QuizCard(props: QuizCardProps) {
  return (
    <article className="rounded-card border border-warning/30 bg-surface p-5 shadow-sm">
      <MultipleChoiceContent {...props} />
    </article>
  );
}
