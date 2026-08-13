-- KO-447 follow-up: show one Kira scenario at a time and label it honestly.
-- The existing lesson visual remains topic-level context; the example pool
-- controls the single visible scenario and the "See another example" action.
BEGIN;

WITH cases(slug, primary_en, primary_id, alternate_en, alternate_id) AS (VALUES
 ('decision-multicandle-context',
  $en$Kira is reviewing an illustrative BBCA sequence in her paper journal. The candles rise, pause, print a long upper wick, and close back near the earlier zone. She records “higher prices were rejected in this interval” instead of calling a reversal. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira meninjau rangkaian BBCA ilustratif di jurnal paper trading-nya. Candle naik, berhenti, membentuk upper wick panjang, lalu ditutup kembali dekat zona sebelumnya. Ia mencatat “harga lebih tinggi ditolak dalam interval ini” alih-alih menyebutnya pembalikan. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira now reviews an illustrative XMLF ETF sequence. The same wick shape appears inside a sideways range, so she writes the timeframe and the next evidence she would need before comparing the pattern. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira kini meninjau rangkaian ETF XMLF ilustratif. Bentuk wick yang sama muncul dalam rentang mendatar, sehingga ia menulis timeframe dan bukti berikutnya yang dibutuhkan sebelum membandingkan pola. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-volume-confirmation',
  $en$Kira notices an illustrative BBRI move with an unusually high volume bar. She checks what event or level might explain the jump instead of copying the move. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira melihat pergerakan BBRI ilustratif dengan bar volume yang sangat tinggi. Ia memeriksa peristiwa atau level yang mungkin menjelaskan lonjakan itu alih-alih meniru pergerakannya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira sees an illustrative XISR ETF volume spike while price stays inside its range. She compares the close, surrounding candles, and later evidence; she does not treat the bar as proof of continuation. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira melihat lonjakan volume ETF XISR ilustratif saat harga tetap dalam rentangnya. Ia membandingkan penutupan, candle sekitar, dan bukti berikutnya; ia tidak menganggap bar itu sebagai bukti kelanjutan. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-zones-false-breakouts',
  $en$Kira marks a reaction zone on an illustrative ANTM chart. Price trades above the zone but closes back inside it, so she labels “breach, then return” and keeps the interpretation provisional. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira menandai zona reaksi pada grafik ANTM ilustratif. Harga diperdagangkan di atas zona tetapi ditutup kembali di dalamnya, sehingga ia menulis “tembus, lalu kembali” dan menjaga interpretasinya tetap sementara. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira studies an illustrative BBCA chart where price tests a prior zone and later closes beyond it. She compares the close and later evidence before using the word breakout. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira mempelajari grafik BBCA ilustratif ketika harga menguji zona sebelumnya lalu kemudian ditutup melewatinya. Ia membandingkan penutupan dan bukti setelahnya sebelum memakai kata breakout. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-timeframe-comparison',
  $en$Kira reviews an illustrative TLKM move on a five-minute chart. The local candles make a small move look dramatic, so she records “short-window detail” before making a claim. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira meninjau pergerakan TLKM ilustratif pada grafik lima menit. Candle lokal membuat pergerakan kecil terlihat dramatis, sehingga ia mencatat “detail jendela pendek” sebelum membuat klaim. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira reviews an illustrative XMLF ETF pullback inside a broader weekly range. She names the timeframe before comparing it with the short view because aggregation changes the visual, not because either view guarantees the next move. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira meninjau pullback ETF XMLF ilustratif di dalam rentang mingguan yang lebih luas. Ia menyebutkan timeframe sebelum membandingkannya dengan tampilan pendek karena agregasi mengubah visual, bukan karena salah satu tampilan menjamin pergerakan berikutnya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-risk-reward',
  $en$Kira uses an illustrative XMLF paper worksheet showing Rp100,000 possible loss versus Rp200,000 possible gain. She writes that 1:2 describes magnitudes only, not the outcome. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira memakai lembar kerja paper trading XMLF ilustratif yang menunjukkan kemungkinan rugi Rp100.000 dibanding kemungkinan untung Rp200.000. Ia menulis bahwa 1:2 hanya menggambarkan besaran, bukan hasil. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira uses an illustrative BBCA worksheet with a smaller possible loss but a shorter review window. She checks essentials, fees, and timing before comparing it with another ratio. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira memakai lembar kerja BBCA ilustratif dengan kemungkinan rugi lebih kecil tetapi periode tinjauan lebih pendek. Ia memeriksa kebutuhan pokok, biaya, dan waktu sebelum membandingkannya dengan rasio lain. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-position-sizing',
  $en$Kira puts an illustrative XISR chart beside two paper plans. One exposes Rp1,000,000 and the other Rp200,000; the candles are identical, but the possible impact differs. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira menempatkan grafik XISR ilustratif di samping dua rencana paper trading. Satu mengekspos Rp1.000.000 dan yang lain Rp200.000; candle-nya sama, tetapi dampak potensialnya berbeda. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira reviews an illustrative BBRI idea while planning for a near-term tuition payment. She keeps that money outside the risk scenario and asks whether the exposure fits her goal. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira meninjau ide BBRI ilustratif saat merencanakan pembayaran uang kuliah dalam waktu dekat. Ia mengeluarkan uang itu dari skenario risiko dan bertanya apakah eksposur sesuai dengan tujuannya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-bias-and-narratives',
  $en$Kira sees a bullish story about illustrative GOTO candles. Three posts agree with it, so she annotates one visible observation that could weaken the story and checks the chart without the caption. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira melihat cerita bullish tentang candle GOTO ilustratif. Tiga unggahan mendukungnya, sehingga ia memberi anotasi pada satu pengamatan yang dapat melemahkan cerita dan memeriksa grafik tanpa caption. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira sees an illustrative ANTM close and volume that do not fit a popular narrative. She separates fact, interpretation, and missing evidence before deciding what to study next. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira melihat penutupan dan volume ANTM ilustratif yang tidak cocok dengan narasi populer. Ia memisahkan fakta, interpretasi, dan bukti yang hilang sebelum memutuskan apa yang dipelajari berikutnya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-thesis-invalidation',
  $en$Kira writes an invalidation boundary before reviewing an illustrative INDF sequence. When the expected evidence no longer appears after the review window, she pauses and reassesses instead of moving the boundary. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira menulis batas pembatalan sebelum meninjau rangkaian INDF ilustratif. Saat bukti yang diharapkan tidak lagi muncul setelah jendela tinjauan, ia berhenti dan menilai ulang alih-alih memindahkan batas. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$,
  $en$Kira reviews an illustrative TLKM thesis with a longer review window. She records the timeframe and checks the evidence at the stated boundary, making the update rule visible instead of treating it as a trade signal. This is an educational scenario, not a current-price claim or recommendation.$en$,
  $id$Kira meninjau tesis TLKM ilustratif dengan jendela tinjauan lebih panjang. Ia mencatat timeframe dan memeriksa bukti pada batas yang ditentukan, sehingga aturan pembaruan terlihat dan tidak dianggap sebagai sinyal transaksi. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$)
)
UPDATE public.content_variants v
SET body = jsonb_build_object('text', cases.primary_en),
    body_id = jsonb_build_object('text', cases.primary_id)
FROM cases JOIN public.lessons l ON l.slug = cases.slug
WHERE v.lesson_id = l.id AND v.variant_type = 'example' AND v.is_active;

WITH cases(slug, alternate_en, alternate_id) AS (VALUES
 ('decision-multicandle-context',$en$Kira now reviews an illustrative XMLF ETF sequence. The same wick shape appears inside a sideways range, so she writes the timeframe and the next evidence she would need before comparing the pattern. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira kini meninjau rangkaian ETF XMLF ilustratif. Bentuk wick yang sama muncul dalam rentang mendatar, sehingga ia menulis timeframe dan bukti berikutnya yang dibutuhkan sebelum membandingkan pola. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-volume-confirmation',$en$Kira sees an illustrative XISR ETF volume spike while price stays inside its range. She compares the close, surrounding candles, and later evidence; she does not treat the bar as proof of continuation. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira melihat lonjakan volume ETF XISR ilustratif saat harga tetap dalam rentangnya. Ia membandingkan penutupan, candle sekitar, dan bukti berikutnya; ia tidak menganggap bar itu sebagai bukti kelanjutan. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-zones-false-breakouts',$en$Kira studies an illustrative BBCA chart where price tests a prior zone and later closes beyond it. She compares the close and later evidence before using the word breakout. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira mempelajari grafik BBCA ilustratif ketika harga menguji zona sebelumnya lalu kemudian ditutup melewatinya. Ia membandingkan penutupan dan bukti setelahnya sebelum memakai kata breakout. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-timeframe-comparison',$en$Kira reviews an illustrative XMLF ETF pullback inside a broader weekly range. She names the timeframe before comparing it with the short view because aggregation changes the visual, not because either view guarantees the next move. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira meninjau pullback ETF XMLF ilustratif di dalam rentang mingguan yang lebih luas. Ia menyebutkan timeframe sebelum membandingkannya dengan tampilan pendek karena agregasi mengubah visual, bukan karena salah satu tampilan menjamin pergerakan berikutnya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-risk-reward',$en$Kira uses an illustrative BBCA worksheet with a smaller possible loss but a shorter review window. She checks essentials, fees, and timing before comparing it with another ratio. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira memakai lembar kerja BBCA ilustratif dengan kemungkinan rugi lebih kecil tetapi periode tinjauan lebih pendek. Ia memeriksa kebutuhan pokok, biaya, dan waktu sebelum membandingkannya dengan rasio lain. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-position-sizing',$en$Kira reviews an illustrative BBRI idea while planning for a near-term tuition payment. She keeps that money outside the risk scenario and asks whether the exposure fits her goal. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira meninjau ide BBRI ilustratif saat merencanakan pembayaran uang kuliah dalam waktu dekat. Ia mengeluarkan uang itu dari skenario risiko dan bertanya apakah eksposur sesuai dengan tujuannya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-bias-and-narratives',$en$Kira sees an illustrative ANTM close and volume that do not fit a popular narrative. She separates fact, interpretation, and missing evidence before deciding what to study next. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira melihat penutupan dan volume ANTM ilustratif yang tidak cocok dengan narasi populer. Ia memisahkan fakta, interpretasi, dan bukti yang hilang sebelum memutuskan apa yang dipelajari berikutnya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-thesis-invalidation',$en$Kira reviews an illustrative TLKM thesis with a longer review window. She records the timeframe and checks the evidence at the stated boundary, making the update rule visible instead of treating it as a trade signal. This is an educational scenario, not a current-price claim or recommendation.$en$,$id$Kira meninjau tesis TLKM ilustratif dengan jendela tinjauan lebih panjang. Ia mencatat timeframe dan memeriksa bukti pada batas yang ditentukan, sehingga aturan pembaruan terlihat dan tidak dianggap sebagai sinyal transaksi. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT l.id, 'example', jsonb_build_object('text', cases.alternate_en), jsonb_build_object('text', cases.alternate_id), l.difficulty, 'Decision Analysis Lab', TRUE
FROM cases JOIN public.lessons l ON l.slug = cases.slug AND l.is_published
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants existing
  WHERE existing.lesson_id = l.id AND existing.variant_type = 'example'
    AND existing.is_active AND existing.body->>'text' = cases.alternate_en
);

DO $$
DECLARE lesson_count INT; example_count INT; illustrative_count INT;
BEGIN
  SELECT COUNT(*) INTO lesson_count FROM public.lessons l JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published;
  SELECT COUNT(*) INTO example_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='example' AND v.is_active;
  SELECT COUNT(*) INTO illustrative_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='example' AND v.is_active AND v.body->>'text' LIKE '%illustrative%';
  IF lesson_count<>8 OR example_count<>16 OR illustrative_count<>16 THEN RAISE EXCEPTION 'KO-447 example presentation mismatch: lessons %, examples %, illustrative %', lesson_count, example_count, illustrative_count; END IF;
END $$;

COMMIT;
