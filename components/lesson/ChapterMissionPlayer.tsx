"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useAuth } from "@/lib/auth/use-auth";
import {
  completeChapterMission,
  getAllLessons,
  getLessonProgress,
  getLessonVariants,
  seededShuffle,
  type ContentVariant,
} from "@/lib/lessons/client";
import { curriculumChapterNumber } from "@/lib/lessons/curriculum";
import {
  CHAPTER_MISSION_QUESTION_COUNT,
  isChapterMissionPassed,
  requiresChapterMission,
} from "@/lib/lessons/mastery";
import { applyParameters, validateQuestion, type ProcessedQuestion } from "@/lib/lessons/question";
import { QuizEngine } from "@/components/lesson/QuizEngine";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { trackEvent } from "@/lib/analytics/client";

interface MissionQuestion {
  question: ProcessedQuestion;
  lessonId: string;
}

interface MissionAnswer {
  correct: boolean;
  variantId: string;
  response: string | boolean;
}

function chapterMissionSeed(userId: string, chapterNumber: number, retry: number): string {
  return `${userId}:chapter-mission:${chapterNumber}:${retry}`;
}

function selectMissionQuestions(
  variants: Array<{ lessonId: string; variant: ContentVariant }>,
  seed: string
): MissionQuestion[] {
  const selected: MissionQuestion[] = [];
  for (const [index, { lessonId, variant }] of seededShuffle(seed, variants).entries()) {
    // The mission RPC deliberately scores only native multiple-choice and
    // true/false rows (`body.type`). `validateQuestion` also normalizes legacy
    // mechanics such as scenario/comparison into multiple-choice, so checking
    // the raw payload first keeps the browser's selection contract identical
    // to the server's eligibility query.
    if (!['multiple_choice', 'true_false'].includes(String(variant.body.type))) continue;
    const validated = validateQuestion(variant.body);
    if (!validated || !["multiple_choice", "true_false"].includes(validated.type)) continue;
    selected.push({
      lessonId,
      question: {
        ...applyParameters(`${seed}:${index}`, validated),
        variantId: variant.id,
      } as ProcessedQuestion,
    });
    if (selected.length === CHAPTER_MISSION_QUESTION_COUNT) break;
  }
  return selected;
}

export function ChapterMissionPlayer({ chapterNumber }: { chapterNumber: number }) {
  const { user } = useAuth(true);
  const { t, locale } = useLocale();
  const [questions, setQuestions] = useState<MissionQuestion[]>([]);
  const [index, setIndex] = useState(0);
  const [results, setResults] = useState<MissionAnswer[]>([]);
  const [retry, setRetry] = useState(0);
  const [state, setState] = useState<"loading" | "ready" | "locked" | "error" | "submitting" | "passed" | "retry">("loading");

  const current = questions[index] ?? null;
  useEffect(() => {
    let mounted = true;
    const load = async () => {
      if (!user || !requiresChapterMission(chapterNumber)) {
        if (mounted) setState("locked");
        return;
      }
      setState("loading");
      setIndex(0);
      setResults([]);

      const [lessons, progress] = await Promise.all([getAllLessons(), getLessonProgress(user.id)]);
      const chapterLessons = lessons.filter(
        (lesson) => curriculumChapterNumber(lesson.chapter ?? null) === chapterNumber
      );
      if (
        chapterLessons.length === 0 ||
        chapterLessons.some((lesson) => progress?.[lesson.id] !== "completed")
      ) {
        if (mounted) setState("locked");
        return;
      }

      const questionSets = await Promise.all(
        chapterLessons.map(async (lesson) => ({
          lessonId: lesson.id,
          variants: await getLessonVariants(lesson.id, "question", null, locale),
        }))
      );
      const selected = selectMissionQuestions(
        questionSets.flatMap(({ lessonId, variants }) => variants.map((variant) => ({ lessonId, variant }))),
        chapterMissionSeed(user.id, chapterNumber, retry)
      );

      if (!mounted) return;
      if (selected.length < CHAPTER_MISSION_QUESTION_COUNT) {
        setState("error");
        return;
      }
      setQuestions(selected);
      setState("ready");
    };

    load();
    return () => {
      mounted = false;
    };
  }, [chapterNumber, locale, retry, user]);

  const submit = async (nextResults: MissionAnswer[]) => {
    if (!user) return;
    setState("submitting");
    const result = await completeChapterMission({
      chapterNumber,
      answers: nextResults.map(({ variantId, response }) => ({ variantId, response })),
    });
    if (!result) {
      setState("error");
      return;
    }
    trackEvent({
      userId: user.id,
      name: "chapter_mission_completed",
      properties: { chapter_number: chapterNumber, score: result.score, max_score: questions.length, passed: result.passed },
    });
    setState(isChapterMissionPassed(result.score, questions.length) && result.passed ? "passed" : "retry");
  };

  const handleComplete = (correct: boolean, response?: string | boolean) => {
    const variantId = current?.question.variantId;
    if (!variantId || response === undefined) return;
    const nextResults = [...results, { correct, variantId, response }];
    setResults(nextResults);
  };

  const answeredCurrent = results.length > index;
  const isLast = index === questions.length - 1;

  if (state === "loading" || state === "submitting") {
    return <main className="mx-auto flex min-h-[60vh] max-w-xl items-center justify-center p-6 text-sm text-muted-foreground">{t("lesson.loading")}</main>;
  }

  if (state === "locked") {
    return <MissionShell><p className="text-sm text-muted-foreground">{t("mission.locked")}</p><BackToLearn /></MissionShell>;
  }

  if (state === "error") {
    return <MissionShell><p className="text-sm text-danger">{t("mission.loadError")}</p><button onClick={() => setRetry((value) => value + 1)} className="mt-5 min-h-[44px] rounded-md bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground">{t("lesson.tryAgain")}</button><BackToLearn /></MissionShell>;
  }

  if (state === "passed") {
    return (
      <MissionShell celebration>
        <p className="text-[11px] font-bold uppercase tracking-[0.14em] text-success">{t("mission.kicker")}</p>
        <h1 className="mt-2 font-display text-3xl font-bold text-foreground">{t("mission.passTitle").replace("{chapterNumber}", String(chapterNumber).padStart(2, "0"))}</h1>
        <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{t("mission.passBody")}</p>
        <BackToLearn primary />
      </MissionShell>
    );
  }

  if (state === "retry") {
    return (
      <MissionShell>
        <p className="text-[11px] font-bold uppercase tracking-[0.14em] text-warning">{t("mission.kicker")}</p>
        <h1 className="mt-2 font-display text-3xl font-bold text-foreground">{t("mission.retryTitle")}</h1>
        <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{t("mission.retryBody")}</p>
        <button onClick={() => setRetry((value) => value + 1)} className="mt-6 min-h-[44px] rounded-md bg-primary px-5 py-3 text-sm font-semibold text-primary-foreground">{t("mission.retry")}</button>
        <BackToLearn />
      </MissionShell>
    );
  }

  return (
    <MissionShell>
      <p className="text-[11px] font-bold uppercase tracking-[0.14em] text-warning">{t("mission.kicker")}</p>
      <h1 className="mt-2 font-display text-3xl font-bold text-foreground">{t("mission.title")}</h1>
      <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{t("mission.body")}</p>
      <p className="mt-6 text-xs font-semibold uppercase tracking-[0.12em] text-muted-foreground">
        {t("mission.checkProgress")
          .replace("{current}", String(index + 1))
          .replace("{total}", String(questions.length))}
      </p>
      {current && <div className="mt-3"><QuizEngine key={current.question.variantId} question={current.question} seed={current.question.variantId ?? String(index)} onAnswer={handleComplete} /></div>}
      {answeredCurrent && (
        <button
          onClick={() => (isLast ? submit(results) : setIndex((value) => value + 1))}
          className="mt-5 min-h-[44px] w-full rounded-md bg-primary px-5 py-3 text-sm font-semibold text-primary-foreground"
        >
          {isLast ? t("lesson.finish") : t("mission.nextCheck")}
        </button>
      )}
    </MissionShell>
  );
}

function MissionShell({ children, celebration = false }: { children: React.ReactNode; celebration?: boolean }) {
  return (
    <main className="mx-auto flex min-h-[calc(100vh-7rem)] w-full max-w-xl items-center px-5 py-10">
      {celebration && (
        <div aria-hidden>
          {Array.from({ length: 18 }, (_, index) => (
            <span
              key={index}
              className={`chapter-confetti-piece fixed z-10 h-2 w-1.5 rounded-sm ${["bg-primary", "bg-success", "bg-warning", "bg-secondary"][index % 4]}`}
              style={{
                left: `${8 + ((index * 17) % 84)}%`,
                animationDelay: `${(index % 6) * 55}ms`,
                animationDuration: `${900 + (index % 5) * 95}ms`,
              }}
            />
          ))}
        </div>
      )}
      <section className="w-full rounded-card border border-muted bg-surface p-6 shadow-sm">{children}</section>
    </main>
  );
}

function BackToLearn({ primary = false }: { primary?: boolean }) {
  const { t } = useLocale();
  return <Link href="/learn" className={`mt-5 inline-flex min-h-[44px] items-center rounded-md px-4 py-2.5 text-sm font-semibold ${primary ? "bg-primary text-primary-foreground" : "text-primary hover:underline"}`}>{t("mission.backToLearn")}</Link>;
}
