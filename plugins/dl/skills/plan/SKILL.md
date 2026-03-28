---
name: plan
description: Plans features as task lists, decomposes work into ordered steps, and saves plan artifacts. Use when planning, decomposing, or organising work into tasks.
argument-hint: "[feature description]"
allowed-tools: Read Write Bash TaskCreate
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/plans/`. Verify with `ls` before wrapping up.

**Constraint:** Do not write code. This skill produces a plan, not an implementation.

## Mode

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them and ask. Arguments always override.

If $ARGUMENTS (or auto-selected slug) matches a file in `.work/plans/` → **refine** mode. If ambiguous, list and ask. Set but no match → **create** mode. Empty → list `.work/plans/`; none: ask what to plan; one: offer refine or new; many: numbered list, ask to pick.

```
Task Progress:
- [ ] Determine mode
- [ ] If refine: read current plan, check for new brainstorm/research artifacts
- [ ] Gather context: CLAUDE.md, project scan, brainstorm/research artifacts
- [ ] If greenfield: run /resolve-rules scope:bootstrap for stack detection
- [ ] List context and ask clarifying questions (only unresolved items)
- [ ] Create tasks with TaskCreate
- [ ] Write plan to .work/plans/
- [ ] Gate: verify plan with ls; update active marker
- [ ] Present plan for spot-check
```

## Context gathering

Read `CLAUDE.md` if present. Scan project directory structure. Check `.work/brainstorms/` and `.work/research/` for matching artifacts — read them if found. If research contains linked repo context, note it. If greenfield (no `CLAUDE.md`, near-empty directory), run `/resolve-rules mode:all scope:bootstrap` — if stack rule found, add scaffold as task 1.

## Clarifying questions

List what you found before asking. Ask 3-5 clarifying questions. Read decisions from brainstorm and recommendations from research — only ask about genuinely unresolved items. Wait for answers.

## Task creation

Create tasks with `TaskCreate`. Make tasks small and vertically-sliced — each task delivers a testable end-to-end slice. Order by dependency, then by what unblocks the most follow-up work.

## Refine mode

Check for new brainstorm/research artifacts. Show the current plan. Ask "What would you like to change?" Iterate until confirmed. Write the updated file once.

## Plan format

```markdown
# <Feature Name>

> One sentence: what this feature does and why.

## Tasks

- [ ] **Task title** — what it does; key constraints or dependencies if any.
  - **Done when:** one-line acceptance criterion.
```

## Gate

Verify plan with `ls`; write if missing. Create or update `.work/active/<slug>.md` with `stage: plan` and today's date; derive slug from feature description if creating (lowercase, hyphens, strip non-alphanumeric).

## Wrap up

Present the plan. Suggest the user spot-check task ordering, then run `/dl:design`.

## Rules

- Do not write code. This skill produces a plan, not an implementation.
- Right-size tasks — small and vertically-sliced over large and horizontal.
- In refine mode, write once at the end.
