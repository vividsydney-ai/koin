"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { signInWithEmail, resendSignupEmail } from "@/lib/auth/client";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [showResend, setShowResend] = useState(false);

  const handleEmailLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setInfo(null);
    setShowResend(false);

    const { error } = await signInWithEmail(email, password);
    setLoading(false);

    if (error) {
      const message = error.message || "";
      setError(message);
      if (message.toLowerCase().includes("email not confirmed")) {
        setShowResend(true);
      }
      return;
    }

    router.push("/");
  };

  const handleResend = async () => {
    setLoading(true);
    setError(null);
    setInfo(null);

    const { error } = await resendSignupEmail(email);
    setLoading(false);

    if (error) {
      setError(error.message);
      return;
    }

    setInfo("Verification email resent. Check your inbox and spam folder.");
  };

  return (
    <main className="flex min-h-screen flex-col justify-center bg-background p-6">
      <div className="mx-auto w-full max-w-sm rounded-2xl border border-border/60 bg-surface p-6 shadow-sm">
        <div className="mb-6 text-center">
          <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-xl bg-primary text-2xl font-bold text-white shadow-sm">
            K
          </div>
          <h1 className="font-display text-2xl font-bold tracking-tight text-foreground">
            Sign in to Koinaku
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Continue your financial literacy journey.
          </p>
        </div>

        {error && (
          <p className="mb-4 rounded-lg border border-danger/20 bg-danger/5 p-3 text-sm text-danger">
            {error}
          </p>
        )}

        {info && (
          <p className="mb-4 rounded-radius-md bg-success/10 p-3 text-sm text-success">
            {info}
          </p>
        )}

        <form onSubmit={handleEmailLogin} className="space-y-4">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-foreground">
              Email
            </label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              placeholder="you@example.com"
              className="mt-2 h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
            />
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-foreground">
              Password
            </label>
            <input
              id="password"
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              placeholder="••••••••"
              className="mt-2 h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="mt-2 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md active:translate-y-0 active:scale-[0.98] disabled:translate-y-0 disabled:scale-100 disabled:cursor-not-allowed disabled:bg-primary-200 disabled:text-primary-400 disabled:shadow-none"
          >
            {loading ? "Signing in..." : "Sign in"}
          </button>

          {showResend && (
            <button
              type="button"
              onClick={handleResend}
              disabled={loading}
              className="inline-flex h-12 w-full items-center justify-center rounded-full border-[1.5px] border-border bg-surface px-6 text-sm font-semibold text-foreground transition-all hover:bg-surface-raised disabled:opacity-50"
            >
              {loading ? "Resending..." : "Resend verification email"}
            </button>
          )}
        </form>

        <p className="mt-6 text-center text-sm text-muted-foreground">
          Don&apos;t have an account?{" "}
          <Link href="/signup" className="font-semibold text-primary hover:underline">
            Sign up
          </Link>
        </p>
      </div>
    </main>
  );
}
