BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'KO388-OJK-PEDIA-DEBT-CONTEXT',
  'OJK Pedia',
  'OJK Pedia',
  1, 'website', 'Otoritas Jasa Keuangan',
  'https://ojk.go.id/id/ojk-pedia/lists/ojk%20pedia/allitems.aspx',
  'id', '2026-08-11', 'verified',
  'Official OJK terminology and consumer-literacy context. It is not a rule that a loan is good or bad because of its stated purpose.',
  'Konteks terminologi dan literasi konsumen resmi OJK. Sumber ini bukan aturan bahwa pinjaman baik atau buruk hanya karena tujuan yang disebutkan.',
  'OJK Pedia provides official financial-literacy terminology. This lesson uses it as consumer-literacy context for checking a borrowing decision rather than assigning a universal good or bad label.',
  'OJK Pedia menyediakan terminologi literasi keuangan resmi. Pelajaran ini menggunakannya sebagai konteks literasi konsumen untuk memeriksa keputusan berutang, bukan untuk memberi label baik atau buruk secara universal.',
  'Supports the lesson''s context check: purpose, full cost and terms, room after essentials, and downside plus a repayment plan all matter before applying a label.',
  'Mendukung pemeriksaan konteks dalam pelajaran: tujuan, total biaya dan syarat, ruang setelah kebutuhan pokok, serta risiko dan rencana pelunasan semuanya penting sebelum memberi label.'
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
JOIN public.sources AS source ON source.source_code = 'KO388-OJK-PEDIA-DEBT-CONTEXT'
WHERE lesson.slug = 'good-debt-vs-bad-debt'
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
  AND lesson.slug = 'good-debt-vs-bad-debt'
  AND source.source_code <> 'KO388-OJK-PEDIA-DEBT-CONTEXT';

DELETE FROM public.lesson_visual_blocks AS block
USING public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'good-debt-vs-bad-debt'
  AND block.placement = 'concept'
  AND block.display_order = 10;

INSERT INTO public.lesson_visual_blocks (
  lesson_id, placement, block_type, content, data_status, display_order, is_published
)
SELECT
  lesson.id,
  'concept',
  'comparison',
  $json$
  {
    "en": {
      "eyebrow": "Borrowing context",
      "title": "A purpose is a starting point, not a verdict",
      "icon": "⚖️",
      "disclosure": "Illustrative comparison — a loan is not automatically good or bad. Check your actual terms and circumstances; this is learning content, not personal financial advice.",
      "altText": "A two-lane comparison. The left lane, could build capacity and needs a check, uses education or a small-business purpose. The right lane, could add pressure and needs a check, uses non-essential consumption. Both lanes require four checks: purpose or value created, full cost and terms, room after essentials, and downside plus a repayment plan. The final row says the same item can change sides with cost, cash flow, and risk; neither lane is a recommendation.",
      "payload": {
        "leftTitle": "Could build capacity — needs a check",
        "rightTitle": "Could add pressure — needs a check",
        "rows": [
          {"left": "Purpose/value created: education or a small-business tool may build capacity", "right": "Purpose/value created: non-essential consumption may add pressure without building capacity"},
          {"left": "Full cost and terms: read the total cost, timing, and conditions", "right": "Full cost and terms: read the total cost, timing, and conditions"},
          {"left": "Room after essentials: repayments still need room in the cash flow", "right": "Room after essentials: repayments still need room in the cash flow"},
          {"left": "Downside + repayment plan: the same item can change sides with cost, cash flow, and risk", "right": "Downside + repayment plan: the same item can change sides with cost, cash flow, and risk"}
        ]
      }
    },
    "id": {
      "eyebrow": "Konteks berutang",
      "title": "Tujuan adalah titik awal, bukan vonis",
      "icon": "⚖️",
      "disclosure": "Perbandingan ilustratif — pinjaman tidak otomatis baik atau buruk. Periksa syarat dan keadaan Anda yang sebenarnya; ini materi belajar, bukan nasihat keuangan pribadi.",
      "altText": "Perbandingan dua lajur. Lajur kiri, dapat membangun kapasitas dan perlu diperiksa, memakai tujuan pendidikan atau alat usaha kecil. Lajur kanan, dapat menambah tekanan dan perlu diperiksa, memakai konsumsi non-esensial. Kedua lajur memerlukan empat pemeriksaan: tujuan atau nilai yang diciptakan, total biaya dan syarat, ruang setelah kebutuhan pokok, serta risiko dan rencana pelunasan. Baris terakhir menyatakan barang yang sama dapat berpindah sisi karena biaya, arus kas, dan risiko; tidak ada lajur yang merupakan rekomendasi.",
      "payload": {
        "leftTitle": "Dapat membangun kapasitas — perlu diperiksa",
        "rightTitle": "Dapat menambah tekanan — perlu diperiksa",
        "rows": [
          {"left": "Tujuan/nilai yang diciptakan: pendidikan atau alat usaha kecil dapat membangun kapasitas", "right": "Tujuan/nilai yang diciptakan: konsumsi non-esensial dapat menambah tekanan tanpa membangun kapasitas"},
          {"left": "Total biaya dan syarat: baca biaya total, waktu, dan ketentuannya", "right": "Total biaya dan syarat: baca biaya total, waktu, dan ketentuannya"},
          {"left": "Ruang setelah kebutuhan pokok: cicilan tetap perlu ruang dalam arus kas", "right": "Ruang setelah kebutuhan pokok: cicilan tetap perlu ruang dalam arus kas"},
          {"left": "Risiko + rencana pelunasan: barang yang sama dapat berpindah sisi karena biaya, arus kas, dan risiko", "right": "Risiko + rencana pelunasan: barang yang sama dapat berpindah sisi karena biaya, arus kas, dan risiko"}
        ]
      }
    }
  }
  $json$::jsonb,
  'illustrative',
  10,
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'good-debt-vs-bad-debt'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM public.lessons AS lesson
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = 'KO388-OJK-PEDIA-DEBT-CONTEXT'
WHERE lesson.slug = 'good-debt-vs-bad-debt'
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'good-debt-vs-bad-debt'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"A course may raise income, but its repayments leave no room after essentials. What does the comparison say next?","options":["It needs more context: check full cost, cash-flow room, downside, and repayment plan.","Call it good debt because the purpose is education.","Ignore the repayments if the course sounds useful.","Call every course loan bad debt immediately."],"answer":"It needs more context: check full cost, cash-flow room, downside, and repayment plan.","explanation":"The comparison treats purpose as a starting point. It still asks about total cost and terms, room after essentials, and a downside and repayment plan."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Kursus mungkin menaikkan penghasilan, tetapi cicilannya tidak menyisakan ruang setelah kebutuhan pokok. Menurut perbandingan, apa langkah berikutnya?","options":["Perlu konteks lebih lanjut: periksa total biaya, ruang arus kas, risiko, dan rencana pelunasan.","Sebut utang baik karena tujuannya pendidikan.","Abaikan cicilan jika kursus terdengar bermanfaat.","Sebut semua pinjaman kursus sebagai utang buruk."],"answer":"Perlu konteks lebih lanjut: periksa total biaya, ruang arus kas, risiko, dan rencana pelunasan.","explanation":"Perbandingan memperlakukan tujuan sebagai titik awal. Tetap periksa total biaya dan syarat, ruang setelah kebutuhan pokok, serta risiko dan rencana pelunasan."}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which row prevents calling a loan good just because its purpose sounds productive?","options":["Full cost and terms","The colour of the loan application","A friend’s opinion","Whether the item is popular"],"answer":"Full cost and terms","explanation":"A productive-sounding purpose is not enough. The visual requires the full cost and terms to be checked too."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Baris mana yang mencegah kita menyebut pinjaman baik hanya karena tujuannya terdengar produktif?","options":["Total biaya dan syarat","Warna formulir pinjaman","Pendapat teman","Apakah barangnya populer"],"answer":"Total biaya dan syarat","explanation":"Tujuan yang terdengar produktif belum cukup. Visual juga meminta total biaya dan syarat diperiksa."}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"The visual says a purchase is automatically bad debt whenever it is for consumption.","options":["True","False"],"answer":false,"explanation":"False. The visual says purpose is only one check; cost, cash-flow room, downside, and a repayment plan still provide the context."}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Visual menyatakan pembelian otomatis menjadi utang buruk setiap kali untuk konsumsi.","options":["Benar","Salah"],"answer":false,"explanation":"Salah. Visual menyatakan tujuan hanya satu pemeriksaan; biaya, ruang arus kas, risiko, dan rencana pelunasan tetap memberi konteks."}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
CROSS JOIN public.lessons AS lesson
WHERE lesson.slug = 'good-debt-vs-bad-debt'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option,
  explanation_en, explanation_id, is_active
)
SELECT
  lesson.id,
  'Before calling borrowing good or bad, which four checks does the context card require?',
  'Sebelum menyebut utang baik atau buruk, empat pemeriksaan apa yang diminta kartu konteks?',
  '["Purpose/value created, full cost and terms, room after essentials, and downside plus a repayment plan","Only whether the purpose sounds productive","Only the monthly repayment","A friend’s label for the debt"]'::jsonb,
  '["Tujuan/nilai yang diciptakan, total biaya dan syarat, ruang setelah kebutuhan pokok, serta risiko dan rencana pelunasan","Hanya apakah tujuannya terdengar produktif","Hanya cicilan bulanan","Label utang dari teman"]'::jsonb,
  'Purpose/value created, full cost and terms, room after essentials, and downside plus a repayment plan',
  'The context card avoids a shortcut label by checking purpose, full cost and terms, cash-flow room after essentials, and downside plus a repayment plan.',
  'Kartu konteks menghindari label singkat dengan memeriksa tujuan, total biaya dan syarat, ruang arus kas setelah kebutuhan pokok, serta risiko dan rencana pelunasan.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'good-debt-vs-bad-debt'
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
  'KO-388 adds an illustrative, bilingual borrowing-context comparison with an OJK Pedia source. It does not classify any stated loan purpose as universally good or bad, and it makes no product, rate, eligibility, or income claim.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'good-debt-vs-bad-debt'
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
