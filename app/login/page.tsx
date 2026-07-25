"use client";

import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Turnstile, type TurnstileInstance } from "@marsidev/react-turnstile";
import { signInWithEmail, resendSignupEmail } from "@/lib/auth/client";
import { trackEvent } from "@/lib/analytics/client";

function EyeIcon({ className }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7Z" />
      <circle cx="12" cy="12" r="3" />
    </svg>
  );
}

function EyeOffIcon({ className }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24" />
      <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68" />
      <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61" />
      <line x1="2" x2="22" y1="2" y2="22" />
    </svg>
  );
}

function ForgotPasswordLink() {
  return (
    <Link
      href="/forgot-password"
      className="text-xs font-medium text-primary hover:underline"
    >
      Forgot password?
    </Link>
  );
}

const TURNSTILE_SITE_KEY = process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY;

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [showResend, setShowResend] = useState(false);
  const [captchaToken, setCaptchaToken] = useState<string | null>(null);
  const turnstileRef = useRef<TurnstileInstance | null>(null);

  const handleEmailLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setInfo(null);
    setShowResend(false);

    if (TURNSTILE_SITE_KEY && !captchaToken) {
      setError("Please complete the captcha check.");
      setLoading(false);
      return;
    }

    const result = captchaToken
      ? await signInWithEmail(email, password, captchaToken)
      : await signInWithEmail(email, password);
    setLoading(false);

    if (!result.ok) {
      turnstileRef.current?.reset();
      setCaptchaToken(null);
      setError(result.error.message);
      if (result.error.code === "email_not_confirmed") {
        setShowResend(true);
      }
      return;
    }

    trackEvent({ userId: result.data.user.id, name: "login", properties: { method: "email" } });
    const deletionStatus = await fetch("/api/account-deletion/status");
    if (deletionStatus.ok && (await deletionStatus.json()).scheduledFor) {
      router.push("/reactivate");
      return;
    }
    router.push("/");
  };

  const handleResend = async () => {
    setLoading(true);
    setError(null);
    setInfo(null);

    const result = await resendSignupEmail(email);
    setLoading(false);

    if (!result.ok) {
      setError(result.error.message);
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
          <p className="mb-4 rounded-md bg-success/10 p-3 text-sm text-success">
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
            <div className="flex items-center justify-between">
              <label htmlFor="password" className="block text-sm font-medium text-foreground">
                Password
              </label>
              <ForgotPasswordLink />
            </div>
            <div className="relative mt-2">
              <input
                id="password"
                type={showPassword ? "text" : "password"}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                placeholder="••••••••"
                className="h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 pr-12 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
              />
              <button
                type="button"
                onClick={() => setShowPassword((prev) => !prev)}
                aria-label={showPassword ? "Hide password" : "Show password"}
                aria-pressed={showPassword}
                className="absolute right-2 top-1/2 inline-flex h-11 w-11 -translate-y-1/2 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-surface-raised hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary"
              >
                {showPassword ? (
                  <EyeOffIcon className="h-5 w-5" />
                ) : (
                  <EyeIcon className="h-5 w-5" />
                )}
              </button>
            </div>
          </div>

          {TURNSTILE_SITE_KEY && (
            <div className="flex justify-center pt-1">
              <Turnstile
                ref={turnstileRef}
                siteKey={TURNSTILE_SITE_KEY}
                onSuccess={(token) => setCaptchaToken(token)}
                onExpire={() => setCaptchaToken(null)}
                onError={() => setCaptchaToken(null)}
              />
            </div>
          )}

          <button
            type="submit"
            disabled={loading || (Boolean(TURNSTILE_SITE_KEY) && !captchaToken)}
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
