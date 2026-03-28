---
name: review
description: Load rules and design context, then review code changes for rule violations and security issues. Works standalone or after /dl:implement.
argument-hint: "[feature-slug]"
allowed-tools: Read Bash Glob Grep
---

Execute each section in order. Copy the checklist from your mode's section and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/reviews/`. Verify with `ls` before wrapping up.

## Mode

**Active feature detection:** Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug — print "Auto-selected feature: <slug>". If multiple markers exist, list them and ask. Arguments always override the marker.

Parse `$ARGUMENTS` (or auto-selected slug):

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

### Determine context and load diff

**Resolve rules:**
- If plan + design exist for the slug (**workflow mode**): read them. Extract rule titles from design task specs. Run `/resolve-rules mode:explicit <titles>` as a subtask. Read implementation notes matching the slug — note intentional deviations (do not flag these as violations).
- If no plan/design (**standalone mode**): derive keywords from branch name or slug. Run `/resolve-rules mode:keyword <terms>`. No design or implementation notes loaded.

If `/resolve-rules` is unavailable, continue without rules. List matched rules in your response.

**Load diff:**
- Feature branch: `git diff main...HEAD` + `git diff` (committed + uncommitted).
- Main branch: `git diff` only. If no changes, stop.

Run `git diff --stat` for the file summary.

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

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: reviewed` and `updated` date.

### Wrap up

1. Present findings summary: rule violations, general findings, security findings.
2. If findings exist, suggest addressing them. If none, confirm the code looks good.
3. Suggest `/dl:review <slug>` again after fixes.

## Re-entry mode

**Constraint:** You MUST NOT modify project files. This skill produces a review artifact, not code changes.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Read existing review artifact
- [ ] Run /resolve-rules and load diff (follow create mode steps)
- [ ] Compare against prior findings
- [ ] Review new/changed code
- [ ] Append dated section to artifact
- [ ] Gate: verify artifact with ls
- [ ] Wrap up: summarize changes since last review
```

1. Read the existing review artifact in full. Note prior findings.
2. Run rule resolution and load diff following the create mode steps.
3. Compare current diff against prior findings: **Resolved** (fixed), **Persisting** (still exist), **New** (in changed code since last review).
4. Review new/changed code in both passes (rule-mapped + general/security).
5. Append a new `## YYYY-MM-DD — Re-review` section with: Resolved from prior review, Persisting Findings, New Findings (Rule-Mapped / General / Security), Summary (resolved/persisting/new counts).

### Gate

Run `ls` on the file. If missing, write it now. Update the active feature marker: set `stage: reviewed` and `updated` date.

### Wrap up

1. Summarize: resolved count, persisting count, new count.
2. If all resolved and no new issues, confirm code is ready. Otherwise suggest addressing findings.

## Rules

- Do not modify project files. This skill produces a review artifact, not code changes.
- Do not flag intentional deviations documented in implementation notes as violations.
- Map findings to specific rules where applicable — do not lump into general findings.
- If no rules match and no issues found, say so clearly.
