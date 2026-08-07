"use client";

import { useLayoutEffect, useRef, useState } from "react";
import { gsap } from "gsap";
import {
  type AnnotatedDataPayload,
  type ComparisonPayload,
  type LessonVisualBlock,
  type ProcessPayload,
  type VisualBlockLocale,
  type WorkedExamplePayload,
  visualBlockCopy,
} from "@/lib/lessons/visual-block";
import { CandlestickChart } from "@/components/charts/CandlestickChart";

const interfaceCopy = {
  en: { showAll: "Show all", illustrative: "Illustrative learning example" },
  id: { showAll: "Tampilkan semua", illustrative: "Contoh pembelajaran ilustratif" },
} as const;

export function LessonVisualBlocks({
  blocks,
  locale,
  placement,
}: {
  blocks: LessonVisualBlock[];
  locale: VisualBlockLocale;
  placement: "concept" | "example";
}) {
  const rootRef = useRef<HTMLDivElement>(null);
  const timelineRef = useRef<gsap.core.Timeline | null>(null);
  const [canSkip, setCanSkip] = useState(false);
  const visibleBlocks = blocks.filter((block) => block.placement === placement);

  useLayoutEffect(() => {
    const root = rootRef.current;
    if (!root || visibleBlocks.length === 0) return;

    const media = gsap.matchMedia();
    media.add("(prefers-reduced-motion: no-preference)", () => {
      const legend = gsap.utils.toArray<HTMLElement>("[data-guided-legend]", root);
      const boundary = gsap.utils.toArray<HTMLElement>("[data-guided-evidence]", root);
      if (legend.length === 0 && boundary.length === 0) return;

      const timeline = gsap.timeline({
        defaults: { duration: 0.2, ease: "power2.out" },
        onComplete: () => setCanSkip(false),
      });
      timelineRef.current = timeline;
      setCanSkip(true);
      timeline.set([...legend, ...boundary], { autoAlpha: 0, y: 8 });
      if (legend.length > 0) timeline.to(legend, { autoAlpha: 1, y: 0, stagger: 0.2 });
      if (boundary.length > 0) timeline.to(boundary, { autoAlpha: 1, y: 0 }, "+=0.08");

      return () => {
        timelineRef.current = null;
      };
    }, root);

    return () => media.revert();
  }, [visibleBlocks.length]);

  if (visibleBlocks.length === 0) return null;

  return (
    <section ref={rootRef} aria-label={locale === "id" ? "Visual pelajaran" : "Lesson visual"} className="mt-5 space-y-5">
      {visibleBlocks.map((block) => <VisualBlock key={block.id} block={block} locale={locale} />)}
      {canSkip && (
        <button
          type="button"
          onClick={() => {
            timelineRef.current?.progress(1);
            setCanSkip(false);
          }}
          className="min-h-11 rounded-lg border border-primary/25 bg-surface px-3 text-sm font-bold text-primary transition-colors hover:bg-primary/5 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        >
          {interfaceCopy[locale].showAll}
        </button>
      )}
    </section>
  );
}

function VisualBlock({ block, locale }: { block: LessonVisualBlock; locale: VisualBlockLocale }) {
  const copy = visualBlockCopy(block, locale);
  return (
    <article className="relative rounded-card border border-primary/20 bg-surface p-4 shadow-sm sm:p-5">
      {copy.eyebrow && <p className="flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.14em] text-primary">{copy.icon && <span aria-hidden="true" className="text-base leading-none">{copy.icon}</span>}{copy.eyebrow}</p>}
      <h3 className="mt-1.5 font-display text-xl font-bold text-foreground">{copy.title}</h3>
      {copy.disclosure && <p className="mt-2 text-xs leading-relaxed text-muted-foreground">{copy.disclosure}</p>}
      <span className="sr-only">{copy.altText}</span>
      <div className="mt-5">
        {block.blockType === "annotated_data" && <AnnotatedData block={block} payload={copy.payload as AnnotatedDataPayload} locale={locale} />}
        {block.blockType === "comparison" && <Comparison payload={copy.payload as ComparisonPayload} />}
        {block.blockType === "process" && <Process payload={copy.payload as ProcessPayload} />}
        {block.blockType === "worked_example" && <WorkedExample payload={copy.payload as WorkedExamplePayload} />}
      </div>
    </article>
  );
}

function AnnotatedData({ block, payload, locale }: { block: LessonVisualBlock; payload: AnnotatedDataPayload; locale: VisualBlockLocale }) {
  const chart = payload.chart;
  return (
    <div className="grid gap-5 lg:grid-cols-[minmax(0,1fr)_minmax(15rem,0.78fr)] lg:items-start">
      {chart ? (
        <section aria-label={payload.quoteTitle} className="overflow-hidden rounded-[var(--radius-xl)] border border-muted bg-surface shadow-sm">
          <div className="border-b border-muted bg-surface-raised px-4 py-3">
            <p className="text-[11px] font-bold uppercase tracking-[0.14em] text-secondary">{payload.quoteTitle}</p>
          </div>
          <div className="p-3">
            <CandlestickChart
              candles={chart.candles}
              label={payload.quoteTitle}
              caption={block.dataStatus === "illustrative" ? interfaceCopy[locale].illustrative : undefined}
              accent={chart.accent ?? "core"}
              compact={chart.compact ?? false}
              markers={chart.markers}
            />
          </div>
        </section>
      ) : (
        <section aria-label={payload.quoteTitle} className="overflow-hidden rounded-[var(--radius-xl)] border border-[var(--rup-blue-200)] bg-surface shadow-sm">
          <div className="border-b border-[var(--rup-blue-100)] bg-[var(--rup-blue-50)] px-4 py-3">
            <p className="text-[11px] font-bold uppercase tracking-[0.14em] text-secondary">{payload.quoteTitle}</p>
            <div className="mt-1 flex items-end justify-between gap-3">
              {payload.price && <strong className="font-display text-2xl leading-none text-foreground">{payload.price}</strong>}
              {payload.change && <span className="text-xs font-bold text-success">{payload.change}</span>}
            </div>
          </div>
          {payload.fields && (
            <dl className="divide-y divide-muted">
              {payload.fields.map((field) => (
                <div key={field.label} className="grid grid-cols-[minmax(0,1fr)_auto] gap-3 px-4 py-3">
                  <dt className="text-xs font-bold text-foreground">{field.label}</dt>
                  <dd className="text-right">
                    <span className="block text-sm font-bold text-foreground">{field.value}</span>
                    <span className="mt-0.5 block text-[11px] leading-snug text-muted-foreground">{field.note}</span>
                  </dd>
                </div>
              ))}
            </dl>
          )}
        </section>
      )}
      <ol className="grid gap-2.5" aria-label={locale === "id" ? "Legenda visual" : "Visual legend"}>
        {payload.annotations.map((annotation) => (
          <li key={annotation.number} data-guided-legend className="grid grid-cols-[1.7rem_minmax(0,1fr)] items-start gap-2.5 rounded-lg border border-muted bg-surface-raised px-3 py-2.5">
            <span className="mt-0.5 flex h-7 w-7 items-center justify-center rounded-full bg-primary text-xs font-bold text-white">{annotation.number}</span>
            <span className="min-w-0">
              <strong className="block text-sm leading-snug text-foreground">{annotation.label}</strong>
              <span className="mt-0.5 block text-xs leading-snug text-muted-foreground">{annotation.detail}</span>
            </span>
          </li>
        ))}
      </ol>
      {block.dataStatus === "illustrative" && !chart && <p className="sr-only">{interfaceCopy[locale].illustrative}</p>}
    </div>
  );
}

function Comparison({ payload }: { payload: ComparisonPayload }) {
  if (payload.items) {
    return (
      <div data-guided-evidence className="space-y-4">
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {payload.items.map((item) => (
            <div key={item.title} className="overflow-hidden rounded-[var(--radius-xl)] border border-muted bg-surface">
              <div className="border-b border-muted bg-surface-raised px-4 py-3">
                <h4 className="text-sm font-bold text-foreground">{item.title}</h4>
                {item.subtitle && <p className="mt-0.5 text-xs text-muted-foreground">{item.subtitle}</p>}
              </div>
              <div className="p-3">
                <CandlestickChart
                  candles={item.chart.candles}
                  label={item.title}
                  accent={item.chart.accent ?? "core"}
                  compact={item.chart.compact ?? true}
                  markers={item.chart.markers}
                />
              </div>
              {item.footnote && <p className="border-t border-muted px-4 py-2 text-xs text-muted-foreground">{item.footnote}</p>}
            </div>
          ))}
        </div>
      </div>
    );
  }
  return (
    <div data-guided-evidence className="overflow-hidden rounded-[var(--radius-xl)] border border-muted bg-surface">
      <div className="grid grid-cols-2 border-b border-muted">
        <h4 className="bg-success/5 px-4 py-3 text-sm font-bold text-success">{payload.leftTitle}</h4>
        <h4 className="bg-[var(--rup-gold-50)] px-4 py-3 text-sm font-bold text-[var(--rup-gold-700)]">{payload.rightTitle}</h4>
      </div>
      {payload.rows && payload.rows.map((row) => (
        <div key={row.left} className="grid grid-cols-2 divide-x divide-muted border-b border-muted last:border-b-0">
          <p className="px-4 py-3 text-sm leading-snug text-foreground">{row.left}</p>
          <p className="px-4 py-3 text-sm leading-snug text-muted-foreground">{row.right}</p>
        </div>
      ))}
    </div>
  );
}

function Process({ payload }: { payload: ProcessPayload }) {
  return (
    <div className="space-y-4">
      {payload.chart && (
        <div data-guided-evidence className="overflow-hidden rounded-[var(--radius-xl)] border border-muted bg-surface p-3">
          <CandlestickChart
            candles={payload.chart.candles}
            label={payload.steps[0]?.title ?? "Process"}
            accent={payload.chart.accent ?? "core"}
            compact={payload.chart.compact ?? false}
            markers={payload.chart.markers}
          />
        </div>
      )}
      <ol className="space-y-3">{payload.steps.map((step, index) => <li key={step.title} className="flex gap-3"><span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary text-xs font-bold text-white">{index + 1}</span><span><strong className="block text-sm text-foreground">{step.title}</strong><span className="text-sm text-muted-foreground">{step.description}</span></span></li>)}</ol>
    </div>
  );
}

function WorkedExample({ payload }: { payload: WorkedExamplePayload }) {
  return <div className="space-y-4"><dl className="grid gap-2 sm:grid-cols-2">{payload.inputs.map((input) => <div key={input.label} className="rounded-lg bg-surface-raised p-3"><dt className="text-xs font-bold text-muted-foreground">{input.label}</dt><dd className="mt-1 text-sm font-bold text-foreground">{input.value}</dd></div>)}</dl><ol className="list-decimal space-y-2 pl-5 text-sm text-foreground">{payload.steps.map((step) => <li key={step}>{step}</li>)}</ol><p className="rounded-lg bg-success/5 p-3 text-sm font-bold text-success">{payload.outcome}</p></div>;
}
