# devloop

Structured development workflow plugin for Claude Code.

## Versioning

This project uses **semver** (`MAJOR.MINOR.PATCH`). When making changes that affect plugin behavior (skills, commands, hooks, rules), bump the version in **both** files before merging:

- `plugins/dl/.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`

Bump rules:
- **Patch** (1.1.x): bug fixes, typo corrections, doc-only changes
- **Minor** (1.x.0): new skills/commands, changed skill behavior, new rules
- **Major** (x.0.0): breaking changes to skill interfaces or plugin structure

## Git

Always work on a feature branch off `main`. Never commit directly to `main`.

## Testing skill changes

Editing `plugins/dl/skills/` does not affect running sessions — the installed plugin cache lags this repo. Skill changes only take effect after reinstalling the plugin or running with `claude --plugin-dir .`; live-test them that way before release.

## Doc sync

When changing skills or plugin config, update documentation to match.

### Content mapping

- `plugins/dl/skills/*/SKILL.md` → Skills table in `README.md`
- `docs/rules.md` → Rules section in `README.md`
- `plugins/dl/.claude-plugin/plugin.json` → description in `README.md` intro (README carries no version string)

### Structural sync

- New skill → add to skills table in `README.md`, update plugin.json keywords if relevant
- Skill renamed or removed → update `README.md` skills table
- Version bump → update in `plugin.json` and `marketplace.json`
