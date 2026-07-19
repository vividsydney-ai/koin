import Link from "next/link";
import { useLocale } from "@/lib/i18n/LocaleProvider";

export function Footer() {
  const { locale } = useLocale();
  const termsHref = locale === "id" ? "/terms/id" : "/terms";
  const privacyHref = locale === "id" ? "/privacy/id" : "/privacy";

  return (
    <footer className="border-t border-border bg-surface py-8 text-center text-xs text-muted-foreground">
      <p className="font-display text-sm font-semibold text-foreground">Koinaku</p>
      <p className="mt-1">Financial literacy, one lesson at a time.</p>
      <nav className="mt-4 flex items-center justify-center gap-4">
        <Link href={termsHref} className="hover:text-foreground hover:underline">
          Terms of Service
        </Link>
        <span aria-hidden="true">·</span>
        <Link href={privacyHref} className="hover:text-foreground hover:underline">
          Privacy Policy
        </Link>
      </nav>
      <p className="mt-4">© {new Date().getFullYear()} Vivid Savitri-Hampton trading as Koinaku.</p>
    </footer>
  );
}
