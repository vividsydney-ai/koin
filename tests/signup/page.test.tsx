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

import SignupPage from "@/app/signup/page";

describe("Signup page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders the signup form", () => {
    render(<SignupPage />);

    expect(screen.getByRole("heading", { name: /create your koinaku account/i })).toBeInTheDocument();
    expect(screen.getByLabelText(/full name/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/^password$/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/^confirm password$/i)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /create account/i })).toBeInTheDocument();
  });

  it("shows a validation error and does not submit when passwords do not match", async () => {
    render(<SignupPage />);

    fireEvent.change(screen.getByLabelText(/full name/i), { target: { value: "Budi Santoso" } });
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: "budi@example.com" } });
    fireEvent.change(screen.getByLabelText(/^password$/i), { target: { value: "password123" } });
    fireEvent.change(screen.getByLabelText(/^confirm password$/i), { target: { value: "different-password" } });
    fireEvent.click(screen.getByRole("button", { name: /create account/i }));

    await waitFor(() => {
      expect(screen.getByText(/passwords do not match/i)).toBeInTheDocument();
    });

    expect(signUpWithEmailMock).not.toHaveBeenCalled();
  });

  it("submits the selected confirmation-email language with the signup metadata", async () => {
    render(<SignupPage />);

    fireEvent.change(screen.getByLabelText(/full name/i), { target: { value: "Budi Santoso" } });
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: "budi@example.com" } });
    fireEvent.change(screen.getByLabelText(/^password$/i), { target: { value: "password123" } });
    fireEvent.change(screen.getByLabelText(/^confirm password$/i), { target: { value: "password123" } });
    fireEvent.click(screen.getByRole("button", { name: /create account/i }));

    await waitFor(() => {
      expect(signUpWithEmailMock).toHaveBeenCalledWith(
        "budi@example.com",
        "password123",
        "password123",
        "Budi Santoso",
        undefined,
        true,
        "en"
      );
    });
  });

  it("rejects a whitespace-only full name", async () => {
    render(<SignupPage />);

    fireEvent.change(screen.getByLabelText(/full name/i), { target: { value: "   " } });
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: "budi@example.com" } });
    fireEvent.change(screen.getByLabelText(/^password$/i), { target: { value: "password123" } });
    fireEvent.change(screen.getByLabelText(/^confirm password$/i), { target: { value: "password123" } });
    fireEvent.click(screen.getByRole("button", { name: /create account/i }));

    await waitFor(() => expect(screen.getAllByText(/full name is required/i)).toHaveLength(2));
    expect(signUpWithEmailMock).not.toHaveBeenCalled();
  });

  it("toggles password input type when show/hide is clicked", () => {
    render(<SignupPage />);

    const passwordInput = screen.getByLabelText(/^password$/i) as HTMLInputElement;
    const confirmPasswordInput = screen.getByLabelText(/^confirm password$/i) as HTMLInputElement;

    expect(passwordInput.type).toBe("password");
    expect(confirmPasswordInput.type).toBe("password");

    const showPasswordButton = screen.getByRole("button", { name: /show password/i });
    fireEvent.click(showPasswordButton);

    expect(passwordInput.type).toBe("text");
    expect(confirmPasswordInput.type).toBe("password");

    fireEvent.click(showPasswordButton);
    expect(passwordInput.type).toBe("password");
  });

  it("toggles confirm password input type independently", () => {
    render(<SignupPage />);

    const confirmPasswordInput = screen.getByLabelText(/^confirm password$/i) as HTMLInputElement;
    expect(confirmPasswordInput.type).toBe("password");

    const showConfirmPasswordButton = screen.getByRole("button", { name: /show confirm password/i });
    fireEvent.click(showConfirmPasswordButton);

    expect(confirmPasswordInput.type).toBe("text");

    fireEvent.click(showConfirmPasswordButton);
    expect(confirmPasswordInput.type).toBe("password");
  });
});
