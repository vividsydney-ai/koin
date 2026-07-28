import { supabase } from "@/lib/auth/client";
import type { Locale } from "@/lib/i18n/types";
import type { LessonStatus } from "./gating";
import type { QuizQuestion } from "./question";
import { orderCurriculumLessons, curriculumChapterNumber } from "./curriculum";
import { requiresChapterMission } from "./mastery";
import { completeChapterMissionSchema } from "@/lib/schemas/lessons";

/**
 * Fallback chapter mapping by topic slug. Once the `topics.chapter` column is
 * applied, the database value takes precedence; this map keeps the UI working
 * if the column is missing or a topic has not been assigned yet.
 */
const TOPIC_SLUG_TO_CHAPTER: Record<string, string> = {
  foundation_zero: "Foundation",
  money_basics: "Money Basics",
  value_purchasing_power: "Money Basics",
  inflation: "Money Basics",
  income_wealth: "Money Basics",
  assets_liabilities: "Money Basics",
  risk_basics: "Money Basics",
  time_value_money: "Money Basics",

  budgeting: "Money Life Skills",
  saving_habits: "Money Life Skills",
  spending_behavior: "Money Life Skills",
  behavioral_finance: "Money Life Skills",

  scam_defense: "Protect Yourself",
  ojk_license_check: "Protect Yourself",
  phishing_social_engineering: "Protect Yourself",
  mlm_pyramid: "Protect Yourself",

  debt_management: "Let's Talk About Debt",

  emergency_fund: "Plan Your Money",
  goal_setting: "Plan Your Money",
  financial_planning: "Plan Your Money",

  interest: "Grow Your Money",
  compound_interest: "Grow Your Money",
  bank_vs_investment: "Grow Your Money",
  risk_return: "Grow Your Money",
  diversification: "Grow Your Money",
  reksa_dana: "Grow Your Money",

  stocks: "Investing in Indonesia",
  idx_basics: "Investing in Indonesia",
  stock_analysis: "Investing in Indonesia",
  portfolio: "Investing in Indonesia",
  taxes: "Investing in Indonesia",
  macro_indicators: "Investing in Indonesia",

  cryptocurrency: "Cryptocurrency 101",
};

export interface Lesson {
  id: string;
  slug: string;
  title: string;
  titleId: string;
  lessonNumber: number;
  chapter?: string | null;
  difficulty: string;
  xpReward: number;
  estimatedMinutes: number;
  summary: string;
  summaryId: string | null;
  conceptBody: string;
  conceptBodyId: string | null;
  indonesianExample: string;
  whyThisMatters: string;
  whyThisMattersId: string | null;
  commonMistake: string;
  commonMistakeId: string | null;
  quizData: QuizQuestion[];
  quizDataId: QuizQuestion[] | null;
}

export interface ContentVariant {
  id: string;
  variantType: "explanation" | "example" | "question";
  body: Record<string, unknown>;
  bodyId?: Record<string, unknown> | null;
  difficulty: string | null;
  topicTag: string | null;
}

export type { QuizQuestion };

const INDONESIAN_LOCALE_MARKERS = new Set(
  "yang dan dengan untuk dari ini itu adalah akan bisa tidak pada atau dalam sebagai karena kamu kami mereka saham uang keuangan investasi risiko pengeluaran tabungan pemasukan kebutuhan keinginan memiliki menjadi mendapatkan digunakan sebuah dapat agar oleh saat juga lebih sudah belum tanpa setiap terhadap antara melalui supaya sehingga jika maka ketika bunga modal pokok suku waktu dihitung rumusnya awal menabung berhutang utang imbalan besarnya tergantung jumlah pertumbuhan sederhana selama tahun berapa meminjam menguntungkan pembayar pinjaman per satu".split(
    " "
  )
);
const ENGLISH_LOCALE_MARKERS = new Set(
  "the and with for from this that is are will can not on or in as because you we they stock money financial investment risk spending savings income needs wants have has become get used to when also more without every through between if then interest principal rate time calculated calculation original amount savings borrowing debt reward depends growth".split(
    " "
  )
);

function flattenVariantText(value: unknown, output: string[] = []): string[] {
  if (typeof value === "string") output.push(value);
  else if (Array.isArray(value)) value.forEach((item) => flattenVariantText(item, output));
  else if (value && typeof value === "object") {
    Object.values(value).forEach((item) => flattenVariantText(item, output));
  }
  return output;
}

/** Hide high-confidence ID-only legacy variants from English learners until KO-225 translations land. */
export function isLikelyIndonesianOnlyVariant(body: Record<string, unknown>): boolean {
  const words = flattenVariantText(body)
    .join(" ")
    .toLowerCase()
    .match(/[a-zà-ÿ]+/g);
  if (!words || words.length < 3) return false;
  const idCount = words.filter((word) => INDONESIAN_LOCALE_MARKERS.has(word)).length;
  const enCount = words.filter((word) => ENGLISH_LOCALE_MARKERS.has(word)).length;
  return idCount >= 2 && idCount > enCount * 1.5;
}

/** Hide high-confidence English-only legacy variants from Indonesian learners. */
export function isLikelyEnglishOnlyVariant(body: Record<string, unknown>): boolean {
  const words = flattenVariantText(body)
    .join(" ")
    .toLowerCase()
    .match(/[a-zà-ÿ]+/g);
  if (!words || words.length < 3) return false;
  const idCount = words.filter((word) => INDONESIAN_LOCALE_MARKERS.has(word)).length;
  const enCount = words.filter((word) => ENGLISH_LOCALE_MARKERS.has(word)).length;
  return enCount >= 2 && enCount > idCount * 1.5;
}

/**
 * A small batch of legacy rows was duplicated into both locale columns. When
 * the two payloads are identical, treat a high-confidence Indonesian payload
 * as Indonesian-only so English retries cannot surface it.
 */
function isDuplicatedIndonesianVariant(variant: ContentVariant): boolean {
  const markerCount = flattenVariantText(variant.body)
    .join(" ")
    .toLowerCase()
    .match(/[a-zà-ÿ]+/g)
    ?.filter((word) => INDONESIAN_LOCALE_MARKERS.has(word)).length ?? 0;
  return Boolean(
    variant.bodyId &&
      JSON.stringify(variant.body) === JSON.stringify(variant.bodyId) &&
      (isLikelyIndonesianOnlyVariant(variant.body) || markerCount >= 2)
  );
}

export interface LessonSource {
  id: string;
  sourceCode: string;
  title: string;
  localTitle: string | null;
  organization: string;
  url: string;
  sourceTier: number;
  citationLabel: string | null;
  isPrimary: boolean;
  relevanceType: "primary" | "supporting" | "further_reading";
  status: "verified" | "needs_review" | string;
  synopsis: string | null;
  synopsisId: string | null;
  relevanceBlurb: string | null;
  relevanceBlurbId: string | null;
}

export async function getLessonBySlug(slug: string): Promise<Lesson | null> {
  const { data, error } = await supabase
    .from("lessons")
    .select(
      "id, slug, title, title_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, summary_id, concept_body, concept_body_id, indonesian_example, why_this_matters, why_this_matters_id, common_mistake, common_mistake_id, quiz_data, quiz_data_id"
    )
    .eq("slug", slug)
    .maybeSingle();

  if (error || !data) {
    console.error("getLessonBySlug error:", error?.message);
    return null;
  }

  return {
    id: data.id,
    slug: data.slug,
    title: data.title,
    titleId: data.title_id,
    lessonNumber: data.lesson_number,
    difficulty: data.difficulty,
    xpReward: data.xp_reward,
    estimatedMinutes: data.estimated_minutes,
    summary: data.summary,
    summaryId: data.summary_id,
    conceptBody: data.concept_body,
    conceptBodyId: data.concept_body_id,
    indonesianExample: data.indonesian_example,
    whyThisMatters: data.why_this_matters,
    whyThisMattersId: data.why_this_matters_id,
    commonMistake: data.common_mistake,
    commonMistakeId: data.common_mistake_id,
    quizData: (data.quiz_data as QuizQuestion[]) ?? [],
    quizDataId: (data.quiz_data_id as QuizQuestion[] | null) ?? null,
  };
}

export async function getLessonVariants(
  lessonId: string,
  variantType?: ContentVariant["variantType"],
  preferredDifficulty?: string | null,
  locale?: Locale
): Promise<ContentVariant[]> {
  let query = supabase
    .from("content_variants")
    .select("id, variant_type, body, body_id, difficulty, topic_tag")
    .eq("lesson_id", lessonId)
    .eq("is_active", true);

  if (variantType) {
    query = query.eq("variant_type", variantType);
  }

  const { data, error } = await query;

  if (error) {
    console.error("getLessonVariants error:", error.message);
    return [];
  }

  const variants =
    data?.map((v) => {
      const bodyId = (v.body_id as Record<string, unknown> | null) ?? null;
      const localizedBody =
        locale === "id" && bodyId ? bodyId : (v.body as Record<string, unknown>) ?? {};
      return {
        id: v.id,
        variantType: v.variant_type as ContentVariant["variantType"],
        body: localizedBody,
        bodyId,
        difficulty: v.difficulty,
        topicTag: v.topic_tag,
      };
    }) ?? [];

  const localeSafeVariants =
    locale === "id"
      ? variants.filter((variant) => !isLikelyEnglishOnlyVariant(variant.body))
      : variants.filter(
          (variant) =>
            !isLikelyIndonesianOnlyVariant(variant.body) &&
            !isDuplicatedIndonesianVariant(variant)
        );

  if (preferredDifficulty) {
    const filtered = localeSafeVariants.filter(
      (v) => v.difficulty === preferredDifficulty || v.difficulty == null
    );
    if (filtered.length > 0) {
      return filtered;
    }

    // Fallback: prefer the next lower difficulty, then step up. This keeps
    // content accessible without jumping the user ahead of their level.
    const difficultyOrder = ["beginner", "intermediate", "advanced"] as const;
    const preferredIndex = difficultyOrder.indexOf(
      preferredDifficulty as (typeof difficultyOrder)[number]
    );

    if (preferredIndex !== -1) {
      const lowerFirst = [
        ...difficultyOrder.slice(0, preferredIndex).reverse(),
        ...difficultyOrder.slice(preferredIndex + 1),
      ];

      for (const difficulty of lowerFirst) {
        const fallback = localeSafeVariants.filter((v) => v.difficulty === difficulty);
        if (fallback.length > 0) {
          return fallback;
        }
      }
    }
  }

  return localeSafeVariants;
}

export async function getLessonSources(lessonId: string): Promise<LessonSource[]> {
  const { data, error } = await supabase
    .from("lesson_sources")
    .select(
      "source_id, citation_label, is_primary, relevance_type, sources(source_code, title, local_title, organization, url, source_tier, status, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)"
    )
    .eq("lesson_id", lessonId)
    .order("display_order", { ascending: true });

  if (error) {
    console.error("getLessonSources error:", error.message);
    return [];
  }

  return (
    data
      ?.map((row: Record<string, unknown>) => {
        const source = row.sources as Record<string, unknown> | undefined;
        if (!source) return null;
        return {
          id: String(row.source_id ?? ""),
          sourceCode: String(source.source_code ?? ""),
          title: String(source.title ?? ""),
          localTitle: source.local_title === null || source.local_title === undefined ? null : String(source.local_title),
          organization: String(source.organization ?? ""),
          url: String(source.url ?? ""),
          sourceTier: Number(source.source_tier ?? 0),
          citationLabel: row.citation_label === null || row.citation_label === undefined ? null : String(row.citation_label),
          isPrimary: Boolean(row.is_primary ?? false),
          relevanceType: (row.relevance_type ?? "supporting") as LessonSource["relevanceType"],
          status: (source.status ?? "needs_review") as LessonSource["status"],
          synopsis: source.synopsis === null || source.synopsis === undefined ? null : String(source.synopsis),
          synopsisId: source.synopsis_id === null || source.synopsis_id === undefined ? null : String(source.synopsis_id),
          relevanceBlurb: source.relevance_blurb === null || source.relevance_blurb === undefined ? null : String(source.relevance_blurb),
          relevanceBlurbId: source.relevance_blurb_id === null || source.relevance_blurb_id === undefined ? null : String(source.relevance_blurb_id),
        };
      })
      .filter(Boolean) as LessonSource[]
  );
}

export async function getAllLessons(): Promise<
  Pick<Lesson, "id" | "slug" | "title" | "titleId" | "lessonNumber" | "chapter" | "difficulty" | "xpReward" | "estimatedMinutes" | "summary" | "summaryId">[]
> {
  const { data, error } = await supabase
    .from("lessons")
    .select("id, slug, title, title_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, summary_id, topics(chapter)")
    .eq("is_published", true)
    .order("lesson_number", { ascending: true });

  if (error) {
    console.error("getAllLessons error:", error.message);
    return [];
  }

  const lessons = data?.map((l) => {
    const topic = Array.isArray(l.topics) ? l.topics[0] : l.topics;
    return {
      id: l.id,
      slug: l.slug,
      title: l.title,
      titleId: l.title_id ?? null,
      lessonNumber: l.lesson_number,
      chapter: topic?.chapter?.trim() || null,
      difficulty: l.difficulty,
      xpReward: l.xp_reward,
      estimatedMinutes: l.estimated_minutes,
      summary: l.summary,
      summaryId: l.summary_id ?? null,
    };
  }) ?? [];

  return orderCurriculumLessons(lessons);
}

export interface ChapterCompletionMilestone {
  chapterNumber: number;
  nextChapterNumber: number | null;
}

export async function getChapterCompletionMilestone(
  userId: string,
  completedLessonId: string
): Promise<ChapterCompletionMilestone | null> {
  const [lessons, progress] = await Promise.all([getAllLessons(), getLessonProgress(userId)]);
  const completedLesson = lessons.find((lesson) => lesson.id === completedLessonId);
  const chapterNumber = curriculumChapterNumber(completedLesson?.chapter ?? null);
  if (!completedLesson || !chapterNumber || !progress) return null;

  const chapterLessons = lessons.filter((lesson) => lesson.chapter === completedLesson.chapter);
  const isChapterComplete = chapterLessons.length > 0 && chapterLessons.every(
    (lesson) => progress[lesson.id] === "completed"
  );
  if (!isChapterComplete) return null;

  // The milestone for Chapters 07–09 belongs to the successfully completed
  // Money Mission, not merely reaching its last lesson.
  if (requiresChapterMission(chapterNumber)) {
    const passedMissions = await getPassedChapterMissions(userId);
    if (!passedMissions.has(chapterNumber)) return null;
  }

  const nextChapterNumber = curriculumChapterNumber(
    lessons.find((lesson) => curriculumChapterNumber(lesson.chapter ?? null) === chapterNumber + 1)?.chapter ?? null
  );

  return { chapterNumber, nextChapterNumber };
}

export async function getPassedChapterMissions(userId: string): Promise<Set<number>> {
  const { data, error } = await supabase
    .from("chapter_mission_attempts")
    .select("chapter_number")
    .eq("user_id", userId)
    .eq("passed", true);

  if (error) {
    // The app remains usable before the migration reaches an environment; the
    // Learn page will simply keep later chapters unavailable until it does.
    console.error("getPassedChapterMissions error:", error.message);
    return new Set();
  }

  return new Set((data ?? []).map((row) => Number(row.chapter_number)));
}

export interface ChapterMissionCompletion {
  attemptNumber: number;
  passed: boolean;
  score: number;
  maxScore: number;
}

export async function completeChapterMission(
  input: {
    chapterNumber: number;
    answers: Array<{ variantId: string; response: string | boolean }>;
  }
): Promise<ChapterMissionCompletion | null> {
  const parsed = completeChapterMissionSchema.safeParse(input);
  if (!parsed.success) {
    console.error("completeChapterMission validation error:", parsed.error.issues[0]?.message);
    return null;
  }

  const { data, error } = await supabase.rpc("complete_chapter_mission", {
    p_chapter_number: parsed.data.chapterNumber,
    p_answers: parsed.data.answers.map((answer) => ({
      variant_id: answer.variantId,
      response: answer.response,
    })),
  });

  if (error || !data) {
    console.error("completeChapterMission error:", error?.message);
    return null;
  }

  const result = data as Record<string, unknown>;
  return {
    attemptNumber: Number(result.attempt_number ?? 0),
    passed: Boolean(result.passed),
    score: Number(result.score ?? 0),
    maxScore: Number(result.max_score ?? parsed.data.answers.length),
  };
}

export { seededIndex, seededShuffle } from "./random";

/**
 * Return the user's progress status for a single lesson, or null when there is
 * no progress row yet (lesson never attempted).
 */
export async function getLessonStatus(
  userId: string,
  lessonId: string
): Promise<LessonStatus | null> {
  const { data, error } = await supabase
    .from("lesson_progress")
    .select("status")
    .eq("user_id", userId)
    .eq("lesson_id", lessonId)
    .maybeSingle();

  if (error) {
    console.error("getLessonStatus error:", error.message);
    return null;
  }

  return (data?.status as LessonStatus | undefined) ?? null;
}

interface AttemptAnswer {
  variant_id?: string;
}

export async function getLessonProgress(
  userId: string
): Promise<Record<string, "locked" | "available" | "in_progress" | "completed"> | null> {
  const { data, error } = await supabase
    .from("lesson_progress")
    .select("lesson_id, status")
    .eq("user_id", userId);

  if (error) {
    console.error("getLessonProgress error:", error.message);
    return null;
  }

  const map: Record<string, "locked" | "available" | "in_progress" | "completed"> = {};
  for (const row of data ?? []) {
    map[row.lesson_id] = row.status as "locked" | "available" | "in_progress" | "completed";
  }
  return map;
}

export async function ensureLessonProgressAvailable(
  userId: string,
  lessonIds: string[]
): Promise<void> {
  if (lessonIds.length === 0) return;

  const { data: existing } = await supabase
    .from("lesson_progress")
    .select("lesson_id, status")
    .eq("user_id", userId)
    .in("lesson_id", lessonIds);

  const existingById = new Map(
    (existing ?? []).map((row) => [row.lesson_id, row.status])
  );
  const lockedIds = lessonIds.filter(
    (id) => existingById.get(id) === "locked"
  );
  const missingIds = lessonIds.filter((id) => !existingById.has(id));

  if (lockedIds.length > 0) {
    const { error: updateError } = await supabase
      .from("lesson_progress")
      .update({ status: "available" })
      .eq("user_id", userId)
      .in("lesson_id", lockedIds);

    if (updateError) {
      console.error("ensureLessonProgressAvailable update error:", updateError.message);
    }
  }

  if (missingIds.length === 0) return;

  const rows = missingIds.map((lessonId) => ({
    user_id: userId,
    lesson_id: lessonId,
    status: "available" as const,
  }));

  const { error } = await supabase.from("lesson_progress").upsert(rows, {
    onConflict: "user_id,lesson_id",
    ignoreDuplicates: true,
  });

  if (error) {
    console.error("ensureLessonProgressAvailable insert error:", error.message);
  }
}

export interface RecentAttemptInfo {
  ids: Set<string>;
  lastVariantId: string | null;
}

export async function getRecentAttemptVariantIds(
  userId: string,
  lessonId: string,
  days = 7
): Promise<RecentAttemptInfo> {
  const since = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString();

  const { data, error } = await supabase
    .from("lesson_attempts")
    .select("answers_json, created_at")
    .eq("user_id", userId)
    .eq("lesson_id", lessonId)
    .gte("created_at", since)
    .order("created_at", { ascending: false });

  if (error || !data) {
    console.error("getRecentAttemptVariantIds error:", error?.message);
    return { ids: new Set(), lastVariantId: null };
  }

  const ids = new Set<string>();
  let lastVariantId: string | null = null;
  for (const row of data) {
    // Defensive: legacy rows may store answers_json as an object instead of an
    // array. Iterating a non-array would throw and leave the lesson player
    // stuck on its loading screen (see KO-REPLAY-001).
    const answers = Array.isArray(row.answers_json) ? (row.answers_json as AttemptAnswer[]) : [];
    for (const answer of answers) {
      if (answer?.variant_id) {
        ids.add(answer.variant_id);
        if (lastVariantId === null) {
          lastVariantId = answer.variant_id;
        }
      }
    }
  }
  return { ids, lastVariantId };
}

export interface ChapterLesson {
  id: string;
  slug: string;
  title: string;
  titleId: string | null;
  lessonNumber: number;
  difficulty: string;
  xpReward: number;
  estimatedMinutes: number;
  summary: string;
  summaryId: string | null;
}

export interface ChapterTopic {
  id: string;
  slug: string;
  name: string;
  displayOrder: number | null;
  lessons: ChapterLesson[];
}

export interface Chapter {
  title: string;
  displayOrder: number;
  topics: ChapterTopic[];
  lessonCount: number;
  completedCount: number;
}

const CHAPTER_ORDER = [
  "Foundation",
  "Money Basics",
  "Money Life Skills",
  "Protect Yourself",
  "Let's Talk About Debt",
  "Plan Your Money",
  "Grow Your Money",
  "Investing in Indonesia",
  "Cryptocurrency 101",
];

function chapterDisplayOrder(title: string): number {
  const index = CHAPTER_ORDER.indexOf(title);
  return index === -1 ? Number.MAX_SAFE_INTEGER : index;
}

function lessonDisplayOrder(lesson: { lesson_number: number }): number {
  return lesson.lesson_number;
}

/**
 * Fetch all topics grouped by chapter, including their lessons and optional
 * completion counts. Topics and lessons are ordered by their existing display
 * fields so the curriculum flow is preserved.
 *
 * If the `topics.chapter` column is not available yet, the function falls back
 * to the static `TOPIC_SLUG_TO_CHAPTER` map so the UI keeps working.
 */
interface TopicWithLessonsRow {
  id: string;
  slug: string;
  name: string;
  name_id: string;
  icon: string | null;
  color: string | null;
  display_order: number | null;
  chapter?: string | null;
  lessons: {
    id: string;
    slug: string;
    title: string;
    title_id: string | null;
    lesson_number: number;
    difficulty: string;
    xp_reward: number;
    estimated_minutes: number;
    summary: string;
    summary_id: string | null;
    is_published: boolean;
  }[];
}

export async function getTopicsWithChapters(
  progressMap?: Record<string, LessonStatus> | null
): Promise<Chapter[]> {
  let data: TopicWithLessonsRow[] | null = null;
  let error: Error | null = null;
  let useFallback = false;

  const primary = await supabase
    .from("topics")
    .select(
      "id, slug, name, name_id, icon, color, display_order, chapter, lessons(id, slug, title, title_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, summary_id, is_published)"
    )
    .order("display_order", { ascending: true })
    .order("lesson_number", { referencedTable: "lessons", ascending: true });

  data = primary.data as TopicWithLessonsRow[] | null;
  error = primary.error;

  if (error && /column.*chapter|chapter.*column|chapter.*does not exist/i.test(error.message)) {
    useFallback = true;
    const fallback = await supabase
      .from("topics")
      .select(
        "id, slug, name, name_id, icon, color, display_order, lessons(id, slug, title, title_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, summary_id, is_published)"
      )
      .order("display_order", { ascending: true })
      .order("lesson_number", { referencedTable: "lessons", ascending: true });
    data = fallback.data as TopicWithLessonsRow[] | null;
    error = fallback.error;
  }

  if (error) {
    console.error("getTopicsWithChapters error:", error.message);
    return [];
  }

  const chaptersMap = new Map<string, Chapter>();

  for (const topic of data ?? []) {
    const lessons = (topic.lessons ?? [])
      .filter((l) => l.is_published !== false)
      .sort((a, b) => lessonDisplayOrder(a) - lessonDisplayOrder(b))
      .map((l) => ({
        id: l.id,
        slug: l.slug,
        title: l.title,
        titleId: l.title_id ?? null,
        lessonNumber: l.lesson_number,
        difficulty: l.difficulty,
        xpReward: l.xp_reward,
        estimatedMinutes: l.estimated_minutes,
        summary: l.summary,
        summaryId: l.summary_id ?? null,
      }));

    const chapterTitle =
      topic.chapter?.trim() ||
      (useFallback ? TOPIC_SLUG_TO_CHAPTER[topic.slug] : undefined) ||
      "Uncategorized";

    if (!chaptersMap.has(chapterTitle)) {
      chaptersMap.set(chapterTitle, {
        title: chapterTitle,
        displayOrder: chapterDisplayOrder(chapterTitle),
        topics: [],
        lessonCount: 0,
        completedCount: 0,
      });
    }

    const chapter = chaptersMap.get(chapterTitle)!;
    chapter.topics.push({
      id: topic.id,
      slug: topic.slug,
      name: topic.name,
      displayOrder: topic.display_order,
      lessons,
    });

    chapter.lessonCount += lessons.length;
    for (const lesson of lessons) {
      if (progressMap?.[lesson.id] === "completed") {
        chapter.completedCount += 1;
      }
    }
  }

  const chapters = Array.from(chaptersMap.values()).sort((a, b) => {
    if (a.displayOrder !== b.displayOrder) {
      return a.displayOrder - b.displayOrder;
    }
    return a.title.localeCompare(b.title);
  });

  for (const chapter of chapters) {
    chapter.topics.sort((a, b) => (a.displayOrder ?? Infinity) - (b.displayOrder ?? Infinity));
  }

  return chapters;
}

/**
 * Find the chapter that contains a given lesson. Used by the Learn page to
 * expand the user's current chapter by default.
 */
export function findChapterForLesson(chapters: Chapter[], lessonId: string): Chapter | undefined {
  return chapters.find((chapter) =>
    chapter.topics.some((topic) => topic.lessons.some((lesson) => lesson.id === lessonId))
  );
}

/**
 * Return the chapter title for a given lesson. Useful for breadcrumbs and
 * player headers without loading the full curriculum.
 *
 * Falls back to the static slug map if `topics.chapter` has not been applied
 * to the database yet.
 */
export async function getLessonChapter(lessonId: string): Promise<string | null> {
  const { data, error } = await supabase
    .from("lessons")
    .select("topics(chapter, slug)")
    .eq("id", lessonId)
    .single();

  if (error || !data) {
    console.error("getLessonChapter error:", error?.message);
    return null;
  }

  const topic = (data.topics as { chapter: string | null; slug: string }[] | null)?.[0];
  return (
    topic?.chapter?.trim() || TOPIC_SLUG_TO_CHAPTER[topic?.slug ?? ""] || null
  );
}
