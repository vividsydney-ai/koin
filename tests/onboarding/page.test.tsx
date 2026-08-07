import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor, fireEvent } from "@testing-library/react";

const pushMock = vi.fn();
const replaceMock = vi.fn();
const completeOnboardingMock = vi.fn().mockResolvedValue({ error: null });
const trackEventMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: pushMock, replace: replaceMock }),
  useSearchParams: vi.fn().mockReturnValue(new URLSearchParams("replay=1")),
}));

vi.mock("@/lib/auth/client", () => ({
  supabase: {
    auth: {
      getUser: vi.fn().mockResolvedValue({
        data: { user: { id: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11" } },
        error: null,
      }),
    },
  },
}));

vi.mock("@/lib/profile/client", () => ({
  getProfile: vi.fn().mockResolvedValue({
    id: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
    onboarding_completed: true,
  }),
  completeOnboarding: (...args: unknown[]) => completeOnboardingMock(...args),
}));

vi.mock("@/lib/analytics/client", () => ({
  trackEvent: (...args: unknown[]) => trackEventMock(...args),
}));

import OnboardingPage from "@/app/onboarding/page";

describe("Onboarding page — replay mode", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("does not redirect already-onboarded users when replay=1", async () => {
    render(<OnboardingPage />);

    await waitFor(() => {
      expect(screen.getByRole("button", { name: /mulai/i })).toBeInTheDocument();
    });

    expect(replaceMock).not.toHaveBeenCalled();
  });

  it("does not call completeOnboarding and redirects to /profile when replay finishes", async () => {
    render(<OnboardingPage />);

    // Welcome -> Profile
    await waitFor(() => screen.getByRole("button", { name: /mulai/i }));
    fireEvent.click(screen.getByRole("button", { name: /mulai/i }));

    // Profile -> Assessment
    await waitFor(() => screen.getByLabelText(/nama panggilan/i));
    fireEvent.change(screen.getByLabelText(/nama panggilan/i), { target: { value: "Budi" } });
    fireEvent.click(screen.getByRole("button", { name: /19–22/i }));
    fireEvent.click(screen.getByRole("button", { name: /lanjut/i }));

    // Assessment -> Goal (skip assessment)
    await waitFor(() => screen.getByRole("button", { name: /lewati/i }));
    fireEvent.click(screen.getByRole("button", { name: /lewati/i }));

    // Goal -> Notifications
    await waitFor(() => screen.getByText(/tujuan keuanganmu/i));
    fireEvent.click(screen.getByRole("button", { name: /mulai investasi/i }));
    fireEvent.click(screen.getByRole("button", { name: /lanjut/i }));

    // Notifications -> Ready
    await waitFor(() => screen.getByRole("heading", { name: /pengingat harian/i }));
    fireEvent.click(screen.getByRole("button", { name: /lanjut/i }));

    // Ready -> finish replay
    await waitFor(() => screen.getByRole("button", { name: /kembali ke profil/i }));
    fireEvent.click(screen.getByRole("button", { name: /kembali ke profil/i }));

    await waitFor(() => {
      expect(completeOnboardingMock).not.toHaveBeenCalled();
      expect(pushMock).toHaveBeenCalledWith("/profile");
    });
  });
});
