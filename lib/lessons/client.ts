import { supabase } from "@/lib/auth/client";
import type { LessonStatus } from "./gating";
import type { QuizQuestion } from "./question";

/**
 * Fallback chapter mapping by topic slug. Once the `topics.chapter` column is
 * applied, the database value takes precedence; this map keeps the UI working
 * if the column is missing or a topic has not been assigned yet.
 */
const TOPIC_SLUG_TO_CHAPTER: Record<string, string> = {
  foundation_zero: "Money Basics",
  money_basics: "Money Basics",
  value_purchasing_power: "Money Basics",
  inflation: "Money Basics",
  income_wealth: "Money Basics",
  assets_liabilities: "Money Basics",
  risk_basics: "Money Basics",
  time_value_money: "Money Basics",

  scam_defense: "Protect Yourself",
  ojk_license_check: "Protect Yourself",
  phishing_social_engineering: "Protect Yourself",
  mlm_pyramid: "Protect Yourself",

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

  emergency_fund: "Money Life Skills",
  saving_habits: "Money Life Skills",
  budgeting: "Money Life Skills",
  spending_behavior: "Money Life Skills",
  debt_management: "Money Life Skills",
  goal_setting: "Money Life Skills",
  behavioral_finance: "Money Life Skills",
  financial_planning: "Money Life Skills",
};

export interface Lesson {
  id: string;
  slug: string;
  title: string;
  titleId: string;
  lessonNumber: number;
  difficulty: string;
  xpReward: number;
  estimatedMinutes: number;
  summary: string;
  conceptBody: string;
  indonesianExample: string;
  whyThisMatters: string;
  commonMistake: string;
  quizData: QuizQuestion[];
}

export interface ContentVariant {
  id: string;
  variantType: "explanation" | "example" | "question";
  body: Record<string, unknown>;
  difficulty: string | null;
  topicTag: string | null;
}

export type { QuizQuestion };

export interface LessonSource {
  id: string;
  sourceCode: string;
  title: string;
  organization: string;
  url: string;
  sourceTier: number;
  citationLabel: string | null;
  isPrimary: boolean;
  relevanceType: "primary" | "supporting" | "further_reading";
  status: "verified" | "needs_review" | string;
}

export async function getLessonBySlug(slug: string): Promise<Lesson | null> {
  const { data, error } = await supabase
    .from("lessons")
    .select(
      "id, slug, title, title_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, concept_body, indonesian_example, why_this_matters, common_mistake, quiz_data"
    )
    .eq("slug", slug)
    .single();

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
    conceptBody: data.concept_body,
    indonesianExample: data.indonesian_example,
    whyThisMatters: data.why_this_matters,
    commonMistake: data.common_mistake,
    quizData: (data.quiz_data as QuizQuestion[]) ?? [],
  };
}

export async function getLessonVariants(
  lessonId: string,
  variantType?: ContentVariant["variantType"],
  preferredDifficulty?: string | null
): Promise<ContentVariant[]> {
  let query = supabase
    .from("content_variants")
    .select("id, variant_type, body, difficulty, topic_tag")
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
    data?.map((v) => ({
      id: v.id,
      variantType: v.variant_type as ContentVariant["variantType"],
      body: (v.body as Record<string, unknown>) ?? {},
      difficulty: v.difficulty,
      topicTag: v.topic_tag,
    })) ?? [];

  if (preferredDifficulty) {
    const filtered = variants.filter(
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
        const fallback = variants.filter((v) => v.difficulty === difficulty);
        if (fallback.length > 0) {
          return fallback;
        }
      }
    }
  }

  return variants;
}

export async function getLessonSources(lessonId: string): Promise<LessonSource[]> {
  const { data, error } = await supabase
    .from("lesson_sources")
    .select(
      "source_id, citation_label, is_primary, relevance_type, sources(source_code, title, organization, url, source_tier, status)"
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
          organization: String(source.organization ?? ""),
          url: String(source.url ?? ""),
          sourceTier: Number(source.source_tier ?? 0),
          citationLabel: row.citation_label === null || row.citation_label === undefined ? null : String(row.citation_label),
          isPrimary: Boolean(row.is_primary ?? false),
          relevanceType: (row.relevance_type ?? "supporting") as LessonSource["relevanceType"],
          status: (source.status ?? "needs_review") as LessonSource["status"],
        };
      })
      .filter(Boolean) as LessonSource[]
  );
}

export async function getAllLessons(): Promise<
  Pick<Lesson, "id" | "slug" | "title" | "lessonNumber" | "difficulty" | "xpReward" | "estimatedMinutes" | "summary">[]
> {
  const { data, error } = await supabase
    .from("lessons")
    .select("id, slug, title, lesson_number, difficulty, xp_reward, estimated_minutes, summary")
    .order("lesson_number", { ascending: true });

  if (error) {
    console.error("getAllLessons error:", error.message);
    return [];
  }

  return (
    data?.map((l) => ({
      id: l.id,
      slug: l.slug,
      title: l.title,
      lessonNumber: l.lesson_number,
      difficulty: l.difficulty,
      xpReward: l.xp_reward,
      estimatedMinutes: l.estimated_minutes,
      summary: l.summary,
    })) ?? []
  );
}

export { seededIndex, seededShuffle } from "./random";

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

export async function getRecentAttemptVariantIds(
  userId: string,
  lessonId: string,
  days = 7
): Promise<Set<string>> {
  const since = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString();

  const { data, error } = await supabase
    .from("lesson_attempts")
    .select("answers_json")
    .eq("user_id", userId)
    .eq("lesson_id", lessonId)
    .gte("created_at", since);

  if (error || !data) {
    console.error("getRecentAttemptVariantIds error:", error?.message);
    return new Set();
  }

  const ids = new Set<string>();
  for (const row of data) {
    const answers = (row.answers_json ?? []) as AttemptAnswer[];
    for (const answer of answers) {
      if (answer?.variant_id) ids.add(answer.variant_id);
    }
  }
  return ids;
}

export interface ChapterLesson {
  id: string;
  slug: string;
  title: string;
  lessonNumber: number;
  difficulty: string;
  xpReward: number;
  estimatedMinutes: number;
  summary: string;
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
  "Money Basics",
  "Protect Yourself",
  "Grow Your Money",
  "Investing in Indonesia",
  "Money Life Skills",
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
    lesson_number: number;
    difficulty: string;
    xp_reward: number;
    estimated_minutes: number;
    summary: string;
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
      "id, slug, name, name_id, icon, color, display_order, chapter, lessons(id, slug, title, lesson_number, difficulty, xp_reward, estimated_minutes, summary)"
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
        "id, slug, name, name_id, icon, color, display_order, lessons(id, slug, title, lesson_number, difficulty, xp_reward, estimated_minutes, summary)"
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
      .sort((a, b) => lessonDisplayOrder(a) - lessonDisplayOrder(b))
      .map((l) => ({
        id: l.id,
        slug: l.slug,
        title: l.title,
        lessonNumber: l.lesson_number,
        difficulty: l.difficulty,
        xpReward: l.xp_reward,
        estimatedMinutes: l.estimated_minutes,
        summary: l.summary,
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
