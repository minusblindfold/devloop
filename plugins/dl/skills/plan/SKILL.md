---
name: plan
description: Plans features as task lists, decomposes work into ordered steps, and saves plan artifacts. Use when planning, decomposing, or organising work into tasks.
argument-hint: "[feature description]"
allowed-tools: Read Write Bash TaskCreate
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Artifact — required output

Write the artifact to `.work/plans/`. Save the artifact before proceeding to wrap up. Do not present results to the user or suggest next steps until the artifact file has been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Mode

If $ARGUMENTS matches a file in `.work/plans/` by exact filename or unambiguous prefix → **refine** mode. If ambiguous, list matches and ask.
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
- [ ] Check .work/research/ for matching artifacts
- [ ] Scan linked repos (if declared)
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
4. Check `.work/research/` for a file matching the feature slug (`*<slug>*-research.md`). If found, read it. Use `### Gaps & Recommendations` to inform clarifying questions and task decomposition.
5. **Linked repo context:** If the research artifact from step 4 contains a `### Linked Repo Context` section, note it — print "Linked repo context found in research artifact." and include it in the gathered context listing. If no research artifact was found, run `/resolve-rules mode:keyword <feature description>` to check for linked repos. If linked repos are declared, do an orientation-only scan of each (expand `~`, verify directory exists, read `CLAUDE.md` or `README.md`, scan top-level directory with `ls`). Skip repos that don't exist locally with a warning. Do not do targeted keyword code search — that's research's job.
6. **Greenfield detection:** if no `CLAUDE.md`, no `.work/bootstrap.md`, and directory is empty or near-empty → run `/resolve-rules mode:all scope:bootstrap` to check for a stack rule. If stack rule found, include "Scaffold project following rules" as task 1 in the plan. If no stack rule exists, proceed normally. If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.
7. List what you found in your response before asking questions: bootstrap context (if any), research artifacts (if any), linked repo context (if any), greenfield status, and available skills.
8. Ask 3–5 clarifying questions. Wait for answers.
   - If bootstrap context was found: skip questions about tech stack, database, and auth approach (already decided). Focus on domain entities, business logic, scope boundaries, and constraints.
   - If no bootstrap context: ask as normal, including stack questions if the project's tech isn't clear from CLAUDE.md.
9. Create tasks with `TaskCreate`. Make tasks small. Order by dependency.
10. Write the plan to `.work/plans/YYYY-MM-DD-<slug>.md`.

### Gate

Run `ls` on the saved file path. If the file does not exist, go back to step 4. Do not proceed until the file is confirmed on disk.

### Wrap up

Ask the user to review. Once confirmed, suggest running `/design` to architect the feature.

## Refine mode

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Check .work/research/ for new artifacts
- [ ] List new research findings in response
- [ ] Show current plan
- [ ] Ask what to change — iterate until confirmed
- [ ] Write updated plan file
- [ ] Gate: verify plan file with ls
```

1. Check `.work/research/` for matching research artifacts. If found, note relevant findings.
2. List any new research findings in your response before showing the plan.
3. Show the current plan.
4. Ask "What would you like to change?" Iterate until confirmed.
5. Write the updated file once.

### Gate

Run `ls` on the saved file path. If the file does not exist, go back to step 5. Do not proceed until the file is confirmed on disk.

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
