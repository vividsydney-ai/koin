-- KO-188: Supabase-managed FAQ content repository.
-- All learner-facing Profile FAQ copy, ordering, visibility, and roadmap labels
-- live in the content repository rather than the client bundle.

CREATE TABLE faq_pages (
  page_key TEXT PRIMARY KEY,
  title_en TEXT NOT NULL CHECK (length(trim(title_en)) > 0),
  title_id TEXT NOT NULL CHECK (length(trim(title_id)) > 0),
  subtitle_en TEXT NOT NULL CHECK (length(trim(subtitle_en)) > 0),
  subtitle_id TEXT NOT NULL CHECK (length(trim(subtitle_id)) > 0),
  notice_en TEXT NOT NULL CHECK (length(trim(notice_en)) > 0),
  notice_id TEXT NOT NULL CHECK (length(trim(notice_id)) > 0),
  is_published BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE faq_sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  page_key TEXT NOT NULL REFERENCES faq_pages(page_key) ON DELETE CASCADE,
  section_key TEXT NOT NULL,
  display_order SMALLINT NOT NULL CHECK (display_order > 0),
  title_en TEXT NOT NULL CHECK (length(trim(title_en)) > 0),
  title_id TEXT NOT NULL CHECK (length(trim(title_id)) > 0),
  eyebrow_en TEXT,
  eyebrow_id TEXT,
  is_roadmap BOOLEAN NOT NULL DEFAULT false,
  is_published BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (page_key, section_key),
  UNIQUE (page_key, display_order)
);

CREATE TABLE faq_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  section_id UUID NOT NULL REFERENCES faq_sections(id) ON DELETE CASCADE,
  entry_key TEXT NOT NULL UNIQUE,
  display_order SMALLINT NOT NULL CHECK (display_order > 0),
  question_en TEXT NOT NULL CHECK (length(trim(question_en)) > 0),
  question_id TEXT NOT NULL CHECK (length(trim(question_id)) > 0),
  answer_en TEXT NOT NULL CHECK (length(trim(answer_en)) > 0),
  answer_id TEXT NOT NULL CHECK (length(trim(answer_id)) > 0),
  is_published BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (section_id, display_order)
);

CREATE INDEX faq_sections_published_order_idx ON faq_sections (page_key, is_published, display_order);
CREATE INDEX faq_entries_published_order_idx ON faq_entries (section_id, is_published, display_order);

ALTER TABLE faq_pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE faq_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE faq_entries ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON faq_pages, faq_sections, faq_entries FROM anon, authenticated;
GRANT SELECT ON faq_pages, faq_sections, faq_entries TO authenticated, service_role;

CREATE POLICY "Authenticated users read published FAQ pages"
  ON faq_pages FOR SELECT TO authenticated
  USING (is_published = true);

CREATE POLICY "Authenticated users read published FAQ sections"
  ON faq_sections FOR SELECT TO authenticated
  USING (is_published = true);

CREATE POLICY "Authenticated users read published FAQ entries"
  ON faq_entries FOR SELECT TO authenticated
  USING (is_published = true);

INSERT INTO faq_pages (
  page_key, title_en, title_id, subtitle_en, subtitle_id, notice_en, notice_id, is_published
) VALUES (
  'profile_faq',
  'Help & FAQ',
  'Bantuan & FAQ',
  'Clear answers about learning, rewards, and source trust.',
  'Jawaban jelas tentang belajar, reward, dan keandalan sumber.',
  'Koinaku helps you learn practical money concepts. It does not provide personalised financial or investment advice.',
  'Koinaku membantu kamu mempelajari konsep keuangan praktis. Koinaku tidak memberikan nasihat keuangan atau investasi yang dipersonalisasi.',
  true
);

INSERT INTO faq_sections (
  page_key, section_key, display_order, title_en, title_id, eyebrow_en, eyebrow_id, is_roadmap, is_published
) VALUES
  ('profile_faq', 'learning_progress', 1, 'Learning & progress', 'Belajar & progres', NULL, NULL, false, true),
  ('profile_faq', 'daily_focus_rewards', 2, 'Daily Focus, Pips & Koin Points', 'Daily Focus, Pip & Koin Points', NULL, NULL, false, true),
  ('profile_faq', 'trust_sources', 3, 'Trust & sources', 'Keandalan & sumber', NULL, NULL, false, true),
  ('profile_faq', 'practice_safety', 4, 'Practice & safety', 'Latihan & keamanan', NULL, NULL, false, true),
  ('profile_faq', 'coming_next', 5, 'Coming next', 'Segera hadir', 'PLANNED, NOT AVAILABLE YET', 'DIRENCANAKAN, BELUM TERSEDIA', true, true);

INSERT INTO faq_entries (
  section_id, entry_key, display_order, question_en, question_id, answer_en, answer_id, is_published
)
SELECT section.id, seed.entry_key, seed.display_order, seed.question_en, seed.question_id, seed.answer_en, seed.answer_id, true
FROM faq_sections AS section
JOIN (
  VALUES
    ('learning_progress', 'lifetime_xp', 1,
      'What is Lifetime XP?', 'Apa itu Lifetime XP?',
      'Lifetime XP is your permanent learning progress. You earn it from eligible milestones, such as completing a lesson for the first time. It does not reset.',
      'Lifetime XP adalah progres belajar permanenmu. Kamu mendapatkannya dari milestone yang memenuhi syarat, seperti menyelesaikan pelajaran untuk pertama kali. Lifetime XP tidak direset.'),
    ('learning_progress', 'weekly_leaderboard', 2,
      'Why does the Weekly Leaderboard change?', 'Kenapa Papan Peringkat Mingguan berubah?',
      'The Weekly Leaderboard compares activity earned during the current week. It refreshes for a new week, while your Lifetime XP remains yours forever.',
      'Papan Peringkat Mingguan membandingkan aktivitas yang diperoleh selama minggu berjalan. Papan ini diperbarui pada minggu baru, sedangkan Lifetime XP tetap milikmu selamanya.'),
    ('learning_progress', 'chapter_locked', 3,
      'Why is a chapter locked?', 'Kenapa bab terkunci?',
      'Your next core chapter opens after you complete the required lessons—and, later in the curriculum, its mastery check. Earlier chapters stay available to revisit.',
      'Bab inti berikutnya terbuka setelah kamu menyelesaikan pelajaran yang diperlukan—dan pada tahap lanjut, cek penguasaan. Bab sebelumnya tetap tersedia untuk diulang.'),
    ('learning_progress', 'assessment_placement', 4,
      'Why did I start at a later chapter?', 'Kenapa saya mulai dari bab yang lebih lanjut?',
      'Your onboarding assessment suggests a starting level. You can still revisit earlier chapters whenever you want.',
      'Asesmen saat onboarding menyarankan titik mulai. Kamu tetap dapat mengulang bab sebelumnya kapan saja.'),
    ('daily_focus_rewards', 'daily_focus', 1,
      'What is Daily Focus?', 'Apa itu Daily Focus?',
      'Daily Focus is optional daily practice: five quick money checks from a question bank separate from lesson quizzes. It helps you recall concepts, but never blocks lesson progress.',
      'Daily Focus adalah latihan opsional harian: lima cek pemahaman keuangan singkat dari bank soal yang terpisah dari kuis pelajaran. Fitur ini membantu mengingat konsep, tetapi tidak menghambat progres pelajaran.'),
    ('daily_focus_rewards', 'focus_pips', 2,
      'What are Focus Pips?', 'Apa itu Pip Fokus?',
      'Focus Pips are your attempts for Daily Focus. A wrong answer uses one pip. Core lessons and lesson replays remain unlimited.',
      'Pip Fokus adalah kesempatanmu di Daily Focus. Jawaban salah mengurangi satu pip. Pelajaran inti dan pengulangan pelajaran tetap tidak terbatas.'),
    ('daily_focus_rewards', 'earn_focus_pips', 3,
      'How do I earn more Focus Pips?', 'Bagaimana saya mendapat Pip Fokus tambahan?',
      'Complete Daily Focus five times in one local week to permanently unlock a fourth Focus Pip for future challenges. You can also use the available once-per-day refill when eligible.',
      'Selesaikan Daily Focus lima kali dalam satu minggu lokal untuk membuka Pip Fokus keempat secara permanen untuk tantangan berikutnya. Kamu juga dapat memakai isi ulang sekali per hari yang tersedia jika memenuhi syarat.'),
    ('daily_focus_rewards', 'koin_points', 4,
      'What are Koin Points?', 'Apa itu Koin Points?',
      'Koin Points are in-app rewards earned through eligible learning milestones. They are separate from XP, are not real money, cannot be withdrawn, and have no cash value.',
      'Koin Points adalah reward di dalam aplikasi yang diperoleh dari milestone belajar yang memenuhi syarat. Koin Points berbeda dari XP, bukan uang asli, tidak dapat dicairkan, dan tidak memiliki nilai tunai.'),
    ('daily_focus_rewards', 'koin_points_usage', 5,
      'What can I use Koin Points for today?', 'Untuk apa Koin Points dapat digunakan saat ini?',
      'At present, Koin Points can be used for the available Daily Focus refill: 50 Koin Points for one refill, once per local day. Available rewards may change over time.',
      'Saat ini, Koin Points dapat digunakan untuk isi ulang Daily Focus yang tersedia: 50 Koin Points untuk satu kali isi ulang, sekali per hari lokal. Reward yang tersedia dapat berubah seiring waktu.'),
    ('trust_sources', 'source_origins', 1,
      'Where does Koinaku’s information come from?', 'Dari mana informasi Koinaku berasal?',
      'We prioritise Indonesian primary sources such as OJK, Bank Indonesia, and IDX, then show the relevant source with each lesson so you can inspect where an idea came from.',
      'Kami memprioritaskan sumber primer Indonesia seperti OJK, Bank Indonesia, dan IDX, lalu menampilkan sumber yang relevan pada setiap pelajaran agar kamu dapat memeriksa asal sebuah informasi.'),
    ('trust_sources', 'wikipedia_fallback', 2,
      'Why do I sometimes see Wikipedia?', 'Kenapa terkadang ada Wikipedia?',
      'If an original source link is unavailable, Koinaku may offer a clearly labelled Wikipedia link as background reading so you are not left at a dead link. It is not a replacement for an official source; check primary sources whenever possible.',
      'Jika tautan sumber asli tidak tersedia, Koinaku dapat menawarkan tautan Wikipedia yang diberi label jelas sebagai bacaan latar agar kamu tidak menemui tautan mati. Wikipedia bukan pengganti sumber resmi; periksa sumber primer bila memungkinkan.'),
    ('trust_sources', 'book_sources', 3,
      'Why are books included as sources?', 'Kenapa buku dimasukkan sebagai sumber?',
      'Our book list is curated to support financial-literacy learning alongside Indonesian primary sources. We will add more titles over time, including deeper premium learning content based on selected books.',
      'Daftar buku kami dikurasi untuk mendukung pembelajaran literasi keuangan, melengkapi sumber primer Indonesia. Kami akan menambahkan lebih banyak judul secara bertahap, termasuk konten belajar premium yang lebih mendalam berdasarkan buku pilihan.'),
    ('practice_safety', 'paper_trading', 1,
      'Is Paper Trading real investing?', 'Apakah Paper Trading adalah investasi sungguhan?',
      'No. Paper Trading is a practice environment using simulated money. No real orders or real money are involved.',
      'Tidak. Paper Trading adalah lingkungan latihan yang menggunakan uang simulasi. Tidak ada order maupun uang asli yang terlibat.'),
    ('practice_safety', 'advice_disclaimer', 2,
      'Can I trust every result or recommendation?', 'Apakah semua hasil atau rekomendasi bisa dipercaya begitu saja?',
      'Use Koinaku to learn concepts and ask better questions—not as a substitute for your own research or regulated professional advice.',
      'Gunakan Koinaku untuk memahami konsep dan mengajukan pertanyaan yang lebih baik—bukan sebagai pengganti risetmu sendiri atau nasihat profesional berizin.'),
    ('coming_next', 'avatar_drops', 1,
      'Will Koin Points unlock avatar drops?', 'Apakah Koin Points dapat membuka avatar drop?',
      'Yes—this is planned for a future release. Koin Points will be redeemable for rotating avatar drops: standard drops are planned to rotate weekly, while rare drops are planned monthly in limited quantities. The app will show the cost, availability, and remaining time before redemption.',
      'Ya—fitur ini direncanakan untuk rilis mendatang. Koin Points akan dapat ditukar dengan avatar drop yang berganti secara berkala: drop reguler direncanakan berganti tiap minggu, sementara drop langka direncanakan hadir setiap bulan dalam jumlah terbatas. Aplikasi akan menampilkan biaya, ketersediaan, dan sisa waktu sebelum penukaran.'),
    ('coming_next', 'avatar_availability', 2,
      'Will all avatars always be available?', 'Apakah semua avatar selalu tersedia?',
      'No. Some future avatar drops may rotate or have limited availability. Availability, cost, and timing will be shown before you redeem.',
      'Tidak. Beberapa avatar drop di masa depan mungkin berganti atau memiliki jumlah terbatas. Ketersediaan, biaya, dan waktunya akan ditampilkan sebelum kamu menukarkannya.'),
    ('coming_next', 'ai_features', 3,
      'Will Koinaku have AI features?', 'Apakah Koinaku akan memiliki fitur AI?',
      'Yes. AI-supported learning features are in development for a later release. The goal is to make practice and explanations more personal—not to replace trusted sources or provide personalised financial advice. We will explain how an available AI feature uses your data.',
      'Ya. Fitur belajar berbantuan AI sedang dikembangkan untuk rilis mendatang. Tujuannya adalah membuat latihan dan penjelasan lebih personal—bukan menggantikan sumber tepercaya atau memberikan nasihat keuangan pribadi. Kami akan menjelaskan bagaimana fitur AI yang tersedia menggunakan datamu.')
) AS seed(section_key, entry_key, display_order, question_en, question_id, answer_en, answer_id)
  ON section.page_key = 'profile_faq'
 AND section.section_key = seed.section_key;
