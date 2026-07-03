---
name: implement
description: Implements tasks from a plan and design, applying rules and saving implementation notes. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number]"
allowed-tools: Read Write Edit Bash(git:*)
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write an implementation note to `.work/implementations/`. Verify with `ls` before wrapping up — even if the task is incomplete.

**Constraint:** You MUST implement only the selected task. Note out-of-scope discoveries in the implementation note rather than acting on them.

## Find the feature

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them, offer to archive any with `date` older than 30 days to `.work/archive/`, then ask. Arguments always override.

Parse $ARGUMENTS as `<slug>` or `<slug> <task-N>`. If the marker has `stage: mini-spec`, read the brainstorm artifact's `## Mini-Spec` section as the spec — a single task, no plan or design required; skip task sync and picking. Otherwise find the plan in `.work/plans/` and matching design in `.work/designs/`. Missing design → print "No design found. Run /design first." and stop. No argument → list plan/design pairs; none: stop; one: confirm; many: ask to pick.

```
Task Progress:
- [ ] Find plan and design by slug
- [ ] Read plan, design, and .mmd diagrams
- [ ] Read completion state from the plan's checkboxes
- [ ] Pick task (from args or ask)
- [ ] Apply project rules from devloop/rules/
- [ ] Read relevant files and run baseline tests
- [ ] Implement against task spec
- [ ] Re-run tests; check off the task in the plan
- [ ] Write implementation note (see implementation-note.md)
- [ ] Gate: verify note with ls; update active marker
- [ ] Wrap up: summarize, note deviations, suggest commit
```

## Load

Read plan and design in full. Read `.mmd` diagrams from `.work/designs/diagrams/` to understand proposed architecture. The plan's `- [ ]` checkboxes are the authoritative completion state — print the task list with status.

## Pick task

If $ARGUMENTS includes a task number, use it. Otherwise ask. Warn if dependencies are incomplete.

## Apply rules

If the task spec has a `**Rules:**` line, apply the rules in `devloop/rules/` whose H1 titles match. Otherwise apply rules whose `keywords` match the task; rules without `keywords` always apply. Follow matched rules when modifying files under their scope. List applied rules in your response.

## Execute

Read all relevant files before editing. Run relevant tests to establish a baseline. Implement against the task spec (Goal, Interfaces, Acceptance criteria from design). Re-run tests — note failures or unexpected results. When fully done, check off the task's box in the plan file.

## Implementation note

Write the note per [implementation-note.md](implementation-note.md). Save to `.work/implementations/YYYY-MM-DD-<slug>-task-N.md`. In the Deviations section, list what design specified vs. what was done and why. This is read by `/review` to distinguish intentional deviations from violations.

## Gate

Verify implementation note with `ls`; write if missing. Update `.work/active/<slug>.md` with `stage: implement` and today's date.

## Wrap up

Summarize changes (files created/modified). Note deviations — suggest `/design refine` if significant. If out-of-scope work discovered, suggest `/plan refine`. Suggest a git commit scoped to this task.

## Rules

- Do not start without a design file (mini-spec features excepted).
- The plan file's checkboxes are the authoritative progress state — check off completed tasks there.
- Implement only the selected task; note out-of-scope discoveries in the implementation note.
