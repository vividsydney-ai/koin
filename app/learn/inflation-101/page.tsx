"use client";

import { useState } from "react";
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
  const [step, setStep] = useState(0);
  const [quizDone, setQuizDone] = useState(false);

  const nextStep = () => setStep((s) => Math.min(s + 1, STEPS.length - 1));

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col bg-background">
      {/* Header */}
      <header className="sticky top-0 z-10 border-b border-muted bg-background/95 px-4 py-3 backdrop-blur-sm">
        <div className="flex items-center justify-between">
          <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">Lesson 3 of 5</span>
          <button className="text-xs font-medium text-muted-foreground hover:text-foreground">Exit</button>
        </div>
        <div className="mt-2 flex gap-1">
          {STEPS.map((s, i) => (
            <div
              key={s.id}
              className={`h-1 flex-1 rounded-full transition-colors duration-300 ${
                i <= step ? "bg-xp" : "bg-muted"
              }`}
            />
          ))}
        </div>
      </header>

      {/* Content */}
      <main className="flex-1 px-5 py-6">
        {step === 0 && <IntroStep onNext={nextStep} />}
        {step === 1 && <ConceptStep onNext={nextStep} />}
        {step === 2 && <ExampleStep onNext={nextStep} />}
        {step === 3 && (
          <QuizStep
            onNext={nextStep}
            onComplete={() => setQuizDone(true)}
          />
        )}
        {step === 4 && <SourceStep quizPassed={quizDone} />}
      </main>

      {/* Bottom nav */}
      <footer className="border-t border-muted bg-surface px-5 py-4">
        <button
          onClick={nextStep}
          disabled={step === 3 && !quizDone}
          className="flex w-full items-center justify-center gap-2 rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary/90 disabled:opacity-50"
        >
          {step === 4 ? "Finish lesson" : "Continue"}
          <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M5 12h14" />
            <path d="m12 5 7 7-7 7" />
          </svg>
        </button>
      </footer>
    </div>
  );
}

function IntroStep({ onNext }: { onNext: () => void }) {
  return (
    <div className="flex flex-col items-center text-center">
      <span className="mb-4 inline-flex h-12 w-12 items-center justify-center rounded-full bg-warning/10 text-2xl">📉</span>
      <h1 className="text-2xl font-bold leading-tight text-foreground">
        Inflation: why your rupiah buys less over time
      </h1>
      <p className="mt-3 text-base leading-relaxed text-muted-foreground">
        The same mie ayam costs more today than it did five years ago. That is inflation at work.
      </p>
      <div className="mt-8 flex items-center gap-2 text-xs text-muted-foreground">
        <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
          <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
        </svg>
        <span>~4 minutes</span>
        <span className="mx-1">·</span>
        <span>60 XP</span>
      </div>
    </div>
  );
}

function ConceptStep({ onNext }: { onNext: () => void }) {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-xs font-semibold uppercase tracking-wide text-xp">The concept</span>
        <h2 className="mt-1 text-xl font-bold text-foreground">Prices creep up. Purchasing power slips down.</h2>
      </div>

      <PriceRiseAnimation />

      <p className="text-sm leading-relaxed text-muted-foreground">
        Inflation is the general rise in prices across the economy. Bank Indonesia targets inflation around{" "}
        <strong className="text-foreground">2.5% ± 1%</strong>. When your savings earn less than inflation, your money
        quietly buys fewer bowls of mie ayam.
      </p>
    </div>
  );
}

function ExampleStep({ onNext }: { onNext: () => void }) {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-xs font-semibold uppercase tracking-wide text-xp">Indonesian example</span>
        <h2 className="mt-1 text-xl font-bold text-foreground">Rina&apos;s savings account</h2>
      </div>

      <div className="rounded-radius-lg border border-muted bg-surface p-5">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-full bg-info/10 text-lg">👩‍🎓</div>
          <div>
            <p className="font-semibold text-foreground">Rina, 21, Bandung</p>
            <p className="text-xs text-muted-foreground">Has Rp 5.000.000 in savings</p>
          </div>
        </div>

        <div className="mt-5 space-y-4">
          <ScenarioRow label="Savings interest" value="+2% / year" tone="muted" />
          <ScenarioRow label="Inflation" value="+4% / year" tone="danger" />
          <div className="border-t border-muted pt-4">
            <ScenarioRow label="Real purchasing power" value="-2% / year" tone="danger" />
          </div>
        </div>
      </div>

      <p className="text-sm leading-relaxed text-muted-foreground">
        In 2020, a bowl of mie ayam cost Rp 12.000. In 2025, it costs Rp 16.000. Rina&apos;s account balance did not fall,
        but her money can buy fewer bowls. That is the hidden cost of inflation.
      </p>
    </div>
  );
}

function QuizStep({ onNext, onComplete }: { onNext: () => void; onComplete: () => void }) {
  return (
    <div className="space-y-5">
      <div>
        <span className="text-xs font-semibold uppercase tracking-wide text-xp">Quick check</span>
        <h2 className="mt-1 text-xl font-bold text-foreground">Test your understanding</h2>
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
        <span className="text-xs font-semibold uppercase tracking-wide text-xp">Source trust</span>
        <h2 className="mt-1 text-xl font-bold text-foreground">Where this comes from</h2>
      </div>

      <div className="rounded-radius-lg border border-muted bg-surface p-5">
        <div className="flex items-start justify-between">
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">Tier 1 source</p>
            <h3 className="mt-1 font-semibold text-foreground">Bank Indonesia</h3>
            <p className="text-sm text-muted-foreground">About Inflation & BI inflation target</p>
          </div>
          <span className="rounded-full bg-warning/10 px-2 py-1 text-xs font-semibold text-warning">BI-001</span>
        </div>
        <a
          href="https://www.bi.go.id/id/moneter/inflasi/Default.aspx"
          target="_blank"
          rel="noreferrer"
          className="mt-4 inline-flex items-center gap-1 text-sm font-medium text-primary hover:underline"
        >
          Read source
          <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M15 3h6v6" />
            <path d="M10 14 21 3" />
            <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
          </svg>
        </a>
      </div>

      {quizPassed && (
        <div className="flex items-center gap-3 rounded-radius-lg border border-success/30 bg-success/5 px-4 py-3 text-success">
          <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="12" cy="12" r="10" />
            <path d="m9 12 2 2 4-4" />
          </svg>
          <div>
            <p className="font-semibold">Lesson complete</p>
            <p className="text-sm">+60 XP · You earned the Compound Wizard badge</p>
          </div>
        </div>
      )}

      <p className="text-sm leading-relaxed text-muted-foreground">
        Koin only teaches from licensed Indonesian regulators and verified institutions. If you see unsourced advice,
        question it.
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
    <div className="flex items-center justify-between text-sm">
      <span className="text-muted-foreground">{label}</span>
      <span className={`font-semibold ${toneClasses[tone]}`}>{value}</span>
    </div>
  );
}
