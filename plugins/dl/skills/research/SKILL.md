---
name: research
description: Scans rules and codebase to produce structured research artifacts that inform planning and design. Use when starting a new feature, when discoveries surface during implementation, or when a project health check is needed.
argument-hint: "[feature-slug or topic]"
allowed-tools: Read Bash Glob Grep
---

Scan rules and codebase to produce structured context for the plan/design/implement cycle.

## Artifact — required output

This skill produces a file in `<work.dir>/research/`. Every execution — create, re-entry, or health-check — must end with a saved artifact on disk. The wrap-up phase below is gated on this: do not summarise findings or suggest next steps until the artifact file has been written and verified with `ls`.

## Config

Read `devenv.json` from `${CLAUDE_PLUGIN_ROOT}/devenv.json` (if running as a plugin) or `~/.claude/devenv.json` (fallback). Keys: `work.dir` (default `.work`).

## Mode

Parse `$ARGUMENTS`:

- Matches an existing file in `<work.dir>/research/` by slug → **re-entry** (append dated section).
- Set but no match → **create** new research file.
- Empty → **health-check** mode. Before starting, confirm with the user: "This will run a full project health check (all rules + full codebase scan). This can take a while. Continue, or would you like to research a specific topic instead?" If they provide a topic, switch to create mode. If they confirm, proceed — writes to `<work.dir>/research/health-check.md`.

## Rule scan

Run `/resolve-rules` to discover rules:
- If topic provided → `mode:keyword <topic>` (match topic against frontmatter keywords).
- If health-check → `mode:all` (return every resolved rule).

If `/resolve-rules` is unavailable, warn the user: "Rule resolution skill not found — rules will not be applied." Then continue without rules.

For each matched rule, extract:
- Title (H1 heading)
- Source layer path
- First 3–5 key patterns

## Codebase scan

1. Read `CLAUDE.md` if present.
2. Scan project directory structure (top-level + key subdirectories).
3. Check for `<work.dir>/bootstrap.md` — read if found.
4. Search code for patterns relevant to the topic — look for existing implementations, inconsistencies, multiple approaches, tech choices.
5. Note anything that might affect planning or design.

## Output

Write to `<work.dir>/research/YYYY-MM-DD-<slug>-research.md` (or `health-check.md` for health-check mode).

**Gate:** run `ls` on the saved file path. If the file does not exist, write it now. Do not proceed to the wrap-up phase until the file is confirmed on disk.

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

## Re-entry

If appending to an existing file:
1. Read the existing file in full.
2. Append a new `## YYYY-MM-DD — <description>` section at the end.
3. Never overwrite or modify prior sections.

## Wrap up

- Summarise what was found: rules matched, patterns observed, recommendations count.
- Suggest next steps:
  - `/plan` or `/plan <slug>` to start planning from findings.
  - `/plan refine` if recommendations affect an existing plan.
  - `/design` if a plan already exists and findings inform architecture.

## Rules

- Never implement. This skill produces context, not code.
- Never overwrite prior research sections on re-entry.
- Rule discovery must use the resolution algorithm — never hardcode paths.
- Keep recommendations actionable and scoped — avoid vague suggestions.
- If no rules match and no relevant codebase patterns are found, say so clearly rather than padding the output.
