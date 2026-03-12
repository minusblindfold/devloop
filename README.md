# devloop

A Claude Code plugin that structures feature work into phases. Each phase produces an artifact the next one reads — no step touches code until `/dl:implement`.

## The workflow

```
/dl:research  →  /dl:plan  →  /dl:design  →  /dl:implement
```

- **research** — scan rules and codebase for context relevant to a topic
- **plan** — ask clarifying questions, then produce an ordered task list
- **design** — generate architecture, diagrams, and a spec for each task
- **implement** — implement one task at a time against the spec

`/dl:bootstrap` scaffolds a new project from rule docs. `/dl:research` can re-enter at any stage — run it before planning, after design, or when discoveries surface during implementation.

## Install

### From marketplace

```bash
claude plugin marketplace add minusblindfold/devloop
claude plugin install dl
```

### For development

```bash
git clone https://github.com/minusblindfold/devloop.git
claude --plugin-dir ./devloop
```

Use `/reload-plugins` after making changes during development.

## Skills

| Skill | What it does |
|-------|-------------|
| `/dl:research` | Scan rules and codebase, produce structured context |
| `/dl:plan` | Ask clarifying questions, create an ordered task list |
| `/dl:design` | Generate architecture, diagrams, and per-task specs |
| `/dl:implement` | Implement one task at a time against the spec |
| `/dl:bootstrap` | Scaffold a new project from rule docs |
| `/dl:document` | Sync documentation after changes |

`/dl:plan` and `/dl:design` support refine mode — invoke with no args when existing artifacts are found.

## Rules

Rules are markdown files that guide skills at runtime — coding patterns, project structure, naming conventions. Drop `.md` files with YAML frontmatter into `~/.claude/rules/` and skills pick them up automatically via keyword matching.

```yaml
---
keywords: [entity, model, JPA, persistence]
---
# Entity Rules

## Patterns

- Pattern one — what to do and why.
```

The `rules/rules.md` file in this plugin documents the full format. For organized packs with a management CLI, see [devloop-rules](https://github.com/minusblindfold/devloop-rules).

## Working directory

Skills read and write artifacts to `.work/` in the current project directory:

```
.work/
├── research/     # Research artifacts
├── plans/        # Task lists
├── designs/      # Design docs + diagrams/
└── implementations/  # Implementation notes
```

Add `.work/` to your `.gitignore`.

## Config

`devenv.json` in the plugin root controls skill behavior:

```json
{
  "backups": { "maxPerArtifact": 5 },
  "work": { "dir": ".work" }
}
```

## Terminal companion tools

For terminal-based artifact browsing (`view-plan`, `view-design`, `view-research`, `view-implement`, `open-diagrams`, `claude-context`), see [devenv](https://github.com/minusblindfold/devenv). These are optional CLI tools that complement the plugin.

## License

[MIT](LICENSE)
