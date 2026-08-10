-- KO-353-A/B: shorten four multi-objective lessons into explicit parts.
-- Existing slugs remain Part 1 so existing progress is preserved. Part 2 rows
-- are prerequisite-linked, mobile-safe, bilingual, and source-backed.

BEGIN;

UPDATE public.lessons
SET
  title = 'Net Worth, Part 1: Own minus owe',
  title_id = 'Kekayaan Bersih, Bagian 1: Milik dikurangi utang',
  summary = 'Learn the net-worth formula and separate assets from liabilities before calculating a snapshot.',
  summary_id = 'Pelajari rumus kekayaan bersih dan bedakan aset dari liabilitas sebelum menghitung sebuah potret.',
  concept_body = $body$
Net worth is a snapshot of your financial position:

**Net worth = assets - liabilities**

**Assets** are things you own or control that have value, such as cash, savings, or an item that can be sold. **Liabilities** are obligations you still need to repay, such as a loan or an unpaid bill.

Make two short lists before doing any arithmetic. Keep the date and the assumptions beside the lists, because balances and values can change.
  $body$,
  concept_body_id = $body_id$
Kekayaan bersih adalah potret posisi keuanganmu:

**Kekayaan bersih = aset - liabilitas**

**Aset** adalah sesuatu yang kamu miliki atau kuasai dan memiliki nilai, seperti kas, tabungan, atau barang yang dapat dijual. **Liabilitas** adalah kewajiban yang masih perlu dibayar, seperti pinjaman atau tagihan.

Buat dua daftar singkat sebelum menghitung. Simpan tanggal dan asumsi di sampingnya karena saldo dan nilai dapat berubah.
  $body_id$,
  indonesian_example = 'Dita mencatat saldo tabungan dan kas di kolom aset, lalu mencatat sisa pinjaman di kolom liabilitas sebelum menghitung posisi bersihnya.',
  why_this_matters = 'Separating the two columns prevents income, spending, and debt from being mistaken for the same measure.',
  why_this_matters_id = 'Memisahkan dua kolom mencegah pendapatan, belanja, dan utang dianggap sebagai ukuran yang sama.',
  common_mistake = 'Treating a high monthly income as proof of high net worth without checking assets and liabilities.',
  common_mistake_id = 'Menganggap pendapatan bulanan tinggi sebagai bukti kekayaan bersih tinggi tanpa memeriksa aset dan liabilitas.',
  estimated_minutes = 4,
  updated_at = NOW()
WHERE slug = 'net-worth-know-your-financial-position';

UPDATE public.lessons
SET
  title = 'Banking Basics, Part 1: Match the account to the job',
  title_id = 'Dasar-Dasar Perbankan, Bagian 1: Cocokkan rekening dengan tugasnya',
  summary = 'Compare everyday, goal-based, and business account jobs before checking provider terms.',
  summary_id = 'Bandingkan fungsi rekening harian, rekening tujuan, dan rekening bisnis sebelum memeriksa syarat penyedia.',
  concept_body = $body$
Choose an account by the job it needs to do, not by a headline rate.

- **Tabungan:** everyday access for spending, transfers, and a liquid buffer.
- **Deposito:** money set aside for a stated term; check access and early-withdrawal conditions.
- **Giro:** higher-volume or business transactions; check limits, fees, and documentation.

For each option, compare access, fees, minimum balance, purpose, and current provider terms. The best fit depends on the job and your timeline.
  $body$,
  concept_body_id = $body_id$
Pilih rekening berdasarkan tugas yang perlu dilakukannya, bukan hanya angka promosi.

- **Tabungan:** akses harian untuk belanja, transfer, dan dana yang mudah dicairkan.
- **Deposito:** uang yang disisihkan untuk jangka waktu tertentu; cek akses dan syarat pencairan awal.
- **Giro:** transaksi volume tinggi atau bisnis; cek batas, biaya, dan dokumen.

Untuk setiap pilihan, bandingkan akses, biaya, saldo minimum, tujuan, dan syarat terbaru dari penyedia. Kecocokan bergantung pada tugas dan waktumu.
  $body_id$,
  indonesian_example = 'Raka memakai tabungan untuk transaksi harian dan membandingkan deposito hanya untuk uang yang tidak akan dibutuhkan dalam waktu dekat.',
  why_this_matters = 'A clear purpose makes fees, access rules, and lock-up conditions easier to compare.',
  why_this_matters_id = 'Tujuan yang jelas membuat biaya, aturan akses, dan syarat penguncian lebih mudah dibandingkan.',
  common_mistake = 'Choosing a rate before checking whether the account can support the way you need to use the money.',
  common_mistake_id = 'Memilih suku bunga sebelum memeriksa apakah rekening mendukung cara penggunaan uangmu.',
  estimated_minutes = 4,
  updated_at = NOW()
WHERE slug = 'banking-basics-choosing-the-right-account';

UPDATE public.lessons
SET
  title = 'Digital Wallets & QRIS, Part 1: How a payment works',
  title_id = 'Dompet Digital & QRIS, Bagian 1: Cara kerja pembayaran',
  summary = 'Understand the wallet-and-QRIS payment path and pause before confirming the merchant and amount.',
  summary_id = 'Pahami alur pembayaran dompet digital dan QRIS, lalu berhenti sebelum mengonfirmasi merchant dan jumlah.',
  concept_body = $body$
A digital wallet stores payment access inside an app. QRIS is a standard that lets a participating merchant display one QR code for supported payment services.

Use a simple three-step check:

1. **Merchant:** does the displayed name match the place you intend to pay?
2. **Amount:** is the total correct before you confirm?
3. **Proof:** can you see and keep the confirmation after paying?

The logo or speed of checkout is not proof that a payment is correct. Stop when the name, amount, or confirmation does not match.
  $body$,
  concept_body_id = $body_id$
Dompet digital menyimpan akses pembayaran di dalam aplikasi. QRIS adalah standar yang memungkinkan merchant peserta menampilkan satu kode QR untuk layanan pembayaran yang didukung.

Gunakan pemeriksaan tiga langkah:

1. **Merchant:** apakah nama yang tampil cocok dengan tempat yang ingin kamu bayar?
2. **Jumlah:** apakah totalnya benar sebelum dikonfirmasi?
3. **Bukti:** apakah konfirmasi terlihat dan dapat disimpan setelah membayar?

Logo atau checkout yang cepat bukan bukti bahwa pembayaran sudah benar. Berhenti jika nama, jumlah, atau konfirmasi tidak cocok.
  $body_id$,
  indonesian_example = 'Sari memindai QRIS, memeriksa nama merchant dan jumlah, lalu menyimpan konfirmasi sebelum meninggalkan kasir.',
  why_this_matters = 'A short pause catches mismatched payment details before a transaction becomes difficult to resolve.',
  why_this_matters_id = 'Jeda singkat dapat menemukan detail pembayaran yang tidak cocok sebelum transaksi sulit diselesaikan.',
  common_mistake = 'Confirming a QR payment from the code or logo alone without reading the merchant and amount.',
  common_mistake_id = 'Mengonfirmasi pembayaran QR hanya dari kode atau logo tanpa membaca nama merchant dan jumlah.',
  estimated_minutes = 4,
  updated_at = NOW()
WHERE slug = 'digital-wallets-qris-safe-and-smart-usage';

UPDATE public.lessons
SET
  title = 'Insurance Basics, Part 1: Compare coverage',
  title_id = 'Dasar-Dasar Asuransi, Bagian 1: Bandingkan perlindungan',
  summary = 'Compare BPJS and private health-cover questions without treating a label as a complete product description.',
  summary_id = 'Bandingkan pertanyaan tentang perlindungan kesehatan BPJS dan swasta tanpa menganggap label sebagai penjelasan produk yang lengkap.',
  concept_body = $body$
Insurance is a way to transfer a defined financial risk under stated terms. The useful comparison is not simply “public or private”.

- **BPJS:** check current eligibility, contribution, coverage, referral, and service rules through official information.
- **Private cover:** check the policy's coverage, exclusions, network, limits, premium, and claims process.

Always read the current terms for the product and person involved. Coverage, cost, eligibility, and access rules can change.
  $body$,
  concept_body_id = $body_id$
Asuransi adalah cara mengalihkan risiko keuangan tertentu berdasarkan syarat yang tercantum. Perbandingan yang berguna bukan sekadar “publik atau swasta”.

- **BPJS:** cek kelayakan, iuran, cakupan, rujukan, dan aturan layanan terbaru melalui informasi resmi.
- **Perlindungan swasta:** cek cakupan polis, pengecualian, jaringan, batas, premi, dan proses klaim.

Selalu baca ketentuan terbaru untuk produk dan orang yang bersangkutan. Cakupan, biaya, kelayakan, dan aturan akses dapat berubah.
  $body_id$,
  indonesian_example = 'Maya menulis daftar cakupan, pengecualian, biaya, dan jalur klaim sebelum membandingkan dua pilihan perlindungan kesehatan.',
  why_this_matters = 'Coverage names are shortcuts; the exclusions, limits, and process determine what a policy can actually do.',
  why_this_matters_id = 'Nama perlindungan hanyalah ringkasan; pengecualian, batas, dan proses menentukan fungsi polis sebenarnya.',
  common_mistake = 'Assuming that two products with similar labels cover the same situations.',
  common_mistake_id = 'Menganggap dua produk dengan label serupa menanggung situasi yang sama.',
  estimated_minutes = 4,
  updated_at = NOW()
WHERE slug = 'insurance-basics-bpjs-vs-private-insurance';

WITH part_specs(slug, source_slug, title, title_id, summary, summary_id, concept_body, concept_body_id, indonesian_example, why_this_matters, why_this_matters_id, common_mistake, common_mistake_id, lesson_number) AS (
  VALUES
  (
    'net-worth-know-your-financial-position-part-2', 'net-worth-know-your-financial-position',
    'Net Worth, Part 2: Read the snapshot', 'Kekayaan Bersih, Bagian 2: Baca potret keuangan',
    'Calculate an illustrative net-worth snapshot, then compare dates without turning it into a measure of personal worth.',
    'Hitung potret kekayaan bersih ilustratif, lalu bandingkan tanggal tanpa mengubahnya menjadi ukuran nilai diri.',
    $body$A simple snapshot can make the formula concrete. If an illustrative list has Rp20m of assets and Rp8m of liabilities, the position is **Rp12m**.

Record the date beside the result. A later snapshot may change when balances, debt, or asset values change. Income is a flow received over time; net worth is a position at a point in time. Neither number alone describes your wellbeing or guarantees a future result.$body$,
    $body_id$Contoh sederhana membuat rumus lebih nyata. Jika daftar ilustratif memiliki aset Rp20 juta dan liabilitas Rp8 juta, posisinya adalah **Rp12 juta**.

Catat tanggal di samping hasilnya. Potret berikutnya dapat berubah saat saldo, utang, atau nilai aset berubah. Pendapatan adalah arus yang diterima dari waktu ke waktu; kekayaan bersih adalah posisi pada satu waktu. Tidak ada satu angka yang sendirian menggambarkan kesejahteraan atau menjamin hasil masa depan.$body_id$,
    'Bayu mencatat Rp20 juta aset dan Rp8 juta liabilitas pada satu tanggal, lalu menyimpan hasil Rp12 juta sebagai titik pembanding, bukan sebagai label dirinya.',
    'A dated snapshot helps you notice what changed without confusing a financial measure with personal worth.',
    'Potret bertanggal membantu melihat perubahan tanpa menyamakan ukuran keuangan dengan nilai diri.',
    'Using an age benchmark or one snapshot as a universal target or verdict.',
    'Memakai patokan usia atau satu potret sebagai target atau penilaian universal.',
    175
  ),
  (
    'banking-basics-choosing-the-right-account-part-2', 'banking-basics-choosing-the-right-account',
    'Banking Basics, Part 2: Terms and red flags', 'Dasar-Dasar Perbankan, Bagian 2: Ketentuan dan tanda bahaya',
    'Check protection, access, fees, and changing provider terms before opening or moving money to an account.',
    'Periksa perlindungan, akses, biaya, dan syarat penyedia yang dapat berubah sebelum membuka atau memindahkan uang ke rekening.',
    $body$After matching the account to its job, read the terms that can change the outcome:

- Check whether the bank and account meet the current LPS requirements and guarantee-rate conditions; do not rely on an old rate or screenshot.
- Check fees, minimum balances, lock-up, early-withdrawal, transfer, and access rules.
- Pause on unusually high returns, hidden charges, unclear provider identity, or pressure to deposit quickly.

The source date matters whenever a rate, limit, fee, or guarantee condition is mentioned.$body$,
    $body_id$Setelah mencocokkan rekening dengan tugasnya, baca ketentuan yang dapat mengubah hasil:

- Cek apakah bank dan rekening memenuhi syarat LPS serta ketentuan tingkat bunga penjaminan terbaru; jangan mengandalkan tarif lama atau tangkapan layar.
- Cek biaya, saldo minimum, penguncian, pencairan awal, transfer, dan aturan akses.
- Berhenti pada imbal hasil yang tidak biasa, biaya tersembunyi, identitas penyedia yang tidak jelas, atau desakan untuk segera menyetor.

Tanggal sumber penting saat tarif, batas, biaya, atau ketentuan penjaminan disebutkan.$body_id$,
    'Raka menandai tanggal saat membaca syarat rekening dan menolak menyimpulkan dari angka promosi yang tidak memiliki sumber terbaru.',
    'The account comparison is only useful when the purpose and current terms are kept together.',
    'Perbandingan rekening hanya berguna jika tujuan dan ketentuan terbaru dibaca bersama.',
    'Treating LPS protection or a headline rate as a guarantee that every product detail is safe.',
    'Menganggap perlindungan LPS atau tarif utama sebagai jaminan bahwa semua detail produk aman.',
    176
  ),
  (
    'digital-wallets-qris-safe-and-smart-usage-part-2', 'digital-wallets-qris-safe-and-smart-usage',
    'Digital Wallets & QRIS, Part 2: Safety boundaries', 'Dompet Digital & QRIS, Bagian 2: Batas aman',
    'Protect payment credentials, understand that fees and limits vary, and know when a wallet is the wrong tool.',
    'Lindungi kredensial pembayaran, pahami bahwa biaya dan batas dapat berbeda, dan kenali kapan dompet bukan alat yang tepat.',
    $body$Keep the payment flow safe after the QR code is scanned:

- Never share a PIN, password, or OTP with a person or message claiming to provide support.
- Check the current fee, limit, refund, and dispute terms in the official app or provider channel.
- Keep proof of payment and use official support when a name, amount, or result is wrong.
- A wallet can be convenient for planned payments, but it is not a reason to borrow or spend beyond a budget.

Speed, cashback, and a familiar logo do not remove fraud or overspending risk.$body$,
    $body_id$Jaga alur pembayaran tetap aman setelah kode QR dipindai:

- Jangan pernah membagikan PIN, kata sandi, atau OTP kepada orang atau pesan yang mengaku memberi dukungan.
- Cek ketentuan biaya, batas, pengembalian dana, dan sengketa terbaru di aplikasi atau kanal resmi penyedia.
- Simpan bukti pembayaran dan gunakan dukungan resmi saat nama, jumlah, atau hasilnya salah.
- Dompet dapat praktis untuk pembayaran terencana, tetapi bukan alasan untuk berutang atau melampaui anggaran.

Kecepatan, cashback, dan logo yang dikenal tidak menghapus risiko penipuan atau belanja berlebihan.$body_id$,
    'Nia menolak mengirim OTP saat ada pesan dukungan palsu, lalu membuka aplikasi resmi untuk memeriksa transaksi yang tidak cocok.',
    'Security is a boundary around the payment process, not an optional extra after a quick scan.',
    'Keamanan adalah batas dalam proses pembayaran, bukan tambahan opsional setelah pemindaian cepat.',
    'Assuming an app is safe because it is popular or because a payment screen looks familiar.',
    'Menganggap aplikasi aman hanya karena populer atau layar pembayarannya terlihat familiar.',
    177
  ),
  (
    'insurance-basics-bpjs-vs-private-insurance-part-2', 'insurance-basics-bpjs-vs-private-insurance',
    'Insurance Basics, Part 2: Prioritise protection', 'Dasar-Dasar Asuransi, Bagian 2: Prioritaskan perlindungan',
    'Think about the risks that could disrupt essentials, then check life and other cover without turning a checklist into advice.',
    'Pikirkan risiko yang dapat mengganggu kebutuhan pokok, lalu periksa perlindungan jiwa dan lainnya tanpa mengubah daftar menjadi nasihat.',
    $body$After comparing health-cover terms, map protection to the risk that could cause the greatest disruption.

1. Keep essential health and work-related protection visible and verify current rules.
2. Consider life-cover questions when another person depends on your income; check the purpose, beneficiary, exclusions, premium, and claim process.
3. Treat travel, property, vehicle, or other cover as a separate decision with its own terms and priority.

Pause on guaranteed language, unclear exclusions, pressure to buy, or a premium that does not fit the budget. A checklist supports questions; it does not choose a product for everyone.$body$,
    $body_id$Setelah membandingkan ketentuan perlindungan kesehatan, petakan perlindungan pada risiko yang paling mengganggu kehidupan pokok.

1. Pastikan perlindungan kesehatan dan pekerjaan yang penting terlihat, lalu verifikasi aturan terbaru.
2. Pertimbangkan pertanyaan tentang perlindungan jiwa jika ada orang lain yang bergantung pada penghasilanmu; cek tujuan, penerima manfaat, pengecualian, premi, dan proses klaim.
3. Perlindungan perjalanan, properti, kendaraan, atau lainnya adalah keputusan terpisah dengan syarat dan prioritas masing-masing.

Berhenti pada bahasa yang menjanjikan, pengecualian yang tidak jelas, desakan membeli, atau premi yang tidak sesuai anggaran. Daftar periksa membantu bertanya; bukan memilih produk untuk semua orang.$body_id$,
    'Ari writes down who depends on the income and what risk would affect essentials before reading a life-insurance illustration.',
    'Prioritising the risk makes a protection conversation more useful than collecting labels or promises.',
    'Memprioritaskan risiko membuat pembicaraan perlindungan lebih berguna daripada mengumpulkan label atau janji.',
    'Buying a policy because of a return promise without checking exclusions, affordability, and claims.',
    'Membeli polis karena janji imbal hasil tanpa memeriksa pengecualian, kemampuan membayar, dan klaim.',
    178
  )
), inserted AS (
  INSERT INTO public.lessons (
    slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward,
    estimated_minutes, summary, summary_id, concept_body, concept_body_id,
    indonesian_example, why_this_matters, why_this_matters_id, common_mistake,
    common_mistake_id, review_status, reviewed_by, reviewed_at, is_published,
    jurisdiction, prerequisite_lesson_id
  )
  SELECT p.slug, p.title, p.title_id, parent.topic_id, p.lesson_number,
    parent.difficulty, parent.xp_reward, 4, p.summary, p.summary_id,
    p.concept_body, p.concept_body_id, p.indonesian_example, p.why_this_matters,
    p.why_this_matters_id, p.common_mistake, p.common_mistake_id,
    parent.review_status, parent.reviewed_by, parent.reviewed_at,
    parent.is_published, parent.jurisdiction, parent.id
  FROM part_specs p
  JOIN public.lessons parent ON parent.slug = p.source_slug
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
    estimated_minutes = EXCLUDED.estimated_minutes,
    is_published = EXCLUDED.is_published,
    prerequisite_lesson_id = EXCLUDED.prerequisite_lesson_id,
    updated_at = NOW()
  RETURNING id, slug
)
SELECT 1 FROM inserted;

INSERT INTO public.lesson_reviews (
  lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status,
  source_verification_status, indonesia_context_status, compliance_status, notes,
  approved_to_publish
)
SELECT child.id, review.reviewer_name, review.reviewer_role, review.review_date,
  review.factual_accuracy_status, review.source_verification_status,
  review.indonesia_context_status, review.compliance_status,
  'KO-353 concise Part 2; re-check changing provider, protection, and payment terms against the linked source.',
  review.approved_to_publish
FROM public.lessons child
JOIN public.lessons parent ON parent.id = child.prerequisite_lesson_id
JOIN public.lesson_reviews review ON review.lesson_id = parent.id
WHERE child.slug IN (
  'net-worth-know-your-financial-position-part-2',
  'banking-basics-choosing-the-right-account-part-2',
  'digital-wallets-qris-safe-and-smart-usage-part-2',
  'insurance-basics-bpjs-vs-private-insurance-part-2'
)
AND NOT EXISTS (SELECT 1 FROM public.lesson_reviews existing WHERE existing.lesson_id = child.id);

INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT child.id, source.source_id, source.relevance_type,
  COALESCE(source.citation_label, source_row.source_code), source.is_primary, source.display_order
FROM public.lessons child
JOIN public.lessons parent ON parent.id = child.prerequisite_lesson_id
JOIN public.lesson_sources source ON source.lesson_id = parent.id
JOIN public.sources source_row ON source_row.id = source.source_id
WHERE child.slug IN (
  'net-worth-know-your-financial-position-part-2',
  'banking-basics-choosing-the-right-account-part-2',
  'digital-wallets-qris-safe-and-smart-usage-part-2',
  'insurance-basics-bpjs-vs-private-insurance-part-2'
)
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

WITH blocks(slug, block_type, data_status, content) AS (VALUES
('net-worth-know-your-financial-position-part-2','worked_example','illustrative',$json${"en":{"icon":"⚖️","eyebrow":"Dated snapshot","title":"Rp20m assets − Rp8m liabilities = Rp12m","altText":"An illustrative calculation subtracts Rp8 million of liabilities from Rp20 million of assets to show Rp12 million net worth.","disclosure":"Illustrative calculation only; values, dates, and categories depend on the person.","payload":{"inputs":[{"label":"Assets","value":"Rp20m"},{"label":"Liabilities","value":"Rp8m"}],"steps":["Write the date beside the list.","Subtract liabilities from assets."],"outcome":"Illustrative net position: Rp12m."}},"id":{"icon":"⚖️","eyebrow":"Potret bertanggal","title":"Aset Rp20 juta − liabilitas Rp8 juta = Rp12 juta","altText":"Perhitungan ilustratif mengurangi liabilitas Rp8 juta dari aset Rp20 juta untuk menunjukkan kekayaan bersih Rp12 juta.","disclosure":"Perhitungan ilustratif saja; nilai, tanggal, dan kategori bergantung pada orangnya.","payload":{"inputs":[{"label":"Aset","value":"Rp20 juta"},{"label":"Liabilitas","value":"Rp8 juta"}],"steps":["Tulis tanggal di samping daftar.","Kurangi liabilitas dari aset."],"outcome":"Posisi bersih ilustratif: Rp12 juta."}}}$json$::jsonb),
('banking-basics-choosing-the-right-account-part-2','comparison','illustrative',$json${"en":{"icon":"🏦","eyebrow":"Terms check","title":"Read the conditions beside the account job","altText":"A comparison lists current protection, access, fees, and red-flag questions before choosing a bank account.","disclosure":"Illustrative checklist only; verify current terms with the provider and relevant official source.","payload":{"leftTitle":"Check the terms","rightTitle":"Pause on the signal","rows":[{"left":"Current protection conditions","right":"Old rate screenshot"},{"left":"Fees, access, and minimum balance","right":"Hidden or unclear charges"},{"left":"Date and official source","right":"Pressure to deposit quickly"}]}},"id":{"icon":"🏦","eyebrow":"Cek ketentuan","title":"Baca syarat di samping tugas rekening","altText":"Perbandingan mencantumkan pertanyaan perlindungan, akses, biaya, dan tanda bahaya sebelum memilih rekening bank.","disclosure":"Daftar periksa ilustratif saja; verifikasi syarat terbaru kepada penyedia dan sumber resmi terkait.","payload":{"leftTitle":"Periksa syarat","rightTitle":"Berhenti pada sinyal","rows":[{"left":"Ketentuan perlindungan terbaru","right":"Tangkapan layar tarif lama"},{"left":"Biaya, akses, dan saldo minimum","right":"Biaya tersembunyi atau tidak jelas"},{"left":"Tanggal dan sumber resmi","right":"Desakan segera menyetor"}]}}}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage-part-2','process','illustrative',$json${"en":{"icon":"🔐","eyebrow":"Payment boundary","title":"Protect the payment after the scan","altText":"A three-step safety flow keeps credentials private, checks official terms, and reports a mismatch through official support.","disclosure":"Never share a PIN, password, or OTP; use official provider support.","payload":{"steps":[{"title":"1. Keep secrets private","description":"Do not share a PIN, password, or OTP."},{"title":"2. Check current terms","description":"Read fees, limits, refunds, and dispute routes in the official app."},{"title":"3. Keep proof","description":"Save confirmation and report a mismatch through official support."}]}},"id":{"icon":"🔐","eyebrow":"Batas pembayaran","title":"Lindungi pembayaran setelah pemindaian","altText":"Alur aman tiga langkah menjaga kredensial tetap rahasia, memeriksa syarat resmi, dan melaporkan ketidaksesuaian lewat dukungan resmi.","disclosure":"Jangan pernah membagikan PIN, kata sandi, atau OTP; gunakan dukungan penyedia resmi.","payload":{"steps":[{"title":"1. Jaga rahasia","description":"Jangan bagikan PIN, kata sandi, atau OTP."},{"title":"2. Cek syarat terbaru","description":"Baca biaya, batas, pengembalian dana, dan jalur sengketa di aplikasi resmi."},{"title":"3. Simpan bukti","description":"Simpan konfirmasi dan laporkan ketidaksesuaian lewat dukungan resmi."}]}}}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance-part-2','comparison','illustrative',$json${"en":{"icon":"🛡️","eyebrow":"Protection priority","title":"Ask who depends on the protection","altText":"A comparison frames life-cover questions around dependants, exclusions, affordability, and claims rather than a return promise.","disclosure":"Illustrative learning checklist only; verify current product terms with official providers.","payload":{"leftTitle":"Ask first","rightTitle":"Keep checking","rows":[{"left":"Who depends on the income?","right":"What exclusions apply?"},{"left":"What risk disrupts essentials?","right":"What premium and limits fit?"},{"left":"What is the claims route?","right":"What does the current source say?"}]}},"id":{"icon":"🛡️","eyebrow":"Prioritas perlindungan","title":"Tanyakan siapa yang bergantung pada perlindungan","altText":"Perbandingan membingkai pertanyaan perlindungan jiwa melalui tanggungan, pengecualian, kemampuan membayar, dan klaim, bukan janji imbal hasil.","disclosure":"Daftar periksa pembelajaran ilustratif saja; verifikasi syarat produk terbaru kepada penyedia resmi.","payload":{"leftTitle":"Tanyakan dulu","rightTitle":"Tetap periksa","rows":[{"left":"Siapa yang bergantung pada penghasilan?","right":"Pengecualian apa yang berlaku?"},{"left":"Risiko apa yang mengganggu kebutuhan pokok?","right":"Premi dan batas apa yang sesuai?"},{"left":"Bagaimana jalur klaimnya?","right":"Apa kata sumber terbaru?"}]}}}$json$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, content, data_status, display_order, is_published)
SELECT lesson.id, 'concept', blocks.block_type, blocks.content, blocks.data_status, 10, TRUE
FROM blocks JOIN public.lessons lesson ON lesson.slug = blocks.slug
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type, content = EXCLUDED.content,
  data_status = EXCLUDED.data_status, is_published = TRUE, updated_at = NOW();

WITH applied(slug, body, body_id) AS (VALUES
('net-worth-know-your-financial-position', $json${"type":"multiple_choice","question":"What does the net-worth visual subtract?","options":["Liabilities from assets","Income from spending","Fees from interest","Goals from time"],"answer":"Liabilities from assets","difficulty":"beginner","explanation":"The snapshot uses assets minus liabilities; it is not a measure of personal worth."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang dikurangi dalam visual kekayaan bersih?","options":["Liabilitas dari aset","Pendapatan dari belanja","Biaya dari bunga","Tujuan dari waktu"],"answer":"Liabilitas dari aset","difficulty":"beginner","explanation":"Potret menggunakan aset dikurangi liabilitas; ini bukan ukuran nilai diri."}$json$::jsonb),
('net-worth-know-your-financial-position', $json${"type":"multiple_choice","question":"Which two lists should you make before calculating a snapshot?","options":["Assets and liabilities","Income and hobbies","Prices and logos","Goals and followers"],"answer":"Assets and liabilities","difficulty":"beginner","explanation":"Separating what you own from what you owe keeps the formula clear."}$json$::jsonb, $json${"type":"multiple_choice","question":"Dua daftar apa yang dibuat sebelum menghitung potret?","options":["Aset dan liabilitas","Pendapatan dan hobi","Harga dan logo","Tujuan dan pengikut"],"answer":"Aset dan liabilitas","difficulty":"beginner","explanation":"Memisahkan yang dimiliki dari yang terutang membuat rumus tetap jelas."}$json$::jsonb),
('net-worth-know-your-financial-position', $json${"type":"multiple_choice","question":"What should sit beside a net-worth result?","options":["The date and assumptions","A guaranteed forecast","A broker ranking","A personal score"],"answer":"The date and assumptions","difficulty":"beginner","explanation":"A snapshot can change, so its date and assumptions matter."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang sebaiknya dicatat di samping hasil kekayaan bersih?","options":["Tanggal dan asumsi","Prediksi yang dijamin","Peringkat broker","Nilai pribadi"],"answer":"Tanggal dan asumsi","difficulty":"beginner","explanation":"Potret dapat berubah, sehingga tanggal dan asumsinya penting."}$json$::jsonb),
('net-worth-know-your-financial-position-part-2', $json${"type":"multiple_choice","question":"In the illustrative visual, Rp20m of assets minus Rp8m of liabilities equals…","options":["Rp12m","Rp28m","Rp8m","Rp20m"],"answer":"Rp12m","difficulty":"beginner","explanation":"The worked example shows the arithmetic only; it is not a universal target."}$json$::jsonb, $json${"type":"multiple_choice","question":"Dalam visual ilustratif, aset Rp20 juta dikurangi liabilitas Rp8 juta sama dengan…","options":["Rp12 juta","Rp28 juta","Rp8 juta","Rp20 juta"],"answer":"Rp12 juta","difficulty":"beginner","explanation":"Contoh menunjukkan aritmetika saja; bukan target universal."}$json$::jsonb),
('net-worth-know-your-financial-position-part-2', $json${"type":"multiple_choice","question":"Why add a date to a net-worth snapshot?","options":["Balances and values can change","It guarantees a higher result","It replaces the formula","It proves financial wellbeing"],"answer":"Balances and values can change","difficulty":"beginner","explanation":"The date tells you when the position was observed."}$json$::jsonb, $json${"type":"multiple_choice","question":"Mengapa tanggal ditambahkan pada potret kekayaan bersih?","options":["Saldo dan nilai dapat berubah","Tanggal menjamin hasil lebih tinggi","Tanggal menggantikan rumus","Tanggal membuktikan kesejahteraan"],"answer":"Saldo dan nilai dapat berubah","difficulty":"beginner","explanation":"Tanggal menunjukkan kapan posisi tersebut diamati."}$json$::jsonb),
('net-worth-know-your-financial-position-part-2', $json${"type":"multiple_choice","question":"What is the safest conclusion from one net-worth snapshot?","options":["It is a dated position, not a verdict about a person","It predicts next year exactly","It replaces an income statement","It sets one target for everyone"],"answer":"It is a dated position, not a verdict about a person","difficulty":"beginner","explanation":"A financial snapshot can support reflection without becoming a personal score."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa kesimpulan paling aman dari satu potret kekayaan bersih?","options":["Itu posisi bertanggal, bukan penilaian terhadap seseorang","Itu memprediksi tahun depan dengan tepat","Itu menggantikan catatan pendapatan","Itu menetapkan satu target untuk semua orang"],"answer":"Itu posisi bertanggal, bukan penilaian terhadap seseorang","difficulty":"beginner","explanation":"Potret keuangan dapat membantu refleksi tanpa menjadi nilai pribadi."}$json$::jsonb),
('banking-basics-choosing-the-right-account', $json${"type":"multiple_choice","question":"Which account job best matches daily transfers and spending?","options":["A savings account","A time deposit only","A business current account only","A loan account"],"answer":"A savings account","difficulty":"beginner","explanation":"Everyday access is a common savings-account job; current provider terms still need checking."}$json$::jsonb, $json${"type":"multiple_choice","question":"Fungsi rekening mana yang paling cocok untuk transfer dan belanja harian?","options":["Rekening tabungan","Hanya deposito","Hanya rekening giro bisnis","Rekening pinjaman"],"answer":"Rekening tabungan","difficulty":"beginner","explanation":"Akses harian adalah fungsi umum tabungan; syarat penyedia terbaru tetap perlu dicek."}$json$::jsonb),
('banking-basics-choosing-the-right-account', $json${"type":"multiple_choice","question":"What should you compare before choosing an account?","options":["Purpose, access, fees, and minimum balance","Only the logo","Only the headline rate","A friend's screenshot"],"answer":"Purpose, access, fees, and minimum balance","difficulty":"beginner","explanation":"The account should fit its job and current terms."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang dibandingkan sebelum memilih rekening?","options":["Tujuan, akses, biaya, dan saldo minimum","Hanya logo","Hanya tarif utama","Tangkapan layar teman"],"answer":"Tujuan, akses, biaya, dan saldo minimum","difficulty":"beginner","explanation":"Rekening perlu cocok dengan tugas dan ketentuan terbarunya."}$json$::jsonb),
('banking-basics-choosing-the-right-account', $json${"type":"multiple_choice","question":"Why can a headline rate be insufficient?","options":["Access, fees, and conditions also affect fit","It always predicts returns","It removes LPS rules","It tells you the account purpose"],"answer":"Access, fees, and conditions also affect fit","difficulty":"beginner","explanation":"A rate is only one part of an account comparison."}$json$::jsonb, $json${"type":"multiple_choice","question":"Mengapa tarif utama saja tidak cukup?","options":["Akses, biaya, dan ketentuan juga memengaruhi kecocokan","Tarif selalu memprediksi imbal hasil","Tarif menghapus aturan LPS","Tarif menjelaskan tujuan rekening"],"answer":"Akses, biaya, dan ketentuan juga memengaruhi kecocokan","difficulty":"beginner","explanation":"Tarif hanya satu bagian dari perbandingan rekening."}$json$::jsonb),
('banking-basics-choosing-the-right-account-part-2', $json${"type":"multiple_choice","question":"Which detail should be checked against a current official source?","options":["A guarantee condition or rate","A favourite colour","A logo size","A social-media caption"],"answer":"A guarantee condition or rate","difficulty":"beginner","explanation":"Rates, limits, fees, and protection conditions can be time-sensitive."}$json$::jsonb, $json${"type":"multiple_choice","question":"Detail mana yang perlu dicek terhadap sumber resmi terbaru?","options":["Ketentuan penjaminan atau tarif","Warna favorit","Ukuran logo","Keterangan media sosial"],"answer":"Ketentuan penjaminan atau tarif","difficulty":"beginner","explanation":"Tarif, batas, biaya, dan ketentuan perlindungan dapat sensitif terhadap waktu."}$json$::jsonb),
('banking-basics-choosing-the-right-account-part-2', $json${"type":"multiple_choice","question":"Which signal belongs in the pause column of the visual?","options":["Pressure to deposit quickly","A dated official source","Clear fees","A stated access rule"],"answer":"Pressure to deposit quickly","difficulty":"beginner","explanation":"Pressure is a reason to verify independently before moving money."}$json$::jsonb, $json${"type":"multiple_choice","question":"Sinyal mana yang masuk kolom berhenti pada visual?","options":["Desakan untuk segera menyetor","Sumber resmi bertanggal","Biaya yang jelas","Aturan akses yang tercantum"],"answer":"Desakan untuk segera menyetor","difficulty":"beginner","explanation":"Desakan adalah alasan untuk melakukan verifikasi mandiri sebelum memindahkan uang."}$json$::jsonb),
('banking-basics-choosing-the-right-account-part-2', $json${"type":"multiple_choice","question":"What does a source date help you remember?","options":["A rate or limit may need rechecking","Every old term is permanent","A screenshot is official","A product is risk-free"],"answer":"A rate or limit may need rechecking","difficulty":"beginner","explanation":"The date keeps changing product details in context."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang diingatkan oleh tanggal sumber?","options":["Tarif atau batas mungkin perlu dicek lagi","Semua syarat lama permanen","Tangkapan layar pasti resmi","Produk bebas risiko"],"answer":"Tarif atau batas mungkin perlu dicek lagi","difficulty":"beginner","explanation":"Tanggal membuat detail produk yang berubah tetap berada dalam konteks."}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage', $json${"type":"multiple_choice","question":"What should you check before confirming a QRIS payment?","options":["The merchant name and amount","Only the QR colour","A message from a stranger","Only the cashback"],"answer":"The merchant name and amount","difficulty":"beginner","explanation":"The displayed merchant and amount are part of the payment check."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang diperiksa sebelum mengonfirmasi pembayaran QRIS?","options":["Nama merchant dan jumlah","Hanya warna QR","Pesan dari orang asing","Hanya cashback"],"answer":"Nama merchant dan jumlah","difficulty":"beginner","explanation":"Nama merchant dan jumlah yang tampil adalah bagian dari pemeriksaan pembayaran."}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage', $json${"type":"multiple_choice","question":"What is the last step in the payment flow?","options":["Keep the confirmation proof","Share your OTP","Close the app without reading","Ignore a mismatch"],"answer":"Keep the confirmation proof","difficulty":"beginner","explanation":"Proof helps you report a mismatch through the official route."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa langkah terakhir dalam alur pembayaran?","options":["Simpan bukti konfirmasi","Bagikan OTP","Tutup aplikasi tanpa membaca","Abaikan ketidaksesuaian"],"answer":"Simpan bukti konfirmasi","difficulty":"beginner","explanation":"Bukti membantu melaporkan ketidaksesuaian melalui jalur resmi."}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage', $json${"type":"multiple_choice","question":"When should you stop a QR payment?","options":["When the merchant, amount, or result does not match","When the logo is familiar","When the queue is short","When a message promises a reward"],"answer":"When the merchant, amount, or result does not match","difficulty":"beginner","explanation":"A mismatch is a reason to pause and verify, not to continue under pressure."}$json$::jsonb, $json${"type":"multiple_choice","question":"Kapan kamu harus menghentikan pembayaran QR?","options":["Saat merchant, jumlah, atau hasilnya tidak cocok","Saat logonya familiar","Saat antreannya pendek","Saat pesan menjanjikan hadiah"],"answer":"Saat merchant, jumlah, atau hasilnya tidak cocok","difficulty":"beginner","explanation":"Ketidaksesuaian adalah alasan untuk berhenti dan memverifikasi, bukan lanjut karena tekanan."}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage-part-2', $json${"type":"multiple_choice","question":"Which credential should never be shared with support by message?","options":["A PIN, password, or OTP","A public merchant name","A receipt date","A product title"],"answer":"A PIN, password, or OTP","difficulty":"beginner","explanation":"Keep payment secrets private and use official support routes."}$json$::jsonb, $json${"type":"multiple_choice","question":"Kredensial mana yang tidak boleh dibagikan kepada dukungan lewat pesan?","options":["PIN, kata sandi, atau OTP","Nama merchant yang publik","Tanggal struk","Judul produk"],"answer":"PIN, kata sandi, atau OTP","difficulty":"beginner","explanation":"Jaga rahasia pembayaran dan gunakan jalur dukungan resmi."}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage-part-2', $json${"type":"multiple_choice","question":"Where should you check current fee and dispute terms?","options":["The official app or provider channel","A random forwarded message","A stranger's link","A promotional comment"],"answer":"The official app or provider channel","difficulty":"beginner","explanation":"Current terms should be checked through an official route."}$json$::jsonb, $json${"type":"multiple_choice","question":"Di mana kamu memeriksa biaya dan ketentuan sengketa terbaru?","options":["Aplikasi atau kanal resmi penyedia","Pesan terusan acak","Tautan orang asing","Komentar promosi"],"answer":"Aplikasi atau kanal resmi penyedia","difficulty":"beginner","explanation":"Ketentuan terbaru perlu dicek melalui jalur resmi."}$json$::jsonb),
('digital-wallets-qris-safe-and-smart-usage-part-2', $json${"type":"multiple_choice","question":"What does convenience not remove?","options":["Fraud and overspending risk","The need to read the amount","The need for proof","The need for private credentials"],"answer":"Fraud and overspending risk","difficulty":"beginner","explanation":"A popular or fast wallet can still be misused or encourage spending beyond a budget."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang tidak dihapus oleh kenyamanan?","options":["Risiko penipuan dan belanja berlebihan","Kebutuhan membaca jumlah","Kebutuhan menyimpan bukti","Kebutuhan menjaga kredensial"],"answer":"Risiko penipuan dan belanja berlebihan","difficulty":"beginner","explanation":"Dompet yang populer atau cepat tetap dapat disalahgunakan atau mendorong belanja di luar anggaran."}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance', $json${"type":"multiple_choice","question":"What should a health-cover comparison include?","options":["Coverage, access rules, limits, and claims","Only the product label","Only the logo","A guaranteed return"],"answer":"Coverage, access rules, limits, and claims","difficulty":"beginner","explanation":"The terms determine what a label means in practice."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa yang termasuk dalam perbandingan perlindungan kesehatan?","options":["Cakupan, aturan akses, batas, dan klaim","Hanya label produk","Hanya logo","Imbal hasil yang dijamin"],"answer":"Cakupan, aturan akses, batas, dan klaim","difficulty":"beginner","explanation":"Ketentuan menentukan arti label dalam praktik."}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance', $json${"type":"multiple_choice","question":"Why should current official terms be checked?","options":["Eligibility and coverage rules can change","A label never changes","A premium guarantees a claim","All products have the same limits"],"answer":"Eligibility and coverage rules can change","difficulty":"beginner","explanation":"Current product and provider information matters for a real decision."}$json$::jsonb, $json${"type":"multiple_choice","question":"Mengapa syarat resmi terbaru perlu dicek?","options":["Aturan kelayakan dan cakupan dapat berubah","Label tidak pernah berubah","Premi menjamin klaim","Semua produk memiliki batas sama"],"answer":"Aturan kelayakan dan cakupan dapat berubah","difficulty":"beginner","explanation":"Informasi produk dan penyedia terbaru penting untuk keputusan nyata."}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance', $json${"type":"multiple_choice","question":"What is a safer comparison habit?","options":["Read exclusions and claims rules beside the coverage","Choose from the name alone","Ignore affordability","Treat a promise as proof"],"answer":"Read exclusions and claims rules beside the coverage","difficulty":"beginner","explanation":"Exclusions and claims rules are part of the protection boundary."}$json$::jsonb, $json${"type":"multiple_choice","question":"Kebiasaan perbandingan mana yang lebih aman?","options":["Baca pengecualian dan aturan klaim di samping cakupan","Pilih hanya dari nama","Abaikan kemampuan membayar","Anggap janji sebagai bukti"],"answer":"Baca pengecualian dan aturan klaim di samping cakupan","difficulty":"beginner","explanation":"Pengecualian dan aturan klaim adalah bagian dari batas perlindungan."}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance-part-2', $json${"type":"multiple_choice","question":"Which question comes first when thinking about life cover?","options":["Who depends on the income?","Which logo is largest?","What return is guaranteed?","Which product is trending?"],"answer":"Who depends on the income?","difficulty":"beginner","explanation":"Dependants and the risk to essentials help frame useful questions without choosing a product for everyone."}$json$::jsonb, $json${"type":"multiple_choice","question":"Pertanyaan apa yang lebih dulu dipikirkan saat mempertimbangkan perlindungan jiwa?","options":["Siapa yang bergantung pada penghasilan?","Logo mana yang terbesar?","Imbal hasil apa yang dijamin?","Produk mana yang sedang tren?"],"answer":"Siapa yang bergantung pada penghasilan?","difficulty":"beginner","explanation":"Tanggungan dan risiko terhadap kebutuhan pokok membantu membingkai pertanyaan tanpa memilih produk untuk semua orang."}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance-part-2', $json${"type":"multiple_choice","question":"Which detail belongs in the protection comparison?","options":["Exclusions, affordability, and claims route","Only a return promise","Only a social review","The colour of the card"],"answer":"Exclusions, affordability, and claims route","difficulty":"beginner","explanation":"These details define the practical boundary of a policy."}$json$::jsonb, $json${"type":"multiple_choice","question":"Detail mana yang termasuk dalam perbandingan perlindungan?","options":["Pengecualian, kemampuan membayar, dan jalur klaim","Hanya janji imbal hasil","Hanya ulasan sosial","Warna kartu"],"answer":"Pengecualian, kemampuan membayar, dan jalur klaim","difficulty":"beginner","explanation":"Detail ini menentukan batas praktis sebuah polis."}$json$::jsonb),
('insurance-basics-bpjs-vs-private-insurance-part-2', $json${"type":"multiple_choice","question":"What is the role of a protection checklist?","options":["It helps you ask better questions; it does not choose for everyone","It guarantees a claim","It replaces official terms","It ranks providers"],"answer":"It helps you ask better questions; it does not choose for everyone","difficulty":"beginner","explanation":"A checklist supports understanding without becoming personalised advice."}$json$::jsonb, $json${"type":"multiple_choice","question":"Apa peran daftar periksa perlindungan?","options":["Membantu bertanya lebih baik; bukan memilih untuk semua orang","Menjamin klaim","Menggantikan syarat resmi","Memberi peringkat penyedia"],"answer":"Membantu bertanya lebih baik; bukan memilih untuk semua orang","difficulty":"beginner","explanation":"Daftar periksa membantu pemahaman tanpa menjadi nasihat pribadi."}$json$::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied JOIN public.lessons lesson ON lesson.slug = applied.slug
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants existing
  WHERE existing.lesson_id = lesson.id
    AND existing.variant_type = 'question'
    AND existing.topic_tag = 'visual_applied'
    AND existing.body->>'question' = applied.body->>'question'
);

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (VALUES
('net-worth-know-your-financial-position','Five days ago, you learned the net-worth formula. What does it compare?','Lima hari lalu, kamu belajar rumus kekayaan bersih. Apa yang dibandingkan?',$json$[{"id":"formula","label":"Assets minus liabilities"},{"id":"income","label":"Income minus spending"},{"id":"score","label":"A personal score"}]$json$::jsonb,$json$[{"id":"formula","label":"Aset dikurangi liabilitas"},{"id":"income","label":"Pendapatan dikurangi belanja"},{"id":"score","label":"Nilai pribadi"}]$json$::jsonb,'formula','The formula uses two columns: what you own and what you owe.','Rumus menggunakan dua kolom: yang dimiliki dan yang terutang.'),
('net-worth-know-your-financial-position-part-2','Five days ago, you learned to date a net-worth snapshot. Why?','Lima hari lalu, kamu belajar memberi tanggal pada potret kekayaan bersih. Mengapa?',$json$[{"id":"change","label":"Balances and values can change"},{"id":"guarantee","label":"It guarantees the next result"},{"id":"rank","label":"It ranks your worth"}]$json$::jsonb,$json$[{"id":"change","label":"Saldo dan nilai dapat berubah"},{"id":"guarantee","label":"Menjamin hasil berikutnya"},{"id":"rank","label":"Memberi peringkat nilai dirimu"}]$json$::jsonb,'change','The date preserves the context of the observation.','Tanggal menjaga konteks pengamatan.'),
('banking-basics-choosing-the-right-account','Five days ago, you learned to match an account to a job. What else should you compare?','Lima hari lalu, kamu belajar mencocokkan rekening dengan tugasnya. Apa lagi yang dibandingkan?',$json$[{"id":"terms","label":"Access, fees, minimum balance, and current terms"},{"id":"logo","label":"Only the logo"},{"id":"rate","label":"Only the headline rate"}]$json$::jsonb,$json$[{"id":"terms","label":"Akses, biaya, saldo minimum, dan ketentuan terbaru"},{"id":"logo","label":"Hanya logo"},{"id":"rate","label":"Hanya tarif utama"}]$json$::jsonb,'terms','The job and the current terms belong in the same comparison.','Tugas dan ketentuan terbaru perlu dibaca dalam satu perbandingan.'),
('banking-basics-choosing-the-right-account-part-2','Five days ago, you learned to check changing account terms. What is a pause signal?','Lima hari lalu, kamu belajar memeriksa ketentuan rekening yang berubah. Apa sinyal untuk berhenti?',$json$[{"id":"pressure","label":"Pressure to deposit quickly"},{"id":"source","label":"A dated official source"},{"id":"fees","label":"Clear fees"}]$json$::jsonb,$json$[{"id":"pressure","label":"Desakan untuk segera menyetor"},{"id":"source","label":"Sumber resmi bertanggal"},{"id":"fees","label":"Biaya yang jelas"}]$json$::jsonb,'pressure','Pressure is a reason to verify independently, not a reason to hurry.','Desakan adalah alasan untuk memverifikasi secara mandiri, bukan terburu-buru.'),
('digital-wallets-qris-safe-and-smart-usage','Five days ago, you learned the QRIS check. What should you read before confirming?','Lima hari lalu, kamu belajar pemeriksaan QRIS. Apa yang dibaca sebelum mengonfirmasi?',$json$[{"id":"details","label":"Merchant name and amount"},{"id":"logo","label":"Only the logo"},{"id":"reward","label":"Only a reward message"}]$json$::jsonb,$json$[{"id":"details","label":"Nama merchant dan jumlah"},{"id":"logo","label":"Hanya logo"},{"id":"reward","label":"Hanya pesan hadiah"}]$json$::jsonb,'details','The payment details are more important than a familiar visual identity.','Detail pembayaran lebih penting daripada tampilan visual yang familiar.'),
('digital-wallets-qris-safe-and-smart-usage-part-2','Five days ago, you learned the wallet safety boundary. Which secret stays private?','Lima hari lalu, kamu belajar batas aman dompet digital. Rahasia mana yang tetap pribadi?',$json$[{"id":"secret","label":"PIN, password, or OTP"},{"id":"receipt","label":"A receipt date"},{"id":"merchant","label":"A public merchant name"}]$json$::jsonb,$json$[{"id":"secret","label":"PIN, kata sandi, atau OTP"},{"id":"receipt","label":"Tanggal struk"},{"id":"merchant","label":"Nama merchant yang publik"}]$json$::jsonb,'secret','Payment credentials must not be shared through messages.','Kredensial pembayaran tidak boleh dibagikan melalui pesan.'),
('insurance-basics-bpjs-vs-private-insurance','Five days ago, you learned to compare health cover. Which detail matters?','Lima hari lalu, kamu belajar membandingkan perlindungan kesehatan. Detail apa yang penting?',$json$[{"id":"terms","label":"Coverage, limits, access, and claims"},{"id":"label","label":"Only the label"},{"id":"promise","label":"Only a promise"}]$json$::jsonb,$json$[{"id":"terms","label":"Cakupan, batas, akses, dan klaim"},{"id":"label","label":"Hanya label"},{"id":"promise","label":"Hanya janji"}]$json$::jsonb,'terms','The terms give the label its practical meaning.','Ketentuan memberi arti praktis pada label.'),
('insurance-basics-bpjs-vs-private-insurance-part-2','Five days ago, you learned to prioritise protection questions. What should a checklist avoid?','Lima hari lalu, kamu belajar memprioritaskan pertanyaan perlindungan. Apa yang harus dihindari daftar periksa?',$json$[{"id":"advice","label":"Turning a general checklist into a universal product recommendation"},{"id":"questions","label":"Asking about exclusions and claims"},{"id":"affordability","label":"Checking affordability"}]$json$::jsonb,$json$[{"id":"advice","label":"Mengubah daftar umum menjadi rekomendasi produk universal"},{"id":"questions","label":"Menanyakan pengecualian dan klaim"},{"id":"affordability","label":"Memeriksa kemampuan membayar"}]$json$::jsonb,'advice','A checklist supports questions; current terms and personal circumstances still matter.','Daftar periksa membantu bertanya; ketentuan terbaru dan kondisi pribadi tetap penting.')
)
INSERT INTO public.lesson_recall_questions (lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
SELECT lesson.id, recalls.question_en, recalls.question_id, recalls.options_en, recalls.options_id,
  recalls.correct_option, recalls.explanation_en, recalls.explanation_id, TRUE
FROM recalls JOIN public.lessons lesson ON lesson.slug = recalls.slug
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en, question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en, options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option, explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id, is_active = TRUE, updated_at = NOW();

COMMIT;
