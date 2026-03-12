---
name: bootstrap
description: Scaffold a project from rules. Use when the user wants to start a new project.
argument-hint: "<project-name> [description]"
allowed-tools: Read Write Bash
---

Scaffold a new project driven entirely by resolved rule docs.

## Config

Read `devenv.json` from `${CLAUDE_PLUGIN_ROOT}/devenv.json` (if running as a plugin) or `~/.claude/devenv.json` (fallback). Key: `work.dir` (default `.work`).

## Resolve rules

Run `/resolve-rules mode:all scope:bootstrap` to resolve every rule that applies at bootstrap time. Read all resolved docs.

If `/resolve-rules` is unavailable, warn the user: "Rule resolution skill not found — rules will not be applied." Then stop.

If no rules are resolved, stop: "No rules found. Add at least a `stack.md` to your rules directory, or install a rule pack from [devloop-rules](https://github.com/minusblindfold/devloop-rules). See `rules/rules.md` in the devloop plugin for the format."

Look for a **Stack** rule (matched by H1 title or `stack` keyword). If no stack rule is found, stop: "No stack rule found. Bootstrap needs a stack rule to know what kind of project to generate."

## Gather inputs

1. Parse `$ARGUMENTS` for the project name (first word) and optional description (rest). If no project name, ask.
2. From the stack rule, identify the technology stack and present a summary to the user.
3. Ask for any missing inputs. Wait for answers before generating. Only ask what the resolved rules make relevant:
   - **Description**: one sentence — what the app does and why. (Skip if provided in arguments.)
   - If security rules are present and define a role model, ask for **domain role name(s)**.
   - If the stack rule uses packages or modules, ask for the **root namespace/group**.
4. Confirm inputs with the user before generating.

## Generate project

Create all files in the **current working directory**. The directory should be empty or near-empty. If not empty, warn the user and ask to confirm.

### Skeleton

Read the stack rule fully. Generate the project skeleton it describes: build file, settings, config files, main entry point, wrapper, gitignore, and test config. Derive names (database name, package name, artifact name) from the project name.

### Rule contributions

Work through each remaining resolved rule that has a `## Bootstrap` section. Process them in natural dependency order: infrastructure → data layer → security → business logic → UI.

For each rule:
1. Read the full rule doc (patterns, examples, and bootstrap section).
2. Generate the files its bootstrap section describes, following the rule's patterns and examples exactly.
3. If a rule references another rule's output (e.g., templates reference security roles), ensure the dependency was generated first.

Skip rules that have no `## Bootstrap` section — they apply during feature work, not scaffolding.

### Project documentation

Generate a `CLAUDE.md` tailored to the project. Derive everything from what was actually generated:
- Project overview (name, description, tech stack from stack rule).
- Common commands (build, run, test — from stack rule's startup section).
- Architecture overview (layers, security config, database, frontend — from the rules that were applied).

## Write bootstrap context marker

Create `<work.dir>/bootstrap.md` in the project directory. Assemble it dynamically from what was resolved and generated:

```markdown
# Bootstrap Context

## Tech Stack
- <derived from stack rule>

## Roles
- <from user input, if applicable>

## Scaffolded Entities
- <list what was generated>

## What's Ready
- <list capabilities the scaffold provides>

## Rules Applied
- <list each rule title and its source layer>
```

This marker is read by `/plan` and `/design` to skip redundant questions about established architecture.

## Wrap up

1. Print a summary of what was generated (file count by category).
2. Suggest next steps derived from the stack rule's startup section:
   - How to start the app.
   - Default credentials if seed users were generated.
   - Commit the initial scaffold.
   - Run `/plan` to start building features.

## Rules

- Never generate features beyond the minimal scaffold — that's what `/plan` → `/design` → `/implement` is for.
- Follow rule docs exactly. If a pattern isn't covered by a rule doc, keep it simple and consistent with the rules that do exist.
- No hardcoded version numbers in generated code. Use latest stable versions at generation time.
- The bootstrap context marker goes in the project's `<work.dir>/`, not in devenv.
- Never hardcode technology choices in this skill. Every file generated must trace back to a resolved rule.
- If no rules are resolved, do not guess a stack. Stop and tell the user.
