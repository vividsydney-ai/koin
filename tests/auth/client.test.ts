import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("@capacitor/preferences", () => ({
  Preferences: {
    get: vi.fn().mockResolvedValue({ value: null }),
    set: vi.fn().mockResolvedValue(undefined),
    remove: vi.fn().mockResolvedValue(undefined),
  },
}));

const mockSignInWithPassword = vi.fn();
const mockSignUp = vi.fn();
const mockResend = vi.fn();
const mockSignOut = vi.fn();
const mockGetUser = vi.fn();
const mockGetSession = vi.fn();
const mockResetPasswordForEmail = vi.fn();
const mockUpdateUser = vi.fn();

vi.mock("@supabase/supabase-js", () => ({
  createClient: vi.fn().mockReturnValue({
    auth: {
      getUser: () => mockGetUser(),
      getSession: () => mockGetSession(),
      signInWithPassword: (args: unknown) => mockSignInWithPassword(args),
      signUp: (args: unknown) => mockSignUp(args),
      resend: (args: unknown) => mockResend(args),
      signOut: () => mockSignOut(),
      resetPasswordForEmail: (email: string, options: unknown) => mockResetPasswordForEmail(email, options),
      updateUser: (attrs: unknown) => mockUpdateUser(attrs),
      onAuthStateChange: vi.fn().mockReturnValue({ subscription: { unsubscribe: vi.fn() } }),
    },
  }),
}));

import {
  supabase,
  signInWithEmail,
  signUpWithEmail,
  resendSignupEmail,
  sendPasswordResetEmail,
  updatePassword,
  signOut,
  getCurrentUser,
  getSession,
} from "@/lib/auth/client";

describe("auth client", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("exports a supabase client", () => {
    expect(supabase).toBeDefined();
    expect(supabase.auth).toBeDefined();
  });

  describe("getCurrentUser", () => {
    it("returns user on success", async () => {
      mockGetUser.mockResolvedValue({
        data: { user: { id: "user-1", email: "a@b.com" } },
        error: null,
      });
      const result = await getCurrentUser();
      expect(result.ok).toBe(true);
      if (result.ok) {
        expect(result.data.id).toBe("user-1");
      }
    });

    it("returns error on failure", async () => {
      mockGetUser.mockResolvedValue({ data: { user: null }, error: { message: "network" } });
      const result = await getCurrentUser();
      expect(result.ok).toBe(false);
      if (!result.ok) {
        expect(result.error.code).toBe("network_error");
      }
    });
  });

  describe("getSession", () => {
    it("returns session on success", async () => {
      mockGetSession.mockResolvedValue({
        data: { session: { access_token: "token" } },
        error: null,
      });
      const result = await getSession();
      expect(result.ok).toBe(true);
    });

    it("returns error when no session", async () => {
      mockGetSession.mockResolvedValue({ data: { session: null }, error: null });
      const result = await getSession();
      expect(result.ok).toBe(false);
    });
  });

  describe("signInWithEmail", () => {
    it("validates input before calling Supabase", async () => {
      const result = await signInWithEmail("not-an-email", "short");
      expect(result.ok).toBe(false);
      expect(mockSignInWithPassword).not.toHaveBeenCalled();
    });

    it("returns session on success", async () => {
      mockSignInWithPassword.mockResolvedValue({
        data: { session: { access_token: "token" } },
        error: null,
      });
      const result = await signInWithEmail("a@b.com", "password123");
      expect(result.ok).toBe(true);
      expect(mockSignInWithPassword).toHaveBeenCalledWith({
        email: "a@b.com",
        password: "password123",
      });
    });

    it("normalizes invalid credentials error", async () => {
      mockSignInWithPassword.mockResolvedValue({
        data: { session: null },
        error: { message: "Invalid login credentials" },
      });
      const result = await signInWithEmail("a@b.com", "password123");
      expect(result.ok).toBe(false);
      if (!result.ok) {
        expect(result.error.code).toBe("invalid_credentials");
      }
    });
  });

  describe("signUpWithEmail", () => {
    it("validates matching passwords", async () => {
      const result = await signUpWithEmail("a@b.com", "password123", "different", "Budi");
      expect(result.ok).toBe(false);
      expect(mockSignUp).not.toHaveBeenCalled();
    });

    it("calls signUp with a trimmed full name, email language, redirect, and metadata", async () => {
      mockSignUp.mockResolvedValue({ data: { user: null, session: null }, error: null });
      const result = await signUpWithEmail("a@b.com", "password123", "password123", "  Budi  ", undefined, undefined, "id");
      expect(result.ok).toBe(true);
      expect(mockSignUp).toHaveBeenCalledWith({
        email: "a@b.com",
        password: "password123",
        options: {
          data: { display_name: "Budi", preferred_language: "id" },
          emailRedirectTo: expect.stringContaining("/auth/callback"),
        },
      });
    });

    it("rejects a whitespace-only full name before calling Supabase", async () => {
      const result = await signUpWithEmail("a@b.com", "password123", "password123", "   ");
      expect(result.ok).toBe(false);
      expect(mockSignUp).not.toHaveBeenCalled();
    });
  });

  describe("resendSignupEmail", () => {
    it("validates email before calling resend", async () => {
      const result = await resendSignupEmail("not-an-email");
      expect(result.ok).toBe(false);
      expect(mockResend).not.toHaveBeenCalled();
    });

    it("calls auth.resend for signup", async () => {
      mockResend.mockResolvedValue({ error: null });
      const result = await resendSignupEmail("a@b.com");
      expect(result.ok).toBe(true);
      expect(mockResend).toHaveBeenCalledWith({
        type: "signup",
        email: "a@b.com",
      });
    });
  });

  describe("signOut", () => {
    it("calls auth signOut", async () => {
      mockSignOut.mockResolvedValue({ error: null });
      const result = await signOut();
      expect(result.ok).toBe(true);
      expect(mockSignOut).toHaveBeenCalled();
    });
  });

  describe("sendPasswordResetEmail", () => {
    it("validates email before calling Supabase", async () => {
      const result = await sendPasswordResetEmail("not-an-email");
      expect(result.ok).toBe(false);
      expect(mockResetPasswordForEmail).not.toHaveBeenCalled();
    });

    it("calls auth.resetPasswordForEmail with redirectTo", async () => {
      mockResetPasswordForEmail.mockResolvedValue({ error: null });
      const result = await sendPasswordResetEmail("a@b.com");
      expect(result.ok).toBe(true);
      expect(mockResetPasswordForEmail).toHaveBeenCalledWith("a@b.com", {
        redirectTo: expect.stringContaining("/reset-password"),
      });
    });

    it("normalizes error on failure", async () => {
      mockResetPasswordForEmail.mockResolvedValue({ error: { message: "rate limit" } });
      const result = await sendPasswordResetEmail("a@b.com");
      expect(result.ok).toBe(false);
    });
  });

  describe("updatePassword", () => {
    it("returns user on success", async () => {
      mockUpdateUser.mockResolvedValue({ data: { user: { id: "user-1" } }, error: null });
      const result = await updatePassword("newpassword123");
      expect(result.ok).toBe(true);
      expect(mockUpdateUser).toHaveBeenCalledWith({ password: "newpassword123" });
    });

    it("returns error when no user is returned", async () => {
      mockUpdateUser.mockResolvedValue({ data: { user: null }, error: null });
      const result = await updatePassword("newpassword123");
      expect(result.ok).toBe(false);
    });

    it("normalizes error on failure", async () => {
      mockUpdateUser.mockResolvedValue({ data: { user: null }, error: { message: "weak password" } });
      const result = await updatePassword("newpassword123");
      expect(result.ok).toBe(false);
    });
  });
});
