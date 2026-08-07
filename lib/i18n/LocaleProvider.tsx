"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import { supabase } from "@/lib/auth/client";
import { useAuth } from "@/lib/auth/use-auth";
import { dictionaries, type Dictionary } from "./dictionaries";
import type { Locale } from "./types";

export type TranslateFn = (key: string) => string;

interface LocaleContextValue {
  locale: Locale;
  setLocale: (locale: Locale) => void;
  t: TranslateFn;
}

function translate(locale: Locale, key: string): string {
  return dictionaries[locale][key as keyof Dictionary] ?? key;
}

// Default context lets components render outside a provider (e.g. unit tests)
// with the default "en" locale.
const LocaleContext = createContext<LocaleContextValue>({
  locale: "en",
  setLocale: () => {},
  t: (key) => translate("en", key),
});

export function LocaleProvider({ children }: { children: ReactNode }) {
  const { user } = useAuth(true);
  const [locale, setLocaleState] = useState<Locale>("en");

  useEffect(() => {
    if (!user) return;
    let mounted = true;

    const load = async () => {
      const { data, error } = await supabase
        .from("user_settings")
        .select("locale")
        .eq("user_id", user.id)
        .maybeSingle();
      if (!mounted || error) return;
      if (data?.locale === "en" || data?.locale === "id") {
        setLocaleState(data.locale);
      }
    };

    load();
    return () => {
      mounted = false;
    };
  }, [user]);

  const setLocale = useCallback(
    (next: Locale) => {
      setLocaleState(next);
      if (!user) return;

      supabase
        .from("user_settings")
        .upsert(
          {
            user_id: user.id,
            locale: next,
            updated_at: new Date().toISOString(),
          },
          { onConflict: "user_id" }
        )
        .then(({ error }) => {
          if (error) {
            console.error("setLocale error:", error.message);
          }
        });
    },
    [user]
  );

  const t = useCallback<TranslateFn>((key) => translate(locale, key), [locale]);

  const value = useMemo(() => ({ locale, setLocale, t }), [locale, setLocale, t]);

  return <LocaleContext.Provider value={value}>{children}</LocaleContext.Provider>;
}

export function useLocale(): LocaleContextValue {
  return useContext(LocaleContext);
}
