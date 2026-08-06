import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import type { ReactNode } from "react";
import LessonPlayer from "@/app/learn/[slug]/LessonPlayer";
import * as lessonsClient from "@/lib/lessons/client";
import type { Lesson, ContentVariant, LessonSource } from "@/lib/lessons/client";
import type { LessonVisualBlock } from "@/lib/lessons/visual-block";
import { dictionaries } from "@/lib/i18n/dictionaries";
import type { Locale } from "@/lib/i18n/types";

vi.mock("@/lib/lessons/client", async () => {
  const actual = await vi.importActual<typeof import("@/lib/lessons/client")>("@/lib/lessons/client");
  return {
    ...actual,
    getLessonBySlug: vi.fn(),
    getLessonVariants: vi.fn(),
    getLessonSources: vi.fn(),
    getLessonVisualBlocks: vi.fn(),
    getLessonStatus: vi.fn(),
    getRecentAttemptVariantIds: vi.fn(),
    seededIndex: vi.fn(),
  };
});

vi.mock("@/lib/auth/use-auth", () => ({
  useAuth: vi.fn().mockReturnValue({ user: { id: "00000000-0000-0000-0000-000000000001" }, loading: false }),
}));

vi.mock("next/navigation", () => ({
  useRouter: vi.fn().mockReturnValue({ push: vi.fn() }),
  usePathname: vi.fn().mockReturnValue("/learn/test-lesson"),
}));

vi.mock("@/lib/profile/client", () => ({
  getFinancialLiteracyLevel: vi.fn().mockResolvedValue(null),
  getProfile: vi.fn().mockResolvedValue({ onboarding_completed: true }),
}));

vi.mock("@/lib/analytics/client", () => ({
  trackEvent: vi.fn(),
}));

vi.mock("@/lib/lessons/completion", () => ({
  completeLesson: vi.fn().mockResolvedValue(null),
}));

const mockLocale = vi.fn<() => Locale>().mockReturnValue("en");

vi.mock("@/lib/i18n/LocaleProvider", () => ({
  useLocale: () => {
    const locale = mockLocale();
    return {
      locale,
      setLocale: vi.fn(),
      t: (key: string) => dictionaries[locale][key as keyof typeof dictionaries.en] ?? key,
    };
  },
  LocaleProvider: ({ children }: { children: ReactNode }) => children,
}));

const baseLesson: Lesson = {
  id: "lesson1",
  slug: "test-lesson",
  title: "Saving",
  titleId: "Menabung",
  lessonNumber: 1,
  difficulty: "beginner",
  xpReward: 10,
  estimatedMinutes: 3,
  summary: "Learn to save",
  summaryId: "Belajar menabung",
  conceptBody: "Saving sets money aside for the future",
  conceptBodyId: "Menabung menyisihkan uang untuk masa depan",
  indonesianExample: "Contoh utama",
  whyThisMatters: "Important",
  whyThisMattersId: "Penting",
  commonMistake: "Forget to save",
  commonMistakeId: "Lupa nabung",
  quizData: [],
  quizDataId: null,
};

const exampleVariants: ContentVariant[] = [
  { id: "ex-main", variantType: "example", body: { text: "Contoh utama" }, difficulty: "beginner", topicTag: null },
  { id: "ex-alt-1", variantType: "example", body: { text: "Contoh alternatif pertama" }, difficulty: "beginner", topicTag: null },
  { id: "ex-alt-2", variantType: "example", body: { text: "Contoh alternatif kedua" }, difficulty: "beginner", topicTag: null },
];

const questionVariants: ContentVariant[] = [
  {
    id: "question-1",
    variantType: "question",
    body: {
      type: "multiple_choice",
      question: "What should you do first?",
      options: ["Save first", "Spend everything"],
      answer: "Save first",
      explanation: "Saving first protects the goal.",
      parameters: {},
    },
    difficulty: "beginner",
    topicTag: "saving",
  },
  {
    id: "question-2",
    variantType: "question",
    body: {
      type: "multiple_choice",
      question: "Which habit supports saving?",
      options: ["Track spending", "Ignore spending"],
      answer: "Track spending",
      explanation: "Tracking spending reveals room to save.",
      parameters: {},
    },
    difficulty: "beginner",
    topicTag: "saving",
  },
];

const visualBlock: LessonVisualBlock = {
  id: "00000000-0000-0000-0000-000000000010",
  lessonId: "lesson1",
  placement: "concept",
  displayOrder: 0,
  dataStatus: "illustrative",
  isPublished: true,
  blockType: "comparison",
  content: {
    en: {
      title: "Evidence boundary",
      altText: "A comparison of observed facts and unsupported conclusions.",
      disclosure: "Illustrative learning example.",
      payload: {
        leftTitle: "Observed",
        rightTitle: "Unknown",
        rows: [{ left: "A value changed.", right: "What happens next." }],
      },
    },
    id: {
      title: "Batas bukti",
      altText: "Perbandingan fakta teramati dan kesimpulan yang belum didukung.",
      disclosure: "Contoh pembelajaran ilustratif.",
      payload: {
        leftTitle: "Teramati",
        rightTitle: "Belum diketahui",
        rows: [{ left: "Nilai berubah.", right: "Apa yang terjadi berikutnya." }],
      },
    },
  },
};

const exampleVisualBlock: LessonVisualBlock = {
  ...visualBlock,
  id: "00000000-0000-0000-0000-000000000011",
  placement: "example",
};

describe("LessonPlayer", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockLocale.mockReturnValue("en");
    Object.defineProperty(window, "matchMedia", {
      configurable: true,
      value: vi.fn().mockReturnValue({
        matches: false,
        addListener: vi.fn(),
        removeListener: vi.fn(),
        addEventListener: vi.fn(),
        removeEventListener: vi.fn(),
      }),
    });
    vi.mocked(lessonsClient.getLessonBySlug).mockResolvedValue(baseLesson);
    vi.mocked(lessonsClient.getLessonVariants).mockImplementation(async (_lessonId, variantType) => {
      if (variantType === "example") return exampleVariants;
      if (variantType === "explanation") return [];
      if (variantType === "question") return [];
      return [];
    });
    vi.mocked(lessonsClient.getLessonSources).mockResolvedValue([] as LessonSource[]);
    vi.mocked(lessonsClient.getLessonVisualBlocks).mockResolvedValue([]);
    vi.mocked(lessonsClient.getLessonStatus).mockResolvedValue(null);
    vi.mocked(lessonsClient.getRecentAttemptVariantIds).mockResolvedValue({ ids: new Set(), lastVariantId: null });
    vi.mocked(lessonsClient.seededIndex).mockReturnValue(0);
  });

  it("in English locale the example uses the variant pool and shows alternate-example UI", async () => {
    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("The concept")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("How this plays out")).toBeInTheDocument(), { timeout: 2000 });

    expect(screen.getByText("Contoh utama")).toBeInTheDocument();
    expect(screen.getByLabelText("See another example")).toBeInTheDocument();
  });

  it("renders an example visual inside How this plays out", async () => {
    vi.mocked(lessonsClient.getLessonVisualBlocks).mockResolvedValue([exampleVisualBlock]);
    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    fireEvent.click(screen.getByText("Continue"));

    await waitFor(() => expect(screen.getByText("How this plays out")).toBeInTheDocument(), { timeout: 2000 });
    expect(screen.getByText("Evidence boundary")).toBeInTheDocument();
  });

  it("renders the chart-literacy visual for the stock-analysis Part 2 example", async () => {
    vi.mocked(lessonsClient.getLessonBySlug).mockResolvedValue({
      ...baseLesson,
      slug: "stock-analysis-basics-fundamental-vs-technical-part-2",
    });
    render(<LessonPlayer slug="stock-analysis-basics-fundamental-vs-technical-part-2" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    fireEvent.click(screen.getByText("Continue"));

    await waitFor(() => expect(screen.getByText("How this plays out")).toBeInTheDocument(), { timeout: 2000 });
    expect(screen.getByRole("figure", { name: "Instructional candlestick chart" })).toBeInTheDocument();
  });

  it("keeps lesson continuation locked after a wrong check and offers a fresh variant", async () => {
    vi.mocked(lessonsClient.getLessonVariants).mockImplementation(async (_lessonId, variantType) => {
      if (variantType === "example") return exampleVariants;
      if (variantType === "question") return questionVariants;
      if (variantType === "explanation") return [];
      return [];
    });

    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    fireEvent.click(screen.getByText("Continue"));
    fireEvent.click(screen.getByText("Continue"));

    await waitFor(() => expect(screen.getByText("What should you do first?")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByRole("button", { name: "Spend everything" }));

    expect(screen.getByText("Saving first protects the goal.")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Try another question" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Continue" })).toBeDisabled();

    fireEvent.click(screen.getByRole("button", { name: "Try another question" }));
    await waitFor(() => expect(screen.getByText("Which habit supports saving?")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByRole("button", { name: "Track spending" }));

    expect(screen.getByRole("button", { name: "Continue" })).toBeEnabled();
  });

  it("keeps Chapter 08 retry questions inside the visual-applied pool", async () => {
    const appliedQuestions: ContentVariant[] = [
      {
        id: "applied-1",
        variantType: "question",
        body: {
          type: "multiple_choice",
          question: "Applied question one",
          options: ["Applied answer one", "Other one"],
          answer: "Applied answer one",
          explanation: "The first applied explanation.",
          parameters: {},
        },
        difficulty: "intermediate",
        topicTag: "visual_applied",
      },
      {
        id: "applied-2",
        variantType: "question",
        body: {
          type: "multiple_choice",
          question: "Applied question two",
          options: ["Applied answer two", "Other two"],
          answer: "Applied answer two",
          explanation: "The second applied explanation.",
          parameters: {},
        },
        difficulty: "intermediate",
        topicTag: "visual_applied",
      },
      {
        id: "contaminated-1",
        variantType: "question",
        body: {
          type: "multiple_choice",
          question: "Unrelated legacy question",
          options: ["Legacy answer", "Other legacy"],
          answer: "Legacy answer",
          explanation: "This question is not part of the visual lesson.",
          parameters: {},
        },
        difficulty: "intermediate",
        topicTag: "legacy-topic",
      },
    ];

    vi.mocked(lessonsClient.getLessonVisualBlocks).mockResolvedValue([visualBlock]);
    vi.mocked(lessonsClient.getLessonVariants).mockImplementation(async (_lessonId, variantType) => {
      if (variantType === "example") return exampleVariants;
      if (variantType === "question") return appliedQuestions;
      if (variantType === "explanation") return [];
      return [];
    });

    render(<LessonPlayer slug="test-lesson" chapterNumber={8} />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    fireEvent.click(screen.getByText("Continue"));
    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("Applied question one")).toBeInTheDocument(), { timeout: 2000 });
    expect(screen.queryByText("Unrelated legacy question")).not.toBeInTheDocument();

    fireEvent.click(screen.getByText("Applied answer one"));
    fireEvent.click(screen.getByRole("button", { name: "Next check" }));

    await waitFor(() => expect(screen.getByText("Applied question two")).toBeInTheDocument(), { timeout: 2000 });
    expect(screen.queryByText("Unrelated legacy question")).not.toBeInTheDocument();
  });

  it("in Indonesian locale shows a different example when clicking Lihat contoh lain", async () => {
    mockLocale.mockReturnValue("id");
    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Memuat pelajaran…")).not.toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByText("Lanjut"));
    await waitFor(() => expect(screen.getByText("Konsepnya")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Lanjut"));
    await waitFor(() => expect(screen.getByText("Begini penerapannya")).toBeInTheDocument(), { timeout: 2000 });

    expect(screen.getByText("Contoh utama")).toBeInTheDocument();
    expect(screen.getByLabelText("Lihat contoh lain")).toBeInTheDocument();

    fireEvent.click(screen.getByLabelText("Lihat contoh lain"));

    await waitFor(() => {
      expect(screen.getByText("Contoh alternatif pertama")).toBeInTheDocument();
    }, { timeout: 2000 });
  });

  it("in Indonesian locale shows another different example after returning to main, then hides the button when exhausted", async () => {
    mockLocale.mockReturnValue("id");
    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Memuat pelajaran…")).not.toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByText("Lanjut"));
    await waitFor(() => expect(screen.getByText("Konsepnya")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Lanjut"));
    await waitFor(() => expect(screen.getByText("Begini penerapannya")).toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByLabelText("Lihat contoh lain"));
    await waitFor(() => expect(screen.getByText("Contoh alternatif pertama")).toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByLabelText("Kembali ke contoh utama"));
    await waitFor(() => expect(screen.getByText("Contoh utama")).toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByLabelText("Lihat contoh lain"));
    await waitFor(() => expect(screen.getByText("Contoh alternatif kedua")).toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByLabelText("Kembali ke contoh utama"));
    await waitFor(() => expect(screen.getByText("Contoh utama")).toBeInTheDocument(), { timeout: 2000 });

    expect(screen.queryByLabelText("Lihat contoh lain")).not.toBeInTheDocument();
  });

  it("in Indonesian locale hides Lihat contoh lain when there is only one example variant", async () => {
    mockLocale.mockReturnValue("id");
    vi.mocked(lessonsClient.getLessonVariants).mockImplementation(async (_lessonId, variantType) => {
      if (variantType === "example") return [exampleVariants[0]];
      if (variantType === "explanation") return [];
      if (variantType === "question") return [];
      return [];
    });

    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Memuat pelajaran…")).not.toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByText("Lanjut"));
    await waitFor(() => expect(screen.getByText("Konsepnya")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Lanjut"));
    await waitFor(() => expect(screen.getByText("Begini penerapannya")).toBeInTheDocument(), { timeout: 2000 });

    expect(screen.queryByLabelText("Lihat contoh lain")).not.toBeInTheDocument();
  });
});
