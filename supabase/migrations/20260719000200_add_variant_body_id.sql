-- Add Indonesian localization column to content_variants.
-- body_id mirrors the structure of body but holds the Bahasa Indonesia version.
alter table public.content_variants
add column if not exists body_id jsonb null;

-- Index to speed up locale checks when filtering active variants by lesson.
create index if not exists idx_content_variants_lesson_active_body_id
on public.content_variants (lesson_id, is_active)
where body_id is not null;

comment on column public.content_variants.body_id is
'Indonesian (id) localization of the variant body. Same JSON schema as body.';
