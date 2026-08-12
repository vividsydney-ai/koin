import { supabase } from "@/lib/auth/client";

export interface PracticeMarketCutoverStatus {
  seasonAccessEnabled: boolean;
  legacyArchived: boolean;
  notice: string;
}

const PREPARING_STATUS: PracticeMarketCutoverStatus = {
  seasonAccessEnabled: false,
  legacyArchived: true,
  notice: "Season 1 is being prepared. Complete Chapter 08 and Before the Bell onboarding to be ready.",
};

/**
 * Reads the small public status projection only. It never falls back to a
 * legacy Paper Trading portfolio, balance, quote, or chart. [KO-417]
 */
export async function getPracticeMarketCutoverStatus(): Promise<PracticeMarketCutoverStatus> {
  const { data, error } = await supabase.rpc("get_practice_market_cutover_status");

  if (error || !data) {
    if (error) {
      console.error("getPracticeMarketCutoverStatus error:", error.message);
    }
    return PREPARING_STATUS;
  }

  const row = Array.isArray(data) ? data[0] : data;
  if (!row || typeof row !== "object") return PREPARING_STATUS;

  const status = row as Record<string, unknown>;
  return {
    seasonAccessEnabled: status.season_access_enabled === true,
    legacyArchived: status.legacy_archived === true,
    notice:
      typeof status.notice === "string" && status.notice.trim()
        ? status.notice
        : PREPARING_STATUS.notice,
  };
}
