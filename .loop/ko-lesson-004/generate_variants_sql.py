#!/usr/bin/env python3
"""Generate Indonesian content_variants body_id SQL for KO-LESSON-004."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
variants = json.loads((ROOT / "variants.json").read_text(encoding="utf-8"))

# Foundation 0 example translations keyed by original English text substring (first 80 chars normalized)
FOUNDATION_EXAMPLES = {
    "When Ani pays for her GoRide using GoPay": {
        "text": "Ketika Ani membayar GoRide pakai GoPay, ia menggunakan uang digital. Sopir menerimanya karena GoPay bisa dikonversi kembali ke rupiah. Bentuknya berubah, tapi itu tetap uang.",
    },
    "Budi wants to buy a Rp 15.000 notebook": {
        "text": "Budi ingin membeli buku catatan Rp 15.000. Ia tidak perlu menukar makan siangnya; ia menyerahkan uang Rp 20.000 dan menerima kembalian Rp 5.000. Penjual menerima rupiah karena semua orang setuju uang itu punya nilai.",
    },
    "In a remote village, people might trade 2 chickens": {
        "text": "Di desa terpencil, orang bisa menukar 2 ayam dengan satu karung beras. Itu barter, bukan uang. Uang membuat perdagangan lebih mudah karena semua orang menerima alat tukar yang sama.",
    },
    "In 2020, a plate of nasi padang near campus": {
        "text": "Pada 2020, sepiring nasi padang di dekat kampus harganya Rp 15.000. Pada 2025, sepiring yang sama harganya Rp 22.000. Makanannya tidak tambah besar; rupiahnya yang membeli lebih sedikit.",
    },
    "Last year, Rina could buy a large boba tea": {
        "text": "Tahun lalu, Rina bisa membeli boba tea besar seharga Rp 25.000. Tahun ini minuman yang sama harganya Rp 28.000. Rp 25.000-nya sekarang tidak cukup. Itulah inflasi yang memakan nilai uangnya.",
    },
    "If inflation is 5% per year, Rp 1.000.000 hidden under a mattress": {
        "text": "Jika inflasi 5% per tahun, Rp 1.000.000 yang disimpan di bawah kasur akan tetap terlihat Rp 1.000.000 dalam sepuluh tahun, tapi bisa membeli jauh lebih sedikit dari sekarang.",
    },
    "Nia borrows Rp 500.000 through a pay-later app": {
        "text": "Nia meminjam Rp 500.000 lewat aplikasi pay-later. Aplikasi itu mengenakan bunga 2% per bulan. Jika ia menunda pembayaran, utangnya menjadi Rp 510.000 setelah sebulan dan terus bertambah.",
    },
    "Andi saves Rp 1.000.000 in a deposit that pays 5% simple interest": {
        "text": "Andi menabung Rp 1.000.000 di deposito dengan bunga sederhana 5% per tahun. Setelah setahun ia punya Rp 1.050.000. Kalau bunga majemuk 5%, tahun berikutnya ia mendapat bunga dari Rp 1.050.000, bukan hanya dari pokok Rp 1.000.000.",
    },
    "Compound interest is like a snowball rolling downhill": {
        "text": "Bunga majemuk seperti bola salju yang menggelinding menuruni bukit. Bunga yang kamu dapat ditambahkan ke tabunganmu, lalu bunga di masa depan dihitung dari jumlah yang lebih besar.",
    },
    "Dina earns Rp 8.000.000 per month but spends Rp 8.000.000": {
        "text": "Dina bergaji Rp 8.000.000 per bulan tapi menghabiskan Rp 8.000.000 untuk sewa, makan, dan belanja. Pendapatannya tinggi tapi kekayaannya datar. Sari bergaji Rp 4.000.000 tapi menyisihkan Rp 800.000 setiap bulan. Lama-kelamaan kekayaan Sari tumbuh meski pendapatannya lebih rendah.",
    },
    "A famous celebrity might earn Rp 1 billion a year": {
        "text": "Selebriti terkenal bisa menghasilkan Rp 1 miliar per tahun tapi bangkrut jika pengeluarannya lebih besar dari pendapatannya. Seorang pemilik warung kecil mungkin penghasilannya Rp 3 juta per bulan tapi menjadi kaya karena rajin menabung dan berinvestasi.",
    },
    "A motorbike used for online food delivery generates income": {
        "text": "Motor yang dipakai untuk antar makanan online menghasilkan uang, jadi ia berperilaku seperti aset. Motor yang dibeli kredit hanya untuk jalan-jalan akhir pekan menghabiskan biaya bensin, perawatan, dan bunga, jadi ia lebih seperti liabilitas.",
    },
    "A laptop bought to play games and watch Netflix": {
        "text": "Laptop yang dibeli untuk main game dan nonton Netflix sebagian besar liabilitas karena terus menghabiskan uang listrik dan internet. Laptop yang sama untuk kerja desain lepas adalah aset karena membantu menghasilkan uang.",
    },
    "Bayu has Rp 5.000.000. Option A: keep it at home": {
        "text": "Bayu punya Rp 5.000.000. Pilihan A: simpan di rumah. Risiko: dicuri atau tergerus inflasi. Pilihan B: taruh di deposito. Risiko: return rendah mungkin kalah dari inflasi. Pilihan C: beli saham. Risiko: harga bisa turun. Setiap pilihan punya risiko berbeda.",
    },
    "Not investing also has risk": {
        "text": "Tidak berinvestasi juga punya risiko. Jika Lina menyimpan semua uangnya di tabungan dengan bunga 1% sementara inflasi 4%, ia kehilangan daya beli setiap tahun. Itu disebut risiko inflasi.",
    },
    "Doni buys a stock for Rp 10.000 per share": {
        "text": "Doni membeli saham seharga Rp 10.000 per lembar. Setahun kemudian harganya Rp 12.000. Jika ia menjual, keuntungan modalnya Rp 2.000 per lembar, return 20%. Tapi jika harga turun ke Rp 8.000, returnnya negatif 20%.",
    },
    "Citra buys a government bond for Rp 1.000.000": {
        "text": "Citra membeli obligasi pemerintah seharga Rp 1.000.000. Setelah setahun ia menerima bunga Rp 60.000 dan masih memiliki obligasinya. Returnnya Rp 60.000, atau 6%. Ia tidak perlu berdagang apa pun; returnnya berasal dari meminjamkan uangnya ke pemerintah.",
    },
    "Saving is like keeping an umbrella by the door": {
        "text": "Menabung seperti menyimpan payung di dekat pintu: kamu butuhnya siap saat hujan. Berinvestasi seperti menanam pohon: butuh waktu untuk tumbuh tapi bisa memberi naungan dan buah bertahun-tahun.",
    },
    "Eko has Rp 10.000.000. He keeps Rp 3.000.000 in a savings account": {
        "text": "Eko punya Rp 10.000.000. Ia menyimpan Rp 3.000.000 di rekening tabungan untuk darurat dan menginvestasikan Rp 7.000.000 dalam campuran obligasi dan saham untuk masa depan. Tabungan melindunginya hari ini; investasi bekerja untuknya besok.",
    },
    "Fani's motorbike breaks down and needs Rp 1.500.000": {
        "text": "Motor Fani rusak dan butuh Rp 1.500.000 untuk perbaikan. Karena ia punya dana darurat, ia membayar tanpa berhutang. Tanpanya, ia mungkin menggunakan aplikasi pay-later dan membayar biaya serta bunga tambahan.",
    },
    "A good emergency fund is like a spare tire": {
        "text": "Dana darurat yang baik seperti ban serep. Kamu berharap tidak perlu menggunakannya, tapi saat dibutuhkan, kamu sangat bersyukur memilikinya.",
    },
    "A basic phone to stay in touch with family": {
        "text": "Ponsel dasar untuk berhubungan dengan keluarga adalah kebutuhan. iPhone model terbaru adalah keinginan. Keduanya ponsel, tapi satu esensial dan satu lagi tambahan.",
    },
    "Hana has Rp 100.000 for the day": {
        "text": "Hana punya Rp 100.000 untuk hari ini. Makan siang Rp 20.000 adalah kebutuhan. Frappuccino Rp 45.000 adalah keinginan. Jika ia membeli frappuccino, uangnya tinggal sedikit untuk pulang. Melihat pertukaran ini membantunya memutuskan.",
    },
    "Irfan borrows Rp 2.000.000 from a pay-later app": {
        "text": "Irfan meminjam Rp 2.000.000 dari aplikasi pay-later untuk membeli sepatu baru. Bunganya 3% per bulan. Jika ia hanya membayar minimum, utangnya bisa tumbuh menjadi Rp 2.500.000 atau lebih. Sepatunya sekarang nilainya lebih rendah dari utangnya.",
    },
    "A student loan that helps you learn a high-demand skill": {
        "text": "Pinjaman pendidikan yang membantumu mempelajari keterampilan diminang bisa menjadi utang produktif jika penghasilanmu di masa depan cukup untuk melunasinya. Pinjaman untuk barang konsumtif biasanya hanya membebani.",
    },
    "A real OJK officer will never ask for your password": {
        "text": "Petugas OJK yang asli tidak akan pernah meminta password, OTP, atau meminta transfer uang ke rekening pribadi. Jika ada yang menekanmu untuk segera transfer atau memberi data rahasia, itu penipuan.",
    },
    "An Instagram account promises 15% profit every month": {
        "text": "Sebuah akun Instagram menjanjikan untung 15% setiap bulan, terjamin. Mereka menunjukkan screenshot keuntungan orang lain dan bilang 'slot terbatas.' Mereka memintamu transfer ke rekening pribadi. Setiap sinyal — return terjamin, urgensi, bukti sosial palsu, rekening pribadi — adalah tanda bahaya.",
    },
}


# Foundation 0 question translations keyed by original question text (first 80 chars normalized)
FOUNDATION_QUESTIONS = {
    "What does it mean when money is a \"unit of account\"": {
        "question": "Apa artinya ketika uang disebut 'satuan hitung'?",
        "options": ["Bisa disimpan di bawah kasur", "Memungkinkan kita membandingkan harga berbagai barang", "Dicetak oleh pemerintah", "Bisa dipakai di negara mana saja"],
        "answer": "Memungkinkan kita membandingkan harga berbagai barang",
        "explanation": "Satuan hitung berarti semua barang punya harga dalam mata uang yang sama, sehingga mudah dibandingkan.",
    },
    "Which role of money allows you to save Rp 100.000 today": {
        "question": "Fungsi uang mana yang memungkinkanmu menabung Rp 100.000 hari ini dan membelanjakannya bulan depan?",
        "options": ["Alat tukar", "Penyimpan nilai", "Satuan hitung", "Standar utang"],
        "answer": "Penyimpan nilai",
        "explanation": "Penyimpan nilai berarti uang mempertahankan daya beli dari waktu ke waktu sehingga bisa ditabung.",
    },
    "Money that everyone accepts as payment for goods and services": {
        "question": "Uang yang diterima semua orang sebagai pembayaran barang dan jasa disebut alat ____.",
        "answer": "tukar",
        "explanation": "Alat tukar adalah sesuatu yang diterima secara luas sebagai pembayaran barang dan jasa.",
    },
    "Which of these is the main reason money is useful": {
        "question": "Manakah alasan utama uang berguna?",
        "options": ["Terbuat dari emas", "Semua orang setuju bisa dipakai membeli barang", "Tidak pernah kehilangan nilai", "Hanya tersedia di bank"],
        "answer": "Semua orang setuju bisa dipakai membeli barang",
        "explanation": "Uang berfungsi karena orang percaya dan menerimanya sebagai pembayaran, bukan karena bahannya.",
    },
    "Digital money in an e-wallet is still money": {
        "question": "Uang digital di dompet elektronik tetap dianggap uang karena bisa dipakai membeli barang dan jasa.",
        "answer": True,
        "explanation": "Uang tidak harus tunai fisik. Saldo e-wallet dan rekening bank juga berfungsi sebagai uang.",
    },
    "Inflation means the same amount of money buys ____ over time": {
        "question": "Inflasi berarti jumlah uang yang sama bisa membeli ____ dari waktu ke waktu.",
        "answer": "lebih sedikit",
        "explanation": "Saat harga naik, daya beli uang menurun.",
    },
    "What does inflation do to the value of money": {
        "question": "Apa yang dilakukan inflasi terhadap nilai uang?",
        "options": ["Meningkatkannya", "Menurunkannya", "Tidak berpengaruh", "Menggandakannya setiap tahun"],
        "answer": "Menurunkannya",
        "explanation": "Inflasi berarti harga naik, sehingga uang yang sama bisa membeli lebih sedikit dari waktu ke waktu.",
    },
    "If inflation is 5%, a Rp 10.000 snack will likely cost less": {
        "question": "Jika inflasi 5%, camilan Rp 10.000 kemungkinan akan berharga kurang dari Rp 10.000 tahun depan.",
        "answer": False,
        "explanation": "Dengan inflasi, harga cenderung naik, jadi camilan kemungkinan akan lebih mahal, bukan lebih murah.",
    },
    "Why is keeping all your savings in cash under a mattress risky": {
        "question": "Mengapa menyimpan semua tabungan dalam bentuk tunai di bawah kasur berisiko saat inflasi?",
        "options": ["Uang tunai bisa dicuri", "Jumlah uang mengecil", "Daya beli uang tunai jatuh", "Bank tidak menerima uang lama"],
        "answer": "Daya beli uang tunai jatuh",
        "explanation": "Meski jumlah lembaran tetap sama, inflasi membuat setiap lembar membeli lebih sedikit.",
    },
    "A bowl of mie ayam cost Rp 12.000 last year and Rp 13.000": {
        "question": "Semangkuk mie ayam tahun lalu Rp 12.000, tahun ini Rp 13.000. Ini contoh apa?",
        "options": ["Deflasi", "Inflasi", "Bunga", "Investasi"],
        "answer": "Inflasi",
        "explanation": "Kenaikan harga umum dari waktu ke waktu disebut inflasi.",
    },
    "When you save, the bank pays you ____ for letting them use your money": {
        "question": "Saat kamu menabung, bank membayar kamu ____ karena meminjam uangmu.",
        "answer": "bunga",
        "explanation": "Bank membayar bunga kepada penabung dan mengenakan bunga kepada peminjam.",
    },
    "If you borrow money at 3% monthly interest, what happens if you only pay": {
        "question": "Jika kamu meminjam uang dengan bunga 3% per bulan, apa yang terjadi jika hanya membayar minimum setiap bulan?",
        "options": ["Utang lebih cepat hilang", "Total bunga yang dibayar biasanya jauh lebih besar", "Suku bunga turun", "Tidak apa-apa, bunga bulanan murah"],
        "answer": "Total bunga yang dibayar biasanya jauh lebih besar",
        "explanation": "Membayar hanya minimum memanjangkan utang dan membuat bunga majemuk bertambah besar.",
    },
    "With compound interest, you earn interest on both your original money": {
        "question": "Dengan bunga majemuk, kamu mendapat bunga dari pokok dan bunga yang sudah ditambahkan sebelumnya.",
        "answer": True,
        "explanation": "Bunga majemuk menghitung pertumbuhan dari total saldo, termasuk bunga yang sudah diperoleh.",
    },
    "What is interest": {
        "question": "Apa itu bunga?",
        "options": ["Denda karena menabung", "Harga menggunakan uang dari waktu ke waktu", "Pajak pemerintah atas pendapatan", "Jenis dividen saham"],
        "answer": "Harga menggunakan uang dari waktu ke waktu",
        "explanation": "Bunga adalah apa yang kamu dapat saat menabung atau bayar saat berhutang.",
    },
    "Which usually grows money faster over a long time": {
        "question": "Mana yang biasanya membuat uang tumbuh lebih cepat dalam jangka panjang?",
        "options": ["Bunga sederhana", "Bunga majemuk", "Tidak ada bunga", "Keduanya sama cepat"],
        "answer": "Bunga majemuk",
        "explanation": "Bunga majemuk mempercepat pertumbuhan karena menghasilkan bunga dari bunga.",
    },
    "What is the difference between income and wealth": {
        "question": "Apa perbedaan pendapatan dan kekayaan?",
        "options": ["Pendapatan adalah yang kamu miliki; kekayaan adalah yang kamu hasilkan", "Pendapatan adalah uang yang masuk; kekayaan adalah uang yang tersisa dan tumbuh", "Keduanya sama", "Kekayaan hanya untuk orang kaya"],
        "answer": "Pendapatan adalah uang yang masuk; kekayaan adalah uang yang tersisa dan tumbuh",
        "explanation": "Pendapatan adalah aliran uang dari waktu ke waktu. Kekayaan adalah stok aset yang terakumulasi dikurangi utang.",
    },
    "A person with a high income but high spending can have lower wealth": {
        "question": "Seseorang dengan pendapatan tinggi tapi pengeluaran tinggi bisa memiliki kekayaan lebih rendah dari orang dengan pendapatan sederhana yang rajin menabung.",
        "answer": True,
        "explanation": "Kekayaan tergantung seberapa banyak yang disimpan dan tumbuh, bukan hanya berapa yang dihasilkan.",
    },
    "Before buying something expensive, which question helps you decide": {
        "question": "Sebelum membeli barang mahal, pertanyaan apa yang membantumu memutuskan apakah itu aset atau liabilitas?",
        "options": ["Apakah ini lagi tren di media sosial?", "Barang ini akan membuatku menghasilkan atau mengeluarkan uang dari waktu ke waktu?", "Apakah warnanya favoritku?", "Apakah temanku sudah membelinya?"],
        "answer": "Barang ini akan membuatku menghasilkan atau mengeluarkan uang dari waktu ke waktu?",
        "explanation": "Tes utamanya adalah apakah barang memasukkan atau mengeluarkan uang dari waktu ke waktu.",
    },
    "In personal finance, what is an asset": {
        "question": "Dalam keuangan pribadi, apa itu aset?",
        "options": ["Sesuatu yang selalu menghabiskan uang", "Sesuatu yang memiliki atau menghasilkan nilai", "Hanya properti fisik", "Barang apa pun yang dibeli kredit"],
        "answer": "Sesuatu yang memiliki atau menghasilkan nilai",
        "explanation": "Aset adalah sesuatu yang menyimpan atau menghasilkan nilai bagimu.",
    },
    "The same item, like a laptop or motorbike, can be an asset for one person": {
        "question": "Barang yang sama, seperti laptop atau motor, bisa menjadi aset untuk satu orang dan liabilitas untuk orang lain tergantung cara penggunaannya.",
        "answer": True,
        "explanation": "Apakah sesuatu berperilaku seperti aset atau liabilitas tergantung apakah ia menghasilkan nilai atau menghabiskan uang bagimu.",
    },
    "Which statement about risk is true": {
        "question": "Manakah pernyataan yang benar tentang risiko?",
        "options": ["Semua risiko bisa dihilangkan", "Potensi return tinggi biasanya disertai risiko tinggi", "Risiko hanya ada di pasar saham", "Penabung tidak pernah menghadapi risiko"],
        "answer": "Potensi return tinggi biasanya disertai risiko tinggi",
        "explanation": "Risiko dan return biasanya terkait. Potensi untung besar cenderung datang dengan potensi rugi besar.",
    },
    "What is financial risk": {
        "question": "Apa itu risiko finansial?",
        "options": ["Jaminan untung", "Kemungkinan kehilangan uang atau return lebih rendah dari yang diharapkan", "Sesuatu yang hanya terjadi di saham", "Jenis biaya bank"],
        "answer": "Kemungkinan kehilangan uang atau return lebih rendah dari yang diharapkan",
        "explanation": "Risiko adalah kemungkinan hasil lebih buruk dari yang diharapkan.",
    },
    "Keeping all your money as cash under a mattress is completely risk-free": {
        "question": "Menyimpan semua uang tunai di bawah kasur sepenuhnya bebas risiko.",
        "answer": False,
        "explanation": "Uang tunai menghadapi risiko pencurian dan inflasi yang perlahan menggerus daya beli.",
    },
    "What kind of risk does a savings account with 1% interest face": {
        "question": "Risiko apa yang dihadapi rekening tabungan dengan bunga 1% ketika inflasi 4%?",
        "options": ["Risiko pencurian", "Risiko inflasi", "Tidak ada risiko", "Risiko kolaps mata uang"],
        "answer": "Risiko inflasi",
        "explanation": "Ketika inflasi lebih tinggi dari bunga tabungan, daya beli uangmu menurun dari waktu ke waktu.",
    },
    "Which is a warning sign that a promised return might be a scam": {
        "question": "Manakah tanda peringatan bahwa return yang dijanjikan mungkin penipuan?",
        "options": ["Lebih tinggi dari inflasi", "Dijanjikan tinggi, terjamin, dan tanpa risiko", "Dari deposito bank", "Dibayar bulanan"],
        "answer": "Dijanjikan tinggi, terjamin, dan tanpa risiko",
        "explanation": "Investasi nyata tidak bisa menjanjikan return tinggi tanpa risiko. Kombinasi itu adalah sinyal klasik penipuan.",
    },
    "What is return in finance": {
        "question": "Apa itu return dalam keuangan?",
        "options": ["Jumlah yang kamu investasikan", "Keuntungan atau kerugian atas uangmu", "Jenis rekening bank", "Pengembalian pajak pemerintah"],
        "answer": "Keuntungan atau kerugian atas uangmu",
        "explanation": "Return mengukur seberapa banyak uang yang dihasilkan atau hilang relatif terhadap modal.",
    },
    "A higher potential return usually means a lower risk": {
        "question": "Potensi return yang lebih tinggi biasanya berarti risiko lebih rendah.",
        "answer": False,
        "explanation": "Potensi return tinggi biasanya terkait dengan risiko tinggi.",
    },
    "If you invest Rp 1.000.000 and later have Rp 1.100.000": {
        "question": "Jika kamu menginvestasikan Rp 1.000.000 dan kemudian memiliki Rp 1.100.000, returnmu Rp 100.000 atau ____.",
        "answer": "10%",
        "explanation": "Return sering dinyatakan sebagai persentase dari jumlah awal.",
    },
    "Which goal is best matched with investing rather than saving": {
        "question": "Tujuan mana yang paling cocok untuk berinvestasi daripada menabung?",
        "options": ["Sewa bulan depan", "Dana darurat", "Ganti ponsel dalam 6 bulan", "Dana kuliah dalam 10 tahun"],
        "answer": "Dana kuliah dalam 10 tahun",
        "explanation": "Investasi untuk tujuan jangka panjang; menabung untuk kebutuhan jangka pendek dan darurat.",
    },
    "What is an emergency fund for": {
        "question": "Dana darurat untuk apa?",
        "options": ["Membeli gadget terbaru", "Pengeluaran tak terduga seperti perbaikan atau tagihan medis", "Berinvestasi di saham", "Membayar liburan yang direncanakan"],
        "answer": "Pengeluaran tak terduga seperti perbaikan atau tagihan medis",
        "explanation": "Dana darurat untuk kebutuhan mendesak, bukan keinginan atau investasi.",
    },
    "Match each item with whether it is usually a need or a want": {
        "question": "Pasangkan setiap item dengan apakah itu biasanya kebutuhan atau keinginan.",
        "answer": {"Makanan pokok": "Kebutuhan", "Sepatu desainer": "Keinginan", "Konsol game terbaru": "Keinginan", "Sewa tempat tinggal": "Kebutuhan"},
        "explanation": "Kebutuhan adalah esensial untuk hidup; keinginan menyenangkan tapi tidak wajib.",
    },
    "Paying only the minimum on a high-interest debt is a good long-term strategy": {
        "question": "Membayar hanya minimum dari utang berbunga tinggi adalah strategi jangka panjang yang baik.",
        "answer": False,
        "explanation": "Pembayaran minimum memanjangkan utang dan membuat total bunga menjadi besar.",
    },
    "Which is a major scam red flag": {
        "question": "Manakah tanda bahaya penipuan utama?",
        "options": ["Investasi terdaftar di OJK", "Return tinggi terjamin tanpa risiko", "Bisa menarik uang kapan saja", "Perusahaan memiliki kantor nyata"],
        "answer": "Return tinggi terjamin tanpa risiko",
        "explanation": "Return tinggi terjamin tanpa risiko adalah tanda utama penipuan investasi.",
    },
}


def normalize_key(text):
    if not text:
        return ""
    return re.sub(r"\s+", " ", text.strip())[:80].lower()


def find_foundation_example(text):
    norm = normalize_key(text)
    for key, trans in FOUNDATION_EXAMPLES.items():
        if normalize_key(key) in norm or norm in normalize_key(key):
            return trans
    return None


def find_foundation_question(question):
    norm = normalize_key(question)
    for key, trans in FOUNDATION_QUESTIONS.items():
        if normalize_key(key) in norm or norm in normalize_key(key):
            return trans
    return None


# Generic term dictionary for advanced / 101 variants
TERM_MAP = {
    "what is": "apa itu",
    "which of the following": "manakah di antara berikut",
    "which of these": "manakah di antara ini",
    "which statement": "manakah pernyataan",
    "what does": "apa yang",
    "why is": "mengapa",
    "how does": "bagaimana",
    "true or false": "benar atau salah",
    "true_false": "true_false",
    "multiple_choice": "multiple_choice",
    "fill_blank": "fill_blank",
    "matching": "matching",
    "case_study": "case_study",
    "beginner": "beginner",
    "intermediate": "intermediate",
    "advanced": "advanced",
    "income": "pendapatan",
    "wealth": "kekayaan",
    "asset": "aset",
    "liability": "liabilitas",
    "liabilities": "liabilitas",
    "risk": "risiko",
    "return": "return",
    "interest": "bunga",
    "inflation": "inflasi",
    "saving": "menabung",
    "investing": "berinvestasi",
    "investment": "investasi",
    "budget": "anggaran",
    "budgeting": "anggaran",
    "emergency fund": "dana darurat",
    "debt": "utang",
    "scam": "penipuan",
    "fraud": "penipuan",
    "OJK": "OJK",
    "IDX": "IDX",
    "stock": "saham",
    "stocks": "saham",
    "bond": "obligasi",
    "bonds": "obligasi",
    "mutual fund": "reksa dana",
    "reksa dana": "reksa dana",
    "diversification": "diversifikasi",
    "portfolio": "portofolio",
    "tax": "pajak",
    "taxes": "pajak",
    "compound interest": "bunga majemuk",
    "simple interest": "bunga sederhana",
    "purchasing power": "daya beli",
    "needs": "kebutuhan",
    "wants": "keinginan",
    "FOMO": "FOMO",
    "loss aversion": "aversi rugi",
    "behavioral bias": "bias perilaku",
    "macro indicator": "indikator makro",
    "financial plan": "rencana keuangan",
    "goal": "tujuan",
    "spending trap": "jebakan pengeluaran",
    "pay yourself first": "bayar diri sendiri dulu",
    "too good to be true": "terlalu bagus untuk jadi kenyataan",
    "pyramid scheme": "skema piramida",
    "MLM": "MLM",
    "phishing": "phishing",
    "social engineering": "social engineering",
    "capital gain": "keuntungan modal",
    "market cap": "kapitalisasi pasar",
    "P/E ratio": "rasio P/E",
    "EPS": "EPS",
    "ROE": "ROE",
    " Sharpe ratio": "rasio Sharpe",
    "beta": "beta",
    "alpha": "alpha",
    "dollar cost averaging": "dollar cost averaging",
    "lump sum": "lump sum",
    "rebalancing": "rebalancing",
    "bull market": "pasar bullish",
    "bear market": "pasar bearish",
    "correction": "koreksi",
    "crash": "crash",
    "drawdown": "drawdown",
    "liquidity": "likuiditas",
    "volatility": "volatilitas",
    "nominal": "nominal",
    "real": "riil",
    "option": "pilihan",
    "options": "pilihan",
    "answer": "jawaban",
    "question": "pertanyaan",
    "explanation": "penjelasan",
    "correct": "benar",
    "incorrect": "salah",
    "always": "selalu",
    "never": "tidak pernah",
    "usually": "biasanya",
    "sometimes": "kadang-kadang",
    "often": "sering",
    "all": "semua",
    "none": "tidak ada",
    "only": "hanya",
    "also": "juga",
    "because": "karena",
    "therefore": "oleh karena itu",
    "however": "namun",
    "for example": "misalnya",
    "such as": "seperti",
    "including": "termasuk",
    "compared to": "dibandingkan dengan",
    "rather than": "daripada",
    "instead of": "alih-alih",
}


PHRASE_MAP = {
    "is called": "disebut",
    "is known as": "dikenal sebagai",
    "is defined as": "didefinisikan sebagai",
    "is an example of": "adalah contoh dari",
    "is a type of": "adalah jenis",
    "is the best": "yang terbaik",
    "is the first": "yang pertama",
    "is the main": "utama",
    "is most relevant": "paling relevan",
    "is most likely": "paling mungkin",
    "is not associated": "tidak terkait",
    "is not related": "tidak terkait",
    "is not true": "tidak benar",
    "is not correct": "tidak benar",
    "is incorrect": "salah",
    "is correct": "benar",
    "is true": "benar",
    "is false": "salah",
    "what should you do": "apa yang harus kamu lakukan",
    "what is the first step": "apa langkah pertama",
    "what is the best": "apa yang terbaik",
    "what is the main reason": "apa alasan utama",
    "what is the likely outcome": "apa hasil yang mungkin",
    "what is the difference": "apa perbedaan",
    "what happens": "apa yang terjadi",
    "how much": "berapa banyak",
    "how long": "berapa lama",
    "how often": "berapa sering",
    "in Indonesian financial context": "dalam konteks keuangan Indonesia",
    "in Indonesia": "di Indonesia",
    "in the long run": "dalam jangka panjang",
    "in the short term": "dalam jangka pendek",
    "over time": "dari waktu ke waktu",
    "per year": "per tahun",
    "per month": "per bulan",
    "per day": "per hari",
    "annually": "per tahun",
    "monthly": "per bulan",
    "daily": "per hari",
    "guaranteed profit": "keuntungan terjamin",
    "possible loss of capital": "kemungkinan kehilangan modal",
    "tax exemption": "pembebasan pajak",
    "free insurance": "asuransi gratis",
    "buying lottery tickets": "membeli tiket lotre",
    "check OJK license": "periksa izin OJK",
    "invest immediately": "investasi segera",
    "ask friends for advice": "minta saran teman",
    "ignore and move on": "abaikan dan lanjutkan",
    "a way to lose money": "cara kehilangan uang",
    "a fundamental financial concept": "konsep keuangan fundamental",
    "a type of bank account": "jenis rekening bank",
    "a government regulation": "regulasi pemerintah",
    "short-term traders only": "hanya trader jangka pendek",
    "long-term investors": "investor jangka panjang",
    "everyone managing money": "semua orang yang mengelola uang",
    "only bank employees": "hanya karyawan bank",
    "in this scenario": "dalam skenario ini",
    "represents the most balanced and informed approach": "adalah pendekatan paling seimbang dan berinformasi",
    "approach to financial decision-making": "dalam pengambilan keputusan keuangan",
    "what would a financially literate person do": "apa yang akan dilakukan orang yang melek keuangan",
    "which choice minimizes risk while preserving opportunity": "pilihan mana yang meminimalkan risiko sambil menjaga peluang",
    "read the following statement and identify": "baca pernyataan berikut dan identifikasi",
    "the financial mistakes": "kesalahan keuangan",
    "order the steps": "urutkan langkah-langkah",
    "the correct order is": "urutan yang benar adalah",
    "the correct words from the bank are": "kata yang benar dari bank kata adalah",
    "without tracking and budgeting": "tanpa pencatatan dan anggaran",
    "spending easily exceeds income": "pengeluaran mudah melebihi pendapatan",
    "without awareness": "tanpa disadari",
    "time in the market": "waktu di pasar",
    "consistent contributions": "kontribusi konsisten",
    "matter far more than": "jauh lebih penting daripada",
    "stock picking": "memilih saham",
    "market timing": "menentukan waktu pasar",
    "insider information": "informasi orang dalam",
    "is expected to move": "diharapkan bergerak",
    "than the overall market": "daripada pasar secara keseluruhan",
    "the most important factor": "faktor paling penting",
    "building wealth through investing": "membangun kekayaan melalui investasi",
    "starting early and staying consistent": "memulai lebih awal dan konsisten",
    "picking the best stocks": "memilih saham terbaik",
    "timing the market perfectly": "menentukan waktu pasar dengan sempurna",
    "having insider information": "memiliki informasi orang dalam",
    "invest all at once": "investasi sekaligus",
    "invest gradually over time": "investasi bertahap dari waktu ke waktu",
    "wait for perfect timing": "tunggu waktu yang sempurna",
    "never invest": "jangan pernah berinvestasi",
    "to start investing in indonesian stocks": "untuk mulai berinvestasi di saham indonesia",
    "to protect savings from inflation": "untuk melindungi tabungan dari inflasi",
    "what is the approximate": "berapakah perkiraan",
    "what is": "apa",
    "a new e-wallet offers": "dompet digital baru menawarkan",
    "cashback for the first month": "cashback untuk bulan pertama",
    "model the customer acquisition cost and churn risk": "modelkan biaya akuisisi pelanggan dan risiko churn",
    "a fintech gamifies spending with cashback rewards": "sebuah fintech menggamifikasi pengeluaran dengan reward cashback",
    "users overspend by 30%": "pengguna membelanjakan 30% lebih banyak",
    "analyze the behavioral mechanism": "analisis mekanisme perilakunya",
    "which choice minimizes risk while preserving opportunity": "pilihan mana yang meminimalkan risiko sambil menjaga peluang",
    "to financial decision-making": "dalam pengambilan keputusan keuangan",
    "if rp 100m grows to rp 150m in 5 years": "jika rp 100 juta tumbuh menjadi rp 150 juta dalam 5 tahun",
    "annual compound growth rate": "tingkat pertumbuhan tahunan majemuk",
    "use the cagr formula": "gunakan rumus cagr",
    "divide stock price by earnings per share": "bagi harga saham dengan laba per saham",
    "open brokerage account": "buka rekening sekuritas",
    "complete kyc process": "lengkapi proses kyc",
    "deposit funds": "setor dana",
    "research stocks": "riset saham",
    "place first order": "tempatkan order pertama",
    "understand inflation rate": "pahami tingkat inflasi",
    "check savings interest rate": "periksa suku bunga tabungan",
    "calculate real return": "hitung return riil",
    "consider alternatives": "pertimbangkan alternatif",
    "adjust savings strategy": "sesuaikan strategi menabung",
    "no budgeting system": "tidak ada sistem anggaran",
    "fragmented spending across platforms": "pengeluaran terpecah di banyak platform",
    "no expense tracking": "tidak ada pencatatan pengeluaran",
    "relies on checking balance reactively": "bergantung pada pengecekan saldo secara reaktif",
    "there are no mistakes": "tidak ada kesalahan",
    "only one minor mistake": "hanya satu kesalahan kecil",
}


def translate_text(text):
    """Simple dictionary-based translation for generic/advanced text."""
    if not isinstance(text, str) or not text.strip():
        return text
    # Don't translate strings that are already mostly Indonesian
    if is_indonesian(text):
        return text
    translated = text
    # Phrase-level replacements first
    for en, id_ in sorted(PHRASE_MAP.items(), key=lambda x: -len(x[0])):
        translated = re.sub(r"(?i)\b" + re.escape(en) + r"\b", id_, translated)
    # Term-level replacements
    for en, id_ in sorted(TERM_MAP.items(), key=lambda x: -len(x[0])):
        translated = re.sub(r"(?i)\b" + re.escape(en) + r"\b", id_, translated)
    # Sentence-level cleanup for common patterns
    return translated


def is_indonesian(text):
    if not isinstance(text, str):
        return False
    markers = [" yang ", " dan ", " atau ", " untuk ", " dengan ", " dari ", " pada ", " adalah ", " ini ", " itu ", " kamu ", " anda ", " kita ", " mereka ", " karena ", " tetapi " ]
    return any(m in text.lower() for m in markers)


def is_english(text):
    if not text or not isinstance(text, str):
        return False
    # Fast path: common English function words (allow word-boundary matches)
    words = re.findall(r"[a-z]+", text.lower())
    if not words:
        return False
    english_words = {
        "the", "is", "are", "and", "or", "that", "this", "with", "for", "you", "your", "what", "which",
        "how", "why", "when", "all", "any", "can", "do", "does", "did", "will", "would", "should", "could",
        "may", "might", "must", "have", "has", "had", "been", "was", "were", "be", "being", "about", "above",
        "after", "again", "against", "into", "through", "during", "before", "below", "between", "both", "each",
        "few", "more", "most", "other", "some", "such", "not", "only", "own", "same", "than", "too", "very",
        "just", "but", "if", "because", "until", "while", "from", "over", "under", "invest", "investing",
        "stock", "market", "money", "financial", "savings", "income", "risk", "spending", "account", "balance",
        "complete", "process", "research", "order", "understand", "calculate", "consider", "adjust", "follow",
    }
    if any(w in english_words for w in words):
        return True
    # If mostly Latin letters and not Indonesian, try translating
    latin_ratio = sum(1 for c in text if c.isalpha() and c.isascii()) / max(len(text), 1)
    return latin_ratio > 0.8 and not is_indonesian(text)


def translate_value(value, in_options=False):
    """Translate a JSON value while preserving structure."""
    if isinstance(value, bool):
        return value
    if isinstance(value, (int, float)):
        return value
    if value is None:
        return None
    if isinstance(value, str):
        # Preserve template expressions like {{amount * rate / 100}}
        if "{{" in value or "}}" in value:
            return translate_template(value)
        # Don't translate if already Indonesian
        if is_indonesian(value):
            return value
        if not is_english(value):
            return value
        return translate_text(value)
    if isinstance(value, list):
        return [translate_value(v, in_options=True) for v in value]
    if isinstance(value, dict):
        out = {}
        for k, v in value.items():
            if k in ("parameters", "difficulty", "type", "source_ids"):
                out[k] = v
            elif k == "answer":
                out[k] = translate_answer(v)
            elif k in ("pairs",):
                out[k] = [translate_value(pair, in_options=True) for pair in v]
            elif k in ("followUp", "follow_up"):
                out[k] = translate_value(v)
            elif k in ("caseText", "case_text"):
                out[k] = translate_value(v)
            else:
                out[k] = translate_value(v, in_options=(k in ("options", "definitions", "terms")))
        return out
    return value


def translate_template(text):
    """Translate text containing {{...}} placeholders, preserving expressions."""
    parts = re.split(r"(\{\{.*?\}\})", text)
    out = []
    for part in parts:
        if part.startswith("{{") and part.endswith("}}"):
            out.append(part)
        else:
            out.append(translate_text(part))
    return "".join(out)


def translate_answer(answer):
    """Translate answer values while preserving matching semantics."""
    if isinstance(answer, bool):
        return answer
    if isinstance(answer, (int, float)):
        return answer
    if isinstance(answer, list):
        return [translate_value(a) for a in answer]
    if isinstance(answer, dict):
        return {translate_value(k): translate_value(v) for k, v in answer.items()}
    if isinstance(answer, str):
        # Try to match against common option translations
        return translate_value(answer)
    return answer


def translate_body(body, lesson_number, variant_type):
    """Translate a variant body to Indonesian."""
    if not isinstance(body, dict):
        return body

    # Foundation 0 direct translations
    if lesson_number <= 12:
        if variant_type == "example" and "text" in body:
            trans = find_foundation_example(body["text"])
            if trans:
                new_body = dict(body)
                new_body.update(trans)
                return new_body
        elif variant_type == "question" and "question" in body:
            trans = find_foundation_question(body["question"])
            if trans:
                new_body = dict(body)
                new_body.update(trans)
                # Preserve type and difficulty
                new_body["type"] = body.get("type")
                new_body["difficulty"] = body.get("difficulty")
                new_body["parameters"] = body.get("parameters", {})
                return new_body

    # Generic translation
    return translate_value(body)


def escape_sql_json(value):
    dumped = json.dumps(value, ensure_ascii=False)
    return "'" + dumped.replace("'", "''") + "'::jsonb"


def main():
    statements = []
    translated_count = 0
    copied_count = 0
    skipped = []

    for v in variants:
        body = v.get("body")
        if not isinstance(body, dict):
            skipped.append((v["id"], "non-dict body"))
            continue

        lesson_number = v["lesson_number"]
        variant_type = v["variant_type"]

        # Determine if body is already Indonesian
        sample = body.get("text") or body.get("question") or ""
        if is_indonesian(sample) and not is_english(sample):
            body_id = body
            copied_count += 1
        else:
            body_id = translate_body(body, lesson_number, variant_type)
            translated_count += 1

        statements.append(
            f"UPDATE public.content_variants\nSET body_id = {escape_sql_json(body_id)}\nWHERE id = '{v['id']}'::uuid;\n"
        )

    header = (
        "-- KO-LESSON-004: Indonesian body_id for all active content_variants\n"
        "-- DO NOT execute directly; review and apply via Conductor.\n\n"
    )
    sql = header + "\n".join(statements)
    (ROOT / "translations" / "variants-indonesian.sql").write_text(sql, encoding="utf-8")
    print(f"Wrote {len(statements)} variant update statements.")
    print(f"  Translated: {translated_count}")
    print(f"  Copied existing Indonesian: {copied_count}")
    if skipped:
        print(f"  Skipped: {len(skipped)}")
        for sid, reason in skipped[:5]:
            print(f"    {sid}: {reason}")


if __name__ == "__main__":
    main()
