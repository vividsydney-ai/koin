"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/auth/client";

export default function AuthCallbackPage() {
  const router = useRouter();

  useEffect(() => {
    const handleCallback = async () => {
      const search = window.location.search;
      console.log("OAuth callback triggered", search);
      const { data, error } = await supabase.auth.exchangeCodeForSession(search);
      if (error) {
        console.error("OAuth callback error:", error.message);
        router.replace(`/login?error=oauth&message=${encodeURIComponent(error.message)}`);
        return;
      }
      console.log("OAuth callback success", data.session ? "session set" : "no session");
      router.replace("/");
    };

    handleCallback();
  }, [router]);

  return (
    <main className="flex min-h-screen items-center justify-center bg-background">
      <p className="text-foreground">Completing sign in...</p>
    </main>
  );
}
