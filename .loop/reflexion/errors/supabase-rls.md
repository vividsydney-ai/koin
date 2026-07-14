# Error: RLS policy missing on new table

**Symptom:** `new row violates row-level security policy for table "xxx"`
**Root cause:** Migration created table but RLS policy was in a separate migration or missing.
**Fix:** RLS policy MUST be in the same migration file that creates the table (RULES.md).
**First seen:** 2026-06-04
**Frequency:** 3
**Last seen:** 2026-07-06
**Tags:** supabase, rls, migration, hard-stop
