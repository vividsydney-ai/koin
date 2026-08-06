-- KO-320: keep the visual practice pool usable after a learner requests
-- another check. Each published Chapter 08 lesson must have at least three
-- active, bilingual visual-applied questions.

BEGIN;

WITH additions(slug, question_en, question_id, options_en, options_id, explanation_en, explanation_id) AS (
  VALUES
    ('what-is-a-stock',
      'Which statement best describes what a stock gives its holder?',
      'Pernyataan mana yang paling tepat menjelaskan apa yang diberikan saham kepada pemegangnya?',
      jsonb_build_array('A partial ownership claim whose value can rise or fall.', 'A fixed repayment from the company on a scheduled date.', 'A guarantee that the holder will receive a profit.', 'An employee role with authority over company decisions.'),
      jsonb_build_array('Klaim kepemilikan sebagian yang nilainya dapat naik atau turun.', 'Pembayaran tetap dari perusahaan pada tanggal yang dijadwalkan.', 'Jaminan bahwa pemegang saham akan menerima keuntungan.', 'Peran karyawan dengan wewenang atas keputusan perusahaan.'),
      'A stock represents ownership exposure; its value and any return are not guaranteed.',
      'Saham menunjukkan eksposur kepemilikan; nilainya dan imbal hasilnya tidak dijamin.'),
    ('idx-basics-101',
      'An IDX stock is quoted at Rp 2,000. What does one standard lot represent before fees?',
      'Saham di IDX dikutip Rp 2.000. Apa arti satu lot standar sebelum biaya?',
      jsonb_build_array('100 shares worth Rp 200,000 before fees.', '1 share worth Rp 2,000 before fees.', '1,000 shares worth Rp 2,000 before fees.', 'A fixed Rp 2,000 payment regardless of lot size.'),
      jsonb_build_array('100 saham senilai Rp 200.000 sebelum biaya.', '1 saham senilai Rp 2.000 sebelum biaya.', '1.000 saham senilai Rp 2.000 sebelum biaya.', 'Pembayaran tetap Rp 2.000 terlepas dari ukuran lot.'),
      'The lot calculation gives a gross amount; current market rules, cash, and fees still need checking.',
      'Perhitungan lot memberi jumlah kotor; aturan pasar terbaru, kas, dan biaya tetap perlu diperiksa.'),
    ('reading-a-stock-page',
      'What should you do when a quote page shows a large volume figure?',
      'Apa yang sebaiknya dilakukan ketika halaman kutipan menunjukkan volume yang besar?',
      jsonb_build_array('Treat it as an observation of trading activity and seek other evidence.', 'Assume the company is profitable because many shares traded.', 'Assume the next price rise is guaranteed by the volume.', 'Conclude that the stock is undervalued without checking anything else.'),
      jsonb_build_array('Anggap itu sebagai pengamatan aktivitas perdagangan dan cari bukti lain.', 'Anggap perusahaan menguntungkan karena banyak saham diperdagangkan.', 'Anggap kenaikan harga berikutnya dijamin oleh volume.', 'Simpulkan saham undervalued tanpa memeriksa hal lain.'),
      'Volume describes activity in an observation window; it does not prove profitability, value, or the next move.',
      'Volume menggambarkan aktivitas pada periode pengamatan; bukan bukti profitabilitas, nilai, atau pergerakan berikutnya.'),
    ('portfolio-thinking',
      'Which combination belongs in a portfolio decision?',
      'Kombinasi mana yang termasuk dalam keputusan portofolio?',
      jsonb_build_array('Goal, time horizon, liquidity needs, and risk capacity.', 'The asset with the highest recent return only.', 'The mix that is most popular on social media.', 'The same allocation for every person with the same starting cash.'),
      jsonb_build_array('Tujuan, jangka waktu, kebutuhan likuiditas, dan kapasitas risiko.', 'Hanya aset dengan imbal hasil terbaru tertinggi.', 'Komposisi yang paling populer di media sosial.', 'Alokasi yang sama untuk setiap orang dengan kas awal yang sama.'),
      'A portfolio is personal: the goal, timing, liquidity, and ability to absorb losses all matter.',
      'Portofolio bersifat personal: tujuan, waktu, likuiditas, dan kemampuan menanggung kerugian semuanya penting.'),
    ('taxes-on-returns',
      'Why compare a gross return with the amount you keep?',
      'Mengapa imbal hasil kotor perlu dibandingkan dengan jumlah yang diterima?',
      jsonb_build_array('Tax treatment and costs can change what you actually keep.', 'Gross and net returns are always identical.', 'No investment return can be affected by tax treatment.', 'A gross return states the exact cash every investor receives.'),
      jsonb_build_array('Perlakuan pajak dan biaya dapat mengubah jumlah yang benar-benar diterima.', 'Imbal hasil kotor dan bersih selalu sama.', 'Tidak ada imbal hasil investasi yang dapat dipengaruhi pajak.', 'Imbal hasil kotor menyatakan kas pasti yang diterima setiap investor.'),
      'A useful comparison states whether the return is gross or net and checks the applicable current rules.',
      'Perbandingan yang berguna menyatakan apakah imbal hasil kotor atau bersih dan memeriksa aturan terbaru yang berlaku.'),
    ('macro-indicators',
      'What is a responsible use of a macro indicator?',
      'Apa penggunaan indikator makro yang bertanggung jawab?',
      jsonb_build_array('Use it as context while keeping timing and company outcomes uncertain.', 'Use it to identify the exact day to buy a stock.', 'Assume every stock will move in the same direction.', 'Treat one reading as a guarantee that purchasing power will rise.'),
      jsonb_build_array('Gunakan sebagai konteks sambil mengakui waktu dan hasil perusahaan tetap tidak pasti.', 'Gunakan untuk menentukan hari yang tepat membeli saham.', 'Anggap setiap saham akan bergerak ke arah yang sama.', 'Anggap satu angka sebagai jaminan daya beli akan naik.'),
      'A macro indicator can sharpen a question about possible channels, but it does not settle an asset-level outcome.',
      'Indikator makro dapat memperjelas pertanyaan tentang jalur dampak, tetapi tidak menentukan hasil pada tingkat aset.'),
    ('etfs-investing-with-one-click',
      'What should you compare before treating two ETFs as interchangeable?',
      'Apa yang perlu dibandingkan sebelum menganggap dua ETF dapat saling menggantikan?',
      jsonb_build_array('Basket, tracking, costs, liquidity, and how each fits the goal.', 'Only the product name and the largest holding.', 'Only the number of holdings, without checking their contents.', 'A promise that every holding will rise together.'),
      jsonb_build_array('Keranjang, pelacakan, biaya, likuiditas, dan kecocokan dengan tujuan.', 'Hanya nama produk dan kepemilikan terbesar.', 'Hanya jumlah kepemilikan tanpa memeriksa isinya.', 'Janji bahwa semua kepemilikan akan naik bersama.'),
      'An ETF comparison needs exposure, tracking, cost, liquidity, and goal-fit evidence, not just a similar label.',
      'Perbandingan ETF memerlukan bukti eksposur, pelacakan, biaya, likuiditas, dan kecocokan tujuan, bukan label yang mirip saja.'),
    ('bonds-sbn-safe-investing-with-the-government',
      'What must be checked for a current SBN decision?',
      'Apa yang harus diperiksa untuk keputusan SBN saat ini?',
      jsonb_build_array('Named series, current terms, source date, access route, and risks.', 'The issuer name alone, because it removes every risk.', 'The coupon alone, because it determines the whole outcome.', 'The headline and product colour, because they prove suitability.'),
      jsonb_build_array('Seri yang disebutkan, ketentuan terbaru, tanggal sumber, jalur akses, dan risiko.', 'Nama penerbit saja karena menghapus semua risiko.', 'Kupon saja karena menentukan seluruh hasil.', 'Judul dan warna produk karena membuktikan kecocokan.'),
      'SBN terms and access details are product- and time-specific; a headline is not enough for a decision.',
      'Ketentuan dan akses SBN bergantung pada produk dan waktu; judul saja tidak cukup untuk keputusan.'),
    ('tax-basics-npwp-pph-21-and-filing-taxes',
      'How should you use an illustrative tax example?',
      'Bagaimana sebaiknya menggunakan contoh pajak ilustratif?',
      jsonb_build_array('Check your facts, period, and current DJP guidance before applying it.', 'Copy the example rate whenever your income looks similar.', 'Ignore your records because the example is already official.', 'Use an old form so that the instructions do not change.'),
      jsonb_build_array('Periksa fakta, periode, dan panduan DJP terbaru sebelum menerapkannya.', 'Salin tarif contoh setiap kali penghasilanmu terlihat sama.', 'Abaikan catatan karena contoh tersebut sudah resmi.', 'Gunakan formulir lama agar petunjuk tidak berubah.'),
      'An illustration explains a method; your facts and the current official rule determine how it applies.',
      'Ilustrasi menjelaskan metode; fakta dan aturan resmi terbaru menentukan penerapannya.'),
    ('brokerage-account-setup-opening-your-rdn',
      'Before funding an RDN, what evidence matters most?',
      'Sebelum mengisi dana ke RDN, bukti apa yang paling penting?',
      jsonb_build_array('The verified provider, official receiving account, and current instructions.', 'A screenshot with a familiar logo, without checking the account.', 'A bonus message that asks you to transfer quickly.', 'A personal receiving account sent through an unverified chat.'),
      jsonb_build_array('Penyedia terverifikasi, rekening tujuan resmi, dan petunjuk terbaru.', 'Tangkapan layar dengan logo yang dikenal tanpa memeriksa rekening.', 'Pesan bonus yang memintamu segera mentransfer.', 'Rekening pribadi yang dikirim melalui chat tidak terverifikasi.'),
      'Funding instructions should be checked through a trusted official channel and matched to the current account details.',
      'Petunjuk pendanaan perlu diperiksa melalui kanal resmi tepercaya dan dicocokkan dengan detail rekening terbaru.'),
    ('stock-analysis-basics-fundamental-vs-technical',
      'What does combining fundamental and technical evidence require?',
      'Apa yang diperlukan untuk menggabungkan bukti fundamental dan teknikal?',
      jsonb_build_array('Study business evidence and dated price context without treating either as a guarantee.', 'Use one ratio as a complete decision.', 'Use a chart alone to decide a company is financially healthy.', 'Treat one headline as proof of tomorrow’s price.'),
      jsonb_build_array('Pelajari bukti bisnis dan konteks harga bertanggal tanpa menganggap salah satunya sebagai jaminan.', 'Gunakan satu rasio sebagai keputusan lengkap.', 'Gunakan grafik saja untuk menentukan perusahaan sehat secara finansial.', 'Anggap satu judul sebagai bukti harga besok.'),
      'The two lenses organise different evidence; neither one guarantees a price outcome or suitability.',
      'Kedua sudut pandang menyusun bukti yang berbeda; tidak ada yang menjamin hasil harga atau kecocokan.'),
    ('etfs-investing-with-one-click-part-2',
      'What does multiplying 100 illustrative units by a quoted price establish?',
      'Apa yang ditunjukkan oleh perkalian 100 unit ilustratif dengan harga kutipan?',
      jsonb_build_array('The gross arithmetic for that example, not a return forecast.', 'A guaranteed return at the next market close.', 'Proof that fees remove tracking and liquidity risk.', 'A forecast of the ETF value because the arithmetic uses 100 units.'),
      jsonb_build_array('Aritmetika kotor untuk contoh itu, bukan perkiraan imbal hasil.', 'Imbal hasil yang dijamin pada penutupan pasar berikutnya.', 'Bukti bahwa biaya menghapus risiko pelacakan dan likuiditas.', 'Perkiraan nilai ETF karena aritmetikanya memakai 100 unit.'),
      'The calculation shows an example amount paid before costs; current product data is still needed for any conclusion.',
      'Perhitungan menunjukkan contoh jumlah pembayaran sebelum biaya; data produk terbaru tetap diperlukan untuk kesimpulan.'),
    ('bonds-sbn-safe-investing-with-the-government-part-2',
      'Why cannot an illustrative coupon calculation stand alone?',
      'Mengapa perhitungan kupon ilustratif tidak dapat berdiri sendiri?',
      jsonb_build_array('Current series terms, source date, tax treatment, and payment rules still matter.', 'The next offer must have exactly the same terms.', 'Government bonds have no price or inflation risk.', 'The issuer name alone determines every payment detail.'),
      jsonb_build_array('Ketentuan seri terbaru, tanggal sumber, perlakuan pajak, dan aturan pembayaran tetap penting.', 'Penawaran berikutnya pasti memiliki ketentuan yang sama persis.', 'Obligasi pemerintah tidak memiliki risiko harga atau inflasi.', 'Nama penerbit saja menentukan semua detail pembayaran.'),
      'A calculation is tied to its stated series and assumptions; it is not a promise about another offer.',
      'Perhitungan terikat pada seri dan asumsi yang disebutkan; bukan janji tentang penawaran lain.'),
    ('tax-basics-npwp-pph-21-and-filing-taxes-part-2',
      'What should you keep after a current filing route confirms submission?',
      'Apa yang sebaiknya disimpan setelah jalur pelaporan saat ini mengonfirmasi pengiriman?',
      jsonb_build_array('The submission receipt or confirmation.', 'Only the unfinished draft.', 'A copied form from another taxpayer.', 'No record, because withholding always completes filing.'),
      jsonb_build_array('Bukti penerimaan atau konfirmasi pengiriman.', 'Hanya draf yang belum selesai.', 'Formulir salinan dari wajib pajak lain.', 'Tidak perlu catatan karena pemotongan selalu menyelesaikan pelaporan.'),
      'A receipt or confirmation is the durable evidence that the submission completed through the current route.',
      'Bukti penerimaan atau konfirmasi menjadi bukti bahwa pengiriman selesai melalui jalur saat ini.'),
    ('brokerage-account-setup-opening-your-rdn-part-2',
      'What makes a funding instruction safer to follow?',
      'Apa yang membuat petunjuk pendanaan lebih aman untuk diikuti?',
      jsonb_build_array('It comes through a verified official channel and matches current account details.', 'It includes a provider logo, even if the sender is unverified.', 'It promises a bonus for transferring immediately.', 'It sends funds to a personal account to simplify the process.'),
      jsonb_build_array('Petunjuk datang melalui kanal resmi terverifikasi dan sesuai dengan detail rekening terbaru.', 'Petunjuk memuat logo penyedia meskipun pengirim tidak terverifikasi.', 'Petunjuk menjanjikan bonus jika segera mentransfer.', 'Dana dikirim ke rekening pribadi agar proses lebih sederhana.'),
      'Verification of the channel and receiving account matters more than branding, urgency, or a promised reward.',
      'Verifikasi kanal dan rekening tujuan lebih penting daripada merek, urgensi, atau hadiah yang dijanjikan.'),
    ('stock-analysis-basics-fundamental-vs-technical-part-2',
      'What can a five-period chart support?',
      'Apa yang dapat didukung oleh grafik lima periode?',
      jsonb_build_array('A dated observation of the chosen price or volume pattern, not a guaranteed next move.', 'A guaranteed future direction from the latest candle.', 'A complete view of the company’s financial health.', 'Proof that the same trade suits every investor.'),
      jsonb_build_array('Pengamatan bertanggal atas pola harga atau volume yang dipilih, bukan pergerakan berikutnya yang dijamin.', 'Arah masa depan yang dijamin dari candle terbaru.', 'Gambaran lengkap kesehatan keuangan perusahaan.', 'Bukti bahwa transaksi yang sama cocok untuk setiap investor.'),
      'A short chart can organise recent observations while leaving the future direction and suitability open.',
      'Grafik singkat dapat menyusun pengamatan terbaru sambil membiarkan arah masa depan dan kecocokan tetap terbuka.')
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT
  lesson.id,
  'question',
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', additions.question_en,
    'options', additions.options_en,
    'answer', additions.options_en->>0,
    'difficulty', 'intermediate',
    'parameters', jsonb_build_object(),
    'explanation', additions.explanation_en
  ),
  jsonb_build_object(
    'type', 'multiple_choice',
    'question', additions.question_id,
    'options', additions.options_id,
    'answer', additions.options_id->>0,
    'difficulty', 'intermediate',
    'parameters', jsonb_build_object(),
    'explanation', additions.explanation_id
  ),
  'intermediate',
  'visual_applied',
  TRUE
FROM additions
JOIN public.lessons AS lesson ON lesson.slug = additions.slug
JOIN public.topics AS topic ON topic.id = lesson.topic_id
WHERE lesson.is_published = TRUE
  AND topic.chapter = 'Investing in Indonesia'
  AND NOT EXISTS (
    SELECT 1
    FROM public.content_variants AS existing
    WHERE existing.lesson_id = lesson.id
      AND existing.variant_type = 'question'
      AND existing.topic_tag = 'visual_applied'
      AND existing.is_active = TRUE
      AND existing.body->>'question' = additions.question_en
  );

COMMIT;
