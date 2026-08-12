-- KO-441: Make Chapter 11 recall checks selectable and useful.
-- This is a forward-only repair for the already-applied KO-440 migration.
BEGIN;

WITH r(slug, options_en, options_id, correct_en, correct_id) AS (VALUES
  ('decision-multicandle-context', jsonb_build_array('It shows developing context while remaining uncertain','It guarantees the next candle','It replaces the need for a plan','It proves the trend will continue'), jsonb_build_array('Menunjukkan konteks berkembang tetapi tetap tidak pasti','Menjamin candle berikutnya','Menggantikan kebutuhan akan rencana','Membuktikan tren akan berlanjut'), 'It shows developing context while remaining uncertain', 'Menunjukkan konteks berkembang tetapi tetap tidak pasti'),
  ('decision-volume-confirmation', jsonb_build_array('A reason to investigate context','A guarantee that price will rise','Proof that the company is undervalued','A substitute for checking the timeframe'), jsonb_build_array('Alasan memeriksa konteks','Jaminan bahwa harga akan naik','Bukti bahwa perusahaan undervalued','Pengganti pemeriksaan timeframe'), 'A reason to investigate context', 'Alasan memeriksa konteks'),
  ('decision-zones-false-breakouts', jsonb_build_array('Evidence to inspect, not a guaranteed reversal','Proof that the zone no longer matters','A signal to ignore other evidence','A guarantee of a profitable exit'), jsonb_build_array('Bukti untuk diperiksa, bukan pembalikan yang dijamin','Bukti bahwa zona tidak lagi penting','Sinyal untuk mengabaikan bukti lain','Jaminan exit yang menguntungkan'), 'Evidence to inspect, not a guaranteed reversal', 'Bukti untuk diperiksa, bukan pembalikan yang dijamin'),
  ('decision-timeframe-comparison', jsonb_build_array('Each lens exposes different detail and context','The longer timeframe removes uncertainty','The shorter timeframe predicts the weekly close','One timeframe must be objectively correct'), jsonb_build_array('Setiap lensa menunjukkan detail dan konteks berbeda','Timeframe lebih panjang menghapus ketidakpastian','Timeframe lebih pendek memprediksi penutupan mingguan','Satu timeframe pasti benar secara objektif'), 'Each lens exposes different detail and context', 'Setiap lensa menunjukkan detail dan konteks berbeda'),
  ('decision-risk-reward', jsonb_build_array('Whether either outcome will happen','The size of the scenarios being compared','The fees and taxes for a specific account','The probability of success'), jsonb_build_array('Apakah salah satu hasil akan terjadi','Besaran skenario yang dibandingkan','Biaya dan pajak akun tertentu','Probabilitas keberhasilan'), 'Whether either outcome will happen', 'Apakah salah satu hasil akan terjadi'),
  ('decision-position-sizing', jsonb_build_array('The amount exposed if the idea is wrong','The chance that the idea is correct','A guarantee against all losses','The right position for every investor'), jsonb_build_array('Jumlah yang terekspos jika ide salah','Peluang bahwa ide benar','Jaminan terhadap semua kerugian','Posisi yang tepat untuk semua investor'), 'The amount exposed if the idea is wrong', 'Jumlah yang terekspos jika ide salah'),
  ('decision-bias-and-narratives', jsonb_build_array('Write evidence that could weaken the belief','Collect only sources that agree','Treat confidence as evidence','Avoid official sources that add nuance'), jsonb_build_array('Tuliskan bukti yang dapat melemahkan keyakinan','Kumpulkan hanya sumber yang setuju','Anggap keyakinan sebagai bukti','Hindari sumber resmi yang menambah nuansa'), 'Write evidence that could weaken the belief', 'Tuliskan bukti yang dapat melemahkan keyakinan'),
  ('decision-thesis-invalidation', jsonb_build_array('Defines evidence that triggers reassessment','Guarantees that the thesis will work','Changes after every price move','Explains every possible outcome in advance'), jsonb_build_array('Menentukan bukti yang memicu penilaian ulang','Menjamin tesis akan berhasil','Berubah setelah setiap pergerakan harga','Menjelaskan semua hasil yang mungkin sebelumnya'), 'Defines evidence that triggers reassessment', 'Menentukan bukti yang memicu penilaian ulang')
)
UPDATE public.lesson_recall_questions q
SET options_en=(
      SELECT jsonb_agg(jsonb_build_object('id',format('option_%s',e.ordinality),'label',e.value) ORDER BY e.ordinality)
      FROM jsonb_array_elements_text(r.options_en) WITH ORDINALITY AS e(value,ordinality)
    ),
    options_id=(
      SELECT jsonb_agg(jsonb_build_object('id',format('option_%s',i.ordinality),'label',i.value) ORDER BY i.ordinality)
      FROM jsonb_array_elements_text(r.options_id) WITH ORDINALITY AS i(value,ordinality)
    ),
    correct_option='option_1',
    updated_at=NOW()
FROM r
JOIN public.lessons l ON l.slug=r.slug AND l.is_published
WHERE q.lesson_id=l.id AND q.is_active;

DO $$
DECLARE invalid_count INT;
BEGIN
  SELECT COUNT(*) INTO invalid_count
  FROM public.lesson_recall_questions q
  JOIN public.lessons l ON l.id=q.lesson_id
  JOIN public.topics t ON t.id=l.topic_id
  WHERE t.chapter='Decision Analysis Lab'
    AND l.is_published
    AND q.is_active
    AND (
      jsonb_array_length(q.options_en)<3
      OR jsonb_array_length(q.options_id)<3
      OR NOT EXISTS (
        SELECT 1 FROM jsonb_array_elements(q.options_en) option_row
        WHERE option_row->>'id'=q.correct_option
      )
      OR NOT EXISTS (
        SELECT 1 FROM jsonb_array_elements(q.options_en) option_row
        WHERE jsonb_typeof(option_row)='object' AND jsonb_typeof(option_row->'label')='string'
      )
    );
  IF invalid_count<>0 THEN
    RAISE EXCEPTION 'KO-441 recall coverage mismatch: % invalid rows', invalid_count;
  END IF;
END $$;

COMMIT;
