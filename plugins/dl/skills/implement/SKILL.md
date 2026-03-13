---
name: implement
description: Implements tasks from a plan and design, applying rules and saving implementation notes. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number]"
allowed-tools: Read Write Edit Bash(git:*) TaskCreate TaskList TaskUpdate
---

Implement one task from a plan+design pair.

## Artifact — required output

This skill produces an implementation note in `<work.dir>/implementations/`. Every execution — even if the task is incomplete — must end with a saved artifact on disk. The wrap-up phase below is gated on this: do not summarise changes, suggest commits, or recommend next steps until the implementation note has been written and verified with `ls`.

## Config

Read `devenv.json` from `${CLAUDE_PLUGIN_ROOT}/devenv.json` (if running as a plugin) or `~/.claude/devenv.json` (fallback). Key: `work.dir` (default `.work`).

## Find the feature

If $ARGUMENTS: treat as `<slug>` or `<slug> <task-N>`. Find plan in `<work.dir>/plans/`, then matching design in `<work.dir>/designs/`. Missing design → "No design found for '<slug>'. Run /design first." and stop.
If no argument: list plans and designs, match by slug. No pairs → "Run /plan then /design first." and stop. One pair → show it and ask to confirm or describe a new feature. Many → numbered list, ask to pick.

## Load and sync

1. Read both files in full.
2. Read any `.mmd` diagrams referenced in the design from `<work.dir>/designs/diagrams/`. Use them to understand the proposed architecture and flow before implementing.
3. Check `.claude/skills/` for available skills. Print what's found.
4. Sync plan tasks to Claude Code task list: call `TaskList`, then `TaskCreate` for any task not already present.
5. Print task list with completion status.

## Pick a task

If $ARGUMENTS includes a task number, use it. Otherwise ask. Warn if dependencies are incomplete. Mark `in_progress` with `TaskUpdate`.

## Apply rules

If the design's task spec includes a `**Rules:**` line, run `/resolve-rules mode:explicit <titles>`. Otherwise, run `/resolve-rules mode:keyword <task description terms>`.

If `/resolve-rules` is unavailable, warn the user: "Rule resolution skill not found — rules will not be applied." Then continue without rules.

Follow the matched rule docs when creating or modifying files that fall under their scope.

## Implement

1. Read all relevant files before editing.
2. Run relevant tests if available to establish a baseline.
3. Implement against the task spec (Goal, Interfaces, Acceptance criteria from the design).
4. Use available skills where applicable.
5. Re-run tests. Note any failures or unexpected results.
6. Mark `completed` with `TaskUpdate` when fully done.

## Wrap up

1. Write an implementation note — see [implementation-note.md](implementation-note.md).
2. **Gate:** run `ls` on the saved file path. If the file does not exist, go back to step 1. Do not proceed until the file is confirmed on disk.
3. Summarise changes (files created/modified).
4. Note any deviations from the design spec — interfaces, structures, or approaches that changed. If significant, suggest running `/design` refine before the next task.
5. If out-of-scope work was discovered, suggest running `/plan` refine to capture it.
6. Suggest a git commit scoped to this task.
7. Recommend follow-up skills — only skills found in `.claude/skills/`.

## Rules

- Never start without a design file.
- Never duplicate tasks — match by subject before creating.
- Implement only the selected task. Note out-of-scope discoveries in the implementation note rather than acting on them.
