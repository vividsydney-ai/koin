"use client";

import { useEffect, useLayoutEffect, useMemo, useRef, useState } from "react";
import { gsap } from "gsap";
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
  // SVG does not paint a path made from one move command. A newly unlocked
  // portfolio has one authoritative snapshot, so draw that value as a visible
  // flat line across the chart until another daily point exists.
  if (coords.length === 1) {
    const y = coords[0][1];
    return {
      line: `M0,${y} L${width},${y}`,
      area: `M0,${y} L${width},${y} L${width},${height} L0,${height} Z`,
    };
  }
  const line = coords.map(([x, y], index) => `${index === 0 ? "M" : "L"}${x},${y}`).join(" ");
  const area = `${line} L${coords.at(-1)?.[0] ?? width},${height} L${coords[0]?.[0] ?? 0},${height} Z`;
  return { line, area };
}

export default function PortfolioChart({ userId, totalValue }: { userId: string; totalValue: number }) {
  const [range, setRange] = useState<PortfolioHistoryRange>("1M");
  const [points, setPoints] = useState<PortfolioValueSnapshot[]>([]);
  const [loading, setLoading] = useState(true);
  const visualRef = useRef<SVGGElement>(null);

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
  const hasMovementHistory = points.length > 1;

  useLayoutEffect(() => {
    if (!visualRef.current || loading) return;

    const media = gsap.matchMedia();
    media.add("(prefers-reduced-motion: no-preference)", () => {
      gsap.fromTo(
        visualRef.current,
        { autoAlpha: 0.45, scaleX: 0.985, transformOrigin: "50% 50%" },
        { autoAlpha: 1, scaleX: 1, duration: 0.22, ease: "power3.out", overwrite: "auto" }
      );
    });
    return () => media.revert();
  }, [hasMovementHistory, loading, path.line, range]);

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
          <svg viewBox="0 0 100 60" preserveAspectRatio="none" className="h-full w-full motion-safe:transition-opacity motion-safe:duration-200" role="img" aria-label={`${range} portfolio value chart`}>
            <path d="M0,54 H100" stroke="var(--border)" strokeWidth="0.45" />
            <g ref={visualRef}>
              {hasMovementHistory && <path d={path.area} fill="var(--primary)" fillOpacity="0.08" />}
              <path d={path.line} fill="none" stroke="var(--primary)" strokeOpacity={hasMovementHistory ? "1" : "0.58"} strokeLinecap="round" strokeLinejoin="round" strokeWidth={hasMovementHistory ? "1.5" : "1"} vectorEffect="non-scaling-stroke" />
              {!hasMovementHistory && <circle cx="5" cy="46" r="1.6" fill="var(--surface)" stroke="var(--primary)" strokeWidth="0.8" vectorEffect="non-scaling-stroke" />}
            </g>
          </svg>
        )}
      </div>

      <div className="mt-2 flex items-center justify-between text-xs text-muted-foreground">
        <span>{displayPoints[0] ? new Date(`${displayPoints[0].date}T00:00:00`).toLocaleDateString("id-ID", { day: "numeric", month: "short" }) : "—"}</span>
        <span>{hasMovementHistory ? `${points.length} daily snapshots` : "Starting value"}</span>
        <span>{formatCompact(totalValue)}</span>
      </div>
      {points.length < 2 && !loading && (
        <p className="mt-3 text-xs leading-relaxed text-muted-foreground">Your starting value is recorded. Daily IDX EOD valuations will extend this line as the market moves.</p>
      )}
    </section>
  );
}
