-- KO-LEGAL-001-C: Help content is managed in Supabase, not React constants.
-- Add a support-contact section after the roadmap without changing existing FAQ order.
INSERT INTO public.faq_sections (
  page_key, section_key, display_order, title_en, title_id, is_roadmap, is_published
) VALUES (
  'profile_faq', 'contact_support', 6, 'Contact & support', 'Kontak & dukungan', false, true
)
ON CONFLICT (page_key, section_key) DO UPDATE
SET
  display_order = EXCLUDED.display_order,
  title_en = EXCLUDED.title_en,
  title_id = EXCLUDED.title_id,
  is_roadmap = EXCLUDED.is_roadmap,
  is_published = EXCLUDED.is_published,
  updated_at = now();

INSERT INTO public.faq_entries (
  section_id, entry_key, display_order, question_en, question_id, answer_en, answer_id, is_published
)
SELECT
  section.id,
  'contact_support',
  1,
  'How can I contact Koinaku?',
  'Bagaimana cara menghubungi Koinaku?',
  'For account, privacy, accessibility, or general support questions, email hello@koinaku.com. Please use the email address on your Koinaku account when asking about that account.',
  'Untuk pertanyaan akun, privasi, aksesibilitas, atau dukungan umum, email hello@koinaku.com. Gunakan alamat email yang terhubung ke akun Koinaku kamu saat menanyakan akun tersebut.',
  true
FROM public.faq_sections AS section
WHERE section.page_key = 'profile_faq'
  AND section.section_key = 'contact_support'
ON CONFLICT (entry_key) DO UPDATE
SET
  section_id = EXCLUDED.section_id,
  display_order = EXCLUDED.display_order,
  question_en = EXCLUDED.question_en,
  question_id = EXCLUDED.question_id,
  answer_en = EXCLUDED.answer_en,
  answer_id = EXCLUDED.answer_id,
  is_published = EXCLUDED.is_published,
  updated_at = now();
