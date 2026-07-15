-- Migration 025: Repurpose and publish lesson 10 as a beginner emergency fund lesson
-- Reuses the existing unpublished row (money_basics-advanced) so lesson_number 10 stays unique.
-- Inserts trusted sources, beginner content variants, and an approved lesson review.
-- Idempotent: UPDATE by immutable UUID; inserts use ON CONFLICT or count guards.

BEGIN;

DO $$
DECLARE
  v_lesson UUID := '5a257fa8-d3b9-4907-95d0-a35af52033c8';
  s_ojk_003 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-003');
  s_ojk_006 UUID := (SELECT id FROM sources WHERE source_code = 'OJK-006');
  existing_examples INT;
  existing_explanations INT;
  existing_questions INT;
BEGIN
  -- 1. Repurpose the placeholder lesson into a beginner emergency-fund lesson
  UPDATE lessons
  SET
    slug = 'emergency-fund-101',
    title = 'Dana Darurat: Siapkan Sebelum Investasi',
    title_id = 'emergency-fund-101',
    difficulty = 'beginner',
    lesson_number = 10,
    xp_reward = 75,
    estimated_minutes = 8,
    summary = 'Dana darurat adalah tabungan khusus untuk kebutuhan tak terduga seperti sakit, kehilangan pekerjaan, atau perbaikan rumah. Sebelum berinvestasi, pastikan kamu sudah memiliki cadangan setidaknya 3–6 bulan pengeluaran rutin.',
    concept_body = 'Dana darurat adalah uang yang disisihkan khusus untuk menutup pengeluaran mendesak tanpa harus berutang atau menjual investasi. Umumnya dianjurkan menyimpan 3–6 bulan total pengeluaran rutin, tergantung stabilitas pendapatan dan tanggungan keluarga. Jika pekerjaanmu bergaji tetap dan ada asuransi kesehatan dari kantor, 3 bulan mungkin cukup; jika penghasilan tidak tetap atau punya tanggungan, 6 bulan atau lebih lebih aman.' || E'\n\n' ||
      'Tempat menyimpan dana darurat sebaiknya mudah dicairkan, aman, dan tidak fluktuatif. Pilihan di Indonesia antara lain tabungan terpisah di bank yang dijamin LPS, deposito berjangka pendek, atau reksa dana pasar uang dengan risiko rendah. Hindari menaruh dana darurat di saham, kripto, atau instrumen lain yang nilainya bisa turun drastis saat kamu butuh uang cepat.',
    indonesian_example = 'Bayu bekerja sebagai karyawan swasta di Jakarta dengan gaji bersih Rp 7.000.000 per bulan. Pengeluaran rutinnya untuk kos, makan, transport, dan tagihan total Rp 5.000.000 per bulan. Ia menargetkan dana darurat 6 bulan, yaitu Rp 30.000.000. Bayu menyimpan Rp 10.000.000 di tabungan terpisah di bank BCA dan Rp 20.000.000 di deposito berjangka 1 bulan agar tetap likuid. Setiap bulan ia menyisihkan Rp 1.000.000 untuk mengisi kembali jika dana terpakai.',
    why_this_matters = 'Investasi punya risiko fluktuasi harga. Jika terjadi kebutuhan mendesak saat pasar sedang turun, kamu bisa terpaksa menjual investasi dalam kerugian. Dana darurat melindungi investasi jangka panjangmu dan mencegah utang darurat berbunga tinggi.',
    common_mistake = 'Dana darurat terlalu kecil karena merasa "masih muda sehat", dicampur dengan tabungan harian sehingga terpakai untuk belanja, atau diletakkan di saham/reksa dana saham yang berisiko tinggi demi imbal hasil lebih besar.',
    quiz_data = jsonb_build_array(
      jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'beginner',
        'question', 'Berapa lama pengeluaran rutin yang umumnya dianjurkan untuk dana darurat?',
        'options', jsonb_build_array('1 bulan', '3–6 bulan', '12 bulan', 'Tidak perlu dana darurat'),
        'answer', '3–6 bulan',
        'explanation', 'Aturan praktisnya adalah menyimpan cadangan 3–6 bulan pengeluaran rutin, disesuaikan dengan stabilitas pendapatan dan tanggungan.',
        'parameters', '{}'::jsonb
      ),
      jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'beginner',
        'question', 'Dana darurat boleh disimpan dalam saham untuk potensi keuntungan lebih besar.',
        'answer', false,
        'explanation', 'Saham berfluktuasi dan bisa turun saat darurat terjadi. Dana darurat sebaiknya disimpan di instrumen aman dan likuid.',
        'parameters', '{}'::jsonb
      ),
      jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'beginner',
        'question', 'Mengapa dana darurat penting disiapkan sebelum mulai berinvestasi?',
        'options', jsonb_build_array('Menjamin investasi selalu untung', 'Menghindari menjual investasi saat darurat', 'Menggantikan asuransi jiwa', 'Meningkatkan imbal hasil deposito'),
        'answer', 'Menghindari menjual investasi saat darurat',
        'explanation', 'Dengan ada dana darurat, kamu tidak perlu mencairkan investasi dalam kondisi pasar yang kurang menguntungkan.',
        'parameters', '{}'::jsonb
      )
    ),
    review_status = 'approved',
    reviewed_by = 'Koin Content Reviewer',
    reviewed_at = NOW(),
    is_published = TRUE,
    updated_at = NOW()
  WHERE id = v_lesson;

  -- 2. Link trusted sources
  IF s_ojk_003 IS NOT NULL THEN
    INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
    VALUES (gen_random_uuid(), v_lesson, s_ojk_003, 'primary', 'OJK Publications Portal', TRUE, 1)
    ON CONFLICT (lesson_id, source_id) DO NOTHING;
  END IF;

  IF s_ojk_006 IS NOT NULL THEN
    INSERT INTO lesson_sources (id, lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
    VALUES (gen_random_uuid(), v_lesson, s_ojk_006, 'supporting', 'OJK Capital Markets Channel', FALSE, 2)
    ON CONFLICT (lesson_id, source_id) DO NOTHING;
  END IF;

  -- 3. Insert beginner content variants idempotently
  SELECT COUNT(*) INTO existing_examples FROM content_variants WHERE lesson_id = v_lesson AND variant_type = 'example';
  SELECT COUNT(*) INTO existing_explanations FROM content_variants WHERE lesson_id = v_lesson AND variant_type = 'explanation';
  SELECT COUNT(*) INTO existing_questions FROM content_variants WHERE lesson_id = v_lesson AND variant_type = 'question';

  IF existing_examples < 3 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_lesson, 'example', body, 'beginner', 'money_basics'
    FROM (VALUES
      (jsonb_build_object(
        'text', 'Rina, fresh graduate di Bandung, memiliki penghasilan bersih Rp 5.000.000 per bulan dan pengeluaran rutin Rp 4.000.000. Ia menargetkan dana darurat 6 bulan, yaitu Rp 24.000.000. Rina menyimpan Rp 8.000.000 di tabungan terpisah dan Rp 16.000.000 di deposito berjangka 1 bulan agar tetap mudah dicairkan.',
        'source_ids', jsonb_build_array(s_ojk_003::text)
      )),
      (jsonb_build_object(
        'text', 'Budi bekerja sebagai pengemudi ojek online dengan penghasilan yang berubah-ubah setiap bulan. Karena pendapatannya tidak tetap, ia memilih target dana darurat 6 bulan pengeluaran. Budi menyimpannya di reksa dana pasar uang yang bisa dicairkan dalam 2–3 hari kerja.',
        'source_ids', jsonb_build_array(s_ojk_003::text)
      )),
      (jsonb_build_object(
        'text', 'Sari adalah karyawan kantoran dengan asuransi kesehatan dari perusahaan dan belum memiliki tanggungan. Ia menetapkan dana darurat 3 bulan pengeluaran dan menyisihkan 10% gaji setiap bulan untuk mengisinya. Setelah penuh, Sari mulai menyalurkan sisanya ke reksa dana saham untuk tujuan jangka panjang.',
        'source_ids', jsonb_build_array(s_ojk_006::text)
      ))
    ) AS v(body)
    LIMIT (3 - existing_examples);
  END IF;

  IF existing_explanations < 2 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_lesson, 'explanation', body, 'beginner', 'money_basics'
    FROM (VALUES
      (jsonb_build_object(
        'text', 'Dana darurat adalah tabungan khusus untuk kebutuhan mendadak seperti sakit, kehilangan pekerjaan, atau perbaikan rumah. Besarnya biasanya 3–6 bulan pengeluaran rutin. Bedakan dengan tabungan untuk liburan atau belanja, sebab dana darurat hanya dipakai saat benar-benar urgent.'
      )),
      (jsonb_build_object(
        'text', 'Simpan dana darurat di tempat aman dan mudah dicairkan, misalnya tabungan terpisah di bank yang dijamin LPS, deposito berjangka pendek, atau reksa dana pasar uang. Hindari saham, kripto, atau instrumen lain yang harganya bisa turun tajam, karena saat darurat kamu butuh nilai yang stabil.'
      ))
    ) AS v(body)
    LIMIT (2 - existing_explanations);
  END IF;

  IF existing_questions < 5 THEN
    INSERT INTO content_variants (lesson_id, variant_type, body, difficulty, topic_tag)
    SELECT v_lesson, 'question', body, 'beginner', 'money_basics'
    FROM (VALUES
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'beginner',
        'question', 'Berapa lama pengeluaran rutin yang umumnya dianjurkan untuk dana darurat?',
        'options', jsonb_build_array('1 bulan', '3–6 bulan', '12 bulan', 'Tidak perlu dana darurat'),
        'answer', '3–6 bulan',
        'explanation', 'Aturan praktisnya adalah cadangan 3–6 bulan pengeluaran rutin, disesuaikan dengan stabilitas pendapatan dan tanggungan.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'beginner',
        'question', 'Dana darurat sebaiknya disimpan di saham agar hasilnya lebih tinggi.',
        'answer', false,
        'explanation', 'Saham berisiko fluktuatif. Dana darurat butuh stabilitas dan likuiditas, jadi pilih instrumen aman seperti tabungan atau deposito.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'beginner',
        'question', 'Tempat paling tepat untuk menyimpan dana darurat adalah ...',
        'options', jsonb_build_array('Deposito berjangka pendek atau tabungan terpisah', 'Saham blue chip', 'Kripto dengan kapitalisasi besar', 'Properti untuk disewakan'),
        'answer', 'Deposito berjangka pendek atau tabungan terpisah',
        'explanation', 'Dana darurat harus likuid dan aman. Deposito pendek atau tabungan terpisah cocok karena mudah dicairkan dan nilainya stabil.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'multiple_choice',
        'difficulty', 'beginner',
        'question', 'Mengapa dana darurat harus dipisah dari tabungan harian?',
        'options', jsonb_build_array('Agar tidak terpakai untuk belanja rutin', 'Agar mendapat bunga lebih tinggi', 'Agar tidak dikenakan pajak', 'Agar bisa dipinjamkan ke teman'),
        'answer', 'Agar tidak terpakai untuk belanja rutin',
        'explanation', 'Memisahkan dana darurat mencegah uang urgent terserap oleh pengeluaran sehari-hari yang sebenarnya bisa ditunda.',
        'parameters', '{}'::jsonb
      )),
      (jsonb_build_object(
        'type', 'true_false',
        'difficulty', 'beginner',
        'question', 'Setelah dana darurat terkumpul, kamu bisa mulai mengalokasikan kelebihan dana ke investasi jangka panjang.',
        'answer', true,
        'explanation', 'Dana darurat adalah fondasi keuangan. Setelah terpenuhi, dana lain bisa dialokasikan untuk investasi sesuai tujuan dan profil risiko.',
        'parameters', '{}'::jsonb
      ))
    ) AS v(body)
    LIMIT (5 - existing_questions);
  END IF;

  -- 4. Insert or update the approved lesson review
  IF EXISTS (SELECT 1 FROM lessons WHERE id = v_lesson) THEN
    INSERT INTO lesson_reviews (
      id, lesson_id, reviewer_name, reviewer_role, review_date,
      factual_accuracy_status, source_verification_status, indonesia_context_status, compliance_status,
      notes, approved_to_publish
    )
    VALUES (
      gen_random_uuid(), v_lesson, 'Koin Content Reviewer', 'content_lead', CURRENT_DATE,
      'pass', 'pass', 'pass', 'pass',
      'Approved for launch', TRUE
    )
    ON CONFLICT (lesson_id) DO UPDATE SET
      reviewer_name = EXCLUDED.reviewer_name,
      reviewer_role = EXCLUDED.reviewer_role,
      review_date = EXCLUDED.review_date,
      factual_accuracy_status = EXCLUDED.factual_accuracy_status,
      source_verification_status = EXCLUDED.source_verification_status,
      indonesia_context_status = EXCLUDED.indonesia_context_status,
      compliance_status = EXCLUDED.compliance_status,
      notes = EXCLUDED.notes,
      approved_to_publish = EXCLUDED.approved_to_publish,
      updated_at = NOW();
  END IF;
END $$;

COMMIT;
