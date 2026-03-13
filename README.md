# devloop

A Claude Code plugin that structures AI-assisted development into phases. Without structure, coding agents generate inconsistent patterns and one-shot attempts that miss edge cases. devloop fixes this by breaking work into research, planning, design, and implementation — each phase produces an artifact the next one reads. No step touches code until `/dl:implement`.

## The loop

```
    /dl:research  →  /dl:plan  →  /dl:design  →  /dl:implement
         ↑               ↑             ↑               │
         └───────────────┴─────────────┴───────────────┘
              re-enter research when discoveries surface
```

- **research** — scan rules and codebase for context, surface gaps and recommendations
- **plan** — ask clarifying questions, produce an ordered task list
- **design** — generate architecture, Mermaid diagrams, and a detailed spec for each task
- **implement** — implement one task at a time against the spec, track completion

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
| `/dl:research` | Scan rules and codebase for context. Run without args for a project health check. |
| `/dl:plan` | Ask clarifying questions, create an ordered task list. Detects greenfield projects. |
| `/dl:design` | Generate architecture, Mermaid diagrams, and per-task specs with acceptance criteria. |
| `/dl:implement` | Implement one task at a time against the spec. Tracks progress across sessions. |
| `/dl:bootstrap` | Scaffold a new project entirely from rule docs. |
| `/dl:document` | Sync documentation after skill or config changes. |

`/dl:plan` and `/dl:design` support refine mode — invoke with no args when existing artifacts are found.

## What you get

- **Architecture diagrams** — `/dl:design` generates Mermaid diagrams (architecture, data flow, component, sequence) saved as `.mmd` files in `.work/designs/diagrams/`.
- **Cross-session tracking** — Task completion persists. Run `/dl:implement` in a new session and pick up where you left off.
- **Refine mode** — Run `/dl:plan` or `/dl:design` with no args to iterate on existing artifacts. Previous versions are backed up automatically.
- **Greenfield detection** — In a new project with no existing structure, `/dl:plan` suggests scaffolding as the first task.
- **Research health checks** — Run `/dl:research` with no topic to scan overall project health against your rules.
- **Rule-driven consistency** — Skills match task descriptions against rule keywords, so the same patterns apply everywhere.

For a deeper walkthrough, see [docs/workflow.md](docs/workflow.md).

## Rules

Rules are markdown files that guide skills at runtime — coding patterns, project structure, naming conventions. Skills resolve rules from four layers, highest precedence first:

| Precedence | Layer | Path | Description |
|---|---|---|---|
| 1 (highest) | User | `~/.claude/rules/` | Claude Code native, personal overrides |
| 2 | Project | `{cwd}/devloop/rules/` | Project-specific rules |
| 3 | Shared/org | `~/devloop/rules/` | Rule packs managed by devloop CLI |
| 4 (lowest) | Plugin-bundled | `${CLAUDE_PLUGIN_ROOT}/rules/` | Defaults shipped with devloop |

Drop `.md` files with YAML frontmatter into any of these directories and skills pick them up automatically via keyword matching. For project-specific rules, create a `devloop/rules/` directory in your project root and commit it to version control.

```yaml
---
keywords: [entity, model, JPA, persistence]
---
# Entity Rules

## Patterns

- Pattern one — what to do and why.
```

Rules are optional. Without them, skills work from codebase context alone. Start by dropping `.md` files with keyword frontmatter into `~/.claude/rules/` — skills discover them automatically. When you want organized, reusable rule sets, see [devloop-rules](https://github.com/minusblindfold/devloop-rules) for packs with a management CLI. The full format spec is in [`plugins/dl/rules/rules.md`](plugins/dl/rules/rules.md).

## Working directory

Skills read and write artifacts to `.work/` in the current project directory:

```
.work/
├── research/        # Research artifacts
├── plans/           # Task lists
├── designs/         # Design docs + diagrams/
└── implementations/ # Implementation notes
```

Artifacts follow the naming convention `YYYY-MM-DD-<slug>-<type>.md` (e.g., `2026-03-11-auth-design.md`). This keeps them sortable and identifiable across features. See [docs/artifacts.md](docs/artifacts.md) for details on how artifacts chain together.

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
