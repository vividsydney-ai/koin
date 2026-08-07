"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth/use-auth";
import { createClient } from "@/lib/supabase/client";
import { useLocale } from "@/lib/i18n/LocaleProvider";

type FaqPage = {
  page_key: string;
  title_en: string;
  title_id: string;
  subtitle_en: string;
  subtitle_id: string;
  notice_en: string;
  notice_id: string;
};

type FaqSection = {
  id: string;
  section_key: string;
  display_order: number;
  title_en: string;
  title_id: string;
  eyebrow_en: string | null;
  eyebrow_id: string | null;
};

type FaqEntry = {
  section_id: string;
  entry_key: string;
  display_order: number;
  question_en: string;
  question_id: string;
  answer_en: string;
  answer_id: string;
};

function EmailLinkedText({ text }: { text: string }) {
  const parts = text.split(/([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,})/gi);
  return parts.map((part, index) =>
    /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(part) ? (
      <a key={`${part}-${index}`} href={`mailto:${part}`} className="font-semibold text-primary hover:underline">
        {part}
      </a>
    ) : (
      part
    )
  );
}

export default function ProfileFaqPage() {
  const { user, loading: authLoading } = useAuth(true);
  const { locale } = useLocale();
  const [page, setPage] = useState<FaqPage | null>(null);
  const [sections, setSections] = useState<FaqSection[]>([]);
  const [entries, setEntries] = useState<FaqEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    if (!user) return;

    let mounted = true;
    const loadFaq = async () => {
      setLoading(true);
      setError(false);
      const supabase = createClient();
      const [pageResult, sectionsResult] = await Promise.all([
        supabase
          .from("faq_pages")
          .select("page_key, title_en, title_id, subtitle_en, subtitle_id, notice_en, notice_id")
          .eq("page_key", "profile_faq")
          .maybeSingle(),
        supabase
          .from("faq_sections")
          .select("id, section_key, display_order, title_en, title_id, eyebrow_en, eyebrow_id")
          .eq("page_key", "profile_faq")
          .order("display_order", { ascending: true }),
      ]);

      if (pageResult.error || sectionsResult.error || !pageResult.data || !sectionsResult.data) {
        if (mounted) {
          setError(true);
          setLoading(false);
        }
        return;
      }

      const sectionIds = sectionsResult.data.map((section) => section.id);
      const entriesResult = sectionIds.length === 0
        ? { data: [], error: null }
        : await supabase
          .from("faq_entries")
          .select("section_id, entry_key, display_order, question_en, question_id, answer_en, answer_id")
          .in("section_id", sectionIds)
          .order("display_order", { ascending: true });

      if (entriesResult.error || !mounted) {
        if (mounted) {
          setError(true);
          setLoading(false);
        }
        return;
      }

      setPage(pageResult.data as FaqPage);
      setSections(sectionsResult.data as FaqSection[]);
      setEntries((entriesResult.data ?? []) as FaqEntry[]);
      setLoading(false);
    };

    void loadFaq();
    return () => {
      mounted = false;
    };
  }, [user]);

  const backLabel = locale === "id" ? "Kembali ke Profil" : "Back to Profile";
  const unavailableTitle = locale === "id" ? "FAQ belum tersedia" : "FAQ is not available yet";
  const unavailableBody = locale === "id"
    ? "Kami belum dapat memuat konten bantuan saat ini. Silakan coba lagi sebentar lagi."
    : "We could not load help content right now. Please try again in a moment.";

  if (authLoading || loading) {
    return <FaqSkeleton />;
  }

  if (error || !page) {
    return (
      <main className="mx-auto max-w-3xl p-5 pb-32 sm:p-6 lg:p-8">
        <Link href="/profile" className="inline-flex min-h-11 items-center text-sm font-semibold text-primary hover:underline">← {backLabel}</Link>
        <section className="mt-5 rounded-card border border-muted bg-surface p-6 text-center shadow-sm">
          <div className="mx-auto flex h-11 w-11 items-center justify-center rounded-full bg-primary/10 text-xl font-bold text-primary" aria-hidden="true">?</div>
          <h1 className="mt-4 font-display text-2xl font-bold text-foreground">{unavailableTitle}</h1>
          <p className="mt-2 text-sm leading-6 text-muted-foreground">{unavailableBody}</p>
        </section>
      </main>
    );
  }

  const copy = (en: string, id: string | null) => locale === "id" ? (id ?? en) : en;

  return (
    <main className="mx-auto max-w-3xl p-5 pb-32 sm:p-6 lg:p-8">
      <Link href="/profile" className="inline-flex min-h-11 items-center text-sm font-semibold text-primary hover:underline">← {backLabel}</Link>

      <header className="mt-5 rounded-card border border-primary/20 bg-[color-mix(in_srgb,var(--color-primary)_6%,var(--color-surface))] p-6 shadow-sm sm:p-8">
        <div className="flex h-11 w-11 items-center justify-center rounded-full bg-primary text-xl font-bold text-primary-foreground" aria-hidden="true">?</div>
        <h1 className="mt-5 font-display text-3xl font-bold tracking-tight text-foreground">{copy(page.title_en, page.title_id)}</h1>
        <p className="mt-2 text-sm leading-6 text-muted-foreground">{copy(page.subtitle_en, page.subtitle_id)}</p>
        <p className="mt-5 rounded-lg border border-primary/15 bg-surface px-4 py-3 text-sm leading-6 text-foreground">{copy(page.notice_en, page.notice_id)}</p>
      </header>

      <div className="mt-8 space-y-8">
        {sections.map((section) => {
          const sectionEntries = entries.filter((entry) => entry.section_id === section.id);
          if (sectionEntries.length === 0) return null;
          const title = copy(section.title_en, section.title_id);
          const eyebrow = copy(section.eyebrow_en ?? "", section.eyebrow_id);
          return (
            <section key={section.id} aria-labelledby={`faq-${section.section_key}`}>
              {eyebrow && <p className="text-xs font-bold tracking-[0.16em] text-primary">{eyebrow}</p>}
              <h2 id={`faq-${section.section_key}`} className="font-display text-xl font-bold text-foreground">{title}</h2>
              <div className="mt-3 divide-y divide-border overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                {sectionEntries.map((entry) => (
                  <details key={entry.entry_key} className="group">
                    <summary className="flex min-h-14 cursor-pointer list-none items-center justify-between gap-4 px-5 py-4 text-sm font-semibold text-foreground marker:content-none hover:bg-surface-raised focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-primary">
                      <span>{copy(entry.question_en, entry.question_id)}</span>
                      <span className="shrink-0 text-lg text-primary transition-transform group-open:rotate-45" aria-hidden="true">+</span>
                    </summary>
                    <p className="border-t border-border bg-background px-5 py-4 text-sm leading-6 text-muted-foreground">
                      <EmailLinkedText text={copy(entry.answer_en, entry.answer_id)} />
                    </p>
                  </details>
                ))}
              </div>
            </section>
          );
        })}
      </div>
    </main>
  );
}

function FaqSkeleton() {
  return (
    <main className="mx-auto max-w-3xl p-5 pb-32 sm:p-6 lg:p-8" aria-busy="true">
      <div className="h-11 w-32 animate-pulse rounded bg-surface-inset" />
      <div className="mt-5 h-52 animate-pulse rounded-card bg-surface-inset" />
      <div className="mt-8 space-y-4">
        <div className="h-7 w-44 animate-pulse rounded bg-surface-inset" />
        <div className="h-52 animate-pulse rounded-card bg-surface-inset" />
      </div>
    </main>
  );
}
