"use client";

import { CandlestickChart } from "./CandlestickChart";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import type { Candlestick } from "@/lib/lessons/question";

const VISUALS: Record<string, Candlestick[]> = {
  "chart-ohcl-basics": [
    { open: 100, high: 116, low: 94, close: 109, label: "OHLC" },
  ],
  "chart-body-and-wick": [
    { open: 102, high: 121, low: 91, close: 114, label: "Body + wicks" },
  ],
  "chart-bullish-bearish-doji": [
    { open: 100, high: 114, low: 97, close: 110, label: "Up" },
    { open: 110, high: 114, low: 96, close: 100, label: "Down" },
    { open: 104, high: 112, low: 97, close: 104, label: "Doji" },
  ],
  "chart-long-wick-rejection": [
    { open: 102, high: 129, low: 99, close: 105, label: "Long upper wick" },
  ],
  "chart-hammer-shooting-star": [
    { open: 105, high: 111, low: 82, close: 109, label: "Hammer" },
    { open: 109, high: 132, low: 104, close: 106, label: "Shooting star" },
  ],
  "chart-support-resistance": [
    { open: 102, high: 110, low: 96, close: 108, label: "Zone" },
    { open: 108, high: 114, low: 101, close: 104, label: "Reaction" },
  ],
  "chart-trend-and-timeframe": [
    { open: 98, high: 108, low: 95, close: 105, label: "1" },
    { open: 105, high: 116, low: 101, close: 112, label: "2" },
    { open: 112, high: 122, low: 108, close: 119, label: "3" },
  ],
  "decision-multicandle-context": [
    { open: 104, high: 109, low: 96, close: 100, label: "1" },
    { open: 100, high: 105, low: 92, close: 97, label: "2" },
    { open: 97, high: 108, low: 94, close: 105, label: "3" },
  ],
  "decision-volume-confirmation": [
    { open: 98, high: 105, low: 94, close: 103, label: "Observe" },
    { open: 103, high: 111, low: 99, close: 106, label: "Confirm" },
  ],
};

const FALLBACK: Candlestick[] = [
  { open: 100, high: 111, low: 95, close: 106, label: "Context" },
  { open: 106, high: 115, low: 101, close: 109, label: "Plan" },
  { open: 109, high: 118, low: 103, close: 105, label: "Review" },
];

export function LessonChartVisual({ slug, advanced }: { slug: string; advanced: boolean }) {
  const { locale } = useLocale();
  const isIndonesian = locale === "id";
  return (
    <div className="mt-4">
      <CandlestickChart
        candles={VISUALS[slug] ?? FALLBACK}
        label={isIndonesian ? "Grafik pembelajaran candlestick" : "Instructional candlestick chart"}
        caption={isIndonesian ? "Contoh visual untuk belajar — bukan sinyal atau prediksi harga." : "A visual learning example — not a price signal or forecast."}
        accent={advanced ? "advanced" : "core"}
      />
    </div>
  );
}
