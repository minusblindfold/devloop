---
keywords: [skill, SKILL.md, plugin]
---
# Skill Authoring Rules

> Principles for writing and modifying devloop skill files, grounded in Anthropic's skill-authoring best practices and devloop conventions.

## Context budget via progressive disclosure

- Keep the SKILL.md body under 500 lines (per Anthropic's skill-authoring best practices). What loads by default is the budget — push detail into sibling files read on demand, the way implement's `implementation-note.md` and `task-worker.md` load only when a worker needs them.
- Cut explanations, never workflow steps. For each sentence, ask: does Claude really need this? Strip field descriptions from artifact templates — section headings alone carry meaning.

## Description is the trigger

- The frontmatter `description` drives skill selection: Claude uses it to choose from potentially 100+ skills (per Anthropic's skill-authoring best practices). State both what the skill does *and* when to use it.
- Include the trigger vocabulary users actually type ("brainstorm", "plan", "review"). A description that only explains internals never fires.

## Frontmatter conventions

- `allowed-tools` pre-approves tools rather than restricting them. Both forms are valid: plain names (`Read`) and scoped filters (`Bash(git:*)`). Devloop convention: use the narrowest form that covers the skill's real needs.
- `context: fork` runs the skill in a forked subagent. Pair it with an explicit `agent:` type — don't rely on the default — and write the body for isolation: a forked skill cannot converse, so it must return everything the caller needs in its final output.
- `disable-model-invocation: true` marks user-only skills, keeping them out of Claude's automatic selection.

## Checklists and gates are quality-critical

- The copy-the-checklist pattern is vendor-documented best practice: give Claude a checklist to copy into its response and check off as it progresses — clear steps prevent skipping critical validation (per Anthropic's skill-authoring best practices).
- Never cut checklists, gates, or validation steps for space. Cut explanation and template verbosity instead. This inverts earlier devloop doctrine that treated structural instructions as the primary cut target.

## Worker orchestration

Devloop convention, corroborated by ecosystem convergence (Anthropic's orchestrator/worker pattern, Superpowers-style subagent-driven development):

- The foreman stays in the main context; each task runs in a fresh-context `general-purpose` worker — never a fork-type skill invocation.
- The worker prompt is a sibling template file plus a payload manifest (task entry, design spec, rule paths, prior notes).
- Workers end with a fenced structured return block (`STATUS`/`FILES`/`TESTS`/`DEVIATIONS`/`NOTE`) that the foreman parses.
- Spawn workers in the foreground for sequential task lines — subagents are background-by-default (≥2.1.198), which would otherwise decouple the foreman from returns.
- Workers are isolated and cannot converse: blocked decisions come back as `STATUS: blocked` with options, not questions.

## Behavioral invariants — never cut when editing skills

Tripwire list; extended rationale lives in `docs/workflow.md`, not here:

- **Vertical slicing** — horizontal-layer tasks can't be tested as functionality or unwound per feature.
- **Artifact chaining** — static markdown artifacts survive context compaction; the chain is the core reliability mechanism.
- **Separation of concerns** — research produces facts, brainstorm owns decisions, design is the review checkpoint; mixing them injects opinion into findings.
- **Gate-strength language** — distinct wording for gates of different weight ("spot-check" vs "primary checkpoint"); identical wording flattens them.
- **Checklist-copying** — visible progress state prevents step-skipping.
