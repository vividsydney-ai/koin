"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import { signOut } from "@/lib/auth/client";
import { useRouter } from "next/navigation";
import { NotificationBell } from "@/components/NotificationsSheet";
import { LocaleProvider, useLocale } from "@/lib/i18n/LocaleProvider";
import { GradientIcon, type GradientIconName } from "@/components/GradientIcon";

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
  const { user, loading } = useAuth(true);
  const { t } = useLocale();

  const handleSignOut = async () => {
    await signOut();
    router.push("/login");
  };

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-primary border-t-transparent" aria-label="Memuat" />
      </div>
    );
  }

  return (
    <div className="flex min-h-screen flex-col bg-background">
      <header className="sticky top-0 z-30 border-b border-border bg-background/95 px-4 py-3 backdrop-blur-md">
        <div className="mx-auto flex max-w-md items-center justify-between">
          <span className="text-xl font-bold tracking-tight text-foreground">Koin</span>
          {user && <NotificationBell userId={user.id} />}
        </div>
      </header>

      <main className="flex-1 pb-24">{children}</main>

      <nav className="fixed bottom-0 left-0 right-0 border-t border-border bg-surface">
        <ul className="mx-auto flex max-w-md justify-around">
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
                      ? "font-semibold text-primary"
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
