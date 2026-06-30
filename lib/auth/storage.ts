function isBrowser(): boolean {
  return typeof document !== "undefined";
}

function encode(value: string): string {
  return encodeURIComponent(value);
}

function decode(value: string): string {
  return decodeURIComponent(value);
}

export const cookieStorage = {
  getItem: async (key: string): Promise<string | null> => {
    if (!isBrowser()) return null;
    const match = document.cookie.match(new RegExp(`(?:^|;\\s*)${encode(key)}=([^;]*)`));
    return match ? decode(match[1]) : null;
  },

  setItem: async (key: string, value: string): Promise<void> => {
    if (!isBrowser()) return;
    // 400 days is the maximum allowed by modern browsers for Set-Cookie.
    document.cookie = `${encode(key)}=${encode(value)};path=/;max-age=34560000;SameSite=Lax`;
  },

  removeItem: async (key: string): Promise<void> => {
    if (!isBrowser()) return;
    document.cookie = `${encode(key)}=;path=/;max-age=0;SameSite=Lax`;
  },
};
