# Delivery workflow

## Loop Engineering v2

Koinaku uses Loop Engineering v2 to keep work bounded and independently verified. The authoritative operational references are `AGENTS.md`, `.agents/skills/loop/SKILL.md`, and `docs/agents/LOOP_ENGINEERING.md`; this page is a navigation aid, not a replacement.

Before planning a task:

1. Resume an active `loop-state.md` or `.loop/state.md` when present; do not stack a new task on an unfinished loop.
2. Read [the human-authored OpenWiki brief](INSTRUCTIONS.md), then task-relevant generated pages.
3. Read handoff, task, policy, domain, schema, and decision sources required by the change.
4. Define one small vertical slice with an explicit done condition.

The Conductor owns scope and state. For complex/risky work, use separate Planner, Maker, Verifier, Fixer, and Lander roles. The Verifier is read-only and the Maker cannot provide official self-certification. One editor holds the loop state at a time.

## When to serialize

Do not parallelize changes that touch:

- `supabase/migrations/` or generated Supabase types;
- authentication/session storage;
- source and lesson-publishing rules;
- dependency upgrades; or
- `ios/` / `android/` assets.

Use one migration at most for a task. A migration introducing a user-sensitive table must include its RLS policy. Native release work is paused even though Capacitor projects and scripts remain in the repository.

## Verification and landing

Use the scripts in `package.json` and the task-specific program metric where one exists. The normal baseline is:

```bash
pnpm type-check
pnpm lint
pnpm test
pnpm build
pnpm loop:gates
```

For a Loop verification run, the current skill additionally expects a diff scan for prohibited browser storage, unsafe publishing, and RLS omissions. Record actual outcomes in the appropriate loop/session artifacts; do not claim a fixed passing-test count because the suite evolves.

After a green task, the Lander updates only the prescribed project memory (`TASKS.md` when truly complete, `progress.md`, session log, Linear issue, and archived loop state/budget). Apply a migration before releasing code that depends on it, then run the production checks in `docs/DEPLOYMENT.md`. If a gate repeats the same root-cause failure twice, budget expires, a credential/production decision is needed, or the task conflicts with human policy, stop and escalate.

## Current change context

Recent shipped work makes the following paths especially sensitive:

- **Lesson completion and replay:** migrations 048/049/051 plus `LessonPlayer`, `QuizEngine`, and lesson services. Read [Learning, trust, and account workflows](learning-and-trust.md) before modifying rewards, attempts, or quiz persistence.
- **Localization:** `lib/i18n/` and migration 050. The active UI preference is `user_settings.locale`.
- **Signup protection:** `app/signup/page.tsx` and `lib/auth/client.ts`; CAPTCHA is optional until human-operated Cloudflare/Supabase activation is complete.
- **UI lift:** `DESIGN.md` defines the accepted token and component conventions. `TASKS.md` lists UI-LIFT-1 through UI-LIFT-6; two decisions remain human-owned: streak color (red versus gold) and whether to add real OHLC data instead of synthesizing a chart from daily closes.

## How to use this wiki on future work

- Start with [Quickstart](quickstart.md), then use [Architecture](architecture.md) for source boundaries and [Learning, trust, and account workflows](learning-and-trust.md) for the recent high-risk contracts.
- Prefer current implementation and migrations over old narrative docs when exact behavior differs.
- Refresh this wiki after landed changes to architecture, workflows, schema contracts, security posture, or agent runbooks. Do not hand-edit `INSTRUCTIONS.md` during a normal refresh.
