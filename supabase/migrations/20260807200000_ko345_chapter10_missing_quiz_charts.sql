-- KO-345 follow-up: attach chart visuals to Chapter 10 visual_applied
-- questions that were missing charts. Charts are illustrative only; answer
-- keys and explanations are unchanged.

BEGIN;

-- chart-support-resistance (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":102,"high":110,"low":101,"close":108,"label":"A"},{"open":108,"high":112,"low":104,"close":105,"label":"B"},{"open":105,"high":107,"low":99,"close":102,"label":"C"},{"open":102,"high":109,"low":101,"close":108,"label":"D"}],"priceScale":[100,110],"markers":[{"number":1,"candleIndex":2,"position":"low","side":"left"},{"number":2,"candleIndex":2,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Why is support described as a zone rather than a single price?';

-- chart-support-resistance (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":102,"high":110,"low":101,"close":108,"label":"A"},{"open":108,"high":112,"low":104,"close":105,"label":"B"},{"open":105,"high":107,"low":99,"close":102,"label":"C"},{"open":102,"high":109,"low":101,"close":108,"label":"D"}],"priceScale":[100,110],"markers":[{"number":1,"candleIndex":2,"position":"low","side":"left"},{"number":2,"candleIndex":2,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Mengapa support dijelaskan sebagai zona bukan harga tunggal?';

-- chart-support-resistance (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":102,"high":110,"low":101,"close":108,"label":"A"},{"open":108,"high":112,"low":104,"close":105,"label":"B"},{"open":105,"high":107,"low":99,"close":102,"label":"C"},{"open":102,"high":109,"low":101,"close":108,"label":"D"}],"priceScale":[100,110],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":3,"position":"high","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'In the chart, resistance is where price has repeatedly done what?';

-- chart-support-resistance (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":102,"high":110,"low":101,"close":108,"label":"A"},{"open":108,"high":112,"low":104,"close":105,"label":"B"},{"open":105,"high":107,"low":99,"close":102,"label":"C"},{"open":102,"high":109,"low":101,"close":108,"label":"D"}],"priceScale":[100,110],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":3,"position":"high","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Pada grafik, resistance adalah area di mana harga berulang kali melakukan apa?';

-- chart-support-resistance (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":102,"high":110,"low":101,"close":108,"label":"A"},{"open":108,"high":112,"low":104,"close":105,"label":"B"},{"open":105,"high":107,"low":99,"close":102,"label":"C"},{"open":102,"high":109,"low":101,"close":108,"label":"D"}],"priceScale":[100,110],"markers":[{"number":1,"candleIndex":2,"position":"low","side":"left"},{"number":2,"candleIndex":2,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'If price briefly moves below a support zone then returns, what does that suggest?';

-- chart-support-resistance (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":102,"high":110,"low":101,"close":108,"label":"A"},{"open":108,"high":112,"low":104,"close":105,"label":"B"},{"open":105,"high":107,"low":99,"close":102,"label":"C"},{"open":102,"high":109,"low":101,"close":108,"label":"D"}],"priceScale":[100,110],"markers":[{"number":1,"candleIndex":2,"position":"low","side":"left"},{"number":2,"candleIndex":2,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Jika harga sebentar bergerak di bawah zona support lalu kembali, apa yang disarankan?';

-- chart-bullish-bearish-doji (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":106,"low":98,"close":106,"label":"Bullish"},{"open":106,"high":107,"low":100,"close":100,"label":"Bearish"},{"open":102,"high":104,"low":100,"close":102,"label":"Doji"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Which candle closes above its open?';

-- chart-bullish-bearish-doji (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":106,"low":98,"close":106,"label":"Bullish"},{"open":106,"high":107,"low":100,"close":100,"label":"Bearish"},{"open":102,"high":104,"low":100,"close":102,"label":"Doji"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Candle mana yang ditutup di atas open-nya?';

-- chart-bullish-bearish-doji (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":106,"low":98,"close":106,"label":"Bullish"},{"open":106,"high":107,"low":100,"close":100,"label":"Bearish"},{"open":102,"high":104,"low":100,"close":102,"label":"Doji"}],"markers":[{"number":1,"candleIndex":2,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'What does a doji mainly show?';

-- chart-bullish-bearish-doji (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":106,"low":98,"close":106,"label":"Bullish"},{"open":106,"high":107,"low":100,"close":100,"label":"Bearish"},{"open":102,"high":104,"low":100,"close":102,"label":"Doji"}],"markers":[{"number":1,"candleIndex":2,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Apa yang utama ditunjukkan oleh doji?';

-- chart-bullish-bearish-doji (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":106,"low":98,"close":106,"label":"Bullish"},{"open":106,"high":107,"low":100,"close":100,"label":"Bearish"},{"open":102,"high":104,"low":100,"close":102,"label":"Doji"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":1,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Why should you not rely only on the bullish or bearish colour?';

-- chart-bullish-bearish-doji (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":106,"low":98,"close":106,"label":"Bullish"},{"open":106,"high":107,"low":100,"close":100,"label":"Bearish"},{"open":102,"high":104,"low":100,"close":102,"label":"Doji"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":1,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Mengapa tidak boleh mengandalkan warna bullish atau bearish saja?';

-- chart-long-wick-rejection (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":108,"low":98,"close":106,"label":"Context"},{"open":106,"high":120,"low":104,"close":108,"label":"Rejection"},{"open":108,"high":109,"low":100,"close":102,"label":"Pullback"}],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":1,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'In the sequence, what created the long upper wick?';

-- chart-long-wick-rejection (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":108,"low":98,"close":106,"label":"Konteks"},{"open":106,"high":120,"low":104,"close":108,"label":"Penolakan"},{"open":108,"high":109,"low":100,"close":102,"label":"Pullback"}],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":1,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Dalam rangkaian, apa yang menciptakan wick atas panjang?';

-- chart-long-wick-rejection (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":108,"low":98,"close":106,"label":"Context"},{"open":106,"high":120,"low":104,"close":108,"label":"Rejection"},{"open":108,"high":109,"low":100,"close":102,"label":"Pullback"}],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":1,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'A long upper wick after a rise is best read as what?';

-- chart-long-wick-rejection (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":108,"low":98,"close":106,"label":"Konteks"},{"open":106,"high":120,"low":104,"close":108,"label":"Penolakan"},{"open":108,"high":109,"low":100,"close":102,"label":"Pullback"}],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":1,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Wick atas panjang setelah kenaikan paling baik dibaca sebagai apa?';

-- chart-long-wick-rejection (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":108,"low":98,"close":106,"label":"Context"},{"open":106,"high":120,"low":104,"close":108,"label":"Rejection"},{"open":108,"high":109,"low":100,"close":102,"label":"Pullback"}],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":2,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'What happened after the long wick formed?';

-- chart-long-wick-rejection (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":108,"low":98,"close":106,"label":"Konteks"},{"open":106,"high":120,"low":104,"close":108,"label":"Penolakan"},{"open":108,"high":109,"low":100,"close":102,"label":"Pullback"}],"markers":[{"number":1,"candleIndex":1,"position":"high","side":"left"},{"number":2,"candleIndex":2,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Apa yang terjadi setelah wick panjang terbentuk?';

-- chart-body-and-wick (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"low","side":"left"},{"number":2,"candleIndex":0,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'A long lower wick with a small body suggests what?';

-- chart-body-and-wick (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"low","side":"left"},{"number":2,"candleIndex":0,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Wick bawah panjang dengan body kecil mengindikasikan apa?';

-- chart-hammer-shooting-star (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Hammer"},{"open":104,"high":118,"low":98,"close":100,"label":"Shooting star"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"right"},{"number":2,"candleIndex":0,"position":"low","side":"left"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'A hammer has a small body and a long wick in which direction?';

-- chart-hammer-shooting-star (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Hammer"},{"open":104,"high":118,"low":98,"close":100,"label":"Shooting star"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"right"},{"number":2,"candleIndex":0,"position":"low","side":"left"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Hammer memiliki body kecil dan wick panjang ke arah mana?';

-- chart-hammer-shooting-star (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Hammer"},{"open":104,"high":118,"low":98,"close":100,"label":"Shooting star"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":1,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Which statement about these patterns is correct?';

-- chart-hammer-shooting-star (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Hammer"},{"open":104,"high":118,"low":98,"close":100,"label":"Shooting star"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":1,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Pernyataan mana tentang pola-pola ini yang benar?';

-- chart-hammer-shooting-star (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Hammer"},{"open":104,"high":118,"low":98,"close":100,"label":"Shooting star"}],"markers":[{"number":1,"candleIndex":1,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":1,"position":"high","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'An inverted hammer has a long upper wick and a small body near which end?';

-- chart-hammer-shooting-star (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":104,"high":106,"low":92,"close":106,"label":"Hammer"},{"open":104,"high":118,"low":98,"close":100,"label":"Shooting star"}],"markers":[{"number":1,"candleIndex":1,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":1,"position":"high","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Inverted hammer memiliki wick atas panjang dan body kecil di dekat ujung mana?';

-- chart-trend-and-timeframe (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":104,"low":99,"close":103,"label":"Day 1"},{"open":103,"high":105,"low":102,"close":104,"label":"Day 2"},{"open":104,"high":106,"low":103,"close":105,"label":"Day 3"},{"open":105,"high":107,"low":104,"close":106,"label":"Day 4"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":3,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'The daily chart shows a smoother trend because each candle covers what?';

-- chart-trend-and-timeframe (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":104,"low":99,"close":103,"label":"Hari 1"},{"open":103,"high":105,"low":102,"close":104,"label":"Hari 2"},{"open":104,"high":106,"low":103,"close":105,"label":"Hari 3"},{"open":105,"high":107,"low":104,"close":106,"label":"Hari 4"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":3,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Grafik harian menunjukkan tren yang lebih halus karena setiap candle mencakup apa?';

-- chart-trend-and-timeframe (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":104,"low":99,"close":103,"label":"Day 1"},{"open":103,"high":105,"low":102,"close":104,"label":"Day 2"},{"open":104,"high":106,"low":103,"close":105,"label":"Day 3"},{"open":105,"high":107,"low":104,"close":106,"label":"Day 4"}],"markers":[{"number":1,"candleIndex":0,"position":"high","side":"left"},{"number":2,"candleIndex":2,"position":"low","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Why does the hourly chart look noisier for the same period?';

-- chart-trend-and-timeframe (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":104,"low":99,"close":103,"label":"Hari 1"},{"open":103,"high":105,"low":102,"close":104,"label":"Hari 2"},{"open":104,"high":106,"low":103,"close":105,"label":"Hari 3"},{"open":105,"high":107,"low":104,"close":106,"label":"Hari 4"}],"markers":[{"number":1,"candleIndex":0,"position":"high","side":"left"},{"number":2,"candleIndex":2,"position":"low","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Mengapa grafik per jam terlihat lebih berisik untuk periode yang sama?';

-- chart-trend-and-timeframe (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":104,"low":99,"close":103,"label":"Day 1"},{"open":103,"high":105,"low":102,"close":104,"label":"Day 2"},{"open":104,"high":106,"low":103,"close":105,"label":"Day 3"},{"open":105,"high":107,"low":104,"close":106,"label":"Day 4"}],"markers":[{"number":1,"candleIndex":1,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":2,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'A pattern should always be read with what information?';

-- chart-trend-and-timeframe (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":104,"low":99,"close":103,"label":"Hari 1"},{"open":103,"high":105,"low":102,"close":104,"label":"Hari 2"},{"open":104,"high":106,"low":103,"close":105,"label":"Hari 3"},{"open":105,"high":107,"low":104,"close":106,"label":"Hari 4"}],"markers":[{"number":1,"candleIndex":1,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":2,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Pola harus selalu dibaca dengan informasi apa?';

-- chart-reading-limits (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":116,"low":94,"close":109,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"high","side":"left"},{"number":2,"candleIndex":0,"position":"low","side":"left"},{"number":3,"candleIndex":0,"position":"open","side":"right"},{"number":4,"candleIndex":0,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Which of these can a price chart show?';

-- chart-reading-limits (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":116,"low":94,"close":109,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"high","side":"left"},{"number":2,"candleIndex":0,"position":"low","side":"left"},{"number":3,"candleIndex":0,"position":"open","side":"right"},{"number":4,"candleIndex":0,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Manakah dari berikut ini yang bisa ditunjukkan grafik harga?';

-- chart-reading-limits (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":116,"low":94,"close":109,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'A chart pattern alone cannot tell you what?';

-- chart-reading-limits (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":116,"low":94,"close":109,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Pola grafik saja tidak dapat memberitahumu apa?';

-- chart-reading-limits (en)
UPDATE public.content_variants
SET body = jsonb_set(body, '{chart}', '{"candles":[{"open":100,"high":116,"low":94,"close":109,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":0,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body->>'question' = 'Why should chart reading be combined with goals and risk limits?';

-- chart-reading-limits (id)
UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{chart}', '{"candles":[{"open":100,"high":116,"low":94,"close":109,"label":"Practice"}],"markers":[{"number":1,"candleIndex":0,"position":"bodyCenter","side":"left"},{"number":2,"candleIndex":0,"position":"close","side":"right"}]}'::jsonb)
WHERE variant_type = 'question'
  AND topic_tag = 'visual_applied'
  AND is_active = true
  AND body_id->>'question' = 'Mengapa membaca grafik harus dikombinasikan dengan tujuan dan batas risiko?';

COMMIT;
