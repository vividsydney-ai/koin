"use client";

import { useLocale } from "@/lib/i18n/LocaleProvider";

export type ChartDataSource = "simulated" | "idx_eod";

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
