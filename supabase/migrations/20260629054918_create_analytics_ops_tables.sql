-- Migration 013: Analytics and ops tables
-- Notifications queue, content flags, and analytics events.

CREATE TABLE notifications_queue (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  data_json JSONB,
  scheduled_for TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE notifications_queue IS 'Outgoing notification queue per user. RLS: users read own rows only.';

CREATE TABLE content_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  source_id UUID REFERENCES sources(id) ON DELETE CASCADE,
  flagged_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  reason TEXT NOT NULL,
  status TEXT DEFAULT 'open' CHECK (status IN ('open','reviewing','resolved','rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE content_flags IS 'User-submitted flags on lessons or sources. RLS: users read flags they created; admin read all.';

CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  event_name TEXT NOT NULL,
  properties JSONB,
  session_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE analytics_events IS 'Client-side analytics event stream. RLS: users insert own rows; no user read; admin only.';

-- RLS: notifications_queue
ALTER TABLE notifications_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own notifications_queue"
  ON notifications_queue FOR SELECT
  USING (auth.uid() = user_id);

COMMENT ON POLICY "Users read own notifications_queue" ON notifications_queue IS 'Authenticated users can only read their own notification rows.';

-- RLS: content_flags - users read flags they created; admin reads all via service role
ALTER TABLE content_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own content_flags"
  ON content_flags FOR SELECT
  USING (flagged_by = auth.uid());

COMMENT ON POLICY "Users read own content_flags" ON content_flags IS 'Authenticated users can read content flags they created. Admins bypass RLS.';

CREATE POLICY "Users create content_flags"
  ON content_flags FOR INSERT
  WITH CHECK (flagged_by = auth.uid());

COMMENT ON POLICY "Users create content_flags" ON content_flags IS 'Authenticated users can create content flags attributed to themselves.';

-- RLS: analytics_events - users insert own rows; no user read
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users insert own analytics_events"
  ON analytics_events FOR INSERT
  WITH CHECK (auth.uid() = user_id);

COMMENT ON POLICY "Users insert own analytics_events" ON analytics_events IS 'Authenticated users can insert analytics events for themselves. Reads are admin-only via service role.';
