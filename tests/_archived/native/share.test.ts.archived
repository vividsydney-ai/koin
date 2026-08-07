import { describe, it, expect, vi } from "vitest";

vi.mock("@capacitor/share", () => ({
  Share: {
    share: vi.fn(),
  },
}));

import { shareContent } from "@/lib/native/share";
import { Share } from "@capacitor/share";

describe("shareContent", () => {
  it("calls Share.share with title and text", async () => {
    await shareContent({
      title: "My Koin Progress",
      text: "I just graduated from Koin!",
      url: "https://koin.app/share/abc123",
    });

    expect(Share.share).toHaveBeenCalledWith({
      title: "My Koin Progress",
      text: "I just graduated from Koin!",
      url: "https://koin.app/share/abc123",
      dialogTitle: "Share your progress",
    });
  });

  it("is safe to call without url", async () => {
    await shareContent({
      title: "Koin Lesson Complete",
      text: "I finished Money Basics!",
    });

    expect(Share.share).toHaveBeenCalledWith({
      title: "Koin Lesson Complete",
      text: "I finished Money Basics!",
      dialogTitle: "Share your progress",
    });
  });
});
