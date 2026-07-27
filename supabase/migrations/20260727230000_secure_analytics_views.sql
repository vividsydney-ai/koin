-- KO-ANALYTICS-001: make reporting views honor the caller's RLS policies.
-- These views do not need elevated privileges; SECURITY INVOKER prevents a
-- view owner from bypassing RLS on analytics_events and profiles.
BEGIN;

ALTER VIEW public.analytics_first_trade SET (security_invoker = true);
ALTER VIEW public.analytics_dau SET (security_invoker = true);
ALTER VIEW public.analytics_activation SET (security_invoker = true);
ALTER VIEW public.analytics_retention SET (security_invoker = true);
ALTER VIEW public.analytics_lesson_completion SET (security_invoker = true);

COMMIT;
