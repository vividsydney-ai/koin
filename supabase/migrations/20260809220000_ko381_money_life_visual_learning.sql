-- KO-381: Complete the Chapter 02 Money Life Skills visual-learning contract.
-- Existing visual treatments remain intact. This migration supplies their
-- reviewed source links, visual-applied checks, and five-calendar-day recall.
BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes, synopsis,
  synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES (
  'CH02-BI-QRIS', 'Bank Indonesia QRIS education material', 'Bahan edukasi QRIS Bank Indonesia',
  1, 'report', 'Bank Indonesia', 'https://www.bi.go.id/id/edukasi/Documents/Bahan-Sosialisasi-QRIS.pdf',
  'id', '2026-08-10', 'verified',
  'Official Bank Indonesia QRIS education material. QRIS is Bank Indonesia''s national QR payment standard.',
  'Indonesian primary source. The lessons use a bilingual, safety-first summary and do not endorse a payment provider.',
  'Bank Indonesia explains QRIS as Indonesia''s QR payment standard and shows a payment flow that includes checking the merchant before confirming.',
  'Bank Indonesia menjelaskan QRIS sebagai standar pembayaran QR Indonesia dan menunjukkan alur pembayaran yang mencakup pemeriksaan merchant sebelum konfirmasi.',
  'Supports the digital-wallet and QRIS lessons, including safe confirmation and official-support boundaries.',
  'Mendukung pelajaran dompet digital dan QRIS, termasuk konfirmasi aman dan batas penggunaan dukungan resmi.'
)
ON CONFLICT (source_code) DO UPDATE SET
  title = EXCLUDED.title, local_title = EXCLUDED.local_title, source_tier = EXCLUDED.source_tier,
  source_type = EXCLUDED.source_type, organization = EXCLUDED.organization, url = EXCLUDED.url,
  language = EXCLUDED.language, last_checked_at = EXCLUDED.last_checked_at, status = EXCLUDED.status,
  trust_notes = EXCLUDED.trust_notes, localization_notes = EXCLUDED.localization_notes,
  synopsis = EXCLUDED.synopsis, synopsis_id = EXCLUDED.synopsis_id,
  relevance_blurb = EXCLUDED.relevance_blurb, relevance_blurb_id = EXCLUDED.relevance_blurb_id;

UPDATE public.sources
SET relevance_blurb = 'Supports the banking lessons on choosing, using, and protecting a consumer bank account.',
    relevance_blurb_id = 'Mendukung pelajaran perbankan tentang memilih, menggunakan, dan melindungi rekening bank konsumen.',
    last_checked_at = '2026-08-10'
WHERE source_code = 'OJK-012';

WITH source_map(slug, source_code, display_order) AS (VALUES
  ('budgeting-101', 'FZ-OJK-PLANNING', 10),
  ('pay-yourself-first', 'FZ-OJK-PLANNING', 10),
  ('spending-traps', 'FZ-OJK-PLANNING', 10),
  ('behavioral-bias-intro', 'FZ-OJK-PLANNING', 10),
  ('banking-basics-choosing-the-right-account', 'OJK-012', 10),
  ('digital-wallets-qris-safe-and-smart-usage', 'CH02-BI-QRIS', 10),
  ('banking-basics-choosing-the-right-account-part-2', 'OJK-012', 10),
  ('digital-wallets-qris-safe-and-smart-usage-part-2', 'CH02-BI-QRIS', 10)
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
    'budgeting-101', 'pay-yourself-first', 'spending-traps', 'behavioral-bias-intro',
    'banking-basics-choosing-the-right-account', 'digital-wallets-qris-safe-and-smart-usage',
    'banking-basics-choosing-the-right-account-part-2', 'digital-wallets-qris-safe-and-smart-usage-part-2'
  )
  AND (lesson.slug, source.source_code) NOT IN (
    ('budgeting-101', 'FZ-OJK-PLANNING'),
    ('pay-yourself-first', 'FZ-OJK-PLANNING'),
    ('spending-traps', 'FZ-OJK-PLANNING'),
    ('behavioral-bias-intro', 'FZ-OJK-PLANNING'),
    ('banking-basics-choosing-the-right-account', 'OJK-012'),
    ('digital-wallets-qris-safe-and-smart-usage', 'CH02-BI-QRIS'),
    ('banking-basics-choosing-the-right-account-part-2', 'OJK-012'),
    ('digital-wallets-qris-safe-and-smart-usage-part-2', 'CH02-BI-QRIS')
  );

WITH source_map(slug, source_code) AS (VALUES
  ('budgeting-101', 'FZ-OJK-PLANNING'),
  ('pay-yourself-first', 'FZ-OJK-PLANNING'),
  ('spending-traps', 'FZ-OJK-PLANNING'),
  ('behavioral-bias-intro', 'FZ-OJK-PLANNING'),
  ('banking-basics-choosing-the-right-account', 'OJK-012'),
  ('digital-wallets-qris-safe-and-smart-usage', 'CH02-BI-QRIS'),
  ('banking-basics-choosing-the-right-account-part-2', 'OJK-012'),
  ('digital-wallets-qris-safe-and-smart-usage-part-2', 'CH02-BI-QRIS')
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
  AND lesson.slug IN ('budgeting-101', 'pay-yourself-first', 'spending-traps', 'behavioral-bias-intro')
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(slug, body, body_id) AS (VALUES
  ('budgeting-101',
    '{"type":"multiple_choice","difficulty":"beginner","question":"In the budget map, which group should be covered before flexible spending?","options":["Essentials such as rent, food, and transport","A surprise purchase","Every optional subscription","A promise of investment returns"],"answer":"Essentials such as rent, food, and transport","explanation":"The visual puts essential costs first, then makes room for flexible spending and goals.","parameters":{"visual":"budgeting-101"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Dalam peta anggaran, kelompok mana yang perlu ditutup sebelum pengeluaran fleksibel?","options":["Kebutuhan pokok seperti sewa, makanan, dan transportasi","Pembelian mendadak","Setiap langganan opsional","Janji imbal hasil investasi"],"answer":"Kebutuhan pokok seperti sewa, makanan, dan transportasi","explanation":"Visual menempatkan biaya pokok terlebih dahulu, lalu memberi ruang untuk pengeluaran fleksibel dan tujuan.","parameters":{"visual":"budgeting-101"}}'::jsonb),
  ('budgeting-101',
    '{"type":"true_false","difficulty":"beginner","question":"The 50/30/20 idea in the visual is a fixed rule that fits every household unchanged.","options":["True","False"],"answer":false,"explanation":"The disclosure calls it a flexible starting framework that should be adapted to a person’s circumstances.","parameters":{"visual":"budgeting-101"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Gagasan 50/30/20 pada visual adalah aturan tetap yang cocok tanpa perubahan untuk setiap rumah tangga.","options":["Benar","Salah"],"answer":false,"explanation":"Pernyataan batas menyebutnya kerangka awal yang fleksibel dan perlu disesuaikan dengan kondisi seseorang.","parameters":{"visual":"budgeting-101"}}'::jsonb),
  ('budgeting-101',
    '{"type":"multiple_choice","difficulty":"beginner","question":"Which action matches the last row of the budget map?","options":["Review actual costs and adjust deliberately","Copy a stranger’s budget","Ignore a rising bill","Spend goals first"],"answer":"Review actual costs and adjust deliberately","explanation":"A budget improves when it reflects real costs and is reviewed deliberately.","parameters":{"visual":"budgeting-101"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Tindakan mana yang sesuai dengan baris terakhir peta anggaran?","options":["Tinjau biaya nyata dan sesuaikan dengan sadar","Salin anggaran orang asing","Abaikan tagihan yang naik","Dahulukan pengeluaran tujuan"],"answer":"Tinjau biaya nyata dan sesuaikan dengan sadar","explanation":"Anggaran membaik saat mencerminkan biaya nyata dan ditinjau dengan sadar.","parameters":{"visual":"budgeting-101"}}'::jsonb),
  ('pay-yourself-first',
    '{"type":"ordering","difficulty":"beginner","question":"Which order follows the pay-yourself-first visual?","options":["Receive income","Move a planned amount","Use the remaining money"],"answer":["Receive income","Move a planned amount","Use the remaining money"],"explanation":"The flow makes a planned transfer before flexible spending, while still respecting essentials and real obligations.","parameters":{"visual":"pay-yourself-first"}}'::jsonb,
    '{"type":"ordering","difficulty":"beginner","question":"Urutan mana yang mengikuti visual bayar diri sendiri dulu?","options":["Terima pendapatan","Pindahkan jumlah yang direncanakan","Gunakan uang yang tersisa"],"answer":["Terima pendapatan","Pindahkan jumlah yang direncanakan","Gunakan uang yang tersisa"],"explanation":"Alur memindahkan jumlah yang direncanakan sebelum belanja fleksibel, sambil tetap menghormati kebutuhan pokok dan kewajiban nyata.","parameters":{"visual":"pay-yourself-first"}}'::jsonb),
  ('pay-yourself-first',
    '{"type":"multiple_choice","difficulty":"beginner","question":"What makes the planned amount safer to start with?","options":["It fits after essentials and due obligations","It empties every account","It is borrowed for shopping","It depends on a guaranteed return"],"answer":"It fits after essentials and due obligations","explanation":"The visual is about a deliberate amount that fits the learner’s real situation, not an automatic promise.","parameters":{"visual":"pay-yourself-first"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Apa yang membuat jumlah yang direncanakan lebih aman untuk dimulai?","options":["Jumlah itu muat setelah kebutuhan pokok dan kewajiban jatuh tempo","Jumlah itu mengosongkan semua rekening","Jumlah itu dipinjam untuk belanja","Jumlah itu bergantung pada imbal hasil terjamin"],"answer":"Jumlah itu muat setelah kebutuhan pokok dan kewajiban jatuh tempo","explanation":"Visual membahas jumlah yang disengaja dan sesuai kondisi nyata pelajar, bukan janji otomatis.","parameters":{"visual":"pay-yourself-first"}}'::jsonb),
  ('pay-yourself-first',
    '{"type":"true_false","difficulty":"beginner","question":"Paying yourself first means ignoring rent, food, or debt due dates.","options":["True","False"],"answer":false,"explanation":"Planning first should not remove money needed for essentials or obligations.","parameters":{"visual":"pay-yourself-first"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Bayar diri sendiri dulu berarti mengabaikan sewa, makanan, atau tanggal jatuh tempo utang.","options":["Benar","Salah"],"answer":false,"explanation":"Merencanakan lebih dulu tidak boleh menghilangkan uang yang diperlukan untuk kebutuhan pokok atau kewajiban.","parameters":{"visual":"pay-yourself-first"}}'::jsonb),
  ('spending-traps',
    '{"type":"ordering","difficulty":"beginner","question":"Which order follows the spending-trap visual?","options":["Notice the trigger","Pause","Choose the next action"],"answer":["Notice the trigger","Pause","Choose the next action"],"explanation":"The visual creates a gap between a trigger and a purchase so the next action can be deliberate.","parameters":{"visual":"spending-traps"}}'::jsonb,
    '{"type":"ordering","difficulty":"beginner","question":"Urutan mana yang mengikuti visual jebakan belanja?","options":["Sadari pemicu","Berhenti sejenak","Pilih tindakan berikutnya"],"answer":["Sadari pemicu","Berhenti sejenak","Pilih tindakan berikutnya"],"explanation":"Visual menciptakan jeda antara pemicu dan pembelian agar tindakan berikutnya dapat disengaja.","parameters":{"visual":"spending-traps"}}'::jsonb),
  ('spending-traps',
    '{"type":"multiple_choice","difficulty":"beginner","question":"A limited-time banner makes you feel rushed. What is the visual’s safest next move?","options":["Pause and check whether the purchase fits your plan","Buy before the timer ends","Borrow immediately","Hide the transaction"],"answer":"Pause and check whether the purchase fits your plan","explanation":"Urgency is a trigger, not a reason to skip a deliberate decision.","parameters":{"visual":"spending-traps"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Banner waktu terbatas membuat Anda merasa terburu-buru. Apa langkah berikutnya yang paling aman menurut visual?","options":["Berhenti sejenak dan cek apakah pembelian sesuai rencana","Beli sebelum penghitung waktu habis","Segera meminjam","Sembunyikan transaksi"],"answer":"Berhenti sejenak dan cek apakah pembelian sesuai rencana","explanation":"Rasa mendesak adalah pemicu, bukan alasan untuk melewati keputusan yang disengaja.","parameters":{"visual":"spending-traps"}}'::jsonb),
  ('spending-traps',
    '{"type":"true_false","difficulty":"beginner","question":"The visual says every non-essential purchase is a mistake.","options":["True","False"],"answer":false,"explanation":"It teaches a pause and deliberate choice, not a blanket ban on optional spending.","parameters":{"visual":"spending-traps"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Visual menyatakan setiap pembelian nonpokok adalah kesalahan.","options":["Benar","Salah"],"answer":false,"explanation":"Visual mengajarkan jeda dan pilihan yang disengaja, bukan larangan menyeluruh atas pengeluaran opsional.","parameters":{"visual":"spending-traps"}}'::jsonb),
  ('behavioral-bias-intro',
    '{"type":"ordering","difficulty":"beginner","question":"Which order follows the bias-check visual?","options":["Name the feeling","Check the evidence","Choose after the pause"],"answer":["Name the feeling","Check the evidence","Choose after the pause"],"explanation":"The visual separates a feeling from evidence before a decision is made.","parameters":{"visual":"behavioral-bias-intro"}}'::jsonb,
    '{"type":"ordering","difficulty":"beginner","question":"Urutan mana yang mengikuti visual cek bias?","options":["Sebutkan perasaannya","Periksa buktinya","Pilih setelah jeda"],"answer":["Sebutkan perasaannya","Periksa buktinya","Pilih setelah jeda"],"explanation":"Visual memisahkan perasaan dari bukti sebelum keputusan dibuat.","parameters":{"visual":"behavioral-bias-intro"}}'::jsonb),
  ('behavioral-bias-intro',
    '{"type":"multiple_choice","difficulty":"beginner","question":"You feel FOMO after a friend’s post. Which question fits the visual?","options":["What evidence supports this choice for my own goal?","How do I copy the friend immediately?","Can I guarantee the same result?","Should I skip the facts?"],"answer":"What evidence supports this choice for my own goal?","explanation":"A bias check brings the decision back to evidence and the learner’s own goal.","parameters":{"visual":"behavioral-bias-intro"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Anda merasa FOMO setelah melihat unggahan teman. Pertanyaan mana yang sesuai dengan visual?","options":["Bukti apa yang mendukung pilihan ini untuk tujuan saya sendiri?","Bagaimana saya segera meniru teman?","Bisakah saya menjamin hasil yang sama?","Haruskah saya melewati fakta?"],"answer":"Bukti apa yang mendukung pilihan ini untuk tujuan saya sendiri?","explanation":"Cek bias mengembalikan keputusan ke bukti dan tujuan pelajar sendiri.","parameters":{"visual":"behavioral-bias-intro"}}'::jsonb),
  ('behavioral-bias-intro',
    '{"type":"true_false","difficulty":"beginner","question":"Noticing a bias guarantees every future decision will be correct.","options":["True","False"],"answer":false,"explanation":"The visual offers a better pause and check. It cannot guarantee an outcome.","parameters":{"visual":"behavioral-bias-intro"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"Menyadari bias menjamin setiap keputusan masa depan akan benar.","options":["Benar","Salah"],"answer":false,"explanation":"Visual menawarkan jeda dan pemeriksaan yang lebih baik. Visual tidak dapat menjamin hasil.","parameters":{"visual":"behavioral-bias-intro"}}'::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
JOIN public.lessons AS lesson ON lesson.slug = applied.slug
WHERE lesson.is_published = TRUE;

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (VALUES
  ('budgeting-101', 'What should a budget map cover before flexible spending?', 'Apa yang perlu ditutup peta anggaran sebelum pengeluaran fleksibel?', '["Essential costs","Every optional want","A guaranteed return"]'::jsonb, '["Biaya pokok","Setiap keinginan opsional","Imbal hasil terjamin"]'::jsonb, 'Essential costs', 'A budget starts by making essential costs visible.', 'Anggaran dimulai dengan membuat biaya pokok terlihat.'),
  ('pay-yourself-first', 'What should a planned transfer still leave room for?', 'Apa yang tetap perlu diberi ruang oleh transfer yang direncanakan?', '["Essentials and due obligations","A rushed purchase","A guaranteed investment"]'::jsonb, '["Kebutuhan pokok dan kewajiban jatuh tempo","Pembelian terburu-buru","Investasi yang dijamin"]'::jsonb, 'Essentials and due obligations', 'A planned amount should fit the learner’s real obligations.', 'Jumlah yang direncanakan perlu sesuai dengan kewajiban nyata pelajar.'),
  ('spending-traps', 'What is the pause for in the spending-trap visual?', 'Untuk apa jeda pada visual jebakan belanja?', '["To choose deliberately after noticing a trigger","To guarantee a discount","To ignore the budget"]'::jsonb, '["Untuk memilih dengan sadar setelah menyadari pemicu","Untuk menjamin diskon","Untuk mengabaikan anggaran"]'::jsonb, 'To choose deliberately after noticing a trigger', 'A pause gives evidence and priorities a chance to enter the decision.', 'Jeda memberi bukti dan prioritas kesempatan untuk masuk ke keputusan.'),
  ('behavioral-bias-intro', 'After naming a feeling, what comes next in the bias check?', 'Setelah menyebutkan perasaan, apa langkah berikutnya dalam cek bias?', '["Check the evidence","Copy a friend","Promise a result"]'::jsonb, '["Periksa bukti","Tiru teman","Janjikan hasil"]'::jsonb, 'Check the evidence', 'The visual asks for evidence before choosing.', 'Visual meminta bukti sebelum memilih.')
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
