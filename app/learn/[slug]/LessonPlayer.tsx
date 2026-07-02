"use client";

import { useEffect, useRef, useState } from "react";
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
import { completeLesson, type CompletionResult } from "@/lib/lessons/completion";

const STEPS = [
  { id: "intro", label: "Intro" },
  { id: "concept", label: "Concept" },
  { id: "example", label: "Example" },
  { id: "quiz", label: "Quiz" },
  { id: "source", label: "Source" },
];

type AiAssistType = "explain" | "example" | "quiz";

interface AiAssistContent {
  type: AiAssistType;
  title: string;
  body: string;
  question?: ProcessedQuestion;
}

export default function LessonPlayer({ slug }: { slug: string }) {
  const router = useRouter();
  const { user } = useAuth(true);
  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [exampleVariant, setExampleVariant] = useState<ContentVariant | null>(null);
  const [exampleVariants, setExampleVariants] = useState<ContentVariant[]>([]);
  const [explanationVariants, setExplanationVariants] = useState<ContentVariant[]>([]);
  const [questionVariants, setQuestionVariants] = useState<ContentVariant[]>([]);
  const [activeQuestion, setActiveQuestion] = useState<ProcessedQuestion | null>(null);
  const [sources, setSources] = useState<LessonSource[]>([]);
  const [loading, setLoading] = useState(true);
  const [step, setStep] = useState(0);
  const [quizDone, setQuizDone] = useState(false);
  const [quizCorrect, setQuizCorrect] = useState<boolean | null>(null);
  const [completionResult, setCompletionResult] = useState<CompletionResult | null>(null);
  const [completing, setCompleting] = useState(false);
  const [completionError, setCompletionError] = useState<string | null>(null);
  const [showSummary, setShowSummary] = useState(false);
  const [aiAssistOpen, setAiAssistOpen] = useState(false);
  const [aiAssistContent, setAiAssistContent] = useState<AiAssistContent | null>(null);
  const [shownVariantIds, setShownVariantIds] = useState<Set<string>>(new Set());
  const startTimeRef = useRef<number>(Date.now());

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const data = await getLessonBySlug(slug);
      if (!mounted || !data) {
        setLoading(false);
        return;
      }

      const [fetchedExampleVariants, explanationData, fetchedQuestionVariants, sourceData, recentIds] = await Promise.all([
        getLessonVariants(data.id, "example"),
        getLessonVariants(data.id, "explanation"),
        getLessonVariants(data.id, "question"),
        getLessonSources(data.id),
        user ? getRecentAttemptVariantIds(user.id, data.id) : Promise.resolve(new Set<string>()),
      ]);

      if (!mounted) return;

      const seed = user ? `${user.id}:${data.id}:${todayKey()}` : `${data.id}:${todayKey()}`;
      const example = fetchedExampleVariants[seededIndex(seed, fetchedExampleVariants.length)] ?? null;

      const eligibleQuestions = fetchedQuestionVariants.filter((v) => !recentIds.has(v.id));
      const pool = eligibleQuestions.length > 0 ? eligibleQuestions : fetchedQuestionVariants;
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
      setExampleVariants(fetchedExampleVariants);
      setExplanationVariants(explanationData);
      setQuestionVariants(fetchedQuestionVariants);
      setActiveQuestion(processedQuestion);
      setSources(sourceData);
      setShownVariantIds(new Set(example ? [example.id] : []));
      setLoading(false);
    };

    load();
    return () => {
      mounted = false;
    };
  }, [slug, user]);


  const nextStep = () => setStep((s) => Math.min(s + 1, STEPS.length - 1));
  const isLastStep = step === STEPS.length - 1;

  const finishLesson = async () => {
    if (showSummary) {
      router.push("/learn");
      return;
    }
    if (!user || !lesson) return;

    setCompleting(true);
    setCompletionError(null);
    const timeSpentSeconds = Math.max(1, Math.round((Date.now() - startTimeRef.current) / 1000));
    const result = await completeLesson({
      userId: user.id,
      lessonId: lesson.id,
      score: quizCorrect ? 1 : 0,
      maxScore: 1,
      answersJson: activeQuestion?.variantId
        ? [{ variant_id: activeQuestion.variantId, correct: quizCorrect ?? false }]
        : [],
      timeSpentSeconds,
      quizCorrect: quizCorrect ?? false,
    });
    setCompleting(false);

    if (!result) {
      setCompletionError("We couldn't save your progress. Please check your connection and try again.");
      return;
    }

    setCompletionError(null);
    setCompletionResult(result);
    setShowSummary(true);
  };

  const seedBase = user && lesson ? `${user.id}:${lesson.id}:${todayKey()}` : `${lesson?.id ?? slug}:${todayKey()}`;

  const handleExplainSimpler = () => {
    if (!lesson) return;
    const available = explanationVariants.filter((v) => !shownVariantIds.has(v.id));
    const pool = available.length > 0 ? available : explanationVariants;
    const variant = pool[seededIndex(`${seedBase}:explain:${shownVariantIds.size}`, pool.length)];

    if (variant) {
      setShownVariantIds((prev) => new Set([...prev, variant.id]));
      setAiAssistContent({
        type: "explain",
        title: "Simpler explanation",
        body: String(variant.body?.text ?? variant.body ?? "Here's a simpler take on this concept."),
      });
    } else {
      setAiAssistContent({
        type: "explain",
        title: "Simpler explanation",
        body: lesson.conceptBody || "A simpler explanation is not available yet.",
      });
    }
    setAiAssistOpen(true);
  };

  const handleIndonesianExample = () => {
    if (!lesson) return;
    const available = exampleVariants.filter((v) => !shownVariantIds.has(v.id) && v.id !== exampleVariant?.id);
    const pool = available.length > 0 ? available : exampleVariants;
    const variant = pool[seededIndex(`${seedBase}:example:${shownVariantIds.size}`, pool.length)];

    if (variant) {
      setShownVariantIds((prev) => new Set([...prev, variant.id]));
      setAiAssistContent({
        type: "example",
        title: "Indonesian example",
        body: String(variant.body?.text ?? variant.body ?? "Here's how this plays out in Indonesia."),
      });
    } else {
      setAiAssistContent({
        type: "example",
        title: "Indonesian example",
        body: lesson.indonesianExample || "An Indonesian example is not available yet.",
      });
    }
    setAiAssistOpen(true);
  };

  const handleQuizAgain = () => {
    if (!lesson) return;

    const available = questionVariants.filter((v) => {
      const valid = validateQuestion(v.body);
      return valid && v.id !== activeQuestion?.variantId;
    });
    const pool = available.length > 0 ? available : questionVariants;
    const variant = pool[seededIndex(`${seedBase}:quiz:${Date.now()}`, pool.length)];

    if (variant) {
      const validated = validateQuestion(variant.body);
      if (validated) {
        const nextSeed = `${seedBase}:q:${Date.now()}`;
        const processed = { ...applyParameters(nextSeed, validated), variantId: variant.id };
        setQuizDone(false);
        setQuizCorrect(null);
        setActiveQuestion(processed);
        setAiAssistContent({
          type: "quiz",
          title: "Try another question",
          body: "Here's another way to check your understanding.",
          question: processed,
        });
        setAiAssistOpen(true);
        return;
      }
    }

    // Fallback: re-parameterize the current question if no alternate is available.
    if (activeQuestion) {
      const nextSeed = `${seedBase}:q:${Date.now()}`;
      const processed = { ...applyParameters(nextSeed, activeQuestion), variantId: activeQuestion.variantId };
      setQuizDone(false);
      setQuizCorrect(null);
      setActiveQuestion(processed);
      setAiAssistContent({
        type: "quiz",
        title: "Try another question",
        body: "Here's another way to check your understanding.",
        question: processed,
      });
      setAiAssistOpen(true);
    }
  };

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

      <main className="relative flex-1 px-5 py-7">
        <div key={showSummary ? "summary" : step} className="step-enter">
          {showSummary ? (
            <CompletionStep result={completionResult} lesson={lesson} />
          ) : (
            <>
              {step === 0 && <IntroStep lesson={lesson} />}
              {step === 1 && <ConceptStep lesson={lesson} />}
              {step === 2 && <ExampleStep lesson={lesson} exampleVariant={exampleVariant} />}
              {step === 3 && (
                <QuizStep
                  question={activeQuestion}
                  onNext={nextStep}
                  onComplete={(correct) => {
                    setQuizDone(true);
                    setQuizCorrect(correct);
                  }}
                />
              )}
              {step === 4 && <SourceStep sources={sources} quizPassed={quizDone} xpReward={lesson.xpReward} />}
            </>
          )}
        </div>

        {!showSummary && step >= 1 && step <= 3 && (
          <button
            onClick={() => setAiAssistOpen(true)}
            className="absolute bottom-4 right-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-lg transition-transform hover:scale-105 active:scale-95"
            aria-label="AI assist"
          >
            <SparklesIcon />
          </button>
        )}
      </main>

      <footer className="border-t border-muted/60 bg-surface px-5 py-4">
        {completionError && (
          <div className="mb-4 rounded-radius-md border border-danger/30 bg-danger/5 px-4 py-3 text-sm text-danger">
            {completionError}
          </div>
        )}
        {!showSummary && (
          <button
            onClick={isLastStep ? finishLesson : nextStep}
            disabled={(step === 3 && !quizDone) || completing}
            className="flex w-full items-center justify-center gap-2 rounded-radius-md bg-primary py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all duration-200 hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
          >
            {isLastStep ? "Finish lesson" : "Continue"}
            <ArrowRightIcon />
          </button>
        )}
      </footer>

      <AiAssistPanel
        open={aiAssistOpen}
        onClose={() => {
          setAiAssistOpen(false);
          setAiAssistContent(null);
        }}
        content={aiAssistContent}
        onExplain={handleExplainSimpler}
        onExample={handleIndonesianExample}
        onQuizAgain={step === 3 ? handleQuizAgain : undefined}
        onComplete={(correct) => {
          setQuizDone(true);
          setQuizCorrect(correct);
          setAiAssistOpen(false);
        }}
      />
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
  onComplete: (correct: boolean) => void;
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
        onComplete={(correct) => onComplete(correct)}
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
  const primary = sources.filter((s) => s.relevanceType === "primary" || s.isPrimary);
  const supporting = sources.filter((s) => s.relevanceType === "supporting" && !s.isPrimary);
  const furtherReading = sources.filter((s) => s.relevanceType === "further_reading");

  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">Source trust</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          Where this comes from
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
          Koin only teaches from licensed Indonesian regulators and verified institutions. If you see unsourced advice,
          question it.
        </p>
      </div>

      {sources.length === 0 ? (
        <p className="text-sm text-muted-foreground">No source listed for this lesson.</p>
      ) : (
        <div className="space-y-5">
          {primary.length > 0 && (
            <div className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">Primary source</h3>
              {primary.map((source) => (
                <SourceCard key={source.id} source={source} highlighted />
              ))}
            </div>
          )}

          {supporting.length > 0 && (
            <div className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">Supporting sources</h3>
              {supporting.map((source) => (
                <SourceCard key={source.id} source={source} />
              ))}
            </div>
          )}

          {furtherReading.length > 0 && (
            <div className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">Further reading</h3>
              {furtherReading.map((source) => (
                <SourceCard key={source.id} source={source} />
              ))}
            </div>
          )}
        </div>
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
    </div>
  );
}

function SourceCard({ source, highlighted = false }: { source: LessonSource; highlighted?: boolean }) {
  const verified = source.status === "verified";

  return (
    <div
      className={`rounded-radius-lg border p-5 ${
        highlighted ? "border-primary/30 bg-primary/5" : "border-muted/60 bg-surface"
      }`}
    >
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <span className="rounded-full bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-primary">
              Tier {source.sourceTier}
            </span>
            <span
              className={`inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${
                verified ? "bg-success/10 text-success" : "bg-warning/10 text-warning"
              }`}
            >
              {verified ? (
                <>
                  <CheckIconMini /> Verified
                </>
              ) : (
                "Needs review"
              )}
            </span>
          </div>
          <h4 className="mt-2 font-semibold text-foreground">{source.title}</h4>
          <p className="text-sm text-muted-foreground">{source.organization}</p>
          {source.citationLabel && (
            <p className="mt-1 text-xs text-muted-foreground">{source.citationLabel}</p>
          )}
        </div>
        <span className="shrink-0 rounded-full bg-muted px-2.5 py-1 text-[10px] font-semibold uppercase tracking-wide text-muted-foreground">
          {source.sourceCode}
        </span>
      </div>
      {source.url && (
        <a
          href={source.url}
          target="_blank"
          rel="noreferrer"
          className="mt-4 inline-flex items-center gap-1.5 text-sm font-semibold text-primary hover:underline"
        >
          Read source
          <ExternalLinkIcon />
        </a>
      )}
    </div>
  );
}

function CheckIconMini() {
  return (
    <svg className="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="m20 6-9 9-5-5" />
    </svg>
  );
}

function CompletionStep({
  result,
  lesson,
}: {
  result: CompletionResult | null;
  lesson: Lesson;
}) {
  const router = useRouter();
  const xpEarned = result?.xpEarned ?? lesson.xpReward;
  const quizBonus = result?.quizBonus ?? 0;
  const streakDays = result?.streakDays ?? 0;
  const badges = result?.badgesEarned ?? [];
  const nextSlug = result?.nextLessonSlug ?? null;

  return (
    <div className="flex flex-col items-center text-center">
      <div className="mb-6 flex h-28 w-28 items-center justify-center rounded-full bg-success/10">
        <CheckIcon />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-success">Lesson complete</span>
      <h2 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        +{xpEarned} XP
      </h2>
      {quizBonus > 0 && (
        <p className="mt-1 text-sm font-medium text-xp">Includes +{quizBonus} quiz bonus</p>
      )}

      <div className="mt-6 grid w-full grid-cols-2 gap-3">
        <div className="rounded-radius-lg bg-streak/10 p-4 text-center">
          <div className="text-xl font-bold text-streak">{streakDays}d</div>
          <div className="text-xs font-medium text-streak/80">Streak</div>
        </div>
        <div className="rounded-radius-lg bg-xp/10 p-4 text-center">
          <div className="text-xl font-bold text-xp">{lesson.xpReward}</div>
          <div className="text-xs font-medium text-xp/80">Base XP</div>
        </div>
      </div>

      {badges.length > 0 && (
        <div className="mt-6 w-full rounded-radius-lg border border-warning/20 bg-warning/5 p-4 text-left">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-warning">Badge earned</p>
          <div className="mt-2 flex flex-wrap gap-2">
            {badges.map((badge) => (
              <span
                key={badge.slug}
                className="inline-flex items-center gap-1.5 rounded-full bg-surface px-3 py-1.5 text-sm font-medium text-foreground shadow-sm"
              >
                <span>{badge.icon}</span>
                {badge.name}
              </span>
            ))}
          </div>
        </div>
      )}

      <div className="mt-6 grid w-full gap-3">
        {nextSlug && (
          <button
            onClick={() => router.push(`/learn/${nextSlug}`)}
            className="w-full rounded-radius-md border border-primary bg-primary/5 py-3.5 text-sm font-semibold text-primary transition-colors hover:bg-primary/10"
          >
            Next lesson
          </button>
        )}
        <button
          onClick={() => router.push("/learn")}
          className="w-full rounded-radius-md border border-muted bg-surface py-3.5 text-sm font-semibold text-foreground transition-colors hover:bg-muted/10"
        >
          Back to Learn
        </button>
      </div>
    </div>
  );
}

function AiAssistPanel({
  open,
  onClose,
  content,
  onExplain,
  onExample,
  onQuizAgain,
  onComplete,
}: {
  open: boolean;
  onClose: () => void;
  content: AiAssistContent | null;
  onExplain: () => void;
  onExample: () => void;
  onQuizAgain?: () => void;
  onComplete: (correct: boolean) => void;
}) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-background/80 p-4 backdrop-blur-sm sm:items-center">
      <div className="w-full max-w-md rounded-radius-lg bg-surface p-5 shadow-xl">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <SparklesIcon />
            <span className="text-sm font-semibold text-foreground">AI assist</span>
          </div>
          <button
            onClick={onClose}
            className="rounded-radius-sm p-1 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
            aria-label="Close"
          >
            <CloseIcon />
          </button>
        </div>

        {!content && (
          <div className="mt-5 grid gap-3">
            <button
              onClick={onExplain}
              className="flex items-center justify-between rounded-radius-md border border-muted bg-background px-4 py-3 text-left text-sm font-medium text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5"
            >
              <span>Explain simpler</span>
              <ArrowRightIcon />
            </button>
            <button
              onClick={onExample}
              className="flex items-center justify-between rounded-radius-md border border-muted bg-background px-4 py-3 text-left text-sm font-medium text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5"
            >
              <span>Indonesian example</span>
              <ArrowRightIcon />
            </button>
            {onQuizAgain && (
              <button
                onClick={onQuizAgain}
                className="flex items-center justify-between rounded-radius-md border border-muted bg-background px-4 py-3 text-left text-sm font-medium text-foreground transition-colors hover:border-primary/40 hover:bg-primary/5"
              >
                <span>Quiz me again</span>
                <ArrowRightIcon />
              </button>
            )}
          </div>
        )}

        {content && (
          <div className="mt-5 space-y-4">
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{content.title}</p>
              <p className="mt-2 text-sm leading-relaxed text-foreground">{content.body}</p>
            </div>
            {content.type === "quiz" && content.question && (
              <QuizEngine question={content.question} seed="ai-assist" onComplete={onComplete} />
            )}
            <button
              onClick={() => onClose()}
              className="w-full rounded-radius-md border border-muted bg-background py-2.5 text-sm font-medium text-foreground transition-colors hover:bg-muted/10"
            >
              Close
            </button>
          </div>
        )}
      </div>
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

function SparklesIcon() {
  return (
    <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .962 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .962L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.962 0z" />
      <path d="M20 3v4" />
      <path d="M22 5h-4" />
      <path d="M4 17v2" />
      <path d="M5 18H3" />
    </svg>
  );
}

function CloseIcon() {
  return (
    <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M18 6 6 18" />
      <path d="m6 6 12 12" />
    </svg>
  );
}
