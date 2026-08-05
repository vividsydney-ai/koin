-- KO-298: publish the bilingual Reading a Stock Page visual pilot.
-- Every number below is deliberately illustrative. It is not market data,
-- a price target, or an execution signal.

BEGIN;

WITH approved_lesson AS (
  SELECT l.id
  FROM public.lessons AS l
  JOIN public.lesson_reviews AS review ON review.lesson_id = l.id
  WHERE l.slug = 'reading-a-stock-page'
    AND l.is_published = TRUE
    AND review.approved_to_publish = TRUE
)
INSERT INTO public.lesson_visual_blocks (
  lesson_id, placement, block_type, display_order, data_status, content, is_published
)
SELECT
  approved_lesson.id,
  'concept',
  'annotated_data',
  10,
  'illustrative',
  $json${
    "en": {
      "eyebrow": "Illustrative quote",
      "title": "A stock page is a record of activity",
      "disclosure": "Illustrative values for learning only — not live data, a price target, or a buy signal.",
      "altText": "An illustrative CNTO stock quote with open, high, low, close, volume, market cap, and a numbered legend explaining each field.",
      "payload": {
        "quoteTitle": "PT Contoh Nusantara · CNTO",
        "price": "Rp 1,240",
        "change": "+1.6% today",
        "fields": [
          {"label": "Open", "value": "Rp 1,220", "note": "where trading started"},
          {"label": "High", "value": "Rp 1,260", "note": "highest trade today"},
          {"label": "Low", "value": "Rp 1,210", "note": "lowest trade today"},
          {"label": "Close", "value": "Rp 1,240", "note": "last trade before close"},
          {"label": "Volume", "value": "8.4m", "note": "shares that changed hands"},
          {"label": "Market cap", "value": "Rp 12.4t", "note": "company size at this price"}
        ],
        "annotations": [
          {"number": 1, "label": "Open", "detail": "Start with the price when trading opened."},
          {"number": 2, "label": "High + Low", "detail": "Read them together as today’s price range."},
          {"number": 3, "label": "Close", "detail": "The last recorded price before the market closed."},
          {"number": 4, "label": "Volume", "detail": "How many shares changed hands today."},
          {"number": 5, "label": "Market cap", "detail": "A size cue, not a value verdict."}
        ]
      }
    },
    "id": {
      "eyebrow": "Kutipan ilustratif",
      "title": "Halaman saham adalah catatan aktivitas",
      "disclosure": "Nilai ilustratif untuk belajar — bukan data langsung, target harga, atau sinyal beli.",
      "altText": "Kutipan saham CNTO ilustratif dengan open, high, low, close, volume, kapitalisasi pasar, serta legenda bernomor yang menjelaskan setiap bidang.",
      "payload": {
        "quoteTitle": "PT Contoh Nusantara · CNTO",
        "price": "Rp 1.240",
        "change": "+1,6% hari ini",
        "fields": [
          {"label": "Open", "value": "Rp 1.220", "note": "harga saat perdagangan dibuka"},
          {"label": "High", "value": "Rp 1.260", "note": "harga tertinggi hari ini"},
          {"label": "Low", "value": "Rp 1.210", "note": "harga terendah hari ini"},
          {"label": "Close", "value": "Rp 1.240", "note": "harga terakhir sebelum pasar tutup"},
          {"label": "Volume", "value": "8,4 jt", "note": "saham yang berpindah tangan"},
          {"label": "Kapitalisasi pasar", "value": "Rp 12,4 T", "note": "ukuran perusahaan pada harga ini"}
        ],
        "annotations": [
          {"number": 1, "label": "Open", "detail": "Mulai dari harga saat perdagangan dibuka."},
          {"number": 2, "label": "High + Low", "detail": "Baca keduanya sebagai rentang harga hari ini."},
          {"number": 3, "label": "Close", "detail": "Harga terakhir yang tercatat sebelum pasar tutup."},
          {"number": 4, "label": "Volume", "detail": "Berapa banyak saham yang berpindah tangan hari ini."},
          {"number": 5, "label": "Kapitalisasi pasar", "detail": "Petunjuk ukuran, bukan putusan nilai."}
        ]
      }
    }
  }$json$::jsonb,
  TRUE
FROM approved_lesson
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = TRUE,
  updated_at = NOW();

WITH approved_lesson AS (
  SELECT l.id
  FROM public.lessons AS l
  JOIN public.lesson_reviews AS review ON review.lesson_id = l.id
  WHERE l.slug = 'reading-a-stock-page'
    AND l.is_published = TRUE
    AND review.approved_to_publish = TRUE
)
INSERT INTO public.lesson_visual_blocks (
  lesson_id, placement, block_type, display_order, data_status, content, is_published
)
SELECT
  approved_lesson.id,
  'concept',
  'comparison',
  20,
  'illustrative',
  $json${
    "en": {
      "title": "Read the facts, then pause",
      "disclosure": "These are learning boundaries, not trading advice.",
      "altText": "A two-column comparison of observations a stock quote supports and conclusions it does not support.",
      "payload": {
        "leftTitle": "What you can observe",
        "rightTitle": "What you still cannot conclude",
        "rows": [
          {"left": "Price moved within a Rp 50 range.", "right": "Whether the company is good or cheap."},
          {"left": "Many shares traded today.", "right": "Why people traded, or what happens tomorrow."},
          {"left": "The company is larger or smaller by market cap.", "right": "Whether this is a buy, sell, or hold."}
        ]
      }
    },
    "id": {
      "title": "Baca faktanya, lalu berhenti sejenak",
      "disclosure": "Ini adalah batas belajar, bukan saran bertransaksi.",
      "altText": "Perbandingan dua kolom antara pengamatan yang didukung oleh kutipan saham dan kesimpulan yang tidak didukungnya.",
      "payload": {
        "leftTitle": "Yang bisa kamu amati",
        "rightTitle": "Yang belum bisa kamu simpulkan",
        "rows": [
          {"left": "Harga bergerak dalam rentang Rp 50.", "right": "Apakah perusahaan bagus atau murah."},
          {"left": "Banyak saham diperdagangkan hari ini.", "right": "Mengapa orang bertransaksi atau apa yang terjadi besok."},
          {"left": "Ukuran perusahaan terlihat dari kapitalisasi pasar.", "right": "Apakah harus beli, jual, atau tahan."}
        ]
      }
    }
  }$json$::jsonb,
  TRUE
FROM approved_lesson
ON CONFLICT (lesson_id, placement, display_order) DO UPDATE SET
  block_type = EXCLUDED.block_type,
  data_status = EXCLUDED.data_status,
  content = EXCLUDED.content,
  is_published = TRUE,
  updated_at = NOW();

WITH approved_lesson AS (
  SELECT l.id
  FROM public.lessons AS l
  JOIN public.lesson_reviews AS review ON review.lesson_id = l.id
  WHERE l.slug = 'reading-a-stock-page'
    AND l.is_published = TRUE
    AND review.approved_to_publish = TRUE
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT
  approved_lesson.id,
  'question',
  $json${
    "type": "multiple_choice",
    "question": "The illustrative quote shows CNTO traded 8.4m shares today. Which conclusion is justified?",
    "options": ["More shares changed hands today.", "CNTO is definitely profitable.", "CNTO will rise tomorrow.", "CNTO is a good value to buy."],
    "answer": "More shares changed hands today.",
    "difficulty": "intermediate",
    "explanation": "Volume tells you how much changed hands. It does not prove company quality, future price movement, or a buy decision."
  }$json$::jsonb,
  $json${
    "type": "multiple_choice",
    "question": "Kutipan ilustratif menunjukkan 8,4 juta saham CNTO diperdagangkan hari ini. Kesimpulan mana yang didukung?",
    "options": ["Lebih banyak saham berpindah tangan hari ini.", "CNTO pasti menguntungkan.", "CNTO akan naik besok.", "CNTO pasti layak dibeli."],
    "answer": "Lebih banyak saham berpindah tangan hari ini.",
    "difficulty": "intermediate",
    "explanation": "Volume menunjukkan banyaknya saham yang berpindah tangan. Volume tidak membuktikan kualitas perusahaan, pergerakan harga berikutnya, atau keputusan beli."
  }$json$::jsonb,
  'intermediate',
  'visual_applied',
  TRUE
FROM approved_lesson
WHERE NOT EXISTS (
  SELECT 1 FROM public.content_variants
  WHERE lesson_id = approved_lesson.id AND topic_tag = 'visual_applied'
);

WITH approved_lesson AS (
  SELECT l.id
  FROM public.lessons AS l
  JOIN public.lesson_reviews AS review ON review.lesson_id = l.id
  WHERE l.slug = 'reading-a-stock-page'
    AND l.is_published = TRUE
    AND review.approved_to_publish = TRUE
)
INSERT INTO public.lesson_recall_questions (
  lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active
)
SELECT
  approved_lesson.id,
  'Five days ago, you learned that a large volume figure records trading activity. What can volume alone not tell you?',
  'Lima hari lalu, kamu belajar bahwa angka volume besar mencatat aktivitas perdagangan. Apa yang tidak dapat diberitahukan oleh volume saja?',
  $json$[{"id":"activity_not_quality","label":"Whether the company is good value or will rise next."},{"id":"shares_changed_hands","label":"How many shares changed hands."},{"id":"price_range","label":"That the day had a trading range."}]$json$::jsonb,
  $json$[{"id":"activity_not_quality","label":"Apakah perusahaan bernilai baik atau akan naik berikutnya."},{"id":"shares_changed_hands","label":"Berapa banyak saham yang berpindah tangan."},{"id":"price_range","label":"Bahwa hari itu memiliki rentang perdagangan."}]$json$::jsonb,
  'activity_not_quality',
  'Volume records activity, not company quality, future price movement, or a buy decision.',
  'Volume mencatat aktivitas, bukan kualitas perusahaan, pergerakan harga berikutnya, atau keputusan beli.',
  TRUE
FROM approved_lesson
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
