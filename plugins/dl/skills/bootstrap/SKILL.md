---
name: bootstrap
description: Scaffolds a new project from resolved rule docs, generating skeleton code, configuration, and a bootstrap context marker. Use when starting a new project or scaffolding from rules.
argument-hint: "<project-name> [description]"
allowed-tools: Read Write Bash
---

Execute each section in order. Copy the checklist and check off items as you complete them. Do not proceed past a **Gate** until verified.

## Bootstrap mode

**Constraint:** You MUST generate only the scaffold. Feature code belongs in /plan → /design → /implement.

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Run /resolve-rules mode:all scope:bootstrap
- [ ] Verify stack rule exists
- [ ] List resolved rules and stack rule in response
- [ ] Parse arguments for project name and description
- [ ] Ask for missing inputs
- [ ] Confirm inputs with user
- [ ] Generate project skeleton from stack rule
- [ ] Apply rule contributions in dependency order
- [ ] Generate CLAUDE.md
- [ ] Write .work/bootstrap.md context marker
- [ ] Gate: verify bootstrap.md with ls
- [ ] Wrap up: summarize generated files, suggest next steps
```

### Resolve rules

Run `/resolve-rules mode:all scope:bootstrap` as a subtask. Read all resolved docs. Stop if: unavailable, no rules resolved, or no stack rule found (matched by H1 title or `stack` keyword). List resolved rules and identify the stack rule before proceeding.

### Gather inputs

1. Parse `$ARGUMENTS` for project name (first word) and optional description (rest). Ask if missing.
2. Present stack summary from the stack rule.
3. Ask for missing inputs: description (if not in args), role names (if security rules define roles), namespace (if stack uses packages). Wait for answers.
4. Confirm inputs with the user before generating.

### Generate project

Create all files in the **current working directory**. The directory should be empty or near-empty. If not empty, warn the user and ask to confirm.

#### Skeleton

Read the stack rule fully. Generate the project skeleton it describes: build file, settings, config files, main entry point, wrapper, gitignore, and test config. Derive names (database name, package name, artifact name) from the project name.

#### Rule contributions

For each remaining rule with a `## Bootstrap` section, process in dependency order (infrastructure → data → security → business → UI): read the full doc, generate files per its patterns and examples, respect cross-rule dependencies. Skip rules without a `## Bootstrap` section.

#### Project documentation

Generate a `CLAUDE.md` tailored to the project. Derive everything from what was actually generated:
- Project overview (name, description, tech stack from stack rule).
- Common commands (build, run, test — from stack rule's startup section).
- Architecture overview (layers, security config, database, frontend — from the rules that were applied).

### Write bootstrap context marker

Create `.work/bootstrap.md` in the project directory. Assemble it dynamically from what was resolved and generated:

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

### Gate

Run `ls` on `.work/bootstrap.md`. If missing, write it now.

### Wrap up

1. Summarize what was generated (file count by category).
2. Suggest next steps: how to start the app, default credentials (if applicable), commit the scaffold, run `/plan`.

## Rules

- Generate only the scaffold. Feature code belongs in /plan → /design → /implement.
- Follow rule docs exactly. If a pattern isn't covered by a rule doc, keep it simple and consistent with the rules that do exist.
- Do not hardcode version numbers in generated code. Use latest stable versions at generation time.
- The bootstrap context marker goes in the project's `.work/`, not in devenv.
- Do not hardcode technology choices in this skill. Every file generated must trace back to a resolved rule.
- If no rules are resolved, do not guess a stack. Stop and tell the user.
