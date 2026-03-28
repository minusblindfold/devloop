# Artifacts

Skills communicate through files in `.work/`. Each phase reads the previous phase's artifact and writes its own. This creates a reviewable chain — you can inspect any artifact to understand what the agent knew and decided at that point.

## Directory structure

```
.work/
├── brainstorms/        # Feature brainstorm decision logs
├── research/           # Context scans
├── plans/              # Ordered task lists
├── designs/            # Architecture docs and specs
│   └── diagrams/       # Mermaid .mmd files
├── implementations/    # Per-task implementation notes
└── reviews/            # Code review findings
```

## Naming convention

Artifacts follow the pattern `YYYY-MM-DD-<slug>-<type>.md`:

```
2026-03-11-user-auth-brainstorm.md
2026-03-11-user-auth-research.md
2026-03-11-user-auth.md              (plan — no type suffix)
2026-03-11-user-auth-design.md
2026-03-11-user-auth-task-1.md       (implementation note)
2026-03-11-user-auth-review.md       (code review)
```

- **Date prefix** — keeps artifacts sortable by when they were created
- **Slug** — a short identifier for the feature, consistent across all phases
- **Type suffix** — identifies the phase (`brainstorm`, `research`, `design`, `task-N`); plans omit the suffix

Slugs are how skills find related artifacts. When you run `/dl:design`, it matches the slug from your plan to locate the right file.

## How artifacts chain

```
/dl:brainstorm → .work/brainstorms/<slug>-brainstorm.md (includes Research Queries)
                      ↓ (required — feeds research queries)
/dl:research   → .work/research/<slug>-research.md
                      ↓ (feeds context)
/dl:plan       → .work/plans/<slug>.md
                      ↓ (required — feeds task list)
/dl:design     → .work/designs/<slug>-design.md + diagrams/<slug>-*.mmd
                      ↓ (required — feeds specs; primary review checkpoint)
/dl:implement  → .work/implementations/<slug>-task-N.md + code changes
                      ↓ (optional — reviews changes)
/dl:review     → .work/reviews/<slug>-review.md
```

- `/dl:brainstorm` is the required entry point. It produces decisions, research queries, and codebase context through iterative conversation.
- `/dl:research` requires a brainstorm artifact. It executes the Research Queries section as targeted codebase searches rather than broad scans.
- `/dl:plan` reads brainstorm and research artifacts. Decisions from brainstorming and gaps from research inform clarifying questions and task ordering. Tasks are vertically-sliced.
- `/dl:design` requires a plan. It produces a spec for each task and is the primary review checkpoint — reviewed thoroughly before implementation.
- `/dl:implement` requires a plan and design. It implements one task at a time against the spec.
- `/dl:review` is optional. It reviews changes for rule violations and security issues. Works standalone or after `/dl:implement`.

## Diagrams

`/dl:design` generates Mermaid diagrams as `.mmd` files in `.work/designs/diagrams/`. Each diagram shares the design file's date-slug prefix:

```
.work/designs/
├── 2026-03-11-user-auth-design.md
└── diagrams/
    ├── 2026-03-11-user-auth-arch.mmd        # High-level architecture
    ├── 2026-03-11-user-auth-flow.mmd        # Data flow
    ├── 2026-03-11-user-auth-component.mmd   # Component design
    └── 2026-03-11-user-auth-sequence.mmd    # Step-by-step interactions
```

Not every design needs all four types. The skill picks diagram types that best illuminate the feature — an architecture diagram plus a sequence diagram if both structure and interaction flow are non-obvious.

Diagrams use Mermaid syntax (`graph TD` or `sequenceDiagram`). They're listed in the design doc under a `## Diagrams` section but not embedded inline.

## Gitignore

Add `.work/` to your project's `.gitignore`. These are ephemeral workflow artifacts — they capture the agent's reasoning and decisions during development, but they're not source code. The value is in the code and commits they produce, not in the artifacts themselves.

```
# devloop workflow artifacts
.work/
```
