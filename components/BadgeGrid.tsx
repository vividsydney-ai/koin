import { toneTint } from "./StatCard";
import { useLocale } from "@/lib/i18n/LocaleProvider";

export interface BadgeGridItem {
  slug: string;
  name: string;
  description?: string | null;
  icon: string;
}

export interface BadgeGridProps {
  /** Earned badges — the only ones the data source returns. */
  badges: BadgeGridItem[];
  /** Grid is padded with muted locked slots up to this many tiles. */
  minSlots?: number;
}

export function BadgeGrid({ badges, minSlots = 8 }: BadgeGridProps) {
  const { t } = useLocale();
  const lockedCount = Math.max(0, minSlots - badges.length);

  return (
    <div className="grid grid-cols-2 gap-3">
      {badges.map((badge) => (
        <div
          key={badge.slug}
          className="rounded-card border border-border/60 bg-surface p-3 shadow-sm"
        >
          <span
            aria-hidden="true"
            className="flex h-10 w-10 items-center justify-center rounded-full text-xl"
            style={{ background: toneTint("koin-points") }}
          >
            {badge.icon}
          </span>
          <p className="mt-2 text-sm font-semibold leading-snug text-foreground">
            {badge.name}
          </p>
          {badge.description && (
            <p className="mt-0.5 text-xs leading-snug text-muted-foreground">
              {badge.description}
            </p>
          )}
        </div>
      ))}
      {Array.from({ length: lockedCount }, (_, i) => (
        <div
          key={`locked-${i}`}
          aria-hidden="true"
          className="rounded-card border border-dashed border-border bg-surface-inset p-3 opacity-70"
        >
          <span className="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-xl grayscale">
            🔒
          </span>
          <p className="mt-2 text-sm font-semibold leading-snug text-muted-foreground">
            {t("profile.locked")}
          </p>
          <p className="mt-0.5 text-xs leading-snug text-muted-foreground">
            {t("profile.keepLearning")}
          </p>
        </div>
      ))}
    </div>
  );
}
