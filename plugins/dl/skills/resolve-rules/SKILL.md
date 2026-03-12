---
name: resolve-rules
description: Resolve and return rule docs from configured layers. Called by other skills — not intended for direct use.
user-invocable: false
allowed-tools: Read, Glob, Grep
---

Discover and read rule docs from the base rules directory and any configured layers.

## Input

The calling skill passes context via $ARGUMENTS:

- `mode:all` — return every resolved rule doc.
- `mode:keyword <terms>` — match terms against frontmatter `keywords` arrays.
- `mode:explicit <title1>, <title2>` — match listed titles against H1 headings.
- Optional modifier: `scope:<value>` — filter results by the `scope` frontmatter field. Can be appended to any mode (e.g., `mode:all scope:bootstrap`).

If $ARGUMENTS is empty, default to `mode:all`.

## Resolution

### Determine mode

Build the layer list using four tiers (highest precedence first):

| Precedence | Layer | Path | Description |
|---|---|---|---|
| 1 (highest) | User | `~/.claude/rules/` | Claude Code native, personal overrides |
| 2 | Project | `{cwd}/devloop/rules/` | Project-specific rules |
| 3 | Shared/org | `~/devloop/rules/` | Rule packs managed by devloop CLI |
| 4 (lowest) | Plugin-bundled | `${CLAUDE_PLUGIN_ROOT}/rules/` | Defaults shipped with devloop |

1. Check if `~/.claude/rules/` exists (user rules). If so, add it as the highest-precedence layer.
2. Check if `{cwd}/devloop/rules/` exists (project rules). If so, add it as the next layer. Skip silently if it doesn't exist.
3. Check if `~/devloop/rules/` exists (shared/org rule packs). If so, scan this directory and all its subdirectories — each subdirectory is an enabled pack. Add all discovered rule directories as layers. Skip silently if it doesn't exist.
4. Check if `${CLAUDE_PLUGIN_ROOT}/rules/` exists (plugin-bundled rules). If so, add it as the lowest-precedence layer.

If only one source exists, use flat mode (single layer). If multiple sources exist, use layered mode with precedence as described.

### Build the resolution map

Walk layers in order (highest precedence first). In flat mode, there is only one layer.

1. In each layer directory, find all `.md` files (excluding `rules.md`, which is documentation, not a rule).
2. Read YAML frontmatter (between `---` delimiters) from each file.
3. Build a resolution map keyed by filename:
   - First occurrence of a filename → add it (path, keywords, title).
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

Rules with `scope: feature` are excluded when `scope:bootstrap` is requested, and vice versa. Rules with `scope: always` are never excluded.

If no `scope` modifier is present, skip this filter — return all mode-matched rules regardless of scope. This preserves backward compatibility.

## Output

Print: "Applying rules: \<list of matched titles\> (from \<layer path\>)". If no rules match, print: "No rules apply to this task."
