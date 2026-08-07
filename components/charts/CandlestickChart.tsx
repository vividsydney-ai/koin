"use client";

import { useEffect, useRef } from "react";
import { gsap } from "gsap";
import type { Candlestick } from "@/lib/lessons/question";

export interface ChartMarker {
  number: number;
  candleIndex: number;
  position: "high" | "low" | "open" | "close" | "bodyTop" | "bodyBottom" | "bodyCenter";
  side?: "left" | "right";
}

export interface CandlestickChartProps {
  candles: Candlestick[];
  label: string;
  caption?: string;
  compact?: boolean;
  accent?: "core" | "advanced";
  animate?: boolean;
  markers?: ChartMarker[];
  showPriceScale?: boolean;
  priceScale?: number[];
}

function formatNumber(value: number) {
  return new Intl.NumberFormat("en-US", { maximumFractionDigits: 0 }).format(value);
}

/**
 * A deterministic, instructional SVG chart—not market data or a prediction.
 * It is shared by explanations and chart_interpretation quiz options.
 */
export function CandlestickChart({
  candles,
  label,
  caption,
  compact = false,
  accent = "core",
  animate = true,
  markers,
  showPriceScale = false,
  priceScale,
}: CandlestickChartProps) {
  const rootRef = useRef<HTMLDivElement>(null);
  const width = compact ? 210 : 420;
  const height = compact ? 132 : 230;
  const basePadding = compact ? { top: 16, right: 12, bottom: 22, left: 12 } : { top: 24, right: 22, bottom: 34, left: 34 };
  const padding = {
    ...basePadding,
    left: showPriceScale && !compact ? Math.max(basePadding.left, 52) : basePadding.left,
  };
  const values = candles.flatMap((candle) => [candle.low, candle.high]);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const range = Math.max(1, max - min);
  const plotHeight = height - padding.top - padding.bottom;
  const plotWidth = width - padding.left - padding.right;
  const step = plotWidth / Math.max(1, candles.length);
  const bodyWidth = Math.min(compact ? 18 : 26, step * 0.52);
  const y = (value: number) => padding.top + ((max - value) / range) * plotHeight;
  const chartAccent = accent === "advanced" ? "var(--color-secondary)" : "var(--color-primary)";

  useEffect(() => {
    if (!animate || !rootRef.current) return;
    const context = gsap.context(() => {
      const media = gsap.matchMedia();
      media.add({ reduceMotion: "(prefers-reduced-motion: reduce)" }, (ctx) => {
        const reduceMotion = Boolean(ctx.conditions?.reduceMotion);
        gsap.fromTo(
          ".candle-mark",
          { autoAlpha: 0, scaleY: 0.35, transformOrigin: "50% 100%" },
          { autoAlpha: 1, scaleY: 1, duration: reduceMotion ? 0 : 0.38, ease: "power2.out", stagger: reduceMotion ? 0 : 0.055 }
        );
      });
      return () => media.revert();
    }, rootRef);
    return () => context.revert();
  }, [animate, candles]);

  const markerRadius = compact ? 8 : 10;
  const markerOffset = compact ? 10 : 14;

  function getMarkerCoordinates(marker: ChartMarker): { x: number; y: number } | null {
    const candle = candles[marker.candleIndex];
    if (!candle) return null;
    const cx = padding.left + step * marker.candleIndex + step / 2;
    const side = marker.side ?? "right";
    let py: number;
    switch (marker.position) {
      case "high":
        py = y(candle.high);
        break;
      case "low":
        py = y(candle.low);
        break;
      case "open":
        py = y(candle.open);
        break;
      case "close":
        py = y(candle.close);
        break;
      case "bodyTop":
        py = y(Math.max(candle.open, candle.close));
        break;
      case "bodyBottom":
        py = y(Math.min(candle.open, candle.close));
        break;
      case "bodyCenter":
        py = (y(Math.max(candle.open, candle.close)) + y(Math.min(candle.open, candle.close))) / 2;
        break;
      default:
        return null;
    }
    const mx = side === "left" ? cx - bodyWidth / 2 - markerOffset : cx + bodyWidth / 2 + markerOffset;
    return { x: mx, y: py };
  }

  const textualSummary = candles
    .map((candle, index) => {
      const direction = candle.close > candle.open ? "up" : candle.close < candle.open ? "down" : "flat";
      return `${candle.label ?? `Candle ${index + 1}`}: opened ${formatNumber(candle.open)}, high ${formatNumber(candle.high)}, low ${formatNumber(candle.low)}, closed ${formatNumber(candle.close)} (${direction}).`;
    })
    .join(" ");

  const rawPriceLevels = showPriceScale && !compact
    ? Array.from(
        candles.reduce((set, candle) => {
          set.add(candle.open).add(candle.high).add(candle.low).add(candle.close);
          (priceScale ?? []).forEach((value) => set.add(value));
          return set;
        }, new Set<number>())
      ).sort((a, b) => a - b)
    : [];

  const minLabelSpacing = 14;
  const priceLevels: { price: number; y: number; offset: number }[] = [];
  for (const price of rawPriceLevels) {
    const py = y(price);
    const last = priceLevels[priceLevels.length - 1];
    const offset = last && Math.abs(py - last.y) < minLabelSpacing ? -last.offset : 0;
    priceLevels.push({ price, y: py, offset });
  }

  return (
    <div ref={rootRef} className="overflow-hidden rounded-md border border-muted/70 bg-surface p-2" role="figure" aria-label={label}>
      <svg viewBox={`0 0 ${width} ${height}`} className="h-auto w-full" role="img" aria-label={`${label}. ${textualSummary}`}>
        <rect x="0" y="0" width={width} height={height} rx="10" fill="var(--color-surface-raised)" />
        {[0.25, 0.5, 0.75].map((position) => (
          <line key={position} x1={padding.left} x2={width - padding.right} y1={padding.top + plotHeight * position} y2={padding.top + plotHeight * position} stroke="var(--color-muted)" strokeWidth="1" strokeDasharray="3 4" />
        ))}
        {priceLevels.map(({ price, y: py, offset }) => {
          const lineOpacity = Math.abs(price - Math.round(price)) < 0.001 ? 0.45 : 0.25;
          return (
            <g key={`price-${price}`}>
              <line
                x1={padding.left}
                x2={width - padding.right}
                y1={py}
                y2={py}
                stroke="var(--color-muted-foreground)"
                strokeWidth="1"
                strokeDasharray="2 3"
                opacity={lineOpacity}
              />
              <line x1={padding.left - 5} x2={padding.left} y1={py} y2={py} stroke="var(--color-muted-foreground)" strokeWidth="1" />
              <text
                x={padding.left - 9}
                y={py}
                dy={offset === 0 ? "0.35em" : offset > 0 ? "0.85em" : "-0.15em"}
                textAnchor="end"
                fill="var(--color-muted-foreground)"
                fontSize="10"
                fontWeight="500"
              >
                {formatNumber(price)}
              </text>
            </g>
          );
        })}
        {candles.map((candle, index) => {
          const x = padding.left + step * index + step / 2;
          const positive = candle.close >= candle.open;
          const fill = positive ? "var(--color-success)" : "var(--color-danger)";
          const bodyTop = y(Math.max(candle.open, candle.close));
          const bodyBottom = y(Math.min(candle.open, candle.close));
          return (
            <g key={`${candle.label ?? "candle"}-${index}`} className="candle-mark">
              <line x1={x} x2={x} y1={y(candle.high)} y2={y(candle.low)} stroke={fill} strokeWidth={compact ? 2 : 3} strokeLinecap="round" />
              <rect x={x - bodyWidth / 2} y={bodyTop} width={bodyWidth} height={Math.max(3, bodyBottom - bodyTop)} rx="2" fill={fill} />
              {!compact && <text x={x} y={height - 12} textAnchor="middle" fill="var(--color-muted-foreground)" fontSize="10">{candle.label ?? index + 1}</text>}
            </g>
          );
        })}
        {markers?.map((marker) => {
          const coords = getMarkerCoordinates(marker);
          if (!coords) return null;
          return (
            <g key={`marker-${marker.number}`} className="candle-marker">
              <circle cx={coords.x} cy={coords.y} r={markerRadius} fill={chartAccent} />
              <text x={coords.x} y={coords.y} dy="0.35em" textAnchor="middle" fill="white" fontSize={compact ? 9 : 11} fontWeight="bold">{marker.number}</text>
            </g>
          );
        })}
        {!compact && <path d={`M ${padding.left} ${height - padding.bottom + 0.5} H ${width - padding.right}`} stroke={chartAccent} strokeWidth="1.5" opacity="0.65" />}
      </svg>
      {caption && <p className="px-1 pt-1 text-xs leading-5 text-muted-foreground">{caption}</p>}
    </div>
  );
}
