-- Migration: Add extra content variants for the 5 launch lessons
-- Adds 1 example + 5 question variants (one per question type) per lesson,
-- for a total of 30 new content_variants rows.

INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag) VALUES

-- ==================== MONEY BASICS ====================
(
  (SELECT id FROM lessons WHERE slug = 'money-basics-101'),
  'example',
  jsonb_build_object(
    'text', 'Rina, pelajar SMA di Surabaya, menerima uang jajan Rp 800.000 per minggu. Ia menyimpan Rp 200.000 di dompet digital untuk transport dan makan siang, Rp 100.000 untuk pulsa dan kuota internet, dan Rp 500.000 untuk tabungan. Ketika temannya menawarkan investasi dengan imbal hasil pasti 20% per bulan, Rina menolak dan memeriksa izin perusahaan di situs OJK.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-001')::text, (SELECT id FROM sources WHERE source_code = 'OJK-007')::text)
  ),
  'beginner',
  'money_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'money-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'difficulty', 'beginner',
    'question', 'Apa ciri umum penawaran investasi ilegal yang perlu diwaspadai?',
    'options', jsonb_build_array('Menjanjikan keuntungan tinggi tanpa risiko', 'Terdaftar dan diawasi OJK', 'Memberikan laporan keuangan berkala', 'Produknya mudah dipahami'),
    'answer', 'Menjanjikan keuntungan tinggi tanpa risiko',
    'explanation', 'Penawaran investasi ilegal sering menjanjikan imbal hasil tinggi dan mengklaim tanpa risiko. Selalu periksa izin di situs OJK.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'money_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'money-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'difficulty', 'beginner',
    'question', 'Uang sisa setelah memenuhi kebutuhan sebaiknya ditabung untuk keperluan mendesak.',
    'answer', true,
    'explanation', 'Menyisihkan sisa uang untuk tabungan darurat adalah kebiasaan keuangan yang baik.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'money_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'money-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'difficulty', 'beginner',
    'question', 'Sesuatu yang harus dipenuhi untuk hidup dan belajar disebut _____.',
    'answer', 'kebutuhan',
    'explanation', 'Kebutuhan adalah pengeluaran penting yang harus diprioritaskan, berbeda dengan keinginan yang bisa ditunda.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'money_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'money-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'word_bank',
    'difficulty', 'beginner',
    'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Sebelum menanamkan uang, pastikan perusahaan telah terdaftar dan diawasi oleh _____."',
    'options', jsonb_build_array('OJK', 'BI'),
    'answer', jsonb_build_array('OJK'),
    'explanation', 'Otoritas Jasa Keuangan (OJK) mengawasi produk dan perusahaan keuangan di Indonesia.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'money_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'money-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'ordering',
    'difficulty', 'beginner',
    'question', 'Urutkan langkah mengelola uang saku dengan bijak.',
    'options', jsonb_build_array('Catat pemasukan', 'Pisahkan kebutuhan dan keinginan', 'Sisihkan tabungan', 'Gunakan sisa untuk keinginan secara terukur'),
    'answer', jsonb_build_array('Catat pemasukan', 'Pisahkan kebutuhan dan keinginan', 'Sisihkan tabungan', 'Gunakan sisa untuk keinginan secara terukur'),
    'explanation', 'Catat pemasukan, pahami prioritas, sisihkan tabungan, baru gunakan sisa untuk keinginan.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'money_basics'
),

-- ==================== BUDGETING ====================
(
  (SELECT id FROM lessons WHERE slug = 'budgeting-101'),
  'example',
  jsonb_build_object(
    'text', 'Doni, pegawai baru di Bandung, memiliki pendapatan bersih Rp 4.000.000 per bulan. Ia menerapkan aturan 50/30/20 dengan penyesuaian: Rp 2.000.000 untuk kebutuhan (kos, makan, transport), Rp 800.000 untuk keinginan (nonton bioskop, jalan-jalan), dan Rp 1.200.000 untuk tabungan serta dana darurat. Setiap minggu Doni meninjau aplikasi catatan keuangannya untuk memastikan tidak over budget.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-003')::text)
  ),
  'beginner',
  'budgeting'
),
(
  (SELECT id FROM lessons WHERE slug = 'budgeting-101'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'difficulty', 'beginner',
    'question', 'Dalam aturan 50/30/20, berapa persen pendapatan yang dialokasikan untuk tabungan dan pelunasan utang?',
    'options', jsonb_build_array('50%', '30%', '20%', '10%'),
    'answer', '20%',
    'explanation', 'Aturan 50/30/20 menggunakan 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan serta utang.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'budgeting'
),
(
  (SELECT id FROM lessons WHERE slug = 'budgeting-101'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'difficulty', 'beginner',
    'question', 'Anggaran harus kaku dan tidak boleh disesuaikan meskipun pendapatan berubah.',
    'answer', false,
    'explanation', 'Anggaran sebaiknya fleksibel dan disesuaikan dengan kondisi pendapatan serta pengeluaran yang berubah.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'budgeting'
),
(
  (SELECT id FROM lessons WHERE slug = 'budgeting-101'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'difficulty', 'beginner',
    'question', 'Kegiatan mencatat setiap pengeluaran kecil setiap hari disebut _____ pengeluaran.',
    'answer', 'pencatatan',
    'explanation', 'Pencatatan pengeluaran membantu kita memantau arus uang dan menjalankan anggaran dengan disiplin.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'budgeting'
),
(
  (SELECT id FROM lessons WHERE slug = 'budgeting-101'),
  'question',
  jsonb_build_object(
    'type', 'word_bank',
    'difficulty', 'beginner',
    'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Aturan 50/30/20 membagi pendapatan menjadi _____ (50%), _____ (30%), dan tabungan/utang (20%)."',
    'options', jsonb_build_array('kebutuhan', 'keinginan'),
    'answer', jsonb_build_array('kebutuhan', 'keinginan'),
    'explanation', 'Aturan 50/30/20 membagi pendapatan untuk kebutuhan, keinginan, serta tabungan dan pelunasan utang.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'budgeting'
),
(
  (SELECT id FROM lessons WHERE slug = 'budgeting-101'),
  'question',
  jsonb_build_object(
    'type', 'ordering',
    'difficulty', 'beginner',
    'question', 'Urutkan langkah mengatasi pengeluaran yang melebihi anggaran.',
    'options', jsonb_build_array('Identifikasi kategori yang melebihi batas', 'Kurangi pengeluaran kategori keinginan', 'Alihkan selisih ke tabungan', 'Evaluasi anggaran bulan depan'),
    'answer', jsonb_build_array('Identifikasi kategori yang melebihi batas', 'Kurangi pengeluaran kategori keinginan', 'Alihkan selisih ke tabungan', 'Evaluasi anggaran bulan depan'),
    'explanation', 'Mulai dari identifikasi masalah, kurangi keinginan, alihkan ke tabungan, lalu evaluasi anggaran berikutnya.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'budgeting'
),

-- ==================== INFLATION ====================
(
  (SELECT id FROM lessons WHERE slug = 'inflation-101'),
  'example',
  jsonb_build_object(
    'text', 'Tahun 2021, harga satu liter minyak goreng kemasan di pasar tradisional sekitar Rp 10.000. Pada 2023, harga naik menjadi lebih dari Rp 17.000 per liter. Kenaikan harga minyak goreng ini adalah contoh inflasi yang memengaruhi daya beli masyarakat Indonesia, terutama keluarga dengan pengeluaran harian ketat.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'BI-001')::text, (SELECT id FROM sources WHERE source_code = 'BI-002')::text)
  ),
  'beginner',
  'inflation'
),
(
  (SELECT id FROM lessons WHERE slug = 'inflation-101'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'difficulty', 'beginner',
    'question', 'Mengapa tabungan dengan bunga rendah bisa kehilangan nilai riil saat inflasi tinggi?',
    'options', jsonb_build_array('Karena bunga tabungan lebih rendah dari kenaikan harga', 'Karena bank menutup rekening', 'Karena inflasi tidak memengaruhi uang', 'Karena harga barang turun'),
    'answer', 'Karena bunga tabungan lebih rendah dari kenaikan harga',
    'explanation', 'Jika bunga tabungan di bawah inflasi, daya beli uang menurun meskipun nominalnya tetap.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'inflation'
),
(
  (SELECT id FROM lessons WHERE slug = 'inflation-101'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'difficulty', 'beginner',
    'question', 'Inflasi yang terlalu tinggi akan merusak daya beli masyarakat.',
    'answer', true,
    'explanation', 'Inflasi tinggi membuat harga barang naik cepat, sehingga uang yang sama bisa membeli lebih sedikit.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'inflation'
),
(
  (SELECT id FROM lessons WHERE slug = 'inflation-101'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'difficulty', 'beginner',
    'question', 'Bank Indonesia menargetkan inflasi sekitar _____ persen per tahun agar perekonomian tetap stabil.',
    'answer', '2,5',
    'explanation', 'Bank Indonesia menargetkan inflasi sekitar 2,5% plus minus 1% untuk menjaga stabilitas ekonomi.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'inflation'
),
(
  (SELECT id FROM lessons WHERE slug = 'inflation-101'),
  'question',
  jsonb_build_object(
    'type', 'word_bank',
    'difficulty', 'beginner',
    'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Inflasi terjadi ketika harga barang dan jasa _____ secara _____."',
    'options', jsonb_build_array('naik', 'umum'),
    'answer', jsonb_build_array('naik', 'umum'),
    'explanation', 'Inflasi adalah kenaikan harga barang dan jasa secara umum dalam jangka waktu tertentu.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'inflation'
),
(
  (SELECT id FROM lessons WHERE slug = 'inflation-101'),
  'question',
  jsonb_build_object(
    'type', 'ordering',
    'difficulty', 'beginner',
    'question', 'Urutkan dampak inflasi terhadap daya beli masyarakat.',
    'options', jsonb_build_array('Harga barang naik', 'Uang yang sama membeli lebih sedikit', 'Daya beli menurun', 'Masyarakat mengurangi konsumsi'),
    'answer', jsonb_build_array('Harga barang naik', 'Uang yang sama membeli lebih sedikit', 'Daya beli menurun', 'Masyarakat mengurangi konsumsi'),
    'explanation', 'Inflasi menaikkan harga, sehingga uang membeli lebih sedikit, daya beli menurun, dan konsumsi berkurang.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'inflation'
),

-- ==================== RISK & RETURN ====================
(
  (SELECT id FROM lessons WHERE slug = 'risk-return-101'),
  'example',
  jsonb_build_object(
    'text', 'Lina, fresh graduate, memiliki Rp 5.000.000 untuk investasi jangka panjang. Ia memutuskan menyebarkan dana: 40% ke reksa dana pasar uang (risiko rendah), 40% ke reksa dana saham (risiko lebih tinggi), dan 20% ke obligasi pemerintah. Dengan diversifikasi, Lina tidak bergantung pada satu instrumen dan mengurangi dampak jika salah satu aset merugi.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'OJK-006')::text, (SELECT id FROM sources WHERE source_code = 'GLB-007')::text)
  ),
  'intermediate',
  'risk_return'
),
(
  (SELECT id FROM lessons WHERE slug = 'risk-return-101'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'difficulty', 'intermediate',
    'question', 'Manakah pernyataan yang paling tepat menggambarkan bunga majemuk?',
    'options', jsonb_build_array('Imbal hasil dihitung hanya dari modal awal', 'Imbal hasil dihitung dari modal dan imbal hasil sebelumnya', 'Bunga yang diterima tetap setiap tahun', 'Tidak memiliki risiko sama sekali'),
    'answer', 'Imbal hasil dihitung dari modal dan imbal hasil sebelumnya',
    'explanation', 'Bunga majemuk menghasilkan imbal hasil dari modal awal dan dari imbal hasil yang sudah diperoleh sebelumnya.',
    'parameters', '{}'::jsonb
  ),
  'intermediate',
  'risk_return'
),
(
  (SELECT id FROM lessons WHERE slug = 'risk-return-101'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'difficulty', 'beginner',
    'question', 'Semakin tinggi potensi keuntungan suatu investasi, semakin tinggi pula risikonya.',
    'answer', true,
    'explanation', 'Risiko dan pengembalian berjalan beriringan; keuntungan tinggi biasanya disertai risiko tinggi.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'risk_return'
),
(
  (SELECT id FROM lessons WHERE slug = 'risk-return-101'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'difficulty', 'intermediate',
    'question', 'Menyebarkan investasi ke berbagai jenis aset untuk mengurangi risiko disebut _____.',
    'answer', 'diversifikasi',
    'explanation', 'Diversifikasi membantu mengurangi risiko dengan tidak menaruh semua dana dalam satu instrumen.',
    'parameters', '{}'::jsonb
  ),
  'intermediate',
  'risk_return'
),
(
  (SELECT id FROM lessons WHERE slug = 'risk-return-101'),
  'question',
  jsonb_build_object(
    'type', 'word_bank',
    'difficulty', 'intermediate',
    'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Investor muda memiliki keunggulan _____ karena bisa membiarkan investasi bertumbuh lebih _____."',
    'options', jsonb_build_array('waktu', 'lama'),
    'answer', jsonb_build_array('waktu', 'lama'),
    'explanation', 'Waktu adalah mitra investor muda karena bunga majemuk bekerja lebih baik dalam jangka panjang.',
    'parameters', '{}'::jsonb
  ),
  'intermediate',
  'risk_return'
),
(
  (SELECT id FROM lessons WHERE slug = 'risk-return-101'),
  'question',
  jsonb_build_object(
    'type', 'ordering',
    'difficulty', 'intermediate',
    'question', 'Urutkan prinsip memilih investasi sesuai profil risiko.',
    'options', jsonb_build_array('Tentukan tujuan keuangan dan jangka waktu', 'Kenali toleransi risiko diri sendiri', 'Pilih instrumen yang sesuai', 'Review portofolio secara berkala'),
    'answer', jsonb_build_array('Tentukan tujuan keuangan dan jangka waktu', 'Kenali toleransi risiko diri sendiri', 'Pilih instrumen yang sesuai', 'Review portofolio secara berkala'),
    'explanation', 'Mulai dari tujuan, pahami risiko diri, pilih instrumen, lalu review portofolio secara rutin.',
    'parameters', '{}'::jsonb
  ),
  'intermediate',
  'risk_return'
),

-- ==================== IDX BASICS ====================
(
  (SELECT id FROM lessons WHERE slug = 'idx-basics-101'),
  'example',
  jsonb_build_object(
    'text', 'Bayu ingin membeli saham PT Telkom Indonesia Tbk (TLKM) di Bursa Efek Indonesia. Ia membuka rekening efek di sekuritas terdaftar OJK, menyetor dana Rp 1.000.000, dan membeli 2 lot TLKM (200 lembar). Harga saham TLKM bisa naik atau turun setiap hari sesuai permintaan dan penawaran di pasar.',
    'source_ids', jsonb_build_array((SELECT id FROM sources WHERE source_code = 'IDX-001')::text, (SELECT id FROM sources WHERE source_code = 'IDX-002')::text, (SELECT id FROM sources WHERE source_code = 'OJK-004')::text)
  ),
  'intermediate',
  'idx_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'idx-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'difficulty', 'beginner',
    'question', 'Jika seorang investor membeli 5 lot saham BBCA, berapa total lembar saham yang dimilikinya?',
    'options', jsonb_build_array('5 lembar', '50 lembar', '500 lembar', '5000 lembar'),
    'answer', '500 lembar',
    'explanation', 'Di IDX, 1 lot sama dengan 100 lembar saham. Jadi 5 lot sama dengan 500 lembar.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'idx_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'idx-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'true_false',
    'difficulty', 'beginner',
    'question', 'SIPF memberikan perlindungan kepada investor yang menyimpan efek di perusahaan sekuritas.',
    'answer', true,
    'explanation', 'Securities Investor Protection Fund (SIPF) melindungi investor dalam efek tercatat sesuai ketentuan.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'idx_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'idx-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'fill_blank',
    'difficulty', 'beginner',
    'question', 'Untuk mulai membeli saham di IDX, investor perlu membuka rekening _____ terlebih dahulu.',
    'answer', 'efek',
    'explanation', 'Rekening efek dibuka melalui perusahaan sekuritas agar investor bisa bertransaksi saham di IDX.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'idx_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'idx-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'word_bank',
    'difficulty', 'beginner',
    'question', 'Lengkapi kalimat berikut dengan kata dari bank kata: "Saham diperdagangkan di _____ Efek Indonesia, dan 1 lot sama dengan _____ lembar saham."',
    'options', jsonb_build_array('Bursa', '100'),
    'answer', jsonb_build_array('Bursa', '100'),
    'explanation', 'Saham diperdagangkan di Bursa Efek Indonesia, dengan 1 lot setara dengan 100 lembar saham.',
    'parameters', '{}'::jsonb
  ),
  'beginner',
  'idx_basics'
),
(
  (SELECT id FROM lessons WHERE slug = 'idx-basics-101'),
  'question',
  jsonb_build_object(
    'type', 'ordering',
    'difficulty', 'intermediate',
    'question', 'Urutkan tahapan menjadi investor saham di IDX.',
    'options', jsonb_build_array('Pilih sekuritas terdaftar', 'Buka rekening efek', 'Setor dana', 'Lakukan transaksi saham'),
    'answer', jsonb_build_array('Pilih sekuritas terdaftar', 'Buka rekening efek', 'Setor dana', 'Lakukan transaksi saham'),
    'explanation', 'Pilih sekuritas terdaftar, buka rekening efek, setor dana, lalu lakukan transaksi saham.',
    'parameters', '{}'::jsonb
  ),
  'intermediate',
  'idx_basics'
);
