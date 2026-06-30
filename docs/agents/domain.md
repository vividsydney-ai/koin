# Domain Docs

How the engineering skills should consume this repo's domain documentation.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root
- **`ADL.md`** at the repo root — architecture decision log

If either file doesn't exist, proceed silently. Don't flag its absence unless the skill specifically requires domain knowledge.

## File structure

Single-context repo:

```
/
├── CONTEXT.md
├── ADL.md
├── docs/agents/
└── ...
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a test name, or code), use the term as defined in `CONTEXT.md`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for future `/domain-modeling`).

## Flag ADR conflicts

If your output contradicts an existing entry in `ADL.md`, surface it explicitly rather than silently overriding:

> _Contradicts ADL-002 (paper trading in MVP) — but worth reopening because…_
