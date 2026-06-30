import { describe, it, expect, vi } from "vitest";

vi.mock("@capacitor/push-notifications", () => ({
  PushNotifications: {
    requestPermissions: vi.fn().mockResolvedValue({ receive: "granted" }),
    register: vi.fn(),
    addListener: vi.fn(),
  },
}));

import { initPushNotifications } from "@/lib/native/push-notifications";
import { PushNotifications } from "@capacitor/push-notifications";

describe("initPushNotifications", () => {
  it("requests permissions and registers", async () => {
    await initPushNotifications();

    expect(PushNotifications.requestPermissions).toHaveBeenCalled();
    expect(PushNotifications.register).toHaveBeenCalled();
    expect(PushNotifications.addListener).toHaveBeenCalledWith(
      "registration",
      expect.any(Function)
    );
  });
});
