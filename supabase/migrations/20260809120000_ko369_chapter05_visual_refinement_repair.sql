-- KO-369 repair: Chapter 05 visual-learning refinement after the recorded 20260809110000 failure.
-- Four published lessons become a bilingual visual bundle. The retirement
-- lesson is split into two explicit objectives before its applied practice is
-- seeded. All examples are illustrative/calculated and keep their disclosure.
BEGIN;

-- Remove only unusable Chapter 05 source links. The official OJK links remain
-- attached and already carry bilingual synopsis/relevance metadata.
DELETE FROM public.lesson_sources AS ls
USING public.lessons AS lesson, public.topics AS topic, public.sources AS source
WHERE ls.lesson_id = lesson.id
  AND topic.chapter = 'Plan Your Money'
  AND lesson.is_published = TRUE
  AND source.id = ls.source_id
  AND source.url IS NULL;

-- Keep one official primary source per lesson after removing placeholders.
UPDATE public.lesson_sources AS ls
SET is_primary = source.source_code = CASE lesson.slug
  WHEN 'emergency-fund-101' THEN 'OJK-003'
  WHEN 'goal-setting-101' THEN 'OJK-002'
  WHEN 'building-financial-plan' THEN 'OJK-001'
  WHEN 'retirement-planning-bpjs-dplk-and-starting-early' THEN 'OJK-001'
  ELSE source.source_code
END
FROM public.lessons AS lesson, public.topics AS topic, public.sources AS source
WHERE ls.lesson_id = lesson.id
  AND topic.chapter = 'Plan Your Money'
  AND lesson.is_published = TRUE
  AND source.id = ls.source_id;

-- Keep the existing retirement slug as Part 1 so existing learner progress is
-- not discarded, and give Part 2 its own prerequisite and curriculum rank.
UPDATE public.lessons
SET title = 'Retirement Planning: BPJS JHT and DPLK',
    title_id = 'Perencanaan Pensiun: BPJS JHT dan DPLK',
    summary = 'Compare the role of BPJS JHT and DPLK before choosing a long-term retirement saving mix.',
    summary_id = 'Bandingkan peran BPJS JHT dan DPLK sebelum memilih kombinasi tabungan pensiun jangka panjang.',
    concept_body = 'Retirement planning starts by knowing which tools already support you and which choices are still yours. BPJS Ketenagakerjaan JHT is connected to employment and has its own contribution, access, and withdrawal rules. DPLK is a voluntary retirement savings route through a financial institution. Personal investments can complement these tools, but they carry different risks, fees, liquidity, and terms. Treat each product as a tool with a role, not as a guaranteed outcome. Check the current official terms before acting.',
    concept_body_id = 'Perencanaan pensiun dimulai dengan memahami alat yang sudah mendukungmu dan pilihan yang masih menjadi keputusanmu. JHT BPJS Ketenagakerjaan terkait dengan pekerjaan dan memiliki aturan kontribusi, akses, serta pencairan sendiri. DPLK adalah jalur tabungan pensiun sukarela melalui lembaga keuangan. Investasi pribadi dapat melengkapi alat tersebut, tetapi memiliki risiko, biaya, likuiditas, dan ketentuan yang berbeda. Perlakukan setiap produk sebagai alat dengan peran tertentu, bukan sebagai hasil yang dijamin. Periksa ketentuan resmi terbaru sebelum bertindak.',
    indonesian_example = 'Rina mencatat saldo JHT, mencari tahu aturan DPLK, lalu memisahkan kebutuhan jangka pendek dari tabungan pensiun. Ia membandingkan biaya, akses, dan risiko sebelum memilih.',
    why_this_matters = 'A clear role for each retirement tool helps you avoid relying on one product or confusing an illustration with a promise.',
    why_this_matters_id = 'Memahami peran setiap alat pensiun membantumu menghindari ketergantungan pada satu produk atau menganggap ilustrasi sebagai janji.',
    common_mistake = 'Assuming BPJS JHT, DPLK, and personal investments have the same rules or guaranteed returns.',
    common_mistake_id = 'Menganggap BPJS JHT, DPLK, dan investasi pribadi memiliki aturan atau imbal hasil yang sama dan pasti.',
    updated_at = NOW()
WHERE slug = 'retirement-planning-bpjs-dplk-and-starting-early';

INSERT INTO public.lessons (
  slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward,
  estimated_minutes, summary, summary_id, concept_body, concept_body_id,
  indonesian_example, why_this_matters, why_this_matters_id, common_mistake,
  common_mistake_id, review_status, reviewed_by, reviewed_at, is_published,
  jurisdiction, prerequisite_lesson_id
)
SELECT
  'retirement-planning-start-early-compounding',
  'Retirement Planning: Start Early and Review the Assumptions',
  'Perencanaan Pensiun: Mulai Lebih Awal dan Tinjau Asumsinya',
  lesson.topic_id,
  179,
  lesson.difficulty,
  lesson.xp_reward,
  4,
  'Starting earlier gives contributions more time to grow, but every projection depends on assumptions that can change.',
  'Memulai lebih awal memberi kontribusi lebih banyak waktu untuk berkembang, tetapi setiap proyeksi bergantung pada asumsi yang dapat berubah.',
  'Starting earlier can give regular contributions more time to compound. A comparison is useful only when you show its assumptions: the monthly contribution, the saving period, the assumed return, and the fact that returns are not guaranteed. Estimate the retirement income you may need, compare it with existing benefits and savings, and review the gap as your income, responsibilities, prices, and goals change. Keep near-term needs separate from long-term retirement money.',
  'Memulai lebih awal dapat memberi kontribusi rutin lebih banyak waktu untuk bertumbuh secara majemuk. Perbandingan hanya berguna jika asumsi ditampilkan: kontribusi bulanan, lama menabung, asumsi imbal hasil, dan fakta bahwa hasil tidak dijamin. Perkirakan pendapatan pensiun yang mungkin kamu butuhkan, bandingkan dengan manfaat dan tabungan yang sudah ada, lalu tinjau selisihnya saat pendapatan, tanggung jawab, harga, dan tujuan berubah. Pisahkan kebutuhan jangka dekat dari uang pensiun jangka panjang.',
  'Rina membandingkan dua waktu mulai dengan kontribusi bulanan yang sama. Ia menggunakan angka itu untuk memahami waktu, bukan untuk menjanjikan hasil masa depan.',
  'Seeing the assumptions behind a projection helps you make a plan without treating a calculator output as a promise.',
  'Melihat asumsi di balik proyeksi membantumu membuat rencana tanpa menganggap hasil kalkulator sebagai janji.',
  'Treating a projected future value as guaranteed or forgetting to review the plan when life changes.',
  'Menganggap nilai masa depan yang diproyeksikan sebagai jaminan atau lupa meninjau rencana saat hidup berubah.',
  lesson.review_status,
  lesson.reviewed_by,
  lesson.reviewed_at,
  TRUE,
  lesson.jurisdiction,
  lesson.id
FROM public.lessons AS lesson
WHERE lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  title_id = EXCLUDED.title_id,
  summary = EXCLUDED.summary,
  summary_id = EXCLUDED.summary_id,
  concept_body = EXCLUDED.concept_body,
  concept_body_id = EXCLUDED.concept_body_id,
  indonesian_example = EXCLUDED.indonesian_example,
  why_this_matters = EXCLUDED.why_this_matters,
  why_this_matters_id = EXCLUDED.why_this_matters_id,
  common_mistake = EXCLUDED.common_mistake,
  common_mistake_id = EXCLUDED.common_mistake_id,
  prerequisite_lesson_id = EXCLUDED.prerequisite_lesson_id,
  is_published = TRUE,
  updated_at = NOW();

INSERT INTO public.lesson_reviews (
  lesson_id, reviewer_name, reviewer_role, review_date,
  factual_accuracy_status, source_verification_status, indonesia_context_status,
  compliance_status, notes, approved_to_publish
)
SELECT new_lesson.id, old_review.reviewer_name, old_review.reviewer_role,
       old_review.review_date, old_review.factual_accuracy_status,
       old_review.source_verification_status, old_review.indonesia_context_status,
       old_review.compliance_status,
       'KO-369 Part 2 inherits the reviewed chapter boundary; projections remain illustrative and non-guaranteed.',
       old_review.approved_to_publish
FROM public.lessons AS old_lesson
JOIN public.lesson_reviews AS old_review ON old_review.lesson_id = old_lesson.id
JOIN public.lessons AS new_lesson ON new_lesson.slug = 'retirement-planning-start-early-compounding'
WHERE old_lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
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

-- Part 2 uses the same reviewed official boundary as Part 1.
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT new_lesson.id, source.id, old_link.relevance_type, source.source_code, old_link.is_primary, old_link.display_order
FROM public.lessons AS old_lesson
JOIN public.lesson_sources AS old_link ON old_link.lesson_id = old_lesson.id
JOIN public.sources AS source ON source.id = old_link.source_id
JOIN public.lessons AS new_lesson ON new_lesson.slug = 'retirement-planning-start-early-compounding'
WHERE old_lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
  AND source.url IS NOT NULL
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

-- Replace only the applied-practice pool for this chapter. The base quiz pool
-- is retained for normal lesson progression and safe retries.
DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
JOIN public.topics AS topic ON topic.id = lesson.topic_id
WHERE variant.lesson_id = lesson.id
  AND topic.chapter = 'Plan Your Money'
  AND variant.topic_tag = 'visual_applied';

WITH applied(slug, body, body_id) AS (VALUES
('emergency-fund-101',
  '{"type":"multiple_choice","difficulty":"beginner","question":"The emergency-fund visual says the main job of this money is to provide what?","options":["Stable, quick access for urgent needs","The highest possible return","A way to buy volatile assets","A substitute for every insurance policy"],"answer":"Stable, quick access for urgent needs","explanation":"The visual separates stability and access from the goal of chasing a high return.","parameters":{"visual":"emergency-fund-101"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Visual dana darurat menunjukkan bahwa fungsi utama uang ini adalah apa?","options":["Akses cepat dan stabil untuk kebutuhan mendesak","Imbal hasil setinggi mungkin","Cara membeli aset yang volatil","Pengganti semua polis asuransi"],"answer":"Akses cepat dan stabil untuk kebutuhan mendesak","explanation":"Visual membedakan stabilitas dan akses dari tujuan mengejar imbal hasil tinggi.","parameters":{"visual":"emergency-fund-101"}}'::jsonb),
('emergency-fund-101',
  '{"type":"multiple_choice","difficulty":"beginner","question":"Which situation supports choosing a larger emergency-fund buffer in the visual?","options":["Irregular income or family dependants","A guaranteed high return","A planned holiday next month","A desire to trade more often"],"answer":"Irregular income or family dependants","explanation":"More income uncertainty or dependants can require a larger accessible buffer.","parameters":{"visual":"emergency-fund-101"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Situasi mana yang mendukung pemilihan penyangga dana darurat lebih besar dalam visual?","options":["Pendapatan tidak tetap atau tanggungan keluarga","Imbal hasil tinggi yang dijamin","Liburan yang sudah direncanakan bulan depan","Keinginan untuk lebih sering berdagang"],"answer":"Pendapatan tidak tetap atau tanggungan keluarga","explanation":"Pendapatan yang lebih tidak pasti atau tanggungan dapat membutuhkan penyangga yang lebih besar dan mudah diakses.","parameters":{"visual":"emergency-fund-101"}}'::jsonb),
('emergency-fund-101',
  '{"type":"multiple_choice","difficulty":"beginner","question":"Which choice conflicts with the emergency-fund visual?","options":["Putting urgent-needs money in a volatile asset","Keeping a separate accessible balance","Starting with a small amount","Building the buffer before taking long-term risk"],"answer":"Putting urgent-needs money in a volatile asset","explanation":"Money needed during a shock should not depend on a price that may fall sharply.","parameters":{"visual":"emergency-fund-101"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Pilihan mana yang bertentangan dengan visual dana darurat?","options":["Menempatkan uang kebutuhan mendesak di aset volatil","Menjaga saldo terpisah yang mudah diakses","Memulai dari jumlah kecil","Membangun penyangga sebelum mengambil risiko jangka panjang"],"answer":"Menempatkan uang kebutuhan mendesak di aset volatil","explanation":"Uang yang dibutuhkan saat guncangan tidak seharusnya bergantung pada harga yang bisa turun tajam.","parameters":{"visual":"emergency-fund-101"}}'::jsonb),
('goal-setting-101',
  '{"type":"worked_example","difficulty":"beginner","question":"The visual goal is Rp12,000,000, you already have Rp3,000,000, and the deadline is 12 months. What monthly saving amount does the worked example show?","options":["Rp750,000","Rp1,000,000","Rp250,000","Rp12,000,000"],"answer":"Rp750,000","explanation":"The remaining Rp9,000,000 divided by 12 months is Rp750,000 per month.","parameters":{"visual":"goal-setting-101"}}'::jsonb,
  '{"type":"worked_example","difficulty":"beginner","question":"Tujuan pada visual adalah Rp12.000.000, kamu sudah memiliki Rp3.000.000, dan tenggatnya 12 bulan. Berapa tabungan bulanan dalam contoh?","options":["Rp750.000","Rp1.000.000","Rp250.000","Rp12.000.000"],"answer":"Rp750.000","explanation":"Sisa Rp9.000.000 dibagi 12 bulan adalah Rp750.000 per bulan.","parameters":{"visual":"goal-setting-101"}}'::jsonb),
('goal-setting-101',
  '{"type":"multiple_choice","difficulty":"beginner","question":"Which goal matches the visual rule for a measurable target?","options":["Save Rp5,000,000 for a laptop by December","Save more someday","Spend less when possible","Buy something useful later"],"answer":"Save Rp5,000,000 for a laptop by December","explanation":"A measurable goal names the purpose, amount, and deadline.","parameters":{"visual":"goal-setting-101"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Tujuan mana yang sesuai dengan aturan target terukur pada visual?","options":["Menabung Rp5.000.000 untuk laptop sebelum Desember","Menabung lebih banyak suatu hari nanti","Mengurangi belanja jika bisa","Membeli sesuatu yang berguna nanti"],"answer":"Menabung Rp5.000.000 untuk laptop sebelum Desember","explanation":"Tujuan terukur menyebutkan keperluan, nominal, dan tenggat waktu.","parameters":{"visual":"goal-setting-101"}}'::jsonb),
('goal-setting-101',
  '{"type":"multiple_choice","difficulty":"beginner","question":"Why does the visual place a short-term goal in savings rather than a volatile investment?","options":["The money may be needed before the price has time to recover","Savings always earns more","Investments are illegal for short goals","A deadline removes every risk"],"answer":"The money may be needed before the price has time to recover","explanation":"A short horizon leaves less time to wait through a market fall.","parameters":{"visual":"goal-setting-101"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Mengapa visual menempatkan tujuan jangka pendek di tabungan, bukan investasi volatil?","options":["Uang mungkin dibutuhkan sebelum harga punya waktu untuk pulih","Tabungan selalu menghasilkan lebih banyak","Investasi ilegal untuk tujuan jangka pendek","Tenggat waktu menghapus semua risiko"],"answer":"Uang mungkin dibutuhkan sebelum harga punya waktu untuk pulih","explanation":"Jangka waktu pendek memberi lebih sedikit kesempatan untuk menunggu saat pasar turun.","parameters":{"visual":"goal-setting-101"}}'::jsonb),
('building-financial-plan',
  '{"type":"ordering","difficulty":"beginner","question":"Which sequence matches the financial-plan flow?","options":["Set goals","Build an emergency buffer","Control high-interest debt","Choose investments for the goal"],"answer":["Set goals","Build an emergency buffer","Control high-interest debt","Choose investments for the goal"],"explanation":"The flow starts with purpose, adds protection, controls expensive debt, and only then matches investment risk to the goal.","parameters":{"visual":"building-financial-plan"}}'::jsonb,
  '{"type":"ordering","difficulty":"beginner","question":"Urutan mana yang sesuai dengan alur rencana keuangan?","options":["Tetapkan tujuan","Bangun penyangga dana darurat","Kendalikan utang berbunga tinggi","Pilih investasi sesuai tujuan"],"answer":["Tetapkan tujuan","Bangun penyangga dana darurat","Kendalikan utang berbunga tinggi","Pilih investasi sesuai tujuan"],"explanation":"Alur dimulai dari tujuan, menambahkan perlindungan, mengendalikan utang mahal, lalu mencocokkan risiko investasi dengan tujuan.","parameters":{"visual":"building-financial-plan"}}'::jsonb),
('building-financial-plan',
  '{"type":"true_false","difficulty":"beginner","question":"The visual says a financial plan should be reviewed when income, goals, or responsibilities change.","options":["True","False"],"answer":true,"explanation":"A plan is a repeatable check-in, not a document made once and never adjusted.","parameters":{"visual":"building-financial-plan"}}'::jsonb,
  '{"type":"true_false","difficulty":"beginner","question":"Visual menyatakan rencana keuangan perlu ditinjau saat pendapatan, tujuan, atau tanggung jawab berubah.","options":["Benar","Salah"],"answer":true,"explanation":"Rencana adalah pemeriksaan berulang, bukan dokumen yang dibuat sekali lalu tidak pernah disesuaikan.","parameters":{"visual":"building-financial-plan"}}'::jsonb),
('building-financial-plan',
  '{"type":"multiple_choice","difficulty":"beginner","question":"What is the safer conclusion from the plan visual when someone has no buffer and high-interest debt?","options":["Protect the basics and control the debt before taking investment risk","Invest all spare cash immediately","Borrow more to invest","Ignore the debt if a return is possible"],"answer":"Protect the basics and control the debt before taking investment risk","explanation":"The sequence protects essentials before adding long-term market risk.","parameters":{"visual":"building-financial-plan"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Apa kesimpulan yang lebih aman dari visual rencana ketika seseorang belum punya penyangga dan memiliki utang berbunga tinggi?","options":["Lindungi kebutuhan dasar dan kendalikan utang sebelum mengambil risiko investasi","Segera investasikan semua uang sisa","Berutang lagi untuk berinvestasi","Abaikan utang jika ada peluang imbal hasil"],"answer":"Lindungi kebutuhan dasar dan kendalikan utang sebelum mengambil risiko investasi","explanation":"Urutan ini melindungi kebutuhan pokok sebelum menambah risiko pasar jangka panjang.","parameters":{"visual":"building-financial-plan"}}'::jsonb),
('retirement-planning-bpjs-dplk-and-starting-early',
  '{"type":"matching","difficulty":"beginner","question":"Match each retirement tool with the role shown in the comparison.","pairs":[["BPJS JHT","Employment-linked old-age benefit"],["DPLK","Voluntary retirement saving through a financial institution"],["Personal investments","Flexible long-term assets with their own risk and terms"]],"answer":{"BPJS JHT":"Employment-linked old-age benefit","DPLK":"Voluntary retirement saving through a financial institution","Personal investments":"Flexible long-term assets with their own risk and terms"},"explanation":"The tools can complement each other but do not have identical rules or guarantees.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb,
  '{"type":"matching","difficulty":"beginner","question":"Pasangkan setiap alat pensiun dengan peran pada perbandingan.","pairs":[["BPJS JHT","Manfaat hari tua terkait pekerjaan"],["DPLK","Tabungan pensiun sukarela melalui lembaga keuangan"],["Investasi pribadi","Aset jangka panjang fleksibel dengan risiko dan ketentuan sendiri"]],"answer":{"BPJS JHT":"Manfaat hari tua terkait pekerjaan","DPLK":"Tabungan pensiun sukarela melalui lembaga keuangan","Investasi pribadi":"Aset jangka panjang fleksibel dengan risiko dan ketentuan sendiri"},"explanation":"Alat-alat ini dapat saling melengkapi, tetapi tidak memiliki aturan atau jaminan yang sama.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb),
('retirement-planning-bpjs-dplk-and-starting-early',
  '{"type":"multiple_choice","difficulty":"beginner","question":"What should a learner check before relying on a retirement product detail?","options":["Current official terms, access rules, fees, and risks","Only the product name","A return promise from a social post","A friend''s result as a guarantee"],"answer":"Current official terms, access rules, fees, and risks","explanation":"Product rules and terms can change; the comparison is a learning frame, not a product endorsement.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Apa yang perlu diperiksa sebelum mengandalkan detail produk pensiun?","options":["Ketentuan resmi terbaru, aturan akses, biaya, dan risiko","Hanya nama produk","Janji imbal hasil dari unggahan media sosial","Hasil teman sebagai jaminan"],"answer":"Ketentuan resmi terbaru, aturan akses, biaya, dan risiko","explanation":"Aturan dan ketentuan produk dapat berubah; perbandingan ini adalah kerangka belajar, bukan dukungan produk.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb),
('retirement-planning-bpjs-dplk-and-starting-early',
  '{"type":"true_false","difficulty":"beginner","question":"BPJS JHT, DPLK, and personal investments should be treated as identical products with identical rules.","options":["True","False"],"answer":false,"explanation":"The visual separates their roles, access rules, risks, and terms.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb,
  '{"type":"true_false","difficulty":"beginner","question":"BPJS JHT, DPLK, dan investasi pribadi harus dianggap sebagai produk identik dengan aturan yang identik.","options":["Benar","Salah"],"answer":false,"explanation":"Visual memisahkan peran, aturan akses, risiko, dan ketentuannya.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb),
('retirement-planning-start-early-compounding',
  '{"type":"multiple_choice","difficulty":"beginner","question":"In the retirement comparison, what changes when the same monthly contribution starts earlier?","options":["There is more time for contributions and compounding","The return becomes guaranteed","All market risk disappears","The learner no longer needs a budget"],"answer":"There is more time for contributions and compounding","explanation":"Time can help contributions compound, but the illustration does not guarantee a return.","parameters":{"visual":"retirement-planning-start-early-compounding"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Dalam perbandingan pensiun, apa yang berubah ketika kontribusi bulanan yang sama dimulai lebih awal?","options":["Ada lebih banyak waktu untuk kontribusi dan pertumbuhan majemuk","Imbal hasil menjadi pasti","Semua risiko pasar hilang","Kamu tidak lagi membutuhkan anggaran"],"answer":"Ada lebih banyak waktu untuk kontribusi dan pertumbuhan majemuk","explanation":"Waktu dapat membantu kontribusi bertumbuh majemuk, tetapi ilustrasi ini tidak menjamin imbal hasil.","parameters":{"visual":"retirement-planning-start-early-compounding"}}'::jsonb),
('retirement-planning-start-early-compounding',
  '{"type":"multiple_choice","difficulty":"beginner","question":"Which assumption must be visible before using a retirement projection?","options":["Contribution, time period, assumed return, and its uncertainty","Only the final number","A promise that the market will repeat the past","The learner''s age alone"],"answer":"Contribution, time period, assumed return, and its uncertainty","explanation":"A projection is only interpretable when its inputs and limits are visible.","parameters":{"visual":"retirement-planning-start-early-compounding"}}'::jsonb,
  '{"type":"multiple_choice","difficulty":"beginner","question":"Asumsi apa yang harus terlihat sebelum menggunakan proyeksi pensiun?","options":["Kontribusi, periode waktu, asumsi imbal hasil, dan ketidakpastiannya","Hanya angka akhir","Janji bahwa pasar akan mengulang masa lalu","Usia pelajar saja"],"answer":"Kontribusi, periode waktu, asumsi imbal hasil, dan ketidakpastiannya","explanation":"Proyeksi hanya dapat dipahami jika input dan batasnya terlihat.","parameters":{"visual":"retirement-planning-start-early-compounding"}}'::jsonb),
('retirement-planning-start-early-compounding',
  '{"type":"true_false","difficulty":"beginner","question":"Starting earlier guarantees that the projected future value will happen.","options":["True","False"],"answer":false,"explanation":"Starting earlier can create more time, but market returns, inflation, and life changes remain uncertain.","parameters":{"visual":"retirement-planning-start-early-compounding"}}'::jsonb,
  '{"type":"true_false","difficulty":"beginner","question":"Memulai lebih awal menjamin nilai masa depan yang diproyeksikan akan terjadi.","options":["Benar","Salah"],"answer":false,"explanation":"Memulai lebih awal dapat memberi lebih banyak waktu, tetapi imbal hasil pasar, inflasi, dan perubahan hidup tetap tidak pasti.","parameters":{"visual":"retirement-planning-start-early-compounding"}}'::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
JOIN public.lessons AS lesson ON lesson.slug = applied.slug
WHERE lesson.is_published;

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (VALUES
('emergency-fund-101', 'What should an emergency fund optimise first?', 'Apa yang harus diutamakan oleh dana darurat?', '["Stable value and quick access","Highest return","Maximum trading activity"]'::jsonb, '["Nilai stabil dan akses cepat","Imbal hasil tertinggi","Aktivitas perdagangan maksimum"]'::jsonb, 'Stable value and quick access', 'Urgent-needs money needs stability and access before return chasing.', 'Uang untuk kebutuhan mendesak membutuhkan stabilitas dan akses sebelum mengejar imbal hasil.'),
('goal-setting-101', 'What two details make a savings goal measurable?', 'Dua detail apa yang membuat tujuan tabungan dapat diukur?', '["Amount and deadline","Colour and slogan","Account logo and password"]'::jsonb, '["Nominal dan tenggat","Warna dan slogan","Logo dan kata sandi rekening"]'::jsonb, 'Amount and deadline', 'A target amount and deadline let you calculate and review progress.', 'Nominal dan tenggat memungkinkanmu menghitung dan meninjau kemajuan.'),
('building-financial-plan', 'What comes before choosing an investment for a goal?', 'Apa yang dilakukan sebelum memilih investasi untuk tujuan?', '["Protect basics and control high-interest debt","Copy a friend''s purchase","Ignore the time horizon"]'::jsonb, '["Lindungi kebutuhan dasar dan kendalikan utang berbunga tinggi","Meniru pembelian teman","Mengabaikan horizon waktu"]'::jsonb, 'Protect basics and control high-interest debt', 'The plan protects essentials and controls expensive debt before adding investment risk.', 'Rencana melindungi kebutuhan pokok dan mengendalikan utang mahal sebelum menambah risiko investasi.'),
('retirement-planning-bpjs-dplk-and-starting-early', 'What should you compare across retirement tools?', 'Apa yang perlu dibandingkan antaralat pensiun?', '["Role, access, fees, risks, and current terms","Only the headline return","A social-media testimonial"]'::jsonb, '["Peran, akses, biaya, risiko, dan ketentuan terbaru","Hanya imbal hasil utama","Testimoni media sosial"]'::jsonb, 'Role, access, fees, risks, and current terms', 'Different tools have different rules and risks; current terms need checking.', 'Alat yang berbeda memiliki aturan dan risiko yang berbeda; ketentuan terbaru perlu diperiksa.'),
('retirement-planning-start-early-compounding', 'Why show the assumptions in a retirement projection?', 'Mengapa asumsi perlu ditampilkan dalam proyeksi pensiun?', '["So the learner can see what is illustrative and uncertain","To guarantee the outcome","To hide the contribution amount"]'::jsonb, '["Agar pelajar melihat mana yang ilustratif dan tidak pasti","Untuk menjamin hasil","Untuk menyembunyikan jumlah kontribusi"]'::jsonb, 'So the learner can see what is illustrative and uncertain', 'Visible inputs prevent a projection from being mistaken for a promise.', 'Input yang terlihat mencegah proyeksi dianggap sebagai janji.')
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

WITH blocks(slug, block_type, data_status, content) AS (VALUES
('emergency-fund-101', 'process', 'illustrative', $json${"en":{"icon":"🛟","eyebrow":"Safety buffer","title":"Build access before chasing return","altText":"A three-step flow shows urgent needs, a separate accessible buffer, and long-term investing after protection.","disclosure":"Illustrative learning framework; the right buffer depends on your income, dependants, and circumstances.","payload":{"steps":[{"title":"1. Name the shock","description":"Illness, job loss, or a broken work tool can arrive without notice."},{"title":"2. Keep a buffer","description":"Separate, stable, accessible money can absorb the first hit."},{"title":"3. Invest after protection","description":"Long-term risk has more room once urgent needs have a buffer."}]}},"id":{"icon":"🛟","eyebrow":"Penyangga aman","title":"Bangun akses sebelum mengejar imbal hasil","altText":"Alur tiga langkah menunjukkan kebutuhan mendesak, penyangga terpisah yang mudah diakses, lalu investasi jangka panjang setelah perlindungan.","disclosure":"Kerangka pembelajaran ilustratif; penyangga yang tepat bergantung pada pendapatan, tanggungan, dan kondisi Anda.","payload":{"steps":[{"title":"1. Kenali guncangan","description":"Sakit, kehilangan pekerjaan, atau alat kerja rusak dapat terjadi tanpa pemberitahuan."},{"title":"2. Simpan penyangga","description":"Uang terpisah yang stabil dan mudah diakses dapat menahan dampak awal."},{"title":"3. Investasi setelah terlindungi","description":"Risiko jangka panjang punya ruang lebih besar setelah kebutuhan mendesak memiliki penyangga."}]}}}$json$::jsonb),
('goal-setting-101', 'worked_example', 'calculated', $json${"en":{"icon":"🎯","eyebrow":"Make it measurable","title":"Turn a wish into a monthly number","altText":"A worked example shows a Rp12,000,000 goal, Rp3,000,000 already saved, Rp9,000,000 remaining, and Rp750,000 needed each month for 12 months.","disclosure":"Calculated illustration only: it ignores interest, fees, and changes in the goal.","payload":{"inputs":[{"label":"Target","value":"Rp12,000,000"},{"label":"Already saved","value":"Rp3,000,000"},{"label":"Deadline","value":"12 months"}],"steps":["Rp12,000,000 − Rp3,000,000 = Rp9,000,000 remaining.","Rp9,000,000 ÷ 12 = Rp750,000 per month."],"outcome":"A clear amount and deadline turn a wish into a checkable plan."}},"id":{"icon":"🎯","eyebrow":"Buat terukur","title":"Ubah keinginan menjadi angka bulanan","altText":"Contoh perhitungan menunjukkan target Rp12.000.000, tabungan Rp3.000.000, sisa Rp9.000.000, dan kebutuhan Rp750.000 per bulan selama 12 bulan.","disclosure":"Ilustrasi perhitungan saja: tidak memperhitungkan bunga, biaya, atau perubahan tujuan.","payload":{"inputs":[{"label":"Target","value":"Rp12.000.000"},{"label":"Sudah ditabung","value":"Rp3.000.000"},{"label":"Tenggat","value":"12 bulan"}],"steps":["Rp12.000.000 − Rp3.000.000 = Rp9.000.000 tersisa.","Rp9.000.000 ÷ 12 = Rp750.000 per bulan."],"outcome":"Nominal dan tenggat yang jelas mengubah keinginan menjadi rencana yang bisa diperiksa."}}}$json$::jsonb),
('building-financial-plan', 'process', 'illustrative', $json${"en":{"icon":"🧭","eyebrow":"Plan in order","title":"Protect the foundation before adding risk","altText":"A four-step flow moves from goals to emergency protection, high-interest debt control, and investment matched to the goal.","disclosure":"Illustrative planning framework; priorities depend on your essentials, debt, protection, and time horizon.","payload":{"steps":[{"title":"1. Set the goal","description":"Name what the money is for and when you need it."},{"title":"2. Protect the basics","description":"Keep essentials and an emergency buffer visible."},{"title":"3. Control expensive debt","description":"High-interest debt can grow faster than an uncertain investment return."},{"title":"4. Match the investment","description":"Choose an instrument only after checking horizon, risk, access, and terms."}]}},"id":{"icon":"🧭","eyebrow":"Susun rencana","title":"Lindungi fondasi sebelum menambah risiko","altText":"Alur empat langkah bergerak dari tujuan ke perlindungan dana darurat, pengendalian utang berbunga tinggi, lalu investasi yang sesuai tujuan.","disclosure":"Kerangka perencanaan ilustratif; prioritas bergantung pada kebutuhan pokok, utang, perlindungan, dan horizon waktu Anda.","payload":{"steps":[{"title":"1. Tetapkan tujuan","description":"Sebutkan untuk apa uang digunakan dan kapan dibutuhkan."},{"title":"2. Lindungi kebutuhan dasar","description":"Buat kebutuhan pokok dan penyangga dana darurat terlihat."},{"title":"3. Kendalikan utang mahal","description":"Utang berbunga tinggi dapat tumbuh lebih cepat daripada imbal hasil investasi yang tidak pasti."},{"title":"4. Sesuaikan investasi","description":"Pilih instrumen setelah memeriksa horizon, risiko, akses, dan ketentuan."}]}}}$json$::jsonb),
('retirement-planning-bpjs-dplk-and-starting-early', 'comparison', 'source_derived', $json${"en":{"icon":"🧰","eyebrow":"Retirement tools","title":"Different tools can have different roles","altText":"A three-column comparison names BPJS JHT as employment-linked, DPLK as voluntary institutional saving, and personal investments as flexible assets with their own risks and terms.","disclosure":"Check current official terms before acting; this comparison is educational and does not endorse a product.","payload":{"leftTitle":"BPJS JHT","rightTitle":"DPLK","rows":[{"left":"Employment-linked benefit","right":"Voluntary institutional saving"},{"left":"Has its own access rules","right":"Has its own fees and terms"},{"left":"Can complement other savings","right":"Does not remove investment risk"}]}},"id":{"icon":"🧰","eyebrow":"Alat pensiun","title":"Alat yang berbeda dapat memiliki peran berbeda","altText":"Perbandingan tiga kolom menyebut BPJS JHT sebagai manfaat terkait pekerjaan, DPLK sebagai tabungan sukarela melalui lembaga, dan investasi pribadi sebagai aset fleksibel dengan risiko serta ketentuannya sendiri.","disclosure":"Periksa ketentuan resmi terbaru sebelum bertindak; perbandingan ini bersifat edukatif dan tidak mendukung produk tertentu.","payload":{"leftTitle":"BPJS JHT","rightTitle":"DPLK","rows":[{"left":"Manfaat terkait pekerjaan","right":"Tabungan sukarela melalui lembaga"},{"left":"Memiliki aturan akses sendiri","right":"Memiliki biaya dan ketentuan sendiri"},{"left":"Dapat melengkapi tabungan lain","right":"Tidak menghapus risiko investasi"}]}}}$json$::jsonb),
('retirement-planning-start-early-compounding', 'comparison', 'calculated', $json${"en":{"icon":"⏳","eyebrow":"Time and assumptions","title":"Earlier contributions get more time, not a guarantee","altText":"A comparison shows the same monthly contribution starting earlier has more years to compound, while both rows are labelled as assumptions rather than promises.","disclosure":"Calculated illustration: monthly contribution Rp500,000, assumed annual return 8%, contributions at month end, no fees or tax, and no guarantee of future returns.","payload":{"leftTitle":"Start at 25","rightTitle":"Start at 35","rows":[{"left":"35 years of contributions","right":"25 years of contributions"},{"left":"More time for compounding","right":"Less time for compounding"},{"left":"Still depends on uncertain returns","right":"Still depends on uncertain returns"}]}},"id":{"icon":"⏳","eyebrow":"Waktu dan asumsi","title":"Kontribusi lebih awal mendapat lebih banyak waktu, bukan jaminan","altText":"Perbandingan menunjukkan kontribusi bulanan yang sama dan dimulai lebih awal memiliki lebih banyak tahun untuk bertumbuh majemuk; kedua baris diberi label sebagai asumsi, bukan janji.","disclosure":"Ilustrasi perhitungan: kontribusi Rp500.000 per bulan, asumsi imbal hasil tahunan 8%, kontribusi di akhir bulan, tanpa biaya atau pajak, dan tanpa jaminan hasil masa depan.","payload":{"leftTitle":"Mulai usia 25","rightTitle":"Mulai usia 35","rows":[{"left":"35 tahun kontribusi","right":"25 tahun kontribusi"},{"left":"Lebih banyak waktu untuk pertumbuhan majemuk","right":"Lebih sedikit waktu untuk pertumbuhan majemuk"},{"left":"Tetap bergantung pada hasil yang tidak pasti","right":"Tetap bergantung pada hasil yang tidak pasti"}]}}}$json$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, data_status, content, display_order, is_published)
SELECT lesson.id, 'concept', blocks.block_type, blocks.data_status, blocks.content, 10, TRUE
FROM blocks
JOIN public.lessons AS lesson ON lesson.slug = blocks.slug
WHERE lesson.is_published
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = TRUE,
  updated_at = NOW();

WITH visual_sources(slug, source_code) AS (VALUES
('emergency-fund-101', 'OJK-003'),
('goal-setting-101', 'OJK-002'),
('building-financial-plan', 'OJK-001'),
('retirement-planning-bpjs-dplk-and-starting-early', 'OJK-001'),
('retirement-planning-start-early-compounding', 'OJK-001')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM visual_sources
JOIN public.lessons AS lesson ON lesson.slug = visual_sources.slug
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = visual_sources.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

COMMIT;
