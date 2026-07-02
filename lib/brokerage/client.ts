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

  return (data ?? []).map((row: any) => ({
    slug: row.slug,
    name: row.name,
    description: row.description,
    url: row.url,
    logoUrl: row.logo_url,
    riskLevel: row.risk_level,
    ojkRegistered: row.ojk_registered,
    productTypes: row.product_types ?? [],
  }));
}
