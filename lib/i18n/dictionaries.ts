import type { Locale } from "./types";

export interface Dictionary {
  // Bottom navigation
  "nav.home": string;
  "nav.learn": string;
  "nav.trade": string;
  "nav.friends": string;
  "nav.library": string;
  "nav.profile": string;

  // Lesson player chrome
  "lesson.step.intro": string;
  "lesson.step.concept": string;
  "lesson.step.example": string;
  "lesson.step.quiz": string;
  "lesson.step.source": string;
  "lesson.lessonWord": string;
  "lesson.of": string;
  "lesson.exit": string;
  "lesson.continue": string;
  "lesson.finish": string;
  "lesson.loading": string;
  "lesson.loadError": string;
  "lesson.errorTitle": string;
  "lesson.tryAgain": string;
  "lesson.backToLearn": string;
  "lesson.notFoundTitle": string;
  "lesson.notFoundBody": string;
  "lesson.completionError": string;
  "lesson.errorTooFast": string;
  "lesson.minutes": string;
  "lesson.theConcept": string;
  "lesson.simplerExplanation": string;
  "lesson.backToMainExplanation": string;
  "lesson.indonesianExample": string;
  "lesson.exampleHeading": string;
  "lesson.seeAnotherExample": string;
  "lesson.backToMainExample": string;
  "lesson.commonMistake": string;
  "lesson.quickCheck": string;
  "lesson.quizHeading": string;
  "lesson.tryAnotherQuestion": string;
  "lesson.sourceTrust": string;
  "lesson.sourceHeading": string;
  "lesson.sourceBody": string;
  "lesson.noSources": string;
  "lesson.primarySource": string;
  "lesson.supportingSources": string;
  "lesson.furtherReading": string;
  "lesson.complete": string;
  "lesson.tier": string;
  "lesson.verified": string;
  "lesson.needsReview": string;
  "lesson.readSource": string;
  "lesson.quizBonus": string;
  "lesson.streak": string;
  "lesson.baseXp": string;
  "lesson.badgeEarned": string;
  "lesson.nextLesson": string;
  "lesson.replayNotice": string;
  "lesson.replayCompleteTitle": string;
  "lesson.noNewXp": string;
  "lesson.alreadyEarned": string;
  "lesson.alreadyEarnedValue": string;

  // Quiz engine
  "quiz.correctAnswer": string;
  "quiz.fallbackStatement": string;
  "quiz.fallbackExplanation": string;

  // Profile page
  "profile.loading": string;
  "profile.edit": string;
  "profile.streak": string;
  "profile.paperPortfolio": string;
  "profile.totalValue": string;
  "profile.cash": string;
  "profile.return": string;
  "profile.noPortfolio": string;
  "profile.badges": string;
  "profile.logout": string;

  // Settings section
  "settings.title": string;
  "settings.language": string;

  // Friends / leaderboard
  "friends.you": string;

  // Trade / price chart
  "trade.simulatedPrices": string;
  "trade.simulatedBody": string;

  // Library filters
  "library.allSources": string;
  "library.allTiers": string;
  "library.allTypes": string;
  "library.allLanguages": string;

  // Library source card
  "library.synopsis": string;
  "library.relevance": string;
  "library.readMore": string;
  "library.showLess": string;

  // Badges
  "profile.locked": string;
  "profile.keepLearning": string;
}

// Note: a few lesson-player strings were originally Indonesian in the old
// mixed-language UI ("Lihat contoh lain" etc.). Per product direction, "en"
// is fully English and "id" is fully Indonesian — each locale is consistent.
export const dictionaries: Record<Locale, Dictionary> = {
  en: {
    "nav.home": "Home",
    "nav.learn": "Learn",
    "nav.trade": "Trade",
    "nav.friends": "Friends",
    "nav.library": "Library",
    "nav.profile": "Profile",

    "lesson.step.intro": "Intro",
    "lesson.step.concept": "Concept",
    "lesson.step.example": "Example",
    "lesson.step.quiz": "Quiz",
    "lesson.step.source": "Source",
    "lesson.lessonWord": "Lesson",
    "lesson.of": "of",
    "lesson.exit": "Exit",
    "lesson.continue": "Continue",
    "lesson.finish": "Finish lesson",
    "lesson.loading": "Loading lesson…",
    "lesson.loadError": "We couldn't load this lesson. Please try again.",
    "lesson.errorTitle": "Something went wrong",
    "lesson.tryAgain": "Try again",
    "lesson.backToLearn": "Back to Learn",
    "lesson.notFoundTitle": "Lesson not found",
    "lesson.notFoundBody": "This topic is not available yet.",
    "lesson.completionError":
      "We couldn't save your progress. Please check your connection and try again.",
    "lesson.errorTooFast":
      "Please spend at least a few more moments on this lesson before finishing.",
    "lesson.minutes": "minutes",
    "lesson.theConcept": "The concept",
    "lesson.simplerExplanation": "Simpler explanation",
    "lesson.backToMainExplanation": "Back to main explanation",
    "lesson.indonesianExample": "Indonesian example",
    "lesson.exampleHeading": "How this plays out",
    "lesson.seeAnotherExample": "See another example",
    "lesson.backToMainExample": "Back to main example",
    "lesson.commonMistake": "Common mistake:",
    "lesson.quickCheck": "Quick check",
    "lesson.quizHeading": "Test your understanding",
    "lesson.tryAnotherQuestion": "Try another question",
    "lesson.sourceTrust": "Source trust",
    "lesson.sourceHeading": "Where this comes from",
    "lesson.sourceBody":
      "Koin only teaches from licensed Indonesian regulators and verified institutions. If you see unsourced advice, question it.",
    "lesson.noSources": "No source listed for this lesson.",
    "lesson.primarySource": "Primary source",
    "lesson.supportingSources": "Supporting sources",
    "lesson.furtherReading": "Further reading",
    "lesson.complete": "Lesson complete",
    "lesson.tier": "Tier",
    "lesson.verified": "Verified",
    "lesson.needsReview": "Needs review",
    "lesson.readSource": "Read source",
    "lesson.quizBonus": "Includes +{bonus} quiz bonus",
    "lesson.streak": "Streak",
    "lesson.baseXp": "Base XP",
    "lesson.badgeEarned": "Badge earned",
    "lesson.nextLesson": "Next lesson",
    "lesson.replayNotice":
      "You've already completed this lesson. Replaying is great practice, but you won't earn XP again.",
    "lesson.replayCompleteTitle": "Practice complete",
    "lesson.noNewXp": "No new XP — you already earned the XP for this lesson.",
    "lesson.alreadyEarned": "Already earned",
    "lesson.alreadyEarnedValue": "0",

    "quiz.correctAnswer": "Correct answer:",
    "quiz.fallbackStatement": "{concept} is important for managing money well.",
    "quiz.fallbackExplanation": "Understanding this is basic for everyday money management.",

    "profile.loading": "Loading profile…",
    "profile.edit": "Edit",
    "profile.streak": "Streak",
    "profile.paperPortfolio": "Paper Portfolio",
    "profile.totalValue": "Total value",
    "profile.cash": "Cash",
    "profile.return": "Return",
    "profile.noPortfolio": "No portfolio yet. Start paper trading from the Trade tab.",
    "profile.badges": "Badges",
    "profile.logout": "Log out",

    "settings.title": "Settings",
    "settings.language": "Language",

    "friends.you": "You",
    "trade.simulatedPrices": "Simulated prices",
    "trade.simulatedBody":
      "some data points are generated when official IDX data is unavailable. For paper-trading practice only.",
    "library.allSources": "All sources",
    "library.allTiers": "All tiers",
    "library.allTypes": "All types",
    "library.allLanguages": "All languages",
    "library.synopsis": "What this source covers",
    "library.relevance": "Why it matters to you",
    "library.readMore": "Read more",
    "library.showLess": "Show less",
    "profile.locked": "Locked",
    "profile.keepLearning": "Keep learning to unlock.",
  },
  id: {
    "nav.home": "Beranda",
    "nav.learn": "Belajar",
    "nav.trade": "Trading",
    "nav.friends": "Teman",
    "nav.library": "Pustaka",
    "nav.profile": "Profil",

    "lesson.step.intro": "Intro",
    "lesson.step.concept": "Konsep",
    "lesson.step.example": "Contoh",
    "lesson.step.quiz": "Kuis",
    "lesson.step.source": "Sumber",
    "lesson.lessonWord": "Pelajaran",
    "lesson.of": "dari",
    "lesson.exit": "Keluar",
    "lesson.continue": "Lanjut",
    "lesson.finish": "Selesaikan pelajaran",
    "lesson.loading": "Memuat pelajaran…",
    "lesson.loadError": "Kami tidak dapat memuat pelajaran ini. Silakan coba lagi.",
    "lesson.errorTitle": "Terjadi kesalahan",
    "lesson.tryAgain": "Coba lagi",
    "lesson.backToLearn": "Kembali ke Belajar",
    "lesson.notFoundTitle": "Pelajaran tidak ditemukan",
    "lesson.notFoundBody": "Topik ini belum tersedia.",
    "lesson.completionError":
      "Kami tidak dapat menyimpan progresmu. Periksa koneksimu dan coba lagi.",
    "lesson.errorTooFast":
      "Silakan luangkan waktu sebentar lagi untuk pelajaran ini sebelum menyelesaikannya.",
    "lesson.minutes": "menit",
    "lesson.theConcept": "Konsepnya",
    "lesson.simplerExplanation": "Penjelasan lebih sederhana",
    "lesson.backToMainExplanation": "Kembali ke penjelasan utama",
    "lesson.indonesianExample": "Contoh Indonesia",
    "lesson.exampleHeading": "Begini penerapannya",
    "lesson.seeAnotherExample": "Lihat contoh lain",
    "lesson.backToMainExample": "Kembali ke contoh utama",
    "lesson.commonMistake": "Kesalahan umum:",
    "lesson.quickCheck": "Cek cepat",
    "lesson.quizHeading": "Uji pemahamanmu",
    "lesson.tryAnotherQuestion": "Coba soal lain",
    "lesson.sourceTrust": "Kepercayaan sumber",
    "lesson.sourceHeading": "Dari mana asalnya",
    "lesson.sourceBody":
      "Koin hanya mengajar dari regulator Indonesia berlisensi dan institusi terverifikasi. Jika kamu melihat saran tanpa sumber, pertanyakan.",
    "lesson.noSources": "Belum ada sumber untuk pelajaran ini.",
    "lesson.primarySource": "Sumber utama",
    "lesson.supportingSources": "Sumber pendukung",
    "lesson.furtherReading": "Bacaan lanjutan",
    "lesson.complete": "Pelajaran selesai",
    "lesson.tier": "Tingkat",
    "lesson.verified": "Terverifikasi",
    "lesson.needsReview": "Perlu ditinjau",
    "lesson.readSource": "Baca sumber",
    "lesson.quizBonus": "Termasuk +{bonus} bonus kuis",
    "lesson.streak": "Rentetan",
    "lesson.baseXp": "XP dasar",
    "lesson.badgeEarned": "Lencana didapat",
    "lesson.nextLesson": "Pelajaran berikutnya",
    "lesson.replayNotice":
      "Kamu sudah menyelesaikan pelajaran ini. Mengulang bagus untuk latihan, tapi XP tidak bertambah lagi.",
    "lesson.replayCompleteTitle": "Latihan selesai",
    "lesson.noNewXp": "Tidak ada XP baru — kamu sudah mendapat XP untuk pelajaran ini.",
    "lesson.alreadyEarned": "Sudah didapat",
    "lesson.alreadyEarnedValue": "0",

    "quiz.correctAnswer": "Jawaban benar:",
    "quiz.fallbackStatement": "{concept} penting untuk mengelola uang dengan baik.",
    "quiz.fallbackExplanation": "Pemahaman ini dasar untuk mengelola keuangan sehari-hari.",

    "profile.loading": "Memuat profil…",
    "profile.edit": "Ubah",
    "profile.streak": "Rentetan",
    "profile.paperPortfolio": "Portofolio Simulasi",
    "profile.totalValue": "Nilai total",
    "profile.cash": "Kas",
    "profile.return": "Imbal hasil",
    "profile.noPortfolio": "Belum ada portofolio. Mulai trading simulasi dari tab Trading.",
    "profile.badges": "Lencana",
    "profile.logout": "Keluar",

    "settings.title": "Pengaturan",
    "settings.language": "Bahasa",

    "friends.you": "Kamu",
    "trade.simulatedPrices": "Harga simulasi",
    "trade.simulatedBody":
      "beberapa titik data dibuat saat data resmi IDX tidak tersedia. Hanya untuk latihan paper trading.",
    "library.allSources": "Semua sumber",
    "library.allTiers": "Semua tingkat",
    "library.allTypes": "Semua tipe",
    "library.allLanguages": "Semua bahasa",
    "library.synopsis": "Apa yang dibahas sumber ini",
    "library.relevance": "Mengapa ini penting bagimu",
    "library.readMore": "Baca selengkapnya",
    "library.showLess": "Tampilkan lebih sedikit",
    "profile.locked": "Terkunci",
    "profile.keepLearning": "Terus belajar untuk membuka.",
  },
};
