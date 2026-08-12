"use client";

import { useId, useMemo, useRef, useState } from "react";
import {
  Area,
  AreaChart,
  CartesianGrid,
  ReferenceLine,
  ResponsiveContainer,
  XAxis,
  YAxis,
} from "recharts";
import { ContextualHelp } from "@/components/ContextualHelp";
import { SourceBadge, type ChartDataSource } from "@/components/SourceBadge";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import type { Locale } from "@/lib/i18n/types";
import {
  formatRupiah,
  formatRupiahChange,
  getChangeTone,
} from "@/lib/formatters/rupiah";
import {
  type PortfolioHistoryRange,
  type PortfolioValueSnapshot,
} from "@/lib/trading/client";

const RANGES: PortfolioHistoryRange[] = ["1M", "3M", "6M", "All"];

const SUBTITLE_OVER_RANGE_KEY: Record<PortfolioHistoryRange, string> = {
  "1M": "portfolioStory.subtitleOver1M",
  "3M": "portfolioStory.subtitleOver3M",
  "6M": "portfolioStory.subtitleOver6M",
  All: "portfolioStory.subtitleOverAll",
};

const compact = new Intl.NumberFormat("id-ID", {
  notation: "compact",
  maximumFractionDigits: 1,
});

const REQUESTED_RANGE_DAYS: Record<
  Exclude<PortfolioHistoryRange, "All">,
  number
> = {
  "1M": 31,
  "3M": 92,
  "6M": 183,
};

function formatAxis(value: number) {
  return `Rp ${compact.format(value)}`;
}

const userTimeZone =
  typeof Intl !== "undefined"
    ? Intl.DateTimeFormat().resolvedOptions().timeZone
    : "Asia/Jakarta";

function localeTag(locale: Locale) {
  return locale === "id" ? "id-ID" : "en-US";
}

function ymdInTimeZone(date: Date, timeZone: string) {
  const formatter = new Intl.DateTimeFormat("en-CA", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
  const parts = formatter.formatToParts(date);
  const year = parts.find((part) => part.type === "year")?.value;
  const month = parts.find((part) => part.type === "month")?.value;
  const day = parts.find((part) => part.type === "day")?.value;
  return `${year}-${month}-${day}`;
}

function parseDateInTimeZone(date: string, timeZone: string) {
  const [year, month, day] = date.split("-").map(Number);
  let candidate = new Date(Date.UTC(year, month - 1, day));
  for (let index = 0; index < 3; index += 1) {
    const actual = ymdInTimeZone(candidate, timeZone);
    if (actual === date) return candidate;
    const [actualYear, actualMonth, actualDay] = actual.split("-").map(Number);
    const diffDays =
      Math.floor(
        Date.UTC(year, month - 1, day) -
          Date.UTC(actualYear, actualMonth - 1, actualDay),
      ) / 86_400_000;
    candidate = new Date(candidate.getTime() + diffDays * 86_400_000);
  }
  return candidate;
}

function dateParts(date: Date | string, locale: Locale, timeZone: string) {
  const formatter = new Intl.DateTimeFormat(localeTag(locale), {
    timeZone,
    day: "numeric",
    month: "short",
  });
  const input = typeof date === "string" ? parseDateInTimeZone(date, timeZone) : date;
  const parts = formatter.formatToParts(input);
  const day = Number(parts.find((part) => part.type === "day")?.value);
  const month = parts.find((part) => part.type === "month")?.value ?? "";
  return { day, month };
}

function formatDate(
  date: Date | string,
  locale: Locale,
  timeZone = userTimeZone,
) {
  const { day, month } = dateParts(date, locale, timeZone);
  return `${day} ${month}`;
}

function formatTickDate(
  date: string,
  range: PortfolioHistoryRange,
  locale: Locale,
) {
  const { day, month } = dateParts(date, locale, userTimeZone);
  if (range === "All") return month;
  return `${month} W${Math.ceil(day / 7)}`;
}

function formatPercentChange(change: number, base: number): string {
  if (base === 0) return "0.0%";
  const percent = (change / base) * 100;
  const formatted = new Intl.NumberFormat("id-ID", {
    minimumFractionDigits: 1,
    maximumFractionDigits: 1,
  }).format(Math.abs(percent));
  if (Math.abs(percent) < 0.05) return "0.0%";
  return `${change > 0 ? "+" : change < 0 ? "-" : ""}${formatted}%`;
}

function recordedDaySpan(points: PortfolioValueSnapshot[]) {
  if (points.length < 2) return 0;
  const first = parseDateInTimeZone(points[0].date, "Asia/Jakarta").getTime();
  const last = parseDateInTimeZone(points.at(-1)!.date, "Asia/Jakarta").getTime();
  return Math.max(0, Math.round((last - first) / 86_400_000));
}

function rangeContext(
  points: PortfolioValueSnapshot[],
  range: PortfolioHistoryRange,
  locale: Locale,
) {
  const days = recordedDaySpan(points);
  const requested = range === "All" ? null : REQUESTED_RANGE_DAYS[range];
  if (requested === null || days >= requested) return null;
  return locale === "id"
    ? `Hanya ${days} hari catatan tersedia. Tampilan ${range} akan bertambah saat valuasi harian tercatat.`
    : `Only ${days} recorded days are available. The ${range} view will grow as daily valuations are recorded.`;
}

function freshnessContext(points: PortfolioValueSnapshot[], locale: Locale) {
  const latest = points.at(-1);
  if (!latest) return null;
  const marketDate = formatDate(latest.date, locale, "Asia/Jakarta");
  const localDate = formatDate(new Date(), locale, userTimeZone);
  return locale === "id"
    ? `Tanggal pasar: ${marketDate} (Jakarta) · Tanggal lokal kamu: ${localDate} (${userTimeZone})`
    : `Market date: ${marketDate} (Jakarta) · Your local date: ${localDate} (${userTimeZone})`;
}

function valueDomain(points: PortfolioValueSnapshot[]): [number, number] {
  const values = points.map((point) => point.totalValue);
  const current = values.at(-1) ?? 0;
  const rawMinimum = values.length > 0 ? Math.min(...values) : current;
  const rawMaximum = values.length > 0 ? Math.max(...values) : current;
  const spread = Math.max(rawMaximum - rawMinimum, Math.abs(current) * 0.03, 1);
  return [rawMinimum - spread * 0.18, rawMaximum + spread * 0.18];
}

function chartPointPosition(
  index: number,
  point: PortfolioValueSnapshot,
  points: PortfolioValueSnapshot[],
  domain: [number, number],
) {
  const x = points.length < 2 ? 50 : (index / (points.length - 1)) * 100;
  const y =
    8 +
    ((domain[1] - point.totalValue) / Math.max(domain[1] - domain[0], 1)) *
      72;
  return { x, y };
}

function pointIndexFromClientX(
  event: { clientX: number },
  element: HTMLDivElement | null,
  pointCount: number,
) {
  if (!element || pointCount < 2) return pointCount === 1 ? 0 : null;
  const rect = element.getBoundingClientRect();
  if (rect.width <= 0) return null;
  const ratio = Math.min(Math.max((event.clientX - rect.left) / rect.width, 0), 1);
  return Math.round(ratio * (pointCount - 1));
}

export default function PortfolioChart({
  snapshots,
  range,
  dataSource = "simulated",
  onRangeChange,
  loading = false,
}: {
  snapshots: PortfolioValueSnapshot[];
  range: PortfolioHistoryRange;
  dataSource?: ChartDataSource;
  onRangeChange?: (range: PortfolioHistoryRange) => void;
  loading?: boolean;
}) {
  const { locale, t } = useLocale();
  const chartRef = useRef<HTMLDivElement>(null);
  const gradientId = useId().replace(/:/g, "");
  const [hoverIndex, setHoverIndex] = useState<number | null>(null);
  const [pinnedIndex, setPinnedIndex] = useState<number | null>(null);
  const [keyboardIndex, setKeyboardIndex] = useState<number | null>(null);

  // This is deliberately a one-to-one view of recorded snapshots: no browser
  // interpolation, no extra current-day point, and no fabricated market data.
  const chartData = useMemo(() => snapshots, [snapshots]);
  const domain = useMemo(() => valueDomain(chartData), [chartData]);
  const chartTotalValue = chartData.at(-1)?.totalValue ?? 0;
  const firstValue = chartData[0]?.totalValue ?? 0;
  const change = chartTotalValue - firstValue;
  const hasHistory = chartData.length > 1;
  const hasMovement = chartData.some(
    (point) => Math.abs(point.totalValue - firstValue) >= 1,
  );
  const rangeNote = useMemo(
    () => rangeContext(chartData, range, locale),
    [chartData, range, locale],
  );
  const freshnessNote = useMemo(
    () => freshnessContext(chartData, locale),
    [chartData, locale],
  );
  const selectedIndex = pinnedIndex ?? keyboardIndex ?? hoverIndex;
  const activePoint = selectedIndex === null ? null : chartData[selectedIndex] ?? null;
  const markerPosition =
    activePoint && selectedIndex !== null
      ? chartPointPosition(selectedIndex, activePoint, chartData, domain)
      : null;

  const inspectAt = (event: { clientX: number }, pin = false) => {
    const index = pointIndexFromClientX(event, chartRef.current, chartData.length);
    if (index === null) return;
    if (pin) {
      setPinnedIndex(index);
      setKeyboardIndex(null);
    } else {
      setHoverIndex(index);
    }
  };

  const clearSelection = () => {
    setHoverIndex(null);
    setPinnedIndex(null);
    setKeyboardIndex(null);
  };

  return (
    <section
      className="rounded-[18px] border border-muted/60 bg-surface p-5 shadow-sm"
      aria-label="Your portfolio performance"
    >
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <div className="flex items-center gap-3">
            <span
              className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/8 text-primary"
              aria-hidden="true"
            >
              <PortfolioIcon />
            </span>
            <h2 className="text-base font-bold tracking-tight text-foreground">
              Your portfolio
            </h2>
            <ContextualHelp label="Your portfolio chart">
              This shows your total paper wealth over time: virtual cash plus
              the latest value of any stocks or ETFs you own. It is not a live
              stock-price chart. It updates after your trades and daily
              end-of-day valuations.
            </ContextualHelp>
          </div>
          <div className="mt-2 flex flex-wrap gap-1.5">
            <SourceBadge dataSource={dataSource} />
          </div>
          <p className="mt-3 text-2xl font-bold tracking-tight text-foreground">
            {formatRupiah(chartTotalValue)}
          </p>
          <p
            className={`mt-1 text-sm font-semibold ${getChangeTone(change) === "positive" ? "text-success" : getChangeTone(change) === "negative" ? "text-danger" : "text-muted-foreground"}`}
          >
            {formatRupiahChange(change)} {t(SUBTITLE_OVER_RANGE_KEY[range])}
          </p>
        </div>
        <div
          className="inline-flex rounded-full border border-muted/60 p-1"
          role="tablist"
          aria-label="Portfolio chart range"
        >
          {RANGES.map((item) => (
            <button
              key={item}
              type="button"
              role="tab"
              aria-selected={range === item}
              onClick={() => onRangeChange?.(item)}
              className={`min-h-8 rounded-full px-3 text-xs font-bold transition-colors duration-150 ${range === item ? "bg-primary/8 text-primary" : "text-muted-foreground hover:text-foreground"}`}
            >
              {item}
            </button>
          ))}
        </div>
      </div>

      <div className="mt-8" aria-live="polite">
        {loading ? (
          <div className="h-56 animate-pulse rounded-xl bg-muted" />
        ) : (
          <div className="relative h-56 w-full">
            <div
              ref={chartRef}
              data-testid="portfolio-area-chart"
              data-series="portfolio-value"
              className="h-full w-full touch-pan-y outline-none focus-visible:ring-2 focus-visible:ring-primary/50"
              role="img"
              aria-label={`${range} portfolio value chart`}
              tabIndex={0}
              onMouseMove={(event) => inspectAt(event)}
              onMouseLeave={() => setHoverIndex(null)}
              onPointerDown={(event) => {
                if (event.pointerType !== "mouse") inspectAt(event, true);
              }}
              onPointerLeave={() => setHoverIndex(null)}
              onKeyDown={(event) => {
              if (chartData.length === 0) return;
              if (event.key === "Escape") {
                clearSelection();
                return;
              }
              if (event.key === "Home") {
                event.preventDefault();
                setKeyboardIndex(0);
                setPinnedIndex(null);
                return;
              }
              if (event.key === "End") {
                event.preventDefault();
                setKeyboardIndex(chartData.length - 1);
                setPinnedIndex(null);
                return;
              }
              if (event.key === "ArrowLeft" || event.key === "ArrowRight") {
                event.preventDefault();
                const current = selectedIndex ?? 0;
                const offset = event.key === "ArrowRight" ? 1 : -1;
                setKeyboardIndex(
                  Math.min(Math.max(current + offset, 0), chartData.length - 1),
                );
                setPinnedIndex(null);
              }
              }}
            >
              <ResponsiveContainer width="100%" height="100%">
              <AreaChart
                accessibilityLayer
                data={chartData}
                margin={{ top: 10, right: 12, left: 0, bottom: 0 }}
              >
                <defs>
                  <linearGradient
                    id={`portfolio-area-fill-${gradientId}`}
                    x1="0"
                    y1="0"
                    x2="0"
                    y2="1"
                  >
                    <stop offset="5%" stopColor="var(--color-primary)" stopOpacity={0.42} />
                    <stop offset="95%" stopColor="var(--color-primary)" stopOpacity={0.04} />
                  </linearGradient>
                </defs>
                <CartesianGrid
                  vertical={false}
                  stroke="var(--color-border)"
                  strokeDasharray="4 6"
                  strokeOpacity={0.72}
                />
                <XAxis
                  dataKey="date"
                  axisLine={false}
                  tickLine={false}
                  tickMargin={10}
                  minTickGap={22}
                  tick={{ fill: "var(--color-muted-foreground)", fontSize: 11 }}
                  tickFormatter={(value: string) => formatTickDate(value, range, locale)}
                />
                <YAxis
                  axisLine={false}
                  tickLine={false}
                  tickMargin={8}
                  width={62}
                  domain={domain}
                  tick={{ fill: "var(--color-muted-foreground)", fontSize: 11 }}
                  tickFormatter={formatAxis}
                />
                {chartData.length === 1 && (
                  <ReferenceLine
                    y={chartData[0].totalValue}
                    stroke="var(--color-primary)"
                    strokeDasharray="4 4"
                    strokeOpacity={0.72}
                  />
                )}
                <Area
                  dataKey="totalValue"
                  type="natural"
                  name="Portfolio value"
                  stroke="var(--color-primary)"
                  strokeWidth={2}
                  fill={`url(#portfolio-area-fill-${gradientId})`}
                  isAnimationActive={false}
                  activeDot={false}
                  dot={false}
                />
              </AreaChart>
              </ResponsiveContainer>
            </div>

            {markerPosition && (
              <span
                data-testid="chart-marker"
                aria-hidden="true"
                className="pointer-events-none absolute z-[1] size-3 -translate-x-1/2 -translate-y-1/2 rounded-full border-2 border-primary bg-surface shadow-sm"
                style={{ left: `${markerPosition.x}%`, top: `${markerPosition.y}%` }}
              />
            )}

            {activePoint && markerPosition && (
              <div
                data-testid="chart-tooltip"
                className="pointer-events-none absolute z-10 min-w-[10rem] -translate-x-1/2 -translate-y-[115%] rounded-xl border border-muted/60 bg-surface p-3 shadow-[0_10px_24px_rgba(43,35,93,0.12)]"
                style={{ left: `${markerPosition.x}%`, top: `${markerPosition.y}%` }}
              >
                <p className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">
                  {formatDate(activePoint.date, locale)}
                </p>
                <p className="mt-0.5 text-base font-bold text-foreground">
                  {formatRupiah(activePoint.totalValue)}
                </p>
                <p
                  className={`mt-1 flex items-center gap-1 text-xs font-bold ${getChangeTone(activePoint.totalValue - firstValue) === "positive" ? "text-success" : getChangeTone(activePoint.totalValue - firstValue) === "negative" ? "text-danger" : "text-muted-foreground"}`}
                >
                  {activePoint.totalValue - firstValue >= 0 ? (
                    <ArrowUpIcon className="h-3 w-3" />
                  ) : (
                    <ArrowDownIcon className="h-3 w-3" />
                  )}
                  {formatPercentChange(activePoint.totalValue - firstValue, firstValue)} {t("portfolioStory.tooltipFromStart")}
                </p>
                <p className="mt-1.5 text-[11px] leading-snug text-muted-foreground">
                  {t("portfolioStory.tooltipDisclosure")}
                </p>
              </div>
            )}
          </div>
        )}
      </div>

      {rangeNote && (
        <p className="mt-3 text-xs leading-relaxed text-muted-foreground">{rangeNote}</p>
      )}
      {freshnessNote && (
        <p className="mt-2 text-xs leading-relaxed text-muted-foreground">{freshnessNote}</p>
      )}

      {!hasMovement && !loading && (
        <p className="mt-5 text-xs leading-relaxed text-muted-foreground">
          {hasHistory
            ? "No portfolio-value change between recorded snapshots yet. Daily end-of-day valuations will extend the history when your holdings move."
            : "Your starting value is shown as a baseline. Daily end-of-day valuations will build the history from here."}
        </p>
      )}
    </section>
  );
}

function PortfolioIcon() {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className="h-5 w-5"
    >
      <path d="M4 18V6" />
      <path d="M4 18h16" />
      <path d="m7 14 3-3 3 2 4-5" />
      <path d="M17 8h-3V5" />
    </svg>
  );
}

function ArrowUpIcon({ className }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="m5 12 7-7 7 7" />
      <path d="M12 19V5" />
    </svg>
  );
}

function ArrowDownIcon({ className }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="m5 12 7 7 7-7" />
      <path d="M12 5v14" />
    </svg>
  );
}
