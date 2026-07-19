-- KO-LESSON-004: Source synopses and relevance blurbs.
-- Run after applying supabase/migrations/20260719000300_add_source_synopses.sql
-- and supabase/migrations/20260719000400_deduplicate_sources.sql.
-- Wikipedia fallback was used for GLB-001, GLB-002, GLB-003, GLB-009 and GLB-010.
-- Covers 42 canonical sources after deduplication.

-- OJK-001
UPDATE sources
SET
  synopsis = 'Indonesia''s national roadmap for improving financial literacy and inclusion across the population from 2021 to 2025.',
  synopsis_id = 'Peta jalan nasional Indonesia untuk meningkatkan literasi dan inklusi keuangan masyarakat dari 2021 hingga 2025.',
  relevance_blurb = 'Reading this helps you see why Koin''s lessons map to the same national goals the government wants every Indonesian to achieve.',
  relevance_blurb_id = 'Membaca ini membantumu memahami mengapa pelajaran Koin sejalan dengan tujuan nasional yang ingin dicapai pemerintah bagi setiap orang Indonesia.'
WHERE source_code = 'OJK-001';

-- OJK-002
UPDATE sources
SET
  synopsis = 'OJK''s national survey measuring how financially literate and included Indonesian adults are each year.',
  synopsis_id = 'Survei nasional OJK yang mengukur seberapa melek keuangan dan terlayani secara finansial orang dewasa Indonesia setiap tahunnya.',
  relevance_blurb = 'The results show exactly why apps like Koin matter: millions of Indonesians still need better money skills.',
  relevance_blurb_id = 'Hasil survei ini menunjukkan mengapa aplikasi seperti Koin penting: jutaan orang Indonesia masih butuh keterampilan keuangan yang lebih baik.'
WHERE source_code = 'OJK-002';

-- OJK-003
UPDATE sources
SET
  synopsis = 'Official OJK portal for reports, regulations, circular letters, and research publications.',
  synopsis_id = 'Portal resmi OJK untuk laporan, peraturan, surat edaran, dan publikasi penelitian.',
  relevance_blurb = 'Use this portal when you want to check the original wording of a financial rule instead of relying on social media summaries.',
  relevance_blurb_id = 'Gunakan portal ini ketika ingin memeriksa bunyi asli sebuah aturan keuangan, bukan mengandalkan ringkasan media sosial.'
WHERE source_code = 'OJK-003';

-- OJK-004
UPDATE sources
SET
  synopsis = 'OJK''s capital markets channel covering regulations, licensing, and investor protection in Indonesia.',
  synopsis_id = 'Kanal pasar modal OJK yang mencakup peraturan, perizinan, dan perlindungan investor di Indonesia.',
  relevance_blurb = 'This is the authoritative source for the rules behind every stock and bond traded on the IDX.',
  relevance_blurb_id = 'Ini adalah sumber otoritatif untuk aturan di balik setiap saham dan obligasi yang diperdagangkan di IDX.'
WHERE source_code = 'OJK-004';

-- OJK-005
UPDATE sources
SET
  synopsis = 'OJK''s annual Financial Literacy Month campaign that promotes nationwide financial education activities.',
  synopsis_id = 'Kampanye Bulan Literasi Keuangan tahunan OJK yang mempromosikan kegiatan edukasi keuangan di seluruh negeri.',
  relevance_blurb = 'It signals that learning about money is a national priority, not just a nice-to-have skill.',
  relevance_blurb_id = 'Ini menandakan bahwa belajar tentang uang adalah prioritas nasional, bukan sekadar keterampilan tambahan.'
WHERE source_code = 'OJK-005';

-- OJK-007
UPDATE sources
SET
  synopsis = 'OJK''s banking channel focused on consumer protection, bank products, and complaint mechanisms.',
  synopsis_id = 'Kanal perbankan OJK yang fokus pada perlindungan konsumen, produk bank, dan mekanisme pengaduan.',
  relevance_blurb = 'Essential reading before you open your first savings account or digital wallet linked to a bank.',
  relevance_blurb_id = 'Wajib dibaca sebelum membuka rekening tabungan pertama atau dompet digital yang terhubung dengan bank.'
WHERE source_code = 'OJK-007';

-- OJK-008
UPDATE sources
SET
  synopsis = 'OJK''s official TikTok account sharing short-form financial literacy and consumer protection content.',
  synopsis_id = 'Akun TikTok resmi OJK yang membagikan konten literasi keuangan dan perlindungan konsumen dalam format pendek.',
  relevance_blurb = 'A quick way to absorb trustworthy tips between Koin lessons without falling for influencer hype.',
  relevance_blurb_id = 'Cara cepat menyerap tips terpercaya di antara pelajaran Koin tanpa terjebak hype influencer.'
WHERE source_code = 'OJK-008';

-- BI-001
UPDATE sources
SET
  synopsis = 'Bank Indonesia''s explanation of inflation, its causes, and how BI works to keep prices stable.',
  synopsis_id = 'Penjelasan Bank Indonesia tentang inflasi, penyebabnya, dan cara BI menjaga stabilitas harga.',
  relevance_blurb = 'Understanding inflation helps you see why money left under the mattress loses value over time.',
  relevance_blurb_id = 'Memahami inflasi membantumu melihat mengapa uang yang disimpan diam-diam akan kehilangan nilai seiring waktu.'
WHERE source_code = 'BI-001';

-- BI-002
UPDATE sources
SET
  synopsis = 'Bank Indonesia''s policy interest rate page explaining how the BI rate influences lending and deposit rates.',
  synopsis_id = 'Halaman suku bunga kebijakan Bank Indonesia yang menjelaskan bagaimana BI Rate memengaruhi suku bunga pinjaman dan deposito.',
  relevance_blurb = 'The BI Rate sets the tone for how much interest you earn on savings and pay on loans.',
  relevance_blurb_id = 'BI Rate menentukan besaran bunga yang kamu dapatkan dari tabungan dan bayarkan untuk pinjaman.'
WHERE source_code = 'BI-002';

-- BI-003
UPDATE sources
SET
  synopsis = 'Bank Indonesia program to improve public understanding of safe digital payments and financial technology.',
  synopsis_id = 'Program Bank Indonesia untuk meningkatkan pemahaman masyarakat tentang pembayaran digital yang aman dan teknologi keuangan.',
  relevance_blurb = 'Great context for teens using QRIS, e-wallets, and mobile banking every day.',
  relevance_blurb_id = 'Konteks yang bagus untuk remaja yang menggunakan QRIS, dompet digital, dan perbankan seluler setiap hari.'
WHERE source_code = 'BI-003';

-- BI-004
UPDATE sources
SET
  synopsis = 'Bank Indonesia''s periodic review of the stability and resilience of Indonesia''s financial system.',
  synopsis_id = 'Tinjauan berkala Bank Indonesia tentang stabilitas dan ketahanan sistem keuangan Indonesia.',
  relevance_blurb = 'Gives you the big-picture context for why regulators care about bank health and safe investing.',
  relevance_blurb_id = 'Memberikan gambaran besar mengapa regulator peduli dengan kesehatan bank dan investasi yang aman.'
WHERE source_code = 'BI-004';

-- BI-005
UPDATE sources
SET
  synopsis = 'Official Bank Indonesia foreign exchange rates for the rupiah against major currencies.',
  synopsis_id = 'Kurs valas resmi Bank Indonesia untuk rupiah terhadap mata uang utama.',
  relevance_blurb = 'Useful when you shop online in foreign currency, travel, or follow import prices that affect daily costs.',
  relevance_blurb_id = 'Berguna saat berbelanja online dalam mata uang asing, bepergian, atau mengikuti harga impor yang memengaruhi biaya harian.'
WHERE source_code = 'BI-005';

-- BI-006
UPDATE sources
SET
  synopsis = 'Bank Indonesia''s official Instagram account for economic updates and financial literacy content.',
  synopsis_id = 'Akun Instagram resmi Bank Indonesia untuk update ekonomi dan konten literasi keuangan.',
  relevance_blurb = 'Follow this for bite-sized, trustworthy updates that complement what you learn in Koin.',
  relevance_blurb_id = 'Ikuti ini untuk update singkat dan terpercaya yang melengkapi apa yang kamu pelajari di Koin.'
WHERE source_code = 'BI-006';

-- BI-007
UPDATE sources
SET
  synopsis = 'Bank Indonesia reports on micro, small and medium enterprises and the progress of financial inclusion.',
  synopsis_id = 'Laporan Bank Indonesia tentang usaha mikro, kecil, dan menengah serta perkembangan inklusi keuangan.',
  relevance_blurb = 'Shows how financial skills reach families and small businesses across Indonesia.',
  relevance_blurb_id = 'Menunjukkan bagaimana keterampilan keuangan menjangkau keluarga dan usaha kecil di seluruh Indonesia.'
WHERE source_code = 'BI-007';

-- BI-008
UPDATE sources
SET
  synopsis = 'Bank Indonesia''s official statistics portal for money, banking, prices, payments, and external sector data.',
  synopsis_id = 'Portal statistik resmi Bank Indonesia untuk data uang, perbankan, harga, pembayaran, dan sektor eksternal.',
  relevance_blurb = 'The place to find real numbers when you want to back up a money decision with data.',
  relevance_blurb_id = 'Tempat mencari angka nyata saat ingin mendukung keputusan uang dengan data.'
WHERE source_code = 'BI-008';

-- BI-009
UPDATE sources
SET
  synopsis = 'Bank Indonesia''s publications portal hosting reports, regulations, and economic research.',
  synopsis_id = 'Portal publikasi Bank Indonesia yang menyediakan laporan, peraturan, dan penelitian ekonomi.',
  relevance_blurb = 'A trusted archive for deepening your understanding of Indonesia''s economy after a Koin lesson.',
  relevance_blurb_id = 'Arsip terpercaya untuk memperdalam pemahamanmu tentang ekonomi Indonesia setelah pelajaran Koin.'
WHERE source_code = 'BI-009';

-- IDX-001
UPDATE sources
SET
  synopsis = 'IDX official education portal with articles, courses, and tools for new stock investors.',
  synopsis_id = 'Portal edukasi resmi IDX dengan artikel, kursus, dan alat untuk investor saham pemula.',
  relevance_blurb = 'The best place to start if you are curious about how the Indonesian stock market actually works.',
  relevance_blurb_id = 'Tempat terbaik untuk memulai jika kamu ingin tahu cara kerja pasar saham Indonesia.'
WHERE source_code = 'IDX-001';

-- IDX-002
UPDATE sources
SET
  synopsis = 'Official glossary defining capital-market terms used on the Indonesia Stock Exchange.',
  synopsis_id = 'Glosarium resmi yang menjelaskan istilah-istilah pasar modal yang digunakan di Bursa Efek Indonesia.',
  relevance_blurb = 'Keep this open when Koin mentions a term like IPO, dividend, or broker that you want to double-check.',
  relevance_blurb_id = 'Simpan ini saat Koin menyebut istilah seperti IPO, dividen, atau pialang yang ingin kamu periksa lagi.'
WHERE source_code = 'IDX-002';

-- IDX-003
UPDATE sources
SET
  synopsis = 'Official IDX market data, historical prices, and trading statistics for listed securities.',
  synopsis_id = 'Data pasar resmi IDX, harga historis, dan statistik perdagangan untuk efek yang tercatat.',
  relevance_blurb = 'Lets you practice analyzing real Indonesian stocks instead of made-up examples.',
  relevance_blurb_id = 'Memungkinkanmu berlatih menganalisis saham Indonesia nyata, bukan contoh fiktif.'
WHERE source_code = 'IDX-003';

-- IDX-004
UPDATE sources
SET
  synopsis = 'IDX YouTube series encouraging regular stock investing through simple, friendly videos.',
  synopsis_id = 'Seri YouTube IDX yang mendorong investasi saham rutin melalui video sederhana dan ramah.',
  relevance_blurb = 'Perfect if you prefer watching a short video before reading a long article about investing.',
  relevance_blurb_id = 'Cocok jika kamu lebih suka menonton video singkat sebelum membaca artikel panjang tentang investasi.'
WHERE source_code = 'IDX-004';

-- IDX-005
UPDATE sources
SET
  synopsis = 'IDX beginner investment guide walking new investors through opening an account and placing trades.',
  synopsis_id = 'Panduan investasi pemula IDX yang membimbing investor baru membuka rekening dan melakukan transaksi.',
  relevance_blurb = 'A practical roadmap for the day you are ready to make your first investment in Indonesia.',
  relevance_blurb_id = 'Peta jalan praktis untuk hari ketika kamu siap melakukan investasi pertama di Indonesia.'
WHERE source_code = 'IDX-005';

-- IDX-006
UPDATE sources
SET
  synopsis = 'Official IDX Mobile app for tracking market data, prices, and investor education content.',
  synopsis_id = 'Aplikasi New IDX Mobile resmi untuk memantau data pasar, harga, dan konten edukasi investor.',
  relevance_blurb = 'Lets you watch real market movements on your phone before you ever invest real money.',
  relevance_blurb_id = 'Memungkinkanmu memantau pergerakan pasar nyata di ponsel sebelum berinvestasi dengan uang sungguhan.'
WHERE source_code = 'IDX-006';

-- IDX-007
UPDATE sources
SET
  synopsis = 'IDX investor protection resources, including information on the Securities Investor Protection Fund.',
  synopsis_id = 'Sumber daya perlindungan investor IDX, termasuk informasi tentang Dana Perlindungan Investor Efek.',
  relevance_blurb = 'Understanding these protections helps you invest with confidence rather than fear.',
  relevance_blurb_id = 'Memahami perlindungan ini membantumu berinvestasi dengan percaya diri, bukan rasa takut.'
WHERE source_code = 'IDX-007';

-- IDX-008
UPDATE sources
SET
  synopsis = 'Curated playlists on IDX''s official YouTube channel covering investing basics and market updates.',
  synopsis_id = 'Playlist tersusun di kanal YouTube resmi IDX yang mencakup dasar-dasar investasi dan update pasar.',
  relevance_blurb = 'A trustworthy video library to deepen what Koin teaches about Indonesian markets.',
  relevance_blurb_id = 'Pustaka video terpercaya untuk memperdalam apa yang Koin ajarkan tentang pasar Indonesia.'
WHERE source_code = 'IDX-008';

-- GLB-001 (Wikipedia fallback)
UPDATE sources
SET
  synopsis = 'OECD framework that defines the financial literacy skills tested in the PISA 2022 international student assessment.',
  synopsis_id = 'Kerangka kerja OECD yang menentukan keterampilan literasi keuangan yang diuji dalam penilaian internasional PISA 2022.',
  relevance_blurb = 'It sets the global benchmark for what a financially literate teenager should know by age 15.',
  relevance_blurb_id = 'Ini menetapkan standar global untuk apa yang seharusnya diketahui seorang remaja yang melek keuangan pada usia 15 tahun.'
WHERE source_code = 'GLB-001';

-- GLB-002 (Wikipedia fallback)
UPDATE sources
SET
  synopsis = 'World Bank survey measuring how adults worldwide save, borrow, make payments, and manage financial risk.',
  synopsis_id = 'Survei Bank Dunia yang mengukur bagaimana orang dewasa di seluruh dunia menabung, meminjam, melakukan pembayaran, dan mengelola risiko finansial.',
  relevance_blurb = 'The Indonesian data reveals how many young people and adults still lack access to formal savings and credit.',
  relevance_blurb_id = 'Data Indonesia menunjukkan berapa banyak pemuda dan orang dewasa yang masih belum memiliki akses ke tabungan dan kredit formal.'
WHERE source_code = 'GLB-002';

-- GLB-003 (Wikipedia fallback)
UPDATE sources
SET
  synopsis = 'World Bank overview of Indonesia''s economy, development priorities, and financial sector trends.',
  synopsis_id = 'Ikhtisar Bank Dunia tentang ekonomi Indonesia, prioritas pembangunan, dan tren sektor keuangan.',
  relevance_blurb = 'Helps you understand why personal finance skills matter against the backdrop of Indonesia''s economic growth.',
  relevance_blurb_id = 'Membantumu memahami mengapa keterampilan keuangan pribadi penting di tengah pertumbuhan ekonomi Indonesia.'
WHERE source_code = 'GLB-003';

-- GLB-004
UPDATE sources
SET
  synopsis = 'A book about how behavior, ego, and psychology shape financial success more than spreadsheets or formulas.',
  synopsis_id = 'Buku tentang bagaimana perilaku, ego, dan psikologi membentuk kesuksesan finansial lebih dari spreadsheet atau rumus.',
  relevance_blurb = 'Teaches you that managing money well is mostly about controlling your impulses, not memorizing math.',
  relevance_blurb_id = 'Mengajarkan bahwa mengelola uang dengan baik sebagian besar tentang mengendalikan dorongan hati, bukan menghafal matematika.'
WHERE source_code = 'GLB-004';

-- GLB-005
UPDATE sources
SET
  synopsis = 'A practical personal-finance system for young people covering saving, budgeting, investing, and conscious spending.',
  synopsis_id = 'Sistem keuangan pribadi yang praktis untuk pemuda, mencakup menabung, anggaran, investasi, dan pengeluaran yang sadar.',
  relevance_blurb = 'A ready-to-use playbook for building your first budget and investment plan without feeling deprived.',
  relevance_blurb_id = 'Panduan siap pakai untuk membuat anggaran dan rencana investasi pertama tanpa merasa kekurangan.'
WHERE source_code = 'GLB-005';

-- GLB-006
UPDATE sources
SET
  synopsis = 'A classic comparison of two money mindsets, focused on the difference between assets that put money in your pocket and liabilities that take it out.',
  synopsis_id = 'Perbandingan klasik dua pola pikir tentang uang, yang fokus pada perbedaan aset yang memasukkan uang dan liabilitas yang mengeluarkan uang.',
  relevance_blurb = 'The asset-versus-liability lens helps you decide whether a purchase is building wealth or draining it.',
  relevance_blurb_id = 'Sudut pandang aset versus liabilitas membantumu memutuskan apakah sebuah pembelian membangun kekayaan atau mengurasnya.'
WHERE source_code = 'GLB-006';

-- GLB-007
UPDATE sources
SET
  synopsis = 'An investing guide that argues low-cost index funds tend to outperform active stock picking over the long run.',
  synopsis_id = 'Panduan investasi yang berargumen bahwa dana indeks biaya rendah cenderung mengungguli pemilihan saham aktif dalam jangka panjang.',
  relevance_blurb = 'Useful context before you decide whether to pick individual stocks or buy the whole market.',
  relevance_blurb_id = 'Konteks yang berguna sebelum memutuskan apakah memilih saham individu atau membeli seluruh pasar.'
WHERE source_code = 'GLB-007';

-- GLB-008
UPDATE sources
SET
  synopsis = 'A behavior-science guide to building new habits by starting tiny and anchoring them to existing routines.',
  synopsis_id = 'Panduan ilmu perilaku untuk membangun kebiasaan baru dengan memulai dari yang sangat kecil dan menambatkannya pada rutinitas yang ada.',
  relevance_blurb = 'Helps you turn saving and budgeting from chores into automatic daily habits.',
  relevance_blurb_id = 'Membantumu mengubah menabung dan membuat anggaran dari tugas menjadi kebiasaan harian yang otomatis.'
WHERE source_code = 'GLB-008';

-- GLB-009 (Wikipedia fallback)
UPDATE sources
SET
  synopsis = 'Research from a global nonprofit on the financial confidence, behavior, and needs of young Indonesians.',
  synopsis_id = 'Penelitian dari organisasi nirlaba global tentang kepercayaan diri, perilaku, dan kebutuhan finansial pemuda Indonesia.',
  relevance_blurb = 'Grounds Koin''s lessons in real evidence about what Indonesian teens actually struggle with financially.',
  relevance_blurb_id = 'Mendasarkan pelajaran Koin pada bukti nyata tentang apa yang sebenarnya menjadi tantangan finansial remaja Indonesia.'
WHERE source_code = 'GLB-009';

-- GLB-010 (Wikipedia fallback)
UPDATE sources
SET
  synopsis = 'Peer-reviewed academic research on the design and effectiveness of youth financial literacy programs.',
  synopsis_id = 'Penelitian akademis peer-reviewed tentang desain dan efektivitas program literasi keuangan untuk pemuda.',
  relevance_blurb = 'Shows the teaching methods behind Koin are backed by published research, not just opinion.',
  relevance_blurb_id = 'Menunjukkan bahwa metode pengajaran di balik Koin didukung oleh penelitian yang dipublikasikan, bukan sekadar opini.'
WHERE source_code = 'GLB-010';

-- GLB-011
UPDATE sources
SET
  synopsis = 'A plain-English guide to simple, low-cost index fund investing and reaching financial independence.',
  synopsis_id = 'Panduan sederhana tentang investasi dana indeks biaya rendah dan mencapai kemandirian finansial.',
  relevance_blurb = 'Cuts through investing jargon so you can start small and stay consistent for decades.',
  relevance_blurb_id = 'Menyingkirkan jargon investasi sehingga kamu bisa memulai dari kecil dan konsisten selama puluhan tahun.'
WHERE source_code = 'GLB-011';

-- GLB-012
UPDATE sources
SET
  synopsis = 'A study of everyday millionaires showing that frugal habits and disciplined saving build wealth more than high salaries.',
  synopsis_id = 'Studi tentang jutawan biasa yang menunjukkan kebiasaan hemat dan menabung disiplin membangun kekayaan lebih dari gaji tinggi.',
  relevance_blurb = 'Proof that your long-term habits matter more than your first paycheck.',
  relevance_blurb_id = 'Bukti bahwa kebiasaan jangka panjangmu lebih penting daripada gaji pertamamu.'
WHERE source_code = 'GLB-012';

-- GLB-013
UPDATE sources
SET
  synopsis = 'A nine-step program that helps you align spending with personal values and work toward financial independence.',
  synopsis_id = 'Program sembilan langkah yang membantumu menyelaraskan pengeluaran dengan nilai pribadi dan menuju kemandirian finansial.',
  relevance_blurb = 'Encourages you to think about what money is really for, beyond just buying more stuff.',
  relevance_blurb_id = 'Mendorongmu berpikir tentang apa sebenarnya tujuan uang, lebih dari sekadar membeli lebih banyak barang.'
WHERE source_code = 'GLB-013';

-- GLB-014
UPDATE sources
SET
  synopsis = 'Vanguard founder John Bogle''s case for low-cost index funds as the most reliable path to market returns.',
  synopsis_id = 'Argumen pendiri Vanguard John Bogle untuk dana indeks biaya rendah sebagai jalur paling andal menuju imbal hasil pasar.',
  relevance_blurb = 'A must-read primer before you choose your first investment product in Indonesia.',
  relevance_blurb_id = 'Buku pengantar wajib sebelum memilih produk investasi pertama di Indonesia.'
WHERE source_code = 'GLB-014';

-- GLB-015
UPDATE sources
SET
  synopsis = 'A book about how small changes in choice architecture can nudge people toward better decisions.',
  synopsis_id = 'Buku tentang bagaimana perubahan kecil dalam tata letak pilihan dapat mendorong orang membuat keputusan yang lebih baik.',
  relevance_blurb = 'Explains why setting default savings rules and spending limits can make good money choices easier.',
  relevance_blurb_id = 'Menjelaskan mengapa menetapkan aturan tabungan default dan batas pengeluaran dapat mempermudah pilihan uang yang baik.'
WHERE source_code = 'GLB-015';

-- GLB-016
UPDATE sources
SET
  synopsis = 'Nobel laureate Daniel Kahneman''s exploration of fast intuitive thinking and slow deliberate thinking.',
  synopsis_id = 'Eksplorasi Daniel Kahneman, pemenang Nobel, tentang berpikir cepat secara intuitif dan berpikir lambat secara deliberate.',
  relevance_blurb = 'Helps you spot the mental shortcuts that make you overspend or panic-sell investments.',
  relevance_blurb_id = 'Membantumu mengenali jalan pintas mental yang membuatmu boros atau panik menjual investasi.'
WHERE source_code = 'GLB-016';

-- GLB-017
UPDATE sources
SET
  synopsis = 'A framework for building good habits and breaking bad ones through tiny, consistent improvements.',
  synopsis_id = 'Kerangka kerja untuk membangun kebiasaan baik dan menghilangkan kebiasaan buruk melalui peningkatan kecil yang konsisten.',
  relevance_blurb = 'Turns budgeting, saving, and learning about money into routines that feel automatic.',
  relevance_blurb_id = 'Mengubah anggaran, menabung, dan belajar tentang uang menjadi rutinitas yang terasa otomatis.'
WHERE source_code = 'GLB-017';

-- GLB-018
UPDATE sources
SET
  synopsis = 'An Australian bestseller delivering straightforward advice on budgeting, debt, and simple investing.',
  synopsis_id = 'Bestseller dari Australia yang memberikan nasihat lugas tentang anggaran, utang, dan investasi sederhana.',
  relevance_blurb = 'A relatable, no-jargon money system that feels like advice from a trusted older sibling.',
  relevance_blurb_id = 'Sistem uang yang relatable dan tanpa jargon, terasa seperti nasihat dari kakak yang dipercaya.'
WHERE source_code = 'GLB-018';
