---
name: implement
description: Implements tasks from a plan and design by delegating each task to a fresh-context worker subagent. Use when coding a planned feature or working through tasks one at a time.
argument-hint: "[plan-slug] [task-number|all]"
allowed-tools: Read Write Edit Bash(git:*) Agent
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** The worker writes an implementation note to `.work/implementations/` — even if the task is incomplete.

**Constraint:** You are the foreman — you do not implement tasks yourself. A fresh-context worker subagent implements the selected task; you build its payload, verify its return, and own the plan checkboxes.

## Find the feature

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them, offer to archive any with `date` older than 30 days to `.work/archive/`, then ask. Arguments always override.

Parse $ARGUMENTS as `<slug>`, `<slug> <task-N>`, or `<slug> all`. If the marker has `stage: mini-spec`, read the brainstorm artifact's `## Mini-Spec` section as the spec — a single task (N = 1), no plan or design required; skip task picking. Otherwise find the plan in `.work/plans/` and matching design in `.work/designs/`. Missing design → print "No design found. Run /design first." and stop. No argument → list plan/design pairs; none: stop; one: confirm; many: ask to pick.

```
Task Progress:
- [ ] Find plan and design by slug
- [ ] Read plan and design; read completion state from the plan's checkboxes
- [ ] Pick task from args or ask — `all`: require clean tree, then loop per All mode
- [ ] Build the worker payload (task entry, design spec, rules, prior notes)
- [ ] Spawn the worker; receive its structured return
- [ ] Verify: note exists, STATUS complete, tests pass
- [ ] Check off the task in the plan (all mode: commit, then next task or halt)
- [ ] Gate: verify note with ls; update active marker
- [ ] Wrap up: summarize worker return(s), note deviations, suggest commit
```

## Load

Read plan and design in full. The plan's `- [ ]` checkboxes are the authoritative completion state — task numbers are positional. Print the task list with status.

## Pick task

If $ARGUMENTS includes a task number, use it; if it says `all`, follow All mode instead; otherwise ask, warning if dependencies are incomplete.

## All mode

`all` runs every unchecked task in plan order — position = task number, no dependency graph. Mini-spec features have a single task, so `all` behaves like task 1.

**Precondition:** `git status --porcelain` must print nothing; otherwise stop and tell the user to commit or stash first — never auto-stash.

Loop over the unchecked tasks in order, halting the line when a trigger fires:

1. **Cross-repo:** the task prose puts the work in a separate repo → halt before spawning.
2. Run Build payload and Verify return (below) for task N.
3. **Failure:** STATUS not `complete`, or tests failing → halt; the box stays unchecked.
4. **Escalation:** on `DEVIATIONS: interface-changing`, grep each named interface across the design specs of unstarted tasks only — any hit → halt; no hits → record it for the wrap-up and continue.
5. Check the task's plan box, then commit only this task's changes: subject = the task title, body = `Task N of <plan-filename>`, no Co-Authored-By line. Never `cd` — the line assumes a single repo.

**Halt report:** give the task number, title, and reason, ending with "Re-run `/dl:implement <slug> all` to resume." Checkboxes are the resume state — a re-run starts at the first unchecked box.

When no unchecked tasks remain, do Gate once and wrap up the whole line: per-task results, commits, any recorded deviations.

## Build payload and spawn worker

Assemble the payload:

- The plan task entry verbatim (title, description, Done when, Verified by) and its positional number N
- The design's matching `### <task title>` spec section verbatim, plus paths of relevant `.work/designs/diagrams/*.mmd` files
- Paths of rule docs in `devloop/rules/` whose H1 titles match the spec's `**Rules:**` line; no line → paths of rules whose `keywords` match the task (rules without `keywords` always apply)
- Paths of prior implementation notes for the slug, and the path of [implementation-note.md](implementation-note.md)
- Mini-spec features: the `## Mini-Spec` section replaces the plan/design excerpts

Spawn one general-purpose subagent — never fork-type; the worker must start from fresh context — whose prompt is the full text of [task-worker.md](task-worker.md) followed by the payload.

## Verify return

The worker's final message ends with a fenced STATUS / FILES / TESTS / DEVIATIONS / NOTE block. Verify the note file exists with `ls` — if missing, write a stub note from the structured return and treat the task as failed. Check off the task's plan checkbox only when STATUS is `complete` and tests pass. On `blocked`, present the worker's options to the user.

## Gate

Verify the implementation note(s) with `ls`, then update `.work/active/<slug>.md` with `stage: implement` and today's date.

## Wrap up

Summarize the worker's return: files created/modified, test results, deviations. Significant deviations → suggest `/design refine`; out-of-scope discoveries → suggest `/plan refine`. Single-task mode only: suggest a git commit scoped to this task (all mode has already committed).

## Rules

- Do not start without a design file (mini-spec features excepted).
- You are the foreman: the worker implements and writes the note — never do either yourself (stub-on-missing-note excepted).
- The plan file's checkboxes are the authoritative progress state — check off only verified completions.
- Spawn workers with fresh context (general-purpose), never fork-type.
