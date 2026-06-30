"use client";

import { useAuth } from "@/lib/auth/use-auth";
import { signOut } from "@/lib/auth/client";
import { useRouter } from "next/navigation";

export default function Home() {
  const { user, loading } = useAuth(true);
  const router = useRouter();

  const handleLogout = async () => {
    await signOut();
    router.push("/login");
  };

  if (loading) {
    return (
      <main className="flex min-h-screen items-center justify-center bg-background">
        <p className="text-foreground">Loading...</p>
      </main>
    );
  }

  return (
    <main className="flex min-h-screen flex-col items-center justify-center bg-background p-6">
      <div className="max-w-md space-y-6 text-center">
        <h1 className="text-3xl font-display font-bold text-foreground">Welcome to Koin</h1>
        <p className="text-muted-foreground">
          Signed in as <span className="text-foreground">{user?.email}</span>
        </p>
        <div className="space-y-3">
          <a
            href="/native-test"
            className="block w-full touch-target rounded-radius-md bg-primary px-4 py-3 font-medium text-primary-foreground"
          >
            Native Bridge Test
          </a>
          <button
            onClick={handleLogout}
            className="w-full touch-target rounded-radius-md border border-muted bg-surface px-4 py-3 font-medium text-foreground"
          >
            Sign out
          </button>
        </div>
      </div>
    </main>
  );
}
