"use client";

import {
  useCallback,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import dynamic from "next/dynamic";
import { useAuth } from "@/lib/auth/use-auth";
import {
  addToWatchlist,
  executeTrade,
  getHoldings,
  getInstruments,
  getMarketData,
  getMarketDataHistory,
  getPortfolio,
  getPortfolioValueHistory,
  getTrades,
  getWatchlist,
  removeFromWatchlist,
  type Holding,
  type Instrument,
  type MarketData,
  type Portfolio,
  type PortfolioValueSnapshot,
  type Trade,
  type WatchlistEntry,
} from "@/lib/trading/client";
import {
  formatRupiah,
  formatRupiahChange,
  getChangeTone,
} from "@/lib/formatters/rupiah";
import {
  getHoldingMovement,
  type HoldingMovement,
} from "@/lib/trading/holding-movement";
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
import { PortfolioBalances } from "@/components/PortfolioBalances";
import PortfolioChart from "@/components/PortfolioChart";
import { useLocale } from "@/lib/i18n/LocaleProvider";

const TradeOnboarding = dynamic(() => import("./TradeOnboarding"));
const SHARES_PER_LOT = 100;
export default function TradePage() {
  const { user } = useAuth(true);
  const { t } = useLocale();
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [portfolioHistory, setPortfolioHistory] = useState<
    PortfolioValueSnapshot[]
  >([]);
  const [holdings, setHoldings] = useState<Holding[]>([]);
  const [holdingMovements, setHoldingMovements] = useState<
    Record<string, HoldingMovement>
  >({});
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
      const history = p ? await getPortfolioValueHistory(user.id, "1M") : [];
      const movementEntries = await Promise.all(
        h.map(async (holding) => [
          holding.symbol,
          getHoldingMovement(await getMarketDataHistory(holding.symbol, 2)),
        ] as const),
      );
      setPortfolio(p);
      setPortfolioHistory(history);
      setHoldings(h);
      setHoldingMovements(Object.fromEntries(movementEntries));
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

  const selectInstrument = (instrument: Instrument) => {
    setSymbol(instrument.symbol);
    // Keep the combobox value searchable after selection. Rendering the full
    // "SYMBOL — company" label here makes the filtered catalogue empty on an
    // exact match because the filter intentionally tokenises symbol/name/type.
    setInstrumentQuery(instrument.symbol);
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
              {t("trade.title")}
            </h1>
            <p className="mt-1 text-sm text-muted-foreground">
              {t("trade.subtitle")}
            </p>
          </div>
          <p className="rounded-full border border-primary/20 bg-primary/5 px-3 py-2 text-xs font-semibold text-primary">
            {t("trade.noRealMoney")}
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
              <main className="relative z-10 min-w-0 space-y-5">
                <PortfolioBalances
                  totalValue={portfolioValue}
                  cashBalance={portfolio.cashBalance}
                  startingCash={portfolio.startingCash}
                  history={portfolioHistory}
                />
                <PortfolioChart userId={user!.id} totalValue={portfolioValue} />
                <HoldingsCard
                  holdings={holdings}
                  marketData={marketData}
                  movements={holdingMovements}
                />
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
  const { t } = useLocale();
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
      <div className="flex items-center gap-3">
        <SectionIcon>
          <OrderIcon />
        </SectionIcon>
        <div className="flex items-center">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            {t("trade.placeOrder")}
          </p>
          <ContextualHelp label="Paper Trading order">
            This is a practice order using virtual IDR. It never sends money or
            an order to IDX.
          </ContextualHelp>
        </div>
      </div>
      <div className="mt-4 grid grid-cols-2 gap-2 rounded-xl bg-muted p-1">
        <button
          type="button"
          onClick={() => setTradeType("buy")}
          className={`min-h-11 rounded-lg text-sm font-semibold ${tradeType === "buy" ? "bg-surface text-success shadow-sm" : "text-muted-foreground"}`}
        >
          {t("trade.buy")}
        </button>
        <button
          type="button"
          onClick={() => setTradeType("sell")}
          className={`min-h-11 rounded-lg text-sm font-semibold ${tradeType === "sell" ? "bg-surface text-danger shadow-sm" : "text-muted-foreground"}`}
        >
          {t("trade.sell")}
        </button>
      </div>
      <div className="mt-4 space-y-4">
        <div className="relative">
          <label
            htmlFor="instrument-search"
            className="block text-sm font-medium text-foreground"
          >
            {t("trade.searchStocksEtfs")}
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
            placeholder={t("trade.searchSymbol")}
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
                            ? formatRupiah(quote.closePrice)
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
                {t("trade.noMatches")}
                </p>
              )}
            </div>
          )}
        </div>
        <div className="rounded-xl bg-muted/70 p-3">
          <div className="flex items-start justify-between gap-3">
            <div>
              <p className="font-bold text-foreground">
                {selectedInstrument?.symbol || t("trade.chooseInstrument")}
              </p>
              <p className="max-w-[210px] truncate text-xs text-muted-foreground">
                {selectedInstrument?.name || t("trade.searchCatalogue")}
              </p>
            </div>
            <div className="text-right">
              <p className="font-semibold text-foreground">
                {selectedPrice ? formatRupiah(selectedPrice) : "—"}
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
              {t("trade.quantityLots")}
            </label>
            <ContextualHelp label="IDX lots">
              IDX shares are bought and sold in lots. One lot equals 100 shares,
              so 2 lots means 200 shares.
            </ContextualHelp>
          </div>
          <p className="mt-0.5 text-xs text-muted-foreground">
            {t("trade.lotHint")}
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
              ? t("trade.maxBuy").replace("{count}", String(maxBuyLots))
              : t("trade.available").replace("{count}", String(maxSellLots))}
          </p>
        </div>
        <div className="rounded-xl border border-muted/70 bg-background p-3 text-sm">
          <div className="flex justify-between">
            <span className="text-muted-foreground">{t("trade.estimatedCost")}</span>
            <span className="font-semibold text-foreground">
              {formatRupiah(estimatedTotal)}
            </span>
          </div>
          <div className="mt-1 flex items-center justify-between">
            <span className="flex items-center text-muted-foreground">
              {t("trade.orderType")}
              <ContextualHelp label="Market order" align="right">
                Koinaku fills this simulated order immediately at the latest
                available closing price shown for this symbol. It is not a live
                IDX price or a real broker order.
              </ContextualHelp>
            </span>
            <span className="font-semibold text-foreground">{t("trade.market")}</span>
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
            ? t("trade.executing")
            : t("trade.execute").replace("{action}", tradeType === "buy" ? t("trade.buy") : t("trade.sell")).replace("{symbol}", symbol || "order")}
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
  const { t } = useLocale();
  const rows = watchlist.map((entry) => ({
    entry,
    instrument: instruments.find((item) => item.symbol === entry.symbol),
    quote: marketData.find((item) => item.symbol === entry.symbol),
  }));
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center justify-between gap-3">
        <div>
          <div className="flex items-center gap-3">
            <SectionIcon>
              <WatchlistIcon />
            </SectionIcon>
            <div className="flex items-center">
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                {t("trade.watchlist")}
              </p>
              <ContextualHelp label="Watchlist" align="right">
                A watchlist is only a shortlist of symbols to follow. Adding a
                symbol here does not buy it.
              </ContextualHelp>
            </div>
          </div>
          <p className="mt-1 text-xs text-muted-foreground">
            {t("trade.savedSymbols")}
          </p>
        </div>
        <button
          type="button"
          onClick={onEdit}
          className="min-h-11 rounded-xl border border-muted px-3 text-xs font-bold text-primary hover:bg-primary/5"
        >
          {t("trade.edit")}
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
                  {quote ? formatRupiah(quote.closePrice) : "—"}
                </p>
                <QuoteStatus quote={quote} className="justify-end" />
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="mt-3 rounded-xl border border-dashed border-muted p-4 text-sm text-muted-foreground">
          {t("trade.watchlistEmpty")}
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
  const { t } = useLocale();
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
              {t("trade.editWatchlist")}
            </h2>
            <p className="mt-1 text-sm text-muted-foreground">
              {t("trade.editWatchlistBody")}
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="min-h-11 rounded-xl border border-muted px-3 text-sm font-bold text-foreground"
          >
            {t("trade.done")}
          </button>
        </div>
        <label htmlFor="watchlist-search" className="sr-only">
          {t("trade.searchToAdd")}
        </label>
        <input
          id="watchlist-search"
          type="search"
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder={t("trade.searchCompany")}
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
            {t("trade.savedSymbolsTitle")}
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
              {t("trade.noSavedSymbols")}
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
  movements,
}: {
  holdings: Holding[];
  marketData: MarketData[];
  movements: Record<string, HoldingMovement>;
}) {
  const { t } = useLocale();
  if (!holdings.length)
    return (
      <EmptyState
        icon="📊"
        title={t("trade.noHoldings")}
        description={t("trade.noHoldingsBody")}
      />
    );
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-center gap-3">
        <SectionIcon>
          <HoldingsIcon />
        </SectionIcon>
        <div className="flex items-center">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            {t("trade.holdings")}
          </p>
          <ContextualHelp label="Holdings">
            A holding is a stock or ETF in your paper portfolio. The movement
            shown is its latest day-over-day EOD price change, not a live quote.
          </ContextualHelp>
        </div>
      </div>
      <div className="mt-3 space-y-3">
        {holdings.map((holding) => {
          const movement = movements[holding.symbol];
          const price =
            movement?.latestPrice ??
            marketData.find((item) => item.symbol === holding.symbol)
              ?.closePrice ??
            holding.currentPrice ??
            holding.averageCost;
          const value = holding.shares * price;
          const changeTone = getChangeTone(movement?.change ?? null);
          const dailyMovement =
            movement?.changePercent === null || movement?.changePercent === undefined
              ? "Awaiting prior EOD"
              : `${formatRupiahChange(movement?.change ?? null)} · ${movement.changePercent > 0 ? "+" : ""}${movement.changePercent.toFixed(2)}% today`;
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
                  {formatRupiah(holding.averageCost)}
                </p>
                <p className="mt-1 text-[11px] text-muted-foreground">
                  {t("trade.latest")} {formatRupiah(price)} · {movement?.isSimulated ? `${t("trade.simulated")} EOD` : t("trade.idxEod")}
                </p>
              </div>
              <div className="text-right">
                <p className="font-semibold text-foreground">
                  {formatRupiah(value)}
                </p>
                <p
                  className={`text-xs font-medium ${changeTone === "positive" ? "text-success" : changeTone === "negative" ? "text-danger" : "text-muted-foreground"}`}
                >
                  {dailyMovement}
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
  const { t } = useLocale();
  if (!trades.length)
    return (
      <EmptyState
        icon="📝"
        title={t("trade.noOrders")}
        description={t("trade.noOrdersBody")}
      />
    );
  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm">
      <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        {t("trade.recentOrders")}
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
              {formatRupiah(trade.totalAmount)}
            </p>
          </div>
        ))}
      </div>
    </section>
  );
}

function DataDisclaimer({ marketData }: { marketData: MarketData[] }) {
  const { t, locale } = useLocale();
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
      {locale === "id" ? "EOD terbaru" : "Latest EOD"}{" "}
      {latest
        ? new Date(`${latest}T00:00:00`).toLocaleDateString("id-ID")
        : t("trade.dataPending")}
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
  const { t } = useLocale();
  if (!quote)
    return (
      <p className={`text-xs text-muted-foreground ${className}`}>
        {t("trade.dataPending")}
      </p>
    );
  return (
    <p
      className={`flex gap-1 text-[11px] ${quote.isSimulated ? "text-warning" : "text-success"} ${className}`}
    >
      <span>{quote.isSimulated ? t("trade.simulated") : t("trade.idxEod")}</span>
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

function SectionIcon({ children }: { children: ReactNode }) {
  return (
    <span
      className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-primary/8 text-primary"
      aria-hidden="true"
    >
      {children}
    </span>
  );
}

function OrderIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-5 w-5">
      <path d="M7 7h11" />
      <path d="m15 4 3 3-3 3" />
      <path d="M17 17H6" />
      <path d="m9 14-3 3 3 3" />
    </svg>
  );
}

function WatchlistIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-5 w-5">
      <path d="M6 4.75A1.75 1.75 0 0 1 7.75 3h8.5A1.75 1.75 0 0 1 18 4.75V21l-6-3.5L6 21V4.75Z" />
    </svg>
  );
}

function HoldingsIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="h-5 w-5">
      <rect x="4" y="5" width="16" height="14" rx="2" />
      <path d="M8 15v-3" />
      <path d="M12 15V9" />
      <path d="M16 15v-5" />
    </svg>
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
