import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { Preferences } from "@capacitor/preferences";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

function isBrowser(): boolean {
  return typeof window !== "undefined";
}

// Custom storage adapter using Capacitor Preferences in the native app,
// falling back to no-op during SSR/SSG.
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

export const supabase: SupabaseClient = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: capacitorStorage,
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
