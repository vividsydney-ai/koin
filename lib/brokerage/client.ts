import { supabase } from "@/lib/auth/client";

export interface BrokerageRecommendation {
  slug: string;
  name: string;
  description: string;
  url: string;
  logoUrl: string | null;
  riskLevel: "beginner" | "intermediate" | "advanced";
  ojkRegistered: boolean;
  productTypes: string[];
}

export async function getBrokerageRecommendations(): Promise<BrokerageRecommendation[]> {
  const { data, error } = await supabase
    .from("brokerage_recommendations")
    .select("slug, name, description, url, logo_url, risk_level, ojk_registered, product_types")
    .eq("is_active", true)
    .order("display_order", { ascending: true });

  if (error) {
    console.error("getBrokerageRecommendations error:", error.message);
    return [];
  }

  return (data ?? []).map((row: Record<string, unknown>) => ({
    slug: String(row.slug ?? ""),
    name: String(row.name ?? ""),
    description: String(row.description ?? ""),
    url: String(row.url ?? ""),
    logoUrl: row.logo_url === null ? null : String(row.logo_url ?? ""),
    riskLevel: row.risk_level as BrokerageRecommendation["riskLevel"],
    ojkRegistered: Boolean(row.ojk_registered ?? false),
    productTypes: (row.product_types ?? []) as string[],
  }));
}
