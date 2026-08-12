-- KO-447: Corrective Chapter 11 visual-learning pass.
-- The previous pass met a count target but left the applied checks text-first.
-- These charts are illustrative scenarios, not live prices or trade signals.
BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES
  (
    'KO447-FIDELITY-TA-OVERVIEW',
    'What is technical analysis?',
    'Apa itu analisis teknikal?',
    2, 'website', 'Fidelity Learning Center',
    'https://www.fidelity.com/learning-center/trading-investing/technical-analysis/what-is-technical-analysis',
    'en', '2026-08-13', 'verified',
    'Accessible educational overview of charts, patterns, support/resistance, and volume. It does not guarantee an outcome.',
    'Ringkasan edukasi yang dapat diakses tentang grafik, pola, support/resistance, dan volume. Sumber ini tidak menjamin hasil.',
    'Fidelity explains technical analysis as a way to study historical price and volume information while keeping the limits of pattern evidence visible.',
    'Fidelity menjelaskan analisis teknikal sebagai cara mempelajari informasi harga dan volume historis sambil tetap menyadari batas bukti pola.',
    'Use this as a readable companion to the official Indonesian source when the lesson distinguishes observation from prediction.',
    'Gunakan sebagai bacaan pendamping yang mudah diakses saat pelajaran membedakan pengamatan dari prediksi.'
  ),
  (
    'KO447-SCHWAB-CHART-PATTERNS',
    'How to read stock charts and trading patterns',
    'Cara membaca grafik saham dan pola perdagangan',
    2, 'website', 'Charles Schwab',
    'https://www.schwab.com/learn/story/how-to-read-stock-charts-and-trading-patterns',
    'en', '2026-08-13', 'verified',
    'Accessible market-literacy article covering chart types, breakouts, confirmation, and false signals.',
    'Artikel literasi pasar yang dapat diakses tentang jenis grafik, breakout, konfirmasi, dan sinyal palsu.',
    'Use for chart-reading vocabulary and the discipline of waiting for confirmation rather than treating one shape as a forecast.',
    'Gunakan untuk kosakata membaca grafik dan disiplin menunggu konfirmasi, bukan menganggap satu bentuk sebagai ramalan.',
    'Supports the chart-led breakout, wick, timeframe, and invalidation checks.',
    'Mendukung pemeriksaan berbasis grafik tentang breakout, wick, timeframe, dan pembatalan tesis.'
  ),
  (
    'KO447-SCHWAB-VOLUME-CONFIRMATION',
    'Ways volume can help confirm price trends',
    'Cara volume membantu mengonfirmasi tren harga',
    2, 'website', 'Charles Schwab',
    'https://www.schwab.com/learn/story/ways-volume-can-help-confirm-price-trends',
    'en', '2026-08-13', 'verified',
    'Accessible educational article showing volume as context for price moves, not a standalone guarantee.',
    'Artikel edukasi yang dapat diakses yang menunjukkan volume sebagai konteks pergerakan harga, bukan jaminan tersendiri.',
    'Supports the distinction between unusual participation and a proven continuation.',
    'Mendukung pembedaan antara partisipasi tidak biasa dan kelanjutan yang sudah terbukti.',
    'Supports the visual volume-confirmation checks.',
    'Mendukung pemeriksaan visual tentang konfirmasi volume.'
  ),
  (
    'KO447-BRIDGEWATER-RISK-PRINCIPLES',
    'Principles for navigating big debt crises',
    'Prinsip menghadapi krisis utang besar',
    2, 'report', 'Bridgewater Associates / Ray Dalio',
    'https://www.bridgewater.com/big-debt-crises/principles-for-navigating-big-debt-crises-by-ray-dalio.pdf',
    'en', '2026-08-13', 'verified',
    'Respectable macro-risk reference. It is used for uncertainty and risk framing, not as a source of stock-specific predictions.',
    'Referensi risiko makro yang bereputasi. Digunakan untuk kerangka ketidakpastian dan risiko, bukan prediksi saham tertentu.',
    'Use as a broader risk-context reading alongside, never instead of, the official primary source.',
    'Gunakan sebagai bacaan konteks risiko yang lebih luas bersama sumber primer resmi, bukan sebagai penggantinya.',
    'Supports the lessons on downside, exposure, and updating a thesis under uncertainty.',
    'Mendukung pelajaran tentang sisi buruk, eksposur, dan pembaruan tesis dalam ketidakpastian.'
  )
ON CONFLICT (source_code) DO UPDATE SET
  title=EXCLUDED.title, local_title=EXCLUDED.local_title, source_tier=EXCLUDED.source_tier,
  source_type=EXCLUDED.source_type, organization=EXCLUDED.organization, url=EXCLUDED.url,
  language=EXCLUDED.language, last_checked_at=EXCLUDED.last_checked_at, status=EXCLUDED.status,
  trust_notes=EXCLUDED.trust_notes, localization_notes=EXCLUDED.localization_notes,
  synopsis=EXCLUDED.synopsis, synopsis_id=EXCLUDED.synopsis_id,
  relevance_blurb=EXCLUDED.relevance_blurb, relevance_blurb_id=EXCLUDED.relevance_blurb_id;

WITH support(slug, source_code, label, display_order) AS (VALUES
  ('decision-multicandle-context','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-multicandle-context','KO447-SCHWAB-CHART-PATTERNS','Schwab: chart patterns',30),
  ('decision-volume-confirmation','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-volume-confirmation','KO447-SCHWAB-VOLUME-CONFIRMATION','Schwab: volume context',30),
  ('decision-zones-false-breakouts','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-zones-false-breakouts','KO447-SCHWAB-CHART-PATTERNS','Schwab: chart patterns',30),
  ('decision-timeframe-comparison','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-timeframe-comparison','KO447-SCHWAB-CHART-PATTERNS','Schwab: chart patterns',30),
  ('decision-risk-reward','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-risk-reward','KO447-BRIDGEWATER-RISK-PRINCIPLES','Bridgewater: risk context',30),
  ('decision-position-sizing','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-position-sizing','KO447-BRIDGEWATER-RISK-PRINCIPLES','Bridgewater: risk context',30),
  ('decision-bias-and-narratives','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-bias-and-narratives','KO447-BRIDGEWATER-RISK-PRINCIPLES','Bridgewater: risk context',30),
  ('decision-thesis-invalidation','KO447-FIDELITY-TA-OVERVIEW','Fidelity: technical-analysis overview',20),
  ('decision-thesis-invalidation','KO447-BRIDGEWATER-RISK-PRINCIPLES','Bridgewater: risk context',30)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT l.id, s.id, 'supporting', support.label, FALSE, support.display_order
FROM support
JOIN public.lessons l ON l.slug=support.slug AND l.is_published
JOIN public.sources s ON s.source_code=support.source_code
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type=EXCLUDED.relevance_type, citation_label=EXCLUDED.citation_label,
  is_primary=FALSE, display_order=EXCLUDED.display_order;

-- Make the existing five-question pool chart-led without losing its already
-- audited variety. Volume is rendered as a compact bar series under candles.
WITH charts(slug, chart) AS (VALUES
 ('decision-multicandle-context',$json$ {"candles":[{"open":100,"high":108,"low":98,"close":106,"volume":42,"label":"BBCA · rise"},{"open":106,"high":109,"low":103,"close":105,"volume":45,"label":"BBCA · pause"},{"open":105,"high":114,"low":101,"close":102,"volume":78,"label":"BBCA · long wick"},{"open":102,"high":106,"low":99,"close":103,"volume":55,"label":"BBCA · follow"}],"markers":[{"number":1,"candleIndex":2,"position":"high"},{"number":2,"candleIndex":3,"position":"close"}]} $json$::jsonb),
 ('decision-volume-confirmation',$json$ {"candles":[{"open":100,"high":103,"low":99,"close":102,"volume":24,"label":"BBRI · ordinary"},{"open":102,"high":104,"low":101,"close":103,"volume":28,"label":"BBRI · ordinary"},{"open":103,"high":108,"low":102,"close":107,"volume":92,"label":"BBRI · high volume"},{"open":107,"high":109,"low":104,"close":105,"volume":64,"label":"BBRI · check"}],"markers":[{"number":1,"candleIndex":2,"position":"bodyCenter"},{"number":2,"candleIndex":3,"position":"close"}]} $json$::jsonb),
 ('decision-zones-false-breakouts',$json$ {"candles":[{"open":100,"high":104,"low":98,"close":102,"volume":40,"label":"ANTM · zone"},{"open":102,"high":106,"low":101,"close":105,"volume":48,"label":"ANTM · test"},{"open":105,"high":111,"low":104,"close":106,"volume":86,"label":"ANTM · breach"},{"open":106,"high":107,"low":101,"close":102,"volume":73,"label":"ANTM · return"}],"markers":[{"number":1,"candleIndex":2,"position":"high"},{"number":2,"candleIndex":3,"position":"close"}]} $json$::jsonb),
 ('decision-timeframe-comparison',$json$ {"candles":[{"open":100,"high":103,"low":99,"close":102,"volume":30,"label":"TLKM · 5m"},{"open":102,"high":106,"low":101,"close":105,"volume":36,"label":"TLKM · 5m"},{"open":100,"high":108,"low":98,"close":104,"volume":66,"label":"TLKM · daily"},{"open":104,"high":109,"low":101,"close":106,"volume":60,"label":"TLKM · daily"}],"markers":[{"number":1,"candleIndex":1,"position":"close"},{"number":2,"candleIndex":3,"position":"close"}]} $json$::jsonb),
 ('decision-risk-reward',$json$ {"candles":[{"open":100,"high":103,"low":96,"close":101,"volume":40,"label":"XMLF · risk"},{"open":101,"high":108,"low":99,"close":106,"volume":52,"label":"XMLF · gain"},{"open":106,"high":109,"low":102,"close":104,"volume":44,"label":"XMLF · outcome"}],"markers":[{"number":1,"candleIndex":0,"position":"low"},{"number":2,"candleIndex":1,"position":"high"}]} $json$::jsonb),
 ('decision-position-sizing',$json$ {"candles":[{"open":100,"high":104,"low":95,"close":98,"volume":38,"label":"XISR · small"},{"open":98,"high":101,"low":90,"close":92,"volume":58,"label":"XISR · drawdown"},{"open":92,"high":96,"low":89,"close":94,"volume":48,"label":"XISR · review"}],"markers":[{"number":1,"candleIndex":1,"position":"low"},{"number":2,"candleIndex":2,"position":"close"}]} $json$::jsonb),
 ('decision-bias-and-narratives',$json$ {"candles":[{"open":100,"high":105,"low":98,"close":104,"volume":44,"label":"GOTO · story"},{"open":104,"high":106,"low":100,"close":101,"volume":72,"label":"GOTO · counter"},{"open":101,"high":103,"low":97,"close":99,"volume":68,"label":"GOTO · evidence"}],"markers":[{"number":1,"candleIndex":0,"position":"close"},{"number":2,"candleIndex":1,"position":"low"}]} $json$::jsonb),
 ('decision-thesis-invalidation',$json$ {"candles":[{"open":100,"high":105,"low":98,"close":104,"volume":42,"label":"INDF · thesis"},{"open":104,"high":106,"low":99,"close":100,"volume":63,"label":"INDF · boundary"},{"open":100,"high":102,"low":94,"close":95,"volume":81,"label":"INDF · reassess"}],"markers":[{"number":1,"candleIndex":1,"position":"close"},{"number":2,"candleIndex":2,"position":"low"}]} $json$::jsonb)
)
UPDATE public.content_variants v
SET body=jsonb_set(v.body,'{chart}',charts.chart,TRUE),
    body_id=jsonb_set(v.body_id,'{chart}',charts.chart,TRUE)
FROM public.lessons l
JOIN public.topics t ON t.id=l.topic_id
JOIN charts ON charts.slug=l.slug
WHERE v.lesson_id=l.id AND v.variant_type='question' AND v.topic_tag='visual_applied' AND v.is_active
  AND t.chapter='Decision Analysis Lab' AND l.is_published;

WITH examples(slug, text_en, text_id) AS (VALUES
 ('decision-multicandle-context',
  'Case A — BBCA (IDX-listed bank, illustrative chart): a rising sequence prints a long upper wick and then closes back near the prior zone. The useful observation is rejection during that interval; the story is not “BBCA must reverse.”\n\nCase B — XMLF (IDX-listed LQ45 ETF, illustrative chart): a similar wick appears during a broader sideways range. Compare the surrounding candles and timeframe before calling it a breakout failure. In both cases, record what happened first and what evidence would change the interpretation. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — BBCA (bank tercatat di BEI, grafik ilustratif): rangkaian naik membentuk upper wick panjang lalu ditutup kembali dekat zona sebelumnya. Pengamatan yang berguna adalah penolakan dalam interval itu; ceritanya bukan “BBCA pasti berbalik.”\n\nKasus B — XMLF (ETF LQ45 tercatat di BEI, grafik ilustratif): wick serupa muncul dalam rentang yang lebih mendatar. Bandingkan candle sekitar dan timeframe sebelum menyebutnya kegagalan breakout. Dalam kedua kasus, catat apa yang terjadi lebih dulu dan bukti apa yang dapat mengubah interpretasi. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-volume-confirmation',
  'Case A — BBRI (IDX-listed bank, illustrative chart): price advances while the volume bar is ordinary, then participation jumps on one candle. Ask what news, level, or event needs checking; high volume alone does not prove continuation.\n\nCase B — XISR (IDX-listed ETF, illustrative chart): a volume spike appears while price remains inside a range. Compare the activity with the close and the next evidence rather than copying the move. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — BBRI (bank tercatat di BEI, grafik ilustratif): harga naik saat bar volume biasa, lalu partisipasi melonjak pada satu candle. Tanyakan berita, level, atau peristiwa apa yang perlu diperiksa; volume tinggi saja tidak membuktikan kelanjutan.\n\nKasus B — XISR (ETF tercatat di BEI, grafik ilustratif): lonjakan volume muncul saat harga tetap di dalam rentang. Bandingkan aktivitas dengan penutupan dan bukti berikutnya, bukan meniru pergerakannya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-zones-false-breakouts',
  'Case A — ANTM (IDX-listed company, illustrative chart): price trades above a reaction zone intraday but closes back inside it. Label the breach-and-return, then wait for more evidence; do not treat it as a guaranteed reversal.\n\nCase B — BBCA (IDX-listed bank, illustrative chart): price tests a prior zone several times and finally closes beyond it. Compare the close, later evidence, and timeframe before calling it a confirmed breakout. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — ANTM (perusahaan tercatat di BEI, grafik ilustratif): harga diperdagangkan di atas zona reaksi secara intraday tetapi ditutup kembali di dalamnya. Tandai penembusan dan kembalinya harga, lalu tunggu bukti berikutnya; jangan menganggapnya pembalikan yang dijamin.\n\nKasus B — BBCA (bank tercatat di BEI, grafik ilustratif): harga menguji zona sebelumnya beberapa kali lalu ditutup melewatinya. Bandingkan penutupan, bukti setelahnya, dan timeframe sebelum menyebutnya breakout terkonfirmasi. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-timeframe-comparison',
  'Case A — TLKM (IDX-listed company, illustrative chart): a five-minute view makes a small move look dramatic because it shows more local candles. The daily view may place that same move inside a normal range.\n\nCase B — XMLF (IDX-listed ETF, illustrative chart): an intraday pullback and a weekly uptrend can coexist because each timeframe aggregates a different window. Name the timeframe before comparing the stories. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — TLKM (perusahaan tercatat di BEI, grafik ilustratif): tampilan lima menit membuat pergerakan kecil terlihat dramatis karena menampilkan lebih banyak candle lokal. Grafik harian dapat menempatkan pergerakan yang sama di dalam rentang normal.\n\nKasus B — XMLF (ETF tercatat di BEI, grafik ilustratif): pullback intraday dan tren mingguan yang naik dapat terjadi bersamaan karena setiap timeframe mengagregasi jendela berbeda. Sebutkan timeframe sebelum membandingkan ceritanya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-risk-reward',
  'Case A — XMLF (IDX-listed ETF, illustrative scenario): a worksheet shows Rp100,000 possible loss and Rp200,000 possible gain. The 1:2 ratio describes magnitudes only; it does not say which outcome will happen.\n\nCase B — BBCA (IDX-listed bank, illustrative scenario): a different worksheet shows a smaller possible loss but a shorter review window. Compare the downside with essentials, fees, and the plan rather than ranking a story by its ratio. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — XMLF (ETF tercatat di BEI, skenario ilustratif): lembar kerja menunjukkan kemungkinan rugi Rp100.000 dan kemungkinan untung Rp200.000. Rasio 1:2 hanya menggambarkan besaran; tidak menyatakan hasil mana yang akan terjadi.\n\nKasus B — BBCA (bank tercatat di BEI, skenario ilustratif): lembar kerja lain menunjukkan kemungkinan rugi lebih kecil tetapi periode tinjauan lebih pendek. Bandingkan sisi buruk dengan kebutuhan pokok, biaya, dan rencana, bukan menilai cerita hanya dari rasionya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-position-sizing',
  'Case A — XISR (IDX-listed ETF, illustrative scenario): two paper portfolios inspect the same chart, but one exposes Rp1,000,000 and the other Rp200,000. The chart did not change; the potential impact on each plan did.\n\nCase B — BBRI (IDX-listed bank, illustrative scenario): a learner has a near-term tuition payment, so the paper exercise keeps that money outside the risk scenario. The useful question is whether the exposure fits the goal and loss capacity, not whether the ticker sounds convincing. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — XISR (ETF tercatat di BEI, skenario ilustratif): dua portofolio kertas mengamati grafik yang sama, tetapi satu mengekspos Rp1.000.000 dan yang lain Rp200.000. Grafiknya tidak berubah; dampak potensial pada setiap rencana yang berubah.\n\nKasus B — BBRI (bank tercatat di BEI, skenario ilustratif): seorang pelajar memiliki pembayaran uang kuliah dalam waktu dekat, sehingga uang itu dikeluarkan dari skenario risiko. Pertanyaan berguna adalah apakah eksposur sesuai tujuan dan kemampuan menanggung rugi, bukan apakah ticker terdengar meyakinkan. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-bias-and-narratives',
  'Case A — GOTO (IDX-listed company, illustrative chart): a learner sees three posts supporting a bullish story, then writes one observation that would weaken it and checks the chart without the caption. The goal is a testable belief, not a stronger story.\n\nCase B — ANTM (IDX-listed company, illustrative chart): a popular narrative conflicts with the visible close and volume context. Record the fact, the interpretation, and the missing evidence separately before deciding what to study next. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — GOTO (perusahaan tercatat di BEI, grafik ilustratif): seorang pelajar melihat tiga unggahan yang mendukung cerita bullish, lalu menulis satu pengamatan yang dapat melemahkannya dan memeriksa grafik tanpa caption. Tujuannya adalah keyakinan yang dapat diuji, bukan cerita yang lebih kuat.\n\nKasus B — ANTM (perusahaan tercatat di BEI, grafik ilustratif): narasi populer tidak cocok dengan penutupan dan konteks volume yang terlihat. Pisahkan fakta, interpretasi, dan bukti yang hilang sebelum memutuskan apa yang dipelajari berikutnya. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.'),
 ('decision-thesis-invalidation',
  'Case A — INDF (IDX-listed company, illustrative chart): a learner writes a thesis and a condition that would weaken it before looking at the next candle. When the condition appears, the correct learning move is to pause and reassess, not silently move the boundary.\n\nCase B — TLKM (IDX-listed company, illustrative chart): a different thesis uses a longer review window, so the learner records the timeframe and checks the evidence at that boundary. Both cases show a rule for updating reasoning, not an automatic buy or sell instruction. These are educational scenarios, not current-price claims or recommendations.',
  'Kasus A — INDF (perusahaan tercatat di BEI, grafik ilustratif): seorang pelajar menulis tesis dan kondisi yang akan melemahkannya sebelum melihat candle berikutnya. Saat kondisi muncul, langkah belajar yang benar adalah berhenti dan menilai ulang, bukan diam-diam memindahkan batas.\n\nKasus B — TLKM (perusahaan tercatat di BEI, grafik ilustratif): tesis lain menggunakan periode tinjauan yang lebih panjang, sehingga pelajar mencatat timeframe dan memeriksa bukti pada batas itu. Kedua kasus menunjukkan aturan untuk memperbarui penalaran, bukan instruksi beli atau jual otomatis. Ini skenario edukasi, bukan klaim harga saat ini atau rekomendasi.')
)
UPDATE public.content_variants v
SET body=jsonb_build_object('text',e.text_en), body_id=jsonb_build_object('text',e.text_id)
FROM examples e JOIN public.lessons l ON l.slug=e.slug AND l.is_published
WHERE v.lesson_id=l.id AND v.variant_type='example' AND v.is_active;

DO $$
DECLARE lesson_count INT; visual_question_count INT; chart_question_count INT; example_count INT; supporting_count INT;
BEGIN
  SELECT COUNT(*) INTO lesson_count FROM public.lessons l JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published;
  SELECT COUNT(*) INTO visual_question_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='question' AND v.topic_tag='visual_applied' AND v.is_active;
  SELECT COUNT(*) INTO chart_question_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='question' AND v.topic_tag='visual_applied' AND v.is_active AND v.body ? 'chart' AND v.body_id ? 'chart';
  SELECT COUNT(*) INTO example_count FROM public.content_variants v JOIN public.lessons l ON l.id=v.lesson_id JOIN public.topics t ON t.id=l.topic_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND v.variant_type='example' AND v.is_active AND length(v.body->>'text') > 300 AND v.body->>'text' LIKE '%Case A%' AND v.body->>'text' LIKE '%Case B%';
  SELECT COUNT(DISTINCT l.id) INTO supporting_count FROM public.lesson_sources ls JOIN public.lessons l ON l.id=ls.lesson_id JOIN public.topics t ON t.id=l.topic_id JOIN public.sources s ON s.id=ls.source_id WHERE t.chapter='Decision Analysis Lab' AND l.is_published AND ls.relevance_type='supporting' AND s.source_tier=2 AND s.status='verified' AND s.url IS NOT NULL;
  IF lesson_count<>8 OR visual_question_count<>40 OR chart_question_count<>40 OR example_count<>8 OR supporting_count<>8 THEN RAISE EXCEPTION 'KO-447 coverage mismatch: lessons %, visual questions %, chart questions %, examples %, supporting lessons %', lesson_count, visual_question_count, chart_question_count, example_count, supporting_count; END IF;
END $$;

COMMIT;
