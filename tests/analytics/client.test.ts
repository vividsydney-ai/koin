import { describe, it, expect, vi, beforeEach } from "vitest";

const mocks = vi.hoisted(() => ({
  insert: vi.fn().mockReturnValue({ error: null }),
  from: vi.fn().mockReturnValue({ insert: vi.fn().mockReturnValue({ error: null }) }),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: mocks.from,
  },
}));

import { trackEvent, type AnalyticsEventName } from "@/lib/analytics/client";

describe("analytics client", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mocks.from.mockImplementation(() => ({ insert: mocks.insert }));
    mocks.insert.mockReturnValue({ error: null });
  });

  it("inserts an analytics event for the authenticated user", async () => {
    await trackEvent({ userId: "user-1", name: "lesson_started", properties: { lesson_id: "lesson-1" } });

    expect(mocks.from).toHaveBeenCalledWith("analytics_events");
    expect(mocks.insert).toHaveBeenCalledWith(
      expect.objectContaining({
        user_id: "user-1",
        event_name: "lesson_started",
        properties: { lesson_id: "lesson-1" },
      })
    );
  });

  it("skips tracking when userId is missing", async () => {
    await trackEvent({ userId: "", name: "lesson_started" });

    expect(mocks.from).not.toHaveBeenCalled();
  });

  it("logs but does not throw when the insert fails", async () => {
    const consoleError = vi.spyOn(console, "error").mockImplementation(() => {});
    mocks.insert.mockReturnValueOnce({ error: { message: "db down" } });

    await expect(trackEvent({ userId: "user-1", name: "login" })).resolves.toBeUndefined();
    expect(consoleError).toHaveBeenCalledWith("trackEvent error:", "db down");

    consoleError.mockRestore();
  });

  it("exports the expected MVP event names", () => {
    const names: AnalyticsEventName[] = [
      "login",
      "onboarding_started",
      "onboarding_assessment_completed",
      "onboarding_completed",
      "lesson_started",
      "lesson_completed",
      "quiz_completed",
      "trade_onboarding_completed",
      "trade_executed",
      "first_trade",
      "notification_clicked",
      "share_progress",
      "streak_reminder_sent",
    ];
    expect(names).toHaveLength(13);
  });
});
