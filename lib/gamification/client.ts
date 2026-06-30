import { supabase } from "@/lib/auth/client";

export interface UserStats {
  streakDays: number;
  xp: number;
  level: { id: number; name: string } | null;
  koinPoints: number;
  badges: { slug: string; name: string; description: string | null; icon: string }[];
}

export async function getUserStats(userId: string): Promise<UserStats> {
  const defaultStats: UserStats = {
    streakDays: 0,
    xp: 0,
    level: null,
    koinPoints: 0,
    badges: [],
  };

  const { data: streak } = await supabase
    .from("streaks")
    .select("current_streak_days")
    .eq("user_id", userId)
    .single();

  const { data: xpData } = await supabase
    .from("xp_events")
    .select("xp_amount")
    .eq("user_id", userId);

  const totalXp = (xpData ?? []).reduce((sum, e) => sum + (e.xp_amount ?? 0), 0);

  const { data: level } = await supabase
    .from("levels")
    .select("id, name")
    .lte("xp_required", totalXp)
    .order("id", { ascending: false })
    .limit(1)
    .single();

  const { data: koinBalance } = await supabase
    .from("koin_point_balances")
    .select("current_balance")
    .eq("user_id", userId)
    .single();

  const { data: badges } = await supabase
    .from("user_badges")
    .select("badge:badges(slug, name, description, icon)")
    .eq("user_id", userId);

  return {
    streakDays: streak?.current_streak_days ?? 0,
    xp: totalXp,
    level: level ?? null,
    koinPoints: koinBalance?.current_balance ?? 0,
    badges:
      badges?.map((b: any) => ({
        slug: b.badge.slug,
        name: b.badge.name,
        description: b.badge.description,
        icon: b.badge.icon,
      })) ?? [],
  };
}
