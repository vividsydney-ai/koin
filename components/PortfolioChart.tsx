"use client";

import { useEffect, useMemo, useState } from "react";
import {
  getPortfolioValueHistory,
  type PortfolioHistoryRange,
  type PortfolioValueSnapshot,
} from "@/lib/trading/client";

const RANGES: PortfolioHistoryRange[] = ["1D", "1M", "1Y", "All"];
const rupiah = new Intl.NumberFormat("id-ID", {
  style: "currency",
  currency: "IDR",
  maximumFractionDigits: 0,
});

function formatCompact(value: number) {
  return new Intl.NumberFormat("id-ID", {
    notation: "compact",
    maximumFractionDigits: 1,
  }).format(value);
}

function chartPath(points: PortfolioValueSnapshot[]) {
  if (points.length === 0) return { line: "", area: "" };
  const values = points.map((point) => point.totalValue);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const spread = Math.max(max - min, Math.max(max * 0.015, 1));
  const width = 100;
  const height = 52;
  const coords = points.map((point, index) => {
    const x = points.length === 1 ? width / 2 : (index / (points.length - 1)) * width;
    const y = height - ((point.totalValue - min + spread * 0.15) / (spread * 1.3)) * height;
    return [x, Math.max(4, Math.min(height - 4, y))] as const;
  });
  const line = coords.map(([x, y], index) => `${index === 0 ? "M" : "L"}${x},${y}`).join(" ");
  const area = `${line} L${coords.at(-1)?.[0] ?? width},${height} L${coords[0]?.[0] ?? 0},${height} Z`;
  return { line, area };
}

export default function PortfolioChart({ userId, totalValue }: { userId: string; totalValue: number }) {
  const [range, setRange] = useState<PortfolioHistoryRange>("1M");
  const [points, setPoints] = useState<PortfolioValueSnapshot[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    getPortfolioValueHistory(userId, range)
      .then((history) => {
        if (active) setPoints(history);
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, [range, userId, totalValue]);

  const displayPoints = useMemo(() => {
    if (points.length > 0) return points;
    return [{ date: new Date().toISOString().slice(0, 10), cashBalance: totalValue, holdingsValue: 0, totalValue }];
  }, [points, totalValue]);
  const path = useMemo(() => chartPath(displayPoints), [displayPoints]);
  const first = displayPoints[0]?.totalValue ?? totalValue;
  const change = totalValue - first;
  const isPositive = change >= 0;

  return (
    <section className="rounded-[18px] border border-muted/60 bg-surface p-4 shadow-sm sm:p-5" aria-label="Your portfolio performance">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">Your portfolio</p>
          <p className="mt-1 text-2xl font-bold tracking-tight text-foreground">{rupiah.format(totalValue)}</p>
          <p className={`mt-1 text-xs font-semibold ${isPositive ? "text-success" : "text-danger"}`}>
            {isPositive ? "+" : ""}{rupiah.format(change)} {range === "1D" ? "today" : `over ${range}`}
          </p>
        </div>
        <div className="flex rounded-xl bg-muted p-1" role="tablist" aria-label="Portfolio chart range">
          {RANGES.map((item) => (
            <button
              key={item}
              type="button"
              role="tab"
              aria-selected={range === item}
              onClick={() => setRange(item)}
              className={`min-h-11 rounded-lg px-3 text-xs font-bold transition ${range === item ? "bg-surface text-primary shadow-sm" : "text-muted-foreground hover:text-foreground"}`}
            >
              {item}
            </button>
          ))}
        </div>
      </div>

      <div className="mt-5 h-52" aria-live="polite">
        {loading ? (
          <div className="h-full animate-pulse rounded-xl bg-muted" />
        ) : (
          <svg viewBox="0 0 100 60" preserveAspectRatio="none" className="h-full w-full" role="img" aria-label={`${range} portfolio value chart`}>
            <defs>
              <linearGradient id="portfolio-area" x1="0" x2="0" y1="0" y2="1">
                <stop offset="0%" stopColor="var(--primary)" stopOpacity="0.28" />
                <stop offset="100%" stopColor="var(--primary)" stopOpacity="0.02" />
              </linearGradient>
            </defs>
            <path d="M0,54 H100" stroke="var(--border)" strokeWidth="0.45" />
            <path d={path.area} fill="url(#portfolio-area)" />
            <path d={path.line} fill="none" stroke="var(--primary)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" vectorEffect="non-scaling-stroke" />
          </svg>
        )}
      </div>

      <div className="mt-2 flex items-center justify-between text-xs text-muted-foreground">
        <span>{displayPoints[0] ? new Date(`${displayPoints[0].date}T00:00:00`).toLocaleDateString("id-ID", { day: "numeric", month: "short" }) : "—"}</span>
        <span>{points.length > 1 ? `${points.length} daily snapshots` : "First snapshot recorded"}</span>
        <span>{formatCompact(totalValue)}</span>
      </div>
      {points.length < 2 && !loading && (
        <p className="mt-3 text-xs leading-relaxed text-muted-foreground">The chart will gain detail as daily EOD valuations are recorded. No trend is invented before then.</p>
      )}
    </section>
  );
}
