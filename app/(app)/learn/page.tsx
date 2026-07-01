"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { getAllLessons, getLessonProgress } from "@/lib/lessons/client";
import { useAuth } from "@/lib/auth/use-auth";
import type { Lesson } from "@/lib/lessons/client";

export default function LearnPage() {
  const { user } = useAuth(true);
  const [lessons, setLessons] = useState<
    Pick<Lesson, "id" | "slug" | "title" | "lessonNumber" | "difficulty" | "xpReward" | "estimatedMinutes" | "summary">[]
  >([]);
  const [progress, setProgress] = useState<Record<string, "locked" | "available" | "in_progress" | "completed"> | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const [all, userProgress] = await Promise.all([
        getAllLessons(),
        user ? getLessonProgress(user.id) : Promise.resolve(null),
      ]);
      if (!mounted) return;
      setLessons(all);
      setProgress(userProgress);
      setLoading(false);
    };

    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  return (
    <div className="p-5 pb-28">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Learn</h1>
        <p className="mt-1 text-sm text-muted-foreground">Bite-sized money lessons, one concept at a time.</p>
      </header>

      {loading ? (
        <div className="space-y-3">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="h-24 animate-pulse rounded-radius-lg bg-muted" />
          ))}
        </div>
      ) : (
        <div className="space-y-3">
          {lessons.map((lesson, index) => (
            <LessonCard
              key={lesson.id}
              lesson={lesson}
              status={progress?.[lesson.id] ?? "locked"}
              previousCompleted={index === 0 || progress?.[lessons[index - 1]?.id] === "completed"}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function LessonCard({
  lesson,
  status,
  previousCompleted,
}: {
  lesson: Pick<Lesson, "id" | "slug" | "title" | "lessonNumber" | "difficulty" | "xpReward" | "estimatedMinutes" | "summary">;
  status: "locked" | "available" | "in_progress" | "completed";
  previousCompleted: boolean;
}) {
  const isCompleted = status === "completed";
  const isLocked = status === "locked" && !previousCompleted;

  const content = (
    <div
      className={`relative rounded-radius-lg border bg-surface p-4 transition-all ${
        isLocked ? "border-muted opacity-70" : "border-muted/60 shadow-sm hover:border-primary/30 hover:shadow-md"
      }`}
    >
      <div className="flex items-start gap-4">
        <span
          className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-full text-sm font-bold ${
            isCompleted
              ? "bg-success text-white"
              : isLocked
                ? "bg-muted text-muted-foreground"
                : "bg-primary/10 text-primary"
          }`}
        >
          {isCompleted ? "✓" : lesson.lessonNumber}
        </span>

        <div className="min-w-0 flex-1">
          <h2 className="font-semibold text-foreground">{lesson.title}</h2>
          <p className="mt-0.5 text-sm leading-relaxed text-muted-foreground">{lesson.summary}</p>
          <div className="mt-2 flex items-center gap-2 text-xs text-muted-foreground">
            <span>{lesson.estimatedMinutes} min</span>
            <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
            <span className="text-xp">{lesson.xpReward} XP</span>
          </div>
        </div>

        {isLocked && (
          <svg
            className="mt-1 h-5 w-5 text-muted-foreground"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
            <path d="M7 11V7a5 5 0 0 1 10 0v4" />
          </svg>
        )}
      </div>
    </div>
  );

  if (isLocked) {
    return <div>{content}</div>;
  }

  return (
    <Link href={`/learn/${lesson.slug}`} className="block">
      {content}
    </Link>
  );
}
