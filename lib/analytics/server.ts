import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import type { AnalyticsEventName } from "./client";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

let adminClient: SupabaseClient | null = null;

function getAdminClient() {
  if (!adminClient) {
    if (!supabaseUrl || !serviceRoleKey) {
      throw new Error("Missing SUPABASE_SERVICE_ROLE_KEY or NEXT_PUBLIC_SUPABASE_URL");
    }
    adminClient = createClient(supabaseUrl, serviceRoleKey);
  }
  return adminClient;
}

export interface TrackServerEventInput {
  userId: string;
  name: AnalyticsEventName;
  properties?: Record<string, unknown>;
  sessionId?: string;
}

/**
 * Insert an analytics event from a server context using the service role key.
 * Used for events triggered by background jobs (e.g. streak reminder emails).
 */
export async function trackServerEvent(input: TrackServerEventInput): Promise<void> {
  const { userId, name, properties, sessionId } = input;
  if (!userId) return;

  const { error } = await getAdminClient().from("analytics_events").insert({
    user_id: userId,
    event_name: name,
    properties: properties ?? {},
    session_id: sessionId ?? null,
  });

  if (error) {
    console.error("trackServerEvent error:", error.message);
  }
}
