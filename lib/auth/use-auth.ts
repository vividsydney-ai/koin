"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "./client";
import { getProfile, type Profile } from "@/lib/profile/client";
import type { User } from "@supabase/supabase-js";

export function useAuth(requireAuth = true) {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;

    const getUser = async () => {
      const { data, error } = await supabase.auth.getUser();
      if (!mounted) return;

      if (error || !data.user) {
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
      listener.subscription.unsubscribe();
    };
  }, [router, requireAuth]);

  return { user, profile, loading };
}
