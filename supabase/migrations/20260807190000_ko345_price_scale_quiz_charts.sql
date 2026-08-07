-- KO-345 follow-up: add explicit priceScale levels to Chapter 10 quiz charts
-- whose answer options contain numeric prices/ranges. This lets learners map
-- each option (e.g. "92–120", "100 to 114") to a visible labelled line on
-- the chart.

BEGIN;

-- Lesson 1 (EN): highest price reached — options: 116, 109, 100, 94
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart,priceScale}', '[94, 100, 109, 116]'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Looking at the practice candle, what was the highest price reached?';

-- Lesson 1 (ID): harga tertinggi — options: 116, 109, 100, 94
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart,priceScale}', '[94, 100, 109, 116]'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Melihat candle latihan, berapa harga tertinggi yang tercapai?';

-- Lesson 2 (EN): body runs from which prices — options: 100-114, 92-120, 102-110, 94-116
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart,priceScale}', '[92, 94, 100, 102, 110, 114, 116, 120]'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'In the Up candle, the body runs from which prices?';

-- Lesson 2 (ID): rentang body — options: 100-114, 92-120, 102-110, 94-116
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart,priceScale}', '[92, 94, 100, 102, 110, 114, 116, 120]'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Pada candle Naik, body berada di rentang harga mana?';

COMMIT;
