"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import {
  getLessonBySlug,
  getLessonVariants,
  getLessonSources,
  getRecentAttemptVariantIds,
  getLessonStatus,
  seededIndex,
  type Lesson,
  type ContentVariant,
  type LessonSource,
} from "@/lib/lessons/client";
import { useAuth } from "@/lib/auth/use-auth";
import { QuizEngine } from "@/components/lesson/QuizEngine";
import { validateQuestion, applyParameters, type ProcessedQuestion } from "@/lib/lessons/question";
import { completeLesson, type CompletionResult } from "@/lib/lessons/completion";
import { getFinancialLiteracyLevel } from "@/lib/profile/client";
import { trackEvent } from "@/lib/analytics/client";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { StatCard } from "@/components/StatCard";

const STEP_IDS = ["intro", "concept", "example", "quiz", "source"] as const;

export default function LessonPlayer({
  slug,
  totalLessons,
  chapterLabel,
}: {
  slug: string;
  totalLessons?: number;
  chapterLabel?: string;
}) {
  const router = useRouter();
  const { user } = useAuth(true);
  const { t } = useLocale();
  const steps = STEP_IDS.map((id) => ({ id, label: t(`lesson.step.${id}`) }));
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
  const [literacyLevel, setLiteracyLevel] = useState<string | null>(null);
  const [shownVariantIds, setShownVariantIds] = useState<Set<string>>(new Set());
  const [loadError, setLoadError] = useState<string | null>(null);
  const [retryCounter, setRetryCounter] = useState(0);
  const [alreadyCompleted, setAlreadyCompleted] = useState(false);
  const startTimeRef = useRef<number>(0);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      startTimeRef.current = Date.now();
      setLoading(true);
      setLoadError(null);
      setStep(0);
      setQuizDone(false);
      setQuizCorrect(null);
      setCompletionResult(null);
      setCompletionError(null);
      setShowSummary(false);

      try {
        const data = await getLessonBySlug(slug);
        if (!mounted) return;
        if (!data) {
          setLoading(false);
          return;
        }

        const level = user ? await getFinancialLiteracyLevel(user.id) : null;
        if (!mounted) return;

        const [fetchedExampleVariants, explanationData, fetchedQuestionVariants, sourceData, recentIds, lessonStatus] = await Promise.all([
          getLessonVariants(data.id, "example", level),
          getLessonVariants(data.id, "explanation", level),
          getLessonVariants(data.id, "question", level),
          getLessonSources(data.id),
          user ? getRecentAttemptVariantIds(user.id, data.id) : Promise.resolve(new Set<string>()),
          user ? getLessonStatus(user.id, data.id) : Promise.resolve(null),
        ]);

        if (!mounted) return;

        const seed = user ? `${user.id}:${data.id}:${todayKey()}` : `${data.id}:${todayKey()}`;
        const example = fetchedExampleVariants[seededIndex(seed, fetchedExampleVariants.length)] ?? null;

        const eligibleQuestions = fetchedQuestionVariants.filter((v) => !recentIds.has(v.id));
        const pool = eligibleQuestions.length > 0 ? eligibleQuestions : fetchedQuestionVariants;
        // Per-load entropy: replays should surface a different question each
        // time instead of the same seeded variant all day.
        const selectedVariant = pool[seededIndex(`${seed}:q:${Date.now()}`, pool.length)] ?? null;

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
        setLiteracyLevel(level);
        setAlreadyCompleted(lessonStatus === "completed");
        setShownVariantIds(new Set(example ? [example.id] : []));
        setLoading(false);

        if (user) {
          trackEvent({
            userId: user.id,
            name: "lesson_started",
            properties: {
              lesson_id: data.id,
              lesson_slug: data.slug,
              lesson_number: data.lessonNumber,
            },
          });
        }
      } catch (e) {
        console.error("LessonPlayer load error:", e);
        if (mounted) {
          setLoadError(t("lesson.loadError"));
          setLoading(false);
        }
      }
    };

    load();
    return () => {
      mounted = false;
    };
  }, [slug, user, retryCounter]);


  const nextStep = () => setStep((s) => Math.min(s + 1, steps.length - 1));
  const isLastStep = step === steps.length - 1;

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
      setCompletionError(t("lesson.completionError"));
      return;
    }

    trackEvent({
      userId: user.id,
      name: "lesson_completed",
      properties: {
        lesson_id: lesson.id,
        lesson_slug: lesson.slug,
        lesson_number: lesson.lessonNumber,
        quiz_correct: quizCorrect,
        xp_earned: result.xpEarned,
      },
    });

    setCompletionError(null);
    setCompletionResult(result);
    setShowSummary(true);
  };

  const seedBase = user && lesson ? `${user.id}:${lesson.id}:${todayKey()}` : `${lesson?.id ?? slug}:${todayKey()}`;

  const handleExplainSimpler = (): ContentVariant | null => {
    if (!lesson) return null;
    const available = explanationVariants.filter((v) => !shownVariantIds.has(v.id));
    const pool = available.length > 0 ? available : explanationVariants;
    const variant = pool[seededIndex(`${seedBase}:explain:${shownVariantIds.size}`, pool.length)];

    if (variant) {
      setShownVariantIds((prev) => new Set([...prev, variant.id]));
    }
    return variant;
  };

  const handleAnotherExample = (): ContentVariant | null => {
    if (!lesson) return null;
    const available = exampleVariants.filter((v) => !shownVariantIds.has(v.id) && v.id !== exampleVariant?.id);
    if (available.length === 0) return null;
    const variant = available[seededIndex(`${seedBase}:example:${shownVariantIds.size}`, available.length)];

    if (variant) {
      setShownVariantIds((prev) => new Set([...prev, variant.id]));
    }
    return variant;
  };

  const handleShowAlternateVariant = (variantId: string) => {
    setShownVariantIds((prev) => new Set([...prev, variantId]));
  };

  const handleAnotherQuestion = (): ProcessedQuestion | null => {
    if (!lesson) return null;

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
        return processed;
      }
    }

    // Fallback: re-parameterize the current question if no alternate is available.
    if (activeQuestion) {
      const nextSeed = `${seedBase}:q:${Date.now()}`;
      const processed = { ...applyParameters(nextSeed, activeQuestion), variantId: activeQuestion.variantId };
      setQuizDone(false);
      setQuizCorrect(null);
      setActiveQuestion(processed);
      return processed;
    }

    return null;
  };

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="text-sm text-muted-foreground">{t("lesson.loading")}</div>
      </div>
    );
  }

  if (loadError) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center bg-background p-6 text-center">
        <h1 className="text-xl font-bold text-foreground">{t("lesson.errorTitle")}</h1>
        <p className="mt-2 text-sm text-muted-foreground">{loadError}</p>
        <div className="mt-6 flex w-full max-w-xs flex-col gap-3">
          <button
            onClick={() => setRetryCounter((c) => c + 1)}
            className="rounded-radius-md bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground"
          >
            {t("lesson.tryAgain")}
          </button>
          <button
            onClick={() => router.push("/learn")}
            className="rounded-radius-md border border-muted bg-surface px-5 py-2.5 text-sm font-semibold text-foreground"
          >
            {t("lesson.backToLearn")}
          </button>
        </div>
      </div>
    );
  }

  if (!lesson) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center bg-background p-6 text-center">
        <h1 className="text-xl font-bold text-foreground">{t("lesson.notFoundTitle")}</h1>
        <p className="mt-2 text-sm text-muted-foreground">{t("lesson.notFoundBody")}</p>
        <button
          onClick={() => router.push("/learn")}
          className="mt-6 rounded-radius-md bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground"
        >
          {t("lesson.backToLearn")}
        </button>
      </div>
    );
  }

  return (
    <div className="mx-auto flex min-h-screen max-w-md flex-col bg-background">
      <header className="sticky top-0 z-10 border-b border-muted/60 bg-background/90 px-5 py-3 backdrop-blur-md">
        <div className="flex items-center justify-between">
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            {chapterLabel ??
              `${t("lesson.lessonWord")} ${lesson.lessonNumber}${totalLessons ? ` ${t("lesson.of")} ${totalLessons}` : ""}`}
          </span>
          <button
            onClick={() => router.push("/learn")}
            className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground hover:text-foreground"
          >
            {t("lesson.exit")}
          </button>
        </div>
        <div className="mt-2.5 flex gap-1.5">
          {steps.map((s, i) => (
            <div
              key={s.id}
              aria-label={s.label}
              className={`h-1 flex-1 rounded-full transition-all duration-500 ${
                i <= step ? "bg-primary" : "bg-muted"
              }`}
            />
          ))}
        </div>
      </header>

      <main className="relative flex-1 px-5 py-7">
        {alreadyCompleted && !showSummary && (
          <div
            role="status"
            className="mb-5 flex items-start gap-2.5 rounded-radius-md border border-primary/25 bg-primary/5 px-4 py-3 text-[13px] leading-snug text-foreground"
          >
            <span aria-hidden="true" className="mt-0.5 inline-flex h-4 w-4 shrink-0 items-center justify-center rounded-full bg-primary/15 text-[10px] font-bold text-primary">
              i
            </span>
            {t("lesson.replayNotice")}
          </div>
        )}
        <div key={showSummary ? "summary" : step} className="step-enter">
          {showSummary ? (
            <CompletionStep result={completionResult} lesson={lesson} />
          ) : (
            <>
              {step === 0 && <IntroStep lesson={lesson} />}
              {step === 1 && (
                <ConceptStep
                  lesson={lesson}
                  onExplainSimpler={explanationVariants.length > 0 ? handleExplainSimpler : undefined}
                />
              )}
              {step === 2 && (
                <ExampleStep
                  lesson={lesson}
                  exampleVariant={exampleVariant}
                  exampleVariants={exampleVariants}
                  shownVariantIds={shownVariantIds}
                  onAnotherExample={exampleVariants.length > 0 ? handleAnotherExample : undefined}
                  onShowAlternate={handleShowAlternateVariant}
                />
              )}
              {step === 3 && (
                <QuizStep
                  lesson={lesson}
                  question={activeQuestion}
                  onNext={nextStep}
                  onComplete={(correct) => {
                    setQuizDone(true);
                    setQuizCorrect(correct);
                    if (user && lesson) {
                      trackEvent({
                        userId: user.id,
                        name: "quiz_completed",
                        properties: {
                          lesson_id: lesson.id,
                          lesson_slug: lesson.slug,
                          correct,
                        },
                      });
                    }
                  }}
                  onAnotherQuestion={handleAnotherQuestion}
                />
              )}
              {step === 4 && <SourceStep sources={sources} quizPassed={quizDone} xpReward={lesson.xpReward} />}
            </>
          )}
        </div>
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
            {isLastStep ? t("lesson.finish") : t("lesson.continue")}
            <ArrowRightIcon />
          </button>
        )}
      </footer>

    </div>
  );
}

function IntroStep({ lesson }: { lesson: Lesson }) {
  const { t, locale } = useLocale();
  const title = locale === "id" ? lesson.titleId : lesson.title;
  return (
    <div className="flex flex-col items-center text-center">
      <div className="mb-6 flex h-28 w-28 items-center justify-center rounded-full bg-primary/8">
        <LessonIcon />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">
        {title.split(":")[0]}
      </span>
      <h1 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
        {title}
      </h1>
      <p className="mt-4 text-base leading-relaxed text-muted-foreground">{lesson.summary}</p>
      <div className="mt-8 flex items-center gap-3 text-xs font-medium text-muted-foreground">
        <BookIcon />
        <span>~{lesson.estimatedMinutes} {t("lesson.minutes")}</span>
        <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
        <span className="text-xp">{lesson.xpReward} XP</span>
      </div>
    </div>
  );
}

function ConceptStep({
  lesson,
  onExplainSimpler,
}: {
  lesson: Lesson;
  onExplainSimpler?: () => ContentVariant | null;
}) {
  const [simplerVariant, setSimplerVariant] = useState<ContentVariant | null>(null);
  const [showSimpler, setShowSimpler] = useState(false);
  const { t, locale } = useLocale();

  const handleShowSimpler = () => {
    const variant = onExplainSimpler?.();
    if (variant) {
      setSimplerVariant(variant);
      setShowSimpler(true);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("lesson.theConcept")}</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          {locale === "id" ? lesson.titleId : lesson.title}
        </h2>
      </div>
      {!showSimpler ? (
        <p className="text-[15px] leading-relaxed text-muted-foreground">{lesson.conceptBody}</p>
      ) : (
        simplerVariant && (
          <div className="rounded-radius-md border border-primary/20 bg-primary/5 p-4">
            <p className="text-[15px] leading-relaxed text-foreground">
              {String(simplerVariant.body?.text ?? simplerVariant.body)}
            </p>
          </div>
        )
      )}
      {onExplainSimpler && !showSimpler && (
        <button
          onClick={handleShowSimpler}
          className="inline-flex min-h-[44px] items-center gap-1.5 text-sm font-medium text-primary hover:underline"
          aria-label={t("lesson.simplerExplanation")}
        >
          {t("lesson.simplerExplanation")}
        </button>
      )}
      {showSimpler && (
        <button
          onClick={() => setShowSimpler(false)}
          className="inline-flex min-h-[44px] items-center gap-1.5 text-sm font-medium text-primary hover:underline"
          aria-label={t("lesson.backToMainExplanation")}
        >
          {t("lesson.backToMainExplanation")}
        </button>
      )}
      {lesson.whyThisMatters && (
        <div className="rounded-radius-md border border-primary/20 bg-primary/5 p-4 text-[15px] leading-relaxed text-foreground">
          {lesson.whyThisMatters}
        </div>
      )}
    </div>
  );
}

function ExampleStep({
  lesson,
  exampleVariant,
  exampleVariants,
  shownVariantIds,
  onAnotherExample,
  onShowAlternate,
}: {
  lesson: Lesson;
  exampleVariant: ContentVariant | null;
  exampleVariants: ContentVariant[];
  shownVariantIds: Set<string>;
  onAnotherExample?: () => ContentVariant | null;
  onShowAlternate?: (variantId: string) => void;
}) {
  const [alternateVariant, setAlternateVariant] = useState<ContentVariant | null>(null);
  const [showAlternate, setShowAlternate] = useState(false);
  const { t } = useLocale();

  const mainText = (exampleVariant?.body?.text as string | undefined) ?? lesson.indonesianExample;
  const displayText = showAlternate && alternateVariant
    ? (alternateVariant.body?.text as string | undefined) ?? alternateVariant.body
    : mainText;

  const canShowAnother =
    exampleVariants.length > 1 &&
    exampleVariants.some((v) => v.id !== exampleVariant?.id && !shownVariantIds.has(v.id));

  const handleShowAlternate = () => {
    const variant = onAnotherExample?.();
    if (variant) {
      setAlternateVariant(variant);
      setShowAlternate(true);
      onShowAlternate?.(variant.id);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("lesson.indonesianExample")}</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          {t("lesson.exampleHeading")}
        </h2>
      </div>
      <div className="rounded-radius-lg border border-muted/60 bg-surface p-5 shadow-sm">
        <p className="text-[15px] leading-relaxed text-muted-foreground">{String(displayText ?? "")}</p>
      </div>
      {canShowAnother && !showAlternate && (
        <button
          onClick={handleShowAlternate}
          className="inline-flex min-h-[44px] items-center gap-1.5 text-sm font-medium text-primary hover:underline"
          aria-label={t("lesson.seeAnotherExample")}
        >
          {t("lesson.seeAnotherExample")}
        </button>
      )}
      {showAlternate && (
        <button
          onClick={() => setShowAlternate(false)}
          className="inline-flex min-h-[44px] items-center gap-1.5 text-sm font-medium text-primary hover:underline"
          aria-label={t("lesson.backToMainExample")}
        >
          {t("lesson.backToMainExample")}
        </button>
      )}
      {lesson.commonMistake && (
        <p className="text-[15px] leading-relaxed text-muted-foreground">
          <strong className="text-foreground">{t("lesson.commonMistake")}</strong> {lesson.commonMistake}
        </p>
      )}
    </div>
  );
}

function QuizStep({
  lesson,
  question,
  onNext,
  onComplete,
  onAnotherQuestion,
}: {
  lesson: Lesson;
  question: ProcessedQuestion | null;
  onNext: () => void;
  onComplete: (correct: boolean) => void;
  onAnotherQuestion?: () => ProcessedQuestion | null;
}) {
  const { t } = useLocale();
  if (!question) {
    const concept = lesson.conceptBody.trim().replace(/\.$/, "");
    const fallbackQuestion: ProcessedQuestion = {
      type: "true_false",
      question: `${concept} penting untuk mengelola uang dengan baik.`,
      answer: true,
      explanation: "Pemahaman ini dasar untuk mengelola keuangan sehari-hari.",
      parameters: {},
      variantId: "fallback",
    };

    return (
      <div className="space-y-5">
        <div>
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("lesson.quickCheck")}</span>
          <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
            {t("lesson.quizHeading")}
          </h2>
        </div>
        <QuizEngine
          key="fallback"
          question={fallbackQuestion}
          seed="fallback"
          onComplete={(correct) => {
            onComplete(correct);
            onNext();
          }}
        />
      </div>
    );
  }

  const seed = question.variantId ?? "legacy";

  return (
    <div className="space-y-5">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("lesson.quickCheck")}</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          {t("lesson.quizHeading")}
        </h2>
      </div>

      <QuizEngine
        key={question.variantId ?? "legacy"}
        question={question}
        seed={seed}
        onComplete={(correct) => onComplete(correct)}
      />

      {onAnotherQuestion && (
        <button
          onClick={() => onAnotherQuestion()}
          className="inline-flex min-h-[44px] items-center gap-1.5 text-sm font-medium text-primary hover:underline"
          aria-label={t("lesson.tryAnotherQuestion")}
        >
          {t("lesson.tryAnotherQuestion")}
        </button>
      )}
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
  const { t } = useLocale();
  const primary = sources.filter((s) => s.relevanceType === "primary" || s.isPrimary);
  const supporting = sources.filter((s) => s.relevanceType === "supporting" && !s.isPrimary);
  const furtherReading = sources.filter((s) => s.relevanceType === "further_reading");

  return (
    <div className="space-y-6">
      <div>
        <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("lesson.sourceTrust")}</span>
        <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
          {t("lesson.sourceHeading")}
        </h2>
        <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
          {t("lesson.sourceBody")}
        </p>
      </div>

      {sources.length === 0 ? (
        <p className="text-sm text-muted-foreground">{t("lesson.noSources")}</p>
      ) : (
        <div className="space-y-5">
          {primary.length > 0 && (
            <div className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">{t("lesson.primarySource")}</h3>
              {primary.map((source) => (
                <SourceCard key={source.id} source={source} highlighted />
              ))}
            </div>
          )}

          {supporting.length > 0 && (
            <div className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">{t("lesson.supportingSources")}</h3>
              {supporting.map((source) => (
                <SourceCard key={source.id} source={source} />
              ))}
            </div>
          )}

          {furtherReading.length > 0 && (
            <div className="space-y-3">
              <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">{t("lesson.furtherReading")}</h3>
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
            <p className="font-semibold">{t("lesson.complete")}</p>
            <p className="text-sm">+{xpReward} XP</p>
          </div>
        </div>
      )}
    </div>
  );
}

function SourceCard({ source, highlighted = false }: { source: LessonSource; highlighted?: boolean }) {
  const { t } = useLocale();
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
              {t("lesson.tier")} {source.sourceTier}
            </span>
            <span
              className={`inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${
                verified ? "bg-success/10 text-success" : "bg-warning/10 text-warning"
              }`}
            >
              {verified ? (
                <>
                  <CheckIconMini /> {t("lesson.verified")}
                </>
              ) : (
                t("lesson.needsReview")
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
          {t("lesson.readSource")}
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
  const { t } = useLocale();
  const isReplay = result?.alreadyCompleted ?? false;
  const xpEarned = result?.xpEarned ?? 0;
  const quizBonus = result?.quizBonus ?? 0;
  const streakDays = result?.streakDays ?? 0;
  const badges = result?.badgesEarned ?? [];
  const nextSlug = result?.nextLessonSlug ?? null;

  return (
    <div className="flex flex-col items-center text-center">
      <div className="mb-6 flex h-28 w-28 items-center justify-center rounded-full bg-success/10">
        <CheckIcon />
      </div>
      <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-success">{t("lesson.complete")}</span>
      {isReplay ? (
        <>
          <h2 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
            {t("lesson.replayCompleteTitle")}
          </h2>
          <p className="mt-2 max-w-xs text-sm leading-relaxed text-muted-foreground">
            {t("lesson.noNewXp")}
          </p>
        </>
      ) : (
        <h2 className="mt-2 text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
          +{xpEarned} XP
        </h2>
      )}
      {quizBonus > 0 && (
        <p className="mt-1 text-sm font-medium text-xp">
          {t("lesson.quizBonus").replace("{bonus}", String(quizBonus))}
        </p>
      )}

      <div className="mt-6 grid w-full grid-cols-2 gap-3">
        <StatCard variant="tile" tone="streak" value={`${streakDays}d`} label={t("lesson.streak")} />
        <StatCard variant="tile" tone="xp" value={lesson.xpReward} label={t("lesson.baseXp")} />
      </div>

      {badges.length > 0 && (
        <div className="mt-6 w-full rounded-radius-lg border border-warning/20 bg-warning/5 p-4 text-left">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-warning">{t("lesson.badgeEarned")}</p>
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
            {t("lesson.nextLesson")}
          </button>
        )}
        <button
          onClick={() => router.push("/learn")}
          className="w-full rounded-radius-md border border-muted bg-surface py-3.5 text-sm font-semibold text-foreground transition-colors hover:bg-muted/10"
        >
          {t("lesson.backToLearn")}
        </button>
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

