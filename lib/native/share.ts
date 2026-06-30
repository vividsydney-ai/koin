import { Share, type ShareOptions } from "@capacitor/share";
import { Capacitor } from "@capacitor/core";

export interface ShareContentOptions {
  title: string;
  text: string;
  url?: string;
}

export async function shareContent(options: ShareContentOptions): Promise<void> {
  if (!Capacitor.isNativePlatform()) {
    // Fallback for web: use navigator.share if available
    if (navigator.share) {
      await navigator.share({
        title: options.title,
        text: options.text,
        url: options.url,
      });
      return;
    }
    throw new Error("Sharing is only available in the Koin mobile app or supported browsers.");
  }

  const shareOptions: ShareOptions = {
    title: options.title,
    text: options.text,
    dialogTitle: "Share your progress",
  };

  if (options.url) {
    shareOptions.url = options.url;
  }

  await Share.share(shareOptions);
}
