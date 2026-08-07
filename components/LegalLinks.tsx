import Link from "next/link";

export function LegalLinks({
  actionText,
  className = "",
}: {
  actionText: string;
  className?: string;
}) {
  return (
    <p className={`text-center text-xs text-muted-foreground ${className}`}>
      {actionText}{" "}
      <Link href="/terms" className="text-primary hover:underline">
        Terms of Service
      </Link>{" "}
      and{" "}
      <Link href="/privacy" className="text-primary hover:underline">
        Privacy Policy
      </Link>
      .
    </p>
  );
}
