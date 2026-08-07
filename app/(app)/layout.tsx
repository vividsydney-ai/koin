"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import { signOut } from "@/lib/auth/client";
import { useRouter } from "next/navigation";
import { NotificationBell } from "@/components/NotificationsSheet";
import { LocaleProvider, useLocale } from "@/lib/i18n/LocaleProvider";
import { GradientIcon, type GradientIconName } from "@/components/GradientIcon";
import { Footer } from "@/components/Footer";

const NAV_ITEMS: { href: string; labelKey: string; icon: GradientIconName }[] = [
  { href: "/", labelKey: "nav.home", icon: "home" },
  { href: "/learn", labelKey: "nav.learn", icon: "learn" },
  { href: "/trade", labelKey: "nav.trade", icon: "trade" },
  { href: "/friends", labelKey: "nav.friends", icon: "friends" },
  { href: "/library", labelKey: "nav.library", icon: "library" },
  { href: "/profile", labelKey: "nav.profile", icon: "profile" },
];

export default function AppLayout({ children }: { children: React.ReactNode }) {
  return (
    <LocaleProvider>
      <AppShell>{children}</AppShell>
    </LocaleProvider>
  );
}

function AppShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const { user, loading, error, retry } = useAuth(true);
  const { t } = useLocale();

  const handleSignOut = async () => {
    await signOut();
    router.push("/login");
  };

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" aria-label={t("auth.loading")} />
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center bg-background p-6 text-center">
        <h1 className="text-xl font-bold text-foreground">{t("auth.loadingErrorTitle")}</h1>
        <p className="mt-2 text-sm text-muted-foreground">{error}</p>
        <div className="mt-6 flex w-full max-w-xs flex-col gap-3">
          <button
            onClick={retry}
            className="rounded-full bg-primary px-6 py-3 text-sm font-semibold text-white shadow-sm transition-all hover:-translate-y-0.5 hover:bg-primary-400 hover:shadow-md active:translate-y-0 active:scale-[0.98]"
          >
            {t("auth.retry")}
          </button>
          <button
            onClick={() => router.push("/login")}
            className="rounded-full border-[1.5px] border-border bg-surface px-6 py-3 text-sm font-semibold text-foreground transition-all hover:bg-surface-raised"
          >
            {t("auth.goToSignIn")}
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen flex-col bg-background">
      <header className="sticky top-0 z-30 border-b border-border bg-background/95 px-4 py-3 backdrop-blur-md sm:px-6 lg:px-8">
        <div className="mx-auto flex w-full max-w-md items-center justify-between sm:max-w-2xl lg:max-w-4xl xl:max-w-7xl 2xl:max-w-[1440px]">
          <span className="font-display text-xl font-bold tracking-tight text-foreground">Koinaku</span>
          {user && <NotificationBell userId={user.id} />}
        </div>
      </header>

      <main className="mx-auto w-full max-w-md flex-1 pb-[calc(6rem+env(safe-area-inset-bottom))] sm:max-w-2xl lg:max-w-4xl xl:max-w-7xl 2xl:max-w-[1440px]">{children}</main>

      <Footer />

      <nav className="fixed bottom-0 left-0 right-0 z-50 border-t border-border bg-surface/95 pb-[env(safe-area-inset-bottom)] shadow-[0_-4px_16px_rgba(31,35,40,0.06)] backdrop-blur-md">
        <ul className="mx-auto flex w-full max-w-md justify-around sm:max-w-2xl lg:max-w-4xl xl:max-w-7xl 2xl:max-w-[1440px]">
          {NAV_ITEMS.map((item) => {
            const isActive =
              item.href === "/"
                ? pathname === "/"
                : pathname === item.href || pathname.startsWith(`${item.href}/`);
            return (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={`flex min-h-[44px] min-w-[44px] flex-col items-center justify-center px-2 py-1 text-xs transition-colors ${
                    isActive
                      ? "font-bold text-primary"
                      : "font-normal text-muted-foreground"
                  }`}
                  aria-current={isActive ? "page" : undefined}
                >
                  <GradientIcon icon={item.icon} active={isActive} />
                  <span className="mt-1">{t(item.labelKey)}</span>
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>
    </div>
  );
}
