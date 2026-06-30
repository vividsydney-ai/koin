import { supabase } from "@/lib/auth/client";

export interface PortfolioSnapshot {
  cashBalance: number;
  totalValue: number;
  startingCash: number;
  returnPct: number;
}

export async function getPortfolioSnapshot(userId: string): Promise<PortfolioSnapshot | null> {
  const { data, error } = await supabase
    .from("portfolios")
    .select("cash_balance, total_value, starting_cash")
    .eq("user_id", userId)
    .single();

  if (error || !data) return null;

  const startingCash = Number(data.starting_cash);
  const totalValue = Number(data.total_value);
  const returnPct = startingCash > 0 ? ((totalValue - startingCash) / startingCash) * 100 : 0;

  return {
    cashBalance: Number(data.cash_balance),
    totalValue,
    startingCash,
    returnPct,
  };
}
