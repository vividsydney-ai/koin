# Issue Tracker: Linear

Issues for this repo live in Linear under team `KO`:  
https://linear.app/vnsavitri/team/KO/overview

## Conventions

- **Team:** `KO` (Koin)
- **Phase-level issues:** `KO-5` through `KO-12`
- **Sub-issues / vertical slices:** `KO-13` and above
- **Status workflow:** Backlog → Todo → In Progress → In Review → Done

## Atomic task rule

Every implementation task must have a Linear issue **before coding starts**.  
Multi-outcome tasks must be atomized into linked child issues.

Use the helper:

```bash
node scripts/linear-task-sync.mjs \
  --task-id KO-XXX \
  --title "[KO-XXX] Task title" \
  --description "Task description" \
  --children .loop/tasks/KO-XXX-children.json
```

Children spec (`.loop/tasks/KO-XXX-children.json`):

```json
[
  {
    "title": "[KO-XXX-A] Atomic child",
    "description": "What done means for this slice.",
    "state": "Todo"
  }
]
```

The helper:

- searches for existing issues before creating anything;
- creates a parent issue when none exists;
- creates missing atomic children under the parent;
- writes the resulting IDs into `loop-state.md`.

## Loop integration

`npm run loop:init` (or `scripts/loop-init.sh`) runs the sync helper automatically.
If the task has no Linear parent, initialization fails — fix tracking first.

The landing gate (`scripts/gate-runner.sh` Gate 7) checks:

1. `loop-state.md` contains a Linear parent link.
2. No `TODO`/`FIXME`/`HACK`/`FOLLOW-UP`/`XXX` comments land without a `[KO-###]` reference.

## When a skill says "create an issue"

Create the issue in Linear under team `KO` using the Linear API. Return the new ticket identifier (e.g., `KO-42`) to the user.

If the issue is a sub-task of an existing phase ticket, set the parent issue ID so it appears nested in Linear.

## When a skill says "fetch the relevant ticket"

Use the Linear identifier provided by the human (e.g., `KO-5`). Query the Linear API for the issue by identifier and read its title, description, and state.

## When a skill says "publish to the issue tracker"

Update the relevant Linear issue. If no issue exists yet, create one. Add a comment with the summary if the work spans multiple sessions.

## Pull requests

External PRs are **not** a triage surface for this repo. All external work flows through Linear issues first.
