"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/auth/client";
import { getProfile, completeOnboarding } from "@/lib/profile/client";

const AGE_RANGES = [
  { value: "under_16", label: "Under 16" },
  { value: "16_18", label: "16–18" },
  { value: "19_22", label: "19–22" },
  { value: "23_25", label: "23–25" },
  { value: "26_plus", label: "26+" },
];

const GOALS = [
  { value: "start_investing", label: "Start investing" },
  { value: "save_emergency", label: "Build an emergency fund" },
  { value: "avoid_scams", label: "Avoid money scams" },
  { value: "budget_better", label: "Budget better" },
  { value: "understand_stocks", label: "Understand stocks" },
];

export default function OnboardingPage() {
  const router = useRouter();
  const [userId, setUserId] = useState<string | null>(null);
  const [displayName, setDisplayName] = useState("");
  const [ageRange, setAgeRange] = useState("");
  const [financialGoal, setFinancialGoal] = useState("");
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    let mounted = true;

    const checkUser = async () => {
      const { data } = await supabase.auth.getUser();
      if (!mounted) return;

      if (!data.user) {
        router.replace("/login");
        return;
      }

      const profile = await getProfile(data.user.id);
      if (!mounted) return;

      if (profile?.onboarding_completed) {
        router.replace("/");
        return;
      }

      setUserId(data.user.id);
      setLoading(false);
    };

    checkUser();

    return () => {
      mounted = false;
    };
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!userId) return;

    setSubmitting(true);
    setError(null);

    const result = await completeOnboarding({
      userId,
      displayName: displayName.trim() || "Koin Learner",
      ageRange,
      financialGoal,
      notificationsEnabled,
    });

    setSubmitting(false);

    if (result.error) {
      setError(result.error);
      return;
    }

    router.push("/");
  };

  if (loading) {
    return (
      <main className="flex min-h-screen items-center justify-center bg-background">
        <p className="text-foreground">Loading...</p>
      </main>
    );
  }

  return (
    <main className="flex min-h-screen items-center justify-center bg-background p-6">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-sm space-y-6 rounded-radius-lg bg-surface p-6 shadow-sm"
      >
        <h1 className="text-2xl font-display font-bold text-foreground">Welcome to Koin</h1>
        <p className="text-sm text-muted-foreground">
          Tell us a bit about yourself so we can personalize your learning journey.
        </p>

        {error && (
          <p className="rounded-radius-md bg-danger/10 p-3 text-sm text-danger">{error}</p>
        )}

        <div className="space-y-4">
          <div>
            <label htmlFor="displayName" className="block text-sm font-medium text-foreground">
              What should we call you?
            </label>
            <input
              id="displayName"
              type="text"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              placeholder="Budi"
              required
              className="mt-1 w-full rounded-radius-md border border-muted bg-background px-3 py-2 text-foreground"
            />
          </div>

          <div>
            <label htmlFor="ageRange" className="block text-sm font-medium text-foreground">
              Age range
            </label>
            <select
              id="ageRange"
              value={ageRange}
              onChange={(e) => setAgeRange(e.target.value)}
              required
              className="mt-1 w-full rounded-radius-md border border-muted bg-background px-3 py-2 text-foreground"
            >
              <option value="" disabled>
                Select your age range
              </option>
              {AGE_RANGES.map((range) => (
                <option key={range.value} value={range.value}>
                  {range.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label htmlFor="financialGoal" className="block text-sm font-medium text-foreground">
              Main financial goal
            </label>
            <select
              id="financialGoal"
              value={financialGoal}
              onChange={(e) => setFinancialGoal(e.target.value)}
              required
              className="mt-1 w-full rounded-radius-md border border-muted bg-background px-3 py-2 text-foreground"
            >
              <option value="" disabled>
                Select a goal
              </option>
              {GOALS.map((goal) => (
                <option key={goal.value} value={goal.value}>
                  {goal.label}
                </option>
              ))}
            </select>
          </div>

          <label className="flex items-center gap-3">
            <input
              type="checkbox"
              checked={notificationsEnabled}
              onChange={(e) => setNotificationsEnabled(e.target.checked)}
              className="h-5 w-5 rounded border-muted text-primary"
            />
            <span className="text-sm text-foreground">Send me daily streak reminders</span>
          </label>
        </div>

        <button
          type="submit"
          disabled={submitting}
          className="w-full touch-target rounded-radius-md bg-primary px-4 py-3 font-medium text-primary-foreground disabled:opacity-50"
        >
          {submitting ? "Saving..." : "Start learning"}
        </button>
      </form>
    </main>
  );
}
