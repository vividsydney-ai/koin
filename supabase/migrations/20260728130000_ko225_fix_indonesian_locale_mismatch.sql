-- KO-225: restore natural Indonesian copy for legacy example variants whose
-- body_id was accidentally left in English. Keep the English body unchanged.

UPDATE public.lessons
SET quiz_data_id = jsonb_set(
  quiz_data_id,
  '{0,options,2}',
  to_jsonb('Fokus hanya pada uang'::text)
)
WHERE slug = 'behavioral-bias-intro'
  AND is_published = TRUE
  AND quiz_data_id IS NOT NULL;

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Jika inflasi 5% per tahun, uang Rp 1.000.000 yang disimpan di bawah kasur tetap terlihat Rp 1.000.000 dalam sepuluh tahun, tetapi daya belinya jauh berkurang.'::text))
WHERE id = 'ec9d5c72-cff0-4f97-b4ba-dd3381c0766f';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Budi ingin membeli buku tulis seharga Rp 15.000. Ia tidak menukar makan siangnya; ia membayar dengan uang Rp 20.000 dan menerima kembalian Rp 5.000. Penjual menerima rupiah karena semua orang sepakat uang itu bernilai.'::text))
WHERE id = 'e99ca8ca-b403-47be-8016-196d5a0e54c2';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Pada 2020, seporsi nasi padang dekat kampus seharga Rp 15.000. Pada 2025, porsi yang sama menjadi Rp 22.000. Makanannya tidak bertambah besar; nilai beli rupiah yang menurun.'::text))
WHERE id = 'e4949c16-882d-4733-b679-e1a911859ed8';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Nia meminjam Rp 500.000 lewat aplikasi bayar nanti. Aplikasi itu mengenakan bunga 2% per bulan. Jika ia menunda pembayaran, utangnya menjadi Rp 510.000 setelah satu bulan dan terus bertambah.'::text))
WHERE id = 'df4ae9e3-c826-4ccb-8ac5-66686d19012f';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Andi menyimpan Rp 1.000.000 dalam deposito dengan bunga sederhana 5% per tahun. Setelah satu tahun, saldonya menjadi Rp 1.050.000. Jika bunganya majemuk, tahun berikutnya ia mendapat bunga dari Rp 1.050.000, bukan hanya dari modal awal Rp 1.000.000.'::text))
WHERE id = 'c7237687-f515-4990-97e7-5009949d353b';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Motor yang dipakai untuk mengantar makanan secara online menghasilkan pendapatan, jadi berfungsi seperti aset. Motor yang dibeli dengan kredit hanya untuk jalan-jalan akhir pekan menghabiskan biaya bensin, perawatan, dan bunga pinjaman, jadi lebih mirip liabilitas.'::text))
WHERE id = 'dedabf9c-06e9-4cc6-a33a-3adc97298cae';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Tidak berinvestasi juga punya risiko. Jika Lina menyimpan semua uangnya di rekening tabungan dengan bunga 1% sementara inflasi 4%, daya beli uangnya berkurang setiap tahun. Ini disebut risiko inflasi.'::text))
WHERE id = 'ed9a338c-4e6c-4e14-8ce8-f37b752a1986';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Dana darurat yang baik seperti ban serep. Kita berharap tidak perlu memakainya, tetapi saat membutuhkannya kita akan sangat terbantu. Dana ini harus mudah diambil dan disimpan di tempat yang aman.'::text))
WHERE id = 'd53f1ed4-0253-4d3e-a504-51532a8942cc';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Hana punya Rp 100.000 untuk hari itu. Makan siang Rp 20.000 adalah kebutuhan. Frappuccino Rp 45.000 adalah keinginan. Jika membeli frappuccino, uang untuk ongkos pulang berkurang. Melihat pilihan ini membantu Hana mengambil keputusan.'::text))
WHERE id = 'c4af25f0-8455-442a-832d-6556a9aa2ea7';

UPDATE public.content_variants
SET body_id = jsonb_set(body_id, '{text}', to_jsonb('Pinjaman pendidikan yang membantu seseorang mempelajari keterampilan yang banyak dibutuhkan bisa menjadi utang produktif jika pendapatan di masa depan cukup untuk melunasinya. Pinjaman untuk pesta atau liburan termasuk utang konsumtif karena tidak menghasilkan uang kembali.'::text))
WHERE id = 'abf53164-4fb3-4d50-a88b-3c06029335ab';
