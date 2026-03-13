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
