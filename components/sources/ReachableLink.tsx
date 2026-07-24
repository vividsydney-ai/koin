"use client";

import { useEffect, useState } from "react";
import { checkUrlReachability, type ReachabilityResult } from "@/lib/sources/reachability";
import { fetchWikipediaSummary, type WikipediaSummary } from "@/lib/sources/wikipedia";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import type { Locale } from "@/lib/i18n/types";

interface ReachableLinkProps {
  url: string;
  title: string;
  locale?: Locale;
  fallbackType?: "wikipedia";
  className?: string;
  linkClassName?: string;
  children?: React.ReactNode;
  ariaLabel?: string;
  /** When true, skip the browser reachability check and render the original link.
   *  Use for Tier-1 regulator domains (OJK, BI, IDX) that block CORS preflight
   *  requests but are trusted by editorial review. */
  skipCheck?: boolean;
}

export function ReachableLink({
  url,
  title,
  locale: localeProp,
  fallbackType = "wikipedia",
  className = "",
  linkClassName = "inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline",
  children,
  ariaLabel,
  skipCheck = false,
}: ReachableLinkProps) {
  const { t, locale: contextLocale } = useLocale();
  const locale = localeProp ?? contextLocale;
  const [result, setResult] = useState<ReachabilityResult | null>(null);
  const [wiki, setWiki] = useState<WikipediaSummary | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;

    async function check() {
      setLoading(true);

      if (skipCheck) {
        if (cancelled) return;
        setResult({ ok: true });
        setLoading(false);
        return;
      }

      const reachability = await checkUrlReachability(url);
      if (cancelled) return;
      setResult(reachability);

      if (!reachability.ok && fallbackType === "wikipedia") {
        const summary = await fetchWikipediaSummary(title, locale);
        if (cancelled) return;
        setWiki(summary);
      }

      setLoading(false);
    }

    check();

    return () => {
      cancelled = true;
    };
  }, [url, title, locale, fallbackType, skipCheck]);

  if (loading) {
    return (
      <span className={linkClassName} aria-busy="true" aria-label={`Checking ${title}`}>
        <span className="inline-block h-3.5 w-3.5 animate-pulse rounded-full bg-current opacity-50" />
        {children}
      </span>
    );
  }

  if (result?.ok) {
    return (
      <a
        href={url}
        target="_blank"
        rel="noopener noreferrer"
        aria-label={ariaLabel ?? `${t("lesson.readSource")}: ${title}`}
        className={linkClassName}
      >
        {children}
      </a>
    );
  }

  const fallbackUrl = wiki?.url ?? "#";
  const fallbackLabel = ariaLabel ?? `${t("sources.readOnWikipedia")}: ${title}`;

  return (
    <span className={`inline-flex flex-wrap items-center gap-2 ${className}`}>
      <a
        href={fallbackUrl}
        target="_blank"
        rel="noopener noreferrer"
        aria-label={fallbackLabel}
        className={linkClassName}
      >
        {children ?? t("sources.readOnWikipedia")}
      </a>
      <span className="inline-flex items-center gap-1 text-xs text-warning">
        <span className="h-1.5 w-1.5 rounded-full bg-warning" aria-hidden="true" />
        {t("sources.originalUnavailable")}
      </span>
    </span>
  );
}
