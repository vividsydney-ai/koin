"use client";

import Link from "next/link";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { TermsOfService } from "@/components/legal/TermsOfService";

export default function AccountTermsPage() {
  const { locale } = useLocale();

  return (
    <div className="p-5 pb-32 sm:p-6 lg:p-8">
      <Link href="/profile/account" className="text-sm font-semibold text-primary hover:underline">
        ← Back to account
      </Link>
      <h1 className="mt-4 font-display text-2xl font-bold text-foreground">Terms of Service</h1>
      <p className="text-sm text-muted-foreground">Effective date: 20 July 2026 · Last updated: 20 July 2026</p>

      <article className="mt-6 space-y-8">
        <TermsOfService locale={locale} />
      </article>
    </div>
  );
}
