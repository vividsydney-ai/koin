import { describe, it, expect, vi, beforeEach } from "vitest";

const mocks = vi.hoisted(() => ({
  select: vi.fn().mockReturnThis(),
  eq: vi.fn().mockReturnThis(),
  order: vi.fn().mockReturnThis(),
  limit: vi.fn().mockResolvedValue({ data: [], error: null }),
  update: vi.fn().mockReturnThis(),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: vi.fn().mockImplementation((table: string) => {
      if (table === "notifications_queue") {
        return {
          select: mocks.select.mockImplementation(() => ({
            eq: mocks.eq.mockImplementation(() => ({
              order: mocks.order.mockImplementation(() => ({
                limit: mocks.limit,
              })),
            })),
          })),
          update: mocks.update.mockImplementation(() => ({
            eq: mocks.eq.mockReturnValue({ error: null }),
          })),
        };
      }
      return {};
    }),
  },
}));

import { getNotifications, markNotificationRead } from "@/lib/notifications/client";

describe("notifications client", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns notifications for a user", async () => {
    mocks.limit.mockResolvedValueOnce({
      data: [
        {
          id: "n1",
          notification_type: "streak_reminder",
          title: "Streak reminder",
          body: "Keep it up",
          read_at: null,
          created_at: "2026-07-16T10:00:00Z",
        },
      ],
      error: null,
    });

    const result = await getNotifications("user-1");

    expect(result).toHaveLength(1);
    expect(result[0].id).toBe("n1");
    expect(result[0].readAt).toBeNull();
  });

  it("returns empty array on error", async () => {
    mocks.limit.mockResolvedValueOnce({ data: null, error: { message: "boom" } });

    const result = await getNotifications("user-1");

    expect(result).toEqual([]);
  });

  it("marks a notification as read", async () => {
    await expect(markNotificationRead("n1")).resolves.toBeUndefined();

    expect(mocks.update).toHaveBeenCalledWith(expect.objectContaining({ read_at: expect.any(String) }));
  });
});
