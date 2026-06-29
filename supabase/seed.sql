-- Koin MVP Reference Seed Data
-- WARNING: This seed file intentionally skips profiles/users and dependent tables
-- because they require auth.users rows. Create dev users via the Supabase Auth Admin
-- API (or Supabase Dashboard) before seeding portfolios, holdings, trades, etc.
-- Seed order follows SCHEMA.md v2 dependency order.

-- 1. topics
INSERT INTO topics (id, slug, name, name_id, icon, color, display_order) VALUES
(gen_random_uuid(), 'money_basics', 'Money Basics', 'Dasar-Dasar Uang', 'wallet', '#10B981', 1),
(gen_random_uuid(), 'inflation', 'Inflation', 'Inflasi', 'trending-up', '#F59E0B', 2),
(gen_random_uuid(), 'budgeting', 'Budgeting', 'Anggaran', 'calculator', '#3B82F6', 3),
(gen_random_uuid(), 'risk_return', 'Risk & Return', 'Risiko dan Pengembalian', 'scale', '#8B5CF6', 4),
(gen_random_uuid(), 'idx_basics', 'IDX Basics', 'Dasar-Dasar IDX', 'chart-bar', '#EC4899', 5);

-- 2. levels
INSERT INTO levels (id, name, name_id, xp_required, badge_icon, description) VALUES
(1, 'Newbie', 'Pemula', 0, '🌱', 'Just getting started with money basics'),
(2, 'Apprentice', 'Pemula Lanjut', 100, '🪙', 'Completing first lessons and building habits'),
(3, 'Saver', 'Penabung', 250, '🐖', 'Understanding saving and inflation'),
(4, 'Budgeter', 'Perencana', 500, '📒', 'Building and sticking to a budget'),
(5, 'Investor', 'Investor', 900, '📈', 'Entering the world of risk and return'),
(6, 'Trader', 'Trader', 1500, '⚖️', 'Making informed paper trades'),
(7, 'Analyst', 'Analis', 2400, '🔍', 'Reading market data and sources critically'),
(8, 'Strategist', 'Strategis', 3700, '🧠', 'Diversifying and managing risk'),
(9, 'Mentor', 'Mentor', 5500, '🏆', 'Helping friends learn finance'),
(10, 'Master', 'Master', 8000, '👑', 'Graduated with a strong financial mindset');

-- 3. badges
INSERT INTO badges (id, slug, name, name_id, description, description_id, icon, trigger_type, trigger_value) VALUES
(gen_random_uuid(), 'first_lesson', 'First Lesson', 'Pelajaran Pertama', 'Complete your first lesson', 'Selesaikan pelajaran pertamamu', '📚', 'lesson_complete', '{"count": 1}'::jsonb),
(gen_random_uuid(), 'three_day_streak', '3-Day Streak', 'Streak 3 Hari', 'Learn for 3 days in a row', 'Belajar 3 hari berturut-turut', '🔥', 'streak', '{"days": 3}'::jsonb),
(gen_random_uuid(), 'seven_day_streak', '7-Day Streak', 'Streak 7 Hari', 'Learn for 7 days in a row', 'Belajar 7 hari berturut-turut', '🚀', 'streak', '{"days": 7}'::jsonb),
(gen_random_uuid(), 'budget_beginner', 'Budget Beginner', 'Pemula Anggaran', 'Complete the Budgeting lesson', 'Selesaikan pelajaran Anggaran', '📒', 'lesson_complete', '{"lesson_slug": "budgeting"}'::jsonb),
(gen_random_uuid(), 'scam_spotter', 'Scam Spotter', 'Pendeteksi Penipuan', 'Complete the Money Basics lesson on fraud awareness', 'Selesaikan pelajaran Dasar Uang tentang waspada penipuan', '🛡️', 'lesson_complete', '{"lesson_slug": "money_basics"}'::jsonb),
(gen_random_uuid(), 'compound_wizard', 'Compound Wizard', 'Ahli Bunga Majemuk', 'Complete the Risk & Return lesson', 'Selesaikan pelajaran Risiko dan Pengembalian', '🧙', 'lesson_complete', '{"lesson_slug": "risk_return"}'::jsonb),
(gen_random_uuid(), 'diversification_defender', 'Diversification Defender', 'Pembela Diversifikasi', 'Hold at least 3 different stocks in your portfolio', 'Miliki minimal 3 saham berbeda di portofoliomu', '🧺', 'trade', '{"min_symbols": 3}'::jsonb),
(gen_random_uuid(), 'first_trade', 'First Trade', 'Transaksi Pertama', 'Execute your first paper trade', 'Lakukan transaksi paper trading pertamamu', '💱', 'trade', '{"count": 1}'::jsonb),
(gen_random_uuid(), 'first_friend', 'First Friend', 'Teman Pertama', 'Have a friend accept your invite', 'Undang teman dan dapatkan persetujuan', '🤝', 'social', '{"event": "friend_accepted"}'::jsonb),
(gen_random_uuid(), 'graduate', 'Graduate', 'Lulusan', 'Graduate by reaching the portfolio target', 'Lulus dengan mencapai target portofolio', '🎓', 'portfolio', '{"status": "graduated"}'::jsonb);

-- 4. sources
-- TIER 1 — OJK
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, publication_year, status) VALUES
(gen_random_uuid(), 'OJK-001', 'National Strategy on Indonesian Financial Literacy (SNLKI) 2021-2025', 'Strategi Nasional Literasi Keuangan Indonesia 2021-2025', 1, 'report', 'OJK', 'https://ojk.go.id/en/berita-dan-kegiatan/publikasi/Pages/National-Strategy-on-Indonesian-Financial-Literacy-(SNLKI)-2021---2025.aspx', 2021, 'verified'),
(gen_random_uuid(), 'OJK-002', 'OJK National Survey on Financial Literacy & Inclusion (SNLIK) 2025', 'Survei Nasional Literasi dan Inklusi Keuangan (SNLIK) 2025', 1, 'survey', 'OJK', 'https://ojk.go.id/id/Fungsi-Utama/Perilaku-Pelaku-Usaha-Jasa-Keuangan/SNLIK/Pages/SNLIK-2025.aspx', 2025, 'verified'),
(gen_random_uuid(), 'OJK-003', 'OJK Pocket Guide: Personal Financial Management', 'Buku Saku Pengelolaan Keuangan Pribadi', 1, 'guide', 'OJK', 'https://ojk.go.id/id/berita-dan-kegiatan/publikasi/Documents/Pages/Buku-Saku-Pengelolaan-Keuangan-Pribadi/Buku-Saku-Pengelolaan-Keuangan-Pribadi.pdf', 2023, 'needs_review'),
(gen_random_uuid(), 'OJK-004', 'OJK Education Portal — Capital Markets Module', 'Portal Edukasi OJK — Modul Pasar Modal', 1, 'website', 'OJK', 'https://ojk.go.id/id/kanal/pasar-modal/Pages/Investasi.aspx', 2024, 'needs_review'),
(gen_random_uuid(), 'OJK-005', 'OJK Financial Literacy Month 2025 Campaign', 'Bulan Literasi Keuangan (BLK) 2025', 1, 'report', 'OJK', 'https://ojk.go.id/en/berita-dan-kegiatan/siaran-pers/Pages/Expanding-Financial-Education-OJK-Launches-the-2025-Financial-Literacy-Month.aspx', 2025, 'needs_review'),
(gen_random_uuid(), 'OJK-006', 'OJK Pocket Guide: Understanding Investment Products', 'Buku Saku Mengenal Produk Investasi', 1, 'guide', 'OJK', 'https://ojk.go.id/id/berita-dan-kegiatan/publikasi/Pages/Buku-Saku-Literasi-Keuangan.aspx', 2023, 'needs_review'),
(gen_random_uuid(), 'OJK-007', 'OJK Consumer Protection — Recognizing Investment Fraud', 'Waspadai Investasi Bodong', 1, 'website', 'OJK', 'https://www.ojk.go.id/id/kanal/perbankan/Pages/Perlindungan-Konsumen.aspx', 2024, 'needs_review'),
(gen_random_uuid(), 'OJK-008', 'OJK TikTok @ojkindonesia', 'TikTok Resmi OJK Indonesia', 1, 'social', 'OJK', 'https://www.tiktok.com/@ojkindonesia', 2025, 'verified');

-- TIER 1 — Bank Indonesia
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, publication_year, status) VALUES
(gen_random_uuid(), 'BI-001', 'Bank Indonesia — About Inflation', 'Bank Indonesia — Tentang Inflasi', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/moneter/inflasi/Default.aspx', 2024, 'verified'),
(gen_random_uuid(), 'BI-002', 'Bank Indonesia — BI Rate', 'Bank Indonesia — Suku Bunga BI', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/moneter/tingkat-suku-bunga/Default.aspx', 2025, 'verified'),
(gen_random_uuid(), 'BI-003', 'Bank Indonesia Digital Financial Literacy Program', 'Program Literasi Keuangan Digital Bank Indonesia', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/fungsi-utama/sistem-pembayaran/Default.aspx', 2025, 'needs_review'),
(gen_random_uuid(), 'BI-004', 'Bank Indonesia Financial System Stability Review', 'Tinjauan Stabilitas Sistem Keuangan Bank Indonesia', 1, 'report', 'Bank Indonesia', 'https://www.bi.go.id/id/publikasi/laporan/Default.aspx', 2025, 'needs_review'),
(gen_random_uuid(), 'BI-005', 'Bank Indonesia — Exchange Rate (Nilai Tukar Rupiah)', 'Bank Indonesia — Nilai Tukar Rupiah', 1, 'website', 'Bank Indonesia', 'https://www.bi.go.id/id/statistik/informasi-kurs/Default.aspx', 2025, 'verified'),
(gen_random_uuid(), 'BI-006', 'Bank Indonesia Instagram @bankindonesia', 'Instagram Resmi Bank Indonesia', 1, 'social', 'Bank Indonesia', 'https://www.instagram.com/bankindonesia/', 2025, 'verified'),
(gen_random_uuid(), 'BI-007', 'Bank Indonesia — UMKM & Financial Inclusion Reports', 'Bank Indonesia — Laporan UMKM & Inklusi Keuangan', 1, 'report', 'Bank Indonesia', 'https://www.bi.go.id/id/publikasi/laporan/Default.aspx', 2024, 'needs_review');

-- TIER 1 — IDX
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, publication_year, status) VALUES
(gen_random_uuid(), 'IDX-001', 'IDX Academy — Investor Education Portal', 'Akademi Investor IDX', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/akademi-investor/', 2025, 'verified'),
(gen_random_uuid(), 'IDX-002', 'IDX Glossary of Capital Markets Terms', 'Glosarium Istilah Pasar Modal IDX', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/perusahaan-terdaftar/glossarium/', 2025, 'verified'),
(gen_random_uuid(), 'IDX-003', 'IDX Statistics — Market Data & Historical Prices', 'Statistik IDX — Data Pasar & Harga Historis', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/', 2026, 'verified'),
(gen_random_uuid(), 'IDX-004', 'IDX YouTube — Yuk Nabung Saham Series', 'YouTube IDX — Seri Yuk Nabung Saham', 1, 'video', 'IDX', 'https://www.youtube.com/c/IDXOfficial', 2025, 'verified'),
(gen_random_uuid(), 'IDX-005', 'IDX — Beginner Investment Guide', 'Panduan Investasi Pemula IDX', 1, 'guide', 'IDX', 'https://www.idx.co.id/id-id/investor/panduan-investasi/', 2024, 'needs_review'),
(gen_random_uuid(), 'IDX-006', 'New IDX Mobile App', 'Aplikasi New IDX Mobile', 1, 'website', 'IDX', 'https://apps.apple.com/app/new-idx-mobile/id1658695361', 2025, 'verified'),
(gen_random_uuid(), 'IDX-007', 'IDX Investor Protection — SIPF', 'Perlindungan Investor IDX — SIPF', 1, 'website', 'IDX', 'https://www.idx.co.id/id-id/investor/perlindungan-investor/', 2024, 'needs_review');

-- TIER 2 — Global Enrichment
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, isbn, publication_year, status, localization_notes) VALUES
(gen_random_uuid(), 'GLB-001', 'OECD PISA 2022 Financial Literacy Framework', 'OECD PISA 2022 Financial Literacy Framework', 2, 'report', 'OECD', 'https://www.oecd.org/pisa/publications/pisa-2022-results.htm', NULL, 2023, 'needs_review', 'Use IDR/Indonesian examples when citing'),
(gen_random_uuid(), 'GLB-002', 'World Bank Global Findex 2021 — Indonesia', 'World Bank Global Findex 2021 — Indonesia', 2, 'report', 'World Bank', 'https://globalfindex.worldbank.org/', NULL, 2021, 'needs_review', 'Localize to Indonesian banking context'),
(gen_random_uuid(), 'GLB-003', 'World Bank Indonesia Country Overview', 'World Bank Indonesia Country Overview', 2, 'report', 'World Bank', 'https://www.worldbank.org/en/country/indonesia/overview', NULL, 2023, 'needs_review', 'Localize to Indonesian macro context'),
(gen_random_uuid(), 'GLB-004', 'The Psychology of Money — Morgan Housel', 'The Psychology of Money — Morgan Housel', 2, 'book', 'Morgan Housel', NULL, '978-0857197689', 2020, 'needs_review', 'Replace USD examples with IDR equivalents'),
(gen_random_uuid(), 'GLB-005', 'I Will Teach You To Be Rich — Ramit Sethi', 'I Will Teach You To Be Rich — Ramit Sethi', 2, 'book', 'Ramit Sethi', NULL, '978-1523505746', 2019, 'needs_review', 'Adapt budgeting examples to Indonesian income levels'),
(gen_random_uuid(), 'GLB-006', 'Rich Dad Poor Dad — Kiyosaki (asset/liability concept ONLY)', 'Rich Dad Poor Dad — Kiyosaki (konsep aset/liabilitas)', 2, 'book', 'Robert Kiyosaki', NULL, '978-1612680194', 1997, 'needs_review', 'Use only asset/liability framing; localize to ID'),
(gen_random_uuid(), 'GLB-007', 'A Random Walk Down Wall Street — Malkiel', 'A Random Walk Down Wall Street — Malkiel', 2, 'book', 'Burton Malkiel', NULL, '978-0393358384', 2019, 'needs_review', 'Use IDX and Indonesian fund examples'),
(gen_random_uuid(), 'GLB-008', 'Tiny Habits — BJ Fogg (product design reference)', 'Tiny Habits — BJ Fogg', 2, 'book', 'BJ Fogg', NULL, '978-0358003328', 2019, 'needs_review', 'Apply habit-building to Indonesian financial routines'),
(gen_random_uuid(), 'GLB-009', 'Women''s World Banking — Indonesian Youth Financial Confidence', 'Women''s World Banking — Indonesian Youth Financial Confidence', 2, 'report', 'Women''s World Banking', 'https://www.womensworldbanking.org/', NULL, 2025, 'needs_review', 'Already Indonesia-focused; verify youth stats'),
(gen_random_uuid(), 'GLB-010', 'Frontiers in Education — Youth Financial Literacy Programs', 'Frontiers in Education — Youth Financial Literacy Programs', 2, 'report', 'Frontiers in Education', 'https://www.frontiersin.org/journals/education/articles/10.3389/feduc.2024.1397060/full', NULL, 2024, 'needs_review', 'Use Indonesian youth context when citing');

-- 5. lessons
INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction
) VALUES
(
  gen_random_uuid(),
  'money-basics-101',
  'Money Basics: Needs, Wants, and Fraud Alerts',
  'Dasar-Dasar Uang: Kebutuhan, Keinginan, dan Waspada Penipuan',
  (SELECT id FROM topics WHERE slug = 'money_basics'),
  1,
  'beginner',
  50,
  5,
  'Learn to separate needs from wants and spot common financial scams in Indonesia.',
  'Money is a tool for exchange. Before spending, ask: is this a need (kebutuhan) or a want (keinginan)? Scammers often promise guaranteed high returns with no risk. OJK warns the public to check licenses before investing.',
  'Budi receives Rp 500,000 pocket money. He needs Rp 200,000 for transport and lunch, but wants a new game skin for Rp 150,000. He also sees an Instagram ad promising "guaranteed 10% returns per week." Budi decides to cover needs first, save Rp 100,000, and reports the suspicious ad to OJK.',
  'Knowing needs vs. wants helps you avoid debt. Recognizing scams protects your savings and future.',
  'Thinking that all investments with high returns are safe. If it sounds too good to be true, it usually is.',
  '[
    {
      "question": "Which of these is a need (kebutuhan)?",
      "type": "multiple_choice",
      "options": ["New sneakers", "Daily lunch", "Latest smartphone", "Concert ticket"],
      "answer": "Daily lunch",
      "explanation": "Daily lunch is a basic need. The others are wants."
    },
    {
      "question": "An investment promises \"guaranteed\" 20% returns per month. What should you do first?",
      "type": "multiple_choice",
      "options": ["Invest immediately", "Check OJK registration/license", "Tell all friends", "Borrow money to invest more"],
      "answer": "Check OJK registration/license",
      "explanation": "OJK-regulated products must be licensed. Guaranteed high returns are a red flag for fraud."
    },
    {
      "question": "What is the safest first step before spending money?",
      "type": "multiple_choice",
      "options": ["Buy first, budget later", "Compare needs vs wants", "Use all savings", "Follow influencer advice"],
      "answer": "Compare needs vs wants",
      "explanation": "Separating needs from wants is the foundation of good money management."
    }
  ]'::jsonb,
  'Help the user understand needs vs wants and how to verify if an investment product is OJK-registered.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'budgeting-101',
  'Budgeting: The 50/30/20 Rule, Indonesian Style',
  'Anggaran: Aturan 50/30/20 ala Indonesia',
  (SELECT id FROM topics WHERE slug = 'budgeting'),
  2,
  'beginner',
  60,
  6,
  'Build a simple budget using the 50/30/20 framework adapted for Indonesian students.',
  'A budget is a plan for your money. The 50/30/20 rule suggests 50% for needs, 30% for wants, and 20% for savings and debt. In Indonesia, you might adjust this based on living costs and family contributions.',
  'Ani earns Rp 2,000,000 per month from part-time work. She allocates Rp 1,000,000 for needs (transport, food, phone), Rp 600,000 for wants (streaming, hangouts), and Rp 400,000 for savings and paying off a small debt to her brother.',
  'Budgeting turns vague anxiety into a clear plan. It helps you save for goals and avoid borrowing impulsively.',
  'Creating a perfect budget but never tracking actual spending. A budget only works if you review it.',
  '[
    {
      "question": "In the 50/30/20 budget, what does the 20% cover?",
      "type": "multiple_choice",
      "options": ["Needs", "Wants", "Savings and debt", "Investments only"],
      "answer": "Savings and debt",
      "explanation": "20% is for savings and paying off debt, while 50% covers needs and 30% covers wants."
    },
    {
      "question": "Ani earns Rp 2,000,000. How much should she aim to save or use for debt?",
      "type": "multiple_choice",
      "options": ["Rp 200,000", "Rp 400,000", "Rp 600,000", "Rp 1,000,000"],
      "answer": "Rp 400,000",
      "explanation": "20% of Rp 2,000,000 is Rp 400,000 for savings and debt."
    },
    {
      "question": "Why is tracking actual spending important?",
      "type": "multiple_choice",
      "options": ["It makes money grow automatically", "It shows if your budget matches reality", "It is required by OJK", "It replaces the need for savings"],
      "answer": "It shows if your budget matches reality",
      "explanation": "Tracking spending reveals whether your plan is realistic and where adjustments are needed."
    }
  ]'::jsonb,
  'Guide the user to build a realistic 50/30/20 budget using Indonesian rupiah examples and local costs.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'inflation-101',
  'Inflation: Why Your Rupiah Buys Less Over Time',
  'Inflasi: Mengapa Rupiahmu Membeli Lebih Sedikit dari Waktu ke Waktu',
  (SELECT id FROM topics WHERE slug = 'inflation'),
  3,
  'beginner',
  60,
  6,
  'Understand inflation, BI''s inflation target, and why saving alone may not protect purchasing power.',
  'Inflation is the general increase in prices over time. Bank Indonesia targets inflation around 2.5% ± 1%. If your savings earn less than inflation, your purchasing power falls.',
  'In 2020, a bowl of mie ayam cost Rp 12,000. In 2025, the same bowl costs Rp 16,000. If Rina kept her money in a savings account paying 2% while inflation averaged 4%, her money buys fewer mie ayam today.',
  'Inflation affects every financial decision. Understanding it helps you choose savings and investments that preserve value.',
  'Keeping all money in cash for long-term goals. Cash loses value when inflation is higher than interest.',
  '[
    {
      "question": "What is inflation?",
      "type": "multiple_choice",
      "options": ["A decrease in prices", "A general increase in prices over time", "A type of bank account", "A government tax"],
      "answer": "A general increase in prices over time",
      "explanation": "Inflation means prices rise and purchasing power falls."
    },
    {
      "question": "Bank Indonesia''s inflation target is roughly:",
      "type": "multiple_choice",
      "options": ["0%", "2.5% ± 1%", "10%", "50%"],
      "answer": "2.5% ± 1%",
      "explanation": "BI targets low and stable inflation around 2.5% ± 1%."
    },
    {
      "question": "If inflation is 4% and your savings account pays 2%, what happens to purchasing power?",
      "type": "multiple_choice",
      "options": ["It stays the same", "It grows by 6%", "It falls", "It doubles"],
      "answer": "It falls",
      "explanation": "When inflation exceeds your savings rate, your real purchasing power declines."
    }
  ]'::jsonb,
  'Explain inflation using BI''s target and Indonesian food/price examples. Avoid investment advice.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'risk-return-101',
  'Risk & Return: Time, Compounding, and Diversification',
  'Risiko dan Pengembalian: Waktu, Bunga Majemuk, dan Diversifikasi',
  (SELECT id FROM topics WHERE slug = 'risk_return'),
  4,
  'intermediate',
  75,
  8,
  'Explore the relationship between risk and return, the power of compounding, and the role of diversification.',
  'Higher potential returns usually come with higher risk. Compounding means earning returns on your returns. Diversification spreads risk across different assets so one loss does not wipe you out.',
  'Dewi invests Rp 1,000,000 in a diversified portfolio that averages 8% per year. After 10 years, compounding grows it to about Rp 2,160,000. Her friend Eko keeps the same amount in cash; it still buys less because of inflation.',
  'Time and diversification are the strongest tools for young investors. Starting early gives compounding more time to work.',
  'Chasing the highest-return asset without considering risk. All-in on one stock or crypto can lead to large losses.',
  '[
    {
      "question": "What is the general relationship between risk and return?",
      "type": "multiple_choice",
      "options": ["Higher risk usually means higher potential return", "Higher risk means guaranteed higher return", "Risk and return are unrelated", "Lower risk always beats inflation"],
      "answer": "Higher risk usually means higher potential return",
      "explanation": "Investors demand higher potential returns for taking on more risk."
    },
    {
      "question": "What is compounding?",
      "type": "multiple_choice",
      "options": ["Earning returns only on the original amount", "Earning returns on both original amount and past returns", "Paying fees every year", "A type of tax"],
      "answer": "Earning returns on both original amount and past returns",
      "explanation": "Compounding accelerates growth because you earn returns on accumulated returns."
    },
    {
      "question": "Why is diversification important?",
      "type": "multiple_choice",
      "options": ["It guarantees profit", "It eliminates all risk", "It reduces the impact of one investment failing", "It is required by BI"],
      "answer": "It reduces the impact of one investment failing",
      "explanation": "Diversification spreads investments across assets so a single loss has less impact."
    }
  ]'::jsonb,
  'Explain risk/return trade-offs, compounding, and diversification using Indonesian rupiah examples. No specific product recommendations.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
),
(
  gen_random_uuid(),
  'idx-basics-101',
  'IDX Basics: How the Indonesian Stock Market Works',
  'Dasar-Dasar IDX: Cara Kerja Pasar Saham Indonesia',
  (SELECT id FROM topics WHERE slug = 'idx_basics'),
  5,
  'intermediate',
  75,
  8,
  'Learn what IDX is, how stocks trade, and what protections exist for Indonesian retail investors.',
  'IDX (Bursa Efek Indonesia) is the national stock exchange. Companies list shares so investors can own a small part of them. Prices move based on supply and demand. SIPF provides investor protection for listed securities.',
  'PT Bank Central Asia (BBCA) is listed on IDX. When you buy 1 lot (100 shares) of BBCA, you become a partial owner of the bank. You can track the price daily on the IDX website or app.',
  'Understanding IDX helps young Indonesians invest in real companies rather than unregulated schemes.',
  'Confusing stock trading with gambling. Successful investing requires research, patience, and diversification.',
  '[
    {
      "question": "What does IDX stand for?",
      "type": "multiple_choice",
      "options": ["International Dollar Exchange", "Bursa Efek Indonesia", "Indonesian Debt Index", "Investment Development Xchange"],
      "answer": "Bursa Efek Indonesia",
      "explanation": "IDX is the Indonesia Stock Exchange, the country''s national stock exchange."
    },
    {
      "question": "How many shares are in 1 lot on IDX?",
      "type": "multiple_choice",
      "options": ["1 share", "10 shares", "100 shares", "1,000 shares"],
      "answer": "100 shares",
      "explanation": "On IDX, 1 lot equals 100 shares."
    },
    {
      "question": "Which organization helps protect investors on IDX?",
      "type": "multiple_choice",
      "options": ["SIPF", "BI Rate", "OJK Social Media", "World Bank"],
      "answer": "SIPF",
      "explanation": "The Securities Investor Protection Fund (SIPF) provides protection for investors in listed securities."
    }
  ]'::jsonb,
  'Introduce IDX, stock lots, and investor protection using IDX and OJK sources. Encourage research before trading.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
);

-- 6. lesson_sources
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order) VALUES
-- money_basics
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), (SELECT id FROM sources WHERE source_code = 'OJK-001'), 'primary', 'SNLKI 2021-2025', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), (SELECT id FROM sources WHERE source_code = 'OJK-003'), 'supporting', 'Buku Saku Pengelolaan Keuangan Pribadi', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), (SELECT id FROM sources WHERE source_code = 'OJK-007'), 'supporting', 'Waspadai Investasi Bodong', FALSE, 3),
-- budgeting
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'budgeting-101'), (SELECT id FROM sources WHERE source_code = 'OJK-003'), 'primary', 'Buku Saku Pengelolaan Keuangan Pribadi', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'budgeting-101'), (SELECT id FROM sources WHERE source_code = 'OJK-006'), 'supporting', 'Buku Saku Mengenal Produk Investasi', FALSE, 2),
-- inflation
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), (SELECT id FROM sources WHERE source_code = 'BI-001'), 'primary', 'Bank Indonesia — About Inflation', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), (SELECT id FROM sources WHERE source_code = 'BI-002'), 'supporting', 'Bank Indonesia — BI Rate', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), (SELECT id FROM sources WHERE source_code = 'BI-005'), 'supporting', 'Bank Indonesia — Exchange Rate', FALSE, 3),
-- risk_return
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), (SELECT id FROM sources WHERE source_code = 'OJK-006'), 'primary', 'Buku Saku Mengenal Produk Investasi', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), (SELECT id FROM sources WHERE source_code = 'GLB-004'), 'supporting', 'The Psychology of Money', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), (SELECT id FROM sources WHERE source_code = 'GLB-007'), 'further_reading', 'A Random Walk Down Wall Street', FALSE, 3),
-- idx_basics
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-001'), 'primary', 'IDX Academy', TRUE, 1),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-002'), 'supporting', 'IDX Glossary', FALSE, 2),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-005'), 'supporting', 'IDX Beginner Investment Guide', FALSE, 3),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), (SELECT id FROM sources WHERE source_code = 'IDX-007'), 'supporting', 'IDX Investor Protection — SIPF', FALSE, 4);

-- 7. lesson_reviews
INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish) VALUES
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'money-basics-101'), 'Dewi Santoso', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Aligned with OJK SNLKI and consumer protection messaging.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'budgeting-101'), 'Dewi Santoso', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Uses Indonesian student income context; examples reviewed.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'inflation-101'), 'Rizky Pratama', 'Financial Reviewer', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'BI inflation target and rupiah examples verified.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'risk-return-101'), 'Rizky Pratama', 'Financial Reviewer', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'No product recommendations; general education only.', TRUE),
(gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'idx-basics-101'), 'Aisha Wijaya', 'Compliance Reviewer', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'IDX and SIPF references verified; no forward-looking claims.', TRUE);

-- 8. market_data
INSERT INTO market_data (id, symbol, company_name, trade_date, open_price, high_price, low_price, close_price, volume, source_url) VALUES
(gen_random_uuid(), 'BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '4 days', 8450.00, 8620.00, 8400.00, 8550.00, 45000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'BBCA', 'Bank Central Asia Tbk', CURRENT_DATE - INTERVAL '3 days', 8580.00, 8700.00, 8520.00, 8650.00, 48000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 4120.00, 4190.00, 4080.00, 4150.00, 62000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'BBRI', 'Bank Rakyat Indonesia Tbk', CURRENT_DATE - INTERVAL '3 days', 4160.00, 4220.00, 4130.00, 4200.00, 58000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 3680.00, 3750.00, 3650.00, 3720.00, 35000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'TLKM', 'Telkom Indonesia Tbk', CURRENT_DATE - INTERVAL '3 days', 3730.00, 3780.00, 3700.00, 3750.00, 33000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '4 days', 102.00, 108.00, 100.00, 105.00, 1200000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'GOTO', 'GoTo Gojek Tokopedia Tbk', CURRENT_DATE - INTERVAL '3 days', 106.00, 112.00, 104.00, 110.00, 1350000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '4 days', 6450.00, 6520.00, 6400.00, 6480.00, 18000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/'),
(gen_random_uuid(), 'UNVR', 'Unilever Indonesia Tbk', CURRENT_DATE - INTERVAL '3 days', 6500.00, 6580.00, 6450.00, 6550.00, 19000000, 'https://www.idx.co.id/id-id/data-pasar/ringkasan-perdagangan/ringkasan-saham/');

-- 9. brokerage_recommendations
INSERT INTO brokerage_recommendations (id, slug, name, description, url, logo_url, risk_level, ojk_registered, product_types, display_order, is_active) VALUES
(gen_random_uuid(), 'bibit', 'Bibit', 'Robo-advisor app for mutual funds and government bonds, beginner-friendly.', 'https://bibit.id', 'https://bibit.id/logo.png', 'beginner', TRUE, ARRAY['mutual_fund','government_bond','money_market'], 1, TRUE),
(gen_random_uuid(), 'ajaib', 'Ajaib', 'All-in-one stock and mutual fund investing platform.', 'https://ajaib.co.id', 'https://ajaib.co.id/logo.png', 'intermediate', TRUE, ARRAY['stock','mutual_fund','ETF'], 2, TRUE),
(gen_random_uuid(), 'stockbit', 'Stockbit', 'Social investing platform with IDX stock trading and community insights.', 'https://stockbit.com', 'https://stockbit.com/logo.png', 'intermediate', TRUE, ARRAY['stock','mutual_fund','ETF'], 3, TRUE),
(gen_random_uuid(), 'ipot', 'IPOT', 'Online trading platform from Indo Premier Sekuritas.', 'https://www.indopremier.com/ipot', 'https://www.indopremier.com/logo.png', 'intermediate', TRUE, ARRAY['stock','mutual_fund','bond'], 4, TRUE),
(gen_random_uuid(), 'bareksa', 'Bareksa', 'Indonesia''s largest mutual fund marketplace.', 'https://bareksa.com', 'https://bareksa.com/logo.png', 'beginner', TRUE, ARRAY['mutual_fund','government_bond','money_market'], 5, TRUE);
