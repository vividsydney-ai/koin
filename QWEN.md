# Qwen Code — Koin project context

## Cross-agent claim protocol (mandatory)

Codex, Claude, Qwen, Kimi, and humans share the same Linear issues. Before editing any Linear-linked task, claim it:

```bash
node scripts/linear-claim.mjs claim --issue KO-XXX --agent qwen
```

- Allowed agents: `codex`, `claude`, `qwen`, `kimi`, `human`.
- First claim also sets an `author:qwen` label that never changes, so later agents can see who wrote the first pass versus who is correcting it.
- If the issue is already claimed by another agent, stop and pick another task (or escalate).
- Release when finishing work (keeps both `agent:qwen` and `author:qwen` as historical records):
  ```bash
  node scripts/linear-claim.mjs release --issue KO-XXX --agent qwen
  ```
- Use `--unassign` when pausing or handing the issue back to the pool:
  ```bash
  node scripts/linear-claim.mjs release --issue KO-XXX --agent qwen --unassign
  ```
- Use `--steal` only to recover a stale/crashed claim.

The issue's `agent:*` label in Linear shows the live owner on open issues and the last handler on closed issues. The `author:*` label shows who did the first pass.

## Project docs

Read `AGENTS.md` and `docs/agents/LOOP_ENGINEERING.md` for the full loop protocol.
Read `docs/agents/issue-tracker.md` for the claim protocol, Linear conventions, and Wayfinder operations.
