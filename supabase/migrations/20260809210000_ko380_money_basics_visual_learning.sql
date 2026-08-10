-- KO-380: Complete the Chapter 01 Money Basics visual-learning contract.
-- Existing visual treatments remain intact; this migration binds them to reviewed
-- official sources and adds visual-applied practice plus five-day recall.
BEGIN;

WITH source_map(slug, source_code, display_order) AS (VALUES
  ('value-and-purchasing-power', 'FZ-BI-INFLATION', 10),
  ('inflation-101', 'FZ-BI-INFLATION', 10),
  ('understanding-risk', 'CH08-OJK-SBN-GUIDE', 10),
  ('time-value-of-money', 'FZ-OJK-PLANNING', 10),
  ('net-worth-know-your-financial-position', 'FZ-OJK-PLANNING', 10),
  ('net-worth-know-your-financial-position-part-2', 'FZ-OJK-PLANNING', 10)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, 'primary', source.source_code, TRUE, source_map.display_order
FROM source_map
JOIN public.lessons AS lesson ON lesson.slug = source_map.slug
JOIN public.sources AS source ON source.source_code = source_map.source_code
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

UPDATE public.lesson_sources AS link
SET is_primary = FALSE
FROM public.lessons AS lesson, public.sources AS source
WHERE link.lesson_id = lesson.id
  AND source.id = link.source_id
  AND lesson.slug IN (
    'value-and-purchasing-power', 'inflation-101', 'understanding-risk',
    'time-value-of-money', 'net-worth-know-your-financial-position',
    'net-worth-know-your-financial-position-part-2'
  )
  AND (lesson.slug, source.source_code) NOT IN (
    ('value-and-purchasing-power', 'FZ-BI-INFLATION'),
    ('inflation-101', 'FZ-BI-INFLATION'),
    ('understanding-risk', 'CH08-OJK-SBN-GUIDE'),
    ('time-value-of-money', 'FZ-OJK-PLANNING'),
    ('net-worth-know-your-financial-position', 'FZ-OJK-PLANNING'),
    ('net-worth-know-your-financial-position-part-2', 'FZ-OJK-PLANNING')
  );

WITH source_map(slug, source_code) AS (VALUES
  ('value-and-purchasing-power', 'FZ-BI-INFLATION'),
  ('inflation-101', 'FZ-BI-INFLATION'),
  ('understanding-risk', 'CH08-OJK-SBN-GUIDE'),
  ('time-value-of-money', 'FZ-OJK-PLANNING'),
  ('net-worth-know-your-financial-position', 'FZ-OJK-PLANNING'),
  ('net-worth-know-your-financial-position-part-2', 'FZ-OJK-PLANNING')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM source_map
JOIN public.lessons AS lesson ON lesson.slug = source_map.slug
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = source_map.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug IN ('value-and-purchasing-power', 'inflation-101', 'understanding-risk', 'time-value-of-money')
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(slug, body, body_id) AS (VALUES
  ('value-and-purchasing-power',
    '{"type":"multiple_choice","difficulty":"beginner","question":"In the visual, what changes when the price per item rises from Rp20k to Rp25k while the budget stays Rp100k?","options":["The budget reaches four items instead of five","The budget becomes Rp125k","The basket costs less","The item price stays Rp20k"],"answer":"The budget reaches four items instead of five","explanation":"The worked example holds the Rp100k budget constant and shows it buying fewer items after the price rise.","parameters":{"visual":"value-and-purchasing-power"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Dalam visual, apa yang berubah ketika harga tiap barang naik dari Rp20 ribu menjadi Rp25 ribu sementara anggaran tetap Rp100 ribu?","options":["Anggaran menjangkau empat barang, bukan lima","Anggaran menjadi Rp125 ribu","Keranjang menjadi lebih murah","Harga barang tetap Rp20 ribu"],"answer":"Anggaran menjangkau empat barang, bukan lima","explanation":"Contoh perhitungan menjaga anggaran Rp100 ribu tetap sama dan menunjukkan uang itu membeli lebih sedikit barang setelah harga naik.","parameters":{"visual":"value-and-purchasing-power"}}'::jsonb),
  ('value-and-purchasing-power',
    '{"type":"true_false","difficulty":"beginner","question":"A budget can lose purchasing power even when the rupiah amount has not changed.","options":["True","False"],"answer":true,"explanation":"The visual shows Rp100k staying the same while the number of items it can buy falls.","parameters":{"visual":"value-and-purchasing-power"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Anggaran dapat kehilangan daya beli meski nominal rupiahnya tidak berubah.","options":["Benar","Salah"],"answer":true,"explanation":"Visual menunjukkan Rp100 ribu tetap sama tetapi jumlah barang yang dapat dibeli berkurang.","parameters":{"visual":"value-and-purchasing-power"}}'::jsonb),
  ('value-and-purchasing-power',
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which comparison matches the visual\u2019s purchasing-power idea?","options":["Compare what the same budget buys before and after a price change","Compare two people\u2019s salaries only","Assume every price changes equally","Treat a larger price tag as higher income"],"answer":"Compare what the same budget buys before and after a price change","explanation":"Purchasing power asks what a fixed amount of money can actually buy at different prices.","parameters":{"visual":"value-and-purchasing-power"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Perbandingan mana yang sesuai dengan gagasan daya beli pada visual?","options":["Bandingkan apa yang dibeli anggaran sama sebelum dan sesudah harga berubah","Bandingkan gaji dua orang saja","Anggap semua harga berubah sama","Anggap label harga lebih besar berarti pendapatan lebih tinggi"],"answer":"Bandingkan apa yang dibeli anggaran sama sebelum dan sesudah harga berubah","explanation":"Daya beli menanyakan apa yang benar-benar dapat dibeli sejumlah uang tetap pada harga berbeda.","parameters":{"visual":"value-and-purchasing-power"}}'::jsonb),
  ('inflation-101',
    '{"type":"multiple_choice","difficulty":"beginner","question":"What does the visual use to show inflation\u2019s effect on purchasing power?","options":["The same Rp100k buys four items at Rp25k instead of five at Rp20k","A guaranteed annual inflation rate","A change in a single person\u2019s salary","A stock-price forecast"],"answer":"The same Rp100k buys four items at Rp25k instead of five at Rp20k","explanation":"The visual is a calculated illustration of a fixed budget reaching fewer goods as prices rise.","parameters":{"visual":"inflation-101"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Apa yang digunakan visual untuk menunjukkan dampak inflasi pada daya beli?","options":["Rp100 ribu yang sama membeli empat barang Rp25 ribu, bukan lima barang Rp20 ribu","Tingkat inflasi tahunan yang dijamin","Perubahan gaji satu orang","Ramalan harga saham"],"answer":"Rp100 ribu yang sama membeli empat barang Rp25 ribu, bukan lima barang Rp20 ribu","explanation":"Visual adalah ilustrasi perhitungan anggaran tetap yang menjangkau lebih sedikit barang saat harga naik.","parameters":{"visual":"inflation-101"}}'::jsonb),
  ('inflation-101',
    '{"type":"true_false","difficulty":"beginner","question":"One item becoming more expensive by itself proves economy-wide inflation.","options":["True","False"],"answer":false,"explanation":"The visual illustrates purchasing power; official inflation refers to a sustained general rise in prices, not one item alone.","parameters":{"visual":"inflation-101"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Satu barang yang menjadi lebih mahal dengan sendirinya membuktikan inflasi di seluruh ekonomi.","options":["Benar","Salah"],"answer":false,"explanation":"Visual mengilustrasikan daya beli; inflasi resmi berarti kenaikan harga umum yang berkelanjutan, bukan satu barang saja.","parameters":{"visual":"inflation-101"}}'::jsonb),
  ('inflation-101',
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which part of the inflation visual is an illustration rather than a current price claim?","options":["The Rp20k and Rp25k item prices","That official prices always rise by Rp5k","That every household buys the same basket","That inflation has no effect on choices"],"answer":"The Rp20k and Rp25k item prices","explanation":"The disclosure labels the example as calculated; real prices vary by item, place, and time.","parameters":{"visual":"inflation-101"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Bagian mana dari visual inflasi yang merupakan ilustrasi, bukan klaim harga saat ini?","options":["Harga barang Rp20 ribu dan Rp25 ribu","Harga resmi selalu naik Rp5 ribu","Setiap rumah tangga membeli keranjang yang sama","Inflasi tidak memengaruhi pilihan"],"answer":"Harga barang Rp20 ribu dan Rp25 ribu","explanation":"Pengungkapan menandai contoh sebagai perhitungan; harga nyata berbeda menurut barang, tempat, dan waktu.","parameters":{"visual":"inflation-101"}}'::jsonb),
  ('understanding-risk',
    '{"type":"ordering","difficulty":"beginner","question":"Which order follows the risk-check visual?","options":["Name the downside","Check your buffer","Match the timeline"],"answer":["Name the downside","Check your buffer","Match the timeline"],"explanation":"The flow first identifies what could go wrong, then checks whether essentials can absorb it, then matches the time horizon.","parameters":{"visual":"understanding-risk"}}'::jsonb,
    '{"type":"ordering","difficulty":"beginner","question":"Urutan mana yang mengikuti visual cek risiko?","options":["Sebutkan sisi buruk","Cek penyangga","Cocokkan waktunya"],"answer":["Sebutkan sisi buruk","Cek penyangga","Cocokkan waktunya"],"explanation":"Alur pertama mengenali apa yang bisa salah, lalu mengecek apakah kebutuhan pokok dapat menahannya, kemudian mencocokkan horizon waktu.","parameters":{"visual":"understanding-risk"}}'::jsonb),
  ('understanding-risk',
    '{"type":"multiple_choice","difficulty":"beginner","question":"According to the visual, why does money needed soon have less room for uncertainty?","options":["There is less time to recover from a loss or delay","Its return is guaranteed","A short deadline removes all risk","It should always be borrowed"],"answer":"There is less time to recover from a loss or delay","explanation":"The final risk-check step matches the money\u2019s timeline to the uncertainty it can reasonably absorb.","parameters":{"visual":"understanding-risk"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Menurut visual, mengapa uang yang dibutuhkan segera memiliki ruang lebih kecil untuk ketidakpastian?","options":["Ada lebih sedikit waktu untuk pulih dari kerugian atau penundaan","Imbal hasilnya dijamin","Tenggat pendek menghapus semua risiko","Uangnya harus selalu dipinjam"],"answer":"Ada lebih sedikit waktu untuk pulih dari kerugian atau penundaan","explanation":"Langkah terakhir cek risiko mencocokkan waktu kebutuhan uang dengan ketidakpastian yang dapat ditanggung secara wajar.","parameters":{"visual":"understanding-risk"}}'::jsonb),
  ('understanding-risk',
    '{"type":"true_false","difficulty":"beginner","question":"The risk-check visual promises that a careful decision cannot lose value.","options":["True","False"],"answer":false,"explanation":"The disclosure says risk is not a prediction or guarantee; the flow helps a learner check exposure before acting.","parameters":{"visual":"understanding-risk"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Visual cek risiko menjanjikan bahwa keputusan yang hati-hati tidak dapat kehilangan nilai.","options":["Benar","Salah"],"answer":false,"explanation":"Pengungkapan menyatakan risiko bukan prediksi atau jaminan; alur membantu pelajar memeriksa eksposur sebelum bertindak.","parameters":{"visual":"understanding-risk"}}'::jsonb),
  ('time-value-of-money',
    '{"type":"ordering","difficulty":"beginner","question":"Which order matches the time-value visual?","options":["Today","Time passes","Compare later"],"answer":["Today","Time passes","Compare later"],"explanation":"The visual begins with a choice today, notes that prices and opportunities can change, then asks the learner to compare outcomes later.","parameters":{"visual":"time-value-of-money"}}'::jsonb,
    '{"type":"ordering","difficulty":"beginner","question":"Urutan mana yang sesuai dengan visual nilai waktu uang?","options":["Hari ini","Waktu berjalan","Bandingkan nanti"],"answer":["Hari ini","Waktu berjalan","Bandingkan nanti"],"explanation":"Visual dimulai dari pilihan hari ini, mencatat bahwa harga dan kesempatan dapat berubah, lalu meminta pelajar membandingkan hasil nanti.","parameters":{"visual":"time-value-of-money"}}'::jsonb),
  ('time-value-of-money',
    '{"type":"multiple_choice","difficulty":"beginner","question":"What is the safest conclusion from the time-value visual?","options":["The use of money can change when prices, interest, and time change","Money today always guarantees a better result","Waiting always makes money worthless","Every future price can be known"],"answer":"The use of money can change when prices, interest, and time change","explanation":"The visual asks learners to compare what money can do at different points in time without promising a result.","parameters":{"visual":"time-value-of-money"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Apa kesimpulan paling aman dari visual nilai waktu uang?","options":["Kegunaan uang dapat berubah saat harga, bunga, dan waktu berubah","Uang hari ini selalu menjamin hasil lebih baik","Menunggu selalu membuat uang tidak bernilai","Semua harga masa depan dapat diketahui"],"answer":"Kegunaan uang dapat berubah saat harga, bunga, dan waktu berubah","explanation":"Visual meminta pelajar membandingkan apa yang dapat dilakukan uang pada waktu berbeda tanpa menjanjikan hasil.","parameters":{"visual":"time-value-of-money"}}'::jsonb),
  ('time-value-of-money',
    '{"type":"true_false","difficulty":"beginner","question":"The Rp100k example in the visual is a guaranteed interest-rate forecast.","options":["True","False"],"answer":false,"explanation":"The disclosure labels the visual as an illustrative learning example; rates, prices, and outcomes can vary.","parameters":{"visual":"time-value-of-money"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Contoh Rp100 ribu pada visual adalah ramalan suku bunga yang dijamin.","options":["Benar","Salah"],"answer":false,"explanation":"Pengungkapan menandai visual sebagai contoh pembelajaran ilustratif; suku bunga, harga, dan hasil dapat berbeda.","parameters":{"visual":"time-value-of-money"}}'::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
JOIN public.lessons AS lesson ON lesson.slug = applied.slug
WHERE lesson.is_published = TRUE;

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (VALUES
  ('value-and-purchasing-power', 'What does purchasing power compare?', 'Apa yang dibandingkan oleh daya beli?', '["What the same budget can buy at different prices","Only the number of rupiah in a wallet","A guaranteed salary increase"]'::jsonb, '["Apa yang dapat dibeli anggaran sama pada harga berbeda","Hanya jumlah rupiah di dompet","Kenaikan gaji yang dijamin"]'::jsonb, 'What the same budget can buy at different prices', 'Purchasing power is about the goods and services a fixed amount can reach.', 'Daya beli berkaitan dengan barang dan jasa yang dapat dijangkau sejumlah uang tetap.'),
  ('inflation-101', 'Why can inflation matter to a fixed budget?', 'Mengapa inflasi dapat penting bagi anggaran tetap?', '["The same money may buy fewer goods","It guarantees every price rises equally","It makes all income grow automatically"]'::jsonb, '["Uang yang sama mungkin membeli lebih sedikit barang","Ini menjamin setiap harga naik sama","Ini membuat semua pendapatan naik otomatis"]'::jsonb, 'The same money may buy fewer goods', 'A fixed budget can reach fewer goods when general prices rise.', 'Anggaran tetap dapat menjangkau lebih sedikit barang saat harga umum naik.'),
  ('understanding-risk', 'What should you check before taking a risk?', 'Apa yang perlu diperiksa sebelum mengambil risiko?', '["Downside, buffer, and timeline","Only the possible return","A friend\u2019s confidence"]'::jsonb, '["Sisi buruk, penyangga, dan waktu","Hanya potensi imbal hasil","Keyakinan teman"]'::jsonb, 'Downside, buffer, and timeline', 'The visual makes risk a structured check, not a prediction.', 'Visual menjadikan risiko pemeriksaan terstruktur, bukan prediksi.'),
  ('time-value-of-money', 'Why compare money today with money later?', 'Mengapa membandingkan uang hari ini dengan uang nanti?', '["Prices, interest, and opportunities can change","Today always guarantees a higher result","Future prices never change"]'::jsonb, '["Harga, bunga, dan kesempatan dapat berubah","Hari ini selalu menjamin hasil lebih tinggi","Harga masa depan tidak pernah berubah"]'::jsonb, 'Prices, interest, and opportunities can change', 'Time can change what money can do, without guaranteeing an outcome.', 'Waktu dapat mengubah apa yang dapat dilakukan uang tanpa menjamin hasil.')
)
INSERT INTO public.lesson_recall_questions (lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
SELECT lesson.id, recalls.question_en, recalls.question_id, recalls.options_en, recalls.options_id, recalls.correct_option, recalls.explanation_en, recalls.explanation_id, TRUE
FROM recalls
JOIN public.lessons AS lesson ON lesson.slug = recalls.slug
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = TRUE,
  updated_at = NOW();

COMMIT;
