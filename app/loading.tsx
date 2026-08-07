import Image from "next/image";

/**
 * App Router fallback shown while a route is streamed during navigation.
 * Keep this deliberately lightweight: it should reassure the learner without
 * competing with the destination page or implying that data was lost.
 */
export default function Loading() {
  return (
    <main
      className="flex min-h-screen items-center justify-center bg-background px-6"
      role="status"
      aria-busy="true"
      aria-live="polite"
    >
      <div className="flex flex-col items-center gap-4 text-center">
        <div className="relative flex h-16 w-16 items-center justify-center">
          <span
            className="absolute inset-0 rounded-full border-2 border-primary/15 border-t-primary motion-safe:animate-spin motion-reduce:animate-none"
            aria-hidden="true"
          />
          <Image
            src="/brand/koinaku-icon.png"
            alt=""
            width={48}
            height={48}
            priority
            className="h-10 w-10 object-contain motion-safe:animate-pulse motion-reduce:animate-none"
          />
        </div>
        <p className="text-sm font-semibold text-muted-foreground">Loading Koinaku…</p>
        <span className="sr-only">Please wait while the next page loads.</span>
      </div>
    </main>
  );
}
