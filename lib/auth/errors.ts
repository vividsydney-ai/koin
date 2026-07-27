/**
 * Normalized authentication errors.
 *
 * The UI should never receive raw Supabase errors. All auth failures are
 * mapped to a stable code and a human-readable message.
 */
export type AuthErrorCode =
  | "invalid_email"
  | "invalid_password"
  | "weak_password"
  | "passwords_do_not_match"
  | "user_already_exists"
  | "invalid_credentials"
  | "email_not_confirmed"
  | "rate_limit"
  | "captcha_failed"
  | "network_error"
  | "unknown";

export interface AuthError {
  code: AuthErrorCode;
  message: string;
}

/**
 * Map a Supabase Auth error message to a normalized AuthError.
 *
 * Supabase error messages are strings and can change between versions.
 * This function keeps the UI decoupled from those internals.
 */
export function normalizeAuthError(raw: { message?: string; status?: number }): AuthError {
  const message = raw.message ?? "";
  const lower = message.toLowerCase();

  if (raw.status === 429 || lower.includes("rate limit") || lower.includes("too many requests")) {
    return { code: "rate_limit", message: "Too many attempts. Please try again later." };
  }

  if (lower.includes("captcha") || lower.includes("request disallowed")) {
    return {
      code: "captcha_failed",
      message: "Human verification failed. Please complete the captcha and try again.",
    };
  }

  if (lower.includes("invalid login credentials")) {
    return { code: "invalid_credentials", message: "Invalid email or password." };
  }

  if (lower.includes("email not confirmed") || lower.includes("email confirmation")) {
    return { code: "email_not_confirmed", message: "Please confirm your email before signing in." };
  }

  if (lower.includes("user already registered") || lower.includes("already exists")) {
    return { code: "user_already_exists", message: "An account with this email already exists." };
  }

  if (lower.includes("weak_password") || lower.includes("password")) {
    return { code: "weak_password", message: "Password is too weak. Use at least 6 characters." };
  }

  if (lower.includes("network") || lower.includes("fetch")) {
    return { code: "network_error", message: "Network error. Please check your connection." };
  }

  return { code: "unknown", message: message || "Something went wrong. Please try again." };
}
