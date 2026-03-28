---
name: design
description: Generates design documents with architecture, diagrams, and task specs from a plan. Primary review checkpoint before implementation. Use when designing, architecting, or speccing out a feature.
argument-hint: "[plan slug]"
allowed-tools: Read Write Bash TaskCreate
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/designs/`. Verify with `ls` before wrapping up.

**Constraint:** Do not write code. This skill produces a design, not an implementation.

## Mode

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them and ask. Arguments always override.

If $ARGUMENTS (or auto-selected slug) is set → check designs for match (refine), then plans for match (create). No match → print "Run /dl:plan first." and stop. Ambiguous → list and ask.
If $ARGUMENTS is empty → list designs; none: fall through to plan picker; one: offer refine or new; many: numbered list. Plan picker: list plans; none → stop; one → auto-select; many → ask.

```
Task Progress:
- [ ] Determine mode
- [ ] If refine: show current design, ask what to change, iterate, write once
- [ ] Read plan: extract tasks and dependencies
- [ ] Gather context: CLAUDE.md, project scan, bootstrap.md if present
- [ ] Ask 2-3 clarifying questions (only unresolved items)
- [ ] Write Overview and Architecture
- [ ] Write Task Specs
- [ ] Write Mermaid diagrams to .work/designs/diagrams/ (see diagrams.md)
- [ ] Write design to .work/designs/
- [ ] Gate: verify design and .mmd files with ls; update active marker
- [ ] Present design for review — primary checkpoint before implementation
```

## Context gathering

Read the plan — extract name, tasks, and dependencies. List them in your response. Read `CLAUDE.md` if present. Scan the project directory. Check for `.work/bootstrap.md` — if found, reference the bootstrapped stack as established context.

## Clarifying questions

Ask 2-3 clarifying questions. Read prior artifact decisions — only ask about genuinely unresolved items. Wait for answers.

## Task specs

Write a spec for each plan task: Goal, Interfaces, Implementation notes, Acceptance criteria, Tests, Dependencies. Note applicable rules by title (e.g., `**Rules:** JPA Entity Rules`) — this tells `/implement` which docs to apply via `/resolve-rules` explicit mode.

## Diagrams

Choose diagrams that illuminate the plan — see [diagrams.md](diagrams.md). A feature may warrant more than one; omit diagrams for trivial tasks. Save each as a `.mmd` file in `.work/designs/diagrams/`. List them in the doc; do not embed diagram code inline.

## Refine mode

Show the current design. Ask "What would you like to change?" Iterate until confirmed. Write the updated files once.

## Design format

```markdown
# <Feature Name> Design

**Plan:** `<plan-filename>.md`

## Overview
## Architecture
## Diagrams
## Task Specs

### Task title
**Goal:**
**Interfaces:**
**Implementation notes:**
**Acceptance criteria:**
**Tests:**
**Dependencies:**
**Rules:**
```

## Gate

Verify design file and each `.mmd` file with `ls`; write if missing. Update `.work/active/<slug>.md` with `stage: design` and today's date.

## Wrap up

Present the design for review — this is the primary checkpoint before implementation. Ask the user to review thoroughly. Once confirmed, suggest `/dl:implement`.

## Rules

- Do not write code. This skill produces a design, not an implementation.
- Stay grounded in the plan — do not invent tasks.
- This design must be reviewed before implementation.
