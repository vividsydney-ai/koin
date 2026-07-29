-- KO-225 group 4: fill lesson-level gaps that had no source copy at all.
-- Quiz payloads reuse the first active bilingual question variant so the
-- lesson-level fallback stays aligned with the content-variant pool.

update public.lessons as l
set quiz_data = cv.body,
    quiz_data_id = cv.body_id
from (
  select distinct on (lesson_id) lesson_id, body, body_id
  from public.content_variants
  where is_active = true and variant_type = 'question' and body_id is not null
  order by lesson_id, created_at asc nulls last, id
) as cv
where l.id = cv.lesson_id
  and l.is_published = true
  and l.quiz_data is null;

update public.lessons set
  why_this_matters = 'ETFs combine diversification with the flexibility of stock trading, making them a practical way to spread investment risk.',
  why_this_matters_id = 'ETF menggabungkan diversifikasi dengan fleksibilitas perdagangan saham, sehingga menjadi cara praktis untuk menyebarkan risiko investasi.',
  common_mistake = 'Assuming every ETF is automatically safe. Check its holdings, fees, tracking method, and risk before investing.',
  common_mistake_id = 'Menganggap semua ETF otomatis aman. Periksa isi, biaya, cara pelacakan indeks, dan risikonya sebelum berinvestasi.'
where id = '099d1a27-84b4-49d4-89db-57efa4257f36';

update public.lessons set
  why_this_matters = 'Gold can diversify a portfolio and help preserve value, but it does not replace an emergency fund or a balanced investment plan.',
  why_this_matters_id = 'Emas dapat membantu diversifikasi dan menjaga nilai, tetapi bukan pengganti dana darurat atau rencana investasi yang seimbang.',
  common_mistake = 'Treating gold as a guaranteed profit. Gold prices can fall, and buying or storing physical gold has costs.',
  common_mistake_id = 'Menganggap emas pasti menghasilkan keuntungan. Harga emas bisa turun, dan emas fisik memiliki biaya pembelian serta penyimpanan.'
where id = 'a72b0aa4-c2dc-4d02-bb1b-b8e9f4ec2800';

update public.lessons set
  why_this_matters = 'Choosing the right account helps you keep money accessible, earn appropriate returns, and understand fees and deposit protection.',
  why_this_matters_id = 'Memilih rekening yang tepat membantu uang tetap mudah diakses, memberi imbal hasil yang sesuai, dan membuat kita memahami biaya serta perlindungan simpanan.',
  common_mistake = 'Choosing an account only because of a promotional rate without checking fees, withdrawal rules, or LPS coverage.',
  common_mistake_id = 'Memilih rekening hanya karena bunga promosi tanpa memeriksa biaya, aturan penarikan, atau perlindungan LPS.'
where id = 'ed8e0623-8896-4031-accd-c3ccdadb1d27';

update public.lessons set
  why_this_matters = 'Using both fundamental and technical analysis helps investors separate business quality from short-term price movement.',
  why_this_matters_id = 'Menggunakan analisis fundamental dan teknikal membantu investor membedakan kualitas bisnis dari pergerakan harga jangka pendek.',
  common_mistake = 'Using a chart pattern as a guarantee or ignoring a company’s financial health because the price is moving up.',
  common_mistake_id = 'Menganggap pola grafik sebagai jaminan atau mengabaikan kesehatan keuangan perusahaan karena harganya sedang naik.'
where id = '2073bd18-f24b-4c42-9cc6-234221100d81';

update public.lessons set
  why_this_matters = 'Digital payments are convenient, but simple security habits protect your money and personal information.',
  why_this_matters_id = 'Pembayaran digital memang praktis, tetapi kebiasaan keamanan sederhana melindungi uang dan informasi pribadi kita.',
  common_mistake = 'Sharing a PIN or OTP, scanning an unknown QR code, or ignoring fees because a payment feels instant.',
  common_mistake_id = 'Membagikan PIN atau OTP, memindai QR yang tidak dikenal, atau mengabaikan biaya karena pembayaran terasa instan.'
where id = '8a50d47e-2897-4d3c-9b79-bee800faf406';

update public.lessons set
  why_this_matters = 'Debt consolidation can simplify repayments and reduce interest, but only when the new loan truly costs less and spending is controlled.',
  why_this_matters_id = 'Konsolidasi utang dapat menyederhanakan pembayaran dan mengurangi bunga, tetapi hanya jika pinjaman baru memang lebih murah dan pengeluaran terkendali.',
  common_mistake = 'Consolidating debt, then taking on new debt without changing the spending pattern that caused the problem.',
  common_mistake_id = 'Menggabungkan utang lalu mengambil utang baru tanpa mengubah pola pengeluaran yang menyebabkan masalah.'
where id = '856eff8d-81f0-4003-8f04-8ffe72b765fc';

update public.lessons set
  why_this_matters = 'Government bonds can provide a relatively stable income while helping investors understand how risk, maturity, and liquidity work.',
  why_this_matters_id = 'Obligasi pemerintah dapat memberi pendapatan yang relatif stabil sekaligus membantu memahami risiko, jatuh tempo, dan likuiditas.',
  common_mistake = 'Calling government bonds risk-free. They still have interest-rate, liquidity, and inflation risks.',
  common_mistake_id = 'Menganggap obligasi pemerintah bebas risiko. Tetap ada risiko suku bunga, likuiditas, dan inflasi.'
where id = '63da429c-f0a4-4223-b18d-9b8bb04a8dbc';

update public.lessons set
  why_this_matters = 'Understanding Indonesian tax basics helps you keep accurate records, avoid surprises, and meet your obligations.',
  why_this_matters_id = 'Memahami dasar pajak Indonesia membantu mencatat dengan rapi, menghindari kejutan, dan memenuhi kewajiban.',
  common_mistake = 'Assuming students or freelancers never need to report income. Check the current rules for your situation.',
  common_mistake_id = 'Menganggap mahasiswa atau pekerja lepas tidak pernah perlu melaporkan penghasilan. Periksa aturan yang berlaku untuk situasimu.'
where id = '760220b7-71a4-4fc9-bff5-9151dc17fc62';

update public.lessons set
  why_this_matters = 'Tracking net worth turns financial progress into something visible and helps you make better decisions over time.',
  why_this_matters_id = 'Melacak kekayaan bersih membuat kemajuan keuangan terlihat dan membantu mengambil keputusan yang lebih baik dari waktu ke waktu.',
  common_mistake = 'Counting only assets and forgetting debts, or comparing your net worth with someone at a different life stage.',
  common_mistake_id = 'Hanya menghitung aset dan melupakan utang, atau membandingkan kekayaan bersih dengan orang yang berada di tahap hidup berbeda.'
where id = 'a068e5b8-e53f-4f28-b52c-e218cdf258ac';

update public.lessons set
  why_this_matters = 'Knowing how BPJS and private insurance differ helps you protect health, income, and family finances without paying for cover you do not need.',
  why_this_matters_id = 'Memahami perbedaan BPJS dan asuransi swasta membantu melindungi kesehatan, penghasilan, dan keuangan keluarga tanpa membayar perlindungan yang tidak diperlukan.',
  common_mistake = 'Buying a policy without checking exclusions, limits, waiting periods, and whether the premium fits the budget.',
  common_mistake_id = 'Membeli polis tanpa memeriksa pengecualian, batas manfaat, masa tunggu, dan kesesuaian premi dengan anggaran.'
where id = '19e843cd-1958-4688-87b7-2b82fb6f17d2';

update public.lessons set
  why_this_matters = 'Starting retirement contributions early gives compound growth more time to work and reduces the pressure to save large amounts later.',
  why_this_matters_id = 'Memulai kontribusi pensiun lebih awal memberi waktu lebih panjang bagi pertumbuhan majemuk dan mengurangi tekanan untuk menabung besar nanti.',
  common_mistake = 'Waiting until retirement feels close, or assuming a pension account alone will cover every future need.',
  common_mistake_id = 'Menunggu sampai pensiun terasa dekat, atau menganggap satu rekening pensiun saja akan mencukupi semua kebutuhan nanti.'
where id = 'e579a631-fbae-4514-9b2c-5cf4be5a3a40';

update public.lessons set
  why_this_matters = 'An RDN keeps investment cash separate and gives you the account structure needed to buy stocks and ETFs on IDX.',
  why_this_matters_id = 'RDN memisahkan uang investasi dan memberi struktur rekening yang diperlukan untuk membeli saham serta ETF di IDX.',
  common_mistake = 'Choosing a broker only because of a low fee without checking licensing, platform reliability, and customer support.',
  common_mistake_id = 'Memilih sekuritas hanya karena biaya rendah tanpa memeriksa izin, keandalan platform, dan dukungan nasabah.'
where id = '9188ad0c-7111-4b45-8955-fac3a39cedd6';

update public.lessons set
  why_this_matters = 'Sharia investments give learners another framework for thinking about ownership, interest, uncertainty, and responsible investing.',
  why_this_matters_id = 'Investasi syariah memberi kerangka lain untuk memahami kepemilikan, bunga, ketidakpastian, dan investasi yang bertanggung jawab.',
  common_mistake = 'Assuming a product is automatically Sharia-compliant without checking its prospectus, screening method, and fees.',
  common_mistake_id = 'Menganggap produk otomatis sesuai syariah tanpa memeriksa prospektus, metode penyaringan, dan biayanya.'
where id = 'c59d0f4c-172b-4cf7-8f12-f291daa6deab';
