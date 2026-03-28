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

## /dl:brainstorm

```
/dl:brainstorm "topic"
```

Iterative questioning session that probes a feature idea. Claude resolves rules, scans the codebase, and asks rounds of questions — each with a recommended answer you can accept, reject, or refine. The conversation continues until you signal you're done or the decision space converges.

The output is a decision log with research queries (not a transcript) saved to `.work/brainstorms/`. The Research Queries section drives what `/dl:research` investigates. After brainstorming, your context may be full of conversation. Use `/rewind` to reset, then run `/dl:research` — the brainstorm artifact carries your decisions and queries forward.

Brainstorm is the required entry point for the devloop workflow.

```
/dl:brainstorm                  # ask what to brainstorm
/dl:brainstorm <slug>           # reopen an existing brainstorm
```

## /dl:research

```
/dl:research "topic"
```

Executes the Research Queries from your brainstorm artifact as targeted codebase searches. Requires a brainstorm artifact. Produces per-query findings and a **Gaps & Recommendations** section.

Run it again at any point — it appends new findings without overwriting prior sections.

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
/dl:implement
```

Claude loads the plan and design, displays the task list with completion status, and implements one task at a time. It reads relevant files first, checks which rules apply, runs existing tests to establish a baseline, implements against the spec, and re-runs tests. An implementation note is saved to `.work/implementations/`.

Completed tasks are tracked — pick up exactly where you left off across sessions.

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
- **One task at a time.** `/dl:implement` works on a single task per invocation. This keeps context focused and changes reviewable.
- **Commit after each task.** Small, well-described commits make review and rollback easy.
- **Use /dl:research as a re-entry point.** Discovered something unexpected? Run `/dl:research` to capture it, then refine the plan or design. The workflow is a loop, not a line.

## Further reading

- [Harness Engineering](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html) — Birgitta Böckeler on structuring systems around AI agents
- [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) — Anthropic's guide to agent patterns
