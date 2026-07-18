import { createClient, type SupabaseClient, type User, type Session } from "@supabase/supabase-js";
import { Capacitor } from "@capacitor/core";
import { Preferences } from "@capacitor/preferences";
import { cookieStorage } from "./storage";
import { normalizeAuthError, type AuthError } from "./errors";
import { signInSchema, signUpSchema, resendEmailSchema } from "./schemas";
import { ok, err, type Result } from "@/lib/types/result";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

function isBrowser(): boolean {
  return typeof window !== "undefined";
}

function isNativePlatform(): boolean {
  return isBrowser() && Capacitor.isNativePlatform();
}

// Capacitor Preferences for iOS/Android; cookies for web.
// Cookies avoid localStorage (forbidden by project rules) while keeping
// the native path functional if the mobile branch is reactivated.
const capacitorStorage = {
  getItem: async (key: string): Promise<string | null> => {
    if (!isBrowser()) return null;
    const { value } = await Preferences.get({ key });
    return value;
  },
  setItem: async (key: string, value: string): Promise<void> => {
    if (!isBrowser()) return;
    await Preferences.set({ key, value });
  },
  removeItem: async (key: string): Promise<void> => {
    if (!isBrowser()) return;
    await Preferences.remove({ key });
  },
};

export const authStorage = isNativePlatform() ? capacitorStorage : cookieStorage;

export const supabase: SupabaseClient = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: authStorage,
    autoRefreshToken: isBrowser(),
    persistSession: isBrowser(),
    detectSessionInUrl: isBrowser(),
  },
});

export async function getCurrentUser(): Promise<Result<User, AuthError>> {
  const { data, error } = await supabase.auth.getUser();
  if (error) return err(normalizeAuthError(error));
  if (!data.user) return err({ code: "unknown", message: "No authenticated user." });
  return ok(data.user);
}

export async function getSession(): Promise<Result<Session, AuthError>> {
  const { data, error } = await supabase.auth.getSession();
  if (error) return err(normalizeAuthError(error));
  if (!data.session) return err({ code: "unknown", message: "No active session." });
  return ok(data.session);
}

export async function signInWithEmail(
  email: string,
  password: string,
  captchaToken?: string
): Promise<Result<Session, AuthError>> {
  const parsed = signInSchema.safeParse({ email, password });
  if (!parsed.success) {
    return err({ code: "invalid_email", message: parsed.error.issues[0].message });
  }

  const { data, error } = await supabase.auth.signInWithPassword({
    ...parsed.data,
    ...(captchaToken ? { captchaToken } : {}),
  });
  if (error) return err(normalizeAuthError(error));
  if (!data.session) return err({ code: "unknown", message: "Sign in succeeded but no session was returned." });
  return ok(data.session);
}

export async function signUpWithEmail(
  email: string,
  password: string,
  confirmPassword: string,
  displayName: string,
  captchaToken?: string
): Promise<Result<{ user: User | null; session: Session | null }, AuthError>> {
  const parsed = signUpSchema.safeParse({ email, password, confirmPassword, displayName });
  if (!parsed.success) {
    return err({ code: "invalid_email", message: parsed.error.issues[0].message });
  }

  const { data, error } = await supabase.auth.signUp({
    email: parsed.data.email,
    password: parsed.data.password,
    options: {
      data: { display_name: parsed.data.displayName },
      emailRedirectTo: `${process.env.NEXT_PUBLIC_APP_URL}/auth/callback`,
      // Only sent when the signup page rendered a captcha widget; Supabase
      // verifies it when captcha protection is enabled in Auth settings.
      ...(captchaToken ? { captchaToken } : {}),
    },
  });

  if (error) return err(normalizeAuthError(error));
  return ok({ user: data.user ?? null, session: data.session ?? null });
}

export async function resendSignupEmail(email: string): Promise<Result<null, AuthError>> {
  const parsed = resendEmailSchema.safeParse({ email });
  if (!parsed.success) {
    return err({ code: "invalid_email", message: parsed.error.issues[0].message });
  }

  const { error } = await supabase.auth.resend({
    type: "signup",
    email: parsed.data.email,
  });

  if (error) return err(normalizeAuthError(error));
  return ok(null);
}

export async function signOut(): Promise<Result<null, AuthError>> {
  const { error } = await supabase.auth.signOut();
  if (error) return err(normalizeAuthError(error));
  return ok(null);
}
