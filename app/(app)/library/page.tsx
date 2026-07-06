"use client";

import { useEffect, useMemo, useState } from "react";
import { getSources, type Source } from "@/lib/sources/client";

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
    <main className="min-h-screen bg-background p-5 pb-28">
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
          className="w-full rounded-radius-md border border-muted bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
        />
      </div>

      <div className="mb-4 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <FilterSelect label="Source" value={organization} onChange={setOrganization} options={organizations} />
        <FilterSelect
          label="Tier"
          value={tier}
          onChange={setTier}
          options={["1", "2", "3"]}
          renderOption={(value) => TIER_LABELS[Number(value)]}
        />
        <FilterSelect label="Type" value={sourceType} onChange={setSourceType} options={sourceTypes} />
        <FilterSelect label="Language" value={language} onChange={setLanguage} options={languages} />
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
        <div className="space-y-3">
          <SourceCardSkeleton />
          <SourceCardSkeleton />
          <SourceCardSkeleton />
        </div>
      ) : filtered.length === 0 ? (
        <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-6 text-center">
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
        <ul className="space-y-3" role="list">
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

function FilterSelect({
  label,
  value,
  onChange,
  options,
  renderOption,
}: {
  label: string;
  value: string;
  onChange: (value: string) => void;
  options: string[];
  renderOption?: (value: string) => string;
}) {
  const id = `filter-${label.toLowerCase()}`;
  return (
    <div>
      <label htmlFor={id} className="mb-1 block text-xs font-medium text-muted-foreground">
        {label}
      </label>
      <select
        id={id}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full rounded-radius-md border border-muted bg-background px-2 py-2 text-sm text-foreground outline-none focus:border-primary"
      >
        <option value="">All {label.toLowerCase()}s</option>
        {options.map((option) => (
          <option key={option} value={option}>
            {renderOption ? renderOption(option) : option}
          </option>
        ))}
      </select>
    </div>
  );
}

function SourceCard({ source }: { source: Source }) {
  const titleContent = (
    <>
      <div className="mb-2 flex flex-wrap items-center gap-2">
        <span
          className={`rounded-radius-sm border px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide ${TIER_CLASSES[source.sourceTier]}`}
        >
          {TIER_LABELS[source.sourceTier]}
        </span>
        <span className="rounded-radius-sm bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
          {source.sourceType}
        </span>
        <span className="rounded-radius-sm bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
          {STATUS_LABELS[source.status]}
        </span>
      </div>
      <h2 className="text-base font-semibold text-foreground">{source.title}</h2>
      {source.localTitle && source.localTitle !== source.title && (
        <p className="text-sm text-muted-foreground">{source.localTitle}</p>
      )}
      <p className="mt-1 text-xs text-muted-foreground">
        {source.organization}
        {source.publicationYear ? ` · ${source.publicationYear}` : ""}
        {source.language ? ` · ${source.language.toUpperCase()}` : ""}
      </p>
    </>
  );

  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm transition-colors hover:border-primary/30">
      {source.url ? (
        <a
          href={source.url}
          target="_blank"
          rel="noopener noreferrer"
          className="block focus:outline-none focus-visible:ring-2 focus-visible:ring-primary rounded-radius-md"
        >
          {titleContent}
        </a>
      ) : (
        titleContent
      )}
    </div>
  );
}

function SourceCardSkeleton() {
  return (
    <div className="rounded-radius-lg border border-muted/60 bg-surface p-4 shadow-sm">
      <div className="mb-2 flex gap-2">
        <div className="h-5 w-24 animate-pulse rounded-radius-sm bg-muted" />
        <div className="h-5 w-16 animate-pulse rounded-radius-sm bg-muted" />
      </div>
      <div className="h-5 w-3/4 animate-pulse rounded bg-muted" />
      <div className="mt-1 h-4 w-1/2 animate-pulse rounded bg-muted" />
    </div>
  );
}
