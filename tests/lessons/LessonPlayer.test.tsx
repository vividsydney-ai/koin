import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import type { ReactNode } from "react";
import LessonPlayer from "@/app/learn/[slug]/LessonPlayer";
import * as lessonsClient from "@/lib/lessons/client";
import type { Lesson, ContentVariant, LessonSource } from "@/lib/lessons/client";
import { dictionaries } from "@/lib/i18n/dictionaries";
import type { Locale } from "@/lib/i18n/types";

vi.mock("@/lib/lessons/client", async () => {
  const actual = await vi.importActual<typeof import("@/lib/lessons/client")>("@/lib/lessons/client");
  return {
    ...actual,
    getLessonBySlug: vi.fn(),
    getLessonVariants: vi.fn(),
    getLessonSources: vi.fn(),
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

describe("LessonPlayer", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockLocale.mockReturnValue("en");
    vi.mocked(lessonsClient.getLessonBySlug).mockResolvedValue(baseLesson);
    vi.mocked(lessonsClient.getLessonVariants).mockImplementation(async (_lessonId, variantType) => {
      if (variantType === "example") return exampleVariants;
      if (variantType === "explanation") return [];
      if (variantType === "question") return [];
      return [];
    });
    vi.mocked(lessonsClient.getLessonSources).mockResolvedValue([] as LessonSource[]);
    vi.mocked(lessonsClient.getRecentAttemptVariantIds).mockResolvedValue(new Set());
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
