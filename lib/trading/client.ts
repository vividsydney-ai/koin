import { supabase } from "@/lib/auth/client";

export interface Portfolio {
  id: string;
  userId: string;
  startingCash: number;
  cashBalance: number;
  totalValue: number;
  status: "active" | "graduated";
  createdAt: string;
  updatedAt: string;
}

export interface Holding {
  id: string;
  portfolioId: string;
  symbol: string;
  shares: number;
  averageCost: number;
  currentPrice: number | null;
  lastPriceUpdatedAt: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface Trade {
  id: string;
  portfolioId: string;
  symbol: string;
  tradeType: "buy" | "sell";
  shares: number;
  price: number;
  totalAmount: number;
  lotCount: number;
  createdAt: string;
}

export interface MarketData {
  id: string;
  symbol: string;
  companyName: string | null;
  tradeDate: string;
  closePrice: number;
  volume: number | null;
}

export interface TradeResult {
  tradeId: string;
  symbol: string;
  tradeType: "buy" | "sell";
  shares: number;
  lotCount: number;
  price: number;
  totalAmount: number;
  cashBalance: number;
}

export async function getPortfolio(userId: string): Promise<Portfolio | null> {
  const { data, error } = await supabase
    .from("portfolios")
    .select("id, user_id, starting_cash, cash_balance, total_value, status, created_at, updated_at")
    .eq("user_id", userId)
    .single();

  if (error) {
    if (error.code !== "PGRST116") {
      console.error("getPortfolio error:", error.message);
    }
    return null;
  }

  if (!data) return null;

  return {
    id: data.id,
    userId: data.user_id,
    startingCash: Number(data.starting_cash),
    cashBalance: Number(data.cash_balance),
    totalValue: Number(data.total_value),
    status: data.status as Portfolio["status"],
    createdAt: data.created_at,
    updatedAt: data.updated_at,
  };
}

export async function ensurePortfolio(userId: string): Promise<Portfolio> {
  const existing = await getPortfolio(userId);
  if (existing) return existing;

  const { data, error } = await supabase
    .from("portfolios")
    .insert({
      user_id: userId,
      starting_cash: 10000000,
      cash_balance: 10000000,
      total_value: 10000000,
      status: "active",
    })
    .select("id, user_id, starting_cash, cash_balance, total_value, status, created_at, updated_at")
    .single();

  if (error || !data) {
    console.error("ensurePortfolio error:", error?.message);
    throw new Error(error?.message ?? "Failed to create portfolio");
  }

  return {
    id: data.id,
    userId: data.user_id,
    startingCash: Number(data.starting_cash),
    cashBalance: Number(data.cash_balance),
    totalValue: Number(data.total_value),
    status: data.status as Portfolio["status"],
    createdAt: data.created_at,
    updatedAt: data.updated_at,
  };
}

export async function getHoldings(userId: string): Promise<Holding[]> {
  const { data, error } = await supabase
    .from("holdings")
    .select(
      "id, portfolio_id, symbol, shares, average_cost, current_price, last_price_updated_at, created_at, updated_at, portfolios!inner(user_id)"
    )
    .eq("portfolios.user_id", userId)
    .order("symbol", { ascending: true });

  if (error) {
    console.error("getHoldings error:", error.message);
    return [];
  }

  return (
    data?.map((h) => ({
      id: h.id,
      portfolioId: h.portfolio_id,
      symbol: h.symbol,
      shares: h.shares,
      averageCost: Number(h.average_cost),
      currentPrice: h.current_price ? Number(h.current_price) : null,
      lastPriceUpdatedAt: h.last_price_updated_at,
      createdAt: h.created_at,
      updatedAt: h.updated_at,
    })) ?? []
  );
}

export async function getTrades(userId: string): Promise<Trade[]> {
  const { data, error } = await supabase
    .from("trades")
    .select(
      "id, portfolio_id, symbol, trade_type, shares, price, total_amount, lot_count, created_at, portfolios!inner(user_id)"
    )
    .eq("portfolios.user_id", userId)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("getTrades error:", error.message);
    return [];
  }

  return (
    data?.map((t) => ({
      id: t.id,
      portfolioId: t.portfolio_id,
      symbol: t.symbol,
      tradeType: t.trade_type as Trade["tradeType"],
      shares: t.shares,
      price: Number(t.price),
      totalAmount: Number(t.total_amount),
      lotCount: t.lot_count,
      createdAt: t.created_at,
    })) ?? []
  );
}

export async function getMarketData(): Promise<MarketData[]> {
  const { data, error } = await supabase.rpc("get_latest_market_data");

  if (error) {
    console.error("getMarketData error:", error.message);
    return [];
  }

  return (
    (data as any[])?.map((row) => ({
      id: row.id,
      symbol: row.symbol,
      companyName: row.company_name ?? null,
      tradeDate: row.trade_date,
      closePrice: Number(row.close_price),
      volume: row.volume ?? null,
    })) ?? []
  );
}

export async function executeTrade(
  userId: string,
  symbol: string,
  tradeType: "buy" | "sell",
  lotCount: number
): Promise<TradeResult> {
  const { data, error } = await supabase.rpc("execute_trade", {
    p_user_id: userId,
    p_symbol: symbol,
    p_trade_type: tradeType,
    p_lot_count: lotCount,
  });

  if (error || !data) {
    console.error("executeTrade error:", error?.message);
    throw new Error(error?.message ?? "Trade failed");
  }

  const raw = data as Record<string, unknown>;
  return {
    tradeId: String(raw.trade_id),
    symbol: String(raw.symbol),
    tradeType: raw.trade_type as "buy" | "sell",
    shares: Number(raw.shares),
    lotCount: Number(raw.lot_count),
    price: Number(raw.price),
    totalAmount: Number(raw.total_amount),
    cashBalance: Number(raw.cash_balance),
  };
}
