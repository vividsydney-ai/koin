-- KO-345 follow-up: attach chart visuals to existing Chapter 10 visual_applied
-- questions. The original migration skipped these rows because they already
-- existed; this migration adds the chart field to the existing bilingual
-- payloads without touching answer keys or other question content.

BEGIN;

-- Lesson 1: OHLC basics
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{
  "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
  "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Looking at the practice candle, what was the highest price reached?';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{
  "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
  "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Melihat candle latihan, berapa harga tertinggi yang tercapai?';

UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{
  "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
  "markers": [{"number": 1, "candleIndex": 0, "position": "close", "side": "right"}]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Which price tells you where the period ended?';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{
  "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
  "markers": [{"number": 1, "candleIndex": 0, "position": "close", "side": "right"}]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Harga mana yang menunjukkan di mana periode berakhir?';

UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{
  "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Practice"}],
  "markers": [
    {"number": 1, "candleIndex": 0, "position": "low", "side": "left"},
    {"number": 2, "candleIndex": 0, "position": "high", "side": "right"}
  ]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'The distance from 94 to 116 on the candle represents what?';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{
  "candles": [{"open": 100, "high": 116, "low": 94, "close": 109, "label": "Latihan"}],
  "markers": [
    {"number": 1, "candleIndex": 0, "position": "low", "side": "left"},
    {"number": 2, "candleIndex": 0, "position": "high", "side": "right"}
  ]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Jarak dari 94 ke 116 pada candle mewakili apa?';

-- Lesson 2: Body and wick
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{
  "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Up"}],
  "markers": [
    {"number": 1, "candleIndex": 0, "position": "bodyBottom", "side": "left"},
    {"number": 2, "candleIndex": 0, "position": "bodyTop", "side": "right"}
  ]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'In the Up candle, the body runs from which prices?';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{
  "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Naik"}],
  "markers": [
    {"number": 1, "candleIndex": 0, "position": "bodyBottom", "side": "left"},
    {"number": 2, "candleIndex": 0, "position": "bodyTop", "side": "right"}
  ]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Pada candle Naik, body berada di rentang harga mana?';

UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{
  "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Up"}],
  "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'What does the upper wick show?';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{
  "candles": [{"open": 100, "high": 120, "low": 92, "close": 114, "label": "Naik"}],
  "markers": [{"number": 1, "candleIndex": 0, "position": "high", "side": "left"}]
}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Apa yang ditunjukkan oleh wick atas?';

COMMIT;
