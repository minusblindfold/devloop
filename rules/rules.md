# Rules

Rules are markdown files that guide Claude Code skills (`/research`, `/plan`, `/design`, `/implement`, `/bootstrap`). Drop `.md` files into this directory and skills will discover them automatically.

## Getting started

Create a rule file with YAML frontmatter and markdown content:

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

The `keywords` field is the only required frontmatter. Skills match task descriptions against these terms to find relevant rules.

Create a `stack.md` to define your project skeleton (language, framework, build tool). This is the anchor rule — `/bootstrap` requires it to scaffold a project. Add more rules as needed: one per concern (e.g., `entity.md`, `service.md`, `controller.md`, `testing.md`).

## Format

### Frontmatter fields

| Field | Required | Values | Description |
|---|---|---|---|
| `keywords` | Yes | Array of strings | Terms for keyword-based discovery. Skills match task descriptions against these. |
| `scope` | No | `bootstrap`, `feature`, `all` | When this rule applies. Default: `all`. |
| `extends` | No | `true`, `false` | If true, appends to a higher-precedence version instead of being overridden. Default: `false`. |

`scope` and `extends` are only relevant when using rule packs with layered resolution. For project-level rules, `keywords` is all you need.

### Sections

- **`## Patterns`** — The core patterns and constraints. This is what skills follow during implementation.
- **`## Bootstrap`** — What this rule contributes when scaffolding a new project. `/bootstrap` reads these sections. Omit if the rule only applies during feature work.
- **`## Example`** — A concrete code sample. Helps the model understand the pattern in practice.

## How this relates to Claude Code's native rules

Put rule files here and they work everywhere — Claude Code reads them automatically, and skills use frontmatter to find the right ones for each task. No extra config needed.

Under the hood, two things happen:
- **Claude Code** natively loads all `.md` files in `~/.claude/rules/` into every session. No filtering — it treats frontmatter as regular text.
- **Skills** like `/research` and `/implement` also read these files, but filter by `keywords` and `scope` so they surface only what's relevant to the current task.

This means a simple rule file with just `keywords` gets the best of both: always available to Claude Code, and discoverable by skills when the topic matches.

Rule packs (managed by [devenv-rules](https://github.com/minusblindfold/devenv-rules)) live in separate directories outside `~/.claude/rules/` and are only discovered by skills — Claude Code doesn't auto-load them. This keeps context lean.

**Note on `paths:` frontmatter.** Claude Code's native rules support a `paths:` field that controls which files trigger the rule to load (e.g., `paths: ["src/**/*.ts"]`). That's file-glob scoping — different from this system's `scope:` field, which controls workflow phase (bootstrap vs feature work). You can use both in the same file if needed.

## Rule packs

For organized, reusable rule sets with management tooling, see [devenv-rules](https://github.com/minusblindfold/devenv-rules). Packs live in their own directories (not in `~/.claude/rules/`) and are discovered by `/resolve-rules` via a layers file (`~/.config/devenv/rule-layers`). This means they're only surfaced to skills when relevant — Claude Code doesn't auto-load them into every session.

Packs add two frontmatter fields that don't matter for simple project-level rules:
- **`scope`** — controls when a rule applies: `bootstrap` (scaffolding only), `feature` (feature work only), or `all` (both — the default). Useful when a pack has rules that only matter during project setup.
- **`extends`** — when multiple packs define a rule with the same filename, `extends: true` appends to the higher-precedence version instead of being shadowed. This is how a project-level rule can add to an org-level standard.
