// Koinaku design tokens
// Source of truth for colors, spacing, typography, and radius.
// Use these values in Tailwind config and components. No hardcoded colors in components.
// Canonical source for new tokens: koinaku-design-system-v4 (theme.css :root).
// Kept in sync with app/globals.css — run scripts/design-drift-check.sh after editing either file.

export const colors = {
  // Brand — Orbit Purple is primary. Red is reserved for danger/destructive
  // only — never reused as the primary action color.
  primary: "#6f4af0", // Orbit Purple 500
  primaryForeground: "#ffffff",

  secondary: "#0a6f90", // 50K blue
  secondaryForeground: "#ffffff",

  // Backgrounds
  background: "#faf8f5",
  backgroundWarm: "#f5f2ed",
  surface: "#ffffff",
  surfaceRaised: "#faf7f2",
  surfaceInset: "#f0ece5",
  muted: "#f0ece5",

  // Text
  foreground: "#171818",
  mutedForeground: "#737779",
  inverse: "#ffffff",

  // Semantic
  success: "#1e8a4c",
  warning: "#b8992e",
  danger: "#c41f26",
  info: "#0a6f90",
  accent: "#6b2d5c",

  // Gamification accents
  streak: "#b8992e",
  xp: "#0a6f90",
  koinPoints: "#b8992e",
} as const;

export const colorRamps = {
  red: {
    50: "#fdf0f1", 100: "#f9d5d7", 200: "#f2aeb1", 300: "#e97d82",
    400: "#d94e54", 500: "#c41f26", 600: "#a1191e", 700: "#7e1317",
    800: "#5c0d10", 900: "#3c080a", 950: "#1f0405",
  },
  blue: {
    50: "#eef5f9", 100: "#d2e5f0", 200: "#a8cfde", 300: "#78b3c9",
    400: "#3f90ad", 500: "#0a6f90", 600: "#085c78", 700: "#064a5f",
    800: "#043746", 900: "#03252f", 950: "#011419",
  },
  green: {
    50: "#f0f8f3", 100: "#d5ecdb", 200: "#abd9b7", 300: "#7bc28e",
    400: "#48a964", 500: "#1e8a4c", 600: "#18723e", 700: "#125a31",
    800: "#0d4224", 900: "#082c18", 950: "#04170c",
  },
  purple: {
    50: "#f4f0f3", 100: "#e6d9e2", 200: "#ccb5c5", 300: "#ad8ba4",
    400: "#8b5b7f", 500: "#6b2d5c", 600: "#5a264d", 700: "#481f3e",
    800: "#36172f", 900: "#251020", 950: "#140812",
  },
  brown: {
    50: "#f5f2f0", 100: "#ebe4dd", 200: "#d9cbbb", 300: "#c3ad95",
    400: "#aa8c6b", 500: "#8e6e4b", 600: "#745a3e", 700: "#5b4731",
    800: "#423324", 900: "#2b2117", 950: "#17120c",
  },
  grey: {
    50: "#f7f7f7", 100: "#ececed", 200: "#dbdcdd", 300: "#c4c6c7",
    400: "#a8abac", 500: "#8d9193", 600: "#737779", 700: "#5a5d5f",
    800: "#424445", 900: "#2c2d2e", 950: "#171818",
  },
  gold: {
    50: "#faf7ef", 100: "#f4ecd8", 200: "#e9d9b2", 300: "#dbc388",
    400: "#cbab59", 500: "#b8992e", 600: "#997e26", 700: "#7a641e",
    800: "#5a4a16", 900: "#3e3517", 950: "#231e0d",
  },
  orbit: {
    50: "#f5f1ff", 100: "#ebe3ff", 200: "#d9caff", 300: "#bda5ff",
    400: "#9b78fb", 500: "#6f4af0", 600: "#5b38ce", 700: "#45308f",
    800: "#31245e", 900: "#1f1937", 950: "#100b24",
  },
} as const;

export const spacing = {
  0: "0",
  1: "0.25rem", // 4px
  2: "0.5rem", // 8px
  3: "0.75rem", // 12px
  4: "1rem", // 16px
  5: "1.25rem", // 20px
  6: "1.5rem", // 24px
  8: "2rem", // 32px
  10: "2.5rem", // 40px
  12: "3rem", // 48px
  16: "4rem", // 64px
  20: "5rem", // 80px
  24: "6rem", // 96px
  32: "8rem", // 128px
  40: "10rem", // 160px
} as const;

export const radius = {
  none: "0",
  sm: "0.25rem",
  md: "0.5rem",
  DEFAULT: "0.5rem",
  lg: "0.75rem",
  xl: "1rem",
  card: "1.125rem", // 18px — dedicated card radius, sits between xl and 2xl
  "2xl": "1.5rem",
  "3xl": "2rem",
  full: "9999px",
} as const;

export const typography = {
  fontFamily: {
    body: "Satoshi, ui-sans-serif, system-ui, sans-serif",
    display: "Cabinet Grotesk, ui-sans-serif, system-ui, sans-serif",
    mono: "ui-monospace, SFMono-Regular, 'SF Mono', Menlo, Consolas, monospace",
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

export const easing = {
  outQuart: "cubic-bezier(0.25, 1, 0.5, 1)",
  outExpo: "cubic-bezier(0.16, 1, 0.3, 1)",
  spring: "cubic-bezier(0.34, 1.56, 0.64, 1)",
} as const;

export const shadows = {
  sm: "0 1px 3px rgba(23, 24, 24, 0.08), 0 1px 2px rgba(23, 24, 24, 0.04)",
  md: "0 4px 12px rgba(23, 24, 24, 0.10), 0 2px 4px rgba(23, 24, 24, 0.06)",
  lg: "0 12px 32px rgba(23, 24, 24, 0.14), 0 4px 8px rgba(23, 24, 24, 0.08)",
  lift: "0 24px 56px rgba(69, 48, 143, 0.22)", // modals, sheets, dialogs — tinted to primary
  focusRing: "0 0 0 3px rgba(111, 74, 240, 0.28)",
} as const;

// Brand gradient — wordmark sweep, icon/illustration use only. Never gradient text.
export const gradients = {
  brand: "linear-gradient(135deg, #6b4cfa 0%, #893da7 35%, #a62e55 68%, #c41f02 100%)",
} as const;

// Z-index scale — every stacked layer pulls from here, never an arbitrary number
export const zIndex = {
  dropdown: 10,
  sticky: 20,
  drawer: 30,
  modalBackdrop: 35,
  modal: 40,
  toast: 50,
  tooltip: 60,
} as const;

// Tailwind v4 CSS variable injection helper
export function cssVariables(): string {
  return `
    :root {
      --color-primary: ${colors.primary};
      --color-primary-foreground: ${colors.primaryForeground};
      --color-secondary: ${colors.secondary};
      --color-secondary-foreground: ${colors.secondaryForeground};
      --color-background: ${colors.background};
      --color-background-warm: ${colors.backgroundWarm};
      --color-surface: ${colors.surface};
      --color-surface-raised: ${colors.surfaceRaised};
      --color-surface-inset: ${colors.surfaceInset};
      --color-muted: ${colors.muted};
      --color-foreground: ${colors.foreground};
      --color-muted-foreground: ${colors.mutedForeground};
      --color-success: ${colors.success};
      --color-warning: ${colors.warning};
      --color-danger: ${colors.danger};
      --color-info: ${colors.info};
      --color-accent: ${colors.accent};
      --color-streak: ${colors.streak};
      --color-xp: ${colors.xp};
      --color-koin-points: ${colors.koinPoints};
      --radius-default: ${radius.DEFAULT};
      --radius-md: ${radius.md};
      --radius-lg: ${radius.lg};
      --radius-xl: ${radius.xl};
      --radius-card: ${radius.card};
      --radius-full: ${radius.full};
      --shadow-lift: ${shadows.lift};
      --gradient-brand: ${gradients.brand};
      --z-dropdown: ${zIndex.dropdown};
      --z-sticky: ${zIndex.sticky};
      --z-drawer: ${zIndex.drawer};
      --z-modal-backdrop: ${zIndex.modalBackdrop};
      --z-modal: ${zIndex.modal};
      --z-toast: ${zIndex.toast};
      --z-tooltip: ${zIndex.tooltip};
    }
  `;
}
