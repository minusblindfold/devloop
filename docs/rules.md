# Rules

Rules are markdown files in `devloop/rules/` at your project root. They guide devloop skills at runtime — coding patterns, naming conventions, architectural decisions. Skills discover them automatically; commit the directory to version control.

## Getting started

Create `devloop/rules/` and drop in a `.md` file:

```markdown
---
keywords: [service, business logic, validation]
---
# Service Layer Rules

> One-line description of what this rule covers.

## Patterns

- Pattern one — what to do and why.
- Pattern two — constraints or guidelines to follow.

## Example

A concrete code example showing the pattern in practice.
```

Add one rule per concern (`service.md`, `controller.md`, `testing.md`). For ready-made sets, copy a pack from [`examples/rule-packs/`](../examples/rule-packs/) into your project's `devloop/rules/`.

## Frontmatter

| Field | Required | Description |
|---|---|---|
| `keywords` | No | Terms matched against the task or topic. **A rule without `keywords` applies to every task** — use for cross-cutting conventions. |
| `repos` | No | Home-relative paths (`~/...`) to related local repos. `/dl:brainstorm` and `/dl:research` scan them for cross-repo context (integration points, API contracts, shared types). Missing repos are skipped. |

## How skills use rules

- Most skills match your task description against `keywords` and apply what's relevant — a task about services pulls in `service.md`, not `testing.md`. This keeps context lean as your rule set grows.
- `/dl:design` names applicable rules in each task spec (`**Rules:** Service Layer Rules`); `/dl:implement` and `/dl:review` then apply those rules by matching the titles against rule H1 headings.
- No `devloop/rules/` directory? Skills work from codebase context alone. Rules are additive, not required.

## Why not `.claude/rules/`?

Claude Code natively loads every file in `.claude/rules/` into every session (optionally scoped by `paths:` file globs). That's fine for a handful of always-on rules, but it defeats keyword scoping — a large rule set crowds the context window with guidance irrelevant to the task. Keeping rules in `devloop/rules/` means skills load only what matches. Use both if you like: `.claude/rules/` for things every session needs, `devloop/rules/` for pattern guidance skills pull in on demand. Native `paths:` globs and this system's `keywords` can coexist in the same file.

## Rules vs hooks

Prose rules are for patterns and judgment. Anything a command can check — lint, typecheck, tests — belongs in a [hook](https://docs.claude.com/en/docs/claude-code/hooks): instructions can get dropped under context pressure, hooks always run.

Hooks now cover more than shell commands. Five hook types handle different enforcement shapes: `command` runs a shell command, `prompt` injects instructions into the conversation, `agent` dispatches a subagent to evaluate the event, `http` calls an external endpoint, and `mcp_tool` invokes an MCP tool. Conditional `if` matchers fire a hook only when an expression matches (tool name, file path, and so on). Skills can also declare their own hooks in frontmatter, scoping enforcement to when that skill is active. devloop wires no hooks itself — which checks to enforce is your call. See [`examples/hooks/`](../examples/hooks/) for a command-type PostToolUse template.
