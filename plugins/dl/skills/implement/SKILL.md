---
name: implement
description: Implements tasks from a plan and design, applying rules and saving implementation notes. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number]"
allowed-tools: Read Write Edit Bash(git:*) TaskCreate TaskList TaskUpdate
---

Implement one task from a plan+design pair.

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

- Summarise changes (files created/modified).
- Note any deviations from the design spec — interfaces, structures, or approaches that changed. If significant, suggest running `/design` refine before the next task.
- If out-of-scope work was discovered, suggest running `/plan` refine to capture it.
- Suggest a git commit scoped to this task.
- Recommend follow-up skills — only skills found in `.claude/skills/`.
- **Save the artifact.** Write an implementation note — see [implementation-note.md](implementation-note.md). Implementation notes record deviations, discoveries, and decisions that inform subsequent tasks and plan refinements. Without a saved note, context is lost between tasks and conversations. After saving, run `ls` on the file path to verify it exists in the correct directory with the expected naming convention. If wrong, fix it before continuing.

## Rules

- **Save a `.work` artifact file (implementation note) every time this skill runs.** Implementation notes capture deviations and discoveries that inform the next task — without them, subsequent `/implement` runs and `/plan` refinements lose critical context. Save the note even if the task is incomplete.
- Never start without a design file.
- Never duplicate tasks — match by subject before creating.
- Implement only the selected task. Note out-of-scope discoveries in the implementation note rather than acting on them.
