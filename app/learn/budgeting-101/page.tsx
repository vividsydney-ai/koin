"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { QuizCard } from "@/components/lesson/QuizCard";

const STEPS = [
  { id: "intro", label: "Intro" },
  { id: "concept", label: "Concept" },
  { id: "example", label: "Example" },
  { id: "quiz", label: "Quiz" },
  { id: "source", label: "Source" },
];

export default function BudgetingLessonPage() {
  const router = useRouter();
  const [step, setStep] = useState(0);
  const [quizDone, setQuizDone] = useState(false);

  const nextStep = () => setStep((s) => Math.min(s + 1, STEPS.length - 1));
  const finishLesson = () => router.push("/learn");
  const isLastStep = step === STEPS.length - 1;

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col bg-background">
      <header className="sticky top-0 z-10 border-b border-muted/60 bg-background/90 px-5 py-3 backdrop-blur-md">
        <div className="flex items-center justify-between">
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Lesson 2 of 5
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

      <main className="flex-1 px-5 py-7">
        <div key={step} className="step-enter">
          {step === 0 && <IntroStep />}
          {step === 1 && <ConceptStep />}
          {step === 2 && <ExampleStep />}
          {step === 3 && <QuizStep onNext={nextStep} onComplete={() => setQuizDone(true)} />}
          {step === 4 && <SourceStep quizPassed={quizDone} />}
        </div>
      </main>

      <footer className="border-t border-muted/60 bg-surface px-5 py-4">
        <button
          onClick={isLastStep ? finishLesson : nextStep}
          disabled={step === 3 && !quizDone}
          className="flex w-full items-center justify-center gap-2 rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all duration-200 hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
        >
          {isLastStep ? "Finish lesson" : "Continue"}
          <ArrowRightIcon />
        </button>
      </footer>
    </div>
  );
}

function IntroStep() {
  return (
    <div className="flex flex-col items-center text-center">
      <div className="mb-6 flex h-28 w-28 items-center justify-center rounded-full bg-primary/8">
        <PieIcon className="h-14 w-14 text-primary" />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Budgeting</span>
      <h1 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        A budget is just a plan for your money
      </h1>
      <p className="mt-4 text-base leading-relaxed text-muted-foreground">
        You do not need a spreadsheet. You need three buckets: needs, wants, and future you.
      </p>
      <div className="mt-8 flex items-center gap-3 text-xs font-medium text-muted-foreground">
        <BookIcon />
        <span>~5 minutes</span>
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
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">The concept</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          The 50/30/20 rule, Indonesian style
        </h2>
      </div>

      <div className="space-y-3">
        <BudgetBucket label="Needs" percent="50%" examples="Kos, transport, makan pokok, pulsa" color="primary" />
        <BudgetBucket label="Wants" percent="30%" examples="Nonton, jalan-jalan, GrabFood" color="warning" />
        <BudgetBucket label="Future you" percent="20%" examples="Tabungan darurat, investasi" color="success" />
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        This is a starting point, not a prison. If your kos already eats 60% of your income, adjust the other buckets. The goal is awareness, not perfection.
      </p>
    </div>
  );
}

function ExampleStep() {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Indonesian example</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Andi, fresh graduate in Jakarta
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <p className="text-sm text-muted-foreground">Monthly take-home pay</p>
        <p className="text-3xl font-bold text-foreground">Rp 7.000.000</p>

        <div className="mt-6 space-y-4">
          <BudgetRow label="Needs (kos, transport, makan)" value="Rp 4.200.000" percent={60} />
          <BudgetRow label="Wants (streaming, hangout)" value="Rp 1.400.000" percent={20} />
          <BudgetRow label="Future you (tabungan)" value="Rp 1.400.000" percent={20} />
        </div>
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        Andi cannot hit 50/30/20 because kos in Jakarta is expensive. But he still sends 20% to future him before spending on wants. That is the real rule: pay yourself first.
      </p>
    </div>
  );
}

function QuizStep({ onNext, onComplete }: { onNext: () => void; onComplete: () => void }) {
  return (
    <div className="space-y-5">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Quick check</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Test your understanding
        </h2>
      </div>

      <QuizCard
        question="Which should you do first on payday?"
        options={[
          { label: "Buy the thing you've been wanting all month", value: "buy" },
          { label: "Pay rent and put savings aside", value: "save" },
          { label: "Split everything evenly across needs and wants", value: "split" },
          { label: "Wait until the end of the month to see what's left", value: "wait" },
        ]}
        correctValue="save"
        explanation="Correct. Pay your obligations and your future self first. Whatever is left is what you can actually afford to spend on wants."
        onComplete={onComplete}
      />
    </div>
  );
}

function SourceStep({ quizPassed }: { quizPassed: boolean }) {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Source trust</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Where this comes from
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <div className="flex items-start justify-between gap-3">
          <div>
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Tier 1 source</p>
            <h3 className="mt-1 font-semibold text-foreground">Bank Indonesia Education</h3>
            <p className="text-sm text-muted-foreground">Financial literacy and money management materials</p>
          </div>
          <span className="shrink-0 rounded-full bg-warning/10 px-2.5 py-1 text-[11px] font-semibold uppercase tracking-wide text-warning">
            BI-EDU
          </span>
        </div>
        <a
          href="https://www.bi.go.id/id/edukasi/default.aspx"
          target="_blank"
          rel="noreferrer"
          className="mt-5 inline-flex items-center gap-1.5 text-sm font-semibold text-primary hover:underline"
        >
          Read source
          <ExternalLinkIcon />
        </a>
      </div>

      {quizPassed && (
        <div className="flex items-center gap-3 rounded-radius-lg border border-success/30 bg-success/5 px-4 py-3.5 text-success">
          <CheckIcon />
          <div>
            <p className="font-semibold">Lesson complete</p>
            <p className="text-sm">+60 XP</p>
          </div>
        </div>
      )}
    </div>
  );
}

function BudgetBucket({
  label,
  percent,
  examples,
  color,
}: {
  label: string;
  percent: string;
  examples: string;
  color: "primary" | "warning" | "success";
}) {
  const colors = {
    primary: "bg-primary text-primary-foreground",
    warning: "bg-warning text-foreground",
    success: "bg-success text-white",
  };

  return (
    <div className="rounded-radius-md border border-muted/60 bg-surface p-4">
      <div className="flex items-center justify-between">
        <span className="font-semibold text-foreground">{label}</span>
        <span className={`rounded-radius-sm px-2 py-0.5 text-xs font-bold ${colors[color]}`}>{percent}</span>
      </div>
      <p className="mt-1 text-sm text-muted-foreground">{examples}</p>
    </div>
  );
}

function BudgetRow({ label, value, percent }: { label: string; value: string; percent: number }) {
  return (
    <div>
      <div className="flex items-center justify-between text-sm">
        <span className="text-muted-foreground">{label}</span>
        <span className="font-semibold text-foreground">{value}</span>
      </div>
      <div className="mt-2 h-2 w-full rounded-full bg-muted">
        <div
          className="h-2 rounded-full bg-primary transition-all duration-1000"
          style={{ width: `${percent}%` }}
        />
      </div>
    </div>
  );
}

function ArrowRightIcon() {
  return (
    <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  );
}

function BookIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
      <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
    </svg>
  );
}

function PieIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="M24 24 6 34a20 20 0 0 0 36-8H24Z" />
      <path d="M24 4v20h18A18 18 0 0 0 24 4Z" />
    </svg>
  );
}

function ExternalLinkIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M15 3h6v6" />
      <path d="M10 14 21 3" />
      <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
    </svg>
  );
}

function CheckIcon() {
  return (
    <svg className="h-6 w-6 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" />
      <path d="m9 12 2 2 4-4" />
    </svg>
  );
}
