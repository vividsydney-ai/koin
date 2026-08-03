"use client";

import { ContextualHelp } from "@/components/ContextualHelp";
import {
  formatRupiah,
  formatRupiahChange,
  getChangeTone,
  type ChangeTone,
} from "@/lib/formatters/rupiah";
import type { PortfolioValueSnapshot } from "@/lib/trading/client";

export function getDailyPortfolioChange(
  totalValue: number,
  history: PortfolioValueSnapshot[],
) {
  const previous = history.at(-2);
  return previous ? totalValue - previous.totalValue : null;
}

export function PortfolioBalances({
  totalValue,
  cashBalance,
  startingCash,
  history,
}: {
  totalValue: number;
  cashBalance: number;
  startingCash: number;
  history: PortfolioValueSnapshot[];
}) {
  const dailyChange = getDailyPortfolioChange(totalValue, history);
  const investedValue = Math.max(totalValue - cashBalance, 0);
  const dailyChangeTone = getChangeTone(dailyChange);

  return (
    <section
      aria-labelledby="balances-title"
      className="rounded-[18px] border border-muted/60 bg-surface p-5 shadow-sm sm:p-6"
    >
      <div className="flex items-center gap-3">
        <span
          className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/8 text-primary"
          aria-hidden="true"
        >
          <WalletIcon />
        </span>
        <h2
          id="balances-title"
          className="text-lg font-bold tracking-tight text-foreground"
        >
          Balances
        </h2>
      </div>
      <div className="mt-6 grid gap-6 sm:grid-cols-3 sm:gap-8">
        <BalanceMetric
          label="Buying power"
          value={formatRupiah(cashBalance)}
          detail="Virtual cash available to place orders"
          help="In Koinaku, buying power is your virtual cash. It goes down when you buy and back up when you sell."
        />
        <BalanceMetric
          label="Invested"
          value={formatRupiah(investedValue)}
          detail="Latest value of stocks and ETFs you own"
          help="This is what your current holdings are worth at the latest available end-of-day prices. It can rise or fall as those prices change."
        />
        <BalanceMetric
          label="Daily change"
          value={formatRupiahChange(dailyChange)}
          detail={
            dailyChange === null
              ? "First recorded day"
              : "Since the previous EOD valuation"
          }
          tone={dailyChangeTone}
          help="This compares your portfolio value with its previous end-of-day valuation. A trade can also change today’s recorded balance."
        />
      </div>
      <p className="mt-6 border-t border-muted/60 pt-4 text-xs text-muted-foreground">
        Your one-time paper grant started at {formatRupiah(startingCash)}. No
        real money is used.
      </p>
    </section>
  );
}

function BalanceMetric({
  label,
  value,
  detail,
  help,
  tone,
}: {
  label: string;
  value: string;
  detail: string;
  help: string;
  tone?: ChangeTone;
}) {
  return (
    <div>
      <div className="flex min-h-5 items-center gap-1">
        <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
          {label}
        </p>
        <ContextualHelp label={label} compact>
          {help}
        </ContextualHelp>
      </div>
      <p
        className={`mt-2 text-2xl font-bold tracking-tight ${tone === "positive" ? "text-success" : tone === "negative" ? "text-danger" : "text-foreground"}`}
      >
        {value}
      </p>
      <p className="mt-1 text-sm text-muted-foreground">{detail}</p>
    </div>
  );
}

function WalletIcon() {
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
      <path d="M4 7.5A2.5 2.5 0 0 1 6.5 5H19a1 1 0 0 1 1 1v3H7a2 2 0 0 0 0 4h13v4a2 2 0 0 1-2 2H6.5A2.5 2.5 0 0 1 4 16.5v-9Z" />
      <path d="M20 9H7a2 2 0 0 0 0 4h13V9Z" />
      <path d="M16 11h.01" />
    </svg>
  );
}
