import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { Capacitor } from "@capacitor/core";
import { Preferences } from "@capacitor/preferences";
import { cookieStorage } from "./storage";

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

export async function getCurrentUser() {
  const { data, error } = await supabase.auth.getUser();
  if (error) return null;
  return data.user;
}

export async function getSession() {
  const { data, error } = await supabase.auth.getSession();
  if (error) return null;
  return data.session;
}

export async function signInWithEmail(email: string, password: string) {
  return supabase.auth.signInWithPassword({ email, password });
}

export async function signUpWithEmail(email: string, password: string, metadata?: object) {
  return supabase.auth.signUp({ email, password, options: { data: metadata } });
}

export async function signInWithGoogle() {
  return supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: `${process.env.NEXT_PUBLIC_APP_URL}/auth/callback`,
    },
  });
}

export async function signOut() {
  return supabase.auth.signOut();
}
