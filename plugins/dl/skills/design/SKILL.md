---
name: design
description: Generates design documents with architecture, diagrams, and task specs from a plan. Use when designing, architecting, or speccing out a feature.
argument-hint: "[plan slug]"
allowed-tools: Read Write Bash TaskCreate
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Artifact — required output

Write design files to `.work/designs/` (and `.work/plans/` in bootstrap mode). Save all artifacts before proceeding to wrap up. Do not present the design to the user or suggest next steps until all artifact files have been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Mode

If $ARGUMENTS is set → check `.work/designs/` for `*<arg>*-design.md` (refine) or `.work/plans/` by exact filename or unambiguous prefix (create). If ambiguous in either case, list matches and ask. No match → bootstrap mode.
If $ARGUMENTS is empty → list designs. None: fall through to plan picker. One: offer refine or new. Many: numbered list.

Plan picker: list `.work/plans/`. None → ask "What would you like to design?" and enter bootstrap mode. One → auto-select. Many → ask.

## Create mode

**Constraint:** Do not write code. This skill produces a design, not an implementation.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read plan: extract name, tasks, dependencies
- [ ] Read CLAUDE.md and scan directory
- [ ] Check for .work/bootstrap.md
- [ ] Ask 2–3 clarifying questions
- [ ] Write design doc (Overview, Architecture, Task Specs)
- [ ] Write Mermaid diagrams to .work/designs/diagrams/
- [ ] Write design to .work/designs/
- [ ] Gate: verify design file and .mmd files with ls
- [ ] Present design for review
```

1. Read the plan. Extract name, tasks, and dependencies.
2. Read `CLAUDE.md` if present. Scan the project directory.
   2a. Check `.claude/skills/` for available skills.
   2b. Check for `.work/bootstrap.md` — if found, read it. Reference the bootstrapped stack as established, not proposed.
3. Ask 2–3 clarifying questions. Wait for answers.
   - If bootstrap context was found: skip architecture-style questions (already decided). Focus on data relationships, UI flow, edge cases.
   - If no bootstrap context: ask as normal, including architecture style if unclear.
4. Write the Overview and Architecture sections.
5. Choose diagrams that best illuminate the plan — see [diagrams.md](diagrams.md). A feature may warrant more than one; omit diagrams for trivial tasks. Save each as a `.mmd` file in `.work/designs/diagrams/`. List them in the doc; do not embed diagram code inline.
6. Write a spec for each plan task: Goal, Interfaces, Implementation notes, Acceptance criteria, Tests, Dependencies. Note which rules apply by title (e.g., `**Rules:** JPA Entity Rules, Liquibase Migration Rules`). This tells `/implement` which docs to apply via `/resolve-rules` explicit mode.
7. Write the complete design to `.work/designs/YYYY-MM-DD-<slug>-design.md`.

### Gate

Run `ls` on the design file and each `.mmd` file. If any are missing, write them now. Do not proceed until all files are confirmed on disk.

### Wrap up

Ask the user to review. Once confirmed, suggest running `/implement` to begin.

## Bootstrap mode

For simple features where no plan exists yet. Treat $ARGUMENTS as the feature description.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Ask 1–2 clarifying questions
- [ ] Create minimal plan (1–3 tasks)
- [ ] Write plan to .work/plans/
- [ ] Gate: verify plan file with ls
- [ ] Confirm plan with user
- [ ] Proceed to create mode
```

1. Ask 1–2 focused clarifying questions (scope and key constraints). Wait for answers.
2. Create a minimal plan — typically 1–3 tasks — using the format in the `/plan` skill's `## Plan format` section.
3. Write the plan to `.work/plans/YYYY-MM-DD-<slug>.md`.

### Gate

Run `ls` on the file path. Do not proceed to create mode until the file is confirmed on disk.

### Next

Confirm the plan with the user ("Here's the plan I'll design from — does this look right?"). Adjust if needed. Then proceed to create mode using the saved plan.

## Refine mode

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Back up current file
- [ ] Show current design
- [ ] Ask what to change — iterate until confirmed
- [ ] Write updated file and .mmd files
- [ ] Gate: verify all files with ls
```

1. Back up the current file — see [backup.md](../backup.md).
2. Show the current design.
3. Ask "What would you like to change?" Iterate until confirmed.
4. Write the updated file and `.mmd` files once.

### Gate

Run `ls` on the design file and each `.mmd` file. If any are missing, write them now. Do not proceed until all files are confirmed on disk.

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

- Do not write code. This skill produces a design, not an implementation.
- Only reference skills found in `.claude/skills/`.
- Stay grounded in the plan — do not invent tasks.
