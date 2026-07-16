-- Migration: KO-FOUND-001 Foundation 0 "Money Dictionary" mini-track
-- Scope: 12 micro-lessons that teach pure financial terms before the main 32-lesson curriculum.
-- Idempotency: Uses ON CONFLICT for upserts.

BEGIN;

-- 1. Insert Foundation 0 topic.
INSERT INTO topics (id, slug, name, name_id, icon, color, display_order)
VALUES (
  gen_random_uuid(),
  'foundation_zero',
  'Foundation 0',
  'Dasar Keuangan',
  'book-open',
  '#10B981',
  1
)
ON CONFLICT (slug) DO NOTHING;

-- 2. Renumber existing main-track lessons to make room for Foundation 0 (1-12).
-- User progress references lesson_id, so changing lesson_number is safe.
-- Use +2000 as a temporary range because +1000 is already occupied by deactivated lessons.
UPDATE lessons
SET lesson_number = lesson_number + 2000
WHERE lesson_number BETWEEN 1 AND 32;

UPDATE lessons
SET lesson_number = lesson_number - 1987
WHERE lesson_number BETWEEN 2001 AND 2032;

-- 3. Insert 12 Foundation 0 micro-lessons (unpublished until assessment gating is wired in Slice 2).
INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  ai_assist_context, review_status, reviewed_by, reviewed_at, is_published
) VALUES
(
  gen_random_uuid(), 'fz-what-is-money', 'What Is Money?', 'Apa Itu Uang?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 1, 'beginner', 25, 2,
  'Money is a tool that makes trade, saving, and planning possible.',
  'Money is anything people commonly accept as payment for goods and services. In daily life, money plays three roles. First, it is a medium of exchange: instead of swapping your mie ayam for a phone charger directly, you use rupiah. Second, it is a store of value: money lets you save today and spend tomorrow. Third, it is a unit of account: it gives everything a price tag so you can compare values quickly.',
  'Budi wants to buy a Rp 15.000 notebook. He does not need to trade his lunch for it; he hands over a Rp 20.000 note and receives Rp 5.000 back. The seller accepts rupiah because everyone agrees it has value. That agreement is what makes money work.',
  'If you do not understand what money actually is, every financial decision feels like magic or luck. Once you see money as a tool, you can start using it intentionally.',
  'Thinking money is only cash. Digital wallets, bank balances, and even some investments are also forms of money because they can be turned into goods and services.',
  'Explain that money is social agreement + tool. Use Indonesian daily examples like GoPay, OVO, cash, and bank transfers. Avoid textbook definitions.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-inflation', 'What Is Inflation?', 'Apa Itu Inflasi?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 2, 'beginner', 25, 2,
  'Inflation means the same amount of money buys less over time.',
  'Inflation is the slow rise in prices across an economy. When inflation is 5%, a Rp 10.000 bowl of mie ayam may cost Rp 10.500 next year. Your money still looks the same, but its purchasing power shrinks. Inflation is usually caused by too much money chasing too few goods, rising production costs, or currency weakness.',
  'Last year, Rina could buy a large boba tea for Rp 25.000. This year the same drink costs Rp 28.000. Her Rp 25.000 no longer buys the drink. That is inflation eating her money''s value.',
  'Inflation is why keeping all your money in a piggy bank for ten years is risky. Even if the amount does not change, what it can buy does.',
  'Thinking inflation means every single price goes up equally. Some prices rise faster than others; inflation is an average measure.',
  'Focus on purchasing power, not abstract economics. Use teen-relevant examples: boba, gorengan, game credits, pulsa.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-interest', 'What Is Interest?', 'Apa Itu Bunga?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 3, 'beginner', 25, 2,
  'Interest is the price of using money over time — either what you earn or what you pay.',
  'Interest has two sides. When you save, a bank pays you interest for letting them use your money. When you borrow, you pay interest for using someone else''s money. Simple interest is calculated only on the original amount. Compound interest is calculated on the original amount plus interest that has already been added, so growth accelerates over time.',
  'Andi saves Rp 1.000.000 in a deposit that pays 5% simple interest per year. After one year he has Rp 1.050.000. If it were 5% compound interest, the next year he would earn 5% on Rp 1.050.000, not just the original Rp 1.000.000.',
  'Interest explains why debt can grow fast and why saving early beats saving later. It is one of the most powerful concepts in personal finance.',
  'Ignoring that interest works against you in debt. A 2% monthly credit card fee sounds small but compounds to much more than 24% per year.',
  'Distinguish simple vs compound clearly. Use small numbers and a one-year horizon first.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-income-vs-wealth', 'Income vs Wealth', 'Pendapatan vs Kekayaan',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 4, 'beginner', 25, 2,
  'Income is money coming in. Wealth is money kept and grown.',
  'Income is what you earn from a salary, allowance, freelance work, or business. Wealth is what you own minus what you owe. A person can have a high income but low wealth if they spend everything. A person can have modest income but growing wealth if they save and invest consistently.',
  'Dina earns Rp 8.000.000 per month but spends Rp 8.000.000 on rent, food, and shopping. Her income is high but her wealth is flat. Sari earns Rp 4.000.000 but saves Rp 800.000 every month. Over time, Sari''s wealth grows even though her income is lower.',
  'Many young people dream of a high salary, but wealth is what creates real freedom. You cannot retire on income alone; you need accumulated wealth.',
  'Judging success by monthly income alone. A flashy lifestyle funded by debt is the opposite of wealth.',
  'Use contrast stories. Keep it non-judgmental: both characters are normal, one chooses to convert income into wealth.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-assets-vs-liabilities', 'Assets vs Liabilities', 'Aset vs Liabilitas',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 5, 'beginner', 25, 2,
  'Assets put money in your pocket. Liabilities take money out.',
  'An asset is something that owns or produces value: savings, investments, a productive skill, or even a motorbike that lets you earn deliveries. A liability is something that costs you money: debt, a luxury item bought on credit, or a subscription you do not use. The same item can be either depending on how you use it.',
  'A laptop bought to play games and watch Netflix is mostly a liability because it keeps costing electricity and internet. The same laptop bought to do freelance design work is an asset because it helps earn money.',
  'This distinction is the foundation of budgeting and investing. Before buying anything, ask: will this make me money or cost me money over time?',
  'Calling a primary residence or a car an asset automatically. If it costs more than it earns, it behaves like a liability on your personal balance sheet.',
  'Avoid Robert-Kiyosaki-style absolutes. Frame it as "behaves like an asset/liability for you" rather than permanent labels.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-risk', 'What Is Risk?', 'Apa Itu Risiko?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 6, 'beginner', 25, 2,
  'Risk is the chance that something bad happens to your money.',
  'Risk is the possibility of losing money or earning less than expected. Every financial choice has risk. Keeping cash under a mattress risks theft and inflation. Putting money in a deposit risks low returns. Investing in stocks risks price drops. There is no such thing as a risk-free choice; there are only different kinds of risk.',
  'Bayu has Rp 5.000.000. Option A: keep it at home. Risk: stolen or eaten by inflation. Option B: put it in a deposit. Risk: low return may not beat inflation. Option C: buy a stock. Risk: price may fall. Every option has a different risk.',
  'Understanding risk stops you from chasing "safe" investments that do not exist. It also helps you choose risks you can live with.',
  'Thinking risk only means losing everything. Risk also includes losing purchasing power, missing opportunities, or being unable to access money when needed.',
  'Use a three-option scenario. Emphasize that risk cannot be eliminated, only managed and understood.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-return', 'What Is Return?', 'Apa Itu Return?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 7, 'beginner', 25, 2,
  'Return is the gain or loss you get from an investment or saving.',
  'Return is the money you make or lose on your money. If you put Rp 1.000.000 into something and later it is worth Rp 1.100.000, your return is Rp 100.000 or 10%. Return can come from interest, dividends, price increases, or business profits. Higher potential return usually comes with higher risk.',
  'Citra buys a government bond for Rp 1.000.000. After a year she receives Rp 60.000 in interest and still owns the bond. Her return is Rp 60.000, or 6%. She did not need to trade anything; the return came from lending her money to the government.',
  'Return is what makes saving turn into investing. Without understanding return, you cannot compare a deposit, a bond, and a stock.',
  'Expecting high return with no risk. If someone promises high return and low risk, it is usually a scam.',
  'Pair with the risk lesson. Use conservative examples first: deposits, bonds, then stocks.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-saving-vs-investing', 'Saving vs Investing', 'Menabung vs Berinvestasi',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 8, 'beginner', 25, 2,
  'Saving protects money now. Investing grows money for later.',
  'Saving is putting money somewhere safe so you can use it soon. Investing is putting money into something that may grow in value over a longer time. Saving is for emergencies and short-term goals. Investing is for goals years away, like education, a business, or retirement. You need both.',
  'Eko has Rp 10.000.000. He keeps Rp 3.000.000 in a savings account for emergencies and invests Rp 7.000.000 in a mix of bonds and stocks for his future. The savings protect him today; the investments work for him tomorrow.',
  'Many beginners think they must choose between saving and investing. In reality, you save first for stability, then invest what you will not need soon.',
  'Investing money you might need next month. Investments can go down short-term; savings should not.',
  'Use a split-example. Make clear that both are valid, just for different time horizons.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-emergency-fund', 'Emergency Fund', 'Dana Darurat',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 9, 'beginner', 25, 2,
  'An emergency fund is money kept safe for unexpected problems.',
  'An emergency fund is cash you can access quickly when life surprises you: a broken phone, a medical bill, a lost job, or a family need. A common target is 3–6 months of essential expenses, but even Rp 1.000.000 is better than nothing. The fund should be safe, easy to reach, and separate from daily spending money.',
  'Fani''s motorbike breaks down and needs Rp 1.500.000 for repairs. Because she has an emergency fund, she pays without borrowing. Without it, she might use a pay-later app and pay extra fees and interest.',
  'An emergency fund is the first financial safety net. It turns a crisis into an inconvenience.',
  'Keeping the emergency fund in risky investments. If the investment drops when you need the money, the fund fails its job.',
  'Keep the target flexible for students and young workers. Emphasize "start small, start now."',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-needs-vs-wants', 'Needs vs Wants', 'Kebutuhan vs Keinginan',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 10, 'beginner', 25, 2,
  'Needs are essentials. Wants are nice-to-haves.',
  'A need is something you must have to live and function: food, shelter, basic clothes, transport to school or work. A want is something you would like but can live without: the latest phone, designer shoes, premium streaming, or extra boba. The line is personal, but being honest about the difference is the first step to budgeting.',
  'Hana has Rp 100.000 for the day. A Rp 20.000 lunch is a need. A Rp 45.000 frappuccino is a want. If she buys the frappuccino, she has less for transport home. Seeing the trade-off helps her decide.',
  'Every budget battle is secretly a needs-vs-wants decision. Mastering this term gives you control over your spending.',
  'Letting advertisers decide what you need. Marketing tries to turn wants into needs; only you can draw your own line.',
  'Avoid being preachy. Use a relatable trade-off, not a lecture.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-debt', 'What Is Debt?', 'Apa Itu Utang?',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 11, 'beginner', 25, 2,
  'Debt is money you owe and must pay back, usually with extra cost.',
  'Debt happens when you borrow money and promise to repay it later. The lender usually charges interest or fees for the loan. Some debt can be useful, like a student loan that increases your earning power. Some debt is dangerous, like high-interest pay-later spending for things that lose value quickly. The key questions are: what is the interest rate, can you afford the payments, and will the debt help you earn more or just consume?',
  'Irfan borrows Rp 2.000.000 from a pay-later app to buy new sneakers. The interest is 3% per month. If he only pays the minimum, the debt can grow to Rp 2.500.000 or more. The sneakers are now worth less than the debt.',
  'Debt is not always bad, but it is always costly. Understanding interest and purpose helps you avoid debt traps.',
  'Thinking minimum payments make debt affordable. Minimum payments stretch debt and multiply total interest.',
  'Distinguish productive vs consumptive debt without moralizing. Use pay-later examples familiar to Gen Z.',
  'approved', 'koin-curriculum-agent', NOW(), false
),
(
  gen_random_uuid(), 'fz-scam-red-flags', 'Scam Red Flags', 'Tanda-Tanda Penipuan',
  (SELECT id FROM topics WHERE slug = 'foundation_zero'), 12, 'beginner', 25, 2,
  'If it sounds too good to be true, it usually is.',
  'Scams often promise guaranteed high returns with little or no risk, pressure you to decide quickly, ask you to recruit friends, or pretend to be from a government agency or famous company. A real investment cannot promise fixed high returns because markets move. A real regulator will never ask for your password or OTP.',
  'An Instagram account promises 15% profit every month, guaranteed. They show screenshots of other people''s gains and say "limited slots." They ask you to transfer money to a personal account. Every signal — guaranteed return, urgency, fake social proof, personal account — is a red flag.',
  'Scam awareness protects your money and your friends. Most financial losses among young Indonesians come from schemes that are obvious in hindsight.',
  'Thinking you are too smart to be scammed. Scammers adapt to educated people too; the defense is checking licenses and slowing down.',
  'Use OJK license checking as the action step. Link to the OJK investment alert list.',
  'approved', 'koin-curriculum-agent', NOW(), false
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  title_id = EXCLUDED.title_id,
  topic_id = EXCLUDED.topic_id,
  lesson_number = EXCLUDED.lesson_number,
  summary = EXCLUDED.summary,
  concept_body = EXCLUDED.concept_body,
  indonesian_example = EXCLUDED.indonesian_example,
  why_this_matters = EXCLUDED.why_this_matters,
  common_mistake = EXCLUDED.common_mistake,
  ai_assist_context = EXCLUDED.ai_assist_context,
  review_status = EXCLUDED.review_status,
  reviewed_by = EXCLUDED.reviewed_by,
  reviewed_at = EXCLUDED.reviewed_at;

-- 4. Link every Foundation 0 lesson to OJK-003 as primary source.
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
SELECT
  gen_random_uuid(),
  l.id,
  s.id,
  'primary',
  true
FROM lessons l
CROSS JOIN sources s
WHERE l.slug LIKE 'fz-%'
  AND s.source_code = 'OJK-003'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- 5. Add approved reviews for Foundation 0 lessons.
INSERT INTO lesson_reviews (
  id, lesson_id, reviewer_name, reviewer_role, review_date,
  factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status,
  notes, approved_to_publish
)
SELECT
  gen_random_uuid(),
  l.id,
  'Koin Content Reviewer',
  'Content Lead',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Foundation 0 term lesson — reviewed for accuracy, source citation, and reading level.',
  true
FROM lessons l
WHERE l.slug LIKE 'fz-%'
ON CONFLICT (lesson_id) DO UPDATE SET
  reviewer_name = EXCLUDED.reviewer_name,
  reviewer_role = EXCLUDED.reviewer_role,
  review_date = EXCLUDED.review_date,
  factual_accuracy_status = EXCLUDED.factual_accuracy_status,
  source_verification_status = EXCLUDED.source_verification_status,
  indonesia_context_status = EXCLUDED.indonesia_context_status,
  compliance_status = EXCLUDED.compliance_status,
  notes = EXCLUDED.notes,
  approved_to_publish = EXCLUDED.approved_to_publish;

COMMIT;
