CREATE TABLE public.account_deletion_requests (
  user_id UUID PRIMARY KEY REFERENCES public.profiles(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL UNIQUE,
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  scheduled_for TIMESTAMPTZ NOT NULL,
  cancelled_at TIMESTAMPTZ
);

ALTER TABLE public.account_deletion_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own account deletion request"
  ON public.account_deletion_requests FOR SELECT
  TO authenticated
  USING ((SELECT auth.uid()) = user_id);

CREATE INDEX idx_account_deletion_requests_due
  ON public.account_deletion_requests (scheduled_for)
  WHERE cancelled_at IS NULL;
