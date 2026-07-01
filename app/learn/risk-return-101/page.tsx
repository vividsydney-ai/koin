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

export default function RiskReturnLessonPage() {
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
            Lesson 4 of 5
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
        <SeesawIcon className="h-14 w-14 text-primary" />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Risk vs Return</span>
      <h1 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        The deal every investor must accept
      </h1>
      <p className="mt-4 text-base leading-relaxed text-muted-foreground">
        Higher potential returns always come with higher potential losses. There is no free lunch in investing.
      </p>
      <div className="mt-8 flex items-center gap-3 text-xs font-medium text-muted-foreground">
        <BookIcon />
        <span>~5 minutes</span>
        <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
        <span className="text-xp">80 XP</span>
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
          Return is the reward for taking risk
        </h2>
      </div>

      <div className="space-y-3">
        <AssetRow label="Tabungan bank" returnRate="~2-4% / tahun" risk="Rendah" riskColor="success" />
        <AssetRow label="Obligasi pemerintah" returnRate="~6-7% / tahun" risk="Rendah-menengah" riskColor="success" />
        <AssetRow label="Reksa dana saham" returnRate="~8-12% / tahun*" risk="Menengah-tinggi" riskColor="warning" />
        <AssetRow label="Saham individu" returnRate="Tidak pasti" risk="Tinggi" riskColor="danger" />
        <AssetRow label={`"Guaranteed" 10% per bulan`} returnRate="Terlalu bagus untuk benar" risk="Penipuan" riskColor="danger" />
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        *Return historis tidak menjamin return masa depan. Yang penting adalah memahami trade-off: semakin tinggi janji return, semakin besar kemungkinan uangmu hilang.
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
          Siti chooses between two friends
        </h2>
      </div>

      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <div className="space-y-4">
          <div className="rounded-radius-md border border-success/30 bg-success/5 p-4">
            <p className="font-semibold text-success">Friend A: Reksadana pasar uang</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Return sekitar 4-5% per tahun. Dana bisa dicairkan dalam 2-3 hari. Risiko rendah.
            </p>
          </div>
          <div className="rounded-radius-md border border-danger/30 bg-danger/5 p-4">
            <p className="font-semibold text-danger">Friend B: "Investasi crypto signals"</p>
            <p className="mt-1 text-sm text-muted-foreground">
              Janji return 20% per bulan. Tidak terdaftar di OJK. Dana ditransfer ke rekening pribadi.
            </p>
          </div>
        </div>
      </div>

      <p className="text-[15px] leading-relaxed text-muted-foreground">
        Siti picks Friend A. She understands that slow and regulated beats fast and suspicious. The 20% per month offer is not an investment — it is a trap.
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
        question={`An investment promises 15% return per month with "zero risk." What is the most likely truth?`}
        options={[
          { label: "It is a revolutionary new product", value: "revolutionary" },
          { label: "It is probably a scam", value: "scam" },
          { label: "It is safer than a government bond", value: "safer" },
          { label: "It only works for early investors", value: "early" },
        ]}
        correctValue="scam"
        explanation="Correct. High returns with no risk violate the basic risk-return trade-off. In Indonesia, unlicensed investment schemes with guaranteed returns are a common form of fraud."
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
            <p className="text-sm text-muted-foreground">Financial literacy and investment awareness materials</p>
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

      <div className="rounded-radius-md border border-muted/60 bg-surface p-4 text-sm text-muted-foreground">
        <strong className="text-foreground">Note:</strong> For topic-specific capital-market guidance, we recommend verifying the latest source from{" "}
        <a
          href="https://www.idx.co.id"
          target="_blank"
          rel="noreferrer"
          className="font-semibold text-primary hover:underline"
        >
          IDX Investor Education
        </a>{" "}
        or{" "}
        <a
          href="https://www.ojk.go.id"
          target="_blank"
          rel="noreferrer"
          className="font-semibold text-primary hover:underline"
        >
          OJK
        </a>
        .
      </div>

      {quizPassed && (
        <div className="flex items-center gap-3 rounded-radius-lg border border-success/30 bg-success/5 px-4 py-3.5 text-success">
          <CheckIcon />
          <div>
            <p className="font-semibold">Lesson complete</p>
            <p className="text-sm">+80 XP</p>
          </div>
        </div>
      )}
    </div>
  );
}

function AssetRow({
  label,
  returnRate,
  risk,
  riskColor,
}: {
  label: string;
  returnRate: string;
  risk: string;
  riskColor: "success" | "warning" | "danger";
}) {
  const colors = {
    success: "text-success",
    warning: "text-warning",
    danger: "text-danger",
  };

  return (
    <div className="rounded-radius-md border border-muted/60 bg-surface p-4">
      <div className="flex items-center justify-between">
        <span className="font-semibold text-foreground">{label}</span>
        <span className={`text-sm font-semibold ${colors[riskColor]}`}>{risk}</span>
      </div>
      <p className="mt-1 text-sm text-muted-foreground">{returnRate}</p>
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

function SeesawIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 36h36" />
      <path d="M24 36V12" />
      <path d="m8 24 16-12 16 12" />
      <circle cx="24" cy="8" r="3" />
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
