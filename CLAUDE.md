# Koin — CLAUDE.md (Project Root)
# Loaded automatically every session. Under 200 lines. Routing file only.
# Scopes: Project-level. For global rules, see ~/.claude/CLAUDE.md

## WHAT
Koin is a web-first financial literacy app for Indonesian Gen Z.
Duolingo meets paper trading for money. Built on official Indonesian regulatory sources (OJK, BI, IDX).

## WHY
Financial literacy index Indonesia 2025: 66.46%. Inclusion: 80.51%.
People have access before understanding. Koin closes that gap.
Every lesson must cite a Tier 1 source before publish. Trust is the product.

## HOW
### Workflow (always)
1. Read loop-state.md — resume active loop before starting anything new
2. Run OpenWiki pre-flight — read `openwiki/quickstart.md` and task-relevant pages if present; always read `openwiki/INSTRUCTIONS.md` if present
3. Read HANDOFF.md — latest session state and next-stream decision
4. Read TASKS.md — find first [ ] task
5. Read RULES.md — do not violate hard stops
6. Read CONTEXT.md — use the shared domain language
7. Read ADL.md — respect recorded architecture decisions
8. Read VISION.md — if ambiguity, consult context
9. Read SCHEMA.md — schema is canonical
10. Read AGENTS.md — check current role, scope, and pre-flight checklist
11. Read docs/agents/LOOP_ENGINEERING.md and .loop/state.md for unattended loop rules
12. Plan → Write tests → Implement → Verify → Document

### Verification is mandatory
After every task, run VERIFIER.md gates. Do not self-certify.
If verification fails, halt and update progress.md with the failure reason.

### Loop engineering (unattended/agent sessions)
Canonical, actually-implemented loop is `docs/agents/LOOP_ENGINEERING.md` + `.loop/state.md` + `.loop/prompts/`.
- OpenWiki is mandatory loop pre-flight for Claude, Codex, Kimi, and any other AI agent. If `openwiki/quickstart.md` exists, read it before planning and follow relevant links. If missing and the `openwiki` CLI is available, run `openwiki code --update --print`; if blocked by credentials or network, continue and log the block. OpenWiki is memory/discovery only and never overrides current human instructions, `RULES.md`, or canonical loop docs.
- Default mode: **Orchestrator → Maker → Checker** (single agent may play all three roles but must separate the work in the session log).
- Swarm mode for complex/risky slices (>5 files, >1 migration, auth/RLS/payments, native bridge, or a repeated gate failure): **Planner → Maker → Verifier → Fixer → Lander**, Maker on worktree `wt/<task-slug>`, Verifier is read-only.
- Commands: `npm run loop:prompt|codex|claude|kimi`, `npm run loop:gates`, `npm run loop:budget`, `npm run verify:loop`.
- Budget: 6 correction iterations max, 2 hours unattended max, escalate to human on repeat gate failure or ambiguity.
- The Koin-root `LOOP_ENGINEERING.md` (`/Users/vividm4/Documents/Projects/Side-Gigs/Koin/LOOP_ENGINEERING.md`) is the full expanded rationale behind the doc above — read it for background, not as separate instructions.
- `SWARM_KARPATHY.md` and `SWARM_ORCHESTRATION.md` (same Koin-root folder) describe a heavier 7-role swarm + metrics-driven experiment loop. **Reference/design-notes only — not implemented, not active.** Don't follow them unless a human explicitly says to adopt them; the swarm actually in use is the 5-role one above.

### Git protocol
- Active integration branch: `web-koinaku`. Verify with `git branch --show-current` — do not hardcode; branch names have drifted before (see `.loop/state.md`).
- Commit every logical sub-step with a clear message.
- Simple tasks: commit and deploy directly on `web-koinaku`. No branch-per-task/PR workflow for those.
- Complex or risky slices (swarm mode, see below): Maker works on an isolated worktree `wt/<task-slug>` branched from `web-koinaku`; Lander merges back only after all gates pass.
- Do not merge to `main` unless explicitly instructed.

### Hard constraints
- No localStorage/sessionStorage (iframe crash)
- No is_published=true without lesson_reviews.approved_to_publish=true
- RLS in same migration as table creation
- TypeScript strict mode, Zod for all inputs, 44px touch targets min
- All monetary values in IDR with realistic Indonesian ranges

### File routing
| File | Purpose |
|------|---------|
| HANDOFF.md | Latest session state + next-stream decision. Read first |
| TASKS.md | Build task list. Find first [ ] item |
| RULES.md | Growing rules. Read-only unless human edits |
| VISION.md | Product context, design tokens, stack |
| CONTEXT.md | Shared domain language and terminology |
| ADL.md | Architecture decision log |
| SCHEMA.md | Full DB schema + RLS + seed order |
| SOURCES.md | 32 seed sources with URLs |
| AGENTS.md | Role definitions, maker/checker split |
| VERIFIER.md | Automated gates. Run after every task |
| RECURRING.md | Periodic checks not tied to a task (source link rot, deps, Lighthouse) |
| openwiki/INSTRUCTIONS.md | Human-authored OpenWiki brief. Read-only during normal loop runs |
| openwiki/quickstart.md | Generated OpenWiki entry point. Read during loop pre-flight if present |
| docs/agents/LOOP_ENGINEERING.md | Canonical closed-loop setup for Claude/Codex/Kimi |
| .loop/state.md | Durable loop memory and stop-token conventions |
| .agents/skills/loop/SKILL.md | Cross-agent `/loop` Conductor protocol. Claude Code entry point is `.claude/skills/loop/SKILL.md`, which delegates here |
| ../LOOP_ENGINEERING.md (Koin root) | Full expanded rationale behind docs/agents/LOOP_ENGINEERING.md — background only |
| ../SWARM_KARPATHY.md, ../SWARM_ORCHESTRATION.md (Koin root) | Draft 7-role swarm + metrics loop design. Reference only — not implemented |
| docs/BUG_TRACKER.md | Google Sheets ↔ Linear bug sync setup |
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

<!-- OPENWIKI:START -->

## OpenWiki

This repository uses OpenWiki for recurring code documentation. Start with `openwiki/quickstart.md`, then follow its links to architecture, workflows, domain concepts, operations, integrations, testing guidance, and source maps.

The scheduled OpenWiki GitHub Actions workflow refreshes the repository wiki. Do not hand-edit generated OpenWiki pages unless explicitly asked; prefer updating source code/docs and letting OpenWiki regenerate.

<!-- OPENWIKI:END -->
