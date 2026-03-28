---
name: design
description: Generates design documents with architecture, diagrams, and task specs from a plan. Use when designing, architecting, or speccing out a feature.
argument-hint: "[plan slug]"
allowed-tools: Read Write Bash TaskCreate
---

Execute each section in order. Copy the checklist from your mode's section and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/designs/` (and `.work/plans/` in bootstrap mode). Verify with `ls` before wrapping up.

## Mode

**Active feature detection:** Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug — print "Auto-selected feature: <slug>". If multiple markers exist, list them and ask. Arguments always override the marker.

If $ARGUMENTS (or auto-selected slug) is set → check designs for match (refine), then plans for match (create). No match → bootstrap mode. Ambiguous → list and ask.
If $ARGUMENTS is empty → list designs. None: fall through to plan picker. One: offer refine or new. Many: numbered list. Plan picker: list plans. None → bootstrap mode. One → auto-select. Many → ask.

## Create mode

**Constraint:** Do not write code. This skill produces a design, not an implementation.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read plan: extract name, tasks, dependencies
- [ ] List extracted tasks and dependencies in response
- [ ] Read CLAUDE.md
- [ ] Scan project directory and .claude/skills/
- [ ] Check for .work/bootstrap.md
- [ ] Ask clarifying questions
- [ ] Write Overview and Architecture
- [ ] Write Task Specs
- [ ] Write Mermaid diagrams to .work/designs/diagrams/
- [ ] Write design to .work/designs/
- [ ] Gate: verify design file and .mmd files with ls
- [ ] Present design for review
```

1. Read the plan. Extract name, tasks, and dependencies.
2. List the extracted tasks and dependencies in your response before proceeding.
3. Read `CLAUDE.md` if present.
4. Scan the project directory. Check `.claude/skills/` for available skills.
5. Check for `.work/bootstrap.md` — if found, read it. Reference the bootstrapped stack as established, not proposed.
6. Ask 2–3 clarifying questions. Wait for answers. Read prior artifact decisions — only ask about genuinely unresolved items.
7. Write the Overview and Architecture sections.
8. Choose diagrams that best illuminate the plan — see [diagrams.md](diagrams.md). A feature may warrant more than one; omit diagrams for trivial tasks. Save each as a `.mmd` file in `.work/designs/diagrams/`. List them in the doc; do not embed diagram code inline.
9. Write a spec for each plan task: Goal, Interfaces, Implementation notes, Acceptance criteria, Tests, Dependencies. Note which rules apply by title (e.g., `**Rules:** JPA Entity Rules, Liquibase Migration Rules`). This tells `/implement` which docs to apply via `/resolve-rules` explicit mode.
10. Write the complete design to `.work/designs/YYYY-MM-DD-<slug>-design.md`.

### Gate

Run `ls` on the design file and each `.mmd` file. If any missing, write them now. Update the active feature marker: set `stage: design` and `updated` date.

### Wrap up

Ask the user to review. Once confirmed, suggest `/implement`.

## Bootstrap mode

For simple features where no plan exists yet. Treat $ARGUMENTS as the feature description.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Ask clarifying questions
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

Run `ls` on the file. If missing, write it now.

### Next

Confirm the plan with the user. Adjust if needed. Then proceed to create mode.

## Refine mode

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Show current design
- [ ] Ask what to change — iterate until confirmed
- [ ] Write updated file and .mmd files
- [ ] Gate: verify all files with ls
```

1. Show the current design.
2. Ask "What would you like to change?" Iterate until confirmed.
3. Write the updated file and `.mmd` files once.

### Gate

Run `ls` on the design file and each `.mmd` file. If any missing, write them now.

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
