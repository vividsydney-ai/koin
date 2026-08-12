"use client";

import { useEffect, useId, useMemo, useRef, useState } from "react";
import {
  Area,
  AreaChart,
  CartesianGrid,
  ReferenceLine,
  ResponsiveContainer,
  XAxis,
  YAxis,
} from "recharts";
import { formatRupiah, formatRupiahChange, getChangeTone } from "@/lib/formatters/rupiah";
import {
  getPracticeMarketValuationHistory,
  PRACTICE_MARKET_SEASON_ONE_SLUG,
  type PracticeMarketValuation,
} from "@/lib/practice-market/valuation-history";

export type { PracticeMarketValuation } from "@/lib/practice-market/valuation-history";

type SeasonRange = "session" | "week" | "season";

const RANGE_LABELS: Record<SeasonRange, string> = {
  session: "Session",
  week: "Week",
  season: "Season",
};

const compactRupiah = new Intl.NumberFormat("id-ID", {
  notation: "compact",
  maximumFractionDigits: 1,
});

function visibleValuations(valuations: PracticeMarketValuation[], range: SeasonRange) {
  if (range === "session") return valuations.slice(-1);
  if (range === "week") return valuations.slice(-5);
  return valuations;
}

function valueDomain(valuations: PracticeMarketValuation[]): [number, number] {
  const values = valuations.map((valuation) => valuation.totalValue);
  const current = values.at(-1) ?? 0;
  const minimum = values.length ? Math.min(...values) : current;
  const maximum = values.length ? Math.max(...values) : current;
  const spread = Math.max(maximum - minimum, Math.abs(current) * 0.025, 1);
  return [Math.max(0, minimum - spread * 0.2), maximum + spread * 0.2];
}

function pointIndexFromClientX(
  event: { clientX: number },
  element: HTMLDivElement | null,
  count: number,
) {
  if (count === 0 || !element) return null;
  if (count === 1) return 0;
  const bounds = element.getBoundingClientRect();
  if (bounds.width <= 0) return null;
  const ratio = Math.min(Math.max((event.clientX - bounds.left) / bounds.width, 0), 1);
  return Math.round(ratio * (count - 1));
}

function markerPosition(
  index: number,
  valuation: PracticeMarketValuation,
  values: PracticeMarketValuation[],
  domain: [number, number],
) {
  const x = values.length < 2 ? 50 : 8 + (index / (values.length - 1)) * 84;
  const y = 9 + ((domain[1] - valuation.totalValue) / Math.max(domain[1] - domain[0], 1)) * 70;
  return { x, y };
}

function formatJakarta(value: string) {
  return new Intl.DateTimeFormat("en-GB", {
    timeZone: "Asia/Jakarta",
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(value));
}

function formatAxis(value: number) {
  return `Rp ${compactRupiah.format(value)}`;
}

export function SeasonPortfolioChart({
  valuations,
}: {
  valuations: PracticeMarketValuation[];
}) {
  const chartRef = useRef<HTMLDivElement>(null);
  const gradientId = useId().replace(/:/g, "");
  const [range, setRange] = useState<SeasonRange>("season");
  const [hoverIndex, setHoverIndex] = useState<number | null>(null);
  const [pinnedIndex, setPinnedIndex] = useState<number | null>(null);
  const [keyboardIndex, setKeyboardIndex] = useState<number | null>(null);

  const visible = useMemo(() => visibleValuations(valuations, range), [range, valuations]);
  const domain = useMemo(() => valueDomain(visible), [visible]);
  const first = visible[0];
  const latest = visible.at(-1);
  const change = latest && first ? latest.totalValue - first.totalValue : 0;
  const selectedIndex = pinnedIndex ?? keyboardIndex ?? hoverIndex;
  const selected = selectedIndex === null ? null : visible[selectedIndex] ?? null;
  const selectedPosition =
    selected && selectedIndex !== null
      ? markerPosition(selectedIndex, selected, visible, domain)
      : null;
  const sparse = valuations.length < 10;

  const clearInspection = () => {
    setHoverIndex(null);
    setPinnedIndex(null);
    setKeyboardIndex(null);
  };

  const inspect = (event: { clientX: number }, pin = false) => {
    const nextIndex = pointIndexFromClientX(event, chartRef.current, visible.length);
    if (nextIndex === null) return;
    if (pin) {
      setPinnedIndex(nextIndex);
      setKeyboardIndex(null);
    } else {
      setHoverIndex(nextIndex);
    }
  };

  return (
    <section
      className="rounded-[18px] border border-muted/60 bg-surface p-5 shadow-sm sm:p-6"
      aria-labelledby="season-portfolio-title"
    >
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <p className="text-xs font-bold uppercase tracking-[0.16em] text-primary">
            Simulation · Season 1
          </p>
          <h1 id="season-portfolio-title" className="mt-2 text-xl font-bold tracking-tight text-foreground">
            Your Season portfolio
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">Price Pressure, Calm Choices</p>
        </div>
        <div className="inline-flex rounded-full border border-muted/60 bg-background p-1" role="tablist" aria-label="Season valuation range">
          {(Object.keys(RANGE_LABELS) as SeasonRange[]).map((item) => (
            <button
              key={item}
              type="button"
              role="tab"
              aria-selected={range === item}
              onClick={() => {
                setRange(item);
                clearInspection();
              }}
              className={`min-h-11 rounded-full px-3 text-xs font-bold transition-colors ${
                range === item ? "bg-primary/10 text-primary" : "text-muted-foreground hover:text-foreground"
              }`}
            >
              {RANGE_LABELS[item]}
            </button>
          ))}
        </div>
      </div>

      <div className="mt-5 flex flex-wrap items-end justify-between gap-3">
        <div>
          <p className="text-3xl font-bold tracking-tight text-foreground">{latest ? formatRupiah(latest.totalValue) : "—"}</p>
          <p className={`mt-1 text-sm font-semibold ${getChangeTone(change) === "positive" ? "text-success" : getChangeTone(change) === "negative" ? "text-danger" : "text-muted-foreground"}`}>
            {formatRupiahChange(change)} from the first released session in this view
          </p>
        </div>
        <p className="rounded-full bg-primary/10 px-3 py-1.5 text-xs font-semibold text-primary">
          Session-close valuation · Jakarta
        </p>
      </div>

      <div className="mt-6" aria-live="polite">
        <div className="relative h-72 w-full">
          <div
            ref={chartRef}
            data-testid="season-valuation-chart"
            data-series="season-valuation-ledger"
            className="h-full w-full touch-pan-y rounded-lg outline-none focus-visible:ring-2 focus-visible:ring-primary/50"
            role="img"
            aria-label="Season portfolio valuation chart"
            tabIndex={0}
            onMouseMove={(event) => inspect(event)}
            onMouseLeave={() => setHoverIndex(null)}
            onPointerDown={(event) => {
              if (event.pointerType !== "mouse") inspect(event, true);
            }}
            onPointerLeave={() => setHoverIndex(null)}
            onKeyDown={(event) => {
              if (visible.length === 0) return;
              if (event.key === "Escape") {
                clearInspection();
                return;
              }
              if (event.key === "Home" || event.key === "End") {
                event.preventDefault();
                setKeyboardIndex(event.key === "Home" ? 0 : visible.length - 1);
                setPinnedIndex(null);
                return;
              }
              if (event.key === "ArrowLeft" || event.key === "ArrowRight") {
                event.preventDefault();
                const activeIndex = selectedIndex ?? 0;
                const offset = event.key === "ArrowRight" ? 1 : -1;
                setKeyboardIndex(Math.min(Math.max(activeIndex + offset, 0), visible.length - 1));
                setPinnedIndex(null);
              }
            }}
          >
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart accessibilityLayer data={visible} margin={{ top: 12, right: 12, left: 0, bottom: 0 }}>
                <defs>
                  <linearGradient id={`season-valuation-fill-${gradientId}`} x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="var(--color-primary)" stopOpacity={0.48} />
                    <stop offset="95%" stopColor="var(--color-primary)" stopOpacity={0.05} />
                  </linearGradient>
                </defs>
                <CartesianGrid vertical={false} stroke="var(--color-border)" strokeDasharray="4 6" strokeOpacity={0.72} />
                <XAxis
                  dataKey="sessionNumber"
                  axisLine={false}
                  tickLine={false}
                  tickMargin={10}
                  minTickGap={18}
                  tick={{ fill: "var(--color-muted-foreground)", fontSize: 11 }}
                  tickFormatter={(value: number) => `S${value}`}
                />
                <YAxis
                  axisLine={false}
                  tickLine={false}
                  tickMargin={8}
                  width={68}
                  domain={domain}
                  tick={{ fill: "var(--color-muted-foreground)", fontSize: 11 }}
                  tickFormatter={formatAxis}
                />
                {visible.length === 1 && <ReferenceLine y={visible[0].totalValue} stroke="var(--color-primary)" strokeDasharray="4 4" strokeOpacity={0.7} />}
                <Area
                  dataKey="totalValue"
                  name="Season valuation"
                  type="natural"
                  stroke="var(--color-primary)"
                  strokeWidth={2.25}
                  fill={`url(#season-valuation-fill-${gradientId})`}
                  isAnimationActive={false}
                  activeDot={false}
                  dot={false}
                />
              </AreaChart>
            </ResponsiveContainer>
          </div>

          {selectedPosition && (
            <span
              data-testid="season-chart-marker"
              aria-hidden="true"
              className="pointer-events-none absolute z-[1] size-3 -translate-x-1/2 -translate-y-1/2 rounded-full border-2 border-primary bg-surface shadow-sm"
              style={{ left: `${selectedPosition.x}%`, top: `${selectedPosition.y}%` }}
            />
          )}

          {selected && selectedPosition && (
            <div
              data-testid="season-chart-tooltip"
              className="pointer-events-none absolute z-10 min-w-52 -translate-x-1/2 -translate-y-[115%] rounded-xl border border-muted/60 bg-surface p-3 shadow-[0_10px_24px_rgba(43,35,93,0.12)]"
              style={{ left: `${selectedPosition.x}%`, top: `${selectedPosition.y}%` }}
            >
              <p className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">Session {selected.sessionNumber}</p>
              <p className="mt-0.5 text-base font-bold text-foreground">{formatRupiah(selected.totalValue)}</p>
              <p className="mt-1 text-xs leading-snug text-muted-foreground">
                Recorded {formatJakarta(selected.valuedAt)} Jakarta from your immutable session-close ledger.
              </p>
            </div>
          )}
        </div>
      </div>

      {sparse && (
        <p className="mt-4 text-sm leading-relaxed text-muted-foreground">
          Only {valuations.length} of 10 Season sessions are available. Future sessions stay hidden until their valuation is recorded.
        </p>
      )}
      {latest && (
        <p className="mt-2 text-xs leading-relaxed text-muted-foreground" role="status">
          The latest released valuation is Session {latest.sessionNumber}, recorded {formatJakarta(latest.valuedAt)} Jakarta. This is a simulated learning experience, not a market quote or investment recommendation.
        </p>
      )}
    </section>
  );
}

export default function PracticeMarketSeasonPortfolio({
  seasonSlug = PRACTICE_MARKET_SEASON_ONE_SLUG,
}: {
  seasonSlug?: string;
}) {
  const [valuations, setValuations] = useState<PracticeMarketValuation[] | null>(null);
  const [error, setError] = useState(false);
  const [attempt, setAttempt] = useState(0);

  useEffect(() => {
    let active = true;

    void getPracticeMarketValuationHistory(seasonSlug)
      .then((history) => {
        if (active) setValuations(history);
      })
      .catch(() => {
        if (active) setError(true);
      });

    return () => {
      active = false;
    };
  }, [attempt, seasonSlug]);

  if (error) {
    return (
      <main className="min-h-screen bg-background p-5 pb-28 sm:p-6 lg:p-8">
        <section className="mx-auto max-w-5xl rounded-card border border-danger/30 bg-danger/5 p-6 text-sm text-danger">
          <p className="font-bold">Couldn&apos;t load your Season valuations.</p>
          <button
            type="button"
            onClick={() => {
              setError(false);
              setValuations(null);
              setAttempt((value) => value + 1);
            }}
            className="mt-3 min-h-11 rounded-lg border border-danger/30 px-4 font-bold"
          >
            Try again
          </button>
        </section>
      </main>
    );
  }

  if (valuations === null) {
    return (
      <main className="min-h-screen bg-background p-5 pb-28 sm:p-6 lg:p-8">
        <section className="mx-auto max-w-5xl rounded-card border border-muted bg-surface p-6 text-sm text-muted-foreground" aria-live="polite">
          Loading your released session valuations…
        </section>
      </main>
    );
  }

  if (valuations.length === 0) {
    return (
      <main className="min-h-screen bg-background p-5 pb-28 sm:p-6 lg:p-8">
        <section className="mx-auto max-w-5xl rounded-card border border-muted bg-surface p-6">
          <p className="text-sm font-bold text-foreground">No session-close valuation has been recorded yet.</p>
          <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
            Your Season portfolio will appear here after your first released session is settled.
          </p>
        </section>
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-background p-5 pb-28 sm:p-6 lg:p-8">
      <div className="mx-auto max-w-5xl">
        <SeasonPortfolioChart valuations={valuations} />
      </div>
    </main>
  );
}
