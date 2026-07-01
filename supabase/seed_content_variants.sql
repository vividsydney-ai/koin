-- 10. content_variants
DO $$
DECLARE
  v_money_basics UUID := (SELECT id FROM lessons WHERE slug = 'money-basics-101');
  v_budgeting UUID := (SELECT id FROM lessons WHERE slug = 'budgeting-101');
  v_inflation UUID := (SELECT id FROM lessons WHERE slug = 'inflation-101');
  v_risk_return UUID := (SELECT id FROM lessons WHERE slug = 'risk-return-101');
  v_idx_basics UUID := (SELECT id FROM lessons WHERE slug = 'idx-basics-101');

  s_ojk_001 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-001');
  s_ojk_003 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-003');
  s_ojk_006 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-006');
  s_ojk_007 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-007');
  s_bi_001 UUID := (SELECT id FROM sources WHERE source_code = 'BI-001');
  s_bi_002 UUID := (SELECT id FROM sources WHERE source_code = 'BI-002');
  s_bi_005 UUID := (SELECT id FROM sources WHERE source_code = 'BI-005');
  s_idx_001 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-001');
  s_idx_002 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-002');
  s_idx_005 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-005');
  s_idx_007 UUID := (SELECT id FROM sources WHERE source_code = 'IDX-007');
  s_glb_004 UUID := (SELECT id FROM sources WHERE source_code = 'GLB-004');
  s_glb_007 UUID := (SELECT id FROM sources WHERE source_code = 'GLB-007');
BEGIN
  INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag) VALUES
  -- ==================== MONEY BASICS ====================
  -- examples
  (
    v_money_basics,
    'example',
    jsonb_build_object(
      'text', 'Budi, mahasiswa semester 1 di Jakarta, menerima uang saku Rp 1.500.000 per bulan. Ia menulis daftar pengeluaran: transport Rp 400.000 (kebutuhan), makan siang kampus Rp 600.000 (kebutuhan), langganan streaming Rp 100.000 (keinginan), dan dana hangout akhir pekan Rp 200.000 (keinginan). Dengan memisahkan kebutuhan dan keinginan, Budi menyisihkan Rp 200.000 untuk tabungan darurat.',
      'source_ids', jsonb_build_array(s_ojk_001::text, s_ojk_003::text)
    ),
    'beginner',
    'money_basics'
  ),
  (
    v_money_basics,
    'example',
    jsonb_build_object(
      'text', 'Siti melihat iklan di media sosial yang menawarkan imbal hasil 15% per bulan dengan jaminan modal aman. Sebelum mengirim uang, Siti memeriksa izin penyelenggara di situs OJK. Ternyata perusahaan itu tidak terdaftar. Siti memilih melapor ke OJK dan tidak menginvestasikan uangnya.',
      'source_ids', jsonb_build_array(s_ojk_007::text)
    ),
    'beginner',
    'money_basics'
  ),
  -- explanation
  (
    v_money_basics,
    'explanation',
    jsonb_build_object(
      'text', 'Uang adalah alat tukar yang harus dikelola dengan bijak. Langkah pertama adalah membedakan kebutuhan (sesuatu yang harus dipenuhi untuk hidup dan belajar) dengan keinginan (sesuatu yang menyenangkan tetapi bisa ditunda). Langkah kedua adalah waspada terhadap penawaran investasi yang menjanjikan keuntungan tinggi tanpa risiko. Selalu periksa izin produk keuangan di situs OJK sebelum memutuskan investasi.',
      'ai_assist_context', 'Bantu pengguna memahami perbedaan kebutuhan dan keinginan dalam konteks mahasiswa Indonesia, serta mengajarkan cara memverifikasi izin produk keuangan melalui OJK.'
    ),
    'beginner',
    'money_basics'
  ),
  -- questions
  (
    v_money_basics,
    'question',
    jsonb_build_object(
      'type', 'multiple_choice',
      'difficulty', 'beginner',
      'question', 'Manakah yang termasuk kebutuhan bagi pelajar Indonesia?',
      'options', jsonb_build_array('Tiket konser', 'Pulsa dan kuota internet untuk kelas online', 'Skin game terbaru', 'Kopi di kafe'),
      'answer', 'Pulsa dan kuota internet untuk kelas online',
      'explanation', 'Pulsa dan kuota internet mendukung kegiatan belajar, sehingga termasuk kebutuhan.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'money_basics'
  ),
  (
    v_money_basics,
    'question',
    jsonb_build_object(
      'type', 'true_false',
      'difficulty', 'beginner',
      'question', 'Investasi yang menjanjikan imbal hasil tinggi dan "dijamin" aman tanpa risiko biasanya dapat dipercaya.',
      'answer', false,
      'explanation', 'Penawaran dengan imbal hasil tinggi dan jaminan tanpa risiko adalah ciri umum investasi ilegal. Selalu periksa izin OJK.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'money_basics'
  ),
  (
    v_money_basics,
    'question',
    jsonb_build_object(
      'type', 'fill_blank',
      'difficulty', 'beginner',
      'question', 'Sebelum berinvestasi, periksa terlebih dahulu izin perusahaan di situs _____.',
      'answer', 'OJK',
      'explanation', 'Otoritas Jasa Keuangan (OJK) mengatur dan mengawasi produk keuangan di Indonesia.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'money_basics'
  ),
  (
    v_money_basics,
    'question',
    jsonb_build_object(
      'type', 'word_bank',
      'difficulty', 'beginner',
      'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Sebelum membeli barang baru, tanyakan pada diri sendiri: apakah ini _____ atau _____?"',
      'options', jsonb_build_array('kebutuhan', 'keinginan'),
      'answer', jsonb_build_array('kebutuhan', 'keinginan'),
      'explanation', 'Membedakan kebutuhan dan keinginan adalah langkah awal mengelola uang.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'money_basics'
  ),
  (
    v_money_basics,
    'question',
    jsonb_build_object(
      'type', 'ordering',
      'difficulty', 'beginner',
      'question', 'Urutkan langkah berikut dari yang paling penting hingga paling akhir.',
      'options', jsonb_build_array('Bayar kebutuhan', 'Sisihkan tabungan', 'Penuhi keinginan jika ada sisa', 'Periksa izin investasi sebelum menanamkan uang'),
      'answer', jsonb_build_array('Bayar kebutuhan', 'Sisihkan tabungan', 'Penuhi keinginan jika ada sisa', 'Periksa izin investasi sebelum menanamkan uang'),
      'explanation', 'Prioritaskan kebutuhan, lalu tabungan, baru keinginan. Investasi hanya setelah izin diverifikasi.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'money_basics'
  ),

  -- ==================== BUDGETING ====================
  -- examples
  (
    v_budgeting,
    'example',
    jsonb_build_object(
      'text', 'Ani bekerja paruh waktu dengan penghasilan Rp 2.500.000 per bulan. Ia menerapkan aturan 50/30/20: Rp 1.250.000 untuk kebutuhan (kos, transport, makan), Rp 750.000 untuk keinginan (streaming, hangout), dan Rp 500.000 untuk tabungan serta pelunasan utang kecil kepada keluarga.',
      'source_ids', jsonb_build_array(s_ojk_003::text)
    ),
    'beginner',
    'budgeting'
  ),
  (
    v_budgeting,
    'example',
    jsonb_build_object(
      'text', 'Rian menggunakan aplikasi catatan keuangan untuk mencatat setiap pengeluaran harian. Setiap akhir minggu, ia meninjau apakah pengeluarannya sesuai anggaran. Jika melebihi batas, ia mengurangi kategori keinginan minggu depan.',
      'source_ids', jsonb_build_array(s_ojk_003::text)
    ),
    'beginner',
    'budgeting'
  ),
  -- explanation
  (
    v_budgeting,
    'explanation',
    jsonb_build_object(
      'text', 'Anggaran adalah rencana penggunaan uang. Aturan 50/30/20 membagi pendapatan: 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan dan pelunasan utang. Di Indonesia, mahasiswa atau pekerja muda dapat menyesuaikan proporsi ini sesuai biaya hidup dan tanggungan keluarga. Yang terpenting adalah mencatat pengeluaran dan meninjau anggaran secara rutin.',
      'ai_assist_context', 'Bantu pengguna membuat anggaran sederhana dengan aturan 50/30/20 menggunakan contoh penghasilan dan biaya hidup di Indonesia.'
    ),
    'beginner',
    'budgeting'
  ),
  -- questions
  (
    v_budgeting,
    'question',
    jsonb_build_object(
      'type', 'multiple_choice',
      'difficulty', 'beginner',
      'question', 'Dalam aturan 50/30/20, berapa persen yang dialokasikan untuk kebutuhan?',
      'options', jsonb_build_array('20%', '30%', '50%', '70%'),
      'answer', '50%',
      'explanation', 'Aturan 50/30/20 menggunakan 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan serta utang.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'budgeting'
  ),
  (
    v_budgeting,
    'question',
    jsonb_build_object(
      'type', 'true_false',
      'difficulty', 'beginner',
      'question', 'Membuat anggaran berarti tidak boleh menghabiskan uang untuk hiburan sama sekali.',
      'answer', false,
      'explanation', 'Anggaran 50/30/20 menyisihkan 30% untuk keinginan, termasuk hiburan, asalkan tetap dalam batas.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'budgeting'
  ),
  (
    v_budgeting,
    'question',
    jsonb_build_object(
      'type', 'fill_blank',
      'difficulty', 'beginner',
      'question', 'Dalam aturan 50/30/20, angka 20% digunakan untuk tabungan dan _____.',
      'answer', 'pelunasan utang',
      'explanation', '20% dari pendapatan sebaiknya dialokasikan untuk tabungan dan melunasi utang.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'budgeting'
  ),
  (
    v_budgeting,
    'question',
    jsonb_build_object(
      'type', 'word_bank',
      'difficulty', 'beginner',
      'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Anggaran hanya berhasil jika kita secara rutin _____ pengeluaran dan _____ anggaran."',
      'options', jsonb_build_array('mencatat', 'meninjau'),
      'answer', jsonb_build_array('mencatat', 'meninjau'),
      'explanation', 'Pencatatan dan peninjauan rutin memastikan anggaran tetap realistis.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'budgeting'
  ),
  (
    v_budgeting,
    'question',
    jsonb_build_object(
      'type', 'ordering',
      'difficulty', 'beginner',
      'question', 'Urutkan langkah membuat anggaran bulanan.',
      'options', jsonb_build_array('Catat semua pemasukan', 'Bagi pengeluaran menjadi kebutuhan, keinginan, dan tabungan', 'Tetapkan batas untuk setiap kategori', 'Evaluasi akhir bulan dan sesuaikan anggaran berikutnya'),
      'answer', jsonb_build_array('Catat semua pemasukan', 'Bagi pengeluaran menjadi kebutuhan, keinginan, dan tabungan', 'Tetapkan batas untuk setiap kategori', 'Evaluasi akhir bulan dan sesuaikan anggaran berikutnya'),
      'explanation', 'Mulai dari pemasukan, lalu kategorikan, tetapkan batas, dan evaluasi secara berkala.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'budgeting'
  ),

  -- ==================== INFLATION ====================
  -- examples
  (
    v_inflation,
    'example',
    jsonb_build_object(
      'text', 'Tahun 2020, seporsi nasi padang di Jakarta dihargai Rp 25.000. Pada 2025, harga yang sama menjadi Rp 32.000. Kenaikan harga ini menunjukkan inflasi: daya beli rupiah menurun seiring waktu.',
      'source_ids', jsonb_build_array(s_bi_001::text)
    ),
    'beginner',
    'inflation'
  ),
  (
    v_inflation,
    'example',
    jsonb_build_object(
      'text', 'Bank Indonesia menetapkan target inflasi sekitar 2,5% plus minus 1%. Target ini dirancang agar harga naik cukup pelan sehingga masyarakat dapat merencanakan pengeluaran dan investasi dengan lebih stabil.',
      'source_ids', jsonb_build_array(s_bi_001::text, s_bi_002::text)
    ),
    'beginner',
    'inflation'
  ),
  -- explanation
  (
    v_inflation,
    'explanation',
    jsonb_build_object(
      'text', 'Inflasi adalah kenaikan harga barang dan jasa secara umum dalam jangka waktu tertentu. Bank Indonesia menargetkan inflasi sekitar 2,5% ± 1% agar perekonomian tetap stabil. Jika tabungan di bank memberikan bunga lebih rendah dari inflasi, daya beli uang menurun. Oleh karena itu, memahami inflasi penting sebelum memilih instrumen tabungan atau investasi jangka panjang.',
      'ai_assist_context', 'Jelaskan inflasi menggunakan target BI dan contoh harga makanan di Indonesia. Hindari rekomendasi produk investasi spesifik.'
    ),
    'beginner',
    'inflation'
  ),
  -- questions
  (
    v_inflation,
    'question',
    jsonb_build_object(
      'type', 'multiple_choice',
      'difficulty', 'beginner',
      'question', 'Apa pengaruh inflasi terhadap daya beli uang?',
      'options', jsonb_build_array('Daya beli meningkat', 'Daya beli menurun', 'Daya beli tetap sama', 'Inflasi tidak berpengaruh'),
      'answer', 'Daya beli menurun',
      'explanation', 'Inflasi membuat harga barang naik, sehingga uang yang sama bisa membeli lebih sedikit.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'inflation'
  ),
  (
    v_inflation,
    'question',
    jsonb_build_object(
      'type', 'true_false',
      'difficulty', 'beginner',
      'question', 'Menyimpan semua uang dalam bentuk tunai dalam jangka panjang tetap aman dari inflasi.',
      'answer', false,
      'explanation', 'Uang tunai tidak menghasilkan bunga, sehingga daya belinya menurun jika inflasi positif.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'inflation'
  ),
  (
    v_inflation,
    'question',
    jsonb_build_object(
      'type', 'fill_blank',
      'difficulty', 'beginner',
      'question', 'Bank Indonesia menargetkan inflasi sekitar _____ persen plus minus satu persen.',
      'answer', '2,5',
      'explanation', 'Bank Indonesia menargetkan inflasi sekitar 2,5% ± 1% untuk menjaga stabilitas ekonomi.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'inflation'
  ),
  (
    v_inflation,
    'question',
    jsonb_build_object(
      'type', 'word_bank',
      'difficulty', 'beginner',
      'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Inflasi membuat _____ yang sama bisa membeli _____ barang dari waktu ke waktu."',
      'options', jsonb_build_array('uang', 'lebih sedikit'),
      'answer', jsonb_build_array('uang', 'lebih sedikit'),
      'explanation', 'Kenaikan harga akibat inflasi mengurangi jumlah barang yang dapat dibeli dengan uang yang sama.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'inflation'
  ),
  (
    v_inflation,
    'question',
    jsonb_build_object(
      'type', 'ordering',
      'difficulty', 'beginner',
      'question', 'Urutkan proses pengaruh inflasi terhadap tabungan.',
      'options', jsonb_build_array('Harga barang naik', 'Daya beli uang menurun', 'Bunga tabungan mungkin lebih rendah dari inflasi', 'Nilai riil tabungan berkurang'),
      'answer', jsonb_build_array('Harga barang naik', 'Daya beli uang menurun', 'Bunga tabungan mungkin lebih rendah dari inflasi', 'Nilai riil tabungan berkurang'),
      'explanation', 'Inflasi menaikkan harga, menurunkan daya beli, dan dapat mengurangi nilai riil tabungan jika bunganya rendah.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'inflation'
  ),

  -- ==================== RISK & RETURN ====================
  -- examples
  (
    v_risk_return,
    'example',
    jsonb_build_object(
      'text', 'Dewi menabung Rp 1.000.000 di instrumen yang memberikan imbal hasil rata-rata 8% per tahun. Dengan bunga majemuk, setelah 10 tahun nilainya menjadi sekitar Rp 2.160.000. Temannya yang menyimpan uang tunai tetap Rp 1.000.000, tetapi daya belinya menurun akibat inflasi.',
      'source_ids', jsonb_build_array(s_ojk_006::text)
    ),
    'intermediate',
    'risk_return'
  ),
  (
    v_risk_return,
    'example',
    jsonb_build_object(
      'text', 'Andi memiliki portofolio yang terdiri dari saham bank (BBCA), saham telekomunikasi (TLKM), reksa dana pasar uang, dan obligasi pemerintah. Ketika harga saham teknologi turun, dampaknya tidak terlalu besar karena uangnya tersebar di berbagai jenis aset.',
      'source_ids', jsonb_build_array(s_ojk_006::text, s_glb_007::text)
    ),
    'intermediate',
    'risk_return'
  ),
  -- explanation
  (
    v_risk_return,
    'explanation',
    jsonb_build_object(
      'text', 'Risiko dan pengembalian berjalan beriringan: potensi keuntungan tinggi biasanya disertai risiko tinggi. Bunga majemuk membuat keuntungan dihasilkan tidak hanya dari modal awal, tetapi juga dari keuntungan sebelumnya. Diversifikasi, atau menyebarkan investasi ke berbagai aset, membantu mengurangi risiko jika salah satu investasi merugi. Waktu adalah mitra terbaik untuk investor muda.',
      'ai_assist_context', 'Jelaskan hubungan risiko dan pengembalian, bunga majemuk, dan diversifikasi dengan contoh rupiah. Jangan berikan rekomendasi produk spesifik.'
    ),
    'intermediate',
    'risk_return'
  ),
  -- questions
  (
    v_risk_return,
    'question',
    jsonb_build_object(
      'type', 'multiple_choice',
      'difficulty', 'intermediate',
      'question', 'Manakah pernyataan yang benar tentang hubungan risiko dan pengembalian?',
      'options', jsonb_build_array('Risiko tinggi selalu menghasilkan keuntungan tinggi', 'Pengembalian tinggi biasanya berarti risiko tinggi', 'Risiko rendah selalu mengalahkan inflasi', 'Risiko dan pengembalian tidak berhubungan'),
      'answer', 'Pengembalian tinggi biasanya berarti risiko tinggi',
      'explanation', 'Investor umumnya menuntut potensi keuntungan lebih tinggi sebagai kompensasi atas risiko yang lebih besar.',
      'parameters', '{}'::jsonb
    ),
    'intermediate',
    'risk_return'
  ),
  (
    v_risk_return,
    'question',
    jsonb_build_object(
      'type', 'true_false',
      'difficulty', 'beginner',
      'question', 'Diversifikasi menjamin investasi selalu menghasilkan keuntungan.',
      'answer', false,
      'explanation', 'Diversifikasi mengurangi risiko, tetapi tidak menjamin keuntungan.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'risk_return'
  ),
  (
    v_risk_return,
    'question',
    jsonb_build_object(
      'type', 'fill_blank',
      'difficulty', 'intermediate',
      'question', 'Bunga majemuk berarti kita mendapatkan imbal hasil dari modal awal dan dari _____ sebelumnya.',
      'answer', 'imbal hasil',
      'explanation', 'Bunga majemuk menghasilkan pertumbuhan yang dipercepat karena imbal hasil dihitung dari modal dan imbal hasil yang sudah diperoleh.',
      'parameters', '{}'::jsonb
    ),
    'intermediate',
    'risk_return'
  ),
  (
    v_risk_return,
    'question',
    jsonb_build_object(
      'type', 'word_bank',
      'difficulty', 'intermediate',
      'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Untuk mengurangi risiko, seorang investor muda sebaiknya melakukan _____ dengan menyebarkan uang ke beberapa _____."',
      'options', jsonb_build_array('diversifikasi', 'jenis aset'),
      'answer', jsonb_build_array('diversifikasi', 'jenis aset'),
      'explanation', 'Diversifikasi menyebarkan investasi ke berbagai jenis aset untuk mengurangi dampak kerugian tunggal.',
      'parameters', '{}'::jsonb
    ),
    'intermediate',
    'risk_return'
  ),
  (
    v_risk_return,
    'question',
    jsonb_build_object(
      'type', 'ordering',
      'difficulty', 'intermediate',
      'question', 'Urutkan langkah menyusun portofolio yang sehat.',
      'options', jsonb_build_array('Tentukan tujuan keuangan', 'Pahami toleransi risiko', 'Pilih berbagai jenis aset', 'Pantau dan sesuaikan secara berkala'),
      'answer', jsonb_build_array('Tentukan tujuan keuangan', 'Pahami toleransi risiko', 'Pilih berbagai jenis aset', 'Pantau dan sesuaikan secara berkala'),
      'explanation', 'Mulai dari tujuan, pahami risiko, diversifikasi, lalu pantau dan sesuaikan.',
      'parameters', '{}'::jsonb
    ),
    'intermediate',
    'risk_return'
  ),
  (
    v_risk_return,
    'question',
    jsonb_build_object(
      'type', 'multiple_choice',
      'difficulty', 'intermediate',
      'question', 'Jika Rp {{amount}} diinvestasikan dengan imbal hasil rata-rata {{rate}}% per tahun, berapa nilai perkiraan setelah {{years}} tahun (bunga majemuk)?',
      'options', jsonb_build_array(
        'Rp {{amount * (1 + rate/100) ** years}}',
        'Rp {{amount + rate * years}}',
        'Rp {{amount * years}}',
        'Rp {{amount * rate}}'
      ),
      'answer', 'Rp {{amount * (1 + rate/100) ** years}}',
      'explanation', 'Bunga majemuk menghitung pertumbuhan dari modal dan imbal hasil yang sudah diperoleh: nilai = modal × (1 + rate)^tahun.',
      'parameters', jsonb_build_object(
        'amount', jsonb_build_object('min', 1000000, 'max', 5000000, 'step', 500000),
        'rate', jsonb_build_object('min', 5, 'max', 12, 'step', 1),
        'years', jsonb_build_object('min', 5, 'max', 15, 'step', 1)
      )
    ),
    'intermediate',
    'risk_return'
  ),

  -- ==================== IDX BASICS ====================
  -- examples
  (
    v_idx_basics,
    'example',
    jsonb_build_object(
      'text', 'PT Bank Central Asia Tbk (BBCA) tercatat di Bursa Efek Indonesia (IDX). Jika Rina membeli 1 lot saham BBCA, ia memiliki 100 lembar saham dan menjadi bagian kecil pemilik perusahaan. Ia bisa memantau harga saham harian melalui situs IDX atau aplikasi resmi.',
      'source_ids', jsonb_build_array(s_idx_001::text, s_idx_002::text)
    ),
    'intermediate',
    'idx_basics'
  ),
  (
    v_idx_basics,
    'example',
    jsonb_build_object(
      'text', 'SIPF (Securities Investor Protection Fund) memberikan perlindungan kepada investor yang menyimpan efek di IDX. Jika perusahaan sekuritas mengalami masalah, investor terlindungi sesuai ketentuan yang berlaku, sepanjang efeknya tercatat.',
      'source_ids', jsonb_build_array(s_idx_007::text)
    ),
    'intermediate',
    'idx_basics'
  ),
  -- explanation
  (
    v_idx_basics,
    'explanation',
    jsonb_build_object(
      'text', 'Bursa Efek Indonesia (IDX) adalah pasar saham nasional Indonesia. Perusahaan yang terdaftar dapat menjual saham kepada publik, sehingga investor menjadi pemilik sebagian kecil perusahaan. Di IDX, 1 lot sama dengan 100 lembar saham. Harga saham bergerak sesuai permintaan dan penawaran. SIPF memberikan perlindungan kepada investor dalam efek tercatat.',
      'ai_assist_context', 'Perkenalkan IDX, lot saham, dan perlindungan investor menggunakan sumber IDX dan OJK. Dorong pengguna untuk melakukan riset sebelum bertransaksi.'
    ),
    'intermediate',
    'idx_basics'
  ),
  -- questions
  (
    v_idx_basics,
    'question',
    jsonb_build_object(
      'type', 'multiple_choice',
      'difficulty', 'beginner',
      'question', 'Berapa lembar saham dalam 1 lot di IDX?',
      'options', jsonb_build_array('1 lembar', '10 lembar', '100 lembar', '1000 lembar'),
      'answer', '100 lembar',
      'explanation', 'Di Bursa Efek Indonesia, 1 lot terdiri dari 100 lembar saham.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'idx_basics'
  ),
  (
    v_idx_basics,
    'question',
    jsonb_build_object(
      'type', 'true_false',
      'difficulty', 'beginner',
      'question', 'Membeli saham berarti meminjamkan uang kepada perusahaan.',
      'answer', false,
      'explanation', 'Membeli saham berarti menjadi pemilik sebagian kecil perusahaan, bukan meminjamkan uang.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'idx_basics'
  ),
  (
    v_idx_basics,
    'question',
    jsonb_build_object(
      'type', 'fill_blank',
      'difficulty', 'beginner',
      'question', 'Singkatan IDX adalah Bursa _____ Indonesia.',
      'answer', 'Efek',
      'explanation', 'IDX adalah singkatan dari Bursa Efek Indonesia.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'idx_basics'
  ),
  (
    v_idx_basics,
    'question',
    jsonb_build_object(
      'type', 'word_bank',
      'difficulty', 'beginner',
      'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Di IDX, investor membeli _____ yang mewakili kepemilikan sebagian dari sebuah _____."',
      'options', jsonb_build_array('saham', 'perusahaan'),
      'answer', jsonb_build_array('saham', 'perusahaan'),
      'explanation', 'Saham adalah bukti kepemilikan sebagian dari perusahaan yang tercatat.',
      'parameters', '{}'::jsonb
    ),
    'beginner',
    'idx_basics'
  ),
  (
    v_idx_basics,
    'question',
    jsonb_build_object(
      'type', 'ordering',
      'difficulty', 'intermediate',
      'question', 'Urutkan langkah membeli saham di IDX secara aman.',
      'options', jsonb_build_array('Buka rekening efek di sekuritas terdaftar', 'Lakukan riset perusahaan', 'Tentukan saham dan jumlah lot', 'Pantau portofolio secara berkala'),
      'answer', jsonb_build_array('Buka rekening efek di sekuritas terdaftar', 'Lakukan riset perusahaan', 'Tentukan saham dan jumlah lot', 'Pantau portofolio secara berkala'),
      'explanation', 'Mulai dengan rekening efek, riset perusahaan, tentukan lot, lalu pantau secara berkala.',
      'parameters', '{}'::jsonb
    ),
    'intermediate',
    'idx_basics'
  );
END $$;

