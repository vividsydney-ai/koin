-- KO-309: split Tax Basics and RDN into short, source-backed parts.
-- Changing tax/provider claims remain current-rule and provider-specific.

BEGIN;

UPDATE public.lessons SET
 title='Tax Basics, Part 1: Identity and records',
 title_id='Dasar-Dasar Pajak, Bagian 1: Identitas dan catatan',
 summary='Learn how tax identity, income records, and source checking fit together before interpreting an example.',
 summary_id='Pelajari hubungan identitas pajak, catatan penghasilan, dan pemeriksaan sumber sebelum menafsirkan contoh.',
 concept_body=$body$Tax learning starts with identity and records, not a single rate copied from an old example.

Build a simple record set:
1. **Identity:** keep the tax-identification information that applies to you.
2. **Income:** record salary, freelance, business, investment, or other relevant income separately.
3. **Withholding:** keep evidence of tax already withheld or paid.
4. **Source:** use current DJP guidance for your taxpayer status, instrument, and reporting period.

NPWP, NIK integration, PPh 21, investment tax, and filing instructions depend on current rules and circumstances. This lesson explains questions to ask; it is not a personal tax calculation.$body$,
 concept_body_id=$body_id$Pelajaran pajak dimulai dari identitas dan catatan, bukan dari satu tarif yang disalin dari contoh lama.

Bangun catatan sederhana:
1. **Identitas:** simpan informasi identitas pajak yang berlaku.
2. **Penghasilan:** catat gaji, freelance, usaha, investasi, atau penghasilan relevan secara terpisah.
3. **Pemotongan:** simpan bukti pajak yang sudah dipotong atau dibayar.
4. **Sumber:** gunakan panduan DJP terbaru sesuai status, instrumen, dan periode.

NPWP, integrasi NIK, PPh 21, pajak investasi, dan pelaporan bergantung pada aturan serta keadaan yang berlaku. Pelajaran ini bukan perhitungan pajak pribadi.$body_id$,
 indonesian_example='Ani menyimpan bukti penghasilan dan pemotongan dalam satu folder. Sebelum mengisi SPT, ia memeriksa panduan DJP terbaru dan tidak menyalin angka dari contoh orang lain.',
 why_this_matters='Good records make it easier to check a current rule and notice when an example does not apply to your situation.',
 why_this_matters_id='Catatan yang rapi memudahkan pemeriksaan aturan terbaru dan membantu melihat ketika contoh tidak berlaku untuk situasimu.',
 common_mistake='Treating a historical example, threshold, or rate as a universal rule.',
 common_mistake_id='Menganggap contoh, batas, atau tarif historis sebagai aturan universal.',
 estimated_minutes=4, updated_at=NOW()
WHERE slug='tax-basics-npwp-pph-21-and-filing-taxes';

UPDATE public.lessons SET
 title='Brokerage Account Setup, Part 1: What an RDN does',
 title_id='Pembukaan Rekening Efek, Bagian 1: Fungsi RDN',
 summary='Understand the role of an RDN and build a neutral checklist for verifying a securities provider.',
 summary_id='Pahami fungsi RDN dan buat daftar periksa netral untuk memverifikasi penyedia jasa sekuritas.',
 concept_body=$body$An RDN (Rekening Dana Nasabah) is a customer-fund account used in the securities-account structure. It is separate from a personal spending account, but the route and terms depend on the licensed securities company, bank, and current rules.

Use a provider-neutral checklist:
1. **Licence:** verify the provider through the current OJK directory.
2. **Account structure:** understand which securities account and RDN are opened.
3. **Documents:** follow the provider's current onboarding instructions.
4. **Costs and support:** read the current fee schedule, funding route, service channels, and risk disclosures.

This is a verification framework, not a broker ranking. Koinaku paper trading is simulated and does not open an RDN or move real money.$body$,
 concept_body_id=$body_id$RDN (Rekening Dana Nasabah) adalah rekening dana nasabah dalam struktur rekening efek. Rekening ini terpisah dari rekening belanja pribadi, tetapi jalur dan ketentuannya bergantung pada perusahaan sekuritas berizin, bank, dan aturan terbaru.

Gunakan daftar periksa netral:
1. **Izin:** verifikasi penyedia melalui direktori OJK terbaru.
2. **Struktur rekening:** pahami rekening efek dan RDN yang dibuka.
3. **Dokumen:** ikuti petunjuk pendaftaran terbaru dari penyedia.
4. **Biaya dan dukungan:** baca jadwal biaya, jalur dana, kanal layanan, dan risiko.

Ini kerangka verifikasi, bukan peringkat sekuritas. Paper trading Koinaku bersifat simulasi dan tidak membuka RDN atau memindahkan uang sungguhan.$body_id$,
 indonesian_example='Bayu memakai daftar periksa yang sama untuk dua halaman pendaftaran. Ia memeriksa izin dan dokumen resmi penyedia yang dipilih, bukan menganggap nama populer berarti aman.',
 why_this_matters='Understanding the account structure helps you verify where funds go and which provider-specific terms you still need to read.',
 why_this_matters_id='Memahami struktur rekening membantu memeriksa ke mana dana masuk dan ketentuan khusus penyedia yang masih perlu dibaca.',
 common_mistake='Choosing a provider from a popularity or fee claim without verifying the current official record and terms.',
 common_mistake_id='Memilih penyedia berdasarkan popularitas atau klaim biaya tanpa memverifikasi catatan resmi dan ketentuan terbaru.',
 estimated_minutes=4, updated_at=NOW()
WHERE slug='brokerage-account-setup-opening-your-rdn';

WITH parts(slug, source_slug, title, title_id, summary, summary_id, concept_body, concept_body_id, indonesian_example, why_this_matters, why_this_matters_id, common_mistake, common_mistake_id, lesson_number) AS (
 VALUES
 ('tax-basics-npwp-pph-21-and-filing-taxes-part-2','tax-basics-npwp-pph-21-and-filing-taxes',
  'Tax Basics, Part 2: SPT and current rules','Dasar-Dasar Pajak, Bagian 2: SPT dan aturan terbaru',
  'Map a simple SPT workflow and learn where current DJP instructions belong.','Petakan alur SPT sederhana dan pelajari peran petunjuk DJP terbaru.',
  $body$A safe SPT workflow is a sequence:
1. Gather income, withholding, and supporting records.
2. Identify the current form and reporting route.
3. Check the official DJP instruction and deadline for the relevant tax year.
4. Submit through the current channel and keep the receipt.

The right form, filing date, and tax treatment can change with taxpayer status, income type, instrument, and regulation. Label any number as illustrative and return to the current official rule.$body$,
  $body_id$Alur SPT yang aman adalah rangkaian langkah:
1. Kumpulkan catatan penghasilan, pemotongan, dan bukti.
2. Identifikasi formulir dan jalur pelaporan terbaru.
3. Periksa petunjuk DJP dan tenggat resmi tahun pajak terkait.
4. Kirim melalui kanal terbaru dan simpan buktinya.

Formulir, tanggal, dan perlakuan pajak dapat berubah. Labeli angka sebagai ilustratif lalu kembali ke aturan resmi terbaru.$body_id$,
  'Ani checks her records, selects the current DJP route, and saves the submission receipt instead of inferring her result from a simplified salary example.',
  'A current source date belongs in the SPT checklist.','Tanggal sumber terbaru adalah bagian dari daftar periksa SPT.',
  'Copying another person’s form or deadline without checking current DJP guidance.',
  'Menyalin formulir atau tenggat orang lain tanpa memeriksa panduan DJP terbaru.',172),
 ('brokerage-account-setup-opening-your-rdn-part-2','brokerage-account-setup-opening-your-rdn',
  'Brokerage Account Setup, Part 2: Open and fund safely','Pembukaan Rekening Efek, Bagian 2: Buka dan isi dengan aman',
  'Walk through a provider-specific onboarding checklist without treating one process as universal.','Ikuti daftar periksa pendaftaran khusus penyedia tanpa menganggap satu proses berlaku universal.',
  $body$Treat onboarding as a verification task:
1. Open the application from the provider's official channel.
2. Read the current identity, risk, account, and fee documents.
3. Confirm the receiving account and funding instructions.
4. Save agreements, support, and complaint routes.
5. Practise with a simulated order while learning.

There is no universal list of documents, fee, approval time, minimum funding amount, or protection statement. Confirm each claim for the selected provider and date. Never send funds to a personal account because someone asked.$body$,
  $body_id$Anggap pendaftaran sebagai tugas verifikasi:
1. Buka aplikasi dari kanal resmi penyedia.
2. Baca dokumen identitas, risiko, rekening, dan biaya terbaru.
3. Pastikan rekening tujuan dan petunjuk pengisian dana.
4. Simpan perjanjian, dukungan, dan jalur pengaduan.
5. Berlatih dengan order simulasi.

Tidak ada daftar dokumen, biaya, waktu persetujuan, jumlah minimum, atau pernyataan perlindungan yang universal. Konfirmasi setiap klaim untuk penyedia dan tanggalnya. Jangan mengirim dana ke rekening pribadi karena diminta seseorang.$body_id$,
  'Bayu verifies the provider domain, reads the current terms, and checks the destination account before any transfer. He practises in Koinaku first.',
  'Provider-specific claims need a named provider, current source, and a clear boundary.',
  'Klaim khusus penyedia memerlukan nama penyedia, sumber terbaru, dan batas yang jelas.',
  'Treating one provider’s fee, documents, or timeline as a market-wide rule.',
  'Menganggap biaya, dokumen, atau waktu satu penyedia sebagai aturan seluruh pasar.',173)
), inserted AS (
 INSERT INTO public.lessons (slug,title,title_id,topic_id,lesson_number,difficulty,xp_reward,estimated_minutes,summary,summary_id,concept_body,concept_body_id,indonesian_example,why_this_matters,why_this_matters_id,common_mistake,common_mistake_id,review_status,reviewed_by,reviewed_at,is_published,jurisdiction,prerequisite_lesson_id)
 SELECT p.slug,p.title,p.title_id,b.topic_id,p.lesson_number,b.difficulty,b.xp_reward,4,p.summary,p.summary_id,p.concept_body,p.concept_body_id,p.indonesian_example,p.why_this_matters,p.why_this_matters_id,p.common_mistake,p.common_mistake_id,b.review_status,b.reviewed_by,b.reviewed_at,TRUE,b.jurisdiction,b.id
 FROM parts p JOIN public.lessons b ON b.slug=p.source_slug
 ON CONFLICT(slug) DO UPDATE SET title=EXCLUDED.title,title_id=EXCLUDED.title_id,summary=EXCLUDED.summary,summary_id=EXCLUDED.summary_id,concept_body=EXCLUDED.concept_body,concept_body_id=EXCLUDED.concept_body_id,indonesian_example=EXCLUDED.indonesian_example,why_this_matters=EXCLUDED.why_this_matters,why_this_matters_id=EXCLUDED.why_this_matters_id,common_mistake=EXCLUDED.common_mistake,common_mistake_id=EXCLUDED.common_mistake_id,estimated_minutes=EXCLUDED.estimated_minutes,is_published=TRUE,prerequisite_lesson_id=EXCLUDED.prerequisite_lesson_id,updated_at=NOW()
 RETURNING id
) SELECT 1 FROM inserted;

INSERT INTO public.lesson_reviews(lesson_id,reviewer_name,reviewer_role,review_date,factual_accuracy_status,source_verification_status,indonesia_context_status,compliance_status,notes,approved_to_publish)
SELECT c.id,r.reviewer_name,r.reviewer_role,r.review_date,r.factual_accuracy_status,r.source_verification_status,r.indonesia_context_status,r.compliance_status,'KO-309 split part; verify current tax/provider claims against linked official sources.',r.approved_to_publish
FROM public.lessons c JOIN public.lessons p ON p.slug=CASE WHEN c.slug='tax-basics-npwp-pph-21-and-filing-taxes-part-2' THEN 'tax-basics-npwp-pph-21-and-filing-taxes' ELSE 'brokerage-account-setup-opening-your-rdn' END
JOIN public.lesson_reviews r ON r.lesson_id=p.id
WHERE c.slug IN('tax-basics-npwp-pph-21-and-filing-taxes-part-2','brokerage-account-setup-opening-your-rdn-part-2')
AND NOT EXISTS(SELECT 1 FROM public.lesson_reviews x WHERE x.lesson_id=c.id);

WITH sm(slug,source_code,display_order) AS (
 VALUES
 ('tax-basics-npwp-pph-21-and-filing-taxes','CH08-DJP-SPT',10),('tax-basics-npwp-pph-21-and-filing-taxes','CH08-DJP-SPT-INDIVIDUAL',20),('tax-basics-npwp-pph-21-and-filing-taxes','CH08-DJP-DEADLINES',30),
 ('tax-basics-npwp-pph-21-and-filing-taxes-part-2','CH08-DJP-SPT',10),('tax-basics-npwp-pph-21-and-filing-taxes-part-2','CH08-DJP-SPT-INDIVIDUAL',20),('tax-basics-npwp-pph-21-and-filing-taxes-part-2','CH08-DJP-DEADLINES',30),
 ('brokerage-account-setup-opening-your-rdn','CH08-OJK-RDN',10),('brokerage-account-setup-opening-your-rdn','CH08-OJK-FIND',20),('brokerage-account-setup-opening-your-rdn','CH08-KSEI-RDN',30),
 ('brokerage-account-setup-opening-your-rdn-part-2','CH08-OJK-RDN',10),('brokerage-account-setup-opening-your-rdn-part-2','CH08-OJK-FIND',20),('brokerage-account-setup-opening-your-rdn-part-2','CH08-KSEI-RDN',30)
)
INSERT INTO public.lesson_sources(lesson_id,source_id,relevance_type,citation_label,is_primary,display_order)
SELECT l.id,s.id,CASE WHEN sm.display_order=10 THEN 'primary' ELSE 'supporting' END,sm.source_code,sm.display_order=10,sm.display_order
FROM sm JOIN public.lessons l ON l.slug=sm.slug JOIN public.sources s ON s.source_code=sm.source_code
ON CONFLICT(lesson_id,source_id) DO UPDATE SET relevance_type=EXCLUDED.relevance_type,citation_label=EXCLUDED.citation_label,is_primary=EXCLUDED.is_primary,display_order=EXCLUDED.display_order;

WITH b(slug,block_type,display_order,data_status,content) AS (
 VALUES
 ('tax-basics-npwp-pph-21-and-filing-taxes','process',10,'source_derived',$json${"en":{"title":"Start with records, then check the rule","disclosure":"Use current DJP guidance for the person, income type, instrument, and period; reviewed 2026-08-05.","altText":"A four-step path from identity to records, withholding evidence, and current source checking.","payload":{"steps":[{"title":"1. Identity","description":"Keep the tax identity that applies to you."},{"title":"2. Income","description":"Separate the income types you received."},{"title":"3. Withholding","description":"Save evidence already withheld or paid."},{"title":"4. Source","description":"Check the current DJP rule."}]}},"id":{"title":"Mulai dari catatan, lalu periksa aturan","disclosure":"Gunakan panduan DJP terbaru; ditinjau 5 Agustus 2026.","altText":"Alur empat langkah dari identitas ke catatan, bukti pemotongan, dan sumber terbaru.","payload":{"steps":[{"title":"1. Identitas","description":"Simpan identitas pajak yang berlaku."},{"title":"2. Penghasilan","description":"Pisahkan jenis penghasilan."},{"title":"3. Pemotongan","description":"Simpan bukti pajak."},{"title":"4. Sumber","description":"Periksa aturan DJP terbaru."}]}}}$json$::jsonb),
 ('tax-basics-npwp-pph-21-and-filing-taxes-part-2','process',10,'source_derived',$json${"en":{"title":"Turn records into an SPT checklist","disclosure":"Check current DJP forms, routes, instructions, and deadlines; reviewed 2026-08-05.","altText":"A four-step SPT workflow from records to a saved confirmation.","payload":{"steps":[{"title":"1. Gather","description":"Collect income and withholding records."},{"title":"2. Identify","description":"Find the current form and route."},{"title":"3. Check","description":"Read the official instruction and deadline."},{"title":"4. Save","description":"Submit and keep confirmation."}]}},"id":{"title":"Ubah catatan menjadi daftar periksa SPT","disclosure":"Periksa formulir, jalur, petunjuk, dan tenggat DJP terbaru; ditinjau 5 Agustus 2026.","altText":"Alur SPT empat langkah dari catatan sampai bukti konfirmasi.","payload":{"steps":[{"title":"1. Kumpulkan","description":"Kumpulkan catatan penghasilan."},{"title":"2. Identifikasi","description":"Cari formulir dan jalur terbaru."},{"title":"3. Periksa","description":"Baca petunjuk dan tenggat resmi."},{"title":"4. Simpan","description":"Kirim dan simpan konfirmasi."}]}}}$json$::jsonb),
 ('brokerage-account-setup-opening-your-rdn','process',10,'source_derived',$json${"en":{"title":"Verify the account structure","disclosure":"Use OJK, KSEI, and selected provider documents; reviewed 2026-08-05. No universal provider claim is implied.","altText":"A provider-neutral path from licence checking to account roles, terms, and funding route.","payload":{"steps":[{"title":"1. Licence","description":"Check the provider in a current official record."},{"title":"2. Structure","description":"Understand securities account and RDN roles."},{"title":"3. Terms","description":"Read current documents, fees, and risks."},{"title":"4. Route","description":"Confirm the official funding path."}]}},"id":{"title":"Verifikasi struktur rekening","disclosure":"Gunakan dokumen OJK, KSEI, dan penyedia; ditinjau 5 Agustus 2026. Tidak ada klaim universal.","altText":"Alur netral penyedia dari izin sampai peran rekening, ketentuan, dan jalur dana.","payload":{"steps":[{"title":"1. Izin","description":"Periksa penyedia dalam catatan resmi."},{"title":"2. Struktur","description":"Pahami peran rekening efek dan RDN."},{"title":"3. Ketentuan","description":"Baca dokumen, biaya, dan risiko."},{"title":"4. Jalur","description":"Pastikan jalur dana resmi."}]}}}$json$::jsonb),
 ('brokerage-account-setup-opening-your-rdn-part-2','process',10,'illustrative',$json${"en":{"title":"Pause before a real transfer","disclosure":"Illustrative checklist; follow the selected provider’s current official instructions.","altText":"A five-step safe onboarding checklist that ends with simulated practice.","payload":{"steps":[{"title":"1. Official channel","description":"Open the application from the provider domain."},{"title":"2. Read","description":"Review identity, risk, account, and fee documents."},{"title":"3. Confirm","description":"Check the receiving account."},{"title":"4. Save","description":"Keep agreements and support routes."},{"title":"5. Practise","description":"Use a simulated order."}]}},"id":{"title":"Berhenti sebelum transfer sungguhan","disclosure":"Daftar periksa ilustratif; ikuti petunjuk resmi terbaru penyedia.","altText":"Daftar periksa pendaftaran aman yang berakhir dengan latihan simulasi.","payload":{"steps":[{"title":"1. Kanal resmi","description":"Buka aplikasi dari domain penyedia."},{"title":"2. Baca","description":"Tinjau dokumen identitas, risiko, rekening, dan biaya."},{"title":"3. Pastikan","description":"Periksa rekening tujuan."},{"title":"4. Simpan","description":"Simpan perjanjian dan jalur dukungan."},{"title":"5. Berlatih","description":"Gunakan order simulasi."}]}}}$json$::jsonb)
)
INSERT INTO public.lesson_visual_blocks(lesson_id,placement,block_type,display_order,data_status,content,is_published)
SELECT l.id,'concept',b.block_type,b.display_order,b.data_status,b.content,TRUE FROM b JOIN public.lessons l ON l.slug=b.slug
ON CONFLICT(lesson_id,placement,display_order) DO UPDATE SET block_type=EXCLUDED.block_type,data_status=EXCLUDED.data_status,content=EXCLUDED.content,is_published=TRUE,updated_at=NOW();

WITH q(slug,body,body_id) AS (
 VALUES
 ('tax-basics-npwp-pph-21-and-filing-taxes',$json${"type":"multiple_choice","question":"What should you do before applying a tax example to yourself?","options":["Check your situation and the current DJP rule","Copy the example’s rate","Ignore your records"],"answer":"Check your situation and the current DJP rule","difficulty":"intermediate","explanation":"Tax treatment depends on current rules and your situation."}$json$::jsonb,$json${"type":"multiple_choice","question":"Apa yang dilakukan sebelum menerapkan contoh pajak?","options":["Periksa situasimu dan aturan DJP terbaru","Salin tarif contoh","Abaikan catatan"],"answer":"Periksa situasimu dan aturan DJP terbaru","difficulty":"intermediate","explanation":"Pajak bergantung pada aturan terbaru dan situasimu."}$json$::jsonb),
 ('tax-basics-npwp-pph-21-and-filing-taxes-part-2',$json${"type":"multiple_choice","question":"Which item belongs at the end of a safe SPT workflow?","options":["Save the submission receipt","Forget the deadline","Copy another form"],"answer":"Save the submission receipt","difficulty":"intermediate","explanation":"Keep a record of submission after following current DJP guidance."}$json$::jsonb,$json${"type":"multiple_choice","question":"Item apa yang termasuk di akhir alur SPT?","options":["Simpan bukti penerimaan","Lupakan tenggat","Salin formulir orang lain"],"answer":"Simpan bukti penerimaan","difficulty":"intermediate","explanation":"Simpan bukti setelah mengikuti panduan DJP terbaru."}$json$::jsonb),
 ('brokerage-account-setup-opening-your-rdn',$json${"type":"multiple_choice","question":"What is the safest first question about an RDN provider?","options":["Can I verify the provider and account structure in current official records?","Which app is best for everyone?","Can I transfer to a personal account?"],"answer":"Can I verify the provider and account structure in current official records?","difficulty":"intermediate","explanation":"Use a provider-neutral verification boundary."}$json$::jsonb,$json${"type":"multiple_choice","question":"Apa pertanyaan pertama yang paling aman tentang penyedia RDN?","options":["Bisakah aku memverifikasi penyedia dan struktur rekening dalam catatan resmi terbaru?","Aplikasi mana yang terbaik untuk semua orang?","Bolehkah transfer ke rekening pribadi?"],"answer":"Bisakah aku memverifikasi penyedia dan struktur rekening dalam catatan resmi terbaru?","difficulty":"intermediate","explanation":"Gunakan batas verifikasi yang netral terhadap penyedia."}$json$::jsonb),
 ('brokerage-account-setup-opening-your-rdn-part-2',$json${"type":"multiple_choice","question":"What should you confirm before funding a real account?","options":["The official receiving account and current provider instructions","A message from an unknown person","A guaranteed return"],"answer":"The official receiving account and current provider instructions","difficulty":"intermediate","explanation":"Funding instructions must be checked through the official current channel."}$json$::jsonb,$json${"type":"multiple_choice","question":"Apa yang harus dipastikan sebelum mengisi rekening sungguhan?","options":["Rekening tujuan resmi dan petunjuk terbaru penyedia","Pesan orang tak dikenal","Imbal hasil yang dijamin"],"answer":"Rekening tujuan resmi dan petunjuk terbaru penyedia","difficulty":"intermediate","explanation":"Petunjuk dana harus diperiksa melalui kanal resmi terbaru."}$json$::jsonb)
)
INSERT INTO public.content_variants(lesson_id,variant_type,body,body_id,difficulty,topic_tag,is_active)
SELECT l.id,'question',q.body,q.body_id,'intermediate','visual_applied',TRUE FROM q JOIN public.lessons l ON l.slug=q.slug
WHERE NOT EXISTS(SELECT 1 FROM public.content_variants x WHERE x.lesson_id=l.id AND x.variant_type='question' AND x.topic_tag='visual_applied');

WITH r(slug,question_en,question_id,options_en,options_id,correct_option,explanation_en,explanation_id) AS (
 VALUES
 ('tax-basics-npwp-pph-21-and-filing-taxes','Five days ago, you learned to keep tax records. What should they include?','Lima hari lalu, kamu belajar menyimpan catatan pajak. Apa isinya?',$json$[{"id":"records","label":"Identity, income, withholding, and current source"},{"id":"rate","label":"Only a copied rate"}]$json$::jsonb,$json$[{"id":"records","label":"Identitas, penghasilan, pemotongan, dan sumber terbaru"},{"id":"rate","label":"Hanya tarif yang disalin"}]$json$::jsonb,'records','Records let you compare your situation with the current rule.','Catatan membantu membandingkan situasimu dengan aturan terbaru.'),
 ('tax-basics-npwp-pph-21-and-filing-taxes-part-2','Five days ago, you learned an SPT workflow. What should you keep after submission?','Lima hari lalu, kamu belajar alur SPT. Apa yang disimpan setelah mengirim?',$json$[{"id":"receipt","label":"The submission receipt or confirmation"},{"id":"nothing","label":"Nothing"}]$json$::jsonb,$json$[{"id":"receipt","label":"Bukti penerimaan atau konfirmasi"},{"id":"nothing","label":"Tidak ada"}]$json$::jsonb,'receipt','The receipt is part of a practical record trail.','Bukti penerimaan adalah bagian dari catatan praktis.'),
 ('brokerage-account-setup-opening-your-rdn','Five days ago, you learned a provider-neutral RDN checklist. Which claim is not universal?','Lima hari lalu, kamu belajar daftar periksa RDN netral. Klaim mana yang tidak universal?',$json$[{"id":"provider","label":"A provider’s documents, fees, and timeline"},{"id":"licence","label":"Checking a current licence"}]$json$::jsonb,$json$[{"id":"provider","label":"Dokumen, biaya, dan waktu satu penyedia"},{"id":"licence","label":"Memeriksa izin terbaru"}]$json$::jsonb,'provider','Provider-specific claims need a named provider and current source.','Klaim khusus penyedia memerlukan nama dan sumber terbaru.'),
 ('brokerage-account-setup-opening-your-rdn-part-2','Five days ago, you learned to pause before funding. What should you verify?','Lima hari lalu, kamu belajar berhenti sebelum mengisi dana. Apa yang diverifikasi?',$json$[{"id":"destination","label":"The official destination account and current instructions"},{"id":"personal","label":"A personal account sent in a message"}]$json$::jsonb,$json$[{"id":"destination","label":"Rekening tujuan resmi dan petunjuk terbaru"},{"id":"personal","label":"Rekening pribadi dari pesan"}]$json$::jsonb,'destination','Follow the selected provider’s current official route; Koinaku is simulated.','Ikuti jalur resmi terbaru penyedia; Koinaku bersifat simulasi.')
)
INSERT INTO public.lesson_recall_questions(lesson_id,question_en,question_id,options_en,options_id,correct_option,explanation_en,explanation_id,is_active)
SELECT l.id,r.question_en,r.question_id,r.options_en,r.options_id,r.correct_option,r.explanation_en,r.explanation_id,TRUE FROM r JOIN public.lessons l ON l.slug=r.slug
ON CONFLICT(lesson_id) DO UPDATE SET question_en=EXCLUDED.question_en,question_id=EXCLUDED.question_id,options_en=EXCLUDED.options_en,options_id=EXCLUDED.options_id,correct_option=EXCLUDED.correct_option,explanation_en=EXCLUDED.explanation_en,explanation_id=EXCLUDED.explanation_id,is_active=TRUE,updated_at=NOW();

COMMIT;





