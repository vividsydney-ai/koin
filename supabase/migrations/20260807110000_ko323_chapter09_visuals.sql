-- KO-323: Chapter 09 — Cryptocurrency 101 visual lesson rollout.
--
-- Adds bilingual visual blocks, visual_applied checks, private five-day recall
-- prompts, and reviewed OJK/BI/Bappebti sources for the four published
-- Chapter 09 lessons. All values are illustrative teaching examples or
-- sourced from official regulator pages; no live quote, return promise, or
-- platform recommendation is implied.

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Primary source register
-- ---------------------------------------------------------------------------
INSERT INTO public.sources (
  source_code,
  title,
  local_title,
  source_tier,
  source_type,
  organization,
  url,
  language,
  last_checked_at,
  status,
  trust_notes,
  localization_notes,
  synopsis,
  synopsis_id,
  relevance_blurb,
  relevance_blurb_id
)
VALUES
  (
    'CH09-OJK-CRYPTO',
    'OJK digital financial asset and crypto asset licensing',
    'Perizinan aset keuangan digital dan aset kripto OJK',
    1,
    'website',
    'OJK',
    'https://ojk.go.id/en/fungsi-utama/itsk/perizinan-itsk-aset-keuangan-digital-aset-kripto/default.aspx',
    'en',
    '2026-08-07',
    'verified',
    'Primary regulator page for digital financial asset trading licensing in Indonesia under POJK 27/2024 as amended by POJK 23/2025.',
    'Indonesian equivalent path uses /id/ prefix.',
    'OJK now supervises digital financial asset trading, including crypto assets, under POJK 27/2024 as amended by POJK 23/2025. The page explains licensing requirements for platforms and reminds investors to use registered providers.',
    'OJK kini mengawasi perdagangan aset keuangan digital termasuk aset kripto berdasarkan POJK 27/2024 yang diubah dengan POJK 23/2025. Halaman ini menjelaskan persyaratan perizinan bagi platform dan mengingatkan investor untuk menggunakan penyedia terdaftar.',
    'Use to verify that a crypto platform is subject to current Indonesian regulator licensing.',
    'Gunakan untuk memverifikasi bahwa platform kripto tunduk pada perizinan regulator Indonesia terkini.'
  ),
  (
    'CH09-BAPPEBTI-LICENSE',
    'Bappebti licence check for futures and crypto physical market participants',
    'Cek legalitas Bappebti untuk pelaku berjangka dan pasar fisik aset kripto',
    1,
    'website',
    'Bappebti',
    'https://ceklegalitas.bappebti.go.id/',
    'id',
    '2026-08-07',
    'verified',
    'Official Bappebti directory for checking registered or licensed commodity futures and crypto physical market participants.',
    'Indonesian-language page; the searchable directory is the authoritative source.',
    'The official Bappebti directory lets you check whether a futures, commodity, or crypto physical market participant is registered or licensed. It also lists tradable crypto assets.',
    'Direktori resmi Bappebti memungkinkan Anda memeriksa apakah pelaku perdagangan berjangka komoditi atau pasar fisik aset kripto terdaftar atau berizin. Direktori ini juga mencantumkan aset kripto yang dapat diperdagangkan.',
    'Use to verify the registration status of a crypto exchange or trader before depositing money.',
    'Gunakan untuk memverifikasi status pendaftaran bursa atau pedagang kripto sebelum menyetor uang.'
  ),
  (
    'CH09-BI-CRYPTO-PAYMENT',
    'Bank Indonesia statement on virtual currencies as payment instruments',
    'Pernyataan Bank Indonesia tentang mata uang virtual sebagai alat pembayaran',
    1,
    'news_release',
    'Bank Indonesia',
    'https://www.bi.go.id/id/publikasi/ruang-media/news-release/Pages/sp_200418.aspx',
    'id',
    '2026-08-07',
    'verified',
    'Official BI news release stating virtual currencies are not recognized as legitimate payment instruments.',
    'Indonesian news release; the principle remains authoritative for explaining that crypto is not official money.',
    'Bank Indonesia clarifies that virtual currencies, including Bitcoin, are not recognized as legitimate payment instruments in Indonesia and may not be used as such.',
    'Bank Indonesia menegaskan bahwa mata uang virtual, termasuk Bitcoin, tidak diakui sebagai alat pembayaran yang sah di Indonesia dan tidak boleh digunakan sebagai alat pembayaran.',
    'Use to support the distinction between crypto and official rupiah.',
    'Gunakan untuk membedakan kripto dengan rupiah resmi.'
  ),
  (
    'CH09-OJK-WASPADA',
    'OJK Waspada Investasi — illegal investment alert portal',
    'OJK Waspada Investasi — portal peringatan investasi ilegal',
    1,
    'website',
    'OJK',
    'https://ojk.go.id/waspada-investasi/id/default.aspx',
    'id',
    '2026-08-07',
    'verified',
    'Official OJK portal for reporting and checking illegal investment offers.',
    'Indonesian-language portal; use to report suspicious schemes.',
    'The OJK Waspada Investasi portal publishes alerts about illegal investments and provides channels to report suspicious offers.',
    'Portal OJK Waspada Investasi menerbitkan peringatan tentang investasi ilegal dan menyediakan kanal untuk melaporkan penawaran mencurigakan.',
    'Use to recognize and report crypto scams and unlicensed investment offers.',
    'Gunakan untuk mengenali dan melaporkan penipuan kripto serta penawaran investasi tanpa izin.'
  )
ON CONFLICT (source_code) DO UPDATE SET
  title = EXCLUDED.title,
  local_title = EXCLUDED.local_title,
  source_tier = EXCLUDED.source_tier,
  source_type = EXCLUDED.source_type,
  organization = EXCLUDED.organization,
  url = EXCLUDED.url,
  language = EXCLUDED.language,
  last_checked_at = EXCLUDED.last_checked_at,
  status = EXCLUDED.status,
  trust_notes = EXCLUDED.trust_notes,
  localization_notes = EXCLUDED.localization_notes,
  synopsis = EXCLUDED.synopsis,
  synopsis_id = EXCLUDED.synopsis_id,
  relevance_blurb = EXCLUDED.relevance_blurb,
  relevance_blurb_id = EXCLUDED.relevance_blurb_id;

-- ---------------------------------------------------------------------------
-- 2. Remove stale legacy BAPPEBTI-001 links from Chapter 09 lessons only
-- ---------------------------------------------------------------------------
DELETE FROM public.lesson_sources AS ls
USING public.lessons AS l, public.sources AS s
WHERE ls.lesson_id = l.id
  AND ls.source_id = s.id
  AND l.slug IN (
    'what-is-cryptocurrency',
    'crypto-risks-scams-indonesia',
    'how-to-buy-crypto-safely',
    'crypto-vs-investing-vs-gambling'
  )
  AND s.source_code = 'BAPPEBTI-001';

-- ---------------------------------------------------------------------------
-- 3. Lesson-source links
-- ---------------------------------------------------------------------------
WITH chapter_sources(slug, source_code, relevance_type, citation_label, is_primary, display_order) AS (
  VALUES
    ('what-is-cryptocurrency', 'CH09-BI-CRYPTO-PAYMENT', 'primary', 'BI: virtual currency is not a payment instrument', TRUE, 10),
    ('what-is-cryptocurrency', 'CH09-OJK-CRYPTO', 'supporting', 'OJK crypto asset licensing', FALSE, 20),
    ('what-is-cryptocurrency', 'CH09-BAPPEBTI-LICENSE', 'supporting', 'Bappebti licence check', FALSE, 30),
    ('crypto-risks-scams-indonesia', 'CH09-OJK-WASPADA', 'primary', 'OJK Waspada Investasi', TRUE, 10),
    ('crypto-risks-scams-indonesia', 'CH09-BAPPEBTI-LICENSE', 'supporting', 'Bappebti licence check', FALSE, 20),
    ('how-to-buy-crypto-safely', 'CH09-BAPPEBTI-LICENSE', 'primary', 'Bappebti licence check', TRUE, 10),
    ('how-to-buy-crypto-safely', 'CH09-OJK-CRYPTO', 'supporting', 'OJK crypto asset licensing', FALSE, 20),
    ('crypto-vs-investing-vs-gambling', 'CH09-OJK-CRYPTO', 'primary', 'OJK crypto asset licensing', TRUE, 10),
    ('crypto-vs-investing-vs-gambling', 'CH09-OJK-WASPADA', 'supporting', 'OJK Waspada Investasi', FALSE, 20),
    ('crypto-vs-investing-vs-gambling', 'CH09-BI-CRYPTO-PAYMENT', 'supporting', 'BI: virtual currency is not a payment instrument', FALSE, 30)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, chapter_sources.relevance_type, chapter_sources.citation_label,
       chapter_sources.is_primary, chapter_sources.display_order
FROM chapter_sources
JOIN public.lessons AS lesson ON lesson.slug = chapter_sources.slug
JOIN public.sources AS source ON source.source_code = chapter_sources.source_code
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

-- ---------------------------------------------------------------------------
-- 4. Visual blocks
-- ---------------------------------------------------------------------------
WITH blocks(slug, placement, block_type, display_order, data_status, content) AS (
  VALUES
    -- Lesson 1: what-is-cryptocurrency
    ('what-is-cryptocurrency', 'concept', 'process', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "A simple chain",
        "title": "How a blockchain keeps a record",
        "disclosure": "Simplified illustration — real networks use more complex cryptography and consensus rules.",
        "altText": "Four-step process showing a transaction being broadcast, grouped into a block, verified, and linked to the previous block by a code.",
        "payload": {
          "steps": [
            {"title": "1. A transaction is requested", "description": "Someone sends crypto to another person; the request is broadcast to the network."},
            {"title": "2. The network checks it", "description": "Many computers verify the sender has the balance and the signature is valid."},
            {"title": "3. It is grouped into a block", "description": "Verified transactions are packed into a block with a timestamp."},
            {"title": "4. The block is linked by a code", "description": "Each block carries a code from the previous block, forming a chain that is hard to change."}
          ]
        }
      },
      "id": {
        "eyebrow": "Rantai sederhana",
        "title": "Bagaimana blockchain menyimpan catatan",
        "disclosure": "Ilustrasi sederhana — jaringan nyata menggunakan kriptografi dan aturan konsensus yang lebih kompleks.",
        "altText": "Proses empat langkah yang menunjukkan transaksi disiarkan, dikelompokkan ke dalam blok, diverifikasi, dan dihubungkan ke blok sebelumnya dengan kode.",
        "payload": {
          "steps": [
            {"title": "1. Transaksi diminta", "description": "Seseorang mengirim kripto ke orang lain; permintaan disiarkan ke jaringan."},
            {"title": "2. Jaringan memeriksanya", "description": "Banyak komputer memeriksa bahwa pengirim memiliki saldo dan tanda tangan valid."},
            {"title": "3. Dikelompokkan ke dalam blok", "description": "Transaksi terverifikasi dikemas ke dalam blok dengan stempel waktu."},
            {"title": "4. Blok dihubungkan dengan kode", "description": "Setiap blok membawa kode dari blok sebelumnya, membentuk rantai yang sulit diubah."}
          ]
        }
      }
    }$block$::jsonb),
    ('what-is-cryptocurrency', 'concept', 'comparison', 20, 'source_derived', $block${
      "en": {
        "title": "Crypto is not the rupiah in your wallet",
        "disclosure": "Source: Bank Indonesia — virtual currencies are not recognized as legitimate payment instruments.",
        "altText": "Comparison between crypto as a digital network record and rupiah as official money.",
        "payload": {
          "leftTitle": "Crypto (like Bitcoin)",
          "rightTitle": "Rupiah",
          "rows": [
            {"left": "A digital record on a shared network.", "right": "Official money issued by Bank Indonesia."},
            {"left": "Can be divided into tiny fractions.", "right": "Divided into rupiah and sen."},
            {"left": "Not insured by LPS and not legal tender.", "right": "Bank deposits may qualify for LPS guarantee."},
            {"left": "Price changes with supply and demand.", "right": "Used for everyday payments and taxes."}
          ]
        }
      },
      "id": {
        "title": "Kripto bukan rupiah di dompetmu",
        "disclosure": "Sumber: Bank Indonesia — mata uang virtual tidak diakui sebagai alat pembayaran yang sah.",
        "altText": "Perbandingan antara kripto sebagai catatan jaringan digital dan rupiah sebagai uang resmi.",
        "payload": {
          "leftTitle": "Kripto (seperti Bitcoin)",
          "rightTitle": "Rupiah",
          "rows": [
            {"left": "Catatan digital di jaringan bersama.", "right": "Uang resmi yang diterbitkan Bank Indonesia."},
            {"left": "Bisa dibagi menjadi pecahan sangat kecil.", "right": "Dibagi menjadi rupiah dan sen."},
            {"left": "Tidak dijamin LPS dan bukan alat pembayaran resmi.", "right": "Tabungan di bank bisa memenuhi syarat jaminan LPS."},
            {"left": "Harganya berubah sesuai penawaran dan permintaan.", "right": "Digunakan untuk pembayaran sehari-hari dan pajak."}
          ]
        }
      }
    }$block$::jsonb),
    ('what-is-cryptocurrency', 'example', 'worked_example', 10, 'calculated', $block${
      "en": {
        "eyebrow": "Divisibility example",
        "title": "You do not need to buy one whole Bitcoin",
        "disclosure": "Illustrative price — not a live quote or return promise.",
        "altText": "Worked example dividing one Bitcoin into small fractions at an illustrative price.",
        "payload": {
          "inputs": [
            {"label": "1 Bitcoin (illustrative)", "value": "Rp 700,000,000"},
            {"label": "Your budget", "value": "Rp 500,000"},
            {"label": "Fraction you receive", "value": "0.000714 BTC"}
          ],
          "steps": [
            "1 BTC = 100,000,000 satoshi.",
            "Rp 500,000 ÷ Rp 700,000,000 ≈ 0.000714 BTC.",
            "You own a tiny fraction; you do not own the whole network."
          ],
          "outcome": "Cryptocurrency is divisible, so a small rupiah amount can buy a fraction — but the price can move sharply either way."
        }
      },
      "id": {
        "eyebrow": "Contoh pembagian",
        "title": "Kamu tidak perlu membeli satu Bitcoin utuh",
        "disclosure": "Harga ilustratif — bukan kutipan langsung atau janji imbal hasil.",
        "altText": "Contoh perhitungan membagi satu Bitcoin menjadi pecahan kecil dengan harga ilustratif.",
        "payload": {
          "inputs": [
            {"label": "1 Bitcoin (ilustratif)", "value": "Rp 700.000.000"},
            {"label": "Anggaranmu", "value": "Rp 500.000"},
            {"label": "Pecahan yang kamu terima", "value": "0,000714 BTC"}
          ],
          "steps": [
            "1 BTC = 100.000.000 satoshi.",
            "Rp 500.000 ÷ Rp 700.000.000 ≈ 0,000714 BTC.",
            "Kamu memiliki pecahan kecil; kamu tidak memiliki seluruh jaringan."
          ],
          "outcome": "Mata uang kripto dapat dibagi, sehingga jumlah rupiah kecil bisa membeli pecahan — tapi harganya bisa bergerak drastis."
        }
      }
    }$block$::jsonb),

    -- Lesson 2: crypto-risks-scams-indonesia
    ('crypto-risks-scams-indonesia', 'concept', 'worked_example', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Illustrative example",
        "title": "Volatility in one day",
        "disclosure": "Illustrative price movement — not a prediction of any coin's future price.",
        "altText": "Worked example showing a Rp 5,000,000 crypto position rising or falling 20% in one day.",
        "payload": {
          "inputs": [
            {"label": "Starting value", "value": "Rp 5,000,000"},
            {"label": "Daily move", "value": "+20% or −20%"},
            {"label": "Possible value next day", "value": "Rp 6,000,000 or Rp 4,000,000"}
          ],
          "steps": [
            "A 20% rise turns Rp 5,000,000 into Rp 6,000,000.",
            "A 20% fall turns Rp 5,000,000 into Rp 4,000,000.",
            "This is market volatility, not a scam — but it can cause panic."
          ],
          "outcome": "Big daily moves are normal for crypto; they are different from someone taking your money and disappearing."
        }
      },
      "id": {
        "eyebrow": "Contoh ilustratif",
        "title": "Volatilitas dalam satu hari",
        "disclosure": "Pergerakan harga ilustratif — bukan prediksi harga koin di masa depan.",
        "altText": "Contoh perhitungan menunjukkan posisi kripto Rp 5.000.000 naik atau turun 20% dalam sehari.",
        "payload": {
          "inputs": [
            {"label": "Nilai awal", "value": "Rp 5.000.000"},
            {"label": "Pergerakan harian", "value": "+20% atau −20%"},
            {"label": "Nilai mungkin besok", "value": "Rp 6.000.000 atau Rp 4.000.000"}
          ],
          "steps": [
            "Kenaikan 20% mengubah Rp 5.000.000 menjadi Rp 6.000.000.",
            "Penurunan 20% mengubah Rp 5.000.000 menjadi Rp 4.000.000.",
            "Ini volatilitas pasar, bukan penipuan — tapi bisa memicu panik."
          ],
          "outcome": "Pergerakan besar sehari-hari normal untuk kripto; berbeda dengan seseorang yang mengambil uangmu lalu menghilang."
        }
      }
    }$block$::jsonb),
    ('crypto-risks-scams-indonesia', 'concept', 'process', 20, 'illustrative', $block${
      "en": {
        "eyebrow": "Scam checklist",
        "title": "Spot a rug-pull pattern",
        "disclosure": "Illustrative warning signs — always verify registration and never trust guaranteed-return promises.",
        "altText": "Four-step scam pattern: big promise, urgency, payment outside the platform, then disappearance.",
        "payload": {
          "steps": [
            {"title": "1. Big promise", "description": "Guaranteed returns like '10x in a week' or 'risk-free profits'."},
            {"title": "2. Urgency and secrecy", "description": "'Only for the first 100 people' or 'do not tell the regulator'."},
            {"title": "3. Payment outside the platform", "description": "You are asked to send rupiah to a personal account or unknown wallet."},
            {"title": "4. The project disappears", "description": "Website and group are deleted; the price collapses and you cannot withdraw."}
          ]
        }
      },
      "id": {
        "eyebrow": "Daftar periksa penipuan",
        "title": "Kenali pola rug pull",
        "disclosure": "Tanda peringatan ilustratif — selalu verifikasi pendaftaran dan jangan percaya janji imbal hasil dijamin.",
        "altText": "Pola penipuan empat langkah: janji besar, urgensi, pembayaran di luar platform, lalu menghilang.",
        "payload": {
          "steps": [
            {"title": "1. Janji besar", "description": "Imbal hasil dijamin seperti '10x dalam seminggu' atau 'keuntungan tanpa risiko'."},
            {"title": "2. Urgensi dan kerahasiaan", "description": "'Hanya untuk 100 orang pertama' atau 'jangan beritahu regulator'."},
            {"title": "3. Pembayaran di luar platform", "description": "Diminta mengirim rupiah ke rekening pribadi atau dompet tidak dikenal."},
            {"title": "4. Proyek menghilang", "description": "Situs dan grup dihapus; harga runtuh dan kamu tidak bisa menarik dana."}
          ]
        }
      }
    }$block$::jsonb),
    ('crypto-risks-scams-indonesia', 'example', 'comparison', 10, 'illustrative', $block${
      "en": {
        "title": "Volatility is not the same as a scam",
        "disclosure": "Illustrative distinction — both can lose money, but the cause is different.",
        "altText": "Comparison between normal market volatility and a scam that steals funds.",
        "payload": {
          "leftTitle": "Normal volatility",
          "rightTitle": "A scam / rug pull",
          "rows": [
            {"left": "Price moves up and down with market demand.", "right": "Someone promises guaranteed returns to take your money."},
            {"left": "Your coins still exist on the network.", "right": "The project or group suddenly disappears."},
            {"left": "Risk comes from price, not from theft.", "right": "You lose money because the operator steals or runs away."}
          ]
        }
      },
      "id": {
        "title": "Volatilitas tidak sama dengan penipuan",
        "disclosure": "Perbedaan ilustratif — keduanya bisa merugikan, tapi penyebabnya berbeda.",
        "altText": "Perbandingan antara volatilitas pasar normal dan penipuan yang mencuri dana.",
        "payload": {
          "leftTitle": "Volatilitas normal",
          "rightTitle": "Penipuan / rug pull",
          "rows": [
            {"left": "Harga naik turun mengikuti permintaan pasar.", "right": "Seseorang menjanjikan imbal hasil dijamin untuk mengambil uangmu."},
            {"left": "Koinmu masih ada di jaringan.", "right": "Proyek atau grup tiba-tiba menghilang."},
            {"left": "Risiko berasal dari harga, bukan pencurian.", "right": "Kamu rugi karena operator mencuri atau lari."}
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 3: how-to-buy-crypto-safely
    ('how-to-buy-crypto-safely', 'concept', 'process', 10, 'source_derived', $block${
      "en": {
        "eyebrow": "Step-by-step",
        "title": "A safer crypto purchase path in Indonesia",
        "disclosure": "Always check the latest official OJK/Bappebti register before depositing — platform status can change.",
        "altText": "Six-step process for checking registration, completing KYC, depositing from own bank, buying small, securing holdings, and ignoring strangers.",
        "payload": {
          "steps": [
            {"title": "1. Check the official register", "description": "Verify the platform is listed on the current OJK/Bappebti register."},
            {"title": "2. Complete KYC with your own ID", "description": "Use your real KTP and contact details; do not use someone else's identity."},
            {"title": "3. Deposit from your own bank account", "description": "Send rupiah from an account in your name, not a third party."},
            {"title": "4. Buy a small amount and record it", "description": "Start small, note the date, price, and fee; treat it as learning."},
            {"title": "5. Move long-term holdings to your own wallet (optional)", "description": "For amounts you plan to hold, consider a wallet you control; keep the seed phrase private."},
            {"title": "6. Ignore strangers offering a cheaper rate", "description": "P2P deals with unknown people are high risk and often scams."}
          ]
        }
      },
      "id": {
        "eyebrow": "Langkah demi langkah",
        "title": "Jalur pembelian kripto yang lebih aman di Indonesia",
        "disclosure": "Selalu periksa daftar resmi OJK/Bappebti terbaru sebelum deposit — status platform bisa berubah.",
        "altText": "Proses enam langkah untuk memeriksa pendaftaran, menyelesaikan KYC, deposit dari bank sendiri, membeli sedikit, mengamankan kepemilikan, dan mengabaikan orang asing.",
        "payload": {
          "steps": [
            {"title": "1. Periksa daftar resmi", "description": "Verifikasi platform tercantum di daftar OJK/Bappebti terkini."},
            {"title": "2. Selesaikan KYC dengan KTP sendiri", "description": "Gunakan KTP dan data kontak aslimu; jangan gunakan identitas orang lain."},
            {"title": "3. Deposit dari rekening bank sendiri", "description": "Kirim rupiah dari rekening atas nama sendiri, bukan pihak ketiga."},
            {"title": "4. Beli sedikit dan catat", "description": "Mulai sedikit, catat tanggal, harga, dan biaya; anggap sebagai pembelajaran."},
            {"title": "5. Pindahkan kepemilikan jangka panjang ke dompet sendiri (opsional)", "description": "Untuk yang ingin ditahan lama, pertimbangkan dompet yang kamu kendalikan; simpan seed phrase secara pribadi."},
            {"title": "6. Abaikan orang asing yang menawarkan harga lebih murah", "description": "Transaksi P2P dengan orang tidak dikenal berisiko tinggi dan sering penipuan."}
          ]
        }
      }
    }$block$::jsonb),
    ('how-to-buy-crypto-safely', 'example', 'comparison', 10, 'illustrative', $block${
      "en": {
        "title": "Registered exchange vs stranger P2P",
        "disclosure": "Illustrative comparison — always verify current registration status on the official list.",
        "altText": "Comparison between using a verified exchange and sending money to a stranger.",
        "payload": {
          "leftTitle": "Registered exchange route",
          "rightTitle": "Stranger P2P route",
          "rows": [
            {"left": "KYC required; identity verified.", "right": "No identity check; you do not know who receives the money."},
            {"left": "Customer funds are separated from company funds.", "right": "Money goes to a personal account; no protection if they run."},
            {"left": "You can report problems through official channels.", "right": "No official dispute channel; often a scam."}
          ]
        }
      },
      "id": {
        "title": "Bursa terdaftar vs P2P dengan orang asing",
        "disclosure": "Perbandingan ilustratif — selalu verifikasi status pendaftaran terkini di daftar resmi.",
        "altText": "Perbandingan antara menggunakan bursa terverifikasi dan mengirim uang ke orang asing.",
        "payload": {
          "leftTitle": "Jalur bursa terdaftar",
          "rightTitle": "Jalur P2P dengan orang asing",
          "rows": [
            {"left": "KYC wajib; identitas terverifikasi.", "right": "Tidak ada pemeriksaan identitas; kamu tidak tahu siapa yang menerima uang."},
            {"left": "Dana nasabah dipisahkan dari dana perusahaan.", "right": "Uang masuk ke rekening pribadi; tidak ada perlindungan jika kabur."},
            {"left": "Bisa melaporkan masalah melalui kanal resmi.", "right": "Tidak ada kanal sengketa resmi; sering penipuan."}
          ]
        }
      }
    }$block$::jsonb),

    -- Lesson 4: crypto-vs-investing-vs-gambling
    ('crypto-vs-investing-vs-gambling', 'concept', 'comparison', 10, 'illustrative', $block${
      "en": {
        "title": "Investing vs speculation",
        "disclosure": "Illustrative distinction — these are teaching labels, not a judgment of any specific person.",
        "altText": "Comparison between investing in productive assets and speculating on short-term price moves.",
        "payload": {
          "leftTitle": "Investing",
          "rightTitle": "Speculation",
          "rows": [
            {"left": "Owns productive assets that can earn income or grow.", "right": "Buys mainly because the price might rise quickly."},
            {"left": "Time horizon is usually years.", "right": "Time horizon is days, weeks, or months."},
            {"left": "Decision is based on evidence and goals.", "right": "Decision is often based on hype or FOMO."}
          ]
        }
      },
      "id": {
        "title": "Investasi vs spekulasi",
        "disclosure": "Perbedaan ilustratif — ini label pembelajaran, bukan penilaian terhadap individu tertentu.",
        "altText": "Perbandingan antara berinvestasi di aset produktif dan berspekulasi pada pergerakan harga jangka pendek.",
        "payload": {
          "leftTitle": "Berinvestasi",
          "rightTitle": "Berspekulasi",
          "rows": [
            {"left": "Memiliki aset produktif yang bisa menghasilkan atau tumbuh.", "right": "Membeli terutama karena harga mungkin naik cepat."},
            {"left": "Jangka waktu biasanya bertahun-tahun.", "right": "Jangka waktu hari, minggu, atau bulan."},
            {"left": "Keputusan berdasarkan bukti dan tujuan.", "right": "Keputusan sering berdasarkan hype atau FOMO."}
          ]
        }
      }
    }$block$::jsonb),
    ('crypto-vs-investing-vs-gambling', 'concept', 'comparison', 20, 'illustrative', $block${
      "en": {
        "title": "Speculation vs gambling",
        "disclosure": "Illustrative distinction — both can lose money, but the structure differs.",
        "altText": "Comparison between speculation on market prices and gambling where the odds favor the house.",
        "payload": {
          "leftTitle": "Speculation",
          "rightTitle": "Gambling",
          "rows": [
            {"left": "Price depends on market supply and demand.", "right": "Outcome is determined by fixed odds or chance."},
            {"left": "You can study the asset and market.", "right": "The house usually has an edge over time."},
            {"left": "Losses come from price moves against you.", "right": "Losses are expected as the cost of entertainment."}
          ]
        }
      },
      "id": {
        "title": "Spekulasi vs judi",
        "disclosure": "Perbedaan ilustratif — keduanya bisa merugikan, tapi strukturnya berbeda.",
        "altText": "Perbandingan antara spekulasi harga pasar dan judi di mana peluang menguntungkan bandar.",
        "payload": {
          "leftTitle": "Spekulasi",
          "rightTitle": "Judi",
          "rows": [
            {"left": "Harga bergantung pada penawaran dan permintaan pasar.", "right": "Hasil ditentukan oleh peluang tetap atau kebetulan."},
            {"left": "Kamu bisa mempelajari aset dan pasar.", "right": "Bandar biasanya punya keunggulan dari waktu ke waktu."},
            {"left": "Kerugian berasal dari pergerakan harga yang merugikanmu.", "right": "Kerugian diharapkan sebagai biaya hiburan."}
          ]
        }
      }
    }$block$::jsonb),
    ('crypto-vs-investing-vs-gambling', 'example', 'worked_example', 10, 'illustrative', $block${
      "en": {
        "eyebrow": "Worked example",
        "title": "Classify Andi's Rp 5,000,000 choice",
        "disclosure": "Illustrative scenario — not a personal recommendation for any learner.",
        "altText": "Worked example classifying three options as investing, speculation, or gambling.",
        "payload": {
          "inputs": [
            {"label": "Option A: mixed reksa dana", "value": "owns stocks and bonds"},
            {"label": "Option B: trending coin from TikTok", "value": "hopes to double in a week"},
            {"label": "Option C: online gambling site", "value": "odds favor the house"}
          ],
          "steps": [
            "Option A is investing: it owns productive assets and matches a goal.",
            "Option B is speculation: it depends on price timing and hype.",
            "Option C is gambling: the platform is designed to make the house win over time."
          ],
          "outcome": "The same amount of money can follow very different risk profiles depending on the choice."
        }
      },
      "id": {
        "eyebrow": "Contoh perhitungan",
        "title": "Klasifikasikan pilihan Rp 5.000.000 Andi",
        "disclosure": "Skenario ilustratif — bukan rekomendasi pribadi untuk peserta didik mana pun.",
        "altText": "Contoh klasifikasi tiga pilihan sebagai investasi, spekulasi, atau judi.",
        "payload": {
          "inputs": [
            {"label": "Pilihan A: reksa dana campuran", "value": "memiliki saham dan obligasi"},
            {"label": "Pilihan B: koin viral dari TikTok", "value": "berharap naik dua kali dalam seminggu"},
            {"label": "Pilihan C: situs judi online", "value": "peluang menguntungkan bandar"}
          ],
          "steps": [
            "Pilihan A adalah investasi: memiliki aset produktif dan sesuai tujuan.",
            "Pilihan B adalah spekulasi: bergantung pada waktu harga dan hype.",
            "Pilihan C adalah judi: platform dirancang agar bandar menang dari waktu ke waktu."
          ],
          "outcome": "Jumlah uang yang sama bisa memiliki profil risiko sangat berbeda tergantung pilihannya."
        }
      }
    }$block$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, display_order, data_status, content, is_published)
SELECT lesson.id, blocks.placement, blocks.block_type, blocks.display_order,
       blocks.data_status, blocks.content, TRUE
FROM blocks
JOIN public.lessons AS lesson ON lesson.slug = blocks.slug
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = TRUE,
  updated_at = NOW();

-- ---------------------------------------------------------------------------
-- 5. Visual block source junctions (only source-derived blocks)
-- ---------------------------------------------------------------------------
WITH block_sources(slug, display_order, source_code, citation_label) AS (
  VALUES
    ('what-is-cryptocurrency', 20, 'CH09-BI-CRYPTO-PAYMENT', 'BI: not a payment instrument'),
    ('how-to-buy-crypto-safely', 10, 'CH09-BAPPEBTI-LICENSE', 'Bappebti licence check'),
    ('how-to-buy-crypto-safely', 10, 'CH09-OJK-CRYPTO', 'OJK crypto asset licensing')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, block_sources.citation_label
FROM block_sources
JOIN public.lessons AS lesson ON lesson.slug = block_sources.slug
JOIN public.lesson_visual_blocks AS block
  ON block.lesson_id = lesson.id AND block.display_order = block_sources.display_order
JOIN public.sources AS source ON source.source_code = block_sources.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET
  citation_label = EXCLUDED.citation_label;

-- ---------------------------------------------------------------------------
-- 6. Applied questions (visual_applied), three bilingual variants per lesson
-- ---------------------------------------------------------------------------
WITH applied_questions(slug, body, body_id) AS (
  VALUES
    -- Lesson 1
    ('what-is-cryptocurrency', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Based on the blockchain process, why is it hard for one person to change a record alone?",
      "options": ["Many computers keep copies and check the chain", "Because it is stored in a bank", "Because the price is high", "Because it is secret"],
      "answer": "Many computers keep copies and check the chain",
      "explanation": "A blockchain is shared across many computers. To change a record, someone would have to change most copies at once, which is extremely difficult."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Berdasarkan proses blockchain, mengapa sulit bagi satu orang untuk mengubah catatan sendirian?",
      "options": ["Banyak komputer menyimpan salinan dan memeriksa rantai", "Karena disimpan di bank", "Karena harganya tinggi", "Karena rahasia"],
      "answer": "Banyak komputer menyimpan salinan dan memeriksa rantai",
      "explanation": "Blockchain dibagikan ke banyak komputer. Untuk mengubah catatan, seseorang harus mengubah sebagian besar salinan sekaligus, yang sangat sulit."
    }$block$::jsonb),
    ('what-is-cryptocurrency', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Based on the comparison, which statement is true?",
      "options": ["Crypto is not official money in Indonesia", "Bitcoin is issued by Bank Indonesia", "Crypto deposits are insured by LPS", "Rupiah runs on a blockchain"],
      "answer": "Crypto is not official money in Indonesia",
      "explanation": "Bank Indonesia states that virtual currencies are not recognized as legitimate payment instruments, unlike the rupiah."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Berdasarkan perbandingan, pernyataan mana yang benar?",
      "options": ["Kripto bukan uang resmi di Indonesia", "Bitcoin diterbitkan Bank Indonesia", "Deposit kripto dijamin LPS", "Rupiah berjalan di blockchain"],
      "answer": "Kripto bukan uang resmi di Indonesia",
      "explanation": "Bank Indonesia menyatakan bahwa mata uang virtual tidak diakui sebagai alat pembayaran yang sah, tidak seperti rupiah."
    }$block$::jsonb),
    ('what-is-cryptocurrency', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "In the divisibility example, what does Rp 500,000 buy?",
      "options": ["A fraction of one Bitcoin", "One whole Bitcoin", "A guaranteed profit", "A bank deposit"],
      "answer": "A fraction of one Bitcoin",
      "explanation": "At the illustrative price, Rp 500,000 buys about 0.000714 BTC — a small fraction, not a whole Bitcoin."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Dalam contoh pembagian, apa yang bisa dibeli dengan Rp 500.000?",
      "options": ["Sebagian kecil dari satu Bitcoin", "Satu Bitcoin utuh", "Keuntungan yang dijamin", "Deposit bank"],
      "answer": "Sebagian kecil dari satu Bitcoin",
      "explanation": "Dengan harga ilustratif, Rp 500.000 membeli sekitar 0,000714 BTC — pecahan kecil, bukan satu Bitcoin utuh."
    }$block$::jsonb),

    -- Lesson 2
    ('crypto-risks-scams-indonesia', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "In the volatility example, what is a possible one-day result of a Rp 5,000,000 crypto position?",
      "options": ["Rp 4,000,000 or Rp 6,000,000", "Rp 5,500,000 only", "Rp 10,000,000 guaranteed", "Rp 0 because it is a scam"],
      "answer": "Rp 4,000,000 or Rp 6,000,000",
      "explanation": "A 20% move either way is common for crypto. That means Rp 5,000,000 could become Rp 4,000,000 or Rp 6,000,000 in one day."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Dalam contoh volatilitas, apa hasil satu hari yang mungkin untuk posisi kripto Rp 5.000.000?",
      "options": ["Rp 4.000.000 atau Rp 6.000.000", "Rp 5.500.000 saja", "Rp 10.000.000 dijamin", "Rp 0 karena ini penipuan"],
      "answer": "Rp 4.000.000 atau Rp 6.000.000",
      "explanation": "Pergerakan 20% ke salah satu arah umum terjadi pada kripto. Artinya Rp 5.000.000 bisa menjadi Rp 4.000.000 atau Rp 6.000.000 dalam sehari."
    }$block$::jsonb),
    ('crypto-risks-scams-indonesia', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Which step in the rug-pull pattern is the clearest warning sign?",
      "options": ["Payment to a personal account or unknown wallet", "Price going up and down", "Reading the whitepaper", "Using a Bappebti-registered exchange"],
      "answer": "Payment to a personal account or unknown wallet",
      "explanation": "Legitimate exchanges use verified company accounts. A request to send money to a personal account or unknown wallet is a strong scam signal."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Langkah mana dalam pola rug pull yang merupakan tanda peringatan paling jelas?",
      "options": ["Pembayaran ke rekening pribadi atau dompet tidak dikenal", "Harga naik turun", "Membaca whitepaper", "Menggunakan bursa terdaftar Bappebti"],
      "answer": "Pembayaran ke rekening pribadi atau dompet tidak dikenal",
      "explanation": "Bursa resmi menggunakan rekening perusahaan terverifikasi. Permintaan mengirim uang ke rekening pribadi atau dompet tidak dikenal adalah sinyal penipuan yang kuat."
    }$block$::jsonb),
    ('crypto-risks-scams-indonesia', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "What is the difference between volatility and a scam?",
      "options": ["Volatility is price movement; a scam takes your money", "Both are the same thing", "Volatility guarantees losses", "Scams only happen on official exchanges"],
      "answer": "Volatility is price movement; a scam takes your money",
      "explanation": "Volatility means prices move; your coins still exist. A scam or rug pull means the operator takes your money and disappears."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Apa perbedaan antara volatilitas dan penipuan?",
      "options": ["Volatilitas adalah pergerakan harga; penipuan mengambil uangmu", "Keduanya sama saja", "Volatilitas menjamin kerugian", "Penipuan hanya terjadi di bursa resmi"],
      "answer": "Volatilitas adalah pergerakan harga; penipuan mengambil uangmu",
      "explanation": "Volatilitas berarti harga bergerak; koinmu masih ada. Penipuan atau rug pull berarti operator mengambil uangmu lalu menghilang."
    }$block$::jsonb),

    -- Lesson 3
    ('how-to-buy-crypto-safely', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Before depositing rupiah, what is the first check?",
      "options": ["Check the OJK/Bappebti register", "Ask a Telegram admin", "Send a small test to a personal account", "Look for celebrity endorsements"],
      "answer": "Check the OJK/Bappebti register",
      "explanation": "The safest first step is to verify that the platform appears on the current official OJK or Bappebti register."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Sebelum menyetor rupiah, pemeriksaan pertama apa yang harus dilakukan?",
      "options": ["Periksa daftar OJK/Bappebti", "Tanya admin Telegram", "Kirim uji coba ke rekening pribadi", "Cari dukungan selebriti"],
      "answer": "Periksa daftar OJK/Bappebti",
      "explanation": "Langkah pertama yang paling aman adalah memverifikasi bahwa platform tercantum di daftar resmi OJK atau Bappebti terkini."
    }$block$::jsonb),
    ('how-to-buy-crypto-safely', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Why should KYC use your own KTP?",
      "options": ["So the account matches your identity and is protected", "Because the platform will pay you extra", "To hide from taxes", "Because strangers asked for it"],
      "answer": "So the account matches your identity and is protected",
      "explanation": "Using your own identity keeps the account legally yours and makes it easier to recover or report problems through official channels."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Mengapa KYC harus menggunakan KTP sendiri?",
      "options": ["Agar akun cocok dengan identitasmu dan dilindungi", "Karena platform akan membayar ekstra", "Untuk menyembunyikan dari pajak", "Karena orang asing memintanya"],
      "answer": "Agar akun cocok dengan identitasmu dan dilindungi",
      "explanation": "Menggunakan identitas sendiri membuat akun secara hukum milikmu dan memudahkan pemulihan atau pelaporan masalah melalui kanal resmi."
    }$block$::jsonb),
    ('how-to-buy-crypto-safely', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Which behaviour is safer for long-term holdings?",
      "options": ["Move them to a wallet you control and keep the seed phrase private", "Keep everything on the exchange forever", "Share your seed phrase for backup", "Buy from a stranger who offers a lower price"],
      "answer": "Move them to a wallet you control and keep the seed phrase private",
      "explanation": "A wallet you control reduces platform risk, but the seed phrase must stay private because anyone with it can take the funds."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Perilaku mana yang lebih aman untuk kepemilikan jangka panjang?",
      "options": ["Pindahkan ke dompet yang kamu kendalikan dan simpan seed phrase pribadi", "Biarkan semua di bursa selamanya", "Bagikan seed phrase untuk cadangan", "Beli dari orang asing yang menawarkan harga lebih murah"],
      "answer": "Pindahkan ke dompet yang kamu kendalikan dan simpan seed phrase pribadi",
      "explanation": "Dompet yang kamu kendalikan mengurangi risiko platform, tapi seed phrase harus tetap pribadi karena siapa pun yang memilikinya bisa mengambil dana."
    }$block$::jsonb),

    -- Lesson 4
    ('crypto-vs-investing-vs-gambling', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Andi buys a trending coin hoping it doubles next week. This is best described as?",
      "options": ["Speculation", "Investing", "Gambling", "Saving"],
      "answer": "Speculation",
      "explanation": "Buying mainly because the price might rise quickly is speculation, not investing in productive assets."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Andi membeli koin viral dengan harapan nilainya naik dua kali minggu depan. Ini paling tepat disebut?",
      "options": ["Spekulasi", "Investasi", "Judi", "Menabung"],
      "answer": "Spekulasi",
      "explanation": "Membeli terutama karena harga mungkin naik cepat adalah spekulasi, bukan berinvestasi di aset produktif."
    }$block$::jsonb),
    ('crypto-vs-investing-vs-gambling', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Which choice is closest to investing?",
      "options": ["A reksa dana that owns stocks and bonds", "A coin promoted by an influencer", "An online slot game", "A P2P deal with a stranger"],
      "answer": "A reksa dana that owns stocks and bonds",
      "explanation": "A reksa dana that owns stocks and bonds holds productive assets, which matches the investing label."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Pilihan mana yang paling mendekati investasi?",
      "options": ["Reksa dana yang memiliki saham dan obligasi", "Koin yang dipromosikan influencer", "Permainan slot online", "Transaksi P2P dengan orang asing"],
      "answer": "Reksa dana yang memiliki saham dan obligasi",
      "explanation": "Reksa dana yang memiliki saham dan obligasi memegang aset produktif, yang sesuai dengan label investasi."
    }$block$::jsonb),
    ('crypto-vs-investing-vs-gambling', $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "What is the main difference between speculation and gambling?",
      "options": ["Speculation depends on market prices; gambling depends on fixed odds", "They are exactly the same", "Speculation is guaranteed", "Gambling is regulated by OJK"],
      "answer": "Speculation depends on market prices; gambling depends on fixed odds",
      "explanation": "Speculation involves market price risk that you can study; gambling outcomes are driven by odds or chance set by the house."
    }$block$::jsonb, $block${
      "type": "multiple_choice",
      "difficulty": "beginner",
      "question": "Apa perbedaan utama antara spekulasi dan judi?",
      "options": ["Spekulasi bergantung pada harga pasar; judi bergantung pada peluang tetap", "Keduanya sama persis", "Spekulasi dijamin", "Judi diatur oleh OJK"],
      "answer": "Spekulasi bergantung pada harga pasar; judi bergantung pada peluang tetap",
      "explanation": "Spekulasi melibatkan risiko harga pasar yang bisa dipelajari; hasil judi ditentukan oleh peluang atau kebetulan yang ditetapkan bandar."
    }$block$::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied_questions.body, applied_questions.body_id, 'intermediate', 'visual_applied', TRUE
FROM applied_questions
JOIN public.lessons AS lesson ON lesson.slug = applied_questions.slug
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants AS existing
  WHERE existing.lesson_id = lesson.id AND existing.topic_tag = 'visual_applied'
);

-- ---------------------------------------------------------------------------
-- 7. Optional five-Jakarta-calendar-day recall prompts (one per lesson)
-- ---------------------------------------------------------------------------
WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (
  VALUES
    ('what-is-cryptocurrency',
     'What makes a blockchain record hard to change alone?',
     'Apa yang membuat catatan blockchain sulit diubah sendirian?',
     $block$[{"id":"many_copies","label":"Many computers keep copies"},{"id":"one_password","label":"One person has a password"},{"id":"government_checks","label":"The government checks every transaction"},{"id":"invisible_blocks","label":"The blocks are invisible"}]$block$::jsonb,
     $block$[{"id":"many_copies","label":"Banyak komputer menyimpan salinan"},{"id":"one_password","label":"Satu orang memiliki kata sandi"},{"id":"government_checks","label":"Pemerintah memeriksa setiap transaksi"},{"id":"invisible_blocks","label":"Blok-bloknya tidak terlihat"}]$block$::jsonb,
     'many_copies',
     'Because many computers keep copies and check the chain, changing one record alone is practically impossible.',
     'Karena banyak komputer menyimpan salinan dan memeriksa rantai, mengubah satu catatan sendirian hampir mustahil.'),
    ('crypto-risks-scams-indonesia',
     'Which of these is a scam sign, not normal crypto volatility?',
     'Manakah di antara ini yang merupakan tanda penipuan, bukan volatilitas kripto normal?',
     $block$[{"id":"guaranteed_10x","label":"Guaranteed 10x returns in a week"},{"id":"price_move","label":"Price moving 20% in a day"},{"id":"buy_fraction","label":"Buying a fraction of Bitcoin"},{"id":"check_register","label":"Checking the Bappebti list"}]$block$::jsonb,
     $block$[{"id":"guaranteed_10x","label":"Imbal hasil 10x dijamin dalam seminggu"},{"id":"price_move","label":"Harga bergerak 20% dalam sehari"},{"id":"buy_fraction","label":"Membeli pecahan Bitcoin"},{"id":"check_register","label":"Memeriksa daftar Bappebti"}]$block$::jsonb,
     'guaranteed_10x',
     'Guaranteed high returns are a classic scam sign. Normal volatility means prices move, not that returns are promised.',
     'Imbal hasil tinggi yang dijamin adalah tanda penipuan klasik. Volatilitas normal berarti harga bergerak, bukan imbal hasil dijanjikan.'),
    ('how-to-buy-crypto-safely',
     'Before sending rupiah to a crypto platform, the safest first step is to...',
     'Sebelum mengirim rupiah ke platform kripto, langkah pertama yang paling aman adalah...',
     $block$[{"id":"check_register","label":"Check the current OJK/Bappebti register"},{"id":"join_telegram","label":"Join a Telegram group"},{"id":"personal_account","label":"Send money to a personal account"},{"id":"cheapest_seller","label":"Look for the cheapest seller"}]$block$::jsonb,
     $block$[{"id":"check_register","label":"Memeriksa daftar OJK/Bappebti terkini"},{"id":"join_telegram","label":"Bergabung dengan grup Telegram"},{"id":"personal_account","label":"Mengirim uang ke rekening pribadi"},{"id":"cheapest_seller","label":"Mencari penjual termurah"}]$block$::jsonb,
     'check_register',
     'Checking the official OJK/Bappebti register first helps confirm the platform is currently recognized before you deposit.',
     'Memeriksa daftar resmi OJK/Bappebti terlebih dahulu membantu memastikan platform saat ini dikenali sebelum menyetor.'),
    ('crypto-vs-investing-vs-gambling',
     'Buying a coin because you expect it to double next week is best described as...',
     'Membeli koin karena berharap nilainya naik dua kali minggu depan paling tepat disebut...',
     $block$[{"id":"speculation","label":"Speculation"},{"id":"investing","label":"Investing"},{"id":"saving","label":"Saving"},{"id":"insurance","label":"Insurance"}]$block$::jsonb,
     $block$[{"id":"speculation","label":"Spekulasi"},{"id":"investing","label":"Investasi"},{"id":"saving","label":"Menabung"},{"id":"insurance","label":"Asuransi"}]$block$::jsonb,
     'speculation',
     'Buying mainly for a quick price rise is speculation, not investing in productive assets.',
     'Membeli terutama untuk kenaikan harga cepat adalah spekulasi, bukan berinvestasi di aset produktif.')
)
INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id,
  correct_option, explanation_en, explanation_id, is_active
)
SELECT lesson.id, recalls.question_en, recalls.question_id, recalls.options_en, recalls.options_id,
       recalls.correct_option, recalls.explanation_en, recalls.explanation_id, TRUE
FROM recalls
JOIN public.lessons AS lesson ON lesson.slug = recalls.slug
ON CONFLICT (lesson_id) DO UPDATE SET
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  options_en = EXCLUDED.options_en,
  options_id = EXCLUDED.options_id,
  correct_option = EXCLUDED.correct_option,
  explanation_en = EXCLUDED.explanation_en,
  explanation_id = EXCLUDED.explanation_id,
  is_active = TRUE,
  updated_at = NOW();

COMMIT;
