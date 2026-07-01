import { createClient } from "@supabase/supabase-js";
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
  return <LessonPlayer slug={slug} />;
}
