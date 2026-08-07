import type { ReactNode } from "react";

export type GradientIconName =
  | "home"
  | "learn"
  | "trade"
  | "friends"
  | "library"
  | "profile";

const ICON_PATHS: Record<GradientIconName, ReactNode> = {
  home: (
    <>
      <path d="M3 10.5 12 3l9 7.5" />
      <path d="M5 9.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5" />
    </>
  ),
  learn: (
    <>
      <path d="M12 6c-2-1.5-4.5-2-8-2v14c3.5 0 6 .5 8 2 2-1.5 4.5-2 8-2V4c-3.5 0-6 .5-8 2Z" />
      <path d="M12 6v14" />
    </>
  ),
  trade: (
    <>
      <path d="M3 17l6-6 4 4 8-8" />
      <path d="M15 7h6v6" />
    </>
  ),
  friends: (
    <>
      <circle cx="9" cy="8" r="3.5" />
      <path d="M3.5 20c.5-3.5 2.8-5.5 5.5-5.5s5 2 5.5 5.5" />
      <circle cx="17" cy="9" r="2.5" />
      <path d="M15.9 14.6c2.7.2 4.1 2 4.6 5.4" />
    </>
  ),
  library: (
    <path d="M6 3h12a1 1 0 0 1 1 1v17l-7-4-7 4V4a1 1 0 0 1 1-1Z" />
  ),
  profile: (
    <>
      <circle cx="12" cy="8" r="4" />
      <path d="M4 21c1-4 4-6 8-6s7 2 8 6" />
    </>
  ),
};

export interface GradientIconProps {
  icon: GradientIconName;
  active?: boolean;
  size?: number;
  className?: string;
}

export function GradientIcon({
  icon,
  active = false,
  size = 22,
  className,
}: GradientIconProps) {
  if (!active) {
    // Color is inherited from the parent (text-muted-foreground).
    return (
      <svg
        width={size}
        height={size}
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth={2}
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden="true"
        focusable="false"
        className={className}
      >
        {ICON_PATHS[icon]}
      </svg>
    );
  }

  return (
    <span className="inline-flex items-center justify-center rounded-md bg-primary/10 p-1.5">
      <svg
        width={size}
        height={size}
        viewBox="0 0 24 24"
        fill="none"
        stroke="url(#koinaku-icon-gradient)"
        strokeWidth={2}
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden="true"
        focusable="false"
        className={className}
      >
        <defs>
          <linearGradient
            id="koinaku-icon-gradient"
            x1="0"
            y1="0"
            x2="24"
            y2="24"
            gradientUnits="userSpaceOnUse"
          >
            <stop offset="0%" stopColor="#6b4cfa" />
            <stop offset="33%" stopColor="#893da7" />
            <stop offset="66%" stopColor="#a62e55" />
            <stop offset="100%" stopColor="#c41f02" />
          </linearGradient>
        </defs>
        {ICON_PATHS[icon]}
      </svg>
    </span>
  );
}
