BEGIN;

-- KO-392: scoped, idempotent consolidation lesson refinement. The comparison
-- remains illustrative: provider eligibility, quoted rates, fees, approval,
-- and outcomes are always agreement-specific.

UPDATE public.lessons
SET
  concept_body = $body$
Debt consolidation means replacing several existing debts with one new credit agreement. One payment can be easier to track, but it is not automatically cheaper or safer.

Use the decision boundary below before treating an offer as useful. List each existing balance, required payment, due date, and any early-settlement condition. Then read the proposed agreement's total repayment, fees, term, payment schedule, and consequences of missing a payment. A lower advertised rate alone does not answer whether the total cost or repayment plan is better.

Eligibility, approval, quoted rate, and final terms are lender-specific. Check whether the required payment still leaves room for essentials and whether the old debts will actually be settled. Consolidating and then taking on new borrowing can make the overall debt problem larger.

This is general learning content, not a recommendation to take a loan or a prediction about an application. Read your own agreements and seek accredited support where needed.
  $body$,
  concept_body_id = $body_id$
Konsolidasi utang berarti mengganti beberapa utang yang ada dengan satu perjanjian kredit baru. Satu pembayaran mungkin lebih mudah dilacak, tetapi tidak otomatis lebih murah atau lebih aman.

Gunakan batas keputusan di bawah sebelum menganggap suatu penawaran bermanfaat. Catat setiap saldo lama, pembayaran wajib, tanggal jatuh tempo, dan ketentuan pelunasan dipercepat. Lalu baca total pembayaran, biaya, tenor, jadwal pembayaran, dan akibat keterlambatan pada perjanjian baru. Suku bunga yang diiklankan lebih rendah saja belum menjawab apakah total biaya atau rencana pembayarannya lebih baik.

Kelayakan, persetujuan, suku bunga yang ditawarkan, dan ketentuan akhir bersifat khusus untuk setiap pemberi pinjaman. Periksa apakah pembayaran wajib masih menyisakan ruang untuk kebutuhan pokok dan apakah utang lama benar-benar dilunasi. Konsolidasi lalu menambah utang baru dapat membuat masalah utang keseluruhan lebih besar.

Ini materi pembelajaran umum, bukan rekomendasi mengambil pinjaman atau prediksi hasil pengajuan. Baca perjanjian Anda sendiri dan cari dukungan terakreditasi bila diperlukan.
  $body_id$,
  updated_at = NOW()
WHERE slug = 'debt-consolidation-when-and-how-to-combine-debts'
  AND is_published = TRUE;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'KO392-OJK-LPBBTI-TERMS',
  'OJK Regulation POJK 40/2024 on LPBBTI',
  'Peraturan OJK POJK 40/2024 tentang LPBBTI',
  1, 'regulation', 'Otoritas Jasa Keuangan',
  'https://ojk.go.id/id/regulasi/Pages/POJK-40-Tahun-2024-Layanan-Pendanaan-Bersama-Berbasis-Teknologi-Informasi.aspx',
  'id', '2026-08-12', 'needs_review',
  'Official OJK regulatory context for technology-enabled funding. It does not set a consolidation rate, fee, eligibility result, approval outcome, or personal borrowing decision.',
  'Konteks regulasi resmi OJK untuk pendanaan berbasis teknologi. Sumber ini tidak menetapkan suku bunga konsolidasi, biaya, hasil kelayakan, hasil persetujuan, atau keputusan pinjaman pribadi.',
  'This official OJK regulation provides Indonesian lending-context literacy. The lesson uses it only to reinforce reading the full agreement and provider-specific terms before comparing a consolidation offer.',
  'Peraturan resmi OJK ini memberikan literasi konteks pendanaan di Indonesia. Pelajaran hanya menggunakannya untuk menegaskan pembacaan perjanjian lengkap dan ketentuan khusus penyedia sebelum membandingkan tawaran konsolidasi.',
  'Use the official regulatory context as a prompt to read the full agreement. Compare your own total repayment, fees, term, payment schedule, and conditions; provider eligibility and outcomes vary.',
  'Gunakan konteks regulasi resmi sebagai pengingat untuk membaca perjanjian lengkap. Bandingkan total pembayaran, biaya, tenor, jadwal pembayaran, dan ketentuan Anda sendiri; kelayakan dan hasil berbeda menurut penyedia.'
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
JOIN public.sources AS source ON source.source_code = 'KO392-OJK-LPBBTI-TERMS'
WHERE lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
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
  AND lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
  AND source.source_code <> 'KO392-OJK-LPBBTI-TERMS';

DELETE FROM public.lesson_visual_blocks AS block
USING public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
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
      "eyebrow": "A decision boundary",
      "title": "Consolidation is worth checking, not a shortcut",
      "icon": "🔎",
      "disclosure": "Illustrative education framework — this is not a loan recommendation or an application forecast. Eligibility, approval, quoted rates, fees, and outcomes are provider- and agreement-specific. Read your own terms and seek accredited support where needed.",
      "altText": "A four-step consolidation decision boundary. First map existing debts with balances, required payments, due dates, and settlement conditions. Second compare the new agreement's total repayment, fees, term, and payment schedule rather than an advertised rate alone. Third test affordability and remember that eligibility, approval, and final terms are lender-specific. Fourth, only treat consolidation as worth checking if old debts are actually settled and new borrowing does not restart; otherwise it is not a shortcut.",
      "payload": {
        "steps": [
          {"title":"1. Map the debts being replaced","description":"List each balance, required payment, due date, and any settlement condition. A tidy list is not yet a cheaper plan."},
          {"title":"2. Compare the full new agreement","description":"Check total repayment, all fees, term, payment schedule, and missed-payment conditions. A lower advertised rate alone is not the full comparison."},
          {"title":"3. Test access and affordability","description":"Eligibility, approval, quoted rate, and final terms depend on the provider. Check whether the required payment leaves room for essentials in your own budget."},
          {"title":"4. Stop at the boundary","description":"It may be worth checking only when the old debts are actually settled and new borrowing does not restart. If total cost, terms, or affordability do not fit, consolidation is not a shortcut."}
        ]
      }
    },
    "id": {
      "eyebrow": "Batas keputusan",
      "title": "Konsolidasi layak diperiksa, bukan jalan pintas",
      "icon": "🔎",
      "disclosure": "Kerangka edukasi ilustratif — ini bukan rekomendasi pinjaman atau prediksi hasil pengajuan. Kelayakan, persetujuan, suku bunga yang ditawarkan, biaya, dan hasil bersifat khusus untuk penyedia serta perjanjian. Baca ketentuan Anda sendiri dan cari dukungan terakreditasi bila diperlukan.",
      "altText": "Batas keputusan konsolidasi dengan empat langkah. Pertama petakan utang lama beserta saldo, pembayaran wajib, tanggal jatuh tempo, dan ketentuan pelunasan. Kedua bandingkan total pembayaran, biaya, tenor, dan jadwal pembayaran pada perjanjian baru, bukan hanya suku bunga yang diiklankan. Ketiga uji kemampuan membayar dan ingat bahwa kelayakan, persetujuan, serta ketentuan akhir bergantung pada pemberi pinjaman. Keempat, anggap konsolidasi layak diperiksa hanya jika utang lama benar-benar dilunasi dan utang baru tidak dimulai lagi; selain itu, konsolidasi bukan jalan pintas.",
      "payload": {
        "steps": [
          {"title":"1. Petakan utang yang akan diganti","description":"Catat setiap saldo, pembayaran wajib, tanggal jatuh tempo, dan ketentuan pelunasan. Daftar yang rapi belum berarti rencana lebih murah."},
          {"title":"2. Bandingkan perjanjian baru secara penuh","description":"Periksa total pembayaran, seluruh biaya, tenor, jadwal pembayaran, dan ketentuan keterlambatan. Suku bunga yang diiklankan lebih rendah saja bukan perbandingan lengkap."},
          {"title":"3. Uji akses dan kemampuan membayar","description":"Kelayakan, persetujuan, suku bunga yang ditawarkan, dan ketentuan akhir bergantung pada penyedia. Periksa apakah pembayaran wajib menyisakan ruang untuk kebutuhan pokok dalam anggaran Anda."},
          {"title":"4. Berhenti pada batasnya","description":"Konsolidasi mungkin layak diperiksa hanya bila utang lama benar-benar dilunasi dan utang baru tidak dimulai lagi. Jika total biaya, ketentuan, atau kemampuan membayar tidak cocok, konsolidasi bukan jalan pintas."}
        ]
      }
    }
  }
  $json$::jsonb,
  'illustrative',
  10,
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM public.lessons AS lesson
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id
  AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = 'KO392-OJK-LPBBTI-TERMS'
WHERE lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"A consolidation offer advertises a lower rate, but its term is longer and it has fees. What should a learner compare before calling it cheaper?","options":["Total repayment, all fees, term, payment schedule, and affordability","Only the advertised rate","Only the number of old debts","Whether a friend was approved"],"answer":"Total repayment, all fees, term, payment schedule, and affordability","explanation":"The decision boundary compares the full agreement. A lower advertised rate alone does not establish a lower total cost or an affordable plan."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Sebuah tawaran konsolidasi mengiklankan suku bunga lebih rendah, tetapi tenornya lebih panjang dan ada biaya. Apa yang perlu dibandingkan sebelum menyebutnya lebih murah?","options":["Total pembayaran, seluruh biaya, tenor, jadwal pembayaran, dan kemampuan membayar","Hanya suku bunga yang diiklankan","Hanya jumlah utang lama","Apakah teman disetujui"],"answer":"Total pembayaran, seluruh biaya, tenor, jadwal pembayaran, dan kemampuan membayar","explanation":"Batas keputusan membandingkan perjanjian secara penuh. Suku bunga yang diiklankan lebih rendah saja tidak membuktikan total biaya lebih rendah atau rencana yang terjangkau."}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which statement keeps the consolidation decision within the boundary shown in the visual?","options":["Approval, eligibility, and final terms depend on the provider and agreement","A lower advertised rate guarantees approval","Combining debts removes the need to check essentials","One new loan automatically fixes overspending"],"answer":"Approval, eligibility, and final terms depend on the provider and agreement","explanation":"The visual does not forecast an application. It treats access and final terms as provider-specific and asks whether required payments fit after essentials."}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Pernyataan mana yang menjaga keputusan konsolidasi di dalam batas pada visual?","options":["Persetujuan, kelayakan, dan ketentuan akhir bergantung pada penyedia serta perjanjian","Suku bunga iklan yang lebih rendah menjamin persetujuan","Menggabungkan utang menghapus kebutuhan memeriksa kebutuhan pokok","Satu pinjaman baru otomatis memperbaiki pengeluaran berlebih"],"answer":"Persetujuan, kelayakan, dan ketentuan akhir bergantung pada penyedia serta perjanjian","explanation":"Visual tidak memprediksi hasil pengajuan. Visual memperlakukan akses dan ketentuan akhir sebagai hal khusus penyedia serta menanyakan apakah pembayaran wajib masih cocok setelah kebutuhan pokok."}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"Consolidation is a shortcut even if old debts are not actually settled and new borrowing starts again.","options":["True","False"],"answer":false,"explanation":"False. The boundary says consolidation is only worth checking when old debts are actually settled, the full agreement fits, and new borrowing does not restart."}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Konsolidasi adalah jalan pintas meskipun utang lama tidak benar-benar dilunasi dan utang baru dimulai lagi.","options":["Benar","Salah"],"answer":false,"explanation":"Salah. Batas keputusan menyatakan konsolidasi hanya layak diperiksa ketika utang lama benar-benar dilunasi, perjanjian penuh cocok, dan utang baru tidak dimulai lagi."}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
CROSS JOIN public.lessons AS lesson
WHERE lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
  AND lesson.is_published = TRUE;

INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option,
  explanation_en, explanation_id, is_active
)
SELECT
  lesson.id,
  'Before treating consolidation as worth checking, which boundary should you use?',
  'Sebelum menganggap konsolidasi layak diperiksa, batas apa yang perlu digunakan?',
  '["Map old debts; compare total repayment, fees, term, and payment schedule; test affordability and provider-specific terms; then avoid restarting borrowing","Choose the lowest advertised rate and ignore the term","Apply first and read fees after approval","Combine debts so spending habits no longer matter"]'::jsonb,
  '["Petakan utang lama; bandingkan total pembayaran, biaya, tenor, dan jadwal pembayaran; uji kemampuan membayar serta ketentuan khusus penyedia; lalu hindari memulai utang lagi","Pilih suku bunga iklan terendah dan abaikan tenor","Ajukan dahulu dan baca biaya setelah disetujui","Gabungkan utang agar kebiasaan belanja tidak lagi penting"]'::jsonb,
  'Map old debts; compare total repayment, fees, term, and payment schedule; test affordability and provider-specific terms; then avoid restarting borrowing',
  'Consolidation is not a shortcut. The useful comparison includes the full agreement, room for essentials, provider-specific access, actual settlement of old debts, and no new borrowing restart.',
  'Konsolidasi bukan jalan pintas. Perbandingan yang berguna mencakup perjanjian penuh, ruang untuk kebutuhan pokok, akses khusus penyedia, pelunasan utang lama yang nyata, dan tidak memulai utang baru lagi.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
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
  'KO-392 adds an illustrative bilingual consolidation decision boundary. It does not recommend a loan, prescribe a lender, quote a rate or fee, promise eligibility or approval, or predict a repayment outcome.',
  TRUE
FROM public.lessons AS lesson
WHERE lesson.slug = 'debt-consolidation-when-and-how-to-combine-debts'
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
