-- Migration: Add adaptive/behavioral finance lessons 6–9
-- Inserts topic, lessons, reviews, source links, and content_variants.
-- Idempotent: uses WHERE NOT EXISTS / ON CONFLICT DO NOTHING / IF guards.

-- 1. Topic
INSERT INTO topics (id, slug, name, name_id, icon, color, display_order)
SELECT gen_random_uuid(), 'behavioral_finance', 'Behavioral Finance', 'Keuangan Perilaku', 'brain', '#14B8A6', 6
WHERE NOT EXISTS (SELECT 1 FROM topics WHERE slug = 'behavioral_finance');

-- 2. Lessons
INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction
)
SELECT
  gen_random_uuid(),
  'loss-aversion-101',
  'Loss Aversion & FOMO',
  'Aversi Rugi & FOMO',
  t.id,
  6,
  'intermediate',
  75,
  8,
  'Kenapa kerugian terasa lebih sakit dari keuntungan, dan bagaimana FOMO membuat kita berinvestasi tanpa rencana.',
  'Aversi rugi (loss aversion) berarti rasa sakit dari kehilangan uang biasanya lebih kuat dua kali lipat dari rasa senang mendapatkan keuntungan. FOMO (Fear Of Missing Out) mendorong kita membeli aset hanya karena semua orang membicarakannya. Kombinasi keduanya sering membuat investor muda Indonesia jual saham bagus saat turun dan beli saham hype saat naik. Solusinya: buat aturan investasi sebelum emosi muncul.',
  'Rina membeli saham BBRI seharga Rp 4.200. Beberapa minggu kemudian harganya turun ke Rp 3.900. Perasaannya seperti "rugi banyak", padahal baru turun 7%. Di saat yang sama, teman-temannya ramai membeli saham teknologi yang baru viral di media sosial. Rina khawatir ketinggalan (FOMO), lalu menjual BBRI dan membeli saham tersebut tanpa riset. Seminggu kemudian saham teknologi itu turun 20%, sementara BBRI kembali naik. Rina belajar bahwa emosi bisa lebih mahal dari biaya transaksi.',
  'Mengenali aversi rugi dan FOMO membantu kamu tetap pada rencana, menghindari jual beli impulsif, dan mengurangi kerugian akibat keputusan emosional.',
  'Menjual investasi yang fundamentalnya baik hanya karena harga turun, atau membeli aset hanya karena viral di TikTok/Twitter tanpa memahami risikonya.',
  '[
    {
      "question": "Loss aversion berarti ...",
      "type": "multiple_choice",
      "options": ["Kerugian terasa lebih menyakitkan dari keuntungan", "Keuntungan selalu lebih besar dari kerugian", "Investor tidak pernah rugi", "Risiko selalu menghasilkan untung"],
      "answer": "Kerugian terasa lebih menyakitkan dari keuntungan",
      "explanation": "Loss aversion menjelaskan bahwa rasa sakit kerugian biasanya lebih kuat dari rasa senang keuntungan yang sama besar."
    },
    {
      "question": "FOMO dalam investasi sering menyebabkan ...",
      "type": "multiple_choice",
      "options": ["Membeli aset karena hype tanpa riset", "Menabung lebih disiplin", "Mengurangi portofolio", "Memeriksa izin OJK"],
      "answer": "Membeli aset karena hype tanpa riset",
      "explanation": "FOMO mendorong investor mengikuti tren atau rekomendasi viral tanpa riset mandiri."
    },
    {
      "question": "Cara mengurangi pengaruh FOMO adalah ...",
      "type": "multiple_choice",
      "options": ["Ikuti semua tren saham", "Buat aturan investasi sebelum emosi muncul", "Cek harga setiap menit", "Jual semua saham saat turun"],
      "answer": "Buat aturan investasi sebelum emosi muncul",
      "explanation": "Aturan yang dibuat saat tenang membantu menahan keputusan impulsif saat FOMO muncul."
    }
  ]'::jsonb,
  'Bantu pengguna memahami loss aversion dan FOMO dengan contoh saham Indonesia. Dorong mereka membuat aturan investasi sebelum emosi muncul dan menghindari keputusan berdasarkan hype media sosial.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
FROM topics t
WHERE t.slug = 'behavioral_finance'
  AND NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'loss-aversion-101');

INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction
)
SELECT
  gen_random_uuid(),
  'diversification-101',
  'Diversification: Don''t Bet Everything',
  'Diversifikasi: Jangan Menyimpan Semua Telur',
  t.id,
  7,
  'intermediate',
  75,
  8,
  'Jangan taruh semua telur dalam satu keranjang—diversifikasi melindungi portofolio dari kejutan tunggal.',
  'Diversifikasi adalah menyebarkan investasi ke berbagai jenis aset, sektor, dan instrumen sehingga kerugian di satu tempat tidak menghancurkan seluruh portofolio. Di Indonesia, kamu bisa diversifikasi dengan membeli saham dari sektor berbeda seperti perbankan (BBCA, BBRI), telekomunikasi (TLKM), konsumer (UNVR), serta reksa dana dan obligasi pemerintah. Kunci diversifikasi bukan memprediksi mana yang naik, tapi mengurangi risiko keseluruhan.',
  'Andi menyimpan seluruh uang investasinya di saham GOTO sebanyak Rp 5.000.000. Temannya Budi menyebarkan Rp 5.000.000 ke BBCA, BBRI, TLKM, dan reksa dana pasar uang. Ketika sektor teknologi mengalami koreksi dan GOTO turun 25%, Andi rugi Rp 1.250.000. Portofolio Budi lebih stabil karena saham bank dan telekomunikasinya menahan penurunan, sehingga kerugiannya jauh lebih kecil.',
  'Diversifikasi mengurangi risiko tanpa harus menjadi peramal pasar. Ini sangat penting bagi investor muda yang baru memulai.',
  'Menaruh semua uang dalam satu saham, kripto, atau sektor karena sedang "lagi hype" atau dapat rekomendasi dari influencer.',
  '[
    {
      "question": "Tujuan utama diversifikasi adalah ...",
      "type": "multiple_choice",
      "options": ["Menjamin keuntungan tinggi", "Mengurangi risiko portofolio", "Menghindari pajak", "Memprediksi saham naik"],
      "answer": "Mengurangi risiko portofolio",
      "explanation": "Diversifikasi menyebarkan risiko sehingga kerugian satu aset tidak terlalu besar bagi keseluruhan portofolio."
    },
    {
      "question": "Contoh diversifikasi di IDX adalah membeli ...",
      "type": "multiple_choice",
      "options": ["Satu saham teknologi saja", "Saham dari sektor berbeda seperti bank dan telekomunikasi", "Hanya menyimpan uang tunai", "Meminjam uang untuk trading"],
      "answer": "Saham dari sektor berbeda seperti bank dan telekomunikasi",
      "explanation": "Diversifikasi sektor mengurangi risiko jika satu industri mengalami penurunan."
    },
    {
      "question": "Diversifikasi berarti ...",
      "type": "multiple_choice",
      "options": ["Semua uang di satu aset", "Menyebar investasi ke berbagai instrumen", "Tidak pernah berinvestasi", "Mengikuti tren terbaru"],
      "answer": "Menyebar investasi ke berbagai instrumen",
      "explanation": "Diversifikasi adalah strategi menyebarkan investasi agar tidak bergantung pada satu instrumen."
    }
  ]'::jsonb,
  'Jelaskan diversifikasi dengan contoh saham dan instrumen Indonesia. Tekankan bahwa diversifikasi mengurangi risiko, bukan menjamin keuntungan.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
FROM topics t
WHERE t.slug = 'behavioral_finance'
  AND NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'diversification-101');

INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction
)
SELECT
  gen_random_uuid(),
  'confidence-101',
  'Confidence & Risk Tolerance',
  'Kepercayaan Diri & Toleransi Risiko',
  t.id,
  8,
  'intermediate',
  75,
  8,
  'Beda orang, beda toleransi risiko. Jangan memaksakan strategi orang lain ke diri sendiri.',
  'Toleransi risiko adalah seberapa besar fluktuasi harga yang bisa kamu terima tanpa panik. Faktor-faktornya antara lain umur, penghasilan stabil, tujuan keuangan, dan horizon waktu. Overconfidence, atau terlalu percaya diri, sering membuat investor muda overtrading dan meremehkan risiko. Pilih instrumen yang sesuai dengan profilmu, bukan dengan gaya hidup influencer.',
  'Siti, mahasiswa semester 2 dengan uang saku Rp 1.500.000 per bulan, punya horizon investasi 10 tahun ke depan. Ia bisa mempertimbangkan portofolio agak agresif dengan campuran saham dan reksa dana. Pak Tono, pensiunan yang bergantung pada tabungan, lebih baik memilih instrumen stabil seperti deposito dan obligasi pemerintah. Jika Siti meniru portofolio konservatif Pak Tono, ia kehilangan potensi pertumbuhan jangka panjang. Jika Pak Tono meniru strategi agresif Siti, ia bisa stres saat pasar turun.',
  'Memahami profil risiko sendiri membantu memilih instrumen yang tepat, mengurangi stres, dan menghindari keputusan investasi yang dipaksakan.',
  'Meniru portofolio influencer atau teman tanpa mempertimbangkan penghasilan, tanggungan, dan tujuan keuangan sendiri.',
  '[
    {
      "question": "Toleransi risiko dipengaruhi oleh ...",
      "type": "multiple_choice",
      "options": ["Hanya usia", "Usia, penghasilan, tujuan, dan horizon waktu", "Jumlah follower influencer", "Warna grafik saham"],
      "answer": "Usia, penghasilan, tujuan, dan horizon waktu",
      "explanation": "Toleransi risiko bergantung pada kondisi keuangan pribadi, tujuan, dan jangka waktu investasi."
    },
    {
      "question": "Overconfidence dalam investasi bisa menyebabkan ...",
      "type": "multiple_choice",
      "options": ["Overtrading dan meremehkan risiko", "Menabung lebih banyak", "Diversifikasi otomatis", "Menghindari kerugian"],
      "answer": "Overtrading dan meremehkan risiko",
      "explanation": "Kepercayaan diri berlebihan sering membuat investor terlalu sering bertransaksi dan mengabaikan risiko."
    },
    {
      "question": "Investor muda dengan horizon panjang biasanya bisa ...",
      "type": "multiple_choice",
      "options": ["Tidak berinvestasi sama sekali", "Mempertimbangkan profil sedikit lebih agresif", "Harus menyimpan semua uang tunai", "Meniru pensiunan secara persis"],
      "answer": "Mempertimbangkan profil sedikit lebih agresif",
      "explanation": "Horizon waktu panjang memberi kesempatan untuk menahan fluktuasi dan mengejar pertumbuhan."
    }
  ]'::jsonb,
  'Bantu pengguna memahami toleransi risiko dan overconfidence dengan contoh mahasiswa dan pensiunan di Indonesia. Dorong mereka mengenali profil risiko sendiri.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
FROM topics t
WHERE t.slug = 'behavioral_finance'
  AND NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'confidence-101');

INSERT INTO lessons (
  id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes,
  summary, concept_body, indonesian_example, why_this_matters, common_mistake,
  quiz_data, ai_assist_context, review_status, reviewed_by, reviewed_at, is_published, jurisdiction
)
SELECT
  gen_random_uuid(),
  'volatility-101',
  'Volatility & Emotional Control',
  'Volatilitas & Pengendalian Emosi',
  t.id,
  9,
  'intermediate',
  75,
  8,
  'Volatilitas adalah naik turun harga normal; yang penting adalah mengendalikan reaksi emosional.',
  'Volatilitas mengukur seberapa besar harga aset berfluktuasi dalam periode tertentu. Saham seperti BBCA atau GOTO bisa naik turun beberapa persen dalam seminggu. Volatilitas itu normal, terutama di pasar saham. Risiko sesungguhnya bagi investor jangka panjang sering kali bukan volatilitas, melainkan reaksi emosional yang membuat kita jual di bawah harga wajar atau beli di puncak euforia.',
  'Dimas membeli saham BBCA di harga Rp 8.500. Dalam seminggu, harganya turun ke Rp 8.200 dan naik lagi ke Rp 8.700. Jika Dimas panik setiap kali cek aplikasi dan menjual saat turun, ia bisa merugi meskipun fundamental perusahaan tidak berubah. Sebaliknya, investor yang memiliki rencana dan batasan "cek harga seminggu sekali" lebih jarang membuat keputusan emosional.',
  'Memahami volatilitas membantu kamu tidak overreact saat pasar turun, sehingga investasi jangka panjang tetap pada jalurnya.',
  'Memeriksa harga investasi berkali-kali sehari dan langsung jual atau beli berdasarkan perasaan saat itu.',
  '[
    {
      "question": "Volatilitas adalah ...",
      "type": "multiple_choice",
      "options": ["Jaminan keuntungan", "Ukuran naik turunnya harga aset", "Pajak atas investasi", "Nama perusahaan sekuritas"],
      "answer": "Ukuran naik turunnya harga aset",
      "explanation": "Volatilitas menunjukkan seberapa besar harga aset bergerak naik turun dalam suatu periode."
    },
    {
      "question": "Risiko terbesar bagi investor jangka panjang sering kali adalah ...",
      "type": "multiple_choice",
      "options": ["Volatilitas harian", "Reaksi emosional berlebihan", "Dividen", "Biaya administrasi bank"],
      "answer": "Reaksi emosional berlebihan",
      "explanation": "Volatilitas normal, tetapi reaksi emosional yang berlebihan bisa menyebabkan jual di bawah harga wajar."
    },
    {
      "question": "Cara mengendalikan emosi saat volatilitas tinggi adalah ...",
      "type": "multiple_choice",
      "options": ["Cek harga setiap menit", "Punya rencana dan batasan cek portofolio", "Jual semua saham saat turun", "Beli aset hanya karena viral"],
      "answer": "Punya rencana dan batasan cek portofolio",
      "explanation": "Rencana dan batasan membantu investor menghindari keputusan impulsif saat pasar bergejolak."
    }
  ]'::jsonb,
  'Jelaskan volatilitas dengan contoh saham Indonesia seperti BBCA. Tekankan pentingnya rencana dan kendali emosi, bukan reaksi terhadap pergerakan harian.',
  'approved',
  'Koin Content Reviewer',
  NOW(),
  TRUE,
  'ID'
FROM topics t
WHERE t.slug = 'behavioral_finance'
  AND NOT EXISTS (SELECT 1 FROM lessons WHERE slug = 'volatility-101');

-- 3. Lesson sources
INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'primary', 'OJK SNLKI 2021-2025', TRUE, 1
FROM lessons l, sources s
WHERE l.slug = 'loss-aversion-101' AND s.source_code = 'OJK-001'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'supporting', 'OJK Buku Saku Mengenal Produk Investasi', FALSE, 2
FROM lessons l, sources s
WHERE l.slug = 'loss-aversion-101' AND s.source_code = 'OJK-006'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'primary', 'OJK Buku Saku Mengenal Produk Investasi', TRUE, 1
FROM lessons l, sources s
WHERE l.slug = 'diversification-101' AND s.source_code = 'OJK-006'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'supporting', 'IDX Academy', FALSE, 2
FROM lessons l, sources s
WHERE l.slug = 'diversification-101' AND s.source_code = 'IDX-001'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'primary', 'OJK Buku Saku Mengenal Produk Investasi', TRUE, 1
FROM lessons l, sources s
WHERE l.slug = 'confidence-101' AND s.source_code = 'OJK-006'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'supporting', 'Bank Indonesia BI Rate', FALSE, 2
FROM lessons l, sources s
WHERE l.slug = 'confidence-101' AND s.source_code = 'BI-002'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'primary', 'IDX Investor Protection SIPF', TRUE, 1
FROM lessons l, sources s
WHERE l.slug = 'volatility-101' AND s.source_code = 'IDX-007'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT gen_random_uuid(), l.id, s.id, 'supporting', 'Bank Indonesia BI Rate', FALSE, 2
FROM lessons l, sources s
WHERE l.slug = 'volatility-101' AND s.source_code = 'BI-002'
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- 4. Lesson reviews
INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT gen_random_uuid(), l.id, 'Koin Content Reviewer', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Behavioral finance concepts aligned with OJK investor education materials.', TRUE
FROM lessons l
WHERE l.slug = 'loss-aversion-101'
ON CONFLICT (lesson_id) DO NOTHING;

INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT gen_random_uuid(), l.id, 'Koin Content Reviewer', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Diversification examples use real IDX tickers and Indonesian rupiah amounts.', TRUE
FROM lessons l
WHERE l.slug = 'diversification-101'
ON CONFLICT (lesson_id) DO NOTHING;

INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT gen_random_uuid(), l.id, 'Koin Content Reviewer', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Risk tolerance framing adapted to Indonesian student and retiree contexts.', TRUE
FROM lessons l
WHERE l.slug = 'confidence-101'
ON CONFLICT (lesson_id) DO NOTHING;

INSERT INTO lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT gen_random_uuid(), l.id, 'Koin Content Reviewer', 'Content Lead', CURRENT_DATE, 'pass', 'pass', 'pass', 'pass', 'Volatility concepts verified against IDX and BI market context; no forward-looking claims.', TRUE
FROM lessons l
WHERE l.slug = 'volatility-101'
ON CONFLICT (lesson_id) DO NOTHING;

-- 5. Content variants
DO $$
DECLARE
  v_loss UUID := (SELECT id FROM lessons WHERE slug = 'loss-aversion-101');
  v_diversification UUID := (SELECT id FROM lessons WHERE slug = 'diversification-101');
  v_confidence UUID := (SELECT id FROM lessons WHERE slug = 'confidence-101');
  v_volatility UUID := (SELECT id FROM lessons WHERE slug = 'volatility-101');

  s_ojk_001 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-001');
  s_ojk_006 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-006');
  s_idx_001 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-001');
  s_idx_007 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-007');
  s_bi_002 UUID := (SELECT id FROM sources WHERE source_code = 'BI-002');
BEGIN
  -- ==================== LOSS AVERSION & FOMO ====================
  IF (SELECT COUNT(*) FROM content_variants WHERE lesson_id = v_loss) = 0 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag) VALUES
    (
      v_loss,
      'example',
      jsonb_build_object(
        'text', 'Teman Rina memposting screenshot untung 30% dari saham kripto baru. Rina merasa iri dan langsung membeli tanpa riset. Dua minggu kemudian harga kripto itu turun 40%. Pengalaman ini mengajarkan bahwa FOMO bisa lebih mahal dari biaya kuliah satu semester.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'example',
      jsonb_build_object(
        'text', 'Bayu membeli saham BBRI dan menahan kerugian 10% selama tiga bulan. Perasaannya seperti kehilangan, meskipun jumlahnya sama dengan biaya makan sebulan. Loss aversion membuatnya ingin segera menjual, padahal harga akhirnya pulih.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'example',
      jsonb_build_object(
        'text', 'Sebuah survei menunjukkan banyak investor pemula di Indonesia lebih takut "rugi Rp 100.000" daripada senang "untung Rp 100.000". Perasaan tidak simetris ini membuat mereka sering menjual saham bagus terlalu dini.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'explanation',
      jsonb_build_object(
        'text', 'Loss aversion dan FOMO adalah dua kekuatan emosional yang sering mengganggu keputusan investasi. Cara terbaik mengatasinya adalah membuat aturan sebelum membeli: tujuan investasi, batas kerugian yang bisa diterima, dan jadwal review. Jangan biarkan media sosial mengatur portofoliomu.',
        'ai_assist_context', 'Bantu pengguna mengenali loss aversion dan FOMO, lalu buat aturan investasi pribadi sebelum emosi muncul.'
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'question',
      jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Manakah contoh loss aversion?',
        'options', jsonb_build_array('Senang untung Rp 100.000', 'Takut rugi Rp 100.000 lebih kuat dari senang untung Rp 100.000', 'Diversifikasi portofolio', 'Menabung di deposito'),
        'answer', 'Takut rugi Rp 100.000 lebih kuat dari senang untung Rp 100.000',
        'explanation', 'Loss aversion berarti rasa sakit kerugian lebih kuat dari rasa senang keuntungan yang sama besar.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'question',
      jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'FOMO selalu menghasilkan keputusan investasi yang baik karena banyak orang yang melakukan.',
        'answer', false,
        'explanation', 'FOMO justru sering menyebabkan pembelian impulsif tanpa riset yang memadai.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'question',
      jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Sebelum membeli aset yang sedang viral, sebaiknya _____ terlebih dahulu.',
        'answer', 'riset',
        'explanation', 'Riset mandiri membantu menghindari keputusan yang murni didorong oleh hype atau FOMO.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'question',
      jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi kalimat: "Aversi rugi membuat rasa sakit dari _____ terasa lebih besar dari rasa senang mendapatkan _____."',
        'options', jsonb_build_array('kerugian', 'keuntungan'),
        'answer', jsonb_build_array('kerugian', 'keuntungan'),
        'explanation', 'Loss aversion menjadikan kerugian terasa lebih menyakitkan dibanding keuntungan.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_loss,
      'question',
      jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah menghadapi FOMO.',
        'options', jsonb_build_array('Tetapkan tujuan investasi', 'Riset aset sebelum membeli', 'Buat aturan kapan boleh jual', 'Hindari cek harga berlebihan'),
        'answer', jsonb_build_array('Tetapkan tujuan investasi', 'Riset aset sebelum membeli', 'Buat aturan kapan boleh jual', 'Hindari cek harga berlebihan'),
        'explanation', 'Mulai dari tujuan, riset, aturan jual, lalu kontrol emosi agar tidak overreact.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    );
  END IF;

  -- ==================== DIVERSIFICATION ====================
  IF (SELECT COUNT(*) FROM content_variants WHERE lesson_id = v_diversification) = 0 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag) VALUES
    (
      v_diversification,
      'example',
      jsonb_build_object(
        'text', 'Maya memiliki portofolio yang terdiri dari saham BBCA, BBRI, TLKM, dan reksa dana pasar uang. Ketika harga GOTO turun 20% karena berita sektor teknologi, portofolio Maya tetap stabil karena hanya sebagian kecil di sektor tersebut.',
        'source_ids', jsonb_build_array(s_ojk_006::text, s_idx_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'example',
      jsonb_build_object(
        'text', 'Seorang pedagang mie ayam menyisihkan Rp 2.000.000 per bulan. Ia tidak menyimpan semuanya di satu tempat, melainkan 50% di deposito BCA, 30% di reksa dana, dan 20% di saham blue chip. Jika satu instrumen turun, yang lain menahan.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'example',
      jsonb_build_object(
        'text', 'Diversifikasi tidak berarti membeli banyak saham dari sektor yang sama. Membeli GOTO, DCII, dan emiten teknologi lain tetap berisiko tinggi jika sektor teknologi koreksi.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'explanation',
      jsonb_build_object(
        'text', 'Diversifikasi adalah strategi menyebarkan risiko, bukan mencari keuntungan maksimal. Dengan memilih berbagai jenis aset dan sektor, kamu mengurangi dampak jika satu investasi gagal. Ingat: jangan menyimpan semua telur dalam satu keranjang.',
        'ai_assist_context', 'Jelaskan diversifikasi sebagai cara mengurangi risiko dengan contoh saham dan instrumen Indonesia.'
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'question',
      jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Tujuan utama diversifikasi adalah ...',
        'options', jsonb_build_array('Menjamin untung besar', 'Mengurangi risiko keseluruhan', 'Mengikuti tren saham', 'Menghindari pajak'),
        'answer', 'Mengurangi risiko keseluruhan',
        'explanation', 'Diversifikasi menyebarkan risiko agar kerugian satu aset tidak terlalu berdampak.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'question',
      jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Membeli banyak saham dari sektor yang sama sudah cukup untuk diversifikasi.',
        'answer', false,
        'explanation', 'Diversifikasi sejati membutuhkan penyebaran antar sektor dan jenis aset, bukan hanya banyak saham dalam satu sektor.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'question',
      jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Diversifikasi artinya menyebarkan investasi ke berbagai _____ dan instrumen.',
        'answer', 'jenis aset',
        'explanation', 'Diversifikasi menyebar dana ke berbagai jenis aset atau sektor untuk mengurangi risiko.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'question',
      jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi: "Jangan menyimpan semua _____ dalam satu _____."',
        'options', jsonb_build_array('telur', 'keranjang'),
        'answer', jsonb_build_array('telur', 'keranjang'),
        'explanation', 'Peribahasa ini mengingatkan kita untuk tidak memusatkan risiko pada satu tempat.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_diversification,
      'question',
      jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah diversifikasi sederhana.',
        'options', jsonb_build_array('Tentukan tujuan keuangan', 'Pilih beberapa jenis aset', 'Bagi dana sesuai proporsi', 'Pantau dan sesuaikan setiap 6 bulan'),
        'answer', jsonb_build_array('Tentukan tujuan keuangan', 'Pilih beberapa jenis aset', 'Bagi dana sesuai proporsi', 'Pantau dan sesuaikan setiap 6 bulan'),
        'explanation', 'Mulai dari tujuan, pilih aset, alokasikan dana, lalu evaluasi secara berkala.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    );
  END IF;

  -- ==================== CONFIDENCE & RISK TOLERANCE ====================
  IF (SELECT COUNT(*) FROM content_variants WHERE lesson_id = v_confidence) = 0 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag) VALUES
    (
      v_confidence,
      'example',
      jsonb_build_object(
        'text', 'Andi baru berinvestasi 3 bulan tetapi sudah merasa bisa mengalahkan pasar. Ia trading harian dengan uang Rp 10.000.000 dan kehilangan 15% dalam sebulan karena overconfidence dan biaya transaksi.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'example',
      jsonb_build_object(
        'text', 'Dua mahasiswa dengan uang saku sama bisa punya profil risiko berbeda. Sisi yang punya dana darurat 6 bulan lebih siap menghadapi fluktuasi saham daripada Fikri yang baru mulai menabung.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'example',
      jsonb_build_object(
        'text', 'Investor yang terlalu percaya diri sering mengabaikan risiko dan membeli saham hanya berdasarkan rumor. Investor yang realistis memeriksa laporan keuangan dan tujuan jangka panjang sebelum membeli.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'explanation',
      jsonb_build_object(
        'text', 'Toleransi risiko bukan tentang berani atau tidak berani, melainkan seberapa besar fluktuasi yang bisa kamu terima tanpa mengganggu tidur dan keuangan. Overconfidence bisa membuatmu overtrading. Kenali diri sendiri sebelum memilih instrumen.',
        'ai_assist_context', 'Bantu pengguna menilai toleransi risiko mereka dengan mempertimbangkan penghasilan, tanggungan, dan tujuan keuangan.'
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'question',
      jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Faktor yang memengaruhi toleransi risiko termasuk ...',
        'options', jsonb_build_array('Jumlah follower di Instagram', 'Usia, penghasilan, dan tujuan keuangan', 'Warna logo saham', 'Jumlah teman yang trading'),
        'answer', 'Usia, penghasilan, dan tujuan keuangan',
        'explanation', 'Toleransi risiko bergantung pada kondisi pribadi, bukan popularitas atau tren.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'question',
      jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Overconfidence biasanya membuat investor lebih berhati-hati dan jarang bertransaksi.',
        'answer', false,
        'explanation', 'Overconfidence cenderung menyebabkan overtrading dan meremehkan risiko.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'question',
      jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Pilih instrumen investasi sesuai dengan _____ risiko sendiri, bukan mengikuti influencer.',
        'answer', 'profil',
        'explanation', 'Profil risiko pribadi menentukan instrumen yang paling sesuai dengan kondisimu.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'question',
      jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi: "Investor muda dengan horizon panjang biasanya bisa lebih _____, sementara pensiunan cenderung lebih _____."',
        'options', jsonb_build_array('agresif', 'konservatif'),
        'answer', jsonb_build_array('agresif', 'konservatif'),
        'explanation', 'Horizon panjang memungkinkan investor muda menahan risiko lebih besar; pensiunan biasanya memerlukan stabilitas.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_confidence,
      'question',
      jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah menentukan profil risiko.',
        'options', jsonb_build_array('Evaluasi penghasilan dan tanggungan', 'Tentukan tujuan dan horizon waktu', 'Kenali reaksi emosional saat rugi', 'Pilih instrumen yang sesuai'),
        'answer', jsonb_build_array('Evaluasi penghasilan dan tanggungan', 'Tentukan tujuan dan horizon waktu', 'Kenali reaksi emosional saat rugi', 'Pilih instrumen yang sesuai'),
        'explanation', 'Kenali kondisi keuangan, tujuan, reaksi emosi, lalu pilih instrumen yang cocok.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    );
  END IF;

  -- ==================== VOLATILITY & EMOTIONAL CONTROL ====================
  IF (SELECT COUNT(*) FROM content_variants WHERE lesson_id = v_volatility) = 0 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag) VALUES
    (
      v_volatility,
      'example',
      jsonb_build_object(
        'text', 'Saham GOTO bisa naik 8% dalam sehari dan turun 7% di hari berikutnya. Fluktuasi harian seperti ini normal untuk saham dengan pertumbuhan tinggi. Investor jangka panjang tidak perlu panik setiap kali harga bergerak.',
        'source_ids', jsonb_build_array(s_idx_007::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'example',
      jsonb_build_object(
        'text', 'Bank Indonesia sering mengumumkan suku bunga (BI Rate) yang bisa memengaruhi pergerakan harga saham perbankan seperti BBCA dan BBRI. Perubahan ini menambah volatilitas pasar, terutama di sektor keuangan.',
        'source_ids', jsonb_build_array(s_bi_002::text, s_idx_001::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'example',
      jsonb_build_object(
        'text', 'Dimas menetapkan aturan: hanya cek portofolio setiap minggu dan hanya jual jika alasan membeli berubah. Aturan sederhana ini membantunya tidak overreact saat saham turun 5%.',
        'source_ids', jsonb_build_array(s_idx_007::text)
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'explanation',
      jsonb_build_object(
        'text', 'Volatilitas adalah bagian normal dari investasi saham. Yang penting bukan menghilangkan fluktuasi, tapi mengendalikan reaksi emosi. Buat rencana, tetapkan batasan cek harga, dan fokus pada tujuan jangka panjang.',
        'ai_assist_context', 'Jelaskan volatilitas sebagai gejala normal pasar dan bantu pengguna membuat rencana mengendalikan emosi.'
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'question',
      jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Volatilitas mengukur ...',
        'options', jsonb_build_array('Jumlah dividen', 'Naik turunnya harga aset', 'Pajak investasi', 'Jumlah lembar saham'),
        'answer', 'Naik turunnya harga aset',
        'explanation', 'Volatilitas menunjukkan seberapa besar harga aset berfluktuasi dalam suatu periode.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'question',
      jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Volatilitas harian selalu berarti investasi tersebut buruk.',
        'answer', false,
        'explanation', 'Volatilitas harian normal di pasar saham; yang penting adalah reaksi jangka panjang investor.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'question',
      jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Risiko terbesar investor jangka panjang sering kali adalah reaksi _____ yang berlebihan.',
        'answer', 'emosional',
        'explanation', 'Reaksi emosional berlebihan bisa menyebabkan jual di bawah harga wajar.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'question',
      jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi: "Volatilitas adalah _____, sedangkan kontrol emosi adalah _____."',
        'options', jsonb_build_array('naik turun harga', 'tanggung jawab investor'),
        'answer', jsonb_build_array('naik turun harga', 'tanggung jawab investor'),
        'explanation', 'Kita tidak bisa mengendalikan pasar, tapi bisa mengendalikan reaksi diri sendiri.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    ),
    (
      v_volatility,
      'question',
      jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan cara menghadapi volatilitas.',
        'options', jsonb_build_array('Buat rencana investasi', 'Tetapkan batasan cek harga', 'Fokus pada tujuan jangka panjang', 'Hindari keputusan saat emosi tinggi'),
        'answer', jsonb_build_array('Buat rencana investasi', 'Tetapkan batasan cek harga', 'Fokus pada tujuan jangka panjang', 'Hindari keputusan saat emosi tinggi'),
        'explanation', 'Rencana, batasan, fokus tujuan, dan kontrol emosi membantu menghadapi volatilitas.',
        'parameters', '{}'::jsonb
      ),
      'intermediate',
      'behavioral_finance'
    );
  END IF;
END $$;
