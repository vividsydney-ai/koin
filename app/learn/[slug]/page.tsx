import { createClient } from "@supabase/supabase-js";
import { redirect } from "next/navigation";
import { createClient as createServerClient } from "@/lib/supabase/server";
import { getTopicsWithChapters } from "@/lib/lessons/client";
import { LocaleProvider } from "@/lib/i18n/LocaleProvider";
import LessonPlayer from "./LessonPlayer";

export async function generateStaticParams() {
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
  const client = createClient(supabaseUrl, supabaseAnonKey);
  const { data } = await client.from("lessons").select("slug").eq("is_published", true);
  return (data ?? []).map((l: { slug: string }) => ({ slug: l.slug }));
}

export default async function LessonPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;

  // Redirect unauthenticated users immediately on the server so they never see
  // the "Loading lesson…" spinner while the client auth check runs.
  const serverClient = await createServerClient();
  const { data: authData } = await serverClient.auth.getUser();
  if (!authData.user) {
    redirect("/login");
  }

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
  const client = createClient(supabaseUrl, supabaseAnonKey);
  const { count } = await client
    .from("lessons")
    .select("*", { count: "exact", head: true })
    .eq("is_published", true);

  const chapters = await getTopicsWithChapters();
  let chapterNumber: number | undefined;
  let lessonNumber: number | undefined;
  let chapterLessonsCount: number | undefined;

  for (let chapterIndex = 0; chapterIndex < chapters.length; chapterIndex++) {
    const chapter = chapters[chapterIndex];
    const chapterLessons = chapter.topics.flatMap((topic) => topic.lessons);
    const position = chapterLessons.findIndex((lesson) => lesson.slug === slug);
    if (position !== -1) {
      chapterNumber = chapterIndex;
      lessonNumber = position + 1;
      chapterLessonsCount = chapterLessons.length;
      break;
    }
  }

  return (
    <LocaleProvider>
      <LessonPlayer
        slug={slug}
        totalLessons={count ?? undefined}
        chapterNumber={chapterNumber}
        lessonNumber={lessonNumber}
        chapterLessonsCount={chapterLessonsCount}
      />
    </LocaleProvider>
  );
}
