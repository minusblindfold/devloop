---
name: implement
description: Implements tasks from a plan and design, applying rules and saving implementation notes. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number]"
allowed-tools: Read Write Edit Bash(git:*) TaskCreate TaskList TaskUpdate
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write an implementation note to `.work/implementations/`. Verify with `ls` before wrapping up — even if the task is incomplete.

## Find the feature

**Active feature detection:** Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug — print "Auto-selected feature: <slug>". If multiple markers exist, list them and ask. Arguments always override the marker.

If $ARGUMENTS (or auto-selected slug): treat as `<slug>` or `<slug> <task-N>`. Find the plan in `.work/plans/`, then the matching design in `.work/designs/`. Missing design → print "No design found for '<slug>'. Run /design first." and stop.
If no argument: list plans and designs, match by slug. No pairs → print "Run /plan then /design first." and stop. One pair → show it and ask to confirm. Many → numbered list, ask to pick.

## Implement mode

**Constraint:** You MUST implement only the selected task. Note out-of-scope discoveries in the implementation note rather than acting on them.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Find plan and design by slug
- [ ] Read plan, design, and .mmd diagrams
- [ ] Check .claude/skills/ for available skills
- [ ] Sync tasks to Claude Code task list
- [ ] Pick task and mark in_progress
- [ ] Run /resolve-rules for applicable rules
- [ ] List applied rules in response
- [ ] Read relevant files
- [ ] Run baseline tests
- [ ] Implement against task spec
- [ ] Re-run tests
- [ ] Mark task completed
- [ ] Write implementation note to .work/implementations/
- [ ] Gate: verify implementation note with ls
- [ ] Wrap up: summarize, note deviations, suggest commit
```

### Load and sync

1. Read the plan and design files in full.
2. Read any `.mmd` diagrams referenced in the design from `.work/designs/diagrams/`. Use them to understand the proposed architecture and flow before implementing.
3. Check `.claude/skills/` for available skills. Print what's found.
4. Sync plan tasks to Claude Code task list: call `TaskList`, then `TaskCreate` for any task not already present. Match by subject before creating — do not duplicate.
5. Print the task list with completion status.

### Pick a task

If $ARGUMENTS includes a task number, use it. Otherwise ask. Warn if dependencies are incomplete. Mark `in_progress` with `TaskUpdate`.

### Apply rules

If the task spec has a `**Rules:**` line, run `/resolve-rules mode:explicit <titles>` as a subtask. Otherwise, run `/resolve-rules mode:keyword <task terms>`. If unavailable, continue without rules.

Follow matched rule docs when modifying files under their scope. List applied rules in your response.

### Execute

1. Read all relevant files before editing.
2. Run relevant tests if available to establish a baseline.
3. Implement against the task spec (Goal, Interfaces, Acceptance criteria from the design).
4. Use available skills where applicable.
5. Re-run tests. Note any failures or unexpected results.
6. Mark `completed` with `TaskUpdate` when fully done.

### Write implementation note

Write the note — see [implementation-note.md](implementation-note.md). Save to `.work/implementations/YYYY-MM-DD-<slug>-task-N.md`. In the **Deviations from design** section, list each deviation as: what the design specified, what was done instead, and why. This is read by `/review` to distinguish intentional deviations from violations.

### Gate

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: implement` and `updated` date.

### Wrap up

1. Summarize changes (files created/modified).
2. Note any deviations from the design spec — interfaces, structures, or approaches that changed. If significant, suggest running `/design refine` before the next task.
3. If out-of-scope work was discovered, suggest running `/plan refine` to capture it.
4. Suggest a git commit scoped to this task.
5. Recommend follow-up skills — only skills found in `.claude/skills/`.

## Rules

- Do not start without a design file.
- Do not duplicate tasks — match by subject before creating.
- Implement only the selected task. Note out-of-scope discoveries in the implementation note rather than acting on them.
