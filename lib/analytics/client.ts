import { supabase } from "@/lib/auth/client";

const SESSION_COOKIE = "koin_analytics_session";

function getCookie(name: string): string | undefined {
  if (typeof document === "undefined") return undefined;
  const match = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + "=([^;]*)"));
  return match ? decodeURIComponent(match[1]) : undefined;
}

function setCookie(name: string, value: string, maxAgeSeconds: number): void {
  if (typeof document === "undefined") return;
  const secure = location.protocol === "https:" ? "; Secure" : "";
  document.cookie = `${name}=${encodeURIComponent(value)}; path=/; max-age=${maxAgeSeconds}; SameSite=Lax${secure}`;
}

export type AnalyticsEventName =
  | "login"
  | "onboarding_started"
  | "onboarding_replay_started"
  | "onboarding_assessment_completed"
  | "onboarding_completed"
  | "onboarding_replay_completed"
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
    let sessionId = getCookie(SESSION_COOKIE);
    if (!sessionId) {
      sessionId = crypto.randomUUID();
      // 4-hour analytics session, renewed on each event.
      setCookie(SESSION_COOKIE, sessionId, 4 * 60 * 60);
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
