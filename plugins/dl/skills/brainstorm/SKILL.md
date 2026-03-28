---
name: brainstorm
description: Iterative questioning to refine a feature idea before research and planning. Use when the user wants to brainstorm, explore an idea, or probe a feature concept.
argument-hint: "[feature or topic]"
allowed-tools: Read Write Bash Glob Grep
---

Execute each section in order. Copy the checklist from your mode's section and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/brainstorms/`. Verify with `ls` before wrapping up.

## Mode

**Active feature detection:** Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug — print "Auto-selected feature: <slug>". If multiple markers exist, list them and ask which to continue. Arguments always override the marker.

Parse `$ARGUMENTS` (or auto-selected slug):

- Matches an existing file in `.work/brainstorms/` by slug → **re-entry** (reopen conversation from prior decisions).
- Set but no match → **create** new brainstorm.
- Empty → ask the user what they would like to brainstorm. Wait for a topic, then proceed in **create** mode.

## Create mode

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Determine mode (create / re-entry)
- [ ] Create or update active feature marker
- [ ] Run /resolve-rules
- [ ] List matched rules in response
- [ ] Read CLAUDE.md
- [ ] Scan project directory structure
- [ ] Scan linked repos (if declared)
- [ ] Search code for topic-relevant patterns
- [ ] List gathered context in response
- [ ] Begin iterative questioning
- [ ] Write artifact to .work/brainstorms/
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: suggest /dl:research
```

### Active feature marker

Derive the slug from the topic: lowercase, replace spaces with hyphens, strip non-alphanumeric characters except hyphens. Create `.work/active/<slug>.md` if it doesn't exist:

```markdown
---
slug: <slug>
stage: brainstorm
started: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

If the marker already exists (re-entry), update `stage` and `updated`.

### Context gathering

Gather context to ground the conversation. Summarize what you found briefly — don't dump raw results. Surface specific findings naturally during the collaborative exploration when they're relevant.

1. Run `/resolve-rules mode:keyword <topic>` as a subtask. If unavailable, continue without rules. Note matched rules.
2. Read `CLAUDE.md` if present.
3. Scan the project directory structure (top-level + key subdirectories).
4. If resolve-rules output included "Linked repos", scan each declared repo: verify it exists, read `CLAUDE.md` (or `README.md`), scan with `ls`, grep for topic patterns (limit 10–15 matches). Skip missing repos with a warning.
5. Search the project codebase for patterns relevant to the topic. Look for existing implementations, naming patterns, tech choices.
6. Summarize what you found briefly, then move into collaborative exploration. Hold details back to surface when they're relevant to the discussion.

### Collaborative exploration

Work back and forth with the user to shape the feature — think together, react to what they say, and build on their ideas. Surface what you found in the codebase naturally as it becomes relevant, not as a dump.

**Goal:** Together, arrive at enough clarity on what the feature does, its scope boundaries, and what to search for in the codebase. Propose wrapping up once you have enough to drive research.

**How to engage:**
- Lead with a recommendation or observation grounded in what you found, then ask for the user's take. Each question MUST include a **recommended answer** — the user refines your thinking rather than starting from zero.
- React to the user's response: push back if you see a concern, agree and build on it if it clicks, surface a related codebase pattern if relevant. Don't just acknowledge and move to an unrelated topic.
- Probe naturally: scope boundaries, trade-offs, edge cases, interactions with existing systems, alternative approaches.
- Wait for the user to respond each round.

**When to wrap up:**
- The user signals done.
- You can recommend strong answers to your own questions — you likely have enough context.
- 5 or more rounds have passed and the decision space feels resolved.

### Output

Write to `.work/brainstorms/YYYY-MM-DD-<slug>-brainstorm.md`:

```markdown
# <Topic> Brainstorm

## Context

### Matched Rules

| Rule | Source | Key Patterns |
|---|---|---|
| Title from H1 | file path | first 3-5 patterns |

### Codebase Patterns

- **Pattern:** <what was found>
- **Location:** <where>
- **Notes:** <consistency, alternatives, concerns>

## Decisions

- **<Decision area>:** <what was decided>
  - **Rationale:** <why>
  - **Alternatives considered:** <what else was discussed>

## Open Questions

- <things not yet resolved>

## Constraints Discovered

- <hard constraints surfaced during brainstorming>
```

Capture decisions and rationale, not a transcript of the conversation.

### Gate

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: brainstorm` and `updated` date.

### Wrap up

1. Summarize: decisions made, open questions remaining, constraints discovered.
2. Suggest next step: `/dl:research <slug>`.

## Re-entry mode

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read existing brainstorm artifact
- [ ] Run /resolve-rules
- [ ] Scan codebase for new patterns
- [ ] Present prior decisions summary
- [ ] Resume iterative questioning
- [ ] Update artifact
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: suggest /dl:research
```

1. Read the existing brainstorm artifact in full.
2. Run `/resolve-rules mode:keyword <topic>` as a subtask. Rules may have changed since last session.
3. Search the codebase for any new patterns relevant to the topic.
4. Present prior decisions: "Here's where we left off:" followed by key decisions and open questions. Ask: "What would you like to explore further?"
5. Resume collaborative exploration. Same conversational approach as create mode.
6. On wrap-up: rewrite the artifact with updated decisions. Mark changed decisions with rationale. Preserve unchanged decisions. Rewrite rather than append — decisions evolve as a whole; appending would create contradictions.

### Gate

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: brainstorm` and `updated` date.

### Wrap up

1. Summarize what changed: new decisions, changed decisions, resolved open questions.
2. Suggest next step: `/dl:research <slug>`.

## Rules

- Do not modify project files. This skill produces context, not code.
- Always include recommended answers with questions — do not ask bare questions.
- Capture decisions and rationale in the artifact, not a conversation transcript.
- On re-entry, rewrite the artifact (decisions evolve as a whole) — do not append a new dated section.
