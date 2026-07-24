import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";

const mocks = vi.hoisted(() => ({
  checkUrlReachability: vi.fn(),
  fetchWikipediaSummary: vi.fn(),
}));

vi.mock("@/lib/sources/reachability", () => ({
  checkUrlReachability: mocks.checkUrlReachability,
}));

vi.mock("@/lib/sources/wikipedia", () => ({
  fetchWikipediaSummary: mocks.fetchWikipediaSummary,
  buildWikipediaSearchUrl: (title: string) => `https://en.wikipedia.org/wiki/${title}`,
}));

vi.mock("@/lib/i18n/LocaleProvider", () => ({
  useLocale: () => ({
    t: (key: string) => {
      const dict: Record<string, string> = {
        "lesson.readSource": "Read source",
        "sources.readOnWikipedia": "Read on Wikipedia",
        "sources.originalUnavailable": "Original link unavailable",
      };
      return dict[key] ?? key;
    },
    locale: "en",
  }),
}));

import { ReachableLink } from "@/components/sources/ReachableLink";

describe("ReachableLink", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders the original link when the URL is reachable", async () => {
    mocks.checkUrlReachability.mockResolvedValueOnce({ ok: true, status: 200 });

    render(
      <ReachableLink url="https://ojk.go.id" title="OJK Home">
        Read source
      </ReachableLink>
    );

    await waitFor(() => {
      const link = screen.getByRole("link", { name: /read source: ojk home/i });
      expect(link).toHaveAttribute("href", "https://ojk.go.id");
    });
  });

  it("renders Wikipedia fallback when the URL is unreachable", async () => {
    mocks.checkUrlReachability.mockResolvedValueOnce({ ok: false, status: 404 });
    mocks.fetchWikipediaSummary.mockResolvedValueOnce({
      title: "OJK Home",
      extract: "",
      url: "https://en.wikipedia.org/wiki/OJK_Home",
    });

    render(
      <ReachableLink url="https://ojk.go.id/missing" title="OJK Home">
        Read source
      </ReachableLink>
    );

    await waitFor(() => {
      const link = screen.getByRole("link", { name: /read on wikipedia: ojk home/i });
      expect(link).toHaveAttribute("href", "https://en.wikipedia.org/wiki/OJK_Home");
    });

    expect(screen.getByText("Original link unavailable")).toBeInTheDocument();
  });

  it("uses the provided children as link text", async () => {
    mocks.checkUrlReachability.mockResolvedValueOnce({ ok: true, status: 200 });

    render(
      <ReachableLink url="https://example.com" title="Example">
        Custom text
      </ReachableLink>
    );

    await waitFor(() => {
      expect(screen.getByText("Custom text")).toBeInTheDocument();
    });
  });

  it("renders the original link without calling reachability when skipCheck is true", async () => {
    render(
      <ReachableLink url="https://ojk.go.id" title="OJK Home" skipCheck>
        Read source
      </ReachableLink>
    );

    await waitFor(() => {
      const link = screen.getByRole("link", { name: /read source: ojk home/i });
      expect(link).toHaveAttribute("href", "https://ojk.go.id");
    });

    expect(mocks.checkUrlReachability).not.toHaveBeenCalled();
  });
});
