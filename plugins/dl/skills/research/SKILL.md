---
name: research
description: Scans rules and codebase to produce structured research artifacts that inform planning and design. Use when starting a new feature, when discoveries surface during implementation, or when a project health check is needed.
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
- Empty → **health-check** mode. Ask the user: "This will run a full project health check (all rules + full codebase scan). This can take a while. Continue, or would you like to research a specific topic instead?" If they provide a topic, switch to create mode. If they confirm, proceed.

## Create mode

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Determine mode (create / re-entry / health-check)
- [ ] Run rule scan via /resolve-rules
- [ ] Read CLAUDE.md
- [ ] Scan project directory structure
- [ ] Check for .work/bootstrap.md
- [ ] Search codebase for topic-relevant patterns
- [ ] Write artifact to .work/research/
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize and suggest next steps
```

### Rule scan

Run `/resolve-rules`:
- Topic provided → `mode:keyword <topic>`.
- Health-check → `mode:all`.

If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.

For each matched rule, extract:
- Title (H1 heading)
- Source layer path
- First 3–5 key patterns

### Codebase scan

**Constraint:** Do not modify project files. This skill produces context, not code.

1. Read `CLAUDE.md` if present.
2. Scan project directory structure (top-level + key subdirectories).
3. Check for `.work/bootstrap.md` — read if found.
4. Search code for patterns relevant to the topic. Look for existing implementations, inconsistencies, multiple approaches, tech choices.
5. Note anything that might affect planning or design.

### Output

Write to `.work/research/YYYY-MM-DD-<slug>-research.md` (or `health-check.md` for health-check mode).

```markdown
# <Topic> Research

## YYYY-MM-DD — <description>

### Applicable Rules

| Rule | Source | Key Patterns |
|---|---|---|
| Title from H1 | file path | first 3-5 patterns |

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

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read existing research file in full
- [ ] Run rule scan via /resolve-rules
- [ ] Scan codebase for new patterns
- [ ] Append new dated section to artifact
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize and suggest next steps
```

**Constraint:** Do not modify project files. This skill produces context, not code.

1. Read the existing research file in full.
2. Run `/resolve-rules` as described in the create mode rule scan section.
3. Scan the codebase for new patterns relevant to the topic.
4. Append a new `## YYYY-MM-DD — <description>` section at the end. Do not overwrite or modify prior sections.

### Gate

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Summarize new findings: rules matched, patterns observed, recommendations count.
2. Suggest next steps as in create mode.

## Health-check mode

Follow the create mode checklist and steps, but use `mode:all` for rule scan and write to `.work/research/health-check.md`.

## Rules

- Do not modify project files. This skill produces context, not code.
- Do not overwrite prior research sections on re-entry.
- Use the resolution algorithm for rule discovery — do not hardcode paths.
- Keep recommendations actionable and scoped — do not pad with vague suggestions.
- If no rules match and no relevant codebase patterns are found, say so clearly.
