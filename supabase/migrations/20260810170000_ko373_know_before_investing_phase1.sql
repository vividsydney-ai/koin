-- KO-373: Know Before Investing — Phase 1 core content (12 lessons, existing components only)
-- Auto-generated from docs/wayfinder/ko-373-preinvesting-readiness/content-package.mjs
BEGIN;

INSERT INTO public.sources (id, source_code, title, local_title, source_tier, source_type, organization, url, language, status, localization_notes)
VALUES
  (gen_random_uuid(), $TXT$OJK-LITERASI-001$TXT$, $TXT$OJK Sikapi Uangmu — Perencanaan Keuangan$TXT$, $TXT$OJK Sikapi Uangmu — Perencanaan Keuangan$TXT$, 1, $TXT$document$TXT$, $TXT$Otoritas Jasa Keuangan$TXT$, $TXT$https://sikapiuangmu.ojk.go.id/FrontEnd/LiterasiPerguruanTinggi/book/book9/reader.html$TXT$, 'id', 'verified', $TXT$OJK financial literacy material used for general readiness and investing basics.$TXT$),
  (gen_random_uuid(), $TXT$IDX-EDU-001$TXT$, $TXT$IDX Capital Market School$TXT$, $TXT$Sekolah Pasar Modal IDX$TXT$, 1, $TXT$website$TXT$, $TXT$PT Bursa Efek Indonesia$TXT$, $TXT$https://www.idx.co.id/id/investhub/capital-market-school/$TXT$, 'id', 'verified', $TXT$Official IDX investor education portal for market phases, valuation, and research.$TXT$),
  (gen_random_uuid(), $TXT$OJK-FILINGS-001$TXT$, $TXT$IDX Financial Statements and Annual Reports$TXT$, $TXT$Laporan Keuangan dan Tahunan IDX$TXT$, 1, $TXT$website$TXT$, $TXT$Otoritas Jasa Keuangan / PT Bursa Efek Indonesia$TXT$, $TXT$https://www.idx.co.id/id/perusahaan-tercatat/laporan-keuangan-dan-tahunan/$TXT$, 'id', 'verified', $TXT$Primary gateway for listed-company financial statements and annual reports in Indonesia.$TXT$),
  (gen_random_uuid(), $TXT$KSEI-001$TXT$, $TXT$PT Kustodian Sentral Efek Indonesia$TXT$, $TXT$PT Kustodian Sentral Efek Indonesia$TXT$, 1, $TXT$website$TXT$, $TXT$KSEI$TXT$, $TXT$https://www.ksei.co.id$TXT$, 'id', 'verified', $TXT$Central securities depository for shareholder data and securities accounts.$TXT$),
  (gen_random_uuid(), $TXT$OJK-SUSTAINABLE-001$TXT$, $TXT$Indonesia Taxonomy for Sustainable Finance$TXT$, $TXT$Taksonomi Indonesia untuk Keuangan Berkelanjutan$TXT$, 1, $TXT$document$TXT$, $TXT$Otoritas Jasa Keuangan$TXT$, $TXT$https://www.ojk.go.id/en/Publikasi/Roadmap-dan-Pedoman/Sektor-Jasa-Keuangan/Keuangan-Berkelanjutan/Documents/Indonesia%20Taxonomy%20for%20Sustainable%20Finance%202025%20Version%202.pdf$TXT$, 'id', 'verified', $TXT$OJK taxonomy defining green and sustainable activities for the Indonesian market.$TXT$)
ON CONFLICT (source_code) DO UPDATE SET
  title = EXCLUDED.title,
  local_title = EXCLUDED.local_title,
  source_tier = EXCLUDED.source_tier,
  source_type = EXCLUDED.source_type,
  organization = EXCLUDED.organization,
  url = EXCLUDED.url,
  language = EXCLUDED.language,
  status = EXCLUDED.status,
  localization_notes = EXCLUDED.localization_notes;

INSERT INTO public.topics (id, slug, name, name_id, icon, color, display_order, chapter)
VALUES (gen_random_uuid(), $TXT$know_before_investing$TXT$, $TXT$Know Before Investing$TXT$, $TXT$Kenali Sebelum Berinvestasi$TXT$, 'book-open', 'primary', 70, $TXT$Know Before Investing$TXT$)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  name_id = EXCLUDED.name_id,
  icon = EXCLUDED.icon,
  color = EXCLUDED.color,
  display_order = EXCLUDED.display_order,
  chapter = EXCLUDED.chapter;

INSERT INTO public.lessons (id, slug, title, title_id, topic_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, summary_id, concept_body, concept_body_id, indonesian_example, why_this_matters, why_this_matters_id, common_mistake, common_mistake_id, review_status, reviewed_by, reviewed_at, is_published)
SELECT
  gen_random_uuid(),
  seed.slug,
  seed.title,
  seed.title_id,
  (SELECT id FROM public.topics WHERE slug = $TXT$know_before_investing$TXT$),
  seed.lesson_number,
  seed.difficulty,
  seed.xp_reward,
  seed.estimated_minutes,
  seed.summary,
  seed.summary_id,
  seed.concept_body,
  seed.concept_body_id,
  seed.indonesian_example,
  seed.why_this_matters,
  seed.why_this_matters_id,
  seed.common_mistake,
  seed.common_mistake_id,
  'approved',
  'koin-curriculum-agent',
  NOW(),
  TRUE
FROM (VALUES
  ($TXT$are-you-ready-to-invest$TXT$, $TXT$Are You Ready to Invest?$TXT$, $TXT$Apakah Kamu Sudah Siap Berinvestasi?$TXT$, 180, $TXT$beginner$TXT$, 60, 5, $TXT$Check four personal finance checkpoints before you put money in the market.$TXT$, $TXT$Periksa empat pilar keuangan pribadi sebelum masuk pasar.$TXT$, $TXT$Investing is not the first step. Before you buy any stock, you should have:
1. An emergency fund covering 3–6 months of expenses.
2. No high-interest debt (above ~10% per year).
3. A time horizon of at least 2 years for the money you invest.
4. The emotional ability to see your portfolio fall 20% without panic.
If any checkpoint fails, fix it first. There is no shame in waiting.$TXT$, $TXT$Berinvestasi bukan langkah pertama. Sebelum membeli saham, pastikan:
1. Dana darurat 3–6 bulan pengeluaran sudah terbentuk.
2. Tidak ada utang bunga tinggi (di atas ~10% per tahun).
3. Uang yang diinvestasikan tidak dibutuhkan dalam 2 tahun ke depan.
4. Kamu siap melihat portofolio turun 20% tanpa panik.
Jika ada yang belum lolos, perbaiki dulu. Tidak apa-apa menunggu.$TXT$, $TXT$Kira has Rp 5M saved, Rp 2M in paylater debt at 24% annual interest, and gets anxious checking prices daily. She pays the debt first.$TXT$, $TXT$Skipping these checks turns investing into gambling with money you cannot afford to lose.$TXT$, $TXT$Melewatkan pemeriksaan ini membuat investasi jadi judi dengan uang yang tidak bisa kamu rugi.$TXT$, $TXT$Investing before building an emergency fund or while carrying high-interest debt.$TXT$, $TXT$Berinvestasi sebelum punya dana darurat atau sambil memegang utang bunga tinggi.$TXT$),
  ($TXT$bull-bear-market-zoo$TXT$, $TXT$Bull, Bear, and the Market Zoo$TXT$, $TXT$Bull, Bear, dan Kebun Binatang Pasar$TXT$, 181, $TXT$beginner$TXT$, 60, 5, $TXT$Learn simple animal metaphors for market phases without treating them as predictions.$TXT$, $TXT$Kenali metafora hewan untuk fase pasar tanpa menjadikannya ramalan.$TXT$, $TXT$Markets move in phases. People use animals to describe them:
- Bull market: prices rising, optimism dominant.
- Bear market: prices falling, pessimism dominant.
- Sideways market: prices moving in a range, no clear trend.
A correction is a ~10% drop from a recent high. A crash is a faster, deeper drop, usually 20% or more. These phases are normal, not emergencies.$TXT$, $TXT$Pasar bergerak dalam fase. Orang pakai hewan untuk menjelaskannya:
- Bull market: harga naik, optimisme dominan.
- Bear market: harga turun, pesimisme dominan.
- Sideways market: harga bergerak dalam rentang, tidak ada tren jelas.
Koreksi adalah penurunan ~10% dari level tertinggi terdekat. Crash adalah penurunan lebih cepat dan dalam, biasanya 20% atau lebih. Fase-fase ini normal, bukan darurat.$TXT$, $TXT$In early 2020 the IHSG dropped sharply on COVID news. By 2021 it was recovering. A long-term investor saw both phases as normal volatility.$TXT$, $TXT$Knowing the phase helps you react with context instead of fear.$TXT$, $TXT$Mengetahui fase pasar membantumu bereaksi dengan konteks, bukan takut.$TXT$, $TXT$Thinking one red day means a crash, or one green day means endless gains.$TXT$, $TXT$Menganggap satu hari merah berarti crash, atau satu hari hijau berarti cuan terus.$TXT$),
  ($TXT$investing-jargon-decoder$TXT$, $TXT$Investing Jargon Decoder$TXT$, $TXT$Dekoder Istilah Investasi$TXT$, 182, $TXT$beginner$TXT$, 65, 6, $TXT$Decode common investing terms so later chapters do not feel intimidating.$TXT$, $TXT$Pecahkan istilah investasi umum agar bab berikutnya tidak menakutkan.$TXT$, $TXT$Investing has its own vocabulary. Here are plain-language meanings for terms you will keep seeing:
- Blue chip: a large, well-established company with a stable history.
- Market cap: total value of a company’s shares (price × shares outstanding).
- Dividend yield: annual dividend divided by share price, shown as a percentage.
- IPO: first time a company sells shares to the public.
- Portfolio: the collection of all your investments.
- Diversification: spreading money across different assets to reduce risk.
- Green investing / ESG: investing with environmental, social, and governance factors in mind.
- Greenwashing: marketing that makes a company look greener than it really is.$TXT$, $TXT$Investasi punya kosakatanya sendiri. Ini arti sederhana istilah yang sering muncul:
- Blue chip / saham unggulan: perusahaan besar, mapan, dan bersejarah stabil.
- Market cap: nilai total saham perusahaan (harga × jumlah saham beredar).
- Dividend yield: dividen tahunan dibagi harga saham, dalam persen.
- IPO: pertama kali perusahaan menjual saham ke publik.
- Portfolio: kumpulan seluruh investasimu.
- Diversifikasi: menyebarkan uang ke berbagai aset untuk mengurangi risiko.
- Green investing / ESG: berinvestasi dengan mempertimbangkan faktor lingkungan, sosial, dan tata kelola.
- Greenwashing: pemasaran yang membuat perusahaan terlihat lebih hijau dari kenyataannya.$TXT$, $TXT$“I’m going long on a blue chip with a decent dividend yield” means buying shares of a large stable company and caring about its cash payouts.$TXT$, $TXT$Jargon separates beginners from confident learners. Decoding it removes intimidation.$TXT$, $TXT$Istilah asing memisahkan pemula dari pelajar percaya diri. Memahaminya menghilangkan rasa takut.$TXT$, $TXT$Assuming a fancy term means a complex strategy, when it is usually simple.$TXT$, $TXT$Menganggap istilah keren berarti strategi rumit, padahal biasanya sederhana.$TXT$),
  ($TXT$who-can-you-trust$TXT$, $TXT$Who Can You Trust?$TXT$, $TXT$Siapa yang Bisa Kamu Percaya?$TXT$, 183, $TXT$beginner$TXT$, 60, 5, $TXT$Separate regulated sources, verifiable news, and high-risk tips.$TXT$, $TXT$Pisahkan sumber teregulasi, berita yang bisa diverifikasi, dan tips berisiko tinggi.$TXT$, $TXT$Not every source is equal. A simple spectrum:
- Green (trust): OJK, IDX, KSEI, company IR pages, licensed securities firms.
- Yellow (verify): financial news outlets and analyst reports with clear disclaimers.
- Red (avoid): anonymous groups, social media flexers, paid signals, friends-of-friends.
Red flags: guaranteed returns, pressure to buy now, no explanation, fees to join, hidden credentials.$TXT$, $TXT$Tidak semua sumber setara. Spektrum sederhana:
- Hijau (percaya): OJK, IDX, KSEI, halaman IR perusahaan, perusahaan sekuritas berizin.
- Kuning (verifikasi): media keuangan dan laporan analis dengan disclaimer jelas.
- Merah (hindari): grup anonim, pamer kekayaan di medsos, sinyal berbayar, teman dari teman.
Tanda bahaya: imbal hasil dijamin, dipaksa beli sekarang, tanpa penjelasan, bayar untuk join, kredensial tersembunyi.$TXT$, $TXT$A WhatsApp message says “BUY NOW TARGET 200%” with rocket emojis and asks for a deposit to join. This is red zone.$TXT$, $TXT$Most beginner losses come from acting on tips, not from doing research.$TXT$, $TXT$Kebanyakan kerugian pemula datang dari mengikuti tips, bukan dari riset.$TXT$, $TXT$Treating a loud social media account as expert advice because they post gains.$TXT$, $TXT$Menganggap akun medsos yang berisik sebagai nasihat ahli karena sering posting cuan.$TXT$),
  ($TXT$where-real-data-lives$TXT$, $TXT$Where Real Data Lives$TXT$, $TXT$Di Mana Data Nyata Berada?$TXT$, 184, $TXT$beginner$TXT$, 65, 6, $TXT$Match your information need to the right Indonesian official source.$TXT$, $TXT$Cocokkan kebutuhan informasimu dengan sumber resmi Indonesia yang tepat.$TXT$, $TXT$When you research a stock, start with primary sources:
- IDX (idx.co.id): current price, market cap, PBV, PER.
- OJK SIPEBI: company filings, annual reports, public expose transcripts.
- KSEI: shareholder structure and ownership data (or use the annual report as fallback).
- Company IR page: annual reports, presentations, dividend history.
Third-party opinions come last, after you have read the facts.$TXT$, $TXT$Saat riset saham, mulai dari sumber primer:
- IDX (idx.co.id): harga terkini, market cap, PBV, PER.
- OJK SIPEBI: pengumuman perusahaan, laporan tahunan, transkrip public expose.
- KSEI: struktur pemegang saham dan data kepemilikan (atau gunakan laporan tahunan sebagai alternatif).
- Halaman IR perusahaan: laporan tahunan, presentasi, riwayat dividen.
Pendapat pihak ketiga diakhir setelah membaca fakta.$TXT$, $TXT$For BBRI, you check the current price on IDX, the annual report on OJK SIPEBI, and dividend history on BRI’s IR page.$TXT$, $TXT$Starting with opinions makes you someone else’s exit liquidity.$TXT$, $TXT$Mulai dari opini membuatmu jadi “exit liquidity” orang lain.$TXT$, $TXT$Googling “BBRI target price” and trusting the first blog or forum post.$TXT$, $TXT$Googling “target harga BBRI” dan percaya pada blog atau forum pertama.$TXT$),
  ($TXT$inside-an-annual-report$TXT$, $TXT$Inside an Annual Report$TXT$, $TXT$Di Dalam Laporan Tahunan$TXT$, 185, $TXT$beginner$TXT$, 65, 6, $TXT$Navigate the main sections of an Indonesian annual report without reading all 200 pages.$TXT$, $TXT$Navigasi bagian utama laporan tahunan Indonesia tanpa baca 200 halaman.$TXT$, $TXT$An annual report looks thick, but you only need six sections:
1. Directors’ letter — what management wants you to believe.
2. Business overview — what the company does, where, and against whom.
3. Financial statements — the numbers (income, balance sheet, cash flow).
4. Notes to financial statements — the fine print; assumptions live here.
5. Auditor’s report — independent opinion: unqualified (clean), qualified (warning), disclaimer (run).
6. Corporate governance — who runs the company and related-party deals.
Go to the financial statements first, then read the story around them.$TXT$, $TXT$Laporan tahunan terlihat tebal, tapi kamu hanya perlu enam bagian:
1. Surat direksi — apa yang manajemen ingin kamu percayai.
2. Ikhtisar bisnis — apa yang dilakukan perusahaan, di mana, dan siapa pesaingnya.
3. Laporan keuangan — angkanya (laba rugi, neraca, arus kas).
4. Catatan atas laporan keuangan — huruf kecil; asumsi ada di sini.
5. Laporan auditor — opini independen: wajar tanpa pengecualian (bersih), wajar dengan pengecualian (waspada), tidak menyatakan pendapat (hindari).
6. Tata kelola perusahaan — siapa yang menjalankan perusahaan dan transaksi pihak terkait.
Ke laporan keuangan dulu, baru baca cerita di sekitarnya.$TXT$, $TXT$Kira wants to know if profit is backed by cash. She jumps to the cash flow statement and notes first, not the glossy letter.$TXT$, $TXT$Reading an annual report cover-to-cover wastes time and lets spin influence you first.$TXT$, $TXT$Membaca laporan tahunan dari halaman satu sampai akhir membuang waktu dan membiarkan spin memengaruhi kamu dulu.$TXT$, $TXT$Trusting the directors’ letter and ignoring the auditor’s report.$TXT$, $TXT$Percaya surat direksi dan mengabaikan laporan auditor.$TXT$),
  ($TXT$three-statements-at-a-glance$TXT$, $TXT$The Three Statements at a Glance$TXT$, $TXT$Tiga Laporan Keuangan dalam Sekali Lihat$TXT$, 186, $TXT$beginner$TXT$, 60, 5, $TXT$Read income statement, balance sheet, and cash flow at a glance.$TXT$, $TXT$Baca laporan laba rugi, neraca, dan arus kas dalam sekali lihat.$TXT$, $TXT$Three statements tell different stories:
- Income statement: Did the company make a profit? Key line = net profit.
- Balance sheet: What does it own and owe? Key line = total equity.
- Cash flow statement: Did cash actually move? Key line = operating cash flow.
Profit is an opinion; cash is harder to fake. A company can report profit while cash flow is negative.$TXT$, $TXT$Tiga laporan menceritakan hal berbeda:
- Laporan laba rugi: Apakah perusahaan untung? Baris kunci = laba bersih.
- Neraca: Apa yang dimiliki dan ditanggung? Baris kunci = total ekuitas.
- Laporan arus kas: Apakah kas benar-benar bergerak? Baris kunci = arus kas operasi.
Laba adalah opini; kas lebih sulit dipalsukan. Perusahaan bisa melaporkan untung sementara arus kas negatif.$TXT$, $TXT$Company A reports Rp 100B profit but operating cash flow is negative. Company B reports Rp 80B profit with strong operating cash flow. Company B looks healthier.$TXT$, $TXT$Focusing only on profit can hide a company that is not collecting cash.$TXT$, $TXT$Fokus hanya pada laba bisa menyembunyikan perusahaan yang tidak mengumpulkan kas.$TXT$, $TXT$Buying a stock because profit grew while ignoring cash flow and debt.$TXT$, $TXT$Beli saham karena laba tumbuh tapi mengabaikan arus kas dan utang.$TXT$),
  ($TXT$red-flags-in-the-fine-print$TXT$, $TXT$Red Flags in the Fine Print$TXT$, $TXT$Tanda Bahaya di Dalam Huruf Kecil$TXT$, 187, $TXT$beginner$TXT$, 65, 6, $TXT$Spot five common warning signs in company financials.$TXT$, $TXT$Temukan lima tanda peringatan umum dalam laporan keuangan perusahaan.$TXT$, $TXT$Red flags do not always mean “avoid,” but they mean “ask harder questions.” Common ones:
1. Profit rises while cash flow falls — the company may not be collecting cash.
2. Debt grows faster than revenue — borrowing to stay afloat.
3. Auditor qualification or change — the accountant found something.
4. Related-party transactions — deals with the CEO’s family or affiliates.
5. Frequent management changes — the captain keeps jumping ship.
6. Greenwashing — big green claims without data, third-party verification, or clear reporting.
Use yellow (research more), orange (proceed with caution), red (avoid until explained).$TXT$, $TXT$Tanda bahaya tidak selalu berarti “hindari,” tapi berarti “ajukan pertanyaan lebih keras.” Yang umum:
1. Laba naik tapi arus kas turun — perusahaan mungkin tidak mengumpulkan kas.
2. Utang tumbuh lebih cepat dari pendapatan — meminjam untuk bertahan.
3. Opini auditor tidak bersih atau pergantian auditor — akuntan menemukan sesuatu.
4. Transaksi pihak terkait — kesepakatan dengan keluarga atau afiliasi CEO.
5. Pergantian manajemen sering — kapten terus berpindah kapal.
6. Greenwashing — klaim hijau besar tanpa data, verifikasi pihak ketiga, atau pelaporan jelas.
Gunakan kuning (riset lagi), oranye (hati-hati), merah (hindari sampai dijelaskan).$TXT$, $TXT$Kira sees a stock with rising profit but falling operating cash flow, plus a recent auditor change. She moves it from “buy” to “watch closely.”$TXT$, $TXT$One red flag is a question; three red flags are a warning.$TXT$, $TXT$Satu tanda bahaya adalah pertanyaan; tiga tanda bahaya adalah peringatan.$TXT$, $TXT$Ignoring red flags because the stock is “cheap” or popular online.$TXT$, $TXT$Mengabaikan tanda bahaya karena sahamnya “murah” atau viral di medsos.$TXT$),
  ($TXT$from-data-to-a-story$TXT$, $TXT$From Data to a Story$TXT$, $TXT$Dari Data ke Cerita$TXT$, 188, $TXT$beginner$TXT$, 60, 5, $TXT$Connect data points into a cautious narrative without confusing correlation and causation.$TXT$, $TXT$Hubungkan titik data menjadi narasi hati-hati tanpa campuradukkan korelasi dan kausalitas.$TXT$, $TXT$Numbers do not tell the whole story; you connect them. Good narrative:
- Revenue up 15% → new store openings in Tier-2 cities.
- Debt down 10% → asset sale, one-time event.
- Margin compressed → raw material costs rose.
Beware false connections. Revenue and the CEO’s new car are probably unrelated. Always ask: what evidence would prove this story wrong?$TXT$, $TXT$Angka tidak menceritakan semuanya; kamu yang menghubungkannya. Narasi yang baik:
- Pendapatan naik 15% → pembukaan toko baru di kota Tier-2.
- Utang turun 10% → penjualan aset, peristiwa satu kali.
- Margin menipis → biaya bahan baku naik.
Waspadai koneksi palsu. Pendapatan dan mobil baru CEO mungkin tidak berhubungan. Selalu tanya: bukti apa yang bisa membantah cerita ini?$TXT$, $TXT$A bank’s profit grew alongside MSME loan expansion. The supported story: more small-business loans → more interest income → profit up.$TXT$, $TXT$Investors who cannot form a story trade on headlines. Investors who can, trade on reasoning.$TXT$, $TXT$Investor yang tidak bisa membuat cerita trading berdasarkan berita. Investor yang bisa, trading berdasarkan alasan.$TXT$, $TXT$Assuming two events happening together means one caused the other.$TXT$, $TXT$Menganggap dua peristiwa yang terjadi bersama berarti satu menyebabkan yang lain.$TXT$),
  ($TXT$building-your-first-watchlist$TXT$, $TXT$Building Your First Watchlist$TXT$, $TXT$Membuat Watchlist Pertamamu$TXT$, 189, $TXT$beginner$TXT$, 60, 5, $TXT$Set personal criteria and track stocks in the paper-trading sandbox.$TXT$, $TXT$Tetapkan kriteria pribadi dan pantau saham di sandbox paper trading.$TXT$, $TXT$A watchlist is a list of stocks you are tracking, not buying yet. Good criteria make it a filter, not a gossip list. Examples:
- Sector focus you understand.
- PBV and PER within a reasonable range for the sector.
- Debt-to-equity under a personal ceiling.
- Minimum dividend yield or profitable history.
“Someone told me to” is not a criterion.$TXT$, $TXT$Watchlist adalah daftar saham yang sedang kamu pantau, belum dibeli. Kriteria yang baik menjadikannya filter, bukan daftar gosip. Contoh:
- Fokus sektor yang kamu pahami.
- PBV dan PER dalam rentang masuk akal untuk sektornya.
- Debt-to-equity di bawah batas pribadi.
- Yield dividen minimum atau riwayat untung.
“Ada yang bilang” bukan kriteria.$TXT$, $TXT$Kira’s watchlist only includes banks with PBV under 2.0, debt-to-equity under 1.0, and at least 3 years of profit. She ignores WhatsApp tips.$TXT$, $TXT$A watchlist turns random tips into deliberate research targets.$TXT$, $TXT$Watchlist mengubah tips acak menjadi target riset yang disengaja.$TXT$, $TXT$Adding a stock because it is trending on social media.$TXT$, $TXT$Menambah saham karena sedang viral di medsos.$TXT$),
  ($TXT$the-5-minute-research-drill$TXT$, $TXT$The 5-Minute Research Drill$TXT$, $TXT$Drill Riset 5 Menit$TXT$, 190, $TXT$beginner$TXT$, 65, 6, $TXT$Run a quick, disciplined check on any IDX stock.$TXT$, $TXT$Lakukan pemeriksaan cepat dan disiplin untuk saham IDX apa pun.$TXT$, $TXT$You do not need to be a genius. You need a checklist:
1. Check PBV and PER vs the sector.
2. Check debt-to-equity.
3. Check the last 3 years of profit trend.
4. Check recent news or OJK/IDX announcements.
5. Can you explain in one sentence why this company makes money?
If you cannot pass the checklist, pass on the stock. The goal is to find reasons to say no.$TXT$, $TXT$Kamu tidak perlu jadi jenius. Kamu perlu daftar periksa:
1. Cek PBV dan PER dibanding sektor.
2. Cek debt-to-equity.
3. Cek tren laba 3 tahun terakhir.
4. Cek berita terkini atau pengumuman OJK/IDX.
5. Bisakah kamu jelaskan dalam satu kalimat mengapa perusahaan ini untung?
Jika tidak lolos daftar periksa, lewati sahamnya. Tujuannya adalah menemukan alasan untuk menolak.$TXT$, $TXT$For BBCA: PBV/PER reasonable for banking, debt low, profit trend stable, no recent suspension news, business model easy to explain. It passes the drill.$TXT$, $TXT$A quick filter saves you from bad decisions without requiring hours of analysis.$TXT$, $TXT$Filter cepat menyelamatkanmu dari keputusan buruk tanpa perlu analisis berjam-jam.$TXT$, $TXT$Trying to find reasons to buy instead of reasons to say no.$TXT$, $TXT$Mencari alasan untuk beli alih-alih alasan untuk menolak.$TXT$),
  ($TXT$make-your-case$TXT$, $TXT$Make Your Case$TXT$, $TXT$Buat Argumenmu$TXT$, 191, $TXT$beginner$TXT$, 70, 6, $TXT$Write a simple investment thesis and an invalidation rule before placing a paper trade.$TXT$, $TXT$Tulis tesis investasi sederhana dan aturan pembatalan sebelum melakukan paper trade.$TXT$, $TXT$A thesis turns research into a testable idea. Use three sentences:
1. I believe [company] will [grow/maintain] because [reason from data].
2. My evidence is [financial metric / annual report finding / industry trend].
3. I will reconsider this if [specific event or metric change].
The third sentence is your invalidation rule. It protects you from hindsight stories and forces honest reflection.$TXT$, $TXT$Tesis mengubah riset menjadi ide yang bisa diuji. Gunakan tiga kalimat:
1. Saya percaya [perusahaan] akan [tumbuh/bertahan] karena [alasan dari data].
2. Bukti saya adalah [metrik keuangan / temuan laporan tahunan / tren industri].
3. Saya akan meninjau ulang jika [peristiwa spesifik atau perubahan metrik].
Kalimat ketiga adalah aturan pembatalanmu. Ini melindungimu dari cerita setelah kejadian dan memaksa refleksi jujur.$TXT$, $TXT$Kira’s thesis: “I believe BBRI will keep growing because MSME loans are expanding. My evidence is 15% profit growth and stable NIM. I will reconsider if MSME loan growth drops below 10%.”$TXT$, $TXT$Writing a thesis before acting separates research from gambling.$TXT$, $TXT$Menulis tesis sebelum bertindak memisahkan riset dari judi.$TXT$, $TXT$Buying a stock first, then inventing a reason later.$TXT$, $TXT$Beli saham dulu, baru cari alasannya belakangan.$TXT$)
) AS seed(slug, title, title_id, lesson_number, difficulty, xp_reward, estimated_minutes, summary, summary_id, concept_body, concept_body_id, indonesian_example, why_this_matters, why_this_matters_id, common_mistake, common_mistake_id)
ON CONFLICT (slug) DO NOTHING;

-- Explanation variants
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$), 'explanation', $JSON${"text":"Investing is not the first step. Before you buy any stock, you should have:\n1. An emergency fund covering 3–6 months of expenses.\n2. No high-interest debt (above ~10% per year).\n3. A time horizon of at least 2 years for the money you invest.\n4. The emotional ability to see your portfolio fall 20% without panic.\nIf any checkpoint fails, fix it first. There is no shame in waiting."}$JSON$, $JSON${"text":"Berinvestasi bukan langkah pertama. Sebelum membeli saham, pastikan:\n1. Dana darurat 3–6 bulan pengeluaran sudah terbentuk.\n2. Tidak ada utang bunga tinggi (di atas ~10% per tahun).\n3. Uang yang diinvestasikan tidak dibutuhkan dalam 2 tahun ke depan.\n4. Kamu siap melihat portofolio turun 20% tanpa panik.\nJika ada yang belum lolos, perbaiki dulu. Tidak apa-apa menunggu."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), 'explanation', $JSON${"text":"Markets move in phases. People use animals to describe them:\n- Bull market: prices rising, optimism dominant.\n- Bear market: prices falling, pessimism dominant.\n- Sideways market: prices moving in a range, no clear trend.\nA correction is a ~10% drop from a recent high. A crash is a faster, deeper drop, usually 20% or more. These phases are normal, not emergencies."}$JSON$, $JSON${"text":"Pasar bergerak dalam fase. Orang pakai hewan untuk menjelaskannya:\n- Bull market: harga naik, optimisme dominan.\n- Bear market: harga turun, pesimisme dominan.\n- Sideways market: harga bergerak dalam rentang, tidak ada tren jelas.\nKoreksi adalah penurunan ~10% dari level tertinggi terdekat. Crash adalah penurunan lebih cepat dan dalam, biasanya 20% atau lebih. Fase-fase ini normal, bukan darurat."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), 'explanation', $JSON${"text":"Investing has its own vocabulary. Here are plain-language meanings for terms you will keep seeing:\n- Blue chip: a large, well-established company with a stable history.\n- Market cap: total value of a company’s shares (price × shares outstanding).\n- Dividend yield: annual dividend divided by share price, shown as a percentage.\n- IPO: first time a company sells shares to the public.\n- Portfolio: the collection of all your investments.\n- Diversification: spreading money across different assets to reduce risk.\n- Green investing / ESG: investing with environmental, social, and governance factors in mind.\n- Greenwashing: marketing that makes a company look greener than it really is."}$JSON$, $JSON${"text":"Investasi punya kosakatanya sendiri. Ini arti sederhana istilah yang sering muncul:\n- Blue chip / saham unggulan: perusahaan besar, mapan, dan bersejarah stabil.\n- Market cap: nilai total saham perusahaan (harga × jumlah saham beredar).\n- Dividend yield: dividen tahunan dibagi harga saham, dalam persen.\n- IPO: pertama kali perusahaan menjual saham ke publik.\n- Portfolio: kumpulan seluruh investasimu.\n- Diversifikasi: menyebarkan uang ke berbagai aset untuk mengurangi risiko.\n- Green investing / ESG: berinvestasi dengan mempertimbangkan faktor lingkungan, sosial, dan tata kelola.\n- Greenwashing: pemasaran yang membuat perusahaan terlihat lebih hijau dari kenyataannya."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), 'explanation', $JSON${"text":"Not every source is equal. A simple spectrum:\n- Green (trust): OJK, IDX, KSEI, company IR pages, licensed securities firms.\n- Yellow (verify): financial news outlets and analyst reports with clear disclaimers.\n- Red (avoid): anonymous groups, social media flexers, paid signals, friends-of-friends.\nRed flags: guaranteed returns, pressure to buy now, no explanation, fees to join, hidden credentials."}$JSON$, $JSON${"text":"Tidak semua sumber setara. Spektrum sederhana:\n- Hijau (percaya): OJK, IDX, KSEI, halaman IR perusahaan, perusahaan sekuritas berizin.\n- Kuning (verifikasi): media keuangan dan laporan analis dengan disclaimer jelas.\n- Merah (hindari): grup anonim, pamer kekayaan di medsos, sinyal berbayar, teman dari teman.\nTanda bahaya: imbal hasil dijamin, dipaksa beli sekarang, tanpa penjelasan, bayar untuk join, kredensial tersembunyi."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), 'explanation', $JSON${"text":"When you research a stock, start with primary sources:\n- IDX (idx.co.id): current price, market cap, PBV, PER.\n- OJK SIPEBI: company filings, annual reports, public expose transcripts.\n- KSEI: shareholder structure and ownership data (or use the annual report as fallback).\n- Company IR page: annual reports, presentations, dividend history.\nThird-party opinions come last, after you have read the facts."}$JSON$, $JSON${"text":"Saat riset saham, mulai dari sumber primer:\n- IDX (idx.co.id): harga terkini, market cap, PBV, PER.\n- OJK SIPEBI: pengumuman perusahaan, laporan tahunan, transkrip public expose.\n- KSEI: struktur pemegang saham dan data kepemilikan (atau gunakan laporan tahunan sebagai alternatif).\n- Halaman IR perusahaan: laporan tahunan, presentasi, riwayat dividen.\nPendapat pihak ketiga diakhir setelah membaca fakta."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$), 'explanation', $JSON${"text":"An annual report looks thick, but you only need six sections:\n1. Directors’ letter — what management wants you to believe.\n2. Business overview — what the company does, where, and against whom.\n3. Financial statements — the numbers (income, balance sheet, cash flow).\n4. Notes to financial statements — the fine print; assumptions live here.\n5. Auditor’s report — independent opinion: unqualified (clean), qualified (warning), disclaimer (run).\n6. Corporate governance — who runs the company and related-party deals.\nGo to the financial statements first, then read the story around them."}$JSON$, $JSON${"text":"Laporan tahunan terlihat tebal, tapi kamu hanya perlu enam bagian:\n1. Surat direksi — apa yang manajemen ingin kamu percayai.\n2. Ikhtisar bisnis — apa yang dilakukan perusahaan, di mana, dan siapa pesaingnya.\n3. Laporan keuangan — angkanya (laba rugi, neraca, arus kas).\n4. Catatan atas laporan keuangan — huruf kecil; asumsi ada di sini.\n5. Laporan auditor — opini independen: wajar tanpa pengecualian (bersih), wajar dengan pengecualian (waspada), tidak menyatakan pendapat (hindari).\n6. Tata kelola perusahaan — siapa yang menjalankan perusahaan dan transaksi pihak terkait.\nKe laporan keuangan dulu, baru baca cerita di sekitarnya."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$), 'explanation', $JSON${"text":"Three statements tell different stories:\n- Income statement: Did the company make a profit? Key line = net profit.\n- Balance sheet: What does it own and owe? Key line = total equity.\n- Cash flow statement: Did cash actually move? Key line = operating cash flow.\nProfit is an opinion; cash is harder to fake. A company can report profit while cash flow is negative."}$JSON$, $JSON${"text":"Tiga laporan menceritakan hal berbeda:\n- Laporan laba rugi: Apakah perusahaan untung? Baris kunci = laba bersih.\n- Neraca: Apa yang dimiliki dan ditanggung? Baris kunci = total ekuitas.\n- Laporan arus kas: Apakah kas benar-benar bergerak? Baris kunci = arus kas operasi.\nLaba adalah opini; kas lebih sulit dipalsukan. Perusahaan bisa melaporkan untung sementara arus kas negatif."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), 'explanation', $JSON${"text":"Red flags do not always mean “avoid,” but they mean “ask harder questions.” Common ones:\n1. Profit rises while cash flow falls — the company may not be collecting cash.\n2. Debt grows faster than revenue — borrowing to stay afloat.\n3. Auditor qualification or change — the accountant found something.\n4. Related-party transactions — deals with the CEO’s family or affiliates.\n5. Frequent management changes — the captain keeps jumping ship.\n6. Greenwashing — big green claims without data, third-party verification, or clear reporting.\nUse yellow (research more), orange (proceed with caution), red (avoid until explained)."}$JSON$, $JSON${"text":"Tanda bahaya tidak selalu berarti “hindari,” tapi berarti “ajukan pertanyaan lebih keras.” Yang umum:\n1. Laba naik tapi arus kas turun — perusahaan mungkin tidak mengumpulkan kas.\n2. Utang tumbuh lebih cepat dari pendapatan — meminjam untuk bertahan.\n3. Opini auditor tidak bersih atau pergantian auditor — akuntan menemukan sesuatu.\n4. Transaksi pihak terkait — kesepakatan dengan keluarga atau afiliasi CEO.\n5. Pergantian manajemen sering — kapten terus berpindah kapal.\n6. Greenwashing — klaim hijau besar tanpa data, verifikasi pihak ketiga, atau pelaporan jelas.\nGunakan kuning (riset lagi), oranye (hati-hati), merah (hindari sampai dijelaskan)."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$), 'explanation', $JSON${"text":"Numbers do not tell the whole story; you connect them. Good narrative:\n- Revenue up 15% → new store openings in Tier-2 cities.\n- Debt down 10% → asset sale, one-time event.\n- Margin compressed → raw material costs rose.\nBeware false connections. Revenue and the CEO’s new car are probably unrelated. Always ask: what evidence would prove this story wrong?"}$JSON$, $JSON${"text":"Angka tidak menceritakan semuanya; kamu yang menghubungkannya. Narasi yang baik:\n- Pendapatan naik 15% → pembukaan toko baru di kota Tier-2.\n- Utang turun 10% → penjualan aset, peristiwa satu kali.\n- Margin menipis → biaya bahan baku naik.\nWaspadai koneksi palsu. Pendapatan dan mobil baru CEO mungkin tidak berhubungan. Selalu tanya: bukti apa yang bisa membantah cerita ini?"}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$), 'explanation', $JSON${"text":"A watchlist is a list of stocks you are tracking, not buying yet. Good criteria make it a filter, not a gossip list. Examples:\n- Sector focus you understand.\n- PBV and PER within a reasonable range for the sector.\n- Debt-to-equity under a personal ceiling.\n- Minimum dividend yield or profitable history.\n“Someone told me to” is not a criterion."}$JSON$, $JSON${"text":"Watchlist adalah daftar saham yang sedang kamu pantau, belum dibeli. Kriteria yang baik menjadikannya filter, bukan daftar gosip. Contoh:\n- Fokus sektor yang kamu pahami.\n- PBV dan PER dalam rentang masuk akal untuk sektornya.\n- Debt-to-equity di bawah batas pribadi.\n- Yield dividen minimum atau riwayat untung.\n“Ada yang bilang” bukan kriteria."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), 'explanation', $JSON${"text":"You do not need to be a genius. You need a checklist:\n1. Check PBV and PER vs the sector.\n2. Check debt-to-equity.\n3. Check the last 3 years of profit trend.\n4. Check recent news or OJK/IDX announcements.\n5. Can you explain in one sentence why this company makes money?\nIf you cannot pass the checklist, pass on the stock. The goal is to find reasons to say no."}$JSON$, $JSON${"text":"Kamu tidak perlu jadi jenius. Kamu perlu daftar periksa:\n1. Cek PBV dan PER dibanding sektor.\n2. Cek debt-to-equity.\n3. Cek tren laba 3 tahun terakhir.\n4. Cek berita terkini atau pengumuman OJK/IDX.\n5. Bisakah kamu jelaskan dalam satu kalimat mengapa perusahaan ini untung?\nJika tidak lolos daftar periksa, lewati sahamnya. Tujuannya adalah menemukan alasan untuk menolak."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$) AND cv.variant_type = 'explanation');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$), 'explanation', $JSON${"text":"A thesis turns research into a testable idea. Use three sentences:\n1. I believe [company] will [grow/maintain] because [reason from data].\n2. My evidence is [financial metric / annual report finding / industry trend].\n3. I will reconsider this if [specific event or metric change].\nThe third sentence is your invalidation rule. It protects you from hindsight stories and forces honest reflection."}$JSON$, $JSON${"text":"Tesis mengubah riset menjadi ide yang bisa diuji. Gunakan tiga kalimat:\n1. Saya percaya [perusahaan] akan [tumbuh/bertahan] karena [alasan dari data].\n2. Bukti saya adalah [metrik keuangan / temuan laporan tahunan / tren industri].\n3. Saya akan meninjau ulang jika [peristiwa spesifik atau perubahan metrik].\nKalimat ketiga adalah aturan pembatalanmu. Ini melindungimu dari cerita setelah kejadian dan memaksa refleksi jujur."}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$) AND cv.variant_type = 'explanation');

-- Example variants
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$), 'example', $JSON${"text":"Kira has Rp 5M saved, Rp 2M in paylater debt at 24% annual interest, and gets anxious checking prices daily. She pays the debt first.","source_ids":[]}$JSON$, $JSON${"text":"Kira punya tabungan Rp 5 juta, utang paylater Rp 2 juta dengan bunga 24% per tahun, dan cemas kalau cek harga tiap hari. Dia lunasi utang dulu.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), 'example', $JSON${"text":"In early 2020 the IHSG dropped sharply on COVID news. By 2021 it was recovering. A long-term investor saw both phases as normal volatility.","source_ids":[]}$JSON$, $JSON${"text":"Awal 2020 IHSG anjlok karena berita COVID. Tahun 2021 mulai pulih. Investor jangka panjang memandang kedua fase sebagai volatilitas biasa.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), 'example', $JSON${"text":"“I’m going long on a blue chip with a decent dividend yield” means buying shares of a large stable company and caring about its cash payouts.","source_ids":[]}$JSON$, $JSON${"text":"“Aku long di saham unggulan dengan dividend yield lumayan” artinya membeli saham perusahaan besar stabil dan memperhatikan dividen tunainya.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), 'example', $JSON${"text":"A WhatsApp message says “BUY NOW TARGET 200%” with rocket emojis and asks for a deposit to join. This is red zone.","source_ids":[]}$JSON$, $JSON${"text":"Pesan WhatsApp bilang “BUY NOW TARGET 200%” dengan emoji roket dan minta deposit untuk join. Ini zona merah.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), 'example', $JSON${"text":"For BBRI, you check the current price on IDX, the annual report on OJK SIPEBI, and dividend history on BRI’s IR page.","source_ids":[]}$JSON$, $JSON${"text":"Untuk BBRI, cek harga terkini di IDX, laporan tahunan di OJK SIPEBI, dan riwayat dividen di halaman IR BRI.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$), 'example', $JSON${"text":"Kira wants to know if profit is backed by cash. She jumps to the cash flow statement and notes first, not the glossy letter.","source_ids":[]}$JSON$, $JSON${"text":"Kira ingin tahu apakah laba didukung kas. Dia langsung ke laporan arus kas dan catatan, bukan surat direksi yang berkilau.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$), 'example', $JSON${"text":"Company A reports Rp 100B profit but operating cash flow is negative. Company B reports Rp 80B profit with strong operating cash flow. Company B looks healthier.","source_ids":[]}$JSON$, $JSON${"text":"Perusahaan A melaporkan laba Rp 100 miliar tapi arus kas operasi negatif. Perusahaan B laba Rp 80 miliar dengan arus kas operasi kuat. Perusahaan B terlihat lebih sehat.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), 'example', $JSON${"text":"Kira sees a stock with rising profit but falling operating cash flow, plus a recent auditor change. She moves it from “buy” to “watch closely.”","source_ids":[]}$JSON$, $JSON${"text":"Kira melihat saham dengan laba naik tapi arus kas operasi turun, ditambah pergantian auditor baru. Dia pindahkan dari “beli” ke “pantau dekat.”","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$), 'example', $JSON${"text":"A bank’s profit grew alongside MSME loan expansion. The supported story: more small-business loans → more interest income → profit up.","source_ids":[]}$JSON$, $JSON${"text":"Laba bank tumbuh seiring ekspansi pinjaman UMKM. Cerita yang didukung: lebih banyak pinjaman usaha kecil → lebih banyak pendapatan bunga → laba naik.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$), 'example', $JSON${"text":"Kira’s watchlist only includes banks with PBV under 2.0, debt-to-equity under 1.0, and at least 3 years of profit. She ignores WhatsApp tips.","source_ids":[]}$JSON$, $JSON${"text":"Watchlist Kira hanya mencakup bank dengan PBV di bawah 2,0, debt-to-equity di bawah 1,0, dan laba minimal 3 tahun. Dia abaikan tips WhatsApp.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), 'example', $JSON${"text":"For BBCA: PBV/PER reasonable for banking, debt low, profit trend stable, no recent suspension news, business model easy to explain. It passes the drill.","source_ids":[]}$JSON$, $JSON${"text":"Untuk BBCA: PBV/PER masuk akal untuk perbankan, utang rendah, tren laba stabil, tidak ada berita suspensi terbaru, model bisnis mudah dijelaskan. Lolos drill.","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$) AND cv.variant_type = 'example');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$), 'example', $JSON${"text":"Kira’s thesis: “I believe BBRI will keep growing because MSME loans are expanding. My evidence is 15% profit growth and stable NIM. I will reconsider if MSME loan growth drops below 10%.”","source_ids":[]}$JSON$, $JSON${"text":"Tesis Kira: “Saya percaya BBRI akan terus tumbuh karena pinjaman UMKM berkembang. Bukti saya adalah laba tumbuh 15% dan NIM stabil. Saya akan tinjau ulang jika pertumbuhan pinjaman UMKM turun di bawah 10%.”","source_ids":[]}$JSON$, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$) AND cv.variant_type = 'example');

-- Question variants
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which checkpoint should you clear first?","options":["Build an emergency fund","Buy a trending stock","Join a Telegram signal group","Open a second paylater account"],"answer":"Build an emergency fund","explanation":"An emergency fund protects you from selling investments at a loss when life happens."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Pemeriksaan mana yang harus dipenuhi dulu?","options":["Bangun dana darurat","Beli saham yang lagi viral","Ikut grup sinyal Telegram","Buka akun paylater kedua"],"answer":"Bangun dana darurat","explanation":"Dana darurat melindungimu dari terpaksa jual investasi saat kebutuhan mendesak."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"It is okay to invest money you will need within 6 months.","answer":false,"explanation":"Short-term money should stay safe and accessible, not in volatile assets."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Boleh berinvestasi dengan uang yang dibutuhkan dalam 6 bulan ke depan.","answer":false,"explanation":"Uang jangka pendek harus tetap aman dan mudah diambil, bukan di aset volatil."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"You have high-interest paylater debt and no emergency fund. What is the right move?","options":["Pay down the debt and build savings first","Buy stocks to “grow your way out”","Borrow more to invest","Wait for a stock tip from a friend"],"answer":"Pay down the debt and build savings first","explanation":"High-interest debt usually costs more than reasonable investment returns."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Kamu punya utang paylater bunga tinggi dan belum ada dana darurat. Langkah yang benar?","options":["Lunasi utang dan tabung dulu","Beli saham “biar cuan nutup utang”","Pinjam lagi untuk investasi","Tunggu rekomendasi teman"],"answer":"Lunasi utang dan tabung dulu","explanation":"Utang bunga tinggi biasanya lebih mahal dari imbal hasil investasi yang masuk akal."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A “bull market” means prices are generally:","options":["Rising","Falling","Flat","Random"],"answer":"Rising","explanation":"Bull = charging up = rising prices and optimistic sentiment."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"“Bull market” berarti harga umumnya:","options":["Naik","Turun","Datar","Acak"],"answer":"Naik","explanation":"Bull = menyerang ke atas = harga naik dan sentimen optimis."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"The IHSG drops 8% from its recent high over two weeks. This is best described as:","options":["A correction","A crash","A bull run","A sideways phase"],"answer":"A correction","explanation":"A correction is roughly a 10% drop; a crash is usually 20% or more."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"IHSG turun 8% dari level tertinggi baru dalam dua minggu. Ini paling tepat disebut:","options":["Koreksi","Crash","Bull run","Fase sideways"],"answer":"Koreksi","explanation":"Koreksi kira-kira penurunan 10%; crash biasanya 20% atau lebih."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"A bear market means it is guaranteed to keep falling forever.","answer":false,"explanation":"Market phases describe the current trend, not the future. They always change eventually."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Bear market berarti harga pasti terus turun selamanya.","answer":false,"explanation":"Fase pasar menggambarkan tren saat ini, bukan masa depan. Fase selalu berubah suatu saat."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), 'question', $JSON${"type":"matching","difficulty":"beginner","parameters":{},"question":"Match the English term to its Indonesian meaning.","options":{"left":["Blue chip","Market cap","Dividend yield","Portfolio"],"right":["Saham unggulan","Kapitalisasi pasar","Yield dividen","Portofolio"]},"answer":{"Blue chip":"Saham unggulan","Market cap":"Kapitalisasi pasar","Dividend yield":"Yield dividen","Portfolio":"Portofolio"},"explanation":""}$JSON$::jsonb, $JSON${"type":"matching","difficulty":"beginner","parameters":{},"question":"Pasangkan istilah Inggris dengan arti dalam bahasa Indonesia.","options":{"left":["Blue chip","Market cap","Dividend yield","Portfolio"],"right":["Saham unggulan","Kapitalisasi pasar","Yield dividen","Portofolio"]},"answer":{"Blue chip":"Saham unggulan","Market cap":"Kapitalisasi pasar","Dividend yield":"Yield dividen","Portfolio":"Portofolio"},"explanation":""}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"What does “market cap” tell you?","options":["Total value of a company’s shares","The company’s debt","The CEO’s salary","The dividend payment date"],"answer":"Total value of a company’s shares","explanation":"Market cap = share price × number of shares outstanding."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Apa yang diukur oleh “market cap”?","options":["Nilai total saham perusahaan","Utang perusahaan","Gaji CEO","Tanggal pembayaran dividen"],"answer":"Nilai total saham perusahaan","explanation":"Market cap = harga saham × jumlah saham beredar."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), 'question', $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"A mining company launches a “Green Future” ad with leaves and forests, but its annual report shows 90% of revenue still comes from coal. What is this?","options":["Greenwashing","Honest ESG reporting","A green investment","A renewable-energy company"],"answer":"Greenwashing","explanation":"Big green marketing without matching business reality is greenwashing."}$JSON$::jsonb, $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Perusahaan tambang meluncurkan iklan “Green Future” dengan daun dan hutan, tapi laporan tahunannya menunjukkan 90% pendapatan masih dari batu bara. Apa ini?","options":["Greenwashing","Pelaporan ESG jujur","Investasi hijau","Perusahaan energi terbarukan"],"answer":"Greenwashing","explanation":"Pemasaran hijau besar tanpa realitas bisnis yang sesuai adalah greenwashing."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which source sits in the “trust” zone?","options":["OJK official website","Anonymous Telegram group","Instagram “guru” showing luxury cars","Friend of a friend’s stock tip"],"answer":"OJK official website","explanation":"Regulators like OJK are in the green zone because they exist to protect market participants."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Sumber mana yang masuk zona “percaya”?","options":["Situs resmi OJK","Grup Telegram anonim","“Guru” Instagram pamer mobil mewah","Tips saham dari teman dari teman"],"answer":"Situs resmi OJK","explanation":"Regulator seperti OJK ada di zona hijau karena tugasnya melindungi peserta pasar."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A “paid signal group” promising guaranteed returns is a:","options":["Red-zone source","Green-zone source","Yellow-zone source","Official regulator"],"answer":"Red-zone source","explanation":"Guaranteed returns and fees to join are classic red flags."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Grup sinyal berbayar yang menjanjikan imbal hasil dijamin masuk:","options":["Zona merah","Zona hijau","Zona kuning","Regulator resmi"],"answer":"Zona merah","explanation":"Imbal hasil dijamin dan biaya join adalah tanda bahaya klasik."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), 'question', $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"You see two posts. Post A is an IDX company announcement with a date and ticker. Post B says “BUY NOW, 200% TARGET” with rocket emojis. Which is more trustworthy and why?","options":["Post A — official and verifiable","Post B — more exciting","Both are equally valid","Neither matters"],"answer":"Post A — official and verifiable","explanation":"Official exchange announcements can be checked; hype posts cannot."}$JSON$::jsonb, $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Kamu melihat dua postingan. Postingan A adalah pengumuman perusahaan dari IDX dengan tanggal dan kode saham. Postingan B bilang “BUY NOW, 200% TARGET” dengan emoji roket. Mana yang lebih bisa dipercaya dan mengapa?","options":["Postingan A — resmi dan bisa diverifikasi","Postingan B — lebih seru","Keduanya sama valid","Keduanya tidak penting"],"answer":"Postingan A — resmi dan bisa diverifikasi","explanation":"Pengumuman bursa resmi bisa diperiksa; postingan hype tidak bisa."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"You want the latest share price and PBV for TLKM. Best first stop?","options":["IDX stock quote page","A Twitter thread","A paid Telegram group","A meme page"],"answer":"IDX stock quote page","explanation":"IDX provides official price, market cap, and valuation ratios."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Kamu ingin harga saham terkini dan PBV TLKM. Pemberhentian pertama terbaik?","options":["Halaman kutipan saham IDX","Thread Twitter","Grup Telegram berbayar","Halaman meme"],"answer":"Halaman kutipan saham IDX","explanation":"IDX menyediakan harga resmi, market cap, dan rasio valuasi."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Where should you look first for a company’s audited annual report?","options":["OJK SIPEBI","A news headline","A friend’s WhatsApp status","A stock-picking forum"],"answer":"OJK SIPEBI","explanation":"OJK SIPEBI is the official repository for company filings."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Di mana pertama kali mencari laporan tahunan teraudit perusahaan?","options":["OJK SIPEBI","Judul berita","Status WhatsApp teman","Forum pilih saham"],"answer":"OJK SIPEBI","explanation":"OJK SIPEBI adalah repositori resmi pengumuman perusahaan."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which source is best for dividend history?","options":["Company IR page","IDX stock quote","OJK SIPEBI","KSEI"],"answer":"Company IR page","explanation":"Companies usually publish their dividend history and policy on their investor relations page."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Sumber terbaik untuk riwayat dividen?","options":["Halaman IR perusahaan","Kutipan saham IDX","OJK SIPEBI","KSEI"],"answer":"Halaman IR perusahaan","explanation":"Perusahaan biasanya menerbitkan riwayat dan kebijakan dividen di halaman IR mereka."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which section should you read first?","options":["Financial statements","Directors' letter","Corporate governance","Back cover"],"answer":"Financial statements","explanation":"The numbers are the core evidence; read the story around them after."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Bagian mana yang harus dibaca dulu?","options":["Laporan keuangan","Surat direksi","Tata kelola perusahaan","Sampul belakang"],"answer":"Laporan keuangan","explanation":"Angka adalah bukti inti; baca cerita di sekitarnya setelahnya."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"An auditor’s “qualified” opinion means:","options":["There is a warning worth investigating","The report is perfect","The company has no debt","Dividends are guaranteed"],"answer":"There is a warning worth investigating","explanation":"A qualified opinion flags issues the auditor could not sign off cleanly on."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Opini auditor “wajar dengan pengecualian” berarti:","options":["Ada peringatan yang perlu diselidiki","Laporan sempurna","Perusahaan tidak punya utang","Dividen dijamin"],"answer":"Ada peringatan yang perlu diselidiki","explanation":"Opini wajar dengan pengecualian menandai masalah yang tidak bisa ditandatangani bersih oleh auditor."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$), 'question', $JSON${"type":"ordering","difficulty":"beginner","parameters":{},"question":"Put these sections in the order a disciplined reader checks them:","options":["Financial statements","Notes to financial statements","Auditor's report","Directors' letter"],"answer":["Financial statements","Notes to financial statements","Auditor's report","Directors' letter"],"explanation":""}$JSON$::jsonb, $JSON${"type":"ordering","difficulty":"beginner","parameters":{},"question":"Urutkan bagian ini sesuai cara pembaca yang disiplin memeriksanya:","options":["Laporan keuangan","Catatan laporan keuangan","Laporan auditor","Surat direksi"],"answer":["Laporan keuangan","Catatan laporan keuangan","Laporan auditor","Surat direksi"],"explanation":""}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which statement shows whether cash actually moved?","options":["Cash flow statement","Income statement","Balance sheet","Directors’ letter"],"answer":"Cash flow statement","explanation":"Cash flow tracks real money in and out of the business."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Laporan mana yang menunjukkan apakah kas benar-benar bergerak?","options":["Laporan arus kas","Laporan laba rugi","Neraca","Surat direksi"],"answer":"Laporan arus kas","explanation":"Arus kas melacak uang nyata masuk dan keluar bisnis."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A company reports profit growth but operating cash flow is falling. This is:","options":["A red flag to investigate","A green flag to buy","Irrelevant","Guaranteed to improve"],"answer":"A red flag to investigate","explanation":"Profit without cash backing can signal accounting choices or collection problems."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Perusahaan melaporkan laba tumbuh tapi arus kas operasi menurun. Ini adalah:","options":["Tanda bahaya untuk diselidiki","Tanda bagus untuk beli","Tidak relevan","Pasti membaik"],"answer":"Tanda bahaya untuk diselidiki","explanation":"Laba tanpa dukungan kas bisa jadi sinyal akuntansi atau masalah penagihan."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$), 'question', $JSON${"type":"matching","difficulty":"beginner","parameters":{},"question":"Match each statement to the question it answers.","options":{"left":["Income statement","Balance sheet","Cash flow statement"],"right":["Did we make money?","What do we own and owe?","Did cash actually move?"]},"answer":{"Income statement":"Did we make money?","Balance sheet":"What do we own and owe?","Cash flow statement":"Did cash actually move?"},"explanation":""}$JSON$::jsonb, $JSON${"type":"matching","difficulty":"beginner","parameters":{},"question":"Pasangkan setiap laporan dengan pertanyaan yang dijawabnya.","options":{"left":["Laporan laba rugi","Neraca","Laporan arus kas"],"right":["Apakah kita untung?","Apa yang kita miliki dan utangi?","Apakah kas benar-benar bergerak?"]},"answer":{"Laporan laba rugi":"Apakah kita untung?","Neraca":"Apa yang kita miliki dan utangi?","Laporan arus kas":"Apakah kas benar-benar bergerak?"},"explanation":""}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), 'question', $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"A fictional company reports profit up 30% but operating cash flow down 40%, and the auditor was replaced this year. How should you treat it?","options":["Avoid until explained","Buy immediately because profit is rising","Ignore the cash flow","Trust the new auditor blindly"],"answer":"Avoid until explained","explanation":"Two red flags together demand explanation before action."}$JSON$::jsonb, $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Sebuah perusahaan fiktif melaporkan laba naik 30% tapi arus kas operasi turun 40%, dan auditor diganti tahun ini. Sikap yang tepat?","options":["Hindari sampai dijelaskan","Beli langsung karena laba naik","Abaikan arus kas","Percaya auditor baru tanpa syarat"],"answer":"Hindari sampai dijelaskan","explanation":"Dua tanda bahaya bersama menuntut penjelasan sebelum bertindak."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which red flag is rated most severe in this lesson?","options":["Auditor qualification","Management churn","Cash down/profit up","Related-party deals"],"answer":"Auditor qualification","explanation":"An auditor qualification means the accountant could not sign off cleanly."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Tanda bahaya mana yang dinilai paling serius dalam pelajaran ini?","options":["Opini auditor tidak bersih","Pergantian manajemen","Laba naik/kas turun","Transaksi pihak terkait"],"answer":"Opini auditor tidak bersih","explanation":"Opini auditor tidak bersih berarti akuntan tidak bisa menandatangani laporan tanpa pengecualian."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"One red flag always means you should avoid the stock completely.","answer":false,"explanation":"One red flag means ask more questions; several together become a stronger warning."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Satu tanda bahaya selalu berarti harus menghindari saham sepenuhnya.","answer":false,"explanation":"Satu tanda bahaya berarti tanyakan lebih banyak; beberapa bersama jadi peringatan lebih kuat."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which clue most suggests greenwashing?","options":["Green ads with no data or third-party verification","A verified sustainability report","A clear emissions-reduction target","An OJK green-bond registration"],"answer":"Green ads with no data or third-party verification","explanation":"Greenwashing is marketing that looks eco-friendly without credible evidence."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Petunjuk mana yang paling menunjukkan greenwashing?","options":["Iklan hijau tanpa data atau verifikasi pihak ketiga","Laporan keberlanjutan terverifikasi","Target pengurangan emisi yang jelas","Pendaftaran green bond OJK"],"answer":"Iklan hijau tanpa data atau verifikasi pihak ketiga","explanation":"Greenwashing adalah pemasaran yang terlihat ramah lingkungan tanpa bukti kredibel."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A company’s revenue rose and the CEO bought a sports car. Can you conclude the car caused the revenue rise?","options":["No — correlation is not causation","Yes — the CEO is motivated","Maybe — cars attract customers","Only if the car is expensive"],"answer":"No — correlation is not causation","explanation":"Two events happening together do not prove one caused the other."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Pendapatan perusahaan naik dan CEO membeli mobil sport. Bisa disimpulkan mobil menyebabkan pendapatan naik?","options":["Tidak — korelasi bukan kausalitas","Ya — CEO jadi termotivasi","Mungkin — mobil menarik pelanggan","Hanya jika mobil mahal"],"answer":"Tidak — korelasi bukan kausalitas","explanation":"Dua peristiwa terjadi bersama tidak membuktikan satu menyebabkan yang lain."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which story is best supported by “profit up 15%” and “MSME loans up 20%”?","options":["More small-business loans are driving profit","The CEO bought a new house","A competitor went bankrupt","The weather was good"],"answer":"More small-business loans are driving profit","explanation":"Loan growth and profit growth can form a plausible business link."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Cerita mana yang paling didukung oleh “laba naik 15%” dan “pinjaman UMKM naik 20%”?","options":["Lebih banyak pinjaman usaha kecil mendorong laba","CEO membeli rumah baru","Pesaing bangkrut","Cuaca bagus"],"answer":"Lebih banyak pinjaman usaha kecil mendorong laba","explanation":"Pertumbuhan pinjaman dan laba bisa membentuk hubungan bisnis yang masuk akal."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$), 'question', $JSON${"type":"ordering","difficulty":"beginner","parameters":{},"question":"Order the steps of building a data story:","options":["Find the data","Ask why it changed","Form a cautious story","Look for evidence that disproves it"],"answer":["Find the data","Ask why it changed","Form a cautious story","Look for evidence that disproves it"],"explanation":""}$JSON$::jsonb, $JSON${"type":"ordering","difficulty":"beginner","parameters":{},"question":"Urutkan langkah membangun cerita dari data:","options":["Temukan datanya","Tanyakan mengapa berubah","Bentuk cerita hati-hati","Cari bukti yang membantah"],"answer":["Temukan datanya","Tanyakan mengapa berubah","Bentuk cerita hati-hati","Cari bukti yang membantah"],"explanation":""}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which is a valid watchlist criterion?","options":["PBV within a reasonable sector range","A tip from a friend","A stock trending on TikTok","A broker’s “sure thing” call"],"answer":"PBV within a reasonable sector range","explanation":"Valuation ratios tied to a sector are research-based criteria."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Mana yang merupakan kriteria watchlist yang valid?","options":["PBV dalam rentang sektor yang masuk akal","Tips dari teman","Saham viral di TikTok","Rekomendasi “pasti untung” dari broker"],"answer":"PBV dalam rentang sektor yang masuk akal","explanation":"Rasio valuasi yang terkait sektor adalah kriteria berbasis riset."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"A watchlist is a list of stocks you have already bought.","answer":false,"explanation":"A watchlist tracks stocks you are researching, not a record of purchases."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Watchlist adalah daftar saham yang sudah dibeli.","answer":false,"explanation":"Watchlist melacak saham yang sedang diriset, bukan catatan pembelian."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$), 'question', $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Kira adds a bank stock because it meets her PBV and debt criteria. Her friend adds a stock because of a “BUY NOW” message. Who is building a real watchlist?","options":["Kira","Her friend","Both","Neither"],"answer":"Kira","explanation":"A watchlist is built on personal criteria, not tips."}$JSON$::jsonb, $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Kira menambah saham bank karena memenuhi kriteria PBV dan utangnya. Temannya menambah saham karena pesan “BUY NOW”. Siapa yang membangun watchlist sungguhan?","options":["Kira","Temnnya","Keduanya","Tidak ada"],"answer":"Kira","explanation":"Watchlist dibangun dari kriteria pribadi, bukan tips."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), 'question', $JSON${"type":"ordering","difficulty":"beginner","parameters":{},"question":"Put the 5-minute drill steps in order:","options":["Check PBV/PER","Check debt","Check profit trend","Check news","Explain the business"],"answer":["Check PBV/PER","Check debt","Check profit trend","Check news","Explain the business"],"explanation":""}$JSON$::jsonb, $JSON${"type":"ordering","difficulty":"beginner","parameters":{},"question":"Urutkan langkah drill 5 menit:","options":["Cek PBV/PER","Cek utang","Cek tren laba","Cek berita","Jelaskan bisnisnya"],"answer":["Cek PBV/PER","Cek utang","Cek tren laba","Cek berita","Jelaskan bisnisnya"],"explanation":""}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"What is the main goal of the drill?","options":["Find reasons to say no","Guarantee a winning stock","Pick the cheapest broker","Copy a famous investor"],"answer":"Find reasons to say no","explanation":"Most stocks should fail a disciplined filter. The few that pass deserve deeper research."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Apa tujuan utama drill ini?","options":["Temukan alasan menolak","Jamin saham pemenang","Pilih broker termurah","Tiru investor terkenal"],"answer":"Temukan alasan menolak","explanation":"Kebanyakan saham seharusnya gagal filter disiplin. Yang lolos layak riset lebih dalam."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"You cannot explain in one sentence how the company makes money. What should you do?","options":["Pass on the stock","Buy a small amount anyway","Ask a stranger online","Hope the price rises"],"answer":"Pass on the stock","explanation":"If you cannot explain the business, you cannot judge its risks."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Kamu tidak bisa menjelaskan dalam satu kalimat bagaimana perusahaan untung. Apa yang harus dilakukan?","options":["Lewati sahamnya","Beli sedikit saja","Tanya orang asing online","Berharap harga naik"],"answer":"Lewati sahamnya","explanation":"Jika kamu tidak bisa menjelaskan bisnisnya, kamu tidak bisa menilai risikonya."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$) AND cv.variant_type = 'question');

INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$), 'question', $JSON${"type":"fill_blank","difficulty":"beginner","parameters":{},"question":"Complete the invalidation rule: “I will reconsider this if _____.”","options":["my evidence changes","the price rises","a friend disagrees","the logo changes"],"answer":"my evidence changes","explanation":"The invalidation rule is tied to the evidence that supports your thesis."}$JSON$::jsonb, $JSON${"type":"fill_blank","difficulty":"beginner","parameters":{},"question":"Lengkapi aturan pembatalan: “Saya akan meninjau ulang jika _____.”","options":["bukti saya berubah","harga naik","teman tidak setuju","logonya berubah"],"answer":"bukti saya berubah","explanation":"Aturan pembatalan terikat pada bukti yang mendukung tesismu."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"How many sentences does the thesis template have?","options":["3","1","5","10"],"answer":"3","explanation":"Three sentences: belief, evidence, and invalidation rule."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Berapa kalimat dalam template tesis?","options":["3","1","5","10"],"answer":"3","explanation":"Tiga kalimat: keyakinan, bukti, dan aturan pembatalan."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$), 'question', $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Kira writes: “I believe TLKM will maintain earnings because mobile data demand is stable. My evidence is steady revenue. I will reconsider if revenue falls two quarters in a row.” Is this a complete thesis?","options":["Yes — it has belief, evidence, and invalidation","No — it needs a price target","No — it needs a broker name","No — it needs emoji"],"answer":"Yes — it has belief, evidence, and invalidation","explanation":"A complete thesis needs only a belief, supporting evidence, and a rule for changing your mind."}$JSON$::jsonb, $JSON${"type":"case_study","difficulty":"beginner","parameters":{},"question":"Kira menulis: “Saya percaya TLKM akan mempertahankan laba karena permintaan data seluler stabil. Bukti saya adalah pendapatan stabil. Saya akan tinjau ulang jika pendapatan turun dua kuartal berturut-turut.” Apakah tesis ini lengkap?","options":["Ya — punya keyakinan, bukti, dan pembatalan","Tidak — perlu target harga","Tidak — perlu nama broker","Tidak — perlu emoji"],"answer":"Ya — punya keyakinan, bukti, dan pembatalan","explanation":"Tesis lengkap hanya perlu keyakinan, bukti, dan aturan untuk berubah pikiran."}$JSON$::jsonb, $TXT$beginner$TXT$, $TXT$know_before_investing$TXT$, TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.content_variants cv WHERE cv.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$) AND cv.variant_type = 'question');

-- Visual blocks
INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$),
  $TXT$concept$TXT$,
  $TXT$process$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Readiness Checkpoints","altText":"Process: Readiness Checkpoints","disclosure":"Illustrative process for educational use only.","icon":"🛡️","payload":{"steps":[{"title":"🛡️ Emergency fund 3–6 months","description":"Emergency fund 3–6 months"},{"title":"💳 No high-interest debt","description":"No high-interest debt"},{"title":"📅 Money not needed for 2+ years","description":"Money not needed for 2+ years"},{"title":"🧠 Can handle a 20% drop","description":"Can handle a 20% drop"}]}},"id":{"title":"Pemeriksaan Kesiapan","altText":"Proses: Pemeriksaan Kesiapan","disclosure":"Proses ilustratif hanya untuk pembelajaran.","icon":"🛡️","payload":{"steps":[{"title":"🛡️ Dana darurat 3–6 bulan","description":"Dana darurat 3–6 bulan"},{"title":"💳 Tidak ada utang bunga tinggi","description":"Tidak ada utang bunga tinggi"},{"title":"📅 Uang tidak dibutuhkan 2+ tahun","description":"Uang tidak dibutuhkan 2+ tahun"},{"title":"🧠 Bisa hadapi penurunan 20%","description":"Bisa hadapi penurunan 20%"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$),
  $TXT$concept$TXT$,
  $TXT$comparison$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Market Animals","altText":"Comparison: Market Animals","disclosure":"Illustrative comparison for educational use only.","icon":"🐂","payload":{"leftTitle":"Animal","rightTitle":"Meaning","rows":[{"left":"🐂 Bull","right":"Prices rising, optimism"},{"left":"🐻 Bear","right":"Prices falling, pessimism"},{"left":"🐔 Chicken","right":"Panic-selling at the bottom"},{"left":"🐷 Pig","right":"Buying at the top on FOMO"}]}},"id":{"title":"Hewan-hewan Pasar","altText":"Perbandingan: Hewan-hewan Pasar","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"🐂","payload":{"leftTitle":"Hewan","rightTitle":"Arti","rows":[{"left":"🐂 Bull","right":"Harga naik, optimisme"},{"left":"🐻 Bear","right":"Harga turun, pesimisme"},{"left":"🐔 Chicken","right":"Jual panik di bawah"},{"left":"🐷 Pig","right":"Beli di puncak karena FOMO"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$),
  $TXT$concept$TXT$,
  $TXT$comparison$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Term Decoder","altText":"Comparison: Term Decoder","disclosure":"Illustrative comparison for educational use only.","icon":"🌱","payload":{"leftTitle":"Term","rightTitle":"Meaning","rows":[{"left":"Blue chip","right":"Large, stable company"},{"left":"Market cap","right":"Total value of all shares"},{"left":"Dividend yield","right":"Annual dividend / share price"},{"left":"IPO","right":"First public share sale"},{"left":"Portfolio","right":"All your investments together"},{"left":"Diversification","right":"Spread money to reduce risk"},{"left":"🌱 Green investing / ESG","right":"Invest with environment, social, governance in mind"},{"left":"🎭 Greenwashing","right":"Marketing that looks greener than the company really is"}]}},"id":{"title":"Dekoder Istilah","altText":"Perbandingan: Dekoder Istilah","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"🌱","payload":{"leftTitle":"Istilah","rightTitle":"Arti","rows":[{"left":"Saham unggulan","right":"Perusahaan besar dan stabil"},{"left":"Kapitalisasi pasar","right":"Nilai total seluruh saham"},{"left":"Yield dividen","right":"Dividen tahunan / harga saham"},{"left":"IPO","right":"Penjualan saham pertama ke publik"},{"left":"Portofolio","right":"Semua investasimu digabung"},{"left":"Diversifikasi","right":"Sebar uang untuk kurangi risiko"},{"left":"🌱 Investasi hijau / ESG","right":"Berinvestasi dengan memperhatikan lingkungan, sosial, tata kelola"},{"left":"🎭 Greenwashing","right":"Pemasaran yang terlihat lebih hijau dari kenyataannya"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$),
  $TXT$example$TXT$,
  $TXT$comparison$TXT$,
  1,
  'illustrative',
  $JSON${"en":{"title":"Value vs Growth","altText":"Comparison: Value vs Growth","disclosure":"Illustrative comparison for educational use only.","icon":"🛒","payload":{"leftTitle":"Style","rightTitle":"Approach","rows":[{"left":"🛒 Value","right":"Buy established companies that look undervalued"},{"left":"🚀 Growth","right":"Bet on faster future expansion, higher risk"},{"left":"🌱 Green / ESG","right":"Invest with planet and people in mind"}]}},"id":{"title":"Value vs Growth","altText":"Perbandingan: Value vs Growth","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"🛒","payload":{"leftTitle":"Gaya","rightTitle":"Pendekatan","rows":[{"left":"🛒 Value","right":"Beli perusahaan mapan yang kelihatan murah"},{"left":"🚀 Growth","right":"Taruhan pada ekspansi cepat di masa depan, risiko lebih tinggi"},{"left":"🌱 Green / ESG","right":"Berinvestasi dengan memperhatikan planet dan orang"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$),
  $TXT$concept$TXT$,
  $TXT$comparison$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Credibility Spectrum","altText":"Comparison: Credibility Spectrum","disclosure":"Illustrative comparison for educational use only.","icon":"🟢","payload":{"leftTitle":"Zone","rightTitle":"Sources","rows":[{"left":"🟢 Trust","right":"OJK, IDX, KSEI, company IR, licensed firms"},{"left":"🟡 Verify","right":"News outlets, analyst reports with disclaimers"},{"left":"🔴 Avoid","right":"Anonymous groups, paid signals, flexers"}]}},"id":{"title":"Spektrum Kredibilitas","altText":"Perbandingan: Spektrum Kredibilitas","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"🟢","payload":{"leftTitle":"Zona","rightTitle":"Sumber","rows":[{"left":"🟢 Trust","right":"OJK, IDX, KSEI, IR perusahaan, sekuritas berizin"},{"left":"🟡 Verify","right":"Media berita, laporan analis dengan disclaimer"},{"left":"🔴 Avoid","right":"Grup anonim, sinyal berbayar, pamer kekayaan"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$),
  $TXT$concept$TXT$,
  $TXT$process$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Source Ladder","altText":"Process: Source Ladder","disclosure":"Illustrative process for educational use only.","icon":"🏢","payload":{"steps":[{"title":"🏢 Company IR page","description":"Company IR page"},{"title":"🏛️ IDX stock quote","description":"IDX stock quote"},{"title":"📋 OJK SIPEBI filings","description":"OJK SIPEBI filings"},{"title":"👥 KSEI shareholder data","description":"KSEI shareholder data"}]}},"id":{"title":"Tangga Sumber","altText":"Proses: Tangga Sumber","disclosure":"Proses ilustratif hanya untuk pembelajaran.","icon":"🏢","payload":{"steps":[{"title":"🏢 Halaman IR perusahaan","description":"Halaman IR perusahaan"},{"title":"🏛️ Kutipan saham IDX","description":"Kutipan saham IDX"},{"title":"📋 Pengumuman OJK SIPEBI","description":"Pengumuman OJK SIPEBI"},{"title":"👥 Data pemegang saham KSEI","description":"Data pemegang saham KSEI"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$),
  $TXT$concept$TXT$,
  $TXT$process$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Annual Report Sections","altText":"Process: Annual Report Sections","disclosure":"Illustrative process for educational use only.","icon":"📄","payload":{"steps":[{"title":"📄 Directors' letter","description":"Directors' letter"},{"title":"💼 Business overview","description":"Business overview"},{"title":"📊 Financial statements","description":"Financial statements"},{"title":"📝 Notes to financial statements","description":"Notes to financial statements"},{"title":"✅ Auditor's report","description":"Auditor's report"},{"title":"👥 Corporate governance","description":"Corporate governance"}]}},"id":{"title":"Bagian Laporan Tahunan","altText":"Proses: Bagian Laporan Tahunan","disclosure":"Proses ilustratif hanya untuk pembelajaran.","icon":"📄","payload":{"steps":[{"title":"📄 Surat direksi","description":"Surat direksi"},{"title":"💼 Ikhtisar bisnis","description":"Ikhtisar bisnis"},{"title":"📊 Laporan keuangan","description":"Laporan keuangan"},{"title":"📝 Catatan laporan keuangan","description":"Catatan laporan keuangan"},{"title":"✅ Laporan auditor","description":"Laporan auditor"},{"title":"👥 Tata kelola perusahaan","description":"Tata kelola perusahaan"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$),
  $TXT$concept$TXT$,
  $TXT$comparison$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"The Three Statements","altText":"Comparison: The Three Statements","disclosure":"Illustrative comparison for educational use only.","icon":"💰","payload":{"leftTitle":"Statement","rightTitle":"What it tells you","rows":[{"left":"💰 Income Statement","right":"Did we make money? — Key line: Net profit"},{"left":"⚖️ Balance Sheet","right":"What do we own and owe? — Key line: Total equity"},{"left":"💵 Cash Flow","right":"Did cash actually move? — Key line: Operating cash flow"}]}},"id":{"title":"Tiga Laporan Keuangan","altText":"Perbandingan: Tiga Laporan Keuangan","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"💰","payload":{"leftTitle":"Laporan","rightTitle":"Apa yang disampaikan","rows":[{"left":"💰 Income Statement","right":"Apakah kita untung? — Baris kunci: Laba bersih"},{"left":"⚖️ Balance Sheet","right":"Apa yang kita miliki dan utangi? — Baris kunci: Total ekuitas"},{"left":"💵 Cash Flow","right":"Apakah kas benar-benar bergerak? — Baris kunci: Arus kas operasi"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$),
  $TXT$concept$TXT$,
  $TXT$comparison$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Red Flags","altText":"Comparison: Red Flags","disclosure":"Illustrative comparison for educational use only.","icon":"📉","payload":{"leftTitle":"Red flag","rightTitle":"What it means","rows":[{"left":"📉 Cash down, profit up","right":"Profit may not be backed by cash"},{"left":"📈 Debt rising fast","right":"Borrowing faster than growing"},{"left":"⚠️ Auditor qualification","right":"Accountant flagged an issue"},{"left":"🤝 Related-party deals","right":"Deals with insiders or affiliates"},{"left":"🚪 Management churn","right":"Leaders keep leaving"},{"left":"🎭🌱 Greenwashing","right":"Green claims without proof"}]}},"id":{"title":"Tanda Bahaya","altText":"Perbandingan: Tanda Bahaya","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"📉","payload":{"leftTitle":"Tanda bahaya","rightTitle":"Artinya","rows":[{"left":"📉 Cash down, profit up","right":"Laba mungkin tidak didukung kas"},{"left":"📈 Debt rising fast","right":"Utang tumbuh lebih cepat dari bisnis"},{"left":"⚠️ Auditor qualification","right":"Akuntan menandai masalah"},{"left":"🤝 Related-party deals","right":"Kesepakatan dengan pihak dalam"},{"left":"🚪 Management churn","right":"Pemimpin terus berganti"},{"left":"🎭🌱 Greenwashing","right":"Klaim hijau tanpa bukti"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$),
  $TXT$concept$TXT$,
  $TXT$worked_example$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Data → Reason → Story","altText":"Worked example: Data → Reason → Story","disclosure":"Worked example for educational use only.","payload":{"inputs":[{"label":"Context","value":"Company financial data"}],"steps":["Revenue up 15% → New store openings → Expansion is driving sales","Debt down 10% → One-time asset sale → Improvement may not repeat","Margin compressed → Raw material costs rose → Pricing power is under pressure"],"outcome":"A cautious story built from data, not a guarantee."}},"id":{"title":"Data → Alasan → Cerita","altText":"Contoh pengerjaan: Data → Alasan → Cerita","disclosure":"Contoh pengerjaan hanya untuk pembelajaran.","payload":{"inputs":[{"label":"Konteks","value":"Data keuangan perusahaan"}],"steps":["Pendapatan naik 15% → Pembukaan toko baru → Ekspansi mendorong penjualan","Utang turun 10% → Penjualan aset satu kali → Peningkatan mungkin tidak berulang","Margin menipis → Biaya bahan baku naik → Kekuatan harga sedang tertekan"],"outcome":"Cerita hati-hati dari data, bukan jaminan."}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$),
  $TXT$concept$TXT$,
  $TXT$comparison$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Watchlist Criteria","altText":"Comparison: Watchlist Criteria","disclosure":"Illustrative comparison for educational use only.","icon":"🏦","payload":{"leftTitle":"Criterion","rightTitle":"Rule","rows":[{"left":"🏦 Sector focus","right":"Only sectors you can explain"},{"left":"📊 PBV / PER range","right":"Reasonable for the sector"},{"left":"📉 Debt ceiling","right":"Debt-to-equity under your limit"},{"left":"💰 Profit history","right":"At least 3 years profitable"},{"left":"📅 Dividend yield","right":"Optional minimum if income matters"}]}},"id":{"title":"Kriteria Watchlist","altText":"Perbandingan: Kriteria Watchlist","disclosure":"Perbandingan ilustratif hanya untuk pembelajaran.","icon":"🏦","payload":{"leftTitle":"Kriteria","rightTitle":"Aturan","rows":[{"left":"🏦 Sector focus","right":"Hanya sektor yang bisa kamu jelaskan"},{"left":"📊 PBV / PER range","right":"Masuk akal untuk sektornya"},{"left":"📉 Debt ceiling","right":"Debt-to-equity di bawah batasmu"},{"left":"💰 Profit history","right":"Laba minimal 3 tahun"},{"left":"📅 Dividend yield","right":"Minimum opsional jika pendapatan penting"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$),
  $TXT$concept$TXT$,
  $TXT$process$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"5-Minute Drill","altText":"Process: 5-Minute Drill","disclosure":"Illustrative process for educational use only.","icon":"1️⃣","payload":{"steps":[{"title":"1️⃣ PBV / PER vs sector","description":"PBV / PER vs sector"},{"title":"2️⃣ Debt-to-equity","description":"Debt-to-equity"},{"title":"3️⃣ 3-year profit trend","description":"3-year profit trend"},{"title":"4️⃣ Recent news / OJK / IDX","description":"Recent news / OJK / IDX"},{"title":"5️⃣ One-sentence business model","description":"One-sentence business model"}]}},"id":{"title":"Drill 5 Menit","altText":"Proses: Drill 5 Menit","disclosure":"Proses ilustratif hanya untuk pembelajaran.","icon":"1️⃣","payload":{"steps":[{"title":"1️⃣ PBV / PER vs sektor","description":"PBV / PER vs sektor"},{"title":"2️⃣ Debt-to-equity","description":"Debt-to-equity"},{"title":"3️⃣ Tren laba 3 tahun","description":"Tren laba 3 tahun"},{"title":"4️⃣ Berita terkini / OJK / IDX","description":"Berita terkini / OJK / IDX"},{"title":"5️⃣ Model bisnis satu kalimat","description":"Model bisnis satu kalimat"}]}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

INSERT INTO public.lesson_visual_blocks (id, lesson_id, placement, block_type, display_order, data_status, content, is_published)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$),
  $TXT$concept$TXT$,
  $TXT$worked_example$TXT$,
  0,
  'illustrative',
  $JSON${"en":{"title":"Thesis Template","altText":"Worked example: Thesis Template","disclosure":"Worked example for educational use only.","payload":{"inputs":[{"label":"Exercise","value":"Fill in the three-sentence thesis template"}],"steps":["I believe [company] will [grow/maintain] because [reason from data].","My evidence is [financial metric / annual report finding / industry trend].","I will reconsider this if [specific event or metric change]."],"outcome":"A clear, testable investment thesis."}},"id":{"title":"Template Tesis","altText":"Contoh pengerjaan: Template Tesis","disclosure":"Contoh pengerjaan hanya untuk pembelajaran.","payload":{"inputs":[{"label":"Latihan","value":"Isi template tesis tiga kalimat"}],"steps":["Saya percaya [perusahaan] akan [tumbuh/bertahan] karena [alasan dari data].","Bukti saya adalah [metrik keuangan / temuan laporan tahunan / tren industri].","Saya akan meninjau ulang jika [peristiwa spesifik atau perubahan metrik]."],"outcome":"Tesis investasi yang jelas dan bisa diuji."}}}$JSON$,
  TRUE
)
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = EXCLUDED.is_published;

-- Recall questions
INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$),
  $TXT$Before investing, you should have an emergency fund, no high-interest debt, a 2-year time horizon, and what else?$TXT$,
  $TXT$Sebelum berinvestasi, kamu harus punya dana darurat, bebas utang bunga tinggi, horison 2 tahun, dan apa lagi?$TXT$,
  $JSON$["The ability to stay calm during a market drop","A paid stock-picking group","At least three brokerage apps","A friend who works at a securities firm"]$JSON$,
  $JSON$["Kemampuan tetap tenang saat pasar turun","Grup pilih saham berbayar","Minimal tiga aplikasi sekuritas","Teman yang kerja di sekuritas"]$JSON$,
  $TXT$The ability to stay calm during a market drop$TXT$,
  $TXT$Emotional readiness keeps you from panic-selling at the worst time.$TXT$,
  $TXT$Kesiapan emosional mencegahmu jual panik di saat terburuk.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$),
  $TXT$Which animal represents panic-selling at the bottom?$TXT$,
  $TXT$Hewan mana yang melambangkan jual panik di bawah?$TXT$,
  $JSON$["Chicken","Bull","Bear","Pig"]$JSON$,
  $JSON$["Ayam","Banteng","Beruang","Babi"]$JSON$,
  $TXT$Chicken$TXT$,
  $TXT$The chicken sells in fear after prices have already fallen.$TXT$,
  $TXT$Ayam menjual karena takut setelah harga sudah jatuh.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$),
  $TXT$Which term means “the total value of a company’s shares”?$TXT$,
  $TXT$Istilah mana yang berarti “nilai total saham perusahaan”?$TXT$,
  $JSON$["Market cap","Dividend yield","Portfolio","IPO"]$JSON$,
  $JSON$["Market cap","Dividend yield","Portofolio","IPO"]$JSON$,
  $TXT$Market cap$TXT$,
  $TXT$Market capitalisation is share price multiplied by shares outstanding.$TXT$,
  $TXT$Kapitalisasi pasar adalah harga saham dikalikan jumlah saham beredar.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$),
  $TXT$Which of these is a red flag when evaluating a source?$TXT$,
  $TXT$Mana di antara ini yang merupakan tanda bahaya saat menilai sumber?$TXT$,
  $JSON$["Guaranteed returns","Clear disclaimers","Links to official filings","Named organisation"]$JSON$,
  $JSON$["Imbal hasil dijamin","Disclaimer jelas","Tautan ke pengumuman resmi","Nama organisasi"]$JSON$,
  $TXT$Guaranteed returns$TXT$,
  $TXT$No legitimate source can guarantee investment returns.$TXT$,
  $TXT$Tidak ada sumber sah yang bisa menjamin imbal hasil investasi.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$),
  $TXT$Which source is best for checking a company’s audited annual report?$TXT$,
  $TXT$Sumber mana yang terbaik untuk memeriksa laporan tahunan teraudit perusahaan?$TXT$,
  $JSON$["OJK SIPEBI","IDX stock quote","KSEI","Company IR page"]$JSON$,
  $JSON$["OJK SIPEBI","Kutipan saham IDX","KSEI","Halaman IR perusahaan"]$JSON$,
  $TXT$OJK SIPEBI$TXT$,
  $TXT$OJK SIPEBI stores official company filings and annual reports.$TXT$,
  $TXT$OJK SIPEBI menyimpan pengumuman resmi dan laporan tahunan perusahaan.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$),
  $TXT$Which annual-report section gives the independent opinion on whether the numbers are trustworthy?$TXT$,
  $TXT$Bagian laporan tahunan mana yang memberikan opini independen apakah angka-angka bisa dipercaya?$TXT$,
  $JSON$["Auditor's report","Directors' letter","Business overview","Notes to financial statements"]$JSON$,
  $JSON$["Laporan auditor","Surat direksi","Ikhtisar bisnis","Catatan laporan keuangan"]$JSON$,
  $TXT$Auditor's report$TXT$,
  $TXT$The auditor independently checks the financial statements and states an opinion.$TXT$,
  $TXT$Auditor secara independen memeriksa laporan keuangan dan menyatakan opini.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$),
  $TXT$Which statement is often called “harder to fake” than profit?$TXT$,
  $TXT$Laporan mana yang sering disebut “lebih sulit dipalsukan” daripada laba?$TXT$,
  $JSON$["Cash flow statement","Income statement","Balance sheet","Auditor’s report"]$JSON$,
  $JSON$["Laporan arus kas","Laporan laba rugi","Neraca","Laporan auditor"]$JSON$,
  $TXT$Cash flow statement$TXT$,
  $TXT$Cash flow tracks actual money movement, not accounting profit.$TXT$,
  $TXT$Arus kas melacak pergerakan uang nyata, bukan laba akuntansi.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$),
  $TXT$Profit is rising but operating cash flow is falling. What does this suggest?$TXT$,
  $TXT$Laba naik tapi arus kas operasi turun. Apa yang ini tunjukkan?$TXT$,
  $JSON$["Profit may not be backed by cash","The company is definitely a buy","Dividends are safe","The auditor loves the report"]$JSON$,
  $JSON$["Laba mungkin tidak didukung kas","Perusahaan pasti layak beli","Dividen aman","Auditor menyukai laporan tersebut"]$JSON$,
  $TXT$Profit may not be backed by cash$TXT$,
  $TXT$Cash flow shows whether the business is actually collecting money.$TXT$,
  $TXT$Arus kas menunjukkan apakah bisnis benar-benar mengumpulkan uang.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$),
  $TXT$Why is it dangerous to confuse correlation with causation?$TXT$,
  $TXT$Mengapa berbahaya mencampuradukkan korelasi dan kausalitas?$TXT$,
  $JSON$["Two events together do not prove one caused the other","Correlation is always wrong","Causation is illegal","Stories are useless"]$JSON$,
  $JSON$["Dua peristiwa bersama tidak membuktikan satu menyebabkan lainnya","Korelasi selalu salah","Kausalitas ilegal","Cerita tidak berguna"]$JSON$,
  $TXT$Two events together do not prove one caused the other$TXT$,
  $TXT$You need a logical business link and evidence, not just timing.$TXT$,
  $TXT$Kamu butuh hubungan bisnis logis dan bukti, bukan hanya waktu yang berdekatan.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$),
  $TXT$What is the main purpose of a watchlist?$TXT$,
  $TXT$Apa tujuan utama watchlist?$TXT$,
  $JSON$["Track stocks you are researching before buying","Record stocks you already own","Receive paid signals","Follow social media trends"]$JSON$,
  $JSON$["Pantau saham yang sedang diriset sebelum beli","Catat saham yang sudah dimiliki","Terima sinyal berbayar","Ikut tren medsos"]$JSON$,
  $TXT$Track stocks you are researching before buying$TXT$,
  $TXT$A watchlist is your personal research queue, not a purchase log.$TXT$,
  $TXT$Watchlist adalah antrean riset pribadimu, bukan catatan pembelian.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$),
  $TXT$In the 5-minute drill, what should you do if a stock fails one of the checks?$TXT$,
  $TXT$Dalam drill 5 menit, apa yang harus dilakukan jika saham gagal salah satu pemeriksaan?$TXT$,
  $JSON$["Pass on it and move on","Buy more to average down","Ask the company CEO","Ignore the check"]$JSON$,
  $JSON$["Lewati dan lanjutkan","Beli lebih banyak untuk rata-rata turun","Tanya CEO perusahaan","Abaikan pemeriksaan"]$JSON$,
  $TXT$Pass on it and move on$TXT$,
  $TXT$The drill is a filter; a fail means the stock is not worth your time right now.$TXT$,
  $TXT$Drill ini adalah filter; gagal berarti saham tidak layak waktumu saat ini.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

INSERT INTO public.lesson_recall_questions (id, lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
VALUES (
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$),
  $TXT$What is the purpose of an invalidation rule?$TXT$,
  $TXT$Apa tujuan aturan pembatalan?$TXT$,
  $JSON$["To define what evidence would make you reconsider","To guarantee a profit","To impress your friends","To avoid reading annual reports"]$JSON$,
  $JSON$["Menentukan bukti apa yang membuatmu meninjau ulang","Menjamin untung","Pamer ke teman","Hindari baca laporan tahunan"]$JSON$,
  $TXT$To define what evidence would make you reconsider$TXT$,
  $TXT$It turns your thesis into a testable idea and protects against hindsight bias.$TXT$,
  $TXT$Ini mengubah tesis menjadi ide yang bisa diuji dan melindungi dari bias hindsight.$TXT$,
  TRUE
)
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = EXCLUDED.is_active;

-- Lesson sources
INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-LITERASI-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$IDX-EDU-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-LITERASI-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-LITERASI-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-SUSTAINABLE-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-LITERASI-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$IDX-EDU-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$IDX-EDU-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-FILINGS-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$KSEI-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-FILINGS-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-FILINGS-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-FILINGS-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-SUSTAINABLE-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-FILINGS-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$IDX-EDU-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$IDX-EDU-001$TXT$), 'primary', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-FILINGS-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

INSERT INTO public.lesson_sources (id, lesson_id, source_id, relevance_type, is_primary)
VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$), (SELECT id FROM public.sources WHERE source_code = $TXT$OJK-LITERASI-001$TXT$), 'primary', TRUE)
ON CONFLICT (lesson_id, source_id) DO NOTHING;

-- Lesson reviews
INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$are-you-ready-to-invest$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$bull-bear-market-zoo$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$investing-jargon-decoder$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$who-can-you-trust$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$where-real-data-lives$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$inside-an-annual-report$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$three-statements-at-a-glance$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$red-flags-in-the-fine-print$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$from-data-to-a-story$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$building-your-first-watchlist$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$the-5-minute-research-drill$TXT$));

INSERT INTO public.lesson_reviews (id, lesson_id, reviewer_name, reviewer_role, review_date, factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status, notes, approved_to_publish)
SELECT
  gen_random_uuid(),
  (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$),
  'koin-curriculum-agent',
  'curriculum-agent',
  CURRENT_DATE,
  'pass',
  'pass',
  'pass',
  'pass',
  'Phase 1 low-key content; no live prices or recommendations.',
  TRUE
WHERE NOT EXISTS (SELECT 1 FROM public.lesson_reviews lr WHERE lr.lesson_id = (SELECT id FROM public.lessons WHERE slug = $TXT$make-your-case$TXT$));

COMMIT;