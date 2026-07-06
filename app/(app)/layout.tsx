"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/lib/auth/use-auth";
import { signOut } from "@/lib/auth/client";
import { useRouter } from "next/navigation";

const NAV_ITEMS = [
  { href: "/", label: "Beranda", icon: "🏠" },
  { href: "/learn", label: "Belajar", icon: "📚" },
  { href: "/trade", label: "Trading", icon: "📈" },
  { href: "/friends", label: "Teman", icon: "👥" },
  { href: "/library", label: "Pustaka", icon: "🔖" },
  { href: "/profile", label: "Profil", icon: "👤" },
];

export default function AppLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const { loading } = useAuth(true);

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
                  <span className="text-lg leading-none" aria-hidden="true">
                    {item.icon}
                  </span>
                  <span className="mt-1">{item.label}</span>
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>
    </div>
  );
}
