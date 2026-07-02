"use client";

import { useEffect, useMemo, useState } from "react";
import { useAuth } from "@/lib/auth/use-auth";
import {
  getPortfolio,
  getHoldings,
  getTrades,
  getMarketData,
  executeTrade,
  ensurePortfolio,
  type Portfolio,
  type Holding,
  type Trade,
  type MarketData,
} from "@/lib/trading/client";

const SHARES_PER_LOT = 100;

export default function TradePage() {
  const { user } = useAuth(true);
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [holdings, setHoldings] = useState<Holding[]>([]);
  const [trades, setTrades] = useState<Trade[]>([]);
  const [marketData, setMarketData] = useState<MarketData[]>([]);
  const [loading, setLoading] = useState(true);
  const [executing, setExecuting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const [symbol, setSymbol] = useState("");
  const [tradeType, setTradeType] = useState<"buy" | "sell">("buy");
  const [lotCount, setLotCount] = useState(1);

  const loadAll = async () => {
    if (!user) return;
    setLoading(true);
    setError(null);
    try {
      const [p, h, t, m] = await Promise.all([
        getPortfolio(user.id),
        getHoldings(user.id),
        getTrades(user.id),
        getMarketData(),
      ]);
      setPortfolio(p);
      setHoldings(h);
      setTrades(t);
      setMarketData(m);
      if (!symbol && m.length > 0) {
        setSymbol(m[0].symbol);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    let mounted = true;
    const run = async () => {
      if (!user) return;
      if (!mounted) return;
      await loadAll();
    };
    run();
    return () => {
      mounted = false;
    };
  }, [user]);

  const selectedPrice = useMemo(() => {
    const row = marketData.find((m) => m.symbol === symbol);
    return row?.closePrice ?? 0;
  }, [marketData, symbol]);

  const estimatedTotal = useMemo(() => {
    return selectedPrice * lotCount * SHARES_PER_LOT;
  }, [selectedPrice, lotCount]);

  const canSubmit = Boolean(symbol && lotCount > 0 && selectedPrice > 0 && !executing);

  const handleExecute = async () => {
    if (!user || !canSubmit) return;
    setExecuting(true);
    setError(null);
    setSuccess(null);
    try {
      await ensurePortfolio(user.id);
      await executeTrade(user.id, symbol, tradeType, lotCount);
      setSuccess(
        `${tradeType === "buy" ? "Bought" : "Sold"} ${lotCount} lot${lotCount === 1 ? "" : "s"} of ${symbol}`
      );
      await loadAll();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Trade failed");
    } finally {
      setExecuting(false);
    }
  };

  const portfolioValue = useMemo(() => {
    const holdingsValue = holdings.reduce((sum, h) => {
      const price =
        marketData.find((m) => m.symbol === h.symbol)?.closePrice ??
        h.currentPrice ??
        h.averageCost;
      return sum + h.shares * price;
    }, 0);
    return (portfolio?.cashBalance ?? 0) + holdingsValue;
  }, [portfolio, holdings, marketData]);

  const totalReturnPct = useMemo(() => {
    if (!portfolio || portfolio.startingCash === 0) return 0;
    return ((portfolioValue - portfolio.startingCash) / portfolio.startingCash) * 100;
  }, [portfolio, portfolioValue]);

  return (
    <div className="min-h-screen bg-background p-5 pb-28">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Trade</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Practice buying and selling Indonesian stocks with paper money.
        </p>
      </header>

      {loading ? (
        <div className="space-y-3">
          <div className="h-32 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-48 animate-pulse rounded-radius-lg bg-muted" />
          <div className="h-48 animate-pulse rounded-radius-lg bg-muted" />
        </div>
      ) : (
        <div className="space-y-5">
          <PortfolioSummaryCard
            portfolio={portfolio}
            portfolioValue={portfolioValue}
            totalReturnPct={totalReturnPct}
          />

          <OrderCard
            symbol={symbol}
            setSymbol={setSymbol}
            tradeType={tradeType}
            setTradeType={setTradeType}
            lotCount={lotCount}
            setLotCount={setLotCount}
            marketData={marketData}
            selectedPrice={selectedPrice}
            estimatedTotal={estimatedTotal}
            canSubmit={canSubmit}
            executing={executing}
            error={error}
            success={success}
            cashBalance={portfolio?.cashBalance ?? 0}
            holdings={holdings}
            onExecute={handleExecute}
          />

          <HoldingsCard holdings={holdings} marketData={marketData} />
          <TradesCard trades={trades} />
        </div>
      )}
    </div>
  );
}

function PortfolioSummaryCard({
  portfolio,
  portfolioValue,
  totalReturnPct,
}: {
  portfolio: Portfolio | null;
  portfolioValue: number;
  totalReturnPct: number;
}) {
  const positive = totalReturnPct >= 0;

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Portfolio value
          </p>
          <p className="mt-1 text-2xl font-bold text-foreground">
            Rp {Math.round(portfolioValue).toLocaleString("id-ID")}
          </p>
          <p className={`text-xs font-medium ${positive ? "text-success" : "text-danger"}`}>
            {positive ? "+" : ""}
            {totalReturnPct.toFixed(2)}%
          </p>
        </div>
        <div className="text-right">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Cash
          </p>
          <p className="mt-1 text-sm font-semibold text-foreground">
            Rp {Math.round(portfolio?.cashBalance ?? 0).toLocaleString("id-ID")}
          </p>
        </div>
      </div>
    </div>
  );
}

function OrderCard({
  symbol,
  setSymbol,
  tradeType,
  setTradeType,
  lotCount,
  setLotCount,
  marketData,
  selectedPrice,
  estimatedTotal,
  canSubmit,
  executing,
  error,
  success,
  cashBalance,
  holdings,
  onExecute,
}: {
  symbol: string;
  setSymbol: (s: string) => void;
  tradeType: "buy" | "sell";
  setTradeType: (t: "buy" | "sell") => void;
  lotCount: number;
  setLotCount: (n: number) => void;
  marketData: MarketData[];
  selectedPrice: number;
  estimatedTotal: number;
  canSubmit: boolean;
  executing: boolean;
  error: string | null;
  success: string | null;
  cashBalance: number;
  holdings: Holding[];
  onExecute: () => void;
}) {
  const holding = holdings.find((h) => h.symbol === symbol);
  const maxBuyLots = selectedPrice > 0 ? Math.floor(cashBalance / (selectedPrice * SHARES_PER_LOT)) : 0;
  const maxSellLots = holding ? Math.floor(holding.shares / SHARES_PER_LOT) : 0;

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Place an order
      </p>

      <div className="mt-4 grid grid-cols-2 gap-2 rounded-radius-md bg-muted p-1">
        <button
          onClick={() => setTradeType("buy")}
          className={`rounded-radius-sm py-2 text-sm font-semibold transition-colors ${
            tradeType === "buy"
              ? "bg-surface text-success shadow-sm"
              : "text-muted-foreground hover:text-foreground"
          }`}
        >
          Buy
        </button>
        <button
          onClick={() => setTradeType("sell")}
          className={`rounded-radius-sm py-2 text-sm font-semibold transition-colors ${
            tradeType === "sell"
              ? "bg-surface text-danger shadow-sm"
              : "text-muted-foreground hover:text-foreground"
          }`}
        >
          Sell
        </button>
      </div>

      <div className="mt-4 space-y-4">
        <div>
          <label htmlFor="symbol" className="block text-sm font-medium text-foreground">
            Stock
          </label>
          <select
            id="symbol"
            value={symbol}
            onChange={(e) => setSymbol(e.target.value)}
            className="mt-1.5 w-full rounded-radius-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          >
            {marketData.map((m) => (
              <option key={m.symbol} value={m.symbol}>
                {m.symbol} — Rp {m.closePrice.toLocaleString("id-ID")}
                {m.companyName ? ` (${m.companyName})` : ""}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="lots" className="block text-sm font-medium text-foreground">
            Lots (1 lot = 100 shares)
          </label>
          <input
            id="lots"
            type="number"
            min={1}
            value={lotCount}
            onChange={(e) => {
              const n = parseInt(e.target.value, 10);
              setLotCount(Number.isNaN(n) ? 1 : Math.max(1, n));
            }}
            className="mt-1.5 w-full rounded-radius-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          />
          {tradeType === "buy" && (
            <p className="mt-1 text-xs text-muted-foreground">
              Max buy: {maxBuyLots} lot{maxBuyLots === 1 ? "" : "s"}
            </p>
          )}
          {tradeType === "sell" && (
            <p className="mt-1 text-xs text-muted-foreground">
              Available: {maxSellLots} lot{maxSellLots === 1 ? "" : "s"}
            </p>
          )}
        </div>

        <div className="rounded-radius-md bg-muted p-3">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">Price per share</span>
            <span className="font-medium text-foreground">
              Rp {selectedPrice.toLocaleString("id-ID")}
            </span>
          </div>
          <div className="mt-1 flex items-center justify-between text-sm">
            <span className="text-muted-foreground">Total</span>
            <span className="font-semibold text-foreground">
              Rp {estimatedTotal.toLocaleString("id-ID")}
            </span>
          </div>
        </div>

        {error && (
          <div className="rounded-radius-md border border-danger/30 bg-danger/5 px-3 py-2.5 text-sm text-danger">
            {error}
          </div>
        )}
        {success && (
          <div className="rounded-radius-md border border-success/30 bg-success/5 px-3 py-2.5 text-sm text-success">
            {success}
          </div>
        )}

        <button
          onClick={onExecute}
          disabled={!canSubmit}
          className={`w-full rounded-radius-md py-3.5 text-sm font-semibold text-white shadow-sm transition-all active:scale-[0.98] disabled:opacity-50 ${
            tradeType === "buy" ? "bg-success hover:bg-success/90" : "bg-danger hover:bg-danger/90"
          }`}
        >
          {executing
            ? "Executing..."
            : `${tradeType === "buy" ? "Buy" : "Sell"} ${symbol}`}
        </button>
      </div>
    </div>
  );
}

function HoldingsCard({
  holdings,
  marketData,
}: {
  holdings: Holding[];
  marketData: MarketData[];
}) {
  if (holdings.length === 0) {
    return (
      <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-4">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          Holdings
        </p>
        <p className="mt-2 text-sm text-muted-foreground">
          You don't own any stocks yet. Place your first buy order above.
        </p>
      </div>
    );
  }

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Holdings
      </p>
      <div className="mt-3 space-y-3">
        {holdings.map((h) => {
          const price =
            marketData.find((m) => m.symbol === h.symbol)?.closePrice ??
            h.currentPrice ??
            h.averageCost;
          const value = h.shares * price;
          const costBasis = h.shares * h.averageCost;
          const pl = value - costBasis;
          const plPct = costBasis > 0 ? (pl / costBasis) * 100 : 0;
          const positive = pl >= 0;

          return (
            <div
              key={h.id}
              className="flex items-center justify-between rounded-radius-md border border-muted/40 bg-background p-3"
            >
              <div>
                <p className="font-semibold text-foreground">{h.symbol}</p>
                <p className="text-xs text-muted-foreground">
                  {h.shares} shares @ Rp {h.averageCost.toLocaleString("id-ID")}
                </p>
              </div>
              <div className="text-right">
                <p className="font-semibold text-foreground">
                  Rp {Math.round(value).toLocaleString("id-ID")}
                </p>
                <p className={`text-xs font-medium ${positive ? "text-success" : "text-danger"}`}>
                  {positive ? "+" : ""}
                  {plPct.toFixed(2)}%
                </p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function TradesCard({ trades }: { trades: Trade[] }) {
  if (trades.length === 0) {
    return (
      <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-4">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          Recent trades
        </p>
        <p className="mt-2 text-sm text-muted-foreground">
          No trades yet. Your history will appear here.
        </p>
      </div>
    );
  }

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Recent trades
      </p>
      <div className="mt-3 space-y-2">
        {trades.slice(0, 20).map((t) => (
          <div
            key={t.id}
            className="flex items-center justify-between rounded-radius-md border border-muted/40 bg-background p-3"
          >
            <div className="flex items-center gap-3">
              <span
                className={`rounded-radius-sm px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${
                  t.tradeType === "buy"
                    ? "bg-success/10 text-success"
                    : "bg-danger/10 text-danger"
                }`}
              >
                {t.tradeType}
              </span>
              <div>
                <p className="font-semibold text-foreground">{t.symbol}</p>
                <p className="text-xs text-muted-foreground">
                  {t.lotCount} lot{t.lotCount === 1 ? "" : "s"} @ Rp{" "}
                  {t.price.toLocaleString("id-ID")}
                </p>
              </div>
            </div>
            <p className="text-sm font-semibold text-foreground">
              Rp {t.totalAmount.toLocaleString("id-ID")}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}
