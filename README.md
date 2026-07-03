# devloop

A Claude Code plugin that structures AI-assisted development into phases. Without structure, coding agents generate inconsistent patterns and one-shot attempts that miss edge cases. devloop fixes this by breaking work into brainstorming, research, planning, design, implementation, and review — each phase produces an artifact the next one reads. No step touches code until `/dl:implement`.

## The loop

```
  brainstorm → research → plan → design → implement → review
                  ↑          ↑       ↑         │
                  └──────────┴───────┴─────────┘
                   re-enter research when
                   discoveries surface
```

- **brainstorm** — recommended entry point; sizes the work, then iterative questioning to refine a feature idea, producing decisions and research queries
- **research** — execute research queries from brainstorm as targeted codebase searches
- **plan** — ask clarifying questions, produce an ordered task list
- **design** — generate architecture, Mermaid diagrams, and a detailed spec for each task
- **implement** — implement one task at a time against the spec, track completion
- **review** — load rules and design context, review code for rule violations and security issues

Start with `/dl:brainstorm` — it sizes the work and routes it: **small** changes get a mini-spec and go straight to `/dl:implement`; **medium** work skips research and goes to `/dl:plan`; **large** features run the full pipeline with design review as the mandatory checkpoint. `/dl:research` can re-enter at any stage when discoveries surface during implementation.

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
| `/dl:brainstorm` | Recommended entry point. Sizes the work (small/medium/large), then iterative questioning to refine the idea. Small work produces a mini-spec for direct implementation. |
| `/dl:research` | Execute research queries from brainstorm as targeted codebase searches, or research a topic directly. Runs in a forked subagent — scan noise stays out of your session. |
| `/dl:plan` | Ask clarifying questions, create a vertically-sliced task list. Detects greenfield projects. |
| `/dl:design` | Primary review checkpoint. Generate architecture, Mermaid diagrams, and per-task specs. |
| `/dl:implement` | Implement one task at a time against the spec. Tracks progress across sessions. |
| `/dl:review` | Load rules and design context, review code for rule violations and security issues. Works standalone or after `/dl:implement`. Runs in a forked subagent; archives the feature marker on completion. |
`/dl:plan` and `/dl:design` support refine mode — invoke with no args when existing artifacts are found.

## What you get

- **Architecture diagrams** — `/dl:design` generates Mermaid diagrams (architecture, data flow, component, sequence) saved as `.mmd` files in `.work/designs/diagrams/`.
- **Cross-session tracking** — Task completion lives as checkboxes in the plan artifact itself. Run `/dl:implement` in a new session and pick up where you left off.
- **Refine mode** — Run `/dl:plan` or `/dl:design` with no args to iterate on existing artifacts.
- **Greenfield detection** — In a new project with no existing structure, `/dl:plan` suggests scaffolding as the first task.
- **Active feature tracking** — Skills auto-detect the active feature via `.work/active/<slug>.md` markers. Start a brainstorm or plan, and every downstream skill auto-selects it — no re-specifying slugs. Supports multiple concurrent features for multi-agent workflows.
- **Rule-driven consistency** — Skills match task descriptions against rule keywords, so the same patterns apply everywhere.
- **Linked repositories** — Declare related repos in rule frontmatter and `/dl:brainstorm` and `/dl:research` will scan them for cross-repo context.

For a deeper walkthrough, see [docs/workflow.md](docs/workflow.md).

## Rules

Rules are markdown files that guide skills at runtime — coding patterns, project structure, naming conventions. They live in one place: `devloop/rules/` in your project root, committed to version control. Skills pick them up automatically via keyword matching; a rule without `keywords` applies to every task.

```yaml
---
keywords: [entity, model, JPA, persistence]
---
# Entity Rules

## Patterns

- Pattern one — what to do and why.
```

Rules can also declare linked repositories with `repos` — paths to other local repos that skills should scan for cross-repo context:

```yaml
---
keywords: [ecosystem, integration]
repos: [~/code/payments-service, ~/code/shared-types]
---
```

When `/dl:brainstorm` or `/dl:research` resolve a rule with `repos`, they scan those directories for relevant code, API contracts, and shared types. Paths must be home-relative (`~/...`). See [`devloop/rules/ecosystem.md`](devloop/rules/ecosystem.md) for a working example.

Rules are optional. Without them, skills work from codebase context alone. For ready-made rule sets, copy a pack from [`examples/rule-packs/`](examples/rule-packs/) into your project's `devloop/rules/`. Prose rules are for patterns and judgment — anything a command can check belongs in a hook instead ([`examples/hooks/`](examples/hooks/)). The full format spec is in [`docs/rules.md`](docs/rules.md).

## Working directory

Skills read and write artifacts to `.work/` in the current project directory:

```
.work/
├── active/          # Active feature markers for workflow continuity
├── archive/         # Markers of completed features
├── brainstorms/     # Feature brainstorm decision logs
├── research/        # Research artifacts
├── plans/           # Task lists
├── designs/         # Design docs + diagrams/
├── implementations/ # Implementation notes
└── reviews/         # Code review findings
```

Artifacts follow the naming convention `YYYY-MM-DD-<slug>-<type>.md` (e.g., `2026-03-11-auth-design.md`). This keeps them sortable and identifiable across features. See [docs/artifacts.md](docs/artifacts.md) for details on how artifacts chain together.

Add `.work/` to your `.gitignore`.

## Terminal companion tools

For terminal-based artifact browsing (`view-brainstorm`, `view-plan`, `view-design`, `view-research`, `view-implement`, `open-diagrams`, `claude-context`), see [devenv](https://github.com/minusblindfold/devenv). These are optional CLI tools that complement the plugin.

## License

[MIT](LICENSE)
