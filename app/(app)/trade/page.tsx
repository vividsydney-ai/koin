"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import dynamic from "next/dynamic";
import { useAuth } from "@/lib/auth/use-auth";
import {
  getPortfolio,
  getHoldings,
  getTrades,
  getMarketData,
  executeTrade,
  getInstruments,
  type Portfolio,
  type Holding,
  type Trade,
  type MarketData,
  type Instrument,
} from "@/lib/trading/client";
import {
  getTradeOnboardingStatus,
  claimPaperPortfolio,
  markPaperChestViewed,
  PAPER_TRADING_UNLOCK_CHAPTER_LABEL,
  type TradeOnboardingStatus,
} from "@/lib/trading/onboarding";
import { trackEvent } from "@/lib/analytics/client";
import { EmptyState } from "@/components/EmptyState";
import PriceChart from "@/components/PriceChart";

const TradeOnboarding = dynamic(() => import("./TradeOnboarding"));

const SHARES_PER_LOT = 100;

export default function TradePage() {
  const { user } = useAuth(true);
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [holdings, setHoldings] = useState<Holding[]>([]);
  const [trades, setTrades] = useState<Trade[]>([]);
  const [marketData, setMarketData] = useState<MarketData[]>([]);
  const [instruments, setInstruments] = useState<Instrument[]>([]);
  const [loading, setLoading] = useState(true);
  const [executing, setExecuting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [onboardingStatus, setOnboardingStatus] = useState<TradeOnboardingStatus | null>(null);
  const [showOnboarding, setShowOnboarding] = useState(false);
  const [openingChest, setOpeningChest] = useState(false);

  const [symbol, setSymbol] = useState("");
  const [tradeType, setTradeType] = useState<"buy" | "sell">("buy");
  const [lotCount, setLotCount] = useState(1);
  const [instrumentQuery, setInstrumentQuery] = useState("");

  const loadAll = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    setError(null);
    try {
      // Resolve eligibility first. Nothing below can render a balance before
      // the server-authoritative chest claim has created the portfolio.
      const status = await getTradeOnboardingStatus(user.id);
      const [p, h, t, m, catalogue] = await Promise.all([
        status.canTrade ? getPortfolio(user.id) : Promise.resolve(null),
        status.canTrade ? getHoldings(user.id) : Promise.resolve([]),
        status.canTrade ? getTrades(user.id) : Promise.resolve([]),
        getMarketData(),
        getInstruments(),
      ]);
      setPortfolio(p);
      setHoldings(h);
      setTrades(t);
      setMarketData(m);
      setInstruments(catalogue);
      setOnboardingStatus(status);
      if (!symbol && m.length > 0) {
        setSymbol(m[0].symbol);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  }, [symbol, user]);

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
  }, [loadAll, user]);

  const selectedQuote = useMemo(
    () => marketData.find((row) => row.symbol === symbol),
    [marketData, symbol]
  );

  const selectedPrice = selectedQuote?.closePrice ?? 0;

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
      const isFirstTrade = trades.length === 0;
      await executeTrade(user.id, symbol, tradeType, lotCount);
      trackEvent({
        userId: user.id,
        name: "trade_executed",
        properties: {
          symbol,
          trade_type: tradeType,
          lot_count: lotCount,
          estimated_total: estimatedTotal,
        },
      });
      if (isFirstTrade) {
        trackEvent({
          userId: user.id,
          name: "first_trade",
          properties: {
            symbol,
            trade_type: tradeType,
            lot_count: lotCount,
          },
        });
      }
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

  const handleOpenChest = async () => {
    if (!user || openingChest) return;
    setOpeningChest(true);
    setError(null);
    try {
      await markPaperChestViewed(user.id);
      trackEvent({ userId: user.id, name: "paper_chest_viewed" });
      const claim = await claimPaperPortfolio(user.id);
      setPortfolio(claim.portfolio);
      trackEvent({
        userId: user.id,
        name: "paper_portfolio_claimed",
        properties: { starting_cash: claim.portfolio.startingCash },
      });
      await loadAll();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Could not open your paper portfolio");
    } finally {
      setOpeningChest(false);
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
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Paper Trading</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Practice buying and selling Indonesian stocks with paper money.
        </p>
      </header>

      {loading ? (
        <div className="space-y-5">
          <PortfolioSummarySkeleton />
          <OrderCardSkeleton />
          <HoldingsCardSkeleton />
          <TradesCardSkeleton />
        </div>
      ) : !onboardingStatus?.requiredLessonsCompleted ? (
        <LockedState
          completedCount={onboardingStatus?.completedLessonSlugs.length ?? 0}
          requiredCount={onboardingStatus?.requiredLessonCount ?? 0}
        />
      ) : !onboardingStatus?.onboardingCompleted || showOnboarding ? (
        <TradeOnboarding
          userId={user!.id}
          onComplete={() => {
            setShowOnboarding(false);
            loadAll();
          }}
          onClose={
            onboardingStatus?.onboardingCompleted
              ? () => setShowOnboarding(false)
              : undefined
          }
        />
      ) : !portfolio ? (
        <PaperChest opening={openingChest} error={error} onOpen={handleOpenChest} />
      ) : (
        <div className="space-y-5">
          <div className="flex items-center justify-between">
            <button
              onClick={() => setShowOnboarding(true)}
              className="text-xs font-semibold text-primary hover:underline"
            >
              Replay onboarding
            </button>
          </div>

          <div className="grid gap-5 lg:grid-cols-[minmax(0,1fr)_360px] lg:items-start">
            <main className="min-w-0 space-y-5">
              <PortfolioSummaryCard
                portfolio={portfolio}
                portfolioValue={portfolioValue}
                totalReturnPct={totalReturnPct}
              />
              <PriceChart
                symbol={symbol}
                companyName={marketData.find((m) => m.symbol === symbol)?.companyName}
              />
              <HoldingsCard holdings={holdings} marketData={marketData} />
              <TradesCard trades={trades} />
            </main>
            <aside className="space-y-5 lg:sticky lg:top-5">
              <OrderCard
                symbol={symbol}
                setSymbol={setSymbol}
                tradeType={tradeType}
                setTradeType={setTradeType}
                lotCount={lotCount}
                setLotCount={setLotCount}
                marketData={marketData}
                instruments={instruments}
                instrumentQuery={instrumentQuery}
                setInstrumentQuery={setInstrumentQuery}
                selectedPrice={selectedPrice}
                selectedQuote={selectedQuote}
                estimatedTotal={estimatedTotal}
                canSubmit={canSubmit}
                executing={executing}
                error={error}
                success={success}
                cashBalance={portfolio?.cashBalance ?? 0}
                holdings={holdings}
                onExecute={handleExecute}
              />
              <WatchlistCard instruments={instruments} marketData={marketData} />
              <DataDisclaimer marketData={marketData} />
            </aside>
          </div>
        </div>
      )}

    </div>
  );
}

function PaperChest({
  opening,
  error,
  onOpen,
}: {
  opening: boolean;
  error: string | null;
  onOpen: () => void;
}) {
  return (
    <section className="mx-auto max-w-xl rounded-[18px] border border-warning/30 bg-surface p-6 text-center shadow-lg sm:p-10">
      <div className="mx-auto flex h-28 w-28 items-center justify-center rounded-3xl border-4 border-warning/50 bg-warning/10 text-6xl motion-safe:animate-bounce" aria-hidden="true">
        🎁
      </div>
      <p className="mt-6 text-xs font-bold uppercase tracking-[0.18em] text-warning">Milestone unlocked</p>
      <h2 className="mt-2 text-2xl font-bold text-foreground">Your paper portfolio is ready</h2>
      <p className="mx-auto mt-3 max-w-md text-sm leading-relaxed text-muted-foreground">
        Open the chest to receive IDR 10,000,000 in simulated buying power. It is one grant, for learning only — never real money.
      </p>
      <button
        type="button"
        onClick={onOpen}
        disabled={opening}
        className="mt-7 min-h-11 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white shadow-sm transition hover:opacity-90 disabled:opacity-60"
      >
        {opening ? "Opening your chest…" : "Open my paper portfolio"}
      </button>
      {error && <p className="mt-4 text-sm text-danger" role="alert">{error}</p>}
      <p className="mt-5 text-xs text-muted-foreground">Prices are delayed or simulated. No real orders are placed.</p>
    </section>
  );
}

function LockedState({
  completedCount,
  requiredCount,
}: {
  completedCount: number;
  requiredCount: number;
}) {
  return (
    <div className="rounded-lg border border-dashed border-muted bg-surface p-6 text-center">
      <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-warning/10 text-2xl">
        🔒
      </div>
      <h2 className="mt-4 text-lg font-bold text-foreground">Paper trading is locked</h2>
      <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
        Complete {PAPER_TRADING_UNLOCK_CHAPTER_LABEL} in the Learn tab to unlock paper trading.
      </p>
      <p className="mt-4 text-xs text-muted-foreground">
        Progress: {completedCount} / {requiredCount} required lessons
      </p>
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
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
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
  instruments,
  instrumentQuery,
  setInstrumentQuery,
  selectedPrice,
  selectedQuote,
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
  instruments: Instrument[];
  instrumentQuery: string;
  setInstrumentQuery: (query: string) => void;
  selectedPrice: number;
  selectedQuote?: MarketData;
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
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Place an order
      </p>

      <div className="mt-4 grid grid-cols-2 gap-2 rounded-md bg-muted p-1">
        <button
          onClick={() => setTradeType("buy")}
          className={`rounded-sm py-2 text-sm font-semibold transition-colors ${
            tradeType === "buy"
              ? "bg-surface text-success shadow-sm"
              : "text-muted-foreground hover:text-foreground"
          }`}
        >
          Buy
        </button>
        <button
          onClick={() => setTradeType("sell")}
          className={`rounded-sm py-2 text-sm font-semibold transition-colors ${
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
          <label htmlFor="instrument-search" className="block text-sm font-medium text-foreground">
            Search IDX stocks and ETFs
          </label>
          <input
            id="instrument-search"
            type="search"
            value={instrumentQuery}
            onChange={(e) => setInstrumentQuery(e.target.value)}
            placeholder="Symbol or company name"
            className="mt-1.5 min-h-11 w-full rounded-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          />
          <label htmlFor="symbol" className="sr-only">Instrument</label>
          <select
            id="symbol"
            value={symbol}
            onChange={(e) => setSymbol(e.target.value)}
            className="mt-1.5 w-full rounded-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          >
            {instruments.filter((instrument) => `${instrument.symbol} ${instrument.name} ${instrument.instrumentType}`.toLowerCase().includes(instrumentQuery.toLowerCase())).map((instrument) => {
              const quote = marketData.find((m) => m.symbol === instrument.symbol);
              return (
              <option key={instrument.symbol} value={instrument.symbol}>
                {instrument.symbol} — {instrument.name} ({instrument.instrumentType.toUpperCase()})
                {quote ? ` · Rp ${quote.closePrice.toLocaleString("id-ID")}` : " · Data pending"}
              </option>
              );
            })}
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
            className="mt-1.5 w-full rounded-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
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

        <div className="rounded-md bg-muted p-3">
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
          <QuoteStatus quote={selectedQuote} className="mt-2" />
        </div>

        {error && (
          <div className="rounded-md border border-danger/30 bg-danger/5 px-3 py-2.5 text-sm text-danger">
            {error}
          </div>
        )}
        {success && (
          <div className="rounded-md border border-success/30 bg-success/5 px-3 py-2.5 text-sm text-success">
            {success}
          </div>
        )}

        <button
          onClick={onExecute}
          disabled={!canSubmit}
          className={`w-full rounded-md py-3.5 text-sm font-semibold text-white shadow-sm transition-all active:scale-[0.98] disabled:opacity-50 ${
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

function WatchlistCard({ instruments, marketData }: { instruments: Instrument[]; marketData: MarketData[] }) {
  const rows = instruments.slice(0, 5).map((instrument) => ({
    instrument,
    quote: marketData.find((row) => row.symbol === instrument.symbol),
  }));

  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">IDX watchlist</p>
        <span className="text-xs text-muted-foreground">Delayed</span>
      </div>
      <div className="mt-3 space-y-2">
        {rows.map(({ instrument, quote }) => (
          <div key={instrument.symbol} className="flex items-center justify-between rounded-lg bg-background px-3 py-2.5">
            <div>
              <p className="text-sm font-bold text-foreground">{instrument.symbol}</p>
              <p className="max-w-[180px] truncate text-xs text-muted-foreground">{instrument.name}</p>
            </div>
            <div className="text-right">
              <p className="text-sm font-semibold text-foreground">{quote ? `Rp ${quote.closePrice.toLocaleString("id-ID")}` : "—"}</p>
              <QuoteStatus quote={quote} className="justify-end" />
            </div>
          </div>
        ))}
      </div>
    </section>
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
      <EmptyState
        icon="📊"
        title="No holdings yet"
        description="You don't own any stocks. Place your first buy order above to start building your paper portfolio."
      />
    );
  }

  return (
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
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
              className="flex items-center justify-between rounded-md border border-muted/40 bg-background p-3"
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
      <EmptyState
        icon="📝"
        title="No trades yet"
        description="Your buy and sell history will appear here once you make your first paper trade."
      />
    );
  }

  return (
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Recent trades
      </p>
      <div className="mt-3 space-y-2">
        {trades.slice(0, 20).map((t) => (
          <div
            key={t.id}
            className="flex items-center justify-between rounded-md border border-muted/40 bg-background p-3"
          >
            <div className="flex items-center gap-3">
              <span
                className={`rounded-sm px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${
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

function DataDisclaimer({ marketData }: { marketData: MarketData[] }) {
  if (marketData.length === 0) return null;

  const latestDate = marketData
    .map((m) => m.tradeDate)
    .sort()
    .at(-1);
  const simulatedCount = marketData.filter((m) => m.isSimulated).length;
  const sourceUrl = marketData.find((m) => m.sourceUrl)?.sourceUrl;

  return (
    <div className="rounded-md border border-warning/20 bg-warning/5 p-3 text-xs leading-relaxed text-muted-foreground">
      <span className="font-semibold text-foreground">Data disclaimer:</span>{" "}
      Prices are delayed and for paper-trading practice only. Latest data:{" "}
      {latestDate ? new Date(latestDate).toLocaleDateString("id-ID") : "—"}.
      {simulatedCount > 0 && ` ${simulatedCount} quote${simulatedCount === 1 ? " is" : "s are"} simulated because official data was unavailable.`}
      {sourceUrl && (
        <>
          {" "}
          <a href={sourceUrl} target="_blank" rel="noreferrer" className="font-medium text-primary hover:underline">
            View source
          </a>
          .
        </>
      )} Not financial advice.
    </div>
  );
}

function QuoteStatus({ quote, className = "" }: { quote?: MarketData; className?: string }) {
  if (!quote) {
    return <p className={`text-xs text-muted-foreground ${className}`.trim()}>Data pending</p>;
  }

  const source = quote.isSimulated ? "Simulated fallback" : "IDX EOD";
  const date = new Date(`${quote.tradeDate}T00:00:00`).toLocaleDateString("id-ID");

  return (
    <p className={`flex gap-1 text-xs ${quote.isSimulated ? "text-warning" : "text-success"} ${className}`.trim()}>
      <span>{source}</span>
      <span aria-hidden="true">·</span>
      <span>as of {date}</span>
    </p>
  );
}

function PortfolioSummarySkeleton() {
  return (
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-start justify-between">
        <div className="w-full">
          <div className="h-3 w-24 animate-pulse rounded bg-muted" />
          <div className="mt-2 h-8 w-1/2 animate-pulse rounded bg-muted" />
          <div className="mt-1 h-3 w-16 animate-pulse rounded bg-muted" />
        </div>
        <div className="text-right">
          <div className="h-3 w-12 animate-pulse rounded bg-muted" />
          <div className="mt-1 h-5 w-24 animate-pulse rounded bg-muted" />
        </div>
      </div>
    </div>
  );
}

function OrderCardSkeleton() {
  return (
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="h-3 w-24 animate-pulse rounded bg-muted" />
      <div className="mt-4 grid grid-cols-2 gap-2 rounded-md bg-muted p-1">
        <div className="h-9 animate-pulse rounded-sm bg-background" />
        <div className="h-9 animate-pulse rounded-sm bg-background" />
      </div>
      <div className="mt-4 space-y-4">
        <div>
          <div className="h-4 w-12 animate-pulse rounded bg-muted" />
          <div className="mt-1.5 h-10 w-full animate-pulse rounded-md bg-muted" />
        </div>
        <div>
          <div className="h-4 w-24 animate-pulse rounded bg-muted" />
          <div className="mt-1.5 h-10 w-full animate-pulse rounded-md bg-muted" />
        </div>
        <div className="rounded-md bg-muted p-3">
          <div className="flex items-center justify-between">
            <div className="h-4 w-28 animate-pulse rounded bg-background" />
            <div className="h-4 w-20 animate-pulse rounded bg-background" />
          </div>
          <div className="mt-1 flex items-center justify-between">
            <div className="h-4 w-12 animate-pulse rounded bg-background" />
            <div className="h-4 w-24 animate-pulse rounded bg-background" />
          </div>
        </div>
        <div className="h-12 w-full animate-pulse rounded-md bg-muted" />
      </div>
    </div>
  );
}

function HoldingsCardSkeleton() {
  return (
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="h-3 w-20 animate-pulse rounded bg-muted" />
      <div className="mt-3 space-y-3">
        <div className="flex items-center justify-between rounded-md border border-muted/40 bg-background p-3">
          <div>
            <div className="h-5 w-16 animate-pulse rounded bg-muted" />
            <div className="mt-1 h-3 w-32 animate-pulse rounded bg-muted" />
          </div>
          <div className="text-right">
            <div className="h-5 w-24 animate-pulse rounded bg-muted" />
            <div className="mt-1 h-3 w-16 animate-pulse rounded bg-muted" />
          </div>
        </div>
      </div>
    </div>
  );
}

function TradesCardSkeleton() {
  return (
    <div className="rounded-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="h-3 w-24 animate-pulse rounded bg-muted" />
      <div className="mt-3 space-y-2">
        <div className="flex items-center justify-between rounded-md border border-muted/40 bg-background p-3">
          <div className="flex items-center gap-3">
            <div className="h-5 w-12 animate-pulse rounded-sm bg-muted" />
            <div>
              <div className="h-4 w-12 animate-pulse rounded bg-muted" />
              <div className="mt-1 h-3 w-28 animate-pulse rounded bg-muted" />
            </div>
          </div>
          <div className="h-5 w-20 animate-pulse rounded bg-muted" />
        </div>
      </div>
    </div>
  );
}
