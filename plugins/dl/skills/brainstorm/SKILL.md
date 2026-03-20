---
name: brainstorm
description: Iterative questioning to refine a feature idea before research and planning. Use when the user wants to brainstorm, explore an idea, or probe a feature concept.
argument-hint: "[feature or topic]"
allowed-tools: Read Bash Glob Grep
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Artifact — required output

Write the artifact to `.work/brainstorms/`. Save the artifact before proceeding to wrap up. Do not summarize or suggest next steps until the artifact file has been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Mode

Parse `$ARGUMENTS`:

- Matches an existing file in `.work/brainstorms/` by slug → **re-entry** (reopen conversation from prior decisions).
- Set but no match → **create** new brainstorm.
- Empty → ask the user what they would like to brainstorm. Wait for a topic, then proceed in **create** mode.

## Create mode

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Determine mode (create / re-entry)
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

### Context gathering

1. Run `/resolve-rules` as a subtask (invoke it, then return here and continue):
   - Topic provided → `mode:keyword <topic>`.
   - If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.
   - After resolve-rules completes, extract title (H1 heading), source layer path, and first 3–5 key patterns from each matched rule.
   - List matched rules in your response, then continue with step 2 below.

2. Read `CLAUDE.md` if present.

3. Scan the project directory structure (top-level + key subdirectories).

4. If `/resolve-rules` output included "Linked repos", scan each declared repo:
   - Expand `~` and verify the directory exists. If not, print a warning and skip.
   - Read `CLAUDE.md` (or `README.md` if no CLAUDE.md).
   - Scan the top-level directory structure with `ls`.
   - Grep for topic-relevant patterns. Limit to the top 10–15 matches.

5. Search the project codebase for patterns relevant to the topic. Look for existing implementations, naming patterns, tech choices, and anything that might shape the feature. This is the same depth as `/research`.

6. List what you found: matched rules, codebase patterns, linked repo context. This grounds the conversation in project reality.

### Iterative questioning

Ask questions in rounds. Each round builds on prior answers.

**Per round:**
- Ask 2–4 questions about the feature.
- Each question MUST include a **recommended answer** based on what you found in the codebase, rules, and prior answers. The user refines your recommendation rather than starting from zero.
- Questions should probe: scope boundaries, trade-offs, edge cases, interactions with existing systems, user expectations, alternative approaches.
- Wait for the user to respond.

**Between rounds:**
- Assess whether there are more branches to explore.
- If the user signals they are done (e.g., "done", "that's enough", "let's move on") → wrap up.
- If 3 or more rounds have passed and the decision space feels resolved, propose wrapping up: "I think we've covered the key decisions. Ready to wrap up, or is there more to explore?"
- If more to explore → ask the next round.

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

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Summarize: decisions made, open questions remaining, constraints discovered.
2. Suggest next step: `/dl:research <slug>` to do a deep codebase scan informed by these decisions.

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
2. Run `/resolve-rules` as a subtask (invoke it, then return here and continue). Rules may have changed since the last session.
3. Search the codebase for any new patterns relevant to the topic.
4. Present a summary of prior decisions to the user: "Here's where we left off:" followed by the key decisions and any open questions. Ask: "What would you like to explore further?"
5. Resume iterative questioning, building on prior decisions. Same round structure as create mode.
6. On wrap-up: rewrite the artifact with updated decisions. Mark changed decisions with rationale for the change. Preserve any decisions that haven't changed.
7. Gate: verify file with `ls`.

### Gate

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Summarize what changed: new decisions, changed decisions, newly resolved open questions.
2. Suggest next step: `/dl:research <slug>` to do a deep codebase scan informed by these decisions.

## Rules

- Do not modify project files. This skill produces context, not code.
- Always include recommended answers with questions — do not ask bare questions.
- Use the resolution algorithm for rule discovery — do not hardcode paths.
- Capture decisions and rationale in the artifact, not a conversation transcript.
- On re-entry, reopen the conversation from prior decisions — do not append a new dated section.
