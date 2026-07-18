import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: pushMock }),
}));

const signUpWithEmailMock = vi
  .fn()
  .mockResolvedValue({ ok: true, data: { user: null, session: null } });
const resendSignupEmailMock = vi.fn().mockResolvedValue({ ok: true, data: null });

vi.mock("@/lib/auth/client", () => ({
  signUpWithEmail: (...args: unknown[]) => signUpWithEmailMock(...args),
  resendSignupEmail: (...args: unknown[]) => resendSignupEmailMock(...args),
}));

// Lightweight Turnstile stand-in: renders a marker and exposes a way to
// simulate a successful challenge. ref-as-prop works under React 19.
vi.mock("@marsidev/react-turnstile", () => ({
  Turnstile: ({ onSuccess }: { onSuccess?: (token: string) => void }) => (
    <button type="button" data-testid="turnstile-widget" onClick={() => onSuccess?.("token-123")}>
      captcha
    </button>
  ),
}));

async function importSignupPage() {
  const mod = await import("@/app/signup/page");
  return mod.default;
}

function fillForm() {
  fireEvent.change(screen.getByLabelText(/full name/i), { target: { value: "Budi Santoso" } });
  fireEvent.change(screen.getByLabelText(/email/i), { target: { value: "budi@example.com" } });
  fireEvent.change(screen.getByLabelText(/^password$/i), { target: { value: "password123" } });
  fireEvent.change(screen.getByLabelText(/^confirm password$/i), { target: { value: "password123" } });
}

describe("Signup page captcha (KO-CAPTCHA-001)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.resetModules();
    vi.unstubAllEnvs();
  });

  it("does not render the captcha widget when the site key is not configured", async () => {
    vi.stubEnv("NEXT_PUBLIC_TURNSTILE_SITE_KEY", "");
    const SignupPage = await importSignupPage();
    render(<SignupPage />);

    expect(screen.queryByTestId("turnstile-widget")).not.toBeInTheDocument();
  });

  it("submits without a captcha token when the site key is not configured", async () => {
    vi.stubEnv("NEXT_PUBLIC_TURNSTILE_SITE_KEY", "");
    const SignupPage = await importSignupPage();
    render(<SignupPage />);

    fillForm();
    fireEvent.click(screen.getByRole("button", { name: /create account/i }));

    await waitFor(() => {
      expect(signUpWithEmailMock).toHaveBeenCalledWith(
        "budi@example.com",
        "password123",
        "password123",
        "Budi Santoso"
      );
    });
  });

  it("renders the captcha widget when the site key is configured", async () => {
    vi.stubEnv("NEXT_PUBLIC_TURNSTILE_SITE_KEY", "test-site-key");
    const SignupPage = await importSignupPage();
    render(<SignupPage />);

    expect(screen.getByTestId("turnstile-widget")).toBeInTheDocument();
  });

  it("blocks submission until the captcha challenge succeeds", async () => {
    vi.stubEnv("NEXT_PUBLIC_TURNSTILE_SITE_KEY", "test-site-key");
    const SignupPage = await importSignupPage();
    render(<SignupPage />);

    expect(screen.getByRole("button", { name: /create account/i })).toBeDisabled();

    fireEvent.click(screen.getByTestId("turnstile-widget"));

    await waitFor(() => {
      expect(screen.getByRole("button", { name: /create account/i })).not.toBeDisabled();
    });
  });

  it("passes the captcha token to signUpWithEmail after a successful challenge", async () => {
    vi.stubEnv("NEXT_PUBLIC_TURNSTILE_SITE_KEY", "test-site-key");
    const SignupPage = await importSignupPage();
    render(<SignupPage />);

    fillForm();
    fireEvent.click(screen.getByTestId("turnstile-widget"));
    await waitFor(() => {
      expect(screen.getByRole("button", { name: /create account/i })).not.toBeDisabled();
    });
    fireEvent.click(screen.getByRole("button", { name: /create account/i }));

    await waitFor(() => {
      expect(signUpWithEmailMock).toHaveBeenCalledWith(
        "budi@example.com",
        "password123",
        "password123",
        "Budi Santoso",
        "token-123"
      );
    });
  });
});
