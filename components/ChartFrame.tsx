"use client";

import { useEffect, useMemo, useState } from "react";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { formatRupiah } from "@/lib/formatters/rupiah";
import PortfolioChart from "@/components/PortfolioChart";
import { type ChartDataSource } from "@/components/SourceBadge";
import {
  getPortfolioValueHistory,
  type PortfolioHistoryRange,
  type PortfolioValueSnapshot,
} from "@/lib/trading/client";

const INSIGHT_OVER_RANGE_KEY: Record<PortfolioHistoryRange, string> = {
  "1M": "portfolioStory.insightOverMonth",
  "3M": "portfolioStory.insightOver3M",
  "6M": "portfolioStory.insightOver6M",
  All: "portfolioStory.insightOverAll",
};

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

function AgentActionCard({
  snapshots,
  dataSource,
}: {
  snapshots: PortfolioValueSnapshot[];
  dataSource: ChartDataSource;
}) {
  const { t } = useLocale();
  const [open, setOpen] = useState(false);
  const first = snapshots[0]?.totalValue;
  const last = snapshots.at(-1)?.totalValue;
  const change = first !== undefined && last !== undefined ? last - first : 0;

  return (
    <div className="rounded-xl border border-muted/60 bg-muted/30 p-3">
      <button
        type="button"
        onClick={() => setOpen((prev) => !prev)}
        className="flex min-h-11 w-full items-center justify-between gap-3 text-sm font-semibold text-foreground"
        aria-expanded={open}
      >
        <span className="inline-flex items-center gap-2">
          <SparkleIcon className="h-4 w-4 text-primary" />
          {t("portfolioStory.explainChange")}
        </span>
        <span aria-hidden="true">{open ? "−" : "+"}</span>
      </button>
      {open && (
        <div className="mt-2 space-y-2 border-t border-muted/60 pt-3 text-sm text-muted-foreground">
          <p>{t("portfolioStory.agentBody")}</p>
          <ul className="space-y-1">
            <li>
              <span className="font-medium text-foreground">{t("home.portfolio")}:</span>{" "}
              {last !== undefined ? formatRupiah(last) : "—"}
            </li>
            <li>
              <span className="font-medium text-foreground">
                {change >= 0 ? t("portfolioStory.insightRoseBy") : t("portfolioStory.insightFellBy")}:
              </span>{" "}
              {formatRupiah(Math.abs(change))}
            </li>
            <li>
              <span className="font-medium text-foreground">{t("trade.dataSource")}:</span>{" "}
              {dataSource === "simulated" ? t("trade.simulated") : t("trade.idxEod")}
            </li>
          </ul>
        </div>
      )}
    </div>
  );
}

function SparkleIcon({ className = "h-5 w-5" }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 2 14.5 9.5H22l-6 4.5 2.5 7.5-6.5-5-6.5 5 2.5-7.5-6-4.5h7.5z" />
    </svg>
  );
}

export default function ChartFrame({
  userId,
  dataSource,
}: {
  userId: string;
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
      <h2 className="sr-only">{t("portfolioStory.title")}</h2>

      <PortfolioChart
        snapshots={snapshots ?? []}
        range={range}
        dataSource={dataSource}
        onRangeChange={setRange}
        loading={status === "loading" && snapshots === null}
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
          <AgentActionCard snapshots={snapshots} dataSource={dataSource} />
        </>
      )}

      <p className="text-xs leading-relaxed text-muted-foreground">
        {t("portfolioStory.disclosure")}
      </p>
    </section>
  );
}
