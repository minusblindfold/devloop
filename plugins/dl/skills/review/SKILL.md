---
name: review
description: Load rules and design context, then review code changes for rule violations and security issues. Works standalone or after /dl:implement.
argument-hint: "[feature-slug]"
allowed-tools: Read Bash Glob Grep
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Artifact — required output

Write the artifact to `.work/reviews/`. Save the artifact before proceeding to wrap up. Do not summarize findings or suggest next steps until the artifact file has been written and verified with `ls`.

## Config

All artifacts are stored under `.work/` in the current project directory.

## Mode

Parse `$ARGUMENTS`:

- Matches an existing file in `.work/reviews/` by slug → **re-entry** (append dated section with new findings).
- Matches a plan in `.work/plans/` and a design in `.work/designs/` → **create** (workflow mode).
- Set but no matching plan/design → **create** (standalone mode using slug as context).
- Empty → detect current branch. If on `main`, review uncommitted changes only. Otherwise, **create** (standalone mode using branch name as context).

## Create mode

**Constraint:** You MUST NOT modify project files. This skill produces a review artifact, not code changes.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Determine mode (workflow / standalone)
- [ ] Run /resolve-rules
- [ ] List matched rules in response
- [ ] Load design context (workflow mode only)
- [ ] Load implementation notes (if present)
- [ ] Load git diff
- [ ] Review diff against rules (code review)
- [ ] Review diff for security issues
- [ ] Map findings to rules
- [ ] Write artifact to .work/reviews/
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize findings
```

### Determine context source

**Workflow mode** (plan + design found for slug):

1. Read the plan and design files in full.
2. Extract `**Rules:**` lines from the design's task specs. Collect all rule titles.
3. Run `/resolve-rules mode:explicit <titles>` as a subtask (invoke it, then return here and continue).
4. If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.
5. Read implementation notes from `.work/implementations/` matching the feature slug. Note any intentional deviations from the design — do not flag these as violations during review.

**Standalone mode** (no matching plan/design):

1. Detect the current branch: `git branch --show-current`.
2. Derive keywords from the branch name by splitting on `/` and `-` (e.g., `feature/add-user-auth` → "add user auth"). If a slug was provided as an argument, use it as keyword source instead.
3. Run `/resolve-rules mode:keyword <derived terms>` as a subtask (invoke it, then return here and continue).
4. If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — continuing without rules." Then continue.
5. No design spec or implementation notes are loaded.

List matched rules in your response, then continue with the next step.

### Load diff

1. Run `git branch --show-current` to confirm the current branch.
2. If on a feature branch (not `main`):
   - Run `git diff main...HEAD` to get all commits since the branch diverged.
   - Run `git diff` to get any uncommitted changes.
   - Combine both as the review scope.
3. If on `main`:
   - Run `git diff` to get uncommitted working tree changes only.
   - If no changes, print: "No changes to review." and stop.
4. Run `git diff main...HEAD --stat` (or `git diff --stat` on main) to get a file summary for the Review Scope section.

### Review

Review the diff in two passes. For each pass, consider the full context: resolved rules, design spec (if workflow mode), and implementation notes (if present).

**Pass 1 — Rule-mapped code review:**

For each resolved rule, check the diff for violations or deviations from the rule's patterns. For each finding:
- Cite the specific rule by title.
- Reference the file and line.
- Describe what the rule expects vs. what the code does.
- If an implementation note marks this as an intentional deviation, note it as "Acknowledged deviation" rather than a violation.

**Pass 2 — General code review and security review:**

Review the diff for:
- Code quality issues not covered by rules (logic errors, maintainability, naming, duplication).
- Security vulnerabilities (OWASP top 10, injection, auth issues, sensitive data exposure, insecure defaults).
- For each finding, reference the file and line. Categorize as general or security.

### Output

Write to `.work/reviews/YYYY-MM-DD-<slug>-review.md` (workflow) or `.work/reviews/YYYY-MM-DD-<branch>-review.md` (standalone):

```markdown
# <Feature or Branch> Review

## YYYY-MM-DD — Initial review

### Review Scope

- **Branch:** `<branch name>`
- **Commit range:** `<base>...<head>` (or "uncommitted changes" if on main)
- **Files changed:** <count>

### Matched Rules

| Rule | Source | Key Patterns |
|---|---|---|
| Title from H1 | file path | first 3-5 patterns |

_(if no rules matched, state: "No rules matched — general review only.")_

### Rule-Mapped Findings

#### <Rule Title>

- **`<file>:<line>`** — <description of violation or concern>
- **`<file>:<line>`** — <description>

_(repeat for each rule with findings. If a rule had no findings, omit it.)_

_(if no rule-mapped findings: "No rule violations found.")_

### General Findings

- **`<file>:<line>`** — <description of code quality issue>

_(if none: "No general issues found.")_

### Security Findings

- **`<file>:<line>`** — <description of vulnerability or concern>

_(if none: "No security issues found.")_

### Summary

- **Rule violations:** <count> across <N> rules
- **General findings:** <count>
- **Security findings:** <count>
- **Overall:** <brief assessment — clean, minor issues, needs attention>
```

### Gate

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Present findings summary: rule violation count, general finding count, security finding count.
2. If findings exist, suggest addressing them before committing.
3. If no findings, confirm the code looks good.
4. Suggest running `/dl:review <slug>` again after fixes for a re-review.

## Re-entry mode

**Constraint:** You MUST NOT modify project files. This skill produces a review artifact, not code changes.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read existing review artifact
- [ ] Run /resolve-rules
- [ ] List matched rules in response
- [ ] Load new git diff
- [ ] Compare against prior findings
- [ ] Review new/changed code
- [ ] Append dated section to artifact
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize changes since last review
```

1. Read the existing review artifact in full. Note prior findings.
2. Run `/resolve-rules` following the create mode context source logic (workflow or standalone, depending on what the prior review used).
3. Load the current git diff following the create mode diff loading steps.
4. Compare the current diff against prior findings:
   - **Resolved:** findings from the prior review that no longer appear in the diff (code was fixed).
   - **Persisting:** findings that still exist.
   - **New:** issues in code that changed since the last review.
5. Review any new or changed code in both passes (rule-mapped + general/security).
6. Append a new dated section to the artifact:

```markdown
## YYYY-MM-DD — Re-review

### Resolved from prior review

- **`<file>:<line>`** — <what was fixed> (was: <original finding>)

_(if none: "No prior findings were resolved.")_

### Persisting Findings

- **`<file>:<line>`** — <description> _(from YYYY-MM-DD review)_

### New Findings

#### Rule-Mapped

- **<Rule Title>** — **`<file>:<line>`** — <description>

#### General

- **`<file>:<line>`** — <description>

#### Security

- **`<file>:<line>`** — <description>

### Summary

- **Resolved:** <count>
- **Persisting:** <count>
- **New:** <count>
- **Overall:** <brief assessment>
```

### Gate

Run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to wrap up until the file is confirmed on disk.

### Wrap up

1. Summarize what changed since the last review: resolved count, persisting count, new count.
2. If all prior findings are resolved and no new issues, confirm the code is ready.
3. If findings persist or new issues appeared, suggest addressing them.

## Rules

- Do not modify project files. This skill produces a review artifact, not code changes.
- Do not flag intentional deviations documented in implementation notes as violations.
- Use the resolution algorithm for rule discovery — do not hardcode paths.
- Map findings to specific rules where applicable — do not lump everything into general findings.
- If no rules match and no issues are found, say so clearly.
