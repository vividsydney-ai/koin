import { PushNotifications } from "@capacitor/push-notifications";
import { Capacitor } from "@capacitor/core";

export async function initPushNotifications(): Promise<void> {
  if (!Capacitor.isNativePlatform()) {
    // eslint-disable-next-line no-console
    console.log("Push notifications are only available in the Koin mobile app.");
    return;
  }

  const permission = await PushNotifications.requestPermissions();

  if (permission.receive === "granted") {
    await PushNotifications.register();

    PushNotifications.addListener("registration", (token) => {
      // eslint-disable-next-line no-console
      console.log("Push registration token:", token.value);
    });

    PushNotifications.addListener("registrationError", (error) => {
      // eslint-disable-next-line no-console
      console.error("Push registration error:", error.error);
    });
  }
}

export async function scheduleLocalNotificationStub(
  title: string,
  body: string
): Promise<void> {
  // MVP stub: real delivery requires FCM/APNs backend integration
  // eslint-disable-next-line no-console
  console.log("[notification stub]", title, body);
}
