"use client";

import { useMemo, useState } from "react";
import { QuizCard } from "./QuizCard";
import { seededShuffle } from "@/lib/lessons/random";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import {
  normalizeAnswer,
  type ProcessedQuestion,
  type MultipleChoiceQuestion,
  type TrueFalseQuestion,
  type FillBlankQuestion,
  type WordBankQuestion,
  type OrderingQuestion,
  type MatchingQuestion,
  type CaseStudyQuestion,
} from "@/lib/lessons/question";

interface QuizEngineProps {
  question: ProcessedQuestion;
  seed: string;
  onComplete?: (correct: boolean) => void;
}

export function QuizEngine({ question, seed, onComplete }: QuizEngineProps) {
  const { t } = useLocale();
  switch (question.type) {
    case "multiple_choice":
      return <MultipleChoice question={question} seed={seed} onComplete={onComplete} />;
    case "true_false":
      return <TrueFalse question={question} onComplete={onComplete} />;
    case "fill_blank":
      return <FillBlank question={question} onComplete={onComplete} />;
    case "word_bank":
      return <WordBank question={question} seed={seed} onComplete={onComplete} />;
    case "ordering":
      return <Ordering question={question} seed={seed} onComplete={onComplete} />;
    case "matching":
      return <Matching question={question} seed={seed} onComplete={onComplete} />;
    case "case_study":
      return <CaseStudy question={question} seed={seed} onComplete={onComplete} />;
    default:
      return (
        <div className="rounded-radius-md border border-warning/30 bg-warning/5 px-4 py-3 text-sm text-warning">
          {t("quiz.notSupported").replace("{type}", question.type)}
        </div>
      );
  }
}

function MultipleChoice({
  question,
  seed,
  onComplete,
}: {
  question: MultipleChoiceQuestion;
  seed: string;
  onComplete?: (correct: boolean) => void;
}) {
  const options = useMemo(
    () =>
      seededShuffle(`${seed}:mc`, question.options).map((label) => ({ label, value: label })),
    [question.options, seed]
  );

  return (
    <QuizCard
      question={question.question}
      options={options}
      correctValue={question.answer}
      explanation={question.explanation}
      onComplete={onComplete}
    />
  );
}

function TrueFalse({
  question,
  onComplete,
}: {
  question: TrueFalseQuestion;
  onComplete?: (correct: boolean) => void;
}) {
  const { t } = useLocale();
  const [showResult, setShowResult] = useState(false);
  const [selected, setSelected] = useState<boolean | null>(null);
  const isCorrect = selected === question.answer;

  const handleSelect = (value: boolean) => {
    if (showResult) return;
    setSelected(value);
    setShowResult(true);
    onComplete?.(value === question.answer);
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <div className="grid grid-cols-2 gap-3">
        <AnswerButton
          label={t("quiz.true")}
          showResult={showResult}
          isSelected={selected === true}
          isCorrect={question.answer === true}
          onClick={() => handleSelect(true)}
        />
        <AnswerButton
          label={t("quiz.false")}
          showResult={showResult}
          isSelected={selected === false}
          isCorrect={question.answer === false}
          onClick={() => handleSelect(false)}
        />
      </div>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer ? t("quiz.true") : t("quiz.false")} />}
    </div>
  );
}

function FillBlank({
  question,
  onComplete,
}: {
  question: FillBlankQuestion;
  onComplete?: (correct: boolean) => void;
}) {
  const { t } = useLocale();
  const [value, setValue] = useState("");
  const [showResult, setShowResult] = useState(false);
  const isCorrect = normalizeAnswer(value) === normalizeAnswer(question.answer);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!value.trim() || showResult) return;
    setShowResult(true);
    onComplete?.(isCorrect);
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <form onSubmit={handleSubmit} className="space-y-3">
        <input
          type="text"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          disabled={showResult}
          placeholder={t("quiz.typeAnswer")}
          className="w-full rounded-radius-md border border-muted bg-surface px-4 py-3 text-sm text-foreground outline-none transition-colors focus:border-primary"
          aria-label={t("quiz.typeAnswer")}
        />
        <button
          type="submit"
          disabled={showResult || !value.trim()}
          className="w-full rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
        >
          {t("quiz.checkAnswer")}
        </button>
      </form>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer} />}
    </div>
  );
}

function WordBank({
  question,
  seed,
  onComplete,
}: {
  question: WordBankQuestion;
  seed: string;
  onComplete?: (correct: boolean) => void;
}) {
  const { t } = useLocale();
  const shuffledBank = useMemo(() => seededShuffle(`${seed}:wb`, question.options), [question.options, seed]);
  const [bank, setBank] = useState<string[]>(shuffledBank);
  const [slots, setSlots] = useState<(string | null)[]>(question.answer.map(() => null));
  const [showResult, setShowResult] = useState(false);

  const filled = slots.every(Boolean);
  const currentAnswer = slots.map((s) => s ?? "");
  const isCorrect = currentAnswer.every((word, i) => word === question.answer[i]);

  const fillSlot = (word: string) => {
    if (showResult) return;
    const slotIndex = slots.findIndex((s) => !s);
    if (slotIndex === -1) return;
    const newSlots = [...slots];
    newSlots[slotIndex] = word;
    setSlots(newSlots);
    setBank((prev) => prev.filter((w) => w !== word));
  };

  const returnToBank = (index: number) => {
    if (showResult) return;
    const word = slots[index];
    if (!word) return;
    const newSlots = [...slots];
    newSlots[index] = null;
    setSlots(newSlots);
    setBank((prev) => [...prev, word]);
  };

  const check = () => {
    if (!filled || showResult) return;
    setShowResult(true);
    onComplete?.(isCorrect);
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <div className="flex flex-wrap gap-2">
        {slots.map((word, i) => (
          <button
            key={i}
            onClick={() => returnToBank(i)}
            disabled={showResult || !word}
            className="flex h-11 min-w-[5rem] items-center justify-center rounded-radius-md border border-dashed border-muted bg-surface px-3 text-sm font-medium text-foreground transition-colors hover:border-primary disabled:cursor-default"
            aria-label={word ? `Filled slot ${i + 1}: ${word}` : `Empty slot ${i + 1}`}
          >
            {word ?? "—"}
          </button>
        ))}
      </div>
      <div className="flex flex-wrap gap-2">
        {bank.map((word) => (
          <button
            key={word}
            onClick={() => fillSlot(word)}
            disabled={showResult}
            className="rounded-radius-md bg-primary/10 px-3 py-2 text-sm font-semibold text-primary transition-colors hover:bg-primary/20"
          >
            {word}
          </button>
        ))}
      </div>
      <button
        onClick={check}
        disabled={!filled || showResult}
        className="w-full rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
      >
        {t("quiz.checkAnswer")}
      </button>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer.join(" → ")} />}
    </div>
  );
}

function Ordering({
  question,
  seed,
  onComplete,
}: {
  question: OrderingQuestion;
  seed: string;
  onComplete?: (correct: boolean) => void;
}) {
  const { t } = useLocale();
  const [order, setOrder] = useState<string[]>(() => seededShuffle(`${seed}:ord`, question.options));
  const [selectedIndex, setSelectedIndex] = useState<number | null>(null);
  const [showResult, setShowResult] = useState(false);
  const isCorrect = question.answer.every((item, i) => item === order[i]);

  const handleSelect = (index: number) => {
    if (showResult) return;
    if (selectedIndex === null) {
      setSelectedIndex(index);
      return;
    }
    if (selectedIndex === index) {
      setSelectedIndex(null);
      return;
    }
    const newOrder = [...order];
    [newOrder[selectedIndex], newOrder[index]] = [newOrder[index], newOrder[selectedIndex]];
    setOrder(newOrder);
    setSelectedIndex(null);
  };

  const check = () => {
    if (showResult) return;
    setShowResult(true);
    onComplete?.(isCorrect);
  };

  return (
    <div className="space-y-4">
      <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <p className="text-xs text-muted-foreground">{t("quiz.tapTwoItems")}</p>
      <div className="space-y-2">
        {order.map((item, i) => (
          <button
            key={`${item}-${i}`}
            onClick={() => handleSelect(i)}
            disabled={showResult}
            className={`flex w-full items-center gap-3 rounded-radius-md border px-4 py-3 text-left text-sm font-medium transition-all ${
              selectedIndex === i
                ? "border-primary bg-primary/10 text-primary"
                : "border-muted bg-surface text-foreground hover:border-primary/40"
            }`}
          >
            <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-radius-sm bg-muted text-xs font-bold text-muted-foreground">
              {i + 1}
            </span>
            {item}
          </button>
        ))}
      </div>
      <button
        onClick={check}
        disabled={showResult}
        className="w-full rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
      >
        {t("quiz.checkAnswer")}
      </button>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer.join(" → ")} />}
    </div>
  );
}

function Matching({
  question,
  seed,
  onComplete,
}: {
  question: MatchingQuestion;
  seed: string;
  onComplete?: (correct: boolean) => void;
}) {
  const { t } = useLocale();
  const leftItems = useMemo(() => question.pairs.map(([left]) => left), [question.pairs]);
  const rightItems = useMemo(() => seededShuffle(`${seed}:match`, question.pairs.map(([, right]) => right)), [question.pairs, seed]);
  const [matches, setMatches] = useState<Record<string, string | null>>(() =>
    Object.fromEntries(leftItems.map((left) => [left, null]))
  );
  const [showResult, setShowResult] = useState(false);

  const filled = leftItems.every((left) => matches[left] != null);
  const isCorrect = leftItems.every((left) => matches[left] === question.answer[left]);

  const assign = (left: string, right: string) => {
    if (showResult) return;
    setMatches((prev) => ({ ...prev, [left]: right }));
  };

  const unassign = (left: string) => {
    if (showResult) return;
    setMatches((prev) => ({ ...prev, [left]: null }));
  };

  const check = () => {
    if (!filled || showResult) return;
    setShowResult(true);
    onComplete?.(isCorrect);
  };

  const usedRights = new Set(Object.values(matches).filter(Boolean));

  return (
    <div className="space-y-5">
      <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <p className="text-xs text-muted-foreground">{t("quiz.tapDefinition")}</p>
      <div className="space-y-3">
        {leftItems.map((left) => (
          <div key={left} className="rounded-radius-md border border-muted bg-surface p-4">
            <div className="mb-2 text-sm font-semibold text-foreground">{left}</div>
            {matches[left] ? (
              <button
                onClick={() => unassign(left)}
                disabled={showResult}
                className={`rounded-radius-md px-3 py-2 text-sm font-medium transition-colors ${
                  showResult
                    ? matches[left] === question.answer[left]
                      ? "bg-success/10 text-success"
                      : "bg-danger/10 text-danger"
                    : "bg-primary/10 text-primary hover:bg-primary/20"
                }`}
              >
                {matches[left]}
              </button>
            ) : (
              <div className="flex flex-wrap gap-2">
                {rightItems
                  .filter((right) => !usedRights.has(right))
                  .map((right) => (
                    <button
                      key={`${left}-${right}`}
                      onClick={() => assign(left, right)}
                      className="rounded-radius-md border border-muted bg-surface px-3 py-2 text-sm font-medium text-foreground transition-colors hover:border-primary hover:bg-primary/5"
                    >
                      {right}
                    </button>
                  ))}
              </div>
            )}
          </div>
        ))}
      </div>
      <button
        onClick={check}
        disabled={!filled || showResult}
        className="w-full rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
      >
        {t("quiz.checkAnswer")}
      </button>
      {showResult && (
        <Explanation
          isCorrect={isCorrect}
          text={question.explanation}
          correctAnswer={leftItems.map((left) => `${left}: ${question.answer[left]}`).join(" · ")}
        />
      )}
    </div>
  );
}

function CaseStudy({
  question,
  seed,
  onComplete,
}: {
  question: CaseStudyQuestion;
  seed: string;
  onComplete?: (correct: boolean) => void;
}) {
  return (
    <div className="space-y-5">
      <div className="rounded-radius-lg border border-primary/20 bg-primary/5 p-5">
        <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
        <p className="mt-3 text-[15px] leading-relaxed text-muted-foreground">{question.caseText}</p>
      </div>
      <div>
        <p className="mb-3 text-sm font-semibold text-foreground">{question.followUp.question}</p>
        <MultipleChoice
          question={{ ...question.followUp, type: "multiple_choice" }}
          seed={`${seed}:cs`}
          onComplete={onComplete}
        />
      </div>
    </div>
  );
}

function AnswerButton({
  label,
  showResult,
  isSelected,
  isCorrect,
  onClick,
}: {
  label: string;
  showResult: boolean;
  isSelected: boolean;
  isCorrect: boolean;
  onClick: () => void;
}) {
  const status = showResult ? (isCorrect ? "correct" : isSelected ? "wrong" : "neutral") : "neutral";

  return (
    <button
      onClick={onClick}
      disabled={showResult}
      className={`min-h-11 rounded-radius-md border px-4 py-3 text-sm font-semibold transition-all active:scale-[0.98] disabled:cursor-default ${
        status === "correct"
          ? "border-success bg-success/10 text-success"
          : status === "wrong"
            ? "border-danger bg-danger/5 text-danger"
            : "border-muted bg-surface text-foreground hover:border-primary/40 hover:bg-primary/5"
      }`}
    >
      {label}
    </button>
  );
}

function Explanation({ isCorrect, text, correctAnswer }: { isCorrect: boolean; text: string; correctAnswer?: string }) {
  const { t } = useLocale();
  return (
    <div
      className={`space-y-1.5 rounded-radius-md border px-4 py-3 text-sm ${
        isCorrect ? "border-success/30 bg-success/5 text-success" : "border-danger/30 bg-danger/5 text-danger"
      }`}
    >
      {!isCorrect && correctAnswer && (
        <p className="font-semibold">
          {t("quiz.correctAnswer")} {correctAnswer}
        </p>
      )}
      <p>{text}</p>
    </div>
  );
}
