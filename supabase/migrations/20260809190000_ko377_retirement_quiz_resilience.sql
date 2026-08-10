-- KO-377: make the final Chapter 05 retirement lesson quiz resilient.
-- The visual lesson has a rotating question pool; these additional applied
-- checks keep that pool varied, while the lesson-level payload prevents an
-- empty Quick Check when the variant request is temporarily unavailable.

BEGIN;

WITH new_variants (body, body_id) AS (
  VALUES
    (
      $json${"type":"multiple_choice","difficulty":"beginner","question":"What is the safest way to read an illustration that compares starting retirement contributions at different ages?","options":["As one scenario whose assumptions and uncertainty should be checked","As a guaranteed future account balance","As proof that market risk has disappeared","As a reason to skip an emergency fund"],"answer":"As one scenario whose assumptions and uncertainty should be checked","explanation":"An illustration can show how time affects a scenario, but its inputs and future returns remain uncertain.","parameters":{"visual":"retirement-planning-start-early-compounding"}}$json$::jsonb,
      $json${"type":"multiple_choice","difficulty":"beginner","question":"Apa cara paling aman membaca ilustrasi yang membandingkan usia mulai kontribusi pensiun?","options":["Sebagai satu skenario yang asumsi dan ketidakpastiannya perlu diperiksa","Sebagai saldo masa depan yang dijamin","Sebagai bukti risiko pasar sudah hilang","Sebagai alasan untuk melewati dana darurat"],"answer":"Sebagai satu skenario yang asumsi dan ketidakpastiannya perlu diperiksa","explanation":"Ilustrasi dapat menunjukkan pengaruh waktu pada satu skenario, tetapi input dan imbal hasil masa depannya tetap tidak pasti.","parameters":{"visual":"retirement-planning-start-early-compounding"}}$json$::jsonb
    ),
    (
      $json${"type":"true_false","difficulty":"beginner","question":"A retirement contribution plan should be reviewed when your income, essential needs, or goal changes.","options":["True","False"],"answer":true,"explanation":"A plan is a living estimate. Review the amount, time horizon, and assumptions when your situation changes.","parameters":{"visual":"retirement-planning-start-early-compounding"}}$json$::jsonb,
      $json${"type":"true_false","difficulty":"beginner","question":"Rencana kontribusi pensiun perlu ditinjau saat pendapatan, kebutuhan pokok, atau tujuanmu berubah.","options":["Benar","Salah"],"answer":true,"explanation":"Rencana adalah perkiraan yang terus berubah. Tinjau nominal, horizon waktu, dan asumsi saat situasimu berubah.","parameters":{"visual":"retirement-planning-start-early-compounding"}}$json$::jsonb
    ),
    (
      $json${"type":"multiple_choice","difficulty":"beginner","question":"Which change is a good reason to revisit a retirement projection?","options":["A change in contribution amount, time horizon, or assumptions","A chart using a different colour","Seeing one strong market day","Nothing; projections never need review"],"answer":"A change in contribution amount, time horizon, or assumptions","explanation":"Changing an input can change the illustration, so reviewing it keeps the plan honest and useful.","parameters":{"visual":"retirement-planning-start-early-compounding"}}$json$::jsonb,
      $json${"type":"multiple_choice","difficulty":"beginner","question":"Perubahan apa yang menjadi alasan baik untuk meninjau kembali proyeksi pensiun?","options":["Perubahan nominal kontribusi, horizon waktu, atau asumsi","Grafik menggunakan warna yang berbeda","Melihat satu hari pasar yang kuat","Tidak ada; proyeksi tidak pernah perlu ditinjau"],"answer":"Perubahan nominal kontribusi, horizon waktu, atau asumsi","explanation":"Mengubah input dapat mengubah ilustrasi, jadi meninjaunya membuat rencana tetap jujur dan berguna.","parameters":{"visual":"retirement-planning-start-early-compounding"}}$json$::jsonb
    )
)
INSERT INTO public.content_variants (
  lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active
)
SELECT
  lesson.id, 'question', new_variants.body, new_variants.body_id,
  'beginner', 'visual_applied', TRUE
FROM public.lessons AS lesson
CROSS JOIN new_variants
WHERE lesson.slug = 'retirement-planning-start-early-compounding'
  AND lesson.is_published = TRUE
  AND NOT EXISTS (
    SELECT 1
    FROM public.content_variants AS existing
    WHERE existing.lesson_id = lesson.id
      AND existing.variant_type = 'question'
      AND existing.body ->> 'question' = new_variants.body ->> 'question'
  );

UPDATE public.lessons
SET
  quiz_data = $json$[
    {"type":"multiple_choice","difficulty":"beginner","question":"In the retirement comparison, what changes when the same monthly contribution starts earlier?","options":["There is more time for contributions and compounding","The return becomes guaranteed","All market risk disappears","The learner no longer needs a budget"],"answer":"There is more time for contributions and compounding","explanation":"Time can help contributions compound, but the illustration does not guarantee a return.","parameters":{"visual":"retirement-planning-start-early-compounding"}},
    {"type":"multiple_choice","difficulty":"beginner","question":"What is the safest way to read an illustration that compares starting retirement contributions at different ages?","options":["As one scenario whose assumptions and uncertainty should be checked","As a guaranteed future account balance","As proof that market risk has disappeared","As a reason to skip an emergency fund"],"answer":"As one scenario whose assumptions and uncertainty should be checked","explanation":"An illustration can show how time affects a scenario, but its inputs and future returns remain uncertain.","parameters":{"visual":"retirement-planning-start-early-compounding"}},
    {"type":"true_false","difficulty":"beginner","question":"A retirement contribution plan should be reviewed when your income, essential needs, or goal changes.","options":["True","False"],"answer":true,"explanation":"A plan is a living estimate. Review the amount, time horizon, and assumptions when your situation changes.","parameters":{"visual":"retirement-planning-start-early-compounding"}}
  ]$json$::jsonb,
  quiz_data_id = $json$[
    {"type":"multiple_choice","difficulty":"beginner","question":"Dalam perbandingan pensiun, apa yang berubah ketika kontribusi bulanan yang sama dimulai lebih awal?","options":["Ada lebih banyak waktu untuk kontribusi dan pertumbuhan majemuk","Imbal hasil menjadi pasti","Semua risiko pasar hilang","Kamu tidak lagi membutuhkan anggaran"],"answer":"Ada lebih banyak waktu untuk kontribusi dan pertumbuhan majemuk","explanation":"Waktu dapat membantu kontribusi bertumbuh majemuk, tetapi ilustrasi ini tidak menjamin imbal hasil.","parameters":{"visual":"retirement-planning-start-early-compounding"}},
    {"type":"multiple_choice","difficulty":"beginner","question":"Apa cara paling aman membaca ilustrasi yang membandingkan usia mulai kontribusi pensiun?","options":["Sebagai satu skenario yang asumsi dan ketidakpastiannya perlu diperiksa","Sebagai saldo masa depan yang dijamin","Sebagai bukti risiko pasar sudah hilang","Sebagai alasan untuk melewati dana darurat"],"answer":"Sebagai satu skenario yang asumsi dan ketidakpastiannya perlu diperiksa","explanation":"Ilustrasi dapat menunjukkan pengaruh waktu pada satu skenario, tetapi input dan imbal hasil masa depannya tetap tidak pasti.","parameters":{"visual":"retirement-planning-start-early-compounding"}},
    {"type":"true_false","difficulty":"beginner","question":"Rencana kontribusi pensiun perlu ditinjau saat pendapatan, kebutuhan pokok, atau tujuanmu berubah.","options":["Benar","Salah"],"answer":true,"explanation":"Rencana adalah perkiraan yang terus berubah. Tinjau nominal, horizon waktu, dan asumsi saat situasimu berubah.","parameters":{"visual":"retirement-planning-start-early-compounding"}}
  ]$json$::jsonb,
  updated_at = NOW()
WHERE slug = 'retirement-planning-start-early-compounding'
  AND is_published = TRUE;

COMMIT;
