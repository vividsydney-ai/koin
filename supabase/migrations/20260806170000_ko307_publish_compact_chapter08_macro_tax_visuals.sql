-- KO-307: publish the second compact Chapter 08 visual batch.
-- Tax and macro examples are labelled to avoid presenting changing values as
-- timeless facts.

BEGIN;

WITH approved_lessons AS (
  SELECT l.id, l.slug
  FROM public.lessons AS l
  JOIN public.lesson_reviews AS review ON review.lesson_id = l.id
  WHERE l.slug IN ('taxes-on-returns', 'macro-indicators')
    AND l.is_published = TRUE
    AND review.approved_to_publish = TRUE
), blocks(slug, placement, block_type, display_order, data_status, content) AS (
  VALUES
    ('taxes-on-returns', 'concept', 'worked_example', 10, 'calculated', $json${
      "en": {
        "eyebrow": "Illustrative net-return example",
        "title": "Compare what you keep, not only the headline",
        "disclosure": "Illustrative arithmetic only — tax treatment and rates depend on the instrument, taxpayer, and current rules.",
        "altText": "A worked example showing a gross return, an explicitly illustrative tax amount, and the resulting net amount.",
        "payload": {
          "inputs": [
            {"label": "Gross dividend example", "value": "Rp 1,000,000"},
            {"label": "Illustrative tax amount", "value": "Rp 100,000"},
            {"label": "Net amount in this example", "value": "Rp 900,000"}
          ],
          "steps": [
            "Start with the gross amount shown by the product or statement.",
            "Subtract the tax amount that applies to that example.",
            "Compare the net amount, while checking the current official rule."
          ],
          "outcome": "A headline return is not automatically the amount the investor keeps."
        }
      },
      "id": {
        "eyebrow": "Contoh imbal hasil bersih ilustratif",
        "title": "Bandingkan yang kamu terima, bukan hanya angka utama",
        "disclosure": "Perhitungan ilustratif saja — perlakuan dan tarif pajak bergantung pada instrumen, wajib pajak, dan aturan yang berlaku.",
        "altText": "Contoh perhitungan yang menunjukkan imbal hasil kotor, jumlah pajak yang secara eksplisit bersifat ilustratif, dan jumlah bersih yang tersisa.",
        "payload": {
          "inputs": [
            {"label": "Contoh dividen kotor", "value": "Rp 1.000.000"},
            {"label": "Jumlah pajak ilustratif", "value": "Rp 100.000"},
            {"label": "Jumlah bersih dalam contoh", "value": "Rp 900.000"}
          ],
          "steps": [
            "Mulai dari jumlah kotor yang tercantum pada produk atau laporan.",
            "Kurangi jumlah pajak yang berlaku untuk contoh tersebut.",
            "Bandingkan jumlah bersih sambil memeriksa aturan resmi terbaru."
          ],
          "outcome": "Imbal hasil yang diiklankan tidak otomatis sama dengan jumlah yang diterima investor."
        }
      }
    }$json$::jsonb),
    ('taxes-on-returns', 'concept', 'comparison', 20, 'illustrative', $json${
      "en": {
        "title": "Gross return versus net return",
        "disclosure": "A teaching boundary, not a universal tax calculation.",
        "altText": "A two-column comparison between a gross return headline and the questions needed to understand the net return.",
        "payload": {
          "leftTitle": "Headline amount",
          "rightTitle": "Questions before comparing",
          "rows": [
            {"left": "The return before deductions.", "right": "Which instrument and rule apply?"},
            {"left": "Easy to compare at a glance.", "right": "What amount is actually received?"},
            {"left": "May use a historical or illustrative figure.", "right": "When was the rule checked?"}
          ]
        }
      },
      "id": {
        "title": "Imbal hasil kotor dan bersih",
        "disclosure": "Batas belajar, bukan perhitungan pajak universal.",
        "altText": "Perbandingan dua kolom antara angka imbal hasil kotor dan pertanyaan yang diperlukan untuk memahami imbal hasil bersih.",
        "payload": {
          "leftTitle": "Jumlah utama",
          "rightTitle": "Pertanyaan sebelum membandingkan",
          "rows": [
            {"left": "Imbal hasil sebelum potongan.", "right": "Instrumen dan aturan mana yang berlaku?"},
            {"left": "Mudah dibandingkan sekilas.", "right": "Berapa jumlah yang benar-benar diterima?"},
            {"left": "Bisa memakai angka historis atau ilustratif.", "right": "Kapan aturan tersebut diperiksa?"}
          ]
        }
      }
    }$json$::jsonb),
    ('macro-indicators', 'concept', 'comparison', 10, 'source_derived', $json${
      "en": {
        "eyebrow": "Three signals, three channels",
        "title": "Macro indicators affect your context, not your certainty",
        "altText": "A comparison of BI Rate, inflation, and the exchange rate with their broad household or market channels, without a price prediction.",
        "payload": {
          "leftTitle": "Signal",
          "rightTitle": "A channel to understand",
          "rows": [
            {"left": "BI Rate", "right": "Can influence borrowing and saving conditions."},
            {"left": "Inflation", "right": "Changes what the same rupiah can buy over time."},
            {"left": "Exchange rate", "right": "Can affect imported costs and purchasing power."}
          ]
        }
      },
      "id": {
        "eyebrow": "Tiga sinyal, tiga jalur dampak",
        "title": "Indikator makro memengaruhi konteks, bukan kepastian",
        "altText": "Perbandingan BI-Rate, inflasi, dan nilai tukar dengan jalur dampak luas pada rumah tangga atau pasar, tanpa prediksi harga.",
        "payload": {
          "leftTitle": "Sinyal",
          "rightTitle": "Jalur yang perlu dipahami",
          "rows": [
            {"left": "BI-Rate", "right": "Bisa memengaruhi kondisi pinjaman dan tabungan."},
            {"left": "Inflasi", "right": "Mengubah daya beli rupiah yang sama dari waktu ke waktu."},
            {"left": "Nilai tukar", "right": "Bisa memengaruhi biaya impor dan daya beli."}
          ]
        }
      }
    }$json$::jsonb),
    ('macro-indicators', 'concept', 'worked_example', 20, 'illustrative', $json${
      "en": {
        "title": "Follow the chain, then stop before a prediction",
        "disclosure": "Illustrative reasoning chain — it does not forecast a stock or tell you when to trade.",
        "altText": "A worked reasoning chain from a macro signal to a possible household effect, ending with a reminder to investigate rather than predict.",
        "payload": {
          "inputs": [
            {"label": "Illustrative signal", "value": "Rupiah weakens against the US dollar"},
            {"label": "Possible channel", "value": "Some imported goods cost more"},
            {"label": "Learner question", "value": "What evidence should I check next?"}
          ],
          "steps": [
            "Name the signal and its source date.",
            "Trace one plausible channel to households or businesses.",
            "Separate a possible effect from a guaranteed market outcome."
          ],
          "outcome": "Macro literacy helps you ask better questions; it does not turn one indicator into a timing signal."
        }
      },
      "id": {
        "title": "Ikuti jalurnya, lalu berhenti sebelum memprediksi",
        "disclosure": "Rangkaian penalaran ilustratif — tidak meramalkan saham atau memberi tahu kapan harus bertransaksi.",
        "altText": "Rangkaian penalaran yang menunjukkan sinyal makro menuju kemungkinan dampak rumah tangga, lalu mengingatkan untuk meneliti bukan memprediksi.",
        "payload": {
          "inputs": [
            {"label": "Sinyal ilustratif", "value": "Rupiah melemah terhadap dolar AS"},
            {"label": "Jalur yang mungkin", "value": "Sebagian barang impor menjadi lebih mahal"},
            {"label": "Pertanyaan pelajar", "value": "Bukti apa yang perlu saya periksa berikutnya?"}
          ],
          "steps": [
            "Sebutkan sinyal dan tanggal sumbernya.",
            "Telusuri satu jalur dampak yang masuk akal ke rumah tangga atau bisnis.",
            "Pisahkan kemungkinan dampak dari hasil pasar yang pasti."
          ],
          "outcome": "Literasi makro membantu kamu mengajukan pertanyaan yang lebih baik; satu indikator bukan sinyal waktu transaksi."
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
    ('taxes-on-returns', 10, 'CH08-DJP-PPH21'), ('taxes-on-returns', 20, 'CH08-DJP-PPH21'),
    ('macro-indicators', 10, 'CH08-BI-RATE'), ('macro-indicators', 10, 'CH08-BI-INFLATION'), ('macro-indicators', 10, 'CH08-BI-JISDOR'),
    ('macro-indicators', 20, 'CH08-BI-JISDOR')
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
    ('taxes-on-returns', $json${
      "type": "multiple_choice",
      "question": "Why should you compare net returns as well as headline returns?",
      "options": ["The amount kept can differ after applicable tax.", "The headline return is always wrong.", "Tax never changes by instrument.", "A gross return guarantees the final amount."],
      "answer": "The amount kept can differ after applicable tax.",
      "difficulty": "intermediate",
      "explanation": "Tax treatment can affect what an investor keeps. The current rule and the instrument must be checked."
    }$json$::jsonb, $json${
      "type": "multiple_choice",
      "question": "Mengapa kamu perlu membandingkan imbal hasil bersih selain angka utama?",
      "options": ["Jumlah yang diterima bisa berbeda setelah pajak yang berlaku.", "Angka utama selalu salah.", "Pajak tidak pernah berbeda antar-instrumen.", "Imbal hasil kotor menjamin jumlah akhir."],
      "answer": "Jumlah yang diterima bisa berbeda setelah pajak yang berlaku.",
      "difficulty": "intermediate",
      "explanation": "Perlakuan pajak dapat memengaruhi jumlah yang diterima investor. Aturan terbaru dan instrumennya perlu diperiksa."
    }$json$::jsonb),
    ('macro-indicators', $json${
      "type": "multiple_choice",
      "question": "What is the safest conclusion from one macro indicator?",
      "options": ["It can help explain a channel, but it does not predict a stock or guarantee an outcome.", "It tells you exactly when to buy.", "It proves every stock will move the same way.", "It guarantees your purchasing power rises."],
      "answer": "It can help explain a channel, but it does not predict a stock or guarantee an outcome.",
      "difficulty": "intermediate",
      "explanation": "Macro indicators provide context. They should lead to better questions, not a guaranteed timing signal."
    }$json$::jsonb, $json${
      "type": "multiple_choice",
      "question": "Apa kesimpulan paling aman dari satu indikator makro?",
      "options": ["Indikator dapat menjelaskan satu jalur dampak, tetapi tidak memprediksi saham atau menjamin hasil.", "Indikator memberi tahu tepat kapan harus membeli.", "Indikator membuktikan semua saham bergerak sama.", "Indikator menjamin daya belimu naik."],
      "answer": "Indikator dapat menjelaskan satu jalur dampak, tetapi tidak memprediksi saham atau menjamin hasil.",
      "difficulty": "intermediate",
      "explanation": "Indikator makro memberi konteks. Indikator seharusnya memunculkan pertanyaan yang lebih baik, bukan sinyal waktu yang dijamin."
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
    ('taxes-on-returns', 'Five days ago, you learned to compare net returns. What must you check before treating a tax example as your own result?', 'Lima hari lalu, kamu belajar membandingkan imbal hasil bersih. Apa yang harus diperiksa sebelum menganggap contoh pajak berlaku untuk hasilmu?',
      $json$[{"id":"current_rule","label":"The current rule and instrument"},{"id":"headline_only","label":"Only the advertised number"},{"id":"guarantee","label":"A guaranteed tax outcome"}]$json$::jsonb,
      $json$[{"id":"current_rule","label":"Aturan terbaru dan instrumennya"},{"id":"headline_only","label":"Hanya angka yang diiklankan"},{"id":"guarantee","label":"Hasil pajak yang dijamin"}]$json$::jsonb,
      'current_rule', 'Tax treatment depends on the applicable current rule and instrument.', 'Perlakuan pajak bergantung pada aturan terbaru yang berlaku dan instrumennya.'),
    ('macro-indicators', 'Five days ago, you learned that macro signals add context. What should one indicator not become?', 'Lima hari lalu, kamu belajar bahwa sinyal makro memberi konteks. Satu indikator tidak boleh berubah menjadi apa?',
      $json$[{"id":"timing_signal","label":"A guaranteed timing signal"},{"id":"question","label":"A question to investigate"},{"id":"context","label":"Context for household effects"}]$json$::jsonb,
      $json$[{"id":"timing_signal","label":"Sinyal waktu yang dijamin"},{"id":"question","label":"Pertanyaan untuk diteliti"},{"id":"context","label":"Konteks untuk dampak rumah tangga"}]$json$::jsonb,
      'timing_signal', 'One macro indicator does not guarantee a price direction or trading timing.', 'Satu indikator makro tidak menjamin arah harga atau waktu transaksi.')
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
