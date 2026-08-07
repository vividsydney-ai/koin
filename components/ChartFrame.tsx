"use client";

import { useEffect, useMemo, useState } from "react";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { formatRupiah } from "@/lib/formatters/rupiah";
import PortfolioChart from "@/components/PortfolioChart";
import {
  getPortfolioValueHistory,
  type PortfolioHistoryRange,
  type PortfolioValueSnapshot,
} from "@/lib/trading/client";

export type ChartDataSource = "simulated" | "idx_eod";

const INSIGHT_OVER_RANGE_KEY: Record<PortfolioHistoryRange, string> = {
  "1D": "portfolioStory.insightOverDay",
  "1M": "portfolioStory.insightOverMonth",
  "1Y": "portfolioStory.insightOverYear",
  All: "portfolioStory.insightOverAll",
};

function formatChartDate(date: string) {
  return new Date(`${date}T00:00:00`).toLocaleDateString("id-ID", {
    day: "numeric",
    month: "short",
  });
}

export function SourceBadge({ dataSource }: { dataSource: ChartDataSource }) {
  const { t } = useLocale();
  const isSimulated = dataSource === "simulated";
  return (
    <span
      className={`inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[11px] font-semibold ${
        isSimulated ? "bg-warning/10 text-warning" : "bg-success/10 text-success"
      }`}
    >
      <span aria-hidden="true">{isSimulated ? "●" : "✓"}</span>
      {isSimulated ? t("trade.simulated") : t("trade.idxEod")}
    </span>
  );
}

export function InsightCard({
  snapshots,
  range,
}: {
  snapshots: PortfolioValueSnapshot[];
  range: PortfolioHistoryRange;
}) {
  const { t } = useLocale();
  const first = snapshots[0]?.totalValue;
  const last = snapshots.at(-1)?.totalValue;
  if (first === undefined || last === undefined) return null;

  const overRange = t(INSIGHT_OVER_RANGE_KEY[range]);
  const change = last - first;
  const isFlat = Math.abs(change) < 1;
  const sentence = isFlat
    ? `${t("portfolioStory.insightFlat")} ${overRange}`
    : `${change > 0 ? t("portfolioStory.insightRoseBy") : t("portfolioStory.insightFellBy")} ${formatRupiah(Math.abs(change))} ${overRange}`;

  return (
    <p className="text-sm font-medium text-foreground" data-testid="insight-card">
      {sentence}
    </p>
  );
}

export function ChartTooltip({
  snapshots,
}: {
  snapshots: PortfolioValueSnapshot[];
}) {
  const { t } = useLocale();
  const [activeIndex, setActiveIndex] = useState<number | null>(null);

  // Decimate to at most 8 focusable points so the row reflows to a single
  // column's width on a 393px phone without horizontal scrolling.
  const points = useMemo(() => {
    if (snapshots.length < 2) return [];
    const step = Math.max(1, Math.ceil(snapshots.length / 8));
    const decimated = snapshots.filter((_, index) => index % step === 0);
    const last = snapshots.at(-1)!;
    if (decimated.at(-1) !== last) decimated.push(last);
    return decimated;
  }, [snapshots]);

  if (points.length < 2) return null;

  const clear = (index: number) =>
    setActiveIndex((current) => (current === index ? null : current));
  const active = activeIndex !== null ? points[activeIndex] : null;
  const previous =
    activeIndex !== null && activeIndex > 0 ? points[activeIndex - 1] : null;
  const change = active && previous ? active.totalValue - previous.totalValue : null;

  return (
    <div>
      <div
        className="flex flex-wrap gap-1"
        role="group"
        aria-label={t("portfolioStory.tooltipLabel")}
      >
        {points.map((point, index) => (
          <button
            key={point.date}
            type="button"
            onFocus={() => setActiveIndex(index)}
            onMouseEnter={() => setActiveIndex(index)}
            onBlur={() => clear(index)}
            onMouseLeave={() => clear(index)}
            className="min-h-8 shrink-0 rounded-md px-2 text-[11px] font-medium text-muted-foreground hover:bg-muted focus-visible:bg-muted"
            aria-label={`${t("portfolioStory.tooltipLabel")} ${formatChartDate(point.date)}`}
          >
            {formatChartDate(point.date)}
          </button>
        ))}
      </div>
      <div aria-live="polite" className="min-h-5 text-xs text-muted-foreground">
        {active && (
          <span>
            {formatChartDate(active.date)} · {formatRupiah(active.totalValue)}
            {change !== null && (
              <>
                {" "}
                · {change >= 0 ? "+" : "-"}
                {formatRupiah(Math.abs(change))} ({t("portfolioStory.tooltipChange")})
              </>
            )}
          </span>
        )}
      </div>
    </div>
  );
}

export default function ChartFrame({
  userId,
  totalValue,
  dataSource,
}: {
  userId: string;
  totalValue: number;
  dataSource: ChartDataSource;
}) {
  const { t } = useLocale();
  const [snapshots, setSnapshots] = useState<PortfolioValueSnapshot[] | null>(null);
  const [status, setStatus] = useState<"loading" | "ready" | "error">("loading");
  const [attempt, setAttempt] = useState(0);
  // Mirrors the range PortfolioChart's tabs are on (via onRangeChange), so the
  // badge/insight/tooltip and screen-reader description stay in sync with
  // whichever period the learner is viewing. Closes the KO-336 follow-up.
  // "1M" matches PortfolioChart's own default range before any tab click.
  const [range, setRange] = useState<PortfolioHistoryRange>("1M");

  useEffect(() => {
    let active = true;
    // Deliberately not resetting status to "loading" here: `status` starts
    // "loading" for the first fetch, and staying "ready"/"error" through a
    // later range-triggered refetch is what keeps the previous insight
    // visible instead of flashing the loading text on every tab click.
    getPortfolioValueHistory(userId, range)
      .then((history) => {
        if (!active) return;
        setSnapshots(history);
        setStatus("ready");
      })
      .catch(() => {
        if (active) setStatus("error");
      });
    return () => {
      active = false;
    };
  }, [userId, attempt, range]);

  const description = useMemo(() => {
    if (!snapshots || snapshots.length === 0) return null;
    const first = snapshots[0].totalValue;
    const last = snapshots.at(-1)!.totalValue;
    const change = last - first;
    const shapeKey =
      Math.abs(change) < 1
        ? "portfolioStory.chartShapeFlat"
        : change > 0
          ? "portfolioStory.chartShapeRose"
          : "portfolioStory.chartShapeFell";
    return `${t(shapeKey)} ${formatRupiah(last)}.`;
  }, [snapshots, t]);

  return (
    <section className="space-y-3" aria-label={t("portfolioStory.title")}>
      <div className="flex items-center justify-between gap-3">
        <h2 className="sr-only">{t("portfolioStory.title")}</h2>
        <SourceBadge dataSource={dataSource} />
      </div>

      <PortfolioChart
        userId={userId}
        totalValue={totalValue}
        onRangeChange={setRange}
      />

      {description && (
        <p className="sr-only" role="status">
          {description}
        </p>
      )}

      {status === "loading" && snapshots === null && (
        <p className="text-xs text-muted-foreground">{t("portfolioStory.loading")}</p>
      )}

      {status === "error" && (
        <div className="rounded-xl border border-danger/30 bg-danger/5 p-3 text-xs text-danger">
          <p>{t("portfolioStory.errorTitle")}</p>
          <button
            type="button"
            onClick={() => setAttempt((n) => n + 1)}
            className="mt-1 min-h-8 font-semibold underline"
          >
            {t("portfolioStory.errorRetry")}
          </button>
        </div>
      )}

      {status !== "error" && snapshots !== null && snapshots.length === 0 && (
        <div className="rounded-xl border border-muted/60 bg-muted/40 p-3 text-xs text-muted-foreground">
          <p className="font-semibold text-foreground">
            {t("portfolioStory.emptyTitle")}
          </p>
          <p className="mt-0.5">{t("portfolioStory.emptyBody")}</p>
        </div>
      )}

      {status !== "error" && snapshots !== null && snapshots.length > 0 && (
        <>
          <InsightCard snapshots={snapshots} range={range} />
          <ChartTooltip snapshots={snapshots} />
        </>
      )}

      <p className="text-xs leading-relaxed text-muted-foreground">
        {t("portfolioStory.disclosure")}
      </p>
    </section>
  );
}
