BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'KO391-OJK-IDEB-SLIK',
  'OJK iDebKu — Debtor Information Service',
  'OJK iDebKu — Layanan Informasi Debitur',
  1, 'website', 'Otoritas Jasa Keuangan', 'https://idebku.ojk.go.id/Public/HomePage',
  'id', '2026-08-11', 'verified',
  'Official OJK service for debtor-information literacy. It does not prescribe a repayment method, provider outcome, eligibility result, or personal credit decision.',
  'Layanan resmi OJK untuk literasi informasi debitur. Sumber ini tidak menetapkan metode pelunasan, hasil dari penyedia, hasil kelayakan, atau keputusan kredit pribadi.',
  'This official OJK service explains the context for checking debtor information. The lesson uses it only to reinforce listing obligations accurately; its avalanche and snowball examples remain educational planning frameworks.',
  'Layanan resmi OJK ini menjelaskan konteks untuk memeriksa informasi debitur. Pelajaran ini hanya menggunakannya untuk menegaskan pentingnya mencatat kewajiban secara akurat; contoh avalanche dan snowball tetap merupakan kerangka perencanaan edukatif.',
  'Use this official context to understand debtor-information literacy. For any real repayment, check your own agreements, due dates, costs, and available support before acting.',
  'Gunakan konteks resmi ini untuk memahami literasi informasi debitur. Untuk pelunasan nyata, periksa perjanjian, tanggal jatuh tempo, biaya, dan dukungan yang tersedia sebelum bertindak.'
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
JOIN public.sources AS source ON source.source_code = 'KO391-OJK-IDEB-SLIK'
WHERE lesson.slug = 'how-to-pay-debt-responsibly'
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
  AND lesson.slug = 'how-to-pay-debt-responsibly'
  AND source.source_code <> 'KO391-OJK-IDEB-SLIK';

DELETE FROM public.lesson_visual_blocks AS block
USING public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'how-to-pay-debt-responsibly'
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
      "eyebrow": "A repayment route",
      "title": "Build a clear route before choosing where extra money goes",
      "icon": "🧭",
      "disclosure": "Illustrative education framework — avalanche and snowball are planning methods, not a universal best choice or personal credit advice. Check your own agreements, due dates, costs, essentials, and available support before acting.",
      "altText": "A four-step responsible repayment flow: first list every debt with its balance, due date, and required payment; second protect essentials and scheduled required payments; third choose either an avalanche focus on the highest cost or a snowball focus on the smallest balance, while continuing required payments; fourth avoid adding new borrowing and revisit the plan or contact the provider early if a payment cannot be met.",
      "payload": {
        "steps": [
          {"title":"1. List every obligation","description":"Write the balance, required payment, due date, and key terms for each debt. Use your own agreements and records; do not guess."},
          {"title":"2. Protect essentials and required payments","description":"Keep food, housing, transport, and other essentials visible. Make the required payments you can while checking due dates and available support."},
          {"title":"3. Choose one educational focus","description":"Avalanche puts extra money toward the highest cost; snowball puts it toward the smallest balance. Neither is automatically best—compare cost, motivation, and your real obligations."},
          {"title":"4. Keep the route from growing","description":"Avoid adding new borrowing to the plan. Review it regularly; if you may miss a payment, check your agreement and contact the provider or appropriate support early."}
        ]
      }
    },
    "id": {
      "eyebrow": "Rute pelunasan",
      "title": "Buat rute yang jelas sebelum memilih tujuan uang ekstra",
      "icon": "🧭",
      "disclosure": "Kerangka edukasi ilustratif — avalanche dan snowball adalah metode perencanaan, bukan pilihan terbaik universal atau nasihat kredit pribadi. Periksa perjanjian, tanggal jatuh tempo, biaya, kebutuhan pokok, dan dukungan yang tersedia sebelum bertindak.",
      "altText": "Alur pelunasan bertanggung jawab dengan empat langkah: pertama catat setiap utang beserta saldo, tanggal jatuh tempo, dan pembayaran wajibnya; kedua lindungi kebutuhan pokok dan pembayaran wajib terjadwal; ketiga pilih fokus avalanche pada biaya tertinggi atau snowball pada saldo terkecil sambil tetap melanjutkan pembayaran wajib; keempat hindari menambah utang baru dan tinjau rencana atau hubungi penyedia lebih awal jika pembayaran tidak dapat dipenuhi.",
      "payload": {
        "steps": [
          {"title":"1. Catat setiap kewajiban","description":"Tuliskan saldo, pembayaran wajib, tanggal jatuh tempo, dan ketentuan utama setiap utang. Gunakan perjanjian dan catatan Anda sendiri; jangan menebak."},
          {"title":"2. Lindungi kebutuhan pokok dan pembayaran wajib","description":"Pastikan makanan, tempat tinggal, transportasi, dan kebutuhan pokok lain tetap terlihat. Lakukan pembayaran wajib yang mampu dilakukan sambil memeriksa tanggal jatuh tempo dan dukungan yang tersedia."},
          {"title":"3. Pilih satu fokus edukatif","description":"Avalanche mengarahkan uang ekstra ke biaya tertinggi; snowball mengarahkannya ke saldo terkecil. Tidak ada yang otomatis terbaik—bandingkan biaya, motivasi, dan kewajiban nyata Anda."},
          {"title":"4. Jaga agar rute tidak bertambah","description":"Hindari menambah utang baru ke dalam rencana. Tinjau rencana secara berkala; jika mungkin tidak dapat membayar, periksa perjanjian dan hubungi penyedia atau dukungan yang sesuai lebih awal."}
        ]
      }
    }
  }
  $json$::jsonb,
  'illustrative',
  10,
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'how-to-pay-debt-responsibly'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM public.lessons AS lesson
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = 'KO391-OJK-IDEB-SLIK'
WHERE lesson.slug = 'how-to-pay-debt-responsibly'
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'how-to-pay-debt-responsibly'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"A learner has several debts and some extra money this month. According to the flow, what should happen before choosing avalanche or snowball?","options":["List each debt and protect essentials plus required payments","Put all money toward the smallest balance immediately","Open a new loan to simplify the list","Ignore due dates until there is more money"],"answer":"List each debt and protect essentials plus required payments","explanation":"The flow starts with accurate obligations, essentials, due dates, and required payments. Avalanche or snowball is a later educational focus, not the first step."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Seorang pelajar memiliki beberapa utang dan uang ekstra bulan ini. Menurut alur, apa yang perlu dilakukan sebelum memilih avalanche atau snowball?","options":["Catat setiap utang dan lindungi kebutuhan pokok serta pembayaran wajib","Langsung arahkan semua uang ke saldo terkecil","Buka pinjaman baru untuk menyederhanakan daftar","Abaikan tanggal jatuh tempo sampai ada lebih banyak uang"],"answer":"Catat setiap utang dan lindungi kebutuhan pokok serta pembayaran wajib","explanation":"Alur dimulai dengan kewajiban yang akurat, kebutuhan pokok, tanggal jatuh tempo, dan pembayaran wajib. Avalanche atau snowball adalah fokus edukatif berikutnya, bukan langkah pertama."}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which statement accurately compares the two educational repayment focuses in the visual?","options":["Avalanche targets the highest cost; snowball targets the smallest balance","Avalanche always works for everyone; snowball never does","Snowball targets the highest cost; avalanche targets the smallest balance","Both methods mean skipping required payments on other debts"],"answer":"Avalanche targets the highest cost; snowball targets the smallest balance","explanation":"The visual compares two possible focuses after essentials and required payments are considered. It does not name a universal winner."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Pernyataan mana yang tepat membandingkan dua fokus pelunasan edukatif pada visual?","options":["Avalanche menargetkan biaya tertinggi; snowball menargetkan saldo terkecil","Avalanche selalu cocok untuk semua orang; snowball tidak pernah cocok","Snowball menargetkan biaya tertinggi; avalanche menargetkan saldo terkecil","Kedua metode berarti melewatkan pembayaran wajib pada utang lain"],"answer":"Avalanche menargetkan biaya tertinggi; snowball menargetkan saldo terkecil","explanation":"Visual membandingkan dua fokus yang mungkin dipilih setelah kebutuhan pokok dan pembayaran wajib dipertimbangkan. Visual tidak menetapkan pemenang universal."}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"The repayment flow says a person should add new borrowing whenever a planned payment feels difficult.","options":["True","False"],"answer":false,"explanation":"False. The flow says to avoid adding new borrowing, review the agreement, and contact the provider or appropriate support early when a payment may not be met."}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Alur pelunasan menyatakan seseorang perlu menambah utang baru setiap kali pembayaran yang direncanakan terasa sulit.","options":["Benar","Salah"],"answer":false,"explanation":"Salah. Alur menyarankan untuk menghindari menambah utang baru, meninjau perjanjian, dan menghubungi penyedia atau dukungan yang sesuai lebih awal jika pembayaran mungkin tidak dapat dipenuhi."}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
CROSS JOIN public.lessons AS lesson
WHERE lesson.slug = 'how-to-pay-debt-responsibly'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option,
  explanation_en, explanation_id, is_active
)
SELECT
  lesson.id,
  'Before choosing a repayment focus, which four parts belong in the responsible-repayment route?',
  'Sebelum memilih fokus pelunasan, empat bagian apa yang termasuk dalam rute pelunasan bertanggung jawab?',
  '["List obligations, protect essentials and required payments, choose a bounded focus, then avoid new borrowing and review","Choose the smallest balance, ignore essentials, borrow more, and hope","Pay only one debt without recording due dates","Copy another person’s plan without checking your agreement"]'::jsonb,
  '["Catat kewajiban, lindungi kebutuhan pokok dan pembayaran wajib, pilih fokus yang terbatas, lalu hindari utang baru dan tinjau","Pilih saldo terkecil, abaikan kebutuhan pokok, berutang lebih banyak, lalu berharap","Bayar hanya satu utang tanpa mencatat tanggal jatuh tempo","Salin rencana orang lain tanpa memeriksa perjanjian Anda"]'::jsonb,
  'List obligations, protect essentials and required payments, choose a bounded focus, then avoid new borrowing and review',
  'The route is a learning framework: list accurate obligations, keep essentials and required payments visible, choose a bounded focus, and avoid adding new borrowing while reviewing the plan.',
  'Rute ini adalah kerangka belajar: catat kewajiban secara akurat, pastikan kebutuhan pokok dan pembayaran wajib tetap terlihat, pilih fokus yang terbatas, lalu hindari menambah utang baru sambil meninjau rencana.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'how-to-pay-debt-responsibly'
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
  'koin-curriculum-agent', 'curriculum-agent', CURRENT_DATE,
  'pass', 'pass', 'pass', 'pass',
  'KO-391 adds an illustrative bilingual responsible-repayment flow. Avalanche and snowball are framed as educational methods rather than a universal best choice, personal credit advice, or predicted outcome.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'how-to-pay-debt-responsibly'
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
