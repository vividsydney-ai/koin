-- KO-375: Chapter 06 "Grow Your Money" refinement.
-- 1. Fix compound-interest-101 to use the RULES.md-mandated core example
--    (Rp 500,000/month starting at 18 vs 30) instead of the prior
--    Rp 100,000/18-vs-28 example, and fix an English mistranslation
--    ("bunga" -> "flowers" instead of "interest").
-- 2. Add the chapter's first visual-learning block (comparison, calculated),
--    three bilingual visual_applied questions, and an optional five-day
--    recall prompt, following the visual-learning-recipe.
BEGIN;

-- 1a. Replace the non-compliant core example with the mandated one.
UPDATE public.content_variants
SET
  body = jsonb_build_object(
    'text', 'Doni started saving Rp500,000 per month from the age of 18, earning about 6% per year. His friend started saving the same Rp500,000 per month from the age of 30. By the time they both turned 40, Doni had put in Rp132,000,000 total and his friend had put in Rp60,000,000 — but Doni''s balance had grown to roughly Rp273,000,000, while his friend''s reached about Rp82,000,000.'
  ),
  body_id = jsonb_build_object(
    'text', 'Doni mulai menabung Rp500.000 per bulan sejak usia 18 tahun, dengan imbal hasil sekitar 6% per tahun. Temannya mulai menabung jumlah yang sama, Rp500.000 per bulan, sejak usia 30 tahun. Saat keduanya berusia 40 tahun, Doni telah menyetor total Rp132.000.000 dan temannya Rp60.000.000 — tetapi saldo Doni tumbuh menjadi sekitar Rp273.000.000, sedangkan saldo temannya sekitar Rp82.000.000.'
  )
WHERE lesson_id = (SELECT id FROM public.lessons WHERE slug = 'compound-interest-101')
  AND variant_type = 'example'
  AND body->>'text' ILIKE '%Doni started saving IDR 100,000%';

-- 1b. Fix an English-only mistranslation ("bunga" incorrectly rendered as
-- "flowers"); the Indonesian body was already correct.
UPDATE public.content_variants
SET body = jsonb_set(
  body,
  '{explanation}',
  '"Time allows interest to accumulate and earn additional interest, so growth accelerates."'
)
WHERE lesson_id = (SELECT id FROM public.lessons WHERE slug = 'compound-interest-101')
  AND body->>'explanation' ILIKE '%flowers%';

-- 2. Visual-learning block: starting-early comparison, using the same
-- Rp 500,000/18-vs-30 figures as the fixed core example above.
WITH blocks(slug, block_type, data_status, content) AS (VALUES
('compound-interest-101','comparison','calculated',$json${"en":{"icon":"🌱","eyebrow":"Same monthly amount, different start","title":"Starting 12 years earlier roughly triples the result","altText":"A comparison shows two savers who each put Rp500,000 a month into a 6%-a-year account, one starting at 18 and one at 30, and their balances at age 40.","disclosure":"Calculated example at an assumed 6% yearly return, no fees or tax; real returns vary and are not guaranteed.","payload":{"leftTitle":"Starts at 18 🌱","rightTitle":"Starts at 30 🌿","rows":[{"left":"Saves Rp500,000/month for 22 years","right":"Saves Rp500,000/month for 10 years"},{"left":"Puts in Rp132,000,000 total","right":"Puts in Rp60,000,000 total"},{"left":"Balance at 40: about Rp273,000,000","right":"Balance at 40: about Rp82,000,000"}]}},"id":{"icon":"🌱","eyebrow":"Jumlah bulanan sama, mulai berbeda","title":"Mulai 12 tahun lebih awal membuat hasilnya kira-kira tiga kali lipat","altText":"Perbandingan menunjukkan dua penabung yang masing-masing menyisihkan Rp500.000 per bulan dengan imbal hasil 6% per tahun, satu mulai usia 18 dan satu usia 30, beserta saldo mereka di usia 40.","disclosure":"Contoh perhitungan dengan asumsi imbal hasil 6% per tahun, tanpa biaya atau pajak; hasil nyata dapat berbeda dan tidak dijamin.","payload":{"leftTitle":"Mulai usia 18 🌱","rightTitle":"Mulai usia 30 🌿","rows":[{"left":"Menabung Rp500.000/bulan selama 22 tahun","right":"Menabung Rp500.000/bulan selama 10 tahun"},{"left":"Total setoran Rp132.000.000","right":"Total setoran Rp60.000.000"},{"left":"Saldo di usia 40: sekitar Rp273.000.000","right":"Saldo di usia 40: sekitar Rp82.000.000"}]}}}$json$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, content, data_status, display_order, is_published)
SELECT lesson.id, 'concept', blocks.block_type, blocks.content, blocks.data_status, 10, TRUE
FROM blocks JOIN public.lessons lesson ON lesson.slug = blocks.slug
WHERE lesson.is_published
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type, content = EXCLUDED.content, data_status = EXCLUDED.data_status, is_published = TRUE;

-- 3. Applied questions (visual_applied), three bilingual variants.
WITH applied_questions(slug, body, body_id) AS (
  VALUES
    ('compound-interest-101', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "In the comparison, both savers put Rp500,000 a month into the same 6%-a-year account. Why does the saver who started at 18 end up with a much bigger balance at 40 than the one who started at 30?",
      "options": ["Their money had more years to earn interest on interest", "They received a higher interest rate", "They put in more money each month", "The bank charged the later saver a fee"],
      "answer": "Their money had more years to earn interest on interest",
      "explanation": "Both savers use the same monthly amount and rate — the only difference is time, which lets compounding work longer."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Dalam perbandingan tersebut, kedua penabung menyisihkan Rp500.000 per bulan ke rekening dengan imbal hasil 6% per tahun yang sama. Mengapa penabung yang mulai di usia 18 memiliki saldo jauh lebih besar di usia 40 dibanding yang mulai di usia 30?",
      "options": ["Uangnya memiliki lebih banyak waktu untuk mendapat bunga dari bunga", "Ia menerima suku bunga yang lebih tinggi", "Ia menyetor lebih banyak uang setiap bulan", "Bank mengenakan biaya kepada penabung yang mulai belakangan"],
      "answer": "Uangnya memiliki lebih banyak waktu untuk mendapat bunga dari bunga",
      "explanation": "Kedua penabung menggunakan jumlah bulanan dan suku bunga yang sama — perbedaannya hanya waktu, yang memberi kesempatan lebih lama bagi bunga majemuk untuk bekerja."
    }$block$::jsonb),
    ('compound-interest-101', $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "The saver who started at 18 put in Rp132,000,000 total and ended with about Rp273,000,000. Roughly how much of that final balance came from interest rather than from money they deposited?",
      "options": ["About Rp141,000,000", "About Rp10,000,000", "None — it all came from deposits", "Exactly Rp132,000,000"],
      "answer": "About Rp141,000,000",
      "explanation": "Rp273,000,000 minus the Rp132,000,000 deposited leaves roughly Rp141,000,000 earned from compounding."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "intermediate",
      "question": "Penabung yang mulai di usia 18 menyetor total Rp132.000.000 dan berakhir dengan sekitar Rp273.000.000. Kira-kira berapa bagian dari saldo akhir itu yang berasal dari bunga, bukan dari uang yang disetor?",
      "options": ["Sekitar Rp141.000.000", "Sekitar Rp10.000.000", "Tidak ada — semuanya dari setoran", "Tepat Rp132.000.000"],
      "answer": "Sekitar Rp141.000.000",
      "explanation": "Rp273.000.000 dikurangi Rp132.000.000 yang disetor menyisakan sekitar Rp141.000.000 yang diperoleh dari bunga majemuk."
    }$block$::jsonb),
    ('compound-interest-101', $block${
      "type": "true_false",
      "difficulty": "intermediate",
      "question": "Because both savers in the comparison earn the same 6% rate, starting 12 years later only costs them 12 years of deposits and nothing more.",
      "answer": false,
      "explanation": "It costs more than the missed deposits — it also costs the compounding those 12 years of early deposits would have earned, which is why the gap (about Rp191,000,000) is much larger than the missed deposits alone (Rp72,000,000)."
    }$block$::jsonb, $block${
      "type": "true_false",
      "difficulty": "intermediate",
      "question": "Karena kedua penabung dalam perbandingan mendapat suku bunga 6% yang sama, mulai 12 tahun lebih lambat hanya membuat mereka kehilangan 12 tahun setoran dan tidak lebih dari itu.",
      "answer": false,
      "explanation": "Kerugiannya lebih dari sekadar setoran yang terlewat — juga kehilangan bunga majemuk yang seharusnya dihasilkan setoran 12 tahun awal tersebut, sehingga selisihnya (sekitar Rp191.000.000) jauh lebih besar daripada setoran yang terlewat saja (Rp72.000.000)."
    }$block$::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied_questions.body, applied_questions.body_id, 'intermediate', 'visual_applied', TRUE
FROM applied_questions
JOIN public.lessons AS lesson ON lesson.slug = applied_questions.slug
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants AS existing
  WHERE existing.lesson_id = lesson.id AND existing.topic_tag = 'visual_applied'
);

-- 4. Optional five-Jakarta-calendar-day recall prompt.
WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (
  VALUES
    ('compound-interest-101',
     'Two people save the same amount every month at the same interest rate, but one starts 12 years earlier. What mainly explains the earlier saver''s much larger balance?',
     'Dua orang menabung jumlah yang sama setiap bulan dengan suku bunga yang sama, tetapi satu mulai 12 tahun lebih awal. Apa yang terutama menjelaskan saldo penabung yang lebih awal jauh lebih besar?',
     $block$[{"id":"time_compounding","label":"More time for interest to earn interest"},{"id":"higher_rate","label":"A higher interest rate"},{"id":"bigger_deposits","label":"Bigger monthly deposits"},{"id":"luck","label":"Random luck"}]$block$::jsonb,
     $block$[{"id":"time_compounding","label":"Waktu lebih lama bagi bunga untuk menghasilkan bunga"},{"id":"higher_rate","label":"Suku bunga yang lebih tinggi"},{"id":"bigger_deposits","label":"Setoran bulanan yang lebih besar"},{"id":"luck","label":"Keberuntungan acak"}]$block$::jsonb,
     'time_compounding',
     'With the same rate and monthly amount, the only variable is time — and compounding needs time to accelerate.',
     'Dengan suku bunga dan jumlah bulanan yang sama, satu-satunya variabel adalah waktu — dan bunga majemuk butuh waktu untuk berakselerasi.')
)
INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active
)
SELECT lesson.id, recalls.question_en, recalls.question_id, recalls.options_en, recalls.options_id,
       recalls.correct_option, recalls.explanation_en, recalls.explanation_id, TRUE
FROM recalls
JOIN public.lessons AS lesson ON lesson.slug = recalls.slug
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en, question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en, options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en, explanation_id = EXCLUDED.explanation_id,
  is_active = TRUE;

COMMIT;
