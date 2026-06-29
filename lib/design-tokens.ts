// Koin design tokens
// Source of truth for colors, spacing, typography, and radius.
// Use these values in Tailwind config and components. No hardcoded colors in components.

export const colors = {
  // Brand
  primary: "#01696f", // Hydra Teal
  primaryForeground: "#ffffff",

  // Backgrounds
  background: "#f7f6f2", // warm neutral
  surface: "#ffffff",
  muted: "#f0efea",

  // Text
  foreground: "#1a1a1a",
  mutedForeground: "#6b6b6b",

  // Semantic
  success: "#16a34a",
  warning: "#f59e0b",
  danger: "#dc2626",
  info: "#2563eb",

  // Streaks / gamification accents
  streak: "#f97316",
  xp: "#01696f",
  koinPoints: "#eab308",
} as const;

export const spacing = {
  xs: "0.25rem", // 4px
  sm: "0.5rem", // 8px
  md: "1rem", // 16px
  lg: "1.5rem", // 24px
  xl: "2rem", // 32px
  "2xl": "3rem", // 48px
} as const;

export const radius = {
  sm: "0.25rem",
  DEFAULT: "0.5rem",
  md: "0.75rem",
  lg: "1rem",
  full: "9999px",
} as const;

export const typography = {
  fontFamily: {
    body: "Satoshi, ui-sans-serif, system-ui, sans-serif",
    display: "Cabinet Grotesk, ui-sans-serif, system-ui, sans-serif",
  },
  fontSize: {
    xs: "0.75rem",
    sm: "0.875rem",
    base: "1rem",
    lg: "1.125rem",
    xl: "1.25rem",
    "2xl": "1.5rem",
    "3xl": "1.875rem",
  },
} as const;

export const touchTargets = {
  min: "44px",
} as const;

// Tailwind v4 CSS variable injection helper
export function cssVariables(): string {
  return `
    :root {
      --color-primary: ${colors.primary};
      --color-primary-foreground: ${colors.primaryForeground};
      --color-background: ${colors.background};
      --color-surface: ${colors.surface};
      --color-muted: ${colors.muted};
      --color-foreground: ${colors.foreground};
      --color-muted-foreground: ${colors.mutedForeground};
      --color-success: ${colors.success};
      --color-warning: ${colors.warning};
      --color-danger: ${colors.danger};
      --color-info: ${colors.info};
      --color-streak: ${colors.streak};
      --color-xp: ${colors.xp};
      --color-koin-points: ${colors.koinPoints};
      --radius-default: ${radius.DEFAULT};
      --radius-md: ${radius.md};
      --radius-lg: ${radius.lg};
    }
  `;
}
