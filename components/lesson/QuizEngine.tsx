"use client";

import { useMemo, useState } from "react";
import { QuizCard, MultipleChoiceContent } from "./QuizCard";
import { seededShuffle } from "@/lib/lessons/random";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import {
  normalizeAnswer,
  type ProcessedQuestion,
  type MultipleChoiceQuestion,
  type TrueFalseQuestion,
  type SwipeYesNoQuestion,
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
  onAnswer?: QuizCompletion;
}

export type QuizCompletion = (correct: boolean, response?: string | boolean) => void;

export function QuizEngine({ question, seed, onComplete, onAnswer }: QuizEngineProps) {
  const forwardCompletion: QuizCompletion = (correct, response) => {
    onComplete?.(correct);
    onAnswer?.(correct, response);
  };
  const { t } = useLocale();
  switch (question.type) {
    case "multiple_choice":
      return <MultipleChoice question={question} seed={seed} onComplete={forwardCompletion} />;
    case "true_false":
      return <TrueFalse question={question} onComplete={forwardCompletion} />;
    case "swipe_yes_no":
      return <YesNo question={question} onComplete={forwardCompletion} />;
    case "fill_blank":
      return <FillBlank question={question} onComplete={forwardCompletion} />;
    case "word_bank":
      return <WordBank question={question} seed={seed} onComplete={forwardCompletion} />;
    case "ordering":
      return <Ordering question={question} seed={seed} onComplete={forwardCompletion} />;
    case "matching":
      return <Matching question={question} seed={seed} onComplete={forwardCompletion} />;
    case "case_study":
      return <CaseStudy question={question} seed={seed} onComplete={forwardCompletion} />;
    default:
      return (
        <div className="rounded-md border border-warning/30 bg-warning/5 px-4 py-3 text-sm text-warning">
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
  onComplete?: QuizCompletion;
}) {
  const { t } = useLocale();
  return (
    <BinaryChoice
      question={question.question}
      trueLabel={t("quiz.true")}
      falseLabel={t("quiz.false")}
      answer={question.answer}
      explanation={question.explanation}
      onComplete={onComplete}
      kicker={`${t("quiz.true")} / ${t("quiz.false")}`}
      kickerIcon={<ToggleIcon />}
      tint="primary"
    />
  );
}

function YesNo({
  question,
  onComplete,
}: {
  question: SwipeYesNoQuestion;
  onComplete?: QuizCompletion;
}) {
  const { t } = useLocale();
  return (
    <BinaryChoice
      question={question.question}
      trueLabel={t("quiz.yes")}
      falseLabel={t("quiz.no")}
      answer={question.answer}
      explanation={question.explanation}
      onComplete={onComplete}
      kicker={`${t("quiz.yes")} / ${t("quiz.no")}`}
      kickerIcon={<ThumbsUpIcon />}
      tint="info"
    />
  );
}

function FillBlank({
  question,
  onComplete,
}: {
  question: FillBlankQuestion;
  onComplete?: QuizCompletion;
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
    <QuizCardShell kicker="Fill in the blank" kickerIcon={<TypeIcon />} tint="info">
      <h3 className="mt-3 text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <form onSubmit={handleSubmit} className="mt-4 space-y-3">
        <input
          type="text"
          value={value}
          onChange={(e) => setValue(e.target.value)}
          disabled={showResult}
          placeholder={t("quiz.typeAnswer")}
          className="w-full rounded-md border border-muted bg-surface px-4 py-3.5 text-sm text-foreground outline-none transition-colors focus:border-primary"
          aria-label={t("quiz.typeAnswer")}
        />
        <button
          type="submit"
          disabled={showResult || !value.trim()}
          className="w-full rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
        >
          {t("quiz.checkAnswer")}
        </button>
      </form>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer} />}
    </QuizCardShell>
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
    <QuizCardShell kicker="Word bank" kickerIcon={<GridIcon />}>
      <h3 className="mt-3 text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <div className="mt-4 flex flex-wrap gap-2">
        {slots.map((word, i) => (
          <button
            key={i}
            onClick={() => returnToBank(i)}
            disabled={showResult || !word}
            className="flex h-11 min-w-[5rem] items-center justify-center rounded-md border border-dashed border-muted bg-surface px-3 text-sm font-semibold text-foreground transition-colors hover:border-primary disabled:cursor-default"
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
            className="rounded-md border border-muted bg-surface px-3 py-2 text-sm font-semibold text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5 disabled:cursor-default disabled:opacity-50"
          >
            {word}
          </button>
        ))}
      </div>
      <button
        onClick={check}
        disabled={!filled || showResult}
        className="mt-4 w-full rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
      >
        {t("quiz.checkAnswer")}
      </button>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer.join(" → ")} />}
    </QuizCardShell>
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
    <QuizCardShell kicker="Ordering" kickerIcon={<SortIcon />}>
      <h3 className="mt-3 text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <p className="mt-2 text-xs text-muted-foreground">{t("quiz.tapTwoItems")}</p>
      <div className="mt-4 space-y-3">
        {order.map((item, i) => {
          const status = selectedIndex === i ? "primary" : "neutral";
          return (
            <ChoiceButton
              key={`${item}-${i}`}
              status={status}
              onClick={() => handleSelect(i)}
              disabled={showResult}
            >
              <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-sm bg-muted text-xs font-bold text-muted-foreground">
                {i + 1}
              </span>
              {item}
            </ChoiceButton>
          );
        })}
      </div>
      <button
        onClick={check}
        disabled={showResult}
        className="mt-4 w-full rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
      >
        {t("quiz.checkAnswer")}
      </button>
      {showResult && <Explanation isCorrect={isCorrect} text={question.explanation} correctAnswer={question.answer.join(" → ")} />}
    </QuizCardShell>
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
    <QuizCardShell kicker="Matching" kickerIcon={<LinkIcon />}>
      <h3 className="mt-3 text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
      <p className="mt-2 text-xs text-muted-foreground">{t("quiz.tapDefinition")}</p>
      <div className="mt-4 space-y-3">
        {leftItems.map((left) => (
          <div key={left} className="rounded-md border border-muted bg-surface p-4">
            <div className="mb-2 text-sm font-semibold text-foreground">{left}</div>
            {matches[left] ? (
              <button
                onClick={() => unassign(left)}
                disabled={showResult}
                className={`rounded-md border px-3 py-2 text-sm font-semibold transition-colors disabled:cursor-default ${
                  showResult
                    ? matches[left] === question.answer[left]
                      ? "border-success bg-success/10 text-success"
                      : "border-danger bg-danger/5 text-danger"
                    : "border-primary bg-primary/10 text-primary hover:bg-primary/20"
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
                      className="rounded-md border border-muted bg-surface px-3 py-2 text-sm font-semibold text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5"
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
        className="mt-4 w-full rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
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
    </QuizCardShell>
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
  const followUpOptions = useMemo(
    () =>
      seededShuffle(`${seed}:cs`, question.followUp.options).map((label) => ({
        label,
        value: label,
      })),
    [question.followUp.options, seed]
  );

  return (
    <QuizCardShell kicker="Case study" kickerIcon={<FileTextIcon />}>
      <div className="mt-3 rounded-lg border border-primary/20 bg-primary/5 p-5">
        <h3 className="text-lg font-semibold leading-snug text-foreground">{question.question}</h3>
        <p className="mt-3 text-[15px] leading-relaxed text-muted-foreground">{question.caseText}</p>
      </div>
      <div className="mt-5">
        <p className="mb-3 text-sm font-semibold text-foreground">{question.followUp.question}</p>
        <MultipleChoiceContent
          question={question.followUp.question}
          options={followUpOptions}
          correctValue={question.followUp.answer}
          explanation={question.followUp.explanation}
          onComplete={onComplete}
          kicker=""
        />
      </div>
    </QuizCardShell>
  );
}

type Tint = "primary" | "warning" | "info";

const tintClasses: Record<Tint, { border: string; kicker: string }> = {
  primary: { border: "border-primary/30", kicker: "bg-primary/10 text-primary" },
  warning: { border: "border-warning/30", kicker: "bg-warning/10 text-warning" },
  info: { border: "border-info/30", kicker: "bg-info/10 text-info" },
};

function QuizCardShell({
  kicker,
  kickerIcon,
  tint = "primary",
  children,
}: {
  kicker: string;
  kickerIcon: React.ReactNode;
  tint?: Tint;
  children: React.ReactNode;
}) {
  const { border, kicker: kickerClass } = tintClasses[tint];
  return (
    <article className={`rounded-card border ${border} bg-surface p-5 shadow-sm`}>
      <span className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide ${kickerClass}`}>
        {kickerIcon}
        {kicker}
      </span>
      {children}
    </article>
  );
}

function ChoiceButton({
  status,
  onClick,
  disabled,
  children,
}: {
  status: "neutral" | "correct" | "wrong" | "primary";
  onClick?: () => void;
  disabled?: boolean;
  children: React.ReactNode;
}) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`flex w-full items-center gap-3 rounded-md border px-4 py-3.5 text-left text-sm font-semibold transition-all active:scale-[0.98] disabled:cursor-default disabled:opacity-50 ${
        status === "correct"
          ? "border-success bg-success/10 text-success"
          : status === "wrong"
            ? "border-danger bg-danger/5 text-danger"
            : status === "primary"
              ? "border-primary bg-primary/10 text-primary"
              : "border-muted bg-surface text-foreground hover:border-primary/40 hover:bg-primary/5"
      }`}
    >
      {children}
    </button>
  );
}

function BinaryChoice({
  question,
  trueLabel,
  falseLabel,
  answer,
  explanation,
  onComplete,
  kicker,
  kickerIcon,
  tint = "primary",
}: {
  question: string;
  trueLabel: string;
  falseLabel: string;
  answer: boolean;
  explanation: string;
  onComplete?: QuizCompletion;
  kicker: string;
  kickerIcon: React.ReactNode;
  tint?: Tint;
}) {
  const [showResult, setShowResult] = useState(false);
  const [selected, setSelected] = useState<boolean | null>(null);
  const isCorrect = selected === answer;

  const handleSelect = (value: boolean) => {
    if (showResult) return;
    setSelected(value);
    setShowResult(true);
    onComplete?.(value === answer, value);
  };

  return (
    <QuizCardShell kicker={kicker} kickerIcon={kickerIcon} tint={tint}>
      <h3 className="mt-3 text-lg font-semibold leading-snug text-foreground">{question}</h3>
      <div className="mt-4 grid grid-cols-2 gap-3">
        <BinaryButton
          label={trueLabel}
          icon={<CheckIcon className="h-[18px] w-[18px]" />}
          showResult={showResult}
          isSelected={selected === true}
          isCorrect={answer === true}
          onClick={() => handleSelect(true)}
        />
        <BinaryButton
          label={falseLabel}
          icon={<XIcon className="h-[18px] w-[18px]" />}
          showResult={showResult}
          isSelected={selected === false}
          isCorrect={answer === false}
          onClick={() => handleSelect(false)}
        />
      </div>
      {showResult && (
        <Explanation isCorrect={isCorrect} text={explanation} correctAnswer={answer ? trueLabel : falseLabel} />
      )}
    </QuizCardShell>
  );
}

function BinaryButton({
  label,
  icon,
  showResult,
  isSelected,
  isCorrect,
  onClick,
}: {
  label: string;
  icon: React.ReactNode;
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
      className={`flex min-h-11 items-center justify-center gap-2 rounded-md border px-4 py-3.5 text-sm font-semibold transition-all active:scale-[0.98] disabled:cursor-default ${
        status === "correct"
          ? "border-success bg-success/10 text-success"
          : status === "wrong"
            ? "border-danger bg-danger/5 text-danger"
            : "border-muted bg-surface text-foreground hover:border-primary/40 hover:bg-primary/5"
      }`}
    >
      {icon}
      {label}
    </button>
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

function ToggleIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <rect x="2" y="6" width="20" height="12" rx="6" />
      <circle cx="8" cy="12" r="2" />
    </svg>
  );
}

function TypeIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <polyline points="4 7 4 4 20 4 20 7" />
      <line x1="9" y1="20" x2="15" y2="20" />
      <line x1="12" y1="4" x2="12" y2="20" />
    </svg>
  );
}

function GridIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <rect x="3" y="3" width="7" height="7" />
      <rect x="14" y="3" width="7" height="7" />
      <rect x="14" y="14" width="7" height="7" />
      <rect x="3" y="14" width="7" height="7" />
    </svg>
  );
}

function SortIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="m3 16 4 4 4-4" />
      <path d="M7 20V4" />
      <path d="m21 8-4-4-4 4" />
      <path d="M17 4v16" />
    </svg>
  );
}

function LinkIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71" />
      <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71" />
    </svg>
  );
}

function FileTextIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
      <path d="M14 2v4a2 2 0 0 0 2 2h4" />
      <path d="M10 9H8" />
      <path d="M16 13H8" />
      <path d="M16 17H8" />
    </svg>
  );
}

function CheckIcon({ className }: { className?: string }) {
  return (
    <svg className={className} width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <polyline points="20 6 9 17 4 12" />
    </svg>
  );
}

function XIcon({ className }: { className?: string }) {
  return (
    <svg className={className} width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M18 6 6 18" />
      <path d="m6 6 12 12" />
    </svg>
  );
}

function ThumbsUpIcon() {
  return (
    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M7 10v12" />
      <path d="M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h3" />
    </svg>
  );
}
