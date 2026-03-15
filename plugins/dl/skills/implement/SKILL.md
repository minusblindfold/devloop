---
name: implement
description: Implements tasks from a plan and design, applying rules and saving implementation notes. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number]"
allowed-tools: Read Write Edit Bash(git:*) TaskCreate TaskList TaskUpdate
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Artifact — required output

Write an implementation note to `.work/implementations/`. Save the artifact before proceeding to wrap up — even if the task is incomplete. Do not summarize changes, suggest commits, or recommend next steps until the implementation note has been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Find the feature

If $ARGUMENTS: treat as `<slug>` or `<slug> <task-N>`. Find the plan in `.work/plans/`, then the matching design in `.work/designs/`. Missing design → print "No design found for '<slug>'. Run /design first." and stop.
If no argument: list plans and designs, match by slug. No pairs → print "Run /plan then /design first." and stop. One pair → show it and ask to confirm or describe a new feature. Many → numbered list, ask to pick.

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

If the design's task spec includes a `**Rules:**` line, run `/resolve-rules mode:explicit <titles>`. Otherwise, run `/resolve-rules mode:keyword <task description terms>`.

If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.

Follow the matched rule docs when creating or modifying files that fall under their scope.

List applied rules in your response before proceeding to read files. If no rules matched, state that explicitly.

### Execute

1. Read all relevant files before editing.
2. Run relevant tests if available to establish a baseline.
3. Implement against the task spec (Goal, Interfaces, Acceptance criteria from the design).
4. Use available skills where applicable.
5. Re-run tests. Note any failures or unexpected results.
6. Mark `completed` with `TaskUpdate` when fully done.

### Write implementation note

Write the note — see [implementation-note.md](implementation-note.md). Save to `.work/implementations/YYYY-MM-DD-<slug>-task-N.md`.

### Gate

Run `ls` on the saved file path. If the file does not exist, go back and write it. Do not proceed until the file is confirmed on disk.

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
