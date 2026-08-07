-- Migration: KO-FOUND-001 Foundation 0 content variants
-- Scope: example and question variants for 12 Foundation 0 micro-lessons.

BEGIN;

-- ============================================================
-- fz-what-is-money: 3 examples + 5 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'example',
  jsonb_build_object(
    'text', 'Budi wants to buy a Rp 15.000 notebook. He does not trade his lunch for it; he hands over a Rp 20.000 note and receives Rp 5.000 back. The seller accepts rupiah because everyone agrees it has value.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'example',
  jsonb_build_object(
    'text', 'When Ani pays for her GoRide using GoPay, she is using digital money. The driver accepts it because GoPay can be converted back into rupiah. The form changed, but it is still money.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'example',
  jsonb_build_object(
    'text', 'In a remote village, people might trade 2 chickens for a bag of rice. That is barter, not money. Money makes trade easier because everyone accepts the same medium.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which of these is the main reason money is useful?',
    'options', jsonb_build_array('It is made of gold', 'Everyone agrees it can be used to buy things', 'It never loses value', 'It is only available in banks'),
    'answer', 'Everyone agrees it can be used to buy things',
    'explanation', 'Money works because people trust and accept it as payment, not because of what it is made of.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Digital money in an e-wallet is still money because it can be used to buy goods and services.',
    'answer', true,
    'explanation', 'Money does not have to be physical cash. E-wallet balances and bank deposits also function as money.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What does it mean when money is a "unit of account"?',
    'options', jsonb_build_array('It can be saved under a mattress', 'It lets us compare prices of different things', 'It is printed by the government', 'It can be used in any country'),
    'answer', 'It lets us compare prices of different things',
    'explanation', 'A unit of account means everything has a price in the same currency, making comparison easy.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which role of money allows you to save Rp 100.000 today and spend it next month?',
    'options', jsonb_build_array('Medium of exchange', 'Store of value', 'Unit of account', 'Standard of debt'),
    'answer', 'Store of value',
    'explanation', 'Store of value means money keeps its purchasing power over time so you can save it for later.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'what-is-money', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-what-is-money'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'question', 'Money that everyone accepts as payment for goods and services is called a medium of ____.',
    'answer', 'exchange',
    'explanation', 'A medium of exchange is something widely accepted in return for goods and services.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'what-is-money', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-inflation: 3 examples + 5 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'example',
  jsonb_build_object(
    'text', 'Last year, Rina could buy a large boba tea for Rp 25.000. This year the same drink costs Rp 28.000. Her Rp 25.000 no longer buys the drink. That is inflation eating her money''s value.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'example',
  jsonb_build_object(
    'text', 'In 2020, a plate of nasi padang near campus cost Rp 15.000. In 2025, the same plate costs Rp 22.000. The food did not get bigger; the rupiah bought less.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'example',
  jsonb_build_object(
    'text', 'If inflation is 5% per year, Rp 1.000.000 hidden under a mattress will still look like Rp 1.000.000 in ten years, but it will buy much less than today.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What does inflation do to the value of money?',
    'options', jsonb_build_array('It increases it', 'It decreases it', 'It has no effect', 'It doubles it every year'),
    'answer', 'It decreases it',
    'explanation', 'Inflation means prices rise, so the same amount of money buys less over time.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'If inflation is 5%, a Rp 10.000 snack will likely cost less than Rp 10.000 next year.',
    'answer', false,
    'explanation', 'With inflation, prices tend to rise, so the snack will likely cost more, not less.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Why is keeping all your savings in cash under a mattress risky during inflation?',
    'options', jsonb_build_array('Cash can be stolen', 'The amount of cash shrinks', 'The purchasing power of the cash falls', 'Banks do not accept old cash'),
    'answer', 'The purchasing power of the cash falls',
    'explanation', 'Even though the number of bills stays the same, inflation means each bill buys less.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'question', 'Inflation means the same amount of money buys ____ over time.',
    'answer', 'less',
    'explanation', 'As prices rise, the purchasing power of money decreases.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'inflation', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-inflation'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'A bowl of mie ayam cost Rp 12.000 last year and Rp 13.000 this year. What is this an example of?',
    'options', jsonb_build_array('Deflation', 'Inflation', 'Interest', 'Investment'),
    'answer', 'Inflation',
    'explanation', 'A general rise in prices over time is called inflation.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'inflation', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-interest: 3 examples + 5 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'example',
  jsonb_build_object(
    'text', 'Andi saves Rp 1.000.000 in a deposit that pays 5% simple interest per year. After one year he has Rp 1.050.000. If it were 5% compound interest, the next year he would earn 5% on Rp 1.050.000, not just the original Rp 1.000.000.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'example',
  jsonb_build_object(
    'text', 'Nia borrows Rp 500.000 through a pay-later app. The app charges 2% interest per month. If she delays repayment, the debt grows to Rp 510.000 after one month and keeps growing.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'example',
  jsonb_build_object(
    'text', 'Compound interest is like a snowball rolling downhill. The interest you earn gets added to your savings, and then future interest is calculated on the bigger amount.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is interest?',
    'options', jsonb_build_array('A penalty for saving money', 'The price of using money over time', 'A government tax on income', 'A type of stock dividend'),
    'answer', 'The price of using money over time',
    'explanation', 'Interest is what you earn when you save or what you pay when you borrow.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'With compound interest, you earn interest on both your original money and the interest already added.',
    'answer', true,
    'explanation', 'Compound interest calculates growth on the total balance, including previously earned interest.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'If you borrow money at 3% monthly interest, what happens if you only pay the minimum each month?',
    'options', jsonb_build_array('The debt disappears faster', 'The total interest paid is usually much higher', 'The interest rate drops', 'Nothing, monthly interest is cheap'),
    'answer', 'The total interest paid is usually much higher',
    'explanation', 'Paying only the minimum stretches the debt and compounds the interest cost over time.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'question', 'When you save, the bank pays you ____ for letting them use your money.',
    'answer', 'interest',
    'explanation', 'Banks pay interest to savers and charge interest to borrowers.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'interest', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-interest'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which usually grows money faster over a long time?',
    'options', jsonb_build_array('Simple interest', 'Compound interest', 'No interest', 'Both grow at the same speed'),
    'answer', 'Compound interest',
    'explanation', 'Compound interest accelerates growth because it earns interest on interest.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'interest', true
)
ON CONFLICT DO NOTHING;

COMMIT;


-- ============================================================
-- fz-income-vs-wealth: 2 examples + 4 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-income-vs-wealth'),
  'example',
  jsonb_build_object(
    'text', 'Dina earns Rp 8.000.000 per month but spends Rp 8.000.000 on rent, food, and shopping. Her income is high but her wealth is flat. Sari earns Rp 4.000.000 but saves Rp 800.000 every month. Over time, Sari''s wealth grows.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'income-vs-wealth', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-income-vs-wealth'),
  'example',
  jsonb_build_object(
    'text', 'A famous celebrity might earn Rp 1 billion a year but end up bankrupt if they spend more than they earn. A small shop owner might earn Rp 3 million a month but become wealthy by saving and investing consistently.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'income-vs-wealth', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-income-vs-wealth'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is the difference between income and wealth?',
    'options', jsonb_build_array('Income is what you own; wealth is what you earn', 'Income is money coming in; wealth is money kept and grown', 'They are the same thing', 'Wealth is only for rich people'),
    'answer', 'Income is money coming in; wealth is money kept and grown',
    'explanation', 'Income is a flow of money over time. Wealth is the stock of assets you have accumulated minus debts.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'income-vs-wealth', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-income-vs-wealth'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'A person with a high income but high spending can have lower wealth than a person with a modest income who saves regularly.',
    'answer', true,
    'explanation', 'Wealth depends on how much you keep and grow, not just how much you earn.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'income-vs-wealth', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-income-vs-wealth'),
  'question',
  jsonb_build_object(
    'type', 'case_study',
    'caseText', 'Rudi earns Rp 10 juta per month. He leases a new car, eats out daily, and has no savings. Tika earns Rp 5 juta per month. She lives simply, saves Rp 1 juta monthly, and invests it.',
    'followUp', jsonb_build_object(
      'question', 'After five years, who is likely to have more wealth?',
      'options', jsonb_build_array('Rudi, because he earns more', 'Tika, because she saves and invests', 'They will have the same', 'It depends on their jobs'),
      'answer', 'Tika, because she saves and invests',
      'explanation', 'Wealth comes from what you keep and grow, not just what you earn.',
      'difficulty', 'beginner',
      'parameters', '{}'::jsonb
    ),
    'answer', 'Tika, because she saves and invests',
    'explanation', 'Wealth comes from what you keep and grow, not just what you earn.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'income-vs-wealth', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-income-vs-wealth'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which person is building wealth?',
    'options', jsonb_build_array('Someone who spends their entire salary', 'Someone who saves and invests part of their salary', 'Someone who only earns a high salary', 'Someone who borrows to buy luxuries'),
    'answer', 'Someone who saves and invests part of their salary',
    'explanation', 'Building wealth requires converting income into saved and invested assets.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'income-vs-wealth', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-assets-vs-liabilities: 2 examples + 4 questions (includes matching)
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-assets-vs-liabilities'),
  'example',
  jsonb_build_object(
    'text', 'A laptop bought to play games and watch Netflix is mostly a liability because it keeps costing electricity and internet. The same laptop bought to do freelance design work is an asset because it helps earn money.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'assets-vs-liabilities', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-assets-vs-liabilities'),
  'example',
  jsonb_build_object(
    'text', 'A motorbike used for online food delivery generates income, so it acts like an asset. A motorbike bought on credit just for weekend rides costs fuel, maintenance, and loan interest, so it acts more like a liability.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'assets-vs-liabilities', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-assets-vs-liabilities'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'In personal finance, what is an asset?',
    'options', jsonb_build_array('Something that always costs money', 'Something that owns or produces value', 'Only physical property', 'Any item you buy on credit'),
    'answer', 'Something that owns or produces value',
    'explanation', 'An asset is something that holds or generates value for you.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'assets-vs-liabilities', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-assets-vs-liabilities'),
  'question',
  jsonb_build_object(
    'type', 'matching',
    'question', 'Match each item with whether it usually behaves like an asset or a liability for most people.',
    'pairs', jsonb_build_array(
      jsonb_build_array('Savings in a deposit', 'Asset'),
      jsonb_build_array('Credit card debt', 'Liability'),
      jsonb_build_array('A skill that earns freelance income', 'Asset'),
      jsonb_build_array('A car bought on loan just for leisure', 'Liability')
    ),
    'answer', jsonb_build_object('Savings in a deposit', 'Asset', 'Credit card debt', 'Liability', 'A skill that earns freelance income', 'Asset', 'A car bought on loan just for leisure', 'Liability'),
    'explanation', 'Assets put money in your pocket or hold value; liabilities take money out.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'assets-vs-liabilities', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-assets-vs-liabilities'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'The same item, like a laptop or motorbike, can be an asset for one person and a liability for another depending on how it is used.',
    'answer', true,
    'explanation', 'Whether something behaves like an asset or liability depends on whether it generates value or costs money for you.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'assets-vs-liabilities', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-assets-vs-liabilities'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Before buying something expensive, which question helps you decide if it is an asset or liability?',
    'options', jsonb_build_array('Is it trending on social media?', 'Will this make me money or cost me money over time?', 'Does it come in my favorite color?', 'Did my friend buy one?'),
    'answer', 'Will this make me money or cost me money over time?',
    'explanation', 'The key test is whether the item puts money in your pocket or takes money out over time.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'assets-vs-liabilities', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-risk: 2 examples + 4 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-risk'),
  'example',
  jsonb_build_object(
    'text', 'Bayu has Rp 5.000.000. Option A: keep it at home. Risk: stolen or eaten by inflation. Option B: put it in a deposit. Risk: low return may not beat inflation. Option C: buy a stock. Risk: price may fall. Every option has a different risk.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'risk', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-risk'),
  'example',
  jsonb_build_object(
    'text', 'Not investing also has risk. If Lina keeps all her money in a savings account earning 1% while inflation is 4%, she loses purchasing power every year. That is called inflation risk.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'risk', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-risk'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is financial risk?',
    'options', jsonb_build_array('A guarantee of profit', 'The chance of losing money or earning less than expected', 'Only something that happens in stocks', 'A type of bank fee'),
    'answer', 'The chance of losing money or earning less than expected',
    'explanation', 'Risk is the possibility that an outcome is worse than expected.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'risk', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-risk'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Keeping all your money as cash under a mattress is completely risk-free.',
    'answer', false,
    'explanation', 'Cash faces theft risk and inflation risk, which slowly reduces purchasing power.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'risk', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-risk'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which statement about risk is true?',
    'options', jsonb_build_array('All risk can be eliminated', 'Higher potential return usually comes with higher risk', 'Risk only exists in the stock market', 'Savers never face any risk'),
    'answer', 'Higher potential return usually comes with higher risk',
    'explanation', 'Risk and return are usually linked. Higher possible rewards tend to come with higher possible losses.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'risk', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-risk'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What kind of risk does a savings account with 1% interest face when inflation is 4%?',
    'options', jsonb_build_array('Theft risk', 'Inflation risk', 'No risk', 'Currency collapse risk'),
    'answer', 'Inflation risk',
    'explanation', 'When inflation is higher than your interest rate, your money loses purchasing power over time.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'risk', true
)
ON CONFLICT DO NOTHING;


-- ============================================================
-- fz-return: 2 examples + 4 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-return'),
  'example',
  jsonb_build_object(
    'text', 'Citra buys a government bond for Rp 1.000.000. After a year she receives Rp 60.000 in interest and still owns the bond. Her return is Rp 60.000, or 6%. She did not need to trade anything; the return came from lending her money.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'return', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-return'),
  'example',
  jsonb_build_object(
    'text', 'Doni buys a stock for Rp 10.000 per share. A year later the price is Rp 12.000. If he sells, his capital gain is Rp 2.000 per share, a 20% return. But if the price drops to Rp 8.000, his return is negative 20%.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'return', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-return'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is return in finance?',
    'options', jsonb_build_array('The amount you invest', 'The gain or loss on your money', 'A type of bank account', 'A government tax refund'),
    'answer', 'The gain or loss on your money',
    'explanation', 'Return measures how much money you made or lost relative to what you put in.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'return', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-return'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'A higher potential return usually means a lower risk.',
    'answer', false,
    'explanation', 'Higher potential returns are usually linked to higher risk.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'return', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-return'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'question', 'If you invest Rp 1.000.000 and later have Rp 1.100.000, your return is Rp 100.000 or ____.',
    'answer', '10%',
    'explanation', 'Return is often expressed as a percentage of the original amount.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'return', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-return'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which is a warning sign that a promised return might be a scam?',
    'options', jsonb_build_array('It is higher than inflation', 'It is guaranteed, high, and risk-free', 'It comes from a bank deposit', 'It is paid monthly'),
    'answer', 'It is guaranteed, high, and risk-free',
    'explanation', 'Real investments cannot promise high returns with no risk. That combination is a classic scam signal.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'return', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-saving-vs-investing: 2 examples + 4 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-saving-vs-investing'),
  'example',
  jsonb_build_object(
    'text', 'Eko has Rp 10.000.000. He keeps Rp 3.000.000 in a savings account for emergencies and invests Rp 7.000.000 in a mix of bonds and stocks for his future. The savings protect him today; the investments work for him tomorrow.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'saving-vs-investing', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-saving-vs-investing'),
  'example',
  jsonb_build_object(
    'text', 'Saving is like keeping an umbrella by the door: you need it ready for rain. Investing is like planting a tree: it takes time to grow but can provide shade and fruit for years.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'saving-vs-investing', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-saving-vs-investing'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is the main difference between saving and investing?',
    'options', jsonb_build_array('Saving is for the rich; investing is for everyone else', 'Saving protects money for short-term needs; investing grows money for long-term goals', 'Saving always beats inflation; investing always loses money', 'They are the same thing'),
    'answer', 'Saving protects money for short-term needs; investing grows money for long-term goals',
    'explanation', 'Saving focuses on safety and access. Investing focuses on growth over a longer period.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'saving-vs-investing', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-saving-vs-investing'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Money you might need next month should usually be kept in savings, not invested in stocks.',
    'answer', true,
    'explanation', 'Short-term money should be safe and accessible. Investments can fluctuate in the short term.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'saving-vs-investing', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-saving-vs-investing'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which goal is best matched with investing rather than saving?',
    'options', jsonb_build_array('Next month''s rent', 'Emergency fund', 'A phone replacement in 6 months', 'University fund in 10 years'),
    'answer', 'University fund in 10 years',
    'explanation', 'Long-term goals can benefit from investment growth because there is time to recover from short-term drops.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'saving-vs-investing', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-saving-vs-investing'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'question', 'You should save for emergencies first, then invest money you will not need for several ____.',
    'answer', 'years',
    'explanation', 'Investing is best for money you can leave alone for a longer time.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'saving-vs-investing', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-emergency-fund: 2 examples + 4 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-emergency-fund'),
  'example',
  jsonb_build_object(
    'text', 'Fani''s motorbike breaks down and needs Rp 1.500.000 for repairs. Because she has an emergency fund, she pays without borrowing. Without it, she might use a pay-later app and pay extra fees and interest.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'emergency-fund', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-emergency-fund'),
  'example',
  jsonb_build_object(
    'text', 'A good emergency fund is like a spare tire. You hope you never need it, but when you do, you are very glad it is there. It should be easy to access and safe from loss.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'emergency-fund', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-emergency-fund'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is an emergency fund for?',
    'options', jsonb_build_array('Buying the latest gadgets', 'Unexpected expenses like repairs or medical bills', 'Investing in stocks', 'Paying for planned vacations'),
    'answer', 'Unexpected expenses like repairs or medical bills',
    'explanation', 'An emergency fund covers surprise costs so you do not need to borrow.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'emergency-fund', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-emergency-fund'),
  'question',
  jsonb_build_object(
    'type', 'case_study',
    'caseText', 'Rina has Rp 2.000.000 saved. Her phone suddenly stops working and she needs Rp 1.800.000 for a replacement for school. She also sees a limited-edition hoodie for Rp 800.000.',
    'followUp', jsonb_build_object(
      'question', 'Which use of her savings is appropriate for an emergency fund?',
      'options', jsonb_build_array('Buy the hoodie because it is limited edition', 'Replace the broken phone needed for school', 'Buy both and use pay-later for the rest', 'Keep all the money and do nothing'),
      'answer', 'Replace the broken phone needed for school',
      'explanation', 'A broken phone needed for school is an unexpected need. A limited hoodie is a want.',
      'difficulty', 'beginner',
      'parameters', '{}'::jsonb
    ),
    'answer', 'Replace the broken phone needed for school',
    'explanation', 'A broken phone needed for school is an unexpected need. A limited hoodie is a want.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'emergency-fund', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-emergency-fund'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'An emergency fund should be kept in a safe place where you can access it quickly.',
    'answer', true,
    'explanation', 'Emergency money must be safe and available when you need it.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'emergency-fund', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-emergency-fund'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Where should you NOT keep your emergency fund?',
    'options', jsonb_build_array('Savings account', 'Low-risk money market fund', 'A volatile stock investment', 'A separate digital wallet'),
    'answer', 'A volatile stock investment',
    'explanation', 'Emergency funds need stability. A volatile investment could drop just when you need the money.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'emergency-fund', true
)
ON CONFLICT DO NOTHING;


-- ============================================================
-- fz-needs-vs-wants: 2 examples + 4 questions (includes matching)
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-needs-vs-wants'),
  'example',
  jsonb_build_object(
    'text', 'Hana has Rp 100.000 for the day. A Rp 20.000 lunch is a need. A Rp 45.000 frappuccino is a want. If she buys the frappuccino, she has less for transport home. Seeing the trade-off helps her decide.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'needs-vs-wants', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-needs-vs-wants'),
  'example',
  jsonb_build_object(
    'text', 'A basic phone to stay in touch with family is a need. The newest iPhone model is a want. Both are phones, but one is essential and the other is a choice.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'needs-vs-wants', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-needs-vs-wants'),
  'question',
  jsonb_build_object(
    'type', 'matching',
    'question', 'Match each item with whether it is usually a need or a want.',
    'pairs', jsonb_build_array(
      jsonb_build_array('Basic food', 'Need'),
      jsonb_build_array('Latest gaming console', 'Want'),
      jsonb_build_array('Rent for housing', 'Need'),
      jsonb_build_array('Designer sneakers', 'Want')
    ),
    'answer', jsonb_build_object('Basic food', 'Need', 'Latest gaming console', 'Want', 'Rent for housing', 'Need', 'Designer sneakers', 'Want'),
    'explanation', 'Needs are essentials for living. Wants are things we would like but can live without.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'needs-vs-wants', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-needs-vs-wants'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which of these is usually a need?',
    'options', jsonb_build_array('Premium streaming subscription', 'Basic transportation to school or work', 'Latest smartphone', 'Weekend trip to Bali'),
    'answer', 'Basic transportation to school or work',
    'explanation', 'Transportation to school or work is usually essential. The others are wants.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'needs-vs-wants', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-needs-vs-wants'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'The line between a need and a want is the same for every person.',
    'answer', false,
    'explanation', 'Needs and wants are personal. A need for one person might be a want for another depending on their situation.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'needs-vs-wants', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-needs-vs-wants'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Advertisers often try to make you feel that a want is actually a need. What is the best defense?',
    'options', jsonb_build_array('Buy immediately before it sells out', 'Ask whether you can live without it for a month', 'Watch more ads to compare', 'Use pay-later so it feels free'),
    'answer', 'Ask whether you can live without it for a month',
    'explanation', 'Waiting and questioning helps you see whether something is truly a need or just marketing pressure.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'needs-vs-wants', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-debt: 2 examples + 4 questions
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-debt'),
  'example',
  jsonb_build_object(
    'text', 'Irfan borrows Rp 2.000.000 from a pay-later app to buy new sneakers. The interest is 3% per month. If he only pays the minimum, the debt can grow to Rp 2.500.000 or more. The sneakers are now worth less than the debt.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'debt', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-debt'),
  'example',
  jsonb_build_object(
    'text', 'A student loan that helps you learn a high-demand skill can be productive debt if your future income rises enough to repay it. A loan for a party or vacation is consumptive debt because it does not earn money back.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'debt', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-debt'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'What is debt?',
    'options', jsonb_build_array('Money you save for the future', 'Money you owe and must repay', 'Money you earn from investments', 'Money the government gives you'),
    'answer', 'Money you owe and must repay',
    'explanation', 'Debt is borrowed money that must be repaid, usually with interest or fees.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'debt', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-debt'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'Paying only the minimum on a high-interest debt is a good long-term strategy.',
    'answer', false,
    'explanation', 'Minimum payments stretch the debt and increase the total interest paid.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'debt', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-debt'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which question should you ask before taking on debt?',
    'options', jsonb_build_array('Will this impress my friends?', 'What is the interest rate and can I afford the payments?', 'Is the item on sale?', 'Does it come with free shipping?'),
    'answer', 'What is the interest rate and can I afford the payments?',
    'explanation', 'Understanding the cost and your ability to repay is essential before borrowing.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'debt', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-debt'),
  'question',
  jsonb_build_object(
    'type', 'case_study',
    'caseText', 'Maya is offered a pay-later plan for a new Rp 4.000.000 phone. The monthly payment seems small, but the total interest over 12 months is Rp 900.000. Her current phone still works but is two years old.',
    'followUp', jsonb_build_object(
      'question', 'What is the smartest thing for Maya to consider first?',
      'options', jsonb_build_array('The color of the new phone', 'Whether the new phone is a need or a want and the true total cost', 'How many influencers use it', 'Whether the store has air conditioning'),
      'answer', 'Whether the new phone is a need or a want and the true total cost',
      'explanation', 'Before debt, decide if the purchase is essential and calculate the full cost including interest.',
      'difficulty', 'beginner',
      'parameters', '{}'::jsonb
    ),
    'answer', 'Whether the new phone is a need or a want and the true total cost',
    'explanation', 'Before debt, decide if the purchase is essential and calculate the full cost including interest.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'debt', true
)
ON CONFLICT DO NOTHING;

-- ============================================================
-- fz-scam-red-flags: 2 examples + 4 questions (case-study heavy)
-- ============================================================
INSERT INTO content_variants (id, lesson_id, variant_type, body, difficulty, topic_tag, is_active) VALUES
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-scam-red-flags'),
  'example',
  jsonb_build_object(
    'text', 'An Instagram account promises 15% profit every month, guaranteed. They show screenshots of other people''s gains and say "limited slots." They ask you to transfer money to a personal account. Every signal — guaranteed return, urgency, fake social proof, personal account — is a red flag.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'scam-red-flags', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-scam-red-flags'),
  'example',
  jsonb_build_object(
    'text', 'A real OJK officer will never ask for your password, OTP, or transfer money to a personal account. If someone pressures you to act fast and keep secrets, slow down and verify through official channels.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner', 'scam-red-flags', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-scam-red-flags'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Which is a major scam red flag?',
    'options', jsonb_build_array('The investment is registered with OJK', 'Guaranteed high returns with no risk', 'You can withdraw money anytime', 'The company has a real office'),
    'answer', 'Guaranteed high returns with no risk',
    'explanation', 'Real investments have risk. Guaranteed high returns with no risk is a classic scam sign.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'scam-red-flags', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-scam-red-flags'),
  'question',
  jsonb_build_object(
    'type', 'case_study',
    'caseText', 'You receive a WhatsApp message: "Congratulations! You won Rp 50.000.000. Click this link and enter your OTP to claim." The sender claims to be from a famous bank.',
    'followUp', jsonb_build_object(
      'question', 'What should you do?',
      'options', jsonb_build_array('Click the link and enter the OTP quickly', 'Ignore it and contact the bank through its official number', 'Reply with your account number', 'Forward it to all your friends'),
      'answer', 'Ignore it and contact the bank through its official number',
      'explanation', 'Real banks never ask for OTPs or passwords. Verify through official channels, not links in messages.',
      'difficulty', 'beginner',
      'parameters', '{}'::jsonb
    ),
    'answer', 'Ignore it and contact the bank through its official number',
    'explanation', 'Real banks never ask for OTPs or passwords. Verify through official channels, not links in messages.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'scam-red-flags', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-scam-red-flags'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'question', 'If an investment sounds too good to be true, it probably is.',
    'answer', true,
    'explanation', 'This is one of the oldest and most reliable rules in personal finance.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'scam-red-flags', true
),
(
  gen_random_uuid(),
  (SELECT id FROM lessons WHERE slug = 'fz-scam-red-flags'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', 'Before investing, where should you check if the product or company is legally registered?',
    'options', jsonb_build_array('Instagram comments', 'The OJK website', 'A friend who already invested', 'The company''s own app only'),
    'answer', 'The OJK website',
    'explanation', 'OJK maintains official lists of licensed financial products and companies. Always verify there.',
    'difficulty', 'beginner',
    'parameters', '{}'::jsonb
  ),
  'beginner', 'scam-red-flags', true
)
ON CONFLICT DO NOTHING;

COMMIT;
