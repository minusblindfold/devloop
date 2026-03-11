Review the changes made in this session and update all documentation to match.

## Content mapping

- `skills/*/SKILL.md` → Skills section in `README.md`
- `skills/backup.md` → referenced by plan and design skills
- `commands/document.md` → Commands section in `README.md`
- `rules/rules.md` → Rules section in `README.md`
- `devenv.json` → Config section in `README.md`
- `.claude-plugin/plugin.json` → version, description in `README.md`

## Doc sync targets

These docs describe the same system from different angles and must stay consistent:
- `README.md` — what devloop is, install, skills overview, rules, config
- `.claude-plugin/plugin.json` — plugin metadata (version, description, keywords)

## Structural sync

- New skill → add to skills table in `README.md`, update plugin.json keywords if relevant
- Skill renamed or removed → update `README.md` skills table
- New command → add to commands section in `README.md`
- Config change in `devenv.json` → update config section in `README.md`
- Version bump → update in `plugin.json` and `marketplace.json`
