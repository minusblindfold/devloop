---
name: research
description: Scans rules and codebase to produce structured research artifacts that inform planning and design. Use when starting a new feature or when discoveries surface during implementation.
argument-hint: "[feature-slug or topic]"
allowed-tools: Read Write Bash Glob Grep
---

Execute each section in order. Copy the checklist from your mode's section and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/research/`. Verify with `ls` before wrapping up.

## Mode

**Active feature detection:** Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug — print "Auto-selected feature: <slug>". If multiple markers exist, list them and ask. Arguments always override the marker.

Parse `$ARGUMENTS` (or auto-selected slug):

- Matches an existing file in `.work/research/` by slug → **re-entry** (append dated section).
- Set but no match → **create** new research file.
- Empty → ask the user what they would like to research. Wait for a topic, then proceed in **create** mode.

## Create mode

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Determine mode (create / re-entry)
- [ ] Run /resolve-rules
- [ ] Extract rule title, source, and key patterns for each match
- [ ] List matched rules in response
- [ ] Read CLAUDE.md
- [ ] Scan project directory structure
- [ ] Scan linked repos (if declared)
- [ ] Search code for topic-relevant patterns
- [ ] List discovered patterns in response
- [ ] Review and synthesize findings
- [ ] Write artifact to .work/research/
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize and suggest next steps
```

### Rule scan

Run `/resolve-rules mode:keyword <topic>` as a subtask. If unavailable, continue without rules. Extract title, source, and key patterns from each match. List matched rules in your response. If none matched, state that explicitly.

### Linked repo scan

If resolve-rules output included "Linked repos", scan each declared repo. Skip if none declared.

For each linked repo:
1. Verify the directory exists. Skip missing repos with a warning.
2. **Orientation:** Read `CLAUDE.md` (or `README.md`). Scan top-level with `ls`.
3. **Targeted search:** Grep for topic-relevant code (limit 10–15 matches).

List findings (repo, description, structure, relevant code) before proceeding.

### Code search

Search code for patterns relevant to the topic: existing implementations, inconsistencies, tech choices. List each pattern using the artifact format (Pattern, Location, Notes).

### Synthesis

Compare matched rules against discovered patterns. Identify gaps — these become the Gaps & Recommendations.

### Output

Write to `.work/research/YYYY-MM-DD-<slug>-research.md`.

```markdown
# <Topic> Research

## YYYY-MM-DD — <description>

### Applicable Rules

| Rule | Source | Key Patterns |
|---|---|---|
| Title from H1 | file path | first 3-5 patterns |

### Linked Repo Context

_(omit this section if no linked repos were declared)_

- **Repo:** `<path>`
- **Description:** <what this repo does>
- **Structure:** <top-level layout>
- **Relevant code:**
  - `<file>:<line>` — <snippet/description>

### Codebase Patterns

- **Pattern:** <what was found>
- **Location:** <where>
- **Notes:** <consistency, alternatives, concerns>

### Gaps & Recommendations

- [ ] <actionable item>
```

### Gate

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: research` and `updated` date.

### Wrap up

1. Summarize: rules matched, patterns observed, recommendations count.
2. Suggest next steps: `/plan <slug>`, `/plan refine`, or `/design` as appropriate.

## Re-entry mode

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read existing research file in full
- [ ] Run /resolve-rules
- [ ] List matched rules in response
- [ ] Scan linked repos for new patterns (if declared)
- [ ] Search code for new patterns
- [ ] List discovered patterns in response
- [ ] Synthesize new findings against prior research
- [ ] Append new dated section to artifact
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize and suggest next steps
```

1. Read the existing research file in full.
2. Follow the create mode rule scan and linked repo scan sections.
3. Search code for new patterns. List discoveries using the artifact format (Pattern, Location, Notes).
4. Compare against existing research: what changed, what's new, what prior recommendations are resolved.
5. Append a new `## YYYY-MM-DD — <description>` section. Do not overwrite prior sections — findings accumulate over time, and prior findings remain valid context.

### Gate

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: research` and `updated` date.

### Wrap up

1. Summarize new findings: rules matched, patterns observed, recommendations count.
2. Suggest next steps as in create mode.

## Rules

- Do not modify project files. This skill produces context, not code.
- Do not overwrite prior research sections on re-entry (findings accumulate).
- Keep recommendations actionable and scoped.
- If no rules match and no relevant patterns found, say so clearly.
