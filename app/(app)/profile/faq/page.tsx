"use client";

import Link from "next/link";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import type { Locale } from "@/lib/i18n/types";

type FaqItem = { question: string; answer: string };
type FaqSection = { title: string; eyebrow?: string; items: FaqItem[] };

const FAQ: Record<Locale, { title: string; subtitle: string; notice: string; sections: FaqSection[] }> = {
  en: {
    title: "Help & FAQ",
    subtitle: "Clear answers about learning, rewards, and source trust.",
    notice: "Koinaku helps you learn practical money concepts. It does not provide personalised financial or investment advice.",
    sections: [
      {
        title: "Learning & progress",
        items: [
          { question: "What is Lifetime XP?", answer: "Lifetime XP is your permanent learning progress. You earn it from eligible milestones, such as completing a lesson for the first time. It does not reset." },
          { question: "Why does the Weekly Leaderboard change?", answer: "The Weekly Leaderboard compares activity earned during the current week. It refreshes for a new week, while your Lifetime XP remains yours forever." },
          { question: "Why is a chapter locked?", answer: "Your next core chapter opens after you complete the required lessons—and, later in the curriculum, its mastery check. Earlier chapters stay available to revisit." },
          { question: "Why did I start at a later chapter?", answer: "Your onboarding assessment suggests a starting level. You can still revisit earlier chapters whenever you want." },
        ],
      },
      {
        title: "Daily Focus, Pips & Koin Points",
        items: [
          { question: "What is Daily Focus?", answer: "Daily Focus is optional daily practice: five quick money checks from a question bank separate from lesson quizzes. It helps you recall concepts, but never blocks lesson progress." },
          { question: "What are Focus Pips?", answer: "Focus Pips are your attempts for Daily Focus. A wrong answer uses one pip. Core lessons and lesson replays remain unlimited." },
          { question: "How do I earn more Focus Pips?", answer: "Complete Daily Focus five times in one local week to permanently unlock a fourth Focus Pip for future challenges. You can also use the available once-per-day refill when eligible." },
          { question: "What are Koin Points?", answer: "Koin Points are in-app rewards earned through eligible learning milestones. They are separate from XP, are not real money, cannot be withdrawn, and have no cash value." },
          { question: "What can I use Koin Points for today?", answer: "At present, Koin Points can be used for the available Daily Focus refill: 50 Koin Points for one refill, once per local day. Available rewards may change over time." },
        ],
      },
      {
        title: "Trust & sources",
        items: [
          { question: "Where does Koinaku’s information come from?", answer: "We prioritise Indonesian primary sources such as OJK, Bank Indonesia, and IDX, then show the relevant source with each lesson so you can inspect where an idea came from." },
          { question: "Why do I sometimes see Wikipedia?", answer: "If an original source link is unavailable, Koinaku may offer a clearly labelled Wikipedia link as background reading so you are not left at a dead link. It is not a replacement for an official source; check primary sources whenever possible." },
          { question: "Why are books included as sources?", answer: "Our book list is curated to support financial-literacy learning alongside Indonesian primary sources. We will add more titles over time, including deeper premium learning content based on selected books." },
        ],
      },
      {
        title: "Practice & safety",
        items: [
          { question: "Is Paper Trading real investing?", answer: "No. Paper Trading is a practice environment using simulated money. No real orders or real money are involved." },
          { question: "Can I trust every result or recommendation?", answer: "Use Koinaku to learn concepts and ask better questions—not as a substitute for your own research or regulated professional advice." },
        ],
      },
      {
        title: "Coming next",
        eyebrow: "PLANNED, NOT AVAILABLE YET",
        items: [
          { question: "Will Koin Points unlock avatar drops?", answer: "Yes—this is planned for a future release. Koin Points will be redeemable for rotating avatar drops: standard drops are planned to rotate weekly, while rare drops are planned monthly in limited quantities. The app will show the cost, availability, and remaining time before redemption." },
          { question: "Will all avatars always be available?", answer: "No. Some future avatar drops may rotate or have limited availability. Availability, cost, and timing will be shown before you redeem." },
          { question: "Will Koinaku have AI features?", answer: "Yes. AI-supported learning features are in development for a later release. The goal is to make practice and explanations more personal—not to replace trusted sources or provide personalised financial advice. We will explain how an available AI feature uses your data." },
        ],
      },
    ],
  },
  id: {
    title: "Bantuan & FAQ",
    subtitle: "Jawaban jelas tentang belajar, reward, dan keandalan sumber.",
    notice: "Koinaku membantu kamu mempelajari konsep keuangan praktis. Koinaku tidak memberikan nasihat keuangan atau investasi yang dipersonalisasi.",
    sections: [
      {
        title: "Belajar & progres",
        items: [
          { question: "Apa itu Lifetime XP?", answer: "Lifetime XP adalah progres belajar permanenmu. Kamu mendapatkannya dari milestone yang memenuhi syarat, seperti menyelesaikan pelajaran untuk pertama kali. Lifetime XP tidak direset." },
          { question: "Kenapa Papan Peringkat Mingguan berubah?", answer: "Papan Peringkat Mingguan membandingkan aktivitas yang diperoleh selama minggu berjalan. Papan ini diperbarui pada minggu baru, sedangkan Lifetime XP tetap milikmu selamanya." },
          { question: "Kenapa bab terkunci?", answer: "Bab inti berikutnya terbuka setelah kamu menyelesaikan pelajaran yang diperlukan—dan pada tahap lanjut, cek penguasaan. Bab sebelumnya tetap tersedia untuk diulang." },
          { question: "Kenapa saya mulai dari bab yang lebih lanjut?", answer: "Asesmen saat onboarding menyarankan titik mulai. Kamu tetap dapat mengulang bab sebelumnya kapan saja." },
        ],
      },
      {
        title: "Daily Focus, Pip & Koin Points",
        items: [
          { question: "Apa itu Daily Focus?", answer: "Daily Focus adalah latihan opsional harian: lima cek pemahaman keuangan singkat dari bank soal yang terpisah dari kuis pelajaran. Fitur ini membantu mengingat konsep, tetapi tidak menghambat progres pelajaran." },
          { question: "Apa itu Pip Fokus?", answer: "Pip Fokus adalah kesempatanmu di Daily Focus. Jawaban salah mengurangi satu pip. Pelajaran inti dan pengulangan pelajaran tetap tidak terbatas." },
          { question: "Bagaimana saya mendapat Pip Fokus tambahan?", answer: "Selesaikan Daily Focus lima kali dalam satu minggu lokal untuk membuka Pip Fokus keempat secara permanen untuk tantangan berikutnya. Kamu juga dapat memakai isi ulang sekali per hari yang tersedia jika memenuhi syarat." },
          { question: "Apa itu Koin Points?", answer: "Koin Points adalah reward di dalam aplikasi yang diperoleh dari milestone belajar yang memenuhi syarat. Koin Points berbeda dari XP, bukan uang asli, tidak dapat dicairkan, dan tidak memiliki nilai tunai." },
          { question: "Untuk apa Koin Points dapat digunakan saat ini?", answer: "Saat ini, Koin Points dapat digunakan untuk isi ulang Daily Focus yang tersedia: 50 Koin Points untuk satu kali isi ulang, sekali per hari lokal. Reward yang tersedia dapat berubah seiring waktu." },
        ],
      },
      {
        title: "Keandalan & sumber",
        items: [
          { question: "Dari mana informasi Koinaku berasal?", answer: "Kami memprioritaskan sumber primer Indonesia seperti OJK, Bank Indonesia, dan IDX, lalu menampilkan sumber yang relevan pada setiap pelajaran agar kamu dapat memeriksa asal sebuah informasi." },
          { question: "Kenapa terkadang ada Wikipedia?", answer: "Jika tautan sumber asli tidak tersedia, Koinaku dapat menawarkan tautan Wikipedia yang diberi label jelas sebagai bacaan latar agar kamu tidak menemui tautan mati. Wikipedia bukan pengganti sumber resmi; periksa sumber primer bila memungkinkan." },
          { question: "Kenapa buku dimasukkan sebagai sumber?", answer: "Daftar buku kami dikurasi untuk mendukung pembelajaran literasi keuangan, melengkapi sumber primer Indonesia. Kami akan menambahkan lebih banyak judul secara bertahap, termasuk konten belajar premium yang lebih mendalam berdasarkan buku pilihan." },
        ],
      },
      {
        title: "Latihan & keamanan",
        items: [
          { question: "Apakah Paper Trading adalah investasi sungguhan?", answer: "Tidak. Paper Trading adalah lingkungan latihan yang menggunakan uang simulasi. Tidak ada order maupun uang asli yang terlibat." },
          { question: "Apakah semua hasil atau rekomendasi bisa dipercaya begitu saja?", answer: "Gunakan Koinaku untuk memahami konsep dan mengajukan pertanyaan yang lebih baik—bukan sebagai pengganti risetmu sendiri atau nasihat profesional berizin." },
        ],
      },
      {
        title: "Segera hadir",
        eyebrow: "DIRENCANAKAN, BELUM TERSEDIA",
        items: [
          { question: "Apakah Koin Points dapat membuka avatar drop?", answer: "Ya—fitur ini direncanakan untuk rilis mendatang. Koin Points akan dapat ditukar dengan avatar drop yang berganti secara berkala: drop reguler direncanakan berganti tiap minggu, sementara drop langka direncanakan hadir setiap bulan dalam jumlah terbatas. Aplikasi akan menampilkan biaya, ketersediaan, dan sisa waktu sebelum penukaran." },
          { question: "Apakah semua avatar selalu tersedia?", answer: "Tidak. Beberapa avatar drop di masa depan mungkin berganti atau memiliki jumlah terbatas. Ketersediaan, biaya, dan waktunya akan ditampilkan sebelum kamu menukarkannya." },
          { question: "Apakah Koinaku akan memiliki fitur AI?", answer: "Ya. Fitur belajar berbantuan AI sedang dikembangkan untuk rilis mendatang. Tujuannya adalah membuat latihan dan penjelasan lebih personal—bukan menggantikan sumber tepercaya atau memberikan nasihat keuangan pribadi. Kami akan menjelaskan bagaimana fitur AI yang tersedia menggunakan datamu." },
        ],
      },
    ],
  },
};

export default function ProfileFaqPage() {
  const { locale } = useLocale();
  const content = FAQ[locale];
  const backLabel = locale === "id" ? "Kembali ke Profil" : "Back to Profile";

  return (
    <main className="mx-auto max-w-3xl p-5 pb-32 sm:p-6 lg:p-8">
      <Link href="/profile" className="inline-flex min-h-11 items-center text-sm font-semibold text-primary hover:underline">
        ← {backLabel}
      </Link>

      <header className="mt-5 rounded-card border border-primary/20 bg-[color-mix(in_srgb,var(--color-primary)_6%,var(--color-surface))] p-6 shadow-sm sm:p-8">
        <div className="flex h-11 w-11 items-center justify-center rounded-full bg-primary text-xl font-bold text-primary-foreground" aria-hidden="true">?</div>
        <h1 className="mt-5 font-display text-3xl font-bold tracking-tight text-foreground">{content.title}</h1>
        <p className="mt-2 text-sm leading-6 text-muted-foreground">{content.subtitle}</p>
        <p className="mt-5 rounded-lg border border-primary/15 bg-surface px-4 py-3 text-sm leading-6 text-foreground">{content.notice}</p>
      </header>

      <div className="mt-8 space-y-8">
        {content.sections.map((section) => (
          <section key={section.title} aria-labelledby={`faq-${section.title}`}>
            {section.eyebrow && <p className="text-xs font-bold tracking-[0.16em] text-primary">{section.eyebrow}</p>}
            <h2 id={`faq-${section.title}`} className="font-display text-xl font-bold text-foreground">{section.title}</h2>
            <div className="mt-3 divide-y divide-border overflow-hidden rounded-card border border-border bg-surface shadow-sm">
              {section.items.map((item) => (
                <details key={item.question} className="group">
                  <summary className="flex min-h-14 cursor-pointer list-none items-center justify-between gap-4 px-5 py-4 text-sm font-semibold text-foreground marker:content-none hover:bg-surface-raised focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-primary">
                    <span>{item.question}</span>
                    <span className="shrink-0 text-lg text-primary transition-transform group-open:rotate-45" aria-hidden="true">+</span>
                  </summary>
                  <p className="border-t border-border bg-background px-5 py-4 text-sm leading-6 text-muted-foreground">{item.answer}</p>
                </details>
              ))}
            </div>
          </section>
        ))}
      </div>
    </main>
  );
}
