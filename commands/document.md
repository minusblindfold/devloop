Review the changes made in this session and update all documentation to match.

## Config to cheatsheet mapping

- `ghostty/` → `docs/ghostty-cheatsheet.md` + Ghostty section in `docs/cheatsheet.md`
- `zsh/` → Shell section in `docs/cheatsheet.md`
- `claude/` → Claude section in `docs/cheatsheet.md`
- `git-hooks/` → Git section in `docs/cheatsheet.md`
- `bin/cheat` → CLI > cheat section in `docs/cheatsheet.md`
- `bin/picker-paths` → CLI > picker-paths section in `docs/cheatsheet.md`
- `bin/view-plan` → CLI > view-plan section in `docs/cheatsheet.md`
- `bin/view-design` → CLI > view-design section in `docs/cheatsheet.md`
- `bin/view-implement` → CLI > view-implement section in `docs/cheatsheet.md`
- `bin/view-research` → CLI > view-research section in `docs/cheatsheet.md`
- `bin/open-diagrams` → CLI > open-diagrams section in `docs/cheatsheet.md`
- `claude/skills/implement/SKILL.md` → Claude section in `docs/cheatsheet.md`
- `claude/skills/plan/SKILL.md` → Claude section in `docs/cheatsheet.md` *(create + refine mode)*
- `claude/skills/design/SKILL.md` → Claude section in `docs/cheatsheet.md` *(create, bootstrap + refine mode)*
- `claude/skills/research/SKILL.md` → Claude section in `docs/cheatsheet.md`
- `claude/devenv.json` → Claude section in `docs/cheatsheet.md` (skill config location)
- `starship/` → Shell section in `docs/cheatsheet.md`
- `picker/` → Project Picker section in `docs/guide.md`

## Doc sync targets

These docs describe the same system from different angles and must stay consistent:
- `README.md` — what's inside, quickstart, install description
- `CLAUDE.md` — project-level instructions for Claude (skills, rules, doc structure)
- `claude/CLAUDE.md` — personal/global Claude instructions (skill list, rule paths)
- `docs/guide.md` — terminal, picker, shell, skill workflow loop, rules, tips
- `docs/cheatsheet.md` — quick-reference for all keybindings, commands, and CLI tools

## Dependency sync

These files must stay in sync when dependencies change:
- `README.md` — dependencies table in quickstart section
- `docs/cheatsheet.md` — install code block
- `verify.sh` — `check_cmd` calls

## Structural sync

- New directory or tool → add to `README.md` what's inside section
- New symlink → add `install_*()` in `install.sh` + check in `verify.sh`
- New bin script → add CLI entry in `docs/cheatsheet.md`
- New Claude skill → add to Claude table in `docs/cheatsheet.md` and `README.md` skills section
- New Claude command → add to Claude table in `docs/cheatsheet.md`
- New dependency → add to all three dependency sources above
- New config change that affects the guide → update `docs/guide.md` (terminal, shell, skill loop, rules sections)

## Final check

Run `./verify.sh` and confirm all checks pass.
