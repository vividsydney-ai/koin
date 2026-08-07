import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { dictionaries, type Dictionary } from "@/lib/i18n/dictionaries";

const maybeSingle = vi.fn();
const upsert = vi.fn().mockResolvedValue({ error: null });

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        eq: vi.fn(() => ({ maybeSingle })),
      })),
      upsert,
    })),
  },
}));

const useAuthMock = vi.fn();
vi.mock("@/lib/auth/use-auth", () => ({
  useAuth: (...args: unknown[]) => useAuthMock(...args),
}));

import { LocaleProvider, useLocale } from "@/lib/i18n/LocaleProvider";

function Probe() {
  const { locale, setLocale, t } = useLocale();
  return (
    <div>
      <span data-testid="locale">{locale}</span>
      <span data-testid="home">{t("nav.home")}</span>
      <span data-testid="missing">{t("missing.key")}</span>
      <button onClick={() => setLocale("id")}>switch</button>
    </div>
  );
}

function renderProbe() {
  return render(
    <LocaleProvider>
      <Probe />
    </LocaleProvider>
  );
}

describe("dictionaries", () => {
  it("en and id have identical key sets", () => {
    const enKeys = Object.keys(dictionaries.en).sort();
    const idKeys = Object.keys(dictionaries.id).sort();
    expect(enKeys).toEqual(idKeys);
    expect(enKeys.length).toBeGreaterThan(0);
  });

  it("every value is a non-empty string in both locales", () => {
    for (const locale of ["en", "id"] as const) {
      for (const [key, value] of Object.entries(dictionaries[locale])) {
        expect(typeof value, `${locale}.${key}`).toBe("string");
        expect(value.length, `${locale}.${key}`).toBeGreaterThan(0);
      }
    }
  });

  it("keys satisfy the Dictionary type", () => {
    const key: keyof Dictionary = "nav.home";
    expect(dictionaries.en[key]).toBe("Home");
    expect(dictionaries.id[key]).toBe("Beranda");
  });
});

describe("LocaleProvider", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    upsert.mockResolvedValue({ error: null });
  });

  it("defaults to en when there is no authenticated user", () => {
    useAuthMock.mockReturnValue({ user: null, loading: false });

    renderProbe();

    expect(screen.getByTestId("locale").textContent).toBe("en");
    expect(screen.getByTestId("home").textContent).toBe("Home");
    expect(maybeSingle).not.toHaveBeenCalled();
  });

  it("defaults to en when the user has no settings row", async () => {
    useAuthMock.mockReturnValue({ user: { id: "user-1" }, loading: false });
    maybeSingle.mockResolvedValue({ data: null, error: null });

    renderProbe();

    await waitFor(() => expect(maybeSingle).toHaveBeenCalled());
    expect(screen.getByTestId("locale").textContent).toBe("en");
  });

  it("loads the saved locale from user_settings", async () => {
    useAuthMock.mockReturnValue({ user: { id: "user-1" }, loading: false });
    maybeSingle.mockResolvedValue({ data: { locale: "id" }, error: null });

    renderProbe();

    await waitFor(() => expect(screen.getByTestId("locale").textContent).toBe("id"));
    expect(screen.getByTestId("home").textContent).toBe("Beranda");
  });

  it("t() returns the right string per locale and falls back to the key when missing", async () => {
    useAuthMock.mockReturnValue({ user: null, loading: false });

    renderProbe();

    expect(screen.getByTestId("home").textContent).toBe("Home");
    expect(screen.getByTestId("missing").textContent).toBe("missing.key");

    fireEvent.click(screen.getByText("switch"));

    await waitFor(() => expect(screen.getByTestId("locale").textContent).toBe("id"));
    expect(screen.getByTestId("home").textContent).toBe("Beranda");
    expect(screen.getByTestId("missing").textContent).toBe("missing.key");
  });

  it("setLocale updates immediately and upserts user_settings when authenticated", async () => {
    useAuthMock.mockReturnValue({ user: { id: "user-1" }, loading: false });
    maybeSingle.mockResolvedValue({ data: null, error: null });

    renderProbe();

    fireEvent.click(screen.getByText("switch"));

    expect(screen.getByTestId("locale").textContent).toBe("id");
    expect(upsert).toHaveBeenCalledWith(
      expect.objectContaining({ user_id: "user-1", locale: "id" }),
      { onConflict: "user_id" }
    );
  });
});
