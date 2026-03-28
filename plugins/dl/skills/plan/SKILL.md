---
name: plan
description: Plans features as task lists, decomposes work into ordered steps, and saves plan artifacts. Use when planning, decomposing, or organising work into tasks.
argument-hint: "[feature description]"
allowed-tools: Read Write Bash TaskCreate
---

Execute each section in order. Copy the checklist from your mode's section and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/plans/`. Verify with `ls` before wrapping up.

## Mode

**Active feature detection:** Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug — print "Auto-selected feature: <slug>". If multiple markers exist, list them and ask. Arguments always override the marker.

If $ARGUMENTS (or auto-selected slug) matches a file in `.work/plans/` by exact filename or unambiguous prefix → **refine** mode. If ambiguous, list matches and ask.
If $ARGUMENTS is set → **create** mode using it as the feature description.
If $ARGUMENTS is empty → list `.work/plans/`. None: ask what to plan. One: offer refine or new. Many: numbered list, ask to pick or describe a new feature.

## Create mode

**Constraint:** Do not write code. This skill produces a plan, not an implementation.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read CLAUDE.md
- [ ] Scan project directory and .claude/skills/
- [ ] Check for .work/bootstrap.md
- [ ] Check .work/brainstorms/ for matching artifacts
- [ ] Check .work/research/ for matching artifacts
- [ ] Check for greenfield project
- [ ] List gathered context in response
- [ ] Ask clarifying questions
- [ ] Create tasks with TaskCreate
- [ ] Write plan to .work/plans/
- [ ] Gate: verify plan file with ls
- [ ] Present plan for review
```

1. Read `CLAUDE.md` if present.
2. Scan project directory structure (top-level + key subdirectories). Check `.claude/skills/` for available skills.
3. Check for `.work/bootstrap.md` — if found, read it. Note tech stack, roles, and scaffolded entities as established context.
4. Check `.work/brainstorms/` for a matching file (`*<slug>*-brainstorm.md`). If found, read it.
5. Check `.work/research/` for a matching file (`*<slug>*-research.md`). If found, read it. If it contains `### Linked Repo Context`, note it in gathered context.
6. **Greenfield detection:** if no `CLAUDE.md`, no `.work/bootstrap.md`, and near-empty directory → run `/resolve-rules mode:all scope:bootstrap` as a subtask. If stack rule found, add "Scaffold project following rules" as task 1.
7. List what you found before asking questions: bootstrap, brainstorm, research, linked repo context, greenfield status, available skills.
8. Ask 3–5 clarifying questions. Wait for answers. Read decisions from brainstorm and recommendations from research — only ask about genuinely unresolved items.
9. Create tasks with `TaskCreate`. Make tasks small. Order by dependency.
10. Write the plan to `.work/plans/YYYY-MM-DD-<slug>.md`.

### Gate

Run `ls` on the file. If missing, write it now. Create or update the active feature marker at `.work/active/<slug>.md` with `stage: plan` and today's date. If no marker exists, create one (slug from feature description: lowercase, hyphens, strip non-alphanumeric).

### Wrap up

Ask the user to review. Once confirmed, suggest `/design`.

## Refine mode

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Check .work/brainstorms/ and .work/research/ for new artifacts
- [ ] List new findings in response
- [ ] Show current plan
- [ ] Ask what to change — iterate until confirmed
- [ ] Write updated plan file
- [ ] Gate: verify plan file with ls
```

1. Check `.work/brainstorms/` and `.work/research/` for matching artifacts. If found, note relevant findings.
2. List any new findings in your response before showing the plan.
3. Show the current plan.
4. Ask "What would you like to change?" Iterate until confirmed.
5. Write the updated file once.

### Gate

Run `ls` on the file. If missing, write it now.

## Plan format

```markdown
# <Feature Name>

> One sentence: what this feature does and why.

## Tasks

- [ ] **Task title** — what it does; key constraints or dependencies if any.
  - **Done when:** one-line acceptance criterion.
- [ ] ...
```

Make tasks small. Order by dependency. Each task includes a one-line "Done when" acceptance criterion so `/design` can expand it into a full spec without guessing intent.

## Rules

- Do not write code. This skill produces a plan, not an implementation.
- Only reference skills found in `.claude/skills/`.
- Right-size tasks — small over large.
- In refine mode, write once at the end.
