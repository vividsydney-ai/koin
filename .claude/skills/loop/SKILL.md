---
name: loop
description: Run Koinaku Loop Engineering v2 as Conductor with OpenWiki pre-flight and swarm routing. Resumes loop-state.md if active, otherwise takes the goal given as args (or the first eligible TASKS.md item/batch), reads OpenWiki repo memory, chooses linear vs parallel execution, dispatches Planner/Maker/Verifier/Fixer/Lander roles, lands on web-koinaku, and logs. Use when asked to "fwd / loop", "/loop", "loop", "use loop eng", "act as conductor", or to pick up the next task.
---

# /loop — Koinaku Loop Engineering v2 (Conductor mode)

This is the Claude Code entry point for `/loop` in this repo. The full protocol —
task selection, swarm routing (Planner → Maker → Verifier → Fixer → Lander), gates,
budget, and escalation rules — lives in `.agents/skills/loop/SKILL.md`. That file is
the single source of truth, shared with Kimi and Codex via the repo's `.agents/`
convention, so all agents follow identical rules.

**Read `.agents/skills/loop/SKILL.md` in full right now and execute it exactly,
acting as Conductor.** Do not improvise a different protocol and do not duplicate
its logic here — if the two files ever disagree, `.agents/skills/loop/SKILL.md` wins.

If `$ARGUMENTS` was given to this skill, treat it as the task/goal argument
described in that file's "Task selection" section.
