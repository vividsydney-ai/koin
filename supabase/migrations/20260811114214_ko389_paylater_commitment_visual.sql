BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'KO389-OJK-LPBBTI-COMMITMENT',
  'OJK Regulation POJK 40/2024 on Information-Technology-Based Co-Funding Services',
  'POJK 40/2024 tentang Layanan Pendanaan Bersama Berbasis Teknologi Informasi',
  1, 'regulation', 'Otoritas Jasa Keuangan',
  'https://ojk.go.id/id/regulasi/Pages/POJK-40-Tahun-2024-Layanan-Pendanaan-Bersama-Berbasis-Teknologi-Informasi.aspx',
  'id', '2026-08-11', 'verified',
  'Official OJK regulatory context for information-technology-based co-funding services. It does not establish the price, fees, eligibility, or outcome of any particular PayLater product.',
  'Konteks regulasi resmi OJK untuk layanan pendanaan bersama berbasis teknologi informasi. Sumber ini tidak menetapkan harga, biaya, kelayakan, atau hasil untuk produk PayLater tertentu.',
  'This regulation provides the official regulatory boundary for technology-enabled funding services. This lesson uses it to reinforce checking the full disclosed commitment and provider terms, not to quote a provider-specific price or fee.',
  'Regulasi ini memberikan batas regulasi resmi bagi layanan pendanaan berbasis teknologi. Pelajaran ini menggunakannya untuk menekankan pemeriksaan komitmen yang diungkapkan secara lengkap dan syarat penyedia, bukan untuk mengutip harga atau biaya penyedia tertentu.',
  'Supports the lesson''s habit of checking instalment amount, due dates, total payable, and the provider''s own late-payment terms before confirming a fictional checkout.',
  'Mendukung kebiasaan memeriksa jumlah cicilan, tanggal jatuh tempo, total pembayaran, dan ketentuan keterlambatan dari penyedia sebelum mengonfirmasi checkout fiktif.'
)
ON CONFLICT (source_code) DO UPDATE SET
  title = EXCLUDED.title,
  local_title = EXCLUDED.local_title,
  source_tier = EXCLUDED.source_tier,
  source_type = EXCLUDED.source_type,
  organization = EXCLUDED.organization,
  url = EXCLUDED.url,
  language = EXCLUDED.language,
  last_checked_at = EXCLUDED.last_checked_at,
  status = EXCLUDED.status,
  trust_notes = EXCLUDED.trust_notes,
  localization_notes = EXCLUDED.localization_notes,
  synopsis = EXCLUDED.synopsis,
  synopsis_id = EXCLUDED.synopsis_id,
  relevance_blurb = EXCLUDED.relevance_blurb,
  relevance_blurb_id = EXCLUDED.relevance_blurb_id;

INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, 'primary', source.source_code, TRUE, 10
FROM public.lessons AS lesson
JOIN public.sources AS source ON source.source_code = 'KO389-OJK-LPBBTI-COMMITMENT'
WHERE lesson.slug = 'why-pay-later-is-bad'
  AND lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

UPDATE public.lesson_sources AS link
SET is_primary = FALSE
FROM public.lessons AS lesson, public.sources AS source
WHERE link.lesson_id = lesson.id
  AND link.source_id = source.id
  AND lesson.slug = 'why-pay-later-is-bad'
  AND source.source_code <> 'KO389-OJK-LPBBTI-COMMITMENT';

DELETE FROM public.lesson_visual_blocks AS block
USING public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'why-pay-later-is-bad'
  AND block.placement = 'concept'
  AND block.display_order = 10;

INSERT INTO public.lesson_visual_blocks (
  lesson_id, placement, block_type, content, data_status, display_order, is_published
)
SELECT
  lesson.id,
  'concept',
  'annotated_data',
  $json$
  {
    "en": {
      "eyebrow": "The full commitment",
      "title": "A small monthly number is not the whole checkout",
      "icon": "🧾",
      "disclosure": "Illustrative receipt — amounts, dates, and terms are fictional. Check the exact disclosure and terms for any provider before confirming; this is learning content, not personal financial advice.",
      "altText": "An illustrative PayLater checkout receipt. The item price is Rp 1,200,000. The plan is three payments of Rp 450,000 due on 5 September, 5 October, and 5 November. The total payable is Rp 1,350,000. The final row says to read the provider terms for late-payment conditions. Four labels explain that monthly instalments are commitments, due dates belong on a calendar, total payable is more informative than one monthly number, and late-payment conditions vary by provider.",
      "payload": {
        "quoteTitle": "Illustrative PayLater checkout",
        "price": "Rp 1.200.000 today",
        "fields": [
          {"label": "Item price", "value": "Rp 1.200.000", "note": "What the item costs at checkout"},
          {"label": "Installments", "value": "3 × Rp 450.000", "note": "Each payment is a commitment"},
          {"label": "Due dates", "value": "5 Sep · 5 Oct · 5 Nov", "note": "Put every date in your calendar"},
          {"label": "Total payable", "value": "Rp 1.350.000", "note": "Check this, not only one monthly number"},
          {"label": "Late-payment terms", "value": "Read the provider terms", "note": "Conditions vary; do not assume a rate or fee"}
        ],
        "annotations": [
          {"number": 1, "label": "Three payments still mean three commitments", "detail": "Ask whether each Rp 450.000 payment has room after essentials."},
          {"number": 2, "label": "A calendar turns a promise into dates", "detail": "Seeing all three due dates helps you check them against other bills."},
          {"number": 3, "label": "Total payable is the comparison number", "detail": "Rp 1.350.000 shows the full illustrated commitment, not just the monthly instalment."},
          {"number": 4, "label": "Terms are part of the decision", "detail": "Read the provider's disclosed late-payment conditions before confirming."}
        ]
      }
    },
    "id": {
      "eyebrow": "Komitmen penuh",
      "title": "Angka cicilan kecil bukan seluruh checkout",
      "icon": "🧾",
      "disclosure": "Struk ilustratif — jumlah, tanggal, dan ketentuan bersifat fiktif. Periksa pengungkapan dan syarat tepat dari penyedia sebelum mengonfirmasi; ini materi belajar, bukan nasihat keuangan pribadi.",
      "altText": "Struk checkout PayLater ilustratif. Harga barang Rp 1.200.000. Rencananya tiga pembayaran masing-masing Rp 450.000 yang jatuh tempo pada 5 September, 5 Oktober, dan 5 November. Total pembayaran Rp 1.350.000. Baris terakhir meminta pembaca membaca syarat penyedia mengenai kondisi keterlambatan pembayaran. Empat label menjelaskan bahwa cicilan bulanan adalah komitmen, tanggal jatuh tempo perlu masuk kalender, total pembayaran lebih informatif daripada satu angka bulanan, dan kondisi keterlambatan berbeda menurut penyedia.",
      "payload": {
        "quoteTitle": "Checkout PayLater ilustratif",
        "price": "Rp 1.200.000 hari ini",
        "fields": [
          {"label": "Harga barang", "value": "Rp 1.200.000", "note": "Biaya barang saat checkout"},
          {"label": "Cicilan", "value": "3 × Rp 450.000", "note": "Setiap pembayaran adalah komitmen"},
          {"label": "Tanggal jatuh tempo", "value": "5 Sep · 5 Okt · 5 Nov", "note": "Masukkan setiap tanggal ke kalender"},
          {"label": "Total pembayaran", "value": "Rp 1.350.000", "note": "Periksa ini, bukan hanya satu angka cicilan"},
          {"label": "Syarat keterlambatan", "value": "Baca syarat penyedia", "note": "Kondisi berbeda; jangan mengasumsikan bunga atau biaya"}
        ],
        "annotations": [
          {"number": 1, "label": "Tiga pembayaran tetap tiga komitmen", "detail": "Tanyakan apakah setiap pembayaran Rp 450.000 masih punya ruang setelah kebutuhan pokok."},
          {"number": 2, "label": "Kalender mengubah janji menjadi tanggal", "detail": "Melihat ketiga tanggal membantu memeriksanya terhadap tagihan lain."},
          {"number": 3, "label": "Total pembayaran adalah angka pembanding", "detail": "Rp 1.350.000 menunjukkan seluruh komitmen ilustratif, bukan hanya cicilan bulanan."},
          {"number": 4, "label": "Syarat adalah bagian dari keputusan", "detail": "Baca kondisi keterlambatan yang diungkapkan penyedia sebelum mengonfirmasi."}
        ]
      }
    }
  }
  $json$::jsonb,
  'illustrative',
  10,
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'why-pay-later-is-bad'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM public.lessons AS lesson
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = 'KO389-OJK-LPBBTI-COMMITMENT'
WHERE lesson.slug = 'why-pay-later-is-bad'
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'why-pay-later-is-bad'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"An item costs Rp 1,200,000. The checkout shows 3 × Rp 450,000. What commitment is easiest to miss if you only notice the monthly number?","options":["The total payable is Rp 1,350,000.","The item will cost Rp 450,000 in total.","There is only one payment to plan for.","The due dates do not matter once checkout is complete."],"answer":"The total payable is Rp 1,350,000.","explanation":"Three payments of Rp 450,000 add to Rp 1,350,000. The receipt teaches you to compare the full illustrated commitment, not only one instalment."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Sebuah barang berharga Rp 1.200.000. Checkout menunjukkan 3 × Rp 450.000. Komitmen apa yang paling mudah terlewat jika hanya melihat angka cicilan bulanan?","options":["Total pembayaran adalah Rp 1.350.000.","Harga total barang menjadi Rp 450.000.","Hanya ada satu pembayaran yang perlu direncanakan.","Tanggal jatuh tempo tidak penting setelah checkout selesai."],"answer":"Total pembayaran adalah Rp 1.350.000.","explanation":"Tiga pembayaran Rp 450.000 berjumlah Rp 1.350.000. Struk mengajarkan untuk membandingkan seluruh komitmen ilustratif, bukan hanya satu cicilan."}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which receipt row helps you notice a payment collision with another bill?","options":["Due dates","The item colour","A seller review","The checkout button label"],"answer":"Due dates","explanation":"Due dates can be put into a calendar and checked against other commitments before you confirm."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Baris struk mana yang membantu melihat bentrokan pembayaran dengan tagihan lain?","options":["Tanggal jatuh tempo","Warna barang","Ulasan penjual","Label tombol checkout"],"answer":"Tanggal jatuh tempo","explanation":"Tanggal jatuh tempo dapat dimasukkan ke kalender dan diperiksa terhadap komitmen lain sebelum mengonfirmasi."}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"If a checkout shows three instalments, you can decide safely without reading the provider's disclosed late-payment terms.","options":["True","False"],"answer":false,"explanation":"False. The visual says terms are part of the decision because late-payment conditions vary by provider."}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Jika checkout menunjukkan tiga cicilan, Anda dapat memutuskan dengan aman tanpa membaca ketentuan keterlambatan yang diungkapkan penyedia.","options":["Benar","Salah"],"answer":false,"explanation":"Salah. Visual menyatakan syarat adalah bagian dari keputusan karena kondisi keterlambatan berbeda menurut penyedia."}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
CROSS JOIN public.lessons AS lesson
WHERE lesson.slug = 'why-pay-later-is-bad'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option,
  explanation_en, explanation_id, is_active
)
SELECT
  lesson.id,
  'Before confirming an illustrated PayLater checkout, which details should you check together?',
  'Sebelum mengonfirmasi checkout PayLater ilustratif, detail apa yang perlu diperiksa bersama?',
  '["Item price, instalment amount and count, due dates, total payable, and disclosed late-payment terms","Only the monthly instalment","Only the item price","Only whether checkout feels quick"]'::jsonb,
  '["Harga barang, jumlah dan banyak cicilan, tanggal jatuh tempo, total pembayaran, serta ketentuan keterlambatan yang diungkapkan","Hanya cicilan bulanan","Hanya harga barang","Hanya apakah checkout terasa cepat"]'::jsonb,
  'Item price, instalment amount and count, due dates, total payable, and disclosed late-payment terms',
  'The receipt makes the whole commitment visible: price, every instalment and date, total payable, and the provider terms you need to read.',
  'Struk membuat seluruh komitmen terlihat: harga, setiap cicilan dan tanggalnya, total pembayaran, serta syarat penyedia yang perlu dibaca.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'why-pay-later-is-bad'
  AND lesson.is_published = TRUE
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

INSERT INTO public.lesson_reviews (
  lesson_id, reviewer_name, reviewer_role, review_date,
  factual_accuracy_status, source_verification_status, indonesia_context_status,
  compliance_status, notes, approved_to_publish
)
SELECT
  lesson.id,
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass', 'pass', 'pass', 'pass',
  'KO-389 adds an illustrative bilingual checkout receipt for full-commitment literacy. It does not quote a real provider price, fee, rate, eligibility rule, or repayment outcome; learners are directed to their provider terms.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'why-pay-later-is-bad'
ON CONFLICT (lesson_id) DO UPDATE SET
  reviewer_name = EXCLUDED.reviewer_name,
  reviewer_role = EXCLUDED.reviewer_role,
  review_date = EXCLUDED.review_date,
  factual_accuracy_status = EXCLUDED.factual_accuracy_status,
  source_verification_status = EXCLUDED.source_verification_status,
  indonesia_context_status = EXCLUDED.indonesia_context_status,
  compliance_status = EXCLUDED.compliance_status,
  notes = EXCLUDED.notes,
  approved_to_publish = EXCLUDED.approved_to_publish,
  updated_at = NOW();

COMMIT;
