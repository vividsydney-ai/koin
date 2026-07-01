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

export default function MoneyBasicsLessonPage() {
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
            Lesson 1 of 5
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
        <WalletShieldIcon className="h-14 w-14 text-primary" />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Money Basics</span>
      <h1 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        Protect your money before you grow it
      </h1>
      <p className="mt-4 text-base leading-relaxed text-muted-foreground">
        The first step to financial health is not investing. It is knowing what you need, what you want, and what smells like a scam.
      </p>
      <div className="mt-8 flex items-center gap-3 text-xs font-medium text-muted-foreground">
        <BookIcon />
        <span>~4 minutes</span>
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
          Needs first, wants second, scams never
        </h2>
      </div>

      <div className="space-y-3">
        <PriorityRow label="Needs" description="Food, rent, transport, emergency fund" color="primary" />
        <PriorityRow label="Wants" description="New phone, holiday, eating out" color="muted" />
        <PriorityRow label="Scams" description={`"Guaranteed 10% returns per month"`} color="danger" />
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        If someone promises guaranteed high returns with no risk, they are lying. In Indonesia, only licensed institutions under OJK or BI can offer regulated financial products.
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
          Budi gets a WhatsApp offer
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <div className="flex items-center gap-3.5">
          <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-danger/10">
            <WarningIcon className="h-6 w-6 text-danger" />
          </div>
          <div>
            <p className="font-semibold text-foreground">"Invest Rp 1 juta, get Rp 2 juta in 7 days"</p>
            <p className="text-xs text-muted-foreground">A message from an unknown number</p>
          </div>
        </div>

        <div className="mt-6 space-y-4">
          <div className="rounded-radius-md bg-muted/50 p-3 text-sm text-muted-foreground">
            <span className="font-semibold text-foreground">Red flag 1:</span> Guaranteed returns above bank deposit rates with no risk.
          </div>
          <div className="rounded-radius-md bg-muted/50 p-3 text-sm text-muted-foreground">
            <span className="font-semibold text-foreground">Red flag 2:</span> Pressure to transfer money quickly via e-wallet.
          </div>
          <div className="rounded-radius-md bg-muted/50 p-3 text-sm text-muted-foreground">
            <span className="font-semibold text-foreground">Red flag 3:</span> The person is not registered with OJK.
          </div>
        </div>
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        Budi checks the OJK registration portal. The company is not listed. He blocks the number and puts the Rp 1 juta into his emergency fund instead.
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
        question={`You receive an offer: "Rp 5 juta returns Rp 50 juta in one month, guaranteed." What should you do?`}
        options={[
          { label: "Transfer quickly before the slot fills up", value: "transfer" },
          { label: "Check if the provider is licensed by OJK", value: "check" },
          { label: "Ask friends if they have tried it", value: "ask" },
          { label: "Invest a small amount to test", value: "test" },
        ]}
        correctValue="check"
        explanation={`Correct. Always verify that a financial provider is licensed by OJK or BI. Unlicensed "guaranteed" returns are a classic scam pattern.`}
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
            <p className="text-sm text-muted-foreground">Financial literacy materials and consumer protection guidance</p>
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

function PriorityRow({
  label,
  description,
  color,
}: {
  label: string;
  description: string;
  color: "primary" | "muted" | "danger";
}) {
  const colors = {
    primary: "border-primary bg-primary/5",
    muted: "border-muted bg-muted/30",
    danger: "border-danger bg-danger/5",
  };

  const textColors = {
    primary: "text-primary",
    muted: "text-foreground",
    danger: "text-danger",
  };

  return (
    <div className={`rounded-radius-md border p-4 ${colors[color]}`}>
      <div className="flex items-center justify-between">
        <span className={`font-semibold ${textColors[color]}`}>{label}</span>
      </div>
      <p className="mt-1 text-sm text-muted-foreground">{description}</p>
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

function WalletShieldIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="M8 20h24a4 4 0 0 1 4 4v12a4 4 0 0 1-4 4H8a4 4 0 0 1-4-4V24a4 4 0 0 1 4-4z" />
      <path d="M32 20V14a4 4 0 0 0-4-4H12" />
      <path d="M36 28h4" />
      <path d="m18 30 4 4 6-8" />
    </svg>
  );
}

function WarningIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z" />
      <path d="M12 9v4" />
      <path d="M12 17h.01" />
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
