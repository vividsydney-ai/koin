-- KO-306: publish the first compact Chapter 08 visual batch.
-- Values are illustrative/calculated teaching examples, not market data or
-- personalised investment advice.

BEGIN;

WITH approved_lessons AS (
  SELECT l.id, l.slug
  FROM public.lessons AS l
  JOIN public.lesson_reviews AS review ON review.lesson_id = l.id
  WHERE l.slug IN ('what-is-a-stock', 'idx-basics-101', 'portfolio-thinking')
    AND l.is_published = TRUE
    AND review.approved_to_publish = TRUE
), blocks(slug, placement, block_type, display_order, data_status, content) AS (
  VALUES
    ('what-is-a-stock', 'concept', 'worked_example', 10, 'calculated', $json${
      "en": {
        "eyebrow": "Illustrative example",
        "title": "A share is a small piece of ownership",
        "disclosure": "Illustrative IDR values for learning only — not a live quote, return promise, or buy recommendation.",
        "altText": "A worked example showing one lot of 100 shares at an illustrative price, the multiplication to calculate cost, and the reminder that ownership does not guarantee profit.",
        "payload": {
          "inputs": [
            {"label": "Shares in 1 lot", "value": "100 shares"},
            {"label": "Illustrative price", "value": "Rp 8,550 per share"},
            {"label": "Before-fee cost", "value": "Rp 855,000"}
          ],
          "steps": [
            "1 lot = 100 shares.",
            "100 × Rp 8,550 = Rp 855,000 before fees.",
            "The buyer owns a tiny share of the company, not a promise of profit."
          ],
          "outcome": "Ownership gives exposure to the company’s results and price changes. It does not guarantee a gain."
        }
      },
      "id": {
        "eyebrow": "Contoh ilustratif",
        "title": "Saham adalah bagian kecil dari kepemilikan",
        "disclosure": "Nilai IDR ilustratif untuk belajar — bukan kutipan langsung, janji imbal hasil, atau rekomendasi beli.",
        "altText": "Contoh perhitungan yang menunjukkan satu lot berisi 100 saham dengan harga ilustratif, perkalian untuk menghitung biaya, dan pengingat bahwa kepemilikan tidak menjamin keuntungan.",
        "payload": {
          "inputs": [
            {"label": "Saham dalam 1 lot", "value": "100 saham"},
            {"label": "Harga ilustratif", "value": "Rp 8.550 per saham"},
            {"label": "Biaya sebelum biaya transaksi", "value": "Rp 855.000"}
          ],
          "steps": [
            "1 lot = 100 saham.",
            "100 × Rp 8.550 = Rp 855.000 sebelum biaya transaksi.",
            "Pembeli memiliki bagian kecil dari perusahaan, bukan jaminan keuntungan."
          ],
          "outcome": "Kepemilikan memberi paparan terhadap kinerja dan perubahan harga perusahaan. Keuntungan tidak dijamin."
        }
      }
    }$json$::jsonb),
    ('what-is-a-stock', 'concept', 'comparison', 20, 'illustrative', $json${
      "en": {
        "title": "Ownership is not a guarantee",
        "disclosure": "This comparison teaches a boundary; it is not investment advice.",
        "altText": "A comparison between what owning a stock means and what it does not promise.",
        "payload": {
          "leftTitle": "What ownership means",
          "rightTitle": "What it does not promise",
          "rows": [
            {"left": "You own a small stake in the company.", "right": "A guaranteed profit."},
            {"left": "Your result can change with the company and market.", "right": "That the price will rise tomorrow."},
            {"left": "You can study evidence before deciding.", "right": "That a famous company is always a good buy."}
          ]
        }
      },
      "id": {
        "title": "Kepemilikan bukan jaminan",
        "disclosure": "Perbandingan ini menjelaskan batas konsep; ini bukan saran investasi.",
        "altText": "Perbandingan antara arti memiliki saham dan hal yang tidak dijanjikan oleh kepemilikan saham.",
        "payload": {
          "leftTitle": "Arti kepemilikan",
          "rightTitle": "Yang tidak dijanjikan",
          "rows": [
            {"left": "Kamu memiliki bagian kecil dari perusahaan.", "right": "Keuntungan yang dijamin."},
            {"left": "Hasilmu bisa berubah mengikuti perusahaan dan pasar.", "right": "Harga pasti naik besok."},
            {"left": "Kamu bisa mempelajari bukti sebelum memutuskan.", "right": "Perusahaan terkenal selalu menjadi pembelian yang baik."}
          ]
        }
      }
    }$json$::jsonb),
    ('idx-basics-101', 'concept', 'process', 10, 'illustrative', $json${
      "en": {
        "eyebrow": "A simple IDX order path",
        "title": "From a rule to a lot-sized order",
        "disclosure": "Simplified learning flow — actual orders also depend on the exchange member, market session, price, fees, and applicable rules.",
        "altText": "A four-step process showing an investor checking the route, using 100-share lots, calculating the amount, and reviewing the order before placing it.",
        "payload": {
          "steps": [
            {"title": "1. Use the proper route", "description": "Use an exchange-member account and verify the relevant institution when needed."},
            {"title": "2. Convert to lots", "description": "On the regular and cash market, 1 lot is 100 shares."},
            {"title": "3. Calculate", "description": "Multiply the share price by the number of shares, then allow for fees."},
            {"title": "4. Review", "description": "Check symbol, side, quantity, price, and the current market rule before submitting."}
          ]
        }
      },
      "id": {
        "eyebrow": "Alur sederhana pesanan IDX",
        "title": "Dari aturan ke pesanan dalam lot",
        "disclosure": "Alur sederhana untuk belajar — pesanan nyata juga bergantung pada anggota bursa, sesi pasar, harga, biaya, dan aturan yang berlaku.",
        "altText": "Proses empat langkah yang menunjukkan investor memeriksa jalur, menggunakan lot 100 saham, menghitung jumlah, dan meninjau pesanan sebelum mengirimkannya.",
        "payload": {
          "steps": [
            {"title": "1. Gunakan jalur yang tepat", "description": "Gunakan rekening pada anggota bursa dan verifikasi lembaga terkait bila diperlukan."},
            {"title": "2. Ubah menjadi lot", "description": "Di pasar reguler dan tunai, 1 lot berisi 100 saham."},
            {"title": "3. Hitung", "description": "Kalikan harga saham dengan jumlah saham, lalu sisihkan biaya transaksi."},
            {"title": "4. Tinjau", "description": "Periksa simbol, sisi transaksi, jumlah, harga, dan aturan pasar saat ini sebelum mengirim."}
          ]
        }
      }
    }$json$::jsonb),
    ('idx-basics-101', 'concept', 'worked_example', 20, 'calculated', $json${
      "en": {
        "title": "Lot size changes the calculation",
        "disclosure": "Illustrative calculation before fees — not an order instruction or current TLKM quote.",
        "altText": "A calculation showing an illustrative TLKM price multiplied by one lot and two lots.",
        "payload": {
          "inputs": [
            {"label": "Illustrative price", "value": "Rp 3,800 per share"},
            {"label": "1 lot", "value": "100 shares"},
            {"label": "2 lots", "value": "200 shares"}
          ],
          "steps": [
            "1 lot: 100 × Rp 3,800 = Rp 380,000.",
            "2 lots: 200 × Rp 3,800 = Rp 760,000.",
            "Fees and the applicable market rules still need to be checked."
          ],
          "outcome": "A lot rule determines the share quantity in the calculation; it does not determine whether the investment is suitable."
        }
      },
      "id": {
        "title": "Ukuran lot mengubah perhitungan",
        "disclosure": "Perhitungan ilustratif sebelum biaya — bukan instruksi pesanan atau kutipan TLKM saat ini.",
        "altText": "Perhitungan yang menunjukkan harga TLKM ilustratif dikalikan dengan satu lot dan dua lot.",
        "payload": {
          "inputs": [
            {"label": "Harga ilustratif", "value": "Rp 3.800 per saham"},
            {"label": "1 lot", "value": "100 saham"},
            {"label": "2 lot", "value": "200 saham"}
          ],
          "steps": [
            "1 lot: 100 × Rp 3.800 = Rp 380.000.",
            "2 lot: 200 × Rp 3.800 = Rp 760.000.",
            "Biaya transaksi dan aturan pasar yang berlaku tetap perlu diperiksa."
          ],
          "outcome": "Aturan lot menentukan jumlah saham dalam perhitungan; aturan itu tidak menentukan apakah investasi tersebut cocok."
        }
      }
    }$json$::jsonb),
    ('portfolio-thinking', 'concept', 'comparison', 10, 'illustrative', $json${
      "en": {
        "eyebrow": "Portfolio lens",
        "title": "The right question is: when do you need the money?",
        "disclosure": "Illustrative learning comparison — not a personal allocation recommendation.",
        "altText": "A comparison of short, medium, and long goal horizons with example asset characteristics and a reminder that the mix is not universal.",
        "payload": {
          "leftTitle": "Shorter horizon",
          "rightTitle": "Longer horizon",
          "rows": [
            {"left": "Need access sooner.", "right": "Can wait through more ups and downs."},
            {"left": "Prioritise liquidity and stability.", "right": "May include more growth-oriented assets."},
            {"left": "A mix is still a personal decision.", "right": "Time horizon does not remove investment risk."}
          ]
        }
      },
      "id": {
        "eyebrow": "Cara melihat portofolio",
        "title": "Pertanyaan utamanya: kapan uang ini dibutuhkan?",
        "disclosure": "Perbandingan ilustratif untuk belajar — bukan rekomendasi alokasi pribadi.",
        "altText": "Perbandingan tujuan jangka pendek, menengah, dan panjang dengan contoh karakteristik aset serta pengingat bahwa komposisinya tidak universal.",
        "payload": {
          "leftTitle": "Jangka lebih pendek",
          "rightTitle": "Jangka lebih panjang",
          "rows": [
            {"left": "Uang lebih cepat dibutuhkan.", "right": "Bisa menunggu melewati lebih banyak naik turun."},
            {"left": "Utamakan likuiditas dan kestabilan.", "right": "Bisa mencakup lebih banyak aset yang berpotensi tumbuh."},
            {"left": "Komposisi tetap merupakan keputusan pribadi.", "right": "Jangka waktu tidak menghapus risiko investasi."}
          ]
        }
      }
    }$json$::jsonb),
    ('portfolio-thinking', 'concept', 'worked_example', 20, 'calculated', $json${
      "en": {
        "title": "See the whole Rp 10 million picture",
        "disclosure": "Illustrative allocation arithmetic — not a suggested portfolio for any person.",
        "altText": "A worked example dividing an illustrative ten million rupiah total across emergency cash, a one-year goal, and one stock, followed by a diversification question.",
        "payload": {
          "inputs": [
            {"label": "Total example portfolio", "value": "Rp 10,000,000"},
            {"label": "Emergency savings", "value": "Rp 3,000,000"},
            {"label": "One-year goal", "value": "Rp 4,000,000"},
            {"label": "One stock", "value": "Rp 3,000,000"}
          ],
          "steps": [
            "Add every holding to see the whole portfolio.",
            "Match each amount to the goal and time horizon it serves.",
            "Ask whether one stock creates concentration risk."
          ],
          "outcome": "Portfolio thinking changes the question from “Is this asset good?” to “How does the whole mix serve the goal?”"
        }
      },
      "id": {
        "title": "Lihat keseluruhan Rp 10 juta",
        "disclosure": "Perhitungan alokasi ilustratif — bukan saran portofolio untuk siapa pun.",
        "altText": "Contoh pembagian total ilustratif sepuluh juta rupiah untuk dana darurat, tujuan satu tahun, dan satu saham, lalu pertanyaan tentang diversifikasi.",
        "payload": {
          "inputs": [
            {"label": "Total portofolio contoh", "value": "Rp 10.000.000"},
            {"label": "Tabungan darurat", "value": "Rp 3.000.000"},
            {"label": "Tujuan satu tahun", "value": "Rp 4.000.000"},
            {"label": "Satu saham", "value": "Rp 3.000.000"}
          ],
          "steps": [
            "Jumlahkan semua kepemilikan untuk melihat seluruh portofolio.",
            "Hubungkan setiap jumlah dengan tujuan dan jangka waktu yang dilayaninya.",
            "Tanyakan apakah satu saham menciptakan risiko konsentrasi."
          ],
          "outcome": "Cara berpikir portofolio mengubah pertanyaan dari “Apakah aset ini bagus?” menjadi “Bagaimana keseluruhan komposisi membantu tujuan?”"
        }
      }
    }$json$::jsonb)
)
INSERT INTO public.lesson_visual_blocks (lesson_id, placement, block_type, display_order, data_status, content, is_published)
SELECT approved_lessons.id, blocks.placement, blocks.block_type, blocks.display_order,
       blocks.data_status, blocks.content, TRUE
FROM blocks
JOIN approved_lessons ON approved_lessons.slug = blocks.slug
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = TRUE,
  updated_at = NOW();

WITH sources(slug, display_order, source_code) AS (
  VALUES
    ('what-is-a-stock', 10, 'CH08-OJK-CAPITAL'), ('what-is-a-stock', 10, 'CH08-IDX-STOCKS'),
    ('idx-basics-101', 10, 'CH08-IDX-TRADING'), ('idx-basics-101', 20, 'CH08-IDX-TRADING'),
    ('portfolio-thinking', 10, 'CH08-OJK-CAPITAL'), ('portfolio-thinking', 20, 'CH08-OJK-CAPITAL')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM sources
JOIN public.lessons AS lesson ON lesson.slug = sources.slug
JOIN public.lesson_visual_blocks AS block
  ON block.lesson_id = lesson.id AND block.display_order = sources.display_order
JOIN public.sources AS source ON source.source_code = sources.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

WITH applied_questions(slug, body, body_id) AS (
  VALUES
    ('what-is-a-stock', $json${
      "type": "multiple_choice",
      "question": "In the illustrative example, what does buying one lot of shares mean?",
      "options": ["A small ownership stake, with no guaranteed profit.", "A guaranteed return from the company.", "Control of the whole company.", "A promise that the price rises tomorrow."],
      "answer": "A small ownership stake, with no guaranteed profit.",
      "difficulty": "beginner",
      "explanation": "A share represents a small ownership stake. The value can change, and a profit is never guaranteed."
    }$json$::jsonb, $json${
      "type": "multiple_choice",
      "question": "Dalam contoh ilustratif, apa arti membeli satu lot saham?",
      "options": ["Bagian kecil dari kepemilikan, tanpa keuntungan yang dijamin.", "Imbal hasil yang dijamin dari perusahaan.", "Kendali atas seluruh perusahaan.", "Jaminan harga naik besok."],
      "answer": "Bagian kecil dari kepemilikan, tanpa keuntungan yang dijamin.",
      "difficulty": "beginner",
      "explanation": "Saham mewakili bagian kecil dari kepemilikan. Nilainya bisa berubah dan keuntungan tidak pernah dijamin."
    }$json$::jsonb),
    ('idx-basics-101', $json${
      "type": "multiple_choice",
      "question": "At the illustrative price of Rp 3,800, what is the before-fee cost of two IDX lots?",
      "options": ["Rp 760,000", "Rp 380,000", "Rp 38,000", "Rp 7,600,000"],
      "answer": "Rp 760,000",
      "difficulty": "beginner",
      "explanation": "Two lots are 200 shares. 200 × Rp 3,800 = Rp 760,000 before fees."
    }$json$::jsonb, $json${
      "type": "multiple_choice",
      "question": "Dengan harga ilustratif Rp 3.800, berapa biaya sebelum biaya transaksi untuk dua lot IDX?",
      "options": ["Rp 760.000", "Rp 380.000", "Rp 38.000", "Rp 7.600.000"],
      "answer": "Rp 760.000",
      "difficulty": "beginner",
      "explanation": "Dua lot berarti 200 saham. 200 × Rp 3.800 = Rp 760.000 sebelum biaya transaksi."
    }$json$::jsonb),
    ('portfolio-thinking', $json${
      "type": "multiple_choice",
      "question": "What should guide a portfolio mix in the illustrative comparison?",
      "options": ["The goal and when the money is needed.", "The same mix for everyone.", "The most popular stock this week.", "A promise of the highest return."],
      "answer": "The goal and when the money is needed.",
      "difficulty": "intermediate",
      "explanation": "Portfolio thinking starts with the whole goal, time horizon, liquidity needs, and risk—not a universal mix or a promised return."
    }$json$::jsonb, $json${
      "type": "multiple_choice",
      "question": "Apa yang seharusnya memandu komposisi portofolio dalam perbandingan ilustratif?",
      "options": ["Tujuan dan kapan uang itu dibutuhkan.", "Komposisi yang sama untuk semua orang.", "Saham yang paling populer minggu ini.", "Janji imbal hasil tertinggi."],
      "answer": "Tujuan dan kapan uang itu dibutuhkan.",
      "difficulty": "intermediate",
      "explanation": "Cara berpikir portofolio dimulai dari tujuan, jangka waktu, kebutuhan likuiditas, dan risiko—bukan komposisi universal atau imbal hasil yang dijanjikan."
    }$json$::jsonb)
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied_questions.body, applied_questions.body_id, 'intermediate', 'visual_applied', TRUE
FROM applied_questions
JOIN public.lessons AS lesson ON lesson.slug = applied_questions.slug
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants AS existing
  WHERE existing.lesson_id = lesson.id AND existing.topic_tag = 'visual_applied'
);

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (
  VALUES
    ('what-is-a-stock', 'Five days ago, you learned that a share is ownership exposure. What is not guaranteed?', 'Lima hari lalu, kamu belajar bahwa saham memberi paparan kepemilikan. Apa yang tidak dijamin?',
      $json$[{"id":"no_guaranteed_profit","label":"A profit or a price increase"},{"id":"small_stake","label":"A small ownership stake"},{"id":"company_exposure","label":"Exposure to company results"}]$json$::jsonb,
      $json$[{"id":"no_guaranteed_profit","label":"Keuntungan atau kenaikan harga"},{"id":"small_stake","label":"Bagian kecil dari kepemilikan"},{"id":"company_exposure","label":"Paparan terhadap kinerja perusahaan"}]$json$::jsonb,
      'no_guaranteed_profit', 'Ownership does not guarantee a profit or a price increase.', 'Kepemilikan tidak menjamin keuntungan atau kenaikan harga.'),
    ('idx-basics-101', 'Five days ago, you learned that 1 lot on IDX is 100 shares. How many shares are in 2 lots?', 'Lima hari lalu, kamu belajar bahwa 1 lot di IDX berisi 100 saham. Berapa saham dalam 2 lot?',
      $json$[{"id":"200","label":"200 shares"},{"id":"100","label":"100 shares"},{"id":"20","label":"20 shares"}]$json$::jsonb,
      $json$[{"id":"200","label":"200 saham"},{"id":"100","label":"100 saham"},{"id":"20","label":"20 saham"}]$json$::jsonb,
      '200', 'Two lots × 100 shares = 200 shares.', 'Dua lot × 100 saham = 200 saham.'),
    ('portfolio-thinking', 'Five days ago, you learned to view the whole portfolio. What should the mix respond to?', 'Lima hari lalu, kamu belajar melihat seluruh portofolio. Komposisinya sebaiknya menanggapi apa?',
      $json$[{"id":"goal_horizon","label":"Goal, time horizon, liquidity, and risk"},{"id":"popularity","label":"What is most popular"},{"id":"guarantee","label":"A guaranteed return"}]$json$::jsonb,
      $json$[{"id":"goal_horizon","label":"Tujuan, jangka waktu, likuiditas, dan risiko"},{"id":"popularity","label":"Yang paling populer"},{"id":"guarantee","label":"Imbal hasil yang dijamin"}]$json$::jsonb,
      'goal_horizon', 'A portfolio mix should be considered against goals, time horizon, liquidity, and risk.', 'Komposisi portofolio perlu dipertimbangkan terhadap tujuan, jangka waktu, likuiditas, dan risiko.')
)
INSERT INTO public.lesson_recall_questions (lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
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
