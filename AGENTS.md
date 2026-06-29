# AGENTS.md — Koin Agent Configuration

## Single-agent sessions (Phase 1–6)
For most sessions: one agent, one task from TASKS.md, hard gate = passing tests.

## Sub-agent split (use for Phase 3+ lesson and schema work)

### maker-agent
Role: Write code, migrations, seed data
Scope: Implement the current TASKS.md item
Stop condition: Writes "MAKER DONE" to progress.md and halts
Must NOT: Self-verify, approve own work, modify RULES.md

### checker-agent
Role: Verify maker output
Checks: TypeScript compilation, Supabase type generation passes,
        all tests pass, RLS policies present, no hard stops violated
Gate: All checks green = write "CHECKER APPROVED" to progress.md
Fail: Write specific failure reason to progress.md, halt

## Gate protocol (what "done" means — never agent opinion)
Phase 1 (migrations): supabase db reset exits 0, supabase gen types exits 0
Phase 2 (auth): auth tests pass, middleware test pass
Phase 3 (lesson player + paper trading): lesson completion flow + first paper trade end-to-end pass
Phase 4 (streaks + Koin Points): streak unit tests pass; Koin Points award on leaderboard/streak/graduation works
Phase 5 (social + graduation): friendship + leaderboard integration tests pass; graduation at 3x–5x issues certificate + brokerage recommendations
Phase 6 (adaptive lessons): lesson triggers fire on panic sell, concentration, inactivity, and portfolio drawdown
Phase 7 (polish): Lighthouse mobile score ≥ 85, zero TypeScript errors

## What agents may NOT modify
- RULES.md (read only — human controls)
- supabase/migrations/ (only maker-agent, one migration per session)
- Any file in /tests/ (checker reads, nobody edits)
- .env files
