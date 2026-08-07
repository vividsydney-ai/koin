import type { CSSProperties, ReactNode } from "react";

export type StatCardTone =
  | "streak"
  | "xp"
  | "koin-points"
  | "primary"
  | "success"
  | "danger"
  | "warning"
  | "info"
  | "neutral";

const TONE_COLOR: Record<StatCardTone, string> = {
  streak: "var(--color-streak)",
  xp: "var(--color-xp)",
  "koin-points": "var(--color-koin-points)",
  primary: "var(--color-primary)",
  success: "var(--color-success)",
  danger: "var(--color-danger)",
  warning: "var(--color-warning)",
  info: "var(--color-info)",
  neutral: "var(--color-muted-foreground)",
};

// Tinted surfaces must be built with color-mix against the surface token —
// never a raw -50 ramp token (see DESIGN.md "Tinted surfaces").
export function toneTint(tone: StatCardTone, percent = 8): string {
  return `color-mix(in srgb, ${TONE_COLOR[tone]} ${percent}%, var(--color-surface))`;
}

export interface StatCardProgress {
  /** 0–100; clamped internally. */
  percent: number;
  label?: ReactNode;
}

export interface StatCardProps {
  label: ReactNode;
  value: ReactNode;
  tone?: StatCardTone;
  /** Renders a tone-tinted icon tile on the right. Takes precedence over `aside`. */
  icon?: ReactNode;
  /** Small line under the value (status text, hint, delta). */
  sublabel?: ReactNode;
  /** Right-aligned extra content when no icon tile is shown. */
  aside?: ReactNode;
  progress?: StatCardProgress;
  /** "card" = bordered surface; "tile" = compact centered tone-tinted tile. */
  variant?: "card" | "tile";
  className?: string;
  children?: ReactNode;
}

export function StatCard({
  label,
  value,
  tone = "neutral",
  icon,
  sublabel,
  aside,
  progress,
  variant = "card",
  className,
  children,
}: StatCardProps) {
  const color = TONE_COLOR[tone];

  if (variant === "tile") {
    return (
      <div
        className={`rounded-lg p-4 text-center ${className ?? ""}`}
        style={{ background: toneTint(tone), color }}
      >
        <div className="text-xl font-bold">{value}</div>
        <div className="text-xs font-medium opacity-80">{label}</div>
      </div>
    );
  }

  const progressPercent = progress
    ? Math.min(100, Math.max(0, progress.percent))
    : 0;

  return (
    <div
      className={`rounded-card border border-border/60 bg-surface p-4 shadow-sm ${className ?? ""}`}
    >
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="text-[11px] font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            {label}
          </p>
          <p className="mt-1 break-words text-2xl font-bold leading-tight text-foreground">
            {value}
          </p>
          {sublabel}
        </div>
        {icon ? (
          <div
            className="flex h-14 w-14 shrink-0 items-center justify-center rounded-full text-2xl"
            style={{ background: toneTint(tone), color } as CSSProperties}
          >
            {icon}
          </div>
        ) : (
          aside
        )}
      </div>
      {children}
      {progress && (
        <div className="mt-3">
          {progress.label && (
            <p className="mb-1 text-xs text-muted-foreground">{progress.label}</p>
          )}
          <div
            role="progressbar"
            aria-valuenow={Math.round(progressPercent)}
            aria-valuemin={0}
            aria-valuemax={100}
            className="h-2 w-full overflow-hidden rounded-full bg-surface-inset"
          >
            <div
              className="h-full rounded-full transition-all"
              style={{ width: `${progressPercent}%`, background: color }}
            />
          </div>
        </div>
      )}
    </div>
  );
}
