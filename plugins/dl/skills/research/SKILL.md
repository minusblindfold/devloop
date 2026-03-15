---
name: research
description: Scans rules and codebase to produce structured research artifacts that inform planning and design. Use when starting a new feature or when discoveries surface during implementation.
argument-hint: "[feature-slug or topic]"
allowed-tools: Read Bash Glob Grep
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Artifact — required output

Write the artifact to `.work/research/`. Save the artifact before proceeding to wrap up. Do not summarize findings or suggest next steps until the artifact file has been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Mode

Parse `$ARGUMENTS`:

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

Run `/resolve-rules`:
- Topic provided → `mode:keyword <topic>`.

If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.

For each matched rule, extract:
- Title (H1 heading)
- Source layer path
- First 3–5 key patterns

List matched rules in your response before proceeding to the next step. If no rules matched, state that explicitly.

### Linked repo scan

If `/resolve-rules` output included "Linked repos", scan each declared repo. If no linked repos were declared, skip this section.

For each linked repo path:
1. Expand `~` and verify the directory exists. If not, print a warning and skip that repo.
2. **Orientation:** Read `CLAUDE.md` (or `README.md` if no CLAUDE.md) to understand what the repo does. Scan the top-level directory structure with `ls`.
3. **Targeted search:** Use the topic keywords from the research topic to `Grep` the linked repo for relevant code (controllers, services, API definitions, shared types, config). Limit to the top 10–15 matches to avoid flooding context.

List findings in your response before proceeding:
- **Repo:** `<path>`
- **Description:** (from CLAUDE.md first paragraph or repo name if no CLAUDE.md)
- **Structure:** (top-level directories)
- **Relevant code:** (grep matches — file, line, snippet)

### Code search

Search code for patterns relevant to the topic. Look for existing implementations, inconsistencies, multiple approaches, tech choices. Note anything that might affect planning or design.

List each discovered pattern in your response before proceeding. Use the artifact template format (Pattern, Location, Notes) so findings transfer directly to the artifact.

### Synthesis

Review your matched rules and discovered patterns. Identify gaps between what the rules prescribe and what the codebase does. These gaps become the Gaps & Recommendations in the artifact.

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

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Summarize what was found: rules matched, patterns observed, recommendations count.
2. Suggest next steps:
   - `/plan` or `/plan <slug>` to start planning from findings.
   - `/plan refine` if recommendations affect an existing plan.
   - `/design` if a plan already exists and findings inform architecture.

## Re-entry mode

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read existing research file in full
- [ ] Run /resolve-rules
- [ ] Extract rule title, source, and key patterns for each match
- [ ] List matched rules in response
- [ ] Scan linked repos for new patterns (if declared)
- [ ] Search code for new patterns relevant to the topic
- [ ] List discovered patterns in response
- [ ] Review and synthesize new findings against prior research
- [ ] Append new dated section to artifact
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize and suggest next steps
```

1. Read the existing research file in full.
2. Run `/resolve-rules` as described in the create mode rule scan section. List matched rules in your response before proceeding. If no rules matched, state that explicitly.
3. If linked repos were declared, scan them as described in the create mode "Linked repo scan" section. Include linked repo findings in the new dated section.
4. Search code for new patterns relevant to the topic. List each discovered pattern in your response using the artifact template format (Pattern, Location, Notes).
5. Compare new findings against the existing research sections. Focus on what changed, what's new, and what prior recommendations are now resolved.
6. Append a new `## YYYY-MM-DD — <description>` section at the end. Do not overwrite or modify prior sections.

### Gate

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Summarize new findings: rules matched, patterns observed, recommendations count.
2. Suggest next steps as in create mode.

## Rules

- Do not modify project files. This skill produces context, not code.
- Do not overwrite prior research sections on re-entry.
- Use the resolution algorithm for rule discovery — do not hardcode paths.
- Keep recommendations actionable and scoped — do not pad with vague suggestions.
- If no rules match and no relevant codebase patterns are found, say so clearly.
