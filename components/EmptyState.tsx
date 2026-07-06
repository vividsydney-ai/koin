import Link from "next/link";

export interface EmptyStateAction {
  label: string;
  href?: string;
  onClick?: () => void;
}

export interface EmptyStateProps {
  icon: string;
  title: string;
  description: string;
  action?: EmptyStateAction;
}

export function EmptyState({ icon, title, description, action }: EmptyStateProps) {
  return (
    <div className="rounded-radius-lg border border-dashed border-muted bg-surface p-6 text-center">
      <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-muted/50 text-2xl">
        {icon}
      </div>
      <h2 className="mt-4 text-lg font-bold text-foreground">{title}</h2>
      <p className="mt-2 text-sm leading-relaxed text-muted-foreground">{description}</p>
      {action && (
        <div className="mt-4">
          {action.href ? (
            <Link
              href={action.href}
              className="inline-flex items-center justify-center rounded-radius-md bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground active:opacity-90 touch-target"
            >
              {action.label}
            </Link>
          ) : (
            <button
              onClick={action.onClick}
              className="inline-flex items-center justify-center rounded-radius-md bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground active:opacity-90 touch-target"
            >
              {action.label}
            </button>
          )}
        </div>
      )}
    </div>
  );
}
