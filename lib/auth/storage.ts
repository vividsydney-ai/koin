function isBrowser(): boolean {
  return typeof document !== "undefined";
}

function encode(value: string): string {
  return encodeURIComponent(value);
}

function decode(value: string): string {
  return decodeURIComponent(value);
}

// Keep each chunk under 4KB so browsers don't drop oversized cookies.
// Supabase sessions can exceed 4KB when provider tokens are included,
// so we split the value across numbered cookies.
const CHUNK_SIZE = 3800;
const CHUNK_KEY = (key: string, index: number) => `${key}.${index}`;

function listChunkKeys(key: string): string[] {
  const keys: string[] = [];
  const prefix = `${encode(key)}.`;
  const cookies = document.cookie.split(";");
  for (const cookie of cookies) {
    const trimmed = cookie.trim();
    if (trimmed.startsWith(prefix)) {
      const name = trimmed.split("=")[0];
      if (name) keys.push(name);
    }
  }
  return keys;
}

export const cookieStorage = {
  getItem: async (key: string): Promise<string | null> => {
    if (!isBrowser()) return null;

    const chunkKeys = listChunkKeys(key).sort();
    if (chunkKeys.length === 0) {
      // Fallback: read the single-cookie format used by earlier versions.
      const single = document.cookie.match(new RegExp(`(?:^|;)\\s*${encode(key)}=([^;]*)`));
      return single ? decode(single[1]) : null;
    }

    const chunks: string[] = [];
    for (const chunkKey of chunkKeys) {
      const match = document.cookie.match(new RegExp(`(?:^|;)\\s*${chunkKey}=([^;]*)`));
      if (!match) return null;
      chunks.push(decode(match[1]));
    }
    return chunks.join("");
  },

  setItem: async (key: string, value: string): Promise<void> => {
    if (!isBrowser()) return;

    // Clear any existing chunks first to avoid stale data.
    const existingKeys = listChunkKeys(key);
    for (const existingKey of existingKeys) {
      document.cookie = `${existingKey}=;path=/;max-age=0;SameSite=Lax`;
    }
    document.cookie = `${encode(key)}=;path=/;max-age=0;SameSite=Lax`;

    const encoded = encode(value);
    const totalChunks = Math.ceil(encoded.length / CHUNK_SIZE);
    for (let i = 0; i < totalChunks; i++) {
      const chunk = encoded.slice(i * CHUNK_SIZE, (i + 1) * CHUNK_SIZE);
      document.cookie = `${CHUNK_KEY(key, i)}=${chunk};path=/;max-age=34560000;SameSite=Lax`;
    }
  },

  removeItem: async (key: string): Promise<void> => {
    if (!isBrowser()) return;

    const existingKeys = listChunkKeys(key);
    for (const existingKey of existingKeys) {
      document.cookie = `${existingKey}=;path=/;max-age=0;SameSite=Lax`;
    }
    document.cookie = `${encode(key)}=;path=/;max-age=0;SameSite=Lax`;
  },
};
