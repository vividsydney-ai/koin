"use client";

import { useParams } from "next/navigation";
import { ChapterMissionPlayer } from "@/components/lesson/ChapterMissionPlayer";
import { chapterMissionRouteSchema } from "@/lib/schemas/lessons";

export default function ChapterMissionPage() {
  const params = useParams<{ chapter: string }>();
  const parsed = chapterMissionRouteSchema.safeParse(params.chapter);
  return parsed.success ? <ChapterMissionPlayer chapterNumber={parsed.data} /> : <ChapterMissionPlayer chapterNumber={0} />;
}
