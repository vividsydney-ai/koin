-- KO-214: award First Friend for existing and future accepted friendships.
-- The original badge was seeded as a social milestone, but the friendship RPC
-- never wrote the corresponding user_badges row.

BEGIN;

INSERT INTO public.badges (id, slug, name, name_id, description, description_id, icon, trigger_type, trigger_value)
SELECT gen_random_uuid(), 'first_friend', 'First Friend', 'Teman Pertama', 'Have a friend accept your invite', 'Undang teman dan dapatkan persetujuan', '🤝', 'social', '{"event": "friend_accepted"}'::jsonb
WHERE NOT EXISTS (SELECT 1 FROM public.badges WHERE slug = 'first_friend');

CREATE OR REPLACE FUNCTION public.award_first_friend_badge(p_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.user_badges (user_id, badge_id)
  SELECT p_user_id, b.id
  FROM public.badges b
  WHERE b.slug = 'first_friend'
  ON CONFLICT (user_id, badge_id) DO NOTHING;
END;
$$;

COMMENT ON FUNCTION public.award_first_friend_badge(UUID)
  IS 'Internal idempotent award helper for the first accepted friendship.';
REVOKE ALL ON FUNCTION public.award_first_friend_badge(UUID) FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.award_first_friend_badges_on_accept()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.status = 'accepted' THEN
    PERFORM public.award_first_friend_badge(NEW.requester_id);
    PERFORM public.award_first_friend_badge(NEW.addressee_id);
  END IF;
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.award_first_friend_badges_on_accept()
  IS 'Internal trigger that awards First Friend to both sides of an accepted friendship.';
REVOKE ALL ON FUNCTION public.award_first_friend_badges_on_accept() FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS friendships_award_first_friend_badge ON public.friendships;
CREATE TRIGGER friendships_award_first_friend_badge
  AFTER INSERT OR UPDATE OF status ON public.friendships
  FOR EACH ROW
  WHEN (NEW.status = 'accepted')
  EXECUTE FUNCTION public.award_first_friend_badges_on_accept();

-- Backfill every participant in an accepted friendship. The unique constraint
-- keeps this safe if the migration is retried or a user already has the badge.
INSERT INTO public.user_badges (user_id, badge_id)
SELECT eligible.user_id, b.id
FROM (
  SELECT requester_id AS user_id
  FROM public.friendships
  WHERE status = 'accepted'
  UNION
  SELECT addressee_id AS user_id
  FROM public.friendships
  WHERE status = 'accepted'
) AS eligible
CROSS JOIN public.badges b
WHERE b.slug = 'first_friend'
ON CONFLICT (user_id, badge_id) DO NOTHING;

COMMIT;
