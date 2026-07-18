import { createClient } from "@supabase/supabase-js";
import { getTopicsWithChapters } from "@/lib/lessons/client";
import LessonPlayer from "./LessonPlayer";

export async function generateStaticParams() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
  const client = createClient(supabaseUrl, supabaseAnonKey);
  const { data } = await client.from("lessons").select("slug");
  return (data ?? []).map((l: { slug: string }) => ({ slug: l.slug }));
}

export default async function LessonPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
  const client = createClient(supabaseUrl, supabaseAnonKey);
  const { count } = await client.from("lessons").select("*", { count: "exact", head: true });

  const chapters = await getTopicsWithChapters();
  let chapterLabel: string | undefined;

  for (let chapterIndex = 0; chapterIndex < chapters.length; chapterIndex++) {
    const chapter = chapters[chapterIndex];
    const chapterLessons = chapter.topics.flatMap((topic) => topic.lessons);
    const position = chapterLessons.findIndex((lesson) => lesson.slug === slug);
    if (position !== -1) {
      chapterLabel = `Chapter ${chapterIndex + 1} · Lesson ${position + 1} of ${chapterLessons.length}`;
      break;
    }
  }

  return <LessonPlayer slug={slug} totalLessons={count ?? undefined} chapterLabel={chapterLabel} />;
}
