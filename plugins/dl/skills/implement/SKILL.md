---
name: implement
description: Implements tasks from a plan and design by delegating each task to a fresh-context worker subagent. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number]"
allowed-tools: Read Write Edit Bash(git:*) Agent
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** The worker writes an implementation note to `.work/implementations/`. Verify with `ls` before wrapping up — even if the task is incomplete.

**Constraint:** You are the foreman — you do not implement tasks yourself. A fresh-context worker subagent implements the selected task; you build its payload, verify its return, and own the plan checkboxes.

## Find the feature

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them, offer to archive any with `date` older than 30 days to `.work/archive/`, then ask. Arguments always override.

Parse $ARGUMENTS as `<slug>` or `<slug> <task-N>`. If the marker has `stage: mini-spec`, read the brainstorm artifact's `## Mini-Spec` section as the spec — a single task (N = 1), no plan or design required; skip task picking. Otherwise find the plan in `.work/plans/` and matching design in `.work/designs/`. Missing design → print "No design found. Run /design first." and stop. No argument → list plan/design pairs; none: stop; one: confirm; many: ask to pick.

```
Task Progress:
- [ ] Find plan and design by slug
- [ ] Read plan and design; read completion state from the plan's checkboxes
- [ ] Pick task (from args or ask)
- [ ] Build the worker payload (task entry, design spec, rules, prior notes)
- [ ] Spawn the worker; receive its structured return
- [ ] Verify: note exists, STATUS complete, tests pass
- [ ] Check off the task in the plan
- [ ] Gate: verify note with ls; update active marker
- [ ] Wrap up: summarize worker return, note deviations, suggest commit
```

## Load

Read plan and design in full. The plan's `- [ ]` checkboxes are the authoritative completion state — task numbers are positional. Print the task list with status.

## Pick task

If $ARGUMENTS includes a task number, use it. Otherwise ask. Warn if dependencies are incomplete.

## Build payload and spawn worker

Assemble the payload:

- The plan task entry verbatim (title, description, Done when, Verified by) and its positional number N
- The design's matching `### <task title>` spec section verbatim, plus paths of relevant `.work/designs/diagrams/*.mmd` files
- Paths of rule docs in `devloop/rules/` whose H1 titles match the spec's `**Rules:**` line; no line → paths of rules whose `keywords` match the task (rules without `keywords` always apply)
- Paths of prior implementation notes for the slug, and the path of [implementation-note.md](implementation-note.md)
- Mini-spec features: the `## Mini-Spec` section replaces the plan/design excerpts

Spawn one general-purpose subagent whose prompt is the full text of [task-worker.md](task-worker.md) followed by the payload. Do not use a fork-type subagent — the worker must start from fresh context.

## Verify return

The worker's final message ends with a fenced STATUS / FILES / TESTS / DEVIATIONS / NOTE block. Verify the note file exists with `ls` — if missing, write a stub note from the structured return and treat the task as failed. Check off the task's plan checkbox only when STATUS is `complete` and tests pass. On `blocked`, present the worker's options to the user.

## Gate

Verify implementation note with `ls`. Update `.work/active/<slug>.md` with `stage: implement` and today's date.

## Wrap up

Summarize the worker's return: files created/modified, test results, deviations. Significant deviations → suggest `/design refine`; out-of-scope discoveries → suggest `/plan refine`. Suggest a git commit scoped to this task.

## Rules

- Do not start without a design file (mini-spec features excepted).
- You are the foreman: the worker implements and writes the note — never do either yourself (stub-on-missing-note excepted).
- The plan file's checkboxes are the authoritative progress state — check off only verified completions.
- Spawn workers with fresh context (general-purpose), never fork-type.
