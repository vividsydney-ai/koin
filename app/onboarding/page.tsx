"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/auth/client";
import { getProfile, completeOnboarding } from "@/lib/profile/client";
import AssessmentStep from "./AssessmentStep";
import {
  defaultLevel,
  diagnosticQuestions,
  type Difficulty,
} from "@/lib/onboarding/diagnosticQuestions";

const AGE_RANGES = [
  { value: "under_16", label: "Di bawah 16", shortLabel: "<16" },
  { value: "16_18", label: "16–18", shortLabel: "16–18" },
  { value: "19_22", label: "19–22", shortLabel: "19–22" },
  { value: "23_25", label: "23–25", shortLabel: "23–25" },
  { value: "26_plus", label: "26+", shortLabel: "26+" },
];

const GOALS = [
  {
    value: "start_investing",
    label: "Mulai investasi",
    description: "Pahami saham, reksa dana, dan portofolio pertamaku.",
    icon: "📈",
  },
  {
    value: "save_emergency",
    label: "Dana darurat",
    description: "Siapkan tabungan aman untuk masa depan.",
    icon: "🛡️",
  },
  {
    value: "avoid_scams",
    label: "Hindari penipuan",
    description: "Kenali investasi bodong dan binary options.",
    icon: "🕵️",
  },
  {
    value: "budget_better",
    label: "Atur uang lebih baik",
    description: "Buat anggaran yang pas untuk gaya hidupku.",
    icon: "📝",
  },
  {
    value: "understand_stocks",
    label: "Pahami saham",
    description: "Belajar dasar pasar modal Indonesia.",
    icon: "🏢",
  },
];

type OnboardingStep = "welcome" | "profile" | "assessment" | "goal" | "notifications" | "ready";

export default function OnboardingPage() {
  const router = useRouter();
  const [userId, setUserId] = useState<string | null>(null);
  const [step, setStep] = useState<OnboardingStep>("welcome");
  const [displayName, setDisplayName] = useState("");
  const [ageRange, setAgeRange] = useState("");
  const [financialGoals, setFinancialGoals] = useState<string[]>([]);
  const [literacyLevel, setLiteracyLevel] = useState<Difficulty>(defaultLevel);
  const [assessmentCompleted, setAssessmentCompleted] = useState(false);
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [direction, setDirection] = useState<"forward" | "back">("forward");

  useEffect(() => {
    let mounted = true;

    const checkUser = async () => {
      const { data } = await supabase.auth.getUser();
      if (!mounted) return;

      if (!data.user) {
        router.replace("/login");
        return;
      }

      const profile = await getProfile(data.user.id);
      if (!mounted) return;

      if (profile?.onboarding_completed) {
        router.replace("/");
        return;
      }

      setUserId(data.user.id);
      setLoading(false);
    };

    checkUser();

    return () => {
      mounted = false;
    };
  }, [router]);

  const navigate = (nextStep: OnboardingStep, dir: "forward" | "back" = "forward") => {
    setDirection(dir);
    setStep(nextStep);
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const handleSubmit = async () => {
    if (!userId) return;

    setSubmitting(true);
    setError(null);

    const result = await completeOnboarding({
      userId,
      displayName: displayName.trim() || "Pembelajar Koinaku",
      ageRange,
      financialGoals,
      financialLiteracyLevel: literacyLevel,
      notificationsEnabled,
    });

    setSubmitting(false);

    if (result.error) {
      setError(result.error);
      return;
    }

    router.push("/");
  };

  if (loading) {
    return (
      <main className="flex min-h-screen items-center justify-center bg-background">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" aria-label="Memuat" />
      </main>
    );
  }

  return (
    <main className="flex min-h-screen flex-col justify-between bg-background p-6">
      <div className="flex flex-1 items-center justify-center">
        <div className="w-full max-w-sm">
          <StepContent
            step={step}
            direction={direction}
            displayName={displayName}
            setDisplayName={setDisplayName}
            ageRange={ageRange}
            setAgeRange={setAgeRange}
            financialGoals={financialGoals}
            setFinancialGoals={setFinancialGoals}
            literacyLevel={literacyLevel}
            setLiteracyLevel={setLiteracyLevel}
            assessmentCompleted={assessmentCompleted}
            setAssessmentCompleted={setAssessmentCompleted}
            notificationsEnabled={notificationsEnabled}
            setNotificationsEnabled={setNotificationsEnabled}
            onNext={() => {
              if (step === "welcome") navigate("profile");
              else if (step === "profile") navigate("assessment");
              else if (step === "assessment") navigate("goal");
              else if (step === "goal") navigate("notifications");
              else if (step === "notifications") navigate("ready");
            }}
            onBack={() => {
              if (step === "profile") navigate("welcome", "back");
              else if (step === "assessment") navigate("profile", "back");
              else if (step === "goal") navigate("assessment", "back");
              else if (step === "notifications") navigate("goal", "back");
              else if (step === "ready") navigate("notifications", "back");
            }}
            onStart={handleSubmit}
            submitting={submitting}
            error={error}
          />
        </div>
      </div>

      <ProgressDots step={step} />
    </main>
  );
}

interface StepContentProps {
  step: OnboardingStep;
  direction: "forward" | "back";
  displayName: string;
  setDisplayName: (value: string) => void;
  ageRange: string;
  setAgeRange: (value: string) => void;
  financialGoals: string[];
  setFinancialGoals: (value: string[]) => void;
  literacyLevel: Difficulty;
  setLiteracyLevel: (value: Difficulty) => void;
  assessmentCompleted: boolean;
  setAssessmentCompleted: (value: boolean) => void;
  notificationsEnabled: boolean;
  setNotificationsEnabled: (value: boolean) => void;
  onNext: () => void;
  onBack: () => void;
  onStart: () => void;
  submitting: boolean;
  error: string | null;
}

function StepContent({
  step,
  direction,
  displayName,
  setDisplayName,
  ageRange,
  setAgeRange,
  financialGoals,
  setFinancialGoals,
  literacyLevel,
  setLiteracyLevel,
  assessmentCompleted,
  setAssessmentCompleted,
  notificationsEnabled,
  setNotificationsEnabled,
  onNext,
  onBack,
  onStart,
  submitting,
  error,
}: StepContentProps) {
  const isForward = direction === "forward";

  return (
    <div
      key={step}
      className={`rounded-2xl border border-border/60 bg-surface p-6 shadow-sm ${isForward ? "step-enter" : "step-enter"}`}
      style={{ animationDirection: isForward ? "normal" : "reverse" }}
    >
      {step !== "welcome" && (
        <button
          onClick={onBack}
          className="mb-4 inline-flex items-center gap-1 text-sm font-medium text-muted-foreground transition-colors hover:text-foreground"
          aria-label="Kembali"
        >
          <ChevronLeftIcon className="h-4 w-4" />
          Kembali
        </button>
      )}

      {step === "welcome" && (
        <WelcomeStep onNext={onNext} />
      )}

      {step === "profile" && (
        <ProfileStep
          displayName={displayName}
          setDisplayName={setDisplayName}
          ageRange={ageRange}
          setAgeRange={setAgeRange}
          onNext={onNext}
        />
      )}

      {step === "assessment" && (
        <AssessmentStep
          questions={diagnosticQuestions}
          onComplete={(level) => {
            setLiteracyLevel(level);
            setAssessmentCompleted(true);
            onNext();
          }}
          onSkip={() => {
            setLiteracyLevel(defaultLevel);
            setAssessmentCompleted(false);
            onNext();
          }}
        />
      )}

      {step === "goal" && (
        <GoalStep
          financialGoals={financialGoals}
          setFinancialGoals={setFinancialGoals}
          onNext={onNext}
        />
      )}

      {step === "notifications" && (
        <NotificationsStep
          notificationsEnabled={notificationsEnabled}
          setNotificationsEnabled={setNotificationsEnabled}
          onNext={onNext}
        />
      )}

      {step === "ready" && (
        <ReadyStep
          displayName={displayName}
          financialGoals={financialGoals}
          onStart={onStart}
          submitting={submitting}
          error={error}
        />
      )}
    </div>
  );
}

function WelcomeStep({ onNext }: { onNext: () => void }) {
  return (
    <div className="text-center">
      <div className="mx-auto mb-6 flex h-20 w-20 items-center justify-center rounded-2xl bg-primary text-3xl font-bold text-white shadow-md">
        K
      </div>
      <h1 className="font-display text-3xl font-bold tracking-tight text-foreground">
        Selamat datang di Koinaku
      </h1>
      <p className="mt-3 text-base leading-relaxed text-muted-foreground">
        Keuangan, akhirnya mudah dipahami orang Indonesia. Belajar sambil latihan tanpa uang sungguhan.
      </p>
      <button
        onClick={onNext}
        className="mt-8 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md active:translate-y-0 active:scale-[0.98]"
      >
        Mulai
      </button>
      <p className="mt-4 text-xs text-muted-foreground">
        Butuh beberapa menit saja
      </p>
    </div>
  );
}

function ProfileStep({
  displayName,
  setDisplayName,
  ageRange,
  setAgeRange,
  onNext,
}: {
  displayName: string;
  setDisplayName: (value: string) => void;
  ageRange: string;
  setAgeRange: (value: string) => void;
  onNext: () => void;
}) {
  const canProceed = displayName.trim().length > 0 && ageRange !== "";

  return (
    <div>
      <h2 className="font-display text-2xl font-bold tracking-tight text-foreground">
        Siapa namamu?
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">
        Personalisasi pengalaman belajarmu.
      </p>

      <div className="mt-6 space-y-5">
        <div>
          <label htmlFor="displayName" className="block text-sm font-medium text-foreground">
            Nama panggilan
          </label>
          <input
            id="displayName"
            type="text"
            value={displayName}
            onChange={(e) => setDisplayName(e.target.value)}
            placeholder="Contoh: Budi"
            maxLength={32}
            className="mt-2 h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
          />
        </div>

        <div>
          <span className="block text-sm font-medium text-foreground">Rentang usia</span>
          <div className="mt-2 grid grid-cols-3 gap-2">
            {AGE_RANGES.map((range) => (
              <button
                key={range.value}
                type="button"
                onClick={() => setAgeRange(range.value)}
                aria-pressed={ageRange === range.value}
                className={`flex h-12 items-center justify-center rounded-lg border-[1.5px] text-sm font-semibold transition-all ${
                  ageRange === range.value
                    ? "border-primary bg-primary text-white shadow-sm"
                    : "border-border bg-surface text-foreground hover:border-primary-300 hover:text-primary-600"
                }`}
              >
                {range.shortLabel}
              </button>
            ))}
          </div>
        </div>
      </div>

      <button
        onClick={onNext}
        disabled={!canProceed}
        className="mt-8 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md disabled:translate-y-0 disabled:scale-100 disabled:cursor-not-allowed disabled:bg-primary-200 disabled:text-primary-400 disabled:shadow-none"
      >
        Lanjut
      </button>
    </div>
  );
}

function GoalStep({
  financialGoals,
  setFinancialGoals,
  onNext,
}: {
  financialGoals: string[];
  setFinancialGoals: (value: string[]) => void;
  onNext: () => void;
}) {
  const toggleGoal = (value: string) => {
    if (financialGoals.includes(value)) {
      setFinancialGoals(financialGoals.filter((g) => g !== value));
    } else if (financialGoals.length < 3) {
      setFinancialGoals([...financialGoals, value]);
    }
  };

  const canProceed = financialGoals.length >= 1 && financialGoals.length <= 3;

  return (
    <div>
      <h2 className="font-display text-2xl font-bold tracking-tight text-foreground">
        Tujuan keuanganmu
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">
        Pilih 1–3 tujuan.
      </p>

      <div className="mt-5 space-y-3">
        {GOALS.map((goal) => {
          const selected = financialGoals.includes(goal.value);
          const maxReached = !selected && financialGoals.length >= 3;
          return (
            <button
              key={goal.value}
              type="button"
              onClick={() => toggleGoal(goal.value)}
              aria-pressed={selected}
              disabled={maxReached}
              className={`flex w-full items-start gap-4 rounded-xl border-[1.5px] p-4 text-left transition-all ${
                selected
                  ? "border-primary bg-primary-50 shadow-sm"
                  : maxReached
                    ? "border-border bg-surface opacity-50 cursor-not-allowed"
                    : "border-border bg-surface hover:border-primary-300 hover:bg-surface-raised"
              }`}
            >
              <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-surface text-xl shadow-sm">
                {goal.icon}
              </span>
              <div>
                <p className={`font-semibold ${selected ? "text-primary" : "text-foreground"}`}>
                  {goal.label}
                </p>
                <p className="mt-0.5 text-sm leading-relaxed text-muted-foreground">
                  {goal.description}
                </p>
              </div>
            </button>
          );
        })}
      </div>

      <button
        onClick={onNext}
        disabled={!canProceed}
        className="mt-6 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md disabled:translate-y-0 disabled:scale-100 disabled:cursor-not-allowed disabled:bg-primary-200 disabled:text-primary-400 disabled:shadow-none"
      >
        Lanjut
      </button>
    </div>
  );
}

function NotificationsStep({
  notificationsEnabled,
  setNotificationsEnabled,
  onNext,
}: {
  notificationsEnabled: boolean;
  setNotificationsEnabled: (value: boolean) => void;
  onNext: () => void;
}) {
  return (
    <div>
      <h2 className="font-display text-2xl font-bold tracking-tight text-foreground">
        Pengingat harian
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">
        Bantu kami membangun kebiasaan belajar yang konsisten.
      </p>

      <div className="mt-8 rounded-xl border border-border bg-surface-raised p-5">
        <div className="flex items-center justify-between gap-4">
          <div>
            <p className="font-semibold text-foreground">Aktifkan pengingat</p>
            <p className="mt-0.5 text-sm text-muted-foreground">
              Kirimkan pengingat harian agar streak-mu tetap menyala.
            </p>
          </div>
          <label className="relative inline-flex cursor-pointer items-center">
            <input
              type="checkbox"
              checked={notificationsEnabled}
              onChange={(e) => setNotificationsEnabled(e.target.checked)}
              className="peer sr-only"
            />
            <span className="h-6 w-11 rounded-full bg-border-strong transition-colors peer-checked:bg-primary peer-focus-visible:shadow-focus-ring">
              <span
                className={`absolute left-1 top-1 h-4 w-4 rounded-full bg-white shadow-sm transition-transform ${
                  notificationsEnabled ? "translate-x-5" : "translate-x-0"
                }`}
              />
            </span>
          </label>
        </div>
      </div>

      <button
        onClick={onNext}
        className="mt-8 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md active:translate-y-0 active:scale-[0.98]"
      >
        Lanjut
      </button>
    </div>
  );
}

function ReadyStep({
  displayName,
  financialGoals,
  onStart,
  submitting,
  error,
}: {
  displayName: string;
  financialGoals: string[];
  onStart: () => void;
  submitting: boolean;
  error: string | null;
}) {
  const goalLabels = financialGoals
    .map((value) => GOALS.find((g) => g.value === value)?.label)
    .filter(Boolean)
    .join(", ");

  return (
    <div className="text-center">
      <div className="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-full bg-success-100 text-2xl">
        🎉
      </div>
      <h2 className="font-display text-2xl font-bold tracking-tight text-foreground">
        Kamu siap, {displayName || "Pembelajar"}!
      </h2>
      <p className="mt-2 text-sm text-muted-foreground">
        Fokusmu: <span className="font-semibold text-foreground">{goalLabels}</span>. Mari mulai perjalanan literasi keuanganmu.
      </p>

      {error && (
        <p className="mt-5 rounded-lg border border-danger/20 bg-danger/5 p-3 text-sm text-danger">
          {error}
        </p>
      )}

      <button
        onClick={onStart}
        disabled={submitting}
        className="mt-8 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md active:translate-y-0 active:scale-[0.98] disabled:translate-y-0 disabled:scale-100 disabled:cursor-not-allowed disabled:bg-primary-200 disabled:text-primary-400 disabled:shadow-none"
      >
        {submitting ? "Menyiapkan..." : "Mulai belajar"}
      </button>
    </div>
  );
}

function ProgressDots({ step }: { step: OnboardingStep }) {
  const steps: OnboardingStep[] = ["welcome", "profile", "assessment", "goal", "notifications", "ready"];
  const currentIndex = steps.indexOf(step);

  return (
    <div className="flex justify-center gap-2 py-6" aria-hidden="true">
      {steps.map((s, index) => (
        <span
          key={s}
          className={`h-2 w-2 rounded-full transition-colors ${
            index <= currentIndex ? "bg-primary" : "bg-border-strong"
          }`}
        />
      ))}
    </div>
  );
}

function ChevronLeftIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <path d="M15 18l-6-6 6-6" />
    </svg>
  );
}
