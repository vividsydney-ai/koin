"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import {
  getLessonBySlug,
  getLessonVariants,
  getLessonSources,
  getRecentAttemptVariantIds,
  seededIndex,
  type Lesson,
  type ContentVariant,
  type LessonSource,
} from "@/lib/lessons/client";
import { useAuth } from "@/lib/auth/use-auth";
import { QuizEngine } from "@/components/lesson/QuizEngine";
import { validateQuestion, applyParameters, type ProcessedQuestion } from "@/lib/lessons/question";

const STEPS = [
  { id: "intro", label: "Intro" },
  { id: "concept", label: "Concept" },
  { id: "example", label: "Example" },
  { id: "quiz", label: "Quiz" },
  { id: "source", label: "Source" },
];

export default function LessonPlayer({ slug }: { slug: string }) {
  const router = useRouter();
  const { user } = useAuth(true);
  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [exampleVariant, setExampleVariant] = useState<ContentVariant | null>(null);
  const [activeQuestion, setActiveQuestion] = useState<ProcessedQuestion | null>(null);
  const [sources, setSources] = useState<LessonSource[]>([]);
  const [loading, setLoading] = useState(true);
  const [step, setStep] = useState(0);
  const [quizDone, setQuizDone] = useState(false);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const data = await getLessonBySlug(slug);
      if (!mounted || !data) {
        setLoading(false);
        return;
      }

      const [exampleVariants, questionVariants, sourceData, recentIds] = await Promise.all([
        getLessonVariants(data.id, "example"),
        getLessonVariants(data.id, "question"),
        getLessonSources(data.id),
        user ? getRecentAttemptVariantIds(user.id, data.id) : Promise.resolve(new Set<string>()),
      ]);

      if (!mounted) return;

      const seed = user ? `${user.id}:${data.id}:${todayKey()}` : `${data.id}:${todayKey()}`;
      const example = exampleVariants[seededIndex(seed, exampleVariants.length)] ?? null;

      const eligibleQuestions = questionVariants.filter((v) => !recentIds.has(v.id));
      const pool = eligibleQuestions.length > 0 ? eligibleQuestions : questionVariants;
      const selectedVariant = pool[seededIndex(`${seed}:q`, pool.length)] ?? null;

      let processedQuestion: ProcessedQuestion | null = null;
      if (selectedVariant) {
        const validated = validateQuestion(selectedVariant.body);
        if (validated) {
          processedQuestion = {
            ...applyParameters(seed, validated),
            variantId: selectedVariant.id,
          };
        }
      }
      // Fallback to legacy lesson.quizData if no valid variant exists.
      if (!processedQuestion && data.quizData.length > 0) {
        const validated = validateQuestion(data.quizData[0]);
        if (validated) {
          processedQuestion = applyParameters(seed, validated);
        }
      }

      setLesson(data);
      setExampleVariant(example);
      setActiveQuestion(processedQuestion);
      setSources(sourceData);
      setLoading(false);
    };

    load();
    return () => {
      mounted = false;
    };
  }, [slug, user]);


  const nextStep = () => setStep((s) => Math.min(s + 1, STEPS.length - 1));
  const finishLesson = () => router.push("/learn");
  const isLastStep = step === STEPS.length - 1;

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="text-sm text-muted-foreground">Loading lesson…</div>
      </div>
    );
  }

  if (!lesson) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center bg-background p-6 text-center">
        <h1 className="text-xl font-bold text-foreground">Lesson not found</h1>
        <p className="mt-2 text-sm text-muted-foreground">This topic is not available yet.</p>
        <button
          onClick={() => router.push("/learn")}
          className="mt-6 rounded-radius-md bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground"
        >
          Back to Learn
        </button>
      </div>
    );
  }

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col bg-background">
      <header className="sticky top-0 z-10 border-b border-muted/60 bg-background/90 px-5 py-3 backdrop-blur-md">
        <div className="flex items-center justify-between">
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Lesson {lesson.lessonNumber} of 5
          </span>
          <button
            onClick={() => router.push("/learn")}
            className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground hover:text-foreground"
          >
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
          {step === 0 && <IntroStep lesson={lesson} />}
          {step === 1 && <ConceptStep lesson={lesson} />}
          {step === 2 && <ExampleStep lesson={lesson} exampleVariant={exampleVariant} />}
          {step === 3 && (
            <QuizStep
              question={activeQuestion}
              onNext={nextStep}
              onComplete={() => setQuizDone(true)}
            />
          )}
          {step === 4 && <SourceStep sources={sources} quizPassed={quizDone} xpReward={lesson.xpReward} />}
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

function IntroStep({ lesson }: { lesson: Lesson }) {
  return (
    <div className="flex flex-col items-center text-center">
      <div className="mb-6 flex h-28 w-28 items-center justify-center rounded-full bg-primary/8">
        <LessonIcon />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
        {lesson.title.split(":")[0]}
      </span>
      <h1 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        {lesson.title}
      </h1>
      <p className="mt-4 text-base leading-relaxed text-muted-foreground">{lesson.summary}</p>
      <div className="mt-8 flex items-center gap-3 text-xs font-medium text-muted-foreground">
        <BookIcon />
        <span>~{lesson.estimatedMinutes} minutes</span>
        <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
        <span className="text-xp">{lesson.xpReward} XP</span>
      </div>
    </div>
  );
}

function ConceptStep({ lesson }: { lesson: Lesson }) {
  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">The concept</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          {lesson.title}
        </h2>
      </div>
      <p className="text-[15px] leading-relaxed text-muted-foreground">{lesson.conceptBody}</p>
      {lesson.whyThisMatters && (
        <div className="rounded-radius-md border border-primary/20 bg-primary/5 p-4 text-[15px] leading-relaxed text-foreground">
          {lesson.whyThisMatters}
        </div>
      )}
    </div>
  );
}

function ExampleStep({ lesson, exampleVariant }: { lesson: Lesson; exampleVariant: ContentVariant | null }) {
  const text = (exampleVariant?.body?.text as string | undefined) ?? lesson.indonesianExample;

  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Indonesian example</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          How this plays out
        </h2>
      </div>
      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <p className="text-[15px] leading-relaxed text-muted-foreground">{text}</p>
      </div>
      {lesson.commonMistake && (
        <p className="text-[15px] leading-relaxed text-muted-foreground">
          <strong className="text-foreground">Common mistake:</strong> {lesson.commonMistake}
        </p>
      )}
    </div>
  );
}

function QuizStep({
  question,
  onNext,
  onComplete,
}: {
  question: ProcessedQuestion | null;
  onNext: () => void;
  onComplete: () => void;
}) {
  if (!question) {
    return (
      <div className="space-y-5">
        <h2 className="text-[22px] font-bold leading-tight tracking-tight text-foreground">Quick check</h2>
        <p className="text-muted-foreground">No question available for this lesson yet.</p>
        <button
          onClick={onNext}
          className="w-full rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground"
        >
          Continue
        </button>
      </div>
    );
  }

  const seed = question.variantId ?? "legacy";

  return (
    <div className="space-y-5">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Quick check</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Test your understanding
        </h2>
      </div>

      <QuizEngine
        question={question}
        seed={seed}
        onComplete={() => onComplete()}
      />
    </div>
  );
}

function SourceStep({
  sources,
  quizPassed,
  xpReward,
}: {
  sources: LessonSource[];
  quizPassed: boolean;
  xpReward: number;
}) {
  const primary = sources.find((s) => s.isPrimary) ?? sources[0];

  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Source trust</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Where this comes from
        </h2>
      </div>

      {primary ? (
        <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
          <div className="flex items-start justify-between gap-3">
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                Tier {primary.sourceTier} source
              </p>
              <h3 className="mt-1 font-semibold text-foreground">{primary.organization}</h3>
              <p className="text-sm text-muted-foreground">{primary.title}</p>
            </div>
            <span className="shrink-0 rounded-full bg-warning/10 px-2.5 py-1 text-[11px] font-semibold uppercase tracking-wide text-warning">
              {primary.sourceCode}
            </span>
          </div>
          <a
            href={primary.url}
            target="_blank"
            rel="noreferrer"
            className="mt-5 inline-flex items-center gap-1.5 text-sm font-semibold text-primary hover:underline"
          >
            Read source
            <ExternalLinkIcon />
          </a>
        </div>
      ) : (
        <p className="text-sm text-muted-foreground">No source listed for this lesson.</p>
      )}

      {quizPassed && (
        <div className="flex items-center gap-3 rounded-radius-lg border border-success/30 bg-success/5 px-4 py-3.5 text-success">
          <CheckIcon />
          <div>
            <p className="font-semibold">Lesson complete</p>
            <p className="text-sm">+{xpReward} XP</p>
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

function todayKey(): string {
  const d = new Date();
  return `${d.getFullYear()}-${d.getMonth()}-${d.getDate()}`;
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

function LessonIcon() {
  return (
    <svg className="h-14 w-14 text-primary" viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 36h24" />
      <path d="M14 12h20a2 2 0 0 1 2 2v20a2 2 0 0 1-2 2H14a2 2 0 0 1-2-2V14a2 2 0 0 1 2-2z" />
      <path d="M18 20h12" />
      <path d="M18 28h8" />
    </svg>
  );
}
