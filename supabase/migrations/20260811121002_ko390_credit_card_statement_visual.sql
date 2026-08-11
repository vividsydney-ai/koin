BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'KO390-BI-CARD-PAYMENT-INSTRUMENTS',
  'Bank Indonesia Card-Based Payment Instruments',
  'Instrumen Pembayaran Berbasis Kartu Bank Indonesia',
  1, 'website', 'Bank Indonesia',
  'https://www.bi.go.id/id/fungsi-utama/sistem-pembayaran/ritel/instrumen/default.aspx',
  'id', '2026-08-11', 'verified',
  'Official Bank Indonesia information about card-based payment instruments. It does not quote the rate, fee, payment rule, or outcome for a particular issuer product.',
  'Informasi resmi Bank Indonesia tentang instrumen pembayaran berbasis kartu. Sumber ini tidak mengutip suku bunga, biaya, aturan pembayaran, atau hasil dari produk penerbit tertentu.',
  'This official page provides current Indonesian card-payment context. The lesson uses it only to reinforce reading a statement balance, minimum due, due date, and issuer terms; all statement figures remain fictional.',
  'Halaman resmi ini memberikan konteks pembayaran kartu di Indonesia saat ini. Pelajaran menggunakannya hanya untuk menegaskan pembacaan saldo tagihan, pembayaran minimum, tanggal jatuh tempo, dan ketentuan penerbit; semua angka tagihan tetap fiktif.',
  'Use this official context to understand why a minimum due and total statement balance are different labels. Check your own issuer statement and terms for the actual due amount, date, rate, and fees.',
  'Gunakan konteks resmi ini untuk memahami mengapa pembayaran minimum dan total saldo tagihan adalah label yang berbeda. Periksa tagihan dan ketentuan penerbit Anda sendiri untuk jumlah, tanggal, suku bunga, dan biaya yang sebenarnya.'
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

DELETE FROM public.lesson_sources AS link
USING public.lessons AS lesson, public.sources AS source
WHERE link.lesson_id = lesson.id
  AND link.source_id = source.id
  AND lesson.slug = 'credit-card-good-or-bad'
  AND source.source_code = 'KO390-OJK-PEDIA-CARD-STATEMENT';

INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, 'primary', source.source_code, TRUE, 10
FROM public.lessons AS lesson
JOIN public.sources AS source ON source.source_code = 'KO390-BI-CARD-PAYMENT-INSTRUMENTS'
WHERE lesson.slug = 'credit-card-good-or-bad'
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
  AND lesson.slug = 'credit-card-good-or-bad'
  AND source.source_code <> 'KO390-BI-CARD-PAYMENT-INSTRUMENTS';

DELETE FROM public.lesson_visual_blocks AS block
USING public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'credit-card-good-or-bad'
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
      "eyebrow": "Statement anatomy",
      "title": "Paying the minimum is different from settling the illustrated statement",
      "icon": "💳",
      "disclosure": "Illustrative statement — all amounts and dates are fictional. The simple remaining-balance arithmetic below is not a rate, fee, or cost forecast. Check your own issuer statement and terms; this is learning content, not personal financial advice.",
      "altText": "An illustrative credit-card statement with a statement balance of Rp 2,400,000, a minimum due of Rp 240,000, and a due date of 25 September. It compares paying the full Rp 2,400,000, which settles the illustrated statement balance, with paying only Rp 240,000, which leaves an illustrated balance of Rp 2,160,000 before any future issuer terms. Four numbered labels explain the statement balance, minimum due, due date, and remaining balance.",
      "payload": {
        "quoteTitle": "Illustrative credit-card statement",
        "price": "Rp 2.400.000 statement balance",
        "fields": [
          {"label": "Statement balance", "value": "Rp 2.400.000", "note": "The total shown on this fictional statement"},
          {"label": "Minimum due", "value": "Rp 240.000", "note": "A stated minimum; it is not the full settlement"},
          {"label": "Due date", "value": "25 September", "note": "Check this date on your own statement"},
          {"label": "Pay in full", "value": "Rp 2.400.000", "note": "Settles this illustrated statement balance before its due date"},
          {"label": "Pay only the minimum", "value": "Rp 2.160.000 remains", "note": "Rp 2.400.000 minus Rp 240.000; not a future cost forecast"}
        ],
        "annotations": [
          {"number": 1, "label": "Start with the statement balance", "detail": "It is the total amount displayed on this fictional statement, not a suggested payment."},
          {"number": 2, "label": "Minimum due is a different number", "detail": "It tells you the stated minimum on this example; it does not make the full balance disappear."},
          {"number": 3, "label": "Due date belongs beside the amount", "detail": "Use the due date and amount together when reading your own issuer statement."},
          {"number": 4, "label": "Carrying a balance leaves an amount to understand", "detail": "After only the fictional Rp 240.000 minimum, Rp 2.160.000 remains before any future issuer-specific terms."}
        ]
      }
    },
    "id": {
      "eyebrow": "Anatomi tagihan",
      "title": "Membayar minimum berbeda dengan melunasi tagihan ilustratif",
      "icon": "💳",
      "disclosure": "Tagihan ilustratif — seluruh jumlah dan tanggal bersifat fiktif. Aritmetika sederhana sisa saldo di bawah ini bukan suku bunga, biaya, atau perkiraan biaya. Periksa tagihan dan ketentuan penerbit Anda sendiri; ini materi belajar, bukan nasihat keuangan pribadi.",
      "altText": "Tagihan kartu kredit ilustratif dengan saldo tagihan Rp 2.400.000, pembayaran minimum Rp 240.000, dan tanggal jatuh tempo 25 September. Tagihan membandingkan pembayaran penuh Rp 2.400.000 yang melunasi saldo tagihan ilustratif dengan pembayaran minimum Rp 240.000 yang menyisakan saldo ilustratif Rp 2.160.000 sebelum ketentuan penerbit di masa depan. Empat label bernomor menjelaskan saldo tagihan, pembayaran minimum, tanggal jatuh tempo, dan sisa saldo.",
      "payload": {
        "quoteTitle": "Tagihan kartu kredit ilustratif",
        "price": "Saldo tagihan Rp 2.400.000",
        "fields": [
          {"label": "Saldo tagihan", "value": "Rp 2.400.000", "note": "Total yang tertera pada tagihan fiktif ini"},
          {"label": "Pembayaran minimum", "value": "Rp 240.000", "note": "Minimum yang tertera; bukan pelunasan penuh"},
          {"label": "Tanggal jatuh tempo", "value": "25 September", "note": "Periksa tanggal ini pada tagihan Anda sendiri"},
          {"label": "Bayar penuh", "value": "Rp 2.400.000", "note": "Melunasi saldo tagihan ilustratif ini sebelum jatuh tempo"},
          {"label": "Bayar minimum saja", "value": "Sisa Rp 2.160.000", "note": "Rp 2.400.000 dikurangi Rp 240.000; bukan perkiraan biaya masa depan"}
        ],
        "annotations": [
          {"number": 1, "label": "Mulai dari saldo tagihan", "detail": "Ini adalah total yang ditampilkan pada tagihan fiktif ini, bukan saran jumlah pembayaran."},
          {"number": 2, "label": "Pembayaran minimum adalah angka yang berbeda", "detail": "Angka ini menunjukkan minimum pada contoh; angka tersebut tidak membuat seluruh saldo hilang."},
          {"number": 3, "label": "Tanggal jatuh tempo perlu dibaca bersama jumlahnya", "detail": "Gunakan tanggal jatuh tempo dan jumlah bersama-sama saat membaca tagihan penerbit Anda."},
          {"number": 4, "label": "Membawa saldo menyisakan jumlah yang perlu dipahami", "detail": "Setelah hanya membayar minimum fiktif Rp 240.000, sisa Rp 2.160.000 sebelum ketentuan penerbit di masa depan."}
        ]
      }
    }
  }
  $json$::jsonb,
  'illustrative',
  10,
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'credit-card-good-or-bad'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM public.lessons AS lesson
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = 'KO390-BI-CARD-PAYMENT-INSTRUMENTS'
WHERE lesson.slug = 'credit-card-good-or-bad'
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'credit-card-good-or-bad'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"An illustrative statement balance is Rp 2,400,000 and its minimum due is Rp 240,000. If only that illustrated minimum is paid, what simple balance remains before any future issuer-specific terms?","options":["Rp 2,160,000","Rp 0","Rp 240,000","The statement balance doubles"],"answer":"Rp 2,160,000","explanation":"Rp 2,400,000 minus Rp 240,000 leaves Rp 2,160,000 in this fictional arithmetic example. It does not forecast a rate, fee, or future cost."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Saldo tagihan ilustratif Rp 2.400.000 dan pembayaran minimumnya Rp 240.000. Jika hanya minimum ilustratif itu dibayar, berapa sisa saldo sederhana sebelum ketentuan penerbit di masa depan?","options":["Rp 2.160.000","Rp 0","Rp 240.000","Saldo tagihan menjadi dua kali lipat"],"answer":"Rp 2.160.000","explanation":"Rp 2.400.000 dikurangi Rp 240.000 menyisakan Rp 2.160.000 dalam contoh aritmetika fiktif ini. Ini bukan perkiraan suku bunga, biaya, atau biaya masa depan."}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which payment shown on the illustrative statement settles its Rp 2,400,000 statement balance before the due date?","options":["Pay Rp 2,400,000 in full","Pay only Rp 240,000","Pay an unstated amount later","Ignore the due date"],"answer":"Pay Rp 2,400,000 in full","explanation":"The visual separates the full statement balance from the minimum due. Paying the full illustrated balance is the path that settles that fictional statement."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Pembayaran mana yang ditampilkan pada tagihan ilustratif melunasi saldo tagihan Rp 2.400.000 sebelum tanggal jatuh tempo?","options":["Bayar penuh Rp 2.400.000","Bayar hanya Rp 240.000","Bayar jumlah yang tidak disebutkan nanti","Abaikan tanggal jatuh tempo"],"answer":"Bayar penuh Rp 2.400.000","explanation":"Visual memisahkan saldo tagihan penuh dari pembayaran minimum. Membayar penuh saldo ilustratif adalah cara yang melunasi tagihan fiktif tersebut."}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"The minimum due on a statement by itself tells you the future cost of carrying the remaining balance.","options":["True","False"],"answer":false,"explanation":"False. The illustration only shows simple subtraction. Check your issuer terms for any actual rate, fees, and payment conditions."}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Pembayaran minimum pada tagihan dengan sendirinya memberi tahu biaya masa depan jika membawa sisa saldo.","options":["Benar","Salah"],"answer":false,"explanation":"Salah. Ilustrasi hanya menunjukkan pengurangan sederhana. Periksa ketentuan penerbit untuk suku bunga, biaya, dan kondisi pembayaran yang sebenarnya."}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
CROSS JOIN public.lessons AS lesson
WHERE lesson.slug = 'credit-card-good-or-bad'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option,
  explanation_en, explanation_id, is_active
)
SELECT
  lesson.id,
  'When you read a credit-card statement, which details should you check together?',
  'Saat membaca tagihan kartu kredit, detail apa yang perlu diperiksa bersama?',
  '["Statement balance, minimum due, due date, and what remains after each payment choice","Only the minimum due","Only the card design","Only whether the statement is recent"]'::jsonb,
  '["Saldo tagihan, pembayaran minimum, tanggal jatuh tempo, dan sisa setelah setiap pilihan pembayaran","Hanya pembayaran minimum","Hanya desain kartu","Hanya apakah tagihan baru"]'::jsonb,
  'Statement balance, minimum due, due date, and what remains after each payment choice',
  'The statement anatomy separates the total shown, minimum due, due date, and the simple amount that remains if the fictional minimum alone is paid. Your own issuer terms determine actual conditions.',
  'Anatomi tagihan memisahkan total yang tertera, pembayaran minimum, tanggal jatuh tempo, dan jumlah sederhana yang tersisa jika hanya minimum fiktif dibayar. Ketentuan penerbit Anda sendiri menentukan kondisi sebenarnya.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'credit-card-good-or-bad'
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
  'KO-390 adds an illustrative bilingual credit-card statement anatomy card. It does not quote a card issuer rate, fee, payment rule, eligibility condition, or outcome; learners are directed to their own issuer statement and terms.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'credit-card-good-or-bad'
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
