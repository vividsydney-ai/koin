"use client";

import { useEffect, useRef, useState, type ReactNode } from "react";
import { useRouter } from "next/navigation";
import {
  getLessonBySlug,
  getLessonVariants,
  getLessonSources,
  getLessonVisualBlocks,
  getRecentAttemptVariantIds,
  getLessonStatus,
  getChapterCompletionMilestone,
  type ChapterCompletionMilestone,
  seededIndex,
  type Lesson,
  type ContentVariant,
  type LessonSource,
  type RecentAttemptInfo,
} from "@/lib/lessons/client";
import { useAuth } from "@/lib/auth/use-auth";
import { QuizEngine } from "@/components/lesson/QuizEngine";
import { LessonChartVisual } from "@/components/charts/LessonChartVisual";
import { LessonVisualBlocks } from "@/components/lesson/visuals/LessonVisualBlocks";
import type { LessonVisualBlock } from "@/lib/lessons/visual-block";
import {
  validateQuestion,
  applyParameters,
  type ProcessedQuestion,
  type QuizQuestion,
} from "@/lib/lessons/question";
import { completeLesson, type CompletionResult } from "@/lib/lessons/completion";
import type { ServiceError } from "@/lib/types/service-error";
import { getFinancialLiteracyLevel } from "@/lib/profile/client";
import { trackEvent } from "@/lib/analytics/client";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { StatCard } from "@/components/StatCard";
import { ReachableLink } from "@/components/sources/ReachableLink";
import { lessonCheckCount } from "@/lib/lessons/mastery";
import { getLocalizedSourceUrl } from "@/lib/sources/localized-url";

const STEP_IDS = ["intro", "concept", "example", "quiz", "source"] as const;

interface ValidatedQuestionVariant {
  variant: ContentVariant;
  question: QuizQuestion;
}

function getValidatedQuestionVariants(variants: ContentVariant[]): ValidatedQuestionVariant[] {
  return variants
    .map((variant) => {
      const question = validateQuestion(variant.body);
      return question ? { variant, question } : null;
    })
    .filter((item): item is ValidatedQuestionVariant => item !== null);
}

function pickRotatedQuestionVariant(
  infos: ValidatedQuestionVariant[],
  avoidIds: Set<string>,
  avoidType: string | null,
  seed: string
): ContentVariant | null {
  if (infos.length === 0) return null;

  let pool = infos.filter((info) => !avoidIds.has(info.variant.id));
  if (pool.length === 0) pool = infos;

  if (avoidType) {
    const differentType = pool.filter((info) => info.question.type !== avoidType);
    if (differentType.length > 0) pool = differentType;
  }

  // Defensive fallback: if rotation constraints eliminated every variant,
  // still return a valid question rather than falling back to a generic.
  if (pool.length === 0) {
    pool = infos;
  }

  const index = seededIndex(seed, pool.length);
  return pool[index]?.variant ?? null;
}

export default function LessonPlayer({
  slug,
  totalLessons,
  chapterNumber,
  lessonNumber,
  chapterLessonsCount,
}: {
  slug: string;
  totalLessons?: number;
  chapterNumber?: number;
  lessonNumber?: number;
  chapterLessonsCount?: number;
}) {
  const router = useRouter();
  const { user } = useAuth(true);
  const { t, locale } = useLocale();
  const steps = STEP_IDS.map((id) => ({ id, label: t(`lesson.step.${id}`) }));
  const [lesson, setLesson] = useState<Lesson | null>(null);
  const [exampleVariant, setExampleVariant] = useState<ContentVariant | null>(null);
  const [exampleVariants, setExampleVariants] = useState<ContentVariant[]>([]);
  const [explanationVariants, setExplanationVariants] = useState<ContentVariant[]>([]);
  const [questionVariants, setQuestionVariants] = useState<ContentVariant[]>([]);
  const [activeQuestion, setActiveQuestion] = useState<ProcessedQuestion | null>(null);
  const [sources, setSources] = useState<LessonSource[]>([]);
  const [visualBlocks, setVisualBlocks] = useState<LessonVisualBlock[]>([]);
  const [loading, setLoading] = useState(true);
  const [step, setStep] = useState(0);
  const [quizDone, setQuizDone] = useState(false);
  const [quizCorrect, setQuizCorrect] = useState<boolean | null>(null);
  const [quizResults, setQuizResults] = useState<boolean[]>([]);
  const [completionResult, setCompletionResult] = useState<CompletionResult | null>(null);
  const [completing, setCompleting] = useState(false);
  const [completionError, setCompletionError] = useState<string | null>(null);
  const [showSummary, setShowSummary] = useState(false);
  const [shownVariantIds, setShownVariantIds] = useState<Set<string>>(new Set());
  const [shownQuestionVariantIds, setShownQuestionVariantIds] = useState<Set<string>>(new Set());
  const [loadError, setLoadError] = useState<string | null>(null);
  const [retryCounter, setRetryCounter] = useState(0);
  const [alreadyCompleted, setAlreadyCompleted] = useState(false);
  const [chapterMilestone, setChapterMilestone] = useState<ChapterCompletionMilestone | null>(null);
  const startTimeRef = useRef<number>(0);
  useEffect(() => {
    if (!chapterMilestone) return;
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") setChapterMilestone(null);
    };
    window.addEventListener("keydown", closeOnEscape);
    return () => window.removeEventListener("keydown", closeOnEscape);
  }, [chapterMilestone]);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      startTimeRef.current = Date.now();
      setLoading(true);
      setLoadError(null);
      setStep(0);
      setQuizDone(false);
      setQuizCorrect(null);
      setQuizResults([]);
      setCompletionResult(null);
      setCompletionError(null);
      setShowSummary(false);
      setChapterMilestone(null);

      try {
        const data = await getLessonBySlug(slug);
        if (!mounted) return;
        if (!data) {
          setLoading(false);
          return;
        }

        const level = user ? await getFinancialLiteracyLevel(user.id) : null;
        if (!mounted) return;

        const [fetchedExampleVariants, explanationData, fetchedQuestionVariants, sourceData, visualData, recentInfo, lessonStatus] = await Promise.all([
          getLessonVariants(data.id, "example", level, locale),
          getLessonVariants(data.id, "explanation", level, locale),
          getLessonVariants(data.id, "question", level, locale),
          getLessonSources(data.id),
          getLessonVisualBlocks(data.id),
          user
            ? getRecentAttemptVariantIds(user.id, data.id)
            : Promise.resolve<RecentAttemptInfo>({ ids: new Set(), lastVariantId: null }),
          user ? getLessonStatus(user.id, data.id) : Promise.resolve(null),
        ]);

        if (!mounted) return;

        const seed = user ? `${user.id}:${data.id}:${todayKey()}` : `${data.id}:${todayKey()}`;

        let example: ContentVariant | null = null;
        let exampleVariants: ContentVariant[] = fetchedExampleVariants;
        const explanationVariants: ContentVariant[] = explanationData;
        let questionVariants: ContentVariant[] = fetchedQuestionVariants;
        const baseQuizData = locale === "id" && data.quizDataId ? data.quizDataId : data.quizData;
        let processedQuestion: ProcessedQuestion | null = null;

        // Use the localized variant pool for both locales; it already swaps body/body_id
        // based on locale inside getLessonVariants.
        example = fetchedExampleVariants[seededIndex(seed, fetchedExampleVariants.length)] ?? null;

        let questionInfos = getValidatedQuestionVariants(fetchedQuestionVariants);
        // Later lessons need two distinct checks. If the learner's adaptive
        // difficulty pool is too small, widen only the question pool instead
        // of silently weakening the mastery requirement.
        if (questionInfos.length < lessonCheckCount(chapterNumber)) {
          questionVariants = await getLessonVariants(data.id, "question", null, locale);
          questionInfos = getValidatedQuestionVariants(questionVariants);
        }
        if (questionInfos.length < lessonCheckCount(chapterNumber) && baseQuizData.length > 0) {
          const baseQuestionVariants: ContentVariant[] = baseQuizData.map((body, index) => ({
            id: `base-quiz:${data.id}:${index}`,
            variantType: "question",
            body,
            difficulty: data.difficulty,
            topicTag: null,
          }));
          questionVariants = [...questionVariants, ...baseQuestionVariants];
          questionInfos = getValidatedQuestionVariants(questionVariants);
        }
        const lastAttemptedType = recentInfo.lastVariantId
          ? questionInfos.find((info) => info.variant.id === recentInfo.lastVariantId)?.question.type ?? null
          : null;
        const visualAppliedQuestions = visualData.length > 0
          ? questionInfos.filter((info) => info.variant.topicTag === "visual_applied")
          : [];
        const selectedQuestionVariant = pickRotatedQuestionVariant(
          visualAppliedQuestions.length > 0 ? visualAppliedQuestions : questionInfos,
          recentInfo.ids,
          lastAttemptedType,
          `${seed}:q:${Date.now()}`
        );
        if (selectedQuestionVariant) {
          const validated = validateQuestion(selectedQuestionVariant.body);
          if (validated) {
            processedQuestion = {
              ...applyParameters(seed, validated),
              variantId: selectedQuestionVariant.id,
            };
          }
        }

        // Fallback to the base Indonesian example only when the variant pool is empty.
        if (!example && locale === "id" && data.indonesianExample) {
          example = {
            id: `base-example:${data.id}`,
            variantType: "example",
            body: { text: data.indonesianExample },
            difficulty: data.difficulty,
            topicTag: null,
          };
          exampleVariants = [example];
        }
        if (!processedQuestion) {
          if (baseQuizData.length > 0) {
            const validated = validateQuestion(baseQuizData[0]);
            if (validated) {
              processedQuestion = applyParameters(seed, validated);
            }
          }
        }

        if (!processedQuestion) {
          console.error("LessonPlayer: no valid question variant could be selected", {
            lessonId: data.id,
            slug: data.slug,
            variantCount: fetchedQuestionVariants.length,
            validVariantCount: questionInfos.length,
          });
        }

        setLesson(data);
        setExampleVariant(example);
        setExampleVariants(exampleVariants);
        setExplanationVariants(explanationVariants);
        setQuestionVariants(questionVariants);
        setActiveQuestion(processedQuestion);
        setSources(sourceData);
        setVisualBlocks(visualData);
        setAlreadyCompleted(lessonStatus === "completed");
        setShownVariantIds(new Set(example ? [example.id] : []));
        setShownQuestionVariantIds(new Set(processedQuestion?.variantId ? [processedQuestion.variantId] : []));
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
    // `t` is a stable i18n function from LocaleProvider; including it would
    // force unnecessary reloads in tests that mock the hook per-render.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [slug, user, retryCounter, locale]);


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
      lessonNumber: lesson.lessonNumber,
      score: quizResults.filter(Boolean).length,
      maxScore: Math.max(1, quizResults.length),
      answersJson: Array.from(shownQuestionVariantIds).map((variantId, index) => ({
        variant_id: variantId,
        correct: quizResults[index] ?? false,
      })),
      timeSpentSeconds,
      quizCorrect: quizCorrect ?? false,
    });
    setCompleting(false);

    if ("code" in result) {
      const error = result as ServiceError;
      if (error.message.toLowerCase().includes("too quickly")) {
        setCompletionError(t("lesson.errorTooFast"));
      } else {
        setCompletionError(t("lesson.completionError"));
      }
      trackEvent({
        userId: user.id,
        name: "lesson_completion_failed",
        properties: {
          lesson_id: lesson.id,
          lesson_slug: lesson.slug,
          error_code: error.code,
          error_message: error.message,
        },
      });
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

    const milestone = result.alreadyCompleted
      ? null
      : await getChapterCompletionMilestone(user.id, lesson.id);

    setCompletionError(null);
    setCompletionResult(result);
    setShowSummary(true);
    setChapterMilestone(milestone);
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
    if (!lesson || exampleVariants.length === 0) return null;
    const available = exampleVariants.filter((v) => !shownVariantIds.has(v.id));
    if (available.length === 0) return null;
    const variant = available[seededIndex(`${seedBase}:example:${shownVariantIds.size}:${Date.now()}`, available.length)];

    if (variant) {
      setShownVariantIds((prev) => new Set([...prev, variant.id]));
    }
    return variant;
  };

  const handleShowAlternateVariant = (variantId: string) => {
    setShownVariantIds((prev) => new Set([...prev, variantId]));
  };

  const handleAnotherQuestion = (): ProcessedQuestion | null => {
    if (!lesson || questionVariants.length === 0) return null;

    const infos = getValidatedQuestionVariants(questionVariants);
    const variant = pickRotatedQuestionVariant(
      infos,
      shownQuestionVariantIds,
      activeQuestion?.type ?? null,
      `${seedBase}:quiz:${shownQuestionVariantIds.size}:${Date.now()}`
    );

    if (variant) {
      const validated = validateQuestion(variant.body);
      if (validated) {
        const nextSeed = `${seedBase}:q:${Date.now()}`;
        const processed = { ...applyParameters(nextSeed, validated), variantId: variant.id };
        setQuizDone(false);
        setQuizCorrect(null);
        setActiveQuestion(processed);
        setShownQuestionVariantIds((prev) => new Set([...prev, variant.id]));
        return processed;
      }
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
            className="rounded-md bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground"
          >
            {t("lesson.tryAgain")}
          </button>
          <button
            onClick={() => router.push("/learn")}
            className="rounded-md border border-muted bg-surface px-5 py-2.5 text-sm font-semibold text-foreground"
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
          className="mt-6 rounded-md bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground"
        >
          {t("lesson.backToLearn")}
        </button>
      </div>
    );
  }

  return (
    <div className="mx-auto flex min-h-screen w-full max-w-md flex-col bg-background sm:max-w-2xl lg:max-w-4xl xl:max-w-7xl 2xl:max-w-[1440px]">
      <header className="sticky top-0 z-10 border-b border-muted/60 bg-background/90 px-5 py-3 backdrop-blur-md sm:px-6 lg:px-8">
        <div className="flex items-center justify-between">
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            {chapterNumber && lessonNumber && chapterLessonsCount
              ? t("lesson.chapterLabel")
                  .replace("{chapterNumber}", String(chapterNumber).padStart(2, "0"))
                  .replace("{lessonNumber}", String(lessonNumber))
                  .replace("{total}", String(chapterLessonsCount))
              : `${t("lesson.lessonWord")} ${lesson.lessonNumber}${totalLessons ? ` ${t("lesson.of")} ${totalLessons}` : ""}`}
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
              className={`h-1.5 flex-1 rounded-full transition-all duration-500 ${
                i <= step ? "bg-primary" : "bg-muted"
              }`}
            />
          ))}
        </div>
      </header>

      <main className="relative flex-1 px-5 py-7 sm:px-6 lg:px-8">
        {alreadyCompleted && !showSummary && (
          <div
            role="status"
            className="mb-5 flex items-start gap-2.5 rounded-md border border-primary/25 bg-primary/5 px-4 py-3 text-[13px] leading-snug text-foreground"
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
                  visualBlocks={visualBlocks}
                  onExplainSimpler={
                    explanationVariants.length > 0
                      ? handleExplainSimpler
                      : undefined
                  }
                />
              )}
              {step === 2 && (
                <ExampleStep
                  lesson={lesson}
                  exampleVariant={exampleVariant}
                  exampleVariants={exampleVariants}
                  shownVariantIds={shownVariantIds}
                  onAnotherExample={
                    exampleVariants.length > 0
                      ? handleAnotherExample
                      : undefined
                  }
                  onShowAlternate={handleShowAlternateVariant}
                />
              )}
              {step === 3 && (
                <QuizStep
                  question={activeQuestion}
                  requiredChecks={lessonCheckCount(chapterNumber)}
                  onComplete={(results) => {
                    setQuizDone(true);
                    setQuizResults(results);
                    setQuizCorrect(results.filter(Boolean).length >= lessonCheckCount(chapterNumber));
                    if (user && lesson) {
                      trackEvent({
                        userId: user.id,
                        name: "quiz_completed",
                        properties: {
                          lesson_id: lesson.id,
                          lesson_slug: lesson.slug,
                          correct: results.every(Boolean),
                          check_count: results.length,
                          correct_count: results.filter(Boolean).length,
                        },
                      });
                    }
                  }}
                  onAnotherQuestion={handleAnotherQuestion}
                  canShowAnotherQuestion={
                    questionVariants.filter((v) => validateQuestion(v.body) && v.id !== activeQuestion?.variantId).length > 0
                  }
                />
              )}
              {step === 4 && <SourceStep sources={sources} quizPassed={quizDone} xpReward={lesson.xpReward} alreadyCompleted={alreadyCompleted} />}
            </>
          )}
        </div>
      </main>

      <footer className="border-t border-muted/60 bg-surface px-5 py-4 sm:px-6 lg:px-8">
        {completionError && (
          <div className="mb-4 rounded-md border border-danger/30 bg-danger/5 px-4 py-3 text-sm text-danger">
            {completionError}
          </div>
        )}
        {!showSummary && (
          <button
            onClick={isLastStep ? finishLesson : nextStep}
            disabled={(step === 3 && !quizDone) || completing}
            className="flex w-full items-center justify-center gap-2 rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98] disabled:opacity-50"
          >
            {isLastStep ? t("lesson.finish") : t("lesson.continue")}
            <ArrowRightIcon />
          </button>
        )}
      </footer>

      {chapterMilestone && (
        <ChapterCompletionCelebration
          milestone={chapterMilestone}
          onClose={() => setChapterMilestone(null)}
        />
      )}

    </div>
  );
}

function IntroStep({ lesson }: { lesson: Lesson }) {
  const { t, locale } = useLocale();
  const title = locale === "id" ? lesson.titleId : lesson.title;
  const summary = locale === "id" ? (lesson.summaryId ?? lesson.summary) : lesson.summary;
  return (
    <article className="relative overflow-hidden rounded-card bg-gradient-to-br from-primary to-[var(--rup-orbit-700)] p-6 text-white">
      <span className="absolute -right-8 -top-8 h-32 w-32 rounded-full bg-white/10" />
      <span className="absolute -bottom-10 -left-10 h-24 w-24 rounded-full border-[10px] border-white/10" />
      <div className="relative flex flex-col items-center text-center">
        <div className="mb-5 flex h-24 w-24 items-center justify-center rounded-full bg-white/10">
          <LessonIcon className="h-12 w-12 text-white" />
        </div>
        <span className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-white">
          {title.split(":")[0]}
        </span>
        <h1 className="mt-3 font-display text-2xl font-bold leading-tight">
          {title}
        </h1>
        <p className="mt-2 text-[15px] leading-relaxed text-white/80">{summary}</p>
        <div className="mt-5 flex items-center gap-3 text-xs font-semibold text-white/80">
          <BookIcon className="h-3.5 w-3.5 text-white" />
          <span>~{lesson.estimatedMinutes} {t("lesson.minutes")}</span>
          <span className="h-1 w-1 rounded-full bg-white/50" />
          <span className="text-white">{lesson.xpReward} XP</span>
        </div>
      </div>
    </article>
  );
}

function splitSentences(text: string): string[] {
  if (!text) return [];
  const sentences = text
    .split(/(?<=[.!?])(?:\s+|$)/)
    .map((s) => s.trim())
    .filter((s) => s.length > 0);
  if (sentences.length === 0) return [text];

  // Keep paragraphs bite-sized: break very long sentences at natural pause markers.
  const chunks: string[] = [];
  for (const sentence of sentences) {
    if (sentence.length <= 160) {
      chunks.push(sentence);
      continue;
    }
    const parts = sentence
      .split(/(?<=[:;])(?:\s+|$)/)
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
    chunks.push(...(parts.length > 1 ? parts : [sentence]));
  }
  return chunks;
}

function SplitParagraphs({
  text,
  className = "",
}: {
  text: string | null | undefined;
  className?: string;
}) {
  if (!text) return null;

  const renderInline = (value: string): ReactNode[] => {
    const tokens = value.split(/(\*\*[^*]+\*\*|__[^_]+__|`[^`]+`)/g).filter(Boolean);
    return tokens.map((token, index) => {
      if ((token.startsWith("**") && token.endsWith("**")) || (token.startsWith("__") && token.endsWith("__"))) {
        return <strong key={index} className="font-bold text-foreground">{token.slice(2, -2)}</strong>;
      }
      if (token.startsWith("`") && token.endsWith("`")) {
        return <code key={index} className="rounded bg-surface-raised px-1.5 py-0.5 text-[0.92em]">{token.slice(1, -1)}</code>;
      }
      return <span key={index}>{token}</span>;
    });
  };

  const lines = String(text).replace(/\r\n?/g, "\n").split("\n");
  const blocks: Array<{ type: "paragraph" | "ul" | "ol" | "heading"; lines: string[] }> = [];
  let current: { type: "paragraph" | "ul" | "ol" | "heading"; lines: string[] } | null = null;
  const flush = () => {
    if (current?.lines.length) blocks.push(current);
    current = null;
  };

  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line) {
      flush();
      continue;
    }
    const heading = line.match(/^#{2,4}\s+(.+)$/);
    const unordered = line.match(/^[-*]\s+(.+)$/);
    const ordered = line.match(/^\d+[.)]\s+(.+)$/);
    if (heading) {
      flush();
      blocks.push({ type: "heading", lines: [heading[1]] });
    } else if (unordered) {
      if (!current || current.type !== "ul") {
        flush();
        current = { type: "ul", lines: [] };
      }
      current.lines.push(unordered[1]);
    } else if (ordered) {
      if (!current || current.type !== "ol") {
        flush();
        current = { type: "ol", lines: [] };
      }
      current.lines.push(ordered[1]);
    } else {
      if (!current || current.type !== "paragraph") {
        flush();
        current = { type: "paragraph", lines: [] };
      }
      current.lines.push(line);
    }
  }
  flush();

  return (
    <div className={className}>
      {blocks.map((block, i) => {
        if (block.type === "heading") {
          return <h3 key={i} className="pt-1 text-base font-bold leading-6 text-foreground">{renderInline(block.lines[0])}</h3>;
        }
        if (block.type === "ul" || block.type === "ol") {
          const List = block.type === "ul" ? "ul" : "ol";
          return (
            <List key={i} className={`${block.type === "ul" ? "list-disc" : "list-decimal"} space-y-1 pl-5 text-[15px] font-medium leading-7 text-[#5a5d5f] sm:text-base sm:leading-7`}>
              {block.lines.map((item, itemIndex) => <li key={itemIndex}>{renderInline(item)}</li>)}
            </List>
          );
        }
        // Keep long prose readable without destroying authored list/paragraph structure.
        const sentences = splitSentences(block.lines.join(" "));
        const parts = sentences.reduce<string[]>((paragraphs, sentence, index) => {
          if (index % 2 === 0) paragraphs.push(sentence);
          else paragraphs[paragraphs.length - 1] += ` ${sentence}`;
          return paragraphs;
        }, []);
        return parts.map((part, partIndex) => (
          <p key={`${i}-${partIndex}`} className="text-[15px] font-medium leading-7 text-[#5a5d5f] sm:text-base sm:leading-7">
            {renderInline(part)}
          </p>
        ));
      })}
    </div>
  );
}

function SectionKicker({
  icon,
  label,
  tone = "primary",
}: {
  icon: React.ReactNode;
  label: string;
  tone?: "primary" | "success" | "warning" | "info";
}) {
  const toneClasses = {
    primary: "bg-primary/10 text-primary",
    success: "bg-success/10 text-success",
    warning: "bg-warning/10 text-warning",
    info: "bg-info/10 text-info",
  };
  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide ${toneClasses[tone]}`}
    >
      {icon}
      {label}
    </span>
  );
}

function ConceptStep({
  lesson,
  visualBlocks,
  onExplainSimpler,
}: {
  lesson: Lesson;
  visualBlocks: LessonVisualBlock[];
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

  const title = locale === "id" ? lesson.titleId : lesson.title;
  const conceptBody = locale === "id" ? (lesson.conceptBodyId ?? lesson.conceptBody) : lesson.conceptBody;
  const whyThisMatters = locale === "id" ? (lesson.whyThisMattersId ?? lesson.whyThisMatters) : lesson.whyThisMatters;

  return (
    <article className="rounded-card border border-muted bg-surface p-5 shadow-sm">
      <SectionKicker icon={<BookIcon className="h-3.5 w-3.5" />} label={t("lesson.theConcept")} tone="primary" />
      <h2 className="mt-2 font-display text-lg font-bold text-foreground">
        {title}
      </h2>
      {!showSimpler ? (
        <div className="mt-4 space-y-3">
          <SectionKicker icon={<LightbulbIcon />} label={t("lesson.theIdea")} tone="primary" />
          <SplitParagraphs text={conceptBody} className="space-y-4" />
          <LessonVisualBlocks blocks={visualBlocks} locale={locale === "id" ? "id" : "en"} placement="concept" />
          {(lesson.chapter === "Reading Trading Charts" || lesson.chapter === "Decision Analysis Lab") && (
            <LessonChartVisual slug={lesson.slug} advanced={lesson.chapter === "Decision Analysis Lab"} />
          )}
        </div>
      ) : (
        simplerVariant && (
          <div
            className="mt-4 space-y-3 rounded-md border border-primary/20 p-4 text-foreground"
            style={{ background: "color-mix(in srgb, var(--color-primary) 8%, var(--color-surface))" }}
          >
            <SectionKicker icon={<LightbulbIcon />} label={t("lesson.simplerExplanation")} tone="primary" />
            <SplitParagraphs
              text={String(simplerVariant.body?.text ?? simplerVariant.body)}
              className="space-y-3"
            />
          </div>
        )
      )}
      {onExplainSimpler && !showSimpler && (
        <button
          onClick={handleShowSimpler}
          className="mt-4 inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
          aria-label={t("lesson.simplerExplanation")}
        >
          {t("lesson.simplerExplanation")}
        </button>
      )}
      {showSimpler && (
        <button
          onClick={() => setShowSimpler(false)}
          className="mt-4 inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
          aria-label={t("lesson.backToMainExplanation")}
        >
          {t("lesson.backToMainExplanation")}
        </button>
      )}
      {whyThisMatters && (
        <div
          className="mt-4 space-y-3 rounded-md border border-success/20 p-4 text-foreground"
          style={{ background: "color-mix(in srgb, var(--color-success) 8%, var(--color-surface))" }}
        >
          <SectionKicker icon={<HeartIcon />} label={t("lesson.whyItMatters")} tone="success" />
          <SplitParagraphs text={whyThisMatters} className="space-y-3" />
        </div>
      )}
    </article>
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
  const { t, locale } = useLocale();

  const mainText = (exampleVariant?.body?.text as string | undefined) ?? lesson.summary;
  const commonMistake = locale === "id" ? (lesson.commonMistakeId ?? lesson.commonMistake) : lesson.commonMistake;
  const displayText = showAlternate && alternateVariant
    ? (alternateVariant.body?.text as string | undefined) ?? alternateVariant.body
    : mainText;

  const canShowAnother =
    exampleVariants.length > 0 &&
    exampleVariants.some((v) => !shownVariantIds.has(v.id));

  const handleShowAlternate = () => {
    const variant = onAnotherExample?.();
    if (variant) {
      setAlternateVariant(variant);
      setShowAlternate(true);
      onShowAlternate?.(variant.id);
    }
  };

  return (
    <article className="rounded-card border border-muted bg-surface p-5 shadow-sm">
      <SectionKicker icon={<TargetIcon />} label={t("lesson.tryThis")} tone="primary" />
      <h2 className="mt-2 font-display text-lg font-bold text-foreground">
        {t("lesson.exampleHeading")}
      </h2>
      <div className="mt-3 space-y-3 rounded-lg border border-muted/60 bg-surface-raised p-4">
        <SectionKicker icon={<MapPinIcon />} label={t("lesson.realExample")} tone="info" />
        <SplitParagraphs text={String(displayText ?? "")} className="space-y-4" />
      </div>
      {canShowAnother && !showAlternate && (
        <button
          onClick={handleShowAlternate}
          className="mt-4 inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
          aria-label={t("lesson.seeAnotherExample")}
        >
          {t("lesson.seeAnotherExample")}
          <ArrowRightMiniIcon />
        </button>
      )}
      {showAlternate && (
        <button
          onClick={() => setShowAlternate(false)}
          className="mt-4 inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
          aria-label={t("lesson.backToMainExample")}
        >
          {t("lesson.backToMainExample")}
        </button>
      )}
      {commonMistake && (
        <div
          className="mt-4 space-y-3 rounded-md border border-warning/20 p-4 text-foreground"
          style={{ background: "color-mix(in srgb, var(--color-warning) 8%, var(--color-surface))" }}
        >
          <SectionKicker icon={<AlertIcon />} label={t("lesson.commonMistake")} tone="warning" />
          <SplitParagraphs text={commonMistake} className="space-y-3" />
        </div>
      )}
    </article>
  );
}

function QuizStep({
  question,
  onComplete,
  onAnotherQuestion,
  canShowAnotherQuestion,
  requiredChecks,
}: {
  question: ProcessedQuestion | null;
  onComplete: (results: boolean[]) => void;
  onAnotherQuestion?: () => ProcessedQuestion | null;
  canShowAnotherQuestion?: boolean;
  requiredChecks: number;
}) {
  const { t } = useLocale();
  const [results, setResults] = useState<boolean[]>([]);
  const [awaitingNext, setAwaitingNext] = useState(false);
  if (!question) {
    return (
      <div className="space-y-5">
        <div>
          <span className="text-[11px] font-semibold uppercase tracking-[0.14em] text-primary">{t("lesson.quickCheck")}</span>
          <h2 className="mt-1.5 text-[22px] font-bold leading-tight tracking-tight text-foreground">
            {t("lesson.quizHeading")}
          </h2>
        </div>
        <div className="rounded-md border border-warning/30 bg-warning/5 px-4 py-3 text-sm text-warning">
          {t("lesson.noQuestionAvailable")}
        </div>
      </div>
    );
  }

  const seed = question.variantId ?? "legacy";
  const completedChecks = results.filter(Boolean).length;
  const retryingWrongAnswer = results.at(-1) === false;
  const nextActionLabel =
    completedChecks < requiredChecks && retryingWrongAnswer
      ? t("lesson.tryAnotherQuestion")
      : completedChecks < requiredChecks
        ? t("mission.nextCheck")
        : t("lesson.tryAnotherQuestion");

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
        onComplete={(correct) => {
          const nextResults = [...results, correct];
          setResults(nextResults);
          setAwaitingNext(true);
          // Failed checks stay practice-only. The learner must answer a fresh
          // variant correctly before the fixed footer can advance the lesson.
          // The explanation remains visible in QuizEngine while awaiting the
          // next variant.
          if (nextResults.filter(Boolean).length >= requiredChecks) onComplete(nextResults);
        }}
      />

      {awaitingNext && onAnotherQuestion && canShowAnotherQuestion && (
        <button
          onClick={() => {
            if (onAnotherQuestion()) {
              // An optional replay after the required check starts a fresh
              // practice question; a required second check retains its first
              // result for lesson mastery.
              if (results.filter(Boolean).length >= requiredChecks) setResults([]);
              setAwaitingNext(false);
            }
          }}
          className="inline-flex min-h-[44px] items-center gap-1.5 text-sm font-medium text-primary hover:underline"
          aria-label={nextActionLabel}
        >
          {nextActionLabel}
        </button>
      )}
      {awaitingNext && completedChecks < requiredChecks && !canShowAnotherQuestion && (
        <div className="rounded-md border border-warning/30 bg-warning/5 px-4 py-3 text-sm text-warning">
          {t("lesson.noQuestionAvailable")}
        </div>
      )}
    </div>
  );
}

function SourceStep({
  sources,
  quizPassed,
  xpReward,
  alreadyCompleted,
}: {
  sources: LessonSource[];
  quizPassed: boolean;
  xpReward: number;
  alreadyCompleted?: boolean;
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
            <div className="@container grid grid-cols-1 gap-3">
              <h3 className="col-span-full text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">{t("lesson.primarySource")}</h3>
              {primary.map((source) => (
                <SourceCard key={source.id} source={source} highlighted />
              ))}
            </div>
          )}

          {supporting.length > 0 && (
            <div className="@container grid grid-cols-1 gap-3 @[640px]:grid-cols-2">
              <h3 className="col-span-full text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">{t("lesson.supportingSources")}</h3>
              {supporting.map((source) => (
                <SourceCard key={source.id} source={source} />
              ))}
            </div>
          )}

          {furtherReading.length > 0 && (
            <div className="@container grid grid-cols-1 gap-3 @[640px]:grid-cols-2">
              <h3 className="col-span-full text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">{t("lesson.furtherReading")}</h3>
              {furtherReading.map((source) => (
                <SourceCard key={source.id} source={source} />
              ))}
            </div>
          )}
        </div>
      )}

      {quizPassed && (
        <div
          className={`flex items-center gap-3 rounded-lg border px-4 py-3.5 ${
            alreadyCompleted
              ? "border-muted bg-muted/10 text-muted-foreground"
              : "border-success/30 bg-success/5 text-success"
          }`}
        >
          {alreadyCompleted ? <InfoIcon /> : <CheckIcon />}
          <div>
            <p className="font-semibold">{alreadyCompleted ? t("lesson.alreadyEarned") : t("lesson.complete")}</p>
            <p className="text-sm">{alreadyCompleted ? `0 XP` : `+${xpReward} XP`}</p>
          </div>
        </div>
      )}
    </div>
  );
}

function SourceCard({ source, highlighted = false }: { source: LessonSource; highlighted?: boolean }) {
  const { t, locale } = useLocale();
  const localizedUrl = getLocalizedSourceUrl(source, locale);
  const [expanded, setExpanded] = useState(false);
  const verified = source.status === "verified";
  const displayTitle = locale === "id" ? (source.localTitle ?? source.title) : source.title;
  const activeSynopsis = locale === "id" ? (source.synopsisId ?? source.synopsis) : source.synopsis;
  const activeRelevance = locale === "id" ? (source.relevanceBlurbId ?? source.relevanceBlurb) : source.relevanceBlurb;
  const hasDetails = Boolean(activeSynopsis || activeRelevance);
  const blurb = activeSynopsis || activeRelevance;

  if (highlighted) {
    return (
      <article className="relative overflow-hidden rounded-card border border-primary/30 bg-surface p-5 shadow-sm transition-colors hover:border-primary/50">
        <div className="absolute inset-x-0 top-0 h-1 bg-primary" aria-hidden="true" />
        <div className="flex flex-wrap items-center gap-2">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
            <FileTextIcon size={14} />
            {t("lesson.tier")} {source.sourceTier}
          </span>
          <span
            className={`inline-flex items-center gap-1 rounded-full px-2.5 py-1 text-[10px] font-bold uppercase tracking-wide ${
              verified ? "bg-success/10 text-success" : "bg-warning/10 text-warning"
            }`}
          >
            {verified && <CheckIconMini />}
            {verified ? t("lesson.verified") : t("lesson.needsReview")}
          </span>
        </div>
        <h4 className="mt-3 font-display text-lg font-bold text-foreground">{displayTitle}</h4>
        <p className="mt-1 text-sm text-muted-foreground">{source.organization}</p>
        {source.citationLabel && (
          <p className="mt-1 text-xs text-muted-foreground">{source.citationLabel}</p>
        )}
        {blurb && (
          <p className={`mt-3 text-sm leading-relaxed text-foreground ${expanded ? "" : "line-clamp-3"}`}>
            {blurb}
          </p>
        )}
        <div className="mt-3 flex flex-wrap items-center gap-4">
          {localizedUrl && (
            <ReachableLink
              url={localizedUrl}
              title={displayTitle}
              ariaLabel={`${t("lesson.readSource")}: ${displayTitle}`}
              linkClassName="inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
              skipCheck={source.sourceTier === 1}
            >
              {t("lesson.readSource")}
              <ArrowRightMiniIcon />
            </ReachableLink>
          )}
          {hasDetails && (
            <button
              type="button"
              onClick={() => setExpanded((e) => !e)}
              aria-expanded={expanded}
              aria-label={`${expanded ? t("library.showLess") : t("library.readMore")}: ${displayTitle}`}
              className="inline-flex items-center gap-1 rounded-md text-sm font-bold text-primary hover:underline focus:outline-none focus-visible:ring-2 focus-visible:ring-primary"
            >
              {expanded ? t("library.showLess") : t("library.readMore")}
              <ChevronIcon expanded={expanded} />
            </button>
          )}
        </div>
        {expanded && (
          <div className="mt-4 space-y-3 border-t border-muted pt-3">
            {activeSynopsis && (
              <div>
                <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                  {t("library.synopsis")}
                </p>
                <p className="mt-1 text-sm leading-relaxed text-foreground">{activeSynopsis}</p>
              </div>
            )}
            {activeRelevance && (
              <div>
                <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                  {t("library.relevance")}
                </p>
                <p className="mt-1 text-sm leading-relaxed text-foreground">{activeRelevance}</p>
              </div>
            )}
          </div>
        )}
      </article>
    );
  }

  return (
    <article className="rounded-card border border-muted bg-surface p-4 grid grid-cols-[80px_minmax(0,1fr)] gap-4 transition-colors hover:border-primary/30">
      <div className="flex h-20 w-full items-center justify-center rounded-md bg-gradient-to-br from-primary/10 to-surface-raised text-primary">
        <FileTextIcon size={26} />
      </div>
      <div className="grid min-w-0 content-start gap-1.5">
        <div className="flex flex-wrap items-center gap-2">
          <span className="inline-flex items-center gap-1 rounded-full bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-primary">
            {t("lesson.tier")} {source.sourceTier}
          </span>
          <span
            className={`inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${
              verified ? "bg-success/10 text-success" : "bg-warning/10 text-warning"
            }`}
          >
            {verified && <CheckIconMini />}
            {verified ? t("lesson.verified") : t("lesson.needsReview")}
          </span>
          <span className="rounded-full bg-muted px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wide text-muted-foreground">
            {source.sourceCode}
          </span>
        </div>
        <h4 className="font-display text-base font-bold text-foreground">{displayTitle}</h4>
        <p className="text-sm text-muted-foreground">{source.organization}</p>
        {source.citationLabel && (
          <p className="text-xs text-muted-foreground">{source.citationLabel}</p>
        )}
        {blurb && <p className="text-sm text-muted-foreground line-clamp-2">{blurb}</p>}
        <div className="mt-1 flex flex-wrap items-center gap-4">
          {localizedUrl && (
            <ReachableLink
              url={localizedUrl}
              title={displayTitle}
              ariaLabel={`${t("lesson.readSource")}: ${displayTitle}`}
              linkClassName="inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
              skipCheck={source.sourceTier === 1}
            >
              {t("lesson.readSource")}
              <ExternalLinkIcon />
            </ReachableLink>
          )}
          {hasDetails && (
            <button
              type="button"
              onClick={() => setExpanded((e) => !e)}
              aria-expanded={expanded}
              aria-label={`${expanded ? t("library.showLess") : t("library.readMore")}: ${displayTitle}`}
              className="inline-flex items-center gap-1 rounded-md text-sm font-bold text-primary hover:underline focus:outline-none focus-visible:ring-2 focus-visible:ring-primary"
            >
              {expanded ? t("library.showLess") : t("library.readMore")}
              <ChevronIcon expanded={expanded} />
            </button>
          )}
        </div>
      </div>
      {expanded && (
        <div className="col-span-2 mt-2 space-y-3 border-t border-muted pt-3">
          {activeSynopsis && (
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                {t("library.synopsis")}
              </p>
              <p className="mt-1 text-sm leading-relaxed text-foreground">{activeSynopsis}</p>
            </div>
          )}
          {activeRelevance && (
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                {t("library.relevance")}
              </p>
              <p className="mt-1 text-sm leading-relaxed text-foreground">{activeRelevance}</p>
            </div>
          )}
        </div>
      )}
    </article>
  );
}

function ChevronIcon({ expanded }: { expanded: boolean }) {
  return (
    <svg
      className={`h-4 w-4 transition-transform ${expanded ? "rotate-180" : ""}`}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="m6 9 6 6 6-6" />
    </svg>
  );
}

function CheckIconMini() {
  return (
    <svg className="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="m20 6-9 9-5-5" />
    </svg>
  );
}

function ChapterCompletionCelebration({
  milestone,
  onClose,
}: {
  milestone: ChapterCompletionMilestone;
  onClose: () => void;
}) {
  const { t } = useLocale();
  const confetti = Array.from({ length: 22 }, (_, index) => ({
    id: index,
    left: 4 + ((index * 17) % 92),
    delay: (index % 6) * 0.08,
    color: ["bg-primary", "bg-success", "bg-warning", "bg-secondary"][index % 4],
  }));

  return (
    <div
      className="fixed inset-0 z-[var(--z-modal)] flex items-center justify-center bg-foreground/35 p-5 backdrop-blur-sm"
      role="dialog"
      aria-modal="true"
      aria-labelledby="chapter-complete-title"
    >
      <div className="relative w-full max-w-md overflow-hidden rounded-card border border-warning/30 bg-surface p-7 text-center shadow-lift">
        <div aria-hidden="true" className="pointer-events-none absolute inset-x-0 top-0 h-48 overflow-hidden">
          {confetti.map((piece) => (
            <span
              key={piece.id}
              className={`chapter-confetti-piece absolute h-2.5 w-1.5 rounded-sm ${piece.color}`}
              style={{ left: `${piece.left}%`, animationDelay: `${piece.delay}s` }}
            />
          ))}
        </div>
        <div className="relative mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-warning/15 text-warning">
          <CheckIconLarge />
        </div>
        <p className="relative mt-5 text-xs font-bold uppercase tracking-[0.14em] text-warning">{t("lesson.complete")}</p>
        <h2 id="chapter-complete-title" className="relative mt-2 font-display text-3xl font-bold tracking-tight text-foreground">
          {t("lesson.chapterCompleteTitle").replace("{chapterNumber}", String(milestone.chapterNumber).padStart(2, "0"))}
        </h2>
        <p className="relative mt-3 text-sm leading-6 text-muted-foreground">
          {milestone.nextChapterNumber
            ? t("lesson.chapterCompleteBody").replace("{nextChapterNumber}", String(milestone.nextChapterNumber).padStart(2, "0"))
            : t("lesson.chapterCompleteFinalBody")}
        </p>
        <button
          type="button"
          onClick={onClose}
          autoFocus
          className="relative mt-6 inline-flex min-h-11 w-full items-center justify-center rounded-full bg-primary px-5 text-sm font-bold text-primary-foreground transition-colors hover:bg-primary/90 active:scale-[0.98]"
        >
          {t("lesson.chapterCompleteContinue")}
        </button>
      </div>
    </div>
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
    <article
      className="flex w-full flex-col items-center rounded-card border border-success/30 p-6 text-center sm:max-w-2xl lg:max-w-4xl xl:max-w-7xl 2xl:max-w-[1440px]"
      style={{ background: "color-mix(in srgb, var(--color-success) 6%, var(--color-surface))" }}
    >
      <div className="flex h-24 w-24 items-center justify-center rounded-full bg-success/15 text-success">
        <CheckIconLarge />
      </div>
      <span className="mt-5 inline-flex items-center gap-1.5 rounded-full bg-success/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-success">
        {t("lesson.complete")}
      </span>
      {isReplay ? (
        <>
          <h2 className="mt-2 font-display text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
            {t("lesson.replayCompleteTitle")}
          </h2>
          <p className="mt-2 max-w-md text-sm leading-relaxed text-muted-foreground">
            {t("lesson.noNewXp")}
          </p>
        </>
      ) : (
        <h2 className="mt-2 font-display text-[28px] font-bold leading-[1.15] tracking-tight text-foreground">
          +{xpEarned} XP
        </h2>
      )}
      {quizBonus > 0 && (
        <p className="mt-1 text-sm font-semibold text-success">
          {t("lesson.quizBonus").replace("{bonus}", String(quizBonus))}
        </p>
      )}

      <div className="mt-6 grid w-full grid-cols-2 gap-3">
        <StatCard variant="tile" tone="streak" value={`${streakDays}d`} label={t("lesson.streak")} />
        <StatCard
          variant="tile"
          tone={isReplay ? "neutral" : "xp"}
          value={isReplay ? t("lesson.alreadyEarnedValue") : lesson.xpReward}
          label={isReplay ? t("lesson.alreadyEarned") : t("lesson.baseXp")}
        />
      </div>

      {badges.length > 0 && (
        <div className="mt-6 w-full rounded-lg border border-warning/20 bg-warning/5 p-4 text-left">
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
            className="w-full rounded-md bg-primary px-5 py-3.5 text-sm font-semibold text-primary-foreground shadow-sm transition-all hover:bg-primary/90 active:scale-[0.98]"
          >
            {t("lesson.nextLesson")}
          </button>
        )}
        <button
          onClick={() => router.push("/learn")}
          className="w-full rounded-md border border-muted bg-surface px-5 py-3.5 text-sm font-semibold text-foreground transition-all hover:bg-muted/20 active:scale-[0.98]"
        >
          {t("lesson.backToLearn")}
        </button>
      </div>
    </article>
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

function BookIcon({ className = "h-3.5 w-3.5" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z" />
      <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z" />
    </svg>
  );
}

function LessonIcon({ className = "h-14 w-14 text-primary" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 36h24" />
      <path d="M14 12h20a2 2 0 0 1 2 2v20a2 2 0 0 1-2 2H14a2 2 0 0 1-2-2V14a2 2 0 0 1 2-2z" />
      <path d="M18 20h12" />
      <path d="M18 28h8" />
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

function FileTextIcon({ size = 24 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
      <path d="M14 2v4a2 2 0 0 0 2 2h4" />
      <path d="M10 9H8" />
      <path d="M16 13H8" />
      <path d="M16 17H8" />
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

function InfoIcon() {
  return (
    <svg className="h-6 w-6 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" />
      <path d="M12 16v-4" />
      <path d="M12 8h.01" />
    </svg>
  );
}

function ArrowRightMiniIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  );
}

function CheckIconLarge() {
  return (
    <svg className="h-10 w-10 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" />
      <path d="m9 12 2 2 4-4" />
    </svg>
  );
}

function LightbulbIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M9 18h6" />
      <path d="M10 22h4" />
      <path d="M12 2a7 7 0 0 0-7 7c0 2.5 1.5 4.5 3 6v2h8v-2c1.5-1.5 3-3.5 3-6a7 7 0 0 0-7-7z" />
    </svg>
  );
}

function HeartIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z" />
    </svg>
  );
}

function MapPinIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z" />
      <circle cx="12" cy="10" r="3" />
    </svg>
  );
}

function AlertIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z" />
      <path d="M12 9v4" />
      <path d="M12 17h.01" />
    </svg>
  );
}

function TargetIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" />
      <circle cx="12" cy="12" r="6" />
      <circle cx="12" cy="12" r="2" />
    </svg>
  );
}
