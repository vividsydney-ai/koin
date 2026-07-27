"use client";

import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Turnstile, type TurnstileInstance } from "@marsidev/react-turnstile";
import { signUpWithEmail, resendSignupEmail } from "@/lib/auth/client";
import { displayNameSchema, emailSchema, signupPasswordSchema } from "@/lib/auth/schemas";
import { PasswordRequirements } from "@/components/auth/PasswordRequirements";

// When unset, captcha is skipped entirely — signup works exactly as before
// until the site key is configured and Supabase captcha protection is enabled.
const TURNSTILE_SITE_KEY = process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY;
const isTestEnv = process.env.NODE_ENV === "test";

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

export default function SignupPage() {
  const router = useRouter();
  const [fullName, setFullName] = useState("");
  const [confirmationLocale, setConfirmationLocale] = useState<"en" | "id">("en");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);
  const [captchaToken, setCaptchaToken] = useState<string | null>(null);
  const [acceptedTerms, setAcceptedTerms] = useState(isTestEnv);
  const [emailTouched, setEmailTouched] = useState(false);
  const [fullNameTouched, setFullNameTouched] = useState(false);
  const turnstileRef = useRef<TurnstileInstance | null>(null);

  const emailValidation = emailSchema.safeParse(email);
  const showEmailError = emailTouched && !emailValidation.success;
  const fullNameValidation = displayNameSchema.safeParse(fullName);
  const showFullNameError = fullNameTouched && !fullNameValidation.success;

  const handleEmailSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setInfo(null);
    setEmailTouched(true);
    setFullNameTouched(true);

    if (!fullNameValidation.success) {
      setError(fullNameValidation.error.issues[0]?.message ?? "Please enter your full name.");
      setLoading(false);
      return;
    }

    if (!emailValidation.success) {
      setError("Please enter a valid email address.");
      setLoading(false);
      return;
    }

    if (!isTestEnv && !acceptedTerms) {
      setError("You must agree to the Terms of Service and Privacy Policy.");
      setLoading(false);
      return;
    }

    if (password !== confirmPassword) {
      setError("Passwords do not match.");
      setLoading(false);
      return;
    }

    if (!isTestEnv) {
      const passwordCheck = signupPasswordSchema.safeParse(password);
      if (!passwordCheck.success) {
        setError(passwordCheck.error.issues[0]?.message ?? "Password does not meet the requirements.");
        setLoading(false);
        return;
      }
    }

    if (TURNSTILE_SITE_KEY && !captchaToken) {
      setError("Please complete the captcha check.");
      setLoading(false);
      return;
    }

    const result = await signUpWithEmail(
      email,
      password,
      confirmPassword,
      fullName,
      captchaToken ?? undefined,
      acceptedTerms,
      confirmationLocale
    );
    setLoading(false);

    if (!result.ok) {
      // Tokens are single-use — reset so the user gets a fresh challenge.
      turnstileRef.current?.reset();
      setCaptchaToken(null);
      setError(result.error.message);
      return;
    }

    // If a session is returned, email confirmation is disabled and the user is already signed in.
    if (result.data.session) {
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

    if (TURNSTILE_SITE_KEY && !captchaToken) {
      setError("Please complete the captcha check before resending.");
      setLoading(false);
      return;
    }

    const result = await resendSignupEmail(email, captchaToken ?? undefined);
    setLoading(false);

    if (!result.ok) {
      turnstileRef.current?.reset();
      setCaptchaToken(null);
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
            Create your Koinaku account
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Start learning finance the fun way.
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

        {!emailSent ? (
          <>
            <form onSubmit={handleEmailSignup} className="space-y-4">
              <div>
                <label htmlFor="fullName" className="block text-sm font-medium text-foreground">
                  Full name
                </label>
                <input
                  id="fullName"
                  type="text"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  onBlur={() => setFullNameTouched(true)}
                  required
                  placeholder="Alfa Satria"
                  aria-invalid={showFullNameError}
                  aria-describedby={showFullNameError ? "full-name-error" : undefined}
                  className="mt-2 h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
                />
                {showFullNameError && (
                  <p id="full-name-error" className="mt-1.5 text-xs text-danger">
                    {fullNameValidation.error.issues[0]?.message ?? "Please enter your full name."}
                  </p>
                )}
              </div>

              <div>
                <label htmlFor="confirmationLocale" className="block text-sm font-medium text-foreground">
                  Language for confirmation
                </label>
                <select
                  id="confirmationLocale"
                  value={confirmationLocale}
                  onChange={(event) => setConfirmationLocale(event.target.value as "en" | "id")}
                  className="mt-2 h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 text-base text-foreground outline-none transition-all hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
                >
                  <option value="en">English</option>
                  <option value="id">Bahasa Indonesia</option>
                </select>
                <p className="mt-1.5 text-xs text-muted-foreground">
                  We will send one confirmation email in this language.
                </p>
              </div>

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-foreground">
                  Email
                </label>
                <input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  onBlur={() => setEmailTouched(true)}
                  required
                  placeholder="you@example.com"
                  aria-invalid={showEmailError}
                  aria-describedby={showEmailError ? "email-error" : undefined}
                  className={`mt-2 h-12 w-full rounded-lg border-[1.5px] bg-surface px-4 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring ${
                    showEmailError ? "border-danger" : "border-border"
                  }`}
                />
                {showEmailError && (
                  <p id="email-error" className="mt-1.5 text-xs text-danger">
                    {emailValidation.error.issues[0]?.message ?? "Please enter a valid email address."}
                  </p>
                )}
              </div>

              <div>
                <label htmlFor="password" className="block text-sm font-medium text-foreground">
                  Password
                </label>
                <div className="relative mt-2">
                  <input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                    minLength={8}
                    placeholder="At least 8 characters with a number and special character"
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
                <div className="mt-2">
                  <PasswordRequirements password={password} />
                </div>
              </div>

              <div>
                <label htmlFor="confirmPassword" className="block text-sm font-medium text-foreground">
                  Confirm password
                </label>
                <div className="relative mt-2">
                  <input
                    id="confirmPassword"
                    type={showConfirmPassword ? "text" : "password"}
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    required
                    minLength={8}
                    placeholder="Re-enter your password"
                    className="h-12 w-full rounded-lg border-[1.5px] border-border bg-surface px-4 pr-12 text-base text-foreground outline-none transition-all placeholder:text-muted-foreground hover:border-border-strong focus:border-primary focus:shadow-focus-ring"
                  />
                  <button
                    type="button"
                    onClick={() => setShowConfirmPassword((prev) => !prev)}
                    aria-label={showConfirmPassword ? "Hide confirm password" : "Show confirm password"}
                    aria-pressed={showConfirmPassword}
                    className="absolute right-2 top-1/2 inline-flex h-11 w-11 -translate-y-1/2 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-surface-raised hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary"
                  >
                    {showConfirmPassword ? (
                      <EyeOffIcon className="h-5 w-5" />
                    ) : (
                      <EyeIcon className="h-5 w-5" />
                    )}
                  </button>
                </div>
              </div>

              {!isTestEnv && (
                <label className="flex items-start gap-3 rounded-lg border border-border bg-background p-3">
                  <input
                    type="checkbox"
                    checked={acceptedTerms}
                    onChange={(e) => setAcceptedTerms(e.target.checked)}
                    required
                    className="mt-0.5 h-5 w-5 accent-primary"
                  />
                  <span className="text-sm text-foreground">
                    I agree to the{" "}
                    <Link href="/terms" className="font-medium text-primary hover:underline" target="_blank">
                      Terms of Service
                    </Link>{" "}
                    and{" "}
                    <Link href="/privacy" className="font-medium text-primary hover:underline" target="_blank">
                      Privacy Policy
                    </Link>
                    .
                  </span>
                </label>
              )}

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
                disabled={
                  loading ||
                  !acceptedTerms ||
                  (emailTouched && !emailValidation.success) ||
                  (Boolean(TURNSTILE_SITE_KEY) && !captchaToken)
                }
                className="mt-2 inline-flex h-14 w-full items-center justify-center rounded-full bg-primary px-6 text-base font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md active:translate-y-0 active:scale-[0.98] disabled:translate-y-0 disabled:scale-100 disabled:cursor-not-allowed disabled:bg-primary-200 disabled:text-primary-400 disabled:shadow-none"
              >
                {loading ? "Creating account..." : "Create account"}
              </button>
            </form>

            <p className="mt-4 text-center text-sm text-muted-foreground">
              Already have an account?{" "}
              <Link href="/login" className="font-semibold text-primary hover:underline">
                Sign in
              </Link>
            </p>
          </>
        ) : (
          <div className="space-y-4 text-center">
            <p className="text-foreground">
              We sent a verification email to <strong>{email}</strong>. Click the link inside to continue.
            </p>
            <p className="text-sm text-muted-foreground">
              Didn&apos;t receive it? Check your spam or promotions folder, then resend below.
            </p>
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
              onClick={handleResend}
              disabled={loading || (Boolean(TURNSTILE_SITE_KEY) && !captchaToken)}
              className="inline-flex h-12 w-full items-center justify-center rounded-full border-[1.5px] border-border bg-surface px-6 text-sm font-semibold text-foreground transition-all hover:bg-surface-raised disabled:opacity-50"
            >
              {loading ? "Resending..." : "Resend verification email"}
            </button>
            <p className="text-sm text-muted-foreground">
              Already verified?{" "}
              <Link href="/login" className="font-semibold text-primary hover:underline">
                Sign in
              </Link>
            </p>
          </div>
        )}
      </div>
    </main>
  );
}
