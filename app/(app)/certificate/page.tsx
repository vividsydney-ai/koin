"use client";

import Link from "next/link";

export default function CertificatePage() {
  return (
    <main className="min-h-screen bg-background p-5 pb-28">
      <section className="rounded-card border border-muted bg-surface p-8 text-center shadow-sm">
        <p className="text-4xl" aria-hidden="true">🎓</p>
        <h1 className="mt-3 text-xl font-bold text-foreground">Practice Market certificates are coming in a future season</h1>
        <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
          Legacy Paper Trading certificates and portfolios are archived during the clean Season 1 transition.
        </p>
        <Link
          href="/learn"
          className="mt-5 inline-flex min-h-11 items-center rounded-lg bg-primary px-4 text-sm font-bold text-primary-foreground"
        >
          Continue learning
        </Link>
      </section>
    </main>
  );
}
