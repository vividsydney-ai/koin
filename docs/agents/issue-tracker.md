# Issue Tracker: Linear

Issues for this repo live in Linear under team `KO`:
https://linear.app/vnsavitri/team/KO/overview

## Conventions

- **Team:** `KO` (Koin)
- **Phase-level issues:** `KO-5` through `KO-12`
- **Sub-issues / vertical slices:** `KO-13` and above
- **Status workflow:** Backlog → Todo → In Progress → In Review → Done

## When a skill says "create an issue"

Create the issue in Linear under team `KO` using the Linear API. Return the new ticket identifier (e.g., `KO-42`) to the user.

If the issue is a sub-task of an existing phase ticket, set the parent issue ID so it appears nested in Linear.

## When a skill says "fetch the relevant ticket"

Use the Linear identifier provided by the human (e.g., `KO-5`). Query the Linear API for the issue by identifier and read its title, description, and state.

## When a skill says "publish to the issue tracker"

Update the relevant Linear issue. If no issue exists yet, create one. Add a comment with the summary if the work spans multiple sessions.

## Pull requests

External PRs are **not** a triage surface for this repo. All external work flows through Linear issues first.
