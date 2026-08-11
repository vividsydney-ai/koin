"use client";

import { useLayoutEffect, useMemo, useRef, useState } from "react";
import { gsap } from "gsap";
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
const CHART_HEIGHT = 60;
const LINE_Y = 29;

type ChartShape = {
  line: string;
  area: string;
  coords: { x: number; y: number }[];
  marker?: { x: number; y: number };
  axisValues: number[];
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
  for (let i = 0; i < 3; i += 1) {
    const actual = ymdInTimeZone(candidate, timeZone);
    if (actual === date) return candidate;
    const [ay, am, ad] = actual.split("-").map(Number);
    const diffDays =
      Math.floor(
        Date.UTC(year, month - 1, day) - Date.UTC(ay, am - 1, ad),
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
  date: Date | string,
  range: PortfolioHistoryRange,
  locale: Locale,
  timeZone = userTimeZone,
) {
  const { day, month } = dateParts(date, locale, timeZone);
  if (range === "All") {
    return month;
  }
  const week = Math.ceil(day / 7);
  return `${month} W${week}`;
}

function formatPercentChange(change: number, base: number): string {
  if (base === 0) return "0.0%";
  const pct = (change / base) * 100;
  const formatted = new Intl.NumberFormat("id-ID", {
    minimumFractionDigits: 1,
    maximumFractionDigits: 1,
  }).format(Math.abs(pct));
  if (Math.abs(pct) < 0.05) return "0.0%";
  return `${change > 0 ? "+" : change < 0 ? "-" : ""}${formatted}%`;
}

function createChartShape(points: PortfolioValueSnapshot[]): ChartShape {
  const values = points.map((point) => point.totalValue);
  const current = values.at(-1) ?? 0;
  const variation = Math.max(Math.abs(current) * 0.015, 1);
  const hasMovement = values.some((value) => Math.abs(value - current) >= 1);
  const rawMin = hasMovement ? Math.min(...values) : current - variation;
  const rawMax = hasMovement ? Math.max(...values) : current + variation;
  const padding = Math.max((rawMax - rawMin) * 0.18, variation * 0.25);
  const minimum = rawMin - padding;
  const maximum = rawMax + padding;
  const range = Math.max(maximum - minimum, 1);
  const axisValues = [maximum, (maximum + minimum) / 2, minimum];

  if (points.length < 2) {
    return {
      line: `M0,${LINE_Y} L100,${LINE_Y}`,
      area: "",
      coords: [
        { x: 0, y: LINE_Y },
        { x: 100, y: LINE_Y },
      ],
      axisValues,
    };
  }

  const coords = points.map((point, index) => {
    const x = (index / (points.length - 1)) * 100;
    const y = 4 + ((maximum - point.totalValue) / range) * (CHART_HEIGHT - 12);
    return { x, y };
  });
  let line = `M${coords[0].x},${coords[0].y}`;
  for (let index = 1; index < coords.length; index += 1) {
    const previous = coords[index - 1];
    const currentPoint = coords[index];
    const midpoint = (previous.x + currentPoint.x) / 2;
    line += ` C${midpoint},${previous.y} ${midpoint},${currentPoint.y} ${currentPoint.x},${currentPoint.y}`;
  }

  return {
    line,
    area: `${line} L100,${CHART_HEIGHT - 2} L0,${CHART_HEIGHT - 2} Z`,
    coords,
    marker: coords.at(-1) ?? { x: 100, y: LINE_Y },
    axisValues,
  };
}

type Tick = { label: string; x: number };

const TICK_CONFIG: Record<
  PortfolioHistoryRange,
  { count: number; minGapDays: number }
> = {
  "1M": { count: 4, minGapDays: 7 },
  "3M": { count: 5, minGapDays: 14 },
  "6M": { count: 5, minGapDays: 14 },
  All: { count: 6, minGapDays: 30 },
};

function generateTicks(
  points: PortfolioValueSnapshot[],
  range: PortfolioHistoryRange,
  locale: Locale,
  timeZone = userTimeZone,
): Tick[] {
  if (points.length === 0) return [];
  if (points.length === 1) {
    return [
      {
        label: formatTickDate(
          parseDateInTimeZone(points[0].date, timeZone),
          range,
          locale,
          timeZone,
        ),
        x: 0,
      },
    ];
  }

  const { count, minGapDays } = TICK_CONFIG[range];
  const startTime = parseDateInTimeZone(points[0].date, timeZone).getTime();
  const endTime = parseDateInTimeZone(points.at(-1)!.date, timeZone).getTime();
  const spanMs = endTime - startTime;
  const msPerDay = 86_400_000;

  if (spanMs <= 0) {
    return points.map((point, index) => ({
      label: formatTickDate(
        parseDateInTimeZone(point.date, timeZone),
        range,
        locale,
        timeZone,
      ),
      x: (index / (points.length - 1)) * 100,
    }));
  }

  const ticks: Tick[] = [];
  const used = new Set<string>();
  let lastTime = -Infinity;

  for (let i = 1; i <= count; i += 1) {
    const targetTime = startTime + (i / (count + 1)) * spanMs;
    const targetDate = new Date(targetTime);
    const label = formatTickDate(targetDate, range, locale, timeZone);

    if (used.has(label)) continue;
    if ((targetTime - lastTime) / msPerDay < minGapDays) continue;

    ticks.push({
      label,
      x: ((targetTime - startTime) / spanMs) * 100,
    });
    used.add(label);
    lastTime = targetTime;
  }

  return ticks;
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
  const [hoverIndex, setHoverIndex] = useState<number | null>(null);
  const svgRef = useRef<SVGSVGElement>(null);
  const visualRef = useRef<SVGGElement>(null);

  const chartTotalValue = snapshots.at(-1)?.totalValue ?? 0;
  const chart = useMemo(() => createChartShape(snapshots), [snapshots]);
  const firstValue = snapshots[0]?.totalValue ?? 0;
  const change = chartTotalValue - firstValue;
  const hasHistory = snapshots.length > 1;
  const hasMovement = useMemo(
    () =>
      snapshots.some(
        (point) => Math.abs(point.totalValue - firstValue) >= 1,
      ),
    [snapshots, firstValue],
  );
  const ticks = useMemo(
    () => generateTicks(snapshots, range, locale),
    [snapshots, range, locale],
  );

  useLayoutEffect(() => {
    if (!visualRef.current || loading) return;
    const media = gsap.matchMedia();
    media.add("(prefers-reduced-motion: no-preference)", () => {
      gsap.fromTo(
        visualRef.current,
        { autoAlpha: 0.35, scaleY: 0.98, transformOrigin: "50% 50%" },
        {
          autoAlpha: 1,
          scaleY: 1,
          duration: 0.22,
          ease: "power3.out",
          overwrite: "auto",
        },
      );
    });
    return () => media.revert();
  }, [chart.line, loading, range]);

  const handleMouseMove = (event: React.MouseEvent<SVGSVGElement>) => {
    if (!svgRef.current || snapshots.length < 2) return;
    const rect = svgRef.current.getBoundingClientRect();
    const ratio = Math.min(
      Math.max((event.clientX - rect.left) / rect.width, 0),
      1,
    );
    const index = Math.round(ratio * (snapshots.length - 1));
    setHoverIndex(index);
  };

  const handleMouseLeave = () => setHoverIndex(null);

  const activePoint =
    hoverIndex !== null ? snapshots[hoverIndex] : null;
  const activeCoord =
    hoverIndex !== null ? chart.coords[hoverIndex] : null;

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

      <div
        className="mt-8 grid grid-cols-[3.75rem_minmax(0,1fr)] gap-x-3"
        aria-live="polite"
      >
        <div className="flex h-56 flex-col justify-between pb-7 text-right text-[11px] font-medium text-muted-foreground">
          {chart.axisValues.map((value) => (
            <span key={value}>{formatAxis(value)}</span>
          ))}
        </div>
        <div className="relative">
          {loading ? (
            <div className="h-56 animate-pulse rounded-xl bg-muted" />
          ) : (
            <>
              <svg
                ref={svgRef}
                viewBox={`0 0 100 ${CHART_HEIGHT}`}
                preserveAspectRatio="none"
                className="h-56 w-full overflow-visible"
                role="img"
                aria-label={`${range} portfolio value chart`}
                onMouseMove={handleMouseMove}
                onMouseLeave={handleMouseLeave}
              >
                {[7, LINE_Y, 52].map((y) => (
                  <path
                    key={y}
                    d={`M0,${y} H100`}
                    stroke="var(--color-border)"
                    strokeDasharray="2 2"
                    strokeOpacity="0.75"
                    strokeWidth="0.35"
                  />
                ))}
                <g ref={visualRef}>
                  {hasMovement && (
                    <path
                      d={chart.area}
                      fill="var(--color-primary)"
                      fillOpacity="0.09"
                    />
                  )}
                  <path
                    d={chart.line}
                    fill="none"
                    stroke="var(--color-primary)"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeOpacity={hasMovement ? "1" : "0.82"}
                    strokeWidth={hasMovement ? "1.2" : "1"}
                    vectorEffect="non-scaling-stroke"
                  />
                  {activeCoord && (
                    <>
                      <line
                        x1={activeCoord.x}
                        y1={0}
                        x2={activeCoord.x}
                        y2={CHART_HEIGHT}
                        stroke="var(--color-border)"
                        strokeOpacity={0.6}
                        strokeWidth="0.5"
                        vectorEffect="non-scaling-stroke"
                      />
                      <circle
                        cx={activeCoord.x}
                        cy={activeCoord.y}
                        r="1.4"
                        fill="var(--color-surface)"
                        stroke="var(--color-primary)"
                        strokeWidth="0.75"
                        vectorEffect="non-scaling-stroke"
                      />
                    </>
                  )}
                  {hasMovement && chart.marker && (
                    <circle
                      cx={chart.marker.x}
                      cy={chart.marker.y}
                      r="1.15"
                      fill="var(--color-surface)"
                      stroke="var(--color-primary)"
                      strokeWidth="0.75"
                      vectorEffect="non-scaling-stroke"
                    />
                  )}
                </g>
              </svg>
              {activePoint && activeCoord && (
                <div
                  data-testid="chart-tooltip"
                  className="pointer-events-none absolute z-10 min-w-[10rem] -translate-x-1/2 -translate-y-[115%] rounded-xl border border-muted/60 bg-surface p-3 shadow-[0_10px_24px_rgba(43,35,93,0.12)]"
                  style={{
                    left: `${activeCoord.x}%`,
                    top: `${activeCoord.y}%`,
                  }}
                >
                  <p className="text-[11px] font-semibold uppercase tracking-wide text-muted-foreground">
                    {formatDate(activePoint.date, locale)}
                  </p>
                  <p className="mt-0.5 text-base font-bold text-foreground">
                    {formatRupiah(activePoint.totalValue)}
                  </p>
                  <p
                    className={`mt-1 flex items-center gap-1 text-xs font-bold ${
                      getChangeTone(activePoint.totalValue - firstValue) ===
                      "positive"
                        ? "text-success"
                        : getChangeTone(activePoint.totalValue - firstValue) ===
                            "negative"
                          ? "text-danger"
                          : "text-muted-foreground"
                    }`}
                  >
                    {activePoint.totalValue - firstValue >= 0 ? (
                      <ArrowUpIcon className="h-3 w-3" />
                    ) : (
                      <ArrowDownIcon className="h-3 w-3" />
                    )}
                    {formatPercentChange(
                      activePoint.totalValue - firstValue,
                      firstValue,
                    )}{" "}
                    {t("portfolioStory.tooltipFromStart")}
                  </p>
                  <p className="mt-1.5 text-[11px] leading-snug text-muted-foreground">
                    {t("portfolioStory.tooltipDisclosure")}
                  </p>
                </div>
              )}
            </>
          )}
          <div className="relative mt-2 h-5 text-[11px] font-medium text-muted-foreground">
            {ticks.map((tick) => (
              <span
                key={tick.label + tick.x}
                className="absolute -translate-x-1/2"
                style={{ left: `${tick.x}%` }}
              >
                {tick.label}
              </span>
            ))}
          </div>
        </div>
      </div>

      {!hasMovement && !loading && (
        <p className="mt-5 text-xs leading-relaxed text-muted-foreground">
          {hasHistory
            ? "No portfolio-value change between recorded snapshots yet. Daily IDX EOD valuations will extend the history when your holdings move."
            : "Your starting value is shown as a baseline. Daily IDX EOD valuations will build the history from here."}
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
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M12 19V5" />
      <path d="m5 12 7-7 7 7" />
    </svg>
  );
}

function ArrowDownIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M12 5v14" />
      <path d="m5 12 7 7 7-7" />
    </svg>
  );
}
