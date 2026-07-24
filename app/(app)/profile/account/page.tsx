"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { signOut } from "@/lib/auth/client";
import { useLocale } from "@/lib/i18n/LocaleProvider";

function AccountRow({ href, label }: { href: string; label: string }) {
  return (
    <Link
      href={href}
      className="flex items-center justify-between rounded-lg border border-border bg-surface px-4 py-4 text-foreground transition-colors hover:bg-surface-raised"
    >
      <span className="text-base font-medium">{label}</span>
      <span aria-hidden="true" className="text-muted-foreground">→</span>
    </Link>
  );
}

export default function AccountPage() {
  const router = useRouter();
  const { t } = useLocale();

  const handleSignOut = async () => {
    await signOut();
    router.replace("/login");
  };

  return (
    <div className="p-5 pb-32 sm:p-6 lg:p-8">
      <div className="mb-6">
        <Link
          href="/profile"
          className="text-sm font-semibold text-primary hover:underline"
        >
          ← Back to profile
        </Link>
        <h1 className="mt-3 font-display text-2xl font-bold text-foreground">Account</h1>
        <p className="text-sm text-muted-foreground">Manage your account, password, and legal agreements.</p>
      </div>

      <div className="space-y-3">
        <AccountRow href="/profile/account/password" label="Change password" />
        <AccountRow href="/profile/account/terms" label="Terms of Service" />
        <AccountRow href="/profile/account/privacy" label="Privacy Policy" />
      </div>

      <button
        type="button"
        onClick={handleSignOut}
        className="mt-6 w-full rounded-lg border border-danger/30 bg-surface py-3 font-semibold text-danger transition-colors hover:bg-danger/5"
      >
        {t("profile.logout")}
      </button>
    </div>
  );
}
