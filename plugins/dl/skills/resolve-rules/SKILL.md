---
name: resolve-rules
description: Resolve and return rule docs from configured layers. Called by other skills — not intended for direct use.
user-invocable: false
allowed-tools: Read, Glob, Grep
---

**Subtask: return to the parent skill's checklist after completing.**

Execute each section below in order. Do not skip sections. Copy the checklist into your response and check off items as you complete them.

```
Task Progress:
- [ ] Parse mode and scope from $ARGUMENTS
- [ ] Build layer list (user → project → shared → plugin)
- [ ] Walk layers, build resolution map
- [ ] Apply mode matching (all / keyword / explicit)
- [ ] Merge always-scoped rules
- [ ] Apply scope filter if present
- [ ] Print matched rules or "No rules apply"
- [ ] Print linked repos or skip if none
```

## Input

The calling skill passes context via $ARGUMENTS:

- `mode:all` — return every resolved rule doc.
- `mode:keyword <terms>` — match terms against frontmatter `keywords` arrays.
- `mode:explicit <title1>, <title2>` — match listed titles against H1 headings.
- Optional modifier: `scope:<value>` — filter results by the `scope` frontmatter field. Can be appended to any mode (e.g., `mode:all scope:bootstrap`).

If $ARGUMENTS is empty, default to `mode:all`.

## Resolution

### Build the layer list

Check each layer directory in precedence order (highest first). Skip missing directories silently.

| Precedence | Layer | Path |
|---|---|---|
| 1 (highest) | User | `~/.claude/rules/` |
| 2 | Project | `{cwd}/devloop/rules/` |
| 3 | Shared/org | `~/devloop/rules/` (each subdirectory is an enabled pack) |
| 4 (lowest) | Plugin-bundled | `${CLAUDE_PLUGIN_ROOT}/rules/` |

### Build the resolution map

Walk layers in precedence order. For each layer, find all `.md` files (exclude `rules.md`). Read YAML frontmatter from each file.

Build a map keyed by filename:
- First occurrence → add it (path, keywords, title, repos).
- Subsequent occurrence → skip unless the new doc has `extends: true` (read both, higher-precedence first).
- Docs without frontmatter: match by H1 title only.

No rules found across all layers is valid — proceed to output.

## Matching

Apply the mode from $ARGUMENTS:

### all
Return every resolved doc.

### keyword
Scan each term against resolved docs' `keywords` arrays. Return all matches.

### explicit
Match each title against the H1 heading of resolved docs. Return all matches.

### Post-processing

After mode matching:
1. Merge any rules with `scope: always` into the matched set (cross-cutting rules apply regardless of mode).
2. If a `scope:<value>` modifier was passed, filter to rules where scope matches the value, `scope: all`, `scope: always`, or no scope field. Exclude cross-scope (`feature` when `bootstrap` requested, and vice versa). If no scope modifier, skip this filter.

## Output

Print: "Applying rules: \<list of matched titles\> (from \<layer path\>)". If no rules match, print: "No rules apply to this task."

### Linked repos

If any matched rules have `repos` frontmatter fields, print: "Linked repos: `<path>` (from `<rule title>`)" for each unique path. If none, skip silently.

## Return to caller

Return to the parent skill's checklist immediately. Do not stop, summarize, or ask the user what to do next.
