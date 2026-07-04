# Creating a Rule Pack

A rule pack is a directory of markdown files that guide devloop skills during planning, design, and implementation. "Installing" one means copying its `.md` files into your project's `devloop/rules/`.

## Quick start

1. Copy this `_template/` directory and rename it (e.g., `my-stack/`).
2. Edit `stack.md` — define your language, framework, build tool, and project structure so skills scaffold and plan against the right stack.
3. Add more rules — one file per concern (e.g., `service.md`, `testing.md`, `api.md`).
4. Give each file a `keywords` array in YAML frontmatter; omit it for rules that should apply to every task.

## Rule file format

```markdown
---
keywords: [service, business logic, validation]   # Optional — omit to apply to every task
---
# Rule Title

> One-line description.

## Patterns

- Pattern or constraint to follow.

## Example

Concrete code showing the rule in practice.
```

The full format spec (including the `repos` field for linked repositories) is in [docs/rules.md](../../../docs/rules.md).

## Tips

- Keep rules focused — one concern per file, named after the concern (`entity.md`, `controller.md`, `testing.md`).
- The `## Patterns` section is what skills follow most closely. Be specific.
- Use `## Example` to show the pattern concretely — this helps the model understand intent.
- Prose rules are for patterns and judgment; anything a command can check (lint, typecheck, tests) belongs in a hook — see [examples/hooks/](../../hooks/).
