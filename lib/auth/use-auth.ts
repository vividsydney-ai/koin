"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "./client";
import { getProfile, type Profile } from "@/lib/profile/client";
import type { User } from "@supabase/supabase-js";

const AUTH_TIMEOUT_MS = 8000;

export interface AuthState {
  user: User | null;
  profile: Profile | null;
  loading: boolean;
  error: string | null;
  retry: () => void;
}

export function useAuth(requireAuth = true): AuthState {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [retryCounter, setRetryCounter] = useState(0);

  const retry = () => {
    setError(null);
    setLoading(true);
    setRetryCounter((c) => c + 1);
  };

  useEffect(() => {
    let mounted = true;
    let timeoutId: ReturnType<typeof setTimeout> | null = null;

    const getUser = async () => {
      timeoutId = setTimeout(() => {
        if (!mounted) return;
        setError("We couldn't confirm your sign-in status. Please try again.");
        setLoading(false);
      }, AUTH_TIMEOUT_MS);

      const { data, error: authError } = await supabase.auth.getUser();
      if (!mounted) return;

      if (timeoutId) {
        clearTimeout(timeoutId);
        timeoutId = null;
      }

      if (authError || !data.user) {
        setUser(null);
        if (requireAuth) {
          router.replace("/login");
        }
        setLoading(false);
        return;
      }

      setUser(data.user);

      const userProfile = await getProfile(data.user.id);
      if (!mounted) return;
      setProfile(userProfile);

      if (requireAuth && userProfile && !userProfile.onboarding_completed) {
        router.replace("/onboarding");
        return;
      }

      setLoading(false);
    };

    getUser();

    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!mounted) return;
      setUser(session?.user ?? null);
      if (requireAuth && !session?.user) {
        router.replace("/login");
      }
    });

    return () => {
      mounted = false;
      if (timeoutId) clearTimeout(timeoutId);
      listener.subscription.unsubscribe();
    };
  }, [router, requireAuth, retryCounter]);

  return { user, profile, loading, error, retry };
}
