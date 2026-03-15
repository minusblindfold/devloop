---
name: plan
description: Plans features as task lists, decomposes work into ordered steps, and saves plan artifacts. Use when planning, decomposing, or organising work into tasks.
argument-hint: "[feature description]"
allowed-tools: Read Write Bash TaskCreate
---

Create or refine a feature plan.

## Artifact — required output

This skill produces a file in `.work/plans/`. Every execution — create or refine — must end with a saved artifact on disk. The wrap-up phase below is gated on this: do not present results to the user or suggest next steps until the artifact file has been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Mode

If $ARGUMENTS matches a file in `.work/plans/` by exact filename or unambiguous prefix → refine mode. If ambiguous, list matches and ask.
If $ARGUMENTS is set → create mode using it as the feature description.
If $ARGUMENTS is empty → list `.work/plans/`. None: ask what to plan. One: offer refine or new. Many: numbered list, ask to pick or describe a new feature.

## Create mode

1. Explore: read `CLAUDE.md`, scan directory, check `.claude/skills/` for available skills. Check for `.work/bootstrap.md` — if found, read it and note the tech stack, roles, and scaffolded entities as established context. Check `.work/research/` for a file matching the feature slug (`*<slug>*-research.md`) and for `health-check.md`. If found, read them — use `### Gaps & Recommendations` to inform clarifying questions and task decomposition. **Greenfield detection:** if the directory appears greenfield (no `CLAUDE.md`, no `.work/bootstrap.md`, and empty or near-empty), run `/resolve-rules mode:all scope:bootstrap` to check for a stack rule. If found, note this is a greenfield project and include "Scaffold project following rules" as task 1 in the plan. If no stack rule exists, proceed normally.
2. Ask 3–5 clarifying questions. Wait for confirmation.
   - If bootstrap context was found: skip questions about tech stack, database, and auth approach (these are already decided). Focus on domain entities, business logic, scope boundaries, and constraints.
   - If no bootstrap context: ask as normal, including stack questions if the project's tech isn't clear from CLAUDE.md.
3. Create tasks with `TaskCreate`. Make them small, meaningful, and ordered by dependency.
4. Write the plan to `.work/plans/YYYY-MM-DD-<slug>.md`.
5. **Gate:** run `ls` on the saved file path. If the file does not exist, go back to step 4. Do not proceed until the file is confirmed on disk.
6. Ask the user to review. Once confirmed, suggest running `/design` to architect the feature.

## Refine mode

1. Back up the current file — see [backup.md](../backup.md).
2. Check `.work/research/` for matching research artifacts (new research may exist since the original plan). If found, note relevant findings.
3. Show current plan.
4. Ask "What would you like to change?" Iterate until confirmed.
5. Write the updated file once.

## Plan format

```markdown
# <Feature Name>

> One sentence: what this feature does and why.

## Tasks

- [ ] **Task title** — what it does; key constraints or dependencies if any.
  - **Done when:** one-line acceptance criterion.
- [ ] ...
```

Tasks should be small and ordered by dependency. Each task includes a one-line "Done when" acceptance criterion so `/design` can expand it into a full spec without guessing intent.

## Rules

- Never implement.
- Only reference skills found in `.claude/skills/`.
- Right-size tasks — small over large.
- In refine mode, write once at the end.
