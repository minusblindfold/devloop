---
name: review
description: Load rules and design context, then review code changes for rule violations and security issues. Works standalone or after /dl:implement.
argument-hint: "[feature-slug]"
allowed-tools: Read Write Bash Glob Grep
context: fork
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/reviews/`. Verify with `ls` before wrapping up.

**Constraint:** You MUST NOT modify project files. This skill produces a review artifact, not code changes.

## Mode

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them, offer to archive any with `date` older than 30 days to `.work/archive/`, then ask. Arguments always override.

Parse `$ARGUMENTS` (or auto-selected slug): matches existing file in `.work/reviews/` → **re-entry**. Matches plan + design → **create** (workflow mode). Set but no plan/design → **create** (standalone, using slug as context). Empty → detect branch; main: uncommitted only; otherwise: standalone using branch name.

You run in a forked context and cannot converse — when a choice is genuinely required (multiple current markers, ambiguous slug), stop and return the options to the caller instead of asking.

```
Task Progress:
- [ ] Determine mode (workflow / standalone / re-entry)
- [ ] If re-entry: read existing review, note prior findings
- [ ] Resolve rules (workflow: explicit from design specs; standalone: keyword from slug)
- [ ] Load implementation notes if present (workflow only)
- [ ] Load git diff (feature branch: main...HEAD + uncommitted; main: uncommitted only)
- [ ] Review diff against rules — cite rule, file, line for each finding
- [ ] Review diff for code quality and security issues
- [ ] Write artifact (create: new file; re-entry: append dated section)
- [ ] Gate: verify artifact with ls; update and archive active marker
- [ ] Wrap up: summarize findings, suggest fixes or confirm clean
```

## Resolve rules and load context

**Workflow mode:** Read plan and design. Extract rule titles from task specs and apply the rules in `devloop/rules/` whose H1 titles match. Read implementation notes matching slug — note intentional deviations (do not flag as violations).

**Standalone mode:** Derive keywords from slug or branch name and apply rules in `devloop/rules/` whose `keywords` match; rules without `keywords` always apply. No design or implementation notes.

List matched rules in your response.

## Load diff

Feature branch: `git diff main...HEAD` + `git diff` (committed + uncommitted). Main branch: `git diff` only — if no changes, stop. Run `git diff --stat` for file summary.

## Review

**Pass 1 — Rule-mapped:** For each resolved rule, check diff for violations. Cite rule title, file, and line. Describe what the rule expects vs. what the code does. If an implementation note marks a deviation as intentional, note as "Acknowledged deviation."

**Pass 2 — General and security:** Review for code quality issues not covered by rules (logic, naming, duplication) and security vulnerabilities (OWASP top 10, injection, auth, data exposure). Reference file and line for each finding.

## Re-entry

Read existing review artifact. Run rule resolution and load diff. Compare against prior findings: resolved, persisting, new. Review new/changed code in both passes. Append a dated `## YYYY-MM-DD — Re-review` section with categorized findings and counts.

## Output

Write to `.work/reviews/YYYY-MM-DD-<slug>-review.md` (workflow) or `YYYY-MM-DD-<branch>-review.md` (standalone):

```markdown
# <Feature or Branch> Review

## YYYY-MM-DD — <Initial review / Re-review>

### Review Scope
### Matched Rules
| Rule | Source | Key Patterns |
### Rule-Mapped Findings
### General Findings
### Security Findings
### Summary
```

## Gate

Verify artifact with `ls`; write if missing. Update `.work/active/<slug>.md` with `stage: reviewed` and today's date, then move it to `.work/archive/` — the feature is complete.

## Wrap up

Summarize: rule violations, general findings, security findings. If findings exist, suggest addressing them. If clean, confirm. Suggest `/dl:review <slug>` again after fixes.

## Rules

- Do not modify project files. This skill produces a review artifact, not code changes.
- Do not flag intentional deviations documented in implementation notes as violations.
- Map findings to specific rules where applicable — do not lump into general findings.
- If no rules match and no issues found, say so clearly.
