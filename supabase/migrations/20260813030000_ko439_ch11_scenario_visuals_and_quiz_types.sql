-- KO-439: make Chapter 11 scenarios visibly teach the idea, and preserve
-- true/false as true/false instead of disguising it as multiple choice.
-- All ticker references and candles are illustrative learning examples.
BEGIN;

-- The example step was showing text only because the existing chart blocks
-- were placed in the concept slot. Give each lesson's "How this plays out"
-- section the same chart, so the two written cases have an accompanying visual.
INSERT INTO public.lesson_visual_blocks (
  lesson_id, placement, block_type, display_order, data_status, content, is_published
)
SELECT
  b.lesson_id,
  'example',
  b.block_type,
  10,
  b.data_status,
  jsonb_set(
    jsonb_set(b.content, '{en,title}', '"Read the scenario chart"'::jsonb),
    '{id,title}', '"Baca grafik skenarionya"'::jsonb
  ),
  TRUE
FROM public.lesson_visual_blocks b
JOIN public.lessons l ON l.id = b.lesson_id AND l.is_published
JOIN public.topics t ON t.id = l.topic_id AND t.chapter = 'Decision Analysis Lab'
WHERE b.placement = 'concept'
  AND b.display_order = 10
  AND NOT EXISTS (
    SELECT 1 FROM public.lesson_visual_blocks existing
    WHERE existing.lesson_id = b.lesson_id
      AND existing.placement = 'example'
      AND existing.display_order = 10
  );

-- The following statements are propositions, not option-selection questions.
-- Convert them to the real true_false interaction and retain the chart.
WITH statements(question_en, question_id, answer_en, answer_id) AS (
  VALUES
    ('High volume proves a price move will continue.', 'Volume tinggi membuktikan pergerakan harga akan berlanjut.', FALSE, FALSE),
    ('A longer timeframe removes market risk.', 'Timeframe lebih panjang menghapus risiko pasar.', FALSE, FALSE),
    ('A favourable ratio can still lose money.', 'Rasio yang tampak baik tetap dapat menghasilkan kerugian.', TRUE, TRUE),
    ('Money needed for rent, food, debt, or near-term goals is available risk capital.', 'Uang untuk sewa, makan, utang, atau tujuan dekat adalah modal risiko.', FALSE, FALSE),
    ('An official source automatically proves your interpretation is correct.', 'Sumber resmi otomatis membuktikan interpretasimu benar.', FALSE, FALSE),
    ('Changing a thesis after new evidence appears can be disciplined decision-making.', 'Mengubah tesis setelah bukti baru muncul dapat menjadi keputusan disiplin.', TRUE, TRUE)
)
UPDATE public.content_variants v
SET
  body = jsonb_set(
    jsonb_set(v.body - 'options', '{type}', '"true_false"'::jsonb, TRUE),
    '{answer}', to_jsonb(s.answer_en), TRUE
  ),
  body_id = jsonb_set(
    jsonb_set(v.body_id - 'options', '{type}', '"true_false"'::jsonb, TRUE),
    '{answer}', to_jsonb(s.answer_id), TRUE
  )
FROM statements s
JOIN public.lessons l ON l.is_published
JOIN public.topics t ON t.id = l.topic_id AND t.chapter = 'Decision Analysis Lab'
WHERE v.lesson_id = l.id
  AND v.variant_type = 'question'
  AND v.topic_tag = 'visual_applied'
  AND v.is_active
  AND v.body->>'question' = s.question_en
  AND v.body_id->>'question' = s.question_id;

-- SQL string literals preserve the backslash in the old content write. Turn
-- those separators into real paragraph breaks for readable Case A / Case B.
UPDATE public.content_variants v
SET
  body = jsonb_set(v.body, '{text}', to_jsonb(replace(v.body->>'text', E'\\n', E'\n')), TRUE),
  body_id = jsonb_set(v.body_id, '{text}', to_jsonb(replace(v.body_id->>'text', E'\\n', E'\n')), TRUE)
FROM public.lessons l
JOIN public.topics t ON t.id = l.topic_id AND t.chapter = 'Decision Analysis Lab'
WHERE v.lesson_id = l.id
  AND l.is_published
  AND v.variant_type = 'example'
  AND v.is_active
  AND (v.body->>'text' LIKE '%Case A%' OR v.body_id->>'text' LIKE '%Kasus A%');

DO $$
DECLARE
  lesson_count INT;
  example_visual_count INT;
  true_false_count INT;
  malformed_statement_count INT;
BEGIN
  SELECT COUNT(*) INTO lesson_count
  FROM public.lessons l JOIN public.topics t ON t.id = l.topic_id
  WHERE t.chapter = 'Decision Analysis Lab' AND l.is_published;

  SELECT COUNT(DISTINCT b.lesson_id) INTO example_visual_count
  FROM public.lesson_visual_blocks b
  JOIN public.lessons l ON l.id = b.lesson_id
  JOIN public.topics t ON t.id = l.topic_id
  WHERE t.chapter = 'Decision Analysis Lab' AND l.is_published
    AND b.placement = 'example' AND b.is_published;

  SELECT COUNT(*) INTO true_false_count
  FROM public.content_variants v
  JOIN public.lessons l ON l.id = v.lesson_id
  JOIN public.topics t ON t.id = l.topic_id
  WHERE t.chapter = 'Decision Analysis Lab' AND l.is_published
    AND v.variant_type = 'question' AND v.topic_tag = 'visual_applied'
    AND v.is_active AND v.body->>'type' = 'true_false'
    AND v.body_id->>'type' = 'true_false';

  SELECT COUNT(*) INTO malformed_statement_count
  FROM public.content_variants v
  JOIN public.lessons l ON l.id = v.lesson_id
  JOIN public.topics t ON t.id = l.topic_id
  WHERE t.chapter = 'Decision Analysis Lab' AND l.is_published
    AND v.variant_type = 'question' AND v.topic_tag = 'visual_applied'
    AND v.is_active
    AND v.body->>'question' IN (
      'High volume proves a price move will continue.',
      'A longer timeframe removes market risk.',
      'A favourable ratio can still lose money.',
      'Money needed for rent, food, debt, or near-term goals is available risk capital.',
      'An official source automatically proves your interpretation is correct.',
      'Changing a thesis after new evidence appears can be disciplined decision-making.'
    )
    AND v.body->>'type' <> 'true_false';

  IF lesson_count <> 8 OR example_visual_count <> 8 OR true_false_count <> 6 OR malformed_statement_count <> 0 THEN
    RAISE EXCEPTION 'KO-439 mismatch: lessons %, example visuals %, true_false %, malformed %', lesson_count, example_visual_count, true_false_count, malformed_statement_count;
  END IF;
END $$;

COMMIT;
