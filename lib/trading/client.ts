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

export interface Instrument {
  id: string;
  symbol: string;
  name: string;
  instrumentType: "stock" | "etf";
  exchange: string;
  lotSize: number;
  sourceUrl: string;
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
  sourceUrl: string | null;
  recordedAt: string | null;
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

export interface WatchlistEntry {
  id: string;
  userId: string;
  symbol: string;
  createdAt: string;
}

export interface PortfolioValueSnapshot {
  date: string;
  cashBalance: number;
  holdingsValue: number;
  totalValue: number;
}

export type PortfolioHistoryRange = "1D" | "1M" | "1Y" | "All";

export async function getPortfolio(userId: string): Promise<Portfolio | null> {
  const { data, error } = await supabase
    .from("portfolios")
    .select("id, user_id, starting_cash, cash_balance, total_value, status, created_at, updated_at")
    .eq("user_id", userId)
    .maybeSingle();

  if (error) {
    console.error("getPortfolio error:", error.message);
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

export async function getInstruments(): Promise<Instrument[]> {
  const { data, error } = await supabase
    .from("instruments")
    .select("id, symbol, name, instrument_type, exchange, lot_size, source_url")
    .eq("is_active", true)
    .order("symbol", { ascending: true });

  if (error) {
    console.error("getInstruments error:", error.message);
    return [];
  }

  return (data ?? []).map((row) => ({
    id: row.id,
    symbol: row.symbol,
    name: row.name,
    instrumentType: row.instrument_type as Instrument["instrumentType"],
    exchange: row.exchange,
    lotSize: row.lot_size,
    sourceUrl: row.source_url,
  }));
}

export async function getWatchlist(userId: string): Promise<WatchlistEntry[]> {
  const { data, error } = await supabase
    .from("watchlists")
    .select("id, user_id, symbol, created_at")
    .eq("user_id", userId)
    .order("created_at", { ascending: true });

  if (error) {
    console.error("getWatchlist error:", error.message);
    return [];
  }

  return (data ?? []).map((row) => ({
    id: row.id,
    userId: row.user_id,
    symbol: row.symbol,
    createdAt: row.created_at,
  }));
}

export async function addToWatchlist(userId: string, symbol: string): Promise<void> {
  const { error } = await supabase
    .from("watchlists")
    .upsert({ user_id: userId, symbol: symbol.trim().toUpperCase() }, { onConflict: "user_id,symbol" });

  if (error) throw new Error(error.message);
}

export async function removeFromWatchlist(userId: string, symbol: string): Promise<void> {
  const { error } = await supabase
    .from("watchlists")
    .delete()
    .eq("user_id", userId)
    .eq("symbol", symbol);

  if (error) throw new Error(error.message);
}

const HISTORY_RANGE_DAYS: Record<PortfolioHistoryRange, number | null> = {
  "1D": 1,
  "1M": 31,
  "1Y": 366,
  All: null,
};

export async function getPortfolioValueHistory(
  userId: string,
  range: PortfolioHistoryRange
): Promise<PortfolioValueSnapshot[]> {
  const { data, error } = await supabase.rpc("get_portfolio_value_history", {
    p_user_id: userId,
    p_days: HISTORY_RANGE_DAYS[range],
  });

  if (error) {
    console.error("getPortfolioValueHistory error:", error.message);
    return [];
  }

  return ((data as Array<Record<string, unknown>> | null) ?? []).map((row) => ({
    date: String(row.snapshot_date),
    cashBalance: Number(row.cash_balance),
    holdingsValue: Number(row.holdings_value),
    totalValue: Number(row.total_value),
  }));
}

export async function ensurePortfolio(userId: string): Promise<Portfolio> {
  const existing = await getPortfolio(userId);
  if (existing) return existing;

  throw new Error("Paper portfolio is created when the bonus chest is opened");
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
    sourceUrl: (row.source_url as string | null) ?? null,
    recordedAt: (row.recorded_at as string | null) ?? null,
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

export interface MarketDataPoint {
  date: string;
  close: number;
  isSimulated: boolean;
}

/**
 * Daily close history for one symbol, oldest-first. The market_data table is
 * public-read (no RLS — see migration 008), so this uses a plain table select
 * like the other client queries. Used by the Trade page price chart.
 */
export async function getMarketDataHistory(
  symbol: string,
  days = 30
): Promise<MarketDataPoint[]> {
  const { data, error } = await supabase.rpc("get_market_data_history", {
    p_symbol: symbol.trim().toUpperCase(),
    p_days: days,
  });

  if (error) {
    console.error("getMarketDataHistory error:", error.message);
    return [];
  }

  return (data as Array<Record<string, unknown>> ?? [])
    .map((row) => ({
      date: String(row.trade_date),
      close: Number(row.close_price),
      isSimulated: row.is_simulated === true,
    }))
    .reverse();
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
