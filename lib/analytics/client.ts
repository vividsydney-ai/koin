import { supabase } from "@/lib/auth/client";

export type AnalyticsEventName =
  | "login"
  | "onboarding_started"
  | "onboarding_assessment_completed"
  | "onboarding_completed"
  | "lesson_started"
  | "lesson_completed"
  | "lesson_completion_failed"
  | "quiz_completed"
  | "trade_onboarding_completed"
  | "trade_executed"
  | "first_trade"
  | "notification_clicked"
  | "share_progress"
  | "streak_reminder_sent";

export interface TrackEventInput {
  userId: string;
  name: AnalyticsEventName;
  properties?: Record<string, unknown>;
}

function getSessionId(): string | undefined {
  if (typeof window === "undefined") return undefined;
  try {
    const key = "koin_analytics_session";
    let sessionId = sessionStorage.getItem(key);
    if (!sessionId) {
      sessionId = crypto.randomUUID();
      sessionStorage.setItem(key, sessionId);
    }
    return sessionId;
  } catch {
    return undefined;
  }
}

/**
 * Fire-and-forget analytics event insert. Failures are logged, not thrown,
 * so business logic is never blocked by instrumentation.
 */
export async function trackEvent(input: TrackEventInput): Promise<void> {
  const { userId, name, properties } = input;
  if (!userId) return;

  const { error } = await supabase.from("analytics_events").insert({
    user_id: userId,
    event_name: name,
    properties: properties ?? {},
    session_id: getSessionId(),
  });

  if (error) {
    console.error("trackEvent error:", error.message);
  }
}
