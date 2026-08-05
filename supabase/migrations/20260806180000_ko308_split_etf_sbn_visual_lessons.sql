-- KO-308: split the ETF and SBN lessons into short, source-backed parts.
-- Part 1 keeps the existing learner progress row; Part 2 is a new explicit
-- lesson. All examples are illustrative and do not recommend an instrument.

BEGIN;

UPDATE public.lessons
SET
  title = 'ETFs, Part 1: What the basket holds',
  title_id = 'ETF, Bagian 1: Isi dalam satu keranjang',
  summary = 'Learn how an ETF bundles assets and trades on the exchange, then inspect the index, holdings, and data source before drawing a conclusion.',
  summary_id = 'Pelajari cara ETF menggabungkan aset dan diperdagangkan di bursa, lalu periksa indeks, isi, dan sumber data sebelum menarik kesimpulan.',
  concept_body = $body$
An ETF (Exchange Traded Fund) is a fund that holds a basket of assets and trades on an exchange like a listed instrument.

Think of the basket in three questions:

1. **What does it hold?** An ETF may hold shares, bonds, or another defined group of assets.
2. **What does it track?** Read the stated index or investment objective rather than guessing from the name.
3. **Where does it trade?** An exchange-traded product uses a trading account and a market price, so its price can move while the market is open.

An ETF can spread exposure across several holdings, but the basket still has market, tracking, liquidity, and fee risks. Diversification is a description of the basket, not a guarantee of safety.
  $body$,
  concept_body_id = $body_id$
ETF (Exchange Traded Fund) adalah dana yang memegang kumpulan aset dan diperdagangkan di bursa seperti instrumen tercatat.

Pahami isi keranjangnya melalui tiga pertanyaan:

1. **Apa yang dimiliki?** ETF bisa memegang saham, obligasi, atau kelompok aset tertentu.
2. **Apa yang dilacak?** Baca indeks atau tujuan investasinya, jangan menebak dari namanya.
3. **Di mana diperdagangkan?** Produk yang diperdagangkan di bursa memakai rekening efek dan harga pasar, sehingga harganya bisa berubah selama pasar buka.

ETF dapat menyebarkan eksposur ke beberapa kepemilikan, tetapi tetap memiliki risiko pasar, tracking error, likuiditas, dan biaya. Diversifikasi menjelaskan isi keranjang, bukan jaminan keamanan.
  $body_id$,
  indonesian_example = 'Bayu membandingkan nama ETF dengan indeks yang dilacak dan daftar kepemilikannya. Ia mencatat bahwa satu unit memberi eksposur ke keranjang, bukan jaminan bahwa setiap isi keranjang akan naik.',
  why_this_matters = 'Reading the basket and its source helps you understand what an ETF actually exposes you to before comparing it with another product.',
  why_this_matters_id = 'Membaca isi keranjang dan sumbernya membantu memahami eksposur ETF sebelum membandingkannya dengan produk lain.',
  common_mistake = 'Assuming an ETF is automatically safe because it holds many assets.',
  common_mistake_id = 'Menganggap ETF otomatis aman hanya karena memegang banyak aset.',
  estimated_minutes = 4,
  updated_at = NOW()
WHERE slug = 'etfs-investing-with-one-click';

UPDATE public.lessons
SET
  title = 'Bonds & SBN, Part 1: The lending relationship',
  title_id = 'Obligasi & SBN, Bagian 1: Hubungan pinjaman',
  summary = 'Learn what an SBN represents, then separate issuer, coupon, term, and access before comparing an offer.',
  summary_id = 'Pelajari arti SBN, lalu bedakan penerbit, kupon, tenor, dan akses sebelum membandingkan suatu penawaran.',
  concept_body = $body$
A government bond is a debt instrument: the buyer lends money to the issuer under stated terms. Retail SBN are Indonesian government securities offered under specific programmes and terms.

Read an SBN description in four passes:

1. **Issuer:** confirm which government programme and official source are being described.
2. **Coupon:** check whether the coupon is fixed or follows a stated rule.
3. **Term:** note when the instrument matures and when money may be accessed.
4. **Route:** check the current offering or distribution channel and the account requirements.

“Government” does not mean “no risk”. Price, interest-rate, inflation, liquidity, and opportunity-cost questions still matter. Treat every series, rate, deadline, and tax detail as time-sensitive.
  $body$,
  concept_body_id = $body_id$
Obligasi pemerintah adalah instrumen utang: pembeli meminjamkan uang kepada penerbit berdasarkan ketentuan yang tercantum. SBN ritel adalah surat berharga pemerintah Indonesia yang ditawarkan melalui program dan ketentuan tertentu.

Baca deskripsi SBN melalui empat langkah:

1. **Penerbit:** pastikan program pemerintah dan sumber resminya.
2. **Kupon:** periksa apakah kupon tetap atau mengikuti aturan tertentu.
3. **Tenor:** catat kapan jatuh tempo dan kapan dana dapat diakses.
4. **Jalur:** periksa penawaran atau kanal distribusi yang berlaku serta persyaratan rekening.

“Pemerintah” bukan berarti “tanpa risiko”. Pertanyaan tentang harga, suku bunga, inflasi, likuiditas, dan biaya peluang tetap penting. Setiap seri, tarif, tenggat, dan detail pajak perlu dianggap sensitif terhadap waktu.
  $body_id$,
  indonesian_example = 'Rina mencatat penerbit, kupon, tenor, dan jalur penawaran SBN dari sumber resmi. Ia tidak menganggap contoh seri lama atau angka kupon lama berlaku untuk penawaran berikutnya.',
  why_this_matters = 'Separating the lending terms from the marketing headline makes it easier to compare an SBN without treating it as risk-free.',
  why_this_matters_id = 'Memisahkan ketentuan pinjaman dari judul promosi membantu membandingkan SBN tanpa menganggapnya bebas risiko.',
  common_mistake = 'Treating a government bond as risk-free or assuming one series’ terms apply to every series.',
  common_mistake_id = 'Menganggap obligasi pemerintah bebas risiko atau mengira ketentuan satu seri berlaku untuk semua seri.',
  estimated_minutes = 4,
  updated_at = NOW()
WHERE slug = 'bonds-sbn-safe-investing-with-the-government';

WITH part_specs(slug, source_slug, title, title_id, summary, summary_id, concept_body, concept_body_id, indonesian_example, why_this_matters, why_this_matters_id, common_mistake, common_mistake_id, lesson_number) AS (
  VALUES
  (
    'etfs-investing-with-one-click-part-2', 'etfs-investing-with-one-click',
    'ETFs, Part 2: Price, costs, and risk', 'ETF, Bagian 2: Harga, biaya, dan risiko',
    'Use a simple ETF comparison to separate market price, fees, tracking, and liquidity risks.',
    'Gunakan perbandingan ETF sederhana untuk membedakan harga pasar, biaya, tracking error, dan risiko likuiditas.',
    $body$An ETF price can change with market demand even when its holdings are not all moving in the same way. Before comparing two ETFs, check the stated basket or index, the latest official list, fees, trading activity, and how closely the product is designed to track its objective.

An illustrative calculation can show the mechanics: 100 units × Rp 5,000 = Rp 500,000 before transaction costs. That arithmetic does not predict a return. A lower fee does not remove market or tracking risk, and a tradeable product may still be hard to exit at a preferred price.

Use the current IDX ETF information and product documents for changing names, holdings, dates, and terms.$body$,
    $body_id$Harga ETF dapat berubah mengikuti permintaan pasar meskipun semua aset di dalamnya tidak bergerak dengan cara yang sama. Sebelum membandingkan dua ETF, periksa keranjang atau indeksnya, daftar resmi terbaru, biaya, aktivitas perdagangan, dan cara produk tersebut melacak tujuannya.

Contoh ilustratif dapat menunjukkan mekanismenya: 100 unit × Rp 5.000 = Rp 500.000 sebelum biaya transaksi. Perhitungan itu tidak memprediksi imbal hasil. Biaya lebih rendah tidak menghapus risiko pasar atau tracking error, dan produk yang dapat diperdagangkan tetap bisa sulit dijual pada harga yang diinginkan.

Gunakan informasi ETF IDX dan dokumen produk yang berlaku untuk nama, kepemilikan, tanggal, dan ketentuan yang dapat berubah.$body_id$,
    'Bayu compares two ETF factsheets using the same checklist. He writes down the basket, fee, source date, and liquidity question instead of ranking one as automatically better.',
    'A checklist keeps a simple price calculation from being mistaken for a return forecast.',
    'Daftar periksa mencegah perhitungan harga sederhana dianggap sebagai prediksi imbal hasil.',
    'Believing a low fee or a familiar index removes every other risk.',
    'Menganggap biaya rendah atau indeks yang dikenal menghapus semua risiko lain.',
    170
  ),
  (
    'bonds-sbn-safe-investing-with-the-government-part-2', 'bonds-sbn-safe-investing-with-the-government',
    'Bonds & SBN, Part 2: Terms and trade-offs', 'Obligasi & SBN, Bagian 2: Ketentuan dan kompromi',
    'Compare coupon, maturity, access, and changing conditions without turning a historical SBN example into a promise.',
    'Bandingkan kupon, jatuh tempo, akses, dan kondisi yang berubah tanpa menjadikan contoh SBN historis sebagai janji.',
    $body$An SBN comparison should place the terms side by side: coupon rule, maturity, access or early-redemption conditions, tax treatment, and the date the information was checked.

For a calculated example only, Rp 1,000,000 × an illustrative 6% annual coupon = Rp 60,000 gross annual coupon. The actual amount, schedule, tax, and product terms depend on the named series and current official documents. The example says nothing about suitability or future returns.

The trade-off is the lesson: a predictable term can coexist with inflation, interest-rate, liquidity, and opportunity-cost risks. Check the current Kemenkeu, DJPPR, and OJK material before relying on a detail.$body$,
    $body_id$Perbandingan SBN sebaiknya menempatkan ketentuan secara berdampingan: aturan kupon, jatuh tempo, akses atau penarikan dini, perlakuan pajak, dan tanggal pemeriksaan informasi.

Sebagai contoh perhitungan saja, Rp 1.000.000 × kupon tahunan ilustratif 6% = Rp 60.000 kupon kotor per tahun. Jumlah, jadwal, pajak, dan ketentuan sebenarnya bergantung pada seri yang disebut dan dokumen resmi terbaru. Contoh ini tidak menjelaskan kecocokan atau imbal hasil masa depan.

Inilah komprominya: ketentuan yang lebih mudah diprediksi tetap dapat memiliki risiko inflasi, suku bunga, likuiditas, dan biaya peluang. Periksa materi Kemenkeu, DJPPR, dan OJK yang berlaku sebelum mengandalkan suatu detail.$body_id$,
    'Rina records the SBN series and review date beside the coupon example. She knows that a historical coupon or tax detail must not be copied into a new offer without checking the current document.',
    'The comparison is useful only when the series, date, and rule are kept together.',
    'Perbandingan hanya berguna jika seri, tanggal, dan aturannya tetap dicatat bersama.',
    'Copying a coupon, tax, or maturity detail from one series into another.',
    'Menyalin detail kupon, pajak, atau jatuh tempo dari satu seri ke seri lain.',
    171
  )
), inserted AS (
  INSERT INTO public.lessons (
    slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward,
    estimated_minutes, summary, summary_id, concept_body, concept_body_id,
    indonesian_example, why_this_matters, why_this_matters_id, common_mistake,
    common_mistake_id, review_status, reviewed_by, reviewed_at, is_published,
    jurisdiction, prerequisite_lesson_id
  )
  SELECT p.slug, p.title, p.title_id, base.topic_id, p.lesson_number, base.difficulty,
    base.xp_reward, 4, p.summary, p.summary_id, p.concept_body, p.concept_body_id,
    p.indonesian_example, p.why_this_matters, p.why_this_matters_id,
    p.common_mistake, p.common_mistake_id, base.review_status, base.reviewed_by,
    base.reviewed_at, TRUE, base.jurisdiction, base.id
  FROM part_specs p
  JOIN public.lessons base ON base.slug = p.source_slug
  ON CONFLICT (slug) DO UPDATE SET
    title = EXCLUDED.title, title_id = EXCLUDED.title_id, summary = EXCLUDED.summary,
    summary_id = EXCLUDED.summary_id, concept_body = EXCLUDED.concept_body,
    concept_body_id = EXCLUDED.concept_body_id, indonesian_example = EXCLUDED.indonesian_example,
    why_this_matters = EXCLUDED.why_this_matters, why_this_matters_id = EXCLUDED.why_this_matters_id,
    common_mistake = EXCLUDED.common_mistake, common_mistake_id = EXCLUDED.common_mistake_id,
    estimated_minutes = EXCLUDED.estimated_minutes, is_published = TRUE,
    prerequisite_lesson_id = EXCLUDED.prerequisite_lesson_id, updated_at = NOW()
  RETURNING id, slug
)
SELECT 1 FROM inserted;

-- A split part inherits the source-review decision of its reviewed parent.
INSERT INTO public.lesson_reviews (
  lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status,
  source_verification_status, indonesia_context_status, compliance_status, notes,
  approved_to_publish
)
SELECT child.id, parent_review.reviewer_name, parent_review.reviewer_role,
  parent_review.review_date, parent_review.factual_accuracy_status,
  parent_review.source_verification_status, parent_review.indonesia_context_status,
  parent_review.compliance_status,
  'KO-308 split part; verify changing product terms against linked official sources.',
  parent_review.approved_to_publish
FROM public.lessons child
JOIN public.lessons parent ON parent.slug = CASE
  WHEN child.slug = 'etfs-investing-with-one-click-part-2' THEN 'etfs-investing-with-one-click'
  ELSE 'bonds-sbn-safe-investing-with-the-government'
END
JOIN public.lesson_reviews parent_review ON parent_review.lesson_id = parent.id
WHERE child.slug IN ('etfs-investing-with-one-click-part-2', 'bonds-sbn-safe-investing-with-the-government-part-2')
  AND NOT EXISTS (SELECT 1 FROM public.lesson_reviews existing WHERE existing.lesson_id = child.id);

WITH source_map(slug, source_code, display_order) AS (
  VALUES
    ('etfs-investing-with-one-click', 'CH08-IDX-ETF-OVERVIEW', 10),
    ('etfs-investing-with-one-click', 'CH08-IDX-ETF-LIST', 20),
    ('etfs-investing-with-one-click', 'CH08-IDX-TRADING', 30),
    ('etfs-investing-with-one-click-part-2', 'CH08-IDX-ETF-OVERVIEW', 10),
    ('etfs-investing-with-one-click-part-2', 'CH08-IDX-ETF-LIST', 20),
    ('etfs-investing-with-one-click-part-2', 'CH08-IDX-TRADING', 30),
    ('bonds-sbn-safe-investing-with-the-government', 'CH08-KEMENKEU-SBN', 10),
    ('bonds-sbn-safe-investing-with-the-government', 'CH08-DJPPR-ORI', 20),
    ('bonds-sbn-safe-investing-with-the-government', 'CH08-OJK-SBN-GUIDE', 30),
    ('bonds-sbn-safe-investing-with-the-government-part-2', 'CH08-KEMENKEU-SBN', 10),
    ('bonds-sbn-safe-investing-with-the-government-part-2', 'CH08-DJPPR-ORI', 20),
    ('bonds-sbn-safe-investing-with-the-government-part-2', 'CH08-OJK-SBN-GUIDE', 30)
  )
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, CASE WHEN source_map.display_order = 10 THEN 'primary' ELSE 'supporting' END,
  source_map.source_code, source_map.display_order = 10, source_map.display_order
FROM source_map
JOIN public.lessons lesson ON lesson.slug = source_map.slug
JOIN public.sources source ON source.source_code = source_map.source_code
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type, citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary, display_order = EXCLUDED.display_order;

WITH visual_blocks(slug, block_type, display_order, data_status, content) AS (
  VALUES
  ('etfs-investing-with-one-click', 'process', 10, 'source_derived', $json${
    "en": {"eyebrow":"ETF reading path","title":"Read the basket before the label","disclosure":"Check the named IDX ETF overview/list; reviewed 2026-08-05. Product names and holdings can change.","altText":"A four-step path from the ETF objective to its basket, trading route, and risk questions.","payload":{"steps":[{"title":"1. Objective","description":"Find the stated index or investment objective."},{"title":"2. Basket","description":"Check which assets and holdings are included."},{"title":"3. Market","description":"Remember that an exchange price can move during trading."},{"title":"4. Questions","description":"Check fees, tracking, liquidity, and the source date."}]}},
    "id": {"eyebrow":"Alur membaca ETF","title":"Baca isi keranjang sebelum labelnya","disclosure":"Periksa daftar/info ETF IDX yang disebut; ditinjau 5 Agustus 2026. Nama dan kepemilikan produk dapat berubah.","altText":"Alur empat langkah dari tujuan ETF ke isi keranjang, jalur perdagangan, dan pertanyaan risiko.","payload":{"steps":[{"title":"1. Tujuan","description":"Cari indeks atau tujuan investasi yang tercantum."},{"title":"2. Keranjang","description":"Periksa aset dan kepemilikan di dalamnya."},{"title":"3. Pasar","description":"Ingat bahwa harga bursa bisa berubah saat perdagangan."},{"title":"4. Pertanyaan","description":"Periksa biaya, tracking, likuiditas, dan tanggal sumber."}]}}
  }$json$::jsonb),
  ('etfs-investing-with-one-click', 'comparison', 20, 'illustrative', $json${
    "en": {"title":"Diversified is not risk-free","disclosure":"Illustrative boundary for learning, not an ETF recommendation.","altText":"A comparison between what an ETF basket can provide and what it cannot promise.","payload":{"leftTitle":"What a basket can do","rightTitle":"What it cannot promise","rows":[{"left":"Spread exposure across holdings.","right":"Every holding rises together."},{"left":"Make the objective easier to inspect.","right":"Remove market or tracking risk."},{"left":"Trade through an exchange route.","right":"Guarantee an exit price."}]}},
    "id": {"title":"Diversifikasi bukan bebas risiko","disclosure":"Batas ilustratif untuk belajar, bukan rekomendasi ETF.","altText":"Perbandingan antara hal yang dapat diberikan keranjang ETF dan hal yang tidak dapat dijaminnya.","payload":{"leftTitle":"Yang bisa dilakukan keranjang","rightTitle":"Yang tidak bisa dijamin","rows":[{"left":"Menyebarkan eksposur ke beberapa kepemilikan.","right":"Semua kepemilikan naik bersama."},{"left":"Membuat tujuan lebih mudah diperiksa.","right":"Menghapus risiko pasar atau tracking error."},{"left":"Diperdagangkan melalui jalur bursa.","right":"Menjamin harga saat keluar."}]}}
  }$json$::jsonb),
  ('etfs-investing-with-one-click-part-2', 'worked_example', 10, 'calculated', $json${
    "en": {"eyebrow":"Illustrative arithmetic","title":"Unit price is not a return","disclosure":"Calculated example before transaction costs; not a live quote or return forecast.","altText":"A calculation multiplying 100 ETF units by an illustrative Rp 5,000 price and separating the result from a return forecast.","payload":{"inputs":[{"label":"Units","value":"100"},{"label":"Illustrative unit price","value":"Rp 5,000"},{"label":"Before-cost total","value":"Rp 500,000"}],"steps":["100 units × Rp 5,000 = Rp 500,000.","Add applicable transaction costs when comparing the amount paid.","Do not turn the arithmetic into a prediction."],"outcome":"The calculation explains an amount paid; it does not say what the ETF will be worth later."}},
    "id": {"eyebrow":"Perhitungan ilustratif","title":"Harga unit bukan imbal hasil","disclosure":"Contoh perhitungan sebelum biaya transaksi; bukan kutipan langsung atau prediksi imbal hasil.","altText":"Perhitungan 100 unit ETF dikalikan harga ilustratif Rp 5.000 dan pemisahan hasilnya dari prediksi imbal hasil.","payload":{"inputs":[{"label":"Unit","value":"100"},{"label":"Harga unit ilustratif","value":"Rp 5.000"},{"label":"Total sebelum biaya","value":"Rp 500.000"}],"steps":["100 unit × Rp 5.000 = Rp 500.000.","Tambahkan biaya transaksi yang berlaku saat membandingkan jumlah pembayaran.","Jangan mengubah perhitungan menjadi prediksi."],"outcome":"Perhitungan menjelaskan jumlah pembayaran; bukan nilai ETF di masa depan."}}
  }$json$::jsonb),
  ('etfs-investing-with-one-click-part-2', 'comparison', 20, 'illustrative', $json${
    "en": {"title":"Four checks before comparing ETFs","disclosure":"Use current product documents for changing details.","altText":"Four checks for comparing an ETF: basket, cost, tracking, and liquidity.","payload":{"leftTitle":"Check","rightTitle":"Question","rows":[{"left":"Basket","right":"What assets and index are named?"},{"left":"Cost","right":"Which fees are disclosed?"},{"left":"Tracking","right":"How is the objective followed?"},{"left":"Liquidity","right":"How active is the market and how might exit work?"}]}},
    "id": {"title":"Empat pemeriksaan sebelum membandingkan ETF","disclosure":"Gunakan dokumen produk terbaru untuk detail yang dapat berubah.","altText":"Empat pemeriksaan untuk membandingkan ETF: keranjang, biaya, pelacakan, dan likuiditas.","payload":{"leftTitle":"Periksa","rightTitle":"Pertanyaan","rows":[{"left":"Keranjang","right":"Aset dan indeks apa yang disebut?"},{"left":"Biaya","right":"Biaya apa yang diungkapkan?"},{"left":"Pelacakan","right":"Bagaimana tujuan tersebut dilacak?"},{"left":"Likuiditas","right":"Seberapa aktif pasarnya dan bagaimana proses keluarnya?"}]}}
  }$json$::jsonb),
  ('bonds-sbn-safe-investing-with-the-government', 'process', 10, 'source_derived', $json${
    "en": {"eyebrow":"SBN reading path","title":"Follow the terms, not the headline","disclosure":"Check the named Kemenkeu, DJPPR, and OJK sources; reviewed 2026-08-05. Series and terms are time-sensitive.","altText":"A four-step path for reading an SBN: issuer, coupon, term, and access route.","payload":{"steps":[{"title":"1. Issuer","description":"Name the government programme or series."},{"title":"2. Coupon","description":"Check the fixed or stated coupon rule."},{"title":"3. Term","description":"Record maturity and access conditions."},{"title":"4. Route","description":"Verify the current official offering and account path."}]}},
    "id": {"eyebrow":"Alur membaca SBN","title":"Ikuti ketentuannya, bukan judulnya","disclosure":"Periksa sumber Kemenkeu, DJPPR, dan OJK yang disebut; ditinjau 5 Agustus 2026. Seri dan ketentuan sensitif terhadap waktu.","altText":"Alur empat langkah membaca SBN: penerbit, kupon, tenor, dan jalur akses.","payload":{"steps":[{"title":"1. Penerbit","description":"Sebutkan program atau seri pemerintah."},{"title":"2. Kupon","description":"Periksa aturan kupon tetap atau kupon yang tercantum."},{"title":"3. Tenor","description":"Catat jatuh tempo dan ketentuan akses."},{"title":"4. Jalur","description":"Verifikasi penawaran resmi dan jalur rekening yang berlaku."}]}}
  }$json$::jsonb),
  ('bonds-sbn-safe-investing-with-the-government', 'comparison', 20, 'illustrative', $json${
    "en": {"title":"Government-backed is not risk-free","disclosure":"Illustrative learning boundary; terms and risk differ by series and current documents.","altText":"A comparison between what a government bond may state and the risks that still need checking.","payload":{"leftTitle":"Read the stated terms","rightTitle":"Keep checking","rows":[{"left":"Issuer and programme.","right":"Inflation can reduce real purchasing power."},{"left":"Coupon and maturity.","right":"Rates can change the relative appeal of a fixed coupon."},{"left":"Access or trading route.","right":"Liquidity and opportunity cost still matter."}]}},
    "id": {"title":"Didukung pemerintah bukan bebas risiko","disclosure":"Batas belajar ilustratif; ketentuan dan risiko berbeda menurut seri dan dokumen terbaru.","altText":"Perbandingan antara hal yang tercantum pada obligasi pemerintah dan risiko yang tetap perlu diperiksa.","payload":{"leftTitle":"Baca ketentuannya","rightTitle":"Tetap periksa","rows":[{"left":"Penerbit dan program.","right":"Inflasi dapat mengurangi daya beli riil."},{"left":"Kupon dan jatuh tempo.","right":"Perubahan suku bunga dapat mengubah daya tarik relatif kupon tetap."},{"left":"Jalur akses atau perdagangan.","right":"Likuiditas dan biaya peluang tetap penting."}]}}
  }$json$::jsonb),
  ('bonds-sbn-safe-investing-with-the-government-part-2', 'worked_example', 10, 'calculated', $json${
    "en": {"eyebrow":"Illustrative arithmetic","title":"Keep the series beside the calculation","disclosure":"Calculated example only; actual coupon, tax, schedule, and terms depend on the named series and current official documents.","altText":"A calculation multiplying an illustrative one-million-rupiah amount by a six-percent annual coupon and labelling it gross and illustrative.","payload":{"inputs":[{"label":"Illustrative principal","value":"Rp 1,000,000"},{"label":"Illustrative annual coupon","value":"6%"},{"label":"Illustrative gross annual coupon","value":"Rp 60,000"}],"steps":["Rp 1,000,000 × 6% = Rp 60,000 gross per year.","The named series determines the actual rule and payment schedule.","Check current official documents before relying on a detail."],"outcome":"A calculation teaches the relationship between amount and stated rate; it is not a promise about a new offer."}},
    "id": {"eyebrow":"Perhitungan ilustratif","title":"Simpan seri di samping perhitungan","disclosure":"Contoh perhitungan saja; kupon, pajak, jadwal, dan ketentuan sebenarnya bergantung pada seri dan dokumen resmi terbaru.","altText":"Perhitungan jumlah ilustratif satu juta rupiah dikalikan kupon tahunan enam persen dan diberi label kotor serta ilustratif.","payload":{"inputs":[{"label":"Pokok ilustratif","value":"Rp 1.000.000"},{"label":"Kupon tahunan ilustratif","value":"6%"},{"label":"Kupon kotor tahunan ilustratif","value":"Rp 60.000"}],"steps":["Rp 1.000.000 × 6% = Rp 60.000 kotor per tahun.","Seri yang disebut menentukan aturan dan jadwal pembayaran sebenarnya.","Periksa dokumen resmi terbaru sebelum mengandalkan detail."],"outcome":"Perhitungan mengajarkan hubungan antara jumlah dan tarif; bukan janji untuk penawaran baru."}}
  }$json$::jsonb),
  ('bonds-sbn-safe-investing-with-the-government-part-2', 'comparison', 20, 'illustrative', $json${
    "en": {"title":"Compare the trade-offs","disclosure":"Use current series documents; no single trade-off makes an instrument universally suitable.","altText":"A comparison of SBN terms and the learner questions attached to each term.","payload":{"leftTitle":"Term","rightTitle":"Question to ask","rows":[{"left":"Coupon","right":"Fixed, floating, or another stated rule?"},{"left":"Maturity","right":"When can the money be accessed?"},{"left":"Liquidity","right":"What route and conditions apply before maturity?"},{"left":"Tax","right":"Which current rule applies to this series?"}]}},
    "id": {"title":"Bandingkan komprominya","disclosure":"Gunakan dokumen seri terbaru; tidak ada satu kompromi yang membuat instrumen cocok untuk semua orang.","altText":"Perbandingan ketentuan SBN dan pertanyaan yang melekat pada setiap ketentuan.","payload":{"leftTitle":"Ketentuan","rightTitle":"Pertanyaan","rows":[{"left":"Kupon","right":"Tetap, mengambang, atau aturan lain yang tercantum?"},{"left":"Jatuh tempo","right":"Kapan dana dapat diakses?"},{"left":"Likuiditas","right":"Jalur dan ketentuan apa yang berlaku sebelum jatuh tempo?"},{"left":"Pajak","right":"Aturan terbaru apa yang berlaku untuk seri ini?"}]}}
  }$json$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, display_order, data_status, content, is_published)
SELECT lesson.id, 'concept', visual_blocks.block_type, visual_blocks.display_order, visual_blocks.data_status,
  visual_blocks.content, TRUE
FROM visual_blocks
JOIN public.lessons lesson ON lesson.slug = visual_blocks.slug
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type, data_status = EXCLUDED.data_status,
  content = EXCLUDED.content, is_published = TRUE, updated_at = NOW();

WITH applied(slug, body, body_id) AS (
  VALUES
  ('etfs-investing-with-one-click', $json${"type":"multiple_choice","question":"What should you read before treating an ETF as diversified?","options":["Its stated basket or index, holdings, costs, and risks","Only the ETF name","A promise that every holding will rise","The biggest company in the basket"],"answer":"Its stated basket or index, holdings, costs, and risks","difficulty":"intermediate","explanation":"A basket can spread exposure, but the objective, holdings, costs, tracking, liquidity, and market risks still need checking."}$json$::jsonb,
    $json${"type":"multiple_choice","question":"Apa yang perlu dibaca sebelum menganggap ETF terdiversifikasi?","options":["Keranjang atau indeks, kepemilikan, biaya, dan risikonya","Hanya nama ETF","Janji bahwa semua kepemilikan akan naik","Perusahaan terbesar dalam keranjang"],"answer":"Keranjang atau indeks, kepemilikan, biaya, dan risikonya","difficulty":"intermediate","explanation":"Keranjang dapat menyebarkan eksposur, tetapi tujuan, kepemilikan, biaya, pelacakan, likuiditas, dan risiko pasar tetap perlu diperiksa."}$json$::jsonb),
  ('etfs-investing-with-one-click-part-2', $json${"type":"multiple_choice","question":"What does the illustrative 100-unit ETF calculation show?","options":["An amount paid before costs, not a return forecast","A guaranteed return","The future ETF price","That liquidity risk disappears"],"answer":"An amount paid before costs, not a return forecast","difficulty":"intermediate","explanation":"Multiplying units by an illustrative price explains arithmetic only; it does not predict future value or remove costs and risk."}$json$::jsonb,
    $json${"type":"multiple_choice","question":"Apa yang ditunjukkan oleh perhitungan ilustratif 100 unit ETF?","options":["Jumlah pembayaran sebelum biaya, bukan prediksi imbal hasil","Imbal hasil yang dijamin","Harga ETF di masa depan","Risiko likuiditas menghilang"],"answer":"Jumlah pembayaran sebelum biaya, bukan prediksi imbal hasil","difficulty":"intermediate","explanation":"Perkalian unit dengan harga ilustratif hanya menjelaskan aritmetika; bukan prediksi nilai masa depan atau penghapusan biaya dan risiko."}$json$::jsonb),
  ('bonds-sbn-safe-investing-with-the-government', $json${"type":"multiple_choice","question":"Which four terms are a useful first pass when reading an SBN description?","options":["Issuer, coupon, term, and access route","Brand, colour, popularity, and headline","Only the coupon","Only the government name"],"answer":"Issuer, coupon, term, and access route","difficulty":"intermediate","explanation":"Those four terms anchor the description. The series, date, current official documents, and risks still need checking."}$json$::jsonb,
    $json${"type":"multiple_choice","question":"Empat ketentuan apa yang berguna saat pertama membaca deskripsi SBN?","options":["Penerbit, kupon, tenor, dan jalur akses","Merek, warna, popularitas, dan judul","Hanya kupon","Hanya nama pemerintah"],"answer":"Penerbit, kupon, tenor, dan jalur akses","difficulty":"intermediate","explanation":"Empat ketentuan itu menjadi dasar deskripsi. Seri, tanggal, dokumen resmi terbaru, dan risiko tetap perlu diperiksa."}$json$::jsonb),
  ('bonds-sbn-safe-investing-with-the-government-part-2', $json${"type":"multiple_choice","question":"What is the safest conclusion from the illustrative SBN coupon calculation?","options":["It explains gross arithmetic; the named series and current rules still decide the actual result","The next offer will pay exactly that amount","Government bonds have no risk","Tax and schedule never change"],"answer":"It explains gross arithmetic; the named series and current rules still decide the actual result","difficulty":"intermediate","explanation":"The calculation is intentionally illustrative. A current series document is needed for actual coupon, tax, schedule, and terms."}$json$::jsonb,
    $json${"type":"multiple_choice","question":"Apa kesimpulan paling aman dari perhitungan kupon SBN ilustratif?","options":["Perhitungan menjelaskan aritmetika kotor; seri dan aturan terbaru menentukan hasil sebenarnya","Penawaran berikutnya pasti membayar jumlah itu","Obligasi pemerintah tidak memiliki risiko","Pajak dan jadwal tidak pernah berubah"],"answer":"Perhitungan menjelaskan aritmetika kotor; seri dan aturan terbaru menentukan hasil sebenarnya","difficulty":"intermediate","explanation":"Perhitungan tersebut sengaja ilustratif. Dokumen seri terbaru diperlukan untuk kupon, pajak, jadwal, dan ketentuan sebenarnya."}$json$::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'intermediate', 'visual_applied', TRUE
FROM applied JOIN public.lessons lesson ON lesson.slug = applied.slug
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants existing
  WHERE existing.lesson_id = lesson.id AND existing.variant_type = 'question'
    AND existing.topic_tag = 'visual_applied'
);

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (
  VALUES
  ('etfs-investing-with-one-click', 'Five days ago, you learned to read an ETF basket. What does diversification not guarantee?', 'Lima hari lalu, kamu belajar membaca isi keranjang ETF. Apa yang tidak dijamin oleh diversifikasi?', $json$[{"id":"spread","label":"That every holding rises or that the ETF is risk-free"},{"id":"basket","label":"That the product holds a defined basket"},{"id":"check","label":"That you can inspect the objective"}]$json$::jsonb, $json$[{"id":"spread","label":"Semua kepemilikan naik atau ETF bebas risiko"},{"id":"basket","label":"Produk memegang keranjang tertentu"},{"id":"check","label":"Tujuan produk bisa diperiksa"}]$json$::jsonb, 'spread', 'Diversification can spread exposure but does not remove market, tracking, liquidity, or fee risk.', 'Diversifikasi dapat menyebarkan eksposur, tetapi tidak menghapus risiko pasar, pelacakan, likuiditas, atau biaya.'),
  ('etfs-investing-with-one-click-part-2', 'Five days ago, you learned to keep a price calculation separate from a return forecast. Which statement follows?', 'Lima hari lalu, kamu belajar memisahkan perhitungan harga dari prediksi imbal hasil. Pernyataan mana yang benar?', $json$[{"id":"arithmetic","label":"100 units × price explains an amount paid, not future value"},{"id":"forecast","label":"The calculation guarantees a gain"},{"id":"liquidity","label":"Costs and liquidity no longer matter"}]$json$::jsonb, $json$[{"id":"arithmetic","label":"100 unit × harga menjelaskan jumlah pembayaran, bukan nilai masa depan"},{"id":"forecast","label":"Perhitungan menjamin keuntungan"},{"id":"liquidity","label":"Biaya dan likuiditas tidak lagi penting"}]$json$::jsonb, 'arithmetic', 'The calculation is arithmetic only; current costs, market movement, and liquidity remain separate questions.', 'Perhitungan hanya aritmetika; biaya, pergerakan pasar, dan likuiditas tetap perlu ditanyakan.'),
  ('bonds-sbn-safe-investing-with-the-government', 'Five days ago, you learned to read an SBN through four terms. Which detail is still time-sensitive?', 'Lima hari lalu, kamu belajar membaca SBN melalui empat ketentuan. Detail mana yang tetap sensitif terhadap waktu?', $json$[{"id":"current","label":"The named series, rate, date, and access rule"},{"id":"headline","label":"Only the marketing headline"},{"id":"never","label":"Nothing changes once the issuer is government"}]$json$::jsonb, $json$[{"id":"current","label":"Seri, tarif, tanggal, dan aturan akses yang disebut"},{"id":"headline","label":"Hanya judul promosi"},{"id":"never","label":"Tidak ada yang berubah karena penerbitnya pemerintah"}]$json$::jsonb, 'current', 'Series terms and current rules must be checked against the official source named for the product.', 'Ketentuan seri dan aturan terbaru perlu diperiksa terhadap sumber resmi yang disebut untuk produk tersebut.'),
  ('bonds-sbn-safe-investing-with-the-government-part-2', 'Five days ago, you learned to keep an SBN series beside a coupon example. What should you check next?', 'Lima hari lalu, kamu belajar menyimpan seri SBN di samping contoh kupon. Apa yang perlu diperiksa berikutnya?', $json$[{"id":"documents","label":"The current series document, tax rule, schedule, and access conditions"},{"id":"copy","label":"Copy the same rate into every series"},{"id":"guarantee","label":"Assume the calculation guarantees the result"}]$json$::jsonb, $json$[{"id":"documents","label":"Dokumen seri terbaru, aturan pajak, jadwal, dan ketentuan akses"},{"id":"copy","label":"Salin tarif yang sama ke semua seri"},{"id":"guarantee","label":"Anggap perhitungan menjamin hasil"}]$json$::jsonb, 'documents', 'The series and current official documents determine the applicable terms; the example is not a promise.', 'Seri dan dokumen resmi terbaru menentukan ketentuan yang berlaku; contoh tersebut bukan janji.' )
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
