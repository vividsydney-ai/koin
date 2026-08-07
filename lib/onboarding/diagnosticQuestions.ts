export type Difficulty = "beginner" | "intermediate" | "advanced";

export type DiagnosticQuestion = {
  id: string;
  difficulty: Difficulty;
  topic: string;
  /** Foundation 0 lesson slug used for remedial recommendations when answered incorrectly. */
  remediationSlug: string;
  type: "multiple_choice" | "true_false";
  question: string;
  options: { value: string; label: string }[];
  answer: string;
  explanation: string;
};

export type AssessmentResult = {
  level: Difficulty;
  score: number;
  maxScore: number;
  correctByDifficulty: Record<Difficulty, number>;
  answers: Record<string, boolean>;
  wrongRemediationSlugs: string[];
};

export const diagnosticQuestions: DiagnosticQuestion[] = [
  {
    id: "q1",
    difficulty: "beginner",
    topic: "tabungan",
    remediationSlug: "fz-saving-vs-investing",
    type: "multiple_choice",
    question: "Menabung secara rutin paling membantu untuk apa?",
    options: [
      { value: "a", label: "Membeli barang impian dengan utang" },
      { value: "b", label: "Membangun dana darurat dan kebiasaan finansial" },
      { value: "c", label: "Mendapatkan keuntungan cepat seperti trading" },
    ],
    answer: "b",
    explanation:
      "Menabung rutin membantu membangun dana darurat dan kebiasaan mengelola uang, bukan untuk utang atau keuntungan instan.",
  },
  {
    id: "q2",
    difficulty: "beginner",
    topic: "inflasi",
    remediationSlug: "fz-inflation",
    type: "true_false",
    question: "Inflasi membuat uang yang disimpan di bawah bantal kehilangan daya beli seiring waktu.",
    options: [
      { value: "true", label: "Benar" },
      { value: "false", label: "Salah" },
    ],
    answer: "true",
    explanation:
      "Benar. Inflasi meningkatkan harga barang dan jasa, sehingga uang yang tidak berkembang akan membeli lebih sedikit di masa depan.",
  },
  {
    id: "q3",
    difficulty: "intermediate",
    topic: "bunga_majemuk",
    remediationSlug: "fz-interest",
    type: "multiple_choice",
    question: "Apa keunggulan utama bunga majemuk (compound interest)?",
    options: [
      { value: "a", label: "Bunga dihitung hanya dari pokok tabungan awal" },
      { value: "b", label: "Bunga dihitung dari pokok ditambah bunga yang sudah didapat" },
      { value: "c", label: "Menjamin keuntungan tanpa risiko" },
    ],
    answer: "b",
    explanation:
      "Bunga majemuk menghitung bunga dari pokok dan bunga yang telah diperoleh sebelumnya, sehingga pertumbuhan dana semakin cepat dari waktu ke waktu.",
  },
  {
    id: "q4",
    difficulty: "intermediate",
    topic: "diversifikasi",
    remediationSlug: "fz-risk",
    type: "true_false",
    question: "Diversifikasi berarti menempatkan semua uang di satu instrumen agar keuntungan maksimal.",
    options: [
      { value: "true", label: "Benar" },
      { value: "false", label: "Salah" },
    ],
    answer: "false",
    explanation:
      "Salah. Diversifikasi justru membagi investasi ke berbagai instrumen untuk mengurangi risiko, bukan memusatkan di satu tempat.",
  },
  {
    id: "q5",
    difficulty: "advanced",
    topic: "risiko_investasi",
    remediationSlug: "fz-return",
    type: "multiple_choice",
    question: "Hubungan antara risiko dan imbal hasil (return) yang umumnya benar adalah...",
    options: [
      { value: "a", label: "Semakin tinggi potensi return, semakin tinggi risikonya" },
      { value: "b", label: "Return tinggi selalu berarti risiko rendah" },
      { value: "c", label: "Risiko tinggi tidak pernah memberikan return tinggi" },
    ],
    answer: "a",
    explanation:
      "Secara umum, imbal hasil yang lebih tinggi menawarkan potensi keuntungan lebih besar, tetapi juga disertai risiko yang lebih besar.",
  },
];

export const defaultLevel: Difficulty = "beginner";

export function scoreAssessment(
  answers: Record<string, boolean>
): AssessmentResult {
  const correctByDifficulty: Record<Difficulty, number> = {
    beginner: 0,
    intermediate: 0,
    advanced: 0,
  };

  const wrongRemediationSlugs: string[] = [];

  for (const question of diagnosticQuestions) {
    const isCorrect = answers[question.id] === true;
    if (isCorrect) {
      correctByDifficulty[question.difficulty] += 1;
    } else {
      wrongRemediationSlugs.push(question.remediationSlug);
    }
  }

  const score = Object.values(correctByDifficulty).reduce((a, b) => a + b, 0);
  const maxScore = diagnosticQuestions.length;

  const upperLevelCorrect =
    correctByDifficulty.intermediate + correctByDifficulty.advanced;

  const upperLevelTotal =
    diagnosticQuestions.filter((q) => q.difficulty !== "beginner").length;

  let level: Difficulty;
  if (upperLevelTotal > 0 && upperLevelCorrect >= upperLevelTotal) {
    level = "advanced";
  } else if (upperLevelCorrect >= 2) {
    level = "intermediate";
  } else {
    level = "beginner";
  }

  return {
    level,
    score,
    maxScore,
    correctByDifficulty,
    answers,
    wrongRemediationSlugs,
  };
}

/**
 * Determine the learning-path gate from an assessment result.
 * - 0-1 correct: full Foundation 0 track.
 * - 2-3 correct: Foundation 0 from its first lesson.
 * - 4-5 correct: skip Foundation 0, start main track.
 */
export function computeLearningPath(result: AssessmentResult): {
  foundationZeroRequired: boolean;
  startingLessonSlug: string;
} {
  const { score } = result;

  if (score >= 4) {
    return {
      foundationZeroRequired: false,
      // `money-basics-101` was intentionally unpublished when Foundation 0
      // became the canonical introduction. Start capable learners at the
      // first published lesson in Chapter 01 instead.
      startingLessonSlug: "needs-vs-wants-101",
    };
  }

  if (score >= 2) {
    return {
      foundationZeroRequired: true,
      startingLessonSlug: "fz-income-vs-wealth",
    };
  }

  return {
    foundationZeroRequired: true,
    startingLessonSlug: "fz-what-is-money",
  };
}
