-- KO-213: Reconcile lesson-specific achievement badges with the current curriculum.
-- The curriculum re-org replaced three legacy lesson slugs. Keep the badge
-- identities and icons stable, but point their award triggers at the published
-- lessons learners can actually complete.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.lessons
    WHERE slug = 'budgeting-101' AND is_published = TRUE
  ) THEN
    RAISE EXCEPTION 'KO-213 requires published lesson budgeting-101';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.lessons
    WHERE slug = 'risk-return-101' AND is_published = TRUE
  ) THEN
    RAISE EXCEPTION 'KO-213 requires published lesson risk-return-101';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.lessons
    WHERE slug = 'fz-scam-red-flags' AND is_published = TRUE
  ) THEN
    RAISE EXCEPTION 'KO-213 requires published lesson fz-scam-red-flags';
  END IF;
END
$$;

UPDATE public.badges
SET trigger_value = jsonb_build_object('lesson_slug', 'budgeting-101'),
    description = 'Complete the Budgeting lesson',
    description_id = 'Selesaikan pelajaran Anggaran'
WHERE slug = 'budget_beginner';

UPDATE public.badges
SET trigger_value = jsonb_build_object('lesson_slug', 'risk-return-101'),
    description = 'Complete the Risk and Return lesson',
    description_id = 'Selesaikan pelajaran Risiko dan Pengembalian'
WHERE slug = 'compound_wizard';

UPDATE public.badges
SET trigger_value = jsonb_build_object('lesson_slug', 'fz-scam-red-flags'),
    description = 'Complete the Scam Red Flags lesson',
    description_id = 'Selesaikan pelajaran Tanda-Tanda Penipuan'
WHERE slug = 'scam_spotter';

COMMIT;
