"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { signUpWithEmail, signInWithGoogle, resendSignupEmail } from "@/lib/auth/client";

export default function SignupPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);

  const handleEmailSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setInfo(null);

    const { data, error } = await signUpWithEmail(email, password);
    setLoading(false);

    if (error) {
      setError(error.message);
      return;
    }

    // If a session is returned, email confirmation is disabled and the user is already signed in.
    if (data?.session) {
      router.push("/onboarding");
      return;
    }

    // Otherwise, the user must confirm their email before continuing.
    setEmailSent(true);
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

    setInfo("Verification email resent. Check your inbox.");
  };

  const handleGoogleLogin = async () => {
    setLoading(true);
    const { error } = await signInWithGoogle();
    setLoading(false);
    if (error) {
      setError(error.message);
    }
  };

  return (
    <main className="flex min-h-screen items-center justify-center bg-background p-6">
      <div className="w-full max-w-sm space-y-6 rounded-radius-lg bg-surface p-6 shadow-sm">
        <h1 className="text-2xl font-display font-bold text-foreground">Create your Koin account</h1>

        {error && (
          <p className="rounded-radius-md bg-danger/10 p-3 text-sm text-danger">{error}</p>
        )}

        {info && (
          <p className="rounded-radius-md bg-success/10 p-3 text-sm text-success">{info}</p>
        )}

        {!emailSent ? (
          <>
            <form onSubmit={handleEmailSignup} className="space-y-4">
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
                  className="mt-1 w-full rounded-radius-md border border-muted bg-background px-3 py-2 text-foreground"
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
                  minLength={6}
                  className="mt-1 w-full rounded-radius-md border border-muted bg-background px-3 py-2 text-foreground"
                />
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full touch-target rounded-radius-md bg-primary px-4 py-3 font-medium text-primary-foreground disabled:opacity-50"
              >
                {loading ? "Creating account..." : "Create account"}
              </button>
            </form>

            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-muted" />
              </div>
              <div className="relative flex justify-center text-xs">
                <span className="bg-surface px-2 text-muted-foreground">or</span>
              </div>
            </div>

            <button
              onClick={handleGoogleLogin}
              disabled={loading}
              className="w-full touch-target rounded-radius-md border border-muted bg-surface px-4 py-3 font-medium text-foreground disabled:opacity-50"
            >
              Continue with Google
            </button>

            <p className="text-center text-sm text-muted-foreground">
              Already have an account?{" "}
              <Link href="/login" className="text-primary">
                Sign in
              </Link>
            </p>
          </>
        ) : (
          <div className="space-y-4 text-center">
            <p className="text-foreground">
              We sent a verification email to <strong>{email}</strong>. Click the link inside to
              continue.
            </p>
            <button
              onClick={handleResend}
              disabled={loading}
              className="w-full touch-target rounded-radius-md border border-muted bg-surface px-4 py-3 font-medium text-foreground disabled:opacity-50"
            >
              {loading ? "Resending..." : "Resend verification email"}
            </button>
            <p className="text-sm text-muted-foreground">
              Already verified?{" "}
              <Link href="/login" className="text-primary">
                Sign in
              </Link>
            </p>
          </div>
        )}
      </div>
    </main>
  );
}
