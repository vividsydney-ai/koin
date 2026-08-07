import { Suspense } from "react";
import { AcceptFriendContent } from "./AcceptFriendContent";

export default function AcceptFriendPage() {
  return (
    <Suspense fallback={<AcceptFallback />}>
      <AcceptFriendContent />
    </Suspense>
  );
}

function AcceptFallback() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-background p-6">
      <p className="text-sm text-muted-foreground">Loading…</p>
    </main>
  );
}
