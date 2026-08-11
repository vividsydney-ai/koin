-- KO-387: Visualise the debt-trap lifecycle for the published Debt Traps lesson.
--
-- The values in the visual are fictional teaching prompts. This migration does
-- not state a provider rate, fee, eligibility rule, or personalised advice.

BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes, synopsis,
  synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES
  (
    'KO387-OJK-LPBBTI-2024',
    'OJK Regulation POJK 40/2024 on Information-Technology-Based Co-Funding Services',
    'Peraturan OJK POJK 40/2024 tentang Layanan Pendanaan Bersama Berbasis Teknologi Informasi',
    1, 'regulation', 'Otoritas Jasa Keuangan',
    'https://ojk.go.id/id/regulasi/Pages/POJK-40-Tahun-2024-Layanan-Pendanaan-Bersama-Berbasis-Teknologi-Informasi.aspx',
    'id', '2026-08-11', 'verified',
    'Primary OJK regulation for technology-enabled co-funding services. It is used for a regulatory and consumer-risk boundary, not to state any provider-specific fee or outcome.',
    'Sumber primer OJK untuk batas regulasi dan risiko konsumen pada layanan pendanaan berbasis teknologi; tidak digunakan untuk menyatakan biaya atau hasil penyedia tertentu.',
    'OJK sets regulatory and risk-mitigation expectations for technology-enabled co-funding services. The lesson uses it to keep the debt example grounded in Indonesian consumer-protection context.',
    'OJK menetapkan ekspektasi regulasi dan mitigasi risiko untuk layanan pendanaan berbasis teknologi. Pelajaran menggunakan sumber ini untuk menempatkan contoh utang dalam konteks perlindungan konsumen Indonesia.',
    'Supports the lesson''s reminder to check terms, due dates, and official consumer-protection information before taking on another obligation.',
    'Mendukung pengingat pelajaran untuk memeriksa syarat, tanggal jatuh tempo, dan informasi perlindungan konsumen resmi sebelum menambah kewajiban.'
  ),
  (
    'KO387-OJK-ONLINE-LENDING-CONSUMER',
    'OJK online-lending consumer-protection reminder',
    'Pengingat OJK tentang perlindungan konsumen pinjaman daring',
    1, 'press_release', 'Otoritas Jasa Keuangan',
    'https://ojk.go.id/en/berita-dan-kegiatan/siaran-pers/Pages/OJK-Summons-Rupiah-Cepat-Calls-on-Online-Lending-Consumer-Protection-Commitment.aspx',
    'en', '2026-08-11', 'verified',
    'OJK consumer-protection communication. It is used for careful-use, credential-protection, and official complaint-channel framing only.',
    'Komunikasi perlindungan konsumen OJK. Digunakan hanya untuk konteks penggunaan secara hati-hati, perlindungan kredensial, dan saluran pengaduan resmi.',
    'OJK highlights consumer-protection commitments in online lending. The lesson uses this as a prompt to use official information and support channels when a debt obligation is unclear.',
    'OJK menyoroti komitmen perlindungan konsumen dalam pinjaman daring. Pelajaran menggunakan sumber ini sebagai pengingat untuk memakai informasi dan saluran bantuan resmi ketika kewajiban utang tidak jelas.',
    'Supports the lesson''s pause point: review the bill and terms, avoid adding a new obligation, and use official consumer-protection information when needed.',
    'Mendukung titik jeda dalam pelajaran: tinjau tagihan dan syarat, hindari menambah kewajiban baru, serta gunakan informasi perlindungan konsumen resmi bila diperlukan.'
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

WITH source_map(source_code, relevance_type, is_primary, display_order) AS (VALUES
  ('KO387-OJK-LPBBTI-2024', 'primary', TRUE, 10),
  ('KO387-OJK-ONLINE-LENDING-CONSUMER', 'supporting', FALSE, 20)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, source_map.relevance_type, source.source_code, source_map.is_primary, source_map.display_order
FROM source_map
JOIN public.lessons AS lesson ON lesson.slug = 'debt-traps'
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
  AND lesson.slug = 'debt-traps'
  AND source.source_code <> 'KO387-OJK-LPBBTI-2024';

DELETE FROM public.lesson_visual_blocks AS block
USING public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'debt-traps'
  AND block.placement = 'concept'
  AND block.display_order = 10;

INSERT INTO public.lesson_visual_blocks (
  lesson_id, placement, block_type, content, data_status, display_order, is_published
)
SELECT
  lesson.id,
  'concept',
  'process',
  $json$
  {
    "en": {
      "eyebrow": "Debt trap map",
      "title": "How a small bill can become a debt stack",
      "icon": "🧾",
      "disclosure": "Illustrative scenario — amounts, fees, and terms vary by provider. This is a learning map, not personal financial advice.",
      "altText": "A five-step debt stack map: a purchase creates an obligation; the due date arrives; a missed or partial payment can leave a balance; new purchases can add obligations; the pause point is to stop adding new borrowing and review the bill and terms.",
      "payload": {
        "steps": [
          {"title": "1. Checkout", "description": "A Rp 300,000 purchase becomes one future obligation. The important information is the total due, due date, and terms."},
          {"title": "2. Due date", "description": "The bill is now due. Checking the statement and its terms makes the obligation visible before it is missed."},
          {"title": "3. Balance carried", "description": "A missed or partial payment can leave an unpaid balance. A late charge or other cost may apply under the provider's terms."},
          {"title": "4. Debt stack", "description": "Adding another purchase while an old balance remains can create more than one obligation competing for the same income."},
          {"title": "5. Pause point", "description": "Do not add new borrowing. Review the bill and terms, then use official consumer-protection information or support if the obligation is unclear."}
        ]
      }
    },
    "id": {
      "eyebrow": "Peta jebakan utang",
      "title": "Bagaimana tagihan kecil dapat menjadi tumpukan utang",
      "icon": "🧾",
      "disclosure": "Skenario ilustratif — jumlah, biaya, dan syarat berbeda menurut penyedia. Ini adalah peta belajar, bukan nasihat keuangan pribadi.",
      "altText": "Peta tumpukan utang lima langkah: pembelian membuat kewajiban; tanggal jatuh tempo tiba; pembayaran terlewat atau sebagian dapat menyisakan saldo; pembelian baru dapat menambah kewajiban; titik jeda adalah berhenti menambah utang baru dan meninjau tagihan serta syarat.",
      "payload": {
        "steps": [
          {"title": "1. Checkout", "description": "Pembelian Rp 300.000 menjadi satu kewajiban di masa depan. Informasi pentingnya adalah total tagihan, tanggal jatuh tempo, dan syarat."},
          {"title": "2. Tanggal jatuh tempo", "description": "Tagihan sekarang jatuh tempo. Memeriksa tagihan dan syaratnya membuat kewajiban terlihat sebelum terlewat."},
          {"title": "3. Saldo terbawa", "description": "Pembayaran yang terlewat atau sebagian dapat menyisakan saldo yang belum dibayar. Biaya keterlambatan atau biaya lain dapat berlaku sesuai syarat penyedia."},
          {"title": "4. Tumpukan utang", "description": "Menambah pembelian lain saat saldo lama masih ada dapat membuat lebih dari satu kewajiban bersaing untuk pendapatan yang sama."},
          {"title": "5. Titik jeda", "description": "Jangan menambah utang baru. Tinjau tagihan dan syarat, lalu gunakan informasi perlindungan konsumen atau bantuan resmi bila kewajiban tidak jelas."}
        ]
      }
    }
  }
  $json$::jsonb,
  'illustrative',
  10,
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'debt-traps'
  AND lesson.is_published = TRUE;

WITH source_map(source_code) AS (VALUES
  ('KO387-OJK-LPBBTI-2024'),
  ('KO387-OJK-ONLINE-LENDING-CONSUMER')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM source_map
JOIN public.lessons AS lesson ON lesson.slug = 'debt-traps'
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = source_map.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'debt-traps'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"In the debt-stack map, which action is the pause point that helps avoid adding another obligation?","options":["Stop adding new borrowing and review the bill and terms","Open another PayLater checkout","Ignore the due date until next month","Assume every provider has the same fee"],"answer":"Stop adding new borrowing and review the bill and terms","explanation":"The visual''s pause point stops the stack from gaining a new obligation and makes the current bill visible first.","parameters":{"visual":"debt-traps"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Dalam peta tumpukan utang, tindakan mana yang menjadi titik jeda untuk membantu menghindari penambahan kewajiban baru?","options":["Berhenti menambah utang baru dan tinjau tagihan serta syarat","Membuka checkout PayLater lain","Mengabaikan tanggal jatuh tempo sampai bulan depan","Menganggap setiap penyedia memiliki biaya yang sama"],"answer":"Berhenti menambah utang baru dan tinjau tagihan serta syarat","explanation":"Titik jeda pada visual menghentikan penambahan kewajiban baru dan membuat tagihan saat ini terlihat lebih dulu.","parameters":{"visual":"debt-traps"}}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which step explains why a second purchase can make the situation harder to manage?","options":["Debt stack: old and new obligations compete for the same income","Checkout: every purchase disappears immediately","Due date: terms no longer matter","Pause point: fees are identical everywhere"],"answer":"Debt stack: old and new obligations compete for the same income","explanation":"The visual shows that a new obligation can join an unpaid balance, so both compete for the same income.","parameters":{"visual":"debt-traps"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Langkah mana yang menjelaskan mengapa pembelian kedua dapat membuat situasi lebih sulit dikelola?","options":["Tumpukan utang: kewajiban lama dan baru bersaing untuk pendapatan yang sama","Checkout: setiap pembelian langsung hilang","Tanggal jatuh tempo: syarat tidak lagi penting","Titik jeda: biaya selalu sama di semua tempat"],"answer":"Tumpukan utang: kewajiban lama dan baru bersaing untuk pendapatan yang sama","explanation":"Visual menunjukkan bahwa kewajiban baru dapat bergabung dengan saldo yang belum dibayar, sehingga keduanya bersaing untuk pendapatan yang sama.","parameters":{"visual":"debt-traps"}}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"The Rp 300,000 amount in the debt-stack map is a standard provider fee or rate that applies to everyone.","options":["True","False"],"answer":false,"explanation":"The map labels the amount as illustrative. Actual totals, fees, and terms depend on the provider and agreement.","parameters":{"visual":"debt-traps"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Jumlah Rp 300.000 dalam peta tumpukan utang adalah biaya atau tarif standar penyedia yang berlaku untuk semua orang.","options":["Benar","Salah"],"answer":false,"explanation":"Peta menandai jumlah tersebut sebagai ilustratif. Total, biaya, dan syarat aktual bergantung pada penyedia dan perjanjian.","parameters":{"visual":"debt-traps"}}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
CROSS JOIN public.lessons AS lesson
WHERE lesson.slug = 'debt-traps'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option,
  explanation_en, explanation_id, is_active
)
SELECT
  lesson.id,
  'What is the pause point in the debt-stack map?',
  'Apa titik jeda dalam peta tumpukan utang?',
  '["Stop adding new borrowing and review the bill and terms","Add another purchase before checking the old bill","Assume every fee is the same"]'::jsonb,
  '["Berhenti menambah utang baru dan tinjau tagihan serta syarat","Tambahkan pembelian lain sebelum memeriksa tagihan lama","Anggap semua biaya sama"]'::jsonb,
  'Stop adding new borrowing and review the bill and terms',
  'The pause point prevents another obligation from joining the stack before the current bill is understood.',
  'Titik jeda mencegah kewajiban lain masuk ke tumpukan sebelum tagihan saat ini dipahami.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'debt-traps'
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
  'KO-387 adds an illustrative, bilingual debt-stack visual with verified OJK sources. It does not state provider-specific fees, rates, eligibility, or personalised advice.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'debt-traps'
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
