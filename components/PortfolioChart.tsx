"use client";

import { useEffect, useLayoutEffect, useMemo, useRef, useState } from "react";
import { gsap } from "gsap";
import { ContextualHelp } from "@/components/ContextualHelp";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import {
  formatRupiah,
  formatRupiahChange,
  getChangeTone,
} from "@/lib/formatters/rupiah";
import {
  getPortfolioValueHistory,
  type PortfolioHistoryRange,
  type PortfolioValueSnapshot,
} from "@/lib/trading/client";

const RANGES: PortfolioHistoryRange[] = ["1D", "1M", "1Y", "All"];
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

function formatDate(date: string) {
  return new Date(`${date}T00:00:00`).toLocaleDateString("id-ID", {
    day: "numeric",
    month: "short",
  });
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

export default function PortfolioChart({
  userId,
  totalValue,
  onRangeChange,
}: {
  userId: string;
  totalValue: number;
  onRangeChange?: (range: PortfolioHistoryRange) => void;
}) {
  const { t } = useLocale();
  const [range, setRange] = useState<PortfolioHistoryRange>("1M");
  const [points, setPoints] = useState<PortfolioValueSnapshot[]>([]);
  const [loading, setLoading] = useState(true);
  const [hoverIndex, setHoverIndex] = useState<number | null>(null);
  const svgRef = useRef<SVGSVGElement>(null);
  const visualRef = useRef<SVGGElement>(null);

  useEffect(() => {
    let active = true;
    getPortfolioValueHistory(userId, range)
      .then((history) => {
        if (active) setPoints(history);
      })
      .catch(() => {
        if (active) setPoints([]);
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [range, totalValue, userId]);

  const today = new Date().toISOString().slice(0, 10);
  const displayPoints = useMemo<PortfolioValueSnapshot[]>(() => {
    if (points.length === 0) {
      return [
        {
          date: today,
          cashBalance: totalValue,
          holdingsValue: 0,
          totalValue,
        },
      ];
    }
    const last = points.at(-1)!;
    if (last.date !== today && Math.abs(totalValue - last.totalValue) >= 1) {
      return [
        ...points,
        {
          date: today,
          cashBalance: last.cashBalance,
          holdingsValue: Math.max(totalValue - last.cashBalance, 0),
          totalValue,
        },
      ];
    }
    return points;
  }, [points, totalValue, today]);

  const chartTotalValue = displayPoints.at(-1)?.totalValue ?? totalValue;
  const chart = useMemo(() => createChartShape(displayPoints), [displayPoints]);
  const firstValue = displayPoints[0]?.totalValue ?? totalValue;
  const change = chartTotalValue - firstValue;
  const hasHistory = displayPoints.length > 1;
  const hasMovement = useMemo(
    () =>
      displayPoints.some(
        (point) => Math.abs(point.totalValue - firstValue) >= 1,
      ),
    [displayPoints, firstValue],
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
    if (!svgRef.current || displayPoints.length < 2) return;
    const rect = svgRef.current.getBoundingClientRect();
    const ratio = Math.min(
      Math.max((event.clientX - rect.left) / rect.width, 0),
      1,
    );
    const index = Math.round(ratio * (displayPoints.length - 1));
    setHoverIndex(index);
  };

  const handleMouseLeave = () => setHoverIndex(null);

  const activePoint =
    hoverIndex !== null ? displayPoints[hoverIndex] : null;
  const activeCoord =
    hoverIndex !== null ? chart.coords[hoverIndex] : null;

  const firstDate = formatDate(
    displayPoints[0]?.date ?? new Date().toISOString().slice(0, 10),
  );
  const lastDate = formatDate(
    displayPoints.at(-1)?.date ?? new Date().toISOString().slice(0, 10),
  );

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
          <p className="mt-3 text-2xl font-bold tracking-tight text-foreground">
            {formatRupiah(chartTotalValue)}
          </p>
          <p
            className={`mt-1 text-sm font-semibold ${getChangeTone(change) === "positive" ? "text-success" : getChangeTone(change) === "negative" ? "text-danger" : "text-muted-foreground"}`}
          >
            {formatRupiahChange(change)} {range === "1D" ? "today" : `over ${range}`}
          </p>
        </div>
        <div
          className="flex rounded-xl bg-muted p-1"
          role="tablist"
          aria-label="Portfolio chart range"
        >
          {RANGES.map((item) => (
            <button
              key={item}
              type="button"
              role="tab"
              aria-selected={range === item}
              onClick={() => {
                setRange(item);
                onRangeChange?.(item);
              }}
              className={`min-h-10 rounded-lg px-3 text-xs font-bold transition-colors duration-150 ${range === item ? "bg-surface text-primary shadow-sm" : "text-muted-foreground hover:text-foreground"}`}
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
                        stroke="var(--color-primary)"
                        strokeOpacity={0.35}
                        strokeWidth={0.5}
                        strokeDasharray="2 2"
                        vectorEffect="non-scaling-stroke"
                      />
                      <circle
                        cx={activeCoord.x}
                        cy={activeCoord.y}
                        r="1.25"
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
                  className="pointer-events-none absolute z-10 min-w-[8.5rem] -translate-x-1/2 -translate-y-[115%] rounded-xl border border-muted/60 bg-surface p-2.5 shadow-md"
                  style={{
                    left: `${activeCoord.x}%`,
                    top: `${activeCoord.y}%`,
                  }}
                >
                  <p className="text-[11px] font-medium text-muted-foreground">
                    {formatDate(activePoint.date)}
                  </p>
                  <p className="text-sm font-bold text-foreground">
                    {formatRupiah(activePoint.totalValue)}
                  </p>
                  <p
                    className={`text-xs font-semibold ${
                      getChangeTone(activePoint.totalValue - firstValue) ===
                      "positive"
                        ? "text-success"
                        : getChangeTone(activePoint.totalValue - firstValue) ===
                            "negative"
                          ? "text-danger"
                          : "text-muted-foreground"
                    }`}
                  >
                    {formatPercentChange(
                      activePoint.totalValue - firstValue,
                      firstValue,
                    )}{" "}
                    {t("portfolioStory.tooltipFromStart")}
                  </p>
                  <p className="mt-1 text-[10px] leading-snug text-muted-foreground">
                    {t("portfolioStory.tooltipDisclosure")}
                  </p>
                </div>
              )}
            </>
          )}
          <div className="mt-2 grid grid-cols-3 text-[11px] font-medium text-muted-foreground">
            <span>{firstDate}</span>
            <span className="text-center">
              {hasHistory ? "Portfolio value" : "Starting value"}
            </span>
            <span className="text-right">{hasHistory ? lastDate : "Now"}</span>
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
