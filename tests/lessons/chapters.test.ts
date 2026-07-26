import { describe, it, expect, vi } from "vitest";

const { from } = vi.hoisted(() => ({
  from: vi.fn(),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from,
  },
}));

import {
  getTopicsWithChapters,
  getLessonChapter,
  findChapterForLesson,
  type Chapter,
} from "@/lib/lessons/client";

function createTopicsQueryChain(rows: unknown[]) {
  const chain = {
    order: vi.fn(() => chain),
    then: vi.fn((cb: (result: { data: unknown[]; error: null }) => void) =>
      cb({ data: rows, error: null })
    ),
  };
  return chain;
}

function createSingleQueryChain(row: unknown) {
  const chain = {
    eq: vi.fn(() => chain),
    single: vi.fn(() => Promise.resolve({ data: row, error: null })),
  };
  return chain;
}

function mockTopicsResponse(rows: unknown[]) {
  from.mockReturnValueOnce({
    select: vi.fn(() => createTopicsQueryChain(rows)),
  });
}

function mockLessonChapterResponse(row: unknown) {
  from.mockReturnValueOnce({
    select: vi.fn(() => createSingleQueryChain(row)),
  });
}

describe("getTopicsWithChapters", () => {
  it("groups topics by chapter and preserves canonical chapter order", async () => {
    mockTopicsResponse([
      {
        id: "t-grow",
        slug: "compound_interest",
        name: "Compound Interest",
        name_id: "Bunga Majemuk",
        icon: null,
        color: null,
        display_order: 2,
        chapter: "Grow Your Money",
        lessons: [],
      },
      {
        id: "t-basics",
        slug: "foundation_zero",
        name: "Foundation Zero",
        name_id: "Dasar Keuangan",
        icon: null,
        color: null,
        display_order: 0,
        chapter: "Foundation",
        lessons: [],
      },
      {
        id: "t-money-basics",
        slug: "money_basics",
        name: "Money Basics",
        name_id: "Dasar Uang",
        icon: null,
        color: null,
        display_order: 11,
        chapter: "Money Basics",
        lessons: [],
      },
      {
        id: "t-protect",
        slug: "scam_defense",
        name: "Scam Defense",
        name_id: "Pertahanan Penipuan",
        icon: null,
        color: null,
        display_order: 1,
        chapter: "Protect Yourself",
        lessons: [],
      },
    ]);

    const chapters = await getTopicsWithChapters();
    expect(chapters.map((c) => c.title)).toEqual([
      "Foundation",
      "Money Basics",
      "Protect Yourself",
      "Grow Your Money",
    ]);
    expect(chapters.map((c) => c.displayOrder)).toEqual([0, 1, 3, 6]);
  });

  it("orders lessons within a topic by lesson_number", async () => {
    mockTopicsResponse([
      {
        id: "t-basics",
        slug: "foundation_zero",
        name: "Foundation Zero",
        name_id: "Dasar Keuangan",
        icon: null,
        color: null,
        display_order: 0,
        chapter: "Money Basics",
        lessons: [
          { id: "l-2", slug: "lesson-2", title: "Second", lesson_number: 2, difficulty: "beginner", xp_reward: 10, estimated_minutes: 3, summary: "" },
          { id: "l-1", slug: "lesson-1", title: "First", lesson_number: 1, difficulty: "beginner", xp_reward: 10, estimated_minutes: 3, summary: "" },
          { id: "l-3", slug: "lesson-3", title: "Third", lesson_number: 3, difficulty: "beginner", xp_reward: 10, estimated_minutes: 3, summary: "" },
        ],
      },
    ]);

    const chapters = await getTopicsWithChapters();
    const lessonIds = chapters[0].topics[0].lessons.map((l) => l.id);
    expect(lessonIds).toEqual(["l-1", "l-2", "l-3"]);
  });

  it("orders topics within a chapter by display_order", async () => {
    mockTopicsResponse([
      {
        id: "t-b",
        slug: "time_value_money",
        name: "Time Value of Money",
        name_id: "Nilai Waktu Uang",
        icon: null,
        color: null,
        display_order: 10,
        chapter: "Money Basics",
        lessons: [],
      },
      {
        id: "t-a",
        slug: "foundation_zero",
        name: "Foundation Zero",
        name_id: "Dasar Keuangan",
        icon: null,
        color: null,
        display_order: 1,
        chapter: "Money Basics",
        lessons: [],
      },
    ]);

    const chapters = await getTopicsWithChapters();
    expect(chapters[0].topics.map((t) => t.slug)).toEqual(["foundation_zero", "time_value_money"]);
  });

  it("reports completed counts when a progress map is provided", async () => {
    mockTopicsResponse([
      {
        id: "t-basics",
        slug: "foundation_zero",
        name: "Foundation Zero",
        name_id: "Dasar Keuangan",
        icon: null,
        color: null,
        display_order: 0,
        chapter: "Money Basics",
        lessons: [
          { id: "l-1", slug: "lesson-1", title: "First", lesson_number: 1, difficulty: "beginner", xp_reward: 10, estimated_minutes: 3, summary: "" },
          { id: "l-2", slug: "lesson-2", title: "Second", lesson_number: 2, difficulty: "beginner", xp_reward: 10, estimated_minutes: 3, summary: "" },
          { id: "l-3", slug: "lesson-3", title: "Third", lesson_number: 3, difficulty: "beginner", xp_reward: 10, estimated_minutes: 3, summary: "" },
        ],
      },
    ]);

    const progressMap = { "l-1": "completed", "l-2": "completed" } as Record<string, "completed">;
    const chapters = await getTopicsWithChapters(progressMap);
    expect(chapters[0].lessonCount).toBe(3);
    expect(chapters[0].completedCount).toBe(2);
  });

  it("falls back to Uncategorized for topics without a chapter", async () => {
    mockTopicsResponse([
      {
        id: "t-orphan",
        slug: "orphan_topic",
        name: "Orphan Topic",
        name_id: "Topik Tanpa Bab",
        icon: null,
        color: null,
        display_order: 99,
        chapter: null,
        lessons: [],
      },
    ]);

    const chapters = await getTopicsWithChapters();
    expect(chapters[0].title).toBe("Uncategorized");
  });
});

describe("getLessonChapter", () => {
  it("returns the chapter title for a lesson", async () => {
    mockLessonChapterResponse({ topics: [{ chapter: "Money Basics" }] });
    const chapter = await getLessonChapter("lesson-1");
    expect(chapter).toBe("Money Basics");
  });

  it("returns null when the lesson has no chapter", async () => {
    mockLessonChapterResponse({ topics: [{ chapter: null }] });
    const chapter = await getLessonChapter("lesson-1");
    expect(chapter).toBeNull();
  });
});

describe("findChapterForLesson", () => {
  const chapters: Chapter[] = [
    {
      title: "Money Basics",
      displayOrder: 0,
      lessonCount: 2,
      completedCount: 0,
      topics: [
        {
          id: "t-basics",
          slug: "foundation_zero",
          name: "Foundation Zero",
          displayOrder: 0,
          lessons: [
            { id: "l-1", slug: "lesson-1", title: "First", titleId: null, lessonNumber: 1, difficulty: "beginner", xpReward: 10, estimatedMinutes: 3, summary: "", summaryId: null },
            { id: "l-2", slug: "lesson-2", title: "Second", titleId: null, lessonNumber: 2, difficulty: "beginner", xpReward: 10, estimatedMinutes: 3, summary: "", summaryId: null },
          ],
        },
      ],
    },
    {
      title: "Protect Yourself",
      displayOrder: 1,
      lessonCount: 1,
      completedCount: 0,
      topics: [
        {
          id: "t-protect",
          slug: "scam_defense",
          name: "Scam Defense",
          displayOrder: 1,
          lessons: [
            { id: "l-3", slug: "lesson-3", title: "Third", titleId: null, lessonNumber: 3, difficulty: "beginner", xpReward: 10, estimatedMinutes: 3, summary: "", summaryId: null },
          ],
        },
      ],
    },
  ];

  it("finds the chapter containing the current lesson", () => {
    const current = findChapterForLesson(chapters, "l-3");
    expect(current?.title).toBe("Protect Yourself");
  });

  it("returns undefined when the lesson is not in any chapter", () => {
    const current = findChapterForLesson(chapters, "missing");
    expect(current).toBeUndefined();
  });
});
