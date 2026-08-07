-- Migration: Expand adaptive/behavioral finance content variant pools
-- Adds example + question variants for the 4 behavioral lessons so each has
-- at least 10 example variants and 11 question variants.
-- Idempotent: counts existing variants per type and only inserts the gap.

-- ==================== LOSS AVERSION & FOMO ====================
DO $$
DECLARE
  v_loss UUID := (SELECT id FROM lessons WHERE slug = 'loss-aversion-101');
  s_ojk_001 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-001');
  s_ojk_006 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-006');
  existing_examples INT;
  existing_questions INT;
BEGIN
  IF v_loss IS NULL THEN
    RETURN;
  END IF;

  SELECT COUNT(*) INTO existing_examples FROM content_variants WHERE lesson_id = v_loss AND variant_type = 'example';
  SELECT COUNT(*) INTO existing_questions FROM content_variants WHERE lesson_id = v_loss AND variant_type = 'question';

  -- EXAMPLES: up to 10
  IF existing_examples < 10 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_loss, 'example', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'text', 'Budi punya saham BBCA seharga Rp 9.000 per lembar. Saat harga turun ke Rp 8.600, ia merasa "rugi besar" meski turunnya baru sekitar 4%. Loss aversion membuatnya ingin segera menjual, padahal fundamental bank tetap kuat.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      )),
      (jsonb_build_object(
        'text', 'Di warung kopi kampus, semua teman Nia membahas saham GOTO yang naik 25% dalam seminggu. Nia langsung transfer Rp 2.000.000 dari GoPay ke aplikasi sekuritas tanpa baca prospektus. Dua minggu kemudian saham koreksi dan Nia sadar FOMO membuatnya lupa aturan riset dulu.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Pak Tono menabung Rp 50 juta di deposito BCA dengan imbal hasil yang stabil. Temannya bilang "rugi" karena saham bisa untung lebih besar, tapi Pak Tono merasa nyaman karena tidak kuatir harga turun setiap hari. Setiap orang punya batas aversi rugi yang berbeda.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      )),
      (jsonb_build_object(
        'text', 'Salsa membeli saham BBRI dan TLKM sebagai bagian portofolio jangka panjang. Setiap kali ada berita negatif, ia panik mau jual. Temannya mengingatkan: rasa takut rugi boleh ada, tapi jangan biarkan emosi mengganti rencana yang sudah dibuat saat tenang.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Sebuah grup Telegram ramai membahas token kripto baru yang katanya "pasti naik". Andi ikut membeli Rp 1.500.000 karena takut ketinggalan. Setelah hype mereda, harga turun 60%. Andi belajar bahwa FOMO sering datang tanpa data yang jelas.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      )),
      (jsonb_build_object(
        'text', 'Rina memiliki reksa dana pasar uang dan saham UNVR. Ketika portofolionya turun Rp 200.000, ia lebih ingat kerugian itu daripada untung Rp 200.000 minggu lalu. Perasaan tidak simetris inilah yang disebut loss aversion.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Fikri membuat aturan: hanya boleh membeli saham baru setelah membaca laporan keuangan minimal 15 menit. Aturan ini membantunya menolak FOMO ketika melihat postingan untung teman di media sosial.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      ))
    ) AS v(body)
    LIMIT (10 - existing_examples);
  END IF;

  -- QUESTIONS: up to 11
  IF existing_questions < 11 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_loss, 'question', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Kenapa FOMO berbahaya saat membeli saham viral?',
        'options', jsonb_build_array('Karena harga selalu turun', 'Karena bisa mendorong pembelian tanpa riset yang cukup', 'Karena saham viral tidak punya risiko', 'Karena biaya transaksi selalu nol'),
        'answer', 'Karena bisa mendorong pembelian tanpa riset yang cukup',
        'explanation', 'FOMO membuat investor mengikuti tren tanpa riset mandiri, yang berisiko menyebabkan kerugian.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Loss aversion paling terlihat ketika investor ...',
        'options', jsonb_build_array('Menjual saham bagus terlalu cepat karena takut rugi', 'Membeli saham dengan riset lengkap', 'Menyebarkan investasi ke banyak sektor', 'Menabung secara rutin setiap bulan'),
        'answer', 'Menjual saham bagus terlalu cepat karena takut rugi',
        'explanation', 'Loss aversion sering membuat investor menjual aset padahal fundamentalnya masih baik.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Rasa sakit dari rugi Rp 100.000 biasanya sama besarnya dengan rasa senang untung Rp 100.000.',
        'answer', false,
        'explanation', 'Loss aversion menunjukkan rasa sakit kerugian biasanya lebih kuat dari rasa senang keuntungan yang sama besar.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Cara melawan FOMO adalah membuat _____ investasi sebelum emosi muncul.',
        'answer', 'aturan',
        'explanation', 'Aturan yang dibuat saat tenang membantu menahan keputusan impulsif saat FOMO melanda.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi kalimat: "FOMO membuat kita _____ aset karena takut _____."',
        'options', jsonb_build_array('membeli', 'ketinggalan'),
        'answer', jsonb_build_array('membeli', 'ketinggalan'),
        'explanation', 'FOMO adalah rasa takut ketinggalan yang mendorong pembelian tanpa riset yang matang.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah agar loss aversion tidak menguasai keputusan.',
        'options', jsonb_build_array('Tentukan batas kerugian yang bisa diterima', 'Buat alasan membeli sebelum transaksi', 'Jangan cek harga setiap menit', 'Review portofolio sesuai jadwal'),
        'answer', jsonb_build_array('Buat alasan membeli sebelum transaksi', 'Tentukan batas kerugian yang bisa diterima', 'Jangan cek harga setiap menit', 'Review portofolio sesuai jadwal'),
        'explanation', 'Rencana sebelum transaksi, batas kerugian, kontrol cek harga, dan review terjadwal membantu mengelola emosi.',
        'parameters', '{}'::jsonb
      ))
    ) AS v(body)
    LIMIT (11 - existing_questions);
  END IF;
END $$;

-- ==================== DIVERSIFICATION ====================
DO $$
DECLARE
  v_diversification UUID := (SELECT id FROM lessons WHERE slug = 'diversification-101');
  s_ojk_006 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-006');
  s_idx_001 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-001');
  existing_examples INT;
  existing_questions INT;
BEGIN
  IF v_diversification IS NULL THEN
    RETURN;
  END IF;

  SELECT COUNT(*) INTO existing_examples FROM content_variants WHERE lesson_id = v_diversification AND variant_type = 'example';
  SELECT COUNT(*) INTO existing_questions FROM content_variants WHERE lesson_id = v_diversification AND variant_type = 'question';

  -- EXAMPLES: up to 10
  IF existing_examples < 10 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_diversification, 'example', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'text', 'Dewi menyisihkan Rp 5.000.000 per bulan: 40% ke reksa dana saham indeks IDX30, 30% ke obligasi pemerintah, 20% ke deposito, dan 10% ke emas digital. Ketika saham turun, bagian obligasi dan deposito membantu menahan nilai portofolio.',
        'source_ids', jsonb_build_array(s_ojk_006::text, s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Seorang pengemudi ojek online membeli saham BBCA, BBRI, TLKM, dan UNVR. Ia tidak membeli hanya satu saham meski temannya bilang "pasti cuan". Pilihannya menyebar antar sektor perbankan, telekomunikasi, dan konsumer.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Penjual mie ayam di Jakarta menyimpan modal usaha di tiga tempat: sebagian di tabungan BCA, sebagian di reksa dana pasar uang, dan sebagian kecil di saham blue chip. Kalau satu tempat bermasalah, usahanya tetap bisa jalan.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Dua investor punya Rp 20.000.000. Satu membeli GOTO, DCII, dan saham teknologi lain semuanya. Yang lain membeli GOTO, BBRI, TLKM, dan reksa dana obligasi. Investor kedua lebih terlindungi jika sektor teknologi koreksi.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Kartika memahami bahwa diversifikasi bukan berarti membeli 20 saham sekaligus. Ia memilih 5 saham dari sektor berbeda plus reksa dana pasar uang. Kualitas penyebaran lebih penting dari jumlah saham.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Sebuah keluarga muda di Bandung memiliki dana darurat di deposito, investasi jangka panjang di saham BBCA dan BBRI, serta tabungan pendidikan anak di reksa dana campuran. Setiap tujuan punya instrumen yang berbeda.',
        'source_ids', jsonb_build_array(s_ojk_006::text, s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Reksa dana indeks yang mengikuti IDX30 secara otomatis memberikan diversifikasi ke 30 saham besar. Ini cocok bagi pemula yang belum punya waktu riset satu per satu.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      ))
    ) AS v(body)
    LIMIT (10 - existing_examples);
  END IF;

  -- QUESTIONS: up to 11
  IF existing_questions < 11 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_diversification, 'question', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Manakah yang paling mendekati diversifikasi yang baik?',
        'options', jsonb_build_array('Semua uang di saham GOTO', 'Saham BBCA, obligasi pemerintah, dan reksa dana pasar uang', 'Membeli 15 saham sektor teknologi', 'Menyimpan semua uang di dompet digital'),
        'answer', 'Saham BBCA, obligasi pemerintah, dan reksa dana pasar uang',
        'explanation', 'Diversifikasi baik menyebar dana ke berbagai jenis aset dan sektor, bukan hanya satu jenis.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Apa risiko membeli banyak saham dari sektor yang sama?',
        'options', jsonb_build_array('Biaya administrasi lebih murah', 'Jika sektor tersebut turun, semua saham ikut terdampak', 'Pajak selalu lebih rendah', 'Dividen dijamin lebih besar'),
        'answer', 'Jika sektor tersebut turun, semua saham ikut terdampak',
        'explanation', 'Saham dalam sektor yang sama cenderung bergerak searah, sehingga diversifikasi sektor penting.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Diversifikasi menjamin portofolio selalu untung setiap bulan.',
        'answer', false,
        'explanation', 'Diversifikasi mengurangi risiko, bukan menjamin keuntungan. Portofolio tetap bisa turun.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Diversifikasi membantu mengurangi dampak jika satu _____ investasi mengalami penurunan.',
        'answer', 'aset',
        'explanation', 'Dengan menyebar ke banyak aset, kerugian satu aset tidak menghancurkan seluruh portofolio.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi: "Jangan taruh semua _____ dalam satu _____."',
        'options', jsonb_build_array('telur', 'keranjang'),
        'answer', jsonb_build_array('telur', 'keranjang'),
        'explanation', 'Peribahasa ini menggambarkan pentingnya menyebar risiko dalam berinvestasi.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah membangun portofolio yang terdiversifikasi.',
        'options', jsonb_build_array('Kenali tujuan keuangan', 'Pilih kombinasi saham, obligasi, dan reksa dana', 'Bagi dana sesuai profil risiko', 'Evaluasi ulang setiap 6 bulan'),
        'answer', jsonb_build_array('Kenali tujuan keuangan', 'Pilih kombinasi saham, obligasi, dan reksa dana', 'Bagi dana sesuai profil risiko', 'Evaluasi ulang setiap 6 bulan'),
        'explanation', 'Mulai dari tujuan, pilih instrumen, alokasikan sesuai profil risiko, lalu evaluasi berkala.',
        'parameters', '{}'::jsonb
      ))
    ) AS v(body)
    LIMIT (11 - existing_questions);
  END IF;
END $$;

-- ==================== CONFIDENCE & RISK TOLERANCE ====================
DO $$
DECLARE
  v_confidence UUID := (SELECT id FROM lessons WHERE slug = 'confidence-101');
  s_ojk_001 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-001');
  s_ojk_006 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-006');
  s_idx_001 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-001');
  s_bi_002 UUID := (SELECT id FROM sources WHERE source_code = 'BI-002');
  existing_examples INT;
  existing_questions INT;
BEGIN
  IF v_confidence IS NULL THEN
    RETURN;
  END IF;

  SELECT COUNT(*) INTO existing_examples FROM content_variants WHERE lesson_id = v_confidence AND variant_type = 'example';
  SELECT COUNT(*) INTO existing_questions FROM content_variants WHERE lesson_id = v_confidence AND variant_type = 'question';

  -- EXAMPLES: up to 10
  IF existing_examples < 10 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_confidence, 'example', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'text', 'Lina, karyawan baru dengan gaji Rp 7.000.000, langsung membeli saham GOTO dan beberapa saham gorengan karena yakin bisa "main saham". Dalam sebulan ia kehilangan 20% modal karena overtrading dan biaya transaksi.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Pak Harto, pensiunan PNS, memilih deposito dan obligasi pemerintah meski imbal hasilnya lebih rendah dari saham. Ia tidur nyenyak karena tidak kuatir fluktuasi harian. Profil risikonya berbeda dengan anak muda.',
        'source_ids', jsonb_build_array(s_ojk_001::text, s_bi_002::text)
      )),
      (jsonb_build_object(
        'text', 'Siti mahasiswa punya dana darurat 6 bulan dan horizon investasi 10 tahun. Ia memilih campuran saham blue chip dan reksa dana. Temannya Fikri yang belum punya dana darurat sebaiknya fokus menabung dulu sebelum saham.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Seorang trader di media sosial pamer untung Rp 50 juta dalam seminggu. Riko ingin meniru tapi tidak sadar modal dan pengalaman mereka berbeda. Overconfidence bisa muncul saat kita hanya melihat hasil bagus orang lain.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Bank Indonesia mempublikasikan BI Rate yang memengaruhi suku bunga deposito dan imbal hasil obligasi. Investor yang paham konteks ini tidak panik mengganti strategi hanya karena satu berita.',
        'source_ids', jsonb_build_array(s_bi_002::text)
      )),
      (jsonb_build_object(
        'text', 'Maya baru pertama kali berinvestasi dan langsung yakin bisa menganalisis laporan keuangan. Setelah rugi di saham pertamanya, ia sadar bahwa belajar bertahap lebih penting daripada percaya diri berlebihan.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      )),
      (jsonb_build_object(
        'text', 'Dua orang dengan penghasilan sama bisa punya toleransi risiko berbeda. Yang punya tanggungan keluarga besar mungkin lebih konservatif, sementara yang single dan punya dana darurat bisa lebih agresif.',
        'source_ids', jsonb_build_array(s_ojk_001::text)
      ))
    ) AS v(body)
    LIMIT (10 - existing_examples);
  END IF;

  -- QUESTIONS: up to 11
  IF existing_questions < 11 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_confidence, 'question', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Investor yang overconfidence cenderung ...',
        'options', jsonb_build_array('Bertransaksi terlalu sering dan meremehkan risiko', 'Menabung dengan disiplin', 'Selalu memeriksa laporan keuangan', 'Mendiversifikasi portofolio dengan hati-hati'),
        'answer', 'Bertransaksi terlalu sering dan meremehkan risiko',
        'explanation', 'Overconfidence sering membuat investor overtrading dan mengabaikan risiko.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Pensiunan yang bergantung pada tabungan sebaiknya cenderung memilih instrumen ...',
        'options', jsonb_build_array('Saham spekulatif', 'Deposito dan obligasi pemerintah', 'Kripto dengan volatilitas tinggi', 'Saham gorengan'),
        'answer', 'Deposito dan obligasi pemerintah',
        'explanation', 'Profil risiko pensiunan biasanya lebih konservatif karena membutuhkan stabilitas.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Toleransi risiko setiap orang pasti sama jika penghasilannya sama.',
        'answer', false,
        'explanation', 'Toleransi risiko juga dipengaruhi tanggungan, dana darurat, tujuan, dan reaksi emosional.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Investor muda dengan horizon panjang biasanya bisa mempertimbangkan profil sedikit lebih _____.',
        'answer', 'agresif',
        'explanation', 'Horizon waktu panjang memberi kesempatan untuk menahan fluktuasi pasar.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi: "Pilih instrumen sesuai _____ risiko sendiri, bukan mengikuti _____ orang lain."',
        'options', jsonb_build_array('profil', 'gaya hidup'),
        'answer', jsonb_build_array('profil', 'gaya hidup'),
        'explanation', 'Keputusan investasi harus disesuaikan dengan profil risiko pribadi, bukan gaya hidup influencer.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah menilai toleransi risiko.',
        'options', jsonb_build_array('Hitung dana darurat dan tanggungan', 'Tentukan horizon waktu investasi', 'Uji reaksi emosi saat portofolio turun', 'Pilih instrumen yang sesuai'),
        'answer', jsonb_build_array('Hitung dana darurat dan tanggungan', 'Tentukan horizon waktu investasi', 'Uji reaksi emosi saat portofolio turun', 'Pilih instrumen yang sesuai'),
        'explanation', 'Kenali kondisi keuangan, horizon, reaksi emosi, lalu pilih instrumen yang cocok.',
        'parameters', '{}'::jsonb
      ))
    ) AS v(body)
    LIMIT (11 - existing_questions);
  END IF;
END $$;

-- ==================== VOLATILITY & EMOTIONAL CONTROL ====================
DO $$
DECLARE
  v_volatility UUID := (SELECT id FROM lessons WHERE slug = 'volatility-101');
  s_idx_001 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-001');
  s_idx_007 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-007');
  s_bi_002 UUID := (SELECT id FROM sources WHERE source_code = 'BI-002');
  existing_examples INT;
  existing_questions INT;
BEGIN
  IF v_volatility IS NULL THEN
    RETURN;
  END IF;

  SELECT COUNT(*) INTO existing_examples FROM content_variants WHERE lesson_id = v_volatility AND variant_type = 'example';
  SELECT COUNT(*) INTO existing_questions FROM content_variants WHERE lesson_id = v_volatility AND variant_type = 'question';

  -- EXAMPLES: up to 10
  IF existing_examples < 10 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_volatility, 'example', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'text', 'Saham TLKM dalam satu kuartal bisa naik dari Rp 3.800 ke Rp 4.200 lalu turun ke Rp 3.900. Investor jangka panjang melihat fluktuasi ini sebagai hal normal, bukan sinyal untuk panik.',
        'source_ids', jsonb_build_array(s_idx_007::text)
      )),
      (jsonb_build_object(
        'text', 'Ketika Bank Indonesia menaikkan BI Rate, harga saham perbankan seperti BBCA dan BBRI sering bergerak lebih aktif. Bagi investor yang paham, ini volatilitas terkait kebijakan moneter, bukan tanda perusahaan bermasalah.',
        'source_ids', jsonb_build_array(s_bi_002::text, s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Nadia membeli saham UNVR dan menetapkan aturan hanya boleh cek aplikasi sekali seminggu. Aturan ini mengurangi keinginannya untuk bereaksi setiap kali harga berubah sedikit.',
        'source_ids', jsonb_build_array(s_idx_007::text)
      )),
      (jsonb_build_object(
        'text', 'Seorang investor FOMO membeli GOTO saat naik 15% dalam seminggu. Ternyata harga kemudian koreksi. Ia belajar bahwa euforia pendek bisa menjadi volatilitas yang menyakitkan.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Ahmad memiliki portofolio saham blue chip dan reksa dana. Saat pasar turun 5% dalam sebulan, portofolionya turun 3%. Ia tidak panik karena sudah memahami volatilitas dan punya rencana.',
        'source_ids', jsonb_build_array(s_idx_007::text)
      )),
      (jsonb_build_object(
        'text', 'Kelas investasi kampus belajar bahwa volatilitas tidak sama dengan kerugian permanen. Kerugian baru terjadi jika kita menjual saat harga di bawah harga beli karena panik.',
        'source_ids', jsonb_build_array(s_idx_001::text)
      )),
      (jsonb_build_object(
        'text', 'Rina membuat jurnal investasi: setiap kali ingin jual, ia harus tulis alasannya. Jurnal ini membuatnya sadar bahwa banyak keinginan jual muncul dari emosi, bukan perubahan fundamental.',
        'source_ids', jsonb_build_array(s_idx_007::text)
      ))
    ) AS v(body)
    LIMIT (10 - existing_examples);
  END IF;

  -- QUESTIONS: up to 11
  IF existing_questions < 11 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_volatility, 'question', body, 'intermediate', 'behavioral_finance'
    FROM (VALUES
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Volatilitas harian yang tinggi pada saham growth seperti GOTO ...',
        'options', jsonb_build_array('Berarti perusahaan pasti bangkrut', 'Adalah hal normal dan tidak selalu buruk', 'Menjamin dividen besar', 'Menunjukkan saham tidak boleh dimiliki'),
        'answer', 'Adalah hal normal dan tidak selalu buruk',
        'explanation', 'Saham growth cenderung fluktuatif; yang penting adalah reaksi investor jangka panjang.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'intermediate',
        'question', 'Kebijakan BI Rate yang berubah bisa memengaruhi ...',
        'options', jsonb_build_array('Hanya harga emas', 'Volatilitas saham perbankan dan imbal hasil obligasi', 'Jumlah follower influencer', 'Warna grafik saham'),
        'answer', 'Volatilitas saham perbankan dan imbal hasil obligasi',
        'explanation', 'Suku bunga acuan memengaruhi sektor keuangan dan instrumen pendapatan tetap.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'intermediate',
        'question', 'Volatilitas selalu sama dengan kerugian nyata.',
        'answer', false,
        'explanation', 'Volatilitas adalah fluktuasi harga. Kerugian nyata terjadi jika menjual saat harga lebih rendah dari harga beli.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'fill_blank',
        'difficulty', 'intermediate',
        'question', 'Cara mengendalikan emosi saat volatilitas tinggi adalah membuat _____ investasi dan batasan cek harga.',
        'answer', 'rencana',
        'explanation', 'Rencana yang dibuat saat tenang membantu menghindari keputusan impulsif saat pasar bergejolak.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'word_bank',
        'difficulty', 'intermediate',
        'question', 'Lengkapi: "Kita tidak bisa mengendalikan _____, tapi bisa mengendalikan _____."',
        'options', jsonb_build_array('pasar', 'emosi'),
        'answer', jsonb_build_array('pasar', 'emosi'),
        'explanation', 'Volatilitas pasar di luar kendali, tetapi reaksi emosional kita bisa dikelola.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'ordering',
        'difficulty', 'intermediate',
        'question', 'Urutkan langkah tetap tenang saat pasar volatil.',
        'options', jsonb_build_array('Ingat tujuan jangka panjang', 'Tetapkan batasan cek portofolio', 'Evaluasi ulang alasan membeli', 'Hindari keputusan besar saat emosi tinggi'),
        'answer', jsonb_build_array('Tetapkan batasan cek portofolio', 'Ingat tujuan jangka panjang', 'Evaluasi ulang alasan membeli', 'Hindari keputusan besar saat emosi tinggi'),
        'explanation', 'Batasi cek harga, ingat tujuan, evaluasi alasan, dan hindari keputusan saat emosi memuncak.',
        'parameters', '{}'::jsonb
      ))
    ) AS v(body)
    LIMIT (11 - existing_questions);
  END IF;
END $$;
