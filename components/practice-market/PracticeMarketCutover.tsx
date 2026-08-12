import Link from "next/link";
import type { PracticeMarketCutoverStatus } from "@/lib/practice-market/cutover";

const DEFAULT_STATUS: PracticeMarketCutoverStatus = {
  seasonAccessEnabled: false,
  legacyArchived: true,
  notice: "Season 1 is being prepared. Complete Chapter 08 and Before the Bell onboarding to be ready.",
};

export default function PracticeMarketCutover({
  status = DEFAULT_STATUS,
}: {
  status?: PracticeMarketCutoverStatus;
}) {
  return (
    <main className="min-h-screen bg-background p-5 pb-28 sm:p-6 lg:p-8">
      <section className="mx-auto max-w-3xl rounded-card border border-muted bg-surface p-6 shadow-sm sm:p-8">
        <span className="inline-flex rounded-full bg-primary/10 px-3 py-1 text-xs font-bold uppercase tracking-wide text-primary">
          Simulated learning experience
        </span>
        <h1 className="mt-4 font-display text-3xl font-bold tracking-tight text-foreground">
          Practice Market
        </h1>
        <p className="mt-2 text-base leading-relaxed text-muted-foreground">
          Learn through a shared, explicitly simulated market season. No real money is used.
        </p>

        <div className="mt-6 rounded-xl border border-primary/20 bg-primary/5 p-5">
          <p className="text-sm font-bold text-foreground">
            {status.seasonAccessEnabled ? "Season 1 access is being opened" : "Season 1 is being prepared"}
          </p>
          <p className="mt-1 text-sm leading-relaxed text-muted-foreground">{status.notice}</p>
        </div>

        <ol className="mt-6 grid gap-3 text-sm text-foreground sm:grid-cols-3" aria-label="Practice Market requirements">
          <li className="rounded-lg border border-muted bg-background p-4">
            <span className="font-bold text-primary">01</span>
            <p className="mt-2 font-semibold">Complete Chapter 08</p>
            <p className="mt-1 text-muted-foreground">Investing in Indonesia</p>
          </li>
          <li className="rounded-lg border border-muted bg-background p-4">
            <span className="font-bold text-primary">02</span>
            <p className="mt-2 font-semibold">Complete Before the Bell</p>
            <p className="mt-1 text-muted-foreground">Learn the season rules first.</p>
          </li>
          <li className="rounded-lg border border-muted bg-background p-4">
            <span className="font-bold text-primary">03</span>
            <p className="mt-2 font-semibold">Join when Season 1 opens</p>
            <p className="mt-1 text-muted-foreground">Your fresh simulated account begins then.</p>
          </li>
        </ol>

        <p className="mt-6 text-sm leading-relaxed text-muted-foreground">
          Previous simulation portfolios are safely archived and will not carry into Season 1.
        </p>
        <Link
          href="/learn"
          className="mt-6 inline-flex min-h-11 items-center rounded-lg bg-primary px-4 text-sm font-bold text-primary-foreground transition-opacity hover:opacity-90"
        >
          Continue learning
        </Link>
      </section>
    </main>
  );
}
