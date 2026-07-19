-- KO-LESSON-004: Indonesian body_id for all active content_variants
-- DO NOT execute directly; review and apply via Conductor.

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Ketika Ani membayar GoRide pakai GoPay, ia menggunakan uang digital. Sopir menerimanya karena GoPay bisa dikonversi kembali ke rupiah. Bentuknya berubah, tapi itu tetap uang."}'::jsonb
WHERE id = '7656d7a3-d2b5-4813-9ee8-147d90dde518'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Budi ingin membeli buku catatan Rp 15.000. Ia tidak perlu menukar makan siangnya; ia menyerahkan uang Rp 20.000 dan menerima kembalian Rp 5.000. Penjual menerima rupiah karena semua orang setuju uang itu punya nilai."}'::jsonb
WHERE id = 'e99ca8ca-b403-47be-8016-196d5a0e54c2'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Di desa terpencil, orang bisa menukar 2 ayam dengan satu karung beras. Itu barter, bukan uang. Uang membuat perdagangan lebih mudah karena semua orang menerima alat tukar yang sama."}'::jsonb
WHERE id = '1b7745b0-edc8-4f3f-a6d1-39c65bdfdc66'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Memungkinkan kita membandingkan harga berbagai barang", "difficulty": "beginner", "explanation": "Satuan hitung berarti semua barang punya harga dalam mata uang yang sama, sehingga mudah dibandingkan.", "options": ["Bisa disimpan di bawah kasur", "Memungkinkan kita membandingkan harga berbagai barang", "Dicetak oleh pemerintah", "Bisa dipakai di negara mana saja"], "parameters": {}, "question": "Apa artinya ketika uang disebut ''satuan hitung''?", "type": "multiple_choice"}'::jsonb
WHERE id = 'dbb3978e-5f87-4eb2-9611-ac98d93edd04'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Penyimpan nilai", "difficulty": "beginner", "explanation": "Penyimpan nilai berarti uang mempertahankan daya beli dari waktu ke waktu sehingga bisa ditabung.", "options": ["Alat tukar", "Penyimpan nilai", "Satuan hitung", "Standar utang"], "parameters": {}, "question": "Fungsi uang mana yang memungkinkanmu menabung Rp 100.000 hari ini dan membelanjakannya bulan depan?", "type": "multiple_choice"}'::jsonb
WHERE id = 'f791630f-8b78-4ca8-87fd-2feeda664473'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "tukar", "difficulty": "beginner", "explanation": "Alat tukar adalah sesuatu yang diterima secara luas sebagai pembayaran barang dan jasa.", "parameters": {}, "question": "Uang yang diterima semua orang sebagai pembayaran barang dan jasa disebut alat ____.", "type": "fill_blank"}'::jsonb
WHERE id = 'c23848aa-a0bb-49e3-b7cd-0755d66170fd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Semua orang setuju bisa dipakai membeli barang", "difficulty": "beginner", "explanation": "Uang berfungsi karena orang percaya dan menerimanya sebagai pembayaran, bukan karena bahannya.", "options": ["Terbuat dari emas", "Semua orang setuju bisa dipakai membeli barang", "Tidak pernah kehilangan nilai", "Hanya tersedia di bank"], "parameters": {}, "question": "Manakah alasan utama uang berguna?", "type": "multiple_choice"}'::jsonb
WHERE id = '40c23ed5-d769-46f6-b260-f2bb1ca65382'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Uang tidak harus tunai fisik. Saldo e-wallet dan rekening bank juga berfungsi sebagai uang.", "parameters": {}, "question": "Uang digital di dompet elektronik tetap dianggap uang karena bisa dipakai membeli barang dan jasa.", "type": "true_false"}'::jsonb
WHERE id = '5541f4e4-8677-49b8-8147-10d5d35e97b7'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Pada 2020, sepiring nasi padang di dekat kampus harganya Rp 15.000. Pada 2025, sepiring yang sama harganya Rp 22.000. Makanannya tidak tambah besar; rupiahnya yang membeli lebih sedikit."}'::jsonb
WHERE id = 'e4949c16-882d-4733-b679-e1a911859ed8'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Tahun lalu, Rina bisa membeli boba tea besar seharga Rp 25.000. Tahun ini minuman yang sama harganya Rp 28.000. Rp 25.000-nya sekarang tidak cukup. Itulah inflasi yang memakan nilai uangnya."}'::jsonb
WHERE id = '1dd92de4-207d-4544-8457-548fd06e36e4'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Jika inflasi 5% per tahun, Rp 1.000.000 yang disimpan di bawah kasur akan tetap terlihat Rp 1.000.000 dalam sepuluh tahun, tapi bisa membeli jauh lebih sedikit dari sekarang."}'::jsonb
WHERE id = 'ec9d5c72-cff0-4f97-b4ba-dd3381c0766f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lebih sedikit", "difficulty": "beginner", "explanation": "Saat harga naik, daya beli uang menurun.", "parameters": {}, "question": "Inflasi berarti jumlah uang yang sama bisa membeli ____ dari waktu ke waktu.", "type": "fill_blank"}'::jsonb
WHERE id = '03496905-0641-4558-b49b-13d0b6b888a4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Menurunkannya", "difficulty": "beginner", "explanation": "Inflasi berarti harga naik, sehingga uang yang sama bisa membeli lebih sedikit dari waktu ke waktu.", "options": ["Meningkatkannya", "Menurunkannya", "Tidak berpengaruh", "Menggandakannya setiap tahun"], "parameters": {}, "question": "Apa yang dilakukan inflasi terhadap nilai uang?", "type": "multiple_choice"}'::jsonb
WHERE id = '55d2b08b-664a-47d4-9195-4345f891df79'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Dengan inflasi, harga cenderung naik, jadi camilan kemungkinan akan lebih mahal, bukan lebih murah.", "parameters": {}, "question": "Jika inflasi 5%, camilan Rp 10.000 kemungkinan akan berharga kurang dari Rp 10.000 tahun depan.", "type": "true_false"}'::jsonb
WHERE id = '24d5670b-25b0-40c7-9e86-caf0fd6c6b09'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Daya beli uang tunai jatuh", "difficulty": "beginner", "explanation": "Meski jumlah lembaran tetap sama, inflasi membuat setiap lembar membeli lebih sedikit.", "options": ["Uang tunai bisa dicuri", "Jumlah uang mengecil", "Daya beli uang tunai jatuh", "Bank tidak menerima uang lama"], "parameters": {}, "question": "Mengapa menyimpan semua tabungan dalam bentuk tunai di bawah kasur berisiko saat inflasi?", "type": "multiple_choice"}'::jsonb
WHERE id = '70c54d33-bb34-470e-a9be-996a232cfabb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Inflasi", "difficulty": "beginner", "explanation": "Kenaikan harga umum dari waktu ke waktu disebut inflasi.", "options": ["Deflasi", "Inflasi", "Bunga", "Investasi"], "parameters": {}, "question": "Semangkuk mie ayam tahun lalu Rp 12.000, tahun ini Rp 13.000. Ini contoh apa?", "type": "multiple_choice"}'::jsonb
WHERE id = 'c46290c4-d62e-4d4a-9778-0f75552005ec'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Nia meminjam Rp 500.000 lewat aplikasi pay-later. Aplikasi itu mengenakan bunga 2% per bulan. Jika ia menunda pembayaran, utangnya menjadi Rp 510.000 setelah sebulan dan terus bertambah."}'::jsonb
WHERE id = 'df4ae9e3-c826-4ccb-8ac5-66686d19012f'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Andi menabung Rp 1.000.000 di deposito dengan bunga sederhana 5% per tahun. Setelah setahun ia punya Rp 1.050.000. Kalau bunga majemuk 5%, tahun berikutnya ia mendapat bunga dari Rp 1.050.000, bukan hanya dari pokok Rp 1.000.000."}'::jsonb
WHERE id = 'c7237687-f515-4990-97e7-5009949d353b'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Bunga majemuk seperti bola salju yang menggelinding menuruni bukit. Bunga yang kamu dapat ditambahkan ke tabunganmu, lalu bunga di masa depan dihitung dari jumlah yang lebih besar."}'::jsonb
WHERE id = '65bcb937-4559-476f-aed7-46e164646125'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina menabung Rp1.000.000 di deposito dengan bunga 4% per tahun. Setelah satu tahun, ia mendapat bunga Rp40.000. Bunga adalah imbalan yang diberikan bank karena Rina meminjamkan uangnya kepada bank untuk sementara waktu."}'::jsonb
WHERE id = '44b16109-6165-47ac-aa56-490486f96d10'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni meminjam Rp2.000.000 melalui pinjol dengan bunga 10% per bulan. Setelah sebulan, ia harus mengembalikan Rp2.200.000. Bunga adalah biaya pinjam meminjam uang."}'::jsonb
WHERE id = '0cd547fb-3e0a-4f60-97dc-dc2b2c9c91f6'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bunga sederhana dihitung dari modal awal saja. Rumusnya: Bunga = Pokok × Suku Bunga × Waktu."}'::jsonb
WHERE id = '9fd4a7c7-a2f7-4912-9858-61bbcdb06116'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bunga bisa menjadi imbalan (saat menabung atau berinvestasi) atau biaya (saat berhutang). Besarnya tergantung pada suku bunga, jumlah uang, dan waktu."}'::jsonb
WHERE id = '96f4a5cb-0d9c-4f69-88ea-34b5ec673823'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "bunga", "difficulty": "beginner", "explanation": "Bank membayar bunga kepada penabung dan mengenakan bunga kepada peminjam.", "parameters": {}, "question": "Saat kamu menabung, bank membayar kamu ____ karena meminjam uangmu.", "type": "fill_blank"}'::jsonb
WHERE id = '1c12528a-8739-47f5-94de-e458388300cc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Total bunga yang dibayar biasanya jauh lebih besar", "difficulty": "beginner", "explanation": "Membayar hanya minimum memanjangkan utang dan membuat bunga majemuk bertambah besar.", "options": ["Utang lebih cepat hilang", "Total bunga yang dibayar biasanya jauh lebih besar", "Suku bunga turun", "Tidak apa-apa, bunga bulanan murah"], "parameters": {}, "question": "Jika kamu meminjam uang dengan bunga 3% per bulan, apa yang terjadi jika hanya membayar minimum setiap bulan?", "type": "multiple_choice"}'::jsonb
WHERE id = '3bda9351-e336-49d8-a349-52abe57ae4ff'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Bunga majemuk menghitung pertumbuhan dari total saldo, termasuk bunga yang sudah diperoleh.", "parameters": {}, "question": "Dengan bunga majemuk, kamu mendapat bunga dari pokok dan bunga yang sudah ditambahkan sebelumnya.", "type": "true_false"}'::jsonb
WHERE id = '76558224-6165-4259-a607-766819f17766'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Harga menggunakan uang dari waktu ke waktu", "difficulty": "beginner", "explanation": "Bunga adalah apa yang kamu dapat saat menabung atau bayar saat berhutang.", "options": ["Denda karena menabung", "Harga menggunakan uang dari waktu ke waktu", "Pajak pemerintah atas pendapatan", "Jenis dividen saham"], "parameters": {}, "question": "Apa itu bunga?", "type": "multiple_choice"}'::jsonb
WHERE id = '2ee9ae86-c1bf-40d2-87db-abe29a4f75eb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Bunga majemuk", "difficulty": "beginner", "explanation": "Bunga majemuk mempercepat pertumbuhan karena menghasilkan bunga dari bunga.", "options": ["Bunga sederhana", "Bunga majemuk", "Tidak ada bunga", "Keduanya sama cepat"], "parameters": {}, "question": "Mana yang biasanya membuat uang tumbuh lebih cepat dalam jangka panjang?", "type": "multiple_choice"}'::jsonb
WHERE id = '056bd058-bfe3-4f32-a16a-0b2b9b7e92de'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp120.000", "difficulty": "intermediate", "explanation": "6% dari Rp2.000.000 adalah Rp120.000.", "options": ["Rp120.000", "Rp200.000", "Rp12.000", "Rp600.000"], "question": "Doni meminjam Rp2.000.000 dengan bunga sederhana 6% per tahun. Berapa bunga selama setahun?", "type": "multiple_choice"}'::jsonb
WHERE id = '706b5820-a638-477c-bd0d-26d2d4f96807'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Bunga bisa menguntungkan (tabungan/investasi) atau merugikan (utang), tergantung posisi kita.", "question": "Bunga selalu merugikan peminjam dan menguntungkan pemberi pinjaman.", "type": "true_false"}'::jsonb
WHERE id = '713d4053-9993-44e6-8d73-590659f2a34e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Imbalan yang kamu terima dari bank", "difficulty": "intermediate", "explanation": "Bunga tabungan/deposito adalah imbalan bank karena kita meminjamkan uang kepada mereka.", "options": ["Imbalan yang kamu terima dari bank", "Biaya yang kamu bayar ke bank", "Denda keterlambatan", "Pajak atas tabungan"], "question": "Jika kamu menabung, bunga adalah ...", "type": "multiple_choice"}'::jsonb
WHERE id = '1e4d2e4d-5e68-4706-a953-9f24d8ae634a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "{{amount * rate / 100}}", "explanation": "Bunga = Rp{{amount}} × {{rate}}% = Rp{{amount * rate / 100}}.", "parameters": {"amount": {"max": 2000000, "min": 1000000, "step": 250000}, "rate": {"max": 6, "min": 3, "step": 1}}, "question": "Rina menabung Rp{{amount}} dengan bunga {{rate}}% per tahun. Bunga sederhana selama satu tahun adalah Rp_____.", "type": "fill_blank"}'::jsonb
WHERE id = '1284e2e7-2764-4e86-b26e-e0c4079e76f8'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Dina bergaji Rp 8.000.000 per bulan tapi menghabiskan Rp 8.000.000 untuk sewa, makan, dan belanja. Pendapatannya tinggi tapi kekayaannya datar. Sari bergaji Rp 4.000.000 tapi menyisihkan Rp 800.000 setiap bulan. Lama-kelamaan kekayaan Sari tumbuh meski pendapatannya lebih rendah."}'::jsonb
WHERE id = '8516eace-77ff-40f4-8233-4ffb9d0bf61b'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Seorang artis mendapat honor Rp100 juta per job, tetapi semua habis untuk gaya hidup mewah. Temannya guru honorer pendapatan Rp3 juta/bulan, tetapi rutin menabung dan memiliki Rp20 juta. Kekayaan dilihat dari apa yang tersisa, bukan yang masuk."}'::jsonb
WHERE id = '34c609f3-6b9d-4e19-a106-8dc5bf878a4c'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Andi promoter gaji Rp8 juta/bulan, tapi habis untuk cicilan motor, hangout, dan belanja online. Tabungannya nol. Budi barista gaji Rp4 juta/bulan, sisihkan Rp500 ribu per bulan, dan sudah punya tabungan Rp15 juta. Budi lebih kaya karena kekayaan adalah stok yang dimiliki, bukan aliran masuk."}'::jsonb
WHERE id = 'c1b1ba06-0414-4c9b-b0f5-751beed805d0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Selebriti terkenal bisa menghasilkan Rp 1 miliar per tahun tapi bangkrut jika pengeluarannya lebih besar dari pendapatannya. Seorang pemilik warung kecil mungkin penghasilannya Rp 3 juta per bulan tapi menjadi kaya karena rajin menabung dan berinvestasi."}'::jsonb
WHERE id = '4ac744fd-c7fa-453d-bdf6-aafa4ad12cb2'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Pendapatan adalah uang yang masuk secara berkala, seperti gaji atau uang saku. Kekayaan adalah total aset yang kita miliki dikurangi utang, atau stok kepemilikan bersih."}'::jsonb
WHERE id = '693a366a-7503-41bb-863b-8585dc5e90ea'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Pendapatan tinggi tidak otomatis membuat kita kaya. Jika pengeluaran lebih besar dari pendapatan, kekayaan bisa nol atau negatif meski gaji besar."}'::jsonb
WHERE id = '89011549-5080-4d55-8961-f5615e63ba0d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pendapatan adalah uang yang masuk; kekayaan adalah uang yang tersisa dan tumbuh", "difficulty": "beginner", "explanation": "Pendapatan adalah aliran uang dari waktu ke waktu. Kekayaan adalah stok aset yang terakumulasi dikurangi utang.", "options": ["Pendapatan adalah yang kamu miliki; kekayaan adalah yang kamu hasilkan", "Pendapatan adalah uang yang masuk; kekayaan adalah uang yang tersisa dan tumbuh", "Keduanya sama", "Kekayaan hanya untuk orang kaya"], "parameters": {}, "question": "Apa perbedaan pendapatan dan kekayaan?", "type": "multiple_choice"}'::jsonb
WHERE id = 'f1e6184d-9cc8-46e4-944e-53f11e350658'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Jika pengeluaran lebih besar dari pendapatan, orang dengan gaji tinggi bisa memiliki kekayaan rendah atau bahkan utang.", "question": "Pendapatan tinggi selalu berarti kekayaan tinggi.", "type": "true_false"}'::jsonb
WHERE id = 'ad911e4e-6e17-4b37-8fb7-816d6aa91ccd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "utang", "difficulty": "beginner", "explanation": "Kekayaan bersih = aset - utang. Ini menunjukkan seberapa besar harta yang benar-benar kita miliki.", "question": "Kekayaan bersih dihitung dari total aset dikurangi total _____.", "type": "fill_blank"}'::jsonb
WHERE id = '6d8c020e-5b0b-4713-95c5-89dd53ddec9c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Tika, karena she saves and invests", "caseText": "Rudi earns Rp 10 juta per bulan. He leases a new car, eats out per hari, and has no savings. Tika earns Rp 5 juta per bulan. She lives simply, saves Rp 1 juta per bulan, and invests it.", "difficulty": "beginner", "explanation": "kekayaan comes from what you keep and grow, not just what you earn.", "followUp": {"answer": "Tika, karena she saves and invests", "difficulty": "beginner", "explanation": "kekayaan comes from what you keep and grow, not just what you earn.", "options": ["Rudi, karena he earns more", "Tika, karena she saves and invests", "They will have the same", "It depends on their jobs"], "parameters": {}, "question": "After five years, who is likely to have more kekayaan?"}, "parameters": {}, "type": "case_study"}'::jsonb
WHERE id = 'da6c83e2-f344-4a0d-a07a-3ec29b12cb93'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Someone who saves and invests part of their salary", "difficulty": "beginner", "explanation": "Building kekayaan requires converting pendapatan into saved and invested assets.", "options": ["Someone who spends their entire salary", "Someone who saves and invests part of their salary", "Someone who hanya earns a high salary", "Someone who borrows to buy luxuries"], "parameters": {}, "question": "Which person is building kekayaan?", "type": "multiple_choice"}'::jsonb
WHERE id = '645b39e4-4dcd-4b7b-8385-f8321c9388aa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Budi", "difficulty": "beginner", "explanation": "Kekayaan diukur dari aset bersih yang dimiliki, bukan dari besarnya gaji.", "options": ["Budi", "Andi", "Sama kaya", "Tidak bisa dibandingkan"], "question": "Andi gaji Rp8 juta, tabungan nol. Budi gaji Rp4 juta, tabungan Rp15 juta. Siapa yang lebih kaya?", "type": "multiple_choice"}'::jsonb
WHERE id = '8fa48ba3-ad69-441c-8d45-c2653dd4eafe'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Kekayaan": "Tabungan Rp15 juta dikurangi utang Rp2 juta", "Pendapatan": "Gaji Rp4 juta per bulan", "Pengeluaran": "Bayar kos Rp800 ribu per bulan"}, "difficulty": "beginner", "explanation": "Membedakan aliran uang (pendapatan/pengeluaran) dan stok kepemilikan (kekayaan) membantu kita menilai kesehatan keuangan.", "pairs": [["Pendapatan", "Gaji Rp4 juta per bulan"], ["Kekayaan", "Tabungan Rp15 juta dikurangi utang Rp2 juta"], ["Pengeluaran", "Bayar kos Rp800 ribu per bulan"]], "question": "Pasangkan konsep dengan contohnya.", "type": "matching"}'::jsonb
WHERE id = '86fcdf8a-3dc8-462a-8ed3-9f04d1bc9b2c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Kekayaan tergantung seberapa banyak yang disimpan dan tumbuh, bukan hanya berapa yang dihasilkan.", "parameters": {}, "question": "Seseorang dengan pendapatan tinggi tapi pengeluaran tinggi bisa memiliki kekayaan lebih rendah dari orang dengan pendapatan sederhana yang rajin menabung.", "type": "true_false"}'::jsonb
WHERE id = '06a75736-53b0-4b55-923e-60da40efda65'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dodi membeli motor kredit untuk jadi driver ojek online. Motor itu menghasilkan uang setiap hari dari orderan, meski ia masih bayar cicilan. Bagi Dodi, motor itu aset karena memasukkan uang ke kantongnya."}'::jsonb
WHERE id = 'cf6fe211-324f-41b3-8089-135cc6b7c0a0'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Eko membeli motor kredit yang sama hanya untuk jalan-jalan akhir pekan. Ia bayar cicilan, bensin, dan parkir, tapi motor tidak menghasilkan uang. Bagi Eko, motor itu lebih bersifat liabilitas karena mengeluarkan uang terus."}'::jsonb
WHERE id = '232bba1b-735e-46e5-9f7d-7a5980cc170b'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Motor yang dipakai untuk antar makanan online menghasilkan uang, jadi ia berperilaku seperti aset. Motor yang dibeli kredit hanya untuk jalan-jalan akhir pekan menghabiskan biaya bensin, perawatan, dan bunga, jadi ia lebih seperti liabilitas."}'::jsonb
WHERE id = 'dedabf9c-06e9-4cc6-a33a-3adc97298cae'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Laptop yang dibeli untuk main game dan nonton Netflix sebagian besar liabilitas karena terus menghabiskan uang listrik dan internet. Laptop yang sama untuk kerja desain lepas adalah aset karena membantu menghasilkan uang."}'::jsonb
WHERE id = '6481d852-0fc0-49bc-9048-a80cee3b4fe7'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Barang yang sama bisa jadi aset atau liabilitas tergantung cara menggunakannya. Motor untuk kerja bisa jadi aset, motor hanya untuk gaya bisa jadi liabilitas."}'::jsonb
WHERE id = '2ab4a387-b4b1-4136-ae68-2b0541631348'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Aset adalah sesuatu yang memasukkan uang ke kantong kita atau bisa meningkat nilainya. Liabilitas adalah sesuatu yang mengeluarkan uang dari kantong kita."}'::jsonb
WHERE id = 'bcafcc6d-6e7a-4e10-b972-48b21c47eb71'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Barang ini akan membuatku menghasilkan atau mengeluarkan uang dari waktu ke waktu?", "difficulty": "beginner", "explanation": "Tes utamanya adalah apakah barang memasukkan atau mengeluarkan uang dari waktu ke waktu.", "options": ["Apakah ini lagi tren di media sosial?", "Barang ini akan membuatku menghasilkan atau mengeluarkan uang dari waktu ke waktu?", "Apakah warnanya favoritku?", "Apakah temanku sudah membelinya?"], "parameters": {}, "question": "Sebelum membeli barang mahal, pertanyaan apa yang membantumu memutuskan apakah itu aset atau liabilitas?", "type": "multiple_choice"}'::jsonb
WHERE id = '052fd659-c21f-4e54-959a-e5b98bf4b3b4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Aset": "Deposito yang menghasilkan bunga", "Bisa keduanya": "Motorbike yang dipakai kerja dan jalan-jalan", "Liabilitas": "Cicilan motor hanya untuk gaya"}, "difficulty": "beginner", "explanation": "Kategori tergantung pada apakah item tersebut memasukkan atau mengeluarkan uang.", "pairs": [["Aset", "Deposito yang menghasilkan bunga"], ["Liabilitas", "Cicilan motor hanya untuk gaya"], ["Bisa keduanya", "Motorbike yang dipakai kerja dan jalan-jalan"]], "question": "Pasangkan item dengan kategorinya.", "type": "matching"}'::jsonb
WHERE id = 'ae6672c9-d83d-4d44-9bef-09da991009ce'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Dodi", "difficulty": "beginner", "explanation": "Motor Dodi menghasilkan pendapatan, sehingga bersifat aset. Motor Eko hanya mengeluarkan biaya.", "options": ["Dodi", "Eko", "Keduanya sama", "Tidak ada yang benar"], "question": "Dodi membeli motor untuk jadi ojek online. Eko membeli motor serupa hanya untuk jalan-jalan. Siapa yang lebih mungkin memiliki aset?", "type": "multiple_choice"}'::jsonb
WHERE id = '3602d75d-f33e-4d53-9f1e-1e59060fb7ff'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Aset bisa berupa uang tunai, deposito, saham, keterampilan, atau bisnis yang menghasilkan uang.", "question": "Aset selalu berbentuk barang fisik seperti rumah atau mobil.", "type": "true_false"}'::jsonb
WHERE id = 'b14308e1-0adc-4319-91f9-99bcf331bfa5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "liabilitas", "difficulty": "beginner", "explanation": "Liabilitas menguras uang, seperti cicilan barang konsumtif yang tidak menghasilkan pendapatan.", "question": "Jika suatu barang mengeluarkan uang terus-menerus tanpa menghasilkan pendapatan, barang itu lebih bersifat _____.", "type": "fill_blank"}'::jsonb
WHERE id = 'a9fb4015-30fb-4b30-8263-036d78ee1e18'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Sesuatu yang memiliki atau menghasilkan nilai", "difficulty": "beginner", "explanation": "Aset adalah sesuatu yang menyimpan atau menghasilkan nilai bagimu.", "options": ["Sesuatu yang selalu menghabiskan uang", "Sesuatu yang memiliki atau menghasilkan nilai", "Hanya properti fisik", "Barang apa pun yang dibeli kredit"], "parameters": {}, "question": "Dalam keuangan pribadi, apa itu aset?", "type": "multiple_choice"}'::jsonb
WHERE id = 'd8577208-a1d6-450b-8f07-009e8689bbbb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"A car bought on loan just for leisure": "liabilitas", "A skill that earns freelance pendapatan": "aset", "Credit card utang": "liabilitas", "Savings in a deposit": "aset"}, "difficulty": "beginner", "explanation": "Assets put money in your pocket or hold value; liabilitas take money out.", "pairs": [["Savings in a deposit", "aset"], ["Credit card utang", "liabilitas"], ["A skill that earns freelance pendapatan", "aset"], ["A car bought on loan just for leisure", "liabilitas"]], "parameters": {}, "question": "Match each item with whether it biasanya behaves like an aset or a liabilitas for most people.", "type": "matching"}'::jsonb
WHERE id = '08ef281d-a623-4359-b72a-ca5d71ea5897'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Apakah sesuatu berperilaku seperti aset atau liabilitas tergantung apakah ia menghasilkan nilai atau menghabiskan uang bagimu.", "parameters": {}, "question": "Barang yang sama, seperti laptop atau motor, bisa menjadi aset untuk satu orang dan liabilitas untuk orang lain tergantung cara penggunaannya.", "type": "true_false"}'::jsonb
WHERE id = '1ae743cd-d90f-4b39-8dbd-f256c05c2779'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Bayu punya Rp 5.000.000. Pilihan A: simpan di rumah. Risiko: dicuri atau tergerus inflasi. Pilihan B: taruh di deposito. Risiko: return rendah mungkin kalah dari inflasi. Pilihan C: beli saham. Risiko: harga bisa turun. Setiap pilihan punya risiko berbeda."}'::jsonb
WHERE id = '2aab93b9-3f3a-4bd9-babc-0b6790c46c27'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Tidak berinvestasi juga punya risiko. Jika Lina menyimpan semua uangnya di tabungan dengan bunga 1% sementara inflasi 4%, ia kehilangan daya beli setiap tahun. Itu disebut risiko inflasi."}'::jsonb
WHERE id = 'ed9a338c-4e6c-4e14-8ce8-f37b752a1986'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Potensi return tinggi biasanya disertai risiko tinggi", "difficulty": "beginner", "explanation": "Risiko dan return biasanya terkait. Potensi untung besar cenderung datang dengan potensi rugi besar.", "options": ["Semua risiko bisa dihilangkan", "Potensi return tinggi biasanya disertai risiko tinggi", "Risiko hanya ada di pasar saham", "Penabung tidak pernah menghadapi risiko"], "parameters": {}, "question": "Manakah pernyataan yang benar tentang risiko?", "type": "multiple_choice"}'::jsonb
WHERE id = '124e9de1-d149-455c-95d1-d10e02fb2408'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Kemungkinan kehilangan uang atau return lebih rendah dari yang diharapkan", "difficulty": "beginner", "explanation": "Risiko adalah kemungkinan hasil lebih buruk dari yang diharapkan.", "options": ["Jaminan untung", "Kemungkinan kehilangan uang atau return lebih rendah dari yang diharapkan", "Sesuatu yang hanya terjadi di saham", "Jenis biaya bank"], "parameters": {}, "question": "Apa itu risiko finansial?", "type": "multiple_choice"}'::jsonb
WHERE id = '79b0b146-c0e4-4b0a-8a0f-24fa104e7429'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Uang tunai menghadapi risiko pencurian dan inflasi yang perlahan menggerus daya beli.", "parameters": {}, "question": "Menyimpan semua uang tunai di bawah kasur sepenuhnya bebas risiko.", "type": "true_false"}'::jsonb
WHERE id = 'a87a1c4d-636b-4850-b256-fad9c3bfda97'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Risiko inflasi", "difficulty": "beginner", "explanation": "Ketika inflasi lebih tinggi dari bunga tabungan, daya beli uangmu menurun dari waktu ke waktu.", "options": ["Risiko pencurian", "Risiko inflasi", "Tidak ada risiko", "Risiko kolaps mata uang"], "parameters": {}, "question": "Risiko apa yang dihadapi rekening tabungan dengan bunga 1% ketika inflasi 4%?", "type": "multiple_choice"}'::jsonb
WHERE id = '904ba181-a1a4-4951-8e97-d980e4495d7a'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Doni membeli saham seharga Rp 10.000 per lembar. Setahun kemudian harganya Rp 12.000. Jika ia menjual, keuntungan modalnya Rp 2.000 per lembar, return 20%. Tapi jika harga turun ke Rp 8.000, returnnya negatif 20%."}'::jsonb
WHERE id = '2a21924e-c5f2-4b1b-aaa3-a12a35015ffb'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Citra membeli obligasi pemerintah seharga Rp 1.000.000. Setelah setahun ia menerima bunga Rp 60.000 dan masih memiliki obligasinya. Returnnya Rp 60.000, atau 6%. Ia tidak perlu berdagang apa pun; returnnya berasal dari meminjamkan uangnya ke pemerintah."}'::jsonb
WHERE id = '37fbcddb-ccdb-4815-afd3-8a0ad5e0376f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Dijanjikan tinggi, terjamin, dan tanpa risiko", "difficulty": "beginner", "explanation": "Investasi nyata tidak bisa menjanjikan return tinggi tanpa risiko. Kombinasi itu adalah sinyal klasik penipuan.", "options": ["Lebih tinggi dari inflasi", "Dijanjikan tinggi, terjamin, dan tanpa risiko", "Dari deposito bank", "Dibayar bulanan"], "parameters": {}, "question": "Manakah tanda peringatan bahwa return yang dijanjikan mungkin penipuan?", "type": "multiple_choice"}'::jsonb
WHERE id = 'e0b5d38a-f0e3-4c7b-bbd3-170c5538dcd2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Keuntungan atau kerugian atas uangmu", "difficulty": "beginner", "explanation": "Return mengukur seberapa banyak uang yang dihasilkan atau hilang relatif terhadap modal.", "options": ["Jumlah yang kamu investasikan", "Keuntungan atau kerugian atas uangmu", "Jenis rekening bank", "Pengembalian pajak pemerintah"], "parameters": {}, "question": "Apa itu return dalam keuangan?", "type": "multiple_choice"}'::jsonb
WHERE id = 'bddcfcce-0cfb-4875-afc9-14cd0314b858'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Potensi return tinggi biasanya terkait dengan risiko tinggi.", "parameters": {}, "question": "Potensi return yang lebih tinggi biasanya berarti risiko lebih rendah.", "type": "true_false"}'::jsonb
WHERE id = '47b3fcc9-9921-4baa-9d94-3a860b2e7250'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "10%", "difficulty": "beginner", "explanation": "Return sering dinyatakan sebagai persentase dari jumlah awal.", "parameters": {}, "question": "Jika kamu menginvestasikan Rp 1.000.000 dan kemudian memiliki Rp 1.100.000, returnmu Rp 100.000 atau ____.", "type": "fill_blank"}'::jsonb
WHERE id = '6e33cb52-73e5-4362-afc1-2c03301a3f23'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Menabung seperti menyimpan payung di dekat pintu: kamu butuhnya siap saat hujan. Berinvestasi seperti menanam pohon: butuh waktu untuk tumbuh tapi bisa memberi naungan dan buah bertahun-tahun."}'::jsonb
WHERE id = '6725f79a-e9f3-44ff-b6fb-c1bc9a9ad325'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Eko punya Rp 10.000.000. Ia menyimpan Rp 3.000.000 di rekening tabungan untuk darurat dan menginvestasikan Rp 7.000.000 dalam campuran obligasi dan saham untuk masa depan. Tabungan melindunginya hari ini; investasi bekerja untuknya besok."}'::jsonb
WHERE id = '7fd6e5b5-290c-4836-b6ba-a798a6a3400c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Dana kuliah dalam 10 tahun", "difficulty": "beginner", "explanation": "Investasi untuk tujuan jangka panjang; menabung untuk kebutuhan jangka pendek dan darurat.", "options": ["Sewa bulan depan", "Dana darurat", "Ganti ponsel dalam 6 bulan", "Dana kuliah dalam 10 tahun"], "parameters": {}, "question": "Tujuan mana yang paling cocok untuk berinvestasi daripada menabung?", "type": "multiple_choice"}'::jsonb
WHERE id = '226275db-0533-4fbb-800b-833442078818'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "menabung protects money for short-term kebutuhan; berinvestasi grows money for long-term goals", "difficulty": "beginner", "explanation": "menabung focuses on safety and access. berinvestasi focuses on growth over a longer period.", "options": ["menabung is for the rich; berinvestasi is for everyone else", "menabung protects money for short-term kebutuhan; berinvestasi grows money for long-term goals", "menabung selalu beats inflasi; berinvestasi selalu loses money", "They are the same thing"], "parameters": {}, "question": "What utama difference between menabung and berinvestasi?", "type": "multiple_choice"}'::jsonb
WHERE id = '1058e6c2-bf4e-4c10-98e6-f6b72607e744'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Short-term money should be safe and accessible. Investments can fluctuate dalam jangka pendek.", "parameters": {}, "question": "Money you might need next month should biasanya be kept in savings, not invested in saham.", "type": "true_false"}'::jsonb
WHERE id = '5cbe66bd-9f40-4682-b42f-f498cd2d5580'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "years", "difficulty": "beginner", "explanation": "berinvestasi is best for money you can leave alone for a longer time.", "parameters": {}, "question": "You should save for emergencies first, then invest money you will not need for several ____.", "type": "fill_blank"}'::jsonb
WHERE id = 'e4c84d4d-14eb-4665-a02b-c1e351285a2c'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Motor Fani rusak dan butuh Rp 1.500.000 untuk perbaikan. Karena ia punya dana darurat, ia membayar tanpa berhutang. Tanpanya, ia mungkin menggunakan aplikasi pay-later dan membayar biaya serta bunga tambahan."}'::jsonb
WHERE id = '9a985e50-5fbf-4cdf-861f-a976cb79bc6d'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Dana darurat yang baik seperti ban serep. Kamu berharap tidak perlu menggunakannya, tapi saat dibutuhkan, kamu sangat bersyukur memilikinya."}'::jsonb
WHERE id = 'd53f1ed4-0253-4d3e-a504-51532a8942cc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pengeluaran tak terduga seperti perbaikan atau tagihan medis", "difficulty": "beginner", "explanation": "Dana darurat untuk kebutuhan mendesak, bukan keinginan atau investasi.", "options": ["Membeli gadget terbaru", "Pengeluaran tak terduga seperti perbaikan atau tagihan medis", "Berinvestasi di saham", "Membayar liburan yang direncanakan"], "parameters": {}, "question": "Dana darurat untuk apa?", "type": "multiple_choice"}'::jsonb
WHERE id = '02ce8283-304b-4e97-8729-02442669f790'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "A volatile saham investasi", "difficulty": "beginner", "explanation": "Emergency funds need stability. A volatile investasi could drop just when you need the money.", "options": ["Savings account", "Low-risiko money market fund", "A volatile saham investasi", "A separate digital wallet"], "parameters": {}, "question": "Where should you NOT keep your dana darurat?", "type": "multiple_choice"}'::jsonb
WHERE id = '023e8288-70af-4c9c-a081-fe9b371a0cb7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Emergency money must be safe and available when you need it.", "parameters": {}, "question": "An dana darurat should be kept in a safe place where you can access it quickly.", "type": "true_false"}'::jsonb
WHERE id = '7db60f1e-ed0b-4838-88c4-6343adee52dd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Replace the broken phone needed for school", "caseText": "Rina has Rp 2.000.000 saved. Her phone suddenly stops working and she kebutuhan Rp 1.800.000 for a replacement for school. She juga sees a limited-edition hoodie for Rp 800.000.", "difficulty": "beginner", "explanation": "A broken phone needed for school is an unexpected need. A limited hoodie is a want.", "followUp": {"answer": "Replace the broken phone needed for school", "difficulty": "beginner", "explanation": "A broken phone needed for school is an unexpected need. A limited hoodie is a want.", "options": ["Buy the hoodie karena it is limited edition", "Replace the broken phone needed for school", "Buy both and use pay-later for the rest", "Keep semua the money and do nothing"], "parameters": {}, "question": "Which use of her savings is appropriate for an dana darurat?"}, "parameters": {}, "type": "case_study"}'::jsonb
WHERE id = '993800d1-ea73-486c-8f63-4353012f5540'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Ponsel dasar untuk berhubungan dengan keluarga adalah kebutuhan. iPhone model terbaru adalah keinginan. Keduanya ponsel, tapi satu esensial dan satu lagi tambahan."}'::jsonb
WHERE id = '45aa0381-fe45-45c2-ba9a-99b5dfefee42'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Hana punya Rp 100.000 untuk hari ini. Makan siang Rp 20.000 adalah kebutuhan. Frappuccino Rp 45.000 adalah keinginan. Jika ia membeli frappuccino, uangnya tinggal sedikit untuk pulang. Melihat pertukaran ini membantunya memutuskan."}'::jsonb
WHERE id = 'c4af25f0-8455-442a-832d-6556a9aa2ea7'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni ingin membeli headphone baru Rp800.000, padahal headphone lamanya masih berfungsi. Di sisi lain, uangnya hanya Rp1 juta dan ia belum bayar uang kos Rp700.000. Headphone adalah keinginan, kos adalah kebutuhan."}'::jsonb
WHERE id = '6bc6ffbd-3cd2-4996-9ffa-a6da56e5cc57'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Sari menerima uang saku Rp1.500.000 per bulan. Kos Rp700.000, pulsa dan kuota Rp150.000, makan di kantin Rp400.000 adalah kebutuhan. Langganan streaming Rp50.000 dan sepatu baru Rp300.000 adalah keinginan. Jika uang saku habis, kebutuhan harus didahulukan."}'::jsonb
WHERE id = 'c38f8c51-b540-4787-adc4-f7339a86823d'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Kebutuhan adalah hal penting untuk hidup dan belajar, seperti makan, tempat tinggal, transportasi, dan pulsa. Keinginan adalah hal yang menyenangkan tetapi tidak mendesak."}'::jsonb
WHERE id = '4cc0e3d7-76e6-4d52-85f7-55e54a5b7f88'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Membedakan kebutuhan dan keinginan membantu kita menyusun anggaran. Aturan sederhana: bayar kebutuhan terlebih dahulu, baru alokasikan sisa untuk keinginan dan tabungan."}'::jsonb
WHERE id = '676b28c2-2fca-438a-8461-a984c8850867'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Bayar kos", "Beli pulsa dan kuota", "Langganan streaming", "Beli sepatu baru"], "difficulty": "beginner", "explanation": "Kos dan pulsa adalah kebutuhan dasar. Streaming dan sepatu baru adalah keinginan yang bisa ditunda.", "options": ["Bayar kos", "Beli pulsa dan kuota", "Langganan streaming", "Beli sepatu baru"], "question": "Urutkan pengeluaran Sari dari yang paling mendesak (kebutuhan) hingga paling bisa ditunda (keinginan).", "type": "ordering"}'::jsonb
WHERE id = '4eebb4c3-d066-4f7f-83fc-847c43114681'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Kebutuhan dasar harus didahulukan. Keinginan baru dipertimbangkan setelah kebutuhan dan tabungan tercukupi.", "question": "Keinginan harus selalu dipenuhi terlebih dahulu agar hidup bahagia.", "type": "true_false"}'::jsonb
WHERE id = '4116fa98-88ef-4d3b-bf58-4599b64aa35d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan", "difficulty": "beginner", "explanation": "Makan untuk bertahan hidup dan belajar adalah kebutuhan, tetapi pilihan tempat mewah adalah keinginan.", "question": "Makan siang di kantin termasuk _____, sedangkan makan di kafe mahal setiap hari termasuk keinginan.", "type": "fill_blank"}'::jsonb
WHERE id = '849b6a1e-03f5-49a1-9053-765c4a8c4add'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pulsa dan kuota internet untuk tugas", "difficulty": "beginner", "explanation": "Pulsa dan kuota mendukung aktivitas belajar, sehingga termasuk kebutuhan.", "options": ["Pulsa dan kuota internet untuk tugas", "Tiket konser", "Skin game terbaru", "Kopi kekinian setiap hari"], "question": "Manakah yang termasuk kebutuhan bagi pelajar?", "type": "multiple_choice"}'::jsonb
WHERE id = '84c3fd61-70a6-4d75-8926-e15953128dfa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Makanan pokok": "Kebutuhan", "Sepatu desainer": "Keinginan", "Konsol game terbaru": "Keinginan", "Sewa tempat tinggal": "Kebutuhan"}, "difficulty": "beginner", "explanation": "Kebutuhan adalah esensial untuk hidup; keinginan menyenangkan tapi tidak wajib.", "pairs": [["Basic food", "Need"], ["Latest gaming console", "Want"], ["Rent for housing", "Need"], ["Designer sneakers", "Want"]], "parameters": {}, "question": "Pasangkan setiap item dengan apakah itu biasanya kebutuhan atau keinginan.", "type": "matching"}'::jsonb
WHERE id = 'ac5554b1-bdbf-4d20-8928-e0845a72c51e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Basic transportation to school or work", "difficulty": "beginner", "explanation": "Transportation to school or work is biasanya essential. The others are keinginan.", "options": ["Premium streaming subscription", "Basic transportation to school or work", "Latest smartphone", "Weekend trip to Bali"], "parameters": {}, "question": "manakah di antara ini is biasanya a need?", "type": "multiple_choice"}'::jsonb
WHERE id = '4a1107c8-e3f8-4cf9-976f-eae31a402fc0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "kebutuhan and keinginan are personal. A need for one person might be a want for another depending on their situation.", "parameters": {}, "question": "The line between a need and a want is the same for every person.", "type": "true_false"}'::jsonb
WHERE id = '4793f7d5-36af-44b1-90b9-ec075e3080aa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Ask whether you can live without it for a month", "difficulty": "beginner", "explanation": "Waiting and questioning helps you see whether something is truly a need or just marketing pressure.", "options": ["Buy immediately before it sells out", "Ask whether you can live without it for a month", "Watch more ads to compare", "Use pay-later so it feels free"], "parameters": {}, "question": "Advertisers sering try to make you feel that a want is actually a need. apa yang terbaik defense?", "type": "multiple_choice"}'::jsonb
WHERE id = '56ae05d7-2b31-4af9-b2e1-e764ee1ea8fd'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Irfan meminjam Rp 2.000.000 dari aplikasi pay-later untuk membeli sepatu baru. Bunganya 3% per bulan. Jika ia hanya membayar minimum, utangnya bisa tumbuh menjadi Rp 2.500.000 atau lebih. Sepatunya sekarang nilainya lebih rendah dari utangnya."}'::jsonb
WHERE id = 'a9135e6d-4d96-4f63-ad83-052563f7e221'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Pinjaman pendidikan yang membantumu mempelajari keterampilan diminang bisa menjadi utang produktif jika penghasilanmu di masa depan cukup untuk melunasinya. Pinjaman untuk barang konsumtif biasanya hanya membebani."}'::jsonb
WHERE id = 'abf53164-4fb3-4d50-a88b-3c06029335ab'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Whether the new phone is a need or a want and the true total cost", "caseText": "Maya is offered a pay-later plan for a new Rp 4.000.000 phone. The per bulan payment seems small, but the total bunga over 12 months is Rp 900.000. Her current phone still works but is two years old.", "difficulty": "beginner", "explanation": "Before utang, decide if the purchase is essential and calculate the full cost termasuk bunga.", "followUp": {"answer": "Whether the new phone is a need or a want and the true total cost", "difficulty": "beginner", "explanation": "Before utang, decide if the purchase is essential and calculate the full cost termasuk bunga.", "options": ["The color of the new phone", "Whether the new phone is a need or a want and the true total cost", "How many influencers use it", "Whether the store has air conditioning"], "parameters": {}, "question": "apa the smartest thing for Maya to consider first?"}, "parameters": {}, "type": "case_study"}'::jsonb
WHERE id = '27ae078b-cfb9-4cb5-820a-4654cf7c6bda'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Pembayaran minimum memanjangkan utang dan membuat total bunga menjadi besar.", "parameters": {}, "question": "Membayar hanya minimum dari utang berbunga tinggi adalah strategi jangka panjang yang baik.", "type": "true_false"}'::jsonb
WHERE id = 'cf1831df-afa2-42e8-8c7c-b93259a871dc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "apa the bunga rate and can I afford the payments?", "difficulty": "beginner", "explanation": "Understanding the cost and your ability to repay is essential before borrowing.", "options": ["Will this impress my friends?", "apa the bunga rate and can I afford the payments?", "Is the item on sale?", "Does it come with free shipping?"], "parameters": {}, "question": "Which pertanyaan should you ask before taking on utang?", "type": "multiple_choice"}'::jsonb
WHERE id = 'a9ca8616-0323-499a-84fe-85325e69f7b8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Money you owe and must repay", "difficulty": "beginner", "explanation": "utang is borrowed money that must be repaid, biasanya with bunga or fees.", "options": ["Money you save for the future", "Money you owe and must repay", "Money you earn from investments", "Money the government gives you"], "parameters": {}, "question": "apa utang?", "type": "multiple_choice"}'::jsonb
WHERE id = '9cb81c45-825a-40e7-ab58-1c81a578ffd0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Petugas OJK yang asli tidak akan pernah meminta password, OTP, atau meminta transfer uang ke rekening pribadi. Jika ada yang menekanmu untuk segera transfer atau memberi data rahasia, itu penipuan."}'::jsonb
WHERE id = '4c780765-1af0-4cf1-916d-2438568bcbe0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Sebuah akun Instagram menjanjikan untung 15% setiap bulan, terjamin. Mereka menunjukkan screenshot keuntungan orang lain dan bilang ''slot terbatas.'' Mereka memintamu transfer ke rekening pribadi. Setiap sinyal — return terjamin, urgensi, bukti sosial palsu, rekening pribadi — adalah tanda bahaya."}'::jsonb
WHERE id = '6a650a5c-8380-4edd-b1c5-df7c78a7b940'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "This is one of the oldest and most reliable rules in personal finance.", "parameters": {}, "question": "If an investasi sounds terlalu bagus untuk jadi kenyataan, it probably is.", "type": "true_false"}'::jsonb
WHERE id = '37eccf82-76be-4120-af40-9064ae8610d1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Ignore it and contact the bank through its official number", "caseText": "You receive a WhatsApp message: \"Congratulations! You won Rp 50.000.000. Click this link and enter your OTP to claim.\" The sender claims to be from a famous bank.", "difficulty": "beginner", "explanation": "riil banks tidak pernah ask for OTPs or passwords. Verify through official channels, not links in messages.", "followUp": {"answer": "Ignore it and contact the bank through its official number", "difficulty": "beginner", "explanation": "riil banks tidak pernah ask for OTPs or passwords. Verify through official channels, not links in messages.", "options": ["Click the link and enter the OTP quickly", "Ignore it and contact the bank through its official number", "Reply with your account number", "Forward it to semua your friends"], "parameters": {}, "question": "apa yang harus kamu lakukan?"}, "parameters": {}, "type": "case_study"}'::jsonb
WHERE id = '8c495e88-16c8-4ae5-8b76-041fb5d717d1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Return tinggi terjamin tanpa risiko", "difficulty": "beginner", "explanation": "Return tinggi terjamin tanpa risiko adalah tanda utama penipuan investasi.", "options": ["Investasi terdaftar di OJK", "Return tinggi terjamin tanpa risiko", "Bisa menarik uang kapan saja", "Perusahaan memiliki kantor nyata"], "parameters": {}, "question": "Manakah tanda bahaya penipuan utama?", "type": "multiple_choice"}'::jsonb
WHERE id = '23230b08-5b42-4162-b4c7-26d3cfb3428f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The OJK website", "difficulty": "beginner", "explanation": "OJK maintains official lists of licensed financial products and companies. selalu verify there.", "options": ["Instagram comments", "The OJK website", "A friend who already invested", "The company''s own app hanya"], "parameters": {}, "question": "Before berinvestasi, where should you check if the product or company is legally registered?", "type": "multiple_choice"}'::jsonb
WHERE id = 'cd625c3d-8fbc-4c29-9f69-89399bd16531'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Kelompok mahasiswa di Yogyakarta membuat catatan keuangan bersama untuk acara kampus. Mereka memisahkan anggaran makan, transport, perlengkapan, dan cadangan 10%. Sisa uang dikembalikan transparan ke setiap anggota."}'::jsonb
WHERE id = 'da9dceab-2602-4ce0-b3b0-55d492a92737'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Siti membuka rekening tabungan tanpa biaya admin di bank BUMN. Setiap minggu ia menyisihkan Rp 50.000 dari uang jajannya. Setahun kemudian, tabungannya Rp 2.600.000 tanpa ia sadari."}'::jsonb
WHERE id = '2b232f24-729c-495c-9b6c-dfcabf87a153'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["9ddb5412-52b8-4461-b2e5-a5443ac63ca8"], "text": "Seorang pedagang di pasar tradisional ditawari skema \"uang kembali 2 kali lipat dalam seminggu\" oleh kenalan. Ia ingat pesan OJK: imbal hasil tinggi tanpa risiko itu tidak wajar. Ia menolak dan mengingatkan tetangganya."}'::jsonb
WHERE id = 'be2049b6-2415-4392-bd3b-021a893cbe3e'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04", "53eef1ac-2553-48d9-92a0-af6159d7d369"], "text": "Budi kerja magang dengan gaji Rp 1.200.000 per bulan. Setiap gajian, ia langsung pindahkan Rp 200.000 ke rekening tabungan terpisah. Setelah 6 bulan, Budi punya dana darurat Rp 1.200.000 untuk biaya kesehatan atau keperluan mendesak."}'::jsonb
WHERE id = '362d9dd4-e56a-40c5-bc96-ec044093c5b3'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Maya membedakan kebutuhan dan keinginan sebelum belanja online. Kebutuhan: skincare habis, sabun cuci piring, dan vitamin. Keinginan: sepatu baru diskon 50%. Maya membeli kebutuhan dulu, menunda keinginan sampai tabungannya cukup."}'::jsonb
WHERE id = '3f64eb98-df19-4e00-b1dd-de9bd23050b8'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["9ddb5412-52b8-4461-b2e5-a5443ac63ca8", "337c397d-743e-4d1b-8344-09e47b95be90"], "text": "Andi melihat promo di Instagram: \"Investasi Rp 500.000 dapat Rp 5 juta dalam sebulan, dijamin aman.\" Andi curiga, lalu cek perusahaan tersebut di situs OJK. Ternyata tidak terdaftar. Andi memutuskan tidak transfer dan melapor ke OJK."}'::jsonb
WHERE id = 'c649b8b4-7d2d-4f96-bc21-4d322472586b'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953", "7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Rina, mahasiswa semester 2 di Bandung, menerima uang saku Rp 2.000.000 per bulan. Ia mencatat: kos Rp 800.000, makan Rp 700.000, pulsa/kuota Rp 150.000, dan tabungan Rp 200.000. Sisanya Rp 150.000 untuk hiburan. Dengan mencatat, Rina tahu uangnya habis untuk hal penting, bukan spontan."}'::jsonb
WHERE id = 'bf53da83-0132-4aa3-823a-02b6675e6f5d'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayu ingin beli mie ayam di warung, tapi penjualnya tidak mau menukar dengan pulpen. Bayu pakai uang Rp15.000, penjual langsung terima. Uang memudahkan pertukaran karena semua orang setuju uang punya nilai."}'::jsonb
WHERE id = '11d54e82-64bf-47d2-923a-313f2ad5b9a0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["9ddb5412-52b8-4461-b2e5-a5443ac63ca8"], "text": "Siti melihat iklan di media sosial yang menawarkan imbal hasil 15% per bulan dengan jaminan modal aman. Sebelum mengirim uang, Siti memeriksa izin penyelenggara di situs OJK. Ternyata perusahaan itu tidak terdaftar. Siti memilih melapor ke OJK dan tidak menginvestasikan uangnya."}'::jsonb
WHERE id = 'a26ab9c1-df86-4203-a72a-553bb17270cb'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Saldo GoPay Rp50.000 milik Rina bisa dipakai bayar ojek online dan top-up pulsa. Meski tidak berbentuk uang kertas, saldo elektronik tetap berfungsi sebagai alat tukar karena diakui sebagai pembayaran."}'::jsonb
WHERE id = 'e4ae917f-3ffe-46b7-adc6-8139bfcff909'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953", "9ddb5412-52b8-4461-b2e5-a5443ac63ca8"], "text": "Rina, pelajar SMA di Surabaya, menerima uang jajan Rp 800.000 per minggu. Ia menyimpan Rp 200.000 di dompet digital untuk transport dan makan siang, Rp 100.000 untuk pulsa dan kuota internet, dan Rp 500.000 untuk tabungan. Ketika temannya menawarkan investasi dengan imbal hasil pasti 20% per bulan, Rina menolak dan memeriksa izin perusahaan di situs OJK."}'::jsonb
WHERE id = '2a7e52dc-5292-4c97-99fb-a1091f8ae199'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["9ddb5412-52b8-4461-b2e5-a5443ac63ca8"], "text": "Pak Harto, pensiunan, tidak pernah memberikan PIN ATM kepada siapa pun, termasuk yang mengaku petugas bank. Ia tahu bank resmi tidak akan meminta PIN. Uang pensiunnya tetap aman."}'::jsonb
WHERE id = 'eccf4689-7c00-441a-935e-2d13a373b911'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["53eef1ac-2553-48d9-92a0-af6159d7d369"], "text": "Lia membandingkan harga mie instan di e-commerce dan warung dekat kos. Meski online sedikit lebih murah, ongkir membuatnya lebih mahal. Lia membeli di warung agar hemat dan mendukung usaha lokal."}'::jsonb
WHERE id = 'db641749-3168-48e7-afba-e4494b0bc5fd'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["9ddb5412-52b8-4461-b2e5-a5443ac63ca8", "337c397d-743e-4d1b-8344-09e47b95be90"], "text": "Doni hampir transfer Rp 1 juta ke nomor rekening yang dikirim via WhatsApp oleh \"customer service\" bank. Ia berhenti dan langsung hubungi call center bank resmi. Ternyata itu modus penipuan."}'::jsonb
WHERE id = '34999ab5-5bbe-46ac-b73c-0748cfbc3fb2'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953", "7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Budi, mahasiswa semester 1 di Jakarta, menerima uang saku Rp 1.500.000 per bulan. Ia menulis daftar pengeluaran: transport Rp 400.000 (kebutuhan), makan siang kampus Rp 600.000 (kebutuhan), langganan streaming Rp 100.000 (keinginan), dan dana hangout akhir pekan Rp 200.000 (keinginan). Dengan memisahkan kebutuhan dan keinginan, Budi menyisihkan Rp 200.000 untuk tabungan darurat."}'::jsonb
WHERE id = '3a4e0d8a-0676-4092-9cd2-4940da762450'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Uang adalah alat tukar yang disepakati orang banyak. Tanpa uang, kita harus bartar—menukar barang langsung—yang sulit karena belum tentu kebutuhan kedua pihak cocok."}'::jsonb
WHERE id = '0523f63e-c588-4d15-ba71-3697aeee434d'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Bantu pengguna memahami perbedaan kebutuhan dan keinginan dalam konteks mahasiswa Indonesia, serta mengajarkan cara memverifikasi izin produk keuangan melalui OJK.", "text": "Uang adalah alat tukar yang harus dikelola dengan bijak. Langkah pertama adalah membedakan kebutuhan (sesuatu yang harus dipenuhi untuk hidup dan belajar) dengan keinginan (sesuatu yang menyenangkan tetapi bisa ditunda). Langkah kedua adalah waspada terhadap penawaran investasi yang menjanjikan keuntungan tinggi tanpa risiko. Selalu periksa izin produk keuangan di situs OJK sebelum memutuskan investasi."}'::jsonb
WHERE id = '733bc7a1-db7b-41e0-b884-909606956be0'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Uang punya tiga fungsi utama: alat tukar, penyimpan nilai, dan satuan hitung. GoPay, OVO, atau saldo bank termasuk uang digital karena bisa dipakai untuk ketiga fungsi tersebut."}'::jsonb
WHERE id = '85b063c5-fa50-4b4e-bd8c-b932f6780689'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Define risiko tolerance → Set time horizon → Choose aset allocation → Select specific investments → Rebalance periodically", "options": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "parameters": {}, "question": "urutkan langkah-langkah to build an investasi portofolio:", "type": "ordering"}'::jsonb
WHERE id = '62631007-dfd5-4bd6-b4d3-a91b0b103553'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Currency depreciation and saham declines may be correlated", "difficulty": "advanced", "explanation": "Rupiah depreciation and saham market declines sering occur together during periods of foreign capital outflows and risiko aversion.", "options": ["Currency appreciation helps saham", "Currency depreciation and saham declines may be correlated", "saham and currency are unrelated", "Government controls both"], "parameters": {"image_description": "A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling."}, "question": "[IMAGE: A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling.]\n\nWhat relationship might this chart be illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = 'c4f3240e-037a-45bb-8fc5-e5ef2c49b43a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Most months are near average, extremes are rare", "difficulty": "advanced", "explanation": "The bell-shaped distribution with most data near the mean and fewer observations in the tails is characteristic of return distributions.", "options": ["Returns are normally distributed", "Returns are predictable", "Most months are near average, extremes are rare", "Every month is equally likely"], "parameters": {"image_description": "A histogram showing distribution of monthly returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%."}, "question": "[IMAGE: A histogram showing distribution of per bulan returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%.]\n\napa yang the shape of this distribution suggest about market returns?", "type": "image_interpretation"}'::jsonb
WHERE id = '6dfb90a6-b1e7-4955-a673-75065e4eb3a6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "periksa izin OJK", "difficulty": "advanced", "explanation": "The flowchart explicitly shows OJK license verification as the first decision point before any further action.", "options": ["Read the prospectus", "periksa izin OJK", "Calculate potential returns", "Ask friends for opinion"], "parameters": {"image_description": "A flowchart: Start → Check OJK license → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths."}, "question": "[IMAGE: A flowchart: Start → periksa izin OJK → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths.]\n\nWhat yang pertama checkpoint in this financial safety flowchart?", "type": "image_interpretation"}'::jsonb
WHERE id = 'f8e3533a-91ea-4ac0-b0f4-4e1bd48eabf3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 3M (20% of pendapatan)", "difficulty": "advanced", "explanation": "benar path: Rp 3M (20% of pendapatan). This represents the most financially sound decision at this stage.", "options": ["Rp 500K", "Rp 3M (20% of pendapatan)", "Rp 7.5M (50% of pendapatan)", "Nothing, spend freely"], "parameters": {"full_tree": {"scenario": "You are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.", "stages": [{"correct": "Rp 3M (20% of income)", "next": {"correct": "High-yield savings", "next": {"correct": "Money market fund", "options": ["Regular savings", "Money market fund", "Aggressive growth stocks", "Friends'' business"], "question": "After emergency fund, monthly surplus goes to house fund. Best vehicle?"}, "options": ["Crypto wallet", "High-yield savings", "Stock market", "Under mattress"], "question": "Where should you keep the emergency portion (3 months expenses = Rp 45M target)?"}, "options": ["Rp 500K", "Rp 3M (20% of income)", "Rp 7.5M (50% of income)", "Nothing, spend freely"], "question": "Month 1: How much should you save first?"}]}}, "question": "Decision Tree Scenario:\n\nYou are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.\n\nMonth 1: berapa banyak should you save first?", "type": "decision_tree"}'::jsonb
WHERE id = '297ae631-ee65-4cb2-81cf-55b2c01ff22c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "more", "difficulty": "advanced", "explanation": "beta measures sensitivity to market movements. beta 1.5 means 50% more volatile than the market.", "options": ["less", "more", "in the opposite direction", "independently"], "parameters": {}, "question": "A saham with a beta of 1.5 diharapkan bergerak ________ daripada pasar secara keseluruhan.", "type": "sentence_completion"}'::jsonb
WHERE id = '4eb0e004-ba0d-46ca-a7d8-b0e12e6d4f36'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "cheaper", "difficulty": "advanced", "explanation": "Currency depreciation makes domestic goods cheaper for foreign buyers, potentially boosting exports.", "options": ["more expensive", "cheaper", "unchanged in price", "illegal"], "parameters": {}, "question": "If a country''s currency depreciates, its export goods become ________ for foreign buyers.", "type": "sentence_completion"}'::jsonb
WHERE id = 'a78fb673-b96d-4d46-933d-5f65501308ac'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"inflasi Hedge": ["Gold", "riil estate", "inflasi-indexed obligasi", "saham portofolio"], "inflasi risiko": ["Cash under mattress", "Fixed deposit at 2%"], "Neutral": ["Foreign currency", "Collectibles"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"inflasi Hedge\": [\"Gold\", \"riil estate\", \"inflasi-indexed obligasi\", \"saham portofolio\"], \"inflasi risiko\": [\"Cash under mattress\", \"Fixed deposit at 2%\"], \"Neutral\": [\"Foreign currency\", \"Collectibles\"]}", "options": {"buckets": ["inflasi Hedge", "inflasi risiko", "Neutral"], "items": ["Gold", "Cash under mattress", "riil estate", "Fixed deposit at 2%", "inflasi-indexed obligasi", "saham portofolio", "Foreign currency", "Collectibles"]}, "parameters": {}, "question": "Classify each item based on its relationship with inflasi:", "type": "categorization"}'::jsonb
WHERE id = 'b36882e0-cec6-40fc-a6f6-7d28ce395d07'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Not an aset": ["Time with family", "Car (depreciating)", "Lifestyle sneakers"], "Risky Assets": ["Bitcoin", "Individual saham", "riil estate"], "Safe Assets": ["Bank deposit", "Government obligasi"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"Safe Assets\": [\"Bank deposit\", \"Government obligasi\"], \"Risky Assets\": [\"Bitcoin\", \"Individual saham\", \"riil estate\"], \"Not an aset\": [\"Time with family\", \"Car (depreciating)\", \"Lifestyle sneakers\"]}", "options": {"buckets": ["Safe Assets", "Risky Assets", "Not an aset"], "items": ["Bank deposit", "Bitcoin", "Time with family", "Government obligasi", "Individual saham", "Car (depreciating)", "riil estate", "Lifestyle sneakers"]}, "parameters": {}, "question": "Sort each item into the benar aset classification:", "type": "categorization"}'::jsonb
WHERE id = '20bc432b-3e4f-4cd8-a3d2-85f07a06c24f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice"], "difficulty": "advanced", "explanation": "investasi decisions should be based on research and fundamentals, not superstition or unverified tips.", "options": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invest based on my horoscope and the advice of a WhatsApp group admin who claims to have informasi orang dalam. I tidak pernah read financial statements.", "type": "spot_mistake"}'::jsonb
WHERE id = '95ce3494-0c07-4ce7-9ffc-9ae3440998dc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "provide financial security during crises", "difficulty": "advanced", "explanation": "Emergency funds prioritize likuiditas and safety over returns, providing a buffer for unexpected expenses.", "options": ["maximize returns", "provide financial security during crises", "beat inflasi", "fund vacations"], "parameters": {}, "question": "The primary purpose of an dana darurat is to ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '634f3e61-0bb5-40ef-a629-39b52b939c3f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs"], "difficulty": "advanced", "explanation": "Starting young maximizes compounding. Even small amounts invested early outperform larger amounts invested later.", "options": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI''m 22 and I think berinvestasi is hanya for old people. I''ll start when I have a ''riil job.'' My money stays in a checking account earning 0% bunga.", "type": "spot_mistake"}'::jsonb
WHERE id = '60e364f1-ea6b-4369-8e4e-8af882ef11d0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions"], "difficulty": "advanced", "explanation": "The disposition effect (selling winners, holding losers) and confirmation bias destroy long-term returns.", "options": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI sold my profitable saham to realize gains but kept my losing saham hoping they''d recover. I read one article that confirmed the losers would bounce back.", "type": "spot_mistake"}'::jsonb
WHERE id = '6d984136-f6bd-459c-a5fa-09c30500d21f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 2M from age 30", "difficulty": "advanced", "explanation": "Starting earlier gives compounding more time to work. Rp 2M × 30 years at 7% beats Rp 5M × 15 years.", "options": ["Rp 2M from age 30", "Rp 5M from age 45", "Both equal at retirement", "Neither is enough"], "parameters": {}, "question": "For retirement savings starting at age 30: is it better to save Rp 2M per bulan or Rp 5M per bulan starting at age 45?", "type": "comparison"}'::jsonb
WHERE id = '43e4780e-dddf-429a-9fd2-9588a0117c64'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Market ETF", "difficulty": "advanced", "explanation": "ETFs hold many saham, eliminating company-specific (unsystematic) risiko that single saham carry.", "options": ["Single saham", "Market ETF", "Both have same risiko", "risiko cannot be measured"], "parameters": {}, "question": "Compare the risiko: buying a single saham vs an ETF tracking the entire market. Which has lower unsystematic risiko?", "type": "comparison"}'::jsonb
WHERE id = '230700ca-4f5a-45cb-adce-be9b327a520c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Personal loan", "difficulty": "advanced", "explanation": "Credit card at 2.5% per bulan compounds to ~34.5% per tahun. Personal loan at 12% annual is far cheaper.", "options": ["Credit card", "Personal loan", "They are equal", "Depends on usage"], "parameters": {}, "question": "Between a credit card with 2.5% per bulan bunga and a personal loan with 12% annual bunga, which has lower effective cost?", "type": "comparison"}'::jsonb
WHERE id = '833e190b-cd72-4a87-b98c-39ca544d5174'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "1,600,000", "difficulty": "advanced", "explanation": "20% of 8,000,000 = 0.20 × 8,000,000 = Rp 1,600,000.", "parameters": {"hint": "Calculate 20% of the monthly income."}, "question": "You earn Rp 8M per bulan. Following the 50/30/20 rule, berapa banyak should go to savings and utang?", "type": "calculation"}'::jsonb
WHERE id = '1c8e5a2d-b370-4edb-baed-1663551e14c4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8.4%", "difficulty": "advanced", "explanation": "CAGR = (Ending Value / Beginning Value)^(1/n) - 1 = (150/100)^(1/5) - 1 ≈ 8.4%.", "parameters": {"hint": "Use the CAGR formula: (FV/PV)^(1/years) - 1."}, "question": "jika rp 100 juta tumbuh menjadi rp 150 juta dalam 5 tahun, berapakah perkiraan tingkat pertumbuhan tahunan majemuk (CAGR)?", "type": "calculation"}'::jsonb
WHERE id = 'b6577efd-49aa-4d02-b9e0-5bff4ef37933'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "advanced", "explanation": "P/E = Price per share / Earnings per share = 20,000 / 1,000 = 20.", "parameters": {"hint": "Divide stock price by earnings per share."}, "question": "A saham trades at Rp 20,000 with EPS of Rp 1,000. apa the rasio P/E?", "type": "calculation"}'::jsonb
WHERE id = 'e9728eee-be1a-4ccd-ac2c-908aa1d13136'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "advanced", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "A new e-wallet offers 10% cashback for the first month. Model the customer acquisition cost and churn risk."}, "question": "dompet digital baru menawarkan 10% cashback untuk bulan pertama. modelkan biaya akuisisi pelanggan dan risiko churn. apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = 'a209cffa-5e4d-4578-acf6-a59cf4773d55'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "advanced", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "Compare the effective cost of ''pay later'' schemes (0% interest, 2% admin fee) vs credit cards (2% monthly)."}, "question": "Compare the effective cost of ''pay later'' schemes (0% bunga, 2% admin fee) vs credit cards (2% per bulan). What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = 'c3aa5334-fa65-46de-9b84-0527ea3a8898'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "advanced", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "A fintech gamifies spending with cashback rewards. Users overspend by 30%. Analyze the behavioral mechanism."}, "question": "sebuah fintech menggamifikasi pengeluaran dengan reward cashback. Users overspend by 30%. analisis mekanisme perilakunya. Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = '23e27c0a-467b-4a24-812c-e4582866f0c8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"advanced Investor": "Uses derivatives, manages risiko", "beginner Investor": "Learns basics, uses deposits", "intermediate Investor": "Understands ratios, diversifies"}, "difficulty": "advanced", "explanation": "benar matches: beginner Investor → Learns basics, uses deposits, intermediate Investor → Understands ratios, diversifies, advanced Investor → Uses derivatives, manages risiko", "options": {"left": ["beginner Investor", "intermediate Investor", "advanced Investor"], "right": ["Learns basics, uses deposits", "Understands ratios, diversifies", "Uses derivatives, manages risiko"]}, "parameters": {}, "question": "Match each investor level with its characteristics:", "type": "matching"}'::jsonb
WHERE id = '839fbcb2-b858-4aae-acf5-6f41851868d4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"50/30/20 Rule": "anggaran allocation framework", "dollar cost averaging": "Regular fixed investments", "dana darurat": "3-6 months expense reserve", "rebalancing": "Adjusting portofolio weights"}, "difficulty": "advanced", "explanation": "Correct matches: 50/30/20 Rule → Budget allocation framework, Emergency Fund → 3-6 months expense reserve, Dollar Cost Averaging → Regular fixed investments, Rebalancing → Adjusting portfolio weights", "options": {"left": ["50/30/20 Rule", "dana darurat", "dollar cost averaging", "rebalancing"], "right": ["anggaran allocation framework", "3-6 months expense reserve", "Regular fixed investments", "Adjusting portofolio weights"]}, "parameters": {}, "question": "Match each strategy with its description:", "type": "matching"}'::jsonb
WHERE id = '6b7432e9-ed70-446f-ad27-054905e441f4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bunga majemuk": "bunga on bunga", "diversifikasi": "Spreading risiko across assets", "likuiditas": "Ease of converting to cash", "volatilitas": "Price fluctuation magnitude"}, "difficulty": "advanced", "explanation": "benar matches: likuiditas → Ease of converting to cash, volatilitas → Price fluctuation magnitude, diversifikasi → Spreading risiko across assets, bunga majemuk → bunga on bunga", "options": {"left": ["likuiditas", "volatilitas", "diversifikasi", "bunga majemuk"], "right": ["Ease of converting to cash", "Price fluctuation magnitude", "Spreading risiko across assets", "bunga on bunga"]}, "parameters": {}, "question": "Match each financial concept with its meaning:", "type": "matching"}'::jsonb
WHERE id = '1681af2c-51f2-426d-a331-32780beb24ca'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: pahami tingkat inflasi → periksa suku bunga tabungan → hitung return riil → pertimbangkan alternatif → sesuaikan strategi menabung", "options": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "parameters": {}, "question": "urutkan langkah-langkah untuk melindungi tabungan dari inflasi:", "type": "ordering"}'::jsonb
WHERE id = '2f9974cb-f9fc-4236-a2ae-5a7052497e5c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: buka rekening sekuritas → lengkapi proses kyc → setor dana → riset saham → tempatkan order pertama", "options": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "parameters": {}, "question": "urutkan langkah-langkah untuk mulai berinvestasi di saham indonesia:", "type": "ordering"}'::jsonb
WHERE id = '80051538-6d9e-4faa-b92b-996b2b1cf01f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kebutuhan", "keinginan"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: kebutuhan, keinginan.", "options": ["kebutuhan", "keinginan", "savings", "dana darurat"], "parameters": {}, "question": "Financial planning starts with distinguishing ________ from ________, then building reserves.", "type": "word_bank"}'::jsonb
WHERE id = 'ffdcf10b-9de2-448b-8af8-b7ad6cb88a71'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["FOMO", "aversi rugi"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: FOMO, aversi rugi.", "options": ["FOMO", "aversi rugi", "herd mentality", "confirmation bias"], "parameters": {}, "question": "Common behavioral biases include ________, ________, and following the crowd without research.", "type": "word_bank"}'::jsonb
WHERE id = '6a818924-d90a-48bd-97bf-17772956c2a6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["P/E ratio", "EPS"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: rasio P/E, EPS.", "options": ["P/E ratio", "EPS", "ROE", "kapitalisasi pasar"], "parameters": {}, "question": "Fundamental metrics like ________ and ________ help evaluate saham valuations.", "type": "word_bank"}'::jsonb
WHERE id = 'db8b7e72-bcd1-497f-89e2-5bf7027f2528'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Sharpe", "difficulty": "advanced", "explanation": "Therasio Sharpe helps investors understand return per unit of risiko taken.", "parameters": {}, "question": "The ________ ratio measures risiko-adjusted return by comparing excess return to volatilitas.", "type": "fill_blank"}'::jsonb
WHERE id = 'df74975a-0d22-4997-9273-25f436032ad3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emergency", "difficulty": "advanced", "explanation": "Emergency funds provide financial security during unforeseen circumstances like job loss or medical emergencies.", "parameters": {}, "question": "A ________ fund is money set aside specifically for unexpected expenses.", "type": "fill_blank"}'::jsonb
WHERE id = 'ba152142-3edb-4392-bd4e-5588d49917c5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "compound", "difficulty": "advanced", "explanation": "bunga majemuk accelerates kekayaan growth by earning returns on returns dari waktu ke waktu.", "parameters": {}, "question": "________ bunga means earning returns on both your original investasi and the accumulated returns.", "type": "fill_blank"}'::jsonb
WHERE id = '0c1d3a00-e5fd-4e2c-a7d2-cf38777d639d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "If a company is famous, its saham is selalu a good investasi.", "type": "true_false"}'::jsonb
WHERE id = '65e606e2-1128-4c52-93a7-c34676d6ac15'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "beginner", "explanation": "Otoritas Jasa Keuangan (OJK) mengawasi produk keuangan di Indonesia.", "parameters": {}, "question": "Sebelum berinvestasi, selalu periksa izin produk keuangan di situs ____.", "type": "fill_blank"}'::jsonb
WHERE id = '6c3d2d55-120f-49dd-a100-f2bca61614ec'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Check if fundamentals changed", "difficulty": "beginner", "explanation": "benar path: Check if fundamentals changed. This represents the most financially sound decision at this stage.", "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "parameters": {"full_tree": {"scenario": "The stock market drops 20% in one month. You have Rp 200M invested across 10 stocks.", "stages": [{"correct": "Check if fundamentals changed", "next": {"correct": "Hold and consider buying more", "next": {"correct": "Dollar cost average over 3 months", "options": ["All remaining cash at once", "Dollar cost average over 3 months", "Wait for ''the bottom''", "Borrow to invest"], "question": "You decide to buy more. Best approach?"}, "options": ["Panic sell to preserve capital", "Hold and consider buying more", "Switch to gold entirely", "Blame the government"], "question": "Fundamentals are intact. What action makes sense?"}, "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "question": "First reaction: What do you check?"}]}}, "question": "Decision Tree Scenario:\n\nThe saham market drops 20% in one month. You have Rp 200M invested across 10 saham.\n\nFirst reaction: What do you check?", "type": "decision_tree"}'::jsonb
WHERE id = '11a1f97f-200f-4799-bb4b-e8fdf8af42be'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Short-term volatilitas is normal, long-term trend matters", "difficulty": "beginner", "explanation": "The chart shows significant short-term drops but a long-term upward trend, illustrating why time in market beats timing the market.", "options": ["Markets selalu crash permanently", "Short-term volatilitas is normal, long-term trend matters", "Timing the market is easy", "Indonesian saham are too risky"], "parameters": {"image_description": "A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatility in 2022, steady climb in 2023-2024."}, "question": "[IMAGE: A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatilitas in 2022, steady climb in 2023-2024.]\n\napa yang this chart primarily demonstrate about long-term berinvestasi?", "type": "image_interpretation"}'::jsonb
WHERE id = '93b19bee-99d0-42e4-a8f2-e4c1729a21c6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "decreases", "difficulty": "beginner", "explanation": "riil return = nominal return - inflasi. If inflasi rises and nominal return is flat, riil return falls.", "options": ["increases", "decreases", "stays the same", "becomes irrelevant"], "parameters": {}, "question": "If inflasi rises while bunga rates stay flat, the riil return on savings ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'a13afdee-9447-4580-b1be-f8a2c1805729'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "24%", "difficulty": "beginner", "explanation": "Initial investment: 200 × 5,000 = 1,000,000. Final value: 200 × 6,200 = 1,240,000. Return = (1,240,000 - 1,000,000) / 1,000,000 = 24%.", "parameters": {"hint": "Calculate total initial cost, total final value, then percentage change."}, "question": "A saham costs Rp 5,000 per share. You buy 200 shares. After 1 year, the price is Rp 6,200. apa your percentage return?", "type": "calculation"}'::jsonb
WHERE id = '5c4d39ad-e4b9-40a8-b1df-55207636a052'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Bank resmi tidak pernah meminta PIN, password, atau kode OTP kepada nasabah.", "parameters": {}, "question": "Bank resmi akan meminta PIN ATM melalui WhatsApp untuk keamanan rekening.", "type": "true_false"}'::jsonb
WHERE id = '5cc92861-76c4-4d7b-8467-cbd2751d0ebb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Catat pemasukan", "Pisahkan kebutuhan & keinginan", "Sisihkan tabungan", "Evaluasi pengeluaran"], "difficulty": "beginner", "explanation": "Catat, pisahkan, tabung, lalu evaluasi adalah siklus pengelolaan uang yang sehat.", "options": ["Catat pemasukan", "Pisahkan kebutuhan & keinginan", "Sisihkan tabungan", "Evaluasi pengeluaran"], "parameters": {}, "question": "Susunlah urutan langkah sehat mengelola uang: ____", "type": "word_bank"}'::jsonb
WHERE id = '7eb56dbe-51e8-46f0-baca-a3ff3441b448'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Identify kebutuhan → Identify keinginan → Allocate 50% to kebutuhan → Allocate 30% to keinginan → Save 20%", "options": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "parameters": {}, "question": "urutkan langkah-langkah to apply the 50/30/20 anggaran rule:", "type": "ordering"}'::jsonb
WHERE id = '5a127b9f-9bf0-472c-9934-79520e8b55c8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: periksa izin OJK → Read the prospectus → Understand the risks → Start with small amount → Monitor regularly", "options": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "parameters": {}, "question": "Order the proper due diligence steps before berinvestasi:", "type": "ordering"}'::jsonb
WHERE id = '280de4ca-301e-4c74-b2fb-722eccb39d62'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Set financial goals → Track pendapatan and expenses → Create a anggaran → Build dana darurat → Start berinvestasi", "options": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "parameters": {}, "question": "Order these steps to build a solid financial foundation:", "type": "ordering"}'::jsonb
WHERE id = '4e9e5e5f-2653-4c9d-a448-f57b1b9204d6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "satuan hitung", "difficulty": "beginner", "explanation": "Satuan hitung membuat kita bisa menyatakan nilai barang dalam rupiah sehingga mudah membandingkan harga.", "question": "Fungsi uang sebagai _____ memungkinkan kita membandingkan harga berbagai barang dengan mudah.", "type": "fill_blank"}'::jsonb
WHERE id = '6f90ed04-f80c-478d-a14c-f1c6b8ae4ec8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena uang bisa ditukar dengan barang apa saja yang dijual", "difficulty": "beginner", "explanation": "Uang diterima umum, jadi kita tidak perlu mencari orang yang kebetulan membutuhkan barang kita.", "options": ["Karena uang bisa ditukar dengan barang apa saja yang dijual", "Karena uang terbuat dari logam mulia", "Karena barter lebih cepat", "Karena uang tidak bisa hilang"], "question": "Mengapa uang lebih praktis daripada barter?", "type": "multiple_choice"}'::jsonb
WHERE id = '0a4c0ef1-8387-487f-a33d-4536d2064060'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Menjanjikan keuntungan tinggi tanpa risiko", "difficulty": "beginner", "explanation": "Penawaran investasi ilegal sering menjanjikan imbal hasil tinggi dan mengklaim tanpa risiko. Selalu periksa izin di situs OJK.", "options": ["Menjanjikan keuntungan tinggi tanpa risiko", "Terdaftar dan diawasi OJK", "Memberikan laporan keuangan berkala", "Produknya mudah dipahami"], "parameters": {}, "question": "Apa ciri umum penawaran investasi ilegal yang perlu diwaspadai?", "type": "multiple_choice"}'::jsonb
WHERE id = 'c9880606-0acc-45e2-8bd6-b9b18096fc38'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Menyisihkan sisa uang untuk tabungan darurat adalah kebiasaan keuangan yang baik.", "parameters": {}, "question": "Uang sisa setelah memenuhi kebutuhan sebaiknya ditabung untuk keperluan mendesak.", "type": "true_false"}'::jsonb
WHERE id = '86053d43-11ff-4b24-be42-30c9f573809a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan", "difficulty": "beginner", "explanation": "Kebutuhan adalah pengeluaran penting yang harus diprioritaskan, berbeda dengan keinginan yang bisa ditunda.", "parameters": {}, "question": "Sesuatu yang harus dipenuhi untuk hidup dan belajar disebut _____.", "type": "fill_blank"}'::jsonb
WHERE id = 'f5641316-d243-43e4-bab7-042556269c2f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["OJK"], "difficulty": "beginner", "explanation": "Otoritas Jasa Keuangan (OJK) mengawasi produk dan perusahaan keuangan di Indonesia.", "options": ["OJK", "BI"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Sebelum menanamkan uang, pastikan perusahaan telah terdaftar dan diawasi oleh _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '5946e30e-bfc2-44b7-92b2-ef051668faa6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Catat pemasukan", "Pisahkan kebutuhan dan keinginan", "Sisihkan tabungan", "Gunakan sisa untuk keinginan secara terukur"], "difficulty": "beginner", "explanation": "Catat pemasukan, pahami prioritas, sisihkan tabungan, baru gunakan sisa untuk keinginan.", "options": ["Catat pemasukan", "Pisahkan kebutuhan dan keinginan", "Sisihkan tabungan", "Gunakan sisa untuk keinginan secara terukur"], "parameters": {}, "question": "Urutkan langkah mengelola uang saku dengan bijak.", "type": "ordering"}'::jsonb
WHERE id = 'dbe23cdc-4a80-4950-afd2-34e28d57a603'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pulsa dan kuota internet untuk kelas online", "difficulty": "beginner", "explanation": "Pulsa dan kuota internet mendukung kegiatan belajar, sehingga termasuk kebutuhan.", "options": ["Tiket konser K-pop", "Pulsa dan kuota internet untuk kelas online", "Skin game terbaru", "Kopi di kafe hipster"], "parameters": {}, "question": "Manakah yang paling termasuk kebutuhan untuk pelajar Indonesia?", "type": "multiple_choice"}'::jsonb
WHERE id = '25846500-0b82-4af4-9258-4b895f0e87d7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Penawaran dengan imbal hasil tinggi dan jaminan tanpa risiko adalah ciri umum investasi ilegal. Selalu periksa izin OJK.", "parameters": {}, "question": "Investasi yang menjanjikan imbal hasil tinggi dan dijamin aman tanpa risiko biasanya dapat dipercaya.", "type": "true_false"}'::jsonb
WHERE id = '5de2b587-a0f8-43d3-9eef-e4758b9acfa3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Membedakan kebutuhan dan keinginan", "difficulty": "beginner", "explanation": "Membedakan kebutuhan dan keinginan adalah fondasi dasar pengelolaan uang.", "options": ["Membeli aset sebanyak-banyaknya", "Membedakan kebutuhan dan keinginan", "Mencari pinjaman online", "Ikut investasi teman"], "parameters": {}, "question": "Langkah pertama mengelola uang dengan bijak adalah?", "type": "multiple_choice"}'::jsonb
WHERE id = '3134c519-24c7-4e38-822c-be9ac7030e78'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Bayar kebutuhan", "Sisihkan tabungan", "Penuhi keinginan jika ada sisa", "Periksa izin investasi sebelum menanamkan uang"], "difficulty": "beginner", "explanation": "Prioritaskan kebutuhan, lalu tabungan, baru keinginan. Investasi hanya setelah izin diverifikasi.", "options": ["Bayar kebutuhan", "Sisihkan tabungan", "Penuhi keinginan jika ada sisa", "Periksa izin investasi sebelum menanamkan uang"], "parameters": {}, "question": "Urutkan langkah berikut dari yang paling penting hingga paling akhir.", "type": "ordering"}'::jsonb
WHERE id = 'a35de4b3-882f-449e-80a4-a37df7854815'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kebutuhan", "keinginan"], "difficulty": "beginner", "explanation": "Membedakan kebutuhan dan keinginan adalah langkah awal mengelola uang.", "options": ["kebutuhan", "keinginan"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Sebelum membeli barang baru, tanyakan pada diri sendiri: apakah ini _____ atau _____?\"", "type": "word_bank"}'::jsonb
WHERE id = 'ab75d712-0dbe-47fc-9e36-752ac747a93c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "beginner", "explanation": "Otoritas Jasa Keuangan (OJK) mengatur dan mengawasi produk keuangan di Indonesia.", "parameters": {}, "question": "Sebelum berinvestasi, periksa terlebih dahulu izin perusahaan di situs _____.", "type": "fill_blank"}'::jsonb
WHERE id = '455b7871-3f75-42d6-bc27-f8dafdef2518'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Penawaran dengan imbal hasil tinggi dan jaminan tanpa risiko adalah ciri umum investasi ilegal. Selalu periksa izin OJK.", "parameters": {}, "question": "Investasi yang menjanjikan imbal hasil tinggi dan \"dijamin\" aman tanpa risiko biasanya dapat dipercaya.", "type": "true_false"}'::jsonb
WHERE id = 'd4801a9c-2e38-4160-b5cb-dabf5ebafba0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pulsa dan kuota internet untuk kelas online", "difficulty": "beginner", "explanation": "Pulsa dan kuota internet mendukung kegiatan belajar, sehingga termasuk kebutuhan.", "options": ["Tiket konser", "Pulsa dan kuota internet untuk kelas online", "Skin game terbaru", "Kopi di kafe"], "parameters": {}, "question": "Manakah yang termasuk kebutuhan bagi pelajar Indonesia?", "type": "multiple_choice"}'::jsonb
WHERE id = '1e8cd781-0892-490d-9bb2-86dc2b4a1d14'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Cek izin di OJK dan diskusikan dengan orang dewasa", "difficulty": "beginner", "explanation": "Verifikasi izin OJK dan konsultasi membantu menghindari investasi bodong.", "options": ["Langsung transfer segera", "Cek izin di OJK dan diskusikan dengan orang dewasa", "Ajak semua teman ikut", "Pinjam uang untuk ikut"], "parameters": {}, "question": "Apa yang sebaiknya dilakukan jika ada penawaran investasi mencurigakan?", "type": "multiple_choice"}'::jsonb
WHERE id = '4264992d-c335-40c5-ab99-867504b5fe74'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mencatat pemasukan dan pengeluaran", "difficulty": "beginner", "explanation": "Mencatat keuangan membantu kita memahami dan mengontrol aliran uang.", "options": ["Belanja setiap hari tanpa catatan", "Mencatat pemasukan dan pengeluaran", "Ikut pinjaman online untuk gaya hidup", "Transfer uang ke nomor yang dikirim via WA"], "parameters": {}, "question": "Kebiasaan mana yang paling mendukung kesehatan keuangan?", "type": "multiple_choice"}'::jsonb
WHERE id = '16cad133-49ba-4efe-8eba-bbdd64ef8a56'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Saldo elektronik tetap diakui sebagai alat tukar dan satuan hitung, sehingga termasuk bentuk uang digital.", "question": "Saldo GoPay atau OVO tidak termasuk uang karena tidak berbentuk uang kertas.", "type": "true_false"}'::jsonb
WHERE id = '1be59258-3ac0-41ec-acf5-2317e09bee81'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "dollar cost averaging", "difficulty": "beginner", "explanation": "DCA spreads purchases dari waktu ke waktu, reducing the impact of berinvestasi at a market peak.", "options": ["lump sum berinvestasi", "dollar cost averaging", "Both eliminate timing risiko", "Neither helps"], "parameters": {}, "question": "Compare lump sum berinvestasi vs dollar cost averaging (DCA) in a volatile market. Which typically reduces timing risiko?", "type": "comparison"}'::jsonb
WHERE id = '941e381b-82c4-4819-96a8-413f119993f9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Start berinvestasi early", "difficulty": "beginner", "explanation": "At a young age, the power of compounding favors starting investments early, while low-bunga loans can be managed alongside.", "options": ["Pay off loans first completely", "Start berinvestasi early", "Do neither, spend on experiences", "Split equally"], "parameters": {}, "question": "For a 25-year-old with stable pendapatan: is it better to prioritize paying off low-bunga student loans or start berinvestasi early?", "type": "comparison"}'::jsonb
WHERE id = '4a910cc8-399b-4b4e-a178-36da49449b81'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK-licensed bank deposit", "difficulty": "beginner", "explanation": "Licensed deposits are regulated and insured. Unlicensed platforms carry penipuan risiko and no investor protection.", "options": ["OJK-licensed bank deposit", "Unlicensed P2P platform", "Both equally safe", "Cannot determine"], "parameters": {}, "question": "Which is generally safer: keeping Rp 50M in an OJK-licensed bank deposit or berinvestasi in an unlicensed P2P platform promising 15% returns?", "type": "comparison"}'::jsonb
WHERE id = '92926cc4-a958-48b9-b631-ba88c41f7b7c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan vs keinginan", "difficulty": "beginner", "explanation": "Understanding kebutuhan versus keinginan is fundamental to anggaran and menabung.", "parameters": {}, "question": "The concept of ________ helps individuals distinguish between essential and non-essential spending.", "type": "fill_blank"}'::jsonb
WHERE id = '83bba410-b64a-4fbc-adf5-e9d4e7118a63'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Bayar UKT", "Makan dan transport", "Tabungan darurat", "Tiket konser"], "difficulty": "beginner", "explanation": "Prioritas utama adalah kebutuhan pendidikan, makan/transport, tabungan, baru keinginan.", "options": ["Tabungan darurat", "Makan dan transport", "Tiket konser", "Bayar UKT"], "parameters": {}, "question": "Urutkan prioritas penggunaan uang saku dari yang paling penting:", "type": "ordering"}'::jsonb
WHERE id = '9af6e436-69d3-4617-89bd-18d8a614169d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "saham have historically outpaced inflasi", "difficulty": "beginner", "explanation": "The chart shows that while savings lose daya beli to inflasi, equities have historically provided returns that exceed inflasi.", "options": ["Savings accounts beat inflasi", "saham have historically outpaced inflasi", "semua investments are equal", "Cash yang terbaik store of value"], "parameters": {"image_description": "A bar chart comparing inflation rate (3%) vs savings account interest (2%) vs stock market average return (10%) over 10 years."}, "question": "[IMAGE: A bar chart comparing inflasi rate (3%) vs savings account bunga (2%) vs saham market average return (10%) over 10 years.]\n\nWhat key insight does this comparison reveal?", "type": "image_interpretation"}'::jsonb
WHERE id = 'f5b3b3b7-c76e-4878-bf0a-8072f7747592'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Moderate risiko tolerance", "difficulty": "beginner", "explanation": "A 50/30/15/5 split between saham, obligasi, cash, and gold represents balanced risiko — neither too conservative nor too aggressive.", "options": ["Ultra-conservative", "Moderate risiko tolerance", "Aggressive growth seeker", "Speculative trader"], "parameters": {"image_description": "A pie chart showing asset allocation: 50% stocks, 30% bonds, 15% cash, 5% gold. Labels show this is a moderate risk portfolio."}, "question": "[IMAGE: A pie chart showing aset allocation: 50% saham, 30% obligasi, 15% cash, 5% gold. Labels show this is a moderate risiko portofolio.]\n\nWhat type of investor does this aset allocation most likely represent?", "type": "image_interpretation"}'::jsonb
WHERE id = '0b7da416-77e7-4ef9-9fa8-a2f853b4d97b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Biaya kesehatan atau keperluan mendesak", "difficulty": "beginner", "explanation": "Dana darurat digunakan untuk kebutuhan tak terduga, bukan keinginan.", "options": ["Beli gadget baru", "Biaya kesehatan atau keperluan mendesak", "Liburan ke Bali", "Semua jawaban benar"], "parameters": {}, "question": "Dana darurat penting untuk?", "type": "multiple_choice"}'::jsonb
WHERE id = '83f9de68-4479-45df-b70a-df1b88367a1e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "A market condition where prices are falling or expected to fall", "pasar bullish": "A market condition where prices are rising or expected to rise", "koreksi": "A decline of 10% or more from a recent peak", "crash": "A sudden dramatic decline of 20% or more in saham prices"}, "difficulty": "beginner", "explanation": "benar matches: pasar bullish = A market condition where prices are rising or expected to rise, pasar bearish = A market condition where prices are falling or expected to fall, koreksi = A decline of 10% or more from a recent peak, crash = A sudden dramatic decline of 20% or more in saham prices", "options": {"definitions": ["A market condition where prices are rising or expected to rise", "A market condition where prices are falling or expected to fall", "A decline of 10% or more from a recent peak", "A sudden dramatic decline of 20% or more in saham prices"], "terms": ["pasar bullish", "pasar bearish", "koreksi", "crash"]}, "parameters": {}, "question": "Match each market term with its description:", "type": "definition_match"}'::jsonb
WHERE id = '52572775-5603-4e00-aac5-a7e53ce25485'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Dividend Yield": "Annual dividend per share divided by saham price", "EPS": "Net pendapatan divided by number of outstanding shares", "P/E Ratio": "Market price per share divided by earnings per share", "ROE": "Net pendapatan divided by shareholders'' equity"}, "difficulty": "beginner", "explanation": "benar matches: rasio P/E = Market price per share divided by earnings per share, EPS = Net pendapatan divided by number of outstanding shares, ROE = Net pendapatan divided by shareholders'' equity, Dividend Yield = Annual dividend per share divided by saham price", "options": {"definitions": ["Market price per share divided by earnings per share", "Net pendapatan divided by number of outstanding shares", "Net pendapatan divided by shareholders'' equity", "Annual dividend per share divided by saham price"], "terms": ["P/E Ratio", "EPS", "ROE", "Dividend Yield"]}, "parameters": {}, "question": "Match each financial metric with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '20c6c2b1-8053-46e1-b559-b1b7f037d207'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "69,770,000", "difficulty": "beginner", "explanation": "Using the future value of an annuity formula: FV = PMT × [(1+r)^n - 1]/r. With r = 0.5% per bulan, n = 60, PMT = 1,000,000. FV ≈ Rp 69.77M.", "parameters": {"hint": "Use FV annuity formula with monthly compounding."}, "question": "If you save Rp 1,000,000 per bulan at 6% annual bunga compounded per bulan, berapa banyak will you have after 5 years?", "type": "calculation"}'::jsonb
WHERE id = '3430c00f-ede6-4331-95cf-ea29554437fc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["menabung", "anggaran"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: menabung, anggaran.", "options": ["menabung", "anggaran", "berinvestasi", "spending"], "parameters": {}, "question": "Before ________, you should selalu create a ________ to plan your pendapatan and expenses.", "type": "word_bank"}'::jsonb
WHERE id = 'fca51716-7491-4935-9e82-809a9a006bca'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Alat tukar": "Bayar mie ayam pakai Rp15.000", "Penyimpan nilai": "Menabung Rp500.000 untuk beli sepatu bulan depan", "Satuan hitung": "Harga pulpen Rp3.000 dan buku Rp50.000"}, "difficulty": "beginner", "explanation": "Fungsi uang membantu kita memahami mengapa uang kertas, koin, maupun saldo digital bisa dipakai dalam kehidupan sehari-hari.", "pairs": [["Alat tukar", "Bayar mie ayam pakai Rp15.000"], ["Penyimpan nilai", "Menabung Rp500.000 untuk beli sepatu bulan depan"], ["Satuan hitung", "Harga pulpen Rp3.000 dan buku Rp50.000"]], "question": "Pasangkan fungsi uang dengan contohnya.", "type": "matching"}'::jsonb
WHERE id = 'de142f5d-3207-4b06-92fc-0c9e3021b81c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "fall", "difficulty": "beginner", "explanation": "obligasi prices and bunga rates have an inverse relationship. Higher rates mean existing obligasi are less attractive.", "options": ["rise", "fall", "remain unchanged", "become more volatile"], "parameters": {}, "question": "When the central bank raises bunga rates, obligasi prices generally ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'd5ff616b-87d7-4775-b8f5-8f5e33d5aa92'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "menabung money under your mattress is selalu better than bank deposits.", "type": "true_false"}'::jsonb
WHERE id = '8d4720b2-3b9b-4ce0-b233-47ec47c7a786'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy"], "difficulty": "beginner", "explanation": "Emotional trading, no strategy, and social media tips are unreliable sources of investasi decisions.", "options": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI check my saham portofolio every hour and sell whenever it drops more than 2%. I juga buy whatever saham is trending on social media.", "type": "spot_mistake"}'::jsonb
WHERE id = '1b4ea261-75f8-4145-a84d-fad259518cd7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals"], "difficulty": "beginner", "explanation": "anggaran is upside-down, savings insufficient, and emergency funds must be liquid and safe.", "options": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy anggaran allocates 70% to keinginan, 20% to kebutuhan, and 10% to savings. I juga keep my dana darurat in cryptocurrency for higher returns.", "type": "spot_mistake"}'::jsonb
WHERE id = 'b07af66b-f7ba-441f-a953-bfb753cf3a13'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time"], "difficulty": "beginner", "explanation": "Multiple errors: no diversifikasi, no due diligence, unrealistic return expectations, and unverified broker.", "options": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invested semua my savings in one saham karena my friend said it was a ''sure thing.'' I juga didn''t check if the broker was OJK-licensed. I''m sure I''ll double my money in 3 months!", "type": "spot_mistake"}'::jsonb
WHERE id = 'd0d2fd2b-9ab3-4200-8965-9b46d98c0840'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "beginner", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "You see an Instagram ad promising double your money in a week. What is the red flag?"}, "question": "You see an Instagram ad promising double your money in a week. apa the red flag? What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = '25147a49-e4f2-41da-a492-f32fc5c0b619'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "beginner", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "You receive Rp 500,000 as a gift. How should you allocate it?"}, "question": "You receive Rp 500,000 as a gift. How should you allocate it? Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = 'f6ddafca-22cc-4166-9930-1a236541ab94'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "beginner", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "A friend offers you 50% guaranteed monthly returns on an investment. What do you do?"}, "question": "A friend offers you 50% guaranteed per bulan returns on an investasi. What do you do? apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = 'e79d30a6-c6b1-407b-97a7-cf054f76c9f7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "9", "difficulty": "beginner", "explanation": "Rule of 72: Years to double = 72 / interest rate. 72 / 8 = 9 years.", "parameters": {"hint": "Divide 72 by the annual return percentage."}, "question": "Using the Rule of 72, how many years does it take to double money at 8% annual return?", "type": "calculation"}'::jsonb
WHERE id = '96be6c1c-451d-4496-8589-84094302eec7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Imbal hasil tinggi dengan jaminan aman", "difficulty": "beginner", "explanation": "Imbal hasil tinggi dengan jaminan aman adalah ciri khas investasi bodong.", "options": ["Bunga rendah dan stabil", "Imbal hasil tinggi dengan jaminan aman", "Terdaftar di OJK", "Memiliki kantor fisik jelas"], "parameters": {}, "question": "Ciri investasi bodong yang paling umum adalah?", "type": "multiple_choice"}'::jsonb
WHERE id = '11626cdd-14d6-4df2-bde0-798b1cc3081b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["inflasi", "deflation"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: inflasi, deflation.", "options": ["inflasi", "deflation", "stagflation", "hyperinflation"], "parameters": {}, "question": "________ occurs when prices rise across the economy, while ________ is when prices fall.", "type": "word_bank"}'::jsonb
WHERE id = '6f07d997-3c54-4081-9d75-ae9e5fe0b339'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["saham", "obligasi"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: saham, obligasi.", "options": ["saham", "obligasi", "mutual funds", "deposits"], "parameters": {}, "question": "A balanced portofolio might include ________, ________, and other aset classes.", "type": "word_bank"}'::jsonb
WHERE id = 'f8131102-af3e-4efc-8958-5a5c1cf1e7ef'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lower", "difficulty": "beginner", "explanation": "diversifikasi reduces unsystematic (company-specific) risiko without sacrificing expected returns.", "options": ["higher", "lower", "equal", "unpredictable"], "parameters": {}, "question": "A diversified portofolio typically has ________ risiko than a concentrated portofolio with the same expected return.", "type": "sentence_completion"}'::jsonb
WHERE id = 'e46c723f-baf9-4750-ac77-1d133d888833'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "beginner", "explanation": "The 50/30/20 rule allocates 50% to kebutuhan, 30% to keinginan, and 20% to savings and utang.", "parameters": {}, "question": "The 50/30/20 rule suggests allocating ________ percent of pendapatan to savings and utang repayment.", "type": "fill_blank"}'::jsonb
WHERE id = '1df1a68e-b11c-4b58-8949-25f108e8ae2d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2.5", "difficulty": "beginner", "explanation": "BI''s inflasi target is approximately 2.5% with a tolerance band of ±1%.", "parameters": {}, "question": "Bank Indonesia targets inflation around ________ percent per year.", "type": "fill_blank"}'::jsonb
WHERE id = 'b58d46f5-db19-4baa-a5b0-fb93a86adbb3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "General price fall", "Hyperinflation": "Extreme rapid price rise", "inflasi": "General price rise", "Stagflation": "High inflasi + stagnation"}, "difficulty": "beginner", "explanation": "benar matches: inflasi → General price rise, Deflation → General price fall, Stagflation → High inflasi + stagnation, Hyperinflation → Extreme rapid price rise", "options": {"left": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"], "right": ["General price rise", "General price fall", "High inflasi + stagnation", "Extreme rapid price rise"]}, "parameters": {}, "question": "Match each economic condition with its definition:", "type": "matching"}'::jsonb
WHERE id = '49122fbe-19c8-4562-a216-d8d11470cee7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"BI": "Central bank", "IDX": "saham exchange", "OJK": "Financial regulator", "SIPF": "Investor protection fund"}, "difficulty": "beginner", "explanation": "benar matches: OJK → Financial regulator, BI → Central bank, IDX → saham exchange, SIPF → Investor protection fund", "options": {"left": ["OJK", "BI", "IDX", "SIPF"], "right": ["Financial regulator", "Central bank", "saham exchange", "Investor protection fund"]}, "parameters": {}, "question": "Match each Indonesian financial institution with its primary function:", "type": "matching"}'::jsonb
WHERE id = '09e42f81-a209-4b87-b874-42c606afbf57'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "memulai lebih awal dan konsisten", "difficulty": "intermediate", "explanation": "waktu di pasar and kontribusi konsisten jauh lebih penting daripada memilih saham or menentukan waktu pasar.", "options": ["memilih saham terbaik", "memulai lebih awal dan konsisten", "menentukan waktu pasar dengan sempurna", "memiliki informasi orang dalam"], "parameters": {}, "question": "faktor paling penting in membangun kekayaan melalui investasi is ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'bde6cf7f-8f47-4164-8aca-9ff87b35a7d4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "A sustained decrease in the general price level", "Hyperinflation": "Extremely rapid and out-of-control price increases", "inflasi": "A sustained increase in the general price level of goods and services", "Stagflation": "A period of high inflasi combined with economic stagnation"}, "difficulty": "intermediate", "explanation": "benar matches: inflasi = A sustained increase in the general price level of goods and services, Deflation = A sustained decrease in the general price level, Stagflation = A period of high inflasi combined with economic stagnation, Hyperinflation = Extremely rapid and out-of-control price increases", "options": {"definitions": ["A sustained increase in the general price level of goods and services", "A sustained decrease in the general price level", "A period of high inflasi combined with economic stagnation", "Extremely rapid and out-of-control price increases"], "terms": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"]}, "parameters": {}, "question": "Match each economic term with its benar definition:", "type": "definition_match"}'::jsonb
WHERE id = '8a7d0162-6254-4cf3-91e6-6da11632bb7e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"alpha": "Excess return relative to a benchmark", "beta": "Sensitivity of a saham''s returns to market movements", "Sharpe Ratio": "risiko-adjusted return measuring excess return per unit of risiko", "Standard Deviation": "A measure of the dispersion of returns around the mean"}, "difficulty": "intermediate", "explanation": "benar matches: alpha = Excess return relative to a benchmark, beta = Sensitivity of a saham''s returns to market movements, Sharpe Ratio = risiko-adjusted return measuring excess return per unit of risiko, Standard Deviation = A measure of the dispersion of returns around the mean", "options": {"definitions": ["Excess return relative to a benchmark", "Sensitivity of a saham''s returns to market movements", "risiko-adjusted return measuring excess return per unit of risiko", "A measure of the dispersion of returns around the mean"], "terms": ["alpha", "beta", "Sharpe Ratio", "Standard Deviation"]}, "parameters": {}, "question": "Match each risiko/return measure with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '4cf2928b-ffa7-4c59-adc6-bf0b6c5bab61'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Leverage": "The use of borrowed capital to increase potential returns", "likuiditas": "The ease with which an aset can be converted to cash", "Solvency": "The ability to meet long-term financial obligations", "volatilitas": "The degree of variation in trading prices dari waktu ke waktu"}, "difficulty": "intermediate", "explanation": "benar matches: likuiditas = The ease with which an aset can be converted to cash, Solvency = The ability to meet long-term financial obligations, Leverage = The use of borrowed capital to increase potential returns, volatilitas = The degree of variation in trading prices dari waktu ke waktu", "options": {"definitions": ["The ease with which an aset can be converted to cash", "The ability to meet long-term financial obligations", "The use of borrowed capital to increase potential returns", "The degree of variation in trading prices dari waktu ke waktu"], "terms": ["likuiditas", "Solvency", "Leverage", "volatilitas"]}, "parameters": {}, "question": "Match each financial concept with its definition:", "type": "definition_match"}'::jsonb
WHERE id = '928f798e-2806-42a0-a65f-cd51a3117b63'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Investments": ["per bulan SIP", "saham purchase"], "kebutuhan": ["Rent payment", "Groceries"], "Savings": ["dana darurat deposit"], "keinginan": ["Netflix subscription", "Gym membership", "New sneakers"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"kebutuhan\": [\"Rent payment\", \"Groceries\"], \"keinginan\": [\"Netflix subscription\", \"Gym membership\", \"New sneakers\"], \"Savings\": [\"dana darurat deposit\"], \"Investments\": [\"per bulan SIP\", \"saham purchase\"]}", "options": {"buckets": ["kebutuhan", "keinginan", "Savings", "Investments"], "items": ["Rent payment", "Netflix subscription", "per bulan SIP", "dana darurat deposit", "Gym membership", "Groceries", "New sneakers", "saham purchase"]}, "parameters": {}, "question": "Categorize each item into the appropriate anggaran bucket:", "type": "categorization"}'::jsonb
WHERE id = '13053353-f68a-402b-a084-4fb1a80a88e1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Long Term": ["Retirement savings", "Children''s education", "Estate planning"], "Medium Term": ["House down payment (3 years)", "Car purchase (1 year)"], "Short Term": ["dana darurat", "Next month''s rent", "Vacation fund"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"Short Term\": [\"dana darurat\", \"Next month''s rent\", \"Vacation fund\"], \"Medium Term\": [\"House down payment (3 years)\", \"Car purchase (1 year)\"], \"Long Term\": [\"Retirement savings\", \"Children''s education\", \"Estate planning\"]}", "options": {"buckets": ["Short Term", "Medium Term", "Long Term"], "items": ["dana darurat", "House down payment (3 years)", "Retirement savings", "Next month''s rent", "Car purchase (1 year)", "Children''s education", "Vacation fund", "Estate planning"]}, "parameters": {}, "question": "Organize each financial tujuan by its typical time horizon:", "type": "categorization"}'::jsonb
WHERE id = '57359092-6cb9-4631-9dfa-394e4d364568'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bias perilaku": ["FOMO buying", "Holding losers too long", "aversi rugi", "Confirmation bias"], "Market Condition": ["pasar bullish", "pasar bearish"], "Rational Strategy": ["rebalancing per tahun", "DCA berinvestasi"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"bias perilaku\": [\"FOMO buying\", \"Holding losers too long\", \"aversi rugi\", \"Confirmation bias\"], \"Rational Strategy\": [\"rebalancing per tahun\", \"DCA berinvestasi\"], \"Market Condition\": [\"pasar bullish\", \"pasar bearish\"]}", "options": {"buckets": ["bias perilaku", "Rational Strategy", "Market Condition"], "items": ["FOMO buying", "rebalancing per tahun", "pasar bullish", "Holding losers too long", "DCA berinvestasi", "aversi rugi", "pasar bearish", "Confirmation bias"]}, "parameters": {}, "question": "Identify whether each item represents a bias perilaku, rational strategy, or market condition:", "type": "categorization"}'::jsonb
WHERE id = '4f569b31-4452-4cc1-9cfa-04535cd86517'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "aversi rugi", "difficulty": "intermediate", "explanation": "aversi rugi is a key concept in behavioral finance where losses hurt about twice as much as gains feel good.", "parameters": {}, "question": "The tendency to feel losses more intensely than equivalent gains disebut ________.", "type": "fill_blank"}'::jsonb
WHERE id = 'eed66247-68d2-41a3-8567-4d14f6120422'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "IDX", "difficulty": "intermediate", "explanation": "Bursa Efek Indonesia (IDX) is the national saham exchange of Indonesia.", "parameters": {}, "question": "________ is the Indonesian saham exchange where companies list their shares.", "type": "fill_blank"}'::jsonb
WHERE id = '1f8d3c36-adc8-4be3-a8c6-aa825135baa1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif"], "difficulty": "intermediate", "explanation": "tanpa pencatatan dan anggaran, pengeluaran mudah melebihi pendapatan tanpa disadari.", "options": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI don''t need to anggaran karena I can selalu check my e-wallet balance. I have 5 different e-wallets and I''m not sure berapa banyak I spend total each month.", "type": "spot_mistake"}'::jsonb
WHERE id = '58d059ae-fb28-4446-9aef-87e4666e3b72'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest"], "difficulty": "intermediate", "explanation": "Credit card utang at 2.5% per bulan compounds to devastating levels. Minimum payments prolong utang for years.", "options": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI use my credit card for semua purchases karena I get cashback. I hanya pay the minimum balance each month. I have Rp 50M in credit card utang.", "type": "spot_mistake"}'::jsonb
WHERE id = '8c0a9ce4-5a62-46cb-b838-db930379b980'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money"], "difficulty": "intermediate", "explanation": "This exhibits classic Ponzi scheme warning signs: guaranteed high returns, secrecy, and pressure to act fast.", "options": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI put semua my money in a ''guaranteed 20% per bulan return'' scheme. The person running it says it''s secret and I shouldn''t tell anyone. I signed up immediately.", "type": "spot_mistake"}'::jsonb
WHERE id = 'd59e6b3c-f1c3-449f-a491-9be60573c047'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "intermediate", "explanation": "Otoritas Jasa Keuangan (OJK) is Indonesia''s financial services authority.", "parameters": {}, "question": "The organization that regulates financial services di Indonesia is abbreviated as ________.", "type": "fill_blank"}'::jsonb
WHERE id = '679d1230-376e-403d-9697-e926bcb4c700'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Index fund berinvestasi", "difficulty": "intermediate", "explanation": "Index funds offer instant diversifikasi, lower fees, and require less research and monitoring.", "options": ["Active memilih saham", "Index fund berinvestasi", "Both require equal expertise", "Neither is good for beginners"], "parameters": {}, "question": "Compare active memilih saham vs index fund berinvestasi for a beginner with limited time. Which is more suitable?", "type": "comparison"}'::jsonb
WHERE id = 'ae70c6c4-145f-4ae7-a665-ad5cb62f4bb8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "High-yield savings account", "difficulty": "intermediate", "explanation": "Emergency funds need likuiditas and capital preservation, which savings accounts provide better than volatile saham.", "options": ["High-yield savings account", "saham portofolio", "Both equally appropriate", "Cryptocurrency wallet"], "parameters": {}, "question": "For emergency funds: is a high-yield savings account or a saham portofolio more appropriate?", "type": "comparison"}'::jsonb
WHERE id = '75c77c01-b17e-4d4b-9c86-5e72fdc6987c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mixed aset classes", "difficulty": "intermediate", "explanation": "diversifikasi across aset classes, sectors, and geographies reduces concentration risiko.", "options": ["100% banking stocks", "Mixed aset classes", "Both are equally diversified", "diversifikasi does not matter"], "parameters": {}, "question": "Which portofolio is likely more diversified: 100% Indonesian banking saham or a mix of Indonesian saham, obligasi, and global ETFs?", "type": "comparison"}'::jsonb
WHERE id = '7000deff-f3d6-4ae1-a90a-1ffaeccc14db'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "10", "difficulty": "intermediate", "explanation": "EPS = Net pendapatan / Shares Outstanding = 100B / 10B = Rp 10 per share.", "parameters": {"hint": "Divide total net income by the number of shares."}, "question": "A company has net pendapatan of Rp 100B and 10B shares outstanding. apa the EPS?", "type": "calculation"}'::jsonb
WHERE id = '36f99f3e-b706-42fa-a36d-db714073d437'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8%", "difficulty": "intermediate", "explanation": "Weighted return = (0.60 × 10%) + (0.40 × 5%) = 6% + 2% = 8%.", "parameters": {"hint": "Multiply each allocation by its return and sum the results."}, "question": "You have Rp 50M to invest. You allocate 60% to saham (expected 10% return) and 40% to obligasi (expected 5% return). apa the expected portofolio return?", "type": "calculation"}'::jsonb
WHERE id = '715a9f24-a479-40f9-a8b7-20a17592d168'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "-2%", "difficulty": "intermediate", "explanation": "riil return ≈ nominal return - inflasi rate = 3% - 5% = -2%. Your daya beli is declining.", "parameters": {"hint": "Subtract inflation from the nominal interest rate."}, "question": "Your savings account pays 3% bunga per tahun. inflasi is 5%. apa your approximate riil return?", "type": "calculation"}'::jsonb
WHERE id = '64050712-3d07-46c7-aefe-174a4d4d72c1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "anggaran is hanya for people with low pendapatan.", "type": "true_false"}'::jsonb
WHERE id = 'b63fcabd-eb31-4f24-9797-51531725ca2d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "You need to be rich to start berinvestasi.", "type": "true_false"}'::jsonb
WHERE id = 'a7d77841-ef4f-4f0a-8fd5-caf7c939687c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "intermediate", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "You have Rp 10M. Option A: deposit at 4% p.a. Option B: invest in a friend''s business promising 20%. Analyze."}, "question": "You have Rp 10M. pilihan A: deposit at 4% p.a. pilihan B: invest in a friend''s business promising 20%. Analyze. apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = '718a9b19-7d8b-4e48-88ef-e7263eff5b73'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "intermediate", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "You want to save for a Rp 50M motorcycle in 3 years. How much must you save monthly at 5% annual return?"}, "question": "You want to save for a Rp 50M motorcycle in 3 years. berapa banyak must you save per bulan at 5% annual return? apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '192c3626-4f05-4629-9acd-6b8991fbeb2d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "intermediate", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "A fintech app offers 8% on deposits but is not OJK-licensed. A bank offers 4% with OJK license. Compare risks."}, "question": "A fintech app offers 8% on deposits but is not OJK-licensed. A bank offers 4% with OJK license. Compare risks. apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = 'e9646e1c-457d-44b2-b339-6e2b78be3f73'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"obligasi": "Fixed pendapatan utang", "Deposit": "Bank savings product", "reksa dana": "Pooled investasi vehicle", "saham": "Company ownership"}, "difficulty": "intermediate", "explanation": "benar matches: Deposit → Bank savings product, saham → Company ownership, obligasi → Fixed pendapatan utang, reksa dana → Pooled investasi vehicle", "options": {"left": ["Deposit", "saham", "obligasi", "reksa dana"], "right": ["Bank savings product", "Company ownership", "Fixed pendapatan utang", "Pooled investasi vehicle"]}, "parameters": {}, "question": "Match each investasi type with its description:", "type": "matching"}'::jsonb
WHERE id = '2d9ad7cb-fabf-4845-91a0-f6445a22f241'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Confirmation Bias": "Seeking confirming info", "FOMO": "Fear of missing out", "aversi rugi": "Fear of losses > joy of gains", "Overconfidence": "Excessive self-assurance"}, "difficulty": "intermediate", "explanation": "Correct matches: Loss Aversion → Fear of losses > joy of gains, FOMO → Fear of missing out, Confirmation Bias → Seeking confirming info, Overconfidence → Excessive self-assurance", "options": {"left": ["aversi rugi", "FOMO", "Confirmation Bias", "Overconfidence"], "right": ["Fear of losses > joy of gains", "Fear of missing out", "Seeking confirming info", "Excessive self-assurance"]}, "parameters": {}, "question": "Match each bias perilaku with its definition:", "type": "matching"}'::jsonb
WHERE id = 'c6486a05-d9f4-4c21-9465-652a608367c4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "Falling prices", "pasar bullish": "Rising prices", "koreksi": "10%+ decline from peak", "Sideways": "Flat movement"}, "difficulty": "intermediate", "explanation": "benar matches: pasar bullish → Rising prices, pasar bearish → Falling prices, Sideways → Flat movement, koreksi → 10%+ decline from peak", "options": {"left": ["pasar bullish", "pasar bearish", "Sideways", "koreksi"], "right": ["Rising prices", "Falling prices", "Flat movement", "10%+ decline from peak"]}, "parameters": {}, "question": "Match each market condition with its description:", "type": "matching"}'::jsonb
WHERE id = '6611fb75-54a6-4264-b096-32299992e664'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Calculate per bulan pendapatan → List fixed expenses → List variable expenses → Set savings target → Adjust spending to meet goals", "options": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "parameters": {}, "question": "urutkan langkah-langkah to create a per bulan anggaran:", "type": "ordering"}'::jsonb
WHERE id = 'a5d0368b-058c-467b-b7c4-6dd3b128bb88'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Feel market panic → Stop and breathe → Review your investasi plan → Check fundamentals → Decide based on strategy not emotion", "options": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "parameters": {}, "question": "urutkan langkah-langkah to handle market volatilitas emotionally:", "type": "ordering"}'::jsonb
WHERE id = 'c402f44d-a358-4452-bc62-af3b9f504ee0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Research the company → Analyze financial statements → Check valuation metrics → Consider market conditions → Decide position size", "options": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "parameters": {}, "question": "urutkan langkah-langkah for fundamental saham analysis:", "type": "ordering"}'::jsonb
WHERE id = 'c940a33e-9444-4772-967a-dafb6c073434'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["OJK", "BI"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: OJK, BI.", "options": ["OJK", "BI", "IDX", "SIPF"], "parameters": {}, "question": "di Indonesia, ________ regulates financial services while ________ manages monetary policy.", "type": "word_bank"}'::jsonb
WHERE id = 'd2fe30da-28c4-4e08-914c-1698e28e865b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["bullish", "bearish"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: bullish, bearish.", "options": ["bullish", "bearish", "sideways", "volatile"], "parameters": {}, "question": "When investors are ________, they expect prices to rise; when ________, they expect declines.", "type": "word_bank"}'::jsonb
WHERE id = '546f3a84-9532-42fc-bf46-636d565c7674'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Optimal portfolios for each risiko level", "difficulty": "intermediate", "explanation": "The efficient frontier represents portfolios that offer the highest expected return for a given level of risiko.", "options": ["Highest return regardless of risiko", "Optimal portfolios for each risiko level", "The safest possible portofolio", "A guaranteed return threshold"], "parameters": {"image_description": "A scatter plot showing risk (volatility) on X-axis and return on Y-axis. Multiple Indonesian stocks plotted. A diagonal line shows the efficient frontier."}, "question": "[IMAGE: A scatter plot showing risiko (volatilitas) on X-axis and return on Y-axis. Multiple Indonesian saham plotted. A diagonal line shows the efficient frontier.]\n\napa yang the efficient frontier line represent?", "type": "image_interpretation"}'::jsonb
WHERE id = 'dea1899b-1cb0-4f75-b2f4-b8cd70b7c175'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The power of bunga majemuk", "difficulty": "intermediate", "explanation": "The dramatic difference between simple accumulation and compound growth demonstrates why starting early and staying invested matters.", "options": ["menentukan waktu pasar", "The power of bunga majemuk", "Day trading profits", "Currency hedging"], "parameters": {"image_description": "An infographic showing compound growth: Rp 1M invested monthly at 7% annual return grows to Rp 1.2B over 30 years vs only Rp 360M without interest."}, "question": "[IMAGE: An infographic showing compound growth: Rp 1M invested per bulan at 7% annual return grows to Rp 1.2B over 30 years vs hanya Rp 360M without bunga.]\n\nWhat principle is this infographic illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = '24fd1f76-bffc-4225-837b-1a734b0f5892'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The saham is in a consolidation phase", "difficulty": "intermediate", "explanation": "Sideways movement without clear trend typically indicates consolidation, where buyers and sellers are in equilibrium.", "options": ["The saham is definitely going up", "The saham is in a consolidation phase", "Sell immediately", "keuntungan terjamin opportunity"], "parameters": {"image_description": "A candlestick chart of a single stock over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend."}, "question": "[IMAGE: A candlestick chart of a single saham over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend.]\n\nWhat conclusion can be drawn from this price action?", "type": "image_interpretation"}'::jsonb
WHERE id = '994a9304-bbd4-478f-a620-fef94b574161'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Total compensation termasuk risiko", "difficulty": "intermediate", "explanation": "benar path: Total compensation termasuk risiko. This represents the most financially sound decision at this stage.", "options": ["Which office is nicer", "Total compensation termasuk risiko", "Which has better Instagram", "Friend''s opinion"], "parameters": {"full_tree": {"scenario": "You receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.", "stages": [{"correct": "Total compensation including risk", "next": {"correct": "Use expected value (probability-weighted)", "next": {"correct": "Depends on risk tolerance and obligations", "options": ["Startup for higher expected value", "Bank for stability", "Negotiate bank to Rp 12M", "Decline both, travel"], "question": "Expected value of startup package ≈ Rp 11M/month. Bank = Rp 10M. But you have Rp 5M/month expenses. Decision?"}, "options": ["Assume maximum value", "Use expected value (probability-weighted)", "Ignore it entirely", "Ask the CEO"], "question": "Startup equity could be worth Rp 500M or zero. How to value it?"}, "options": ["Which office is nicer", "Total compensation including risk", "Which has better Instagram", "Friend''s opinion"], "question": "First factor to evaluate?"}]}}, "question": "Decision Tree Scenario:\n\nYou receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.\n\nFirst factor to evaluate?", "type": "decision_tree"}'::jsonb
WHERE id = 'f0701740-0a5b-48cd-a198-96a25840cf61'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK license status", "difficulty": "intermediate", "explanation": "benar path: OJK license status. This represents the most financially sound decision at this stage.", "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "parameters": {"full_tree": {"scenario": "A ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% monthly returns''.", "stages": [{"correct": "OJK license status", "next": {"correct": "Report to OJK and block", "next": {"correct": "Warn friends and family", "options": ["Ignore and move on", "Warn friends and family", "Post about it on social media", "Confront the scammer"], "question": "To protect others, best action?"}, "options": ["Invest a small amount to test", "Report to OJK and block", "Ask for a discount on entry fee", "Invite friends to join"], "question": "They have no OJK license but show ''proof'' of payments to others. What now?"}, "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "question": "First red flag to check?"}]}}, "question": "Decision Tree Scenario:\n\nA ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% per bulan returns''.\n\nFirst red flag to check?", "type": "decision_tree"}'::jsonb
WHERE id = '3f19875e-de2f-4d79-98d3-2cc403146eb1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "disposition", "difficulty": "intermediate", "explanation": "The disposition effect describes how investors prefer realizing gains over realizing losses.", "options": ["disposition", "confirmation", "anchoring", "availability"], "parameters": {}, "question": "In behavioral finance, the tendency to sell winning investments too early while holding losers too long disebut the ________ effect.", "type": "sentence_completion"}'::jsonb
WHERE id = 'c8e230f9-8c35-48ff-8e71-2823d49632f2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emotion-driven", "difficulty": "intermediate", "explanation": "Frequent monitoring and trading sering lead to emotional decision-making daripada disciplined strategy.", "options": ["patient long-term", "emotion-driven", "perfectly rational", "index-fund style"], "parameters": {}, "question": "An investor who checks their portofolio per hari and trades frequently is more likely to exhibit ________ behavior.", "type": "sentence_completion"}'::jsonb
WHERE id = '3715365c-a83a-4950-bc9e-b722751a90df'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["risiko", "return"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: risiko, return.", "options": ["risiko", "return", "diversifikasi", "likuiditas"], "parameters": {}, "question": "Investors must understand the trade-off between ________ and expected ________.", "type": "word_bank"}'::jsonb
WHERE id = 'd46ba1ea-36d9-4d66-ade5-707b2025de1e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pay off semua credit card utang", "difficulty": "intermediate", "explanation": "benar path: Pay off semua credit card utang. This represents the most financially sound decision at this stage.", "options": ["Invest in saham for high returns", "Pay off semua credit card utang", "Build dana darurat", "Buy a new car"], "parameters": {"full_tree": {"scenario": "You unexpectedly receive Rp 100M. You have Rp 30M in credit card debt at 2.5% monthly interest, no emergency fund, and no investments.", "stages": [{"correct": "Pay off all credit card debt", "next": {"correct": "Build 6-month emergency fund", "next": {"correct": "Diversified index fund portfolio", "options": ["All in one stock", "Diversified index fund portfolio", "Keep in savings", "Lend to a friend"], "question": "With emergency fund set, Rp 50M remains. Final decision?"}, "options": ["Invest everything in crypto", "Build 6-month emergency fund", "Start a business", "Luxury vacation"], "question": "After paying debt, you have Rp 70M left. Next step?"}, "options": ["Invest in stocks for high returns", "Pay off all credit card debt", "Build emergency fund", "Buy a new car"], "question": "First priority: What do you do with the first portion?"}]}}, "question": "Decision Tree Scenario:\n\nYou unexpectedly receive Rp 100M. You have Rp 30M in credit card utang at 2.5% per bulan bunga, no dana darurat, and no investments.\n\nFirst priority: What do you do with the first portion?", "type": "decision_tree"}'::jsonb
WHERE id = '8ec505c1-2237-464e-bd96-d219ef061185'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Semangkuk mie ayam di Jakarta harganya Rp18.000, tapi di kampung halaman Rina hanya Rp12.000. Uang Rp50.000 milik Rina di Jakarta cukup untuk 2 mangkuk plus sisa, di kampung cukup untuk 4 mangkuk. Daya beli uangnya berbeda di dua tempat."}'::jsonb
WHERE id = '357e7cb3-509d-498c-85af-b896fe444fd2'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni punya Rp100.000. Di kantin sekolah, uang itu bisa beli 10 porsi nasi goreng. Di mal, harga nasi goreng Rp35.000, jadi uangnya hanya cukup untuk 2 porsi. Lokasi dan situasi mengubah daya beli."}'::jsonb
WHERE id = '1bd65e9d-3dc2-4330-ad39-c629ba8c7202'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Nilai uang tidak hanya ditentukan oleh jumlahnya, tapi juga oleh harga barang yang ingin dibeli. Jika harga naik, daya beli turun meski nominal uang tetap sama."}'::jsonb
WHERE id = 'f471b0d3-5907-42b6-a5b3-b3b327cf49be'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Daya beli adalah seberapa banyak barang atau jasa yang bisa dibeli dengan sejumlah uang. Uang Rp50.000 bisa jadi lebih berharga di kota kecil daripada di kota besar jika harga-harga lebih murah."}'::jsonb
WHERE id = 'aab987c6-3037-4636-a1df-fec5acbe99bf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Daya belinya lebih besar di Yogyakarta", "difficulty": "beginner", "explanation": "Dengan harga lebih murah, uang yang sama bisa membeli lebih banyak porsi, artinya daya beli lebih besar.", "options": ["Daya belinya lebih besar di Yogyakarta", "Daya belinya lebih besar di Jakarta", "Daya belinya sama karena nominalnya sama", "Rp50.000 tidak bisa beli mie ayam di dua kota"], "question": "Mie ayam di Jakarta Rp18.000, di Yogyakarta Rp12.000. Manakah pernyataan yang benar tentang Rp50.000?", "type": "multiple_choice"}'::jsonb
WHERE id = 'eadf4fdc-8b39-4e53-949c-c41995c3a90c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Ketika harga naik, uang yang sama bisa membeli lebih sedikit barang, sehingga daya beli menurun.", "question": "Jika harga barang naik, daya beli uang yang kita milai juga naik.", "type": "true_false"}'::jsonb
WHERE id = '41c19172-9e63-4cfc-867a-34bd33e0eaaf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "banyak", "difficulty": "beginner", "explanation": "Daya beli mengukur jumlah barang/jasa yang dapat dibeli, bukan hanya nominal uangnya.", "question": "Daya beli menunjukkan seberapa _____ barang atau jasa yang bisa dibeli dengan sejumlah uang.", "type": "fill_blank"}'::jsonb
WHERE id = '5eaa1a1c-6d45-4e7a-8934-f02a6068fdf1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "1,5 novel lebih banyak di toko online", "difficulty": "beginner", "explanation": "Di toko online Rp100.000 dapat 4 novel; di toko fisik hanya 2,5 novel. Selisihnya 1,5 novel.", "options": ["1,5 novel lebih banyak di toko online", "Tidak ada perbedaan", "Novel lebih murah di toko fisik", "Rp100.000 tidak cukup di dua tempat"], "question": "Rina punya Rp100.000. Harga novel bekas di toko online Rp25.000, di toko fisik Rp40.000. Berapa perbedaan daya beli dalam jumlah novel?", "type": "multiple_choice"}'::jsonb
WHERE id = 'f1fd8db9-568c-4812-bdac-29195e7496e5'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4"], "text": "Di zaman Orde Baru, Indonesia pernah mengalami hiperinflasi. Harga barang bisa berubah dalam hitung hari. Pengalaman itu menjadi pelajaran kenapa stabilitas harga penting bagi ekonomi."}'::jsonb
WHERE id = '5fa2cbda-7ebb-4e15-be62-6c5f189bb481'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Ayah Doni bercerita tiket bioskop dulu Rp35.000, sekarang Rp50.000. Dengan uang Rp100.000, Doni dulu bisa nonton 2,8 kali, sekarang hanya 2 kali. Inflasi membuat harga naik secara perlahan dari tahun ke tahun."}'::jsonb
WHERE id = 'fb815ef8-7e95-4f4d-a9b7-e468e28293bb'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4", "097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Tahun 2021, harga satu liter minyak goreng kemasan di pasar tradisional sekitar Rp 10.000. Pada 2023, harga naik menjadi lebih dari Rp 17.000 per liter. Kenaikan harga minyak goreng ini adalah contoh inflasi yang memengaruhi daya beli masyarakat Indonesia, terutama keluarga dengan pengeluaran harian ketat."}'::jsonb
WHERE id = '5f0f9f70-20be-4e67-b38d-1989e4fa41d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4"], "text": "Tahun 2020, seporsi nasi padang di Jakarta dihargai Rp 25.000. Pada 2025, harga yang sama menjadi Rp 32.000. Kenaikan harga ini menunjukkan inflasi: daya beli rupiah menurun seiring waktu."}'::jsonb
WHERE id = '6bccef67-4bae-4330-a414-e86e411a32f7'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4"], "text": "Pak Tono menyimpan uang Rp 10 juta di bantal selama 10 tahun. Jika inflasi rata-rata 4% per tahun, daya beli uang itu menurun. Barang yang dulu Rp 10 juta, kini mungkin butuh Rp 14,8 juta."}'::jsonb
WHERE id = '5df74bbd-1665-4a01-bcd7-87a42521ec67'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Tahun 2020, Rina bisa membeli 10 mangkuk mie ayam dengan Rp120.000. Tahun 2025, harga mie ayam naik menjadi Rp16.000 per mangkuk, sehingga Rp120.000 hanya cukup untuk 7,5 mangkuk. Inflasi mengurangi daya beli uang yang diam saja."}'::jsonb
WHERE id = 'cdd0bac9-61b3-4487-a3cd-28af29c48423'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["53eef1ac-2553-48d9-92a0-af6159d7d369"], "text": "Aplikasi belanja online sering memberikan diskon besar. Namun jika diskon membuat kita membeli barang yang tidak dibutuhkan, kita tetap kehilangan daya beli karena uang habis untuk hal tidak penting."}'::jsonb
WHERE id = '51960795-f4ca-4da6-92a8-7340e13da59f'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4"], "text": "Mahasiswa yang menyewa kos di dekat kampus mengalami kenaikan harga kos 10% per tahun. Uang saku yang tetap membuatnya harus mencari kos lebih jauh atau mengurangi pengeluaran lain."}'::jsonb
WHERE id = 'fad6dd9a-ebe8-40dc-9d70-c1d4a56afc81'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4", "097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Bank Indonesia menetapkan target inflasi sekitar 2,5% plus minus 1%. Target ini dirancang agar harga naik cukup pelan sehingga masyarakat dapat merencanakan pengeluaran dan investasi dengan lebih stabil."}'::jsonb
WHERE id = '809a021d-9e46-4018-aa45-4cca7a501080'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4"], "text": "Ketika harga beras naik, pedagang nasi goreng di pinggir jalan menaikkan harga jual dari Rp 12.000 menjadi Rp 15.000. Inflasi bahan baku merambat ke harga jual ke konsumen."}'::jsonb
WHERE id = 'e6e5fcf4-dd2c-40e4-95ff-f993aaf9ac95'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["e49fe239-c534-4bed-b0bd-a7950b9e35c4", "8da2696d-9836-4a3b-9524-da7e2b823c60"], "text": "Tahun 2020, harga seporsi nasi padang di kantin kampus Rp 15.000. Tiga tahun kemudian, harganya menjadi Rp 20.000. Uang yang sama kini membeli porsi lebih kecil. Itulah inflasi menggerus daya beli."}'::jsonb
WHERE id = 'c26876f8-83a6-4c92-bbba-fe3243f10fe0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Susi memiliki tabungan di bank dengan bunga 3% per tahun, sedangkan inflasi 5%. Daya beli tabungannya turun 2% per tahun meski nominalnya bertambah. Ini disebut real return negatif."}'::jsonb
WHERE id = 'ffd4da83-c95a-490b-95c1-a109bf461afc'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["8da2696d-9836-4a3b-9524-da7e2b823c60"], "text": "Nilai tukar rupiah terhadap dolar Amerika mempengaruhi harga barang impor seperti minyak dan obat-obatan. Jika rupiah melemah, harga barang-barang itu naik dan memicu inflasi."}'::jsonb
WHERE id = '14a38cc0-e8c9-44ca-90dc-20c144666264'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Seorang pensiunan yang bergantung pada tabungan tunai akan merasa hidupnya semakin mahal setiap tahun. Tabungan yang tidak bertumbuh lebih cepat dari inflasi akan kehabisan daya beli."}'::jsonb
WHERE id = 'b6d211ca-35fe-4c5e-bbad-d88153c631b9'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Bank Indonesia menetapkan target inflasi 2,5% ± 1% pada 2025. Jika inflasi terlalu tinggi, harga barang naik cepat dan orang sulit merencanakan pengeluaran. Jika terlalu rendah, ekonomi bisa melambat."}'::jsonb
WHERE id = '092e3f71-0440-4583-9b13-6b4fc1a42b78'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Jelaskan inflasi menggunakan target BI dan contoh harga makanan di Indonesia. Hindari rekomendasi produk investasi spesifik.", "text": "Inflasi adalah kenaikan harga barang dan jasa secara umum dalam jangka waktu tertentu. Bank Indonesia menargetkan inflasi sekitar 2,5% ± 1% agar perekonomian tetap stabil. Jika tabungan di bank memberikan bunga lebih rendah dari inflasi, daya beli uang menurun. Oleh karena itu, memahami inflasi penting sebelum memilih instrumen tabungan atau investasi jangka panjang."}'::jsonb
WHERE id = 'b002ee98-a550-47ad-af12-2e5df8b0a0da'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bank Indonesia menargetkan inflasi sekitar 2,5% plus minus 1%. Jika inflasi 4% per tahun dan tabungan kita hanya bunga 2%, nilai riil uang kita menurun."}'::jsonb
WHERE id = '342f25f7-d4b8-4080-8b81-7202aec2f5db'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Inflasi adalah kenaikan harga barang dan jasa secara umum dalam periode waktu tertentu. Inflasi ringan dan stabil wajar, tetapi inflasi tinggi menggerus daya beli."}'::jsonb
WHERE id = '263d6a44-1604-4eab-b977-729f589f31b0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "advanced", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "Compare BI''s inflation targeting framework (2016-present) with the pre-2016 multiple-indicator approach."}, "question": "Compare BI''s inflasi targeting framework (2016-present) with the pre-2016 multiple-indicator approach. What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = '0f4064b3-a53b-485c-ae10-6ba96a7583c5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "aversi rugi", "difficulty": "advanced", "explanation": "aversi rugi is a key concept in behavioral finance where losses hurt about twice as much as gains feel good.", "parameters": {}, "question": "The tendency to feel losses more intensely than equivalent gains disebut ________.", "type": "fill_blank"}'::jsonb
WHERE id = 'bf367494-bd4e-4851-b22d-0b242ba5c358'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "compound", "difficulty": "advanced", "explanation": "bunga majemuk accelerates kekayaan growth by earning returns on returns dari waktu ke waktu.", "parameters": {}, "question": "________ bunga means earning returns on both your original investasi and the accumulated returns.", "type": "fill_blank"}'::jsonb
WHERE id = '8e541144-f274-4a4c-a85d-3b2968bc343a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Market ETF", "difficulty": "advanced", "explanation": "ETFs hold many saham, eliminating company-specific (unsystematic) risiko that single saham carry.", "options": ["Single saham", "Market ETF", "Both have same risiko", "risiko cannot be measured"], "parameters": {}, "question": "Compare the risiko: buying a single saham vs an ETF tracking the entire market. Which has lower unsystematic risiko?", "type": "comparison"}'::jsonb
WHERE id = 'ea747d6c-feab-4941-9103-6e019d32e865'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "anggaran is hanya for people with low pendapatan.", "type": "true_false"}'::jsonb
WHERE id = '571ea5cf-3d72-4289-8fad-2a339c57d971'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8.4%", "difficulty": "advanced", "explanation": "CAGR = (Ending Value / Beginning Value)^(1/n) - 1 = (150/100)^(1/5) - 1 ≈ 8.4%.", "parameters": {"hint": "Use the CAGR formula: (FV/PV)^(1/years) - 1."}, "question": "jika rp 100 juta tumbuh menjadi rp 150 juta dalam 5 tahun, berapakah perkiraan tingkat pertumbuhan tahunan majemuk (CAGR)?", "type": "calculation"}'::jsonb
WHERE id = 'ca6b784d-981d-4ff4-8566-ed9e33de4c76'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: pahami tingkat inflasi → periksa suku bunga tabungan → hitung return riil → pertimbangkan alternatif → sesuaikan strategi menabung", "options": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "parameters": {}, "question": "urutkan langkah-langkah untuk melindungi tabungan dari inflasi:", "type": "ordering"}'::jsonb
WHERE id = 'c3c231a3-c380-4588-8bc3-0e2902dab358'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "more", "difficulty": "advanced", "explanation": "beta measures sensitivity to market movements. beta 1.5 means 50% more volatile than the market.", "options": ["less", "more", "in the opposite direction", "independently"], "parameters": {}, "question": "A saham with a beta of 1.5 diharapkan bergerak ________ daripada pasar secara keseluruhan.", "type": "sentence_completion"}'::jsonb
WHERE id = '300c99e8-b43d-4b49-9bf8-2ed68effd24c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: buka rekening sekuritas → lengkapi proses kyc → setor dana → riset saham → tempatkan order pertama", "options": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "parameters": {}, "question": "urutkan langkah-langkah untuk mulai berinvestasi di saham indonesia:", "type": "ordering"}'::jsonb
WHERE id = '905ddd9f-479c-4791-8522-9660a3101b5f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Calculate per bulan pendapatan → List fixed expenses → List variable expenses → Set savings target → Adjust spending to meet goals", "options": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "parameters": {}, "question": "urutkan langkah-langkah to create a per bulan anggaran:", "type": "ordering"}'::jsonb
WHERE id = 'd8a9c0a0-a4a1-48f4-946a-875847c1f7e8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs"], "difficulty": "advanced", "explanation": "Starting young maximizes compounding. Even small amounts invested early outperform larger amounts invested later.", "options": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI''m 22 and I think berinvestasi is hanya for old people. I''ll start when I have a ''riil job.'' My money stays in a checking account earning 0% bunga.", "type": "spot_mistake"}'::jsonb
WHERE id = '1062d0cb-d229-40de-aa55-7c29b976763e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions"], "difficulty": "advanced", "explanation": "The disposition effect (selling winners, holding losers) and confirmation bias destroy long-term returns.", "options": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI sold my profitable saham to realize gains but kept my losing saham hoping they''d recover. I read one article that confirmed the losers would bounce back.", "type": "spot_mistake"}'::jsonb
WHERE id = '24bfd6d2-a9fb-4ce6-ba2a-e43724183a40'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif"], "difficulty": "advanced", "explanation": "tanpa pencatatan dan anggaran, pengeluaran mudah melebihi pendapatan tanpa disadari.", "options": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI don''t need to anggaran karena I can selalu check my e-wallet balance. I have 5 different e-wallets and I''m not sure berapa banyak I spend total each month.", "type": "spot_mistake"}'::jsonb
WHERE id = '84a85a04-7077-4f95-87a7-857f6be9d54f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Index fund berinvestasi", "difficulty": "advanced", "explanation": "Index funds offer instant diversifikasi, lower fees, and require less research and monitoring.", "options": ["Active memilih saham", "Index fund berinvestasi", "Both require equal expertise", "Neither is good for beginners"], "parameters": {}, "question": "Compare active memilih saham vs index fund berinvestasi for a beginner with limited time. Which is more suitable?", "type": "comparison"}'::jsonb
WHERE id = '1007bc94-226d-406b-a9c0-9d376c71ea9a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "cheaper", "difficulty": "advanced", "explanation": "Currency depreciation makes domestic goods cheaper for foreign buyers, potentially boosting exports.", "options": ["more expensive", "cheaper", "unchanged in price", "illegal"], "parameters": {}, "question": "If a country''s currency depreciates, its export goods become ________ for foreign buyers.", "type": "sentence_completion"}'::jsonb
WHERE id = '56cb8183-c61d-444e-81c6-135268030522'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "periksa izin OJK", "difficulty": "advanced", "explanation": "The flowchart explicitly shows OJK license verification as the first decision point before any further action.", "options": ["Read the prospectus", "periksa izin OJK", "Calculate potential returns", "Ask friends for opinion"], "parameters": {"image_description": "A flowchart: Start → Check OJK license → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths."}, "question": "[IMAGE: A flowchart: Start → periksa izin OJK → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths.]\n\nWhat yang pertama checkpoint in this financial safety flowchart?", "type": "image_interpretation"}'::jsonb
WHERE id = '496e9159-cb1e-4e39-968b-b84ade388924'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Personal loan", "difficulty": "advanced", "explanation": "Credit card at 2.5% per bulan compounds to ~34.5% per tahun. Personal loan at 12% annual is far cheaper.", "options": ["Credit card", "Personal loan", "They are equal", "Depends on usage"], "parameters": {}, "question": "Between a credit card with 2.5% per bulan bunga and a personal loan with 12% annual bunga, which has lower effective cost?", "type": "comparison"}'::jsonb
WHERE id = '3e7dbab5-6e64-408d-93c6-8a523d7a683b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emergency", "difficulty": "advanced", "explanation": "Emergency funds provide financial security during unforeseen circumstances like job loss or medical emergencies.", "parameters": {}, "question": "A ________ fund is money set aside specifically for unexpected expenses.", "type": "fill_blank"}'::jsonb
WHERE id = 'e69c7e48-f571-45d4-910d-32c92e7ed80d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "disposition", "difficulty": "advanced", "explanation": "The disposition effect describes how investors prefer realizing gains over realizing losses.", "options": ["disposition", "confirmation", "anchoring", "availability"], "parameters": {}, "question": "In behavioral finance, the tendency to sell winning investments too early while holding losers too long disebut the ________ effect.", "type": "sentence_completion"}'::jsonb
WHERE id = '4d016565-68b5-47cc-9144-426b67636a25'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"obligasi": "Fixed pendapatan utang", "Deposit": "Bank savings product", "reksa dana": "Pooled investasi vehicle", "saham": "Company ownership"}, "difficulty": "advanced", "explanation": "benar matches: Deposit → Bank savings product, saham → Company ownership, obligasi → Fixed pendapatan utang, reksa dana → Pooled investasi vehicle", "options": {"left": ["Deposit", "saham", "obligasi", "reksa dana"], "right": ["Bank savings product", "Company ownership", "Fixed pendapatan utang", "Pooled investasi vehicle"]}, "parameters": {}, "question": "Match each investasi type with its description:", "type": "matching"}'::jsonb
WHERE id = 'db4382d6-6763-4f67-af2a-0cb690ed043c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Optimal portfolios for each risiko level", "difficulty": "advanced", "explanation": "The efficient frontier represents portfolios that offer the highest expected return for a given level of risiko.", "options": ["Highest return regardless of risiko", "Optimal portfolios for each risiko level", "The safest possible portofolio", "A guaranteed return threshold"], "parameters": {"image_description": "A scatter plot showing risk (volatility) on X-axis and return on Y-axis. Multiple Indonesian stocks plotted. A diagonal line shows the efficient frontier."}, "question": "[IMAGE: A scatter plot showing risiko (volatilitas) on X-axis and return on Y-axis. Multiple Indonesian saham plotted. A diagonal line shows the efficient frontier.]\n\napa yang the efficient frontier line represent?", "type": "image_interpretation"}'::jsonb
WHERE id = '7bcaf6c5-c45e-4e32-81bf-93d13d4dbf90'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Investments": ["per bulan SIP", "saham purchase"], "kebutuhan": ["Rent payment", "Groceries"], "Savings": ["dana darurat deposit"], "keinginan": ["Netflix subscription", "Gym membership", "New sneakers"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"kebutuhan\": [\"Rent payment\", \"Groceries\"], \"keinginan\": [\"Netflix subscription\", \"Gym membership\", \"New sneakers\"], \"Savings\": [\"dana darurat deposit\"], \"Investments\": [\"per bulan SIP\", \"saham purchase\"]}", "options": {"buckets": ["kebutuhan", "keinginan", "Savings", "Investments"], "items": ["Rent payment", "Netflix subscription", "per bulan SIP", "dana darurat deposit", "Gym membership", "Groceries", "New sneakers", "saham purchase"]}, "parameters": {}, "question": "Categorize each item into the appropriate anggaran bucket:", "type": "categorization"}'::jsonb
WHERE id = '31ee07e1-0ef9-4f8e-b54f-648b3448c6e9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "advanced", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "Design an inflation swap hedging strategy for a pension fund with Rp 500B in fixed-income assets."}, "question": "Design an inflasi swap hedging strategy for a pension fund with Rp 500B in fixed-pendapatan assets. Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = '999a4fc7-69d0-4c36-b6ca-91c5b3097844'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "advanced", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "Indonesia''s debt-to-GDP is 41%. If BI monetizes 10% of new issuance, model the inflation risk over 5 years."}, "question": "Indonesia''s utang-to-GDP is 41%. If BI monetizes 10% of new issuance, model the inflasi risiko over 5 years. apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = 'f5640b4e-8e69-447f-a5a5-60737e75c796'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"50/30/20 Rule": "anggaran allocation framework", "dollar cost averaging": "Regular fixed investments", "dana darurat": "3-6 months expense reserve", "rebalancing": "Adjusting portofolio weights"}, "difficulty": "advanced", "explanation": "Correct matches: 50/30/20 Rule → Budget allocation framework, Emergency Fund → 3-6 months expense reserve, Dollar Cost Averaging → Regular fixed investments, Rebalancing → Adjusting portfolio weights", "options": {"left": ["50/30/20 Rule", "dana darurat", "dollar cost averaging", "rebalancing"], "right": ["anggaran allocation framework", "3-6 months expense reserve", "Regular fixed investments", "Adjusting portofolio weights"]}, "parameters": {}, "question": "Match each strategy with its description:", "type": "matching"}'::jsonb
WHERE id = '109a4c54-1da8-484a-80bd-e145a1201785'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bunga majemuk": "bunga on bunga", "diversifikasi": "Spreading risiko across assets", "likuiditas": "Ease of converting to cash", "volatilitas": "Price fluctuation magnitude"}, "difficulty": "advanced", "explanation": "benar matches: likuiditas → Ease of converting to cash, volatilitas → Price fluctuation magnitude, diversifikasi → Spreading risiko across assets, bunga majemuk → bunga on bunga", "options": {"left": ["likuiditas", "volatilitas", "diversifikasi", "bunga majemuk"], "right": ["Ease of converting to cash", "Price fluctuation magnitude", "Spreading risiko across assets", "bunga on bunga"]}, "parameters": {}, "question": "Match each financial concept with its meaning:", "type": "matching"}'::jsonb
WHERE id = '5f971430-4a4b-47bf-8818-a3009837a677'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["OJK", "BI"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: OJK, BI.", "options": ["OJK", "BI", "IDX", "SIPF"], "parameters": {}, "question": "di Indonesia, ________ regulates financial services while ________ manages monetary policy.", "type": "word_bank"}'::jsonb
WHERE id = 'ae7c445a-61c6-4d59-a2c8-efba41c8e77e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["P/E ratio", "EPS"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: rasio P/E, EPS.", "options": ["P/E ratio", "EPS", "ROE", "kapitalisasi pasar"], "parameters": {}, "question": "Fundamental metrics like ________ and ________ help evaluate saham valuations.", "type": "word_bank"}'::jsonb
WHERE id = 'dfa4e434-ae37-40ae-b0bb-67ed73a9e27e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["FOMO", "aversi rugi"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: FOMO, aversi rugi.", "options": ["FOMO", "aversi rugi", "herd mentality", "confirmation bias"], "parameters": {}, "question": "Common behavioral biases include ________, ________, and following the crowd without research.", "type": "word_bank"}'::jsonb
WHERE id = '1d2e1efa-5e45-4011-b8f9-5b38748552d8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Most months are near average, extremes are rare", "difficulty": "advanced", "explanation": "The bell-shaped distribution with most data near the mean and fewer observations in the tails is characteristic of return distributions.", "options": ["Returns are normally distributed", "Returns are predictable", "Most months are near average, extremes are rare", "Every month is equally likely"], "parameters": {"image_description": "A histogram showing distribution of monthly returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%."}, "question": "[IMAGE: A histogram showing distribution of per bulan returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%.]\n\napa yang the shape of this distribution suggest about market returns?", "type": "image_interpretation"}'::jsonb
WHERE id = 'e107d4b1-bad2-4247-a515-16cb3d5c4da8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Check if fundamentals changed", "difficulty": "advanced", "explanation": "benar path: Check if fundamentals changed. This represents the most financially sound decision at this stage.", "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "parameters": {"full_tree": {"scenario": "The stock market drops 20% in one month. You have Rp 200M invested across 10 stocks.", "stages": [{"correct": "Check if fundamentals changed", "next": {"correct": "Hold and consider buying more", "next": {"correct": "Dollar cost average over 3 months", "options": ["All remaining cash at once", "Dollar cost average over 3 months", "Wait for ''the bottom''", "Borrow to invest"], "question": "You decide to buy more. Best approach?"}, "options": ["Panic sell to preserve capital", "Hold and consider buying more", "Switch to gold entirely", "Blame the government"], "question": "Fundamentals are intact. What action makes sense?"}, "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "question": "First reaction: What do you check?"}]}}, "question": "Decision Tree Scenario:\n\nThe saham market drops 20% in one month. You have Rp 200M invested across 10 saham.\n\nFirst reaction: What do you check?", "type": "decision_tree"}'::jsonb
WHERE id = '5350c185-1c21-4434-aaae-c43117825f78'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Deflasi", "Inflasi ringan", "Inflasi tinggi", "Hiperinflasi"], "difficulty": "advanced", "explanation": "Deflasi (harga turun), inflasi ringan, inflasi tinggi, hiperinflasi (sangat ekstrem).", "options": ["Hiperinflasi", "Deflasi", "Inflasi ringan", "Inflasi tinggi"], "parameters": {}, "question": "Urutkan dari yang paling ringan hingga paling ekstrem:", "type": "ordering"}'::jsonb
WHERE id = 'fd7cb77c-dd6f-42a3-bb74-9731d788765a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "If a company is famous, its saham is selalu a good investasi.", "type": "true_false"}'::jsonb
WHERE id = '90f6498d-00c7-4e79-bc8c-54cfc75b2de0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "10", "difficulty": "advanced", "explanation": "EPS = Net pendapatan / Shares Outstanding = 100B / 10B = Rp 10 per share.", "parameters": {"hint": "Divide total net income by the number of shares."}, "question": "A company has net pendapatan of Rp 100B and 10B shares outstanding. apa the EPS?", "type": "calculation"}'::jsonb
WHERE id = '22e95576-63ad-4cbf-a556-625f2f6c232f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "advanced", "explanation": "P/E = Price per share / Earnings per share = 20,000 / 1,000 = 20.", "parameters": {"hint": "Divide stock price by earnings per share."}, "question": "A saham trades at Rp 20,000 with EPS of Rp 1,000. apa the rasio P/E?", "type": "calculation"}'::jsonb
WHERE id = '185add90-c4d0-4608-ab8b-f44e07ce147c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals"], "difficulty": "beginner", "explanation": "anggaran is upside-down, savings insufficient, and emergency funds must be liquid and safe.", "options": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy anggaran allocates 70% to keinginan, 20% to kebutuhan, and 10% to savings. I juga keep my dana darurat in cryptocurrency for higher returns.", "type": "spot_mistake"}'::jsonb
WHERE id = '792f801c-ed98-4aca-a0a2-9b78b67756cd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time"], "difficulty": "beginner", "explanation": "Multiple errors: no diversifikasi, no due diligence, unrealistic return expectations, and unverified broker.", "options": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invested semua my savings in one saham karena my friend said it was a ''sure thing.'' I juga didn''t check if the broker was OJK-licensed. I''m sure I''ll double my money in 3 months!", "type": "spot_mistake"}'::jsonb
WHERE id = '874696af-5b51-4ac2-ae77-d8d4a3dcce20'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')"], "difficulty": "beginner", "explanation": "Lottery is entertainment, not a rencana keuangan. The ''due'' fallacy ignores that each draw is independent.", "options": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy rencana keuangan is to win the lottery. I''ve spent Rp 5M on lottery tickets this year. I''m sure my numbers are due to come up soon.", "type": "spot_mistake"}'::jsonb
WHERE id = '80c16de8-91a6-4392-b49a-e2d4c3c0435e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pay off semua credit card utang", "difficulty": "beginner", "explanation": "benar path: Pay off semua credit card utang. This represents the most financially sound decision at this stage.", "options": ["Invest in saham for high returns", "Pay off semua credit card utang", "Build dana darurat", "Buy a new car"], "parameters": {"full_tree": {"scenario": "You unexpectedly receive Rp 100M. You have Rp 30M in credit card debt at 2.5% monthly interest, no emergency fund, and no investments.", "stages": [{"correct": "Pay off all credit card debt", "next": {"correct": "Build 6-month emergency fund", "next": {"correct": "Diversified index fund portfolio", "options": ["All in one stock", "Diversified index fund portfolio", "Keep in savings", "Lend to a friend"], "question": "With emergency fund set, Rp 50M remains. Final decision?"}, "options": ["Invest everything in crypto", "Build 6-month emergency fund", "Start a business", "Luxury vacation"], "question": "After paying debt, you have Rp 70M left. Next step?"}, "options": ["Invest in stocks for high returns", "Pay off all credit card debt", "Build emergency fund", "Buy a new car"], "question": "First priority: What do you do with the first portion?"}]}}, "question": "Decision Tree Scenario:\n\nYou unexpectedly receive Rp 100M. You have Rp 30M in credit card utang at 2.5% per bulan bunga, no dana darurat, and no investments.\n\nFirst priority: What do you do with the first portion?", "type": "decision_tree"}'::jsonb
WHERE id = '6572371c-cf2b-4065-ad9c-e9618e45338c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Uang tunai tidak bertumbuh, sehingga daya belinya tergerus inflasi.", "parameters": {}, "question": "Menyimpan uang tunai dalam jumlah besar di rumah adalah cara terbaik mengalahkan inflasi.", "type": "true_false"}'::jsonb
WHERE id = 'c33e96e8-bc41-4348-b247-88c179fce2b5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "BI", "difficulty": "beginner", "explanation": "Bank Indonesia (BI) bertugas menjaga stabilitas nilai tukar rupiah dan mengendalikan inflasi.", "options": ["OJK", "BI", "IDX", "Kemenkeu"], "parameters": {}, "question": "Institusi yang bertugas menjaga stabilitas harga di Indonesia adalah?", "type": "multiple_choice"}'::jsonb
WHERE id = 'cb88a442-97e4-494c-925b-4dc4970625db'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Harga barang naik", "Uang yang sama membeli lebih sedikit", "Daya beli menurun", "Masyarakat mengurangi konsumsi"], "difficulty": "beginner", "explanation": "Inflasi menaikkan harga, sehingga uang membeli lebih sedikit, daya beli menurun, dan konsumsi berkurang.", "options": ["Harga barang naik", "Uang yang sama membeli lebih sedikit", "Daya beli menurun", "Masyarakat mengurangi konsumsi"], "parameters": {}, "question": "Urutkan dampak inflasi terhadap daya beli masyarakat.", "type": "ordering"}'::jsonb
WHERE id = 'c63097f1-d5d4-4c02-bdad-7d3d5d618bd5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Penurunan daya beli uang terhadap barang dan jasa", "difficulty": "beginner", "explanation": "Inflasi adalah kenaikan harga barang dan jasa secara umum yang mengurangi daya beli uang.", "options": ["Kenaikan jumlah uang beredar", "Penurunan daya beli uang terhadap barang dan jasa", "Peningkatan nilai tukar rupiah", "Penurunan harga barang secara umum"], "parameters": {}, "question": "Apa yang dimaksud dengan inflasi?", "type": "multiple_choice"}'::jsonb
WHERE id = '64f0d2d9-1559-4469-9234-75cb9a6dab79'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["principal", "bunga"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: principal, bunga.", "options": ["principal", "bunga", "compound", "maturity"], "parameters": {}, "question": "With ________ bunga, you earn returns on both your ________ and accumulated earnings.", "type": "word_bank"}'::jsonb
WHERE id = '6bec8bf1-5818-4e21-8719-01a749e339af'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["menabung", "anggaran"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: menabung, anggaran.", "options": ["menabung", "anggaran", "berinvestasi", "spending"], "parameters": {}, "question": "Before ________, you should selalu create a ________ to plan your pendapatan and expenses.", "type": "word_bank"}'::jsonb
WHERE id = '3c34c395-2b7b-4e4e-bdde-4a9a6a3560d9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["inflasi", "deflation"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: inflasi, deflation.", "options": ["inflasi", "deflation", "stagflation", "hyperinflation"], "parameters": {}, "question": "________ occurs when prices rise across the economy, while ________ is when prices fall.", "type": "word_bank"}'::jsonb
WHERE id = '8f44ff9b-785e-4ec8-8e64-d6252458c443'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["naik", "umum"], "difficulty": "beginner", "explanation": "Inflasi adalah kenaikan harga barang dan jasa secara umum dalam jangka waktu tertentu.", "options": ["naik", "umum"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Inflasi terjadi ketika harga barang dan jasa _____ secara _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '15321024-10c5-4659-be9e-e726156bc6b4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Short-term volatilitas is normal, long-term trend matters", "difficulty": "beginner", "explanation": "The chart shows significant short-term drops but a long-term upward trend, illustrating why time in market beats timing the market.", "options": ["Markets selalu crash permanently", "Short-term volatilitas is normal, long-term trend matters", "Timing the market is easy", "Indonesian saham are too risky"], "parameters": {"image_description": "A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatility in 2022, steady climb in 2023-2024."}, "question": "[IMAGE: A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatilitas in 2022, steady climb in 2023-2024.]\n\napa yang this chart primarily demonstrate about long-term berinvestasi?", "type": "image_interpretation"}'::jsonb
WHERE id = '4eeec7ec-04b0-43ff-9c37-fb7b50d4e282'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Moderate risiko tolerance", "difficulty": "beginner", "explanation": "A 50/30/15/5 split between saham, obligasi, cash, and gold represents balanced risiko — neither too conservative nor too aggressive.", "options": ["Ultra-conservative", "Moderate risiko tolerance", "Aggressive growth seeker", "Speculative trader"], "parameters": {"image_description": "A pie chart showing asset allocation: 50% stocks, 30% bonds, 15% cash, 5% gold. Labels show this is a moderate risk portfolio."}, "question": "[IMAGE: A pie chart showing aset allocation: 50% saham, 30% obligasi, 15% cash, 5% gold. Labels show this is a moderate risiko portofolio.]\n\nWhat type of investor does this aset allocation most likely represent?", "type": "image_interpretation"}'::jsonb
WHERE id = '96a72691-25c0-4ef4-bc34-81244e458e28'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "Behavioral biases hanya affect inexperienced investors.", "type": "true_false"}'::jsonb
WHERE id = '7c79de72-e64d-4163-8888-817a864a1a04'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Start berinvestasi early", "difficulty": "beginner", "explanation": "At a young age, the power of compounding favors starting investments early, while low-bunga loans can be managed alongside.", "options": ["Pay off loans first completely", "Start berinvestasi early", "Do neither, spend on experiences", "Split equally"], "parameters": {}, "question": "For a 25-year-old with stable pendapatan: is it better to prioritize paying off low-bunga student loans or start berinvestasi early?", "type": "comparison"}'::jsonb
WHERE id = '45646169-61da-48d0-8809-40aa41e50415'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "0.69", "difficulty": "beginner", "explanation": "Portfolio beta = (0.50 × 1.2) + (0.30 × 0.3) + (0.20 × 0) = 0.60 + 0.09 + 0 = 0.69.", "parameters": {"hint": "Weight each asset''s beta by its portfolio allocation."}, "question": "A portofolio has 50% saham (beta 1.2), 30% obligasi (beta 0.3), 20% cash (beta 0). apa the portofolio beta?", "type": "calculation"}'::jsonb
WHERE id = '9812151e-7a5a-45b3-ba7a-5befdfd4043c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "69,770,000", "difficulty": "beginner", "explanation": "Using the future value of an annuity formula: FV = PMT × [(1+r)^n - 1]/r. With r = 0.5% per bulan, n = 60, PMT = 1,000,000. FV ≈ Rp 69.77M.", "parameters": {"hint": "Use FV annuity formula with monthly compounding."}, "question": "If you save Rp 1,000,000 per bulan at 6% annual bunga compounded per bulan, berapa banyak will you have after 5 years?", "type": "calculation"}'::jsonb
WHERE id = 'b5317ffd-6013-4fb5-949b-495de78b361d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Dividend Yield": "Annual dividend per share divided by saham price", "EPS": "Net pendapatan divided by number of outstanding shares", "P/E Ratio": "Market price per share divided by earnings per share", "ROE": "Net pendapatan divided by shareholders'' equity"}, "difficulty": "beginner", "explanation": "benar matches: rasio P/E = Market price per share divided by earnings per share, EPS = Net pendapatan divided by number of outstanding shares, ROE = Net pendapatan divided by shareholders'' equity, Dividend Yield = Annual dividend per share divided by saham price", "options": {"definitions": ["Market price per share divided by earnings per share", "Net pendapatan divided by number of outstanding shares", "Net pendapatan divided by shareholders'' equity", "Annual dividend per share divided by saham price"], "terms": ["P/E Ratio", "EPS", "ROE", "Dividend Yield"]}, "parameters": {}, "question": "Match each financial metric with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '3de964a6-e3d4-465e-a92b-7655d192457b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "A sustained decrease in the general price level", "Hyperinflation": "Extremely rapid and out-of-control price increases", "inflasi": "A sustained increase in the general price level of goods and services", "Stagflation": "A period of high inflasi combined with economic stagnation"}, "difficulty": "beginner", "explanation": "benar matches: inflasi = A sustained increase in the general price level of goods and services, Deflation = A sustained decrease in the general price level, Stagflation = A period of high inflasi combined with economic stagnation, Hyperinflation = Extremely rapid and out-of-control price increases", "options": {"definitions": ["A sustained increase in the general price level of goods and services", "A sustained decrease in the general price level", "A period of high inflasi combined with economic stagnation", "Extremely rapid and out-of-control price increases"], "terms": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"]}, "parameters": {}, "question": "Match each economic term with its benar definition:", "type": "definition_match"}'::jsonb
WHERE id = '1345341e-e85a-4a2e-838c-91894f26f892'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"alpha": "Excess return relative to a benchmark", "beta": "Sensitivity of a saham''s returns to market movements", "Sharpe Ratio": "risiko-adjusted return measuring excess return per unit of risiko", "Standard Deviation": "A measure of the dispersion of returns around the mean"}, "difficulty": "beginner", "explanation": "benar matches: alpha = Excess return relative to a benchmark, beta = Sensitivity of a saham''s returns to market movements, Sharpe Ratio = risiko-adjusted return measuring excess return per unit of risiko, Standard Deviation = A measure of the dispersion of returns around the mean", "options": {"definitions": ["Excess return relative to a benchmark", "Sensitivity of a saham''s returns to market movements", "risiko-adjusted return measuring excess return per unit of risiko", "A measure of the dispersion of returns around the mean"], "terms": ["alpha", "beta", "Sharpe Ratio", "Standard Deviation"]}, "parameters": {}, "question": "Match each risiko/return measure with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '2b61d6cd-0cd1-498c-ba70-0b6a2fb82599'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Harga barang naik", "Daya beli uang menurun", "Bunga tabungan mungkin lebih rendah dari inflasi", "Nilai riil tabungan berkurang"], "difficulty": "beginner", "explanation": "Inflasi menaikkan harga, menurunkan daya beli, dan dapat mengurangi nilai riil tabungan jika bunganya rendah.", "options": ["Harga barang naik", "Daya beli uang menurun", "Bunga tabungan mungkin lebih rendah dari inflasi", "Nilai riil tabungan berkurang"], "parameters": {}, "question": "Urutkan proses pengaruh inflasi terhadap tabungan.", "type": "ordering"}'::jsonb
WHERE id = '8a2ebd4e-fd31-4a76-b679-f8ae7234c8b2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["uang", "lebih sedikit"], "difficulty": "beginner", "explanation": "Kenaikan harga akibat inflasi mengurangi jumlah barang yang dapat dibeli dengan uang yang sama.", "options": ["uang", "lebih sedikit"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Inflasi membuat _____ yang sama bisa membeli _____ barang dari waktu ke waktu.\"", "type": "word_bank"}'::jsonb
WHERE id = '54eddea4-5d9c-48d4-9473-b43809101711'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2,5", "difficulty": "beginner", "explanation": "Bank Indonesia menargetkan inflasi sekitar 2,5% ± 1% untuk menjaga stabilitas ekonomi.", "parameters": {}, "question": "Bank Indonesia menargetkan inflasi sekitar _____ persen plus minus satu persen.", "type": "fill_blank"}'::jsonb
WHERE id = '2aa8eac1-7bb6-4fb3-97ff-078917a13761'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "24%", "difficulty": "beginner", "explanation": "Initial investment: 200 × 5,000 = 1,000,000. Final value: 200 × 6,200 = 1,240,000. Return = (1,240,000 - 1,000,000) / 1,000,000 = 24%.", "parameters": {"hint": "Calculate total initial cost, total final value, then percentage change."}, "question": "A saham costs Rp 5,000 per share. You buy 200 shares. After 1 year, the price is Rp 6,200. apa your percentage return?", "type": "calculation"}'::jsonb
WHERE id = 'ba17e0e1-00df-40cf-b290-9d67726e29b1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Uang tunai tidak menghasilkan bunga, sehingga daya belinya menurun jika inflasi positif.", "parameters": {}, "question": "Menyimpan semua uang dalam bentuk tunai dalam jangka panjang tetap aman dari inflasi.", "type": "true_false"}'::jsonb
WHERE id = '10949e6a-477d-4b6a-ad3d-a1d656528be8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: periksa izin OJK → Read the prospectus → Understand the risks → Start with small amount → Monitor regularly", "options": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "parameters": {}, "question": "Order the proper due diligence steps before berinvestasi:", "type": "ordering"}'::jsonb
WHERE id = '2f4a1fea-7c5a-49d9-80fc-13cbb7a2d34f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Daya beli menurun 2%", "difficulty": "beginner", "explanation": "Inflasi 5% menggerus nilai uang lebih cepat daripada bunga 3% menambahnya, sehingga daya beli riil turun sekitar 2%.", "options": ["Daya beli menurun 2%", "Daya beli naik 2%", "Daya beli tetap sama", "Daya beli naik 8%"], "question": "Jika inflasi 5% per tahun dan tabunganmu bunga 3% per tahun, apa yang terjadi pada daya beli tabunganmu?", "type": "multiple_choice"}'::jsonb
WHERE id = 'f37f554e-94cb-41e1-ba93-ea27c1cc428b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Set financial goals → Track pendapatan and expenses → Create a anggaran → Build dana darurat → Start berinvestasi", "options": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "parameters": {}, "question": "Order these steps to build a solid financial foundation:", "type": "ordering"}'::jsonb
WHERE id = '449dc976-dabf-4c28-80a9-d2e65032ca0b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Spot red flags → Verify information → Consult trusted sources → Document concerns → Report to authorities if needed", "options": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "parameters": {}, "question": "urutkan langkah-langkah to respond to a potential investasi penipuan:", "type": "ordering"}'::jsonb
WHERE id = '97a1e0d7-56be-4d1c-bb3a-4151b246f248'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2,5", "difficulty": "beginner", "explanation": "Bank Indonesia menargetkan inflasi sekitar 2,5% plus minus 1% untuk menjaga stabilitas ekonomi.", "parameters": {}, "question": "Bank Indonesia menargetkan inflasi sekitar _____ persen per tahun agar perekonomian tetap stabil.", "type": "fill_blank"}'::jsonb
WHERE id = '2510f83e-e377-470a-a970-b370dc5b28af'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Inflasi tinggi membuat harga barang naik cepat, sehingga uang yang sama bisa membeli lebih sedikit.", "parameters": {}, "question": "Inflasi yang terlalu tinggi akan merusak daya beli masyarakat.", "type": "true_false"}'::jsonb
WHERE id = '17e173b7-c87c-4b24-808c-51bf77d911f6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena bunga tabungan lebih rendah dari kenaikan harga", "difficulty": "beginner", "explanation": "Jika bunga tabungan di bawah inflasi, daya beli uang menurun meskipun nominalnya tetap.", "options": ["Karena bunga tabungan lebih rendah dari kenaikan harga", "Karena bank menutup rekening", "Karena inflasi tidak memengaruhi uang", "Karena harga barang turun"], "parameters": {}, "question": "Mengapa tabungan dengan bunga rendah bisa kehilangan nilai riil saat inflasi tinggi?", "type": "multiple_choice"}'::jsonb
WHERE id = '1e9872b6-6586-4476-8bbb-af173d669d7c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "General price fall", "Hyperinflation": "Extreme rapid price rise", "inflasi": "General price rise", "Stagflation": "High inflasi + stagnation"}, "difficulty": "beginner", "explanation": "benar matches: inflasi → General price rise, Deflation → General price fall, Stagflation → High inflasi + stagnation, Hyperinflation → Extreme rapid price rise", "options": {"left": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"], "right": ["General price rise", "General price fall", "High inflasi + stagnation", "Extreme rapid price rise"]}, "parameters": {}, "question": "Match each economic condition with its definition:", "type": "matching"}'::jsonb
WHERE id = 'cf1c55b9-4335-416d-9c09-f730775dd273'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Starting early dramatically increases final kekayaan", "difficulty": "beginner", "explanation": "The accelerating growth shown in the timeline demonstrates the exponential power of bunga majemuk over long periods.", "options": ["You need to be rich to start", "Starting early dramatically increases final kekayaan", "Retirement is impossible", "hanya high earners can retire"], "parameters": {"image_description": "A timeline infographic: Age 25 (start investing Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B)."}, "question": "[IMAGE: A timeline infographic: Age 25 (start berinvestasi Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B).]\n\nWhat utama message of this retirement savings timeline?", "type": "image_interpretation"}'::jsonb
WHERE id = '4db82397-40b5-435b-9fdd-7aa6106284c2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Not an aset": ["Time with family", "Car (depreciating)", "Lifestyle sneakers"], "Risky Assets": ["Bitcoin", "Individual saham", "riil estate"], "Safe Assets": ["Bank deposit", "Government obligasi"]}, "difficulty": "beginner", "explanation": "benar categorization: {\"Safe Assets\": [\"Bank deposit\", \"Government obligasi\"], \"Risky Assets\": [\"Bitcoin\", \"Individual saham\", \"riil estate\"], \"Not an aset\": [\"Time with family\", \"Car (depreciating)\", \"Lifestyle sneakers\"]}", "options": {"buckets": ["Safe Assets", "Risky Assets", "Not an aset"], "items": ["Bank deposit", "Bitcoin", "Time with family", "Government obligasi", "Individual saham", "Car (depreciating)", "riil estate", "Lifestyle sneakers"]}, "parameters": {}, "question": "Sort each item into the benar aset classification:", "type": "categorization"}'::jsonb
WHERE id = 'a891c049-0bdc-419f-b5df-a2da35cdf397'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "beginner", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "Your parents say they bought a house for Rp 50M in 2000. What would it cost today with 5% average inflation?"}, "question": "Your parents say they bought a house for Rp 50M in 2000. What would it cost today with 5% average inflasi? Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = 'c88ff84e-c976-4131-bc3a-6ee28ff8c364'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Uang tunai tidak menghasilkan bunga, sehingga daya belinya menurun saat inflasi positif.", "question": "Menyimpan semua uang di bawah bantal selalu aman dari inflasi.", "type": "true_false"}'::jsonb
WHERE id = '12dd724a-f26c-4cfa-abf3-78086485a30f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Inflasi adalah kenaikan harga umum yang terus-menerus, bukan kenaikan satu barang saja.", "question": "Inflasi berarti harga barang dan jasa naik secara umum dalam jangka waktu tertentu.", "type": "true_false"}'::jsonb
WHERE id = 'e912ae59-23ab-43db-a05a-fe1695f8dc59'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"BI": "Central bank", "IDX": "saham exchange", "OJK": "Financial regulator", "SIPF": "Investor protection fund"}, "difficulty": "beginner", "explanation": "benar matches: OJK → Financial regulator, BI → Central bank, IDX → saham exchange, SIPF → Investor protection fund", "options": {"left": ["OJK", "BI", "IDX", "SIPF"], "right": ["Financial regulator", "Central bank", "saham exchange", "Investor protection fund"]}, "parameters": {}, "question": "Match each Indonesian financial institution with its primary function:", "type": "matching"}'::jsonb
WHERE id = 'd6719969-d2d1-41c0-b4b4-37fe08cb7c38'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Fundamental Analysis": "Financial statements", "Quantitative Analysis": "Mathematical models", "Sentiment Analysis": "Market mood and emotions", "Technical Analysis": "Charts and patterns"}, "difficulty": "beginner", "explanation": "benar matches: Technical Analysis → Charts and patterns, Fundamental Analysis → Financial statements, Quantitative Analysis → Mathematical models, Sentiment Analysis → Market mood and emotions", "options": {"left": ["Technical Analysis", "Fundamental Analysis", "Quantitative Analysis", "Sentiment Analysis"], "right": ["Charts and patterns", "Financial statements", "Mathematical models", "Market mood and emotions"]}, "parameters": {}, "question": "Match each analysis approach with its focus:", "type": "matching"}'::jsonb
WHERE id = '11804656-8892-4b67-997a-bf39cf49e59a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "diversifikasi", "difficulty": "beginner", "explanation": "diversifikasi ensures that poor performance in one investasi does not destroy the entire portofolio.", "parameters": {}, "question": "________ is the practice of spreading investments across different assets to reduce risiko.", "type": "fill_blank"}'::jsonb
WHERE id = '5ce8909c-30b9-405a-9af2-e797f66ba5ae'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan vs keinginan", "difficulty": "beginner", "explanation": "Understanding kebutuhan versus keinginan is fundamental to anggaran and menabung.", "parameters": {}, "question": "The concept of ________ helps individuals distinguish between essential and non-essential spending.", "type": "fill_blank"}'::jsonb
WHERE id = 'b41b7977-5a92-419d-8c9f-8fbaa5a086d1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2.5", "difficulty": "beginner", "explanation": "BI''s inflasi target is approximately 2.5% with a tolerance band of ±1%.", "parameters": {}, "question": "Bank Indonesia targets inflation around ________ percent per year.", "type": "fill_blank"}'::jsonb
WHERE id = 'cbeba65a-79f8-4e35-abef-6c78f8d835fb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "beginner", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "A bowl of noodles cost Rp 15,000 last year and Rp 16,500 now. What is the inflation rate?"}, "question": "A bowl of noodles cost Rp 15,000 last year and Rp 16,500 now. apa the inflasi rate? apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = '83538985-5683-495f-a7ea-0c60c12c9301'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "beginner", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "A store raises prices by 10% during Ramadan. Is this inflation or something else?"}, "question": "A store raises prices by 10% during Ramadan. Is this inflasi or something else? apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '7ad993cb-aa4f-4303-a011-879774483900'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "menabung money under your mattress is selalu better than bank deposits.", "type": "true_false"}'::jsonb
WHERE id = '4896c4e0-5e58-4662-aac7-df9632c9b01d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 3M (20% of pendapatan)", "difficulty": "beginner", "explanation": "benar path: Rp 3M (20% of pendapatan). This represents the most financially sound decision at this stage.", "options": ["Rp 500K", "Rp 3M (20% of pendapatan)", "Rp 7.5M (50% of pendapatan)", "Nothing, spend freely"], "parameters": {"full_tree": {"scenario": "You are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.", "stages": [{"correct": "Rp 3M (20% of income)", "next": {"correct": "High-yield savings", "next": {"correct": "Money market fund", "options": ["Regular savings", "Money market fund", "Aggressive growth stocks", "Friends'' business"], "question": "After emergency fund, monthly surplus goes to house fund. Best vehicle?"}, "options": ["Crypto wallet", "High-yield savings", "Stock market", "Under mattress"], "question": "Where should you keep the emergency portion (3 months expenses = Rp 45M target)?"}, "options": ["Rp 500K", "Rp 3M (20% of income)", "Rp 7.5M (50% of income)", "Nothing, spend freely"], "question": "Month 1: How much should you save first?"}]}}, "question": "Decision Tree Scenario:\n\nYou are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.\n\nMonth 1: berapa banyak should you save first?", "type": "decision_tree"}'::jsonb
WHERE id = '12f88b0f-cdc9-4345-a41a-657856a48480'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Biaya hidup tidak pasti dan sulit diperkirakan", "difficulty": "beginner", "explanation": "Inflasi tinggi membuat biaya hidup tidak pasti, sehingga perencanaan keuangan sulit.", "options": ["Lebih mudah menabung", "Biaya hidup tidak pasti dan sulit diperkirakan", "Gaji otomatis naik", "Bunga pinjaman turun"], "parameters": {}, "question": "Apa akibat inflasi tinggi bagi perencanaan keuangan?", "type": "multiple_choice"}'::jsonb
WHERE id = '02624d1b-97ca-48ee-8a35-d0f4bd6397f1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lower", "difficulty": "beginner", "explanation": "diversifikasi reduces unsystematic (company-specific) risiko without sacrificing expected returns.", "options": ["higher", "lower", "equal", "unpredictable"], "parameters": {}, "question": "A diversified portofolio typically has ________ risiko than a concentrated portofolio with the same expected return.", "type": "sentence_completion"}'::jsonb
WHERE id = '6a24b9f0-a8db-463c-9104-1f9efedcae64'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Government obligasi", "difficulty": "beginner", "explanation": "Real return deposits: 4% - 3% = 1%. Bonds: 6% - 3% = 3%. Bonds provide better inflation protection.", "options": ["Fixed deposits", "Government obligasi", "Both equal", "Neither beats inflasi"], "parameters": {}, "question": "Compare fixed deposits (4% p.a.) vs government obligasi (6% p.a.) for a conservative investor. Which offers better riil returns if inflasi is 3%?", "type": "comparison"}'::jsonb
WHERE id = '8ecf36b8-c583-4ce7-8668-cba0d3ba10e6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK-licensed bank deposit", "difficulty": "beginner", "explanation": "Licensed deposits are regulated and insured. Unlicensed platforms carry penipuan risiko and no investor protection.", "options": ["OJK-licensed bank deposit", "Unlicensed P2P platform", "Both equally safe", "Cannot determine"], "parameters": {}, "question": "Which is generally safer: keeping Rp 50M in an OJK-licensed bank deposit or berinvestasi in an unlicensed P2P platform promising 15% returns?", "type": "comparison"}'::jsonb
WHERE id = 'dcb3e303-7e25-4203-9594-4933bfdab3e8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "decreases", "difficulty": "beginner", "explanation": "riil return = nominal return - inflasi. If inflasi rises and nominal return is flat, riil return falls.", "options": ["increases", "decreases", "stays the same", "becomes irrelevant"], "parameters": {}, "question": "If inflasi rises while bunga rates stay flat, the riil return on savings ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'ed546528-ff90-4ca5-9d09-ac88850d57d9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "is not indicative of", "difficulty": "beginner", "explanation": "Standard disclaimer: past performance does not guarantee future results. Markets are inherently uncertain.", "options": ["guarantees", "is not indicative of", "is the hanya predictor of", "selalu exceeds"], "parameters": {}, "question": "When evaluating an investasi, past performance ________ future results.", "type": "sentence_completion"}'::jsonb
WHERE id = 'bcb77a9f-b482-4317-87c5-96258187a01d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Daya beli menurun", "difficulty": "beginner", "explanation": "Inflasi membuat harga barang naik, sehingga uang yang sama bisa membeli lebih sedikit.", "options": ["Daya beli meningkat", "Daya beli menurun", "Daya beli tetap sama", "Inflasi tidak berpengaruh"], "parameters": {}, "question": "Apa pengaruh inflasi terhadap daya beli uang?", "type": "multiple_choice"}'::jsonb
WHERE id = '416516f6-b2c2-4436-9ca9-a253a7d235d9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK license status", "difficulty": "intermediate", "explanation": "benar path: OJK license status. This represents the most financially sound decision at this stage.", "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "parameters": {"full_tree": {"scenario": "A ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% monthly returns''.", "stages": [{"correct": "OJK license status", "next": {"correct": "Report to OJK and block", "next": {"correct": "Warn friends and family", "options": ["Ignore and move on", "Warn friends and family", "Post about it on social media", "Confront the scammer"], "question": "To protect others, best action?"}, "options": ["Invest a small amount to test", "Report to OJK and block", "Ask for a discount on entry fee", "Invite friends to join"], "question": "They have no OJK license but show ''proof'' of payments to others. What now?"}, "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "question": "First red flag to check?"}]}}, "question": "Decision Tree Scenario:\n\nA ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% per bulan returns''.\n\nFirst red flag to check?", "type": "decision_tree"}'::jsonb
WHERE id = 'eb83f5ad-68c1-41ab-a689-35cae8bbe52d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "intermediate", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "Government raises fuel subsidies. How does this affect reported inflation vs actual cost of living?"}, "question": "Government raises fuel subsidies. bagaimana this affect reported inflasi vs actual cost of living? apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '0e826d6e-4803-43d2-85d3-e217c1d489bd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "intermediate", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "A company gives 8% raises when inflation is 3%. What happens to their competitiveness vs foreign rivals?"}, "question": "A company gives 8% raises when inflasi is 3%. apa yang terjadi to their competitiveness vs foreign rivals? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = 'cfdfdaac-ce62-4a7f-aeb8-65f33fe68fb6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "intermediate", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "Compare cost-push inflation (oil price shock) vs demand-pull inflation (fiscal stimulus). Which is harder to control?"}, "question": "Compare cost-push inflasi (oil price shock) vs demand-pull inflasi (fiscal stimulus). Which is harder to control? What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = 'de5546f1-3b8a-4119-8961-5f4d6b23698d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Leverage": "The use of borrowed capital to increase potential returns", "likuiditas": "The ease with which an aset can be converted to cash", "Solvency": "The ability to meet long-term financial obligations", "volatilitas": "The degree of variation in trading prices dari waktu ke waktu"}, "difficulty": "intermediate", "explanation": "benar matches: likuiditas = The ease with which an aset can be converted to cash, Solvency = The ability to meet long-term financial obligations, Leverage = The use of borrowed capital to increase potential returns, volatilitas = The degree of variation in trading prices dari waktu ke waktu", "options": {"definitions": ["The ease with which an aset can be converted to cash", "The ability to meet long-term financial obligations", "The use of borrowed capital to increase potential returns", "The degree of variation in trading prices dari waktu ke waktu"], "terms": ["likuiditas", "Solvency", "Leverage", "volatilitas"]}, "parameters": {}, "question": "Match each financial concept with its definition:", "type": "definition_match"}'::jsonb
WHERE id = '93e86a86-ee11-46fe-9cbc-e3d4759751be'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "A market condition where prices are falling or expected to fall", "pasar bullish": "A market condition where prices are rising or expected to rise", "koreksi": "A decline of 10% or more from a recent peak", "crash": "A sudden dramatic decline of 20% or more in saham prices"}, "difficulty": "intermediate", "explanation": "benar matches: pasar bullish = A market condition where prices are rising or expected to rise, pasar bearish = A market condition where prices are falling or expected to fall, koreksi = A decline of 10% or more from a recent peak, crash = A sudden dramatic decline of 20% or more in saham prices", "options": {"definitions": ["A market condition where prices are rising or expected to rise", "A market condition where prices are falling or expected to fall", "A decline of 10% or more from a recent peak", "A sudden dramatic decline of 20% or more in saham prices"], "terms": ["pasar bullish", "pasar bearish", "koreksi", "crash"]}, "parameters": {}, "question": "Match each market term with its description:", "type": "definition_match"}'::jsonb
WHERE id = 'c4256d11-e9b0-4890-b1b9-cfd5b3bc0dd6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "memulai lebih awal dan konsisten", "difficulty": "intermediate", "explanation": "waktu di pasar and kontribusi konsisten jauh lebih penting daripada memilih saham or menentukan waktu pasar.", "options": ["memilih saham terbaik", "memulai lebih awal dan konsisten", "menentukan waktu pasar dengan sempurna", "memiliki informasi orang dalam"], "parameters": {}, "question": "faktor paling penting in membangun kekayaan melalui investasi is ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '0565859c-0a4a-419e-b3da-4b420ad11541'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Long Term": ["Retirement savings", "Children''s education", "Estate planning"], "Medium Term": ["House down payment (3 years)", "Car purchase (1 year)"], "Short Term": ["dana darurat", "Next month''s rent", "Vacation fund"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"Short Term\": [\"dana darurat\", \"Next month''s rent\", \"Vacation fund\"], \"Medium Term\": [\"House down payment (3 years)\", \"Car purchase (1 year)\"], \"Long Term\": [\"Retirement savings\", \"Children''s education\", \"Estate planning\"]}", "options": {"buckets": ["Short Term", "Medium Term", "Long Term"], "items": ["dana darurat", "House down payment (3 years)", "Retirement savings", "Next month''s rent", "Car purchase (1 year)", "Children''s education", "Vacation fund", "Estate planning"]}, "parameters": {}, "question": "Organize each financial tujuan by its typical time horizon:", "type": "categorization"}'::jsonb
WHERE id = '961cc765-722d-46b5-b4d2-10b58a9d1503'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bias perilaku": ["FOMO buying", "Holding losers too long", "aversi rugi", "Confirmation bias"], "Market Condition": ["pasar bullish", "pasar bearish"], "Rational Strategy": ["rebalancing per tahun", "DCA berinvestasi"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"bias perilaku\": [\"FOMO buying\", \"Holding losers too long\", \"aversi rugi\", \"Confirmation bias\"], \"Rational Strategy\": [\"rebalancing per tahun\", \"DCA berinvestasi\"], \"Market Condition\": [\"pasar bullish\", \"pasar bearish\"]}", "options": {"buckets": ["bias perilaku", "Rational Strategy", "Market Condition"], "items": ["FOMO buying", "rebalancing per tahun", "pasar bullish", "Holding losers too long", "DCA berinvestasi", "aversi rugi", "pasar bearish", "Confirmation bias"]}, "parameters": {}, "question": "Identify whether each item represents a bias perilaku, rational strategy, or market condition:", "type": "categorization"}'::jsonb
WHERE id = '60adf989-b25f-4a3c-a102-dba9df212b7b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "You need to be rich to start berinvestasi.", "type": "true_false"}'::jsonb
WHERE id = 'a2a63f29-5cd6-4187-83f5-2169cd8f1488'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"inflasi Hedge": ["Gold", "riil estate", "inflasi-indexed obligasi", "saham portofolio"], "inflasi risiko": ["Cash under mattress", "Fixed deposit at 2%"], "Neutral": ["Foreign currency", "Collectibles"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"inflasi Hedge\": [\"Gold\", \"riil estate\", \"inflasi-indexed obligasi\", \"saham portofolio\"], \"inflasi risiko\": [\"Cash under mattress\", \"Fixed deposit at 2%\"], \"Neutral\": [\"Foreign currency\", \"Collectibles\"]}", "options": {"buckets": ["inflasi Hedge", "inflasi risiko", "Neutral"], "items": ["Gold", "Cash under mattress", "riil estate", "Fixed deposit at 2%", "inflasi-indexed obligasi", "saham portofolio", "Foreign currency", "Collectibles"]}, "parameters": {}, "question": "Classify each item based on its relationship with inflasi:", "type": "categorization"}'::jsonb
WHERE id = '442378fa-912f-4f17-bd3c-d68586111f97'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emotion-driven", "difficulty": "intermediate", "explanation": "Frequent monitoring and trading sering lead to emotional decision-making daripada disciplined strategy.", "options": ["patient long-term", "emotion-driven", "perfectly rational", "index-fund style"], "parameters": {}, "question": "An investor who checks their portofolio per hari and trades frequently is more likely to exhibit ________ behavior.", "type": "sentence_completion"}'::jsonb
WHERE id = '93053cc9-693d-41e4-8d67-061cbfd31909'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "10%", "difficulty": "intermediate", "explanation": "Kenaikan Rp 800.000 dari Rp 8 juta adalah 10%.", "options": ["8%", "10%", "12%", "15%"], "parameters": {}, "question": "Jika harga sepeda motor bekas naik dari Rp 8 juta menjadi Rp 8,8 juta dalam setahun, berapa laju inflasi harga motor itu?", "type": "multiple_choice"}'::jsonb
WHERE id = 'bf4b3b83-7685-433c-b574-39d1941cd5c2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "fall", "difficulty": "intermediate", "explanation": "obligasi prices and bunga rates have an inverse relationship. Higher rates mean existing obligasi are less attractive.", "options": ["rise", "fall", "remain unchanged", "become more volatile"], "parameters": {}, "question": "When the central bank raises bunga rates, obligasi prices generally ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'e6bd6931-d5b6-48c2-ad64-030be1572c7a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "intermediate", "explanation": "The 50/30/20 rule allocates 50% to kebutuhan, 30% to keinginan, and 20% to savings and utang.", "parameters": {}, "question": "The 50/30/20 rule suggests allocating ________ percent of pendapatan to savings and utang repayment.", "type": "fill_blank"}'::jsonb
WHERE id = 'eb762d4c-404b-44e7-9a9b-9301fd21c1cc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "intermediate", "explanation": "Otoritas Jasa Keuangan (OJK) is Indonesia''s financial services authority.", "parameters": {}, "question": "The organization that regulates financial services di Indonesia is abbreviated as ________.", "type": "fill_blank"}'::jsonb
WHERE id = '11cad06e-ec7a-4e0b-8d62-1ba6be4a54e3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "IDX", "difficulty": "intermediate", "explanation": "Bursa Efek Indonesia (IDX) is the national saham exchange of Indonesia.", "parameters": {}, "question": "________ is the Indonesian saham exchange where companies list their shares.", "type": "fill_blank"}'::jsonb
WHERE id = 'c50e6ef4-0064-40f8-93c3-542f0ea45cdb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest"], "difficulty": "intermediate", "explanation": "Credit card utang at 2.5% per bulan compounds to devastating levels. Minimum payments prolong utang for years.", "options": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI use my credit card for semua purchases karena I get cashback. I hanya pay the minimum balance each month. I have Rp 50M in credit card utang.", "type": "spot_mistake"}'::jsonb
WHERE id = 'd506268b-cc7a-480c-ad75-c2cedd088275'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money"], "difficulty": "intermediate", "explanation": "This exhibits classic Ponzi scheme warning signs: guaranteed high returns, secrecy, and pressure to act fast.", "options": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI put semua my money in a ''guaranteed 20% per bulan return'' scheme. The person running it says it''s secret and I shouldn''t tell anyone. I signed up immediately.", "type": "spot_mistake"}'::jsonb
WHERE id = '7228d83d-a37b-40ba-8693-f8edfcf7f1e2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy"], "difficulty": "intermediate", "explanation": "Emotional trading, no strategy, and social media tips are unreliable sources of investasi decisions.", "options": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI check my saham portofolio every hour and sell whenever it drops more than 2%. I juga buy whatever saham is trending on social media.", "type": "spot_mistake"}'::jsonb
WHERE id = '77122c7d-1f60-49b2-8f8e-322bbfd8b7b5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Kenaikan harga bahan baku", "Permintaan tinggi", "Rupiah melemah"], "difficulty": "intermediate", "explanation": "Kenaikan harga bahan baku, permintaan tinggi, dan rupiah melemah bisa memicu inflasi.", "options": ["Kenaikan harga bahan baku", "Permintaan tinggi", "Rupiah melemah", "Bunga tabungan tinggi"], "parameters": {}, "question": "Faktor yang dapat memicu inflasi: ____", "type": "word_bank"}'::jsonb
WHERE id = 'e060ea82-d95d-4ddf-9f37-5e889b24bda4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Emas atau saham", "difficulty": "intermediate", "explanation": "Aset seperti emas dan saham berpotensi bertumbuh melebihi inflasi dalam jangka panjang.", "options": ["Tabungan biasa", "Emas atau saham", "Uang di bantal", "Dompet digital kosong"], "parameters": {}, "question": "Dalam jangka panjang, investasi apa yang umumnya digunakan untuk melindungi nilai dari inflasi?", "type": "multiple_choice"}'::jsonb
WHERE id = '2432d7cf-2a80-4da3-b08f-cc669e75314e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena harga barang impor naik", "difficulty": "intermediate", "explanation": "Rupiah melemah membuat barang impor seperti minyak dan obat lebih mahal.", "options": ["Karena bunga bank naik", "Karena harga barang impor naik", "Karena gaji naik", "Karena tabungan bertambah"], "parameters": {}, "question": "Mengapa rupiah melemah bisa memicu inflasi?", "type": "multiple_choice"}'::jsonb
WHERE id = '9416b819-47d0-4a3f-970a-a71a256a2446'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2,5", "difficulty": "intermediate", "explanation": "Bank Indonesia menetapkan target inflasi sekitar 2,5% ± 1%.", "parameters": {}, "question": "Target inflasi Bank Indonesia adalah sekitar ____% ± 1%.", "type": "fill_blank"}'::jsonb
WHERE id = 'e5e33ab5-9d50-4cf5-bf86-446a7caf0d0c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Daya beli menurun karena inflasi (5%) lebih tinggi dari bunga tabungan (3%).", "parameters": {}, "question": "Jika inflasi 5% per tahun, tabungan dengan bunga 3% per tahun masih meningkat daya belinya.", "type": "true_false"}'::jsonb
WHERE id = '9f5216b3-399b-4411-b11e-d36d7ef9d300'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["saham", "obligasi"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: saham, obligasi.", "options": ["saham", "obligasi", "mutual funds", "deposits"], "parameters": {}, "question": "A balanced portofolio might include ________, ________, and other aset classes.", "type": "word_bank"}'::jsonb
WHERE id = '91cd0e05-5221-475c-946d-306d43120a26'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["risiko", "return"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: risiko, return.", "options": ["risiko", "return", "diversifikasi", "likuiditas"], "parameters": {}, "question": "Investors must understand the trade-off between ________ and expected ________.", "type": "word_bank"}'::jsonb
WHERE id = '89fb016e-0781-4951-95e5-ba49f463b370'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["bullish", "bearish"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: bullish, bearish.", "options": ["bullish", "bearish", "sideways", "volatile"], "parameters": {}, "question": "When investors are ________, they expect prices to rise; when ________, they expect declines.", "type": "word_bank"}'::jsonb
WHERE id = '8ff715a0-85c8-46b4-9ffb-4ae7cf33c83e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Total compensation termasuk risiko", "difficulty": "intermediate", "explanation": "benar path: Total compensation termasuk risiko. This represents the most financially sound decision at this stage.", "options": ["Which office is nicer", "Total compensation termasuk risiko", "Which has better Instagram", "Friend''s opinion"], "parameters": {"full_tree": {"scenario": "You receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.", "stages": [{"correct": "Total compensation including risk", "next": {"correct": "Use expected value (probability-weighted)", "next": {"correct": "Depends on risk tolerance and obligations", "options": ["Startup for higher expected value", "Bank for stability", "Negotiate bank to Rp 12M", "Decline both, travel"], "question": "Expected value of startup package ≈ Rp 11M/month. Bank = Rp 10M. But you have Rp 5M/month expenses. Decision?"}, "options": ["Assume maximum value", "Use expected value (probability-weighted)", "Ignore it entirely", "Ask the CEO"], "question": "Startup equity could be worth Rp 500M or zero. How to value it?"}, "options": ["Which office is nicer", "Total compensation including risk", "Which has better Instagram", "Friend''s opinion"], "question": "First factor to evaluate?"}]}}, "question": "Decision Tree Scenario:\n\nYou receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.\n\nFirst factor to evaluate?", "type": "decision_tree"}'::jsonb
WHERE id = '433fd2c0-aad3-4a66-ac88-b6ca983e6305'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "High-yield savings account", "difficulty": "intermediate", "explanation": "Emergency funds need likuiditas and capital preservation, which savings accounts provide better than volatile saham.", "options": ["High-yield savings account", "saham portofolio", "Both equally appropriate", "Cryptocurrency wallet"], "parameters": {}, "question": "For emergency funds: is a high-yield savings account or a saham portofolio more appropriate?", "type": "comparison"}'::jsonb
WHERE id = 'dbb87dd6-fc20-4289-b7cb-52cc13a022cb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mixed aset classes", "difficulty": "intermediate", "explanation": "diversifikasi across aset classes, sectors, and geographies reduces concentration risiko.", "options": ["100% banking stocks", "Mixed aset classes", "Both are equally diversified", "diversifikasi does not matter"], "parameters": {}, "question": "Which portofolio is likely more diversified: 100% Indonesian banking saham or a mix of Indonesian saham, obligasi, and global ETFs?", "type": "comparison"}'::jsonb
WHERE id = '7a4c7298-c08b-43dd-901b-b5524568091d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "dollar cost averaging", "difficulty": "intermediate", "explanation": "DCA spreads purchases dari waktu ke waktu, reducing the impact of berinvestasi at a market peak.", "options": ["lump sum berinvestasi", "dollar cost averaging", "Both eliminate timing risiko", "Neither helps"], "parameters": {}, "question": "Compare lump sum berinvestasi vs dollar cost averaging (DCA) in a volatile market. Which typically reduces timing risiko?", "type": "comparison"}'::jsonb
WHERE id = '1c3a1843-3db1-4548-98b1-2555e541a3c3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Identify kebutuhan → Identify keinginan → Allocate 50% to kebutuhan → Allocate 30% to keinginan → Save 20%", "options": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "parameters": {}, "question": "urutkan langkah-langkah to apply the 50/30/20 anggaran rule:", "type": "ordering"}'::jsonb
WHERE id = '207f9e60-2d06-41c1-b2d8-f544ea634941'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Research the company → Analyze financial statements → Check valuation metrics → Consider market conditions → Decide position size", "options": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "parameters": {}, "question": "urutkan langkah-langkah for fundamental saham analysis:", "type": "ordering"}'::jsonb
WHERE id = '958036bb-89fa-4077-8d11-4b96bcf27e89'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Feel market panic → Stop and breathe → Review your investasi plan → Check fundamentals → Decide based on strategy not emotion", "options": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "parameters": {}, "question": "urutkan langkah-langkah to handle market volatilitas emotionally:", "type": "ordering"}'::jsonb
WHERE id = '969e07f9-04ef-4641-9c1e-6ac0469939d6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The power of bunga majemuk", "difficulty": "intermediate", "explanation": "The dramatic difference between simple accumulation and compound growth demonstrates why starting early and staying invested matters.", "options": ["menentukan waktu pasar", "The power of bunga majemuk", "Day trading profits", "Currency hedging"], "parameters": {"image_description": "An infographic showing compound growth: Rp 1M invested monthly at 7% annual return grows to Rp 1.2B over 30 years vs only Rp 360M without interest."}, "question": "[IMAGE: An infographic showing compound growth: Rp 1M invested per bulan at 7% annual return grows to Rp 1.2B over 30 years vs hanya Rp 360M without bunga.]\n\nWhat principle is this infographic illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = 'b89daebc-effd-4c0e-b16d-474af5eb6240'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The saham is in a consolidation phase", "difficulty": "intermediate", "explanation": "Sideways movement without clear trend typically indicates consolidation, where buyers and sellers are in equilibrium.", "options": ["The saham is definitely going up", "The saham is in a consolidation phase", "Sell immediately", "keuntungan terjamin opportunity"], "parameters": {"image_description": "A candlestick chart of a single stock over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend."}, "question": "[IMAGE: A candlestick chart of a single saham over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend.]\n\nWhat conclusion can be drawn from this price action?", "type": "image_interpretation"}'::jsonb
WHERE id = '3e1bd41b-f52b-417e-9d4a-228d410e3802'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "saham have historically outpaced inflasi", "difficulty": "intermediate", "explanation": "The chart shows that while savings lose daya beli to inflasi, equities have historically provided returns that exceed inflasi.", "options": ["Savings accounts beat inflasi", "saham have historically outpaced inflasi", "semua investments are equal", "Cash yang terbaik store of value"], "parameters": {"image_description": "A bar chart comparing inflation rate (3%) vs savings account interest (2%) vs stock market average return (10%) over 10 years."}, "question": "[IMAGE: A bar chart comparing inflasi rate (3%) vs savings account bunga (2%) vs saham market average return (10%) over 10 years.]\n\nWhat key insight does this comparison reveal?", "type": "image_interpretation"}'::jsonb
WHERE id = '2bcae7bc-a230-4e65-b8c2-d4017f20758e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8%", "difficulty": "intermediate", "explanation": "Weighted return = (0.60 × 10%) + (0.40 × 5%) = 6% + 2% = 8%.", "parameters": {"hint": "Multiply each allocation by its return and sum the results."}, "question": "You have Rp 50M to invest. You allocate 60% to saham (expected 10% return) and 40% to obligasi (expected 5% return). apa the expected portofolio return?", "type": "calculation"}'::jsonb
WHERE id = 'c566327d-c6a6-447c-aa05-a6e1a8128e98'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "-2%", "difficulty": "intermediate", "explanation": "riil return ≈ nominal return - inflasi rate = 3% - 5% = -2%. Your daya beli is declining.", "parameters": {"hint": "Subtract inflation from the nominal interest rate."}, "question": "Your savings account pays 3% bunga per tahun. inflasi is 5%. apa your approximate riil return?", "type": "calculation"}'::jsonb
WHERE id = '91f3e295-9e19-42b6-aa49-c50c84c656b5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "9", "difficulty": "intermediate", "explanation": "Rule of 72: Years to double = 72 / interest rate. 72 / 8 = 9 years.", "parameters": {"hint": "Divide 72 by the annual return percentage."}, "question": "Using the Rule of 72, how many years does it take to double money at 8% annual return?", "type": "calculation"}'::jsonb
WHERE id = 'c83ff655-ef56-4d60-9996-de4c1186ad18'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "Falling prices", "pasar bullish": "Rising prices", "koreksi": "10%+ decline from peak", "Sideways": "Flat movement"}, "difficulty": "intermediate", "explanation": "benar matches: pasar bullish → Rising prices, pasar bearish → Falling prices, Sideways → Flat movement, koreksi → 10%+ decline from peak", "options": {"left": ["pasar bullish", "pasar bearish", "Sideways", "koreksi"], "right": ["Rising prices", "Falling prices", "Flat movement", "10%+ decline from peak"]}, "parameters": {}, "question": "Match each market condition with its description:", "type": "matching"}'::jsonb
WHERE id = '52f9e123-5a05-4384-9b92-6f5a321fc068'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Confirmation Bias": "Seeking confirming info", "FOMO": "Fear of missing out", "aversi rugi": "Fear of losses > joy of gains", "Overconfidence": "Excessive self-assurance"}, "difficulty": "intermediate", "explanation": "Correct matches: Loss Aversion → Fear of losses > joy of gains, FOMO → Fear of missing out, Confirmation Bias → Seeking confirming info, Overconfidence → Excessive self-assurance", "options": {"left": ["aversi rugi", "FOMO", "Confirmation Bias", "Overconfidence"], "right": ["Fear of losses > joy of gains", "Fear of missing out", "Seeking confirming info", "Excessive self-assurance"]}, "parameters": {}, "question": "Match each bias perilaku with its definition:", "type": "matching"}'::jsonb
WHERE id = 'ffaa48e9-5e02-4dc8-bbee-d3fcade25b92'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni memilih naik ojek online saat hujan deras. Risikonya adalah perjalanan lebih lama dan mahal. Imbalannya adalah ia sampai di rumah lebih cepat dan lebih aman daripada naik motor sendiri."}'::jsonb
WHERE id = '31a8e682-45c4-4d0e-8960-4b0f45034868'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina meminjamkan Rp200.000 kepada teman yang sering terlambat bayar. Risikonya adalah temannya tidak membayar kembali. Imbalannya adalah temannya bisa lekas menyelesaikan masalah dan Rina mendapat reputasi sebagai teman yang membantu."}'::jsonb
WHERE id = 'b83b8186-aab0-485c-aa27-cf875b0fddda'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Risiko adalah kemungkinan hasil yang terjadi lebih buruk dari yang diharapkan. Semua pilihan memiliki risiko, termasuk menyimpan uang di bantal yang berisiko hilang atau inflasi."}'::jsonb
WHERE id = '2e46bf32-c5bd-4d05-af5d-d4c661e2309f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Mengelola risiko bukan berarti menghindari risiko sepenuhnya. Kita mengenali risiko, memutuskan apakah imbalannya sepadan, lalu mengambil langkah pengamanan jika perlu."}'::jsonb
WHERE id = 'e4944274-1c80-41c0-90a5-8a1c90147c1f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Risiko utama adalah uangnya tidak kembali. Rina bisa meminimalkan risiko dengan meminjam dalam jumlah kecil atau meminta jaminan.", "caseText": "Rina diminta meminjamkan Rp500.000 kepada teman yang baru beberapa kali bertemu. Teman itu berjanji membayar minggu depan, tetapi Rina mendengar dia sering menunda hutang.", "difficulty": "beginner", "explanation": "Risiko adalah kemungkinan hasil buruk. Meminjamkan uang kepada seseorang yang sering menunda berarti risiko gagal bayar tinggi.", "followUp": {"answer": "Teman tidak membayar kembali", "explanation": "Risiko kredit adalah lawan tidak memenuhi janji pembayaran.", "options": ["Teman tidak membayar kembali", "Rina kehilangan waktu", "Rina kehilangan kesempatan memakai uang itu", "Teman meminjam lagi"], "question": "Apa risiko utama yang dihadapi Rina?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = 'a346f094-7c26-4d27-bf36-e08311a6a357'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Meminjamkan uang tanpa jaminan", "difficulty": "beginner", "explanation": "Meminjamkan uang tanpa jaminan berisiko lawan tidak membayar kembali.", "options": ["Meminjamkan uang tanpa jaminan", "Menyimpan uang di bank berlisensi", "Membeli pulsa di konter resmi", "Membayar uang kos tepat waktu"], "question": "Manakah contoh risiko dalam kehidupan sehari-hari?", "type": "multiple_choice"}'::jsonb
WHERE id = 'ef3c2514-0e5d-444c-8ac8-7582f6ab06f0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Risiko ada di mana saja: meminjamkan uang, naik kendaraan, memilih jurusan, bahkan menyimpan uang di rumah.", "question": "Risiko hanya ada dalam investasi, tidak ada dalam kehidupan sehari-hari.", "type": "true_false"}'::jsonb
WHERE id = 'b74b89ec-80be-4d76-8c7b-999ab614c2ad'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lebih buruk", "difficulty": "beginner", "explanation": "Risiko berkaitan dengan hasil negatif atau tidak sesuai harapan yang mungkin terjadi.", "question": "Risiko adalah kemungkinan hasil yang _____ dari yang diharapkan.", "type": "fill_blank"}'::jsonb
WHERE id = 'b321dd5b-9303-4609-91ac-0594aeb3bb96'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayu dipinjami Rp500.000 oleh temannya. Ia bisa meminta dibayar hari ini atau tiga bulan lagi. Jika dibayar hari ini, Bayu bisa membeli charger hp yang dibutuhkan sekarang dan mulai bekerja sebagai freelancer. Uang yang diterima lebih awal memberi lebih banyak pilihan."}'::jsonb
WHERE id = 'a47fe829-db38-4187-b7fd-3b7a734a2635'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina ditawari uang tunai Rp1 juta sekarang atau Rp1 juta setahun lagi. Jika ia terima sekarang, uang itu bisa disimpan di deposito dan menghasilkan bunga. Menerima lebih awal memberinya nilai lebih."}'::jsonb
WHERE id = 'b8058b41-c540-43a9-ae5b-332592daf77d'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Menunggu pembayaran memiliki biaya kesempatan. Uang yang ditangguhkan tidak bisa digunakan untuk kebutuhan mendesak atau menghasilkan bunga selama masa tunggu."}'::jsonb
WHERE id = 'e6f09959-6b2d-47e7-9d30-86b59e9dd4ca'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Nilai waktu uang berarti uang yang diterima sekarang lebih berharga daripada uang yang diterima di masa depan, karena uang sekarang bisa dipakai, ditabung, atau diinvestasikan."}'::jsonb
WHERE id = '866365a1-94f0-4391-a04f-662ada90e261'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena bisa langsung dipakai atau ditabung", "difficulty": "beginner", "explanation": "Uang sekarang bisa digunakan untuk kebutuhan atau menghasilkan bunga, sehingga memiliki nilai lebih.", "options": ["Karena bisa langsung dipakai atau ditabung", "Karena nominalnya lebih besar", "Karena uang masa depan tidak berharga", "Karena harga barang pasti turun"], "question": "Mengapa uang Rp500.000 yang diterima hari ini lebih baik daripada Rp500.000 yang diterima tiga bulan lagi?", "type": "multiple_choice"}'::jsonb
WHERE id = 'ba535b49-7d41-4e2e-8e13-ad85d8fe7368'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Secara umum uang sekarang lebih berharga, tetapi ada pengecualian seperti bunga tinggi pada pinjaman yang harus dibayar lebih cepat.", "question": "Menerima uang lebih cepat selalu lebih baik daripada menerimanya nanti.", "type": "true_false"}'::jsonb
WHERE id = '3b2d0410-d796-43f3-b0b4-1d097c272635'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Kehilangan kesempatan memakai atau menabung uang selama masa tunggu", "difficulty": "beginner", "explanation": "Selama menunggu, uang tersebut tidak bisa digunakan untuk kebutuhan atau menghasilkan bunga.", "options": ["Kehilangan kesempatan memakai atau menabung uang selama masa tunggu", "Nominal uang berkurang otomatis", "Uang hilang selamanya", "Bank meminta biaya administrasi"], "question": "Biaya kesempatan dari menunggu pembayaran adalah ...", "type": "multiple_choice"}'::jsonb
WHERE id = '853ff6ac-d128-44a0-a6c2-f4b87163de33'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "bunga", "difficulty": "beginner", "explanation": "Bunga adalah imbalan atas waktu penyimpanan uang, sehingga uang sekarang bisa tumbuh menjadi lebih besar di masa depan.", "question": "Uang yang diterima sekarang lebih bernilai karena bisa menghasilkan _____ jika ditabung atau diinvestasikan.", "type": "fill_blank"}'::jsonb
WHERE id = '65a3eccb-6d57-4170-b943-d7b72b859c18'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Doni, pegawai baru di Bandung, memiliki pendapatan bersih Rp 4.000.000 per bulan. Ia menerapkan aturan 50/30/20 dengan penyesuaian: Rp 2.000.000 untuk kebutuhan (kos, makan, transport), Rp 800.000 untuk keinginan (nonton bioskop, jalan-jalan), dan Rp 1.200.000 untuk tabungan serta dana darurat. Setiap minggu Doni meninjau aplikasi catatan keuangannya untuk memastikan tidak over budget."}'::jsonb
WHERE id = 'fdd59825-5658-45e3-9a84-c13d1a60989f'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["53eef1ac-2553-48d9-92a0-af6159d7d369"], "text": "Raka mengevaluasi langganannya setiap 3 bulan: streaming, musik, cloud, gym. Ia membatalkan dua langganan yang jarang digunakan dan menghemat Rp 150.000 per bulan."}'::jsonb
WHERE id = '8c6d70a1-42be-4da9-a592-040626908bf7'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Rian menggunakan aplikasi catatan keuangan untuk mencatat setiap pengeluaran harian. Setiap akhir minggu, ia meninjau apakah pengeluarannya sesuai anggaran. Jika melebihi batas, ia mengurangi kategori keinginan minggu depan."}'::jsonb
WHERE id = 'cba0520f-5650-4088-afa8-dcabf2737b00'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Budi gaji Rp3.000.000. Kebutuhan Rp1.500.000 (50%), keinginan Rp900.000 (30%), tabungan/utang Rp600.000 (20%). Jika kebutuhannya melonjak karena biaya kuliah, Budi harus mengurangi keinginan sementara, bukan mengurangi tabungan."}'::jsonb
WHERE id = '14dfd850-27ba-4b42-991b-ca7e803bc79f'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Keluarga Pak Budi di Surabaya membuat anggaran bulanan dengan menyisihkan dulu Rp 1 juta untuk tabungan pendidikan anak, baru kemudian mengatur pengeluaran lainnya. Prinsip \"bayar diri sendiri dulu\" membantu mereka konsisten menabung."}'::jsonb
WHERE id = 'e1d15afb-5d2b-4651-a0ce-d2847e65ca0d'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Ani bekerja paruh waktu dengan gaji Rp2.000.000 per bulan. Kos Rp800.000 dan makan Rp600.000 adalah kebutuhan (70%). Ia ingin streaming dan hangout Rp400.000 (20%). Menurut 50/30/20, ia harus sisihkan Rp200.000 (10%) untuk tabungan/utang, lebih idealnya kurangi keinginan hingga 30% agar tabungan 20%."}'::jsonb
WHERE id = 'd7ec453f-4959-4e6a-a536-eafbab47e54c'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Ani bekerja paruh waktu dengan penghasilan Rp 2.500.000 per bulan. Ia menerapkan aturan 50/30/20: Rp 1.250.000 untuk kebutuhan (kos, transport, makan), Rp 750.000 untuk keinginan (streaming, hangout), dan Rp 500.000 untuk tabungan serta pelunasan utang kecil kepada keluarga."}'::jsonb
WHERE id = 'a48ffaed-298f-4de6-9697-7e8b4d8e689f'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Ibu Siti membuat daftar belanja mingguan sebelum ke pasar. Dengan daftar, ia tidak tergoda membeli barang di luar kebutuhan dan menghemat Rp 100.000 per minggu."}'::jsonb
WHERE id = '3020cf7e-2f44-45a6-9050-ec77526afd6f'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Fajar, karyawan baru di Jakarta, menggunakan aplikasi catatan keuangan untuk melacak pengeluaran harian. Ia menyadari 30% uangnya habis untuk delivery makanan. Ia mulai membawa bekal dan mengurangi pesan antar."}'::jsonb
WHERE id = 'd2c9427e-e3c7-475c-bf8c-46f831a4db38'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04", "ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Alya menerima uang saku Rp 2.500.000 per bulan. Ia menerapkan 50/30/20: Rp 1.250.000 untuk kebutuhan (kos, makan, transport), Rp 750.000 untuk keinginan (nonton, jajan), dan Rp 500.000 untuk tabungan."}'::jsonb
WHERE id = 'a5fd353d-8499-4a87-8bde-8e5e9298d426'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Seorang mahasiswa di Malang menggunakan metode amplop: setiap awal bulan ia membagi uang saku ke beberapa kategori dalam dompet terpisah. Ketika amplop hiburan habis, ia berhenti berfoya-foya."}'::jsonb
WHERE id = 'a87ceb81-5fda-48a0-b1ec-9f2cacf16671'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953", "53eef1ac-2553-48d9-92a0-af6159d7d369"], "text": "Keluarga muda di Tangerang menyisihkan 10% gaji untuk dana darurat sebelum membayar tagihan. Setelah 1 tahun, mereka punya cadangan 3 bulan pengeluaran."}'::jsonb
WHERE id = '0ec8cfea-0661-4950-954f-627beaea36b5'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["53eef1ac-2553-48d9-92a0-af6159d7d369"], "text": "Nina ingin membeli laptop Rp 8 juta. Gajinya Rp 4 juta per bulan. Ia membuat target menabung Rp 1 juta per bulan selama 8 bulan, bukan memakai paylater dengan bunga tinggi."}'::jsonb
WHERE id = 'f7f2137f-ec74-418a-9b13-fd3c62d087b1'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Sebuah UKM di Bandung memisahkan rekening operasional dan rekening pribadi pemilik. Pemilik mengambil gaji tetap Rp 3 juta per bulan, sehingga keuangan bisnis tidak tercampur dengan pengeluaran pribadi."}'::jsonb
WHERE id = '113bc537-eb0b-465d-96f9-3ab54a18c0ed'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Dewa, freelancer desain, memiliki pendapatan tidak tetap. Bulan ramai ia tabung 30% penghasilan, bulan sepi ia pakai tabungan tersebut tanpan mengutang."}'::jsonb
WHERE id = '18eb5284-ee42-4d0c-9998-7127797cf8d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Anggaran bukan larangan menghabiskan uang, tapi rencana pengeluaran. Dengan anggaran, kita tahu uang pergi ke mana dan bisa menyesuaikan jika ada tujuan penting."}'::jsonb
WHERE id = '8e0c5c79-e511-4725-a91a-43b912b10a89'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Bantu pengguna membuat anggaran sederhana dengan aturan 50/30/20 menggunakan contoh penghasilan dan biaya hidup di Indonesia.", "text": "Anggaran adalah rencana penggunaan uang. Aturan 50/30/20 membagi pendapatan: 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan dan pelunasan utang. Di Indonesia, mahasiswa atau pekerja muda dapat menyesuaikan proporsi ini sesuai biaya hidup dan tanggungan keluarga. Yang terpenting adalah mencatat pengeluaran dan meninjau anggaran secara rutin."}'::jsonb
WHERE id = '16a15e36-a8f3-471a-8c40-a3b2260fcb0a'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Aturan 50/30/20 membagi pendapatan: 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan serta melunasi utang."}'::jsonb
WHERE id = '7967140c-bfaa-405d-8eb2-31cdcce599aa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "periksa izin OJK", "difficulty": "advanced", "explanation": "The flowchart explicitly shows OJK license verification as the first decision point before any further action.", "options": ["Read the prospectus", "periksa izin OJK", "Calculate potential returns", "Ask friends for opinion"], "parameters": {"image_description": "A flowchart: Start → Check OJK license → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths."}, "question": "[IMAGE: A flowchart: Start → periksa izin OJK → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths.]\n\nWhat yang pertama checkpoint in this financial safety flowchart?", "type": "image_interpretation"}'::jsonb
WHERE id = '4a867be8-c6e0-44c4-bc2f-b6caec922b83'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["P/E ratio", "EPS"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: rasio P/E, EPS.", "options": ["P/E ratio", "EPS", "ROE", "kapitalisasi pasar"], "parameters": {}, "question": "Fundamental metrics like ________ and ________ help evaluate saham valuations.", "type": "word_bank"}'::jsonb
WHERE id = '9ac49bea-4681-4f0d-a5fd-d8a48eeb0bd2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif"], "difficulty": "advanced", "explanation": "tanpa pencatatan dan anggaran, pengeluaran mudah melebihi pendapatan tanpa disadari.", "options": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI don''t need to anggaran karena I can selalu check my e-wallet balance. I have 5 different e-wallets and I''m not sure berapa banyak I spend total each month.", "type": "spot_mistake"}'::jsonb
WHERE id = '7871f63f-08dc-46ff-bac7-34816faa8298'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions"], "difficulty": "advanced", "explanation": "The disposition effect (selling winners, holding losers) and confirmation bias destroy long-term returns.", "options": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI sold my profitable saham to realize gains but kept my losing saham hoping they''d recover. I read one article that confirmed the losers would bounce back.", "type": "spot_mistake"}'::jsonb
WHERE id = '39274c37-38c8-4a56-894a-37fe6c6a4702'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "compound", "difficulty": "advanced", "explanation": "bunga majemuk accelerates kekayaan growth by earning returns on returns dari waktu ke waktu.", "parameters": {}, "question": "________ bunga means earning returns on both your original investasi and the accumulated returns.", "type": "fill_blank"}'::jsonb
WHERE id = 'ecbced9a-d7bf-48d2-aeb6-a10711e05620'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "aversi rugi", "difficulty": "advanced", "explanation": "aversi rugi is a key concept in behavioral finance where losses hurt about twice as much as gains feel good.", "parameters": {}, "question": "The tendency to feel losses more intensely than equivalent gains disebut ________.", "type": "fill_blank"}'::jsonb
WHERE id = 'd684ccf0-835c-4054-a7d4-11f27e083645'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "IDX", "difficulty": "advanced", "explanation": "Bursa Efek Indonesia (IDX) is the national saham exchange of Indonesia.", "parameters": {}, "question": "________ is the Indonesian saham exchange where companies list their shares.", "type": "fill_blank"}'::jsonb
WHERE id = '104ccf31-ddb4-4f16-b0ad-b6c5bce81db0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The power of bunga majemuk", "difficulty": "advanced", "explanation": "The dramatic difference between simple accumulation and compound growth demonstrates why starting early and staying invested matters.", "options": ["menentukan waktu pasar", "The power of bunga majemuk", "Day trading profits", "Currency hedging"], "parameters": {"image_description": "An infographic showing compound growth: Rp 1M invested monthly at 7% annual return grows to Rp 1.2B over 30 years vs only Rp 360M without interest."}, "question": "[IMAGE: An infographic showing compound growth: Rp 1M invested per bulan at 7% annual return grows to Rp 1.2B over 30 years vs hanya Rp 360M without bunga.]\n\nWhat principle is this infographic illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = '2059ee33-a3c2-4a7d-8b5a-cb9f4b197476'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Long Term": ["Retirement savings", "Children''s education", "Estate planning"], "Medium Term": ["House down payment (3 years)", "Car purchase (1 year)"], "Short Term": ["dana darurat", "Next month''s rent", "Vacation fund"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"Short Term\": [\"dana darurat\", \"Next month''s rent\", \"Vacation fund\"], \"Medium Term\": [\"House down payment (3 years)\", \"Car purchase (1 year)\"], \"Long Term\": [\"Retirement savings\", \"Children''s education\", \"Estate planning\"]}", "options": {"buckets": ["Short Term", "Medium Term", "Long Term"], "items": ["dana darurat", "House down payment (3 years)", "Retirement savings", "Next month''s rent", "Car purchase (1 year)", "Children''s education", "Vacation fund", "Estate planning"]}, "parameters": {}, "question": "Organize each financial tujuan by its typical time horizon:", "type": "categorization"}'::jsonb
WHERE id = '4aa33088-fdfe-43b6-8315-8b6c861409b2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Investments": ["per bulan SIP", "saham purchase"], "kebutuhan": ["Rent payment", "Groceries"], "Savings": ["dana darurat deposit"], "keinginan": ["Netflix subscription", "Gym membership", "New sneakers"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"kebutuhan\": [\"Rent payment\", \"Groceries\"], \"keinginan\": [\"Netflix subscription\", \"Gym membership\", \"New sneakers\"], \"Savings\": [\"dana darurat deposit\"], \"Investments\": [\"per bulan SIP\", \"saham purchase\"]}", "options": {"buckets": ["kebutuhan", "keinginan", "Savings", "Investments"], "items": ["Rent payment", "Netflix subscription", "per bulan SIP", "dana darurat deposit", "Gym membership", "Groceries", "New sneakers", "saham purchase"]}, "parameters": {}, "question": "Categorize each item into the appropriate anggaran bucket:", "type": "categorization"}'::jsonb
WHERE id = 'a1fd3338-0d1d-4e13-8caa-9aeee7ff9e1e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Not an aset": ["Time with family", "Car (depreciating)", "Lifestyle sneakers"], "Risky Assets": ["Bitcoin", "Individual saham", "riil estate"], "Safe Assets": ["Bank deposit", "Government obligasi"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"Safe Assets\": [\"Bank deposit\", \"Government obligasi\"], \"Risky Assets\": [\"Bitcoin\", \"Individual saham\", \"riil estate\"], \"Not an aset\": [\"Time with family\", \"Car (depreciating)\", \"Lifestyle sneakers\"]}", "options": {"buckets": ["Safe Assets", "Risky Assets", "Not an aset"], "items": ["Bank deposit", "Bitcoin", "Time with family", "Government obligasi", "Individual saham", "Car (depreciating)", "riil estate", "Lifestyle sneakers"]}, "parameters": {}, "question": "Sort each item into the benar aset classification:", "type": "categorization"}'::jsonb
WHERE id = '0f362ef3-9abf-4562-a12c-c1401d3fa9a4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bunga majemuk": "bunga on bunga", "diversifikasi": "Spreading risiko across assets", "likuiditas": "Ease of converting to cash", "volatilitas": "Price fluctuation magnitude"}, "difficulty": "advanced", "explanation": "benar matches: likuiditas → Ease of converting to cash, volatilitas → Price fluctuation magnitude, diversifikasi → Spreading risiko across assets, bunga majemuk → bunga on bunga", "options": {"left": ["likuiditas", "volatilitas", "diversifikasi", "bunga majemuk"], "right": ["Ease of converting to cash", "Price fluctuation magnitude", "Spreading risiko across assets", "bunga on bunga"]}, "parameters": {}, "question": "Match each financial concept with its meaning:", "type": "matching"}'::jsonb
WHERE id = '2bb0b98b-b07f-434d-b314-7e8be7f29ce0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "anggaran is hanya for people with low pendapatan.", "type": "true_false"}'::jsonb
WHERE id = '49828446-bb16-4ed4-be7a-d733c02de179'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "cheaper", "difficulty": "advanced", "explanation": "Currency depreciation makes domestic goods cheaper for foreign buyers, potentially boosting exports.", "options": ["more expensive", "cheaper", "unchanged in price", "illegal"], "parameters": {}, "question": "If a country''s currency depreciates, its export goods become ________ for foreign buyers.", "type": "sentence_completion"}'::jsonb
WHERE id = '7bbb762d-062e-4b66-bec8-a31fa8bb8a65'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "advanced", "explanation": "P/E = Price per share / Earnings per share = 20,000 / 1,000 = 20.", "parameters": {"hint": "Divide stock price by earnings per share."}, "question": "A saham trades at Rp 20,000 with EPS of Rp 1,000. apa the rasio P/E?", "type": "calculation"}'::jsonb
WHERE id = '51afad43-021c-4f1f-bae6-95ea6c08d950'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "10", "difficulty": "advanced", "explanation": "EPS = Net pendapatan / Shares Outstanding = 100B / 10B = Rp 10 per share.", "parameters": {"hint": "Divide total net income by the number of shares."}, "question": "A company has net pendapatan of Rp 100B and 10B shares outstanding. apa the EPS?", "type": "calculation"}'::jsonb
WHERE id = 'ccdd9af1-0bf5-4dd2-a24c-82773ea03b95'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8%", "difficulty": "advanced", "explanation": "Weighted return = (0.60 × 10%) + (0.40 × 5%) = 6% + 2% = 8%.", "parameters": {"hint": "Multiply each allocation by its return and sum the results."}, "question": "You have Rp 50M to invest. You allocate 60% to saham (expected 10% return) and 40% to obligasi (expected 5% return). apa the expected portofolio return?", "type": "calculation"}'::jsonb
WHERE id = 'c7f0c249-295f-4593-8aad-b6be8b6dc392'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Feel market panic → Stop and breathe → Review your investasi plan → Check fundamentals → Decide based on strategy not emotion", "options": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "parameters": {}, "question": "urutkan langkah-langkah to handle market volatilitas emotionally:", "type": "ordering"}'::jsonb
WHERE id = 'fa368804-b55f-44db-9fe1-5fc75ef567f9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Calculate per bulan pendapatan → List fixed expenses → List variable expenses → Set savings target → Adjust spending to meet goals", "options": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "parameters": {}, "question": "urutkan langkah-langkah to create a per bulan anggaran:", "type": "ordering"}'::jsonb
WHERE id = 'f7c002d6-7617-40ea-a6a0-2adf8bf14520'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: buka rekening sekuritas → lengkapi proses kyc → setor dana → riset saham → tempatkan order pertama", "options": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "parameters": {}, "question": "urutkan langkah-langkah untuk mulai berinvestasi di saham indonesia:", "type": "ordering"}'::jsonb
WHERE id = '39ebc8d4-14d8-489b-823b-fae702e60ca9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Optimal portfolios for each risiko level", "difficulty": "advanced", "explanation": "The efficient frontier represents portfolios that offer the highest expected return for a given level of risiko.", "options": ["Highest return regardless of risiko", "Optimal portfolios for each risiko level", "The safest possible portofolio", "A guaranteed return threshold"], "parameters": {"image_description": "A scatter plot showing risk (volatility) on X-axis and return on Y-axis. Multiple Indonesian stocks plotted. A diagonal line shows the efficient frontier."}, "question": "[IMAGE: A scatter plot showing risiko (volatilitas) on X-axis and return on Y-axis. Multiple Indonesian saham plotted. A diagonal line shows the efficient frontier.]\n\napa yang the efficient frontier line represent?", "type": "image_interpretation"}'::jsonb
WHERE id = 'b36c4fea-5bf0-4114-825e-58f3d0b07906'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"obligasi": "Fixed pendapatan utang", "Deposit": "Bank savings product", "reksa dana": "Pooled investasi vehicle", "saham": "Company ownership"}, "difficulty": "advanced", "explanation": "benar matches: Deposit → Bank savings product, saham → Company ownership, obligasi → Fixed pendapatan utang, reksa dana → Pooled investasi vehicle", "options": {"left": ["Deposit", "saham", "obligasi", "reksa dana"], "right": ["Bank savings product", "Company ownership", "Fixed pendapatan utang", "Pooled investasi vehicle"]}, "parameters": {}, "question": "Match each investasi type with its description:", "type": "matching"}'::jsonb
WHERE id = '2da434e4-fd8e-4208-b541-41f37ccde956'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Confirmation Bias": "Seeking confirming info", "FOMO": "Fear of missing out", "aversi rugi": "Fear of losses > joy of gains", "Overconfidence": "Excessive self-assurance"}, "difficulty": "advanced", "explanation": "Correct matches: Loss Aversion → Fear of losses > joy of gains, FOMO → Fear of missing out, Confirmation Bias → Seeking confirming info, Overconfidence → Excessive self-assurance", "options": {"left": ["aversi rugi", "FOMO", "Confirmation Bias", "Overconfidence"], "right": ["Fear of losses > joy of gains", "Fear of missing out", "Seeking confirming info", "Excessive self-assurance"]}, "parameters": {}, "question": "Match each bias perilaku with its definition:", "type": "matching"}'::jsonb
WHERE id = '8e83c228-9f31-4027-a89c-68c9349e963b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "A sustained decrease in the general price level", "Hyperinflation": "Extremely rapid and out-of-control price increases", "inflasi": "A sustained increase in the general price level of goods and services", "Stagflation": "A period of high inflasi combined with economic stagnation"}, "difficulty": "advanced", "explanation": "benar matches: inflasi = A sustained increase in the general price level of goods and services, Deflation = A sustained decrease in the general price level, Stagflation = A period of high inflasi combined with economic stagnation, Hyperinflation = Extremely rapid and out-of-control price increases", "options": {"definitions": ["A sustained increase in the general price level of goods and services", "A sustained decrease in the general price level", "A period of high inflasi combined with economic stagnation", "Extremely rapid and out-of-control price increases"], "terms": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"]}, "parameters": {}, "question": "Match each economic term with its benar definition:", "type": "definition_match"}'::jsonb
WHERE id = '2934c7f1-5ae4-487a-8d38-9f99132a7f17'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "memulai lebih awal dan konsisten", "difficulty": "advanced", "explanation": "waktu di pasar and kontribusi konsisten jauh lebih penting daripada memilih saham or menentukan waktu pasar.", "options": ["memilih saham terbaik", "memulai lebih awal dan konsisten", "menentukan waktu pasar dengan sempurna", "memiliki informasi orang dalam"], "parameters": {}, "question": "faktor paling penting in membangun kekayaan melalui investasi is ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'c0671012-4b93-46a6-8915-11bb76253a97'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "disposition", "difficulty": "advanced", "explanation": "The disposition effect describes how investors prefer realizing gains over realizing losses.", "options": ["disposition", "confirmation", "anchoring", "availability"], "parameters": {}, "question": "In behavioral finance, the tendency to sell winning investments too early while holding losers too long disebut the ________ effect.", "type": "sentence_completion"}'::jsonb
WHERE id = '0be901fe-b12d-4577-ad8e-2c0bc5614799'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "advanced", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "Using lifecycle hypothesis, how should a person''s savings rate change from age 25 to 60 in Indonesia?"}, "question": "Using lifecycle hypothesis, how should a person''s savings rate change from age 25 to 60 di Indonesia? Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = '04218699-eb5f-4215-bd01-e841cc6c7d29'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "advanced", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "A 30-year-old professional must choose: MBA (Rp 500M cost, +30% salary) vs invest in property. Model NPV."}, "question": "A 30-year-old professional must choose: MBA (Rp 500M cost, +30% salary) vs invest in property. Model NPV. apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = '4664c335-65db-40a8-96e6-92a20eef1034'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "advanced", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "A parent considers leaving Rp 1B inheritance vs spending it on children''s education. Model the trade-off."}, "question": "A parent considers leaving Rp 1B inheritance vs spending it on children''s education. Model the trade-off. apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '0fb93e6a-24a1-4e9f-844e-c1a19c295ddb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Personal loan", "difficulty": "advanced", "explanation": "Credit card at 2.5% per bulan compounds to ~34.5% per tahun. Personal loan at 12% annual is far cheaper.", "options": ["Credit card", "Personal loan", "They are equal", "Depends on usage"], "parameters": {}, "question": "Between a credit card with 2.5% per bulan bunga and a personal loan with 12% annual bunga, which has lower effective cost?", "type": "comparison"}'::jsonb
WHERE id = 'ee7652de-5a7a-4cb6-a2ae-70bdfbecfc0c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Index fund berinvestasi", "difficulty": "advanced", "explanation": "Index funds offer instant diversifikasi, lower fees, and require less research and monitoring.", "options": ["Active memilih saham", "Index fund berinvestasi", "Both require equal expertise", "Neither is good for beginners"], "parameters": {}, "question": "Compare active memilih saham vs index fund berinvestasi for a beginner with limited time. Which is more suitable?", "type": "comparison"}'::jsonb
WHERE id = 'd1cfce5e-ec1d-4e68-874d-3730cefe5501'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "High-yield savings account", "difficulty": "advanced", "explanation": "Emergency funds need likuiditas and capital preservation, which savings accounts provide better than volatile saham.", "options": ["High-yield savings account", "saham portofolio", "Both equally appropriate", "Cryptocurrency wallet"], "parameters": {}, "question": "For emergency funds: is a high-yield savings account or a saham portofolio more appropriate?", "type": "comparison"}'::jsonb
WHERE id = '7a2c87bf-bce9-4b35-b410-7812abe70b12'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest"], "difficulty": "advanced", "explanation": "Credit card utang at 2.5% per bulan compounds to devastating levels. Minimum payments prolong utang for years.", "options": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI use my credit card for semua purchases karena I get cashback. I hanya pay the minimum balance each month. I have Rp 50M in credit card utang.", "type": "spot_mistake"}'::jsonb
WHERE id = 'e4ff7e2b-04b1-4be0-8051-3dae5efecfc9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["OJK", "BI"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: OJK, BI.", "options": ["OJK", "BI", "IDX", "SIPF"], "parameters": {}, "question": "di Indonesia, ________ regulates financial services while ________ manages monetary policy.", "type": "word_bank"}'::jsonb
WHERE id = '641d87ef-30e0-489e-8027-b4cac1863899'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["bullish", "bearish"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: bullish, bearish.", "options": ["bullish", "bearish", "sideways", "volatile"], "parameters": {}, "question": "When investors are ________, they expect prices to rise; when ________, they expect declines.", "type": "word_bank"}'::jsonb
WHERE id = '7b2578f3-5f44-462b-9d9a-6d6358d067d1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK license status", "difficulty": "beginner", "explanation": "benar path: OJK license status. This represents the most financially sound decision at this stage.", "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "parameters": {"full_tree": {"scenario": "A ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% monthly returns''.", "stages": [{"correct": "OJK license status", "next": {"correct": "Report to OJK and block", "next": {"correct": "Warn friends and family", "options": ["Ignore and move on", "Warn friends and family", "Post about it on social media", "Confront the scammer"], "question": "To protect others, best action?"}, "options": ["Invest a small amount to test", "Report to OJK and block", "Ask for a discount on entry fee", "Invite friends to join"], "question": "They have no OJK license but show ''proof'' of payments to others. What now?"}, "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "question": "First red flag to check?"}]}}, "question": "Decision Tree Scenario:\n\nA ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% per bulan returns''.\n\nFirst red flag to check?", "type": "decision_tree"}'::jsonb
WHERE id = '51b050e0-87aa-4bbd-bab6-e2da095e4171'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pay off semua credit card utang", "difficulty": "beginner", "explanation": "benar path: Pay off semua credit card utang. This represents the most financially sound decision at this stage.", "options": ["Invest in saham for high returns", "Pay off semua credit card utang", "Build dana darurat", "Buy a new car"], "parameters": {"full_tree": {"scenario": "You unexpectedly receive Rp 100M. You have Rp 30M in credit card debt at 2.5% monthly interest, no emergency fund, and no investments.", "stages": [{"correct": "Pay off all credit card debt", "next": {"correct": "Build 6-month emergency fund", "next": {"correct": "Diversified index fund portfolio", "options": ["All in one stock", "Diversified index fund portfolio", "Keep in savings", "Lend to a friend"], "question": "With emergency fund set, Rp 50M remains. Final decision?"}, "options": ["Invest everything in crypto", "Build 6-month emergency fund", "Start a business", "Luxury vacation"], "question": "After paying debt, you have Rp 70M left. Next step?"}, "options": ["Invest in stocks for high returns", "Pay off all credit card debt", "Build emergency fund", "Buy a new car"], "question": "First priority: What do you do with the first portion?"}]}}, "question": "Decision Tree Scenario:\n\nYou unexpectedly receive Rp 100M. You have Rp 30M in credit card utang at 2.5% per bulan bunga, no dana darurat, and no investments.\n\nFirst priority: What do you do with the first portion?", "type": "decision_tree"}'::jsonb
WHERE id = '3d889124-c10e-4b95-9060-78f951426b0b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Short-term volatilitas is normal, long-term trend matters", "difficulty": "beginner", "explanation": "The chart shows significant short-term drops but a long-term upward trend, illustrating why time in market beats timing the market.", "options": ["Markets selalu crash permanently", "Short-term volatilitas is normal, long-term trend matters", "Timing the market is easy", "Indonesian saham are too risky"], "parameters": {"image_description": "A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatility in 2022, steady climb in 2023-2024."}, "question": "[IMAGE: A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatilitas in 2022, steady climb in 2023-2024.]\n\napa yang this chart primarily demonstrate about long-term berinvestasi?", "type": "image_interpretation"}'::jsonb
WHERE id = '749f1688-8b52-45c0-8b7f-3ee49c5903e6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Starting early dramatically increases final kekayaan", "difficulty": "beginner", "explanation": "The accelerating growth shown in the timeline demonstrates the exponential power of bunga majemuk over long periods.", "options": ["You need to be rich to start", "Starting early dramatically increases final kekayaan", "Retirement is impossible", "hanya high earners can retire"], "parameters": {"image_description": "A timeline infographic: Age 25 (start investing Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B)."}, "question": "[IMAGE: A timeline infographic: Age 25 (start berinvestasi Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B).]\n\nWhat utama message of this retirement savings timeline?", "type": "image_interpretation"}'::jsonb
WHERE id = '5bc275a0-8903-4666-a714-99ffbe0bd973'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Currency depreciation and saham declines may be correlated", "difficulty": "beginner", "explanation": "Rupiah depreciation and saham market declines sering occur together during periods of foreign capital outflows and risiko aversion.", "options": ["Currency appreciation helps saham", "Currency depreciation and saham declines may be correlated", "saham and currency are unrelated", "Government controls both"], "parameters": {"image_description": "A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling."}, "question": "[IMAGE: A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling.]\n\nWhat relationship might this chart be illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = '265fb0d1-462c-4226-ba7d-311f26116c5b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "Behavioral biases hanya affect inexperienced investors.", "type": "true_false"}'::jsonb
WHERE id = '1bfacf6a-9d6e-429c-aa69-cca4b98845e3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Sharpe", "difficulty": "beginner", "explanation": "Therasio Sharpe helps investors understand return per unit of risiko taken.", "parameters": {}, "question": "The ________ ratio measures risiko-adjusted return by comparing excess return to volatilitas.", "type": "fill_blank"}'::jsonb
WHERE id = '453837c8-7ff7-4eb8-b238-8966c7478365'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "diversifikasi", "difficulty": "beginner", "explanation": "diversifikasi ensures that poor performance in one investasi does not destroy the entire portofolio.", "parameters": {}, "question": "________ is the practice of spreading investments across different assets to reduce risiko.", "type": "fill_blank"}'::jsonb
WHERE id = 'be4aeda6-952c-4c2b-970e-ab5e8bef3075'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan vs keinginan", "difficulty": "beginner", "explanation": "Understanding kebutuhan versus keinginan is fundamental to anggaran and menabung.", "parameters": {}, "question": "The concept of ________ helps individuals distinguish between essential and non-essential spending.", "type": "fill_blank"}'::jsonb
WHERE id = 'bee5e997-c65d-4484-8d31-3cd6ad7b57d6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20%", "difficulty": "beginner", "explanation": "Aturan 50/30/20 menggunakan 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan serta utang.", "options": ["50%", "30%", "20%", "10%"], "parameters": {}, "question": "Dalam aturan 50/30/20, berapa persen pendapatan yang dialokasikan untuk tabungan dan pelunasan utang?", "type": "multiple_choice"}'::jsonb
WHERE id = '0ec5a6ac-f406-4e49-b42e-42233f280f18'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kebutuhan", "keinginan"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: kebutuhan, keinginan.", "options": ["kebutuhan", "keinginan", "savings", "dana darurat"], "parameters": {}, "question": "Financial planning starts with distinguishing ________ from ________, then building reserves.", "type": "word_bank"}'::jsonb
WHERE id = 'acc48124-1c81-4516-be68-8381be8a8d5e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["principal", "bunga"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: principal, bunga.", "options": ["principal", "bunga", "compound", "maturity"], "parameters": {}, "question": "With ________ bunga, you earn returns on both your ________ and accumulated earnings.", "type": "word_bank"}'::jsonb
WHERE id = '6b6ff0eb-7e96-4bf2-8431-ddc532656901'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["menabung", "anggaran"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: menabung, anggaran.", "options": ["menabung", "anggaran", "berinvestasi", "spending"], "parameters": {}, "question": "Before ________, you should selalu create a ________ to plan your pendapatan and expenses.", "type": "word_bank"}'::jsonb
WHERE id = 'e980bec6-0559-4db2-ba46-9099fdd35c57'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Anggaran sebaiknya fleksibel dan disesuaikan dengan kondisi pendapatan serta pengeluaran yang berubah.", "parameters": {}, "question": "Anggaran harus kaku dan tidak boleh disesuaikan meskipun pendapatan berubah.", "type": "true_false"}'::jsonb
WHERE id = '52933b46-c41e-491a-bcb0-030fbed38bc8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "pencatatan", "difficulty": "beginner", "explanation": "Pencatatan pengeluaran membantu kita memantau arus uang dan menjalankan anggaran dengan disiplin.", "parameters": {}, "question": "Kegiatan mencatat setiap pengeluaran kecil setiap hari disebut _____ pengeluaran.", "type": "fill_blank"}'::jsonb
WHERE id = 'c5a4db39-7ac9-4687-b940-f1649f311a18'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kebutuhan", "keinginan"], "difficulty": "beginner", "explanation": "Aturan 50/30/20 membagi pendapatan untuk kebutuhan, keinginan, serta tabungan dan pelunasan utang.", "options": ["kebutuhan", "keinginan"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Aturan 50/30/20 membagi pendapatan menjadi _____ (50%), _____ (30%), dan tabungan/utang (20%).\"", "type": "word_bank"}'::jsonb
WHERE id = '41388bcd-578f-4dc3-9f34-15c62cd35ac0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Identifikasi kategori yang melebihi batas", "Kurangi pengeluaran kategori keinginan", "Alihkan selisih ke tabungan", "Evaluasi anggaran bulan depan"], "difficulty": "beginner", "explanation": "Mulai dari identifikasi masalah, kurangi keinginan, alihkan ke tabungan, lalu evaluasi anggaran berikutnya.", "options": ["Identifikasi kategori yang melebihi batas", "Kurangi pengeluaran kategori keinginan", "Alihkan selisih ke tabungan", "Evaluasi anggaran bulan depan"], "parameters": {}, "question": "Urutkan langkah mengatasi pengeluaran yang melebihi anggaran.", "type": "ordering"}'::jsonb
WHERE id = '61a89b27-6785-4f78-9625-8a7895584967'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Define risiko tolerance → Set time horizon → Choose aset allocation → Select specific investments → Rebalance periodically", "options": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "parameters": {}, "question": "urutkan langkah-langkah to build an investasi portofolio:", "type": "ordering"}'::jsonb
WHERE id = '6906a70c-e9db-4572-a0ff-6a071ff5cb23'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Spot red flags → Verify information → Consult trusted sources → Document concerns → Report to authorities if needed", "options": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "parameters": {}, "question": "urutkan langkah-langkah to respond to a potential investasi penipuan:", "type": "ordering"}'::jsonb
WHERE id = '177fb338-8e4f-4f4a-84f7-37bacc1546cb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Set financial goals → Track pendapatan and expenses → Create a anggaran → Build dana darurat → Start berinvestasi", "options": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "parameters": {}, "question": "Order these steps to build a solid financial foundation:", "type": "ordering"}'::jsonb
WHERE id = 'affbfafa-5608-41af-86a0-31b144c9d5d5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "50%", "difficulty": "beginner", "explanation": "Aturan 50/30/20 menggunakan 50% untuk kebutuhan, 30% untuk keinginan, dan 20% untuk tabungan serta utang.", "options": ["20%", "30%", "50%", "70%"], "parameters": {}, "question": "Dalam aturan 50/30/20, berapa persen yang dialokasikan untuk kebutuhan?", "type": "multiple_choice"}'::jsonb
WHERE id = 'b0d984ed-7e7e-4c5d-9cde-a2d15cbaa86e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Anggaran 50/30/20 menyisihkan 30% untuk keinginan, termasuk hiburan, asalkan tetap dalam batas.", "parameters": {}, "question": "Membuat anggaran berarti tidak boleh menghabiskan uang untuk hiburan sama sekali.", "type": "true_false"}'::jsonb
WHERE id = 'a7d13902-c344-4980-b51e-29c9e1e73d05'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"advanced Investor": "Uses derivatives, manages risiko", "beginner Investor": "Learns basics, uses deposits", "intermediate Investor": "Understands ratios, diversifies"}, "difficulty": "beginner", "explanation": "benar matches: beginner Investor → Learns basics, uses deposits, intermediate Investor → Understands ratios, diversifies, advanced Investor → Uses derivatives, manages risiko", "options": {"left": ["beginner Investor", "intermediate Investor", "advanced Investor"], "right": ["Learns basics, uses deposits", "Understands ratios, diversifies", "Uses derivatives, manages risiko"]}, "parameters": {}, "question": "Match each investor level with its characteristics:", "type": "matching"}'::jsonb
WHERE id = 'c6e95f1a-2ca8-4dd8-b945-283132c9320f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Fundamental Analysis": "Financial statements", "Quantitative Analysis": "Mathematical models", "Sentiment Analysis": "Market mood and emotions", "Technical Analysis": "Charts and patterns"}, "difficulty": "beginner", "explanation": "benar matches: Technical Analysis → Charts and patterns, Fundamental Analysis → Financial statements, Quantitative Analysis → Mathematical models, Sentiment Analysis → Market mood and emotions", "options": {"left": ["Technical Analysis", "Fundamental Analysis", "Quantitative Analysis", "Sentiment Analysis"], "right": ["Charts and patterns", "Financial statements", "Mathematical models", "Market mood and emotions"]}, "parameters": {}, "question": "Match each analysis approach with its focus:", "type": "matching"}'::jsonb
WHERE id = 'd3a52581-5511-47a3-99d9-84e0dc25f911'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"BI": "Central bank", "IDX": "saham exchange", "OJK": "Financial regulator", "SIPF": "Investor protection fund"}, "difficulty": "beginner", "explanation": "benar matches: OJK → Financial regulator, BI → Central bank, IDX → saham exchange, SIPF → Investor protection fund", "options": {"left": ["OJK", "BI", "IDX", "SIPF"], "right": ["Financial regulator", "Central bank", "saham exchange", "Investor protection fund"]}, "parameters": {}, "question": "Match each Indonesian financial institution with its primary function:", "type": "matching"}'::jsonb
WHERE id = '35f4b4f7-e4f9-4788-a6c9-4bbbec7d0cfc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "pelunasan utang", "difficulty": "beginner", "explanation": "20% dari pendapatan sebaiknya dialokasikan untuk tabungan dan melunasi utang.", "parameters": {}, "question": "Dalam aturan 50/30/20, angka 20% digunakan untuk tabungan dan _____.", "type": "fill_blank"}'::jsonb
WHERE id = '40cc4611-6a45-4d7c-920f-d09ee3b4dda2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["mencatat", "meninjau"], "difficulty": "beginner", "explanation": "Pencatatan dan peninjauan rutin memastikan anggaran tetap realistis.", "options": ["mencatat", "meninjau"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Anggaran hanya berhasil jika kita secara rutin _____ pengeluaran dan _____ anggaran.\"", "type": "word_bank"}'::jsonb
WHERE id = '5429e479-96e5-4ca8-9255-6fcd4a93fb7c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Catat semua pemasukan", "Bagi pengeluaran menjadi kebutuhan, keinginan, dan tabungan", "Tetapkan batas untuk setiap kategori", "Evaluasi akhir bulan dan sesuaikan anggaran berikutnya"], "difficulty": "beginner", "explanation": "Mulai dari pemasukan, lalu kategorikan, tetapkan batas, dan evaluasi secara berkala.", "options": ["Catat semua pemasukan", "Bagi pengeluaran menjadi kebutuhan, keinginan, dan tabungan", "Tetapkan batas untuk setiap kategori", "Evaluasi akhir bulan dan sesuaikan anggaran berikutnya"], "parameters": {}, "question": "Urutkan langkah membuat anggaran bulanan.", "type": "ordering"}'::jsonb
WHERE id = 'd9727e4a-e7db-4ae2-ba81-da5c9bbcc91e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "50%", "difficulty": "beginner", "explanation": "Aturan 50/30/20: 50% kebutuhan, 30% keinginan, 20% tabungan atau utang.", "options": ["20%", "30%", "50%", "80%"], "parameters": {}, "question": "Menurut aturan 50/30/20, berapa persen uang yang idealnya untuk kebutuhan?", "type": "multiple_choice"}'::jsonb
WHERE id = '43a2499e-61bb-43bf-b1b6-5b00848493ad'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Keinginan adalah hal yang menyenangkan tetapi bisa ditunda, berbeda dengan kebutuhan.", "parameters": {}, "question": "Keinginan adalah pengeluaran yang harus dipenuhi untuk hidup sehari-hari.", "type": "true_false"}'::jsonb
WHERE id = '4964f7dd-37e5-4f5b-bd08-e9f415d61ba8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "diri sendiri", "difficulty": "beginner", "explanation": "Bayar diri sendiri dulu artinya prioritaskan tabungan sebelum pengeluaran lain.", "parameters": {}, "question": "Prinsip \"bayar ____ dulu\" berarti menyisihkan tabungan sebelum berbelanja.", "type": "fill_blank"}'::jsonb
WHERE id = 'a0584ac5-f28e-4ab6-ad24-6954b586f3fa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 1.000.000", "difficulty": "beginner", "explanation": "20% dari Rp 5.000.000 adalah Rp 1.000.000.", "options": ["Rp 500.000", "Rp 1.000.000", "Rp 1.500.000", "Rp 2.500.000"], "parameters": {}, "question": "Jika gaji Rina Rp 5.000.000, berapa idealnya untuk tabungan dengan aturan 50/30/20?", "type": "multiple_choice"}'::jsonb
WHERE id = '7440ebee-0f27-4ae0-a9b5-1818f84a9fea'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Catat pemasukan", "Bagi pengeluaran ke kategori", "Tetapkan tujuan tabungan", "Evaluasi akhir bulan"], "difficulty": "beginner", "explanation": "Catat pemasukan, bagi pengeluaran, tetapkan tujuan tabungan, lalu evaluasi.", "options": ["Tetapkan tujuan tabungan", "Catat pemasukan", "Evaluasi akhir bulan", "Bagi pengeluaran ke kategori"], "parameters": {}, "question": "Urutkan langkah membuat anggaran sederhana:", "type": "ordering"}'::jsonb
WHERE id = '65f19304-4b5e-4fe8-a1bf-41f827ab1683'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "beginner", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "You want to build a 3-month emergency fund earning Rp 4M/month. How much do you need?"}, "question": "You want to build a 3-month dana darurat earning Rp 4M/month. berapa banyak do you need? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = '9d7437fa-8b55-43a8-96f4-44e2cea319b9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "beginner", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "You spend Rp 2M/month on food delivery. What is one way to cut this without cooking every day?"}, "question": "You spend Rp 2M/month on food delivery. apa one way to cut this without cooking every day? apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = 'cc6d1ed3-26ff-4a50-aeee-9e02744f5983'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "beginner", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "You earn Rp 5M/month. Apply the 50/30/20 rule. How much for needs, wants, and savings?"}, "question": "You earn Rp 5M/month. Apply the 50/30/20 rule. berapa banyak for kebutuhan, keinginan, and savings? apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = '28495b08-8ec0-4743-923f-2f9534c0825b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Bayar kos bulanan", "difficulty": "beginner", "explanation": "Kos adalah kebutuhan tempat tinggal, sedangkan yang lain bisa ditunda.", "options": ["Nonton bioskop setiap minggu", "Bayar kos bulanan", "Beli sneakers baru", "Langganan kopi premium"], "parameters": {}, "question": "Manakah yang termasuk kebutuhan, bukan keinginan?", "type": "multiple_choice"}'::jsonb
WHERE id = '1e3c6de4-0bae-4ff6-8274-44b6979dd463'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Kebutuhan", "Keinginan", "Tabungan"], "difficulty": "beginner", "explanation": "50/30/20 adalah kebutuhan, keinginan, dan tabungan/utang.", "options": ["Kebutuhan", "Keinginan", "Tabungan", "Hutang konsumtif"], "parameters": {}, "question": "Kategori anggaran 50/30/20 terdiri dari: ____", "type": "word_bank"}'::jsonb
WHERE id = 'f8d09cdf-e55b-461a-9451-a2cbca6ce749'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Melihat kebocoran pengeluaran dan memperbaiki kebiasaan", "difficulty": "beginner", "explanation": "Evaluasi membantu kita melihat di mana uang bocor dan memperbaikinya.", "options": ["Menghabiskan sisa uang", "Melihat kebocoran pengeluaran dan memperbaiki kebiasaan", "Membandingkan gaji dengan teman", "Mencari pinjaman baru"], "parameters": {}, "question": "Tujuan evaluasi anggaran setiap bulan adalah?", "type": "multiple_choice"}'::jsonb
WHERE id = '0bafde3f-9fab-4d2c-bd97-cab6714e5fef'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Membawa bekal dan membatasi pesan antar", "difficulty": "beginner", "explanation": "Membatasi pengeluaran tidak perlu dan membawa bekal membantu anggaran tetap sehat.", "options": ["Belanja impulsif setiap gajian", "Membawa bekal dan membatasi pesan antar", "Menggunakan paylater untuk semua keinginan", "Tidak mencatat pengeluaran"], "parameters": {}, "question": "Kebiasaan mana yang paling mendukung anggaran sehat?", "type": "multiple_choice"}'::jsonb
WHERE id = '41f06dbb-5b4d-4ac5-a10e-297058fba75d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Dana darurat sebaiknya disisihkan di awal, sebelum keinginan.", "parameters": {}, "question": "Dana darurat sebaiknya disisihkan setelah semua keinginan terpenuhi.", "type": "true_false"}'::jsonb
WHERE id = 'b9fdd286-3669-4b08-8349-73ae6f21a667'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "1,600,000", "difficulty": "beginner", "explanation": "20% of 8,000,000 = 0.20 × 8,000,000 = Rp 1,600,000.", "parameters": {"hint": "Calculate 20% of the monthly income."}, "question": "You earn Rp 8M per bulan. Following the 50/30/20 rule, berapa banyak should go to savings and utang?", "type": "calculation"}'::jsonb
WHERE id = 'c63927bf-27c1-43bd-a836-574993dde006'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "0.69", "difficulty": "beginner", "explanation": "Portfolio beta = (0.50 × 1.2) + (0.30 × 0.3) + (0.20 × 0) = 0.60 + 0.09 + 0 = 0.69.", "parameters": {"hint": "Weight each asset''s beta by its portfolio allocation."}, "question": "A portofolio has 50% saham (beta 1.2), 30% obligasi (beta 0.3), 20% cash (beta 0). apa the portofolio beta?", "type": "calculation"}'::jsonb
WHERE id = '7479193f-0ff4-4680-a6fa-c3961c5161ee'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "69,770,000", "difficulty": "beginner", "explanation": "Using the future value of an annuity formula: FV = PMT × [(1+r)^n - 1]/r. With r = 0.5% per bulan, n = 60, PMT = 1,000,000. FV ≈ Rp 69.77M.", "parameters": {"hint": "Use FV annuity formula with monthly compounding."}, "question": "If you save Rp 1,000,000 per bulan at 6% annual bunga compounded per bulan, berapa banyak will you have after 5 years?", "type": "calculation"}'::jsonb
WHERE id = 'e8861246-c5e8-4bdc-9949-277f1f130fb5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 2M from age 30", "difficulty": "beginner", "explanation": "Starting earlier gives compounding more time to work. Rp 2M × 30 years at 7% beats Rp 5M × 15 years.", "options": ["Rp 2M from age 30", "Rp 5M from age 45", "Both equal at retirement", "Neither is enough"], "parameters": {}, "question": "For retirement savings starting at age 30: is it better to save Rp 2M per bulan or Rp 5M per bulan starting at age 45?", "type": "comparison"}'::jsonb
WHERE id = 'f436a585-241e-46dd-83d4-5b99597a10dc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Government obligasi", "difficulty": "beginner", "explanation": "Real return deposits: 4% - 3% = 1%. Bonds: 6% - 3% = 3%. Bonds provide better inflation protection.", "options": ["Fixed deposits", "Government obligasi", "Both equal", "Neither beats inflasi"], "parameters": {}, "question": "Compare fixed deposits (4% p.a.) vs government obligasi (6% p.a.) for a conservative investor. Which offers better riil returns if inflasi is 3%?", "type": "comparison"}'::jsonb
WHERE id = '4971ec9c-91e6-44e1-a458-36d5f2db6f27'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK-licensed bank deposit", "difficulty": "beginner", "explanation": "Licensed deposits are regulated and insured. Unlicensed platforms carry penipuan risiko and no investor protection.", "options": ["OJK-licensed bank deposit", "Unlicensed P2P platform", "Both equally safe", "Cannot determine"], "parameters": {}, "question": "Which is generally safer: keeping Rp 50M in an OJK-licensed bank deposit or berinvestasi in an unlicensed P2P platform promising 15% returns?", "type": "comparison"}'::jsonb
WHERE id = 'f05c179e-0586-4256-80b3-79a765ae4b6b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice"], "difficulty": "beginner", "explanation": "investasi decisions should be based on research and fundamentals, not superstition or unverified tips.", "options": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invest based on my horoscope and the advice of a WhatsApp group admin who claims to have informasi orang dalam. I tidak pernah read financial statements.", "type": "spot_mistake"}'::jsonb
WHERE id = 'fdd1a2b3-f5fc-4ec8-b910-dfb244020507'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')"], "difficulty": "beginner", "explanation": "Lottery is entertainment, not a rencana keuangan. The ''due'' fallacy ignores that each draw is independent.", "options": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy rencana keuangan is to win the lottery. I''ve spent Rp 5M on lottery tickets this year. I''m sure my numbers are due to come up soon.", "type": "spot_mistake"}'::jsonb
WHERE id = '24d25e77-d9a4-4af2-b2ea-56f3b1ff5d5a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time"], "difficulty": "beginner", "explanation": "Multiple errors: no diversifikasi, no due diligence, unrealistic return expectations, and unverified broker.", "options": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invested semua my savings in one saham karena my friend said it was a ''sure thing.'' I juga didn''t check if the broker was OJK-licensed. I''m sure I''ll double my money in 3 months!", "type": "spot_mistake"}'::jsonb
WHERE id = '805c38db-ca58-4316-903e-111411f3bd01'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan", "difficulty": "beginner", "explanation": "50% untuk kebutuhan hidup, 30% untuk keinginan, dan 20% untuk tabungan dan melunasi utang.", "question": "Dalam aturan 50/30/20, angka 50% digunakan untuk _____, 30% untuk keinginan, dan 20% untuk tabungan serta utang.", "type": "fill_blank"}'::jsonb
WHERE id = '389b4cb4-7b95-478a-bceb-09190b9cda1d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Anggaran 50/30/20 menyisihkan 30% untuk keinginan, termasuk hiburan, asalkan tetap dalam batas.", "question": "Anggaran berarti kita tidak boleh menghabiskan uang untuk hiburan sama sekali.", "type": "true_false"}'::jsonb
WHERE id = 'cf83323b-f919-48b9-a1fb-5b8e1d527f06'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp400.000", "difficulty": "beginner", "explanation": "20% dari Rp2.000.000 adalah Rp400.000 untuk tabungan dan melunasi utang.", "options": ["Rp400.000", "Rp600.000", "Rp1.000.000", "Rp200.000"], "question": "Ani gaji Rp2.000.000. Berapa idealnya dialokasikan untuk tabungan/utang menurut 50/30/20?", "type": "multiple_choice"}'::jsonb
WHERE id = '716d8b2d-2a06-43c8-9746-8e57e971d156'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "provide financial security during crises", "difficulty": "beginner", "explanation": "Emergency funds prioritize likuiditas and safety over returns, providing a buffer for unexpected expenses.", "options": ["maximize returns", "provide financial security during crises", "beat inflasi", "fund vacations"], "parameters": {}, "question": "The primary purpose of an dana darurat is to ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '2cf205df-519c-4caf-8d63-1cceeca816e7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "is not indicative of", "difficulty": "beginner", "explanation": "Standard disclaimer: past performance does not guarantee future results. Markets are inherently uncertain.", "options": ["guarantees", "is not indicative of", "is the hanya predictor of", "selalu exceeds"], "parameters": {}, "question": "When evaluating an investasi, past performance ________ future results.", "type": "sentence_completion"}'::jsonb
WHERE id = '4b858699-9a30-45d4-a77a-6b175f0845f2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "decreases", "difficulty": "beginner", "explanation": "riil return = nominal return - inflasi. If inflasi rises and nominal return is flat, riil return falls.", "options": ["increases", "decreases", "stays the same", "becomes irrelevant"], "parameters": {}, "question": "If inflasi rises while bunga rates stay flat, the riil return on savings ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '65e3c5de-70b0-4531-a87e-e3157e8b96ea'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"alpha": "Excess return relative to a benchmark", "beta": "Sensitivity of a saham''s returns to market movements", "Sharpe Ratio": "risiko-adjusted return measuring excess return per unit of risiko", "Standard Deviation": "A measure of the dispersion of returns around the mean"}, "difficulty": "beginner", "explanation": "benar matches: alpha = Excess return relative to a benchmark, beta = Sensitivity of a saham''s returns to market movements, Sharpe Ratio = risiko-adjusted return measuring excess return per unit of risiko, Standard Deviation = A measure of the dispersion of returns around the mean", "options": {"definitions": ["Excess return relative to a benchmark", "Sensitivity of a saham''s returns to market movements", "risiko-adjusted return measuring excess return per unit of risiko", "A measure of the dispersion of returns around the mean"], "terms": ["alpha", "beta", "Sharpe Ratio", "Standard Deviation"]}, "parameters": {}, "question": "Match each risiko/return measure with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '19677fb2-6ee5-4419-a159-e225a114928c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Total compensation termasuk risiko", "difficulty": "beginner", "explanation": "benar path: Total compensation termasuk risiko. This represents the most financially sound decision at this stage.", "options": ["Which office is nicer", "Total compensation termasuk risiko", "Which has better Instagram", "Friend''s opinion"], "parameters": {"full_tree": {"scenario": "You receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.", "stages": [{"correct": "Total compensation including risk", "next": {"correct": "Use expected value (probability-weighted)", "next": {"correct": "Depends on risk tolerance and obligations", "options": ["Startup for higher expected value", "Bank for stability", "Negotiate bank to Rp 12M", "Decline both, travel"], "question": "Expected value of startup package ≈ Rp 11M/month. Bank = Rp 10M. But you have Rp 5M/month expenses. Decision?"}, "options": ["Assume maximum value", "Use expected value (probability-weighted)", "Ignore it entirely", "Ask the CEO"], "question": "Startup equity could be worth Rp 500M or zero. How to value it?"}, "options": ["Which office is nicer", "Total compensation including risk", "Which has better Instagram", "Friend''s opinion"], "question": "First factor to evaluate?"}]}}, "question": "Decision Tree Scenario:\n\nYou receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.\n\nFirst factor to evaluate?", "type": "decision_tree"}'::jsonb
WHERE id = '837cbb23-e860-49a7-a03e-8d33374177aa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["risiko", "return"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: risiko, return.", "options": ["risiko", "return", "diversifikasi", "likuiditas"], "parameters": {}, "question": "Investors must understand the trade-off between ________ and expected ________.", "type": "word_bank"}'::jsonb
WHERE id = 'e65eafa6-d8c6-4a91-90ba-7c721ba0e4b6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Check if fundamentals changed", "difficulty": "intermediate", "explanation": "benar path: Check if fundamentals changed. This represents the most financially sound decision at this stage.", "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "parameters": {"full_tree": {"scenario": "The stock market drops 20% in one month. You have Rp 200M invested across 10 stocks.", "stages": [{"correct": "Check if fundamentals changed", "next": {"correct": "Hold and consider buying more", "next": {"correct": "Dollar cost average over 3 months", "options": ["All remaining cash at once", "Dollar cost average over 3 months", "Wait for ''the bottom''", "Borrow to invest"], "question": "You decide to buy more. Best approach?"}, "options": ["Panic sell to preserve capital", "Hold and consider buying more", "Switch to gold entirely", "Blame the government"], "question": "Fundamentals are intact. What action makes sense?"}, "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "question": "First reaction: What do you check?"}]}}, "question": "Decision Tree Scenario:\n\nThe saham market drops 20% in one month. You have Rp 200M invested across 10 saham.\n\nFirst reaction: What do you check?", "type": "decision_tree"}'::jsonb
WHERE id = '8262292b-7840-4fe9-b446-04378f6acda3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "24%", "difficulty": "intermediate", "explanation": "Initial investment: 200 × 5,000 = 1,000,000. Final value: 200 × 6,200 = 1,240,000. Return = (1,240,000 - 1,000,000) / 1,000,000 = 24%.", "parameters": {"hint": "Calculate total initial cost, total final value, then percentage change."}, "question": "A saham costs Rp 5,000 per share. You buy 200 shares. After 1 year, the price is Rp 6,200. apa your percentage return?", "type": "calculation"}'::jsonb
WHERE id = '45fdd357-6886-461e-83b7-73470cd8e659'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "9", "difficulty": "intermediate", "explanation": "Rule of 72: Years to double = 72 / interest rate. 72 / 8 = 9 years.", "parameters": {"hint": "Divide 72 by the annual return percentage."}, "question": "Using the Rule of 72, how many years does it take to double money at 8% annual return?", "type": "calculation"}'::jsonb
WHERE id = '3f96e50a-5759-4283-8347-7cd23cb4a49c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "-2%", "difficulty": "intermediate", "explanation": "riil return ≈ nominal return - inflasi rate = 3% - 5% = -2%. Your daya beli is declining.", "parameters": {"hint": "Subtract inflation from the nominal interest rate."}, "question": "Your savings account pays 3% bunga per tahun. inflasi is 5%. apa your approximate riil return?", "type": "calculation"}'::jsonb
WHERE id = '012349fa-d71a-4fe5-a3c7-735b9df26eb2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Research the company → Analyze financial statements → Check valuation metrics → Consider market conditions → Decide position size", "options": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "parameters": {}, "question": "urutkan langkah-langkah for fundamental saham analysis:", "type": "ordering"}'::jsonb
WHERE id = '45835fe4-7d81-47c9-8315-a7c11af2c242'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Identify kebutuhan → Identify keinginan → Allocate 50% to kebutuhan → Allocate 30% to keinginan → Save 20%", "options": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "parameters": {}, "question": "urutkan langkah-langkah to apply the 50/30/20 anggaran rule:", "type": "ordering"}'::jsonb
WHERE id = '0e65d38d-7c21-40c5-80e7-697cf743a936'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: periksa izin OJK → Read the prospectus → Understand the risks → Start with small amount → Monitor regularly", "options": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "parameters": {}, "question": "Order the proper due diligence steps before berinvestasi:", "type": "ordering"}'::jsonb
WHERE id = '4be54a16-a37e-40e8-87ce-c8767c0b6a10'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "You need to be rich to start berinvestasi.", "type": "true_false"}'::jsonb
WHERE id = 'b2a1c7f9-ec47-4e08-a6df-780f7c823aea'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "menabung money under your mattress is selalu better than bank deposits.", "type": "true_false"}'::jsonb
WHERE id = 'ee9785c9-cdff-4837-ae58-1a1c01898917'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["inflasi", "deflation"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: inflasi, deflation.", "options": ["inflasi", "deflation", "stagflation", "hyperinflation"], "parameters": {}, "question": "________ occurs when prices rise across the economy, while ________ is when prices fall.", "type": "word_bank"}'::jsonb
WHERE id = '1dc45963-cde4-446d-b8b7-473b4afbdc3f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["saham", "obligasi"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: saham, obligasi.", "options": ["saham", "obligasi", "mutual funds", "deposits"], "parameters": {}, "question": "A balanced portofolio might include ________, ________, and other aset classes.", "type": "word_bank"}'::jsonb
WHERE id = '31305303-ee58-45d0-8426-5b1e06cbe8b0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emotion-driven", "difficulty": "intermediate", "explanation": "Frequent monitoring and trading sering lead to emotional decision-making daripada disciplined strategy.", "options": ["patient long-term", "emotion-driven", "perfectly rational", "index-fund style"], "parameters": {}, "question": "An investor who checks their portofolio per hari and trades frequently is more likely to exhibit ________ behavior.", "type": "sentence_completion"}'::jsonb
WHERE id = '499d2cd9-daa8-44b0-9688-ba2dead28a49'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lower", "difficulty": "intermediate", "explanation": "diversifikasi reduces unsystematic (company-specific) risiko without sacrificing expected returns.", "options": ["higher", "lower", "equal", "unpredictable"], "parameters": {}, "question": "A diversified portofolio typically has ________ risiko than a concentrated portofolio with the same expected return.", "type": "sentence_completion"}'::jsonb
WHERE id = '7da74c17-adcd-4499-a60f-8da1b7ef5c21'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "intermediate", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "Create a 12-month cash flow forecast for a freelancer with irregular income (Rp 3M–8M/month)."}, "question": "Create a 12-month cash flow forecast for a freelancer with irregular pendapatan (Rp 3M–8M/month). Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = 'fc03c94e-58f5-488d-b95a-100afd32ad65'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Moderate risiko tolerance", "difficulty": "intermediate", "explanation": "A 50/30/15/5 split between saham, obligasi, cash, and gold represents balanced risiko — neither too conservative nor too aggressive.", "options": ["Ultra-conservative", "Moderate risiko tolerance", "Aggressive growth seeker", "Speculative trader"], "parameters": {"image_description": "A pie chart showing asset allocation: 50% stocks, 30% bonds, 15% cash, 5% gold. Labels show this is a moderate risk portfolio."}, "question": "[IMAGE: A pie chart showing aset allocation: 50% saham, 30% obligasi, 15% cash, 5% gold. Labels show this is a moderate risiko portofolio.]\n\nWhat type of investor does this aset allocation most likely represent?", "type": "image_interpretation"}'::jsonb
WHERE id = 'd30e1c92-d430-4705-846b-750afe2bc632'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mixed aset classes", "difficulty": "intermediate", "explanation": "diversifikasi across aset classes, sectors, and geographies reduces concentration risiko.", "options": ["100% banking stocks", "Mixed aset classes", "Both are equally diversified", "diversifikasi does not matter"], "parameters": {}, "question": "Which portofolio is likely more diversified: 100% Indonesian banking saham or a mix of Indonesian saham, obligasi, and global ETFs?", "type": "comparison"}'::jsonb
WHERE id = '334a0eb6-678f-409b-b791-c9679ce71c6f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "fall", "difficulty": "intermediate", "explanation": "obligasi prices and bunga rates have an inverse relationship. Higher rates mean existing obligasi are less attractive.", "options": ["rise", "fall", "remain unchanged", "become more volatile"], "parameters": {}, "question": "When the central bank raises bunga rates, obligasi prices generally ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'f3c9b56c-d0ab-4041-8d3d-3918e3bb1ae4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Leverage": "The use of borrowed capital to increase potential returns", "likuiditas": "The ease with which an aset can be converted to cash", "Solvency": "The ability to meet long-term financial obligations", "volatilitas": "The degree of variation in trading prices dari waktu ke waktu"}, "difficulty": "intermediate", "explanation": "benar matches: likuiditas = The ease with which an aset can be converted to cash, Solvency = The ability to meet long-term financial obligations, Leverage = The use of borrowed capital to increase potential returns, volatilitas = The degree of variation in trading prices dari waktu ke waktu", "options": {"definitions": ["The ease with which an aset can be converted to cash", "The ability to meet long-term financial obligations", "The use of borrowed capital to increase potential returns", "The degree of variation in trading prices dari waktu ke waktu"], "terms": ["likuiditas", "Solvency", "Leverage", "volatilitas"]}, "parameters": {}, "question": "Match each financial concept with its definition:", "type": "definition_match"}'::jsonb
WHERE id = '85bbb655-41b0-4c83-9bfe-f1661468b2e1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "A market condition where prices are falling or expected to fall", "pasar bullish": "A market condition where prices are rising or expected to rise", "koreksi": "A decline of 10% or more from a recent peak", "crash": "A sudden dramatic decline of 20% or more in saham prices"}, "difficulty": "intermediate", "explanation": "benar matches: pasar bullish = A market condition where prices are rising or expected to rise, pasar bearish = A market condition where prices are falling or expected to fall, koreksi = A decline of 10% or more from a recent peak, crash = A sudden dramatic decline of 20% or more in saham prices", "options": {"definitions": ["A market condition where prices are rising or expected to rise", "A market condition where prices are falling or expected to fall", "A decline of 10% or more from a recent peak", "A sudden dramatic decline of 20% or more in saham prices"], "terms": ["pasar bullish", "pasar bearish", "koreksi", "crash"]}, "parameters": {}, "question": "Match each market term with its description:", "type": "definition_match"}'::jsonb
WHERE id = '04506a83-c499-4209-a445-419750d20e6a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Dividend Yield": "Annual dividend per share divided by saham price", "EPS": "Net pendapatan divided by number of outstanding shares", "P/E Ratio": "Market price per share divided by earnings per share", "ROE": "Net pendapatan divided by shareholders'' equity"}, "difficulty": "intermediate", "explanation": "benar matches: rasio P/E = Market price per share divided by earnings per share, EPS = Net pendapatan divided by number of outstanding shares, ROE = Net pendapatan divided by shareholders'' equity, Dividend Yield = Annual dividend per share divided by saham price", "options": {"definitions": ["Market price per share divided by earnings per share", "Net pendapatan divided by number of outstanding shares", "Net pendapatan divided by shareholders'' equity", "Annual dividend per share divided by saham price"], "terms": ["P/E Ratio", "EPS", "ROE", "Dividend Yield"]}, "parameters": {}, "question": "Match each financial metric with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '2770ccfd-f0b4-4886-a32f-e8d4f191890b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "dollar cost averaging", "difficulty": "intermediate", "explanation": "DCA spreads purchases dari waktu ke waktu, reducing the impact of berinvestasi at a market peak.", "options": ["lump sum berinvestasi", "dollar cost averaging", "Both eliminate timing risiko", "Neither helps"], "parameters": {}, "question": "Compare lump sum berinvestasi vs dollar cost averaging (DCA) in a volatile market. Which typically reduces timing risiko?", "type": "comparison"}'::jsonb
WHERE id = 'e51ea97f-8dee-47e7-a4b5-147d4d54a5aa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Start berinvestasi early", "difficulty": "intermediate", "explanation": "At a young age, the power of compounding favors starting investments early, while low-bunga loans can be managed alongside.", "options": ["Pay off loans first completely", "Start berinvestasi early", "Do neither, spend on experiences", "Split equally"], "parameters": {}, "question": "For a 25-year-old with stable pendapatan: is it better to prioritize paying off low-bunga student loans or start berinvestasi early?", "type": "comparison"}'::jsonb
WHERE id = 'bdb4df3d-9578-49dd-ad73-606d7aa55d5f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The saham is in a consolidation phase", "difficulty": "intermediate", "explanation": "Sideways movement without clear trend typically indicates consolidation, where buyers and sellers are in equilibrium.", "options": ["The saham is definitely going up", "The saham is in a consolidation phase", "Sell immediately", "keuntungan terjamin opportunity"], "parameters": {"image_description": "A candlestick chart of a single stock over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend."}, "question": "[IMAGE: A candlestick chart of a single saham over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend.]\n\nWhat conclusion can be drawn from this price action?", "type": "image_interpretation"}'::jsonb
WHERE id = '51f3b9b7-e971-49a5-be3e-261aa3b2309d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "Falling prices", "pasar bullish": "Rising prices", "koreksi": "10%+ decline from peak", "Sideways": "Flat movement"}, "difficulty": "intermediate", "explanation": "benar matches: pasar bullish → Rising prices, pasar bearish → Falling prices, Sideways → Flat movement, koreksi → 10%+ decline from peak", "options": {"left": ["pasar bullish", "pasar bearish", "Sideways", "koreksi"], "right": ["Rising prices", "Falling prices", "Flat movement", "10%+ decline from peak"]}, "parameters": {}, "question": "Match each market condition with its description:", "type": "matching"}'::jsonb
WHERE id = '700a3a5a-7cc2-49af-a2f4-1fe75a7fe7ae'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "General price fall", "Hyperinflation": "Extreme rapid price rise", "inflasi": "General price rise", "Stagflation": "High inflasi + stagnation"}, "difficulty": "intermediate", "explanation": "benar matches: inflasi → General price rise, Deflation → General price fall, Stagflation → High inflasi + stagnation, Hyperinflation → Extreme rapid price rise", "options": {"left": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"], "right": ["General price rise", "General price fall", "High inflasi + stagnation", "Extreme rapid price rise"]}, "parameters": {}, "question": "Match each economic condition with its definition:", "type": "matching"}'::jsonb
WHERE id = '0ec9b25f-345d-4974-ab8d-347eb7ef962b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "saham have historically outpaced inflasi", "difficulty": "intermediate", "explanation": "The chart shows that while savings lose daya beli to inflasi, equities have historically provided returns that exceed inflasi.", "options": ["Savings accounts beat inflasi", "saham have historically outpaced inflasi", "semua investments are equal", "Cash yang terbaik store of value"], "parameters": {"image_description": "A bar chart comparing inflation rate (3%) vs savings account interest (2%) vs stock market average return (10%) over 10 years."}, "question": "[IMAGE: A bar chart comparing inflasi rate (3%) vs savings account bunga (2%) vs saham market average return (10%) over 10 years.]\n\nWhat key insight does this comparison reveal?", "type": "image_interpretation"}'::jsonb
WHERE id = 'e4e6929b-322e-4a09-8ecc-4f7deeb4f553'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 3M (20% of pendapatan)", "difficulty": "intermediate", "explanation": "benar path: Rp 3M (20% of pendapatan). This represents the most financially sound decision at this stage.", "options": ["Rp 500K", "Rp 3M (20% of pendapatan)", "Rp 7.5M (50% of pendapatan)", "Nothing, spend freely"], "parameters": {"full_tree": {"scenario": "You are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.", "stages": [{"correct": "Rp 3M (20% of income)", "next": {"correct": "High-yield savings", "next": {"correct": "Money market fund", "options": ["Regular savings", "Money market fund", "Aggressive growth stocks", "Friends'' business"], "question": "After emergency fund, monthly surplus goes to house fund. Best vehicle?"}, "options": ["Crypto wallet", "High-yield savings", "Stock market", "Under mattress"], "question": "Where should you keep the emergency portion (3 months expenses = Rp 45M target)?"}, "options": ["Rp 500K", "Rp 3M (20% of income)", "Rp 7.5M (50% of income)", "Nothing, spend freely"], "question": "Month 1: How much should you save first?"}]}}, "question": "Decision Tree Scenario:\n\nYou are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.\n\nMonth 1: berapa banyak should you save first?", "type": "decision_tree"}'::jsonb
WHERE id = '15ed4a39-b587-4fcf-9e7c-95fa2f5d81b4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"inflasi Hedge": ["Gold", "riil estate", "inflasi-indexed obligasi", "saham portofolio"], "inflasi risiko": ["Cash under mattress", "Fixed deposit at 2%"], "Neutral": ["Foreign currency", "Collectibles"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"inflasi Hedge\": [\"Gold\", \"riil estate\", \"inflasi-indexed obligasi\", \"saham portofolio\"], \"inflasi risiko\": [\"Cash under mattress\", \"Fixed deposit at 2%\"], \"Neutral\": [\"Foreign currency\", \"Collectibles\"]}", "options": {"buckets": ["inflasi Hedge", "inflasi risiko", "Neutral"], "items": ["Gold", "Cash under mattress", "riil estate", "Fixed deposit at 2%", "inflasi-indexed obligasi", "saham portofolio", "Foreign currency", "Collectibles"]}, "parameters": {}, "question": "Classify each item based on its relationship with inflasi:", "type": "categorization"}'::jsonb
WHERE id = '7292eb51-665f-4cb2-9fe3-54c31f197c70'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bias perilaku": ["FOMO buying", "Holding losers too long", "aversi rugi", "Confirmation bias"], "Market Condition": ["pasar bullish", "pasar bearish"], "Rational Strategy": ["rebalancing per tahun", "DCA berinvestasi"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"bias perilaku\": [\"FOMO buying\", \"Holding losers too long\", \"aversi rugi\", \"Confirmation bias\"], \"Rational Strategy\": [\"rebalancing per tahun\", \"DCA berinvestasi\"], \"Market Condition\": [\"pasar bullish\", \"pasar bearish\"]}", "options": {"buckets": ["bias perilaku", "Rational Strategy", "Market Condition"], "items": ["FOMO buying", "rebalancing per tahun", "pasar bullish", "Holding losers too long", "DCA berinvestasi", "aversi rugi", "pasar bearish", "Confirmation bias"]}, "parameters": {}, "question": "Identify whether each item represents a bias perilaku, rational strategy, or market condition:", "type": "categorization"}'::jsonb
WHERE id = '3d936e2b-456e-4258-809d-956c23cb3943'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2.5", "difficulty": "intermediate", "explanation": "BI''s inflasi target is approximately 2.5% with a tolerance band of ±1%.", "parameters": {}, "question": "Bank Indonesia targets inflation around ________ percent per year.", "type": "fill_blank"}'::jsonb
WHERE id = '94704f68-74fd-4a65-b10c-2eed062fac7b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Pendapatan tidak tetap justru membutuhkan anggaran lebih fleksibel dan dana darurat.", "parameters": {}, "question": "Pendapatan tidak tetap membuat anggaran tidak perlu dibuat.", "type": "true_false"}'::jsonb
WHERE id = 'd2a7dc2a-386d-41ae-9cd8-b4c2e5273c6a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "intermediate", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "Your actual spending is 15% higher than budgeted in 3 categories. How do you diagnose and fix?"}, "question": "Your actual spending is 15% higher than budgeted in 3 categories. How do you diagnose and fix? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = '64b87465-c66a-4fed-8f2c-663c14a958d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "intermediate", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "You want to buy a Rp 300M house in 5 years. You have Rp 50M saved. Model monthly savings needed at 6% return."}, "question": "You want to buy a Rp 300M house in 5 years. You have Rp 50M saved. Model per bulan savings needed at 6% return. What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = '37f70328-2411-4013-a2cd-30ba0378d65e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "intermediate", "explanation": "The 50/30/20 rule allocates 50% to kebutuhan, 30% to keinginan, and 20% to savings and utang.", "parameters": {}, "question": "The 50/30/20 rule suggests allocating ________ percent of pendapatan to savings and utang repayment.", "type": "fill_blank"}'::jsonb
WHERE id = 'd7977056-e476-48c5-97b6-0a5193d109a1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "intermediate", "explanation": "Otoritas Jasa Keuangan (OJK) is Indonesia''s financial services authority.", "parameters": {}, "question": "The organization that regulates financial services di Indonesia is abbreviated as ________.", "type": "fill_blank"}'::jsonb
WHERE id = '71fdad49-2ed3-4e2a-bc0c-ff9f3b957ec9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money"], "difficulty": "intermediate", "explanation": "This exhibits classic Ponzi scheme warning signs: guaranteed high returns, secrecy, and pressure to act fast.", "options": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI put semua my money in a ''guaranteed 20% per bulan return'' scheme. The person running it says it''s secret and I shouldn''t tell anyone. I signed up immediately.", "type": "spot_mistake"}'::jsonb
WHERE id = '0df13b5a-818d-4ccc-9fea-3c8f6785b6dd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy"], "difficulty": "intermediate", "explanation": "Emotional trading, no strategy, and social media tips are unreliable sources of investasi decisions.", "options": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI check my saham portofolio every hour and sell whenever it drops more than 2%. I juga buy whatever saham is trending on social media.", "type": "spot_mistake"}'::jsonb
WHERE id = '301bcffd-8c24-41a9-9cbd-64a1e3795bb4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals"], "difficulty": "intermediate", "explanation": "anggaran is upside-down, savings insufficient, and emergency funds must be liquid and safe.", "options": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy anggaran allocates 70% to keinginan, 20% to kebutuhan, and 10% to savings. I juga keep my dana darurat in cryptocurrency for higher returns.", "type": "spot_mistake"}'::jsonb
WHERE id = '70b3114b-cc05-4105-b538-ba1a3a442439'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Sari adalah karyawan kantoran dengan asuransi kesehatan dari perusahaan dan belum memiliki tanggungan. Ia menetapkan dana darurat 3 bulan pengeluaran dan menyisihkan 10% gaji setiap bulan untuk mengisinya. Setelah penuh, Sari mulai menyalurkan sisanya ke reksa dana saham untuk tujuan jangka panjang."}'::jsonb
WHERE id = 'b867493b-629a-4438-b7cf-e23d154c3e9f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina bekerja magang dengan gaji Rp2.500.000. Ia menyisihkan Rp300.000 per bulan ke rekening terpisah. Setelah setahun, ia punya Rp3.600.000 yang bisa dipakai jika ia sakit atau kehilangan pekerjaan."}'::jsonb
WHERE id = '98bd93b2-dfe3-4845-b8fc-667d6c4faeb0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Budi bekerja sebagai pengemudi ojek online dengan penghasilan yang berubah-ubah setiap bulan. Karena pendapatannya tidak tetap, ia memilih target dana darurat 6 bulan pengeluaran. Budi menyimpannya di reksa dana pasar uang yang bisa dicairkan dalam 2–3 hari kerja."}'::jsonb
WHERE id = '3b16a7b1-202f-42b6-bb13-6cca8c93d7b1'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Budi adalah driver ojek online dengan pendapatan tidak tetap. Handphonenya rusak dan biaya perbaikan Rp3.000.000. Karena Budi punya dana darurat Rp5.000.000 di tabungan terpisah, ia bisa memperbaiki hp tanpa pinjam ke aplikasi pinjol."}'::jsonb
WHERE id = '11539219-0b5e-4644-8964-73c1fec839a3'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04"], "text": "Rina, fresh graduate di Bandung, memiliki penghasilan bersih Rp 5.000.000 per bulan dan pengeluaran rutin Rp 4.000.000. Ia menargetkan dana darurat 6 bulan, yaitu Rp 24.000.000. Rina menyimpan Rp 8.000.000 di tabungan terpisah dan Rp 16.000.000 di deposito berjangka 1 bulan agar tetap mudah dicairkan."}'::jsonb
WHERE id = '2da95141-a69e-4880-8e6d-5760fd9a0968'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dana darurat adalah tabungan khusus untuk kebutuhan mendadak seperti sakit, kehilangan pekerjaan, atau perbaikan rumah. Besarnya biasanya 3–6 bulan pengeluaran rutin. Bedakan dengan tabungan untuk liburan atau belanja, sebab dana darurat hanya dipakai saat benar-benar urgent."}'::jsonb
WHERE id = '3cd9f173-828a-4382-8b66-f4e35412d7c7'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dana darurat adalah tabungan khusus untuk kebutuhan mendesak seperti sakit, kehilangan pekerjaan, atau kerusakan alat produktif. Besarannya umumnya 3-6 bulan pengeluaran."}'::jsonb
WHERE id = '3f627048-75b6-4f32-8c48-a934e52fef98'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dana darurat sebaiknya disimpan di tempat aman dan likuid, seperti tabungan terpisah atau deposito berjangka pendek, agar cepat diambil saat dibutuhkan."}'::jsonb
WHERE id = '39f1c2c0-9efa-4765-b31b-7bfe9388ec63'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Simpan dana darurat di tempat aman dan mudah dicairkan, misalnya tabungan terpisah di bank yang dijamin LPS, deposito berjangka pendek, atau reksa dana pasar uang. Hindari saham, kripto, atau instrumen lain yang harganya bisa turun tajam, karena saat darurat kamu butuh nilai yang stabil."}'::jsonb
WHERE id = '00520940-8cba-4a03-9b68-3e5ea52d44a2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Deposito berjangka pendek atau tabungan terpisah", "difficulty": "beginner", "explanation": "Dana darurat harus likuid dan aman. Deposito pendek atau tabungan terpisah cocok karena mudah dicairkan dan nilainya stabil.", "options": ["Deposito berjangka pendek atau tabungan terpisah", "Saham blue chip", "Kripto dengan kapitalisasi besar", "Properti untuk disewakan"], "parameters": {}, "question": "Tempat paling tepat untuk menyimpan dana darurat adalah ...", "type": "multiple_choice"}'::jsonb
WHERE id = '52372ad6-2545-4c1e-b229-4bfeb60199b5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "3–6 bulan", "difficulty": "beginner", "explanation": "Aturan praktisnya adalah cadangan 3–6 bulan pengeluaran rutin, disesuaikan dengan stabilitas pendapatan dan tanggungan.", "options": ["1 bulan", "3–6 bulan", "12 bulan", "Tidak perlu dana darurat"], "parameters": {}, "question": "Berapa lama pengeluaran rutin yang umumnya dianjurkan untuk dana darurat?", "type": "multiple_choice"}'::jsonb
WHERE id = '2611aa7e-6067-4c10-a1ec-37f9f9c0c97d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Agar tidak terpakai untuk belanja rutin", "difficulty": "beginner", "explanation": "Memisahkan dana darurat mencegah uang urgent terserap oleh pengeluaran sehari-hari yang sebenarnya bisa ditunda.", "options": ["Agar tidak terpakai untuk belanja rutin", "Agar mendapat bunga lebih tinggi", "Agar tidak dikenakan pajak", "Agar bisa dipinjamkan ke teman"], "parameters": {}, "question": "Mengapa dana darurat harus dipisah dari tabungan harian?", "type": "multiple_choice"}'::jsonb
WHERE id = '37c03eb1-6122-43ab-a6d6-30b9842fac3b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Dana darurat adalah fondasi keuangan. Setelah terpenuhi, dana lain bisa dialokasikan untuk investasi sesuai tujuan dan profil risiko.", "parameters": {}, "question": "Setelah dana darurat terkumpul, kamu bisa mulai mengalokasikan kelebihan dana ke investasi jangka panjang.", "type": "true_false"}'::jsonb
WHERE id = 'cc85d84f-08c7-461b-8750-712a91b383f8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Dana darurat mencegah kita berutang saat kebutuhan mendesak muncul.", "caseText": "Budi, driver ojek online, mendapat penghasilan tidak tetap. Handphonenya rusak dan biaya perbaikan Rp3.000.000. Ia tidak punya dana darurat.", "difficulty": "beginner", "explanation": "Dana darurat adalah pelindung keuangan yang menjaga kita dari utang berbunga tinggi saat ada kebutuhan tak terduga.", "followUp": {"answer": "Terpaksa pinjam ke pinjol berbunga tinggi", "explanation": "Tanpa dana darurat, orang sering terpaksa berutang dengan bunga tinggi untuk menutup kebutuhan mendesak.", "options": ["Terpaksa pinjam ke pinjol berbunga tinggi", "Tidak bisa membeli makanan", "Tidak bisa bekerja selama beberapa hari karena hp rusak", "Harus meminjam dari keluarga dengan konsekuensi sosial"], "question": "Apa risiko terbesar yang dihadapi Budi?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = '10fde24d-d9fb-4d6a-8a37-2244a3931376'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Tabungan terpisah yang mudah diambil", "difficulty": "beginner", "explanation": "Dana darurat harus aman dan likuid, sehingga tabungan terpisah adalah pilihan tepat.", "options": ["Tabungan terpisah yang mudah diambil", "Saham individu", "Kripto yang volatil", "Uang pinjaman dari teman"], "question": "Manakah tempat yang paling cocok untuk menyimpan dana darurat?", "type": "multiple_choice"}'::jsonb
WHERE id = 'd91a8a8b-b2d1-4942-a58f-93cbcfe26641'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Dana darurat sebaiknya dipisahkan agar tidak terpakai untuk keinginan sehari-hari.", "question": "Dana darurat sebaiknya disatukan dengan uang belanja harian agar mudah diakses.", "type": "true_false"}'::jsonb
WHERE id = 'eaea7d91-a34c-43f6-816a-57f05e7e6099'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "tiga", "difficulty": "beginner", "explanation": "Dana darurat idealnya 3-6 bulan pengeluaran untuk menghadapi keadaan darurat.", "question": "Besaran dana darurat yang umum disarankan adalah _____ hingga enam bulan pengeluaran.", "type": "fill_blank"}'::jsonb
WHERE id = '5d4289d6-5309-467e-b1bd-5c135964b46f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Saham berisiko fluktuatif. Dana darurat butuh stabilitas dan likuiditas, jadi pilih instrumen aman seperti tabungan atau deposito.", "parameters": {}, "question": "Dana darurat sebaiknya disimpan di saham agar hasilnya lebih tinggi.", "type": "true_false"}'::jsonb
WHERE id = '41daebf5-ca5b-49a6-b92f-68a7f0e4fb62'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina menunggu akhir bulan untuk menyisihkan sisa uang saku. Namun, setiap akhir bulan uangnya selalu habis untuk jajan dan streaming. Ia beralih menyisihkan Rp200.000 di awal bulan, dan ternyata bisa menyesuaikan pengeluarannya."}'::jsonb
WHERE id = '8cecd791-b370-4bb8-b78d-8be968fdf07f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Setiap kali gaji masuk, Doni langsung transfer Rp300.000 ke rekening tabungan terpisah sebelum membeli pulsa atau kopi. Baru setelah itu ia mengatur pengeluaran harian. Tabungannya tumbuh tanpa ia merasa berkorban."}'::jsonb
WHERE id = 'af6ecdf9-147a-4f50-a20f-101a2b8d664a'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayar diri sendiri dulu artinya menyisihkan uang untuk tabungan atau investasi begitu pendapatan masuk, sebelum membayar orang lain atau membeli keinginan."}'::jsonb
WHERE id = 'a42e5419-fed3-49f2-9a17-4a75b714a7d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Menabung di awal lebih andal daripada menabung dari sisa. Jika menunggu sisa, biasanya tidak ada yang tersisa karena pengeluaran akan mengikuti uang yang tersedia."}'::jsonb
WHERE id = '50a4b982-d95a-4001-9265-f17b71ce4ac7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Bayar diri sendiri dulu justru menabung di awal, sebelum uang habis untuk keinginan.", "question": "Prinsip bayar diri sendiri dulu berarti menabung setelah semua keinginan terpenuhi.", "type": "true_false"}'::jsonb
WHERE id = 'fafffa70-d17f-41b8-ad3a-8d5753a6d26d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena kita terbiasa hidup dengan uang yang tersisa", "difficulty": "beginner", "explanation": "Jika tabungan diambil dulu, pengeluaran akan menyesuaikan dengan sisa uang.", "options": ["Karena kita terbiasa hidup dengan uang yang tersisa", "Karena bunga bank lebih tinggi di awal bulan", "Karena uang sisa selalu banyak", "Karena keinginan lebih sedikit di awal bulan"], "question": "Mengapa menabung di awal bulan lebih efektif daripada menabung dari sisa?", "type": "multiple_choice"}'::jsonb
WHERE id = 'a24c92f8-c473-406a-b84f-b525e4066968'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "bayar diri sendiri dulu", "difficulty": "beginner", "explanation": "Dengan otomatisasi, tabungan terjadi tanpa perlu bergantung pada tekad setiap bulan.", "question": "Automatisasi transfer ke tabungan begitu gaji masuk adalah contoh prinsip _____.", "type": "fill_blank"}'::jsonb
WHERE id = 'c275915c-9d7d-4716-a63c-c9dae6e4bfb3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp200.000", "difficulty": "beginner", "explanation": "10% dari Rp2.000.000 adalah Rp200.000.", "options": ["Rp200.000", "Rp400.000", "Rp100.000", "Rp500.000"], "question": "Doni gaji Rp2.000.000 dan ingin menabung 10% di awal. Berapa yang harus disisihkan pertama kali?", "type": "multiple_choice"}'::jsonb
WHERE id = '71e6c081-07ca-495b-8f47-91c54dafa6c3'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dina melihat flash sale di Shopee: beli 2 gratis 1 skincare. Ia tertarik meski skincarenya belum habis dan bukan kebutuhan. Jika ia membeli, ia mengeluarkan uang untuk barang yang tidak direncanakan."}'::jsonb
WHERE id = 'c6e83d79-a1d5-441c-a83d-b4df525a5c1f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayu mengikuti influencer yang selalu merekomendasikan gadget terbaru. Ia merasa harus membeli agar tidak ketinggalan. Padahal laptopnya masih berfungsi dengan baik."}'::jsonb
WHERE id = 'd1b5aa49-2e15-4e54-9a0c-db4c278e2696'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Pertahanan terbaik adalah jeda sebelum membeli. Tanyakan: apakah ini kebutuhan? Apakah saya punya uang tanpa mengganggu tabungan? Apakah saya masih mau membeli besok?"}'::jsonb
WHERE id = 'bd6482c2-ba77-4668-82f4-a7520f249904'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jebakan pengeluaran adalah situasi yang membuat kita membeli lebih dari yang direncanakan atau dibutuhkan. Contohnya flash sale, influencer hype, dan pembelian kecil harian yang terasa murah tapi menumpuk."}'::jsonb
WHERE id = '3568f99c-9f97-4aae-b4e0-9c4ddc585671'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "24 jam", "difficulty": "beginner", "explanation": "Jeda 24 jam atau lebih membantu kita membedakan kebutuhan nyata dan dorongan emosional.", "question": "Sebelum membeli barang karena influencer, sebaiknya tunggu _____ agar emosi FOMO mereda.", "type": "fill_blank"}'::jsonb
WHERE id = '73e56048-a46e-4f13-b13d-4a519842663c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Flash sale sering membuat kita membeli barang yang tidak dibutuhkan. Jeda sebelum checkout adalah strategi sederhana untuk menghindari jebakan.", "caseText": "Dina menemukan flash sale beli 2 gratis 1 skincare. Skincare yang ada di rumah masih setengah, dan skincare tersebut bukan kebutuhan rutin.", "difficulty": "beginner", "explanation": "Jebakan pengeluaran sering tampak seperti hemat, padahal justru membuat kita membeli barang yang tidak perlu.", "followUp": {"answer": "Tunggu 24-48 jam dan tanyakan apakah benar dibutuhkan", "explanation": "Jeda membantu kita menghindari pembelian impulsif yang dipicu oleh diskon palsu.", "options": ["Tunggu 24-48 jam dan tanyakan apakah benar dibutuhkan", "Langsung checkout sebelum habis", "Beli karena gratis 1", "Bagikan ke teman agar ikut beli"], "question": "Apa yang sebaiknya Dina lakukan sebelum checkout?"}, "question": "Baca kasus dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = '583e2ce4-82c7-4a71-b659-a6bd8d02577e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Membeli kopi Rp25.000 setiap hari karena terasa murah", "difficulty": "beginner", "explanation": "Pengeluaran kecil yang terus-menerus bisa menumpuk besar dan menguras anggaran.", "options": ["Membeli kopi Rp25.000 setiap hari karena terasa murah", "Membayar kos tepat waktu", "Menabung di awal bulan", "Membeli pulsa sesuai kebutuhan"], "question": "Manakah yang termasuk jebakan pengeluaran?", "type": "multiple_choice"}'::jsonb
WHERE id = '0e0b0cfa-c17d-4c71-89b2-7d4eed145683'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Diskon menghemat hanya jika kita benar-benar membutuhkan barang tersebut. Jika tidak, kita malah mengeluarkan uang untuk barang tak perlu.", "question": "Diskon besar selalu berarti kita berhemat.", "type": "true_false"}'::jsonb
WHERE id = '0aed0cee-d947-4177-a3c2-0b283472b636'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Raka membeli hoodie Rp1.200.000 pakai PayLater. Ia lupa membayar tagihan tepat waktu dan tagihan membengkak menjadi Rp1.500.000 karena denda keterlambatan. Utang konsumtif kecil bisa tumbuh besar jika tidak diatur."}'::jsonb
WHERE id = '0c1953c1-7528-41a6-91b9-b7e67fa355b7'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dina punya kartu kredit dengan bunga 2,5% per bulan. Ia membayar minimum payment saja, sehingga sisa utang terus berbunga. Tagihan Rp5 juta yang tidak dilunasi penuh bisa tumbuh menjadi Rp6,5 juta dalam beberapa bulan."}'::jsonb
WHERE id = '09c3cf85-3540-443c-a2b2-098582d21cb5'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jebakan utang terjadi ketika kita meminjam untuk konsumsi, membayar terlambat, atau hanya membayar minimum sehingga bunga menumpuk."}'::jsonb
WHERE id = 'a72062cf-eda5-42a4-84e1-fa04875a7b11'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Cara keluar dari jebakan utang: hentikan peminjaman baru, bayar utang berbunga tinggi terlebih dahulu, dan alokasikan lebih dari minimum payment."}'::jsonb
WHERE id = 'f088598b-076c-400a-9bc4-a85c13827a4a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "PayLater dan pinjol sering mengenakan bunga, denda, atau biaya yang bisa membuat utang membengkak.", "question": "PayLater dan pinjol online selalu gratis tanpa risiko.", "type": "true_false"}'::jsonb
WHERE id = '61a7c4c5-4668-43ac-a170-a71c70db8fb8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Raka harus menghentikan pembelian baru dan fokus melunasi utang agar tidak semakin besar.", "caseText": "Raka membeli hoodie Rp1.200.000 pakai PayLater dan terlambat bayar. Tagihannya membengkak menjadi Rp1.500.000. Gajinya Rp2.500.000 per bulan.", "difficulty": "beginner", "explanation": "Utang konsumtif dengan bunga tinggi bisa tumbuh cepat. Solusinya adalah berhenti menambah dan bayar lebih cepat.", "followUp": {"answer": "Hentikan pembelian baru dan bayar tagihan PayLater secepatnya", "explanation": "Menghentikan peminjaman baru dan melunasi utang konsumtif mencegah bunga dan denda tambahan.", "options": ["Hentikan pembelian baru dan bayar tagihan PayLater secepatnya", "Beli barang lain untuk merasa lebih baik", "Bayar minimum dan lanjutkan gaya hidup", "Pinjam ke teman untuk membayar minimum"], "question": "Langkah pertama apa yang paling penting untuk Raka?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = 'c11fe616-3261-4ddb-b05c-000818220a07'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Sisa utang tetap berbunga setiap bulan", "difficulty": "beginner", "explanation": "Minimum payment hanya menunda utang; bunga terus menambah saldo.", "options": ["Sisa utang tetap berbunga setiap bulan", "Bank menghapuskan bunga", "Limit kartu kredit naik otomatis", "Tidak ada denda keterlambatan"], "question": "Mengapa membayar minimum kartu kredit bisa menjadi jebakan?", "type": "multiple_choice"}'::jsonb
WHERE id = '0200774f-51ef-43c3-a18d-cb6e72b9d00c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "tinggi", "difficulty": "beginner", "explanation": "Utang berbunga tinggi menumpuk paling cepat, sehingga harus diprioritaskan.", "question": "Untuk keluar dari jebakan utang, bayar terlebih dahulu utang dengan bunga paling _____.", "type": "fill_blank"}'::jsonb
WHERE id = 'f7903fde-3b1f-4297-a521-ddc574317e68'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Fani ingin membeli laptop Rp5.000.000 untuk kuliah dalam 10 bulan. Ia perlu menabung Rp500.000 per bulan. Target ini spesifik dan punya deadline, sehingga Fani bisa mengukur perkembangannya setiap bulan."}'::jsonb
WHERE id = '4e7ab39f-afd0-42e3-9f27-63a8a36113b4'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayu punya tujuan ''menabung lebih banyak.'' Ia tidak tahu berapa yang harus disisihkan atau kapan mencapainya. Setelah ia mengubahnya menjadi ''menabung Rp2 juta dalam 5 bulan'' atau Rp400.000 per bulan, ia menjadi lebih termotivasi."}'::jsonb
WHERE id = '75e8f63a-c60c-4fae-ad40-ac1ff44179c0'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Tujuan keuangan yang baik bersifat SMART: Spesifik, Measurable, Achievable, Relevant, Time-bound. Vague seperti ''menabung lebih banyak'' sulup dilaksanakan."}'::jsonb
WHERE id = '37fb3d76-b5d2-401f-b4d7-a74ccb98db21'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Membagi tujuan besar menjadi target bulanan membuatnya tidak terasa berat. Jika target tercapai, kita bisa merayakan kemajuan kecil."}'::jsonb
WHERE id = '018946ee-44fa-45ab-8867-093a7bd5aa5f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tentukan tujuan spesifik", "Tetapkan tenggat waktu", "Hitung target bulanan", "Sisihkan uang di awal bulan"], "difficulty": "beginner", "explanation": "Mulai dari tujuan spesifik, beri deadline, pecah menjadi target bulanan, lalu sisihkan di awal.", "options": ["Tentukan tujuan spesifik", "Tetapkan tenggat waktu", "Hitung target bulanan", "Sisihkan uang di awal bulan"], "question": "Urutkan langkah menetapkan tujuan keuangan dari awal hingga eksekusi.", "type": "ordering"}'::jsonb
WHERE id = '8277cace-9a5b-44fb-bd28-306b27fe22c1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "500.000", "difficulty": "beginner", "explanation": "Rp5.000.000 dibagi 10 bulan sama dengan Rp500.000 per bulan.", "question": "Fani ingin beli laptop Rp5.000.000 dalam 10 bulan, jadi ia harus menabung Rp_____ per bulan.", "type": "fill_blank"}'::jsonb
WHERE id = 'c6ada195-8e7c-4fba-9663-cacda1bc5782'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Menabung Rp2.000.000 untuk laptop dalam 5 bulan", "difficulty": "beginner", "explanation": "Tujuan yang spesifik dan punya deadline lebih mudah dijalankan dan diukur.", "options": ["Menabung Rp2.000.000 untuk laptop dalam 5 bulan", "Menabung lebih banyak", "Tidak menghabiskan uang", "Beli apa yang diinginkan"], "question": "Manakah tujuan keuangan yang paling baik?", "type": "multiple_choice"}'::jsonb
WHERE id = '5256c9be-535b-47bc-81a3-8ec1ae912001'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Tujuan SMART lebih mudah dicapai karena jelas jumlah, tujuan, dan waktunya.", "question": "Tujuan keuangan yang baik sebaiknya spesifik dan memiliki tenggat waktu.", "type": "true_false"}'::jsonb
WHERE id = '45e4c67c-a8c8-4d0b-9525-9144ef5fd8ca'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Aplikasi investasi baru menawarkan bonus saldo Rp1 juta jika user melakukan deposit Rp500.000. Setelah deposit, aplikasi tidak bisa diakses. Janji bonus besar adalah taktik umum penipuan."}'::jsonb
WHERE id = '3f86d847-4384-4d91-9952-d7c16916ebac'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Sebuah grup Telegram menjanjikan keuntungan 20% per bulan, tanpa risiko, dan meminta mengajak teman untuk untung lebih besar. Janji seperti ini melanggar hukum pasar: imbal hasil tinggi selalu berisiko tinggi. Jika terlalu bagus untuk jadi kenyataan, kemungkinan besar memang begitu."}'::jsonb
WHERE id = '7bcde6c6-2143-4896-a16a-07daa42861f1'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Ciri investasi bodong: imbal hasil dijamin tinggi, tanpa risiko, tekanan waktu, dan skema ajak teman. Investasi yang sah tidak menjanjikan keuntungan pasti."}'::jsonb
WHERE id = 'bbd3ab75-8868-48c9-b2a1-7a795e2e9b12'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jika penawaran terlalu bagus untuk jadi kenyataan, hentikan dan periksa izin OJK. Tidak ada investasi yang menghasilkan untung besar tanpa risiko."}'::jsonb
WHERE id = '96bd67e3-a4fe-4c20-ba09-44fa5ef396b7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Jika penawaran menggabungkan imbal hasil tinggi, tanpa risiko, dan skema referral, itu adalah red flag besar.", "caseText": "Sebuah grup WhatsApp menawarkan investasi dengan janji: ''Profit 20% per bulan, tanpa risiko, modal Rp500.000, ajak 2 teman untuk bonus.''", "difficulty": "beginner", "explanation": "Investasi yang sah tidak menjanjikan imbal hasil pasti. Selalu periksa izin OJK sebelum mengeluarkan uang.", "followUp": {"answer": "Hentikan dan periksa izin OJK, jangan transfer", "explanation": "Imbal hasil tinggi dijamin dan skema ajak teman adalah ciri investasi bodong.", "options": ["Hentikan dan periksa izin OJK, jangan transfer", "Transfer Rp500.000 karena tanpa risiko", "Ajak teman untuk mendapat bonus", "Investasi Rp5.000.000 agar untung besar"], "question": "Apa yang sebaiknya kamu lakukan?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = '33ef8bda-e07c-49ef-a83e-61188c382ff9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "izin OJK", "difficulty": "beginner", "explanation": "Otoritas Jasa Keuangan mengawasi produk keuangan yang legal di Indonesia.", "question": "Jika penawaran terlalu bagus untuk jadi kenyataan, sebaiknya periksa _____ sebelum mengeluarkan uang.", "type": "fill_blank"}'::jsonb
WHERE id = '839e3ffe-8295-4a56-99a4-b76172ff4119'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Investasi yang sah menginformasikan risiko dan tidak menjanjikan keuntungan pasti.", "question": "Investasi yang sah selalu menjanjikan keuntungan pasti kepada nasabah.", "type": "true_false"}'::jsonb
WHERE id = '3190f6d6-197f-4afd-84d9-ddd50db4ef18'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Imbal hasil 20% per bulan dijamin tanpa risiko", "difficulty": "beginner", "explanation": "Tidak ada investasi yang dijamin tanpa risiko, apalagi imbal hasil sangat tinggi.", "options": ["Imbal hasil 20% per bulan dijamin tanpa risiko", "Deposito bank berbunga 4% per tahun", "Reksa dana saham berfluktuasi", "Tabungan tidak ada bunga"], "question": "Manakah pernyataan yang paling mencurigakan?", "type": "multiple_choice"}'::jsonb
WHERE id = '2a712c0a-c4a2-42ea-9bf4-36de52ec661b'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Seorang teman merekomendasikan aplikasi ''crypto staking'' yang belum pernah didengar. Sebelum deposit, Budi membuka situs OJK, mencari nama aplikasi di daftar perusahaan berizin. Tidak ditemukan. Budi menolak investasi dan memberi tahu temannya."}'::jsonb
WHERE id = 'a6374b54-3e4f-4c49-8b9f-e711ffd640fe'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina ingin membuka rekening efek di perusahaan sekuritas. Ia memeriksa situs OJK untuk memastikan perusahaan tersebut terdaftar sebagai penyelenggara pasar modal. Setelah terverifikasi, ia baru mendaftar."}'::jsonb
WHERE id = '31059c8c-324c-44e8-83e7-21944bf08e91'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Cara memeriksa: kunjungi situs OJK, buka bagian ''Waspada Investasi'' atau daftar perusahaan berizin, lalu cari nama aplikasi/perusahaan. Jika tidak ada, jangan berinvestasi."}'::jsonb
WHERE id = '5f123bce-bd86-4d49-bcd3-414129a2f377'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "OJK mengawasi bank, asuransi, reksa dana, dan pasar modal di Indonesia. Produk keuangan yang legal harus memiliki izin dari OJK."}'::jsonb
WHERE id = 'a43832d5-5f4c-470d-a9b5-7683ede38b43'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Banyak aplikasi pinjol ilegal. Selalu periksa daftar OJK sebelum menggunakan layanan keuangan.", "question": "Semua aplikasi pinjaman online yang ada di internet sudah pasti berizin OJK.", "type": "true_false"}'::jsonb
WHERE id = 'fb081e0e-c665-48b5-ac02-9826b4423ee6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Cek izin OJK sebelum deposit", "difficulty": "beginner", "explanation": "Memeriksa izin OJK adalah langkah pertama untuk menghindari investasi ilegal.", "options": ["Cek izin OJK sebelum deposit", "Deposit kecil untuk mencoba", "Tanya grup media sosial", "Ajak teman lain ikut"], "question": "Teman kamu menawarkan aplikasi investasi baru. Apa langkah pertama yang benar?", "type": "multiple_choice"}'::jsonb
WHERE id = '02668524-2a7e-4b43-96b1-d9b10fcbe564'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Kunjungi situs OJK", "Cari nama perusahaan/aplikasi", "Pastikan terdaftar berizin", "Transfer dana jika terverifikasi"], "difficulty": "beginner", "explanation": "Verifikasi izin OJK harus dilakukan sebelum mengeluarkan uang.", "options": ["Kunjungi situs OJK", "Cari nama perusahaan/aplikasi", "Pastikan terdaftar berizin", "Transfer dana jika terverifikasi"], "question": "Urutkan langkah aman sebelum berinvestasi.", "type": "ordering"}'::jsonb
WHERE id = 'bcd11556-0f6a-42ac-9cf1-291282f5821b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Jasa", "difficulty": "beginner", "explanation": "Otoritas Jasa Keuangan mengatur dan mengawasi layanan keuangan di Indonesia.", "question": "OJK adalah singkatan dari Otoritas _____ Keuangan.", "type": "fill_blank"}'::jsonb
WHERE id = 'd9a8bc49-ebc2-445d-8b3c-0197b76c5190'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina mendapat email yang tampak dari OVO meminta verifikasi data. Alamat email pengirim ov0-support@gmail.com. Rina curiga karena domain tidak resmi dan menghapus emailnya."}'::jsonb
WHERE id = '1516d4c8-f9a9-4968-84e2-42a446f9bb42'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayu menerima pesan WhatsApp yang mengatasnamakan Bank BCA: ''Rekening Anda diblokir, klik link untuk aktifkan.'' Link meminta OTP dan password. Bayu tidak mengklik dan langsung menghubungi call center BCA resmi. Pesan itu adalah phishing."}'::jsonb
WHERE id = '6ee9e84c-72b1-414d-8d55-652b4ef327fa'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jangan pernah mengklik link, memasukkan password, atau memberikan OTP dari pesan yang tidak diminta. Hubungi layanan resmi melalui nomor/website resmi."}'::jsonb
WHERE id = 'c27a330f-5225-4d40-a685-b9262f1ec76c'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Phishing adalah upaya penipuan yang meniru lembaga resmi untuk mencuri data pribadi, password, atau OTP. Social engineering memanipulasi emosi seperti takut atau rasa terhormat."}'::jsonb
WHERE id = 'f2a0c581-5aa3-4f36-84b5-ca0195b8878d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Meminta OTP melalui link yang tidak diminta", "difficulty": "beginner", "explanation": "Lembaga keuangan resmi tidak meminta OTP atau password melalui link.", "options": ["Meminta OTP melalui link yang tidak diminta", "Menggunakan nomor resmi bank", "Memberikan informasi tanpa meminta data", "Mengirimkan bukti transaksi"], "question": "Manakah ciri pesan phishing?", "type": "multiple_choice"}'::jsonb
WHERE id = 'fa2d8d28-a24e-413f-977a-109c0176dbf0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "data", "difficulty": "beginner", "explanation": "Tujuan phishing adalah mencuri data pribadi, password, atau OTP.", "question": "Phishing adalah penipuan yang meniru lembaga resmi untuk mencuri _____ pengguna.", "type": "fill_blank"}'::jsonb
WHERE id = '15867c25-09a3-4840-a193-f1820cba3281'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OTP dan password tidak boleh diberikan melalui link. Selalu verifikasi melalui kanal resmi.", "caseText": "Bayu dapat pesan WhatsApp: ''Rekening BCA Anda diblokir, segera klik link untuk mengaktifkan kembali. Link meminta OTP.''", "difficulty": "beginner", "explanation": "Phishing sering memakai urgensi dan ancaman agar kita bertindak cepat tanpa berpikir.", "followUp": {"answer": "Hubungi call center BCA resmi dan jangan klik link", "explanation": "Bank resmi tidak meminta OTP melalui link. Hubungi call center resmi untuk konfirmasi.", "options": ["Hubungi call center BCA resmi dan jangan klik link", "Klik link dan masukkan OTP", "Balas pesan untuk bertanya", "Bagikan link ke keluarga"], "question": "Apa yang harus Bayu lakukan?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = '0833677f-feb9-49cb-87f1-9696a4871c83'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Penipu bisa meniru tampilan bank. Selalu verifikasi melalui aplikasi atau nomor resmi.", "question": "Jika pesan terlihat dari bank, mengklik link di dalamnya selalu aman.", "type": "true_false"}'::jsonb
WHERE id = '1779115e-75eb-417e-b06a-0af9bf2812da'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Sari diundang ke bisnis skincare. Ia harus membeli paket Rp3.000.000 dan merekrut dua teman. Keuntungan utama datang dari biaya pendaftaran rekrutan, bukan dari penjualan produk. Ini adalah skema piramida, bukan MLM produktif."}'::jsonb
WHERE id = '0a60f6f6-6364-4531-90ef-7dd80f235544'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Sebuah MLM menjual vitamin dengan harga wajar. Anggota boleh menjual produk tanpa harus merekrut. Komisi didapat dari penjualan produk. Ini lebih mendekati MLM berbasis produk."}'::jsonb
WHERE id = 'bbcb7f2c-d5e4-4460-915a-f6e360377557'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "MLM berbasis produk menghasilkan uang dari penjualan barang. Piramida menghasilkan uang terutama dari merekrut anggota baru. Ketika rekrutan habis, piramida runtuh."}'::jsonb
WHERE id = '0d9cd1b9-e67d-47b1-b34f-4e1ada988c61'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Red flag piramida: fokus utama adalah merekrut, bukan menjual produk; harus membeli paket mahal; janji uang mudah; skema multi-level yang tidak berkelanjutan."}'::jsonb
WHERE id = '20bc940b-cee4-4dcf-bf4a-cbf6c8dd8e2d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Ini menunjukkan skema piramida karena pendapatan bergantung pada rekrutan, bukan penjualan produk.", "caseText": "Sari diundang ke bisnis skincare. Paket masuk Rp3.000.000. Untung besar didapat jika Sari merekrut dua teman, yang masing-masing juga harus beli paket Rp3.000.000. Penjualan produk ke konsumen akhir hampir tidak dibahas.", "difficulty": "beginner", "explanation": "Skema piramida akan runtuh ketika tidak ada anggota baru. Hindari bisnis yang menekan rekrutan daripada penjualan produk.", "followUp": {"answer": "Skema piramida", "explanation": "Keuntungan utama berasal dari rekrutan dan biaya pendaftaran, bukan penjualan produk.", "options": ["Skema piramida", "MLM berbasis produk murni", "Franchise waralaba", "Tabungan berjangka"], "question": "Apa jenis bisnis ini?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = 'e7c4d48d-e538-4fba-823f-19d81735b4e3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "pendaftaran", "difficulty": "beginner", "explanation": "Piramida bergantung pada uang masuk dari anggota baru untuk membayar anggota lama.", "question": "Jika keuntungan utama datang dari biaya _____ anggota baru, bisnis itu kemungkinan besar skema piramida.", "type": "fill_blank"}'::jsonb
WHERE id = '6dbae953-e5b8-40d1-9717-1436ed6b3849'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Tingkatan ada di banyak bisnis. Yang membedakan adalah apakah pendapatan utama dari penjualan produk atau dari biaya rekrutan.", "question": "Semua bisnis yang memiliki tingkatan rekrutan pasti skema piramida.", "type": "true_false"}'::jsonb
WHERE id = 'e0fe4634-688c-4989-b3dd-caa122527c0e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "MLM produktif fokus menjual produk; piramida fokus merekrut", "difficulty": "beginner", "explanation": "Sumber utama pendapatan menentukan apakah bisnis itu berbasis produk atau piramida.", "options": ["MLM produktif fokus menjual produk; piramida fokus merekrut", "MLM ilegal; piramida legal", "Keduanya sama", "Piramida menjual produk lebih banyak"], "question": "Apa perbedaan utama MLM produktif dan skema piramida?", "type": "multiple_choice"}'::jsonb
WHERE id = 'f3341059-f4b9-4bde-97ef-71854156447f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni mulai menabung Rp100.000 per bulan sejak usia 18 dengan imbal hasil 6% per tahun. Kakaknya mulai menabung Rp100.000 per bulan sejak usia 28. Pada usia 40, Doni memiliki jauh lebih banyak karena uangnya sempat tumbuh lebih lama dan bunga menghasilkan bunga lagi."}'::jsonb
WHERE id = 'cb099265-e8b8-4d05-b6e7-6a3978336e66'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina menabung Rp1.000.000 dengan bunga 5% per tahun. Tahun pertama dapat Rp50.000. Tahun kedua, bunganya dihitung dari Rp1.050.000, jadi lebih besar. Inilah bunga majemuk."}'::jsonb
WHERE id = '78e582e9-9850-4550-b137-5c8af57c7c16'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Dua faktor penting bunga majemuk: waktu dan suku bunga. Memulai lebih awal memberi waktu lebih lama bagi uang untuk tumbuh."}'::jsonb
WHERE id = 'bd45826f-22ec-461f-a4b9-0976a301a93e'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bunga majemuk adalah bunga yang dihitung dari pokok ditambah bunga sebelumnya. Hasilnya tumbuh semakin cepat seiring waktu."}'::jsonb
WHERE id = 'd40da5d7-d3d2-40a2-93c1-160fb88612d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "bunga", "difficulty": "intermediate", "explanation": "Bunga majemuk menghasilkan bunga atas bunga, bukan hanya atas modal awal.", "question": "Bunga majemuk berarti kita mendapat bunga dari modal awal dan juga dari _____ yang sudah diperoleh sebelumnya.", "type": "fill_blank"}'::jsonb
WHERE id = 'f78d1771-d1c1-4b66-b489-ceb46fab20fa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp52.500", "difficulty": "intermediate", "explanation": "5% dari Rp1.050.000 adalah Rp52.500.", "options": ["Rp52.500", "Rp50.000", "Rp5.000", "Rp100.000"], "question": "Tabungan Rp1.000.000 dengan bunga 5% per tahun. Setelah tahun pertama saldo Rp1.050.000. Berapa bunga tahun kedua?", "type": "multiple_choice"}'::jsonb
WHERE id = 'cf14409e-eb82-448c-be72-00e33ae27110'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena bunga dihitung dari bunga sebelumnya dalam waktu lebih lama", "difficulty": "intermediate", "explanation": "Waktu memungkinkan bunga menumpuk dan menghasilkan bunga baru, sehingga pertumbuhan semakin cepat.", "options": ["Karena bunga dihitung dari bunga sebelumnya dalam waktu lebih lama", "Karena bank memberi bonus untuk pemula", "Karena bunga tetap sama setiap tahun", "Karena uang awal selalu lebih besar"], "question": "Mengapa menabung lebih awal menghasilkan lebih banyak dengan bunga majemuk?", "type": "multiple_choice"}'::jsonb
WHERE id = '9be07756-e5d4-4c6c-a720-68726f9e332a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "intermediate", "explanation": "Bunga dihitung dari saldo yang terus bertambah, sehingga pertumbuhan semakin cepat.", "question": "Bunga majemuk membuat pertumbuhan uang menjadi semakin cepat seiring waktu.", "type": "true_false"}'::jsonb
WHERE id = '66a35cd7-db19-4bb2-a18c-f4e7b881ab8e'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bayu punya Rp5.000.000. Ia perlu Rp2.000.000 bulan depan untuk uang kuliah. Rp2 juta itu disimpan di tabungan agar mudah diambil. Rp3.000.000 yang tidak segera dipakai bisa diputar di deposito atau reksa dana sesuai tujuan."}'::jsonb
WHERE id = 'ba6a3e0f-c88c-4d8f-a3ae-8dac43abf6b0'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina ingin membeli rumah 10 tahun lagi. Tabungan bank dengan bunga 3% mungkin tidak cukup mengimbangi inflasi. Investasi seperti reksa dana saham berisiko lebih tinggi tetapi berpotensi memberi imbal hasil lebih besar untuk tujuan jangka panjang."}'::jsonb
WHERE id = '4d78262a-6c7a-42fd-bca5-31c6a715f23e'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bank (tabungan/deposito) umumnya aman dan likuid, cocok untuk dana darurat dan tujuan jangka pendek. Investasi berpotensi imbal hasil lebih tinggi tetapi memiliki risiko dan cocok untuk jangka panjang."}'::jsonb
WHERE id = 'baa35b90-38ba-4048-9b1d-e046b3298e91'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Pilih bank untuk uang yang akan segera dipakai. Pilih investasi untuk uang yang bisa dibiarkan tumbuh dalam jangka waktu lama."}'::jsonb
WHERE id = '3b1292d2-16da-4603-a2b9-12afb8a81b0a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Dana darurat": "Tabungan bank", "Tujuan 1 tahun": "Deposito", "Tujuan 10 tahun": "Reksa dana saham"}, "difficulty": "intermediate", "explanation": "Pemilihan instrumen tergantung pada waktu dan risiko yang bisa ditoleransi.", "pairs": [["Dana darurat", "Tabungan bank"], ["Tujuan 1 tahun", "Deposito"], ["Tujuan 10 tahun", "Reksa dana saham"]], "question": "Pasangkan tujuan keuangan dengan tempat yang paling cocok.", "type": "matching"}'::jsonb
WHERE id = '178bb67f-d272-4e3a-8f5e-9fdf49211758'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Tabungan bank", "difficulty": "intermediate", "explanation": "Uang yang segera dibutuhkan harus aman dan likuid, seperti tabungan bank.", "options": ["Tabungan bank", "Saham individu", "Kripto", "Reksa dana saham"], "question": "Bayu butuh Rp2 juta bulan depan untuk uang kuliah. Tempat terbaik untuk menyimpannya adalah ...", "type": "multiple_choice"}'::jsonb
WHERE id = '9a6f7929-23e5-4ead-9504-5fe9cdcb6f63'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "risiko", "difficulty": "intermediate", "explanation": "Imbal hasil lebih tinggi umumnya disertai risiko lebih tinggi.", "question": "Untuk tujuan jangka panjang, investasi berpotensi memberi imbal hasil lebih tinggi tetapi juga memiliki _____ lebih tinggi.", "type": "fill_blank"}'::jsonb
WHERE id = '353b5699-b19e-4b66-bbf6-4bede6119f31'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Investasi memiliki risiko. Untuk tujuan jangka pendek dan dana darurat, bank lebih aman.", "question": "Investasi selalu lebih baik daripada menyimpan uang di bank untuk semua tujuan.", "type": "true_false"}'::jsonb
WHERE id = '4d3aa205-b342-4c2c-80b0-bfd7fc1ab667'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Dalam sejarah pasar modal Indonesia, IHSG pernah anjlok saat krisis 1998 dan 2008, tetapi dalam jangka panjang indeks tersebut naik. Investor yang bertahan dan rutin menabung cenderung mendapat hasil positif."}'::jsonb
WHERE id = '770ddcbd-4488-4f0b-9ac6-a78b820f0712'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Reksa dana pasar uang memiliki risiko rendah dan return rendah. Saham individual memiliki risiko tinggi dan return berpotensi tinggi. Tidak ada instrumen yang memberikan return tinggi tanpa risiko."}'::jsonb
WHERE id = '7c92b500-a30e-42e1-8697-6b2f3de999ab'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["eca56a9e-df9b-432f-b360-c1ab6450a2ae"], "text": "Bimo mendengar saham ABC naik 50% dalam sebulan. Ia membeli tanpa riset. Ternyata kenaikan itu hanya spekulasi singkat dan harga turun 30%. Bimo belajar bahwa mengikuti tren tanpa pemahaman adalah risiko besar."}'::jsonb
WHERE id = '3b853258-889d-4033-9941-21c9dad21855'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Lima mahasiswa membentuk kelompok belajar investasi. Mereka memutuskan setiap bulan menyisihkan Rp 100.000 untuk beli saham IDX30 secara berkala. Strategi ini disebut dollar-cost averaging."}'::jsonb
WHERE id = 'a993a433-bf70-4cb5-9fe4-9808518405b9'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Rina memiliki Rp 10 juta. Ia membeli saham satu perusahaan teknologi. Jika perusahaan itu rugi, seluruh portofolionya terkena. Temannya membeli 5 saham berbeda: perbankan, konsumer, energi, kesehatan, dan teknologi. Risikonya lebih tersebar."}'::jsonb
WHERE id = '6e22a1b2-3e5d-486e-a6c1-1a89b52565b1'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["7f4b83f2-8f1d-415c-9d4f-64e6284bef04", "f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Dewi memiliki dana darurat 6 bulan pengeluaran di tabungan, sehingga ia tidak perlu menjual investasi sahamnya saat butuh uang mendesak. Dana darurat melindungi investasi jangka panjang."}'::jsonb
WHERE id = '2917dfcc-ab04-4fff-b4a3-6c758dd94d8e'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["eca56a9e-df9b-432f-b360-c1ab6450a2ae", "f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Ahmad mulai menabung Rp 500.000 per bulan di reksa dana pasar uang sejak usia 20. Temannya Bayu mulai menabung jumlah sama di usia 30. Karena bunga majemuk, Ahmad memiliki nilai lebih besar saat usia 40 meski total setoran tidak jauh berbeda."}'::jsonb
WHERE id = '064c3aca-12ee-4e89-83ea-453ad76f782a'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Obligasi pemerintah umumnya lebih aman daripada saham perusahaan kecil. Oleh karena itu, imbal hasil obligasi pemerintah biasanya lebih rendah dari potensi saham."}'::jsonb
WHERE id = '6639883b-5c97-471f-bb07-0a3161135fe3'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["eca56a9e-df9b-432f-b360-c1ab6450a2ae"], "text": "Pak Sutrisno kalah Rp 2 juta karena panik menjual saham ketika harga turun 15%. Dua bulan kemudian harga saham itu naik lagi. Ia belajar bahwa panik selling bisa menghancurkan rencana jangka panjang."}'::jsonb
WHERE id = '423b8a3a-a442-4c30-bf87-392a2b84df09'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Seorang investor muda dengan tujuan pensiun 30 tahun ke depan bisa menoleransi fluktuasi pasar. Seorang investor yang butuh uang untuk DP rumah 2 tahun lagi sebaiknya memilih instrumen lebih stabil."}'::jsonb
WHERE id = '06a42cc3-7cd8-4acb-be04-ade4380541af'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Tabungan bank menawarkan bunga rendah sekitar 2-4% per tahun, tetapi uang relatif aman. Reksa dana saham berpotensi imbal hasil lebih tinggi, tetapi nilainya bisa turun dalam jangka pendek. Ini adalah hubungan risiko dan imbal hasil."}'::jsonb
WHERE id = 'c64cb7dc-bd8b-4d9a-9f07-a6b83eac5fc7'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1", "f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Seseorang yang menempatkan semua uangnya di deposito 4% per tahun memiliki risiko rendah, tetapi daya belinya bisa tergerus inflasi 5%. Return realnya negatif 1%."}'::jsonb
WHERE id = '6d00adde-de7d-4c40-9254-d8e90310fed6'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a", "07f09c6e-6a98-4fe1-b38f-0868f149ca3e"], "text": "Lina, fresh graduate, memiliki Rp 5.000.000 untuk investasi jangka panjang. Ia memutuskan menyebarkan dana: 40% ke reksa dana pasar uang (risiko rendah), 40% ke reksa dana saham (risiko lebih tinggi), dan 20% ke obligasi pemerintah. Dengan diversifikasi, Lina tidak bergantung pada satu instrumen dan mengurangi dampak jika salah satu aset merugi."}'::jsonb
WHERE id = 'd6eeab68-bcab-4e5c-a3d7-fbc6a279ecc5'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Dewi menabung Rp 1.000.000 di instrumen yang memberikan imbal hasil rata-rata 8% per tahun. Dengan bunga majemuk, setelah 10 tahun nilainya menjadi sekitar Rp 2.160.000. Temannya yang menyimpan uang tunai tetap Rp 1.000.000, tetapi daya belinya menurun akibat inflasi."}'::jsonb
WHERE id = 'a4c1cb48-291b-48b3-a34d-acc9d9e157fa'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a", "07f09c6e-6a98-4fe1-b38f-0868f149ca3e"], "text": "Andi memiliki portofolio yang terdiri dari saham bank (BBCA), saham telekomunikasi (TLKM), reksa dana pasar uang, dan obligasi pemerintah. Ketika harga saham teknologi turun, dampaknya tidak terlalu besar karena uangnya tersebar di berbagai jenis aset."}'::jsonb
WHERE id = '0228382f-0eac-4221-93e4-7b5502f778d5'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Jelaskan hubungan risiko dan pengembalian, bunga majemuk, dan diversifikasi dengan contoh rupiah. Jangan berikan rekomendasi produk spesifik.", "text": "Risiko dan pengembalian berjalan beriringan: potensi keuntungan tinggi biasanya disertai risiko tinggi. Bunga majemuk membuat keuntungan dihasilkan tidak hanya dari modal awal, tetapi juga dari keuntungan sebelumnya. Diversifikasi, atau menyebarkan investasi ke berbagai aset, membantu mengurangi risiko jika salah satu investasi merugi. Waktu adalah mitra terbaik untuk investor muda."}'::jsonb
WHERE id = 'c419d1ae-2c5e-4c3d-9a56-6fbc91532625'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Secara umum, semakin tinggi potensi imbal hasil, semakin tinggi risiko yang harus diterima. Tidak ada investasi yang menghasilkan tinggi tanpa risiko."}'::jsonb
WHERE id = '7b12b4fc-1f4b-4a72-9603-197a1d585a9c'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Pilihan investasi harus disesuaikan dengan tujuan dan toleransi risiko. Dana darurat tidak boleh diinvestasikan secara agresif."}'::jsonb
WHERE id = 'd1b89173-1815-4d4c-9b1f-f5538127168d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "-2%", "difficulty": "advanced", "explanation": "riil return ≈ nominal return - inflasi rate = 3% - 5% = -2%. Your daya beli is declining.", "parameters": {"hint": "Subtract inflation from the nominal interest rate."}, "question": "Your savings account pays 3% bunga per tahun. inflasi is 5%. apa your approximate riil return?", "type": "calculation"}'::jsonb
WHERE id = 'b7c3f735-831d-457c-abfa-d9df1d65a946'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "advanced", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "A momentum factor strategy in IDX has 15% annual return but 30% max drawdown. Is this acceptable for a pension fund?"}, "question": "A momentum factor strategy in IDX has 15% annual return but 30% max drawdown. Is this acceptable for a pension fund? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = '9e501b5d-ffb1-4eb0-a0ec-e3f6c0a339b1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "advanced", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "Explain why the efficient frontier shifts when adding Indonesian government bonds (SUN) to an all-equity portfolio."}, "question": "Explain why the efficient frontier shifts when adding Indonesian government obligasi (SUN) to an semua-equity portofolio. apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '8f79c32d-d764-4d93-8b3c-ed8d9573e3a3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "10", "difficulty": "advanced", "explanation": "EPS = Net pendapatan / Shares Outstanding = 100B / 10B = Rp 10 per share.", "parameters": {"hint": "Divide total net income by the number of shares."}, "question": "A company has net pendapatan of Rp 100B and 10B shares outstanding. apa the EPS?", "type": "calculation"}'::jsonb
WHERE id = '06af0d2a-858b-44a1-a248-e4d7e75f5f83'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "advanced", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "A fund has daily returns with mean 0.05% and std dev 1.2%. Calculate 95% 1-day VaR for Rp 1B portfolio."}, "question": "A fund has per hari returns with mean 0.05% and std dev 1.2%. Calculate 95% 1-day VaR for Rp 1B portofolio. apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = '4760c9db-9b94-4ac2-b086-7a22d2c1dea7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Calculate per bulan pendapatan → List fixed expenses → List variable expenses → Set savings target → Adjust spending to meet goals", "options": ["Calculate per bulan pendapatan", "List fixed expenses", "List variable expenses", "Set savings target", "Adjust spending to meet goals"], "parameters": {}, "question": "urutkan langkah-langkah to create a per bulan anggaran:", "type": "ordering"}'::jsonb
WHERE id = '29d0c0b0-bfba-4d9d-b5dd-1c25bb7b1f48'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Feel market panic → Stop and breathe → Review your investasi plan → Check fundamentals → Decide based on strategy not emotion", "options": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "parameters": {}, "question": "urutkan langkah-langkah to handle market volatilitas emotionally:", "type": "ordering"}'::jsonb
WHERE id = '7aa64149-4c82-48af-9438-e24926b87a3a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Research the company → Analyze financial statements → Check valuation metrics → Consider market conditions → Decide position size", "options": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "parameters": {}, "question": "urutkan langkah-langkah for fundamental saham analysis:", "type": "ordering"}'::jsonb
WHERE id = 'fc3ec95e-73fb-4086-b8b4-440334b8760a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8%", "difficulty": "advanced", "explanation": "Weighted return = (0.60 × 10%) + (0.40 × 5%) = 6% + 2% = 8%.", "parameters": {"hint": "Multiply each allocation by its return and sum the results."}, "question": "You have Rp 50M to invest. You allocate 60% to saham (expected 10% return) and 40% to obligasi (expected 5% return). apa the expected portofolio return?", "type": "calculation"}'::jsonb
WHERE id = '91783e78-a9e9-4db0-b13f-2c567bdae3b6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["OJK", "BI"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: OJK, BI.", "options": ["OJK", "BI", "IDX", "SIPF"], "parameters": {}, "question": "di Indonesia, ________ regulates financial services while ________ manages monetary policy.", "type": "word_bank"}'::jsonb
WHERE id = '24160d11-38ee-4068-a44a-ad884dc7a4d9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["bullish", "bearish"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: bullish, bearish.", "options": ["bullish", "bearish", "sideways", "volatile"], "parameters": {}, "question": "When investors are ________, they expect prices to rise; when ________, they expect declines.", "type": "word_bank"}'::jsonb
WHERE id = '7d54d1b5-dcfa-42bf-b971-0c70f1869c4d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["risiko", "return"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: risiko, return.", "options": ["risiko", "return", "diversifikasi", "likuiditas"], "parameters": {}, "question": "Investors must understand the trade-off between ________ and expected ________.", "type": "word_bank"}'::jsonb
WHERE id = 'd0e1f766-ac1e-4090-9726-509f6cf0cbd2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mixed aset classes", "difficulty": "advanced", "explanation": "diversifikasi across aset classes, sectors, and geographies reduces concentration risiko.", "options": ["100% banking stocks", "Mixed aset classes", "Both are equally diversified", "diversifikasi does not matter"], "parameters": {}, "question": "Which portofolio is likely more diversified: 100% Indonesian banking saham or a mix of Indonesian saham, obligasi, and global ETFs?", "type": "comparison"}'::jsonb
WHERE id = 'ed542354-0846-4bc1-8a81-680e3b99d7b1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "High-yield savings account", "difficulty": "advanced", "explanation": "Emergency funds need likuiditas and capital preservation, which savings accounts provide better than volatile saham.", "options": ["High-yield savings account", "saham portofolio", "Both equally appropriate", "Cryptocurrency wallet"], "parameters": {}, "question": "For emergency funds: is a high-yield savings account or a saham portofolio more appropriate?", "type": "comparison"}'::jsonb
WHERE id = '505b2922-a904-48ba-8ad9-76b5cee98a9c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Index fund berinvestasi", "difficulty": "advanced", "explanation": "Index funds offer instant diversifikasi, lower fees, and require less research and monitoring.", "options": ["Active memilih saham", "Index fund berinvestasi", "Both require equal expertise", "Neither is good for beginners"], "parameters": {}, "question": "Compare active memilih saham vs index fund berinvestasi for a beginner with limited time. Which is more suitable?", "type": "comparison"}'::jsonb
WHERE id = '7d5f0f6f-f296-47ec-8c40-699b461663bf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "aversi rugi", "difficulty": "advanced", "explanation": "aversi rugi is a key concept in behavioral finance where losses hurt about twice as much as gains feel good.", "parameters": {}, "question": "The tendency to feel losses more intensely than equivalent gains disebut ________.", "type": "fill_blank"}'::jsonb
WHERE id = '6abe667a-a2fb-4fff-b37c-5248237d6008'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "IDX", "difficulty": "advanced", "explanation": "Bursa Efek Indonesia (IDX) is the national saham exchange of Indonesia.", "parameters": {}, "question": "________ is the Indonesian saham exchange where companies list their shares.", "type": "fill_blank"}'::jsonb
WHERE id = '6227a680-e09d-4068-94a0-a58db845841a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "advanced", "explanation": "Otoritas Jasa Keuangan (OJK) is Indonesia''s financial services authority.", "parameters": {}, "question": "The organization that regulates financial services di Indonesia is abbreviated as ________.", "type": "fill_blank"}'::jsonb
WHERE id = '17848a93-5b40-4bba-a95d-e8a056f1eb33'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The saham is in a consolidation phase", "difficulty": "advanced", "explanation": "Sideways movement without clear trend typically indicates consolidation, where buyers and sellers are in equilibrium.", "options": ["The saham is definitely going up", "The saham is in a consolidation phase", "Sell immediately", "keuntungan terjamin opportunity"], "parameters": {"image_description": "A candlestick chart of a single stock over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend."}, "question": "[IMAGE: A candlestick chart of a single saham over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend.]\n\nWhat conclusion can be drawn from this price action?", "type": "image_interpretation"}'::jsonb
WHERE id = 'ea37c8a6-4885-4dca-bc74-3b39ae35068c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money"], "difficulty": "advanced", "explanation": "This exhibits classic Ponzi scheme warning signs: guaranteed high returns, secrecy, and pressure to act fast.", "options": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI put semua my money in a ''guaranteed 20% per bulan return'' scheme. The person running it says it''s secret and I shouldn''t tell anyone. I signed up immediately.", "type": "spot_mistake"}'::jsonb
WHERE id = '67b16de2-066e-4f01-b171-98c2e3933cc9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest"], "difficulty": "advanced", "explanation": "Credit card utang at 2.5% per bulan compounds to devastating levels. Minimum payments prolong utang for years.", "options": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI use my credit card for semua purchases karena I get cashback. I hanya pay the minimum balance each month. I have Rp 50M in credit card utang.", "type": "spot_mistake"}'::jsonb
WHERE id = 'd5715826-7482-4be9-9718-01b3a08c2a07'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif"], "difficulty": "advanced", "explanation": "tanpa pencatatan dan anggaran, pengeluaran mudah melebihi pendapatan tanpa disadari.", "options": ["tidak ada sistem anggaran", "pengeluaran terpecah di banyak platform", "tidak ada pencatatan pengeluaran", "bergantung pada pengecekan saldo secara reaktif", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI don''t need to anggaran karena I can selalu check my e-wallet balance. I have 5 different e-wallets and I''m not sure berapa banyak I spend total each month.", "type": "spot_mistake"}'::jsonb
WHERE id = 'c4b8bb23-6262-4aa6-91ba-4d30516abbae'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "anggaran is hanya for people with low pendapatan.", "type": "true_false"}'::jsonb
WHERE id = '9dce3830-ea79-4191-bb21-e554c9354ed1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "You need to be rich to start berinvestasi.", "type": "true_false"}'::jsonb
WHERE id = '8006f0fb-2aa9-4cff-aae9-8f1f309d02fe'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bias perilaku": ["FOMO buying", "Holding losers too long", "aversi rugi", "Confirmation bias"], "Market Condition": ["pasar bullish", "pasar bearish"], "Rational Strategy": ["rebalancing per tahun", "DCA berinvestasi"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"bias perilaku\": [\"FOMO buying\", \"Holding losers too long\", \"aversi rugi\", \"Confirmation bias\"], \"Rational Strategy\": [\"rebalancing per tahun\", \"DCA berinvestasi\"], \"Market Condition\": [\"pasar bullish\", \"pasar bearish\"]}", "options": {"buckets": ["bias perilaku", "Rational Strategy", "Market Condition"], "items": ["FOMO buying", "rebalancing per tahun", "pasar bullish", "Holding losers too long", "DCA berinvestasi", "aversi rugi", "pasar bearish", "Confirmation bias"]}, "parameters": {}, "question": "Identify whether each item represents a bias perilaku, rational strategy, or market condition:", "type": "categorization"}'::jsonb
WHERE id = '3e123552-0d95-4a94-9949-53ce49105f43'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Long Term": ["Retirement savings", "Children''s education", "Estate planning"], "Medium Term": ["House down payment (3 years)", "Car purchase (1 year)"], "Short Term": ["dana darurat", "Next month''s rent", "Vacation fund"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"Short Term\": [\"dana darurat\", \"Next month''s rent\", \"Vacation fund\"], \"Medium Term\": [\"House down payment (3 years)\", \"Car purchase (1 year)\"], \"Long Term\": [\"Retirement savings\", \"Children''s education\", \"Estate planning\"]}", "options": {"buckets": ["Short Term", "Medium Term", "Long Term"], "items": ["dana darurat", "House down payment (3 years)", "Retirement savings", "Next month''s rent", "Car purchase (1 year)", "Children''s education", "Vacation fund", "Estate planning"]}, "parameters": {}, "question": "Organize each financial tujuan by its typical time horizon:", "type": "categorization"}'::jsonb
WHERE id = '1477aa0b-edb8-4f31-a54a-c9f2c3001bb5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Investments": ["per bulan SIP", "saham purchase"], "kebutuhan": ["Rent payment", "Groceries"], "Savings": ["dana darurat deposit"], "keinginan": ["Netflix subscription", "Gym membership", "New sneakers"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"kebutuhan\": [\"Rent payment\", \"Groceries\"], \"keinginan\": [\"Netflix subscription\", \"Gym membership\", \"New sneakers\"], \"Savings\": [\"dana darurat deposit\"], \"Investments\": [\"per bulan SIP\", \"saham purchase\"]}", "options": {"buckets": ["kebutuhan", "keinginan", "Savings", "Investments"], "items": ["Rent payment", "Netflix subscription", "per bulan SIP", "dana darurat deposit", "Gym membership", "Groceries", "New sneakers", "saham purchase"]}, "parameters": {}, "question": "Categorize each item into the appropriate anggaran bucket:", "type": "categorization"}'::jsonb
WHERE id = '7a0fae7e-d0e2-4360-853a-d1c7a3c6583f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Total compensation termasuk risiko", "difficulty": "advanced", "explanation": "benar path: Total compensation termasuk risiko. This represents the most financially sound decision at this stage.", "options": ["Which office is nicer", "Total compensation termasuk risiko", "Which has better Instagram", "Friend''s opinion"], "parameters": {"full_tree": {"scenario": "You receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.", "stages": [{"correct": "Total compensation including risk", "next": {"correct": "Use expected value (probability-weighted)", "next": {"correct": "Depends on risk tolerance and obligations", "options": ["Startup for higher expected value", "Bank for stability", "Negotiate bank to Rp 12M", "Decline both, travel"], "question": "Expected value of startup package ≈ Rp 11M/month. Bank = Rp 10M. But you have Rp 5M/month expenses. Decision?"}, "options": ["Assume maximum value", "Use expected value (probability-weighted)", "Ignore it entirely", "Ask the CEO"], "question": "Startup equity could be worth Rp 500M or zero. How to value it?"}, "options": ["Which office is nicer", "Total compensation including risk", "Which has better Instagram", "Friend''s opinion"], "question": "First factor to evaluate?"}]}}, "question": "Decision Tree Scenario:\n\nYou receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.\n\nFirst factor to evaluate?", "type": "decision_tree"}'::jsonb
WHERE id = '53936207-8494-4c15-a529-4faa468cf77e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK license status", "difficulty": "advanced", "explanation": "benar path: OJK license status. This represents the most financially sound decision at this stage.", "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "parameters": {"full_tree": {"scenario": "A ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% monthly returns''.", "stages": [{"correct": "OJK license status", "next": {"correct": "Report to OJK and block", "next": {"correct": "Warn friends and family", "options": ["Ignore and move on", "Warn friends and family", "Post about it on social media", "Confront the scammer"], "question": "To protect others, best action?"}, "options": ["Invest a small amount to test", "Report to OJK and block", "Ask for a discount on entry fee", "Invite friends to join"], "question": "They have no OJK license but show ''proof'' of payments to others. What now?"}, "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "question": "First red flag to check?"}]}}, "question": "Decision Tree Scenario:\n\nA ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% per bulan returns''.\n\nFirst red flag to check?", "type": "decision_tree"}'::jsonb
WHERE id = '855aeb94-e041-4986-b101-dcb17ef15d66'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "A sustained decrease in the general price level", "Hyperinflation": "Extremely rapid and out-of-control price increases", "inflasi": "A sustained increase in the general price level of goods and services", "Stagflation": "A period of high inflasi combined with economic stagnation"}, "difficulty": "advanced", "explanation": "benar matches: inflasi = A sustained increase in the general price level of goods and services, Deflation = A sustained decrease in the general price level, Stagflation = A period of high inflasi combined with economic stagnation, Hyperinflation = Extremely rapid and out-of-control price increases", "options": {"definitions": ["A sustained increase in the general price level of goods and services", "A sustained decrease in the general price level", "A period of high inflasi combined with economic stagnation", "Extremely rapid and out-of-control price increases"], "terms": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"]}, "parameters": {}, "question": "Match each economic term with its benar definition:", "type": "definition_match"}'::jsonb
WHERE id = '0e64dcfd-8d60-4068-a3f3-139a5e14bd05'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emotion-driven", "difficulty": "advanced", "explanation": "Frequent monitoring and trading sering lead to emotional decision-making daripada disciplined strategy.", "options": ["patient long-term", "emotion-driven", "perfectly rational", "index-fund style"], "parameters": {}, "question": "An investor who checks their portofolio per hari and trades frequently is more likely to exhibit ________ behavior.", "type": "sentence_completion"}'::jsonb
WHERE id = '28fef88e-72f4-4b13-a435-290ab0baf7ef'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "memulai lebih awal dan konsisten", "difficulty": "advanced", "explanation": "waktu di pasar and kontribusi konsisten jauh lebih penting daripada memilih saham or menentukan waktu pasar.", "options": ["memilih saham terbaik", "memulai lebih awal dan konsisten", "menentukan waktu pasar dengan sempurna", "memiliki informasi orang dalam"], "parameters": {}, "question": "faktor paling penting in membangun kekayaan melalui investasi is ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'bca757fe-0dbf-429f-a66e-8011dcefdbc2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "disposition", "difficulty": "advanced", "explanation": "The disposition effect describes how investors prefer realizing gains over realizing losses.", "options": ["disposition", "confirmation", "anchoring", "availability"], "parameters": {}, "question": "In behavioral finance, the tendency to sell winning investments too early while holding losers too long disebut the ________ effect.", "type": "sentence_completion"}'::jsonb
WHERE id = '6d72cace-a6ed-4904-acc6-db339bd8e58f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Optimal portfolios for each risiko level", "difficulty": "advanced", "explanation": "The efficient frontier represents portfolios that offer the highest expected return for a given level of risiko.", "options": ["Highest return regardless of risiko", "Optimal portfolios for each risiko level", "The safest possible portofolio", "A guaranteed return threshold"], "parameters": {"image_description": "A scatter plot showing risk (volatility) on X-axis and return on Y-axis. Multiple Indonesian stocks plotted. A diagonal line shows the efficient frontier."}, "question": "[IMAGE: A scatter plot showing risiko (volatilitas) on X-axis and return on Y-axis. Multiple Indonesian saham plotted. A diagonal line shows the efficient frontier.]\n\napa yang the efficient frontier line represent?", "type": "image_interpretation"}'::jsonb
WHERE id = '2433e80e-e16f-4115-ae10-7ae9481451ce'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The power of bunga majemuk", "difficulty": "advanced", "explanation": "The dramatic difference between simple accumulation and compound growth demonstrates why starting early and staying invested matters.", "options": ["menentukan waktu pasar", "The power of bunga majemuk", "Day trading profits", "Currency hedging"], "parameters": {"image_description": "An infographic showing compound growth: Rp 1M invested monthly at 7% annual return grows to Rp 1.2B over 30 years vs only Rp 360M without interest."}, "question": "[IMAGE: An infographic showing compound growth: Rp 1M invested per bulan at 7% annual return grows to Rp 1.2B over 30 years vs hanya Rp 360M without bunga.]\n\nWhat principle is this infographic illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = '120b3804-65f9-4bf5-b508-213b0f27e775'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"obligasi": "Fixed pendapatan utang", "Deposit": "Bank savings product", "reksa dana": "Pooled investasi vehicle", "saham": "Company ownership"}, "difficulty": "advanced", "explanation": "benar matches: Deposit → Bank savings product, saham → Company ownership, obligasi → Fixed pendapatan utang, reksa dana → Pooled investasi vehicle", "options": {"left": ["Deposit", "saham", "obligasi", "reksa dana"], "right": ["Bank savings product", "Company ownership", "Fixed pendapatan utang", "Pooled investasi vehicle"]}, "parameters": {}, "question": "Match each investasi type with its description:", "type": "matching"}'::jsonb
WHERE id = '8b41bba6-e859-4774-a2c6-c8c2048b1acf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Confirmation Bias": "Seeking confirming info", "FOMO": "Fear of missing out", "aversi rugi": "Fear of losses > joy of gains", "Overconfidence": "Excessive self-assurance"}, "difficulty": "advanced", "explanation": "Correct matches: Loss Aversion → Fear of losses > joy of gains, FOMO → Fear of missing out, Confirmation Bias → Seeking confirming info, Overconfidence → Excessive self-assurance", "options": {"left": ["aversi rugi", "FOMO", "Confirmation Bias", "Overconfidence"], "right": ["Fear of losses > joy of gains", "Fear of missing out", "Seeking confirming info", "Excessive self-assurance"]}, "parameters": {}, "question": "Match each bias perilaku with its definition:", "type": "matching"}'::jsonb
WHERE id = '09cb9442-48fc-45e6-af08-55444d02499e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "Falling prices", "pasar bullish": "Rising prices", "koreksi": "10%+ decline from peak", "Sideways": "Flat movement"}, "difficulty": "advanced", "explanation": "benar matches: pasar bullish → Rising prices, pasar bearish → Falling prices, Sideways → Flat movement, koreksi → 10%+ decline from peak", "options": {"left": ["pasar bullish", "pasar bearish", "Sideways", "koreksi"], "right": ["Rising prices", "Falling prices", "Flat movement", "10%+ decline from peak"]}, "parameters": {}, "question": "Match each market condition with its description:", "type": "matching"}'::jsonb
WHERE id = 'b8792eb4-aa37-443d-ac8c-d1cfd67987d8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kebutuhan", "keinginan"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: kebutuhan, keinginan.", "options": ["kebutuhan", "keinginan", "savings", "dana darurat"], "parameters": {}, "question": "Financial planning starts with distinguishing ________ from ________, then building reserves.", "type": "word_bank"}'::jsonb
WHERE id = 'ff1185f0-1f36-4436-bc12-11e5185e1164'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"50/30/20 Rule": "anggaran allocation framework", "dollar cost averaging": "Regular fixed investments", "dana darurat": "3-6 months expense reserve", "rebalancing": "Adjusting portofolio weights"}, "difficulty": "beginner", "explanation": "Correct matches: 50/30/20 Rule → Budget allocation framework, Emergency Fund → 3-6 months expense reserve, Dollar Cost Averaging → Regular fixed investments, Rebalancing → Adjusting portfolio weights", "options": {"left": ["50/30/20 Rule", "dana darurat", "dollar cost averaging", "rebalancing"], "right": ["anggaran allocation framework", "3-6 months expense reserve", "Regular fixed investments", "Adjusting portofolio weights"]}, "parameters": {}, "question": "Match each strategy with its description:", "type": "matching"}'::jsonb
WHERE id = '20b404d6-8317-40f3-b3cd-3a989a7d14b3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')"], "difficulty": "beginner", "explanation": "Lottery is entertainment, not a rencana keuangan. The ''due'' fallacy ignores that each draw is independent.", "options": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy rencana keuangan is to win the lottery. I''ve spent Rp 5M on lottery tickets this year. I''m sure my numbers are due to come up soon.", "type": "spot_mistake"}'::jsonb
WHERE id = '2909968b-a67c-4136-a802-e763fea132fb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice"], "difficulty": "beginner", "explanation": "investasi decisions should be based on research and fundamentals, not superstition or unverified tips.", "options": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invest based on my horoscope and the advice of a WhatsApp group admin who claims to have informasi orang dalam. I tidak pernah read financial statements.", "type": "spot_mistake"}'::jsonb
WHERE id = 'ea4f0582-88d3-4942-b51f-095ac74ea811'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Untuk menghindari penjualan investasi saat butuh uang mendesak", "difficulty": "beginner", "explanation": "Dana darurat melindungi investasi jangka panjang dari kebutuhan mendesak.", "options": ["Untuk membeli saham murah", "Untuk menghindari penjualan investasi saat butuh uang mendesak", "Untuk membayar pajak", "Untuk berjudi di pasar"], "parameters": {}, "question": "Apa fungsi dana darurat dalam berinvestasi?", "type": "multiple_choice"}'::jsonb
WHERE id = 'b7405533-24ce-4d87-af52-05c2c1301e99'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Risiko dan pengembalian berjalan beriringan; keuntungan tinggi biasanya disertai risiko tinggi.", "parameters": {}, "question": "Semakin tinggi potensi keuntungan suatu investasi, semakin tinggi pula risikonya.", "type": "true_false"}'::jsonb
WHERE id = 'a8cf2f45-a350-4bc0-b12b-f01e7b5d0644'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Leverage": "The use of borrowed capital to increase potential returns", "likuiditas": "The ease with which an aset can be converted to cash", "Solvency": "The ability to meet long-term financial obligations", "volatilitas": "The degree of variation in trading prices dari waktu ke waktu"}, "difficulty": "beginner", "explanation": "benar matches: likuiditas = The ease with which an aset can be converted to cash, Solvency = The ability to meet long-term financial obligations, Leverage = The use of borrowed capital to increase potential returns, volatilitas = The degree of variation in trading prices dari waktu ke waktu", "options": {"definitions": ["The ease with which an aset can be converted to cash", "The ability to meet long-term financial obligations", "The use of borrowed capital to increase potential returns", "The degree of variation in trading prices dari waktu ke waktu"], "terms": ["likuiditas", "Solvency", "Leverage", "volatilitas"]}, "parameters": {}, "question": "Match each financial concept with its definition:", "type": "definition_match"}'::jsonb
WHERE id = '0b7b4a1c-82c2-4716-ae07-61c98754d13b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Currency depreciation and saham declines may be correlated", "difficulty": "beginner", "explanation": "Rupiah depreciation and saham market declines sering occur together during periods of foreign capital outflows and risiko aversion.", "options": ["Currency appreciation helps saham", "Currency depreciation and saham declines may be correlated", "saham and currency are unrelated", "Government controls both"], "parameters": {"image_description": "A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling."}, "question": "[IMAGE: A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling.]\n\nWhat relationship might this chart be illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = '35f8fc95-ce8b-49ba-979b-922c305b8b20'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Government obligasi", "difficulty": "beginner", "explanation": "Real return deposits: 4% - 3% = 1%. Bonds: 6% - 3% = 3%. Bonds provide better inflation protection.", "options": ["Fixed deposits", "Government obligasi", "Both equal", "Neither beats inflasi"], "parameters": {}, "question": "Compare fixed deposits (4% p.a.) vs government obligasi (6% p.a.) for a conservative investor. Which offers better riil returns if inflasi is 3%?", "type": "comparison"}'::jsonb
WHERE id = 'e071e9d8-a34a-40d7-b27d-b6ae0e71902e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 2M from age 30", "difficulty": "beginner", "explanation": "Starting earlier gives compounding more time to work. Rp 2M × 30 years at 7% beats Rp 5M × 15 years.", "options": ["Rp 2M from age 30", "Rp 5M from age 45", "Both equal at retirement", "Neither is enough"], "parameters": {}, "question": "For retirement savings starting at age 30: is it better to save Rp 2M per bulan or Rp 5M per bulan starting at age 45?", "type": "comparison"}'::jsonb
WHERE id = 'ffc442e9-929f-4aeb-b343-bd0e9e30b036'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Market ETF", "difficulty": "beginner", "explanation": "ETFs hold many saham, eliminating company-specific (unsystematic) risiko that single saham carry.", "options": ["Single saham", "Market ETF", "Both have same risiko", "risiko cannot be measured"], "parameters": {}, "question": "Compare the risiko: buying a single saham vs an ETF tracking the entire market. Which has lower unsystematic risiko?", "type": "comparison"}'::jsonb
WHERE id = '8efd6a16-335a-4ce8-9536-47a9fe897a3e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["principal", "bunga"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: principal, bunga.", "options": ["principal", "bunga", "compound", "maturity"], "parameters": {}, "question": "With ________ bunga, you earn returns on both your ________ and accumulated earnings.", "type": "word_bank"}'::jsonb
WHERE id = '23408171-abea-4a31-aa5b-609e73994250'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs"], "difficulty": "beginner", "explanation": "Starting young maximizes compounding. Even small amounts invested early outperform larger amounts invested later.", "options": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI''m 22 and I think berinvestasi is hanya for old people. I''ll start when I have a ''riil job.'' My money stays in a checking account earning 0% bunga.", "type": "spot_mistake"}'::jsonb
WHERE id = '1da2144c-dc34-409c-9cef-fbf5e150ddcc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "Behavioral biases hanya affect inexperienced investors.", "type": "true_false"}'::jsonb
WHERE id = '0f0e707e-5164-4343-a3df-2257c4f353d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "diversifikasi", "difficulty": "beginner", "explanation": "diversifikasi ensures that poor performance in one investasi does not destroy the entire portofolio.", "parameters": {}, "question": "________ is the practice of spreading investments across different assets to reduce risiko.", "type": "fill_blank"}'::jsonb
WHERE id = '0e253fc2-5930-409b-bd7b-64a788e19d59'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tentukan tujuan", "Pilih instrumen sesuai risiko", "Diversifikasi", "Evaluasi berkala"], "difficulty": "beginner", "explanation": "Tentukan tujuan, pilih instrumen, diversifikasi, lalu evaluasi secara berkala.", "options": ["Tentukan tujuan", "Pilih instrumen sesuai risiko", "Diversifikasi", "Evaluasi berkala"], "parameters": {}, "question": "Urutkan langkah menyusun portofolio sederhana:", "type": "ordering"}'::jsonb
WHERE id = 'cfb21e77-6a6b-466b-86fc-3acca267d9ac'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "beginner", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "A bond pays 6% fixed. A stock might return 15% or lose 10%. Which is riskier?"}, "question": "A obligasi pays 6% fixed. A saham might return 15% or lose 10%. Which is riskier? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = 'fd9b5365-618b-4d62-ada7-28adab2d2526'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Most months are near average, extremes are rare", "difficulty": "beginner", "explanation": "The bell-shaped distribution with most data near the mean and fewer observations in the tails is characteristic of return distributions.", "options": ["Returns are normally distributed", "Returns are predictable", "Most months are near average, extremes are rare", "Every month is equally likely"], "parameters": {"image_description": "A histogram showing distribution of monthly returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%."}, "question": "[IMAGE: A histogram showing distribution of per bulan returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%.]\n\napa yang the shape of this distribution suggest about market returns?", "type": "image_interpretation"}'::jsonb
WHERE id = '89162961-01c7-487d-bef8-aea7540521c8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Sharpe", "difficulty": "beginner", "explanation": "Therasio Sharpe helps investors understand return per unit of risiko taken.", "parameters": {}, "question": "The ________ ratio measures risiko-adjusted return by comparing excess return to volatilitas.", "type": "fill_blank"}'::jsonb
WHERE id = '43da2ad7-d582-4ee6-9c61-52bd8e604c0e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"advanced Investor": "Uses derivatives, manages risiko", "beginner Investor": "Learns basics, uses deposits", "intermediate Investor": "Understands ratios, diversifies"}, "difficulty": "beginner", "explanation": "benar matches: beginner Investor → Learns basics, uses deposits, intermediate Investor → Understands ratios, diversifies, advanced Investor → Uses derivatives, manages risiko", "options": {"left": ["beginner Investor", "intermediate Investor", "advanced Investor"], "right": ["Learns basics, uses deposits", "Understands ratios, diversifies", "Uses derivatives, manages risiko"]}, "parameters": {}, "question": "Match each investor level with its characteristics:", "type": "matching"}'::jsonb
WHERE id = 'c894ce04-0428-4b7c-b921-414b87336579'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emergency", "difficulty": "beginner", "explanation": "Emergency funds provide financial security during unforeseen circumstances like job loss or medical emergencies.", "parameters": {}, "question": "A ________ fund is money set aside specifically for unexpected expenses.", "type": "fill_blank"}'::jsonb
WHERE id = '0b83dc8b-d306-439c-854c-0e1f000938e6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Diversifikasi mengurangi risiko, tetapi tidak menjamin keuntungan.", "parameters": {}, "question": "Diversifikasi menjamin investasi selalu menghasilkan keuntungan.", "type": "true_false"}'::jsonb
WHERE id = '51c19eaf-3ede-4d9e-9fb6-c6b9d29b7e3f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "If a company is famous, its saham is selalu a good investasi.", "type": "true_false"}'::jsonb
WHERE id = '850dcb21-b80d-439a-90cc-292e26e5785d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Fundamental Analysis": "Financial statements", "Quantitative Analysis": "Mathematical models", "Sentiment Analysis": "Market mood and emotions", "Technical Analysis": "Charts and patterns"}, "difficulty": "beginner", "explanation": "benar matches: Technical Analysis → Charts and patterns, Fundamental Analysis → Financial statements, Quantitative Analysis → Mathematical models, Sentiment Analysis → Market mood and emotions", "options": {"left": ["Technical Analysis", "Fundamental Analysis", "Quantitative Analysis", "Sentiment Analysis"], "right": ["Charts and patterns", "Financial statements", "Mathematical models", "Market mood and emotions"]}, "parameters": {}, "question": "Match each analysis approach with its focus:", "type": "matching"}'::jsonb
WHERE id = 'c9c656c2-44b6-4334-9716-2d39eb4dff96'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "beginner", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "Using the Rule of 72, how long does it take to double money at 6% annual return?"}, "question": "Using the Rule of 72, berapa lama does it take to double money at 6% annual return? What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = '957de8a4-9a9c-4d88-b81e-f5efaccb6eab'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Beli banyak saham dari sektor berbeda"], "difficulty": "beginner", "explanation": "Diversifikasi antar sektor mengurangi risiko jika satu perusahaan atau sektor lesu.", "options": ["Beli banyak saham dari sektor berbeda", "Menyimpan semua uang di satu saham", "Menabung di bantal", "Ikut tren tanpa riset"], "parameters": {}, "question": "Cara mengurangi risiko spesifik saham: ____", "type": "word_bank"}'::jsonb
WHERE id = '703fb839-48a6-4090-a77b-b1834ec1ee85'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Belajar dulu dan mulai dengan uang yang tidak akan digunakan dalam jangka pendek", "difficulty": "beginner", "explanation": "Pemula harus belajar dan menggunakan uang dingin agar tidak panik saat pasar turun.", "options": ["Langsung berutang untuk beli saham", "Belajar dulu dan mulai dengan uang yang tidak akan digunakan dalam jangka pendek", "Ikut saran influencer tanpa riset", "Menempatkan semua uang di satu saham teman"], "parameters": {}, "question": "Seseorang yang baru mulai berinvestasi sebaiknya?", "type": "multiple_choice"}'::jsonb
WHERE id = '0859abed-d81b-454a-91d2-dbf4d68d262b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "beginner", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "You split Rp 20M equally across 5 stocks vs putting all in 1 stock. Which is safer?"}, "question": "You split Rp 20M equally across 5 saham vs putting semua in 1 saham. Which is safer? apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = 'a667b8f8-aab1-4ac1-be6e-8c400e9696ed'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Risiko tinggi, return berpotensi tinggi", "difficulty": "beginner", "explanation": "Umumnya, semakin tinggi potensi return, semakin tinggi risikonya.", "options": ["Risiko tinggi, return rendah", "Risiko rendah, return tinggi", "Risiko tinggi, return berpotensi tinggi", "Tidak ada hubungan"], "parameters": {}, "question": "Hubungan umum antara risiko dan return adalah?", "type": "multiple_choice"}'::jsonb
WHERE id = '72198eb1-4fc6-489d-b5ef-fb100b44e65a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "is not indicative of", "difficulty": "beginner", "explanation": "Standard disclaimer: past performance does not guarantee future results. Markets are inherently uncertain.", "options": ["guarantees", "is not indicative of", "is the hanya predictor of", "selalu exceeds"], "parameters": {}, "question": "When evaluating an investasi, past performance ________ future results.", "type": "sentence_completion"}'::jsonb
WHERE id = '229ec97f-82d1-48ff-9be7-5ae5ca132697'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "provide financial security during crises", "difficulty": "beginner", "explanation": "Emergency funds prioritize likuiditas and safety over returns, providing a buffer for unexpected expenses.", "options": ["maximize returns", "provide financial security during crises", "beat inflasi", "fund vacations"], "parameters": {}, "question": "The primary purpose of an dana darurat is to ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '00374998-2f0e-4d3d-8ca8-c0deecec5b0e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "more", "difficulty": "beginner", "explanation": "beta measures sensitivity to market movements. beta 1.5 means 50% more volatile than the market.", "options": ["less", "more", "in the opposite direction", "independently"], "parameters": {}, "question": "A saham with a beta of 1.5 diharapkan bergerak ________ daripada pasar secara keseluruhan.", "type": "sentence_completion"}'::jsonb
WHERE id = '168e9d89-3755-46fd-997b-75e6050d3442'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Diversifikasi adalah menyebarkan investasi ke berbagai instrumen untuk mengurangi risiko.", "parameters": {}, "question": "Diversifikasi berarti menempatkan semua uang di satu instrumen yang paling menjanjikan.", "type": "true_false"}'::jsonb
WHERE id = 'ff58c4d0-b09f-428d-bd86-d38bcf89c95a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Starting early dramatically increases final kekayaan", "difficulty": "beginner", "explanation": "The accelerating growth shown in the timeline demonstrates the exponential power of bunga majemuk over long periods.", "options": ["You need to be rich to start", "Starting early dramatically increases final kekayaan", "Retirement is impossible", "hanya high earners can retire"], "parameters": {"image_description": "A timeline infographic: Age 25 (start investing Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B)."}, "question": "[IMAGE: A timeline infographic: Age 25 (start berinvestasi Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B).]\n\nWhat utama message of this retirement savings timeline?", "type": "image_interpretation"}'::jsonb
WHERE id = '9d4db30f-96dc-4485-84a2-9749506715a9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena bunga majemuk bekerja lebih baik dalam jangka panjang", "difficulty": "beginner", "explanation": "Semakin lama waktu investasi, semakin besar efek bunga majemuk.", "options": ["Karena pasar selalu naik setiap hari", "Karena bunga majemuk bekerja lebih baik dalam jangka panjang", "Karena biaya administrasi lebih murah", "Karena tidak ada risiko"], "parameters": {}, "question": "Mengapa waktu investasi penting?", "type": "multiple_choice"}'::jsonb
WHERE id = '3ec90d06-7ff0-4ca7-8c25-b16c4cbe8e5b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Spot red flags → Verify information → Consult trusted sources → Document concerns → Report to authorities if needed", "options": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "parameters": {}, "question": "urutkan langkah-langkah to respond to a potential investasi penipuan:", "type": "ordering"}'::jsonb
WHERE id = 'f38612ca-5453-415d-840b-38419f1a466b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Define risiko tolerance → Set time horizon → Choose aset allocation → Select specific investments → Rebalance periodically", "options": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "parameters": {}, "question": "urutkan langkah-langkah to build an investasi portofolio:", "type": "ordering"}'::jsonb
WHERE id = '5306d7ee-cc95-480f-a594-fec7c1d5e3bc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: pahami tingkat inflasi → periksa suku bunga tabungan → hitung return riil → pertimbangkan alternatif → sesuaikan strategi menabung", "options": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "parameters": {}, "question": "urutkan langkah-langkah untuk melindungi tabungan dari inflasi:", "type": "ordering"}'::jsonb
WHERE id = '617438b4-5b03-49fc-b69d-e2af6f8a7921'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "panic", "difficulty": "beginner", "explanation": "Panic selling adalah menjual investasi karena takut, sering merugikan jangka panjang.", "parameters": {}, "question": "Menjual saham dalam panik ketika harga turun disebut ____ selling.", "type": "fill_blank"}'::jsonb
WHERE id = '0da1cd80-2542-4111-807e-5a0d81509537'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8.4%", "difficulty": "beginner", "explanation": "CAGR = (Ending Value / Beginning Value)^(1/n) - 1 = (150/100)^(1/5) - 1 ≈ 8.4%.", "parameters": {"hint": "Use the CAGR formula: (FV/PV)^(1/years) - 1."}, "question": "jika rp 100 juta tumbuh menjadi rp 150 juta dalam 5 tahun, berapakah perkiraan tingkat pertumbuhan tahunan majemuk (CAGR)?", "type": "calculation"}'::jsonb
WHERE id = 'a9de97c3-4235-4df4-ad50-399ef8dc65d7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "1,600,000", "difficulty": "beginner", "explanation": "20% of 8,000,000 = 0.20 × 8,000,000 = Rp 1,600,000.", "parameters": {"hint": "Calculate 20% of the monthly income."}, "question": "You earn Rp 8M per bulan. Following the 50/30/20 rule, berapa banyak should go to savings and utang?", "type": "calculation"}'::jsonb
WHERE id = 'cf9963d4-a613-4275-b306-b7e4c298cf17'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["FOMO", "aversi rugi"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: FOMO, aversi rugi.", "options": ["FOMO", "aversi rugi", "herd mentality", "confirmation bias"], "parameters": {}, "question": "Common behavioral biases include ________, ________, and following the crowd without research.", "type": "word_bank"}'::jsonb
WHERE id = 'cb5ecd86-d77c-436a-aa20-b774d43957f2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "0.69", "difficulty": "beginner", "explanation": "Portfolio beta = (0.50 × 1.2) + (0.30 × 0.3) + (0.20 × 0) = 0.60 + 0.09 + 0 = 0.69.", "parameters": {"hint": "Weight each asset''s beta by its portfolio allocation."}, "question": "A portofolio has 50% saham (beta 1.2), 30% obligasi (beta 0.3), 20% cash (beta 0). apa the portofolio beta?", "type": "calculation"}'::jsonb
WHERE id = 'e62eb996-f99f-45aa-8611-b74696dae311'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"alpha": "Excess return relative to a benchmark", "beta": "Sensitivity of a saham''s returns to market movements", "Sharpe Ratio": "risiko-adjusted return measuring excess return per unit of risiko", "Standard Deviation": "A measure of the dispersion of returns around the mean"}, "difficulty": "beginner", "explanation": "benar matches: alpha = Excess return relative to a benchmark, beta = Sensitivity of a saham''s returns to market movements, Sharpe Ratio = risiko-adjusted return measuring excess return per unit of risiko, Standard Deviation = A measure of the dispersion of returns around the mean", "options": {"definitions": ["Excess return relative to a benchmark", "Sensitivity of a saham''s returns to market movements", "risiko-adjusted return measuring excess return per unit of risiko", "A measure of the dispersion of returns around the mean"], "terms": ["alpha", "beta", "Sharpe Ratio", "Standard Deviation"]}, "parameters": {}, "question": "Match each risiko/return measure with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '58f6def5-7217-408d-9140-8765dbd61118'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy"], "difficulty": "intermediate", "explanation": "Emotional trading, no strategy, and social media tips are unreliable sources of investasi decisions.", "options": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI check my saham portofolio every hour and sell whenever it drops more than 2%. I juga buy whatever saham is trending on social media.", "type": "spot_mistake"}'::jsonb
WHERE id = '49a960a6-d288-4f2c-930d-6855136e1165'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals"], "difficulty": "intermediate", "explanation": "anggaran is upside-down, savings insufficient, and emergency funds must be liquid and safe.", "options": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy anggaran allocates 70% to keinginan, 20% to kebutuhan, and 10% to savings. I juga keep my dana darurat in cryptocurrency for higher returns.", "type": "spot_mistake"}'::jsonb
WHERE id = '8c29d6ad-92e7-4ec9-9359-c2baf05e5194'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "menabung money under your mattress is selalu better than bank deposits.", "type": "true_false"}'::jsonb
WHERE id = '12b2671f-5885-4594-827e-420043cbd619'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time"], "difficulty": "intermediate", "explanation": "Multiple errors: no diversifikasi, no due diligence, unrealistic return expectations, and unverified broker.", "options": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invested semua my savings in one saham karena my friend said it was a ''sure thing.'' I juga didn''t check if the broker was OJK-licensed. I''m sure I''ll double my money in 3 months!", "type": "spot_mistake"}'::jsonb
WHERE id = '30d6716b-66b4-4248-b320-b116330ce406'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan vs keinginan", "difficulty": "intermediate", "explanation": "Understanding kebutuhan versus keinginan is fundamental to anggaran and menabung.", "parameters": {}, "question": "The concept of ________ helps individuals distinguish between essential and non-essential spending.", "type": "fill_blank"}'::jsonb
WHERE id = 'b41d6b59-d3bd-495f-8800-0033d06a24c3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2.5", "difficulty": "intermediate", "explanation": "BI''s inflasi target is approximately 2.5% with a tolerance band of ±1%.", "parameters": {}, "question": "Bank Indonesia targets inflation around ________ percent per year.", "type": "fill_blank"}'::jsonb
WHERE id = '8e3d60dc-c045-47ac-a3f4-9e45c3ff1be0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "intermediate", "explanation": "The 50/30/20 rule allocates 50% to kebutuhan, 30% to keinginan, and 20% to savings and utang.", "parameters": {}, "question": "The 50/30/20 rule suggests allocating ________ percent of pendapatan to savings and utang repayment.", "type": "fill_blank"}'::jsonb
WHERE id = 'fb4666fb-7d8e-4c96-a603-770b8a5ae53c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "saham have historically outpaced inflasi", "difficulty": "intermediate", "explanation": "The chart shows that while savings lose daya beli to inflasi, equities have historically provided returns that exceed inflasi.", "options": ["Savings accounts beat inflasi", "saham have historically outpaced inflasi", "semua investments are equal", "Cash yang terbaik store of value"], "parameters": {"image_description": "A bar chart comparing inflation rate (3%) vs savings account interest (2%) vs stock market average return (10%) over 10 years."}, "question": "[IMAGE: A bar chart comparing inflasi rate (3%) vs savings account bunga (2%) vs saham market average return (10%) over 10 years.]\n\nWhat key insight does this comparison reveal?", "type": "image_interpretation"}'::jsonb
WHERE id = '56ba86a8-c4f4-4f0b-881c-0d19fab2dfa6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp {{amount * (1 + rate/100) ** years}}", "difficulty": "intermediate", "explanation": "Bunga majemuk menghitung pertumbuhan dari modal dan imbal hasil yang sudah diperoleh: nilai = modal × (1 + rate)^tahun.", "options": ["Rp {{amount * (1 + rate/100) ** years}}", "Rp {{amount + rate * years}}", "Rp {{amount * years}}", "Rp {{amount * rate}}"], "parameters": {"amount": {"max": 5000000, "min": 1000000, "step": 500000}, "rate": {"max": 12, "min": 5, "step": 1}, "years": {"max": 15, "min": 5, "step": 1}}, "question": "Jika Rp {{amount}} diinvestasikan dengan imbal hasil rata-rata {{rate}}% per tahun, berapa nilai perkiraan setelah {{years}} tahun (bunga majemuk)?", "type": "multiple_choice"}'::jsonb
WHERE id = '32b58bc8-66c9-41d9-9c47-8f5ea2a38b19'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Not an aset": ["Time with family", "Car (depreciating)", "Lifestyle sneakers"], "Risky Assets": ["Bitcoin", "Individual saham", "riil estate"], "Safe Assets": ["Bank deposit", "Government obligasi"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"Safe Assets\": [\"Bank deposit\", \"Government obligasi\"], \"Risky Assets\": [\"Bitcoin\", \"Individual saham\", \"riil estate\"], \"Not an aset\": [\"Time with family\", \"Car (depreciating)\", \"Lifestyle sneakers\"]}", "options": {"buckets": ["Safe Assets", "Risky Assets", "Not an aset"], "items": ["Bank deposit", "Bitcoin", "Time with family", "Government obligasi", "Individual saham", "Car (depreciating)", "riil estate", "Lifestyle sneakers"]}, "parameters": {}, "question": "Sort each item into the benar aset classification:", "type": "categorization"}'::jsonb
WHERE id = '9481fc20-9abb-4e16-8d3e-d30da842f7fa'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"inflasi Hedge": ["Gold", "riil estate", "inflasi-indexed obligasi", "saham portofolio"], "inflasi risiko": ["Cash under mattress", "Fixed deposit at 2%"], "Neutral": ["Foreign currency", "Collectibles"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"inflasi Hedge\": [\"Gold\", \"riil estate\", \"inflasi-indexed obligasi\", \"saham portofolio\"], \"inflasi risiko\": [\"Cash under mattress\", \"Fixed deposit at 2%\"], \"Neutral\": [\"Foreign currency\", \"Collectibles\"]}", "options": {"buckets": ["inflasi Hedge", "inflasi risiko", "Neutral"], "items": ["Gold", "Cash under mattress", "riil estate", "Fixed deposit at 2%", "inflasi-indexed obligasi", "saham portofolio", "Foreign currency", "Collectibles"]}, "parameters": {}, "question": "Classify each item based on its relationship with inflasi:", "type": "categorization"}'::jsonb
WHERE id = '034f6752-c99b-42ed-8c12-6a82facb64b3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Imbal hasil dihitung dari modal dan imbal hasil sebelumnya", "difficulty": "intermediate", "explanation": "Bunga majemuk menghasilkan imbal hasil dari modal awal dan dari imbal hasil yang sudah diperoleh sebelumnya.", "options": ["Imbal hasil dihitung hanya dari modal awal", "Imbal hasil dihitung dari modal dan imbal hasil sebelumnya", "Bunga yang diterima tetap setiap tahun", "Tidak memiliki risiko sama sekali"], "parameters": {}, "question": "Manakah pernyataan yang paling tepat menggambarkan bunga majemuk?", "type": "multiple_choice"}'::jsonb
WHERE id = 'c0287659-5b95-4f84-a39d-a1c675bff63a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "dollar cost averaging", "difficulty": "intermediate", "explanation": "DCA spreads purchases dari waktu ke waktu, reducing the impact of berinvestasi at a market peak.", "options": ["lump sum berinvestasi", "dollar cost averaging", "Both eliminate timing risiko", "Neither helps"], "parameters": {}, "question": "Compare lump sum berinvestasi vs dollar cost averaging (DCA) in a volatile market. Which typically reduces timing risiko?", "type": "comparison"}'::jsonb
WHERE id = 'a5e58561-3816-468c-ac84-9128d50d57e4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Start berinvestasi early", "difficulty": "intermediate", "explanation": "At a young age, the power of compounding favors starting investments early, while low-bunga loans can be managed alongside.", "options": ["Pay off loans first completely", "Start berinvestasi early", "Do neither, spend on experiences", "Split equally"], "parameters": {}, "question": "For a 25-year-old with stable pendapatan: is it better to prioritize paying off low-bunga student loans or start berinvestasi early?", "type": "comparison"}'::jsonb
WHERE id = '69f112a9-df6d-48b7-8725-dcd34da67cd7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK-licensed bank deposit", "difficulty": "intermediate", "explanation": "Licensed deposits are regulated and insured. Unlicensed platforms carry penipuan risiko and no investor protection.", "options": ["OJK-licensed bank deposit", "Unlicensed P2P platform", "Both equally safe", "Cannot determine"], "parameters": {}, "question": "Which is generally safer: keeping Rp 50M in an OJK-licensed bank deposit or berinvestasi in an unlicensed P2P platform promising 15% returns?", "type": "comparison"}'::jsonb
WHERE id = 'f8167651-7bca-4d55-80d8-a6d9ddeb991b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["menabung", "anggaran"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: menabung, anggaran.", "options": ["menabung", "anggaran", "berinvestasi", "spending"], "parameters": {}, "question": "Before ________, you should selalu create a ________ to plan your pendapatan and expenses.", "type": "word_bank"}'::jsonb
WHERE id = '793942d6-7d29-4992-ba9a-f7eb43da1541'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["inflasi", "deflation"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: inflasi, deflation.", "options": ["inflasi", "deflation", "stagflation", "hyperinflation"], "parameters": {}, "question": "________ occurs when prices rise across the economy, while ________ is when prices fall.", "type": "word_bank"}'::jsonb
WHERE id = '4bb2ba73-f9b8-415f-8653-482b3103f592'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Return real deposito negatif karena inflasi lebih tinggi dari bunga.", "parameters": {}, "question": "Deposito bank dengan bunga 4% per tahun tetap menguntungkan meski inflasi 5% per tahun.", "type": "true_false"}'::jsonb
WHERE id = 'f003118b-c0c6-4729-838f-00b512ecacc7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["saham", "obligasi"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: saham, obligasi.", "options": ["saham", "obligasi", "mutual funds", "deposits"], "parameters": {}, "question": "A balanced portofolio might include ________, ________, and other aset classes.", "type": "word_bank"}'::jsonb
WHERE id = '18137f33-ad79-458f-91b2-f29380a6af7a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Instrumen stabil seperti deposito atau pasar uang", "difficulty": "intermediate", "explanation": "Untuk tujuan jangka pendek, pilih instrumen stabil agar nilai tidak tergerus pasar.", "options": ["Saham individu yang spekulatif", "Instrumen stabil seperti deposito atau pasar uang", "Kripto dengan volatilitas tinggi", "Tidak menabung sama sekali"], "parameters": {}, "question": "Investor yang butuh uang untuk DP rumah dalam 2 tahun sebaiknya memilih?", "type": "multiple_choice"}'::jsonb
WHERE id = '7d470952-0eed-4014-9300-9f3a9fc09831'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "9", "difficulty": "intermediate", "explanation": "Rule of 72: Years to double = 72 / interest rate. 72 / 8 = 9 years.", "parameters": {"hint": "Divide 72 by the annual return percentage."}, "question": "Using the Rule of 72, how many years does it take to double money at 8% annual return?", "type": "calculation"}'::jsonb
WHERE id = 'f3efd05f-3cf0-4b2e-a4a6-387c67ff6e88'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "24%", "difficulty": "intermediate", "explanation": "Initial investment: 200 × 5,000 = 1,000,000. Final value: 200 × 6,200 = 1,240,000. Return = (1,240,000 - 1,000,000) / 1,000,000 = 24%.", "parameters": {"hint": "Calculate total initial cost, total final value, then percentage change."}, "question": "A saham costs Rp 5,000 per share. You buy 200 shares. After 1 year, the price is Rp 6,200. apa your percentage return?", "type": "calculation"}'::jsonb
WHERE id = '85da7d33-af34-476d-bfa7-47be1e0c047b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "69,770,000", "difficulty": "intermediate", "explanation": "Using the future value of an annuity formula: FV = PMT × [(1+r)^n - 1]/r. With r = 0.5% per bulan, n = 60, PMT = 1,000,000. FV ≈ Rp 69.77M.", "parameters": {"hint": "Use FV annuity formula with monthly compounding."}, "question": "If you save Rp 1,000,000 per bulan at 6% annual bunga compounded per bulan, berapa banyak will you have after 5 years?", "type": "calculation"}'::jsonb
WHERE id = '167f1562-962f-4378-a1d7-3556e512fb23'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "A market condition where prices are falling or expected to fall", "pasar bullish": "A market condition where prices are rising or expected to rise", "koreksi": "A decline of 10% or more from a recent peak", "crash": "A sudden dramatic decline of 20% or more in saham prices"}, "difficulty": "intermediate", "explanation": "benar matches: pasar bullish = A market condition where prices are rising or expected to rise, pasar bearish = A market condition where prices are falling or expected to fall, koreksi = A decline of 10% or more from a recent peak, crash = A sudden dramatic decline of 20% or more in saham prices", "options": {"definitions": ["A market condition where prices are rising or expected to rise", "A market condition where prices are falling or expected to fall", "A decline of 10% or more from a recent peak", "A sudden dramatic decline of 20% or more in saham prices"], "terms": ["pasar bullish", "pasar bearish", "koreksi", "crash"]}, "parameters": {}, "question": "Match each market term with its description:", "type": "definition_match"}'::jsonb
WHERE id = 'abeab129-bb52-4d2f-8378-12d3e6321a0f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Set financial goals → Track pendapatan and expenses → Create a anggaran → Build dana darurat → Start berinvestasi", "options": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "parameters": {}, "question": "Order these steps to build a solid financial foundation:", "type": "ordering"}'::jsonb
WHERE id = '2c237ddc-7b0a-4d81-b868-b819db9469ec'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: periksa izin OJK → Read the prospectus → Understand the risks → Start with small amount → Monitor regularly", "options": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "parameters": {}, "question": "Order the proper due diligence steps before berinvestasi:", "type": "ordering"}'::jsonb
WHERE id = 'e54b1852-a0c1-435f-aea4-ae274ef24f9d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Identify kebutuhan → Identify keinginan → Allocate 50% to kebutuhan → Allocate 30% to keinginan → Save 20%", "options": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "parameters": {}, "question": "urutkan langkah-langkah to apply the 50/30/20 anggaran rule:", "type": "ordering"}'::jsonb
WHERE id = '8a424566-b4e2-4a1c-9c9c-4fc6fff447f7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Check if fundamentals changed", "difficulty": "intermediate", "explanation": "benar path: Check if fundamentals changed. This represents the most financially sound decision at this stage.", "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "parameters": {"full_tree": {"scenario": "The stock market drops 20% in one month. You have Rp 200M invested across 10 stocks.", "stages": [{"correct": "Check if fundamentals changed", "next": {"correct": "Hold and consider buying more", "next": {"correct": "Dollar cost average over 3 months", "options": ["All remaining cash at once", "Dollar cost average over 3 months", "Wait for ''the bottom''", "Borrow to invest"], "question": "You decide to buy more. Best approach?"}, "options": ["Panic sell to preserve capital", "Hold and consider buying more", "Switch to gold entirely", "Blame the government"], "question": "Fundamentals are intact. What action makes sense?"}, "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "question": "First reaction: What do you check?"}]}}, "question": "Decision Tree Scenario:\n\nThe saham market drops 20% in one month. You have Rp 200M invested across 10 saham.\n\nFirst reaction: What do you check?", "type": "decision_tree"}'::jsonb
WHERE id = '86325b41-7802-405f-9092-e7d10820dad3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Imbal hasil tinggi biasanya disertai risiko tinggi", "difficulty": "intermediate", "explanation": "Investor menuntut kompensasi lebih besar untuk menanggung risiko lebih besar.", "options": ["Imbal hasil tinggi biasanya disertai risiko tinggi", "Investasi aman selalu menghasilkan untung besar", "Risiko tinggi berarti pasti rugi", "Imbal hasil dan risiko tidak berhubungan"], "question": "Manakah pernyataan yang benar tentang hubungan risiko dan imbal hasil?", "type": "multiple_choice"}'::jsonb
WHERE id = 'f66c2e8d-4334-4225-91fc-d88cb2a005c9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "intermediate", "explanation": "Risiko rendah umumnya diimbangi dengan imbal hasil rendah.", "question": "Tabungan bank berisiko sangat rendah, sehingga bunganya biasanya rendah.", "type": "true_false"}'::jsonb
WHERE id = '6a0ac6c3-d54a-4353-acf9-784cd1610ed2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "fluktuasi", "difficulty": "intermediate", "explanation": "Saham bisa naik dan turun dalam jangka pendek, sehingga risiko fluktuasi tinggi.", "question": "Reksa dana saham memiliki potensi imbal hasil tinggi tetapi juga _____ harga yang lebih besar.", "type": "fill_blank"}'::jsonb
WHERE id = '005dfc88-b7cc-4d70-b484-81d770cf3a6a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 3M (20% of pendapatan)", "difficulty": "intermediate", "explanation": "benar path: Rp 3M (20% of pendapatan). This represents the most financially sound decision at this stage.", "options": ["Rp 500K", "Rp 3M (20% of pendapatan)", "Rp 7.5M (50% of pendapatan)", "Nothing, spend freely"], "parameters": {"full_tree": {"scenario": "You are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.", "stages": [{"correct": "Rp 3M (20% of income)", "next": {"correct": "High-yield savings", "next": {"correct": "Money market fund", "options": ["Regular savings", "Money market fund", "Aggressive growth stocks", "Friends'' business"], "question": "After emergency fund, monthly surplus goes to house fund. Best vehicle?"}, "options": ["Crypto wallet", "High-yield savings", "Stock market", "Under mattress"], "question": "Where should you keep the emergency portion (3 months expenses = Rp 45M target)?"}, "options": ["Rp 500K", "Rp 3M (20% of income)", "Rp 7.5M (50% of income)", "Nothing, spend freely"], "question": "Month 1: How much should you save first?"}]}}, "question": "Decision Tree Scenario:\n\nYou are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.\n\nMonth 1: berapa banyak should you save first?", "type": "decision_tree"}'::jsonb
WHERE id = '80f9687d-d51a-409c-9886-e93c3d4128dc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Reksa dana saham dibanding tabungan", "difficulty": "intermediate", "explanation": "Untuk jangka menengah-panjang, investasi seperti reksa dana saham lebih berpotensi mengalahkan inflasi.", "options": ["Reksa dana saham dibanding tabungan", "Tabungan 100%", "Menyimpan uang tunai", "Pinjaman online"], "question": "Untuk tujuan 5 tahun ke depan, mana yang lebih sesuai?", "type": "multiple_choice"}'::jsonb
WHERE id = '93c1fab6-6862-4230-9f4a-4a5176ed0063'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pay off semua credit card utang", "difficulty": "intermediate", "explanation": "benar path: Pay off semua credit card utang. This represents the most financially sound decision at this stage.", "options": ["Invest in saham for high returns", "Pay off semua credit card utang", "Build dana darurat", "Buy a new car"], "parameters": {"full_tree": {"scenario": "You unexpectedly receive Rp 100M. You have Rp 30M in credit card debt at 2.5% monthly interest, no emergency fund, and no investments.", "stages": [{"correct": "Pay off all credit card debt", "next": {"correct": "Build 6-month emergency fund", "next": {"correct": "Diversified index fund portfolio", "options": ["All in one stock", "Diversified index fund portfolio", "Keep in savings", "Lend to a friend"], "question": "With emergency fund set, Rp 50M remains. Final decision?"}, "options": ["Invest everything in crypto", "Build 6-month emergency fund", "Start a business", "Luxury vacation"], "question": "After paying debt, you have Rp 70M left. Next step?"}, "options": ["Invest in stocks for high returns", "Pay off all credit card debt", "Build emergency fund", "Buy a new car"], "question": "First priority: What do you do with the first portion?"}]}}, "question": "Decision Tree Scenario:\n\nYou unexpectedly receive Rp 100M. You have Rp 30M in credit card utang at 2.5% per bulan bunga, no dana darurat, and no investments.\n\nFirst priority: What do you do with the first portion?", "type": "decision_tree"}'::jsonb
WHERE id = '4113c099-622a-4dd5-9c7a-799d0871b99b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "decreases", "difficulty": "intermediate", "explanation": "riil return = nominal return - inflasi. If inflasi rises and nominal return is flat, riil return falls.", "options": ["increases", "decreases", "stays the same", "becomes irrelevant"], "parameters": {}, "question": "If inflasi rises while bunga rates stay flat, the riil return on savings ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '8942930c-b315-46c0-974a-9cb4d0ebf733'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lower", "difficulty": "intermediate", "explanation": "diversifikasi reduces unsystematic (company-specific) risiko without sacrificing expected returns.", "options": ["higher", "lower", "equal", "unpredictable"], "parameters": {}, "question": "A diversified portofolio typically has ________ risiko than a concentrated portofolio with the same expected return.", "type": "sentence_completion"}'::jsonb
WHERE id = 'c2c3ed88-4472-4205-9c07-8ad1d105b38c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "fall", "difficulty": "intermediate", "explanation": "obligasi prices and bunga rates have an inverse relationship. Higher rates mean existing obligasi are less attractive.", "options": ["rise", "fall", "remain unchanged", "become more volatile"], "parameters": {}, "question": "When the central bank raises bunga rates, obligasi prices generally ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'adfafc81-abd6-4730-8582-ed18e760b7d2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "intermediate", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "You invest Rp 2M monthly (DCA) vs Rp 24M lump sum. Under what market conditions does each win?"}, "question": "You invest Rp 2M per bulan (DCA) vs Rp 24M lump sum. Under what market conditions does each win? What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = '57e8280a-4a2d-4fe7-885f-21c565134c00'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "intermediate", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "A stock has beta 1.5. The market goes up 10%. What is the expected stock return?"}, "question": "A saham has beta 1.5. The market goes up 10%. apa the expected saham return? Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = '4decb3a5-b998-4222-a109-0804a0f71bc0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "intermediate", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "Portfolio A: 8% return, 12% volatility. Portfolio B: 10% return, 20% volatility. Risk-free rate is 5%. Which has better Sharpe ratio?"}, "question": "portofolio A: 8% return, 12% volatilitas. portofolio B: 10% return, 20% volatilitas. risiko-free rate is 5%. Which has betterrasio Sharpe? apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = '4630573e-8e86-416f-995d-91bc15be04c7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tentukan tujuan keuangan dan jangka waktu", "Kenali toleransi risiko diri sendiri", "Pilih instrumen yang sesuai", "Review portofolio secara berkala"], "difficulty": "intermediate", "explanation": "Mulai dari tujuan, pahami risiko diri, pilih instrumen, lalu review portofolio secara rutin.", "options": ["Tentukan tujuan keuangan dan jangka waktu", "Kenali toleransi risiko diri sendiri", "Pilih instrumen yang sesuai", "Review portofolio secara berkala"], "parameters": {}, "question": "Urutkan prinsip memilih investasi sesuai profil risiko.", "type": "ordering"}'::jsonb
WHERE id = 'c202c54b-3a8d-41fc-a817-9c1291e30b91'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "3%", "difficulty": "intermediate", "explanation": "Return real = return nominal - inflasi = 8% - 5% = 3%.", "options": ["3%", "5%", "8%", "13%"], "parameters": {}, "question": "Jika inflasi 5% dan return investasi 8%, berapa return real kasarnya?", "type": "multiple_choice"}'::jsonb
WHERE id = '3f836bc5-d7ef-4240-9f04-4e3242f18889'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["waktu", "lama"], "difficulty": "intermediate", "explanation": "Waktu adalah mitra investor muda karena bunga majemuk bekerja lebih baik dalam jangka panjang.", "options": ["waktu", "lama"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Investor muda memiliki keunggulan _____ karena bisa membiarkan investasi bertumbuh lebih _____.\"", "type": "word_bank"}'::jsonb
WHERE id = 'fb78ce7d-4e8f-4a7c-8fe3-35502950b4f9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "diversifikasi", "difficulty": "intermediate", "explanation": "Diversifikasi membantu mengurangi risiko dengan tidak menaruh semua dana dalam satu instrumen.", "parameters": {}, "question": "Menyebarkan investasi ke berbagai jenis aset untuk mengurangi risiko disebut _____.", "type": "fill_blank"}'::jsonb
WHERE id = '4056d096-2923-42bb-a7e7-b024f88678e8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"EPS": "Earnings per share", "kapitalisasi pasar": "Total shares × price", "P/E Ratio": "Price per earnings share", "ROE": "return on equity"}, "difficulty": "intermediate", "explanation": "benar matches: rasio P/E → Price per earnings share, EPS → Earnings per share, ROE → return on equity, kapitalisasi pasar → Total shares × price", "options": {"left": ["P/E Ratio", "EPS", "ROE", "kapitalisasi pasar"], "right": ["Price per earnings share", "Earnings per share", "return on equity", "Total shares × price"]}, "parameters": {}, "question": "Match each financial metric with its meaning:", "type": "matching"}'::jsonb
WHERE id = '14d9f160-b938-41a7-9c97-afe26f81365a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "General price fall", "Hyperinflation": "Extreme rapid price rise", "inflasi": "General price rise", "Stagflation": "High inflasi + stagnation"}, "difficulty": "intermediate", "explanation": "benar matches: inflasi → General price rise, Deflation → General price fall, Stagflation → High inflasi + stagnation, Hyperinflation → Extreme rapid price rise", "options": {"left": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"], "right": ["General price rise", "General price fall", "High inflasi + stagnation", "Extreme rapid price rise"]}, "parameters": {}, "question": "Match each economic condition with its definition:", "type": "matching"}'::jsonb
WHERE id = '9c959f99-f899-4ba3-af12-e7f7070e00b4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"BI": "Central bank", "IDX": "saham exchange", "OJK": "Financial regulator", "SIPF": "Investor protection fund"}, "difficulty": "intermediate", "explanation": "benar matches: OJK → Financial regulator, BI → Central bank, IDX → saham exchange, SIPF → Investor protection fund", "options": {"left": ["OJK", "BI", "IDX", "SIPF"], "right": ["Financial regulator", "Central bank", "saham exchange", "Investor protection fund"]}, "parameters": {}, "question": "Match each Indonesian financial institution with its primary function:", "type": "matching"}'::jsonb
WHERE id = '6c8752fc-91aa-4000-bf28-06a96b0c89ce'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pengembalian tinggi biasanya berarti risiko tinggi", "difficulty": "intermediate", "explanation": "Investor umumnya menuntut potensi keuntungan lebih tinggi sebagai kompensasi atas risiko yang lebih besar.", "options": ["Risiko tinggi selalu menghasilkan keuntungan tinggi", "Pengembalian tinggi biasanya berarti risiko tinggi", "Risiko rendah selalu mengalahkan inflasi", "Risiko dan pengembalian tidak berhubungan"], "parameters": {}, "question": "Manakah pernyataan yang benar tentang hubungan risiko dan pengembalian?", "type": "multiple_choice"}'::jsonb
WHERE id = '28508b9d-a741-4421-9ec3-41fd5cedfda1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "imbal hasil", "difficulty": "intermediate", "explanation": "Bunga majemuk menghasilkan pertumbuhan yang dipercepat karena imbal hasil dihitung dari modal dan imbal hasil yang sudah diperoleh.", "parameters": {}, "question": "Bunga majemuk berarti kita mendapatkan imbal hasil dari modal awal dan dari _____ sebelumnya.", "type": "fill_blank"}'::jsonb
WHERE id = '81fbd35d-d86f-4a48-a401-0d826bd00984'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["diversifikasi", "jenis aset"], "difficulty": "intermediate", "explanation": "Diversifikasi menyebarkan investasi ke berbagai jenis aset untuk mengurangi dampak kerugian tunggal.", "options": ["diversifikasi", "jenis aset"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Untuk mengurangi risiko, seorang investor muda sebaiknya melakukan _____ dengan menyebarkan uang ke beberapa _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '277dcd33-a07a-4092-8027-1fca0daace03'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tentukan tujuan keuangan", "Pahami toleransi risiko", "Pilih berbagai jenis aset", "Pantau dan sesuaikan secara berkala"], "difficulty": "intermediate", "explanation": "Mulai dari tujuan, pahami risiko, diversifikasi, lalu pantau dan sesuaikan.", "options": ["Tentukan tujuan keuangan", "Pahami toleransi risiko", "Pilih berbagai jenis aset", "Pantau dan sesuaikan secara berkala"], "parameters": {}, "question": "Urutkan langkah menyusun portofolio yang sehat.", "type": "ordering"}'::jsonb
WHERE id = 'f433c456-836d-462b-8d20-10789fc09fe1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Short-term volatilitas is normal, long-term trend matters", "difficulty": "intermediate", "explanation": "The chart shows significant short-term drops but a long-term upward trend, illustrating why time in market beats timing the market.", "options": ["Markets selalu crash permanently", "Short-term volatilitas is normal, long-term trend matters", "Timing the market is easy", "Indonesian saham are too risky"], "parameters": {"image_description": "A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatility in 2022, steady climb in 2023-2024."}, "question": "[IMAGE: A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatilitas in 2022, steady climb in 2023-2024.]\n\napa yang this chart primarily demonstrate about long-term berinvestasi?", "type": "image_interpretation"}'::jsonb
WHERE id = '372708bc-2304-45b6-ba73-d5b5cd511707'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Moderate risiko tolerance", "difficulty": "intermediate", "explanation": "A 50/30/15/5 split between saham, obligasi, cash, and gold represents balanced risiko — neither too conservative nor too aggressive.", "options": ["Ultra-conservative", "Moderate risiko tolerance", "Aggressive growth seeker", "Speculative trader"], "parameters": {"image_description": "A pie chart showing asset allocation: 50% stocks, 30% bonds, 15% cash, 5% gold. Labels show this is a moderate risk portfolio."}, "question": "[IMAGE: A pie chart showing aset allocation: 50% saham, 30% obligasi, 15% cash, 5% gold. Labels show this is a moderate risiko portofolio.]\n\nWhat type of investor does this aset allocation most likely represent?", "type": "image_interpretation"}'::jsonb
WHERE id = '1b200afa-12d3-4f87-bbff-d2e2ba6b35bf'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Warung A hanya menjual mie ayam. Ketika harga ayam melonjak, penjualan anjlok. Warung B menjual mie ayam, es teh, nasi goreng, dan gorengan. Jika satu menu rugi, menu lain tetap mendatangkan uang. Warung B lebih terdiversifikasi."}'::jsonb
WHERE id = '532f9393-9028-4009-97bd-2c4d0c49362e'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Diversifikasi tidak berarti membeli banyak saham dari sektor yang sama. Membeli GOTO, DCII, dan emiten teknologi lain tetap berisiko tinggi jika sektor teknologi koreksi."}'::jsonb
WHERE id = '0c2ab69e-ce56-4c33-8b0d-355f7fec8a89'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Kartika memahami bahwa diversifikasi bukan berarti membeli 20 saham sekaligus. Ia memilih 5 saham dari sektor berbeda plus reksa dana pasar uang. Kualitas penyebaran lebih penting dari jumlah saham."}'::jsonb
WHERE id = '3afce518-9681-47cf-90e9-d0cb09027e76'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Seorang pedagang mie ayam menyisihkan Rp 2.000.000 per bulan. Ia tidak menyimpan semuanya di satu tempat, melainkan 50% di deposito BCA, 30% di reksa dana, dan 20% di saham blue chip. Jika satu instrumen turun, yang lain menahan."}'::jsonb
WHERE id = '9f6e2fcf-672b-4b77-a697-ef21d002828d'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Penjual mie ayam di Jakarta menyimpan modal usaha di tiga tempat: sebagian di tabungan BCA, sebagian di reksa dana pasar uang, dan sebagian kecil di saham blue chip. Kalau satu tempat bermasalah, usahanya tetap bisa jalan."}'::jsonb
WHERE id = '8672cb4a-c413-4c53-9d73-2209349fc2d2'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Dua investor punya Rp 20.000.000. Satu membeli GOTO, DCII, dan saham teknologi lain semuanya. Yang lain membeli GOTO, BBRI, TLKM, dan reksa dana obligasi. Investor kedua lebih terlindungi jika sektor teknologi koreksi."}'::jsonb
WHERE id = '8aafa57f-2f8d-4f50-a440-bf2343cb590e'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina memiliki uang Rp10.000.000. Jika semuanya disimpan dalam satu saham perusahaan kecil dan perusahaan itu bangkrut, uangnya hilang. Jika ia membeli reksa dana yang berisi banyak saham, kerugian satu saham tidak menghancurkan seluruh investasi."}'::jsonb
WHERE id = '4573ae74-7a47-4f9b-a91b-97f193fbb4ba'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a", "c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Sebuah keluarga muda di Bandung memiliki dana darurat di deposito, investasi jangka panjang di saham BBCA dan BBRI, serta tabungan pendidikan anak di reksa dana campuran. Setiap tujuan punya instrumen yang berbeda."}'::jsonb
WHERE id = 'e6a5d8a7-d36b-4194-ab3a-4efccd31a0a2'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Reksa dana indeks yang mengikuti IDX30 secara otomatis memberikan diversifikasi ke 30 saham besar. Ini cocok bagi pemula yang belum punya waktu riset satu per satu."}'::jsonb
WHERE id = 'bc066666-f10c-4937-8a5c-a176906aac55'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a", "c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Dewi menyisihkan Rp 5.000.000 per bulan: 40% ke reksa dana saham indeks IDX30, 30% ke obligasi pemerintah, 20% ke deposito, dan 10% ke emas digital. Ketika saham turun, bagian obligasi dan deposito membantu menahan nilai portofolio."}'::jsonb
WHERE id = 'e6be6e88-bbef-4404-bba3-ec6fbef28c38'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a", "c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Maya memiliki portofolio yang terdiri dari saham BBCA, BBRI, TLKM, dan reksa dana pasar uang. Ketika harga GOTO turun 20% karena berita sektor teknologi, portofolio Maya tetap stabil karena hanya sebagian kecil di sektor tersebut."}'::jsonb
WHERE id = '9f73e989-324c-4c85-9697-dac18fd87529'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Seorang pengemudi ojek online membeli saham BBCA, BBRI, TLKM, dan UNVR. Ia tidak membeli hanya satu saham meski temannya bilang \"pasti cuan\". Pilihannya menyebar antar sektor perbankan, telekomunikasi, dan konsumer."}'::jsonb
WHERE id = '0306eb40-1b91-4df0-80b4-3ca263ca3eb7'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Diversifikasi mengurangi risiko tanpa harus memprediksi aset mana yang terbaik. Itu sebabnya diversifikasi sering disebut ''makan siang gratis'' dalam investasi."}'::jsonb
WHERE id = 'd91dc4a5-02e7-4ec5-9e78-6873f2e98cc9'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Diversifikasi adalah menyebarkan uang ke berbagai aset agar kerugian satu aset tidak terlalu berdampak besar pada keseluruhan."}'::jsonb
WHERE id = '92508623-cac8-48fe-b94f-e161fb0a5dcc'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Jelaskan diversifikasi sebagai cara mengurangi risiko dengan contoh saham dan instrumen Indonesia.", "text": "Diversifikasi adalah strategi menyebarkan risiko, bukan mencari keuntungan maksimal. Dengan memilih berbagai jenis aset dan sektor, kamu mengurangi dampak jika satu investasi gagal. Ingat: jangan menyimpan semua telur dalam satu keranjang."}'::jsonb
WHERE id = 'b0d293ed-a2f6-44ee-8024-4c291b908efc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tentukan tujuan keuangan", "Pilih beberapa jenis aset", "Bagi dana sesuai proporsi", "Pantau dan sesuaikan setiap 6 bulan"], "difficulty": "intermediate", "explanation": "Mulai dari tujuan, pilih aset, alokasikan dana, lalu evaluasi secara berkala.", "options": ["Tentukan tujuan keuangan", "Pilih beberapa jenis aset", "Bagi dana sesuai proporsi", "Pantau dan sesuaikan setiap 6 bulan"], "parameters": {}, "question": "Urutkan langkah diversifikasi sederhana.", "type": "ordering"}'::jsonb
WHERE id = '0c482b93-bbef-4266-bd57-e12b6b3b46e4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "aset", "difficulty": "intermediate", "explanation": "Dengan menyebar ke banyak aset, kerugian satu aset tidak menghancurkan seluruh portofolio.", "parameters": {}, "question": "Diversifikasi membantu mengurangi dampak jika satu _____ investasi mengalami penurunan.", "type": "fill_blank"}'::jsonb
WHERE id = '393628c2-d324-402b-a4c8-05854510f174'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Kenali tujuan keuangan", "Pilih kombinasi saham, obligasi, dan reksa dana", "Bagi dana sesuai profil risiko", "Evaluasi ulang setiap 6 bulan"], "difficulty": "intermediate", "explanation": "Mulai dari tujuan, pilih instrumen, alokasikan sesuai profil risiko, lalu evaluasi berkala.", "options": ["Kenali tujuan keuangan", "Pilih kombinasi saham, obligasi, dan reksa dana", "Bagi dana sesuai profil risiko", "Evaluasi ulang setiap 6 bulan"], "parameters": {}, "question": "Urutkan langkah membangun portofolio yang terdiversifikasi.", "type": "ordering"}'::jsonb
WHERE id = '2ea83ce2-acbf-42bb-be56-601b8ec7880d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["telur", "keranjang"], "difficulty": "intermediate", "explanation": "Peribahasa ini menggambarkan pentingnya menyebar risiko dalam berinvestasi.", "options": ["telur", "keranjang"], "parameters": {}, "question": "Lengkapi: \"Jangan taruh semua _____ dalam satu _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '0fb15be0-28a8-456e-aee7-0e2036e3385c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Saham BBCA, obligasi pemerintah, dan reksa dana pasar uang", "difficulty": "intermediate", "explanation": "Diversifikasi baik menyebar dana ke berbagai jenis aset dan sektor, bukan hanya satu jenis.", "options": ["Semua uang di saham GOTO", "Saham BBCA, obligasi pemerintah, dan reksa dana pasar uang", "Membeli 15 saham sektor teknologi", "Menyimpan semua uang di dompet digital"], "parameters": {}, "question": "Manakah yang paling mendekati diversifikasi yang baik?", "type": "multiple_choice"}'::jsonb
WHERE id = '533508c3-bd87-4e5e-8b43-0c4bda64a797'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Diversifikasi melindungi Andi dari risiko saham tunggal.", "caseText": "Andi punya Rp5.000.000 dan ingin mulai investasi. Temannya menyarankan membeli saham satu perusahaan teknologi karena sedang viral. Andi ingin aman tetapi tetap berpotensi tumbuh.", "difficulty": "intermediate", "explanation": "Diversifikasi mengurangi risiko tanpa harus memilih satu pemenang. Reksa dana adalah cara sederhana untuk diversifikasi.", "followUp": {"answer": "Pilih reksa dana yang memiliki banyak saham agar terdiversifikasi", "explanation": "Reksa dana menyebarkan risiko ke banyak saham, sehingga kerugian satu saham tidak terlalu besar.", "options": ["Pilih reksa dana yang memiliki banyak saham agar terdiversifikasi", "Beli semua saham perusahaan viral", "Tunggu sampai punya Rp50 juta", "Pinjam uang untuk beli lebih banyak saham viral"], "question": "Apa saran terbaik untuk Andi?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = 'fda2044a-e6ac-423d-a03f-dcb703d5d8f8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["telur", "keranjang"], "difficulty": "intermediate", "explanation": "Peribahasa ini mengingatkan kita untuk tidak memusatkan risiko pada satu tempat.", "options": ["telur", "keranjang"], "parameters": {}, "question": "Lengkapi: \"Jangan menyimpan semua _____ dalam satu _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '0afe08f9-472e-4856-844f-b094376536fe'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "jenis aset", "difficulty": "intermediate", "explanation": "Diversifikasi menyebar dana ke berbagai jenis aset atau sektor untuk mengurangi risiko.", "parameters": {}, "question": "Diversifikasi artinya menyebarkan investasi ke berbagai _____ dan instrumen.", "type": "fill_blank"}'::jsonb
WHERE id = 'ff45cb29-ccca-46ae-808e-a687ec75acdc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Diversifikasi sejati membutuhkan penyebaran antar sektor dan jenis aset, bukan hanya banyak saham dalam satu sektor.", "parameters": {}, "question": "Membeli banyak saham dari sektor yang sama sudah cukup untuk diversifikasi.", "type": "true_false"}'::jsonb
WHERE id = '3dbbb15a-d612-463f-ac58-97c985f64241'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mengurangi risiko keseluruhan", "difficulty": "intermediate", "explanation": "Diversifikasi menyebarkan risiko agar kerugian satu aset tidak terlalu berdampak.", "options": ["Menjamin untung besar", "Mengurangi risiko keseluruhan", "Mengikuti tren saham", "Menghindari pajak"], "parameters": {}, "question": "Tujuan utama diversifikasi adalah ...", "type": "multiple_choice"}'::jsonb
WHERE id = '2991cc26-7ee0-419a-adc3-6081b1e43d2d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Jika sektor tersebut turun, semua saham ikut terdampak", "difficulty": "intermediate", "explanation": "Saham dalam sektor yang sama cenderung bergerak searah, sehingga diversifikasi sektor penting.", "options": ["Biaya administrasi lebih murah", "Jika sektor tersebut turun, semua saham ikut terdampak", "Pajak selalu lebih rendah", "Dividen dijamin lebih besar"], "parameters": {}, "question": "Apa risiko membeli banyak saham dari sektor yang sama?", "type": "multiple_choice"}'::jsonb
WHERE id = 'a0bc6f99-aea4-4e50-97b5-283ad3d70bca'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Diversifikasi mengurangi risiko, bukan menjamin keuntungan. Portofolio tetap bisa turun.", "parameters": {}, "question": "Diversifikasi menjamin portofolio selalu untung setiap bulan.", "type": "true_false"}'::jsonb
WHERE id = '07d7a1ad-953c-48a1-afa5-f1bdcb4886a9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "menebak", "difficulty": "intermediate", "explanation": "Dengan diversifikasi, kita tidak perlu memprediksi pemenang; kita memiliki banyak aset.", "question": "Diversifikasi sering disebut ''makan siang gratis'' karena mengurangi risiko tanpa harus _____ aset mana yang terbaik.", "type": "fill_blank"}'::jsonb
WHERE id = 'b3899c41-a194-4219-bbe3-65731e03f561'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Diversifikasi mengurangi risiko, tetapi tidak menjamin keuntungan.", "question": "Diversifikasi menjamin investasi selalu menghasilkan keuntungan.", "type": "true_false"}'::jsonb
WHERE id = '78cd98cc-c86c-47ec-904b-c6183b85bbdb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mengurangi dampak kerugian satu aset", "difficulty": "intermediate", "explanation": "Diversifikasi menyebarkan risiko, tetapi tidak menghilangkan risiko atau menjamin keuntungan.", "options": ["Mengurangi dampak kerugian satu aset", "Menjamin keuntungan setiap tahun", "Menghilangkan risiko sepenuhnya", "Membuat investasi lebih rumit"], "question": "Manakah manfaat diversifikasi?", "type": "multiple_choice"}'::jsonb
WHERE id = '838c46b9-b443-42bf-95af-66ee4f1e44a6'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Ani ingin berinvestasi di saham tetapi tidak tahu cara memilih perusahaan. Ia membeli reksa dana saham yang dikelola manajer investasi berizin OJK. Uangnya digabung dengan uang banyak investor lain untuk membeli banyak saham sekaligus."}'::jsonb
WHERE id = '31fa35b0-4e3b-4d48-bc67-8f0d934366e9'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Reksa dana pasar uang berisiko rendah dan cocok untuk jangka pendek. Reksa dana pendapatan tetap menengah. Reksa dana saham berpotensi imbal hasil tinggi tetapi berfluktuasi besar."}'::jsonb
WHERE id = '82cd30d9-f6ac-481e-bc3c-390650297252'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jenis utama: pasar uang (rendah risiko), pendapatan tetap (menengah), saham (tinggi risiko/imbal hasil). Pilihlah sesuai tujuan dan waktu."}'::jsonb
WHERE id = '3db49742-a2ed-4aab-838e-7ce80d8142b3'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Reksa dana adalah wadah untuk mengumpulkan uang dari banyak investor, lalu dikelola manajer investasi untuk dibeli berbagai aset sesuai jenis reksa dana."}'::jsonb
WHERE id = '56498ba7-4c3d-4836-ad4a-11c36ff55f47'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "manajer", "difficulty": "intermediate", "explanation": "Manajer investasi mengelola dana investor sesuai prospektus reksa dana.", "question": "Reksa dana dikelola oleh _____ investasi yang berizin OJK.", "type": "fill_blank"}'::jsonb
WHERE id = '0013e43a-48bf-499e-97b2-ff1b85bda7fe'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena uangnya dikelola profesional dan terdiversifikasi", "difficulty": "intermediate", "explanation": "Reksa dana memungkinkan pemula memiliki banyak aset sekaligus dengan pengelolaan profesional.", "options": ["Karena uangnya dikelola profesional dan terdiversifikasi", "Karena dijamin untung oleh pemerintah", "Karena tidak ada risiko", "Karena hanya butuh Rp10.000"], "question": "Mengapa reksa dana cocok untuk pemula seperti Ani?", "type": "multiple_choice"}'::jsonb
WHERE id = '61868608-687b-4fa6-961f-bac9de08bad0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Reksa dana pasar uang": "Rendah risiko, cocok jangka pendek", "Reksa dana pendapatan tetap": "Risiko menengah, berisi obligasi", "Reksa dana saham": "Risiko tinggi, potensi imbal hasil tinggi"}, "difficulty": "intermediate", "explanation": "Setiap jenis reksa dana memiliki profil risiko dan imbal hasil yang berbeda.", "pairs": [["Reksa dana pasar uang", "Rendah risiko, cocok jangka pendek"], ["Reksa dana pendapatan tetap", "Risiko menengah, berisi obligasi"], ["Reksa dana saham", "Risiko tinggi, potensi imbal hasil tinggi"]], "question": "Pasangkan jenis reksa dana dengan karakteristiknya.", "type": "matching"}'::jsonb
WHERE id = 'bddcc2d8-e274-4031-a285-e4ae85f3cea2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Reksa dana pasar uang, pendapatan tetap, dan saham memiliki profil risiko berbeda.", "question": "Semua jenis reksa dana memiliki risiko yang sama.", "type": "true_false"}'::jsonb
WHERE id = 'a58c565c-08d3-40cd-afde-fd297e6f8623'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Membeli 1 lot saham BBCA artinya membeli 100 lembar saham Bank Central Asia. Dengan membeli saham, kita menjadi pemilik sebagian kecil bank tersebut. Jika bank untung, nilai saham bisa naik; jika rugi, bisa turun."}'::jsonb
WHERE id = '8c2fd7c4-35a6-4902-b0ac-f40336330a33'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Harga saham GOTO berubah setiap hari karena banyak orang membeli dan menjual. Jika lebih banyak yang ingin membeli, harga naik. Jika lebih banyak yang ingin menjual, harga turun."}'::jsonb
WHERE id = '18c5bb40-f173-4049-ab99-eb977492ffc3'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Membeli saham berbeda dengan meminjamkan uang. Saham = kepemilikan. Obligasi = pinjaman."}'::jsonb
WHERE id = '6806e5a2-1113-40b2-a9ad-902b5c3fa470'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Saham adalah bukti kepemilikan sebagian dari perusahaan. Harga saham berubah karena permintaan dan penawaran di pasar."}'::jsonb
WHERE id = 'ca2c3c53-14f6-44c0-9c1f-930ebfe2f05c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Menjadi pemilik sebagian kecil perusahaan", "difficulty": "intermediate", "explanation": "Saham adalah bukti kepemilikan sebagian dari perusahaan.", "options": ["Menjadi pemilik sebagian kecil perusahaan", "Meminjamkan uang kepada perusahaan", "Menjadi karyawan perusahaan", "Mendapat gaji tetap dari perusahaan"], "question": "Apa artinya membeli saham perusahaan?", "type": "multiple_choice"}'::jsonb
WHERE id = '9547388d-b2da-4644-bd7c-7999be4b3d9f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "100", "difficulty": "intermediate", "explanation": "Di IDX, 1 lot sama dengan 100 lembar saham.", "question": "Jika membeli 1 lot saham BBCA, kita memiliki _____ lembar saham.", "type": "fill_blank"}'::jsonb
WHERE id = '9e49b14e-f6ff-47d8-9d81-c546e30d414c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "intermediate", "explanation": "Harga ditentukan oleh permintaan dan penawaran. Permintaan tinggi mendorong harga naik.", "question": "Harga saham naik jika lebih banyak orang yang ingin membeli daripada menjual.", "type": "true_false"}'::jsonb
WHERE id = 'b42a3a2d-4077-4aa1-941d-2717f94a89be'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Saham adalah kepemilikan, obligasi adalah pinjaman", "difficulty": "intermediate", "explanation": "Pemegang saham memiliki perusahaan; pemegang obligasi meminjamkan uang kepada perusahaan.", "options": ["Saham adalah kepemilikan, obligasi adalah pinjaman", "Saham lebih aman dari obligasi", "Obligasi adalah kepemilikan", "Keduanya sama"], "question": "Saham berbeda dengan obligasi karena ...", "type": "multiple_choice"}'::jsonb
WHERE id = '35820ca4-a032-4cb3-95db-18cb3b11ff3b'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760", "58e3fb2d-7dbc-4a08-ab1a-379af3fa5c38"], "text": "PT Bank Central Asia Tbk memiliki kode saham BBCA di Bursa Efek Indonesia. Jika seseorang membeli 1 lot BBCA, ia memiliki 100 lembar saham dan menjadi salah satu pemilik kecil perusahaan tersebut."}'::jsonb
WHERE id = 'd8114721-d8e2-451f-b492-4b18e7bf6ae9'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["52aff5b9-0d1c-42d8-8dba-a1a97a3f3b3f"], "text": "Seorang investor membeli saham BBRI di harga Rp 4.000 per lembar. Setahun kemudian harganya Rp 4.800. Keuntungan modalnya 20%, belum termasuk dividen yang mungkin dibagikan perusahaan."}'::jsonb
WHERE id = '3d09d13a-f45b-4e43-bd66-1f6fb3b2fda8'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Di IDX, transaksi saham terjadi pada jam bursa 09.00–15.00 WIB. Harga saham berubah setiap detik sesuai permintaan dan penawaran dari investor."}'::jsonb
WHERE id = 'c9a41524-020c-4bcd-bc3e-6e8522639983'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["52aff5b9-0d1c-42d8-8dba-a1a97a3f3b3f", "47189cc8-8e51-4890-ace4-3f30b913f5ee"], "text": "Untuk berinvestasi saham sungguhan di Indonesia, seseorang perlu membuka rekening saham di perusahaan sekuritas yang terdaftar di OJK, seperti Ajaib, Stockbit, IPOT, atau sekuritas konvensional."}'::jsonb
WHERE id = 'd06231e3-c1cf-4ba7-9066-939cb02bef53'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["52aff5b9-0d1c-42d8-8dba-a1a97a3f3b3f"], "text": "Koin menggunakan paper trading dengan harga penutupan harian. Saat sungguhan, harga saham bisa berbeda sedikit karena spread dan biaya broker. Paper trading mengajarkan konsep tanpa biaya transaksi nyata."}'::jsonb
WHERE id = 'a0beb091-dc10-4345-a937-35390f897e1c'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Indeks Harga Saham Gabungan (IHSG) mencerminkan pergerakan harga saham-saham besar di Indonesia. Jika IHSG naik, artinya mayoritas saham besar naik, meski tidak semua saham ikut naik."}'::jsonb
WHERE id = '0ab1d22c-2d9f-44b3-afca-c3b0afa81acd'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni ingin membeli 75 lembar saham TLKM. Di Bursa Efek Indonesia, saham diperdagangkan dalam lot yang terdiri dari 100 lembar. Doni harus membeli minimal 1 lot atau 100 lembar."}'::jsonb
WHERE id = '1cdfd723-cfba-47ba-84d3-eace3c5c1d05'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "SIPF (Securities Investor Protection Fund) melindungi investor jika perusahaan sekuritas bangkrut. Dana investor yang disimpan di rekening saham terpisah dari aset perusahaan sekuritas."}'::jsonb
WHERE id = '1276d418-6775-4bb4-a925-8a44c740cf40'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "SIPF (Securities Investor Protection Fund) memberikan perlindungan kepada investor yang menyimpan efek di IDX. Jika perusahaan sekuritas mengalami masalah, investor terlindungi sesuai ketentuan yang berlaku, sepanjang efeknya tercatat."}'::jsonb
WHERE id = '239bcc43-06ab-4657-98fc-2f331fe0d6df'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760", "58e3fb2d-7dbc-4a08-ab1a-379af3fa5c38", "47189cc8-8e51-4890-ace4-3f30b913f5ee"], "text": "Bayu ingin membeli saham PT Telkom Indonesia Tbk (TLKM) di Bursa Efek Indonesia. Ia membuka rekening efek di sekuritas terdaftar OJK, menyetor dana Rp 1.000.000, dan membeli 2 lot TLKM (200 lembar). Harga saham TLKM bisa naik atau turun setiap hari sesuai permintaan dan penawaran di pasar."}'::jsonb
WHERE id = '69c34671-7af9-456b-a994-3ce167a43158'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Perdagangan saham di IDX berlangsung hari kerja, Senin-Jumat. Jika Doni ingin membeli saham, ia harus memiliki rekening efek di perusahaan sekuritas yang terdaftar."}'::jsonb
WHERE id = '4571c39b-920e-4816-ad58-478c795b5d35'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760", "58e3fb2d-7dbc-4a08-ab1a-379af3fa5c38"], "text": "PT Bank Central Asia Tbk (BBCA) tercatat di Bursa Efek Indonesia (IDX). Jika Rina membeli 1 lot saham BBCA, ia memiliki 100 lembar saham dan menjadi bagian kecil pemilik perusahaan. Ia bisa memantau harga saham harian melalui situs IDX atau aplikasi resmi."}'::jsonb
WHERE id = '9a7650a5-2a90-4551-ab2c-d8c3cd81bb64'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["58e3fb2d-7dbc-4a08-ab1a-379af3fa5c38"], "text": "Saham GOTO dan saham BBCA memiliki karakter berbeda. GOTO adalah perusahaan teknologi yang masih berkembang dengan volatilitas tinggi. BBCA adalah bank besar dengan sejarah laba yang lebih stabil."}'::jsonb
WHERE id = '94faa86c-1169-4fe7-8a40-00037b7e1098'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760", "5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Perusahaan yang terdaftar di IDX wajib mengungkapkan laporan keuangan secara berkala. Investor dapat membaca laporan keuangan tersebut untuk menilai kesehatan perusahaan sebelum membeli sahamnya."}'::jsonb
WHERE id = '4533c533-b7f3-446f-8fa5-cc600f992ff9'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["58e3fb2d-7dbc-4a08-ab1a-379af3fa5c38"], "text": "ETF adalah kumpulan saham yang diperdagangkan seperti satu saham. Misalnya ETF IDX30 memungkinkan investor membeli 30 saham besar sekaligus dalam satu transaksi, sehingga langsung diversifikasi."}'::jsonb
WHERE id = '74ef7fbc-1abc-4cb4-b03d-d7d515ca1e5f'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Perkenalkan IDX, lot saham, dan perlindungan investor menggunakan sumber IDX dan OJK. Dorong pengguna untuk melakukan riset sebelum bertransaksi.", "text": "Bursa Efek Indonesia (IDX) adalah pasar saham nasional Indonesia. Perusahaan yang terdaftar dapat menjual saham kepada publik, sehingga investor menjadi pemilik sebagian kecil perusahaan. Di IDX, 1 lot sama dengan 100 lembar saham. Harga saham bergerak sesuai permintaan dan penawaran. SIPF memberikan perlindungan kepada investor dalam efek tercatat."}'::jsonb
WHERE id = '6601f54d-f37c-4407-b420-bde5e5b0128c'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "SIPF (Securities Investor Protection Fund) memberikan perlindungan bagi investor di pasar modal sesuai ketentuan. Ini adalah salah satu mekanisme perlindungan investor."}'::jsonb
WHERE id = '6ec64db1-40ae-4ee8-a238-ba5d3880bcf6'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "IDX adalah Bursa Efek Indonesia. Di IDX, 1 lot = 100 lembar saham. Perdagangan hari kerja dengan jam tertentu."}'::jsonb
WHERE id = '16ecd02c-a7df-4c04-bb0a-3b020331325a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["saham", "obligasi"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: saham, obligasi.", "options": ["saham", "obligasi", "mutual funds", "deposits"], "parameters": {}, "question": "A balanced portofolio might include ________, ________, and other aset classes.", "type": "word_bank"}'::jsonb
WHERE id = '8318c54b-93e5-4da4-bc94-dca8213b7509'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["risiko", "return"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: risiko, return.", "options": ["risiko", "return", "diversifikasi", "likuiditas"], "parameters": {}, "question": "Investors must understand the trade-off between ________ and expected ________.", "type": "word_bank"}'::jsonb
WHERE id = '64c9475d-91d4-44e9-98af-704bdd0e6893'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "A market condition where prices are falling or expected to fall", "pasar bullish": "A market condition where prices are rising or expected to rise", "koreksi": "A decline of 10% or more from a recent peak", "crash": "A sudden dramatic decline of 20% or more in saham prices"}, "difficulty": "advanced", "explanation": "benar matches: pasar bullish = A market condition where prices are rising or expected to rise, pasar bearish = A market condition where prices are falling or expected to fall, koreksi = A decline of 10% or more from a recent peak, crash = A sudden dramatic decline of 20% or more in saham prices", "options": {"definitions": ["A market condition where prices are rising or expected to rise", "A market condition where prices are falling or expected to fall", "A decline of 10% or more from a recent peak", "A sudden dramatic decline of 20% or more in saham prices"], "terms": ["pasar bullish", "pasar bearish", "koreksi", "crash"]}, "parameters": {}, "question": "Match each market term with its description:", "type": "definition_match"}'::jsonb
WHERE id = 'a73b4c7b-bbfb-416a-9242-14c4e3ea2489'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "IDX", "difficulty": "advanced", "explanation": "Bursa Efek Indonesia (IDX) is the national saham exchange of Indonesia.", "parameters": {}, "question": "________ is the Indonesian saham exchange where companies list their shares.", "type": "fill_blank"}'::jsonb
WHERE id = '4bcfddf9-3db5-478b-8bb3-9d2c8291cc61'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "advanced", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "ESG scoring is introduced for IDX constituents. How might this affect capital allocation and valuations?"}, "question": "ESG scoring is introduced for IDX constituents. How might this affect capital allocation and valuations? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = '7e6cffe0-dffe-426e-ae8e-fde6106b8f7d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["bullish", "bearish"], "difficulty": "advanced", "explanation": "kata yang benar dari bank kata adalah: bullish, bearish.", "options": ["bullish", "bearish", "sideways", "volatile"], "parameters": {}, "question": "When investors are ________, they expect prices to rise; when ________, they expect declines.", "type": "word_bank"}'::jsonb
WHERE id = 'f43acbd0-a8e0-40a8-9dcf-ddcc251a193e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8%", "difficulty": "advanced", "explanation": "Weighted return = (0.60 × 10%) + (0.40 × 5%) = 6% + 2% = 8%.", "parameters": {"hint": "Multiply each allocation by its return and sum the results."}, "question": "You have Rp 50M to invest. You allocate 60% to saham (expected 10% return) and 40% to obligasi (expected 5% return). apa the expected portofolio return?", "type": "calculation"}'::jsonb
WHERE id = '8f5c8bd0-7979-4802-bf45-cb34227aa767'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "-2%", "difficulty": "advanced", "explanation": "riil return ≈ nominal return - inflasi rate = 3% - 5% = -2%. Your daya beli is declining.", "parameters": {"hint": "Subtract inflation from the nominal interest rate."}, "question": "Your savings account pays 3% bunga per tahun. inflasi is 5%. apa your approximate riil return?", "type": "calculation"}'::jsonb
WHERE id = 'f648b848-fff9-446b-a550-7316471daf97'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "9", "difficulty": "advanced", "explanation": "Rule of 72: Years to double = 72 / interest rate. 72 / 8 = 9 years.", "parameters": {"hint": "Divide 72 by the annual return percentage."}, "question": "Using the Rule of 72, how many years does it take to double money at 8% annual return?", "type": "calculation"}'::jsonb
WHERE id = '49ab93a3-4316-4ef2-bce1-2ce4e532f54c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "advanced", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "Model the impact of a 0.1% securities transaction tax on high-frequency trading volumes in IDX."}, "question": "Model the impact of a 0.1% securities transaction pajak on high-frequency trading volumes in IDX. apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '45c2a4b2-fa83-4ed5-8c79-6aec393757f5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Research the company → Analyze financial statements → Check valuation metrics → Consider market conditions → Decide position size", "options": ["Research the company", "Analyze financial statements", "Check valuation metrics", "Consider market conditions", "Decide position size"], "parameters": {}, "question": "urutkan langkah-langkah for fundamental saham analysis:", "type": "ordering"}'::jsonb
WHERE id = '6c275081-84ea-4f8d-b21c-d05fbe5ceda6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "saham have historically outpaced inflasi", "difficulty": "advanced", "explanation": "The chart shows that while savings lose daya beli to inflasi, equities have historically provided returns that exceed inflasi.", "options": ["Savings accounts beat inflasi", "saham have historically outpaced inflasi", "semua investments are equal", "Cash yang terbaik store of value"], "parameters": {"image_description": "A bar chart comparing inflation rate (3%) vs savings account interest (2%) vs stock market average return (10%) over 10 years."}, "question": "[IMAGE: A bar chart comparing inflasi rate (3%) vs savings account bunga (2%) vs saham market average return (10%) over 10 years.]\n\nWhat key insight does this comparison reveal?", "type": "image_interpretation"}'::jsonb
WHERE id = 'a3452d69-5ec6-4355-8d22-eea350182f5c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The saham is in a consolidation phase", "difficulty": "advanced", "explanation": "Sideways movement without clear trend typically indicates consolidation, where buyers and sellers are in equilibrium.", "options": ["The saham is definitely going up", "The saham is in a consolidation phase", "Sell immediately", "keuntungan terjamin opportunity"], "parameters": {"image_description": "A candlestick chart of a single stock over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend."}, "question": "[IMAGE: A candlestick chart of a single saham over 30 days. Prices swing between Rp 8,000 and Rp 9,500 with no clear trend.]\n\nWhat conclusion can be drawn from this price action?", "type": "image_interpretation"}'::jsonb
WHERE id = '66e339f8-2eee-4b02-8eca-daae5794b953'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Identify kebutuhan → Identify keinginan → Allocate 50% to kebutuhan → Allocate 30% to keinginan → Save 20%", "options": ["Identify kebutuhan", "Identify keinginan", "Allocate 50% to needs", "Allocate 30% to wants", "Save 20%"], "parameters": {}, "question": "urutkan langkah-langkah to apply the 50/30/20 anggaran rule:", "type": "ordering"}'::jsonb
WHERE id = '412ea6d8-ce03-4e92-945d-de331c0b5e98'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK license status", "difficulty": "advanced", "explanation": "benar path: OJK license status. This represents the most financially sound decision at this stage.", "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "parameters": {"full_tree": {"scenario": "A ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% monthly returns''.", "stages": [{"correct": "OJK license status", "next": {"correct": "Report to OJK and block", "next": {"correct": "Warn friends and family", "options": ["Ignore and move on", "Warn friends and family", "Post about it on social media", "Confront the scammer"], "question": "To protect others, best action?"}, "options": ["Invest a small amount to test", "Report to OJK and block", "Ask for a discount on entry fee", "Invite friends to join"], "question": "They have no OJK license but show ''proof'' of payments to others. What now?"}, "options": ["Past performance charts", "OJK license status", "Number of members in their group", "Their profile picture"], "question": "First red flag to check?"}]}}, "question": "Decision Tree Scenario:\n\nA ''financial advisor'' contacts you on WhatsApp offering exclusive access to a fund with ''guaranteed 25% per bulan returns''.\n\nFirst red flag to check?", "type": "decision_tree"}'::jsonb
WHERE id = '81fbad72-c5ed-43a4-acfc-9c9bcc577a86'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"pasar bearish": "Falling prices", "pasar bullish": "Rising prices", "koreksi": "10%+ decline from peak", "Sideways": "Flat movement"}, "difficulty": "advanced", "explanation": "benar matches: pasar bullish → Rising prices, pasar bearish → Falling prices, Sideways → Flat movement, koreksi → 10%+ decline from peak", "options": {"left": ["pasar bullish", "pasar bearish", "Sideways", "koreksi"], "right": ["Rising prices", "Falling prices", "Flat movement", "10%+ decline from peak"]}, "parameters": {}, "question": "Match each market condition with its description:", "type": "matching"}'::jsonb
WHERE id = '3a0e5d35-adc8-4c66-8059-f3c92ab61295'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Check if fundamentals changed", "difficulty": "advanced", "explanation": "benar path: Check if fundamentals changed. This represents the most financially sound decision at this stage.", "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "parameters": {"full_tree": {"scenario": "The stock market drops 20% in one month. You have Rp 200M invested across 10 stocks.", "stages": [{"correct": "Check if fundamentals changed", "next": {"correct": "Hold and consider buying more", "next": {"correct": "Dollar cost average over 3 months", "options": ["All remaining cash at once", "Dollar cost average over 3 months", "Wait for ''the bottom''", "Borrow to invest"], "question": "You decide to buy more. Best approach?"}, "options": ["Panic sell to preserve capital", "Hold and consider buying more", "Switch to gold entirely", "Blame the government"], "question": "Fundamentals are intact. What action makes sense?"}, "options": ["Sell everything immediately", "Check if fundamentals changed", "Check social media sentiment", "Buy more on margin"], "question": "First reaction: What do you check?"}]}}, "question": "Decision Tree Scenario:\n\nThe saham market drops 20% in one month. You have Rp 200M invested across 10 saham.\n\nFirst reaction: What do you check?", "type": "decision_tree"}'::jsonb
WHERE id = '712c0533-ae0a-4bf3-b300-88d5b82431a8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "The power of bunga majemuk", "difficulty": "advanced", "explanation": "The dramatic difference between simple accumulation and compound growth demonstrates why starting early and staying invested matters.", "options": ["menentukan waktu pasar", "The power of bunga majemuk", "Day trading profits", "Currency hedging"], "parameters": {"image_description": "An infographic showing compound growth: Rp 1M invested monthly at 7% annual return grows to Rp 1.2B over 30 years vs only Rp 360M without interest."}, "question": "[IMAGE: An infographic showing compound growth: Rp 1M invested per bulan at 7% annual return grows to Rp 1.2B over 30 years vs hanya Rp 360M without bunga.]\n\nWhat principle is this infographic illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = 'a593314d-7580-4199-899f-99f0f6ec7820'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Confirmation Bias": "Seeking confirming info", "FOMO": "Fear of missing out", "aversi rugi": "Fear of losses > joy of gains", "Overconfidence": "Excessive self-assurance"}, "difficulty": "advanced", "explanation": "Correct matches: Loss Aversion → Fear of losses > joy of gains, FOMO → Fear of missing out, Confirmation Bias → Seeking confirming info, Overconfidence → Excessive self-assurance", "options": {"left": ["aversi rugi", "FOMO", "Confirmation Bias", "Overconfidence"], "right": ["Fear of losses > joy of gains", "Fear of missing out", "Seeking confirming info", "Excessive self-assurance"]}, "parameters": {}, "question": "Match each bias perilaku with its definition:", "type": "matching"}'::jsonb
WHERE id = 'fcf9cb8f-3187-4b1c-b018-15f2d5017a17'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "High-yield savings account", "difficulty": "advanced", "explanation": "Emergency funds need likuiditas and capital preservation, which savings accounts provide better than volatile saham.", "options": ["High-yield savings account", "saham portofolio", "Both equally appropriate", "Cryptocurrency wallet"], "parameters": {}, "question": "For emergency funds: is a high-yield savings account or a saham portofolio more appropriate?", "type": "comparison"}'::jsonb
WHERE id = 'acfde6d9-c8c0-4653-bbe3-d0516305f5f9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Mixed aset classes", "difficulty": "advanced", "explanation": "diversifikasi across aset classes, sectors, and geographies reduces concentration risiko.", "options": ["100% banking stocks", "Mixed aset classes", "Both are equally diversified", "diversifikasi does not matter"], "parameters": {}, "question": "Which portofolio is likely more diversified: 100% Indonesian banking saham or a mix of Indonesian saham, obligasi, and global ETFs?", "type": "comparison"}'::jsonb
WHERE id = '31a036fa-5114-4e20-8b60-b50093ab4382'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "fall", "difficulty": "advanced", "explanation": "obligasi prices and bunga rates have an inverse relationship. Higher rates mean existing obligasi are less attractive.", "options": ["rise", "fall", "remain unchanged", "become more volatile"], "parameters": {}, "question": "When the central bank raises bunga rates, obligasi prices generally ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '31f75151-af0a-41a7-80de-8f1b9c34bc1f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy"], "difficulty": "advanced", "explanation": "Emotional trading, no strategy, and social media tips are unreliable sources of investasi decisions.", "options": ["Over-monitoring portofolio", "Panic selling on small dips", "Social media driven berinvestasi", "No long-term strategy", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI check my saham portofolio every hour and sell whenever it drops more than 2%. I juga buy whatever saham is trending on social media.", "type": "spot_mistake"}'::jsonb
WHERE id = '0774c16c-dfbe-429b-9cb1-90541481fa28'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emotion-driven", "difficulty": "advanced", "explanation": "Frequent monitoring and trading sering lead to emotional decision-making daripada disciplined strategy.", "options": ["patient long-term", "emotion-driven", "perfectly rational", "index-fund style"], "parameters": {}, "question": "An investor who checks their portofolio per hari and trades frequently is more likely to exhibit ________ behavior.", "type": "sentence_completion"}'::jsonb
WHERE id = 'e3259501-704c-4182-b789-c09fba2dfaeb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "memulai lebih awal dan konsisten", "difficulty": "advanced", "explanation": "waktu di pasar and kontribusi konsisten jauh lebih penting daripada memilih saham or menentukan waktu pasar.", "options": ["memilih saham terbaik", "memulai lebih awal dan konsisten", "menentukan waktu pasar dengan sempurna", "memiliki informasi orang dalam"], "parameters": {}, "question": "faktor paling penting in membangun kekayaan melalui investasi is ________.", "type": "sentence_completion"}'::jsonb
WHERE id = '34cd43e9-f1d0-4189-bdca-bcb4f7e8aca9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "advanced", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "Compare corporate governance quality between state-owned banks (BBRI, BMRI) and private banks (BBCA)."}, "question": "Compare corporate governance quality between state-owned banks (BBRI, BMRI) and private banks (BBCA). What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = '9a026328-3aa3-4dbf-b548-b321772db83e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "advanced", "explanation": "The 50/30/20 rule allocates 50% to kebutuhan, 30% to keinginan, and 20% to savings and utang.", "parameters": {}, "question": "The 50/30/20 rule suggests allocating ________ percent of pendapatan to savings and utang repayment.", "type": "fill_blank"}'::jsonb
WHERE id = '4d3b89f3-7964-4b18-8563-0db11fdc9083'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "dollar cost averaging", "difficulty": "advanced", "explanation": "DCA spreads purchases dari waktu ke waktu, reducing the impact of berinvestasi at a market peak.", "options": ["lump sum berinvestasi", "dollar cost averaging", "Both eliminate timing risiko", "Neither helps"], "parameters": {}, "question": "Compare lump sum berinvestasi vs dollar cost averaging (DCA) in a volatile market. Which typically reduces timing risiko?", "type": "comparison"}'::jsonb
WHERE id = '9f474961-e63e-417b-b756-dd9f28f896b8'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money"], "difficulty": "advanced", "explanation": "This exhibits classic Ponzi scheme warning signs: guaranteed high returns, secrecy, and pressure to act fast.", "options": ["Unrealistic return promise", "Secrecy requirement is red flag", "No verification of legitimacy", "Invested semua money", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI put semua my money in a ''guaranteed 20% per bulan return'' scheme. The person running it says it''s secret and I shouldn''t tell anyone. I signed up immediately.", "type": "spot_mistake"}'::jsonb
WHERE id = '67916a2e-1490-4fc0-b89d-1d9307a00b1b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "You need to be rich to start berinvestasi.", "type": "true_false"}'::jsonb
WHERE id = '057d03eb-8f84-4c35-bd3a-740d8bbe156e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK", "difficulty": "advanced", "explanation": "Otoritas Jasa Keuangan (OJK) is Indonesia''s financial services authority.", "parameters": {}, "question": "The organization that regulates financial services di Indonesia is abbreviated as ________.", "type": "fill_blank"}'::jsonb
WHERE id = '9b3e83f0-c9e5-4856-a0e7-abdec1924987'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest"], "difficulty": "advanced", "explanation": "Credit card utang at 2.5% per bulan compounds to devastating levels. Minimum payments prolong utang for years.", "options": ["Carrying high credit card balance", "hanya paying minimum", "Using credit for routine purchases without plan", "Accumulating 2.5% monthly interest", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI use my credit card for semua purchases karena I get cashback. I hanya pay the minimum balance each month. I have Rp 50M in credit card utang.", "type": "spot_mistake"}'::jsonb
WHERE id = 'a2891cff-0811-43df-99ee-9e17eb6e1df0'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "difficulty": "advanced", "explanation": "urutan yang benar adalah: Feel market panic → Stop and breathe → Review your investasi plan → Check fundamentals → Decide based on strategy not emotion", "options": ["Feel market panic", "Stop and breathe", "Review your investasi plan", "Check fundamentals", "Decide based on strategy not emotion"], "parameters": {}, "question": "urutkan langkah-langkah to handle market volatilitas emotionally:", "type": "ordering"}'::jsonb
WHERE id = 'b34b9739-773d-470d-aa67-54dfcb39fb5d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bias perilaku": ["FOMO buying", "Holding losers too long", "aversi rugi", "Confirmation bias"], "Market Condition": ["pasar bullish", "pasar bearish"], "Rational Strategy": ["rebalancing per tahun", "DCA berinvestasi"]}, "difficulty": "advanced", "explanation": "benar categorization: {\"bias perilaku\": [\"FOMO buying\", \"Holding losers too long\", \"aversi rugi\", \"Confirmation bias\"], \"Rational Strategy\": [\"rebalancing per tahun\", \"DCA berinvestasi\"], \"Market Condition\": [\"pasar bullish\", \"pasar bearish\"]}", "options": {"buckets": ["bias perilaku", "Rational Strategy", "Market Condition"], "items": ["FOMO buying", "rebalancing per tahun", "pasar bullish", "Holding losers too long", "DCA berinvestasi", "aversi rugi", "pasar bearish", "Confirmation bias"]}, "parameters": {}, "question": "Identify whether each item represents a bias perilaku, rational strategy, or market condition:", "type": "categorization"}'::jsonb
WHERE id = '543cdef3-d4a0-4cc0-9881-7d1b36cdbc85'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 700.000", "difficulty": "beginner", "explanation": "2 lot = 200 lembar. 200 × Rp 3.500 = Rp 700.000.", "options": ["Rp 350.000", "Rp 700.000", "Rp 3.500.000", "Rp 7.000.000"], "parameters": {}, "question": "Jika harga saham TLKM Rp 3.500 per lembar, berapa biaya membeli 2 lot?", "type": "multiple_choice"}'::jsonb
WHERE id = '63380433-e391-450d-8c88-ad96a740dee3'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "If a company is famous, its saham is selalu a good investasi.", "type": "true_false"}'::jsonb
WHERE id = '0295c1c4-8b31-4897-9d17-8163e1f55602'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "compound", "difficulty": "beginner", "explanation": "bunga majemuk accelerates kekayaan growth by earning returns on returns dari waktu ke waktu.", "parameters": {}, "question": "________ bunga means earning returns on both your original investasi and the accumulated returns.", "type": "fill_blank"}'::jsonb
WHERE id = 'a2c8c1ac-6cc8-41b6-b3e0-f9a7d3a51e97'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emergency", "difficulty": "beginner", "explanation": "Emergency funds provide financial security during unforeseen circumstances like job loss or medical emergencies.", "parameters": {}, "question": "A ________ fund is money set aside specifically for unexpected expenses.", "type": "fill_blank"}'::jsonb
WHERE id = '2046d8d8-36c4-4010-9d8d-b5bae6c40145'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Sharpe", "difficulty": "beginner", "explanation": "Therasio Sharpe helps investors understand return per unit of risiko taken.", "parameters": {}, "question": "The ________ ratio measures risiko-adjusted return by comparing excess return to volatilitas.", "type": "fill_blank"}'::jsonb
WHERE id = 'e8870825-116d-41c0-9a12-44a5e4f02bfd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["P/E ratio", "EPS"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: rasio P/E, EPS.", "options": ["P/E ratio", "EPS", "ROE", "kapitalisasi pasar"], "parameters": {}, "question": "Fundamental metrics like ________ and ________ help evaluate saham valuations.", "type": "word_bank"}'::jsonb
WHERE id = 'cf553b03-cc9b-4753-8a00-8101cf9031e9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["FOMO", "aversi rugi"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: FOMO, aversi rugi.", "options": ["FOMO", "aversi rugi", "herd mentality", "confirmation bias"], "parameters": {}, "question": "Common behavioral biases include ________, ________, and following the crowd without research.", "type": "word_bank"}'::jsonb
WHERE id = '8715b17a-cf66-48ab-bc12-fa174ef52124'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kebutuhan", "keinginan"], "difficulty": "beginner", "explanation": "kata yang benar dari bank kata adalah: kebutuhan, keinginan.", "options": ["kebutuhan", "keinginan", "savings", "dana darurat"], "parameters": {}, "question": "Financial planning starts with distinguishing ________ from ________, then building reserves.", "type": "word_bank"}'::jsonb
WHERE id = 'b7de35b7-4d29-4c96-9d18-f93f1195febf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: buka rekening sekuritas → lengkapi proses kyc → setor dana → riset saham → tempatkan order pertama", "options": ["buka rekening sekuritas", "lengkapi proses kyc", "setor dana", "riset saham", "tempatkan order pertama"], "parameters": {}, "question": "urutkan langkah-langkah untuk mulai berinvestasi di saham indonesia:", "type": "ordering"}'::jsonb
WHERE id = 'b5977add-1ed7-41da-8372-5174241f2341'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: pahami tingkat inflasi → periksa suku bunga tabungan → hitung return riil → pertimbangkan alternatif → sesuaikan strategi menabung", "options": ["pahami tingkat inflasi", "periksa suku bunga tabungan", "hitung return riil", "pertimbangkan alternatif", "sesuaikan strategi menabung"], "parameters": {}, "question": "urutkan langkah-langkah untuk melindungi tabungan dari inflasi:", "type": "ordering"}'::jsonb
WHERE id = '30a78f51-a472-4df0-8429-f6576c14d10d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "difficulty": "beginner", "explanation": "urutan yang benar adalah: Define risiko tolerance → Set time horizon → Choose aset allocation → Select specific investments → Rebalance periodically", "options": ["Define risiko tolerance", "Set time horizon", "Choose aset allocation", "Select specific investments", "Rebalance periodically"], "parameters": {}, "question": "urutkan langkah-langkah to build an investasi portofolio:", "type": "ordering"}'::jsonb
WHERE id = '0d0ea6bd-b87f-428a-b4b0-ba1e1ac67e5a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "20", "difficulty": "beginner", "explanation": "P/E = Price per share / Earnings per share = 20,000 / 1,000 = 20.", "parameters": {"hint": "Divide stock price by earnings per share."}, "question": "A saham trades at Rp 20,000 with EPS of Rp 1,000. apa the rasio P/E?", "type": "calculation"}'::jsonb
WHERE id = '15379a9a-0e03-455c-bb7f-b42d0fd97c75'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"bunga majemuk": "bunga on bunga", "diversifikasi": "Spreading risiko across assets", "likuiditas": "Ease of converting to cash", "volatilitas": "Price fluctuation magnitude"}, "difficulty": "beginner", "explanation": "benar matches: likuiditas → Ease of converting to cash, volatilitas → Price fluctuation magnitude, diversifikasi → Spreading risiko across assets, bunga majemuk → bunga on bunga", "options": {"left": ["likuiditas", "volatilitas", "diversifikasi", "bunga majemuk"], "right": ["Ease of converting to cash", "Price fluctuation magnitude", "Spreading risiko across assets", "bunga on bunga"]}, "parameters": {}, "question": "Match each financial concept with its meaning:", "type": "matching"}'::jsonb
WHERE id = '92899b04-4ecd-4180-affd-9f157b3286d7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"50/30/20 Rule": "anggaran allocation framework", "dollar cost averaging": "Regular fixed investments", "dana darurat": "3-6 months expense reserve", "rebalancing": "Adjusting portofolio weights"}, "difficulty": "beginner", "explanation": "Correct matches: 50/30/20 Rule → Budget allocation framework, Emergency Fund → 3-6 months expense reserve, Dollar Cost Averaging → Regular fixed investments, Rebalancing → Adjusting portfolio weights", "options": {"left": ["50/30/20 Rule", "dana darurat", "dollar cost averaging", "rebalancing"], "right": ["anggaran allocation framework", "3-6 months expense reserve", "Regular fixed investments", "Adjusting portofolio weights"]}, "parameters": {}, "question": "Match each strategy with its description:", "type": "matching"}'::jsonb
WHERE id = '8ced115e-4824-41e5-9d17-528a4ca7f2e9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"advanced Investor": "Uses derivatives, manages risiko", "beginner Investor": "Learns basics, uses deposits", "intermediate Investor": "Understands ratios, diversifies"}, "difficulty": "beginner", "explanation": "benar matches: beginner Investor → Learns basics, uses deposits, intermediate Investor → Understands ratios, diversifies, advanced Investor → Uses derivatives, manages risiko", "options": {"left": ["beginner Investor", "intermediate Investor", "advanced Investor"], "right": ["Learns basics, uses deposits", "Understands ratios, diversifies", "Uses derivatives, manages risiko"]}, "parameters": {}, "question": "Match each investor level with its characteristics:", "type": "matching"}'::jsonb
WHERE id = 'ed84c808-551e-46bb-9aab-3c8183a42cfe'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "beginner", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "What is the difference between owning 100 shares of a company and working for that company?"}, "question": "apa perbedaan between owning 100 shares of a company and working for that company? Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = '3295a609-517d-47f3-a719-b9b589e540b7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Analyze the data", "difficulty": "beginner", "explanation": "dalam skenario ini, analyze the data adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Trust your intuition", "Analyze the data", "Ask friends", "Copy influencers"], "parameters": {"scenario_text": "IDX opens at 9 AM and closes at 4 PM. Can you place orders at 8:30 AM?"}, "question": "IDX opens at 9 AM and closes at 4 PM. Can you place orders at 8:30 AM? What critical information is missing before deciding?", "type": "scenario"}'::jsonb
WHERE id = 'd4c0328e-2afb-4d54-8dda-75e15e67c716'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "investasi bertahap dari waktu ke waktu", "difficulty": "beginner", "explanation": "dalam skenario ini, investasi bertahap dari waktu ke waktu adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["investasi sekaligus", "investasi bertahap dari waktu ke waktu", "tunggu waktu yang sempurna", "jangan pernah berinvestasi"], "parameters": {"scenario_text": "A company announces a 2:1 stock split. You own 50 shares at Rp 10,000. What happens?"}, "question": "A company announces a 2:1 saham split. You own 50 shares at Rp 10,000. apa yang terjadi? apa yang akan dilakukan orang yang melek keuangan?", "type": "scenario"}'::jsonb
WHERE id = '29d92bfe-9dd4-492e-9daa-963ce352c285'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "8.4%", "difficulty": "beginner", "explanation": "CAGR = (Ending Value / Beginning Value)^(1/n) - 1 = (150/100)^(1/5) - 1 ≈ 8.4%.", "parameters": {"hint": "Use the CAGR formula: (FV/PV)^(1/years) - 1."}, "question": "jika rp 100 juta tumbuh menjadi rp 150 juta dalam 5 tahun, berapakah perkiraan tingkat pertumbuhan tahunan majemuk (CAGR)?", "type": "calculation"}'::jsonb
WHERE id = '1f81f925-c454-42d1-a7ff-0fae25a63df2'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "1,600,000", "difficulty": "beginner", "explanation": "20% of 8,000,000 = 0.20 × 8,000,000 = Rp 1,600,000.", "parameters": {"hint": "Calculate 20% of the monthly income."}, "question": "You earn Rp 8M per bulan. Following the 50/30/20 rule, berapa banyak should go to savings and utang?", "type": "calculation"}'::jsonb
WHERE id = 'e966ed8a-0473-434e-9530-9122eadac908'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Personal loan", "difficulty": "beginner", "explanation": "Credit card at 2.5% per bulan compounds to ~34.5% per tahun. Personal loan at 12% annual is far cheaper.", "options": ["Credit card", "Personal loan", "They are equal", "Depends on usage"], "parameters": {}, "question": "Between a credit card with 2.5% per bulan bunga and a personal loan with 12% annual bunga, which has lower effective cost?", "type": "comparison"}'::jsonb
WHERE id = '1705218a-ae5d-4570-aeac-afae5da2ddcd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Market ETF", "difficulty": "beginner", "explanation": "ETFs hold many saham, eliminating company-specific (unsystematic) risiko that single saham carry.", "options": ["Single saham", "Market ETF", "Both have same risiko", "risiko cannot be measured"], "parameters": {}, "question": "Compare the risiko: buying a single saham vs an ETF tracking the entire market. Which has lower unsystematic risiko?", "type": "comparison"}'::jsonb
WHERE id = 'da1b4073-b5a3-4055-82e4-e67f75ca5743'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 2M from age 30", "difficulty": "beginner", "explanation": "Starting earlier gives compounding more time to work. Rp 2M × 30 years at 7% beats Rp 5M × 15 years.", "options": ["Rp 2M from age 30", "Rp 5M from age 45", "Both equal at retirement", "Neither is enough"], "parameters": {}, "question": "For retirement savings starting at age 30: is it better to save Rp 2M per bulan or Rp 5M per bulan starting at age 45?", "type": "comparison"}'::jsonb
WHERE id = '5fcda180-54a0-4178-8492-a943836be9fc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions"], "difficulty": "beginner", "explanation": "The disposition effect (selling winners, holding losers) and confirmation bias destroy long-term returns.", "options": ["Disposition effect", "Confirmation bias", "No stop-loss strategy", "Emotion-driven decisions", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI sold my profitable saham to realize gains but kept my losing saham hoping they''d recover. I read one article that confirmed the losers would bounce back.", "type": "spot_mistake"}'::jsonb
WHERE id = '12dff2c9-e85e-4ca4-b201-ff274838a840'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs"], "difficulty": "beginner", "explanation": "Starting young maximizes compounding. Even small amounts invested early outperform larger amounts invested later.", "options": ["Age-based investasi procrastination", "0% return on idle cash", "Missed compounding opportunity", "False prerequisite beliefs", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI''m 22 and I think berinvestasi is hanya for old people. I''ll start when I have a ''riil job.'' My money stays in a checking account earning 0% bunga.", "type": "spot_mistake"}'::jsonb
WHERE id = '906e5428-8799-40a4-9e8b-ef70cff210cf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice"], "difficulty": "beginner", "explanation": "investasi decisions should be based on research and fundamentals, not superstition or unverified tips.", "options": ["Superstition-based berinvestasi", "Unverified insider claims", "No fundamental analysis", "Following unqualified advice", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invest based on my horoscope and the advice of a WhatsApp group admin who claims to have informasi orang dalam. I tidak pernah read financial statements.", "type": "spot_mistake"}'::jsonb
WHERE id = '5368f332-4121-4be8-9327-2e885e0507ca'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "09.00–15.00 WIB", "difficulty": "beginner", "explanation": "Jam bursa IDX adalah 09.00–15.00 WIB.", "options": ["08.00–14.00 WIB", "09.00–15.00 WIB", "10.00–16.00 WIB", "24 jam"], "parameters": {}, "question": "Jam perdagangan saham di IDX adalah?", "type": "multiple_choice"}'::jsonb
WHERE id = 'bad176ea-3d32-48bf-9512-b18610f65521'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Paper trading menggunakan uang virtual, bukan uang sungguhan.", "parameters": {}, "question": "Paper trading di Koin menggunakan uang sungguhan.", "type": "true_false"}'::jsonb
WHERE id = 'eaa33b3e-75eb-43d1-a45c-aa8a2e08d1cd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"inflasi Hedge": ["Gold", "riil estate", "inflasi-indexed obligasi", "saham portofolio"], "inflasi risiko": ["Cash under mattress", "Fixed deposit at 2%"], "Neutral": ["Foreign currency", "Collectibles"]}, "difficulty": "beginner", "explanation": "benar categorization: {\"inflasi Hedge\": [\"Gold\", \"riil estate\", \"inflasi-indexed obligasi\", \"saham portofolio\"], \"inflasi risiko\": [\"Cash under mattress\", \"Fixed deposit at 2%\"], \"Neutral\": [\"Foreign currency\", \"Collectibles\"]}", "options": {"buckets": ["inflasi Hedge", "inflasi risiko", "Neutral"], "items": ["Gold", "Cash under mattress", "riil estate", "Fixed deposit at 2%", "inflasi-indexed obligasi", "saham portofolio", "Foreign currency", "Collectibles"]}, "parameters": {}, "question": "Classify each item based on its relationship with inflasi:", "type": "categorization"}'::jsonb
WHERE id = '68be658b-d697-468a-a704-6a93f1b67623'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Pilih perusahaan sekuritas terdaftar", "Buka rekening saham", "Deposit dana", "Beli saham"], "difficulty": "beginner", "explanation": "Pilih sekuritas, buka rekening, deposit, baru beli saham.", "options": ["Pilih perusahaan sekuritas terdaftar", "Buka rekening saham", "Deposit dana", "Beli saham"], "parameters": {}, "question": "Urutkan langkah memulai investasi saham sungguhan:", "type": "ordering"}'::jsonb
WHERE id = 'e3f99b53-3697-4ec5-b484-5755bf8be7e9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "100", "difficulty": "beginner", "explanation": "Di Bursa Efek Indonesia, 1 lot = 100 lembar saham.", "options": ["10", "50", "100", "1000"], "parameters": {}, "question": "Berapa lembar saham dalam 1 lot di IDX?", "type": "multiple_choice"}'::jsonb
WHERE id = '09f41247-1e1b-4fb6-a84a-e2e66c1344f1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "IHSG", "difficulty": "beginner", "explanation": "IHSG adalah Indeks Harga Saham Gabungan.", "parameters": {}, "question": "Indeks yang mencerminkan pergerakan harga saham besar di Indonesia disebut ____.", "type": "fill_blank"}'::jsonb
WHERE id = '0e041f3a-bb8d-48d8-9a5a-4acc2e094a1a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "1 lot saham di IDX sama dengan 100 lembar saham.", "parameters": {}, "question": "Membeli 1 lot saham BBCA berarti membeli 10 lembar saham.", "type": "true_false"}'::jsonb
WHERE id = '9c7b568e-c3a3-4ee2-85e9-d2e8357a138d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Dividend Yield": "Annual dividend per share divided by saham price", "EPS": "Net pendapatan divided by number of outstanding shares", "P/E Ratio": "Market price per share divided by earnings per share", "ROE": "Net pendapatan divided by shareholders'' equity"}, "difficulty": "beginner", "explanation": "benar matches: rasio P/E = Market price per share divided by earnings per share, EPS = Net pendapatan divided by number of outstanding shares, ROE = Net pendapatan divided by shareholders'' equity, Dividend Yield = Annual dividend per share divided by saham price", "options": {"definitions": ["Market price per share divided by earnings per share", "Net pendapatan divided by number of outstanding shares", "Net pendapatan divided by shareholders'' equity", "Annual dividend per share divided by saham price"], "terms": ["P/E Ratio", "EPS", "ROE", "Dividend Yield"]}, "parameters": {}, "question": "Match each financial metric with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '50fcda3f-9403-4627-952c-6367464c1010'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Leverage": "The use of borrowed capital to increase potential returns", "likuiditas": "The ease with which an aset can be converted to cash", "Solvency": "The ability to meet long-term financial obligations", "volatilitas": "The degree of variation in trading prices dari waktu ke waktu"}, "difficulty": "beginner", "explanation": "benar matches: likuiditas = The ease with which an aset can be converted to cash, Solvency = The ability to meet long-term financial obligations, Leverage = The use of borrowed capital to increase potential returns, volatilitas = The degree of variation in trading prices dari waktu ke waktu", "options": {"definitions": ["The ease with which an aset can be converted to cash", "The ability to meet long-term financial obligations", "The use of borrowed capital to increase potential returns", "The degree of variation in trading prices dari waktu ke waktu"], "terms": ["likuiditas", "Solvency", "Leverage", "volatilitas"]}, "parameters": {}, "question": "Match each financial concept with its definition:", "type": "definition_match"}'::jsonb
WHERE id = 'd87701b4-aaff-4e3f-bf2e-9c0712bacd65'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Tempat membeli dan menjual saham di Indonesia", "difficulty": "beginner", "explanation": "IDX adalah pasar tempat saham dan efek lain diperdagangkan di Indonesia.", "options": ["Menerbitkan uang rupiah", "Tempat membeli dan menjual saham di Indonesia", "Mengatur suku bunga bank", "Menyalurkan kredit UMKM"], "parameters": {}, "question": "Apa fungsi utama Bursa Efek Indonesia (IDX)?", "type": "multiple_choice"}'::jsonb
WHERE id = 'b4677ef1-5bea-4ef4-8a47-86f2726e9009'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "cheaper", "difficulty": "beginner", "explanation": "Currency depreciation makes domestic goods cheaper for foreign buyers, potentially boosting exports.", "options": ["more expensive", "cheaper", "unchanged in price", "illegal"], "parameters": {}, "question": "If a country''s currency depreciates, its export goods become ________ for foreign buyers.", "type": "sentence_completion"}'::jsonb
WHERE id = 'bcad4066-696b-4f73-b17f-879725562858'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "more", "difficulty": "beginner", "explanation": "beta measures sensitivity to market movements. beta 1.5 means 50% more volatile than the market.", "options": ["less", "more", "in the opposite direction", "independently"], "parameters": {}, "question": "A saham with a beta of 1.5 diharapkan bergerak ________ daripada pasar secara keseluruhan.", "type": "sentence_completion"}'::jsonb
WHERE id = '8524486b-cb07-463f-8d47-216ad7ec8334'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "provide financial security during crises", "difficulty": "beginner", "explanation": "Emergency funds prioritize likuiditas and safety over returns, providing a buffer for unexpected expenses.", "options": ["maximize returns", "provide financial security during crises", "beat inflasi", "fund vacations"], "parameters": {}, "question": "The primary purpose of an dana darurat is to ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'a9c4189b-34ac-4b6a-8248-8ea58617e297'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "periksa izin OJK", "difficulty": "beginner", "explanation": "The flowchart explicitly shows OJK license verification as the first decision point before any further action.", "options": ["Read the prospectus", "periksa izin OJK", "Calculate potential returns", "Ask friends for opinion"], "parameters": {"image_description": "A flowchart: Start → Check OJK license → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths."}, "question": "[IMAGE: A flowchart: Start → periksa izin OJK → If yes: proceed to research → If no: stop and report. Branches show safe vs unsafe paths.]\n\nWhat yang pertama checkpoint in this financial safety flowchart?", "type": "image_interpretation"}'::jsonb
WHERE id = 'd9d16a3e-e111-4513-a5e7-d5687a0c4cef'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Most months are near average, extremes are rare", "difficulty": "beginner", "explanation": "The bell-shaped distribution with most data near the mean and fewer observations in the tails is characteristic of return distributions.", "options": ["Returns are normally distributed", "Returns are predictable", "Most months are near average, extremes are rare", "Every month is equally likely"], "parameters": {"image_description": "A histogram showing distribution of monthly returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%."}, "question": "[IMAGE: A histogram showing distribution of per bulan returns for the IDX Composite over 20 years. Most months cluster around 0-2%, with tails extending to -15% and +15%.]\n\napa yang the shape of this distribution suggest about market returns?", "type": "image_interpretation"}'::jsonb
WHERE id = '24322e13-1c32-4518-ba48-1f0c0d378004'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Currency depreciation and saham declines may be correlated", "difficulty": "beginner", "explanation": "Rupiah depreciation and saham market declines sering occur together during periods of foreign capital outflows and risiko aversion.", "options": ["Currency appreciation helps saham", "Currency depreciation and saham declines may be correlated", "saham and currency are unrelated", "Government controls both"], "parameters": {"image_description": "A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling."}, "question": "[IMAGE: A dual-axis chart: left axis shows Rupiah/USD exchange rate rising (depreciating), right axis shows Jakarta Composite Index falling.]\n\nWhat relationship might this chart be illustrating?", "type": "image_interpretation"}'::jsonb
WHERE id = '15304875-0cba-4c62-aaeb-d6ada7601fdb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Bursa", "100"], "difficulty": "beginner", "explanation": "Saham diperdagangkan di Bursa Efek Indonesia, dengan 1 lot setara dengan 100 lembar saham.", "options": ["Bursa", "100"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Saham diperdagangkan di _____ Efek Indonesia, dan 1 lot sama dengan _____ lembar saham.\"", "type": "word_bank"}'::jsonb
WHERE id = '7e07fc74-99e9-457c-be4c-5dda6571214a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "efek", "difficulty": "beginner", "explanation": "Rekening efek dibuka melalui perusahaan sekuritas agar investor bisa bertransaksi saham di IDX.", "parameters": {}, "question": "Untuk mulai membeli saham di IDX, investor perlu membuka rekening _____ terlebih dahulu.", "type": "fill_blank"}'::jsonb
WHERE id = '1748054b-8cea-4f9a-a3a7-b4ca4d972196'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "beginner", "explanation": "Securities Investor Protection Fund (SIPF) melindungi investor dalam efek tercatat sesuai ketentuan.", "parameters": {}, "question": "SIPF memberikan perlindungan kepada investor yang menyimpan efek di perusahaan sekuritas.", "type": "true_false"}'::jsonb
WHERE id = '225aa5e9-80de-444e-9a8c-f8599d3ce322'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "500 lembar", "difficulty": "beginner", "explanation": "Di IDX, 1 lot sama dengan 100 lembar saham. Jadi 5 lot sama dengan 500 lembar.", "options": ["5 lembar", "50 lembar", "500 lembar", "5000 lembar"], "parameters": {}, "question": "Jika seorang investor membeli 5 lot saham BBCA, berapa total lembar saham yang dimilikinya?", "type": "multiple_choice"}'::jsonb
WHERE id = '2726df68-f041-4288-ae22-0a49a95f7cac'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["saham", "perusahaan"], "difficulty": "beginner", "explanation": "Saham adalah bukti kepemilikan sebagian dari perusahaan yang tercatat.", "options": ["saham", "perusahaan"], "parameters": {}, "question": "Lengkapi kalimat berikut dengan kata dari bank kata: \"Di IDX, investor membeli _____ yang mewakili kepemilikan sebagian dari sebuah _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '40031ab2-8d1b-4fed-bba1-e6839c55b950'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Efek", "difficulty": "beginner", "explanation": "IDX adalah singkatan dari Bursa Efek Indonesia.", "parameters": {}, "question": "Singkatan IDX adalah Bursa _____ Indonesia.", "type": "fill_blank"}'::jsonb
WHERE id = '24e86c49-5a5d-4995-a5cf-09873cdda83b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "beginner", "explanation": "Membeli saham berarti menjadi pemilik sebagian kecil perusahaan, bukan meminjamkan uang.", "parameters": {}, "question": "Membeli saham berarti meminjamkan uang kepada perusahaan.", "type": "true_false"}'::jsonb
WHERE id = '44a59b78-bcae-4f97-8d5b-7861eb41ac0d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Short-term volatilitas is normal, long-term trend matters", "difficulty": "intermediate", "explanation": "The chart shows significant short-term drops but a long-term upward trend, illustrating why time in market beats timing the market.", "options": ["Markets selalu crash permanently", "Short-term volatilitas is normal, long-term trend matters", "Timing the market is easy", "Indonesian saham are too risky"], "parameters": {"image_description": "A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatility in 2022, steady climb in 2023-2024."}, "question": "[IMAGE: A line chart showing the IDX Composite (IHSG) from 2019 to 2024. Sharp drop in March 2020, gradual recovery through 2021, volatilitas in 2022, steady climb in 2023-2024.]\n\napa yang this chart primarily demonstrate about long-term berinvestasi?", "type": "image_interpretation"}'::jsonb
WHERE id = 'f727b9ea-f7d6-4df7-a0c7-61cfebdc3b73'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Starting early dramatically increases final kekayaan", "difficulty": "intermediate", "explanation": "The accelerating growth shown in the timeline demonstrates the exponential power of bunga majemuk over long periods.", "options": ["You need to be rich to start", "Starting early dramatically increases final kekayaan", "Retirement is impossible", "hanya high earners can retire"], "parameters": {"image_description": "A timeline infographic: Age 25 (start investing Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B)."}, "question": "[IMAGE: A timeline infographic: Age 25 (start berinvestasi Rp 1M/month) → Age 35 (already have Rp 170M) → Age 45 (Rp 520M) → Age 55 (Rp 1.3B) → Age 65 (Rp 2.8B).]\n\nWhat utama message of this retirement savings timeline?", "type": "image_interpretation"}'::jsonb
WHERE id = 'a1d48e80-37b6-4379-a10d-f320b45be891'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp 3M (20% of pendapatan)", "difficulty": "intermediate", "explanation": "benar path: Rp 3M (20% of pendapatan). This represents the most financially sound decision at this stage.", "options": ["Rp 500K", "Rp 3M (20% of pendapatan)", "Rp 7.5M (50% of pendapatan)", "Nothing, spend freely"], "parameters": {"full_tree": {"scenario": "You are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.", "stages": [{"correct": "Rp 3M (20% of income)", "next": {"correct": "High-yield savings", "next": {"correct": "Money market fund", "options": ["Regular savings", "Money market fund", "Aggressive growth stocks", "Friends'' business"], "question": "After emergency fund, monthly surplus goes to house fund. Best vehicle?"}, "options": ["Crypto wallet", "High-yield savings", "Stock market", "Under mattress"], "question": "Where should you keep the emergency portion (3 months expenses = Rp 45M target)?"}, "options": ["Rp 500K", "Rp 3M (20% of income)", "Rp 7.5M (50% of income)", "Nothing, spend freely"], "question": "Month 1: How much should you save first?"}]}}, "question": "Decision Tree Scenario:\n\nYou are 28, earning Rp 15M/month, with no savings. You want to buy a house in 7 years.\n\nMonth 1: berapa banyak should you save first?", "type": "decision_tree"}'::jsonb
WHERE id = '5f8cfc4c-4d61-42f2-9818-5293491ba3a1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "Behavioral biases hanya affect inexperienced investors.", "type": "true_false"}'::jsonb
WHERE id = '2fb174fa-124d-44ec-a201-ac092a9ce774'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "This statement salah. Common misconceptions can lead to poor financial decisions.", "parameters": {}, "question": "menabung money under your mattress is selalu better than bank deposits.", "type": "true_false"}'::jsonb
WHERE id = '0bc00a0e-c9b5-4583-8e57-d0dc387a4e5e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "diversifikasi", "difficulty": "intermediate", "explanation": "diversifikasi ensures that poor performance in one investasi does not destroy the entire portofolio.", "parameters": {}, "question": "________ is the practice of spreading investments across different assets to reduce risiko.", "type": "fill_blank"}'::jsonb
WHERE id = '62ac81be-3928-4d64-8574-4438c5ac41e5'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Buka rekening efek di sekuritas terdaftar", "Lakukan riset perusahaan", "Tentukan saham dan jumlah lot", "Pantau portofolio secara berkala"], "difficulty": "intermediate", "explanation": "Mulai dengan rekening efek, riset perusahaan, tentukan lot, lalu pantau secara berkala.", "options": ["Buka rekening efek di sekuritas terdaftar", "Lakukan riset perusahaan", "Tentukan saham dan jumlah lot", "Pantau portofolio secara berkala"], "parameters": {}, "question": "Urutkan langkah membeli saham di IDX secara aman.", "type": "ordering"}'::jsonb
WHERE id = '53e73e28-a176-4999-9d31-78368444f333'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "kebutuhan vs keinginan", "difficulty": "intermediate", "explanation": "Understanding kebutuhan versus keinginan is fundamental to anggaran and menabung.", "parameters": {}, "question": "The concept of ________ helps individuals distinguish between essential and non-essential spending.", "type": "fill_blank"}'::jsonb
WHERE id = '9199d08e-c5e0-48bf-bc9d-b410798e4e33'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "2.5", "difficulty": "intermediate", "explanation": "BI''s inflasi target is approximately 2.5% with a tolerance band of ±1%.", "parameters": {}, "question": "Bank Indonesia targets inflation around ________ percent per year.", "type": "fill_blank"}'::jsonb
WHERE id = '69b2a8d0-a7c4-462e-ae00-e09a01f86e8f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["principal", "bunga"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: principal, bunga.", "options": ["principal", "bunga", "compound", "maturity"], "parameters": {}, "question": "With ________ bunga, you earn returns on both your ________ and accumulated earnings.", "type": "word_bank"}'::jsonb
WHERE id = '649e050a-5081-4b68-8fe0-d129131ee637'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["menabung", "anggaran"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: menabung, anggaran.", "options": ["menabung", "anggaran", "berinvestasi", "spending"], "parameters": {}, "question": "Before ________, you should selalu create a ________ to plan your pendapatan and expenses.", "type": "word_bank"}'::jsonb
WHERE id = 'faab6151-f0b3-4dc7-8911-2bd9c21bc942'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["inflasi", "deflation"], "difficulty": "intermediate", "explanation": "kata yang benar dari bank kata adalah: inflasi, deflation.", "options": ["inflasi", "deflation", "stagflation", "hyperinflation"], "parameters": {}, "question": "________ occurs when prices rise across the economy, while ________ is when prices fall.", "type": "word_bank"}'::jsonb
WHERE id = '2cb49f35-548f-4533-8515-31f55d02a028'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Spot red flags → Verify information → Consult trusted sources → Document concerns → Report to authorities if needed", "options": ["Spot red flags", "Verify information", "Consult trusted sources", "Document concerns", "Report to authorities if needed"], "parameters": {}, "question": "urutkan langkah-langkah to respond to a potential investasi penipuan:", "type": "ordering"}'::jsonb
WHERE id = '79092d1a-674c-4a63-83b7-5af63e185760'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: Set financial goals → Track pendapatan and expenses → Create a anggaran → Build dana darurat → Start berinvestasi", "options": ["Set financial goals", "Track pendapatan and expenses", "Create a anggaran", "Build dana darurat", "Start berinvestasi"], "parameters": {}, "question": "Order these steps to build a solid financial foundation:", "type": "ordering"}'::jsonb
WHERE id = '4e2f2627-1a06-4f6d-b47e-7e9d38c7eba6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "difficulty": "intermediate", "explanation": "urutan yang benar adalah: periksa izin OJK → Read the prospectus → Understand the risks → Start with small amount → Monitor regularly", "options": ["periksa izin OJK", "Read the prospectus", "Understand the risks", "Start with small amount", "Monitor regularly"], "parameters": {}, "question": "Order the proper due diligence steps before berinvestasi:", "type": "ordering"}'::jsonb
WHERE id = '68f9407f-e59a-4ff0-afde-096b01e3bc9d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Pilih sekuritas terdaftar", "Buka rekening efek", "Setor dana", "Lakukan transaksi saham"], "difficulty": "intermediate", "explanation": "Pilih sekuritas terdaftar, buka rekening efek, setor dana, lalu lakukan transaksi saham.", "options": ["Pilih sekuritas terdaftar", "Buka rekening efek", "Setor dana", "Lakukan transaksi saham"], "parameters": {}, "question": "Urutkan tahapan menjadi investor saham di IDX.", "type": "ordering"}'::jsonb
WHERE id = '34475e6f-3af3-4aa8-841a-909a6acba69c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Fundamental Analysis": "Financial statements", "Quantitative Analysis": "Mathematical models", "Sentiment Analysis": "Market mood and emotions", "Technical Analysis": "Charts and patterns"}, "difficulty": "intermediate", "explanation": "benar matches: Technical Analysis → Charts and patterns, Fundamental Analysis → Financial statements, Quantitative Analysis → Mathematical models, Sentiment Analysis → Market mood and emotions", "options": {"left": ["Technical Analysis", "Fundamental Analysis", "Quantitative Analysis", "Sentiment Analysis"], "right": ["Charts and patterns", "Financial statements", "Mathematical models", "Market mood and emotions"]}, "parameters": {}, "question": "Match each analysis approach with its focus:", "type": "matching"}'::jsonb
WHERE id = '7c3735a1-ace7-4e32-839d-ae76a05ce379'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"BI": "Central bank", "IDX": "saham exchange", "OJK": "Financial regulator", "SIPF": "Investor protection fund"}, "difficulty": "intermediate", "explanation": "benar matches: OJK → Financial regulator, BI → Central bank, IDX → saham exchange, SIPF → Investor protection fund", "options": {"left": ["OJK", "BI", "IDX", "SIPF"], "right": ["Financial regulator", "Central bank", "saham exchange", "Investor protection fund"]}, "parameters": {}, "question": "Match each Indonesian financial institution with its primary function:", "type": "matching"}'::jsonb
WHERE id = '8dac5741-5781-451e-9fc0-cfd450cd7980'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "General price fall", "Hyperinflation": "Extreme rapid price rise", "inflasi": "General price rise", "Stagflation": "High inflasi + stagnation"}, "difficulty": "intermediate", "explanation": "benar matches: inflasi → General price rise, Deflation → General price fall, Stagflation → High inflasi + stagnation, Hyperinflation → Extreme rapid price rise", "options": {"left": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"], "right": ["General price rise", "General price fall", "High inflasi + stagnation", "Extreme rapid price rise"]}, "parameters": {}, "question": "Match each economic condition with its definition:", "type": "matching"}'::jsonb
WHERE id = 'e7705584-992a-462a-a7a7-49166ae21dff'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Plan for long-term goals", "difficulty": "intermediate", "explanation": "dalam skenario ini, plan for long-term goals adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Focus on short-term gains", "Plan for long-term goals", "React to every news", "Ignore the market"], "parameters": {"scenario_text": "Short selling is restricted in Indonesia. How does this affect market efficiency and volatility?"}, "question": "Short selling is restricted di Indonesia. bagaimana this affect market efficiency and volatilitas? apa the likely long-term outcome of each pilihan?", "type": "scenario"}'::jsonb
WHERE id = '27bfca5d-647f-42fd-a26c-33e5bad83421'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gather more information", "difficulty": "intermediate", "explanation": "dalam skenario ini, gather more information adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Act immediately", "Gather more information", "Consult a professional", "Do nothing"], "parameters": {"scenario_text": "BBCA has P/E 18, BBRI has P/E 12. Does this automatically mean BBRI is cheaper?"}, "question": "BBCA has P/E 18, BBRI has P/E 12. Does this automatically mean BBRI is cheaper? apa the most rational next step?", "type": "scenario"}'::jsonb
WHERE id = 'ba48b038-9319-4bee-881b-e6720289731e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Minimize risiko", "difficulty": "intermediate", "explanation": "dalam skenario ini, minimize risiko adalah pendekatan paling seimbang dan berinformasi dalam pengambilan keputusan keuangan.", "options": ["Maximize return", "Minimize risiko", "Balance risiko and return", "Follow the crowd"], "parameters": {"scenario_text": "Calculate market cap: 20 billion shares outstanding, price Rp 5,000. What is the market cap in trillion?"}, "question": "Calculate kapitalisasi pasar: 20 billion shares outstanding, price Rp 5,000. apa the kapitalisasi pasar in trillion? Which pilihan minimizes risiko while preserving opportunity?", "type": "scenario"}'::jsonb
WHERE id = '1f157020-bb4a-44b6-a09e-b88fd10a3660'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "0.69", "difficulty": "intermediate", "explanation": "Portfolio beta = (0.50 × 1.2) + (0.30 × 0.3) + (0.20 × 0) = 0.60 + 0.09 + 0 = 0.69.", "parameters": {"hint": "Weight each asset''s beta by its portfolio allocation."}, "question": "A portofolio has 50% saham (beta 1.2), 30% obligasi (beta 0.3), 20% cash (beta 0). apa the portofolio beta?", "type": "calculation"}'::jsonb
WHERE id = '666e2d95-5dfa-4f6b-9d38-8129159afb7c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "69,770,000", "difficulty": "intermediate", "explanation": "Using the future value of an annuity formula: FV = PMT × [(1+r)^n - 1]/r. With r = 0.5% per bulan, n = 60, PMT = 1,000,000. FV ≈ Rp 69.77M.", "parameters": {"hint": "Use FV annuity formula with monthly compounding."}, "question": "If you save Rp 1,000,000 per bulan at 6% annual bunga compounded per bulan, berapa banyak will you have after 5 years?", "type": "calculation"}'::jsonb
WHERE id = '850e1f1a-2db3-486e-a0fa-3deb6d2abf78'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "24%", "difficulty": "intermediate", "explanation": "Initial investment: 200 × 5,000 = 1,000,000. Final value: 200 × 6,200 = 1,240,000. Return = (1,240,000 - 1,000,000) / 1,000,000 = 24%.", "parameters": {"hint": "Calculate total initial cost, total final value, then percentage change."}, "question": "A saham costs Rp 5,000 per share. You buy 200 shares. After 1 year, the price is Rp 6,200. apa your percentage return?", "type": "calculation"}'::jsonb
WHERE id = 'ea6c9519-41df-445a-92cd-34b2f2199a3e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Government obligasi", "difficulty": "intermediate", "explanation": "Real return deposits: 4% - 3% = 1%. Bonds: 6% - 3% = 3%. Bonds provide better inflation protection.", "options": ["Fixed deposits", "Government obligasi", "Both equal", "Neither beats inflasi"], "parameters": {}, "question": "Compare fixed deposits (4% p.a.) vs government obligasi (6% p.a.) for a conservative investor. Which offers better riil returns if inflasi is 3%?", "type": "comparison"}'::jsonb
WHERE id = 'f6b0ee7c-0519-415c-a616-cf4e2f58ed93'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "OJK-licensed bank deposit", "difficulty": "intermediate", "explanation": "Licensed deposits are regulated and insured. Unlicensed platforms carry penipuan risiko and no investor protection.", "options": ["OJK-licensed bank deposit", "Unlicensed P2P platform", "Both equally safe", "Cannot determine"], "parameters": {}, "question": "Which is generally safer: keeping Rp 50M in an OJK-licensed bank deposit or berinvestasi in an unlicensed P2P platform promising 15% returns?", "type": "comparison"}'::jsonb
WHERE id = '6e618c73-2d84-4ca7-b4f2-c996c3db067d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Start berinvestasi early", "difficulty": "intermediate", "explanation": "At a young age, the power of compounding favors starting investments early, while low-bunga loans can be managed alongside.", "options": ["Pay off loans first completely", "Start berinvestasi early", "Do neither, spend on experiences", "Split equally"], "parameters": {}, "question": "For a 25-year-old with stable pendapatan: is it better to prioritize paying off low-bunga student loans or start berinvestasi early?", "type": "comparison"}'::jsonb
WHERE id = '4c75fcb7-71b5-476d-9e0c-b18e89f23128'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')"], "difficulty": "intermediate", "explanation": "Lottery is entertainment, not a rencana keuangan. The ''due'' fallacy ignores that each draw is independent.", "options": ["Gambling fallacy", "Sunk cost in lottery", "No riil rencana keuangan", "Gambler''s fallacy (numbers ''due'')", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy rencana keuangan is to win the lottery. I''ve spent Rp 5M on lottery tickets this year. I''m sure my numbers are due to come up soon.", "type": "spot_mistake"}'::jsonb
WHERE id = '55808110-f444-4105-8d98-627d3d074d44'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time"], "difficulty": "intermediate", "explanation": "Multiple errors: no diversifikasi, no due diligence, unrealistic return expectations, and unverified broker.", "options": ["Concentrated semua savings in one saham", "Trusted friend''s tip without research", "Didn''t verify OJK license", "Expected guaranteed high returns in short time", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nI invested semua my savings in one saham karena my friend said it was a ''sure thing.'' I juga didn''t check if the broker was OJK-licensed. I''m sure I''ll double my money in 3 months!", "type": "spot_mistake"}'::jsonb
WHERE id = '022749a5-4e73-42e9-a484-e5b6164bf99e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals"], "difficulty": "intermediate", "explanation": "anggaran is upside-down, savings insufficient, and emergency funds must be liquid and safe.", "options": ["Inverted kebutuhan/keinginan ratio", "Savings rate too low", "dana darurat in volatile aset", "No clear financial goals", "tidak ada kesalahan", "hanya satu kesalahan kecil"], "parameters": {"mistake_count": 4}, "question": "baca pernyataan berikut dan identifikasi kesalahan keuangan:\n\nMy anggaran allocates 70% to keinginan, 20% to kebutuhan, and 10% to savings. I juga keep my dana darurat in cryptocurrency for higher returns.", "type": "spot_mistake"}'::jsonb
WHERE id = '66c33717-e3d9-4e0b-b413-eec408c1c63b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Diversifikasi instan", "Likuid di bursa"], "difficulty": "intermediate", "explanation": "ETF memberikan diversifikasi instan dan diperdagangkan di bursa.", "options": ["Diversifikasi instan", "Biaya lebih rendah", "Tidak ada risiko", "Likuid di bursa"], "parameters": {}, "question": "Manfaat ETF dibanding saham individual: ____", "type": "word_bank"}'::jsonb
WHERE id = 'f7f83a1f-0967-4088-aa4f-23d84d4f671f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Agar investor dapat menilai kesehatan perusahaan", "difficulty": "intermediate", "explanation": "Transparansi laporan keuangan membantu investor membuat keputusan berdasarkan data.", "options": ["Untuk membayar pajak", "Agar investor dapat menilai kesehatan perusahaan", "Untuk mendapatkan iklan gratis", "Untuk mengubah harga saham"], "parameters": {}, "question": "Mengapa perusahaan terdaftar di IDX wajib mengungkapkan laporan keuangan?", "type": "multiple_choice"}'::jsonb
WHERE id = '60915792-532d-4287-aa8a-6304a9c381fb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Long Term": ["Retirement savings", "Children''s education", "Estate planning"], "Medium Term": ["House down payment (3 years)", "Car purchase (1 year)"], "Short Term": ["dana darurat", "Next month''s rent", "Vacation fund"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"Short Term\": [\"dana darurat\", \"Next month''s rent\", \"Vacation fund\"], \"Medium Term\": [\"House down payment (3 years)\", \"Car purchase (1 year)\"], \"Long Term\": [\"Retirement savings\", \"Children''s education\", \"Estate planning\"]}", "options": {"buckets": ["Short Term", "Medium Term", "Long Term"], "items": ["dana darurat", "House down payment (3 years)", "Retirement savings", "Next month''s rent", "Car purchase (1 year)", "Children''s education", "Vacation fund", "Estate planning"]}, "parameters": {}, "question": "Organize each financial tujuan by its typical time horizon:", "type": "categorization"}'::jsonb
WHERE id = '1ef5669f-0b5b-4c58-9a9b-56ca68e1a39f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Investments": ["per bulan SIP", "saham purchase"], "kebutuhan": ["Rent payment", "Groceries"], "Savings": ["dana darurat deposit"], "keinginan": ["Netflix subscription", "Gym membership", "New sneakers"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"kebutuhan\": [\"Rent payment\", \"Groceries\"], \"keinginan\": [\"Netflix subscription\", \"Gym membership\", \"New sneakers\"], \"Savings\": [\"dana darurat deposit\"], \"Investments\": [\"per bulan SIP\", \"saham purchase\"]}", "options": {"buckets": ["kebutuhan", "keinginan", "Savings", "Investments"], "items": ["Rent payment", "Netflix subscription", "per bulan SIP", "dana darurat deposit", "Gym membership", "Groceries", "New sneakers", "saham purchase"]}, "parameters": {}, "question": "Categorize each item into the appropriate anggaran bucket:", "type": "categorization"}'::jsonb
WHERE id = 'bc943cbf-8b9f-4f3a-a066-f5375ad04527'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Not an aset": ["Time with family", "Car (depreciating)", "Lifestyle sneakers"], "Risky Assets": ["Bitcoin", "Individual saham", "riil estate"], "Safe Assets": ["Bank deposit", "Government obligasi"]}, "difficulty": "intermediate", "explanation": "benar categorization: {\"Safe Assets\": [\"Bank deposit\", \"Government obligasi\"], \"Risky Assets\": [\"Bitcoin\", \"Individual saham\", \"riil estate\"], \"Not an aset\": [\"Time with family\", \"Car (depreciating)\", \"Lifestyle sneakers\"]}", "options": {"buckets": ["Safe Assets", "Risky Assets", "Not an aset"], "items": ["Bank deposit", "Bitcoin", "Time with family", "Government obligasi", "Individual saham", "Car (depreciating)", "riil estate", "Lifestyle sneakers"]}, "parameters": {}, "question": "Sort each item into the benar aset classification:", "type": "categorization"}'::jsonb
WHERE id = 'd461ffe0-5d99-48c7-9ed3-521c172204c7'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "SIPF", "difficulty": "intermediate", "explanation": "SIPF (Securities Investor Protection Fund) melindungi dana investor di perusahaan sekuritas.", "options": ["SIPF", "BI Rate", "PPN", "OJK tax"], "parameters": {}, "question": "Apa yang melindungi investor jika perusahaan sekuritas bangkrut?", "type": "multiple_choice"}'::jsonb
WHERE id = 'a89ff3c4-c476-4764-8b69-dc6975c90417'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"alpha": "Excess return relative to a benchmark", "beta": "Sensitivity of a saham''s returns to market movements", "Sharpe Ratio": "risiko-adjusted return measuring excess return per unit of risiko", "Standard Deviation": "A measure of the dispersion of returns around the mean"}, "difficulty": "intermediate", "explanation": "benar matches: alpha = Excess return relative to a benchmark, beta = Sensitivity of a saham''s returns to market movements, Sharpe Ratio = risiko-adjusted return measuring excess return per unit of risiko, Standard Deviation = A measure of the dispersion of returns around the mean", "options": {"definitions": ["Excess return relative to a benchmark", "Sensitivity of a saham''s returns to market movements", "risiko-adjusted return measuring excess return per unit of risiko", "A measure of the dispersion of returns around the mean"], "terms": ["alpha", "beta", "Sharpe Ratio", "Standard Deviation"]}, "parameters": {}, "question": "Match each risiko/return measure with its meaning:", "type": "definition_match"}'::jsonb
WHERE id = '24f65b92-e9d8-4083-b74e-52bbbd86ba38'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"Deflation": "A sustained decrease in the general price level", "Hyperinflation": "Extremely rapid and out-of-control price increases", "inflasi": "A sustained increase in the general price level of goods and services", "Stagflation": "A period of high inflasi combined with economic stagnation"}, "difficulty": "intermediate", "explanation": "benar matches: inflasi = A sustained increase in the general price level of goods and services, Deflation = A sustained decrease in the general price level, Stagflation = A period of high inflasi combined with economic stagnation, Hyperinflation = Extremely rapid and out-of-control price increases", "options": {"definitions": ["A sustained increase in the general price level of goods and services", "A sustained decrease in the general price level", "A period of high inflasi combined with economic stagnation", "Extremely rapid and out-of-control price increases"], "terms": ["inflasi", "Deflation", "Stagflation", "Hyperinflation"]}, "parameters": {}, "question": "Match each economic term with its benar definition:", "type": "definition_match"}'::jsonb
WHERE id = '0223f51c-fa3e-4176-8d7b-f33a6ee58b82'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Pay off semua credit card utang", "difficulty": "intermediate", "explanation": "benar path: Pay off semua credit card utang. This represents the most financially sound decision at this stage.", "options": ["Invest in saham for high returns", "Pay off semua credit card utang", "Build dana darurat", "Buy a new car"], "parameters": {"full_tree": {"scenario": "You unexpectedly receive Rp 100M. You have Rp 30M in credit card debt at 2.5% monthly interest, no emergency fund, and no investments.", "stages": [{"correct": "Pay off all credit card debt", "next": {"correct": "Build 6-month emergency fund", "next": {"correct": "Diversified index fund portfolio", "options": ["All in one stock", "Diversified index fund portfolio", "Keep in savings", "Lend to a friend"], "question": "With emergency fund set, Rp 50M remains. Final decision?"}, "options": ["Invest everything in crypto", "Build 6-month emergency fund", "Start a business", "Luxury vacation"], "question": "After paying debt, you have Rp 70M left. Next step?"}, "options": ["Invest in stocks for high returns", "Pay off all credit card debt", "Build emergency fund", "Buy a new car"], "question": "First priority: What do you do with the first portion?"}]}}, "question": "Decision Tree Scenario:\n\nYou unexpectedly receive Rp 100M. You have Rp 30M in credit card utang at 2.5% per bulan bunga, no dana darurat, and no investments.\n\nFirst priority: What do you do with the first portion?", "type": "decision_tree"}'::jsonb
WHERE id = '8467fd82-226e-493e-9050-61632a01cfc1'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Total compensation termasuk risiko", "difficulty": "intermediate", "explanation": "benar path: Total compensation termasuk risiko. This represents the most financially sound decision at this stage.", "options": ["Which office is nicer", "Total compensation termasuk risiko", "Which has better Instagram", "Friend''s opinion"], "parameters": {"full_tree": {"scenario": "You receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.", "stages": [{"correct": "Total compensation including risk", "next": {"correct": "Use expected value (probability-weighted)", "next": {"correct": "Depends on risk tolerance and obligations", "options": ["Startup for higher expected value", "Bank for stability", "Negotiate bank to Rp 12M", "Decline both, travel"], "question": "Expected value of startup package ≈ Rp 11M/month. Bank = Rp 10M. But you have Rp 5M/month expenses. Decision?"}, "options": ["Assume maximum value", "Use expected value (probability-weighted)", "Ignore it entirely", "Ask the CEO"], "question": "Startup equity could be worth Rp 500M or zero. How to value it?"}, "options": ["Which office is nicer", "Total compensation including risk", "Which has better Instagram", "Friend''s opinion"], "question": "First factor to evaluate?"}]}}, "question": "Decision Tree Scenario:\n\nYou receive a job offer: Rp 12M/month at a startup (equity included) vs Rp 10M/month at a stable bank.\n\nFirst factor to evaluate?", "type": "decision_tree"}'::jsonb
WHERE id = '108f3d08-76c4-44cd-af59-67e559071535'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "1 lot", "difficulty": "intermediate", "explanation": "Di IDX, pembelian saham minimal 1 lot yang berisi 100 lembar.", "options": ["1 lot", "0,5 lot", "10 lot", "Tidak ada minimum"], "question": "Berapa lot minimal yang bisa dibeli untuk satu saham di IDX?", "type": "multiple_choice"}'::jsonb
WHERE id = '77a8ad22-3dcc-4d89-8a40-4cdeefa47771'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": true, "difficulty": "intermediate", "explanation": "SIPF adalah mekanisme perlindungan investor di pasar modal sesuai ketentuan.", "question": "SIPF memberikan perlindungan bagi investor di pasar modal Indonesia.", "type": "true_false"}'::jsonb
WHERE id = 'd107ce71-ef08-4e0f-b42a-d1a2ed504944'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Membeli minimal 1 lot (100 lembar)", "difficulty": "intermediate", "explanation": "IDX menggunakan satuan lot, minimal 1 lot = 100 lembar.", "options": ["Membeli minimal 1 lot (100 lembar)", "Membeli tepat 75 lembar", "Menjual 25 lembar", "Meminjam saham dari broker"], "question": "Doni ingin membeli 75 lembar saham TLKM. Apa yang harus ia lakukan?", "type": "multiple_choice"}'::jsonb
WHERE id = '34d89769-e71b-47c7-8f55-534ac2eae7dc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "100", "difficulty": "intermediate", "explanation": "1 lot di Bursa Efek Indonesia terdiri dari 100 lembar saham.", "question": "Di IDX, 1 lot saham sama dengan _____ lembar saham.", "type": "fill_blank"}'::jsonb
WHERE id = 'a2095697-000e-4d07-9d3c-b2d515cc381a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "lower", "difficulty": "intermediate", "explanation": "diversifikasi reduces unsystematic (company-specific) risiko without sacrificing expected returns.", "options": ["higher", "lower", "equal", "unpredictable"], "parameters": {}, "question": "A diversified portofolio typically has ________ risiko than a concentrated portofolio with the same expected return.", "type": "sentence_completion"}'::jsonb
WHERE id = 'd50fda77-b085-40f8-8232-8ffe26727ff4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "decreases", "difficulty": "intermediate", "explanation": "riil return = nominal return - inflasi. If inflasi rises and nominal return is flat, riil return falls.", "options": ["increases", "decreases", "stays the same", "becomes irrelevant"], "parameters": {}, "question": "If inflasi rises while bunga rates stay flat, the riil return on savings ________.", "type": "sentence_completion"}'::jsonb
WHERE id = 'af5d5732-90fe-4b87-b238-26d6739a0bcb'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Moderate risiko tolerance", "difficulty": "intermediate", "explanation": "A 50/30/15/5 split between saham, obligasi, cash, and gold represents balanced risiko — neither too conservative nor too aggressive.", "options": ["Ultra-conservative", "Moderate risiko tolerance", "Aggressive growth seeker", "Speculative trader"], "parameters": {"image_description": "A pie chart showing asset allocation: 50% stocks, 30% bonds, 15% cash, 5% gold. Labels show this is a moderate risk portfolio."}, "question": "[IMAGE: A pie chart showing aset allocation: 50% saham, 30% obligasi, 15% cash, 5% gold. Labels show this is a moderate risiko portofolio.]\n\nWhat type of investor does this aset allocation most likely represent?", "type": "image_interpretation"}'::jsonb
WHERE id = '725d4eb7-3c05-4ce4-875e-29c4ff4af408'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "is not indicative of", "difficulty": "intermediate", "explanation": "Standard disclaimer: past performance does not guarantee future results. Markets are inherently uncertain.", "options": ["guarantees", "is not indicative of", "is the hanya predictor of", "selalu exceeds"], "parameters": {}, "question": "When evaluating an investasi, past performance ________ future results.", "type": "sentence_completion"}'::jsonb
WHERE id = '4abcb8af-a3fb-4c3a-8667-e8288020b2da'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Saham BBCA hari ini dibuka di Rp8.450, tertinggi Rp8.620, terendah Rp8.400, dan ditutup di Rp8.550. Volume 45 juta lembar. Open, high, low, close menunjukkan rentang harga, sedangkan volume menunjukkan seberapa aktif saham diperdagangkan."}'::jsonb
WHERE id = 'b35d054e-2feb-433b-8240-92644c266b9a'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Market cap menunjukkan nilai total perusahaan. Jika harga saham Rp1.000 dan ada 10 miliar lembar saham, market cap-nya Rp10 triliun. Volume tinggi artinya banyak transaksi."}'::jsonb
WHERE id = 'd5b59567-79cd-4d8f-8f0e-f699338425f1'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Volume menunjukkan likuiditas. Saham dengan volume tinggi lebih mudah dibeli dan dijual tanpa menggerakkan harga terlalu banyak."}'::jsonb
WHERE id = '1c335ff0-57be-4df0-b9f5-1be6fbc63d83'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Open adalah harga pembukaan, high/low adalah harga tertinggi/terendah, close adalah harga penutupan, volume adalah jumlah saham yang diperdagangkan, dan market cap adalah nilai pasar perusahaan."}'::jsonb
WHERE id = 'a2c8861f-f009-41b2-9453-691f5045c28e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "close", "difficulty": "intermediate", "explanation": "Close adalah harga terakhir saham diperdagangkan pada hari itu.", "question": "Harga penutupan saham disebut _____.", "type": "fill_blank"}'::jsonb
WHERE id = '8340025f-62e4-419c-ba73-5dffd40017d4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp950 - Rp1.100", "difficulty": "intermediate", "explanation": "Rentang harga adalah dari low (terendah) ke high (tertinggi), yaitu Rp950 hingga Rp1.100.", "options": ["Rp950 - Rp1.100", "Rp1.000 - Rp1.050", "Rp1.050 - Rp1.100", "Rp950 - Rp1.050"], "question": "Saham ABC dibuka Rp1.000, high Rp1.100, low Rp950, close Rp1.050. Berapa rentang harga hari itu?", "type": "multiple_choice"}'::jsonb
WHERE id = '4d26ddac-0efe-4b9c-92c5-805523b9b39c'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Volume tinggi hanya menunjukkan aktivitas perdagangan tinggi, bukan jaminan keuntungan.", "question": "Volume saham yang tinggi berarti saham tersebut pasti menguntungkan.", "type": "true_false"}'::jsonb
WHERE id = 'fb676a8c-34ec-4d02-ad5a-8f155b5af3fc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"High": "Harga tertinggi hari itu", "Market cap": "Nilai total perusahaan di pasar", "Open": "Harga saham saat pasar dibuka", "Volume": "Jumlah saham yang diperdagangkan"}, "difficulty": "intermediate", "explanation": "Memahami istilah dasar membaca halaman saham sangat penting sebelum berinvestasi.", "pairs": [["Open", "Harga saham saat pasar dibuka"], ["High", "Harga tertinggi hari itu"], ["Volume", "Jumlah saham yang diperdagangkan"], ["Market cap", "Nilai total perusahaan di pasar"]], "question": "Pasangkan istilah saham dengan artinya.", "type": "matching"}'::jsonb
WHERE id = '1617cfb0-6c0c-4b02-bad3-2480bbdc9e4d'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jika tujuan Rina membeli laptop dalam 1 tahun, sebagian besar dananya harus aman. Jika tujuannya pensiun 30 tahun lagi, ia bisa menambah saham dan reksa dana saham."}'::jsonb
WHERE id = '9cef2e89-e351-4b5a-98bd-bfe990f2b15e'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina memiliki Rp10.000.000: Rp3 juta di tabungan, Rp4 juta di reksa dana pasar uang, dan Rp3 juta di satu saham. Ini adalah portofolio, meskipun masih perlu diversifikasi lebih baik."}'::jsonb
WHERE id = 'e25241f2-5b10-4e97-ae3e-fc5a0f2addff'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Portofolio adalah gabungan semua aset yang kita miliki. Memikirkan portofolio berarti mempertimbangkan keseluruhan, bukan hanya satu aset."}'::jsonb
WHERE id = '7d1444b8-993e-47cb-b2d1-387be70a81ff'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Komposisi portofolio harus sesuai dengan tujuan dan horizon waktu. Tujuan jangka pendek perlu aset aman; tujuan jangka panjang bisa menahan fluktuasi."}'::jsonb
WHERE id = 'c2df85fa-c1e4-4f5e-929f-16e40a1ae249'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Portofolio harus disesuaikan dengan tujuan, horizon waktu, dan toleransi risiko masing-masing.", "question": "Komposisi portofolio harus sama untuk semua orang regardless tujuan keuangan.", "type": "true_false"}'::jsonb
WHERE id = '0cf7b56f-09c6-42bb-86b9-fdd31d191361'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Gabungan semua aset yang dimiliki", "difficulty": "intermediate", "explanation": "Portofolio mencakup tabungan, deposito, saham, reksa dana, dan aset lain yang kita miliki.", "options": ["Gabungan semua aset yang dimiliki", "Satu saham yang paling bagus", "Tabungan di satu bank", "Utang yang dimiliki"], "question": "Apa yang dimaksud dengan portofolio?", "type": "multiple_choice"}'::jsonb
WHERE id = '048d7456-8a6a-432e-b502-9354b98c3419'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "berisiko", "difficulty": "intermediate", "explanation": "Waktu panjang memungkinkan kita menahan fluktuasi aset berisiko untuk potensi imbal hasil lebih tinggi.", "question": "Untuk tujuan jangka panjang, portofolio bisa memiliki lebih banyak aset yang berpotensi tumbuh meski lebih _____.", "type": "fill_blank"}'::jsonb
WHERE id = 'd525b34a-2f38-4860-bea1-8a8e92890b01'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Portofolio Rina terlalu konservatif untuk horizon waktu panjang.", "caseText": "Rina berusia 19 tahun, ingin pensiun di usia 50 tahun. Saat ini ia menempatkan 100% uangnya di tabungan dengan bunga 3%. Inflasi rata-rata 4%.", "difficulty": "intermediate", "explanation": "Portofolio harus disesuaikan dengan tujuan dan waktu. Untuk pensiun jangka panjang, perlu aset yang berpotensi tumbuh lebih tinggi.", "followUp": {"answer": "Tabungan tidak mengimbangi inflasi untuk tujuan jangka panjang", "explanation": "Untuk tujuan jangka panjang, tabungan dengan bunga rendah bisa kehilangan daya beli karena inflasi.", "options": ["Tabungan tidak mengimbangi inflasi untuk tujuan jangka panjang", "Tabungan terlalu berisiko", "Tabungan sudah cukup untuk tujuan jangka panjang", "Inflasi tidak berpengaruh pada tabungan"], "question": "Apa masalah utama portofolio Rina?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = '0f782703-54ff-4292-a678-08fa6d7fdf70'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Sebuah reksa dana mengiklankan imbal hasil 10% per tahun. Setelah pajak final atas bunga atau dividen, imbal hasil bersih yang diterima investor bisa lebih rendah, misalnya 8,5%."}'::jsonb
WHERE id = '1d0a6089-7924-4db3-8916-a184fc92ce4b'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Doni mendapat bunga deposito Rp500.000 dan dividen saham Rp1.000.000. Pemerintah mengenakan pajak atas penghasilan tersebut. Setelah pajak, uang yang benar-benar ia terima lebih kecil dari angka kotor."}'::jsonb
WHERE id = '0e2e3139-b003-4eda-a09f-bc48c7ed0074'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Jenis imbal hasil yang bisa kena pajak di Indonesia antara lain bunga deposito, dividen, dan capital gain sesuai ketentuan perpajakan yang berlaku."}'::jsonb
WHERE id = '5e17f295-6bc3-479d-a0da-9ec5708e90cc'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Pajak atas imbal hasil investasi mengurangi keuntungan bersih yang kita terima. Oleh karena itu, bandingkan imbal hasil bersih, bukan hanya angka kotor."}'::jsonb
WHERE id = '5bdc521c-4a2f-4de2-8555-614ff8ac9147'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "pajak", "difficulty": "advanced", "explanation": "Pemerintah mengenakan pajak atas beberapa jenis imbal hasil investasi.", "question": "Pendapatan dari dividen dan bunga deposito bisa dikenakan _____ sesuai ketentuan.", "type": "fill_blank"}'::jsonb
WHERE id = '9736c4e3-1315-416f-9075-98accd997ccc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "Imbal hasil kotor belum memperhitungkan pajak, biaya, dan potensi perubahan harga.", "question": "Imbal hasil yang diiklankan produk investasi sudah pasti sama dengan yang diterima investor.", "type": "true_false"}'::jsonb
WHERE id = 'ececba83-82b0-46a1-b174-59f4115dcc48'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Rp900.000", "difficulty": "advanced", "explanation": "Pajak 10% dari Rp1.000.000 adalah Rp100.000, sehingga bersihnya Rp900.000.", "options": ["Rp900.000", "Rp1.100.000", "Rp800.000", "Rp1.000.000"], "question": "Doni mendapat dividen kotor Rp1.000.000 dan pajak 10%. Berapa dividen bersihnya?", "type": "multiple_choice"}'::jsonb
WHERE id = '45e594d4-6e4b-4c70-b9b6-38535e8c05bc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena pajak mengurangi imbal hasil bersih", "difficulty": "advanced", "explanation": "Imbal hasil kotor bisa lebih tinggi dari imbal hasil bersih setelah pajak.", "options": ["Karena pajak mengurangi imbal hasil bersih", "Karena pajak menambah imbal hasil", "Karena pajak hanya untuk perusahaan", "Karena pajak tidak berlaku untuk investor kecil"], "question": "Mengapa penting memperhitungkan pajak saat membandingkan imbal hasil?", "type": "multiple_choice"}'::jsonb
WHERE id = '5e4b73d1-354e-4b17-ad3a-f6c81238675f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bank Indonesia menaikkan BI Rate. Bunga deposito bank bisa naik, sehingga menabung lebih menguntungkan. Namun, biaya pinjaman juga naik dan harga saham bisa lebih volatile. Indikator makro ini memengaruhi keputusan keuangan."}'::jsonb
WHERE id = 'f4670b72-4212-454d-88e3-cadc7b03532e'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Ketika nilai tukar rupiah melemah terhadap dolar AS, harga gadget impor seperti smartphone atau laptop bisa naik. Inflasi yang tinggi membuat harga mie ayam dan bensin naik. Kedua indikator ini memengaruhi daya beli."}'::jsonb
WHERE id = '96fc07ba-5230-4650-9673-7b8817856b52'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Indikator makro seperti BI Rate, inflasi, dan nilai tukar memengaruhi ekonomi secara keseluruhan dan berdampak pada investasi serta daya beli."}'::jsonb
WHERE id = '111850a1-1d9c-4d4d-b205-7fc1fde2cd41'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Investor pemula tidak perlu mencoba menaklukkan indikator makro. Yang bisa dikontrol adalah tujuan, diversifikasi, dan disiplin menabung."}'::jsonb
WHERE id = '7b3159b2-4ff9-4f0e-bd64-efac2d1f3941'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena sulit diprediksi secara konsisten", "difficulty": "advanced", "explanation": "Tidak ada yang secara konsisten memprediksi pergerakan makro; fokus pada yang bisa dikontrol.", "options": ["Karena sulit diprediksi secara konsisten", "Karena indikator makro tidak penting", "Karena hanya bank yang terpengaruh", "Karena indikator makro tidak berubah"], "question": "Mengapa investor pemula tidak perlu mencoba ''timing'' indikator makro?", "type": "multiple_choice"}'::jsonb
WHERE id = '584ca181-c868-4f85-8c0b-5cc32bbccf83'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "Inflasi tinggi menggerus daya beli karena harga barang naik.", "question": "Inflasi tinggi selalu meningkatkan daya beli uang.", "type": "true_false"}'::jsonb
WHERE id = 'f23d2d24-3b2d-4f29-b3e9-3c5732b6a1fd'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "BI", "difficulty": "advanced", "explanation": "BI Rate adalah suku bunga acuan yang memengaruhi bunga pinjaman dan tabungan.", "question": "Bank Indonesia mengatur suku bunga acuan yang disebut _____ Rate.", "type": "fill_blank"}'::jsonb
WHERE id = '149c1e73-282c-430c-83e0-5d82669101af'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": {"BI Rate naik": "Bunga tabungan/deposito cenderung naik", "Inflasi tinggi": "Daya beli uang menurun", "Rupiah melemah": "Harga barang impor cenderung naik"}, "difficulty": "advanced", "explanation": "Indikator makro saling terkait dan memengaruhi keuangan pribadi.", "pairs": [["BI Rate naik", "Bunga tabungan/deposito cenderung naik"], ["Inflasi tinggi", "Daya beli uang menurun"], ["Rupiah melemah", "Harga barang impor cenderung naik"]], "question": "Pasangkan indikator makro dengan dampaknya.", "type": "matching"}'::jsonb
WHERE id = 'def9e811-af63-416e-abd9-521b0aa92d5f'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rina melihat sahamnya turun 5%. Karena takut rugi lebih besar, ia langsung menjual. Padahal tujuannya investasi jangka panjang dan penurunan itu normal. Loss aversion membuatnya bereaksi berlebihan."}'::jsonb
WHERE id = '8750708a-9e0c-403a-8b64-c22b43b518e6'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Semua teman Bayu membeli saham GOTO karena viral di TikTok. Bayu takut ketinggalan (FOMO) dan ingin membeli juga, meski tidak tahu fundamental perusahaannya. Di saat yang sama, ia takut rugi (loss aversion). Kedua bias ini mengaburkan pertimbangannya."}'::jsonb
WHERE id = '9dea08b5-ac2e-4be5-bea4-33be2dc5982b'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Bias perilaku adalah pola pikir yang menyimpangkan keputusan keuangan. Contohnya FOMO, loss aversion, dan herd behavior (mengikuti kerumunan)."}'::jsonb
WHERE id = '5181d92f-5934-4f5b-8aa2-10453fc0fa2c'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Mengenali bias membantu kita membuat keputusan lebih tenang. Caranya: kembali ke tujuan awal, lakukan riset, dan hindari keputusan besar saat emosi tinggi."}'::jsonb
WHERE id = 'ee457d87-7f28-45ae-a77f-a6feb12bb534'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Lebih takut rugi daripada senang untung", "difficulty": "advanced", "explanation": "Loss aversion membuat kita merasakan penderitaan kerugian lebih besar daripada kegembiraan keuntungan.", "options": ["Lebih takut rugi daripada senang untung", "Suka kehilangan uang", "Tidak peduli dengan kerugian", "Selalu membeli saham yang turun"], "question": "Loss aversion adalah kecenderungan untuk ...", "type": "multiple_choice"}'::jsonb
WHERE id = '7085ba9a-3231-4e53-9a05-00cf3ffabecf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Out", "difficulty": "advanced", "explanation": "FOMO adalah takut ketinggalan kesempatan, yang sering mendorong keputusan impulsif.", "question": "FOMO adalah kepanjakan dari Fear Of Missing _____.", "type": "fill_blank"}'::jsonb
WHERE id = '1dce8489-7003-478e-bf24-a1e88e04ea62'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "Herd behavior bisa berbahaya jika keputusan didasarkan pada FOMO, bukan analisis.", "question": "Mengikuti tren media sosial tanpa riset adalah contoh herd behavior yang sehat.", "type": "true_false"}'::jsonb
WHERE id = 'cfd0730f-511d-4ec9-87ea-89bb977f445b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Bayu mengambil keputusan berdasarkan emosi, bukan analisis.", "caseText": "Bayu melihat semua temannya membeli saham GOTO karena viral di TikTok. Ia takut ketinggalan untung, tetapi juga takut kehilangan uang. Ia belum memahami bisnis perusahaan.", "difficulty": "advanced", "explanation": "Bias perilaku bisa merusak rencana keuangan. Bayu sebaiknya kembali ke tujuan dan riset sebelum membeli saham.", "followUp": {"answer": "FOMO dan loss aversion", "explanation": "Bayu termakan tren (FOMO) dan takut rugi (loss aversion), yang mengaburkan riset.", "options": ["FOMO dan loss aversion", "Tidak ada bias", "Keputusan rasional murni", "Diversifikasi berlebihan"], "question": "Bias apa yang dominan pada Bayu?"}, "question": "Baca kasus berikut dan pilih respons terbaik.", "type": "case_study"}'::jsonb
WHERE id = '8a90d924-9613-4c7e-805f-94ff739d5290'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Budi ingin memiliki rumah dalam 10 tahun. Ia membuat rencana: hitung kebutuhan dana, sisihkan setiap bulan, pilih instrumen investasi sesuai horizon, dan evaluasi setiap tahun."}'::jsonb
WHERE id = 'a9c1ccda-7c46-462a-9c71-50525fffb3c9'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Ani berusia 19 tahun, penghasilan Rp2,5 juta/bulan dari desain freelance, tanpa dana darurat, dan punya utang PayLater Rp2 juta. Rencananya: 1) buat dana darurat kecil, 2) bayar utang PayLater, 3) buat anggaran 50/30/20, 4) mulai asuransi kesehatan, 5) mulai investasi kecil."}'::jsonb
WHERE id = 'e5578081-99f4-45b3-861e-560a0047279b'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rencana keuangan tidak harus sempurna sejak awal. Mulailah sederhana, lalu evaluasi dan sesuaikan seiring perubahan penghasilan dan tujuan."}'::jsonb
WHERE id = 'da916aef-39a8-4511-92d4-2770d5ea1655'::uuid;

UPDATE public.content_variants
SET body_id = '{"text": "Rencana keuangan mencakup tujuan, dana darurat, utang, proteksi, dan langkah investasi. Rencana membantu kita membuat keputusan yang selaras dengan tujuan jangka panjang."}'::jsonb
WHERE id = '102af6c8-55c1-46f0-aa4f-1591d5613917'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "advanced", "explanation": "Rencana keuangan harus dievaluasi dan disesuaikan secara berkala.", "question": "Rencana keuangan hanya perlu dibuat sekali seumur hidup.", "type": "true_false"}'::jsonb
WHERE id = '48141c0a-a344-4e4a-8c60-6b2f586c4337'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tetapkan tujuan", "Siapkan dana darurat", "Lunasi utang berbunga tinggi", "Pilih instrumen investasi sesuai tujuan"], "difficulty": "advanced", "explanation": "Mulai dari tujuan, lindungi dengan dana darurat, bebaskan dari utang berbunga tinggi, baru investasi.", "options": ["Tetapkan tujuan", "Siapkan dana darurat", "Lunasi utang berbunga tinggi", "Pilih instrumen investasi sesuai tujuan"], "question": "Urutkan langkah menyusun rencana keuangan dasar.", "type": "ordering"}'::jsonb
WHERE id = '639c01b7-9667-4624-8aad-4c3daf4b570f'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Prioritas pertama adalah proteksi dasar dan menghentikan spiral utang.", "caseText": "Ani, 19 tahun, penghasilan Rp2,5 juta/bulan, tidak punya dana darurat, punya utang PayLater Rp2 juta.", "difficulty": "advanced", "explanation": "Rencana keuangan dimulai dari fondasi: dana darurat, utang, anggaran, proteksi, baru investasi.", "followUp": {"answer": "Buat dana darurat kecil dan hentikan pembelian baru", "explanation": "Dana darurat kecil mencegah utang tambahan; menghentikan pembelian baru menghentikan spiral utang.", "options": ["Buat dana darurat kecil dan hentikan pembelian baru", "Langsung investasi di saham", "Beli gadget baru untuk kerja", "Ajukan pinjaman baru untuk melunasi PayLater"], "question": "Langkah pertama apa yang paling penting?"}, "question": "Baca kasus berikut dan pilih urutan langkah terbaik.", "type": "case_study"}'::jsonb
WHERE id = '689144f6-9f59-42bf-bcd5-fdb0ffa87f6b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "berbunga tinggi", "difficulty": "advanced", "explanation": "Utang berbunga tinggi bisa menghapus keuntungan investasi, sehingga perlu dikendalikan terlebih dahulu.", "question": "Sebelum berinvestasi, pastikan dana darurat sudah tersedia dan utang _____ sudah terkendali.", "type": "fill_blank"}'::jsonb
WHERE id = '723db299-1994-4dbf-8a1b-f1290c9bd2d3'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Sebuah survei menunjukkan banyak investor pemula di Indonesia lebih takut \"rugi Rp 100.000\" daripada senang \"untung Rp 100.000\". Perasaan tidak simetris ini membuat mereka sering menjual saham bagus terlalu dini."}'::jsonb
WHERE id = '6dec2386-d58e-47ab-b49f-4c82c090587b'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Bayu membeli saham BBRI dan menahan kerugian 10% selama tiga bulan. Perasaannya seperti kehilangan, meskipun jumlahnya sama dengan biaya makan sebulan. Loss aversion membuatnya ingin segera menjual, padahal harga akhirnya pulih."}'::jsonb
WHERE id = 'aa9ae455-3d92-4850-a649-e45e1628dfb9'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Budi punya saham BBCA seharga Rp 9.000 per lembar. Saat harga turun ke Rp 8.600, ia merasa \"rugi besar\" meski turunnya baru sekitar 4%. Loss aversion membuatnya ingin segera menjual, padahal fundamental bank tetap kuat."}'::jsonb
WHERE id = '8b576b44-61ca-41f5-b392-eb8ce1fc9c7d'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Pak Tono menabung Rp 50 juta di deposito BCA dengan imbal hasil yang stabil. Temannya bilang \"rugi\" karena saham bisa untung lebih besar, tapi Pak Tono merasa nyaman karena tidak kuatir harga turun setiap hari. Setiap orang punya batas aversi rugi yang berbeda."}'::jsonb
WHERE id = '94e6cad2-938a-4519-92d6-44e31b577479'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Salsa membeli saham BBRI dan TLKM sebagai bagian portofolio jangka panjang. Setiap kali ada berita negatif, ia panik mau jual. Temannya mengingatkan: rasa takut rugi boleh ada, tapi jangan biarkan emosi mengganti rencana yang sudah dibuat saat tenang."}'::jsonb
WHERE id = '57489e26-52d8-4cbe-843e-207d55bc6d79'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Sebuah grup Telegram ramai membahas token kripto baru yang katanya \"pasti naik\". Andi ikut membeli Rp 1.500.000 karena takut ketinggalan. Setelah hype mereda, harga turun 60%. Andi belajar bahwa FOMO sering datang tanpa data yang jelas."}'::jsonb
WHERE id = '9ee94ba5-d305-45e4-b527-7864f90cd3aa'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Rina memiliki reksa dana pasar uang dan saham UNVR. Ketika portofolionya turun Rp 200.000, ia lebih ingat kerugian itu daripada untung Rp 200.000 minggu lalu. Perasaan tidak simetris inilah yang disebut loss aversion."}'::jsonb
WHERE id = '37c091b2-86cb-414c-a86a-6aef3972aeb1'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Fikri membuat aturan: hanya boleh membeli saham baru setelah membaca laporan keuangan minimal 15 menit. Aturan ini membantunya menolak FOMO ketika melihat postingan untung teman di media sosial."}'::jsonb
WHERE id = '7058f2c8-eba4-4873-83d8-827bc4592d46'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Di warung kopi kampus, semua teman Nia membahas saham GOTO yang naik 25% dalam seminggu. Nia langsung transfer Rp 2.000.000 dari GoPay ke aplikasi sekuritas tanpa baca prospektus. Dua minggu kemudian saham koreksi dan Nia sadar FOMO membuatnya lupa aturan riset dulu."}'::jsonb
WHERE id = '57ff2805-60aa-4980-8d02-99f37ba59770'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Teman Rina memposting screenshot untung 30% dari saham kripto baru. Rina merasa iri dan langsung membeli tanpa riset. Dua minggu kemudian harga kripto itu turun 40%. Pengalaman ini mengajarkan bahwa FOMO bisa lebih mahal dari biaya kuliah satu semester."}'::jsonb
WHERE id = '760a07ea-ebea-4362-ac45-98a8a0789676'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Bantu pengguna mengenali loss aversion dan FOMO, lalu buat aturan investasi pribadi sebelum emosi muncul.", "text": "Loss aversion dan FOMO adalah dua kekuatan emosional yang sering mengganggu keputusan investasi. Cara terbaik mengatasinya adalah membuat aturan sebelum membeli: tujuan investasi, batas kerugian yang bisa diterima, dan jadwal review. Jangan biarkan media sosial mengatur portofoliomu."}'::jsonb
WHERE id = '9fc5e28a-1a59-49dc-b47e-d4438b2d460a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tetapkan tujuan investasi", "Riset aset sebelum membeli", "Buat aturan kapan boleh jual", "Hindari cek harga berlebihan"], "difficulty": "intermediate", "explanation": "Mulai dari tujuan, riset, aturan jual, lalu kontrol emosi agar tidak overreact.", "options": ["Tetapkan tujuan investasi", "Riset aset sebelum membeli", "Buat aturan kapan boleh jual", "Hindari cek harga berlebihan"], "parameters": {}, "question": "Urutkan langkah menghadapi FOMO.", "type": "ordering"}'::jsonb
WHERE id = 'd3ca956a-7828-4901-95c0-7aae6e332d68'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Menjual saham bagus terlalu cepat karena takut rugi", "difficulty": "intermediate", "explanation": "aversi rugi sering membuat investor menjual aset padahal fundamentalnya masih baik.", "options": ["Menjual saham bagus terlalu cepat karena takut rugi", "Membeli saham dengan riset lengkap", "Menyebarkan investasi ke banyak sektor", "Menabung secara rutin setiap bulan"], "parameters": {}, "question": "aversi rugi paling terlihat ketika investor ...", "type": "multiple_choice"}'::jsonb
WHERE id = '6f1b6379-3409-4c08-ab8a-b1fc9f08e5ec'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Loss aversion menunjukkan rasa sakit kerugian biasanya lebih kuat dari rasa senang keuntungan yang sama besar.", "parameters": {}, "question": "Rasa sakit dari rugi Rp 100.000 biasanya sama besarnya dengan rasa senang untung Rp 100.000.", "type": "true_false"}'::jsonb
WHERE id = '9b4643a0-ed9b-48ef-bb1e-32cad5f9d194'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "aturan", "difficulty": "intermediate", "explanation": "Aturan yang dibuat saat tenang membantu menahan keputusan impulsif saat FOMO melanda.", "parameters": {}, "question": "Cara melawan FOMO adalah membuat _____ investasi sebelum emosi muncul.", "type": "fill_blank"}'::jsonb
WHERE id = '28b57497-aac8-4839-8ef5-48019e239738'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["membeli", "ketinggalan"], "difficulty": "intermediate", "explanation": "FOMO adalah rasa takut ketinggalan yang mendorong pembelian tanpa riset yang matang.", "options": ["membeli", "ketinggalan"], "parameters": {}, "question": "Lengkapi kalimat: \"FOMO membuat kita _____ aset karena takut _____.\"", "type": "word_bank"}'::jsonb
WHERE id = 'e9182774-5f10-4cc4-ae60-868f151211a9'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Buat alasan membeli sebelum transaksi", "Tentukan batas kerugian yang bisa diterima", "Jangan cek harga setiap menit", "Review portofolio sesuai jadwal"], "difficulty": "intermediate", "explanation": "Rencana sebelum transaksi, batas kerugian, kontrol cek harga, dan review terjadwal membantu mengelola emosi.", "options": ["Tentukan batas kerugian yang bisa diterima", "Buat alasan membeli sebelum transaksi", "Jangan cek harga setiap menit", "Review portofolio sesuai jadwal"], "parameters": {}, "question": "Urutkan langkah agar aversi rugi tidak menguasai keputusan.", "type": "ordering"}'::jsonb
WHERE id = '3039344a-1a4c-4e76-afc9-79fc61ae885a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["kerugian", "keuntungan"], "difficulty": "intermediate", "explanation": "Loss aversion menjadikan kerugian terasa lebih menyakitkan dibanding keuntungan.", "options": ["kerugian", "keuntungan"], "parameters": {}, "question": "Lengkapi kalimat: \"Aversi rugi membuat rasa sakit dari _____ terasa lebih besar dari rasa senang mendapatkan _____.\"", "type": "word_bank"}'::jsonb
WHERE id = 'bb3a8005-6b4e-4386-b356-1e2c930d316e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "riset", "difficulty": "intermediate", "explanation": "Riset mandiri membantu menghindari keputusan yang murni didorong oleh hype atau FOMO.", "parameters": {}, "question": "Sebelum membeli aset yang sedang viral, sebaiknya _____ terlebih dahulu.", "type": "fill_blank"}'::jsonb
WHERE id = '854fee0f-2d60-484e-9746-42341c8724d6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "FOMO justru sering menyebabkan pembelian impulsif tanpa riset yang memadai.", "parameters": {}, "question": "FOMO selalu menghasilkan keputusan investasi yang baik karena banyak orang yang melakukan.", "type": "true_false"}'::jsonb
WHERE id = 'e06d0291-cfbf-424d-9045-8acc05745324'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Takut rugi Rp 100.000 lebih kuat dari senang untung Rp 100.000", "difficulty": "intermediate", "explanation": "Loss aversion berarti rasa sakit kerugian lebih kuat dari rasa senang keuntungan yang sama besar.", "options": ["Senang untung Rp 100.000", "Takut rugi Rp 100.000 lebih kuat dari senang untung Rp 100.000", "Diversifikasi portofolio", "Menabung di deposito"], "parameters": {}, "question": "Manakah contoh aversi rugi?", "type": "multiple_choice"}'::jsonb
WHERE id = '1b4e86dc-e201-4666-bcda-76798df2c369'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Karena bisa mendorong pembelian tanpa riset yang cukup", "difficulty": "intermediate", "explanation": "FOMO membuat investor mengikuti tren tanpa riset mandiri, yang berisiko menyebabkan kerugian.", "options": ["Karena harga selalu turun", "Karena bisa mendorong pembelian tanpa riset yang cukup", "Karena saham viral tidak punya risiko", "Karena biaya transaksi selalu nol"], "parameters": {}, "question": "Kenapa FOMO berbahaya saat membeli saham viral?", "type": "multiple_choice"}'::jsonb
WHERE id = 'a6e43f6e-6fcd-438b-a680-5561f7841fbd'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Andi baru berinvestasi 3 bulan tetapi sudah merasa bisa mengalahkan pasar. Ia trading harian dengan uang Rp 10.000.000 dan kehilangan 15% dalam sebulan karena overconfidence dan biaya transaksi."}'::jsonb
WHERE id = 'f4e3039b-130f-445b-9809-9a6bca1fbe89'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Seorang trader di media sosial pamer untung Rp 50 juta dalam seminggu. Riko ingin meniru tapi tidak sadar modal dan pengalaman mereka berbeda. Overconfidence bisa muncul saat kita hanya melihat hasil bagus orang lain."}'::jsonb
WHERE id = '65c169bb-3e7c-4e80-ba4b-cd0a61478ec5'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Lina, karyawan baru dengan gaji Rp 7.000.000, langsung membeli saham GOTO dan beberapa saham gorengan karena yakin bisa \"main saham\". Dalam sebulan ia kehilangan 20% modal karena overtrading dan biaya transaksi."}'::jsonb
WHERE id = '4746696d-7635-45b6-ab84-419d9c39a352'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Dua orang dengan penghasilan sama bisa punya toleransi risiko berbeda. Yang punya tanggungan keluarga besar mungkin lebih konservatif, sementara yang single dan punya dana darurat bisa lebih agresif."}'::jsonb
WHERE id = '150878a9-a98f-4cf3-9d0b-f92a871ca8af'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Maya baru pertama kali berinvestasi dan langsung yakin bisa menganalisis laporan keuangan. Setelah rugi di saham pertamanya, ia sadar bahwa belajar bertahap lebih penting daripada percaya diri berlebihan."}'::jsonb
WHERE id = '274f115a-974e-4a98-b733-74250cc2f312'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Bank Indonesia mempublikasikan BI Rate yang memengaruhi suku bunga deposito dan imbal hasil obligasi. Investor yang paham konteks ini tidak panik mengganti strategi hanya karena satu berita."}'::jsonb
WHERE id = '42c3df35-1ee4-4042-8521-66118541ba76'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Investor yang terlalu percaya diri sering mengabaikan risiko dan membeli saham hanya berdasarkan rumor. Investor yang realistis memeriksa laporan keuangan dan tujuan jangka panjang sebelum membeli."}'::jsonb
WHERE id = 'ce5b30e1-2038-44d9-8629-a655f2eb7276'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953", "097b62c4-9aae-4933-a870-ac74a526b8f1"], "text": "Pak Harto, pensiunan PNS, memilih deposito dan obligasi pemerintah meski imbal hasilnya lebih rendah dari saham. Ia tidur nyenyak karena tidak kuatir fluktuasi harian. Profil risikonya berbeda dengan anak muda."}'::jsonb
WHERE id = '7d758ea9-5ba4-4ab1-9718-996edf2696b7'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["f7003b72-8158-4a9e-a853-1c3bf914ea4a"], "text": "Siti mahasiswa punya dana darurat 6 bulan dan horizon investasi 10 tahun. Ia memilih campuran saham blue chip dan reksa dana. Temannya Fikri yang belum punya dana darurat sebaiknya fokus menabung dulu sebelum saham."}'::jsonb
WHERE id = '0c01a9c0-08ff-4026-9909-d56097bcb516'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["ad0e8258-4e0a-4378-b257-4fd3628c6953"], "text": "Dua mahasiswa dengan uang saku sama bisa punya profil risiko berbeda. Sisi yang punya dana darurat 6 bulan lebih siap menghadapi fluktuasi saham daripada Fikri yang baru mulai menabung."}'::jsonb
WHERE id = '08b0902a-4922-4bf5-b492-c075a545e505'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Bantu pengguna menilai toleransi risiko mereka dengan mempertimbangkan penghasilan, tanggungan, dan tujuan keuangan.", "text": "Toleransi risiko bukan tentang berani atau tidak berani, melainkan seberapa besar fluktuasi yang bisa kamu terima tanpa mengganggu tidur dan keuangan. Overconfidence bisa membuatmu overtrading. Kenali diri sendiri sebelum memilih instrumen."}'::jsonb
WHERE id = '161d4ffc-3f94-4cb3-a301-59ecb28d5442'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["profil", "gaya hidup"], "difficulty": "intermediate", "explanation": "Keputusan investasi harus disesuaikan dengan profil risiko pribadi, bukan gaya hidup influencer.", "options": ["profil", "gaya hidup"], "parameters": {}, "question": "Lengkapi: \"Pilih instrumen sesuai _____ risiko sendiri, bukan mengikuti _____ orang lain.\"", "type": "word_bank"}'::jsonb
WHERE id = '6bb4ef6d-1319-4973-9709-9fb6b8c86881'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Usia, penghasilan, dan tujuan keuangan", "difficulty": "intermediate", "explanation": "Toleransi risiko bergantung pada kondisi pribadi, bukan popularitas atau tren.", "options": ["Jumlah follower di Instagram", "Usia, penghasilan, dan tujuan keuangan", "Warna logo saham", "Jumlah teman yang trading"], "parameters": {}, "question": "Faktor yang memengaruhi toleransi risiko termasuk ...", "type": "multiple_choice"}'::jsonb
WHERE id = '764d55e3-aadc-408f-a899-2bff75554281'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Overconfidence cenderung menyebabkan overtrading dan meremehkan risiko.", "parameters": {}, "question": "Overconfidence biasanya membuat investor lebih berhati-hati dan jarang bertransaksi.", "type": "true_false"}'::jsonb
WHERE id = '1aafccd0-b529-4189-aa1d-1fd7631d5f7b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "profil", "difficulty": "intermediate", "explanation": "Profil risiko pribadi menentukan instrumen yang paling sesuai dengan kondisimu.", "parameters": {}, "question": "Pilih instrumen investasi sesuai dengan _____ risiko sendiri, bukan mengikuti influencer.", "type": "fill_blank"}'::jsonb
WHERE id = 'a8724e4a-ea98-44a3-9b2e-d4a3b9a3d3fe'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["agresif", "konservatif"], "difficulty": "intermediate", "explanation": "Horizon panjang memungkinkan investor muda menahan risiko lebih besar; pensiunan biasanya memerlukan stabilitas.", "options": ["agresif", "konservatif"], "parameters": {}, "question": "Lengkapi: \"Investor muda dengan horizon panjang biasanya bisa lebih _____, sementara pensiunan cenderung lebih _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '4fe83503-a476-4a57-80d9-e3de81fa5dda'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Evaluasi penghasilan dan tanggungan", "Tentukan tujuan dan horizon waktu", "Kenali reaksi emosional saat rugi", "Pilih instrumen yang sesuai"], "difficulty": "intermediate", "explanation": "Kenali kondisi keuangan, tujuan, reaksi emosi, lalu pilih instrumen yang cocok.", "options": ["Evaluasi penghasilan dan tanggungan", "Tentukan tujuan dan horizon waktu", "Kenali reaksi emosional saat rugi", "Pilih instrumen yang sesuai"], "parameters": {}, "question": "Urutkan langkah menentukan profil risiko.", "type": "ordering"}'::jsonb
WHERE id = '1693b54c-64e0-4660-982d-7ee60fc7dc19'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Bertransaksi terlalu sering dan meremehkan risiko", "difficulty": "intermediate", "explanation": "Overconfidence sering membuat investor overtrading dan mengabaikan risiko.", "options": ["Bertransaksi terlalu sering dan meremehkan risiko", "Menabung dengan disiplin", "Selalu memeriksa laporan keuangan", "Mendiversifikasi portofolio dengan hati-hati"], "parameters": {}, "question": "Investor yang overconfidence cenderung ...", "type": "multiple_choice"}'::jsonb
WHERE id = '9407f0eb-2853-4d51-91c8-8e8d3e1af191'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Deposito dan obligasi pemerintah", "difficulty": "intermediate", "explanation": "Profil risiko pensiunan biasanya lebih konservatif karena membutuhkan stabilitas.", "options": ["Saham spekulatif", "Deposito dan obligasi pemerintah", "Kripto dengan volatilitas tinggi", "Saham gorengan"], "parameters": {}, "question": "Pensiunan yang bergantung pada tabungan sebaiknya cenderung memilih instrumen ...", "type": "multiple_choice"}'::jsonb
WHERE id = '76553c1e-4365-464b-b82d-b047ed73c863'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Toleransi risiko juga dipengaruhi tanggungan, dana darurat, tujuan, dan reaksi emosional.", "parameters": {}, "question": "Toleransi risiko setiap orang pasti sama jika penghasilannya sama.", "type": "true_false"}'::jsonb
WHERE id = 'a0aeada8-0612-40d0-aa5a-22ceb28782b4'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "agresif", "difficulty": "intermediate", "explanation": "Horizon waktu panjang memberi kesempatan untuk menahan fluktuasi pasar.", "parameters": {}, "question": "Investor muda dengan horizon panjang biasanya bisa mempertimbangkan profil sedikit lebih _____.", "type": "fill_blank"}'::jsonb
WHERE id = '0ca2c32e-5651-46ac-9370-e79800087076'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Hitung dana darurat dan tanggungan", "Tentukan horizon waktu investasi", "Uji reaksi emosi saat portofolio turun", "Pilih instrumen yang sesuai"], "difficulty": "intermediate", "explanation": "Kenali kondisi keuangan, horizon, reaksi emosi, lalu pilih instrumen yang cocok.", "options": ["Hitung dana darurat dan tanggungan", "Tentukan horizon waktu investasi", "Uji reaksi emosi saat portofolio turun", "Pilih instrumen yang sesuai"], "parameters": {}, "question": "Urutkan langkah menilai toleransi risiko.", "type": "ordering"}'::jsonb
WHERE id = '993dc340-a8db-434e-be08-eafcc96848d0'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Nadia membeli saham UNVR dan menetapkan aturan hanya boleh cek aplikasi sekali seminggu. Aturan ini mengurangi keinginannya untuk bereaksi setiap kali harga berubah sedikit."}'::jsonb
WHERE id = '719890f8-3e54-47cf-8d98-b765438b910a'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1", "c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Bank Indonesia sering mengumumkan suku bunga (BI Rate) yang bisa memengaruhi pergerakan harga saham perbankan seperti BBCA dan BBRI. Perubahan ini menambah volatilitas pasar, terutama di sektor keuangan."}'::jsonb
WHERE id = 'eecc47e1-f6fd-4c13-a6f4-f48f1450dd07'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Rina membuat jurnal investasi: setiap kali ingin jual, ia harus tulis alasannya. Jurnal ini membuatnya sadar bahwa banyak keinginan jual muncul dari emosi, bukan perubahan fundamental."}'::jsonb
WHERE id = '1e085705-92ef-47ab-9b76-4ce0ff7d5221'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Dimas menetapkan aturan: hanya cek portofolio setiap minggu dan hanya jual jika alasan membeli berubah. Aturan sederhana ini membantunya tidak overreact saat saham turun 5%."}'::jsonb
WHERE id = 'ee7a5725-c524-4f03-a619-a8dd3a1ad4cf'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Saham GOTO bisa naik 8% dalam sehari dan turun 7% di hari berikutnya. Fluktuasi harian seperti ini normal untuk saham dengan pertumbuhan tinggi. Investor jangka panjang tidak perlu panik setiap kali harga bergerak."}'::jsonb
WHERE id = '6587bda6-a9bb-4022-91e0-d921275cd99d'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["097b62c4-9aae-4933-a870-ac74a526b8f1", "c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Ketika Bank Indonesia menaikkan BI Rate, harga saham perbankan seperti BBCA dan BBRI sering bergerak lebih aktif. Bagi investor yang paham, ini volatilitas terkait kebijakan moneter, bukan tanda perusahaan bermasalah."}'::jsonb
WHERE id = 'ec780bc8-bf48-4a33-8669-91ac88c3bf34'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Seorang investor FOMO membeli GOTO saat naik 15% dalam seminggu. Ternyata harga kemudian koreksi. Ia belajar bahwa euforia pendek bisa menjadi volatilitas yang menyakitkan."}'::jsonb
WHERE id = '89da55fd-b46e-4139-9ed6-e56232e11053'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["c7c57d03-733f-4fe8-bd15-ce3a1cd4a760"], "text": "Kelas investasi kampus belajar bahwa volatilitas tidak sama dengan kerugian permanen. Kerugian baru terjadi jika kita menjual saat harga di bawah harga beli karena panik."}'::jsonb
WHERE id = '23ba2ff6-8220-425c-a253-fd9ede922a75'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Ahmad memiliki portofolio saham blue chip dan reksa dana. Saat pasar turun 5% dalam sebulan, portofolionya turun 3%. Ia tidak panik karena sudah memahami volatilitas dan punya rencana."}'::jsonb
WHERE id = '68e6e867-58e5-47f1-98af-62a1ad5d4f32'::uuid;

UPDATE public.content_variants
SET body_id = '{"source_ids": ["5fa2799e-2b92-46e8-b68a-c9d64847410c"], "text": "Saham TLKM dalam satu kuartal bisa naik dari Rp 3.800 ke Rp 4.200 lalu turun ke Rp 3.900. Investor jangka panjang melihat fluktuasi ini sebagai hal normal, bukan sinyal untuk panik."}'::jsonb
WHERE id = 'c8b09c3c-a400-4499-a3ba-e2b6b688f89f'::uuid;

UPDATE public.content_variants
SET body_id = '{"ai_assist_context": "Jelaskan volatilitas sebagai gejala normal pasar dan bantu pengguna membuat rencana mengendalikan emosi.", "text": "Volatilitas adalah bagian normal dari investasi saham. Yang penting bukan menghilangkan fluktuasi, tapi mengendalikan reaksi emosi. Buat rencana, tetapkan batasan cek harga, dan fokus pada tujuan jangka panjang."}'::jsonb
WHERE id = '64666f95-c038-40bc-ad30-c99b6cb8e76a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Volatilitas saham perbankan dan imbal hasil obligasi", "difficulty": "intermediate", "explanation": "Suku bunga acuan memengaruhi sektor keuangan dan instrumen pendapatan tetap.", "options": ["Hanya harga emas", "Volatilitas saham perbankan dan imbal hasil obligasi", "Jumlah follower influencer", "Warna grafik saham"], "parameters": {}, "question": "Kebijakan BI Rate yang berubah bisa memengaruhi ...", "type": "multiple_choice"}'::jsonb
WHERE id = '05a4e48c-af4d-4a85-8762-81884e5464e6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Buat rencana investasi", "Tetapkan batasan cek harga", "Fokus pada tujuan jangka panjang", "Hindari keputusan saat emosi tinggi"], "difficulty": "intermediate", "explanation": "Rencana, batasan, fokus tujuan, dan kontrol emosi membantu menghadapi volatilitas.", "options": ["Buat rencana investasi", "Tetapkan batasan cek harga", "Fokus pada tujuan jangka panjang", "Hindari keputusan saat emosi tinggi"], "parameters": {}, "question": "Urutkan cara menghadapi volatilitas.", "type": "ordering"}'::jsonb
WHERE id = '54177567-1072-4f01-98ab-64bb8a08128b'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["naik turun harga", "tanggung jawab investor"], "difficulty": "intermediate", "explanation": "Kita tidak bisa mengendalikan pasar, tapi bisa mengendalikan reaksi diri sendiri.", "options": ["naik turun harga", "tanggung jawab investor"], "parameters": {}, "question": "Lengkapi: \"Volatilitas adalah _____, sedangkan kontrol emosi adalah _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '0642a816-0d92-4eb9-a23b-f5db0adbe041'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "emosional", "difficulty": "intermediate", "explanation": "Reaksi emosional berlebihan bisa menyebabkan jual di bawah harga wajar.", "parameters": {}, "question": "Risiko terbesar investor jangka panjang sering kali adalah reaksi _____ yang berlebihan.", "type": "fill_blank"}'::jsonb
WHERE id = '80670f4a-2d37-4e5f-901b-e31fdd8b909e'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Volatilitas harian normal di pasar saham; yang penting adalah reaksi jangka panjang investor.", "parameters": {}, "question": "Volatilitas harian selalu berarti investasi tersebut buruk.", "type": "true_false"}'::jsonb
WHERE id = 'd0f4b73c-6bd1-4d82-8b91-017b2bc3b4bf'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Naik turunnya harga aset", "difficulty": "intermediate", "explanation": "Volatilitas menunjukkan seberapa besar harga aset berfluktuasi dalam suatu periode.", "options": ["Jumlah dividen", "Naik turunnya harga aset", "Pajak investasi", "Jumlah lembar saham"], "parameters": {}, "question": "Volatilitas mengukur ...", "type": "multiple_choice"}'::jsonb
WHERE id = '36e8f23e-8868-4314-a9bc-9aa7ee974f7d'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["Tetapkan batasan cek portofolio", "Ingat tujuan jangka panjang", "Evaluasi ulang alasan membeli", "Hindari keputusan besar saat emosi tinggi"], "difficulty": "intermediate", "explanation": "Batasi cek harga, ingat tujuan, evaluasi alasan, dan hindari keputusan saat emosi memuncak.", "options": ["Ingat tujuan jangka panjang", "Tetapkan batasan cek portofolio", "Evaluasi ulang alasan membeli", "Hindari keputusan besar saat emosi tinggi"], "parameters": {}, "question": "Urutkan langkah tetap tenang saat pasar volatil.", "type": "ordering"}'::jsonb
WHERE id = '46e19447-7376-4a97-a11d-563924f80771'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": ["pasar", "emosi"], "difficulty": "intermediate", "explanation": "Volatilitas pasar di luar kendali, tetapi reaksi emosional kita bisa dikelola.", "options": ["pasar", "emosi"], "parameters": {}, "question": "Lengkapi: \"Kita tidak bisa mengendalikan _____, tapi bisa mengendalikan _____.\"", "type": "word_bank"}'::jsonb
WHERE id = '9c8fcf35-23ef-407a-92e4-eafb89b2b74a'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "rencana", "difficulty": "intermediate", "explanation": "Rencana yang dibuat saat tenang membantu menghindari keputusan impulsif saat pasar bergejolak.", "parameters": {}, "question": "Cara mengendalikan emosi saat volatilitas tinggi adalah membuat _____ investasi dan batasan cek harga.", "type": "fill_blank"}'::jsonb
WHERE id = '0c041de3-4d16-4b4a-ad81-99c49ad1e8c6'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": false, "difficulty": "intermediate", "explanation": "Volatilitas adalah fluktuasi harga. Kerugian nyata terjadi jika menjual saat harga lebih rendah dari harga beli.", "parameters": {}, "question": "Volatilitas selalu sama dengan kerugian nyata.", "type": "true_false"}'::jsonb
WHERE id = 'eed421e3-dcfa-445f-bb2a-1bf2ef99bfcc'::uuid;

UPDATE public.content_variants
SET body_id = '{"answer": "Adalah hal normal dan tidak selalu buruk", "difficulty": "intermediate", "explanation": "Saham growth cenderung fluktuatif; yang penting adalah reaksi investor jangka panjang.", "options": ["Berarti perusahaan pasti bangkrut", "Adalah hal normal dan tidak selalu buruk", "Menjamin dividen besar", "Menunjukkan saham tidak boleh dimiliki"], "parameters": {}, "question": "Volatilitas harian yang tinggi pada saham growth seperti GOTO ...", "type": "multiple_choice"}'::jsonb
WHERE id = 'c199715c-9ae2-47ff-b63b-4332bf19886d'::uuid;
