---
name: resolve-rules
description: Resolve and return rule docs from configured layers. Called by other skills — not intended for direct use.
user-invocable: false
allowed-tools: Read, Glob, Grep
---

Execute each section below in order. Do not skip sections.

1. Copy the **Task Progress** checklist below into your response.
2. Work through each item. Check it off as you complete it.

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

Build the layer list using four tiers (highest precedence first):

| Precedence | Layer | Path | Description |
|---|---|---|---|
| 1 (highest) | User | `~/.claude/rules/` | Claude Code native, personal overrides |
| 2 | Project | `{cwd}/devloop/rules/` | Project-specific rules |
| 3 | Shared/org | `~/devloop/rules/` | Rule packs managed by devloop CLI |
| 4 (lowest) | Plugin-bundled | `${CLAUDE_PLUGIN_ROOT}/rules/` | Defaults shipped with devloop |

1. Check if `~/.claude/rules/` exists. If so, add it as the highest-precedence layer.
2. Check if `{cwd}/devloop/rules/` exists. If so, add it as the next layer. Skip silently if missing.
3. Check if `~/devloop/rules/` exists. If so, scan this directory and all subdirectories — each subdirectory is an enabled pack. Add all discovered rule directories as layers. Skip silently if missing.
4. Check if `${CLAUDE_PLUGIN_ROOT}/rules/` exists. If so, add it as the lowest-precedence layer.

If only one source exists, use flat mode (single layer). If multiple sources exist, use layered mode with precedence as described.

### Build the resolution map

Walk layers in order (highest precedence first). In flat mode, there is only one layer.

1. In each layer directory, find all `.md` files (exclude `rules.md` — that is documentation, not a rule).
2. Read YAML frontmatter (between `---` delimiters) from each file.
3. Build a resolution map keyed by filename:
   - First occurrence of a filename → add it (path, keywords, title, repos).
   - Subsequent occurrence → check the new doc's `extends` frontmatter:
     - `extends: true` → mark as extension. Read both: higher-precedence doc first, then this one appends.
     - `extends: false` or omitted → skip. Higher-precedence version already won.
4. For docs without frontmatter, use the H1 title and blockquote description for matching. These docs are still resolved but can only be matched by title.
5. Skip missing layer directories with a warning. Do not error.
6. If no rules are found across all layers, this is a valid state — proceed to output with no rules.

## Matching

Apply the mode from $ARGUMENTS:

### all
Return every resolved doc.

### keyword
Scan each term against resolved docs' `keywords` arrays. Return all matches.

### explicit
Match each title against the H1 heading of resolved docs. Return all matches.

### Always-scoped rules

After mode matching, scan the full resolution map for rules with `scope: always` in their frontmatter. Merge these into the matched set if not already present. This ensures cross-cutting rules (e.g., git conventions, code style) are included regardless of mode or keywords.

### Scope filtering

If a `scope:<value>` modifier is present in $ARGUMENTS, apply it as a post-filter after mode matching. Keep rules where:
- the frontmatter `scope` matches the requested value, OR
- `scope` equals `all`, OR
- `scope` equals `always`, OR
- no `scope` field is present (defaults to `all`)

Exclude rules with `scope: feature` when `scope:bootstrap` is requested, and vice versa. Do not exclude rules with `scope: always`.

If no `scope` modifier is present, skip this filter — return all mode-matched rules regardless of scope.

## Output

Print: "Applying rules: \<list of matched titles\> (from \<layer path\>)". If no rules match, print: "No rules apply to this task."

### Linked repos

After printing matched rules, scan all matched rules for `repos` frontmatter fields. Collect all paths and deduplicate — if the same path appears in multiple rules, list it once and note all source rules.

If any repos are found, print: "Linked repos: `<path>` (from `<rule title>`), `<path>` (from `<rule title>`)"

If no repos are declared in any matched rule, skip silently — do not print anything about linked repos.
