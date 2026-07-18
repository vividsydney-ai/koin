"use client";

import { toneTint } from "./StatCard";

export interface FilterChipOption {
  value: string;
  label: string;
}

export interface FilterChipGroupProps {
  /** Visible group label, also used as the group's accessible name. */
  label: string;
  /** Currently selected value; "" means the "All" chip is active. */
  value: string;
  options: FilterChipOption[];
  onChange: (value: string) => void;
  /** Label for the clearing chip; defaults to "All". */
  allLabel?: string;
}

export function FilterChipGroup({
  label,
  value,
  options,
  onChange,
  allLabel = "All",
}: FilterChipGroupProps) {
  return (
    <div>
      <p className="mb-1.5 text-xs font-medium text-muted-foreground">{label}</p>
      <div role="group" aria-label={label} className="flex flex-wrap gap-2">
        <FilterChip active={value === ""} onClick={() => onChange("")}>
          {allLabel}
        </FilterChip>
        {options.map((option) => (
          <FilterChip
            key={option.value}
            active={value === option.value}
            onClick={() => onChange(option.value)}
          >
            {option.label}
          </FilterChip>
        ))}
      </div>
    </div>
  );
}

function FilterChip({
  active,
  onClick,
  children,
}: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      aria-pressed={active}
      onClick={onClick}
      style={active ? { background: toneTint("primary", 12) } : undefined}
      className={`min-h-[44px] rounded-full border px-4 text-sm font-semibold transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary/40 ${
        active
          ? "border-primary/40 text-primary"
          : "border-muted bg-surface text-muted-foreground hover:text-foreground"
      }`}
    >
      {children}
    </button>
  );
}

export interface FilterChipsProps {
  groups: FilterChipGroupProps[];
  className?: string;
}

export function FilterChips({ groups, className }: FilterChipsProps) {
  return (
    <div className={`space-y-3 ${className ?? ""}`}>
      {groups.map((group) => (
        <FilterChipGroup key={group.label} {...group} />
      ))}
    </div>
  );
}
