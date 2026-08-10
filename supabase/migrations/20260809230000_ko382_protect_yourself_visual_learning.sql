-- KO-382: Complete the Chapter 03 Protect Yourself visual-learning contract.
BEGIN;

INSERT INTO public.sources (source_code, title, local_title, source_tier, source_type, organization, url, language, last_checked_at, status, trust_notes, localization_notes, synopsis, synopsis_id, relevance_blurb, relevance_blurb_id)
VALUES (
  'CH03-OJK-INSURANCE', 'OJK insurance overview', 'Ringkasan perasuransian OJK',
  1, 'website', 'OJK', 'https://ojk.go.id/id/kanal/iknb/pages/asuransi.aspx?%2Fblog=', 'id', '2026-08-10', 'verified',
  'Official OJK overview of insurance as a contract that manages specified risks under a policy and premium.',
  'Indonesian primary source. The lesson gives a bilingual education-first summary and does not recommend a product.',
  'OJK explains insurance as an agreement in which an insurer receives a premium and provides specified protection or benefits under its terms.',
  'OJK menjelaskan asuransi sebagai perjanjian ketika perusahaan menerima premi dan memberikan perlindungan atau manfaat tertentu sesuai ketentuannya.',
  'Supports the insurance lessons on comparing coverage, exclusions, affordability, and claims rather than choosing from a label alone.',
  'Mendukung pelajaran asuransi tentang membandingkan cakupan, pengecualian, kemampuan membayar, dan klaim, bukan memilih hanya dari label.'
)
ON CONFLICT (source_code) DO UPDATE SET title = EXCLUDED.title, local_title = EXCLUDED.local_title, source_tier = EXCLUDED.source_tier, source_type = EXCLUDED.source_type, organization = EXCLUDED.organization, url = EXCLUDED.url, language = EXCLUDED.language, last_checked_at = EXCLUDED.last_checked_at, status = EXCLUDED.status, trust_notes = EXCLUDED.trust_notes, localization_notes = EXCLUDED.localization_notes, synopsis = EXCLUDED.synopsis, synopsis_id = EXCLUDED.synopsis_id, relevance_blurb = EXCLUDED.relevance_blurb, relevance_blurb_id = EXCLUDED.relevance_blurb_id;

WITH source_map(slug, source_code) AS (VALUES
  ('too-good-to-be-true', 'FZ-OJK-WASPADA'),
  ('check-ojk-license', 'CH08-OJK-FIND'),
  ('phishing-social-engineering', 'OJK-012'),
  ('mlm-pyramid-red-flags', 'FZ-OJK-WASPADA'),
  ('insurance-basics-bpjs-vs-private-insurance', 'CH03-OJK-INSURANCE'),
  ('insurance-basics-bpjs-vs-private-insurance-part-2', 'CH03-OJK-INSURANCE')
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, 'primary', source.source_code, TRUE, 10
FROM source_map JOIN public.lessons lesson ON lesson.slug = source_map.slug JOIN public.sources source ON source.source_code = source_map.source_code
WHERE lesson.is_published = TRUE
ON CONFLICT (lesson_id, source_id) DO UPDATE SET relevance_type = EXCLUDED.relevance_type, citation_label = EXCLUDED.citation_label, is_primary = EXCLUDED.is_primary, display_order = EXCLUDED.display_order;

UPDATE public.lesson_sources AS link SET is_primary = FALSE
FROM public.lessons AS lesson, public.sources AS source
WHERE link.lesson_id = lesson.id AND link.source_id = source.id
  AND lesson.slug IN ('too-good-to-be-true', 'check-ojk-license', 'phishing-social-engineering', 'mlm-pyramid-red-flags', 'insurance-basics-bpjs-vs-private-insurance', 'insurance-basics-bpjs-vs-private-insurance-part-2')
  AND (lesson.slug, source.source_code) NOT IN (('too-good-to-be-true', 'FZ-OJK-WASPADA'), ('check-ojk-license', 'CH08-OJK-FIND'), ('phishing-social-engineering', 'OJK-012'), ('mlm-pyramid-red-flags', 'FZ-OJK-WASPADA'), ('insurance-basics-bpjs-vs-private-insurance', 'CH03-OJK-INSURANCE'), ('insurance-basics-bpjs-vs-private-insurance-part-2', 'CH03-OJK-INSURANCE'));

WITH source_map(slug, source_code) AS (VALUES
  ('too-good-to-be-true', 'FZ-OJK-WASPADA'), ('check-ojk-license', 'CH08-OJK-FIND'), ('phishing-social-engineering', 'OJK-012'), ('mlm-pyramid-red-flags', 'FZ-OJK-WASPADA'), ('insurance-basics-bpjs-vs-private-insurance', 'CH03-OJK-INSURANCE'), ('insurance-basics-bpjs-vs-private-insurance-part-2', 'CH03-OJK-INSURANCE')
)
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM source_map JOIN public.lessons lesson ON lesson.slug = source_map.slug
JOIN public.lesson_visual_blocks block ON block.lesson_id = lesson.id AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources source ON source.source_code = source_map.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id AND lesson.slug IN ('too-good-to-be-true', 'check-ojk-license', 'phishing-social-engineering', 'mlm-pyramid-red-flags') AND variant.variant_type = 'question' AND variant.topic_tag = 'visual_applied';

WITH q(slug, question, options, answer, explanation, question_id, options_id, answer_id, explanation_id) AS (VALUES
  ('too-good-to-be-true','Which promise in the visual is a reason to pause?','["Guaranteed profit with no risk","Time to verify independently","A link to an official regulator"]'::jsonb,'Guaranteed profit with no risk','Guaranteed-profit and no-risk language needs independent checking.','Janji mana pada visual yang menjadi alasan untuk berhenti sejenak?','["Untung pasti tanpa risiko","Waktu untuk verifikasi mandiri","Tautan ke regulator resmi"]'::jsonb,'Untung pasti tanpa risiko','Bahasa untung pasti dan tanpa risiko perlu diperiksa secara mandiri.'),
  ('too-good-to-be-true','What evidence does the visual say not to rely on alone?','["Screenshots or group-chat testimonials","An official OJK directory","Current written terms"]'::jsonb,'Screenshots or group-chat testimonials','A promoter’s screenshots or testimonials are not independent proof.','Bukti apa yang menurut visual tidak boleh diandalkan sendirian?','["Tangkapan layar atau testimoni grup chat","Direktori OJK resmi","Ketentuan tertulis terbaru"]'::jsonb,'Tangkapan layar atau testimoni grup chat','Tangkapan layar atau testimoni promotor bukan bukti mandiri.'),
  ('too-good-to-be-true','True or false: an urgent message is a reason to share a PIN or OTP.','["True","False"]'::jsonb,'False','Pressure is a reason to protect credentials, not share them.','Benar atau salah: pesan mendesak adalah alasan untuk membagikan PIN atau OTP.','["Benar","Salah"]'::jsonb,'Salah','Tekanan adalah alasan untuk melindungi kredensial, bukan membagikannya.'),
  ('check-ojk-license','What should you copy before checking a provider?','["The company, product, and claim","Only the logo colour","A promoter’s password"]'::jsonb,'The company, product, and claim','Keeping details lets you check the right offer independently.','Apa yang perlu dicatat sebelum memeriksa penyedia?','["Perusahaan, produk, dan klaim","Hanya warna logo","Kata sandi promotor"]'::jsonb,'Perusahaan, produk, dan klaim','Mencatat detail membantu Anda memeriksa penawaran yang tepat secara mandiri.'),
  ('check-ojk-license','Which route follows the verification visual?','["Use an official OJK channel, not a promoter link","Ask the group chat","Pay first and check later"]'::jsonb,'Use an official OJK channel, not a promoter link','Independent verification means starting from an official channel.','Jalur mana yang mengikuti visual verifikasi?','["Gunakan kanal resmi OJK, bukan tautan promotor","Tanya grup chat","Bayar dulu lalu cek kemudian"]'::jsonb,'Gunakan kanal resmi OJK, bukan tautan promotor','Verifikasi mandiri berarti memulai dari kanal resmi.'),
  ('check-ojk-license','True or false: a directory search alone certifies every claim a promoter makes.','["True","False"]'::jsonb,'False','A directory check is one step. Claims and current terms still need careful reading.','Benar atau salah: pencarian direktori saja mengesahkan setiap klaim promotor.','["Benar","Salah"]'::jsonb,'Salah','Pemeriksaan direktori adalah satu langkah. Klaim dan ketentuan terbaru tetap perlu dibaca dengan cermat.'),
  ('phishing-social-engineering','What is the first move in the safety flow?','["Do not click or share a code","Reply with a PIN","Forward the link"]'::jsonb,'Do not click or share a code','Stopping prevents a rushed message from taking your credentials.','Apa langkah pertama dalam alur keamanan?','["Jangan klik atau bagikan kode","Balas dengan PIN","Teruskan tautan"]'::jsonb,'Jangan klik atau bagikan kode','Berhenti mencegah pesan terburu-buru mengambil kredensial Anda.'),
  ('phishing-social-engineering','Where should you verify a suspicious contact?','["The official app, site, or number","The message link","A stranger’s account"]'::jsonb,'The official app, site, or number','Use a route you find independently, not the one in the suspicious message.','Di mana Anda perlu memverifikasi kontak mencurigakan?','["Aplikasi, situs, atau nomor resmi","Tautan di pesan","Akun orang asing"]'::jsonb,'Aplikasi, situs, atau nomor resmi','Gunakan jalur yang Anda temukan mandiri, bukan yang ada di pesan mencurigakan.'),
  ('phishing-social-engineering','True or false: a real service needs your password or OTP because it says your account is blocked.','["True","False"]'::jsonb,'False','Do not disclose passwords, PINs, or OTPs because of a message.','Benar atau salah: layanan asli memerlukan kata sandi atau OTP Anda karena mengatakan akun diblokir.','["Benar","Salah"]'::jsonb,'Salah','Jangan ungkapkan kata sandi, PIN, atau OTP karena sebuah pesan.'),
  ('mlm-pyramid-red-flags','Which sign belongs in the pause-on-pressure column?','["The main message is recruiting others","Clear product terms","Time to verify"]'::jsonb,'The main message is recruiting others','Recruitment pressure is a reason to slow down and check the offer independently.','Tanda mana yang masuk kolom berhenti saat ditekan?','["Pesan utama adalah merekrut orang lain","Syarat produk jelas","Ada waktu untuk verifikasi"]'::jsonb,'Pesan utama adalah merekrut orang lain','Tekanan rekrutmen adalah alasan untuk memperlambat dan memeriksa penawaran secara mandiri.'),
  ('mlm-pyramid-red-flags','What helps you examine a real offer?','["Independent information and clear terms","Only a promoter’s claim","Urgency and secrecy"]'::jsonb,'Independent information and clear terms','The visual contrasts independently checkable information with pressure tactics.','Apa yang membantu Anda memeriksa penawaran nyata?','["Informasi mandiri dan syarat jelas","Hanya klaim promotor","Desakan dan kerahasiaan"]'::jsonb,'Informasi mandiri dan syarat jelas','Visual membedakan informasi yang dapat diperiksa mandiri dengan taktik tekanan.'),
  ('mlm-pyramid-red-flags','True or false: a clear product automatically makes recruitment pressure safe.','["True","False"]'::jsonb,'False','A clear product is one point to check. Pressure and claims still need scrutiny.','Benar atau salah: produk yang jelas otomatis membuat tekanan rekrutmen aman.','["Benar","Salah"]'::jsonb,'Salah','Produk yang jelas adalah satu hal untuk diperiksa. Tekanan dan klaim tetap perlu diteliti.')
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', jsonb_build_object('type','multiple_choice','difficulty','beginner','question',q.question,'options',q.options,'answer',q.answer,'explanation',q.explanation,'parameters',jsonb_build_object('visual',q.slug)), jsonb_build_object('type','multiple_choice','difficulty','beginner','question',q.question_id,'options',q.options_id,'answer',q.answer_id,'explanation',q.explanation_id,'parameters',jsonb_build_object('visual',q.slug)), 'beginner', 'visual_applied', TRUE
FROM q JOIN public.lessons lesson ON lesson.slug = q.slug WHERE lesson.is_published = TRUE;

WITH recalls(slug, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id) AS (VALUES
  ('too-good-to-be-true','What should a guarantee-of-profit claim trigger?','Apa yang perlu dipicu oleh klaim untung pasti?','["An independent check and a pause","An instant payment","Sharing an OTP"]'::jsonb,'["Pemeriksaan mandiri dan jeda","Pembayaran langsung","Membagikan OTP"]'::jsonb,'An independent check and a pause','A promise is not proof. Pause and check independently.','Janji bukan bukti. Berhenti sejenak dan periksa secara mandiri.'),
  ('check-ojk-license','Where should you begin a provider check?','Di mana Anda perlu memulai pemeriksaan penyedia?','["An official OJK channel","A promoter’s link","An urgent group chat"]'::jsonb,'["Kanal resmi OJK","Tautan promotor","Grup chat mendesak"]'::jsonb,'An official OJK channel','Start from a source you can identify independently.','Mulailah dari sumber yang dapat Anda identifikasi secara mandiri.'),
  ('phishing-social-engineering','What should you not share after a suspicious message?','Apa yang tidak boleh Anda bagikan setelah pesan mencurigakan?','["Password, PIN, or OTP","A question through an official channel","Time to verify"]'::jsonb,'["Kata sandi, PIN, atau OTP","Pertanyaan lewat kanal resmi","Waktu untuk verifikasi"]'::jsonb,'Password, PIN, or OTP','Credentials stay private, even when a message feels urgent.','Kredensial tetap privat, bahkan saat pesan terasa mendesak.'),
  ('mlm-pyramid-red-flags','What is a reason to pause on an offer?','Apa alasan untuk berhenti sejenak pada suatu penawaran?','["Pressure to recruit or act quickly","Time to read the terms","Independent information"]'::jsonb,'["Tekanan untuk merekrut atau bertindak cepat","Waktu untuk membaca syarat","Informasi mandiri"]'::jsonb,'Pressure to recruit or act quickly','Pressure makes independent checking more important.','Tekanan membuat pemeriksaan mandiri semakin penting.')
)
INSERT INTO public.lesson_recall_questions (lesson_id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, is_active)
SELECT lesson.id, question_en, question_id, options_en, options_id, correct_option, explanation_en, explanation_id, TRUE FROM recalls JOIN public.lessons lesson ON lesson.slug = recalls.slug
ON CONFLICT (lesson_id) DO UPDATE SET question_en = EXCLUDED.question_en, question_id = EXCLUDED.question_id, options_en = EXCLUDED.options_en, options_id = EXCLUDED.options_id, correct_option = EXCLUDED.correct_option, explanation_en = EXCLUDED.explanation_en, explanation_id = EXCLUDED.explanation_id, is_active = TRUE, updated_at = NOW();

COMMIT;
