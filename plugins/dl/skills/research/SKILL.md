---
name: research
description: Executes research queries from a brainstorm artifact as targeted codebase searches. Requires a brainstorm with Research Queries. Use after /dl:brainstorm or when discoveries surface during implementation.
argument-hint: "[feature-slug]"
allowed-tools: Read Write Bash Glob Grep
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

**Artifact:** Write to `.work/research/`. Verify with `ls` before wrapping up.

**Constraint:** You MUST NOT modify project files. This skill produces context, not code.

## Mode

Check `.work/active/` for marker files. If exactly one exists and no $ARGUMENTS provided, auto-select that feature's slug. If multiple markers exist, list them and ask. Arguments always override.

Parse `$ARGUMENTS` (or auto-selected slug): matches existing file in `.work/research/` by slug → **re-entry**. Set but no match → **create**. Empty → ask what to research, then proceed in create mode.

**Brainstorm required:** Find matching brainstorm artifact in `.work/brainstorms/`. If missing, print "Run /dl:brainstorm first." and stop. Read the brainstorm artifact and extract the `## Research Queries` section.

```
Task Progress:
- [ ] Determine mode; find and read brainstorm artifact
- [ ] If brainstorm missing: stop with message
- [ ] If re-entry: read existing research artifact
- [ ] Run /resolve-rules mode:keyword <topic>
- [ ] Execute each research query as targeted search
- [ ] List findings per query in response
- [ ] Synthesize: identify gaps across queries
- [ ] Write artifact (create: new file; re-entry: append dated section)
- [ ] Gate: verify artifact with ls; update active marker
- [ ] Wrap up: summarize, suggest /dl:plan
```

## Query execution

Run `/resolve-rules mode:keyword <topic>` as a subtask. For each query from the brainstorm artifact, search the codebase with targeted reads and greps. For linked repos from resolve-rules, include them in the search. Record findings per query — keep findings factual, not opinionated.

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
- If no brainstorm artifact exists, stop and tell the user.
