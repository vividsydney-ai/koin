-- KO-373 quality follow-up:
-- 1. Correct source tiers/names/organizations so Wikipedia fallbacks are not labelled as OJK/IDX.
-- 2. Rewrite explanation variants to be genuinely simpler and distinct from concept bodies.
-- 3. Add at least two extra active question variants per lesson so every lesson has >= 5.
BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Source quality and honesty
-- ---------------------------------------------------------------------------

-- Wikipedia fallback for personal-finance readiness (official OJK page is unreachable).
UPDATE public.sources
SET
  source_tier = 3,
  source_type = 'encyclopedia',
  title = 'Wikipedia — Personal finance',
  local_title = 'Wikipedia — Keuangan pribadi',
  organization = 'Wikipedia',
  url = 'https://en.wikipedia.org/wiki/Personal_finance',
  synopsis = 'Personal finance covers budgeting, saving, debt management, emergency funds, and goal setting before investing.',
  synopsis_id = 'Keuangan pribadi mencakup anggaran, menabung, manajemen utang, dana darurat, dan penetapan tujuan sebelum berinvestasi.',
  relevance_blurb = 'Supports the readiness check that stable finances should come before market risk.',
  relevance_blurb_id = 'Mendukung pemeriksaan kesiapan bahwa keuangan yang stabil harus didahulukan sebelum mengambil risiko pasar.',
  localization_notes = 'Tier-3 fallback. The official OJK Sikapi Uangmu page blocks automated/cross-region requests, so this stable Wikipedia article is used instead.',
  status = 'verified',
  last_checked_at = NOW()
WHERE source_code = 'OJK-LITERASI-001';

-- Wikipedia fallback for the Indonesia Stock Exchange (official IDX education page is unreachable).
UPDATE public.sources
SET
  source_tier = 3,
  source_type = 'encyclopedia',
  title = 'Wikipedia — Indonesia Stock Exchange',
  local_title = 'Wikipedia — Bursa Efek Indonesia',
  organization = 'Wikipedia',
  url = 'https://en.wikipedia.org/wiki/Indonesia_Stock_Exchange',
  synopsis = 'The Indonesia Stock Exchange (IDX) is the national stock exchange providing listed securities, market data, and investor education.',
  synopsis_id = 'Bursa Efek Indonesia (BEI) adalah bursa saham nasional yang menyediakan efek tercatat, data pasar, dan edukasi investor.',
  relevance_blurb = 'Provides context for how Indonesian capital markets operate and where official company disclosures are published.',
  relevance_blurb_id = 'Memberikan konteks bagaimana pasar modal Indonesia beroperasi dan di mana pengungkapan perusahaan resmi diterbitkan.',
  localization_notes = 'Tier-3 fallback. The official IDX Capital Market School page returns 403/404 from many learner networks.',
  status = 'verified',
  last_checked_at = NOW()
WHERE source_code = 'IDX-EDU-001';

-- Wikipedia fallback for financial-statement fundamentals (official IDX filings gateway is unreachable).
UPDATE public.sources
SET
  source_tier = 3,
  source_type = 'encyclopedia',
  title = 'Wikipedia — Financial statement',
  local_title = 'Wikipedia — Laporan keuangan',
  organization = 'Wikipedia',
  url = 'https://en.wikipedia.org/wiki/Financial_statement',
  synopsis = 'Financial statements summarize a company''s financial position, performance, and cash flows, forming the basis of fundamental analysis.',
  synopsis_id = 'Laporan keuangan merangkum posisi keuangan, kinerja, dan arus kas perusahaan, yang menjadi dasar analisis fundamental.',
  relevance_blurb = 'Explains why reading annual reports and financial statements matters before picking stocks or funds.',
  relevance_blurb_id = 'Menjelaskan mengapa membaca laporan tahunan dan laporan keuangan penting sebelum memilih saham atau reksa dana.',
  localization_notes = 'Tier-3 fallback. The official IDX financial-statements gateway blocks automated/cross-region requests.',
  status = 'verified',
  last_checked_at = NOW()
WHERE source_code = 'OJK-FILINGS-001';

-- KSEI is reachable and stays Tier 1.
UPDATE public.sources
SET
  source_tier = 1,
  source_type = 'website',
  title = 'PT Kustodian Sentral Efek Indonesia',
  local_title = 'PT Kustodian Sentral Efek Indonesia',
  organization = 'KSEI',
  url = 'https://www.ksei.co.id',
  synopsis = 'KSEI is Indonesia''s central securities depository that records ownership of stocks, bonds, and other securities in investor accounts.',
  synopsis_id = 'KSEI adalah kustodian sentral efek Indonesia yang mencatat kepemilikan saham, obligasi, dan efek lainnya di rekening investor.',
  relevance_blurb = 'Helps learners understand how securities ownership is recorded and settled in Indonesia.',
  relevance_blurb_id = 'Membantu pelajar memahami bagaimana kepemilikan efek dicatat dan diselesaikan di Indonesia.',
  localization_notes = 'Tier-1 official source. Central securities depository for Indonesian capital markets.',
  status = 'verified',
  last_checked_at = NOW()
WHERE source_code = 'KSEI-001';

-- OJK Sustainable Finance Taxonomy PDF is reachable and stays Tier 1.
UPDATE public.sources
SET
  source_tier = 1,
  source_type = 'document',
  title = 'Indonesia Taxonomy for Sustainable Finance',
  local_title = 'Taksonomi Indonesia untuk Keuangan Berkelanjutan',
  organization = 'Otoritas Jasa Keuangan',
  url = 'https://www.ojk.go.id/en/Publikasi/Roadmap-dan-Pedoman/Sektor-Jasa-Keuangan/Keuangan-Berkelanjutan/Documents/Indonesia%20Taxonomy%20for%20Sustainable%20Finance%202025%20Version%202.pdf',
  synopsis = 'The Sustainable Finance Taxonomy defines which economic activities qualify as green or sustainable in Indonesia.',
  synopsis_id = 'Taksonomi Keuangan Berkelanjutan menentukan aktivitas ekonomi mana yang memenuhi syarat hijau atau berkelanjutan di Indonesia.',
  relevance_blurb = 'Used to introduce ESG and greenwashing concepts relevant to Indonesian investors.',
  relevance_blurb_id = 'Digunakan untuk memperkenalkan konsep ESG dan greenwashing yang relevan bagi investor Indonesia.',
  localization_notes = 'Tier-1 official OJK document defining green and sustainable activities in Indonesia.',
  status = 'verified',
  last_checked_at = NOW()
WHERE source_code = 'OJK-SUSTAINABLE-001';

-- ---------------------------------------------------------------------------
-- 2. Rewrite explanation variants so "Explain simpler" is actually simpler
-- ---------------------------------------------------------------------------

UPDATE public.content_variants
SET
  body = $JSON${"text":"Before investing, cover your basics first: an emergency fund, no expensive debt, money you can leave alone for at least two years, and nerves for a 20% drop. If any are missing, wait."}$JSON$::jsonb,
  body_id = $JSON${"text":"Sebelum berinvestasi, penuhi dasar-dulu: dana darurat, bebas utang mahal, uang yang bisa ditinggal minimal dua tahun, dan mental kuat menghadapi penurunan 20%. Kalau ada yang kurang, tunggu dulu."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'are-you-ready-to-invest');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Bull market = prices going up. Bear market = prices going down. Sideways = going nowhere. Corrections and crashes happen and are normal, not reasons to panic."}$JSON$::jsonb,
  body_id = $JSON${"text":"Bull market = harga naik. Bear market = harga turun. Sideways = tidak kemana-mana. Koreksi dan crash terjadi dan wajar, bukan alasan panik."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'bull-bear-market-zoo');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Blue chip = big stable company. Market cap = total company value. Dividend yield = cash return vs price. IPO = first share sale. Portfolio = all your investments. Diversification = spread money around. ESG = invest with values. Greenwashing = fake green ads."}$JSON$::jsonb,
  body_id = $JSON${"text":"Blue chip = perusahaan besar stabil. Market cap = nilai total perusahaan. Dividend yield = dividen vs harga. IPO = penjualan saham pertama. Portofolio = semua investasimu. Diversifikasi = sebar uang. ESG = berinvestasi dengan nilai. Greenwashing = iklan hijau palsu."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'investing-jargon-decoder');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Green sources are regulators and licensed firms you can mostly trust. Yellow sources are news and analyst reports you should verify. Red sources are anonymous tips, paid signals, and social-media hype. Watch for guaranteed returns and pressure to buy."}$JSON$::jsonb,
  body_id = $JSON${"text":"Sumber hijau adalah regulator dan perusahaan berizin yang bisa dipercaya. Sumber kuning adalah berita dan laporan analis yang perlu diverifikasi. Sumber merah adalah tips anonim, sinyal berbayar, dan hype media sosial. Waspadai imbal hasil dijamin dan tekanan beli."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'who-can-you-trust');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Start with official facts: IDX for prices, OJK SIPEBI for filings, KSEI for ownership, and the company IR page for dividends. Only look at opinions after you have checked the facts."}$JSON$::jsonb,
  body_id = $JSON${"text":"Mulai dari fakta resmi: IDX untuk harga, OJK SIPEBI untuk pengumuman, KSEI untuk kepemilikan, dan halaman IR perusahaan untuk dividen. Baru lihat opini setelah memeriksa fakta."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'where-real-data-lives');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Annual reports are thick, but six sections matter most: directors'' letter, business overview, financial statements, notes, auditor opinion, and governance. Start with the numbers, then read the story around them."}$JSON$::jsonb,
  body_id = $JSON${"text":"Laporan tahunan tebal, tapi enam bagian paling penting: surat direksi, ikhtisar bisnis, laporan keuangan, catatan, opini auditor, dan tata kelola. Mulai dari angka, baru baca cerita di sekitarnya."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'inside-an-annual-report');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Three statements tell different stories. The income statement shows profit. The balance sheet shows what the company owns and owes. The cash-flow statement shows real money movement. Cash is harder to fake than profit."}$JSON$::jsonb,
  body_id = $JSON${"text":"Tiga laporan menceritakan hal berbeda. Laporan laba rugi menunjukkan untung. Neraca menunjukkan yang dimiliki dan ditanggung. Laporan arus kas menunjukkan pergerakan uang nyata. Kas lebih sulit dipalsukan daripada laba."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'three-statements-at-a-glance');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Watch for profit rising while cash falls, debt growing fast, auditor warnings, related-party deals, frequent management changes, and greenwashing. One flag asks a question; three flags warn."}$JSON$::jsonb,
  body_id = $JSON${"text":"Waspadai laba naik tapi kas turun, utang tumbuh cepat, peringatan auditor, transaksi pihak terkait, pergantian manajemen sering, dan greenwashing. Satu tanda membuat bertanya; tiga tanda memperingatkan."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'red-flags-in-the-fine-print');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Data only becomes insight when you connect it with evidence. Revenue up because new stores opened is a real story. Revenue up because the CEO bought a car is not."}$JSON$::jsonb,
  body_id = $JSON${"text":"Data menjadi wawasan hanya jika dihubungkan dengan bukti. Pendapatan naik karena buka toko baru adalah cerita nyata. Pendapatan naik karena CEO beli mobil bukan."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'from-data-to-a-story');

UPDATE public.content_variants
SET
  body = $JSON${"text":"A watchlist is a shortlist of stocks you want to research, not a buy list. Good rules: understand the sector, keep valuation reasonable, limit debt, and have a profit history. Ignore tips."}$JSON$::jsonb,
  body_id = $JSON${"text":"Watchlist adalah daftar saham yang ingin diteliti, bukan daftar beli. Aturan baik: pahami sektor, valuasi masuk akal, utang terbatas, dan punya riwayat untung. Abaikan tips."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'building-your-first-watchlist');

UPDATE public.content_variants
SET
  body = $JSON${"text":"Run a quick checklist before buying: compare PBV and PER to the sector, check debt, check the profit trend, check news, and explain the business in one sentence. If you cannot pass the checklist, skip it."}$JSON$::jsonb,
  body_id = $JSON${"text":"Lakukan daftar periksa cepat sebelum beli: bandingkan PBV dan PER dengan sektor, cek utang, cek tren laba, cek berita, dan jelaskan bisnis dalam satu kalimat. Kalau tidak lolos, lewati."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'the-5-minute-research-drill');

UPDATE public.content_variants
SET
  body = $JSON${"text":"A thesis is three sentences: what you believe, the evidence, and what would prove you wrong. The third sentence is your safety net against wishful thinking."}$JSON$::jsonb,
  body_id = $JSON${"text":"Tesis adalah tiga kalimat: apa yang kamu percaya, buktinya, dan apa yang bisa membuktikan kamu salah. Kalimat ketiga adalah pengaman dari harapan berlebihan."}$JSON$::jsonb
WHERE variant_type = 'explanation'
  AND lesson_id = (SELECT id FROM public.lessons WHERE slug = 'make-your-case');

-- ---------------------------------------------------------------------------
-- 3. Add extra question variants so every KO-373 lesson has >= 5 active questions
-- ---------------------------------------------------------------------------

-- are-you-ready-to-invest: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'are-you-ready-to-invest'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which of these is the best sign you are ready to invest?","options":["Emergency fund in place, no high-interest debt, long-term money","A hot stock tip from social media","A friend doubled their money last month","You opened three brokerage apps"],"answer":"Emergency fund in place, no high-interest debt, long-term money","explanation":"Readiness comes from stable finances, not tips or app downloads."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Manakah tanda terbaik bahwa kamu sudah siap berinvestasi?","options":["Dana darurat ada, bebas utang bunga tinggi, uang jangka panjang","Tips saham panas dari media sosial","Teman untung dua kali lipat bulan lalu","Kamu buka tiga aplikasi sekuritas"],"answer":"Dana darurat ada, bebas utang bunga tinggi, uang jangka panjang","explanation":"Kesiapan datang dari keuangan stabil, bukan dari tips atau unduhan aplikasi."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'are-you-ready-to-invest'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Investing money you need next month is a safe way to grow it.","answer":false,"explanation":"Short-term money should stay safe and liquid."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Berinvestasi dengan uang yang dibutuhkan bulan depan adalah cara aman untuk menumbuhkannya.","answer":false,"explanation":"Uang jangka pendek harus tetap aman dan likuid."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- bull-bear-market-zoo: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'bull-bear-market-zoo'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which animal describes an investor who buys near the top because of FOMO?","options":["Pig","Bull","Bear","Chicken"],"answer":"Pig","explanation":"The pig buys at the top out of fear of missing out."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Hewan mana yang menggambarkan investor yang beli di dekat puncak karena FOMO?","options":["Babi","Banteng","Beruang","Ayam"],"answer":"Babi","explanation":"Babi beli di puncak karena takut ketinggalan."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'bull-bear-market-zoo'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"A correction and a crash are the same thing.","answer":false,"explanation":"A correction is roughly a 10% drop; a crash is usually 20% or more."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Koreksi dan crash adalah hal yang sama.","answer":false,"explanation":"Koreksi kira-kira penurunan 10%; crash biasanya 20% atau lebih."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- investing-jargon-decoder: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'investing-jargon-decoder'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A company claims to be green but most revenue still comes from coal. What is this?","options":["Greenwashing","Blue chip","IPO","Diversification"],"answer":"Greenwashing","explanation":"Big green marketing without matching business reality is greenwashing."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Perusahaan mengklaim hijau tapi sebagian besar pendapatan masih dari batu bara. Apa ini?","options":["Greenwashing","Saham unggulan","IPO","Diversifikasi"],"answer":"Greenwashing","explanation":"Pemasaran hijau besar tanpa realitas bisnis yang sesuai adalah greenwashing."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'investing-jargon-decoder'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Spreading your money across many assets to lower risk is called:","options":["Diversification","Market cap","IPO","Dividend yield"],"answer":"Diversification","explanation":"Diversification means not putting everything in one place."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Menyebar uang ke banyak aset untuk mengurangi risiko disebut:","options":["Diversifikasi","Market cap","IPO","Yield dividen"],"answer":"Diversifikasi","explanation":"Diversifikasi artinya tidak menaruh semua uang di satu tempat."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- who-can-you-trust: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'who-can-you-trust'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A source promises 'guaranteed 200% returns' and asks for a fee. Which zone is it in?","options":["Red","Green","Yellow","Tier 1"],"answer":"Red","explanation":"Guaranteed returns and fees to join are classic red-zone signs."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Sumber menjanjikan 'imbal hasil dijamin 200%' dan meminta biaya. Zona mana?","options":["Merah","Hijau","Kuning","Tier 1"],"answer":"Merah","explanation":"Imbal hasil dijamin dan biaya join adalah tanda zona merah yang klasik."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'who-can-you-trust'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Licensed securities firms are generally in the green trust zone.","answer":true,"explanation":"Licensed firms are regulated and therefore in the green zone."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Perusahaan sekuritas berizin umumnya masuk zona hijau.","answer":true,"explanation":"Perusahaan berizin diawasi sehingga masuk zona hijau."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- where-real-data-lives: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'where-real-data-lives'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"For official company filings and annual reports, the best first stop is:","options":["OJK SIPEBI","A finance YouTube channel","A stock-picking forum","Twitter"],"answer":"OJK SIPEBI","explanation":"OJK SIPEBI is the official repository for company filings."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Untuk pengumuman resmi dan laporan tahunan perusahaan, pemberhentian pertama terbaik adalah:","options":["OJK SIPEBI","Kanal YouTube keuangan","Forum pilih saham","Twitter"],"answer":"OJK SIPEBI","explanation":"OJK SIPEBI adalah repositori resmi pengumuman perusahaan."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'where-real-data-lives'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Third-party opinions should come before reading official filings.","answer":false,"explanation":"Check official facts first, then look at opinions."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Opini pihak ketiga harus didahulukan sebelum membaca pengumuman resmi.","answer":false,"explanation":"Periksa fakta resmi dulu, baru lihat opini."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- inside-an-annual-report: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'inside-an-annual-report'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which section gives an independent opinion on whether the numbers are fair?","options":["Auditor's report","Directors' letter","Business overview","Governance"],"answer":"Auditor's report","explanation":"The auditor independently reviews the financial statements."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Bagian mana yang memberi opini independen apakah angkanya wajar?","options":["Laporan auditor","Surat direksi","Ikhtisar bisnis","Tata kelola"],"answer":"Laporan auditor","explanation":"Auditor meninjau laporan keuangan secara independen."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'inside-an-annual-report'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"You should read an annual report from cover to cover every time.","answer":false,"explanation":"Focus on the key sections instead of reading everything."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Kamu harus membaca laporan tahunan dari sampul ke sampul setiap kali.","answer":false,"explanation":"Fokus pada bagian kunci, tidak perlu baca semuanya."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- three-statements-at-a-glance: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'three-statements-at-a-glance'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which statement best shows whether cash actually entered or left the company?","options":["Cash flow statement","Income statement","Balance sheet","Directors' report"],"answer":"Cash flow statement","explanation":"Cash flow tracks real money movement."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Laporan mana yang paling menunjukkan apakah kas benar-benar masuk atau keluar perusahaan?","options":["Laporan arus kas","Laporan laba rugi","Neraca","Laporan direksi"],"answer":"Laporan arus kas","explanation":"Arus kas melacak pergerakan uang nyata."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'three-statements-at-a-glance'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"A company can report profit while its cash flow is negative.","answer":true,"explanation":"Profit is an accounting measure; cash flow can be negative at the same time."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Perusahaan bisa melaporkan untung sementara arus kasnya negatif.","answer":true,"explanation":"Laba adalah ukuran akuntansi; arus kas bisa negatif bersamaan."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- red-flags-in-the-fine-print: add 2 (total 6)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'red-flags-in-the-fine-print'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Profit is rising but operating cash flow is falling. What should you do?","options":["Ask harder questions","Buy immediately","Trust the headline","Ignore it"],"answer":"Ask harder questions","explanation":"A gap between profit and cash is a warning sign that needs explanation."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Laba naik tapi arus kas operasi turun. Apa yang harus dilakukan?","options":["Ajukan pertanyaan lebih keras","Beli segera","Percaya headline","Abaikan"],"answer":"Ajukan pertanyaan lebih keras","explanation":"Jarak antara laba dan kas adalah tanda bahaya yang perlu dijelaskan."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'red-flags-in-the-fine-print'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Greenwashing means a company markets itself as greener than it really is.","answer":true,"explanation":"Greenwashing is misleading green marketing."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Greenwashing berarti perusahaan memasarkan diri lebih hijau dari kenyataannya.","answer":true,"explanation":"Greenwashing adalah pemasaran hijau yang menyesatkan."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- from-data-to-a-story: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'from-data-to-a-story'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"What makes a data story trustworthy?","options":["It is backed by evidence and can be proven wrong","It explains the CEO's new car","It uses exciting headlines","It ignores counter-evidence"],"answer":"It is backed by evidence and can be proven wrong","explanation":"A good story can be tested against evidence."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Apa yang membuat cerita data bisa dipercaya?","options":["Didukung bukti dan bisa dibuktikan salah","Menjelaskan mobil baru CEO","Menggunakan headline seru","Abaikan bukti kontra"],"answer":"Didukung bukti dan bisa dibuktikan salah","explanation":"Cerita yang baik bisa diuji dengan bukti."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'from-data-to-a-story'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Correlation always means causation.","answer":false,"explanation":"Two things happening together does not prove one caused the other."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Korelasi selalu berarti kausalitas.","answer":false,"explanation":"Dua hal terjadi bersamaan tidak membuktikan satu menyebabkan yang lain."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- building-your-first-watchlist: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'building-your-first-watchlist'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"A good watchlist rule is:","options":["Only include companies you can explain in one sentence","Add every trending stock","Copy a friend's list","Pick by logo color"],"answer":"Only include companies you can explain in one sentence","explanation":"A watchlist should contain companies you understand."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Aturan watchlist yang baik adalah:","options":["Hanya masukkan perusahaan yang bisa dijelaskan dalam satu kalimat","Tambahkan setiap saham yang viral","Tiru daftar teman","Pilih dari warna logo"],"answer":"Hanya masukkan perusahaan yang bisa dijelaskan dalam satu kalimat","explanation":"Watchlist sebaiknya berisi perusahaan yang kamu pahami."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'building-your-first-watchlist'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"A watchlist is a list of stocks you plan to research, not a buy list.","answer":true,"explanation":"A watchlist is for tracking candidates, not automatic purchases."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Watchlist adalah daftar saham yang ingin diteliti, bukan daftar beli.","answer":true,"explanation":"Watchlist untuk memantau kandidat, bukan pembelian otomatis."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- the-5-minute-research-drill: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'the-5-minute-research-drill'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"The main goal of the 5-minute drill is to:","options":["Find reasons to say no","Find a stock to buy immediately","Memorize ratios","Join a signal group"],"answer":"Find reasons to say no","explanation":"The drill filters out weak ideas before you invest."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Tujuan utama drill 5 menit adalah:","options":["Menemukan alasan menolak","Menemukan saham untuk langsung beli","Menghafal rasio","Ikut grup sinyal"],"answer":"Menemukan alasan menolak","explanation":"Drill menyaring ide lemah sebelum berinvestasi."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'the-5-minute-research-drill'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"If you cannot explain why a company makes money in one sentence, you should skip it.","answer":true,"explanation":"Not understanding the business is a reason to pass."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Jika kamu tidak bisa menjelaskan mengapa perusahaan untung dalam satu kalimat, lewati saja.","answer":true,"explanation":"Tidak memahami bisnis adalah alasan untuk melewati."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

-- make-your-case: add 2 (total 5)
INSERT INTO public.content_variants (id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT * FROM (VALUES
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'make-your-case'), 'question', $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Which sentence is the invalidation rule?","options":["I will reconsider if MSME loan growth drops below 10%","I believe BBRI will keep growing","My evidence is 15% profit growth","BBRI is a bank"],"answer":"I will reconsider if MSME loan growth drops below 10%","explanation":"The invalidation rule states what would prove your thesis wrong."}$JSON$::jsonb, $JSON${"type":"multiple_choice","difficulty":"beginner","parameters":{},"question":"Kalimat mana yang merupakan aturan pembatalan?","options":["Saya akan meninjau ulang jika pertumbuhan kredit UMKM turun di bawah 10%","Saya percaya BBRI akan terus tumbuh","Bukti saya adalah laba tumbuh 15%","BBRI adalah bank"],"answer":"Saya akan meninjau ulang jika pertumbuhan kredit UMKM turun di bawah 10%","explanation":"Aturan pembatalan menyatakan apa yang akan membuktikan tesis salah."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE),
  (gen_random_uuid(), (SELECT id FROM public.lessons WHERE slug = 'make-your-case'), 'question', $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"A good investment thesis should include what would prove you wrong.","answer":true,"explanation":"Knowing what would invalidate your idea protects against bias."}$JSON$::jsonb, $JSON${"type":"true_false","difficulty":"beginner","parameters":{},"question":"Tesis investasi yang baik harus menyertakan apa yang bisa membuktikan kamu salah.","answer":true,"explanation":"Mengetahui apa yang membatalkan ide melindungi dari bias."}$JSON$::jsonb, 'beginner', 'know_before_investing', TRUE)
) AS v(id, lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants cv
  WHERE cv.lesson_id = v.lesson_id
    AND cv.variant_type = 'question'
    AND cv.body->>'question' = v.body->>'question'
);

COMMIT;
