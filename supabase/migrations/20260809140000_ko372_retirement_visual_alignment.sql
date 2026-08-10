-- KO-372: make the visible BPJS JHT/DPLK comparison, alt text, source links,
-- and visual-applied assessment describe the same two-column teaching model.
BEGIN;

INSERT INTO public.sources (
  source_code, title, local_title, source_tier, source_type, organization, url,
  language, last_checked_at, status, trust_notes, localization_notes,
  synopsis, synopsis_id, relevance_blurb, relevance_blurb_id
)
VALUES
  (
    'CH05-BPJS-JHT',
    'BPJS Ketenagakerjaan JHT claim guidance',
    'Panduan klaim JHT BPJS Ketenagakerjaan',
    1, 'website', 'BPJS Ketenagakerjaan',
    'https://www.bpjsketenagakerjaan.go.id/artikel/18927/artikel-kriteria-pengajuan-klaim-jht-%28jaminan-hari-tua%29-dan-dokumen-pendukung.bpjs',
    'id', '2026-08-09', 'verified',
    'Official BPJS Ketenagakerjaan explanation of JHT as a social-protection programme and its current claim boundary.',
    'Use for role and current-terms verification only; claim conditions can change.',
    'Official BPJS Ketenagakerjaan guidance describing JHT as a programme that pays a cash benefit under specified old-age, disability, death, and employment-ending conditions.',
    'Panduan resmi BPJS Ketenagakerjaan yang menjelaskan JHT sebagai program dengan manfaat uang tunai dalam kondisi usia tua, cacat, meninggal, dan kondisi kerja tertentu.',
    'Use this to verify the current official role and conditions of JHT before treating a product detail as current.',
    'Gunakan ini untuk memverifikasi peran dan ketentuan resmi JHT terbaru sebelum menganggap detail produk sebagai informasi terkini.'
  ),
  (
    'CH05-OJK-DPLK',
    'OJK regulation on pension-fund licensing and institutions',
    'Peraturan OJK tentang perizinan dan kelembagaan dana pensiun',
    1, 'regulation', 'OJK',
    'https://www.ojk.go.id/id/regulasi/Pages/POJK-35-Tahun-2024-Perizinan-dan-Kelembagaan-Dana-Pensiun.aspx',
    'id', '2026-08-09', 'verified',
    'Current OJK regulatory page covering pension-fund institutions, including DPLK governance and licensing context.',
    'Use for institutional definitions and current-rule checks; do not infer provider-specific fees or returns.',
    'Official OJK regulation page covering pension-fund licensing and institutions, including the governance context for DPLK.',
    'Halaman regulasi resmi OJK tentang perizinan dan kelembagaan dana pensiun, termasuk konteks tata kelola DPLK.',
    'Use this to distinguish an institutional pension route from an employment-linked benefit and to check current terms.',
    'Gunakan ini untuk membedakan jalur pensiun melalui lembaga dari manfaat terkait pekerjaan dan untuk memeriksa ketentuan terbaru.'
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

WITH links(source_code, relevance_type, is_primary, display_order) AS (VALUES
  ('CH05-BPJS-JHT', 'primary', TRUE, 10),
  ('CH05-OJK-DPLK', 'supporting', FALSE, 20)
)
INSERT INTO public.lesson_sources (lesson_id, source_id, relevance_type, citation_label, is_primary, display_order)
SELECT lesson.id, source.id, links.relevance_type, links.source_code, links.is_primary, links.display_order
FROM links
JOIN public.lessons AS lesson ON lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
JOIN public.sources AS source ON source.source_code = links.source_code
ON CONFLICT (lesson_id, source_id) DO UPDATE SET
  relevance_type = EXCLUDED.relevance_type,
  citation_label = EXCLUDED.citation_label,
  is_primary = EXCLUDED.is_primary,
  display_order = EXCLUDED.display_order;

UPDATE public.lesson_sources AS link
SET is_primary = FALSE
FROM public.lessons AS lesson, public.sources AS source
WHERE link.lesson_id = lesson.id
  AND lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
  AND source.id = link.source_id
  AND source.source_code <> 'CH05-BPJS-JHT';

UPDATE public.lesson_visual_blocks AS block
SET data_status = 'source_derived',
    content = $json${"en":{"icon":"🧰","eyebrow":"Retirement tools","title":"Compare BPJS JHT and DPLK by role and terms","altText":"A two-column comparison shows BPJS JHT as an employment-linked old-age programme and DPLK as a retirement route through a financial institution, then distinguishes their access rules and terms.","disclosure":"Check current official terms before acting; this comparison is educational and does not endorse a product.","payload":{"leftTitle":"BPJS JHT","rightTitle":"DPLK","rows":[{"left":"Employment-linked old-age programme","right":"Retirement route through a financial institution"},{"left":"Has its own access and claim rules","right":"Has its own fees, access, and product terms"},{"left":"Verify current conditions with BPJS Ketenagakerjaan","right":"Verify current conditions with OJK and the institution"}]}},"id":{"icon":"🧰","eyebrow":"Alat pensiun","title":"Bandingkan BPJS JHT dan DPLK berdasarkan peran dan ketentuan","altText":"Perbandingan dua kolom menunjukkan BPJS JHT sebagai program hari tua terkait pekerjaan dan DPLK sebagai jalur pensiun melalui lembaga keuangan, lalu membedakan aturan akses serta ketentuannya.","disclosure":"Periksa ketentuan resmi terbaru sebelum bertindak; perbandingan ini bersifat edukatif dan tidak mendukung produk tertentu.","payload":{"leftTitle":"BPJS JHT","rightTitle":"DPLK","rows":[{"left":"Program hari tua terkait pekerjaan","right":"Jalur pensiun melalui lembaga keuangan"},{"left":"Memiliki aturan akses dan klaim sendiri","right":"Memiliki biaya, akses, dan ketentuan produk sendiri"},{"left":"Verifikasi ketentuan terbaru ke BPJS Ketenagakerjaan","right":"Verifikasi ketentuan terbaru ke OJK dan lembaga terkait"}]}}}$json$::jsonb,
    updated_at = NOW()
FROM public.lessons AS lesson
WHERE block.lesson_id = lesson.id
  AND lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
  AND block.placement = 'concept'
  AND block.display_order = 10;

DELETE FROM public.lesson_visual_block_sources AS visual_link
USING public.lesson_visual_blocks AS block, public.lessons AS lesson
WHERE visual_link.visual_block_id = block.id
  AND block.lesson_id = lesson.id
  AND lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
  AND block.placement = 'concept'
  AND block.display_order = 10;

WITH sources(source_code) AS (VALUES ('CH05-BPJS-JHT'), ('CH05-OJK-DPLK'))
INSERT INTO public.lesson_visual_block_sources (visual_block_id, source_id, citation_label)
SELECT block.id, source.id, source.source_code
FROM sources
JOIN public.lessons AS lesson ON lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
JOIN public.lesson_visual_blocks AS block ON block.lesson_id = lesson.id AND block.placement = 'concept' AND block.display_order = 10
JOIN public.sources AS source ON source.source_code = sources.source_code
ON CONFLICT (visual_block_id, source_id) DO UPDATE SET citation_label = EXCLUDED.citation_label;

DELETE FROM public.content_variants AS variant
USING public.lessons AS lesson
WHERE variant.lesson_id = lesson.id
  AND lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early'
  AND variant.variant_type = 'question'
  AND variant.topic_tag = 'visual_applied';

WITH applied(body, body_id) AS (VALUES
  (
    '{"type":"matching","difficulty":"beginner","question":"Match each visible retirement tool with the role shown in the two-column comparison.","pairs":[["BPJS JHT","Employment-linked old-age programme"],["DPLK","Retirement route through a financial institution"]],"answer":{"BPJS JHT":"Employment-linked old-age programme","DPLK":"Retirement route through a financial institution"},"explanation":"The visual compares two tools with different roles and terms. It does not show a third product column.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb,
    '{"type":"matching","difficulty":"beginner","question":"Pasangkan setiap alat pensiun yang terlihat dengan peran pada perbandingan dua kolom.","pairs":[["BPJS JHT","Program hari tua terkait pekerjaan"],["DPLK","Jalur pensiun melalui lembaga keuangan"]],"answer":{"BPJS JHT":"Program hari tua terkait pekerjaan","DPLK":"Jalur pensiun melalui lembaga keuangan"},"explanation":"Visual membandingkan dua alat dengan peran dan ketentuan yang berbeda. Visual ini tidak menampilkan kolom produk ketiga.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb
  ),
  (
    '{"type":"multiple_choice","difficulty":"beginner","question":"What should a learner check before relying on a BPJS JHT or DPLK product detail?","options":["Current official terms, access rules, fees, and risks","Only the product name","A return promise from a social post","A friend''s result as a guarantee"],"answer":"Current official terms, access rules, fees, and risks","explanation":"The visual tells you to verify the current conditions with the relevant official body or institution.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb,
    '{"type":"multiple_choice","difficulty":"beginner","question":"Apa yang perlu diperiksa sebelum mengandalkan detail produk BPJS JHT atau DPLK?","options":["Ketentuan resmi terbaru, aturan akses, biaya, dan risiko","Hanya nama produk","Janji imbal hasil dari unggahan media sosial","Hasil teman sebagai jaminan"],"answer":"Ketentuan resmi terbaru, aturan akses, biaya, dan risiko","explanation":"Visual mengarahkanmu untuk memverifikasi ketentuan terbaru dengan badan resmi atau lembaga terkait.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb
  ),
  (
    '{"type":"true_false","difficulty":"beginner","question":"BPJS JHT and DPLK have identical access rules and product terms.","options":["True","False"],"answer":false,"explanation":"The two-column visual explicitly separates their roles and terms, so current conditions must be checked independently.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb,
    '{"type":"true_false","difficulty":"beginner","question":"BPJS JHT dan DPLK memiliki aturan akses serta ketentuan produk yang identik.","options":["Benar","Salah"],"answer":false,"explanation":"Visual dua kolom memisahkan peran dan ketentuannya, sehingga kondisi terbaru perlu diperiksa secara mandiri.","parameters":{"visual":"retirement-planning-bpjs-dplk-and-starting-early"}}'::jsonb
  )
)
INSERT INTO public.content_variants (lesson_id, variant_type, body, body_id, difficulty, topic_tag, is_active)
SELECT lesson.id, 'question', applied.body, applied.body_id, 'beginner', 'visual_applied', TRUE
FROM applied
JOIN public.lessons AS lesson ON lesson.slug = 'retirement-planning-bpjs-dplk-and-starting-early';

COMMIT;
