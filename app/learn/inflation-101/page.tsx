"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { PriceRiseAnimation } from "@/components/lesson/PriceRiseAnimation";
import { QuizCard } from "@/components/lesson/QuizCard";

const STEPS = [
  { id: "intro", label: "Intro" },
  { id: "concept", label: "Concept" },
  { id: "example", label: "Example" },
  { id: "quiz", label: "Quiz" },
  { id: "source", label: "Source" },
];

export default function InflationLessonPage() {
  const router = useRouter();
  const [step, setStep] = useState(0);
  const [quizDone, setQuizDone] = useState(false);

  const nextStep = () => setStep((s) => Math.min(s + 1, STEPS.length - 1));
  const finishLesson = () => router.push("/learn");

  const isLastStep = step === STEPS.length - 1;

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col bg-background">
      {/* Header */}
      <header className="sticky top-0 z-10 border-b border-muted/60 bg-background/90 px-5 py-3 backdrop-blur-md">
        <div className="flex items-center justify-between">
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Lesson 3 of 5
          </span>
          <button className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground hover:text-foreground">
            Exit
          </button>
        </div>
        <div className="mt-2.5 flex gap-1.5">
          {STEPS.map((s, i) => (
            <div
              key={s.id}
              className={`h-1 flex-1 rounded-full transition-all duration-500 ${
                i <= step ? "bg-primary" : "bg-muted"
              }`}
            />
          ))}
        </div>
      </header>

      {/* Content */}
      <main className="flex-1 px-5 py-7">
        <div
          key={step}
          className="step-enter"
        >
          {step === 0 && <IntroStep />}
          {step === 1 && <ConceptStep />}
          {step === 2 && <ExampleStep />}
          {step === 3 && (
            <QuizStep
              onNext={nextStep}
              onComplete={() => setQuizDone(true)}
            />
          )}
          {step === 4 && <SourceStep quizPassed={quizDone} />}
        </div>
      </main>

      {/* Bottom nav */}
      <footer className="border-t border-muted/60 bg-surface px-5 py-4">
        <button
          onClick={isLastStep ? finishLesson : nextStep}
          disabled={step === 3 && !quizDone}
          className="flex w-full items-center justify-center gap-2 rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all duration-200 hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
        >
          {isLastStep ? "Finish lesson" : "Continue"}
          <svg
            className="h-4 w-4"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M5 12h14" />
            <path d="m12 5 7 7-7 7" />
          </svg>
        </button>
      </footer>
    </div>
  );
}

function IntroStep() {
  return (
    <div className="flex flex-col items-center text-center">
      <div className="mb-6 flex h-28 w-28 items-center justify-center rounded-full bg-primary/8">
        <InflationIcon className="h-14 w-14 text-primary" />
      </div>

      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
        Inflation
      </span>
      <h1 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        Why your rupiah buys less over time
      </h1>
      <p className="mt-4 text-base leading-relaxed text-muted-foreground">
        The same mie ayam costs more today than it did five years ago. That slow price creep is inflation at work.
      </p>

      <div className="mt-8 flex items-center gap-3 text-xs font-medium text-muted-foreground">
        <span className="flex items-center gap-1.5">
          <svg
            className="h-3.5 w-3.5"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
            <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
          </svg>
          ~4 minutes
        </span>
        <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
        <span className="text-xp">60 XP</span>
      </div>
    </div>
  );
}

function ConceptStep() {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
          The concept
        </span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Prices creep up. Purchasing power slips down.
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <PriceRiseAnimation />
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        Inflation is the general rise in prices across the economy. Bank Indonesia targets inflation around{" "}
        <strong className="font-semibold text-foreground">2.5% ± 1%</strong>. When your savings earn less than inflation, your money quietly buys fewer bowls of mie ayam.
      </p>
    </div>
  );
}

function ExampleStep() {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
          Indonesian example
        </span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Rina&apos;s savings account
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <div className="flex items-center gap-3.5">
          <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-primary/8">
            <WalletIcon className="h-6 w-6 text-primary" />
          </div>
          <div>
            <p className="font-semibold text-foreground">Rina, 21, Bandung</p>
            <p className="text-xs text-muted-foreground">Has Rp 5.000.000 in savings</p>
          </div>
        </div>

        <div className="mt-6 space-y-4">
          <ScenarioRow label="Savings interest" value="+2% / year" tone="muted" />
          <ScenarioRow label="Inflation" value="+4% / year" tone="danger" />
          <div className="border-t border-muted pt-4">
            <ScenarioRow label="Real purchasing power" value="-2% / year" tone="danger" />
          </div>
        </div>
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        In 2020, a bowl of mie ayam cost Rp 12.000. In 2025, it costs Rp 16.000. Rina&apos;s account balance did not fall, but her money can buy fewer bowls. That is the hidden cost of inflation.
      </p>
    </div>
  );
}

function QuizStep({ onNext, onComplete }: { onNext: () => void; onComplete: () => void }) {
  return (
    <div className="space-y-5">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
          Quick check
        </span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Test your understanding
        </h2>
      </div>

      <QuizCard
        question="Rina earns 2% interest but inflation is 4%. What happens to her purchasing power?"
        options={[
          { label: "It grows by 2%", value: "grow" },
          { label: "It stays the same", value: "same" },
          { label: "It falls by about 2%", value: "fall" },
          { label: "It doubles in 5 years", value: "double" },
        ]}
        correctValue="fall"
        explanation="Correct. Inflation (4%) eats more than interest (2%), so purchasing power falls by roughly the difference: 2%."
        onComplete={onComplete}
      />
    </div>
  );
}

function SourceStep({ quizPassed }: { quizPassed: boolean }) {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
          Source trust
        </span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Where this comes from
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <div className="flex items-start justify-between gap-3">
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              Tier 1 source
            </p>
            <h3 className="mt-1 font-semibold text-foreground">Bank Indonesia</h3>
            <p className="text-sm text-muted-foreground">About inflation and the BI inflation target</p>
          </div>
          <span className="shrink-0 rounded-full bg-warning/10 px-2.5 py-1 text-[11px] font-semibold uppercase tracking-wide text-warning">
            BI-001
          </span>
        </div>
        <a
          href="https://www.bi.go.id/en/fungsi-utama/moneter/inflasi/default.aspx"
          target="_blank"
          rel="noreferrer"
          className="mt-5 inline-flex items-center gap-1.5 text-sm font-semibold text-primary hover:underline"
        >
          Read source
          <svg
            className="h-3.5 w-3.5"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M15 3h6v6" />
            <path d="M10 14 21 3" />
            <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
          </svg>
        </a>
      </div>

      {quizPassed && (
        <div className="flex items-center gap-3 rounded-radius-lg border border-success/30 bg-success/5 px-4 py-3.5 text-success">
          <svg
            className="h-6 w-6 shrink-0"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <circle cx="12" cy="12" r="10" />
            <path d="m9 12 2 2 4-4" />
          </svg>
          <div>
            <p className="font-semibold">Lesson complete</p>
            <p className="text-sm">+60 XP</p>
          </div>
        </div>
      )}

      <p className="text-sm leading-relaxed text-muted-foreground">
        Koin only teaches from licensed Indonesian regulators and verified institutions. If you see unsourced advice, question it.
      </p>
    </div>
  );
}

function ScenarioRow({ label, value, tone }: { label: string; value: string; tone: "muted" | "danger" | "success" }) {
  const toneClasses = {
    muted: "text-muted-foreground",
    danger: "text-danger",
    success: "text-success",
  };

  return (
    <div className="flex items-center justify-between text-[15px]">
      <span className="text-muted-foreground">{label}</span>
      <span className={`font-semibold ${toneClasses[tone]}`}>{value}</span>
    </div>
  );
}

function InflationIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="M8 40h32" />
      <path d="M12 32c6-4 8-14 12-14s6 14 16 14" />
      <path d="M36 22v-6" />
      <path d="m30 16 6-6 6 6" />
    </svg>
  );
}

function WalletIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4" />
      <circle cx="17" cy="12" r="2" />
    </svg>
  );
}
