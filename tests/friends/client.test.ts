import { describe, it, expect, vi, beforeEach } from "vitest";

const mockRpc = vi.fn();
const mockFrom = vi.fn();
const mockSelect = vi.fn();
const mockOr = vi.fn();
const mockOrder = vi.fn();

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    rpc: (...args: unknown[]) => mockRpc(...args),
    from: (table: string) => mockFrom(table),
  },
}));

mockFrom.mockReturnValue({
  select: mockSelect,
});

mockSelect.mockReturnValue({
  or: mockOr,
});

mockOr.mockReturnValue({
  order: mockOrder,
});

import { addFriendByQr, getFriends } from "@/lib/friends/client";

describe("friends client", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("addFriendByQr", () => {
    it("returns friendship id and status on success", async () => {
      mockRpc.mockResolvedValue({
        data: { friendship_id: "friendship-1", status: "accepted" },
        error: null,
      });

      const result = await addFriendByQr("user-2");

      expect(result).toEqual({ friendshipId: "friendship-1", status: "accepted" });
      expect(mockRpc).toHaveBeenCalledWith("add_friend_by_qr", {
        p_scanned_user_id: "user-2",
      });
    });

    it("returns null when RPC returns an error", async () => {
      mockRpc.mockResolvedValue({
        data: null,
        error: { message: "User not found" },
      });

      const result = await addFriendByQr("user-2");

      expect(result).toBeNull();
    });

    it("returns null when RPC returns no data", async () => {
      mockRpc.mockResolvedValue({ data: null, error: null });

      const result = await addFriendByQr("user-2");

      expect(result).toBeNull();
    });
  });

  describe("getFriends", () => {
    it("maps requester rows to Friend shape", async () => {
      mockOrder.mockResolvedValue({
        data: [
          {
            status: "accepted",
            requester_id: "user-1",
            addressee_id: "user-2",
            requester: { id: "user-1", display_name: "Budi", avatar_url: null },
            addressee: { id: "user-2", display_name: "Ani", avatar_url: "https://example.com/ani.png" },
          },
        ],
        error: null,
      });

      const result = await getFriends("user-1");

      expect(result).toHaveLength(1);
      expect(result[0]).toEqual({
        userId: "user-2",
        displayName: "Ani",
        avatarUrl: "https://example.com/ani.png",
        status: "accepted",
        isRequester: true,
      });
    });

    it("maps addressee rows to Friend shape", async () => {
      mockOrder.mockResolvedValue({
        data: [
          {
            status: "pending",
            requester_id: "user-2",
            addressee_id: "user-1",
            requester: { id: "user-2", display_name: "Ani", avatar_url: null },
            addressee: { id: "user-1", display_name: "Budi", avatar_url: null },
          },
        ],
        error: null,
      });

      const result = await getFriends("user-1");

      expect(result[0].isRequester).toBe(false);
      expect(result[0].userId).toBe("user-2");
      expect(result[0].displayName).toBe("Ani");
    });

    it("returns empty array on error", async () => {
      mockOrder.mockResolvedValue({ data: null, error: { message: "network" } });

      const result = await getFriends("user-1");

      expect(result).toEqual([]);
    });
  });
});
