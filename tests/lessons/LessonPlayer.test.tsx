import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import LessonPlayer from "@/app/learn/[slug]/LessonPlayer";
import * as lessonsClient from "@/lib/lessons/client";
import type { Lesson, ContentVariant, LessonSource } from "@/lib/lessons/client";

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
  useAuth: vi.fn().mockReturnValue({ user: { id: "user1" }, loading: false }),
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

const baseLesson: Lesson = {
  id: "lesson1",
  slug: "test-lesson",
  title: "Menabung",
  titleId: "Menabung",
  lessonNumber: 1,
  difficulty: "beginner",
  xpReward: 10,
  estimatedMinutes: 3,
  summary: "Belajar menabung",
  summaryId: null,
  conceptBody: "Menabung menyisihkan uang untuk masa depan",
  conceptBodyId: null,
  indonesianExample: "Contoh utama",
  whyThisMatters: "Penting",
  whyThisMattersId: null,
  commonMistake: "Lupa nabung",
  commonMistakeId: null,
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

  it("shows a different example when clicking See another example", async () => {
    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });

    // Advance from intro -> concept -> example.
    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("The concept")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("Indonesian example")).toBeInTheDocument(), { timeout: 2000 });

    expect(screen.getByText("Contoh utama")).toBeInTheDocument();
    expect(screen.getByLabelText("See another example")).toBeInTheDocument();

    fireEvent.click(screen.getByLabelText("See another example"));

    await waitFor(() => {
      expect(screen.getByText("Contoh alternatif pertama")).toBeInTheDocument();
    }, { timeout: 2000 });
  });

  it("shows another different example after returning to main, then hides the button when exhausted", async () => {
    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("The concept")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("Indonesian example")).toBeInTheDocument(), { timeout: 2000 });

    // First alternate.
    fireEvent.click(screen.getByLabelText("See another example"));
    await waitFor(() => expect(screen.getByText("Contoh alternatif pertama")).toBeInTheDocument(), { timeout: 2000 });

    // Return to main.
    fireEvent.click(screen.getByLabelText("Back to main example"));
    await waitFor(() => expect(screen.getByText("Contoh utama")).toBeInTheDocument(), { timeout: 2000 });

    // Second alternate.
    fireEvent.click(screen.getByLabelText("See another example"));
    await waitFor(() => expect(screen.getByText("Contoh alternatif kedua")).toBeInTheDocument(), { timeout: 2000 });

    // Return to main.
    fireEvent.click(screen.getByLabelText("Back to main example"));
    await waitFor(() => expect(screen.getByText("Contoh utama")).toBeInTheDocument(), { timeout: 2000 });

    // Button should be hidden because all alternates are exhausted.
    expect(screen.queryByLabelText("See another example")).not.toBeInTheDocument();
  });

  it("hides See another example when there is only one example variant", async () => {
    vi.mocked(lessonsClient.getLessonVariants).mockImplementation(async (_lessonId, variantType) => {
      if (variantType === "example") return [exampleVariants[0]];
      if (variantType === "explanation") return [];
      if (variantType === "question") return [];
      return [];
    });

    render(<LessonPlayer slug="test-lesson" />);

    await waitFor(() => expect(screen.queryByText("Loading lesson…")).not.toBeInTheDocument(), { timeout: 2000 });

    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("The concept")).toBeInTheDocument(), { timeout: 2000 });
    fireEvent.click(screen.getByText("Continue"));
    await waitFor(() => expect(screen.getByText("Indonesian example")).toBeInTheDocument(), { timeout: 2000 });

    expect(screen.queryByLabelText("See another example")).not.toBeInTheDocument();
  });
});
