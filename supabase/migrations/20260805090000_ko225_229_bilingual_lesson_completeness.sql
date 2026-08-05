-- KO-225 / KO-229: close the live bilingual lesson completeness gaps.
--
-- This migration is intentionally idempotent. It only fills missing lesson
-- pointers/cards and corrects the specifically audited duplicate locale rows;
-- it does not delete or deactivate authored curriculum content.

-- Newer chapters already have bilingual question variants, but their lesson
-- summary pointer was not populated. Use the first stable active question
-- variant as the lesson quiz payload so the existing lesson player can load it.
WITH first_question AS (
  SELECT DISTINCT ON (lesson_id)
    lesson_id,
    body,
    body_id
  FROM public.content_variants
  WHERE is_active = TRUE
    AND variant_type = 'question'
    AND body_id IS NOT NULL
  ORDER BY lesson_id, id
)
UPDATE public.lessons AS l
SET quiz_data = q.body,
    quiz_data_id = q.body_id
FROM first_question AS q
WHERE l.id = q.lesson_id
  AND l.is_published = TRUE
  AND l.quiz_data_id IS NULL;

-- Correct the audited rows where one locale payload was copied into the other.
-- English rows receive Indonesian text in body_id.
UPDATE public.content_variants SET body_id = jsonb_build_object(
  'type', 'comparison',
  'answer', 'Rp 2 juta sejak usia 30',
  'options', jsonb_build_array('Rp 2 juta sejak usia 30', 'Rp 5 juta sejak usia 45', 'Keduanya sama saat pensiun', 'Tidak ada yang cukup'),
  'question', 'Untuk tabungan pensiun mulai usia 30 tahun: lebih baik menabung Rp 2 juta per bulan atau Rp 5 juta per bulan mulai usia 45?',
  'difficulty', 'beginner',
  'explanation', 'Memulai lebih awal memberi waktu lebih panjang bagi penggandaan, meski jumlah bulanannya lebih kecil.'
) WHERE id = 'ffc442e9-929f-4aeb-b343-bd0e9e30b036';

UPDATE public.content_variants SET body_id = jsonb_build_object(
  'type', 'multiple_choice',
  'answer', 'Rp {{amount * (1 + rate/100) ** years}}',
  'options', jsonb_build_array('Rp {{amount * (1 + rate/100) ** years}}', 'Rp {{amount + rate * years}}', 'Rp {{amount * years}}', 'Rp {{amount * rate}}'),
  'question', 'Jika Rp {{amount}} diinvestasikan dengan imbal hasil rata-rata {{rate}}% per tahun, berapa perkiraan nilainya setelah {{years}} tahun dengan bunga majemuk?',
  'difficulty', 'intermediate',
  'parameters', jsonb_build_object('rate', jsonb_build_object('max', 12, 'min', 5, 'step', 1), 'years', jsonb_build_object('max', 15, 'min', 5, 'step', 1), 'amount', jsonb_build_object('max', 5000000, 'min', 1000000, 'step', 500000)),
  'explanation', 'Bunga majemuk menghitung pertumbuhan dari modal dan imbal hasil yang sudah diperoleh: nilai = modal × (1 + rate)^tahun.'
) WHERE id = '32b58bc8-66c9-41d9-9c47-8f5ea2a38b19';

UPDATE public.content_variants SET body_id = jsonb_build_object(
  'type', 'word_bank', 'answer', jsonb_build_array('bullish', 'bearish'),
  'options', jsonb_build_array('bullish', 'bearish', 'sideways', 'volatile'),
  'question', 'Saat investor ________, mereka memperkirakan harga naik; saat mereka ________, mereka memperkirakan harga turun.',
  'difficulty', 'advanced', 'explanation', 'Bullish berarti memperkirakan kenaikan; bearish berarti memperkirakan penurunan.'
) WHERE id = 'f43acbd0-a8e0-40a8-9dcf-ddcc251a193e';

UPDATE public.content_variants SET body_id = jsonb_build_object(
  'type', 'image_interpretation', 'answer', 'Volatilitas jangka pendek itu normal; tren jangka panjang perlu dilihat',
  'options', jsonb_build_array('Pasar selalu jatuh permanen', 'Volatilitas jangka pendek itu normal; tren jangka panjang perlu dilihat', 'Menentukan waktu pasar itu mudah', 'Saham Indonesia terlalu berisiko'),
  'question', 'Apa yang terutama ditunjukkan grafik IHSG 2019–2024 dengan penurunan tajam pada 2020 dan pemulihan setelahnya tentang investasi jangka panjang?',
  'difficulty', 'intermediate', 'parameters', jsonb_build_object('image_description', 'Grafik IHSG 2019–2024 dengan penurunan tajam pada Maret 2020, pemulihan bertahap, volatilitas, dan kenaikan berikutnya.'),
  'explanation', 'Pergerakan jangka pendek dapat bergejolak, sehingga satu penurunan tidak membuktikan hasil jangka panjang.'
) WHERE id = 'f727b9ea-f7d6-4df7-a0c7-61cfebdc3b73';

UPDATE public.content_variants SET body_id = jsonb_build_object(
  'type', 'calculation', 'answer', '24%',
  'question', 'Harga satu saham Rp 5.000. Kamu membeli 200 saham. Setahun kemudian harganya Rp 6.200. Berapa persentase imbal hasilnya?',
  'difficulty', 'intermediate', 'parameters', jsonb_build_object('hint', 'Hitung nilai awal, nilai akhir, lalu perubahan persentasenya.'),
  'explanation', 'Nilai awal Rp 1.000.000 dan nilai akhir Rp 1.240.000. Perubahan Rp 240.000 dibagi Rp 1.000.000 adalah 24%.'
) WHERE id = 'ea6c9519-41df-445a-92cd-34b2f2199a3e';

UPDATE public.content_variants SET body_id = jsonb_build_object(
  'type', 'comparison', 'answer', 'Obligasi pemerintah',
  'options', jsonb_build_array('Deposito tetap', 'Obligasi pemerintah', 'Keduanya sama', 'Tidak ada yang mengalahkan inflasi'),
  'question', 'Bandingkan deposito tetap 4% per tahun dengan obligasi pemerintah 6% per tahun untuk investor konservatif. Mana yang memberi imbal hasil riil lebih baik jika inflasi 3%?',
  'difficulty', 'intermediate', 'explanation', 'Imbal hasil riil deposito adalah 1%, sedangkan obligasi pemerintah adalah 3%, sebelum mempertimbangkan biaya dan risiko lain.'
) WHERE id = 'f6b0ee7c-0519-415c-a616-cf4e2f58ed93';

-- Indonesian rows receive English text in body while retaining their source
-- metadata and the already-authored Indonesian body_id.
UPDATE public.content_variants SET body = jsonb_set(body, '{text}', to_jsonb('When Bank Indonesia raises its policy rate, bank deposit rates may rise, but borrowing costs can also increase and share prices may become more volatile. The indicator adds context; it does not predict a trade.'::text), true) WHERE id = 'f4670b72-4212-454d-88e3-cadc7b03532e';
UPDATE public.content_variants SET body = jsonb_set(body, '{text}', to_jsonb('A survey may show that a loss of Rp 100,000 feels more painful than a gain of Rp 100,000 feels pleasant. Loss aversion can make people react strongly, so the feeling should be separated from the evidence.'::text), true) WHERE id = '6dec2386-d58e-47ab-b49f-4c82c090587b';
UPDATE public.content_variants SET body = jsonb_set(body, '{text}', to_jsonb('Bayu holds BBRI after a 10% loss for three months. The loss feels like a month of meals, which makes him want to sell immediately. Loss aversion is a reason to pause and review the plan, not proof that the price will recover.'::text), true) WHERE id = 'aa9ae455-3d92-4850-a649-e45e1628dfb9';
UPDATE public.content_variants SET body = jsonb_set(body, '{text}', to_jsonb('Nia hears friends celebrating GOTO after a 25% weekly rise and transfers Rp 2,000,000 without reading the information. When the price later falls, she recognises that FOMO replaced a research step.'::text), true) WHERE id = '57ff2805-60aa-4980-8d02-99f37ba59770';
UPDATE public.content_variants SET body = jsonb_build_object('type','word_bank','answer',jsonb_build_array('losses','gains'),'options',jsonb_build_array('losses','gains'),'question','Complete the sentence: "Loss aversion makes the pain of _____ feel larger than the pleasure of receiving _____."','difficulty','intermediate','parameters',jsonb_build_object(),'explanation','Loss aversion describes the tendency for losses to feel more painful than equivalent gains feel pleasant.') WHERE id = 'bb3a8005-6b4e-4386-b356-1e2c930d316e';
UPDATE public.content_variants SET body = jsonb_build_object('type','fill_blank','answer','research','question','Before buying an asset that is trending, you should _____ first.','difficulty','intermediate','parameters',jsonb_build_object(),'explanation','Independent research helps separate a considered decision from one driven only by hype or FOMO.') WHERE id = '854fee0f-2d60-484e-9746-42341c8724d6';
UPDATE public.content_variants SET body = jsonb_build_object('type','multiple_choice','answer','It is normal and not always bad','options',jsonb_build_array('It means the company will definitely fail','It is normal and not always bad','It guarantees a large dividend','It means the stock should never be owned'),'question','High daily volatility in a growth stock such as GOTO ...','difficulty','intermediate','parameters',jsonb_build_object(),'explanation','Growth stocks can fluctuate sharply; the useful habit is to review the long-term plan rather than react to one day.') WHERE id = 'c199715c-9ae2-47ff-b63b-4332bf19886d';

-- KO-229: concise bilingual explanation fallbacks from the authored lesson
-- summaries. These are deliberately short and preserve the lesson's existing
-- source-reviewed meaning.
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT l.id, 'explanation', jsonb_build_object('text', l.summary), jsonb_build_object('text', l.summary_id), l.difficulty, 'lesson-fallback', TRUE
FROM public.lessons AS l
WHERE l.is_published = TRUE
  AND l.summary IS NOT NULL
  AND l.summary_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.content_variants v
    WHERE v.lesson_id = l.id AND v.variant_type = 'explanation' AND v.is_active = TRUE
  );

-- KO-229: authored examples for the eleven lessons that had no active example.
WITH examples(slug, text_en, text_id) AS (
  VALUES
    ('gold-investment-safe-haven-in-turbulent-times', 'Ani saves Rp 100,000 a month in a gold account. After six months she sells part of it for a planned expense, while keeping her emergency cash separate. The example shows access and price risk, not a guaranteed safe return.', 'Ani menabung Rp 100.000 per bulan di rekening emas. Setelah enam bulan ia menjual sebagian untuk kebutuhan yang sudah direncanakan, sementara dana darurat tetap terpisah. Contoh ini menunjukkan risiko akses dan harga, bukan imbal hasil yang dijamin.'),
    ('digital-wallets-qris-safe-and-smart-usage', 'Bayu uses QRIS for small daily purchases and keeps only a limited balance in his wallet. For rent, he transfers from his bank account and checks the recipient before confirming. Different payment methods fit different amounts and risks.', 'Bayu menggunakan QRIS untuk pembelian kecil dan menyimpan saldo terbatas di dompet digital. Untuk membayar kos, ia mentransfer dari rekening bank dan memeriksa penerima sebelum mengonfirmasi. Metode pembayaran yang berbeda cocok untuk jumlah dan risiko yang berbeda.'),
    ('bonds-sbn-safe-investing-with-the-government', 'Rina compares an SBN offer with her deposit by checking the coupon, tax, term, liquidity, and protection. She chooses only an amount that does not replace her emergency fund and records when the money can be accessed.', 'Rina membandingkan penawaran SBN dengan depositonya dengan memeriksa kupon, pajak, tenor, likuiditas, dan perlindungan. Ia hanya memilih jumlah yang tidak menggantikan dana darurat dan mencatat kapan uangnya dapat diakses.'),
    ('insurance-basics-bpjs-vs-private-insurance', 'Doni keeps BPJS coverage and reviews whether his family depends on his income. Before considering additional insurance, he checks exclusions, waiting periods, claim rules, and whether the premium fits his budget.', 'Doni mempertahankan perlindungan BPJS dan meninjau apakah keluarganya bergantung pada penghasilannya. Sebelum mempertimbangkan asuransi tambahan, ia memeriksa pengecualian, masa tunggu, aturan klaim, dan kesesuaian premi dengan anggaran.'),
    ('stock-analysis-basics-fundamental-vs-technical', 'Bayu reviews a company business and financial information, then looks at a chart only to understand recent price context. He writes what would change his mind and does not treat either method as a guaranteed signal.', 'Bayu meninjau bisnis dan informasi keuangan perusahaan, lalu melihat grafik hanya untuk memahami konteks harga terbaru. Ia menulis hal yang dapat mengubah pandangannya dan tidak menganggap salah satu metode sebagai sinyal yang dijamin.'),
    ('debt-consolidation-when-and-how-to-combine-debts', 'Doni lists each debt, its full cost, term, and early-repayment rule before comparing consolidation. He changes the spending habit that created the debt and rejects the offer if the new total cost is not lower.', 'Doni mencatat setiap utang, biaya penuh, tenor, dan aturan pelunasan lebih awal sebelum membandingkan konsolidasi. Ia mengubah kebiasaan belanja yang menyebabkan utang dan menolak tawaran jika total biaya baru tidak lebih rendah.'),
    ('tax-basics-npwp-pph-21-and-filing-taxes', 'Ani keeps her income and withholding records in one folder and checks the current official filing instructions. As a freelancer, she does not assume an example calculation applies to her; she verifies the rule for her situation.', 'Ani menyimpan catatan penghasilan dan pemotongan pajak dalam satu folder serta memeriksa petunjuk pelaporan resmi yang berlaku. Sebagai pekerja lepas, ia tidak menganggap contoh perhitungan berlaku otomatis dan memeriksa aturan untuk situasinya.'),
    ('net-worth-know-your-financial-position', 'Every three months, Citra lists her assets and debts. When a PayLater balance falls, her net worth can improve even if her savings do not jump, because liabilities are part of the calculation.', 'Setiap tiga bulan, Citra mencatat aset dan utangnya. Saat saldo PayLater turun, kekayaan bersihnya dapat membaik meski tabungan tidak melonjak, karena liabilitas juga termasuk dalam perhitungan.'),
    ('retirement-planning-bpjs-dplk-and-starting-early', 'Rina starts with a small monthly contribution and reviews it once a year. She treats the return assumption as uncertain, keeps near-term needs separate, and increases the contribution only when her budget can support it.', 'Rina memulai kontribusi bulanan kecil dan meninjaunya setahun sekali. Ia menganggap asumsi imbal hasil tidak pasti, memisahkan kebutuhan jangka pendek, dan menaikkan kontribusi hanya saat anggarannya mampu.'),
    ('brokerage-account-setup-opening-your-rdn', 'Before opening an RDN, Bayu compares the broker licence, fees, support, and transfer process. He starts with a simulated order and checks the lot size and total cost before committing any real money.', 'Sebelum membuka RDN, Bayu membandingkan izin sekuritas, biaya, dukungan, dan proses transfer. Ia mulai dengan order simulasi serta memeriksa ukuran lot dan total biaya sebelum menggunakan uang sungguhan.'),
    ('sharia-investments-reksa-dana-syariah-and-sukuk', 'Siti checks the product prospectus, screening method, fees, and current approval information before choosing a Sharia product. She matches the choice to her goal and does not treat a Sharia label as a guarantee of profit.', 'Siti memeriksa prospektus, metode penyaringan, biaya, dan informasi persetujuan terbaru sebelum memilih produk syariah. Ia mencocokkan pilihan dengan tujuannya dan tidak menganggap label syariah sebagai jaminan keuntungan.')
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT l.id, 'example', jsonb_build_object('text', e.text_en), jsonb_build_object('text', e.text_id), l.difficulty, 'lesson-fallback', TRUE
FROM examples e
JOIN public.lessons l ON l.slug = e.slug
WHERE l.is_published = TRUE
  AND NOT EXISTS (
    SELECT 1 FROM public.content_variants v
    WHERE v.lesson_id = l.id AND v.variant_type = 'example' AND v.is_active = TRUE
  );
