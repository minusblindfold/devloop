---
name: brainstorm
description: Sizes the work, then refines a feature idea through iterative questioning. Recommended entry point for the devloop workflow. Use when the user wants to brainstorm, explore an idea, or probe a feature concept.
argument-hint: "[feature or topic]"
allowed-tools: Read Write Bash Glob Grep
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/brainstorms/`. Verify with `ls` before wrapping up.

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

## Mode

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them, offer to archive any with `date` older than 30 days to `.work/archive/`, then ask. Arguments always override.

Parse `$ARGUMENTS` (or auto-selected slug): matches existing file in `.work/brainstorms/` by slug → **re-entry**. Set but no match → **create**. Empty → ask what to brainstorm, then proceed in create mode.

```
Task Progress:
- [ ] Determine mode and update active marker
- [ ] Size the work: small / medium / large
- [ ] If re-entry: read existing artifact, present prior decisions and open questions
- [ ] Gather context: project rules, CLAUDE.md, project scan, linked repos, codebase search
- [ ] Summarize context; surface findings during conversation
- [ ] Collaborative exploration with user (small: 1-2 rounds)
- [ ] Write artifact (small: Mini-Spec; medium: no Research Queries; large: full)
- [ ] Gate: verify artifact with ls; update active marker
- [ ] Wrap up: summarize decisions, suggest next step by size
```

## Active marker

Derive slug from topic (lowercase, hyphens, strip non-alphanumeric). Create or update `.work/active/<slug>.md` with `stage: brainstorm` and today's date.

## Size triage

Open by sizing the work — ask with a recommended answer. **Small**: single-session change, few files, no open design decisions — collapse exploration to 1-2 rounds and write a `## Mini-Spec` instead of Research Queries. **Medium**: multi-file but the architecture is clear — normal exploration, omit Research Queries. **Large**: new architecture or cross-cutting change — full brainstorm with Research Queries.

## Context gathering

Read `devloop/rules/*.md` if present — apply rules whose `keywords` match the topic; rules without `keywords` always apply. Read `CLAUDE.md` if present. Scan project directory structure. If a matched rule declares `repos:`, scan those repos for topic-relevant patterns. Search the project codebase for existing implementations and naming patterns. Summarize briefly — hold details back to surface naturally during conversation.

## Collaborative exploration

Work back and forth with the user to shape the feature. Lead with recommendations grounded in codebase findings. Each question MUST include a recommended answer — the user refines your thinking rather than starting from zero. React to responses: push back on concerns, agree and build on what clicks, surface related codebase patterns. Probe scope boundaries, trade-offs, edge cases, and interactions with existing systems. Wait for the user each round. Propose wrapping up when you can recommend strong answers to your own questions or after 5+ rounds.

## Re-entry

Read the existing artifact in full. Present prior decisions and open questions: "Here's where we left off:" Resume collaborative exploration. On wrap-up, rewrite the entire artifact with updated decisions — decisions evolve as a whole.

## Output

Write to `.work/brainstorms/YYYY-MM-DD-<slug>-brainstorm.md`:

```markdown
# <Topic> Brainstorm

## Context
### Matched Rules
| Rule | Source | Key Patterns |
### Codebase Patterns

## Decisions

## Research Queries

## Open Questions

## Constraints Discovered
```

Capture decisions and rationale, not a conversation transcript. Research Queries are specific questions about codebase facts for `/dl:research` to execute — not implementation tasks. Small work replaces Research Queries with `## Mini-Spec`: Goal, Approach, Done when — about 10 lines. Medium omits Research Queries.

## Gate

Verify artifact with `ls`; write if missing. Update `.work/active/<slug>.md` with `stage: brainstorm` (small: `stage: mini-spec`) and today's date.

## Wrap up

Summarize: decisions made, open questions remaining. Suggest next step by size — small: `/dl:implement <slug>`; medium: `/dl:plan <slug>`; large: `/dl:research <slug>`.

## Rules

- Do not modify project files. This skill produces context, not code.
- Always include recommended answers with questions — do not ask bare questions.
- Capture decisions and rationale in the artifact, not a conversation transcript.
- On re-entry, rewrite the artifact (decisions evolve as a whole) — do not append.
