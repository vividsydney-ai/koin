"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import dynamic from "next/dynamic";
import { useAuth } from "@/lib/auth/use-auth";
import {
  addToWatchlist,
  executeTrade,
  getHoldings,
  getInstruments,
  getMarketData,
  getPortfolio,
  getTrades,
  getWatchlist,
  removeFromWatchlist,
  type Holding,
  type Instrument,
  type MarketData,
  type Portfolio,
  type Trade,
  type WatchlistEntry,
} from "@/lib/trading/client";
import {
  claimPaperPortfolio,
  getTradeOnboardingStatus,
  markPaperChestViewed,
  PAPER_TRADING_UNLOCK_CHAPTER_LABEL,
  type TradeOnboardingStatus,
} from "@/lib/trading/onboarding";
import { trackEvent } from "@/lib/analytics/client";
import { EmptyState } from "@/components/EmptyState";
import {
  ContextualHelp,
  ContextualHelpProvider,
} from "@/components/ContextualHelp";
import PortfolioChart from "@/components/PortfolioChart";

const TradeOnboarding = dynamic(() => import("./TradeOnboarding"));
const SHARES_PER_LOT = 100;
const rupiah = new Intl.NumberFormat("id-ID", {
  style: "currency",
  currency: "IDR",
  maximumFractionDigits: 0,
});

export default function TradePage() {
  const { user } = useAuth(true);
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [holdings, setHoldings] = useState<Holding[]>([]);
  const [trades, setTrades] = useState<Trade[]>([]);
  const [marketData, setMarketData] = useState<MarketData[]>([]);
  const [instruments, setInstruments] = useState<Instrument[]>([]);
  const [watchlist, setWatchlist] = useState<WatchlistEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [executing, setExecuting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [onboardingStatus, setOnboardingStatus] =
    useState<TradeOnboardingStatus | null>(null);
  const [showOnboarding, setShowOnboarding] = useState(false);
  const [openingChest, setOpeningChest] = useState(false);
  const [symbol, setSymbol] = useState("");
  const [tradeType, setTradeType] = useState<"buy" | "sell">("buy");
  const [lotCount, setLotCount] = useState(1);
  const [instrumentQuery, setInstrumentQuery] = useState("");
  const [watchlistOpen, setWatchlistOpen] = useState(false);

  const loadDashboard = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    setError(null);
    try {
      const status = await getTradeOnboardingStatus(user.id);
      const [p, h, t, m, catalogue, savedWatchlist] = await Promise.all([
        status.canTrade ? getPortfolio(user.id) : Promise.resolve(null),
        status.canTrade ? getHoldings(user.id) : Promise.resolve([]),
        status.canTrade ? getTrades(user.id) : Promise.resolve([]),
        getMarketData(),
        getInstruments(),
        status.canTrade ? getWatchlist(user.id) : Promise.resolve([]),
      ]);
      setPortfolio(p);
      setHoldings(h);
      setTrades(t);
      setMarketData(m);
      setInstruments(catalogue);
      setWatchlist(savedWatchlist);
      setOnboardingStatus(status);
      setSymbol(
        (current) => current || m[0]?.symbol || catalogue[0]?.symbol || "",
      );
    } catch (caught) {
      console.error(caught);
      setError("Could not load paper trading. Please refresh and try again.");
    } finally {
      setLoading(false);
    }
  }, [user]);

  useEffect(() => {
    void Promise.resolve().then(loadDashboard);
  }, [loadDashboard]);

  const selectedInstrument = useMemo(
    () => instruments.find((instrument) => instrument.symbol === symbol),
    [instruments, symbol],
  );
  const selectedQuote = useMemo(
    () => marketData.find((row) => row.symbol === symbol),
    [marketData, symbol],
  );
  const selectedPrice = selectedQuote?.closePrice ?? 0;
  const estimatedTotal = selectedPrice * lotCount * SHARES_PER_LOT;
  const canSubmit = Boolean(
    symbol && lotCount > 0 && selectedPrice > 0 && !executing,
  );
  const portfolioValue = portfolio?.totalValue ?? 0;
  const totalReturnPct =
    portfolio && portfolio.startingCash > 0
      ? ((portfolioValue - portfolio.startingCash) / portfolio.startingCash) *
        100
      : 0;

  const selectInstrument = (instrument: Instrument) => {
    setSymbol(instrument.symbol);
    setInstrumentQuery(`${instrument.symbol} — ${instrument.name}`);
    setSuccess(null);
    setError(null);
  };

  const handleInstrumentQuery = (query: string) => {
    setInstrumentQuery(query);
    const exact = instruments.find(
      (instrument) =>
        instrument.symbol.toLowerCase() === query.trim().toLowerCase(),
    );
    if (exact) selectInstrument(exact);
  };

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
      if (isFirstTrade)
        trackEvent({
          userId: user.id,
          name: "first_trade",
          properties: { symbol, trade_type: tradeType, lot_count: lotCount },
        });
      setSuccess(
        `${tradeType === "buy" ? "Bought" : "Sold"} ${lotCount} lot${lotCount === 1 ? "" : "s"} of ${symbol}`,
      );
      await loadDashboard();
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : "Trade failed");
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
      await loadDashboard();
    } catch (caught) {
      setError(
        caught instanceof Error
          ? caught.message
          : "Could not open your paper portfolio",
      );
    } finally {
      setOpeningChest(false);
    }
  };

  const addWatchlistSymbol = async (nextSymbol: string) => {
    if (!user) return;
    try {
      await addToWatchlist(user.id, nextSymbol);
      setWatchlist(await getWatchlist(user.id));
    } catch (caught) {
      setError(
        caught instanceof Error
          ? caught.message
          : "Could not update your watchlist",
      );
    }
  };

  const removeWatchlistSymbol = async (nextSymbol: string) => {
    if (!user) return;
    try {
      await removeFromWatchlist(user.id, nextSymbol);
      setWatchlist(await getWatchlist(user.id));
    } catch (caught) {
      setError(
        caught instanceof Error
          ? caught.message
          : "Could not update your watchlist",
      );
    }
  };

  return (
    <ContextualHelpProvider>
      <div className="min-h-screen bg-background p-5 pb-28">
        <header className="mb-6 flex flex-wrap items-start justify-between gap-3">
          <div>
            <h1 className="text-2xl font-bold tracking-tight text-foreground">
              Paper Trading
            </h1>
            <p className="mt-1 text-sm text-muted-foreground">
              Practice IDX orders with virtual money.
            </p>
          </div>
          <p className="rounded-full border border-primary/20 bg-primary/5 px-3 py-2 text-xs font-semibold text-primary">
            Paper Trading — no real money is used
          </p>
        </header>

        {loading ? (
          <DashboardSkeleton />
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
              void loadDashboard();
            }}
            onClose={
              onboardingStatus?.onboardingCompleted
                ? () => setShowOnboarding(false)
                : undefined
            }
          />
        ) : !portfolio ? (
          <PaperChest
            opening={openingChest}
            error={error}
            onOpen={handleOpenChest}
          />
        ) : (
          <div className="space-y-5">
            <div className="flex justify-end">
              <button
                type="button"
                onClick={() => setShowOnboarding(true)}
                className="min-h-11 px-2 text-xs font-semibold text-primary hover:underline"
              >
                Replay onboarding
              </button>
            </div>
            <div className="grid gap-5 lg:grid-cols-[minmax(0,1fr)_380px] lg:items-start">
              <main className="min-w-0 space-y-5">
                <PortfolioSummaryCard
                  portfolio={portfolio}
                  portfolioValue={portfolioValue}
                  totalReturnPct={totalReturnPct}
                />
                <PortfolioChart userId={user!.id} totalValue={portfolioValue} />
                <HoldingsCard holdings={holdings} marketData={marketData} />
                <TradesCard trades={trades} />
              </main>
              <aside className="space-y-5 lg:sticky lg:top-5">
                <OrderCard
                  symbol={symbol}
                  selectedInstrument={selectedInstrument}
                  tradeType={tradeType}
                  setTradeType={setTradeType}
                  lotCount={lotCount}
                  setLotCount={setLotCount}
                  marketData={marketData}
                  instruments={instruments}
                  instrumentQuery={instrumentQuery}
                  setInstrumentQuery={handleInstrumentQuery}
                  onSelectInstrument={selectInstrument}
                  selectedPrice={selectedPrice}
                  selectedQuote={selectedQuote}
                  estimatedTotal={estimatedTotal}
                  canSubmit={canSubmit}
                  executing={executing}
                  error={error}
                  success={success}
                  cashBalance={portfolio.cashBalance}
                  holdings={holdings}
                  onExecute={handleExecute}
                />
                <WatchlistCard
                  watchlist={watchlist}
                  instruments={instruments}
                  marketData={marketData}
                  onEdit={() => setWatchlistOpen(true)}
                />
                <DataDisclaimer marketData={marketData} />
              </aside>
            </div>
            {watchlistOpen && (
              <WatchlistDialog
                watchlist={watchlist}
                instruments={instruments}
                onClose={() => setWatchlistOpen(false)}
                onAdd={addWatchlistSymbol}
                onRemove={removeWatchlistSymbol}
              />
            )}
          </div>
        )}
      </div>
    </ContextualHelpProvider>
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
      <div
        className="mx-auto flex h-28 w-28 items-center justify-center rounded-3xl border-4 border-warning/50 bg-warning/10 text-6xl motion-safe:animate-bounce"
        aria-hidden="true"
      >
        🎁
      </div>
      <p className="mt-6 text-xs font-bold uppercase tracking-[0.18em] text-warning">
        Milestone unlocked
      </p>
      <h2 className="mt-2 text-2xl font-bold text-foreground">
        Your paper portfolio is ready
      </h2>
      <p className="mx-auto mt-3 max-w-md text-sm leading-relaxed text-muted-foreground">
        Open the chest to receive IDR 10,000,000 in simulated buying power. It
        is one grant, for learning only — never real money.
      </p>
      <button
        type="button"
        onClick={onOpen}
        disabled={opening}
        className="mt-7 min-h-11 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white shadow-sm transition hover:opacity-90 disabled:opacity-60"
      >
        {opening ? "Opening your chest…" : "Open my paper portfolio"}
      </button>
      {error && (
        <p className="mt-4 text-sm text-danger" role="alert">
          {error}
        </p>
      )}
      <p className="mt-5 text-xs text-muted-foreground">
        Prices are delayed or simulated. No real orders are placed.
      </p>
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
    <div className="rounded-[18px] border border-dashed border-muted bg-surface p-6 text-center">
      <div
        className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-warning/10 text-2xl"
        aria-hidden="true"
      >
        🔒
      </div>
      <h2 className="mt-4 text-lg font-bold text-foreground">
        Paper trading is locked
      </h2>
      <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
        Complete {PAPER_TRADING_UNLOCK_CHAPTER_LABEL} in the Learn tab to unlock
        paper trading.
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
  portfolio: Portfolio;
  portfolioValue: number;
  totalReturnPct: number;
}) {
  const positive = totalReturnPct >= 0;
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm sm:p-5">
      <div className="grid gap-4 sm:grid-cols-3">
        <Metric
          label="Portfolio value"
          value={rupiah.format(portfolioValue)}
          detail={`${positive ? "+" : ""}${totalReturnPct.toFixed(2)}% since start`}
          positive={positive}
        />
        <Metric
          label="Buying power"
          value={rupiah.format(portfolio.cashBalance)}
          detail="Available to place orders"
          help="This is virtual cash still available to buy investments. Buying reduces it; selling adds virtual cash back."
        />
        <Metric
          label="Starting portfolio"
          value={rupiah.format(portfolio.startingCash)}
          detail="One-time paper grant"
        />
      </div>
    </section>
  );
}

function Metric({
  label,
  value,
  detail,
  positive,
  help,
}: {
  label: string;
  value: string;
  detail: string;
  positive?: boolean;
  help?: string;
}) {
  return (
    <div>
      <div className="flex items-center">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          {label}
        </p>
        {help && <ContextualHelp label={label}>{help}</ContextualHelp>}
      </div>
      <p className="mt-1 text-xl font-bold text-foreground">{value}</p>
      <p
        className={`mt-1 text-xs ${positive === undefined ? "text-muted-foreground" : positive ? "text-success" : "text-danger"}`}
      >
        {detail}
      </p>
    </div>
  );
}

function OrderCard({
  symbol,
  selectedInstrument,
  tradeType,
  setTradeType,
  lotCount,
  setLotCount,
  marketData,
  instruments,
  instrumentQuery,
  setInstrumentQuery,
  onSelectInstrument,
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
  selectedInstrument?: Instrument;
  tradeType: "buy" | "sell";
  setTradeType: (type: "buy" | "sell") => void;
  lotCount: number;
  setLotCount: (count: number) => void;
  marketData: MarketData[];
  instruments: Instrument[];
  instrumentQuery: string;
  setInstrumentQuery: (query: string) => void;
  onSelectInstrument: (instrument: Instrument) => void;
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
  const [open, setOpen] = useState(false);
  const matches = instruments
    .filter((instrument) =>
      `${instrument.symbol} ${instrument.name} ${instrument.instrumentType}`
        .toLowerCase()
        .includes(instrumentQuery.toLowerCase()),
    )
    .slice(0, 8);
  const holding = holdings.find((item) => item.symbol === symbol);
  const maxBuyLots =
    selectedPrice > 0
      ? Math.floor(cashBalance / (selectedPrice * SHARES_PER_LOT))
      : 0;
  const maxSellLots = holding ? Math.floor(holding.shares / SHARES_PER_LOT) : 0;
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          Place an order
        </p>
        <ContextualHelp label="Paper Trading order">
          This is a practice order using virtual IDR. It never sends money or an
          order to IDX.
        </ContextualHelp>
      </div>
      <div className="mt-4 grid grid-cols-2 gap-2 rounded-xl bg-muted p-1">
        <button
          type="button"
          onClick={() => setTradeType("buy")}
          className={`min-h-11 rounded-lg text-sm font-semibold ${tradeType === "buy" ? "bg-surface text-success shadow-sm" : "text-muted-foreground"}`}
        >
          Buy
        </button>
        <button
          type="button"
          onClick={() => setTradeType("sell")}
          className={`min-h-11 rounded-lg text-sm font-semibold ${tradeType === "sell" ? "bg-surface text-danger shadow-sm" : "text-muted-foreground"}`}
        >
          Sell
        </button>
      </div>
      <div className="mt-4 space-y-4">
        <div className="relative">
          <label
            htmlFor="instrument-search"
            className="block text-sm font-medium text-foreground"
          >
            Search IDX stocks and ETFs
          </label>
          <input
            id="instrument-search"
            type="search"
            role="combobox"
            aria-expanded={open}
            aria-controls="instrument-results"
            autoComplete="off"
            value={instrumentQuery}
            onFocus={() => setOpen(true)}
            onChange={(event) => {
              setInstrumentQuery(event.target.value);
              setOpen(true);
            }}
            onKeyDown={(event) => {
              if (event.key === "Enter" && matches[0]) {
                event.preventDefault();
                onSelectInstrument(matches[0]);
                setOpen(false);
              }
              if (event.key === "Escape") setOpen(false);
            }}
            placeholder="Symbol or company name"
            className="mt-1.5 min-h-11 w-full rounded-xl border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          />
          {open && (
            <div
              id="instrument-results"
              role="listbox"
              className="absolute z-20 mt-1 max-h-72 w-full overflow-y-auto rounded-xl border border-muted bg-surface p-1 shadow-lg"
            >
              {matches.length ? (
                matches.map((instrument) => {
                  const quote = marketData.find(
                    (item) => item.symbol === instrument.symbol,
                  );
                  return (
                    <button
                      key={instrument.symbol}
                      type="button"
                      role="option"
                      aria-selected={instrument.symbol === symbol}
                      onMouseDown={(event) => event.preventDefault()}
                      onClick={() => {
                        onSelectInstrument(instrument);
                        setOpen(false);
                      }}
                      className="flex min-h-11 w-full items-center justify-between gap-3 rounded-lg px-3 py-2 text-left hover:bg-muted focus:bg-muted"
                    >
                      <span>
                        <span className="block text-sm font-bold text-foreground">
                          {instrument.symbol}
                        </span>
                        <span className="block max-w-[190px] truncate text-xs text-muted-foreground">
                          {instrument.name}
                        </span>
                      </span>
                      <span className="text-right">
                        <span className="block text-xs font-semibold text-foreground">
                          {quote
                            ? rupiah.format(quote.closePrice)
                            : "Data pending"}
                        </span>
                        <span className="block text-[11px] text-primary">
                          {instrument.instrumentType.toUpperCase()}
                        </span>
                      </span>
                    </button>
                  );
                })
              ) : (
                <p className="px-3 py-3 text-sm text-muted-foreground">
                  No IDX instrument matches that search.
                </p>
              )}
            </div>
          )}
        </div>
        <div className="rounded-xl bg-muted/70 p-3">
          <div className="flex items-start justify-between gap-3">
            <div>
              <p className="font-bold text-foreground">
                {selectedInstrument?.symbol || "Choose an instrument"}
              </p>
              <p className="max-w-[210px] truncate text-xs text-muted-foreground">
                {selectedInstrument?.name || "Search the IDX catalogue above"}
              </p>
            </div>
            <div className="text-right">
              <p className="font-semibold text-foreground">
                {selectedPrice ? rupiah.format(selectedPrice) : "—"}
              </p>
              <QuoteStatus quote={selectedQuote} className="justify-end" />
            </div>
          </div>
        </div>
        <div>
          <div className="flex items-center">
            <label
              htmlFor="lots"
              className="block text-sm font-medium text-foreground"
            >
              Quantity in lots
            </label>
            <ContextualHelp label="IDX lots">
              IDX shares are bought and sold in lots. One lot equals 100 shares,
              so 2 lots means 200 shares.
            </ContextualHelp>
          </div>
          <p className="mt-0.5 text-xs text-muted-foreground">
            1 lot = 100 shares · Market order
          </p>
          <input
            id="lots"
            type="number"
            min={1}
            value={lotCount}
            onChange={(event) => {
              const next = Number.parseInt(event.target.value, 10);
              setLotCount(Number.isNaN(next) ? 1 : Math.max(1, next));
            }}
            className="mt-1.5 min-h-11 w-full rounded-xl border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          />
          <p className="mt-1 text-xs text-muted-foreground">
            {tradeType === "buy"
              ? `Max buy: ${maxBuyLots} lots`
              : `Available: ${maxSellLots} lots`}
          </p>
        </div>
        <div className="rounded-xl border border-muted/70 bg-background p-3 text-sm">
          <div className="flex justify-between">
            <span className="text-muted-foreground">Estimated cost</span>
            <span className="font-semibold text-foreground">
              {rupiah.format(estimatedTotal)}
            </span>
          </div>
          <div className="mt-1 flex items-center justify-between">
            <span className="flex items-center text-muted-foreground">
              Order type
              <ContextualHelp label="Market order" align="right">
                Koinaku fills this simulated order immediately at the latest
                available closing price shown for this symbol. It is not a live
                IDX price or a real broker order.
              </ContextualHelp>
            </span>
            <span className="font-semibold text-foreground">Market</span>
          </div>
        </div>
        {error && (
          <p
            role="alert"
            className="rounded-xl border border-danger/30 bg-danger/5 px-3 py-2.5 text-sm text-danger"
          >
            {error}
          </p>
        )}
        {success && (
          <p className="rounded-xl border border-success/30 bg-success/5 px-3 py-2.5 text-sm text-success">
            {success}
          </p>
        )}
        <button
          type="button"
          onClick={onExecute}
          disabled={!canSubmit}
          className={`min-h-12 w-full rounded-xl px-4 text-sm font-bold text-white shadow-sm transition disabled:opacity-50 ${tradeType === "buy" ? "bg-success hover:bg-success/90" : "bg-danger hover:bg-danger/90"}`}
        >
          {executing
            ? "Executing…"
            : `${tradeType === "buy" ? "Buy" : "Sell"} ${symbol || "order"}`}
        </button>
      </div>
    </section>
  );
}

function WatchlistCard({
  watchlist,
  instruments,
  marketData,
  onEdit,
}: {
  watchlist: WatchlistEntry[];
  instruments: Instrument[];
  marketData: MarketData[];
  onEdit: () => void;
}) {
  const rows = watchlist.map((entry) => ({
    entry,
    instrument: instruments.find((item) => item.symbol === entry.symbol),
    quote: marketData.find((item) => item.symbol === entry.symbol),
  }));
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between gap-3">
        <div>
          <div className="flex items-center">
            <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              IDX watchlist
            </p>
            <ContextualHelp label="Watchlist" align="right">
              A watchlist is only a shortlist of symbols to follow. Adding a
              symbol here does not buy it.
            </ContextualHelp>
          </div>
          <p className="mt-1 text-xs text-muted-foreground">
            Your saved symbols · delayed EOD
          </p>
        </div>
        <button
          type="button"
          onClick={onEdit}
          className="min-h-11 rounded-xl border border-muted px-3 text-xs font-bold text-primary hover:bg-primary/5"
        >
          Edit
        </button>
      </div>
      {rows.length ? (
        <div className="mt-3 space-y-2">
          {rows.map(({ entry, instrument, quote }) => (
            <div
              key={entry.id}
              className="flex items-center justify-between rounded-xl bg-background px-3 py-2.5"
            >
              <div>
                <p className="text-sm font-bold text-foreground">
                  {entry.symbol}
                </p>
                <p className="max-w-[180px] truncate text-xs text-muted-foreground">
                  {instrument?.name || "IDX instrument"}
                </p>
              </div>
              <div className="text-right">
                <p className="text-sm font-semibold text-foreground">
                  {quote ? rupiah.format(quote.closePrice) : "—"}
                </p>
                <QuoteStatus quote={quote} className="justify-end" />
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="mt-3 rounded-xl border border-dashed border-muted p-4 text-sm text-muted-foreground">
          Save symbols you want to follow. Choose Edit to search the IDX
          catalogue.
        </div>
      )}
    </section>
  );
}

function WatchlistDialog({
  watchlist,
  instruments,
  onClose,
  onAdd,
  onRemove,
}: {
  watchlist: WatchlistEntry[];
  instruments: Instrument[];
  onClose: () => void;
  onAdd: (symbol: string) => Promise<void>;
  onRemove: (symbol: string) => Promise<void>;
}) {
  const [query, setQuery] = useState("");
  const [working, setWorking] = useState(false);
  const saved = new Set(watchlist.map((entry) => entry.symbol));
  const matches = instruments
    .filter(
      (instrument) =>
        !saved.has(instrument.symbol) &&
        `${instrument.symbol} ${instrument.name}`
          .toLowerCase()
          .includes(query.toLowerCase()),
    )
    .slice(0, 6);
  const add = async (symbol: string) => {
    setWorking(true);
    await onAdd(symbol);
    setWorking(false);
    setQuery("");
  };
  const remove = async (symbol: string) => {
    setWorking(true);
    await onRemove(symbol);
    setWorking(false);
  };
  return (
    <div
      className="fixed inset-0 z-50 flex items-end bg-foreground/30 p-4 sm:items-center sm:justify-center"
      role="dialog"
      aria-modal="true"
      aria-labelledby="watchlist-title"
    >
      <section className="max-h-[85vh] w-full max-w-lg overflow-y-auto rounded-[18px] bg-surface p-5 shadow-xl">
        <div className="flex items-start justify-between gap-3">
          <div>
            <h2
              id="watchlist-title"
              className="text-lg font-bold text-foreground"
            >
              Edit watchlist
            </h2>
            <p className="mt-1 text-sm text-muted-foreground">
              Search an IDX stock or ETF, then add or remove it.
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="min-h-11 rounded-xl border border-muted px-3 text-sm font-bold text-foreground"
          >
            Done
          </button>
        </div>
        <label htmlFor="watchlist-search" className="sr-only">
          Search symbols to add
        </label>
        <input
          id="watchlist-search"
          type="search"
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Search symbol or company"
          className="mt-5 min-h-11 w-full rounded-xl border border-muted bg-background px-3 text-sm text-foreground outline-none focus:border-primary"
        />
        {query && (
          <div className="mt-2 space-y-1 rounded-xl border border-muted p-1">
            {matches.length ? (
              matches.map((instrument) => (
                <button
                  key={instrument.symbol}
                  type="button"
                  disabled={working}
                  onClick={() => void add(instrument.symbol)}
                  className="flex min-h-11 w-full items-center justify-between rounded-lg px-3 text-left hover:bg-muted disabled:opacity-50"
                >
                  <span>
                    <span className="block text-sm font-bold text-foreground">
                      {instrument.symbol}
                    </span>
                    <span className="block text-xs text-muted-foreground">
                      {instrument.name}
                    </span>
                  </span>
                  <span className="text-xl text-primary" aria-hidden="true">
                    +
                  </span>
                  <span className="sr-only">Add {instrument.symbol}</span>
                </button>
              ))
            ) : (
              <p className="p-3 text-sm text-muted-foreground">
                No new symbols found.
              </p>
            )}
          </div>
        )}
        <div className="mt-5">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Saved symbols
          </p>
          {watchlist.length ? (
            <div className="mt-2 space-y-1">
              {watchlist.map((entry) => {
                const instrument = instruments.find(
                  (item) => item.symbol === entry.symbol,
                );
                return (
                  <div
                    key={entry.id}
                    className="flex min-h-11 items-center justify-between rounded-xl bg-background px-3"
                  >
                    <span>
                      <span className="block text-sm font-bold text-foreground">
                        {entry.symbol}
                      </span>
                      <span className="block text-xs text-muted-foreground">
                        {instrument?.name || "IDX instrument"}
                      </span>
                    </span>
                    <button
                      type="button"
                      disabled={working}
                      onClick={() => void remove(entry.symbol)}
                      aria-label={`Remove ${entry.symbol} from watchlist`}
                      className="min-h-11 min-w-11 rounded-lg text-danger hover:bg-danger/5"
                    >
                      ×
                    </button>
                  </div>
                );
              })}
            </div>
          ) : (
            <p className="mt-2 text-sm text-muted-foreground">
              No saved symbols yet.
            </p>
          )}
        </div>
      </section>
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
  if (!holdings.length)
    return (
      <EmptyState
        icon="📊"
        title="No holdings yet"
        description="You don't own any stocks. Place your first buy order to start building your paper portfolio."
      />
    );
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          Holdings
        </p>
        <ContextualHelp label="Holdings">
          A holding is a stock or ETF in your paper portfolio. “Avg” is your
          average purchase price; the percentage compares its latest value with
          what you paid.
        </ContextualHelp>
      </div>
      <div className="mt-3 space-y-3">
        {holdings.map((holding) => {
          const price =
            marketData.find((item) => item.symbol === holding.symbol)
              ?.closePrice ??
            holding.currentPrice ??
            holding.averageCost;
          const value = holding.shares * price;
          const cost = holding.shares * holding.averageCost;
          const returnPct = cost ? ((value - cost) / cost) * 100 : 0;
          return (
            <div
              key={holding.id}
              className="flex items-center justify-between rounded-xl border border-muted/40 bg-background p-3"
            >
              <div>
                <p className="font-semibold text-foreground">
                  {holding.symbol}
                </p>
                <p className="text-xs text-muted-foreground">
                  {holding.shares} shares · avg{" "}
                  {rupiah.format(holding.averageCost)}
                </p>
              </div>
              <div className="text-right">
                <p className="font-semibold text-foreground">
                  {rupiah.format(value)}
                </p>
                <p
                  className={`text-xs font-medium ${returnPct >= 0 ? "text-success" : "text-danger"}`}
                >
                  {returnPct >= 0 ? "+" : ""}
                  {returnPct.toFixed(2)}%
                </p>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}

function TradesCard({ trades }: { trades: Trade[] }) {
  if (!trades.length)
    return (
      <EmptyState
        icon="📝"
        title="No orders yet"
        description="Your completed paper-market orders will appear here."
      />
    );
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Recent orders
      </p>
      <div className="mt-3 space-y-2">
        {trades.slice(0, 20).map((trade) => (
          <div
            key={trade.id}
            className="flex items-center justify-between rounded-xl border border-muted/40 bg-background p-3"
          >
            <div className="flex items-center gap-3">
              <span
                className={`rounded-lg px-2 py-1 text-[10px] font-bold uppercase ${trade.tradeType === "buy" ? "bg-success/10 text-success" : "bg-danger/10 text-danger"}`}
              >
                {trade.tradeType}
              </span>
              <div>
                <p className="font-semibold text-foreground">{trade.symbol}</p>
                <p className="text-xs text-muted-foreground">
                  {trade.lotCount} lots · Market
                </p>
              </div>
            </div>
            <p className="text-sm font-semibold text-foreground">
              {rupiah.format(trade.totalAmount)}
            </p>
          </div>
        ))}
      </div>
    </section>
  );
}

function DataDisclaimer({ marketData }: { marketData: MarketData[] }) {
  const latest = marketData
    .map((item) => item.tradeDate)
    .sort()
    .at(-1);
  const simulated = marketData.filter((item) => item.isSimulated).length;
  return (
    <div className="rounded-xl border border-warning/20 bg-warning/5 p-3 text-xs leading-relaxed text-muted-foreground">
      <span className="inline-flex items-center font-semibold text-foreground">
        Delayed data:
        <ContextualHelp label="Delayed and simulated data" align="right">
          Quotes use the latest end-of-day data available to Koinaku. A
          simulated label means official IDX data was unavailable, so use it for
          learning rather than a real-world trading decision.
        </ContextualHelp>
      </span>{" "}
      Latest EOD{" "}
      {latest
        ? new Date(`${latest}T00:00:00`).toLocaleDateString("id-ID")
        : "pending"}
      .
      {simulated
        ? ` ${simulated} displayed quote${simulated === 1 ? " is" : "s are"} simulated because official data was unavailable.`
        : ""}{" "}
      No real orders are placed or filled.
    </div>
  );
}

function QuoteStatus({
  quote,
  className = "",
}: {
  quote?: MarketData;
  className?: string;
}) {
  if (!quote)
    return (
      <p className={`text-xs text-muted-foreground ${className}`}>
        Data pending
      </p>
    );
  return (
    <p
      className={`flex gap-1 text-[11px] ${quote.isSimulated ? "text-warning" : "text-success"} ${className}`}
    >
      <span>{quote.isSimulated ? "Simulated" : "IDX EOD"}</span>
      <span aria-hidden="true">·</span>
      <span>
        {new Date(`${quote.tradeDate}T00:00:00`).toLocaleDateString("id-ID", {
          day: "numeric",
          month: "short",
        })}
      </span>
    </p>
  );
}

function DashboardSkeleton() {
  return (
    <div className="grid gap-5 lg:grid-cols-[minmax(0,1fr)_380px]">
      <div className="space-y-5">
        <div className="h-36 animate-pulse rounded-[18px] bg-muted" />
        <div className="h-72 animate-pulse rounded-[18px] bg-muted" />
        <div className="h-48 animate-pulse rounded-[18px] bg-muted" />
      </div>
      <div className="h-[36rem] animate-pulse rounded-[18px] bg-muted" />
    </div>
  );
}
