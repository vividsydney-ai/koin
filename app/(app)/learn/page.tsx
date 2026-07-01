"use client";

import Link from "next/link";

interface Lesson {
  id: string;
  slug: string;
  number: number;
  title: string;
  description: string;
  duration: string;
  xp: number;
  status: "available" | "locked" | "completed";
}

const LESSONS: Lesson[] = [
  {
    id: "money-basics-101",
    slug: "/learn/money-basics-101",
    number: 1,
    title: "Money Basics",
    description: "Needs vs wants, emergency funds, and why scams always sound urgent.",
    duration: "4 min",
    xp: 60,
    status: "available",
  },
  {
    id: "budgeting-101",
    slug: "/learn/budgeting-101",
    number: 2,
    title: "Budgeting That Sticks",
    description: "The Indonesian version of 50/30/20: needs, wants, and future you.",
    duration: "5 min",
    xp: 60,
    status: "available",
  },
  {
    id: "inflation-101",
    slug: "/learn/inflation-101",
    number: 3,
    title: "Inflation",
    description: "Why your rupiah buys less over time — and what to do about it.",
    duration: "4 min",
    xp: 60,
    status: "available",
  },
  {
    id: "risk-return-101",
    slug: "/learn/risk-return-101",
    number: 4,
    title: "Risk vs Return",
    description: "The one rule every investor has to accept: higher return means higher risk.",
    duration: "5 min",
    xp: 80,
    status: "locked",
  },
  {
    id: "investing-101",
    slug: "/learn/investing-101",
    number: 5,
    title: "Start Investing",
    description: "RDPU, reksa dana, and the magic of starting small and early.",
    duration: "6 min",
    xp: 100,
    status: "locked",
  },
];

export default function LearnPage() {
  return (
    <div className="p-5 pb-28">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Learn</h1>
        <p className="mt-1 text-sm text-muted-foreground">Bite-sized money lessons, one concept at a time.</p>
      </header>

      <div className="space-y-3">
        {LESSONS.map((lesson) => (
          <LessonCard key={lesson.id} lesson={lesson} />
        ))}
      </div>
    </div>
  );
}

function LessonCard({ lesson }: { lesson: Lesson }) {
  const isLocked = lesson.status === "locked";
  const isCompleted = lesson.status === "completed";

  const content = (
    <div
      className={`relative rounded-radius-lg border bg-surface p-4 transition-all ${
        isLocked
          ? "border-muted opacity-70"
          : "border-muted/60 shadow-sm hover:border-primary/30 hover:shadow-md"
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
          {isCompleted ? (
            <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M20 6 9 17l-5-5" />
            </svg>
          ) : (
            lesson.number
          )}
        </span>

        <div className="min-w-0 flex-1">
          <h2 className="font-semibold text-foreground">{lesson.title}</h2>
          <p className="mt-0.5 text-sm leading-relaxed text-muted-foreground">{lesson.description}</p>
          <div className="mt-2 flex items-center gap-2 text-xs text-muted-foreground">
            <span>{lesson.duration}</span>
            <span className="h-1 w-1 rounded-full bg-muted-foreground/40" />
            <span className="text-xp">{lesson.xp} XP</span>
          </div>
        </div>

        {isLocked && (
          <svg className="mt-1 h-5 w-5 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
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
    <Link href={lesson.slug} className="block">
      {content}
    </Link>
  );
}
