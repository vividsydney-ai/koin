-- KO-225: the English simpler-explanation variants for fz-interest were
-- accidentally duplicated from the Indonesian body. Keep body_id Indonesian.

UPDATE public.content_variants
SET body = jsonb_set(body, '{text}', to_jsonb('Simple interest is calculated only on the original amount. The formula is: Interest = Principal × Interest rate × Time.'::text))
WHERE id = '9fd4a7c7-a2f7-4912-9858-61bbcdb06116';

UPDATE public.content_variants
SET body = jsonb_set(body, '{text}', to_jsonb('Interest can be a reward when you save or invest, or a cost when you borrow. The amount depends on the interest rate, the amount of money, and the length of time.'::text))
WHERE id = '96f4a5cb-0d9c-4f69-88ea-34b5ec673823';
