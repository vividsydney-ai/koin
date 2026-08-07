"use client";

import { useEffect, useMemo, useState } from "react";
import { getSources, type Source } from "@/lib/sources/client";
import { getLocalizedSourceUrl } from "@/lib/sources/localized-url";
import { FilterChips } from "@/components/FilterChips";
import { useLocale } from "@/lib/i18n/LocaleProvider";
import { ReachableLink } from "@/components/sources/ReachableLink";

const TIER_LABELS: Record<number, string> = {
  1: "Tier 1 — Regulator",
  2: "Tier 2 — Enrichment",
  3: "Tier 3 — Creator",
};

const TIER_CLASSES: Record<number, string> = {
  1: "bg-success/10 text-success border-success/20",
  2: "bg-info/10 text-info border-info/20",
  3: "bg-muted/50 text-muted-foreground border-muted",
};

const STATUS_LABELS: Record<Source["status"], string> = {
  verified: "Verified",
  needs_review: "Needs review",
  use_carefully: "Use carefully",
  deprecated: "Deprecated",
};

export default function LibraryPage() {
  const { t } = useLocale();
  const [sources, setSources] = useState<Source[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [organization, setOrganization] = useState("");
  const [tier, setTier] = useState("");
  const [sourceType, setSourceType] = useState("");
  const [language, setLanguage] = useState("");

  useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      const data = await getSources();
      if (!mounted) return;
      setSources(data);
      setLoading(false);
    };
    load();
    return () => {
      mounted = false;
    };
  }, []);

  const organizations = useMemo(
    () => Array.from(new Set(sources.map((s) => s.organization))).sort(),
    [sources]
  );

  const sourceTypes = useMemo(
    () => Array.from(new Set(sources.map((s) => s.sourceType))).sort(),
    [sources]
  );

  const languages = useMemo(
    () => Array.from(new Set(sources.map((s) => s.language))).sort(),
    [sources]
  );

  const filtered = useMemo(() => {
    const term = search.trim().toLowerCase();
    return sources.filter((s) => {
      if (term) {
        const haystack = `${s.title} ${s.localTitle ?? ""} ${s.organization}`.toLowerCase();
        if (!haystack.includes(term)) return false;
      }
      if (organization && s.organization !== organization) return false;
      if (tier && s.sourceTier !== Number(tier)) return false;
      if (sourceType && s.sourceType !== sourceType) return false;
      if (language && s.language !== language) return false;
      return true;
    });
  }, [sources, search, organization, tier, sourceType, language]);

  const activeFilterCount = [organization, tier, sourceType, language].filter(Boolean).length;

  const resetFilters = () => {
    setOrganization("");
    setTier("");
    setSourceType("");
    setLanguage("");
    setSearch("");
  };

  return (
    <main className="min-h-screen bg-background p-5 pb-28 sm:p-6 lg:p-8 xl:p-10">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight text-foreground">Library</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Trusted sources for Indonesian financial literacy.
        </p>
      </header>

      <div className="mb-4">
        <label htmlFor="source-search" className="sr-only">
          Search sources
        </label>
        <input
          id="source-search"
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search by title, local title, or organization"
          className="w-full rounded-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
        />
      </div>

      <div className="mb-4">
        <FilterChips
          groups={[
            {
              label: "Source",
              value: organization,
              onChange: setOrganization,
              allLabel: t("library.allSources"),
              options: organizations.map((o) => ({ value: o, label: o })),
            },
            {
              label: "Tier",
              value: tier,
              onChange: setTier,
              allLabel: t("library.allTiers"),
              options: ["1", "2", "3"].map((v) => ({ value: v, label: TIER_LABELS[Number(v)] })),
            },
            {
              label: "Type",
              value: sourceType,
              onChange: setSourceType,
              allLabel: t("library.allTypes"),
              options: sourceTypes.map((t) => ({ value: t, label: t })),
            },
            {
              label: "Language",
              value: language,
              onChange: setLanguage,
              allLabel: t("library.allLanguages"),
              options: languages.map((l) => ({ value: l, label: l })),
            },
          ]}
        />
      </div>

      <div className="mb-6 flex items-center justify-between">
        <p className="text-sm text-muted-foreground">
          {loading ? "Loading sources…" : `${filtered.length} result${filtered.length === 1 ? "" : "s"}`}
        </p>
        {activeFilterCount > 0 && (
          <button
            onClick={resetFilters}
            className="text-sm font-semibold text-primary hover:underline"
          >
            Reset filters
          </button>
        )}
      </div>

      {loading ? (
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-4 lg:grid-cols-3 lg:gap-5 xl:gap-8">
          <SourceCardSkeleton />
          <SourceCardSkeleton />
          <SourceCardSkeleton />
        </div>
      ) : filtered.length === 0 ? (
        <div className="rounded-lg border border-dashed border-muted bg-surface p-6 text-center">
          <p className="text-sm text-muted-foreground">No sources match your filters.</p>
          {activeFilterCount > 0 && (
            <button
              onClick={resetFilters}
              className="mt-3 text-sm font-semibold text-primary hover:underline"
            >
              Clear filters
            </button>
          )}
        </div>
      ) : (
        <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2 sm:gap-4 lg:grid-cols-3 lg:gap-5 xl:gap-8" role="list">
          {filtered.map((source) => (
            <li key={source.id}>
              <SourceCard source={source} />
            </li>
          ))}
        </ul>
      )}
    </main>
  );
}

function SourceCard({ source }: { source: Source }) {
  const { t, locale } = useLocale();
  const localizedUrl = getLocalizedSourceUrl(source, locale);
  const [expanded, setExpanded] = useState(false);
  const activeSynopsis = locale === "id" ? (source.synopsisId ?? source.synopsis) : source.synopsis;
  const activeRelevance = locale === "id" ? (source.relevanceBlurbId ?? source.relevanceBlurb) : source.relevanceBlurb;
  const hasDetails = Boolean(activeSynopsis || activeRelevance);
  const blurb = activeSynopsis || activeRelevance;
  const isTier1 = source.sourceTier === 1;

  if (isTier1) {
    return (
      <article className="relative overflow-hidden rounded-card border border-primary/30 bg-surface p-5 shadow-sm transition-colors hover:border-primary/50">
        <div className="absolute inset-x-0 top-0 h-1 bg-primary" aria-hidden="true" />
        <div className="flex flex-wrap items-center gap-2">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-primary/10 px-2.5 py-1 text-[11px] font-bold uppercase tracking-wide text-primary">
            <FileTextIcon size={14} />
            {TIER_LABELS[source.sourceTier]}
          </span>
          <span className="rounded-md bg-primary/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-primary">
            {source.sourceType}
          </span>
          <StatusPill status={source.status} variant="light" />
        </div>
        <h2 className="mt-3 font-display text-lg font-bold text-foreground">{source.title}</h2>
        {source.localTitle && source.localTitle !== source.title && (
          <p className="mt-1 text-sm text-muted-foreground">{source.localTitle}</p>
        )}
        <p className="mt-1 text-sm text-muted-foreground">
          {source.organization}
          {source.publicationYear ? ` · ${source.publicationYear}` : ""}
          {source.language ? ` · ${source.language.toUpperCase()}` : ""}
        </p>
        {blurb && (
          <p className={`mt-3 text-sm leading-relaxed text-foreground ${expanded ? "" : "line-clamp-3"}`}>
            {blurb}
          </p>
        )}
        <div className="mt-3 flex flex-wrap items-center gap-4">
          {localizedUrl && (
            <ReachableLink
              url={localizedUrl}
              title={source.title}
              ariaLabel={`${t("lesson.readSource")}: ${source.title}`}
              linkClassName="inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
              skipCheck={source.sourceTier === 1}
            >
              {t("lesson.readSource")}
              <ArrowRightIcon />
            </ReachableLink>
          )}
          {hasDetails && (
            <button
              type="button"
              onClick={() => setExpanded((e) => !e)}
              aria-expanded={expanded}
              aria-label={`${expanded ? t("library.showLess") : t("library.readMore")}: ${source.title}`}
              className="inline-flex items-center gap-1 rounded-md text-sm font-bold text-primary hover:underline focus:outline-none focus-visible:ring-2 focus-visible:ring-primary"
            >
              {expanded ? t("library.showLess") : t("library.readMore")}
              <ChevronIcon expanded={expanded} />
            </button>
          )}
        </div>
        {expanded && (
          <div className="mt-4 space-y-3 border-t border-muted pt-3">
            {activeSynopsis && (
              <div>
                <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                  {t("library.synopsis")}
                </p>
                <p className="mt-1 text-sm leading-relaxed text-foreground">{activeSynopsis}</p>
              </div>
            )}
            {activeRelevance && (
              <div>
                <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                  {t("library.relevance")}
                </p>
                <p className="mt-1 text-sm leading-relaxed text-foreground">{activeRelevance}</p>
              </div>
            )}
          </div>
        )}
      </article>
    );
  }

  return (
    <article className="rounded-card border border-muted bg-surface p-4 grid grid-cols-[80px_minmax(0,1fr)] gap-4 transition-colors hover:border-primary/30">
      <div className="flex h-20 w-full items-center justify-center rounded-md bg-gradient-to-br from-primary/10 to-surface-raised text-primary">
        {source.sourceType.toLowerCase().includes("news") || source.sourceType.toLowerCase().includes("article") ? (
          <NewspaperIcon size={26} />
        ) : (
          <FileTextIcon size={26} />
        )}
      </div>
      <div className="grid min-w-0 content-start gap-1.5">
        <div className="flex flex-wrap items-center gap-2">
          <span className={`rounded-md border px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${TIER_CLASSES[source.sourceTier]}`}>
            {TIER_LABELS[source.sourceTier]}
          </span>
          <span className="rounded-md bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            {source.sourceType}
          </span>
          <StatusPill status={source.status} variant="light" />
        </div>
        <h2 className="font-display text-base font-bold text-foreground">{source.title}</h2>
        {source.localTitle && source.localTitle !== source.title && (
          <p className="text-sm text-muted-foreground">{source.localTitle}</p>
        )}
        <p className="text-xs text-muted-foreground">
          {source.organization}
          {source.publicationYear ? ` · ${source.publicationYear}` : ""}
          {source.language ? ` · ${source.language.toUpperCase()}` : ""}
        </p>
        {blurb && <p className="text-sm text-muted-foreground line-clamp-2">{blurb}</p>}
        <div className="mt-1 flex flex-wrap items-center gap-4">
          {localizedUrl && (
            <ReachableLink
              url={localizedUrl}
              title={source.title}
              ariaLabel={`${t("lesson.readSource")}: ${source.title}`}
              linkClassName="inline-flex items-center gap-1 text-sm font-bold text-primary hover:underline"
              skipCheck={source.sourceTier === 1}
            >
              {t("lesson.readSource")}
              <ExternalLinkIcon />
            </ReachableLink>
          )}
          {hasDetails && (
            <button
              type="button"
              onClick={() => setExpanded((e) => !e)}
              aria-expanded={expanded}
              aria-label={`${expanded ? t("library.showLess") : t("library.readMore")}: ${source.title}`}
              className="inline-flex items-center gap-1 rounded-md text-sm font-bold text-primary hover:underline focus:outline-none focus-visible:ring-2 focus-visible:ring-primary"
            >
              {expanded ? t("library.showLess") : t("library.readMore")}
              <ChevronIcon expanded={expanded} />
            </button>
          )}
        </div>
      </div>
      {expanded && (
        <div className="col-span-2 mt-2 space-y-3 border-t border-muted pt-3">
          {activeSynopsis && (
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                {t("library.synopsis")}
              </p>
              <p className="mt-1 text-sm leading-relaxed text-muted-foreground">{activeSynopsis}</p>
            </div>
          )}
          {activeRelevance && (
            <div>
              <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
                {t("library.relevance")}
              </p>
              <p className="mt-1 text-sm leading-relaxed text-muted-foreground">{activeRelevance}</p>
            </div>
          )}
        </div>
      )}
    </article>
  );
}

function StatusPill({ status, variant }: { status: Source["status"]; variant: "dark" | "light" }) {
  const label = STATUS_LABELS[status];
  const base = variant === "dark"
    ? "rounded-md bg-white/10 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide"
    : "rounded-md px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide";
  const tone = variant === "dark"
    ? status === "verified"
      ? "text-success"
      : status === "needs_review"
      ? "text-warning"
      : "text-white/70"
    : status === "verified"
    ? "bg-success/10 text-success"
    : status === "needs_review"
    ? "bg-warning/10 text-warning"
    : status === "use_carefully"
    ? "bg-info/10 text-info"
    : "bg-muted text-muted-foreground";
  return <span className={`${base} ${tone}`}>{label}</span>;
}

function ChevronIcon({ expanded }: { expanded: boolean }) {
  return (
    <svg
      className={`h-4 w-4 transition-transform ${expanded ? "rotate-180" : ""}`}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="m6 9 6 6 6-6" />
    </svg>
  );
}

function FileTextIcon({ size = 24 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
      <path d="M14 2v4a2 2 0 0 0 2 2h4" />
      <path d="M10 9H8" />
      <path d="M16 13H8" />
      <path d="M16 17H8" />
    </svg>
  );
}

function NewspaperIcon({ size = 24 }: { size?: number }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-4 0v-9a2 2 0 0 1 2-2h2" />
      <path d="M10 6h8" />
      <path d="M10 10h8" />
      <path d="M10 14h5" />
    </svg>
  );
}

function ExternalLinkIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M15 3h6v6" />
      <path d="M10 14 21 3" />
      <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
    </svg>
  );
}

function ArrowRightIcon() {
  return (
    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14" />
      <path d="m12 5 7 7-7 7" />
    </svg>
  );
}

function SourceCardSkeleton() {
  return (
    <div className="rounded-card border border-muted bg-surface p-4 grid grid-cols-[80px_minmax(0,1fr)] gap-4">
      <div className="h-20 w-full animate-pulse rounded-md bg-muted" />
      <div className="grid content-start gap-1.5">
        <div className="flex gap-2">
          <div className="h-5 w-20 animate-pulse rounded-md bg-muted" />
          <div className="h-5 w-16 animate-pulse rounded-md bg-muted" />
        </div>
        <div className="h-5 w-3/4 animate-pulse rounded bg-muted" />
        <div className="h-4 w-1/2 animate-pulse rounded bg-muted" />
        <div className="mt-1 h-4 w-full animate-pulse rounded bg-muted" />
      </div>
    </div>
  );
}
