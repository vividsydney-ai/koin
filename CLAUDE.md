# Koin — CLAUDE.md (Project Root)
# Loaded automatically every session. Under 200 lines. Routing file only.
# Scopes: Project-level. For global rules, see ~/.claude/CLAUDE.md

## WHAT
Koin is a mobile-first financial literacy web app for Indonesian Gen Z.
Duolingo meets paper trading for money. Built on official Indonesian regulatory sources (OJK, BI, IDX).

## WHY
Financial literacy index Indonesia 2025: 66.46%. Inclusion: 80.51%.
People have access before understanding. Koin closes that gap.
Every lesson must cite a Tier 1 source before publish. Trust is the product.

## HOW
### Workflow (always)
1. Read TASKS.md — find first [ ] task
2. Read RULES.md — do not violate hard stops
3. Read CONTEXT.md — use the shared domain language
4. Read ADL.md — respect recorded architecture decisions
5. Read VISION.md — if ambiguity, consult context
6. Read SCHEMA.md — schema is canonical
7. Read AGENTS.md — check current role, scope, and pre-flight checklist
8. Plan → Write tests → Implement → Verify → Document

### Verification is mandatory
After every task, run VERIFIER.md gates. Do not self-certify.
If verification fails, halt and update progress.md with the failure reason.

### Git protocol
- Branch: koin/<task-slug>-<date>
- Commit every logical sub-step
- PR description: link to task in TASKS.md, list schema changes, verify result
- NEVER merge to main — draft PR only

### Hard constraints
- No localStorage/sessionStorage (iframe crash)
- No is_published=true without lesson_reviews.approved_to_publish=true
- RLS in same migration as table creation
- TypeScript strict mode, Zod for all inputs, 44px touch targets min
- All monetary values in IDR with realistic Indonesian ranges

### File routing
| File | Purpose |
|------|---------|
| TASKS.md | Build task list. Find first [ ] item |
| RULES.md | Growing rules. Read-only unless human edits |
| VISION.md | Product context, design tokens, stack |
| CONTEXT.md | Shared domain language and terminology |
| ADL.md | Architecture decision log |
| SCHEMA.md | Full DB schema + RLS + seed order |
| SOURCES.md | 32 seed sources with URLs |
| AGENTS.md | Role definitions, maker/checker split |
| VERIFIER.md | Automated gates. Run after every task |
| progress.md | Live state. Update after every session |

## Agent skills

This repo also uses `mattpocock/skills` conventions.

### Issue tracker

Issues live in Linear under team `KO`: https://linear.app/vnsavitri/team/KO/overview. See `docs/agents/issue-tracker.md`.

### Triage labels

Canonical roles mapped to Linear labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context repo: read `CONTEXT.md` and `ADL.md` at the repo root before exploring. See `docs/agents/domain.md`.

### Hooks
- /hooks: configured in .claude/settings.json
- PreToolUse: route destructive commands to Opus for approval
- PostToolUse: auto-format code after every file edit
- Stop: run VERIFIER.md before Claude marks task done

### Skills
- /skill:domain-schema — load for any schema migration task
- /skill:tailwind-ui — load for UI component work
- /skill:supabase-auth — load for auth/RLS work
- /skill:indonesian-finance — load for lesson content tasks
