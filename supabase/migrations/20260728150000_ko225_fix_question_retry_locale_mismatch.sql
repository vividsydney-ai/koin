-- KO-225: keep the question-retry pool locale-safe. These four legacy
-- interest questions were duplicated into both body columns as Indonesian,
-- so English learners saw Indonesian after selecting "Try another question".

update public.content_variants
set body = jsonb_build_object(
  'type', 'multiple_choice',
  'answer', 'Rp120,000',
  'options', jsonb_build_array('Rp120,000', 'Rp200,000', 'Rp12,000', 'Rp600,000'),
  'question', 'Doni borrows Rp2,000,000 at 6% simple interest per year. How much interest does he pay over one year?',
  'difficulty', 'intermediate',
  'explanation', '6% of Rp2,000,000 is Rp120,000.'
)
where id = '706b5820-a638-477c-bd0d-26d2d4f96807';

update public.content_variants
set body = jsonb_build_object(
  'type', 'true_false',
  'answer', false,
  'question', 'Interest always hurts borrowers and benefits lenders.',
  'difficulty', 'intermediate',
  'explanation', 'Interest can help us earn money through savings or investments, or cost us money through debt, depending on our position.'
)
where id = '713d4053-9993-44e6-8d73-590659f2a34e';

update public.content_variants
set body = jsonb_build_object(
  'type', 'multiple_choice',
  'answer', 'The reward you receive from the bank',
  'options', jsonb_build_array('The reward you receive from the bank', 'The fee you pay to the bank', 'A late-payment penalty', 'A tax on savings'),
  'question', 'If you save money, interest is ...',
  'difficulty', 'intermediate',
  'explanation', 'Savings or deposit interest is the reward a bank pays because you let it use your money.'
)
where id = '1e4d2e4d-5e68-4706-a953-9f24d8ae634a';

update public.content_variants
set body = jsonb_build_object(
  'type', 'fill_blank',
  'answer', '{{amount * rate / 100}}',
  'question', 'Rina saves Rp{{amount}} at {{rate}}% annual interest. The simple interest for one year is Rp_____.',
  'parameters', jsonb_build_object(
    'rate', jsonb_build_object('max', 6, 'min', 3, 'step', 1),
    'amount', jsonb_build_object('max', 2000000, 'min', 1000000, 'step', 250000)
  ),
  'difficulty', 'intermediate',
  'explanation', 'Interest = Rp{{amount}} × {{rate}}% = Rp{{amount * rate / 100}}.'
)
where id = '1284e2e7-2764-4e86-b26e-e0c4079e76f8';
