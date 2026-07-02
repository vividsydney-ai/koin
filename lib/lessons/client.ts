import { supabase } from "@/lib/auth/client";
import type { QuizQuestion } from "./question";

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
  variantType?: ContentVariant["variantType"]
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

  return (
    data?.map((v) => ({
      id: v.id,
      variantType: v.variant_type as ContentVariant["variantType"],
      body: (v.body as Record<string, unknown>) ?? {},
      difficulty: v.difficulty,
      topicTag: v.topic_tag,
    })) ?? []
  );
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
      ?.map((row: any) => {
        const source = row.sources;
        if (!source) return null;
        return {
          id: row.source_id,
          sourceCode: source.source_code,
          title: source.title,
          organization: source.organization,
          url: source.url,
          sourceTier: source.source_tier,
          citationLabel: row.citation_label,
          isPrimary: row.is_primary,
          relevanceType: row.relevance_type ?? "supporting",
          status: source.status ?? "needs_review",
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
