# Workflow

AI coding agents can generate anything, which is the problem. Without structure you get inconsistent patterns and one-shot attempts that miss edge cases. devloop structures work into phases — sometimes called [harness engineering](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html) — so the agent's output stays consistent and reviewable.

Each step produces an artifact that the next step reads. No step touches code until `/dl:implement`. Artifacts are saved to `.work/` in your project directory — add `.work/` to your `.gitignore`. See [artifacts.md](artifacts.md) for details on the artifact system.

## The loop

```
    /dl:brainstorm  →  /dl:research  →  /dl:plan  →  /dl:design  →  /dl:implement
                            ↑               ↑             ↑               │
                            └───────────────┴─────────────┴───────────────┘
                                 re-enter research when discoveries surface
```

During any phase, run `/dl:research` to feed discoveries back into plans and designs.

Ceremony scales with the work. Brainstorm opens by sizing it:

| Size | Meaning | Path |
|---|---|---|
| small | Single-session change, few files, no open design decisions | brainstorm (1-2 rounds) → mini-spec → implement |
| medium | Multi-file, but the architecture is clear | brainstorm → plan → implement |
| large | New architecture or cross-cutting change | full pipeline; design review is the mandatory checkpoint |

## /dl:brainstorm

```
/dl:brainstorm "topic"
```

Iterative questioning session that probes a feature idea. Claude resolves rules, scans the codebase, and asks rounds of questions — each with a recommended answer you can accept, reject, or refine. The conversation continues until you signal you're done or the decision space converges.

The output is a decision log with research queries (not a transcript) saved to `.work/brainstorms/`. The Research Queries section drives what `/dl:research` investigates. After brainstorming, your context may be full of conversation. Use `/rewind` to reset, then run `/dl:research` — the brainstorm artifact carries your decisions and queries forward.

Brainstorm is the recommended entry point for the devloop workflow. For small work it collapses to 1-2 rounds and writes a `## Mini-Spec` (goal, approach, done-when) that `/dl:implement` consumes directly — no plan or design needed.

```
/dl:brainstorm                  # ask what to brainstorm
/dl:brainstorm <slug>           # reopen an existing brainstorm
```

## /dl:research

```
/dl:research "topic"
```

Executes the Research Queries from your brainstorm artifact as targeted codebase searches. Without a brainstorm artifact it derives queries from the topic directly. Produces per-query findings and a **Gaps & Recommendations** section.

Run it again at any point — it appends new findings without overwriting prior sections.

Research runs in a forked subagent: the codebase scanning happens in a fresh context and only the findings return to your session (the artifact is the interface).

Research artifacts are saved to `.work/research/`.

## /dl:plan

```
/dl:plan "feature"
```

Claude asks clarifying questions (scope, constraints, entities), then produces a task list ordered by dependency. The plan is saved to `.work/plans/`.

If brainstorm or research artifacts exist for the feature, `/dl:plan` reads them automatically — decisions from brainstorming and gaps from research inform the questions and tasks. In a greenfield project (no existing structure), `/dl:plan` detects this and suggests scaffolding as the first task.

Push back. Reorder tasks, split or merge them, add constraints. Claude won't touch code.

```
/dl:plan                    # picker if plans exist, or ask what to plan
/dl:plan <slug>             # refine an existing plan
```

## /dl:design

```
/dl:design
```

Claude reads the plan, explores the codebase, and produces a high-level design: architecture decisions, Mermaid diagrams (saved as `.mmd` files in `.work/designs/diagrams/`), and a detailed spec for each task — goal, interfaces, implementation notes, acceptance criteria, and which rule docs apply.

The design is the primary review checkpoint — review it thoroughly before implementation. Diagram types include architecture, data flow, component structure, and sequence interactions.

## /dl:implement

```
/dl:implement                   # pick a task
/dl:implement <slug> <N>        # implement task N
/dl:implement <slug> all        # run every unchecked task in order
```

Claude acts as a foreman: it loads the plan and design, displays the task list with completion status, and delegates the selected task to a fresh-context worker subagent. The worker receives a payload — the task entry, its design spec, applicable rules, and prior implementation notes — then reads the relevant files, runs existing tests to establish a baseline, implements against the spec, and re-runs tests. An implementation note is saved to `.work/implementations/`, and the foreman verifies the worker's return before checking the task off.

**Single-task mode** implements one task per invocation and suggests a commit at the end.

**All mode** (`all`) requires a clean working tree, then loops over every unchecked task in plan order, committing each task's changes separately as it completes. The line halts — leaving the box unchecked — when a task fails, targets a separate repo, or declares an interface-changing deviation that affects unstarted tasks; re-run `/dl:implement <slug> all` to resume from the first unchecked task. When the last task lands, it automatically runs `/dl:review` in a forked subagent and surfaces the findings without acting on them. All mode requires Claude Code ≥ 2.1.172 (nested subagent spawning).

Completed tasks are checked off in the plan file itself — the artifact is the authoritative progress state, so you pick up exactly where you left off across sessions.

## Working effectively

### Mid-loop corrections

If `/dl:implement` produces something that doesn't match your expectations, don't just fix the code. Ask what was missing:

- **Design gap?** Run `/dl:design refine` to tighten the spec before continuing.
- **Plan gap?** Run `/dl:plan refine` to add a missing task or adjust scope.
- **Rule gap?** Update the rule doc so every future task gets it right.
- **New discovery?** Run `/dl:research` to capture it — the findings inform the next plan.

### Context hygiene

Claude's output degrades as context fills up. The phased workflow helps — each skill starts with a focused read of specific artifacts rather than accumulating a session's worth of conversation.

If you've corrected Claude multiple times on the same issue, the context can become cluttered with failed approaches. Run `/clear` and start fresh with a more specific prompt. A clean session with a better prompt almost always outperforms a long correction chain.

### Tips

- **Start small.** Don't plan 15 tasks. Start with 3-5. You can always `/dl:plan refine` to add more.
- **Let Claude interview you.** Give a short description and let Claude ask the clarifying questions. They often surface constraints you hadn't considered.
- **Review artifacts, not just code.** Check `.work/brainstorms/`, `.work/plans/`, `.work/designs/`, and `.work/implementations/` between sessions. The artifacts capture decisions and rationale that git commits don't.
- **One task per worker.** Every task runs in its own fresh-context worker, whether you invoke `/dl:implement` per task or once with `all`. This keeps each task's context focused; reviewability comes from the per-task commits.
- **Commit after each task.** Small, well-described commits make review and rollback easy. All mode does this for you.
- **Use /dl:research as a re-entry point.** Discovered something unexpected? Run `/dl:research` to capture it, then refine the plan or design. The workflow is a loop, not a line.

## Further reading

- [Harness Engineering](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html) — Birgitta Böckeler on structuring systems around AI agents
- [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) — Anthropic's guide to agent patterns
