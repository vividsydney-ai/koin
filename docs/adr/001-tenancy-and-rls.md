# ADR 001: Tenant isolation with Supabase RLS

## Status

Accepted

## Context

Koinaku stores per-user data (profiles, settings, lesson progress, simulated trades). We needed a tenant isolation strategy that:

- Works for a small team without dedicated backend engineers
- Enforces isolation at the data layer so client bugs cannot bypass it
- Supports Next.js Server Components, Server Actions, and native mobile paths

## Decision

Use Supabase Row Level Security (RLS) as the primary enforcement mechanism. Every tenant table enables RLS and defines policies using `auth.uid()`. A database trigger creates the initial `profiles` and `user_settings` rows for each new `auth.users` record.

## Consequences

### Pros

- Isolation is enforced by Postgres, not by application code.
- Works identically for client SDK, Server Actions, and RPC calls.
- Simplifies client code because the database filters rows automatically.

### Cons

- RLS policies can be accidentally omitted on new tables.
- Complex authorization rules become SQL-heavy.
- Debugging RLS requires understanding the Postgres execution context.

## Mitigations

- Migration tests assert that every tenant table has `ENABLE ROW LEVEL SECURITY` and a policy referencing `auth.uid()`.
- Runtime RLS smoke tests create two users and verify cross-user reads fail.
- All new table migrations are reviewed in PRs against a checklist derived from this ADR.
