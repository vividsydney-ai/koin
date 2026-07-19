import { supabase } from "@/lib/auth/client";

export interface PublicProfile {
  id: string;
  displayName: string;
  avatarUrl: string | null;
  subscriptionTier: "free" | "pro";
}

export async function getPublicProfile(userId: string): Promise<PublicProfile | null> {
  const { data, error } = await supabase.rpc("get_public_profile", {
    p_user_id: userId,
  });

  if (error) {
    console.error("getPublicProfile error:", error.message);
    return null;
  }

  if (!data) return null;

  const raw = data as Record<string, unknown>;
  return {
    id: String(raw.id ?? ""),
    displayName: String(raw.display_name ?? "Unknown"),
    avatarUrl: raw.avatar_url === null || raw.avatar_url === undefined ? null : String(raw.avatar_url),
    subscriptionTier: (raw.subscription_tier === "pro" ? "pro" : "free") as "free" | "pro",
  };
}
