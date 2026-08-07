import { supabase } from "@/lib/auth/client";

export interface Friend {
  userId: string;
  displayName: string;
  avatarUrl: string | null;
  status: "pending" | "accepted" | "declined" | "blocked";
  isRequester: boolean;
}

export async function addFriendByQr(
  scannedUserId: string
): Promise<{ friendshipId: string; status: string } | null> {
  const { data, error } = await supabase.rpc("add_friend_by_qr", {
    p_scanned_user_id: scannedUserId,
  });

  if (error || !data) {
    console.error("addFriendByQr error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    friendshipId: String(raw.friendship_id),
    status: String(raw.status),
  };
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

  return (data ?? []).map((row: Record<string, unknown>) => {
    const isRequester = row.requester_id === userId;
    const other = (isRequester ? row.addressee : row.requester) as Record<string, unknown> | undefined;
    return {
      userId: String(other?.id ?? ""),
      displayName: String(other?.display_name ?? "Unknown"),
      avatarUrl: other?.avatar_url === null || other?.avatar_url === undefined ? null : String(other.avatar_url),
      status: row.status as Friend["status"],
      isRequester,
    };
  });
}
