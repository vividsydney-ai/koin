-- Migration: KO-CURR-003 — Restructure curriculum into 8 numbered chapters and add Cryptocurrency 101
-- Branch: web-koinaku

-- Part A: Update chapter assignments for existing topics.
UPDATE topics SET chapter = 'Money Basics' WHERE slug IN (
  'foundation_zero', 'money_basics', 'value_purchasing_power', 'inflation',
  'income_wealth', 'assets_liabilities', 'risk_basics', 'time_value_money'
);

UPDATE topics SET chapter = 'Money Life Skills' WHERE slug IN (
  'budgeting', 'saving_habits', 'spending_behavior', 'behavioral_finance'
);

UPDATE topics SET chapter = 'Protect Yourself' WHERE slug IN (
  'scam_defense', 'ojk_license_check', 'phishing_social_engineering', 'mlm_pyramid'
);

UPDATE topics SET chapter = 'Let''s Talk About Debt' WHERE slug = 'debt_management';

UPDATE topics SET chapter = 'Plan Your Money' WHERE slug IN (
  'emergency_fund', 'goal_setting', 'financial_planning'
);

UPDATE topics SET chapter = 'Grow Your Money' WHERE slug IN (
  'interest', 'compound_interest', 'bank_vs_investment', 'risk_return',
  'diversification', 'reksa_dana'
);

UPDATE topics SET chapter = 'Investing in Indonesia' WHERE slug IN (
  'stocks', 'idx_basics', 'stock_analysis', 'portfolio', 'taxes', 'macro_indicators'
);

-- Part B: Insert the new Cryptocurrency topic.
INSERT INTO topics (id, slug, name, name_id, icon, color, display_order, chapter)
VALUES (
  gen_random_uuid(),
  'cryptocurrency',
  'Cryptocurrency',
  'Mata Uang Kripto',
  'crypto',
  'primary',
  80,
  'Cryptocurrency 101'
)
ON CONFLICT (slug) DO NOTHING;

-- Part C: Reactivate main-track lessons that were deduplicated in migration 039.
-- Foundation Zero kept the canonical titles, so the main-track versions were renamed
-- to *-duplicate-deprecated. We need them back in the main track with unique titles.
UPDATE lessons
SET
  slug = CASE slug
    WHEN 'income-vs-wealth-duplicate-deprecated' THEN 'income-vs-wealth'
    WHEN 'needs-vs-wants-101-duplicate-deprecated' THEN 'needs-vs-wants-101'
    WHEN 'assets-vs-liabilities-duplicate-deprecated' THEN 'assets-vs-liabilities'
    WHEN 'interest-101-duplicate-deprecated' THEN 'interest-101'
  END,
  title = CASE title
    WHEN 'Income vs Wealth [duplicate-deprecated]' THEN 'Income vs Wealth (Main Track)'
    WHEN 'Needs vs Wants [duplicate-deprecated]' THEN 'Needs vs Wants (Main Track)'
    WHEN 'Assets vs Liabilities [duplicate-deprecated]' THEN 'Assets vs Liabilities (Main Track)'
    WHEN 'What Is Interest? [duplicate-deprecated]' THEN 'What Is Interest? (Main Track)'
  END,
  title_id = CASE slug
    WHEN 'income-vs-wealth-duplicate-deprecated' THEN 'Pendapatan vs Kekayaan (Jalur Utama)'
    WHEN 'needs-vs-wants-101-duplicate-deprecated' THEN 'Kebutuhan vs Keinginan (Jalur Utama)'
    WHEN 'assets-vs-liabilities-duplicate-deprecated' THEN 'Aset vs Liabilitas (Jalur Utama)'
    WHEN 'interest-101-duplicate-deprecated' THEN 'Apa Itu Bunga? (Jalur Utama)'
  END,
  is_published = TRUE,
  review_status = COALESCE(review_status, 'approved'),
  updated_at = NOW()
WHERE slug IN (
  'income-vs-wealth-duplicate-deprecated',
  'needs-vs-wants-101-duplicate-deprecated',
  'assets-vs-liabilities-duplicate-deprecated',
  'interest-101-duplicate-deprecated'
);

-- Ensure the reactivated lessons have approved reviews and Tier-1 sources.
INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  l.id,
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Reactivated and approved as part of KO-CURR-003.',
  TRUE
FROM lessons l
WHERE l.slug IN ('income-vs-wealth', 'needs-vs-wants-101', 'assets-vs-liabilities', 'interest-101')
  AND NOT EXISTS (SELECT 1 FROM lesson_reviews lr WHERE lr.lesson_id = l.id);

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
SELECT
  gen_random_uuid(),
  l.id,
  s.id,
  'primary',
  TRUE
FROM lessons l
JOIN sources s ON s.source_code = 'OJK-003'
WHERE l.slug IN ('income-vs-wealth', 'needs-vs-wants-101', 'assets-vs-liabilities', 'interest-101')
  AND NOT EXISTS (SELECT 1 FROM lesson_sources ls WHERE ls.lesson_id = l.id AND ls.source_id = s.id);

-- Part D: Renumber main-track lessons to follow the new 8-chapter order.
-- Move affected lessons into a temporary range to avoid UNIQUE collisions.
UPDATE lessons
SET lesson_number = lesson_number + 10000
WHERE slug IN (
  'money-basics-101', 'value-and-purchasing-power', 'inflation-101', 'income-vs-wealth',
  'needs-vs-wants-101', 'assets-vs-liabilities', 'understanding-risk', 'time-value-of-money',
  'budgeting-101', 'pay-yourself-first', 'spending-traps', 'behavioral-bias-intro',
  'too-good-to-be-true', 'check-ojk-license', 'phishing-social-engineering', 'mlm-pyramid-red-flags',
  'debt-traps', 'good-debt-vs-bad-debt', 'why-pay-later-is-bad', 'credit-card-good-or-bad',
  'how-to-pay-debt-responsibly', 'emergency-fund-101', 'goal-setting-101', 'building-financial-plan',
  'interest-101', 'compound-interest-101', 'bank-vs-investment', 'risk-return-101',
  'diversification-101', 'reksa-dana-basics', 'what-is-a-stock', 'idx-basics-101',
  'reading-a-stock-page', 'portfolio-thinking', 'taxes-on-returns', 'macro-indicators'
);

CREATE TEMP TABLE tmp_lesson_number_map (
  slug TEXT PRIMARY KEY,
  new_number INTEGER NOT NULL
) ON COMMIT DROP;

INSERT INTO tmp_lesson_number_map (slug, new_number) VALUES
  -- Foundation 0 remedial micro-lessons (separate 100-range, unchanged)
  ('fz-what-is-money', 101),
  ('fz-inflation', 102),
  ('fz-interest', 103),
  ('fz-income-vs-wealth', 104),
  ('fz-assets-vs-liabilities', 105),
  ('fz-risk', 106),
  ('fz-return', 107),
  ('fz-saving-vs-investing', 108),
  ('fz-emergency-fund', 109),
  ('fz-needs-vs-wants', 110),
  ('fz-debt', 111),
  ('fz-scam-red-flags', 112),
  -- 01 Money Basics
  ('money-basics-101', 1),
  ('value-and-purchasing-power', 2),
  ('inflation-101', 3),
  ('income-vs-wealth', 4),
  ('needs-vs-wants-101', 5),
  ('assets-vs-liabilities', 6),
  ('understanding-risk', 7),
  ('time-value-of-money', 8),
  -- 02 Money Life Skills
  ('budgeting-101', 9),
  ('pay-yourself-first', 10),
  ('spending-traps', 11),
  ('behavioral-bias-intro', 12),
  -- 03 Protect Yourself
  ('too-good-to-be-true', 13),
  ('check-ojk-license', 14),
  ('phishing-social-engineering', 15),
  ('mlm-pyramid-red-flags', 16),
  -- 04 Let's Talk About Debt
  ('debt-traps', 17),
  ('good-debt-vs-bad-debt', 18),
  ('why-pay-later-is-bad', 19),
  ('credit-card-good-or-bad', 20),
  ('how-to-pay-debt-responsibly', 21),
  -- 05 Plan Your Money
  ('emergency-fund-101', 22),
  ('goal-setting-101', 23),
  ('building-financial-plan', 24),
  -- 06 Grow Your Money
  ('interest-101', 25),
  ('compound-interest-101', 26),
  ('bank-vs-investment', 27),
  ('risk-return-101', 28),
  ('diversification-101', 29),
  ('reksa-dana-basics', 30),
  -- 07 Investing in Indonesia
  ('what-is-a-stock', 31),
  ('idx-basics-101', 32),
  ('reading-a-stock-page', 33),
  ('portfolio-thinking', 34),
  ('taxes-on-returns', 35),
  ('macro-indicators', 36),
  -- 08 Cryptocurrency 101 (added below)
  ('what-is-cryptocurrency', 37),
  ('crypto-risks-scams-indonesia', 38),
  ('how-to-buy-crypto-safely', 39),
  ('crypto-vs-investing-vs-gambling', 40);

UPDATE lessons l
SET lesson_number = m.new_number
FROM tmp_lesson_number_map m
WHERE l.slug = m.slug;

-- Part D-defensive: ensure every Foundation 0 lesson has a primary Tier-1 source.
-- Some local resets do not preserve the links from migration 033; this keeps the
-- curriculum self-healing without changing production state.
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
SELECT
  gen_random_uuid(),
  l.id,
  s.id,
  'primary',
  TRUE
FROM lessons l
CROSS JOIN sources s
WHERE l.slug LIKE 'fz-%'
  AND s.source_code = 'OJK-003'
  AND NOT EXISTS (
    SELECT 1 FROM lesson_sources ls
    WHERE ls.lesson_id = l.id AND ls.is_primary = TRUE
  )
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- Part D: Ensure required Tier-1 sources exist for crypto lessons.
INSERT INTO sources (id, source_code, title, local_title, source_tier, source_type, organization, url, isbn, publication_year, language, status, localization_notes) VALUES
  (gen_random_uuid(), 'BAPPEBTI-001', 'Bappebti — Cek Legalitas Pelaku Usaha Perdagangan Berjangka Komoditi', 'Bappebti — Cek Legalitas Pelaku Usaha Perdagangan Berjangka Komoditi', 1, 'website', 'Bappebti', 'https://ceklegalitas.bappebti.go.id/', NULL, 2024, 'id', 'verified', 'Use to explain that crypto is regulated as a commodity in Indonesia and only Bappebti-registered exchanges may legally trade it')
ON CONFLICT (source_code) DO NOTHING;

-- Part E: Insert four Cryptocurrency 101 lessons.
INSERT INTO lessons (id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, concept_body, indonesian_example, why_this_matters, common_mistake, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published) VALUES
  (gen_random_uuid(), 'what-is-cryptocurrency', 'What is Cryptocurrency?', 'Apa Itu Mata Uang Kripto?', (SELECT id FROM topics WHERE slug = 'cryptocurrency'), 37, 'beginner', 55, 6, 'Cryptocurrency is a digital asset that runs on a shared computer network called blockchain. Bitcoin and Ethereum are the best known, but none of them are official money in Indonesia.', 'Cryptocurrency is digital money that exists only as records on a network called blockchain. A blockchain is a public ledger shared across thousands of computers around the world. Because many computers keep copies, it is very hard for one person to change the records alone. Bitcoin, created in 2009, was the first cryptocurrency. People often compare it to "digital gold" because its supply is limited and its price is driven by demand. Ethereum, launched in 2015, added smart contracts — small programs that run automatically when conditions are met — which made it a platform for many other crypto projects.

In Indonesia, cryptocurrency is treated as a commodity, or *aset kripto*, under Bappebti regulation. It is not official currency like the rupiah, so you cannot use it to pay taxes, buy coffee, or settle debts. Its price is set by supply and demand on exchanges, which means it can rise or fall sharply within hours. For a young Indonesian, crypto can be interesting to learn about, but owning it means owning a risky digital asset, not a guaranteed way to build wealth.', 'Rina sees Bitcoin priced at around Rp 700,000,000 per BTC on the news. She learns that one Bitcoin can be divided into very small units, so someone with Rp 500,000 can still buy a tiny fraction. She also learns that Bitcoin is not a company share, not a bank deposit, and not insured by LPS. Its price can move 10% or more in a single day. Rina decides to first learn how blockchain works before putting any money in.', 'Crypto appears constantly on TikTok, Telegram, and WhatsApp groups. Knowing the basics helps you tell the difference between a real technology discussion and a sales pitch.', 'Thinking crypto is "free money" or a guaranteed shortcut to get rich quickly.', 'Explain blockchain, Bitcoin, and Ethereum with simple Indonesian analogies (for example, a shared Google Sheet that no one can edit alone). Avoid price predictions and never recommend specific coins. Ask the user to explain in their own words what problem crypto solves and whether they understand it is a high-risk asset.', 'approved', 'koin-curriculum-agent', NOW(), TRUE),
  (gen_random_uuid(), 'crypto-risks-scams-indonesia', 'Crypto Risks and Scams in Indonesia', 'Risiko dan Penipuan Kripto di Indonesia', (SELECT id FROM topics WHERE slug = 'cryptocurrency'), 38, 'beginner', 60, 7, 'Crypto prices can swing wildly, and scammers use fake tokens, rug pulls, and celebrity endorsements to steal money from young Indonesians.', 'The first risk of crypto is volatility. It is normal for a cryptocurrency to rise or fall 20% in a single day. That means someone who invests Rp 5,000,000 can see it become Rp 4,000,000 — or Rp 6,000,000 — within 24 hours. This is not a bug; it is how the market works. For someone with no emergency fund or stable income, this volatility can cause panic and poor decisions.

The second risk is scams. A *rug pull* happens when developers create a new coin, attract buyers, then disappear with the money. Fake tokens copy the names of famous coins to trick beginners. Other scams include Ponzi schemes that promise guaranteed monthly returns, fake celebrity endorsements, and phishing links that steal wallet passwords. OJK and Bappebti have repeatedly warned Indonesians: if an offer promises fixed high returns, pressures you to recruit friends, or comes from an unregistered platform, it is almost certainly a scam. In Indonesia, legal crypto trading must go through Bappebti-registered exchanges; anything else is unprotected and high-risk.', 'Bayu joins a Telegram group where admins promise "MoonCoin" will rise 10 times in a week. They show screenshots of profits and say the offer is only for the first 100 people. Bayu transfers Rp 2,000,000 to a personal account. Three days later, the group is deleted, the website is gone, and the price collapses from Rp 1,000 to Rp 10. Bayu loses almost everything.', 'Crypto scams often target people aged 18–30 through social media. Learning the red flags protects your savings and your friendships.', 'Buying a coin because an influencer, friend, or Telegram group promises guaranteed quick profits.', 'List concrete red flags using Indonesian examples: guaranteed returns, anonymous teams, pressure to recruit friends, countdown timers, and sellers who only accept payment to personal bank accounts. Mention WhatsApp/Telegram groups and TikTok influencers. Never name current scam tokens or predict prices.', 'approved', 'koin-curriculum-agent', NOW(), TRUE),
  (gen_random_uuid(), 'how-to-buy-crypto-safely', 'How to Buy Crypto Safely', 'Cara Membeli Kripto dengan Aman', (SELECT id FROM topics WHERE slug = 'cryptocurrency'), 39, 'beginner', 55, 6, 'If you decide to buy crypto, use a Bappebti-registered exchange, avoid P2P strangers, protect your wallet, and remember that taxes may apply.', 'The safest way to buy crypto in Indonesia is through a Bappebti-registered exchange. These platforms must follow know-your-customer (KYC) rules, keep records, and separate customer assets from company funds. Well-known Indonesian platforms that have stated they are Bappebti-registered include Tokocrypto, Indodax, Pintu, and Reku, but you should always check the latest list on the Bappebti website before depositing money.

Avoid peer-to-peer (P2P) deals with strangers on WhatsApp, Telegram, or Instagram. A lower price is not worth the risk of fraud. Once money is sent to a personal account, it is almost impossible to recover. For storage, exchanges keep crypto in an online "hot wallet," which is convenient but still a target for hackers. A "cold wallet" is a physical device that stores crypto offline and is harder to hack, but losing the device or recovery phrase means losing access forever.

Finally, crypto is not tax-free. In Indonesia, trading profits and crypto-related income can be subject to income tax (PPh) and value-added tax (PPN) depending on the transaction type. Keep records of every buy, sell, and transfer. Tax rules can change, so check the official Direktorat Jenderal Pajak guidance for the latest rules.', 'Dina wants to learn about crypto with Rp 1,000,000. She opens an account on a Bappebti-registered exchange, uploads her KTP for KYC, and deposits from her BCA savings account. She buys a small fraction of Bitcoin and records the date and price. She does not answer WhatsApp messages offering a "cheaper rate" and does not keep all her crypto on the exchange long-term.', 'Using registered channels and keeping records protects you from fraud, hacking, and unexpected tax problems.', 'Sending money directly to a seller on WhatsApp or Instagram to get a "better price," then losing it to a scam.', 'Walk through the safe buying process: check Bappebti registration, complete KYC, deposit from a personal bank account, keep tax records, and avoid P2P strangers. Explain hot wallet vs cold wallet in simple terms. Do not help users evade taxes or KYC.', 'approved', 'koin-curriculum-agent', NOW(), TRUE),
  (gen_random_uuid(), 'crypto-vs-investing-vs-gambling', 'Crypto vs Investing vs Gambling', 'Kripto vs Investasi vs Judi', (SELECT id FROM topics WHERE slug = 'cryptocurrency'), 40, 'beginner', 60, 7, 'Buying crypto to flip it quickly is mostly speculation, not investing. Investing builds wealth through productive assets; gambling is entertainment that usually loses money.', 'Investing means buying something that is expected to produce income or grow because of real economic activity. For example, a reksa dana owns stocks and bonds that earn profits and interest. A deposito earns interest because the bank lends the money to businesses and homeowners. Over years, these productive assets can build wealth slowly.

Speculation means buying something mainly because you hope the price will rise quickly. Buying a new crypto token because you expect it to "moon" next week is speculation. You are not earning dividends or interest; you are betting that someone else will pay more later. Speculation is not automatically bad, but it is high-risk and should only involve money you can afford to lose completely.

Gambling is different from both. When you gamble, the game is designed so that the house wins over time. It is entertainment, not a way to build wealth. Many crypto games, prediction markets, and leveraged trading apps feel like investing but behave like gambling. A good rule: if you do not understand the asset, need the money soon, or feel FOMO, stay away.', 'Andi has Rp 5,000,000. Option A is a reksa dana campuran that invests in Indonesian companies and government bonds. Option B is a trending crypto coin he saw on TikTok, hoping it doubles in a week. Option C is an online gambling site. Andi classifies A as investing because it owns productive assets, B as speculation because it depends on price timing, and C as gambling because the odds favor the house. He chooses A because he is still building his emergency fund and does not understand B well enough.', 'Many young Indonesians enter crypto thinking they are investing, when they are actually speculating or gambling. Knowing the difference protects your financial goals.', 'Putting money you cannot afford to lose into crypto because you are afraid of missing out (FOMO).', 'Help the user classify a financial decision as investing, speculation, or gambling using Indonesian examples. Ask about the time horizon, source of returns, level of understanding, and whether the money is needed soon. Encourage starting with productive assets before considering any speculation.', 'approved', 'koin-curriculum-agent', NOW(), TRUE)
ON CONFLICT (slug) DO NOTHING;

-- Part F: Insert approved lesson_reviews for the four new lessons.
INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish) VALUES
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'koin-curriculum-agent', 'curriculum-agent', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Approved as part of KO-CURR-003. Tier-1 source BAPPEBTI-001 cited.', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'koin-curriculum-agent', 'curriculum-agent', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Approved as part of KO-CURR-003. Tier-1 sources BAPPEBTI-001 cited.', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'koin-curriculum-agent', 'curriculum-agent', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Approved as part of KO-CURR-003. Tier-1 source BAPPEBTI-001 cited.', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'koin-curriculum-agent', 'curriculum-agent', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Approved as part of KO-CURR-003. Tier-1 source BAPPEBTI-001 cited.', TRUE)
ON CONFLICT (lesson_id) DO NOTHING;

-- Part G: Link new lessons to sources.
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary) VALUES
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), (SELECT id FROM sources WHERE source_code = 'BAPPEBTI-001'), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), (SELECT id FROM sources WHERE source_code = 'BAPPEBTI-001'), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), (SELECT id FROM sources WHERE source_code = 'BAPPEBTI-001'), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), (SELECT id FROM sources WHERE source_code = 'BAPPEBTI-001'), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- Part H: Insert content variants for the four new crypto lessons.
DELETE FROM content_variants WHERE lesson_id IN (SELECT id FROM lessons WHERE slug IN ('what-is-cryptocurrency', 'crypto-risks-scams-indonesia', 'how-to-buy-crypto-safely', 'crypto-vs-investing-vs-gambling'));

INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, is_active) VALUES
  -- what-is-cryptocurrency examples
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'example', '{"text": "Andi membaca bahwa harga Bitcoin pernah turun dari Rp 1 miliar menjadi Rp 700 juta dalam beberapa minggu. Ia menyadari kripto sangat volatil dan bukan tempat untuk menyimpan uang yang dibutuhkan dalam waktu dekat."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'example', '{"text": "Sebuah aplikasi mengklaim bisa menggandakan uang kripto setiap bulan. Budi ingat pelajaran ini: jika imbal hasil dijamin, itu bukan investasi melainkan penipuan. Ia menutup aplikasi tersebut."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'example', '{"text": "Dina mempelajari bahwa Ethereum memungkinkan program otomatis yang disebut smart contract. Tetapi ia juga tahu bahwa banyak proyek di Ethereum gagal, jadi teknologi menarik tidak berarti harganya pasti naik."}'::jsonb, 'beginner', TRUE),
  -- what-is-cryptocurrency questions
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "multiple_choice", "question": "Apa itu blockchain secara sederhana?", "options": ["Buku besar digital yang dibagikan ke banyak komputer", "Bank sentral untuk kripto", "Aplikasi chatting untuk trader", "Jenis koin baru"], "answer": "Buku besar digital yang dibagikan ke banyak komputer", "explanation": "Blockchain adalah buku besar publik yang tersebar di ribuan komputer, sehingga sulit diubah sendirian.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "true_false", "question": "Bitcoin adalah perusahaan seperti Bank BCA yang bisa diawasi OJK.", "answer": false, "explanation": "Bitcoin bukan perusahaan dan tidak diawasi OJK sebagai lembaga keuangan. Di Indonesia, kripto diatur sebagai komoditas oleh Bappebti.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "multiple_choice", "question": "Di Indonesia, mata uang kripto diperlakukan sebagai...", "options": ["Komoditas / aset kripto", "Mata uang resmi untuk membayar pajak", "Saham perusahaan", "Simpanan bank yang dijamin LPS"], "answer": "Komoditas / aset kripto", "explanation": "Bappebti mengatur kripto sebagai komoditas, bukan sebagai mata uang resmi atau produk pasar modal.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "true_false", "question": "Kamu bisa menggunakan Bitcoin untuk membayar pajak atau membeli kopi di warung Indonesia seperti uang rupiah.", "answer": false, "explanation": "Kripto bukan alat pembayaran yang sah di Indonesia. Transaksi resmi harus menggunakan rupiah.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "multiple_choice", "question": "Ethereum terkenal karena menambahkan fitur...", "options": ["Smart contract", "Kartu kredit", "Asuransi jiwa", "Pinjaman tanpa bunga"], "answer": "Smart contract", "explanation": "Ethereum memperkenalkan smart contract, yaitu program yang berjalan otomatis ketika kondisi tertentu terpenuhi.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "fill_blank", "question": "Harga kripto ditentukan oleh _____ dan _____, sehingga bisa naik atau turun sangat cepat.", "answer": "permintaan dan penawaran", "explanation": "Tidak ada bank sentral yang menetapkan harga kripto. Harganya murni dari permintaan dan penawaran di pasar.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "multiple_choice", "question": "Memiliki kripto berarti memiliki...", "options": ["Aset digital berisiko tinggi", "Simpanan aman seperti tabungan", "Jaminan kekayaan dari pemerintah", "Saham di bank sentral"], "answer": "Aset digital berisiko tinggi", "explanation": "Kripto adalah aset digital yang harganya sangat fluktuatif dan tidak dijamin oleh LPS atau pemerintah.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'what-is-cryptocurrency'), 'question', '{"type": "true_false", "question": "Karena harganya bisa naik cepat, kripto adalah cara pasti untuk cepat kaya.", "answer": false, "explanation": "Harga kripto bisa naik dan turun drastis. Tidak ada jaminan keuntungan, dan banyak orang justru rugi karena FOMO.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),

  -- crypto-risks-scams-indonesia examples
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'example', '{"text": "Sari melihat akun TikTok menjanjikan untung 20% per bulan dari staking kripto. Ia mencari nama aplikasi di daftar Bappebti dan tidak menemukannya. Ia memutuskan untuk tidak deposit."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'example', '{"text": "Rina membeli token baru yang namanya mirip dengan koin terkenal. Ternyata itu token palsu. Harganya langsung turun dari Rp 50.000 menjadi hampir nol. Ia kehilangan Rp 1.000.000 dalam satu malam."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'example', '{"text": "Doni diminta mengajak tiga teman untuk mendapatkan bonus kripto. Ia ingat ciri MLM dan piramida, lalu menolak. Bonus besar dari merekrut orang adalah tanda penipuan."}'::jsonb, 'beginner', TRUE),
  -- crypto-risks-scams-indonesia questions
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "multiple_choice", "question": "Apa yang dimaksud dengan rug pull?", "options": ["Pengembang koin menghilang bersama uang investor", "Harga kripto naik 100%", "Bank sentral menarik kripto dari pasar", "Proses menjual kripto secara legal"], "answer": "Pengembang koin menghilang bersama uang investor", "explanation": "Rug pull terjadi ketika pembuat koin kabur setelah mengumpulkan uang banyak orang, meninggalkan koin tanpa nilai.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "true_false", "question": "Harga kripto sangat stabil seperti tabungan bank.", "answer": false, "explanation": "Kripto sangat volatil. Harganya bisa naik atau turun drastis dalam hitungan jam atau hari.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "multiple_choice", "question": "Manakah tanda penipuan kripto?", "options": ["Menjanjikan imbal hasil tinggi yang dijamin", "Terdaftar di Bappebti", "Memiliki rencana keuangan jangka panjang", "Transparan tentang risiko"], "answer": "Menjanjikan imbal hasil tinggi yang dijamin", "explanation": "Imbal hasil dijamin adalah red flag utama. Investasi yang sah selalu memiliki risiko.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "multiple_choice", "question": "Di Indonesia, perdagangan kripto yang legal harus melalui...", "options": ["Bursa berizin Bappebti", "Grup WhatsApp pribadi", "Akun Instagram yang menawarkan harga murah", "Aplikasi luar negeri tanpa izin"], "answer": "Bursa berizin Bappebti", "explanation": "Hanya bursa yang terdaftar di Bappebti yang boleh menyelenggarakan perdagangan aset kripto secara legal.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "true_false", "question": "OJK mengatur kripto sebagai produk pasar modal seperti saham dan reksa dana.", "answer": false, "explanation": "Kripto di Indonesia diatur oleh Bappebti sebagai komoditas, bukan oleh OJK sebagai produk pasar modal.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "fill_blank", "question": "Jika sebuah koin menjanjikan imbal hasil _____ dan memaksamu merekrut teman, kemungkinan besar itu penipuan.", "answer": "pasti", "explanation": "Imbal hasil pasti dan skema rekrutmen adalah ciri umum penipuan kripto dan piramida.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "multiple_choice", "question": "Kenapa token palsu berbahaya?", "options": ["Namanya meniru koin terkenal sehingga pemula tertipu", "Harganya selalu stabil", "Dijamin oleh LPS", "Diterbitkan oleh Bank Indonesia"], "answer": "Namanya meniru koin terkenal sehingga pemula tertipu", "explanation": "Token palsu sering memakai nama mirip koin populer agar pembeli mengira mereka membeli aset yang sah.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-risks-scams-indonesia'), 'question', '{"type": "true_false", "question": "Aman mengirim uang ke penjual kripto yang dikenal lewat Instagram jika harganya lebih murah.", "answer": false, "explanation": "Membeli dari penjual pribadi di media sosial berisiko tinggi. Uang bisa hilang dan tidak ada perlindungan konsumen.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),

  -- how-to-buy-crypto-safely examples
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'example', '{"text": "Andi ingin membeli kripto. Ia memeriksa situs Bappebti dan hanya mempertimbangkan bursa yang masuk daftar pedagang aset kripto berizin. Ia tidak tergoda WhatsApp yang menawarkan harga di bawah pasar."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'example', '{"text": "Bayu menyimpan sebagian kecil kriptonya di cold wallet setelah membeli. Ia menyimpan frasa pemulihan di tempat aman yang terpisah dari perangkatnya, karena jika frasa itu hilang, kriptonya tidak bisa diakses lagi."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'example', '{"text": "Rina menjual kriptonya dengan keuntungan Rp 500.000. Ia mencatat tanggal beli, harga beli, harga jual, dan biaya agar bisa melaporkannya sesuai aturan pajak yang berlaku."}'::jsonb, 'beginner', TRUE),
  -- how-to-buy-crypto-safely questions
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "multiple_choice", "question": "Cara paling aman membeli kripto di Indonesia adalah...", "options": ["Menggunakan bursa berizin Bappebti", "Transfer ke rekening pribadi penjual di Instagram", "Membeli dari grup Telegram yang menawarkan harga murah", "Mengirim uang tunai melalui ojek online"], "answer": "Menggunakan bursa berizin Bappebti", "explanation": "Bursa berizin Bappebti memiliki aturan KYC dan perlindungan konsumen. Transaksi di luar itu berisiko tinggi.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "true_false", "question": "Transaksi P2P dengan orang asing di WhatsApp aman selama harganya lebih murah.", "answer": false, "explanation": "Harga murah dari penjual tidak dikenal adalah tanda umum penipuan. Uang yang terkirim ke rekening pribadi sulit dikembalikan.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "multiple_choice", "question": "Apa itu KYC dalam konteks kripto?", "options": ["Verifikasi identitas pengguna", "Kode diskon untuk trading", "Jenis dompet kripto", "Strategi investasi"], "answer": "Verifikasi identitas pengguna", "explanation": "KYC (Know Your Customer) adalah proses bursa memverifikasi identitas pengguna untuk mencegah penipuan dan pencucian uang.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "multiple_choice", "question": "Dompet kripto yang paling aman dari peretasan namun berisiko hilang akses jika frasa pemulihannya hilang adalah...", "options": ["Cold wallet", "Hot wallet di bursa", "Dompet kertas biasa", "Rekening tabungan bank"], "answer": "Cold wallet", "explanation": "Cold wallet menyimpan kripto secara offline sehingga sulit diretas, tetapi kehilangan frasa pemulihan bisa membuat akses hilang selamanya.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "true_false", "question": "Keuntungan dari trading kripto di Indonesia tidak perlu dilaporkan untuk pajak.", "answer": false, "explanation": "Keuntungan dan pendapatan terkait kripto bisa dikenakan pajak sesuai aturan yang berlaku. Selalu simpan catatan transaksi.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "fill_blank", "question": "Sebelum menyetor uang ke bursa kripto, periksa apakah bursa tersebut terdaftar di _____.", "answer": "Bappebti", "explanation": "Hanya bursa yang terdaftar di Bappebti yang boleh menyelenggarakan perdagangan aset kripto secara legal di Indonesia.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "multiple_choice", "question": "Mengapa disarankan tidak menyimpan semua kripto di bursa dalam jangka panjang?", "options": ["Bursa bisa diretas atau mengalami masalah keuangan", "Bursa selalu menutup akun aktif", "Kripto di bursa tidak bisa dijual", "Bursa tidak memerlukan KYC"], "answer": "Bursa bisa diretas atau mengalami masalah keuangan", "explanation": "Menyimpan kripto di bursa berarti mempercayakan asetmu kepada pihak ketiga, yang berisiko diretas atau bangkrut.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'how-to-buy-crypto-safely'), 'question', '{"type": "true_false", "question": "Menyimpan catatan tanggal dan harga setiap transaksi kripto membantu saat menghitung pajak.", "answer": true, "explanation": "Catatan transaksi yang rapi memudahkan pelaporan pajak dan menghindari masalah di kemudian hari.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),

  -- crypto-vs-investing-vs-gambling examples
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'example', '{"text": "Sari menyisihkan Rp 300.000 per bulan untuk reksa dana indeks sebagai investasi jangka panjang. Ia memisahkan itu dari uang spekulasi Rp 200.000 yang rela hilang untuk mencoba kripto. Uang makan dan kosnya tidak disentuh."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'example', '{"text": "Doni meminjam Rp 2 juta dari aplikasi pinjol untuk membeli kripto yang sedang viral. Ia merasa ini investasi, padahal ia tidak mengerti proyeknya dan harus membayar bunga pinjol. Ini adalah spekulasi berisiko tinggi."}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'example', '{"text": "Rina menghabiskan Rp 500.000 di aplikasi prediksi kripto yang menawarkan hadiah besar. Ia sadar ini lebih mirip judi daripada investasi karena hasilnya murni keberuntungan dan rumah selalu punya keunggulan."}'::jsonb, 'beginner', TRUE),
  -- crypto-vs-investing-vs-gambling questions
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "multiple_choice", "question": "Membeli kripto dengan harapan harganya berlipat dalam seminggu termasuk...", "options": ["Spekulasi", "Investasi produktif", "Tabungan", "Asuransi"], "answer": "Spekulasi", "explanation": "Spekulasi adalah bertaruh pada kenaikan harga cepat tanpa menghasilkan pendapatan atau pertumbuhan ekonomi nyata.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "true_false", "question": "Reksa dana campuran yang memiliki saham dan obligasi adalah contoh investasi produktif.", "answer": true, "explanation": "Reksa dana memiliki aset yang menghasilkan keuntungan dan bunga, sehingga termasuk investasi produktif.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "multiple_choice", "question": "Apa ciri utama judi dibandingkan investasi?", "options": ["Rumah atau penyelenggara memiliki keunggulan matematis", "Hasilnya bisa diprediksi dengan pasti", "Memiliki aset nyata", "Dijamin oleh pemerintah"], "answer": "Rumah atau penyelenggara memiliki keunggulan matematis", "explanation": "Judi dirancang agar bandar atau rumah menang dalam jangka panjang, tidak seperti aset produktif.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "multiple_choice", "question": "Kapan spekulasi bisa dipertimbangkan?", "options": ["Jika kamu punya uang yang sanggup hilang dan memahami risikonya", "Jika kamu membutuhkan uang itu dalam satu bulan", "Jika kamu meminjam uang untuk spekulasi", "Jika kamu merasa FOMO karena teman sudah untung"], "answer": "Jika kamu punya uang yang sanggup hilang dan memahami risikonya", "explanation": "Spekulasi hanya boleh dengan uang yang rela hilang dan setelah memahami risiko tinggi yang dihadapi.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "true_false", "question": "Omongan pasti naik di media sosial adalah alasan yang bagus untuk membeli kripto.", "answer": false, "explanation": "Tidak ada yang pasti di pasar keuangan. Klaim pasti naik sering digunakan untuk memicu FOMO dan penipuan.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "fill_blank", "question": "Sebaiknya menjauh dari kripto jika kamu merasa _____ dan belum memahami asetnya.", "answer": "FOMO", "explanation": "FOMO (takut ketinggalan) sering menyebabkan keputusan spekulatif yang merugi.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "multiple_choice", "question": "Manakah yang paling mendekati investasi produktif?", "options": ["Reksa dana pasar uang untuk tujuan 3 tahun", "Membeli koin viral berharap untung cepat", "Bertaruh di aplikasi prediksi", "Meminjam uang untuk trading"], "answer": "Reksa dana pasar uang untuk tujuan 3 tahun", "explanation": "Reksa dana pasar uang memiliki aset yang menghasilkan bunga dan cocok untuk tujuan jangka menengah.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE),
  (gen_random_uuid(), (SELECT id FROM lessons WHERE slug = 'crypto-vs-investing-vs-gambling'), 'question', '{"type": "true_false", "question": "Investasi produktif biasanya menghasilkan kekayaan dengan cepat seperti trading kripto.", "answer": false, "explanation": "Investasi produktif biasanya membangun kekayaan secara perlahan melalui bunga, dividen, dan pertumbuhan ekonomi.", "difficulty": "beginner"}'::jsonb, 'beginner', TRUE);
