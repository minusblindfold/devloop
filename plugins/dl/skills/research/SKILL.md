---
name: research
description: Executes research queries from a brainstorm artifact as targeted codebase searches, or researches a topic directly. Use after /dl:brainstorm or when discoveries surface during implementation.
argument-hint: "[feature-slug]"
allowed-tools: Read Write Bash Glob Grep
context: fork
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/research/`. Verify with `ls` before wrapping up.

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

## Mode

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them, offer to archive any with `date` older than 30 days to `.work/archive/`, then ask. Arguments always override.

Parse `$ARGUMENTS` (or auto-selected slug): matches existing file in `.work/research/` by slug → **re-entry**. Set but no match → **create**. Empty → stop and return, asking the caller for a topic.

You run in a forked context and cannot converse — when a choice is genuinely required (multiple current markers, no topic), stop and return the options to the caller instead of asking.

Find matching brainstorm artifact in `.work/brainstorms/` and extract its `## Research Queries` section. If missing, note it and derive queries from the given topic directly.

```
Task Progress:
- [ ] Determine mode; find and read brainstorm artifact (missing: derive queries from topic)
- [ ] If re-entry: read existing research artifact
- [ ] Read project rules from devloop/rules/
- [ ] Execute each research query as targeted search
- [ ] List findings per query in response
- [ ] Synthesize: identify gaps across queries
- [ ] Write artifact (create: new file; re-entry: append dated section)
- [ ] Gate: verify artifact with ls; update active marker
- [ ] Wrap up: summarize, suggest /dl:plan
```

## Query execution

Read `devloop/rules/*.md` if present — apply rules whose `keywords` match the topic; rules without `keywords` always apply. If a matched rule declares `repos:`, include those repos in the search. For each query from the brainstorm artifact, search the codebase with targeted reads and greps. Record findings per query — keep findings factual, not opinionated. When a query touches an existing feature, note how it's structured through the stack (e.g., route → service → model → test) — this gives plan concrete examples for vertical slicing.

## Synthesis

Compare findings across queries. Identify gaps — things the brainstorm assumed that don't match reality, missing implementations, inconsistencies. These become the Gaps & Recommendations.

## Re-entry

Read the existing research artifact in full. Execute brainstorm queries again (codebase may have changed since last session). Append a new `## YYYY-MM-DD` dated section — do not overwrite prior sections.

## Output

Write to `.work/research/YYYY-MM-DD-<slug>-research.md`:

```markdown
# <Topic> Research

## YYYY-MM-DD — <description>

### Applicable Rules
| Rule | Source | Key Patterns |

### Query: <research question>
- **Finding:** <what was discovered>
- **Location:** <where>
- **Implications:** <what this means>

### Gaps & Recommendations
- [ ] <actionable item>
```

Repeat `### Query:` for each research query. Omit `### Applicable Rules` on re-entry if rules haven't changed.

## Gate

Verify artifact with `ls`; write if missing. Update `.work/active/<slug>.md` with `stage: research` and today's date.

## Wrap up

Summarize: rules matched, findings per query, gaps count. Suggest next step: `/dl:plan <slug>`.

## Rules

- Do not modify project files. This skill produces context, not code.
- Do not overwrite prior research sections on re-entry (findings accumulate).
- Keep findings factual — opinions belong in brainstorm decisions.
- Without a brainstorm artifact, note it and derive queries from the topic.
