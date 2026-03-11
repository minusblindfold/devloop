---
name: design
description: Generate a design document from a plan. Use when the user wants to design, architect, or spec out a feature.
argument-hint: "[plan slug]"
allowed-tools: Read Write Bash TaskCreate
---

Create or refine a feature design.

## Config

Read `devenv.json` from `${CLAUDE_PLUGIN_ROOT}/devenv.json` (if running as a plugin) or `~/.claude/devenv.json` (fallback). Keys: `work.dir` (default `.work`), `backups.maxPerArtifact` (default 5, applies to refine mode only).

## Mode

If $ARGUMENTS is set → check `<work.dir>/designs/` for `*<arg>*-design.md` (refine) or `<work.dir>/plans/` by exact filename or unambiguous prefix (create). If ambiguous in either case, list matches and ask. No match → bootstrap mode.
If $ARGUMENTS is empty → list designs. None: fall through to plan picker. One: offer refine or new. Many: numbered list.

Plan picker: list `<work.dir>/plans/`. None → ask "What would you like to design?" and enter bootstrap mode. One → auto-select. Many → ask.

## Bootstrap mode

For simple features where no plan exists yet. Treats $ARGUMENTS as the feature description.

1. Ask 1–2 focused clarifying questions (scope and any key constraints). Wait for answers.
2. Create a minimal plan — typically 1–3 tasks — using the format in the `/plan` skill's `## Plan format` section.
3. Save it to `<work.dir>/plans/YYYY-MM-DD-<slug>.md`.
4. Confirm the plan with the user ("Here's the plan I'll design from — does this look right?"). Adjust if needed.
5. Proceed to create mode using the saved plan.

## Create mode

1. Read plan: extract name, tasks, dependencies.
2. Explore codebase: read `CLAUDE.md`, scan directory, check `.claude/skills/`. Check for `<work.dir>/bootstrap.md` — if found, read it. The architecture section should reference the bootstrapped stack as established rather than proposing it.
3. Ask 2–3 questions. Wait for confirmation.
   - If bootstrap context was found: skip architecture-style questions (already decided). Focus on design-specific questions — data relationships, UI flow, edge cases.
   - If no bootstrap context: ask as normal, including architecture style if unclear.
4. Write design doc with: Overview, Architecture, Diagrams, Task Specs.
5. Choose diagrams that best illuminate the plan — see [diagrams.md](diagrams.md). A feature may warrant more than one; omit diagrams for trivial tasks. Save each as a `.mmd` file in `<work.dir>/designs/diagrams/`. List them in the doc; do not embed code inline.
6. For each plan task write a spec: Goal, Interfaces, Implementation notes, Acceptance criteria, Dependencies. Also note which rules apply by title (e.g., `**Rules:** JPA Entity Rules, Liquibase Migration Rules`). This tells `/implement` which docs to apply via `/resolve-rules` explicit mode.
7. Save design to `<work.dir>/designs/YYYY-MM-DD-<slug>-design.md`.
8. Ask the user to review. Once confirmed, suggest running `/implement` to begin.

## Refine mode

1. Back up the current file — see [backup.md](../backup.md).
2. Show current design.
3. Ask "What would you like to change?" Iterate until confirmed.
4. Write updated file and `.mmd` files once.

## Design format

```markdown
# <Feature Name> Design

**Plan:** `<plan-filename>.md`

## Overview

One paragraph: what this feature does, why, and the approach taken.

## Architecture

Key design decisions, component structure, and data flow.

## Diagrams

- [High-level architecture](diagrams/YYYY-MM-DD-<slug>-arch.mmd)
- [Data flow](diagrams/YYYY-MM-DD-<slug>-flow.mmd)

_(include only the diagrams that apply)_

## Task Specs

### Task title

**Goal:** What this task achieves.
**Interfaces:** Public APIs, function signatures, or data shapes involved.
**Implementation notes:** Approach, constraints, anything non-obvious.
**Acceptance criteria:** How to verify it's done.
**Tests:** What to test — key scenarios, edge cases, and integration points. Name the test class or file where they belong.
**Dependencies:** Other tasks or external systems this relies on.
**Rules:** Rule titles that apply (e.g., JPA Entity Rules, Liquibase Migration Rules). Omit if none apply.
```

## Rules

- Never implement.
- Only reference skills found in `.claude/skills/`.
- Stay grounded in the plan — do not invent tasks.
