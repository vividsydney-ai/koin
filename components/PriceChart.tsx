"use client";

import { useEffect, useMemo, useState } from "react";
import { getMarketDataHistory, type MarketDataPoint } from "@/lib/trading/client";
import { useLocale } from "@/lib/i18n/LocaleProvider";

export interface Candle {
  date: string;
  open: number;
  high: number;
  low: number;
  close: number;
  isSimulated: boolean;
}

/**
 * Synthesize OHLC candles from daily closes: open = prior close (first day
 * opens at its own close), high/low span the open–close range. Intraday
 * detail doesn't exist for this dataset; the wick marks the day-over-day move.
 */
export function buildCandles(points: MarketDataPoint[]): Candle[] {
  return points.map((point, index) => {
    const open = index === 0 ? point.close : points[index - 1].close;
    return {
      date: point.date,
      open,
      high: Math.max(open, point.close),
      low: Math.min(open, point.close),
      close: point.close,
      isSimulated: point.isSimulated,
    };
  });
}

const CHART_WIDTH = 280;
const CHART_HEIGHT = 120;

function buildCandleGeometry(candles: Candle[]) {
  const max = Math.max(...candles.map((c) => c.high));
  const min = Math.min(...candles.map((c) => c.low));
  const pad = (max - min) * 0.1 || max * 0.01 || 1;
  const scaleMax = max + pad;
  const scaleMin = min - pad;
  const range = scaleMax - scaleMin;
  const slot = CHART_WIDTH / candles.length;
  const bodyWidth = slot * 0.56;
  const scaleY = (value: number) =>
    CHART_HEIGHT - ((value - scaleMin) / range) * CHART_HEIGHT;

  return candles.map((candle, index) => {
    const center = slot * index + slot / 2;
    const isUp = candle.close >= candle.open;
    const bodyTop = scaleY(Math.max(candle.open, candle.close));
    const bodyBottom = scaleY(Math.min(candle.open, candle.close));
    return {
      center,
      wickTop: scaleY(candle.high),
      wickBottom: scaleY(candle.low),
      bodyTop,
      bodyHeight: Math.max(bodyBottom - bodyTop, 2),
      bodyLeft: center - bodyWidth / 2,
      bodyWidth,
      isUp,
    };
  });
}

export default function PriceChart({
  symbol,
  companyName,
}: {
  symbol: string;
  companyName?: string | null;
}) {
  const { t } = useLocale();
  const [result, setResult] = useState<{
    symbol: string;
    points: MarketDataPoint[];
  } | null>(null);

  useEffect(() => {
    if (!symbol) return;
    let cancelled = false;
    getMarketDataHistory(symbol).then((points) => {
      if (!cancelled) setResult({ symbol, points });
    });
    return () => {
      cancelled = true;
    };
  }, [symbol]);

  const loading = Boolean(symbol) && result?.symbol !== symbol;
  const series = useMemo(
    () => (result?.symbol === symbol ? result.points : []),
    [result, symbol]
  );

  const candles = useMemo(() => buildCandles(series), [series]);
  const geometry = useMemo(
    () => (candles.length > 0 ? buildCandleGeometry(candles) : []),
    [candles]
  );

  const latest = candles.at(-1);
  const prior = candles.length > 1 ? candles[candles.length - 2] : undefined;
  const changePct =
    latest && prior && prior.close > 0
      ? ((latest.close - prior.close) / prior.close) * 100
      : 0;
  const positive = changePct >= 0;
  const hasSimulated = candles.some((c) => c.isSimulated);

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            Price chart
          </p>
          <p className="mt-1 text-lg font-bold text-foreground">
            {symbol || "—"}
            {companyName && (
              <span className="ml-2 text-xs font-medium text-muted-foreground">
                {companyName}
              </span>
            )}
          </p>
        </div>
        {latest && (
          <div className="text-right">
            <p className="text-sm font-semibold text-foreground">
              Rp {latest.close.toLocaleString("id-ID")}
            </p>
            <p
              className={`text-xs font-medium ${positive ? "text-success" : "text-danger"}`}
            >
              {positive ? "+" : ""}
              {changePct.toFixed(2)}%
            </p>
          </div>
        )}
      </div>

      {loading ? (
        <div className="mt-3 h-32 animate-pulse rounded-radius-md bg-muted" />
      ) : candles.length === 0 ? (
        <div className="mt-3 flex h-32 items-center justify-center rounded-radius-md bg-muted">
          <p className="text-xs text-muted-foreground">
            No price history yet for {symbol || "this stock"}.
          </p>
        </div>
      ) : (
        <>
          <svg
            viewBox={`0 0 ${CHART_WIDTH} ${CHART_HEIGHT}`}
            preserveAspectRatio="none"
            className="mt-3 h-32 w-full"
            role="img"
            aria-label={`${symbol} daily price chart, last ${candles.length} days, ${positive ? "up" : "down"} ${Math.abs(changePct).toFixed(2)}% versus prior day`}
          >
            {geometry.map((candle, index) => {
              const color = candle.isUp
                ? "var(--color-success)"
                : "var(--color-danger)";
              return (
                <g key={candles[index].date}>
                  <line
                    x1={candle.center}
                    x2={candle.center}
                    y1={candle.wickTop}
                    y2={candle.wickBottom}
                    stroke={color}
                    strokeWidth={1.5}
                  />
                  <rect
                    x={candle.bodyLeft}
                    y={candle.bodyTop}
                    width={candle.bodyWidth}
                    height={candle.bodyHeight}
                    fill={color}
                    rx={1}
                  />
                </g>
              );
            })}
          </svg>
          <div className="mt-1 flex items-center justify-between text-[10px] text-muted-foreground">
            <span>{new Date(candles[0].date).toLocaleDateString("id-ID")}</span>
            <span>{candles.length} days</span>
            <span>
              {new Date(candles[candles.length - 1].date).toLocaleDateString("id-ID")}
            </span>
          </div>
          {hasSimulated && (
            <p className="mt-2 rounded-radius-md border border-warning/20 bg-warning/5 px-3 py-2 text-xs leading-relaxed text-muted-foreground">
              <span className="font-semibold text-foreground">{t("trade.simulatedPrices")}</span> —{" "}
              {t("trade.simulatedBody")}
            </p>
          )}
        </>
      )}
    </div>
  );
}
