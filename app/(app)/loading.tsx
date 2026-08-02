import Image from "next/image";

/** Segment-level fallback for authenticated routes during streamed navigation. */
export default function AppLoading() {
  return (
    <main className="flex min-h-[60vh] items-center justify-center px-6" role="status" aria-busy="true" aria-live="polite">
      <div className="flex flex-col items-center gap-3 text-center">
        <div className="relative flex h-14 w-14 items-center justify-center">
          <span className="absolute inset-0 rounded-full border-2 border-primary/15 border-t-primary motion-safe:animate-spin motion-reduce:animate-none" aria-hidden="true" />
          <Image src="/brand/koinaku-icon.png" alt="" width={40} height={40} priority className="h-8 w-8 object-contain motion-safe:animate-pulse motion-reduce:animate-none" />
        </div>
        <p className="text-sm font-semibold text-muted-foreground">Loading Koinaku…</p>
        <span className="sr-only">Please wait while this page loads.</span>
      </div>
    </main>
  );
}
