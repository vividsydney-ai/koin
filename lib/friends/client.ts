import { supabase } from "@/lib/auth/client";

export interface FriendInvite {
  inviteId: string;
  inviteCode: string;
  usesCount: number;
  maxUses: number;
  expiresAt: string;
}

export async function createFriendInvite(userId: string): Promise<FriendInvite | null> {
  const { data, error } = await supabase.rpc("create_friend_invite", {
    p_user_id: userId,
  });

  if (error || !data) {
    console.error("createFriendInvite error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    inviteId: String(raw.invite_id),
    inviteCode: String(raw.invite_code),
    usesCount: Number(raw.uses_count),
    maxUses: Number(raw.max_uses),
    expiresAt: String(raw.expires_at),
  };
}

export async function acceptFriendInvite(userId: string, code: string): Promise<{ friendshipId: string; status: string } | null> {
  const { data, error } = await supabase.rpc("accept_friend_invite", {
    p_user_id: userId,
    p_invite_code: code,
  });

  if (error || !data) {
    console.error("acceptFriendInvite error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    friendshipId: String(raw.friendship_id),
    status: String(raw.status),
  };
}

export interface Friend {
  userId: string;
  displayName: string;
  avatarUrl: string | null;
  status: "pending" | "accepted" | "declined" | "blocked";
  isRequester: boolean;
}

export async function getFriends(userId: string): Promise<Friend[]> {
  const { data, error } = await supabase
    .from("friendships")
    .select(
      "status, requester_id, addressee_id, requester:profiles!friendships_requester_id_fkey(id, display_name, avatar_url), addressee:profiles!friendships_addressee_id_fkey(id, display_name, avatar_url)"
    )
    .or(`requester_id.eq.${userId},addressee_id.eq.${userId}`)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("getFriends error:", error.message);
    return [];
  }

  return (data ?? []).map((row: any) => {
    const isRequester = row.requester_id === userId;
    const other = isRequester ? row.addressee : row.requester;
    return {
      userId: other?.id ?? "",
      displayName: other?.display_name ?? "Unknown",
      avatarUrl: other?.avatar_url ?? null,
      status: row.status,
      isRequester,
    };
  });
}
