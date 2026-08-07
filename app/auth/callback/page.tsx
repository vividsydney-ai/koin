"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/auth/client";
import { trackEvent } from "@/lib/analytics/client";

export default function AuthCallbackPage() {
  const router = useRouter();

  useEffect(() => {
    let subscription: { unsubscribe: () => void } | null = null;

    const finishSignIn = () => {
      // Onboarding page will redirect away if the user has already completed onboarding.
      router.replace("/onboarding");
    };

    const trackLogin = async () => {
      const { data } = await supabase.auth.getUser();
      if (data.user) {
        trackEvent({ userId: data.user.id, name: "login", properties: { method: "email_callback" } });
      }
    };

    const handleCallback = async () => {
      const search = window.location.search;
      const hash = window.location.hash;

      // OAuth PKCE flow returns a ?code=... query parameter.
      if (search.includes("code=")) {
        console.log("OAuth callback triggered", search);
        const { data, error } = await supabase.auth.exchangeCodeForSession(search);
        if (error) {
          console.error("OAuth callback error:", error.message);
          router.replace(`/login?error=oauth&message=${encodeURIComponent(error.message)}`);
          return;
        }
        if (data.session?.user) {
          trackEvent({ userId: data.session.user.id, name: "login", properties: { method: "oauth" } });
        }
        finishSignIn();
        return;
      }

      // Email confirmation / magic links carry the token in the URL hash.
      // detectSessionInUrl is enabled in lib/auth/client.ts, so the client will
      // automatically process the hash and emit a SIGNED_IN event.
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (session) {
        await trackLogin();
        finishSignIn();
        return;
      }

      const { data } = supabase.auth.onAuthStateChange((event) => {
        if (event === "SIGNED_IN") {
          trackLogin().catch(() => {});
          finishSignIn();
        }
      });
      subscription = data.subscription;
    };

    handleCallback();

    return () => {
      subscription?.unsubscribe();
    };
  }, [router]);

  return (
    <main className="flex min-h-screen items-center justify-center bg-background">
      <p className="text-foreground">Completing sign in...</p>
    </main>
  );
}
