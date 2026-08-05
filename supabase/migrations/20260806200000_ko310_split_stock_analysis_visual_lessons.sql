-- KO-310: split stock analysis into evidence and chart-context parts.
BEGIN;

UPDATE public.lessons SET
 title='Stock Analysis, Part 1: Fundamental evidence',
 title_id='Analisis Saham, Bagian 1: Bukti fundamental',
 summary='Build a small evidence checklist for understanding a company without turning one metric into a verdict.',
 summary_id='Bangun daftar periksa bukti untuk memahami perusahaan tanpa mengubah satu metrik menjadi keputusan.',
 concept_body='Fundamental analysis asks what a business does and what evidence describes it.' || E'\n\n1. **Business:** what does the company sell?\n2. **Results:** what do current official reports say?\n3. **Context:** what industry and macro factors matter?\n4. **Uncertainty:** what could change the conclusion?\n\nA ratio or headline is a starting point, not a verdict. Use dated company and IDX disclosures.',
 concept_body_id='Analisis fundamental bertanya tentang bisnis dan bukti yang menggambarkannya.' || E'\n\n1. **Bisnis:** apa yang dijual perusahaan?\n2. **Hasil:** apa kata laporan resmi terbaru?\n3. **Konteks:** faktor industri dan makro apa yang penting?\n4. **Ketidakpastian:** apa yang dapat mengubah kesimpulan?\n\nRasio atau judul hanya titik awal. Gunakan laporan perusahaan dan IDX bertanggal.',
 indonesian_example='Citra menulis tiga fakta dari laporan resmi dan satu pertanyaan yang belum terjawab. Ia tidak menyimpulkan saham pasti naik karena laba meningkat.',
 why_this_matters='Evidence-first analysis separates a business question from a price prediction.',
 why_this_matters_id='Analisis berbasis bukti membedakan pertanyaan bisnis dari prediksi harga.',
 common_mistake='Treating one ratio or headline as a complete investment conclusion.',
 common_mistake_id='Menganggap satu rasio atau judul sebagai kesimpulan investasi lengkap.',
 estimated_minutes=4, updated_at=NOW()
WHERE slug='stock-analysis-basics-fundamental-vs-technical';

WITH p AS (
 SELECT 'stock-analysis-basics-fundamental-vs-technical-part-2'::text slug,
 'stock-analysis-basics-fundamental-vs-technical'::text source_slug,
 'Stock Analysis, Part 2: Technical context without signals'::text title,
 'Analisis Saham, Bagian 2: Konteks teknikal tanpa sinyal'::text title_id,
 'Use a chart to describe recent price context while keeping observation separate from prediction.'::text summary,
 'Gunakan grafik untuk menggambarkan konteks harga terbaru sambil memisahkan pengamatan dari prediksi.'::text summary_id,
 'Technical analysis describes price and volume history. It can organise observations about trend, range, volatility, and volume; it does not guarantee what happens next.'::text concept_body,
 'Analisis teknikal menggambarkan riwayat harga dan volume. Ini membantu menyusun pengamatan, tetapi tidak menjamin apa yang terjadi berikutnya.'::text concept_body_id,
 'Bayu describes a dated price range and volume change, then writes that the chart cannot prove a future direction.'::text indonesian_example,
 'Separating observation from prediction is the core chart-literacy habit.'::text why_this_matters,
 'Memisahkan pengamatan dari prediksi adalah kebiasaan utama literasi grafik.'::text why_this_matters_id,
 'Treating a technical pattern as a guaranteed timing signal.'::text common_mistake,
 'Menganggap pola teknikal sebagai sinyal waktu yang dijamin.'::text common_mistake_id,
 174::integer lesson_number
), inserted AS (
 INSERT INTO public.lessons(slug,title,title_id,topic_id,lesson_number,difficulty,xp_reward,estimated_minutes,summary,summary_id,concept_body,concept_body_id,indonesian_example,why_this_matters,why_this_matters_id,common_mistake,common_mistake_id,review_status,reviewed_by,reviewed_at,is_published,jurisdiction,prerequisite_lesson_id)
 SELECT p.slug,p.title,p.title_id,b.topic_id,p.lesson_number,b.difficulty,b.xp_reward,4,p.summary,p.summary_id,p.concept_body,p.concept_body_id,p.indonesian_example,p.why_this_matters,p.why_this_matters_id,p.common_mistake,p.common_mistake_id,b.review_status,b.reviewed_by,b.reviewed_at,TRUE,b.jurisdiction,b.id
 FROM p JOIN public.lessons b ON b.slug=p.source_slug
 ON CONFLICT(slug) DO UPDATE SET title=EXCLUDED.title,title_id=EXCLUDED.title_id,summary=EXCLUDED.summary,summary_id=EXCLUDED.summary_id,concept_body=EXCLUDED.concept_body,concept_body_id=EXCLUDED.concept_body_id,indonesian_example=EXCLUDED.indonesian_example,why_this_matters=EXCLUDED.why_this_matters,why_this_matters_id=EXCLUDED.why_this_matters_id,common_mistake=EXCLUDED.common_mistake,common_mistake_id=EXCLUDED.common_mistake_id,estimated_minutes=EXCLUDED.estimated_minutes,is_published=TRUE,prerequisite_lesson_id=EXCLUDED.prerequisite_lesson_id,updated_at=NOW()
 RETURNING id
) SELECT 1 FROM inserted;

INSERT INTO public.lesson_reviews(lesson_id,reviewer_name,reviewer_role,review_date,factual_accuracy_status,source_verification_status,indonesia_context_status,compliance_status,notes,approved_to_publish)
SELECT c.id,r.reviewer_name,r.reviewer_role,r.review_date,r.factual_accuracy_status,r.source_verification_status,r.indonesia_context_status,r.compliance_status,'KO-310 split part; keep observations separate from predictions.',r.approved_to_publish
FROM public.lessons c JOIN public.lessons p ON p.slug='stock-analysis-basics-fundamental-vs-technical'
JOIN public.lesson_reviews r ON r.lesson_id=p.id
WHERE c.slug='stock-analysis-basics-fundamental-vs-technical-part-2'
AND NOT EXISTS(SELECT 1 FROM public.lesson_reviews x WHERE x.lesson_id=c.id);

WITH sm(slug,source_code,display_order) AS (
 VALUES ('stock-analysis-basics-fundamental-vs-technical','CH08-OJK-CAPITAL',10),
 ('stock-analysis-basics-fundamental-vs-technical','CH08-IDX-STOCKS',20),
 ('stock-analysis-basics-fundamental-vs-technical-part-2','CH08-OJK-CAPITAL',10),
 ('stock-analysis-basics-fundamental-vs-technical-part-2','CH08-IDX-STOCKS',20)
)
INSERT INTO public.lesson_sources(lesson_id,source_id,relevance_type,citation_label,is_primary,display_order)
SELECT l.id,s.id,CASE WHEN sm.display_order=10 THEN 'primary' ELSE 'supporting' END,sm.source_code,sm.display_order=10,sm.display_order
FROM sm JOIN public.lessons l ON l.slug=sm.slug JOIN public.sources s ON s.source_code=sm.source_code
ON CONFLICT(lesson_id,source_id) DO UPDATE SET relevance_type=EXCLUDED.relevance_type,citation_label=EXCLUDED.citation_label,is_primary=EXCLUDED.is_primary,display_order=EXCLUDED.display_order;

INSERT INTO public.lesson_visual_blocks(lesson_id,placement,block_type,display_order,data_status,content,is_published)
SELECT l.id,'concept',v.block_type,10,v.data_status,v.content,TRUE
FROM (VALUES
 ('stock-analysis-basics-fundamental-vs-technical','process','source_derived',
  jsonb_build_object('en',jsonb_build_object('title','Fundamental questions before a verdict','disclosure','Use dated company and IDX disclosures; reviewed 2026-08-05. This is a learning framework, not a recommendation.','altText','A four-step fundamental-analysis checklist.','payload',jsonb_build_object('steps',jsonb_build_array(jsonb_build_object('title','1. Business','description','What does the company sell?'),jsonb_build_object('title','2. Results','description','What do current reports show?'),jsonb_build_object('title','3. Context','description','What industry factors matter?'),jsonb_build_object('title','4. Uncertainty','description','What could change the conclusion?')))),'id',jsonb_build_object('title','Pertanyaan fundamental sebelum kesimpulan','disclosure','Gunakan laporan perusahaan dan IDX bertanggal; ditinjau 5 Agustus 2026. Ini kerangka belajar, bukan rekomendasi.','altText','Daftar periksa analisis fundamental.','payload',jsonb_build_object('steps',jsonb_build_array(jsonb_build_object('title','1. Bisnis','description','Apa yang dijual perusahaan?'),jsonb_build_object('title','2. Hasil','description','Apa kata laporan terbaru?'),jsonb_build_object('title','3. Konteks','description','Faktor industri apa yang penting?'),jsonb_build_object('title','4. Ketidakpastian','description','Apa yang dapat mengubah kesimpulan?')))))),
 ('stock-analysis-basics-fundamental-vs-technical-part-2','comparison','illustrative',
  jsonb_build_object('en',jsonb_build_object('title','Observation is not prediction','disclosure','Illustrative chart-literacy boundary; no pattern guarantees a future price.','altText','A comparison between observed chart facts and unknown outcomes.','payload',jsonb_build_object('leftTitle','Observed','rightTitle','Still unknown','rows',jsonb_build_array(jsonb_build_object('left','The dated price range changed.','right','What price will do next.'),jsonb_build_object('left','An indicator has a value.','right','A guaranteed timing signal.'),jsonb_build_object('left','A chart gives context.','right','Whether an outcome suits a person.')))),'id',jsonb_build_object('title','Pengamatan bukan prediksi','disclosure','Batas literasi grafik ilustratif; tidak ada pola yang menjamin harga masa depan.','altText','Perbandingan fakta grafik dan hasil yang belum diketahui.','payload',jsonb_build_object('leftTitle','Teramati','rightTitle','Belum diketahui','rows',jsonb_build_array(jsonb_build_object('left','Rentang harga bertanggal berubah.','right','Apa yang terjadi pada harga berikutnya.'),jsonb_build_object('left','Indikator memiliki nilai.','right','Sinyal waktu yang dijamin.'),jsonb_build_object('left','Grafik memberi konteks.','right','Apakah hasilnya cocok untuk seseorang.'))))))
) AS v(slug,block_type,data_status,content)
JOIN public.lessons l ON l.slug=v.slug
ON CONFLICT(lesson_id,placement,display_order) DO UPDATE SET block_type=EXCLUDED.block_type,data_status=EXCLUDED.data_status,content=EXCLUDED.content,is_published=TRUE,updated_at=NOW();

WITH q(slug,body,body_id) AS (
 VALUES
 ('stock-analysis-basics-fundamental-vs-technical',
  jsonb_build_object('type','multiple_choice','question','What is a good first use of fundamental analysis?','options',jsonb_build_array('Study the business and dated evidence before a conclusion','Treat one ratio as a guaranteed signal','Predict tomorrow from a headline'),'answer','Study the business and dated evidence before a conclusion','difficulty','intermediate','explanation','Fundamental analysis organises business evidence; it does not guarantee a return.'),
  jsonb_build_object('type','multiple_choice','question','Apa penggunaan awal analisis fundamental yang baik?','options',jsonb_build_array('Pelajari bisnis dan bukti bertanggal sebelum kesimpulan','Anggap satu rasio sebagai sinyal yang dijamin','Prediksi besok dari judul'),'answer','Pelajari bisnis dan bukti bertanggal sebelum kesimpulan','difficulty','intermediate','explanation','Analisis fundamental menyusun bukti bisnis; bukan jaminan imbal hasil.')),
 ('stock-analysis-basics-fundamental-vs-technical-part-2',
  jsonb_build_object('type','multiple_choice','question','What can a dated chart show without becoming a prediction?','options',jsonb_build_array('Recent observed price or volume context','A guaranteed future direction','Whether a trade suits everyone'),'answer','Recent observed price or volume context','difficulty','intermediate','explanation','Charts describe context; they cannot guarantee direction or suitability.'),
  jsonb_build_object('type','multiple_choice','question','Apa yang dapat ditunjukkan grafik bertanggal tanpa menjadi prediksi?','options',jsonb_build_array('Konteks harga atau volume terbaru yang teramati','Arah masa depan yang dijamin','Kecocokan transaksi untuk semua orang'),'answer','Konteks harga atau volume terbaru yang teramati','difficulty','intermediate','explanation','Grafik menggambarkan konteks; bukan jaminan arah atau kecocokan.'))
)
INSERT INTO public.content_variants(lesson_id,variant_type,body,body_id,difficulty,topic_tag,is_active)
SELECT l.id,'question',q.body,q.body_id,'intermediate','visual_applied',TRUE FROM q JOIN public.lessons l ON l.slug=q.slug
WHERE NOT EXISTS(SELECT 1 FROM public.content_variants x WHERE x.lesson_id=l.id AND x.variant_type='question' AND x.topic_tag='visual_applied');

WITH r(slug,question_en,question_id,options_en,options_id,correct_option,explanation_en,explanation_id) AS (
 VALUES
 ('stock-analysis-basics-fundamental-vs-technical','Five days ago, you learned to start with business evidence. What is not a complete conclusion?','Lima hari lalu, kamu belajar mulai dari bukti bisnis. Apa yang bukan kesimpulan lengkap?',jsonb_build_array(jsonb_build_object('id','ratio','label','One ratio or headline by itself')),jsonb_build_array(jsonb_build_object('id','ratio','label','Satu rasio atau judul saja')),'ratio','A complete analysis needs context, uncertainty, and dated evidence.','Analisis lengkap memerlukan konteks, ketidakpastian, dan bukti bertanggal.'),
 ('stock-analysis-basics-fundamental-vs-technical-part-2','Five days ago, you learned to separate chart observation from prediction. What can a chart provide?','Lima hari lalu, kamu belajar memisahkan pengamatan grafik dari prediksi. Apa yang dapat diberikan grafik?',jsonb_build_array(jsonb_build_object('id','context','label','Recent context, not a guaranteed timing signal')),jsonb_build_array(jsonb_build_object('id','context','label','Konteks terbaru, bukan sinyal waktu yang dijamin')),'context','A chart organises observations without proving the future.','Grafik menyusun pengamatan tanpa membuktikan masa depan.')
)
INSERT INTO public.lesson_recall_questions(lesson_id,question_en,question_id,options_en,options_id,correct_option,explanation_en,explanation_id,is_active)
SELECT l.id,r.question_en,r.question_id,r.options_en,r.options_id,r.correct_option,r.explanation_en,r.explanation_id,TRUE FROM r JOIN public.lessons l ON l.slug=r.slug
ON CONFLICT(lesson_id) DO UPDATE SET question_en=EXCLUDED.question_en,question_id=EXCLUDED.question_id,options_en=EXCLUDED.options_en,options_id=EXCLUDED.options_id,correct_option=EXCLUDED.correct_option,explanation_en=EXCLUDED.explanation_en,explanation_id=EXCLUDED.explanation_id,is_active=TRUE,updated_at=NOW();

COMMIT;

