import { describe, it, expect, vi } from "vitest";

vi.mock("@capacitor/preferences", () => ({
  Preferences: {
    get: vi.fn().mockResolvedValue({ value: null }),
    set: vi.fn().mockResolvedValue(undefined),
    remove: vi.fn().mockResolvedValue(undefined),
  },
}));

vi.mock("@supabase/supabase-js", () => ({
  createClient: vi.fn().mockReturnValue({
    auth: {
      getUser: vi.fn().mockResolvedValue({ data: { user: { id: "user-1", email: "a@b.com" } }, error: null }),
      getSession: vi.fn().mockResolvedValue({ data: { session: null }, error: null }),
      signInWithPassword: vi.fn().mockResolvedValue({ data: { user: null, session: null }, error: null }),
      signUp: vi.fn().mockResolvedValue({ data: { user: null, session: null }, error: null }),
      signInWithOAuth: vi.fn().mockResolvedValue({ data: { url: "https://example.com" }, error: null }),
      signOut: vi.fn().mockResolvedValue({ error: null }),
      onAuthStateChange: vi.fn().mockReturnValue({ subscription: { unsubscribe: vi.fn() } }),
    },
  }),
}));

import { supabase, signInWithEmail, signUpWithEmail, signInWithGoogle, signOut } from "@/lib/auth/client";

describe("auth client", () => {
  it("exports a supabase client", () => {
    expect(supabase).toBeDefined();
    expect(supabase.auth).toBeDefined();
  });

  it("signInWithEmail calls signInWithPassword", async () => {
    await signInWithEmail("a@b.com", "password123");
    expect(supabase.auth.signInWithPassword).toHaveBeenCalledWith({
      email: "a@b.com",
      password: "password123",
    });
  });

  it("signUpWithEmail calls signUp", async () => {
    await signUpWithEmail("a@b.com", "password123", { name: "Budi" });
    expect(supabase.auth.signUp).toHaveBeenCalledWith({
      email: "a@b.com",
      password: "password123",
      options: { data: { name: "Budi" } },
    });
  });

  it("signInWithGoogle uses google provider", async () => {
    await signInWithGoogle();
    expect(supabase.auth.signInWithOAuth).toHaveBeenCalledWith({
      provider: "google",
      options: {
        redirectTo: expect.stringContaining("/auth/callback"),
      },
    });
  });

  it("signOut calls auth signOut", async () => {
    await signOut();
    expect(supabase.auth.signOut).toHaveBeenCalled();
  });
});
