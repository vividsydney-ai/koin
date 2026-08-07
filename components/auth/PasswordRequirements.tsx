"use client";

export interface PasswordRequirement {
  label: string;
  met: boolean;
}

export function getPasswordRequirements(password: string): PasswordRequirement[] {
  return [
    { label: "At least 8 characters", met: password.length >= 8 },
    { label: "Contains a number", met: /\d/.test(password) },
    { label: "Contains a special character", met: /[^A-Za-z0-9\s]/.test(password) },
  ];
}

function CheckIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <path d="m20 6-9 9-5-5" />
    </svg>
  );
}

function XIcon({ className }: { className?: string }) {
  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2.5"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      <path d="M18 6 6 18" />
      <path d="m6 6 12 12" />
    </svg>
  );
}

export function PasswordRequirements({ password }: { password: string }) {
  const requirements = getPasswordRequirements(password);
  const allMet = requirements.every((r) => r.met);

  return (
    <ul
      className="space-y-1.5"
      aria-label="Password requirements"
      aria-live="polite"
    >
      {requirements.map((req) => (
        <li
          key={req.label}
          className={`flex items-center gap-2 text-xs ${
            req.met ? "text-success" : "text-muted-foreground"
          }`}
        >
          <span
            className={`flex h-4 w-4 shrink-0 items-center justify-center rounded-full ${
              req.met ? "bg-success/15" : "bg-muted"
            }`}
            aria-hidden="true"
          >
            {req.met ? (
              <CheckIcon className="h-2.5 w-2.5" />
            ) : (
              <XIcon className="h-2.5 w-2.5" />
            )}
          </span>
          {req.label}
        </li>
      ))}
      {allMet && (
        <li className="text-xs text-success">Password looks good.</li>
      )}
    </ul>
  );
}
