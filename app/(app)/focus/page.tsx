"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth/use-auth";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import {
  getDailyFocusChallenge,
  getLocalTimeZone,
  refillDailyFocus,
  submitDailyFocusAnswer,
  type DailyFocusQuestion,
  type DailyFocusState,
} from "@/lib/focus/client";

type FocusAnswer = string | boolean | string[];

export default function DailyFocusPage() {
  const { user, loading: authLoading } = useAuth(true);
  const { locale } = useLocale();
  const [focus, setFocus] = useState<DailyFocusState | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [refilling, setRefilling] = useState(false);
  const [pendingQuestion, setPendingQuestion] = useState<DailyFocusQuestion | null>(null);
  const [feedback, setFeedback] = useState<{ correct: boolean; explanation: string | null; answer: string | boolean | null } | null>(null);
  const [error, setError] = useState<string | null>(null);
  const timeZone = getLocalTimeZone();

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user) return;
      setLoading(true);
      const state = await getDailyFocusChallenge(timeZone);
      if (!mounted) return;
      setFocus(state);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, [user, timeZone]);

  const currentIndex = focus?.questionsAnswered ?? 0;
  const currentQuestion = pendingQuestion ?? focus?.questions[currentIndex] ?? null;

  const answer = async (value: FocusAnswer) => {
    if (!focus || !currentQuestion || submitting || feedback) return;
    setSubmitting(true);
    setError(null);
    setPendingQuestion(currentQuestion);

    const result = await submitDailyFocusAnswer(currentIndex, value, timeZone);
    if (result.error || !result.state) {
      setError(result.error ?? "We could not record that answer. Please try again.");
      setPendingQuestion(null);
      setSubmitting(false);
      return;
    }

    setFocus(result.state);
    setFeedback({
      correct: result.state.answerCorrect === true,
      explanation: result.state.explanation,
      answer: result.state.correctAnswer,
    });
    setSubmitting(false);
  };

  const continueChallenge = () => {
    setPendingQuestion(null);
    setFeedback(null);
    setError(null);
  };

  const refill = async () => {
    if (refilling) return;
    setRefilling(true);
    setError(null);
    const result = await refillDailyFocus(timeZone);
    if (result.error || !result.state) {
      setError(result.error ?? "We could not refill Focus right now.");
    } else {
      setFocus(result.state);
    }
    setRefilling(false);
  };

  if (authLoading || loading) {
    return (
      <div className="min-h-screen bg-background p-5 pb-28">
        <div className="h-7 w-28 animate-pulse rounded bg-surface-inset" />
        <div className="mt-6 h-64 animate-pulse rounded-card bg-surface-inset" />
      </div>
    );
  }

  if (!focus) {
    return (
      <div className="min-h-screen bg-background p-5 pb-28">
        <BackLink />
        <section className="mt-6 rounded-card border border-muted bg-surface p-6 text-center shadow-sm">
          <FocusMark className="mx-auto h-10 w-10 text-primary" />
          <h1 className="mt-4 font-display text-2xl font-bold text-foreground">Daily Focus is resting</h1>
          <p className="mt-2 text-sm leading-6 text-muted-foreground">We could not load today&apos;s challenge. Please try again in a moment.</p>
          <Link href="/" className="mt-5 inline-flex min-h-11 items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground">
            Back home
          </Link>
        </section>
      </div>
    );
  }

  const finishedAnswer = feedback && focus.status === "completed";

  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <BackLink />

      <header className="mt-6">
        <p className="text-xs font-bold uppercase tracking-[0.16em] text-primary">Optional daily practice</p>
        <div className="mt-2 flex items-start justify-between gap-4">
          <div>
            <h1 className="font-display text-3xl font-bold tracking-tight text-foreground">Daily Focus</h1>
            <p className="mt-1 text-sm text-muted-foreground">Five quick money checks. Lessons always stay unlimited.</p>
            <Link href="/profile/faq" className="mt-2 inline-flex min-h-11 items-center text-sm font-semibold text-primary hover:underline">
              {locale === "id" ? "Cara kerja Daily Focus" : "How Daily Focus works"} →
            </Link>
          </div>
          <FocusMark className="mt-1 h-9 w-9 shrink-0 text-primary" />
        </div>
      </header>

      <section className="mt-6 rounded-card border border-primary/20 bg-[color-mix(in_srgb,var(--color-primary)_6%,var(--color-surface))] p-5 shadow-sm">
        <div className="flex items-center justify-between gap-4">
          <div>
            <p className="text-sm font-bold text-foreground">Your Focus</p>
            <p className="mt-1 text-xs text-muted-foreground">A wrong answer uses one. Core lessons never do.</p>
          </div>
          <FocusPips remaining={focus.focusRemaining} max={focus.maxFocus} />
        </div>
        <div className="mt-5 h-2 overflow-hidden rounded-full bg-surface-inset" role="progressbar" aria-label="Daily Focus question progress" aria-valuemin={0} aria-valuemax={5} aria-valuenow={focus.questionsAnswered}>
          <div className="h-full rounded-full bg-primary transition-[width] duration-200" style={{ width: `${(focus.questionsAnswered / 5) * 100}%` }} />
        </div>
        <div className="mt-2 flex items-center justify-between text-xs font-semibold text-muted-foreground">
          <span>{focus.status === "completed" ? "Complete" : `Question ${Math.min(focus.questionsAnswered + 1, 5)} of 5`}</span>
          <span>{focus.correctAnswers} correct</span>
        </div>
      </section>

      <MissionProgress focus={focus} />

      {error && <p className="mt-4 rounded-md border border-danger/25 bg-danger/5 px-4 py-3 text-sm font-medium text-danger">{error}</p>}

      {focus.status === "active" && currentQuestion && (
        <QuestionCard key={currentIndex} question={currentQuestion} disabled={submitting || Boolean(feedback)} onAnswer={answer} />
      )}

      {feedback && (
        <section className={`mt-5 rounded-card border p-5 shadow-sm ${feedback.correct ? "border-success/30 bg-success/5" : "border-danger/25 bg-danger/5"}`} aria-live="polite">
          <p className={`text-sm font-bold ${feedback.correct ? "text-success" : "text-danger"}`}>{feedback.correct ? "Nice work — your Focus is intact." : "Not quite — one Focus was used."}</p>
          {!feedback.correct && feedback.answer !== null && <p className="mt-2 text-sm font-semibold text-foreground">Correct answer: {String(feedback.answer)}</p>}
          {feedback.explanation && <p className="mt-2 text-sm leading-6 text-muted-foreground">{feedback.explanation}</p>}
          {finishedAnswer ? (
            <CompletionCard focus={focus} />
          ) : focus.status === "exhausted" ? (
            <ExhaustedActions focus={focus} refilling={refilling} onRefill={refill} />
          ) : (
            <button onClick={continueChallenge} className="mt-5 flex min-h-11 w-full items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground transition-colors hover:bg-primary/90">
              Next question
            </button>
          )}
        </section>
      )}

      {!feedback && focus.status === "exhausted" && <ExhaustedActions focus={focus} refilling={refilling} onRefill={refill} />}
      {!feedback && focus.status === "completed" && <CompletionCard focus={focus} />}
    </main>
  );
}

function QuestionCard({ question, disabled, onAnswer }: { question: DailyFocusQuestion; disabled: boolean; onAnswer: (answer: FocusAnswer) => void }) {
  const [fillValue, setFillValue] = useState("");
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const { locale } = useLocale();
  const checkLabel = locale === "id" ? "Periksa jawaban" : "Check answer";

  const handleOption = (value: FocusAnswer) => {
    if (disabled) return;
    onAnswer(value);
  };

  const toggleSelect = (option: string) => {
    if (disabled) return;
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(option)) next.delete(option);
      else next.add(option);
      return next;
    });
  };

  const submitSelectAll = () => {
    if (disabled || selected.size === 0) return;
    onAnswer(Array.from(selected));
  };

  const submitFillBlank = () => {
    if (disabled || !fillValue.trim()) return;
    onAnswer(fillValue.trim());
  };

  return (
    <section className="mt-5 rounded-card border border-muted bg-surface p-5 shadow-sm">
      <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
        <FocusMark className="h-3.5 w-3.5" /> Focus check
      </span>
      <h2 className="mt-3 text-xl font-bold leading-snug text-foreground">{question.question}</h2>

      {question.type === "fill_blank" && (
        <div className="mt-5 space-y-4">
          <label htmlFor="focus-fill-blank" className="sr-only">
            {locale === "id" ? "Ketik jawabanmu" : "Type your answer"}
          </label>
          <input
            id="focus-fill-blank"
            type="text"
            value={fillValue}
            onChange={(e) => setFillValue(e.target.value)}
            disabled={disabled}
            placeholder={locale === "id" ? "Ketik jawabanmu" : "Type your answer"}
            className="h-12 w-full rounded-lg border-[1.5px] border-border bg-background px-4 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring disabled:opacity-60"
            onKeyDown={(e) => {
              if (e.key === "Enter") submitFillBlank();
            }}
          />
          <button
            onClick={submitFillBlank}
            disabled={disabled || !fillValue.trim()}
            className="flex min-h-11 w-full items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground transition-colors hover:bg-primary/90 disabled:opacity-60"
          >
            {checkLabel}
          </button>
        </div>
      )}

      {question.type === "select_all" && (
        <div className="mt-5 space-y-3">
          <p className="text-xs font-semibold text-muted-foreground">{locale === "id" ? "Pilih semua yang benar:" : "Select all that apply:"}</p>
          {(question.options ?? []).map((option) => (
            <label
              key={option}
              className={`flex min-h-12 cursor-pointer items-center gap-3 rounded-md border px-4 text-sm font-semibold text-foreground transition-colors ${
                selected.has(option)
                  ? "border-primary bg-primary/5"
                  : "border-muted bg-surface hover:border-primary/40 hover:bg-primary/5"
              } ${disabled ? "cursor-not-allowed opacity-60" : ""}`}
            >
              <input
                type="checkbox"
                checked={selected.has(option)}
                onChange={() => toggleSelect(option)}
                disabled={disabled}
                className="h-5 w-5 accent-primary"
              />
              <span>{option}</span>
            </label>
          ))}
          <button
            onClick={submitSelectAll}
            disabled={disabled || selected.size === 0}
            className="flex min-h-11 w-full items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground transition-colors hover:bg-primary/90 disabled:opacity-60"
          >
            {checkLabel}
          </button>
        </div>
      )}

      {(question.type === "multiple_choice" || question.type === "true_false" || question.type === "swipe_yes_no") && (
        <div className="mt-5 grid gap-3">
          {question.type === "multiple_choice"
            ? (question.options ?? []).map((option) => (
                <button
                  key={option}
                  disabled={disabled}
                  onClick={() => handleOption(option)}
                  className="flex min-h-12 w-full items-center rounded-md border border-muted bg-surface px-4 text-left text-sm font-semibold text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5 disabled:cursor-wait disabled:opacity-60"
                >
                  {option}
                </button>
              ))
            : [
                { label: locale === "id" ? "Benar" : "True", value: true },
                { label: locale === "id" ? "Salah" : "False", value: false },
              ].map((option) => (
                <button
                  key={option.label}
                  disabled={disabled}
                  onClick={() => handleOption(option.value)}
                  className="flex min-h-12 w-full items-center rounded-md border border-muted bg-surface px-4 text-left text-sm font-semibold text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5 disabled:cursor-wait disabled:opacity-60"
                >
                  {option.label}
                </button>
              ))}
        </div>
      )}
    </section>
  );
}

function MissionProgress({ focus }: { focus: DailyFocusState }) {
  const percent = Math.min(100, (focus.missionsCompletedThisWeek / focus.missionGoal) * 100);
  return (
    <section className="mt-4 rounded-card border border-warning/25 bg-[color-mix(in_srgb,var(--color-warning)_7%,var(--color-surface))] p-4">
      <div className="flex items-start justify-between gap-4">
        <div>
          <p className="text-xs font-bold uppercase tracking-[0.14em] text-warning">Weekly Money Missions</p>
          <p className="mt-1 text-sm font-bold text-foreground">
            {focus.fourthFocusUnlocked ? "Fourth Focus unlocked" : `${focus.missionsCompletedThisWeek} of ${focus.missionGoal} completed`}
          </p>
        </div>
        <span className="rounded-full bg-warning/10 px-2.5 py-1 text-xs font-bold text-warning">{focus.fourthFocusUnlocked ? "4 Focus" : "3 → 4"}</span>
      </div>
      {!focus.fourthFocusUnlocked && (
        <>
          <div className="mt-3 h-1.5 overflow-hidden rounded-full bg-surface-inset" role="progressbar" aria-label="Weekly Money Missions" aria-valuemin={0} aria-valuemax={focus.missionGoal} aria-valuenow={focus.missionsCompletedThisWeek}>
            <div className="h-full rounded-full bg-warning" style={{ width: `${percent}%` }} />
          </div>
          <p className="mt-2 text-xs leading-5 text-muted-foreground">Finish Daily Focus five times in one local week to permanently gain a fourth Focus.</p>
        </>
      )}
    </section>
  );
}

function ExhaustedActions({ focus, refilling, onRefill }: { focus: DailyFocusState; refilling: boolean; onRefill: () => void }) {
  return (
    <section className="mt-5 rounded-card border border-muted bg-surface p-5 shadow-sm">
      <h2 className="text-lg font-bold text-foreground">Focus spent for today</h2>
      <p className="mt-1 text-sm leading-6 text-muted-foreground">You can return tomorrow, or use your one optional refill. Your lessons are still open anytime.</p>
      {!focus.refillUsed ? (
        <button onClick={onRefill} disabled={refilling} className="mt-5 flex min-h-11 w-full items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground transition-colors hover:bg-primary/90 disabled:opacity-60">
          {refilling ? "Refilling…" : "Refill Focus · 50 Koin Points"}
        </button>
      ) : (
        <p className="mt-4 text-sm font-semibold text-muted-foreground">Today&apos;s refill has already been used.</p>
      )}
      <Link href="/learn" className="mt-3 flex min-h-11 items-center justify-center rounded-full border border-muted px-5 text-sm font-bold text-foreground transition-colors hover:bg-surface-raised">Continue learning</Link>
    </section>
  );
}

function CompletionCard({ focus }: { focus: DailyFocusState }) {
  return (
    <section className="mt-5 rounded-card border border-success/30 bg-success/5 p-5 text-center">
      <FocusMark className="mx-auto h-9 w-9 text-success" />
      <h2 className="mt-3 text-xl font-bold text-foreground">Focus complete</h2>
      <p className="mt-1 text-sm leading-6 text-muted-foreground">You earned 20 Koin Points and completed one Money Mission. Come back tomorrow for a new set.</p>
      {focus.fourthFocusUnlocked && <p className="mt-3 text-sm font-bold text-success">Your fourth Focus is ready for tomorrow.</p>}
      <Link href="/" className="mt-5 inline-flex min-h-11 items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground">Back home</Link>
    </section>
  );
}

function BackLink() {
  return <Link href="/" className="inline-flex min-h-11 items-center gap-2 text-sm font-bold text-primary"><ArrowLeftIcon className="h-4 w-4" /> Home</Link>;
}

function FocusPips({ remaining, max }: { remaining: number; max: number }) {
  return (
    <div className="flex gap-1.5" aria-label={`${remaining} of ${max} Focus remaining`}>
      {Array.from({ length: max }, (_, index) => <span key={index} className={`flex h-8 w-8 items-center justify-center rounded-md border ${index < remaining ? "border-primary/30 bg-primary text-primary-foreground" : "border-muted bg-surface text-muted-foreground"}`}><FocusMark className="h-4 w-4" /></span>)}
    </div>
  );
}

function FocusMark({ className }: { className?: string }) {
  return <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="m12 3 2.25 6.75L21 12l-6.75 2.25L12 21l-2.25-6.75L3 12l6.75-2.25L12 3Z" /><circle cx="12" cy="12" r="1.5" fill="currentColor" stroke="none" /></svg>;
}

function ArrowLeftIcon({ className }: { className?: string }) {
  return <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="m19 12H5" /><path d="m12 19-7-7 7-7" /></svg>;
}
