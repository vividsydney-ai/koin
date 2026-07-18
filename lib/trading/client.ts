import { supabase } from "@/lib/auth/client";
import * as tradingService from "@/lib/services/trading";

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
  isSimulated: boolean;
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

const MARKET_DATA_TTL_MS = 5 * 60 * 1000; // 5 minutes

const marketDataCache: {
  data: MarketData[] | null;
  promise: Promise<MarketData[]> | null;
  timestamp: number;
} = {
  data: null,
  promise: null,
  timestamp: 0,
};

function mapMarketDataRow(row: Record<string, unknown>): MarketData {
  return {
    id: String(row.id),
    symbol: String(row.symbol),
    companyName: (row.company_name as string | null) ?? null,
    tradeDate: String(row.trade_date),
    closePrice: Number(row.close_price),
    volume: (row.volume as number | null) ?? null,
    isSimulated: row.is_simulated === true,
  };
}

export async function getMarketData(): Promise<MarketData[]> {
  const now = Date.now();

  // Return fresh cached data immediately.
  if (marketDataCache.data && now - marketDataCache.timestamp < MARKET_DATA_TTL_MS) {
    return marketDataCache.data;
  }

  // Deduplicate in-flight requests so concurrent callers share one network call.
  if (!marketDataCache.promise) {
    marketDataCache.promise = Promise.resolve(supabase.rpc("get_latest_market_data"))
      .then(({ data, error }) => {
        if (error) {
          console.error("getMarketData error:", error.message);
          return [];
        }
        const mapped = ((data as Record<string, unknown>[]) ?? []).map(mapMarketDataRow);
        marketDataCache.data = mapped;
        marketDataCache.timestamp = Date.now();
        return mapped;
      })
      .finally(() => {
        marketDataCache.promise = null;
      });
  }

  return marketDataCache.promise;
}

/** Exported for tests. */
export function __resetMarketDataCache() {
  marketDataCache.data = null;
  marketDataCache.promise = null;
  marketDataCache.timestamp = 0;
}

export async function executeTrade(
  userId: string,
  symbol: string,
  tradeType: "buy" | "sell",
  lotCount: number
): Promise<TradeResult> {
  const result = await tradingService.executeTrade({ userId, symbol, tradeType, lotCount });
  if (!result.ok) {
    console.error("executeTrade error:", result.error.message);
    throw new Error(result.error.message);
  }
  return result.data;
}
