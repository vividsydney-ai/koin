import Link from "next/link";

export interface LegalPageProps {
  title: string;
  lastUpdated: string;
  effectiveDate: string;
  children: React.ReactNode;
  alternateHref: string;
  alternateLabel: string;
}

export function LegalPage({
  title,
  lastUpdated,
  effectiveDate,
  children,
  alternateHref,
  alternateLabel,
}: LegalPageProps) {
  return (
    <main className="min-h-screen bg-background px-5 py-10 pb-20 sm:px-8">
      <div className="mx-auto w-full max-w-3xl">
        <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-sm font-semibold text-primary hover:underline"
          >
            <span aria-hidden="true">←</span> Back to Koinaku
          </Link>
          <Link
            href={alternateHref}
            className="text-sm font-medium text-muted-foreground hover:text-foreground"
          >
            {alternateLabel}
          </Link>
        </div>

        <h1 className="font-display text-3xl font-bold tracking-tight text-foreground sm:text-4xl">
          {title}
        </h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Effective date: {effectiveDate} · Last updated: {lastUpdated}
        </p>

        <article className="mt-10 space-y-8 text-foreground">
          {children}
        </article>

        <footer className="mt-16 border-t border-border pt-8 text-sm text-muted-foreground">
          <p>
            Questions? Contact us at{" "}
            <a href="mailto:hello@koinaku.com" className="text-primary hover:underline">
              hello@koinaku.com
            </a>
            .
          </p>
        </footer>
      </div>
    </main>
  );
}

export function LegalSection({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  return (
    <section>
      <h2 className="text-xl font-bold tracking-tight text-foreground">{title}</h2>
      <div className="mt-3 space-y-3 text-sm leading-relaxed text-muted-foreground">
        {children}
      </div>
    </section>
  );
}
