# Koinaku OpenWiki Instructions

This is the human-authored brief for OpenWiki repository documentation. Agents must read this during Loop Engineering v2 pre-flight before using generated OpenWiki pages.

## Purpose

Use OpenWiki as shared repo memory for Koinaku: architecture maps, workflow notes, domain concepts, source maps, tests, runbooks, and agent handoff context.

OpenWiki should help Claude Code, Codex, Kimi Code, and any future AI agent understand the codebase faster during `/loop` / Loop Engineering v2 runs.

## Authority

Generated OpenWiki pages are discovery and memory. They do not override:

1. Current human instructions.
2. `RULES.md`.
3. `AGENTS.md`, `CLAUDE.md`, and `KIMI_HANDOFF.md`.
4. `docs/agents/LOOP_ENGINEERING.md`.
5. `TASKS.md`.

## Koinaku Priorities

- Trust is the product: published lessons need reviewed Tier 1 Indonesian sources, preferably OJK, BI, or IDX.
- Keep the app web-first until the human explicitly resumes native iOS/Android work.
- Preserve the Loop Engineering v2 workflow: Conductor owns scope, Maker implements, Verifier is read-only, gates decide done.
- Highlight schema, RLS, auth/session, lesson publishing, paper trading, analytics, and notification workflows.
- Surface risks and stale docs rather than smoothing them over.

## Documentation Boundaries

- Do not hand-edit generated OpenWiki pages during normal loop runs.
- Prefer updating source docs/code, then running `openwiki code --update --print`.
- Do not include secrets, `.env*` values, app passwords, private tokens, or production credentials.
- Keep financial claims tied to cited sources and avoid unsupported investment advice.
