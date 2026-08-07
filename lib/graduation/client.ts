import { supabase } from "@/lib/auth/client";

export interface GraduationResult {
  graduated: boolean;
  certificateId?: string;
  certificateCode?: string;
  sharePublicId?: string;
  multiplier?: number;
  totalValue?: number;
  alreadyIssued?: boolean;
}

export async function checkGraduation(userId: string): Promise<GraduationResult | null> {
  const { data, error } = await supabase.rpc("check_graduation", {
    p_user_id: userId,
  });

  if (error || !data) {
    console.error("checkGraduation error:", error?.message);
    return null;
  }

  const raw = data as Record<string, unknown>;
  return {
    graduated: Boolean(raw.graduated),
    certificateId: raw.certificate_id ? String(raw.certificate_id) : undefined,
    certificateCode: raw.certificate_code ? String(raw.certificate_code) : undefined,
    sharePublicId: raw.share_public_id ? String(raw.share_public_id) : undefined,
    multiplier: raw.multiplier ? Number(raw.multiplier) : undefined,
    totalValue: raw.total_value ? Number(raw.total_value) : undefined,
    alreadyIssued: raw.already_issued ? Boolean(raw.already_issued) : undefined,
  };
}

export interface Certificate {
  certificateCode: string;
  portfolioValueAtGraduation: number;
  multiplierAchieved: number;
  issuedAt: string;
  sharePublicId: string | null;
}

export async function getCertificate(userId: string): Promise<Certificate | null> {
  const { data, error } = await supabase
    .from("certificates")
    .select("certificate_code, portfolio_value_at_graduation, multiplier_achieved, issued_at, share_public_id")
    .eq("user_id", userId)
    .single();

  if (error || !data) {
    if (error && error.code !== "PGRST116") {
      console.error("getCertificate error:", error.message);
    }
    return null;
  }

  return {
    certificateCode: data.certificate_code,
    portfolioValueAtGraduation: Number(data.portfolio_value_at_graduation),
    multiplierAchieved: Number(data.multiplier_achieved),
    issuedAt: data.issued_at,
    sharePublicId: data.share_public_id,
  };
}
