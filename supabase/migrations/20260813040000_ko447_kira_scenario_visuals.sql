-- KO-447 follow-up: examples must be persona-led and visually relevant.
-- Kira is a fictional learner; IDX names and chart values are illustrative.
BEGIN;

WITH examples(slug, text_en, text_id) AS (VALUES
 ('decision-multicandle-context',
  $en$Kira is reviewing an illustrative BBCA sequence in her paper journal. Case A: the candles rise, pause, print a long upper wick, and close back near the earlier zone. Kira records “higher prices were rejected in this interval” instead of calling a reversal. Case B: she sees the same wick shape on an illustrative XMLF ETF sequence, but the surrounding range is sideways. She writes the timeframe and the next evidence she would need before comparing the two stories. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira meninjau rangkaian BBCA ilustratif di jurnal paper trading-nya. Kasus A: candle naik, berhenti, membentuk upper wick panjang, lalu ditutup kembali dekat zona sebelumnya. Kira mencatat “harga lebih tinggi ditolak dalam interval ini” alih-alih menyebutnya pembalikan. Kasus B: ia melihat bentuk wick yang sama pada rangkaian ETF XMLF ilustratif, tetapi rentang di sekitarnya mendatar. Ia menulis timeframe dan bukti berikutnya yang dibutuhkan sebelum membandingkan kedua cerita. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-volume-confirmation',
  $en$Kira notices an illustrative BBRI move with an unusually high volume bar. Case A: price advances and participation jumps, so she checks what event or level might explain it instead of copying the move. Case B: an illustrative XISR ETF shows a volume spike while price stays inside its range. Kira compares the close, the surrounding candles, and later evidence; she does not treat the bar as proof of continuation. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira melihat pergerakan BBRI ilustratif dengan bar volume yang sangat tinggi. Kasus A: harga naik dan partisipasi melonjak, sehingga ia memeriksa peristiwa atau level yang mungkin menjelaskannya alih-alih meniru pergerakan. Kasus B: ETF XISR ilustratif menunjukkan lonjakan volume saat harga tetap dalam rentangnya. Kira membandingkan penutupan, candle sekitar, dan bukti berikutnya; ia tidak menganggap bar itu sebagai bukti kelanjutan. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-zones-false-breakouts',
  $en$Kira marks a reaction zone on an illustrative ANTM chart. Case A: price trades above the zone but closes back inside it, so she labels “breach, then return” and keeps the interpretation provisional. Case B: on an illustrative BBCA chart, price tests a prior zone and later closes beyond it. Kira compares the close and later evidence before using the word breakout. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira menandai zona reaksi pada grafik ANTM ilustratif. Kasus A: harga diperdagangkan di atas zona tetapi ditutup kembali di dalamnya, sehingga ia menulis “tembus, lalu kembali” dan menjaga interpretasinya tetap sementara. Kasus B: pada grafik BBCA ilustratif, harga menguji zona sebelumnya lalu kemudian ditutup melewatinya. Kira membandingkan penutupan dan bukti setelahnya sebelum memakai kata breakout. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-timeframe-comparison',
  $en$Kira is deciding whether an illustrative TLKM move is meaningful. Case A: the five-minute chart makes a small move look dramatic because local candles fill the screen; she writes “short-window detail.” Case B: an illustrative XMLF ETF pullback appears inside a broader weekly range. Kira names the timeframe before comparing them, because the visual changes with aggregation—not because either view guarantees the next move. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira sedang menilai apakah pergerakan TLKM ilustratif bermakna. Kasus A: grafik lima menit membuat pergerakan kecil terlihat dramatis karena candle lokal memenuhi layar; ia menulis “detail jendela pendek.” Kasus B: pullback ETF XMLF ilustratif muncul di dalam rentang mingguan yang lebih luas. Kira menyebutkan timeframe sebelum membandingkan keduanya, karena visual berubah akibat agregasi—bukan karena salah satu tampilan menjamin pergerakan berikutnya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-risk-reward',
  $en$Kira uses two illustrative worksheets instead of treating a ratio as a prediction. Case A: her XMLF paper exercise shows Rp100,000 possible loss versus Rp200,000 possible gain; she writes that 1:2 describes magnitudes only. Case B: a BBCA worksheet shows a smaller possible loss but a shorter review window; Kira checks essentials, fees, and timing before comparing the scenarios. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira memakai dua lembar kerja ilustratif, bukan menganggap rasio sebagai ramalan. Kasus A: latihan paper trading XMLF menunjukkan kemungkinan rugi Rp100.000 dibanding kemungkinan untung Rp200.000; ia menulis bahwa 1:2 hanya menggambarkan besaran. Kasus B: lembar kerja BBCA menunjukkan kemungkinan rugi lebih kecil tetapi periode tinjauan lebih pendek; Kira memeriksa kebutuhan pokok, biaya, dan waktu sebelum membandingkan skenario. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-position-sizing',
  $en$Kira puts the same illustrative XISR chart beside two paper plans. Case A: one plan exposes Rp1,000,000 and another exposes Rp200,000; the candles are identical, but the possible impact is not. Case B: Kira has a near-term tuition payment while reviewing an illustrative BBRI idea, so she keeps that money outside the risk scenario. She uses the visual to discuss exposure, not to prove a ticker is convincing. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira menempatkan grafik XISR ilustratif yang sama di samping dua rencana paper trading. Kasus A: satu rencana mengekspos Rp1.000.000 dan yang lain Rp200.000; candle-nya sama, tetapi dampak potensialnya berbeda. Kasus B: Kira memiliki pembayaran uang kuliah dalam waktu dekat saat meninjau ide BBRI ilustratif, sehingga uang itu ia keluarkan dari skenario risiko. Ia memakai visual untuk membahas eksposur, bukan membuktikan ticker itu meyakinkan. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-bias-and-narratives',
  $en$Kira sees a bullish story about illustrative GOTO candles. Case A: three posts agree with the story, so she annotates one visible observation that could weaken it and checks the chart without the caption. Case B: an illustrative ANTM close and volume do not fit the popular narrative, so Kira separates fact, interpretation, and missing evidence. The visual helps her test a story; it does not decide for her. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira melihat cerita bullish tentang candle GOTO ilustratif. Kasus A: tiga unggahan mendukung cerita itu, sehingga ia memberi anotasi pada satu pengamatan yang dapat melemahkannya dan memeriksa grafik tanpa caption. Kasus B: penutupan dan volume ANTM ilustratif tidak cocok dengan narasi populer, sehingga Kira memisahkan fakta, interpretasi, dan bukti yang hilang. Visual membantu menguji cerita; bukan mengambil keputusan untuknya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$),
 ('decision-thesis-invalidation',
  $en$Kira writes an invalidation boundary before reviewing an illustrative INDF sequence. Case A: the evidence she expected no longer appears after the review window, so she pauses and reassesses instead of moving the boundary. Case B: an illustrative TLKM thesis uses a longer window, so Kira records that timeframe and checks the evidence at the stated boundary. The visual makes the update rule visible; it is not an automatic buy or sell instruction. These are educational scenarios, not current-price claims or recommendations.$en$,
  $id$Kira menulis batas pembatalan sebelum meninjau rangkaian INDF ilustratif. Kasus A: bukti yang ia harapkan tidak lagi muncul setelah jendela tinjauan, sehingga ia berhenti dan menilai ulang alih-alih memindahkan batas. Kasus B: tesis TLKM ilustratif memakai jendela yang lebih panjang, sehingga Kira mencatat timeframe dan memeriksa bukti pada batas yang ditentukan. Visual membuat aturan pembaruan terlihat; ini bukan instruksi beli atau jual otomatis. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.$id$)
)
UPDATE public.content_variants v
SET body = jsonb_build_object('text', examples.text_en),
    body_id = jsonb_build_object('text', examples.text_id)
FROM examples
JOIN public.lessons l ON l.slug = examples.slug AND l.is_published
WHERE v.lesson_id = l.id AND v.variant_type = 'example' AND v.is_active;

-- Match each example visual to Kira's actual question rather than reusing a
-- generic concept chart without a learner-facing purpose.
WITH visuals(slug, block_type, content) AS (VALUES
 ('decision-multicandle-context','annotated_data',$json${"en":{"icon":"🕯️","eyebrow":"Kira's chart note","title":"Kira separates a wick from a forecast","altText":"Illustrative BBCA and XMLF candle sequences show a wick, a return, and the surrounding context.","disclosure":"Illustrative chart only. Kira is practising observation, not predicting a price.","payload":{"quoteTitle":"Kira's observation","chart":{"accent":"advanced","candles":[{"open":100,"high":108,"low":98,"close":106,"volume":42,"label":"BBCA · rise"},{"open":106,"high":109,"low":103,"close":105,"volume":45,"label":"BBCA · pause"},{"open":105,"high":114,"low":101,"close":102,"volume":78,"label":"BBCA · wick"},{"open":102,"high":106,"low":99,"close":103,"volume":55,"label":"BBCA · close"}],"markers":[{"number":1,"candleIndex":2,"position":"high"},{"number":2,"candleIndex":3,"position":"close"}]},"annotations":[{"number":1,"label":"Observe the wick","detail":"Record what happened inside the interval."},{"number":2,"label":"Check the close","detail":"Compare it with the prior zone before naming a pattern."}]}},"id":{"icon":"🕯️","eyebrow":"Catatan grafik Kira","title":"Kira memisahkan wick dari ramalan","altText":"Rangkaian candle BBCA dan XMLF ilustratif menunjukkan wick, kembalinya harga, dan konteks sekitar.","disclosure":"Hanya grafik ilustratif. Kira berlatih mengamati, bukan meramalkan harga.","payload":{"quoteTitle":"Pengamatan Kira","chart":{"accent":"advanced","candles":[{"open":100,"high":108,"low":98,"close":106,"volume":42,"label":"BBCA · naik"},{"open":106,"high":109,"low":103,"close":105,"volume":45,"label":"BBCA · jeda"},{"open":105,"high":114,"low":101,"close":102,"volume":78,"label":"BBCA · wick"},{"open":102,"high":106,"low":99,"close":103,"volume":55,"label":"BBCA · tutup"}],"markers":[{"number":1,"candleIndex":2,"position":"high"},{"number":2,"candleIndex":3,"position":"close"}]},"annotations":[{"number":1,"label":"Amati wick","detail":"Catat apa yang terjadi dalam interval."},{"number":2,"label":"Periksa penutupan","detail":"Bandingkan dengan zona sebelumnya sebelum menamai pola."}]}}}$json$),
 ('decision-volume-confirmation','annotated_data',$json${"en":{"icon":"📊","eyebrow":"Kira checks participation","title":"A volume spike starts a question","altText":"Illustrative BBRI and XISR charts show ordinary activity, a spike, and a range-bound close.","disclosure":"Illustrative volume only. A spike is evidence to investigate, not proof of continuation.","payload":{"quoteTitle":"Kira's next question","chart":{"accent":"advanced","candles":[{"open":100,"high":103,"low":99,"close":102,"volume":24,"label":"BBRI · ordinary"},{"open":102,"high":104,"low":101,"close":103,"volume":28,"label":"BBRI · ordinary"},{"open":103,"high":108,"low":102,"close":107,"volume":92,"label":"BBRI · spike"},{"open":107,"high":109,"low":104,"close":105,"volume":64,"label":"BBRI · check"}],"markers":[{"number":1,"candleIndex":2,"position":"bodyCenter"},{"number":2,"candleIndex":3,"position":"close"}]},"annotations":[{"number":1,"label":"Spot the change","detail":"Participation rose sharply in this interval."},{"number":2,"label":"Ask what explains it","detail":"Check the close, level, event, and later evidence."}]}},"id":{"icon":"📊","eyebrow":"Kira memeriksa partisipasi","title":"Lonjakan volume memulai pertanyaan","altText":"Grafik BBRI dan XISR ilustratif menunjukkan aktivitas biasa, lonjakan, dan penutupan dalam rentang.","disclosure":"Hanya volume ilustratif. Lonjakan adalah bukti untuk diperiksa, bukan bukti kelanjutan.","payload":{"quoteTitle":"Pertanyaan Kira berikutnya","chart":{"accent":"advanced","candles":[{"open":100,"high":103,"low":99,"close":102,"volume":24,"label":"BBRI · biasa"},{"open":102,"high":104,"low":101,"close":103,"volume":28,"label":"BBRI · biasa"},{"open":103,"high":108,"low":102,"close":107,"volume":92,"label":"BBRI · lonjakan"},{"open":107,"high":109,"low":104,"close":105,"volume":64,"label":"BBRI · periksa"}],"markers":[{"number":1,"candleIndex":2,"position":"bodyCenter"},{"number":2,"candleIndex":3,"position":"close"}]},"annotations":[{"number":1,"label":"Lihat perubahannya","detail":"Partisipasi meningkat tajam dalam interval ini."},{"number":2,"label":"Tanyakan penjelasannya","detail":"Periksa penutupan, level, peristiwa, dan bukti berikutnya."}]}}}$json$),
 ('decision-zones-false-breakouts','annotated_data',$json${"en":{"icon":"🧭","eyebrow":"Kira labels the boundary","title":"A breach is not the whole story","altText":"Illustrative ANTM and BBCA candles show a zone breach followed by a return inside the zone.","disclosure":"Illustrative chart only. Kira is labelling evidence, not issuing a trade signal.","payload":{"quoteTitle":"Breach, then return","chart":{"accent":"advanced","candles":[{"open":100,"high":104,"low":98,"close":102,"volume":40,"label":"ANTM · zone"},{"open":102,"high":106,"low":101,"close":105,"volume":48,"label":"ANTM · test"},{"open":105,"high":111,"low":104,"close":106,"volume":86,"label":"ANTM · breach"},{"open":106,"high":107,"low":101,"close":102,"volume":73,"label":"ANTM · return"}],"markers":[{"number":1,"candleIndex":2,"position":"high"},{"number":2,"candleIndex":3,"position":"close"}]},"annotations":[{"number":1,"label":"Mark the breach","detail":"Price moved beyond the prior reaction area."},{"number":2,"label":"Mark the return","detail":"The close back inside changes the description."}]}},"id":{"icon":"🧭","eyebrow":"Kira menandai batas","title":"Penembusan bukan seluruh ceritanya","altText":"Candle ANTM dan BBCA ilustratif menunjukkan penembusan zona lalu kembali ke dalam zona.","disclosure":"Hanya grafik ilustratif. Kira menandai bukti, bukan memberi sinyal transaksi.","payload":{"quoteTitle":"Tembus, lalu kembali","chart":{"accent":"advanced","candles":[{"open":100,"high":104,"low":98,"close":102,"volume":40,"label":"ANTM · zona"},{"open":102,"high":106,"low":101,"close":105,"volume":48,"label":"ANTM · uji"},{"open":105,"high":111,"low":104,"close":106,"volume":86,"label":"ANTM · tembus"},{"open":106,"high":107,"low":101,"close":102,"volume":73,"label":"ANTM · kembali"}],"markers":[{"number":1,"candleIndex":2,"position":"high"},{"number":2,"candleIndex":3,"position":"close"}]},"annotations":[{"number":1,"label":"Tandai penembusan","detail":"Harga bergerak melewati area reaksi sebelumnya."},{"number":2,"label":"Tandai kembalinya harga","detail":"Penutupan kembali mengubah deskripsi."}]}}}$json$)
)
UPDATE public.lesson_visual_blocks b
SET block_type = visuals.block_type, content = visuals.content, is_published = TRUE, updated_at = NOW()
FROM visuals JOIN public.lessons l ON l.slug = visuals.slug
WHERE b.lesson_id = l.id AND b.placement = 'example' AND b.display_order = 10 AND l.is_published;

-- The remaining five lessons already use the correct visual primitive
-- (timeframe, ratio, sizing, bias, or invalidation). Keep those payloads, but
-- make the learner POV explicit so the visual is not presented as a ticker
-- label without a decision context.
UPDATE public.lesson_visual_blocks b
SET content = jsonb_set(
  jsonb_set(
    jsonb_set(b.content, '{en,eyebrow}', '"Kira tests the idea"'::jsonb, TRUE),
    '{en,title}', to_jsonb(CASE l.slug
      WHEN 'decision-timeframe-comparison' THEN 'Kira changes the timeframe'
      WHEN 'decision-risk-reward' THEN 'Kira compares the downside'
      WHEN 'decision-position-sizing' THEN 'Kira changes the exposure'
      WHEN 'decision-bias-and-narratives' THEN 'Kira tests the story'
      ELSE 'Kira writes the boundary' END), TRUE
  ),
  '{id,eyebrow}', '"Kira menguji ide"'::jsonb, TRUE
)
FROM public.lessons l
JOIN public.topics t ON t.id = l.topic_id AND t.chapter = 'Decision Analysis Lab'
WHERE b.lesson_id = l.id AND b.placement = 'example' AND b.display_order = 10
  AND l.is_published
  AND l.slug NOT IN ('decision-multicandle-context','decision-volume-confirmation','decision-zones-false-breakouts');

UPDATE public.lesson_visual_blocks b
SET content = jsonb_set(
  b.content,
  '{id,title}',
  to_jsonb(CASE l.slug
    WHEN 'decision-timeframe-comparison' THEN 'Kira mengganti timeframe'
    WHEN 'decision-risk-reward' THEN 'Kira membandingkan sisi buruk'
    WHEN 'decision-position-sizing' THEN 'Kira mengubah eksposur'
    WHEN 'decision-bias-and-narratives' THEN 'Kira menguji cerita'
    ELSE 'Kira menulis batas' END), TRUE
)
FROM public.lessons l
JOIN public.topics t ON t.id = l.topic_id AND t.chapter = 'Decision Analysis Lab'
WHERE b.lesson_id = l.id AND b.placement = 'example' AND b.display_order = 10
  AND l.is_published
  AND l.slug NOT IN ('decision-multicandle-context','decision-volume-confirmation','decision-zones-false-breakouts');

DO $$
DECLARE example_count INT; kira_count INT; visual_count INT;
BEGIN
  SELECT COUNT(*) INTO example_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='example' AND v.is_active AND v.body->>'text' LIKE '%Kira%';
  SELECT COUNT(*) INTO kira_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='example' AND v.is_active AND v.body_id->>'text' LIKE '%Kira%';
  SELECT COUNT(*) INTO visual_count FROM public.lesson_visual_blocks b JOIN public.lessons l ON l.id=b.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND b.placement='example' AND b.is_published AND b.content->'en'->>'title' LIKE '%Kira%';
  IF example_count<>8 OR kira_count<>8 OR visual_count<>8 THEN RAISE EXCEPTION 'KO-447 Kira coverage mismatch: en %, id %, visuals %', example_count, kira_count, visual_count; END IF;
END $$;

COMMIT;
