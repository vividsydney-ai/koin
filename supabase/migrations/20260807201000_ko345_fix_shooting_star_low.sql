-- KO-345 follow-up fix: the shooting-star candle in the hammer/shooting-star
-- quiz charts had low=102, which is invalid because close=100. Lower the low
-- to 98 so the candle satisfies low <= min(open, close).

BEGIN;

UPDATE public.content_variants
SET body = jsonb_set(body, '{chart,candles,1,low}', '98'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->'chart'->'candles'->1->>'label' = 'Shooting star';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart,candles,1,low}', '98'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->'chart'->'candles'->1->>'label' = 'Shooting star';

COMMIT;
