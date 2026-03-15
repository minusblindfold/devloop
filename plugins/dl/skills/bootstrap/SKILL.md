---
name: bootstrap
description: Scaffolds a new project from resolved rule docs, generating skeleton code, configuration, and a bootstrap context marker. Use when starting a new project or scaffolding from rules.
argument-hint: "<project-name> [description]"
allowed-tools: Read Write Bash
---

Execute each section below in order. Do not skip sections.

1. Determine your mode.
2. Copy the **Task Progress** checklist from that mode's section into your response.
3. Work through each item. Check it off as you complete it.
4. Do not proceed past a **Gate** until the gate condition is verified.

## Config

All artifacts are stored under `.work/` in the current project directory.

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

Run `/resolve-rules mode:all scope:bootstrap` to resolve every rule that applies at bootstrap time. Read all resolved docs.

If `/resolve-rules` is unavailable, print: "Rule resolution unavailable — cannot bootstrap without rules." Then stop.

If no rules are resolved, stop: "No rules found. Add at least a `stack.md` to your rules directory, or install a rule pack from [devloop-rules](https://github.com/minusblindfold/devloop-rules). See `rules/rules.md` in the devloop plugin for the format."

Look for a **Stack** rule (matched by H1 title or `stack` keyword). If no stack rule is found, stop: "No stack rule found. Bootstrap needs a stack rule to know what kind of project to generate."

List all resolved rules in your response and identify which one is the stack rule before proceeding to gather inputs.

### Gather inputs

1. Parse `$ARGUMENTS` for the project name (first word) and optional description (rest). If no project name, ask.
2. From the stack rule, identify the technology stack and present a summary to the user.
3. Ask for any missing inputs. Wait for answers before generating. Only ask what the resolved rules make relevant:
   - **Description**: one sentence — what the app does and why. (Skip if provided in arguments.)
   - If security rules are present and define a role model, ask for **domain role name(s)**.
   - If the stack rule uses packages or modules, ask for the **root namespace/group**.
4. Confirm inputs with the user before generating.

### Generate project

Create all files in the **current working directory**. The directory should be empty or near-empty. If not empty, warn the user and ask to confirm.

#### Skeleton

Read the stack rule fully. Generate the project skeleton it describes: build file, settings, config files, main entry point, wrapper, gitignore, and test config. Derive names (database name, package name, artifact name) from the project name.

#### Rule contributions

Work through each remaining resolved rule that has a `## Bootstrap` section. Process them in natural dependency order: infrastructure → data layer → security → business logic → UI.

For each rule:
1. Read the full rule doc (patterns, examples, and bootstrap section).
2. Generate the files its bootstrap section describes, following the rule's patterns and examples exactly.
3. If a rule references another rule's output (e.g., templates reference security roles), ensure the dependency was generated first.

Skip rules that have no `## Bootstrap` section — they apply during feature work, not scaffolding.

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

Run `ls` on `.work/bootstrap.md`. If the file does not exist, write it now. Do not proceed until the file is confirmed on disk.

### Wrap up

1. Print a summary of what was generated (file count by category).
2. Suggest next steps derived from the stack rule's startup section:
   - How to start the app.
   - Default credentials if seed users were generated.
   - Commit the initial scaffold.
   - Run `/plan` to start building features.

## Rules

- Generate only the scaffold. Feature code belongs in /plan → /design → /implement.
- Follow rule docs exactly. If a pattern isn't covered by a rule doc, keep it simple and consistent with the rules that do exist.
- Do not hardcode version numbers in generated code. Use latest stable versions at generation time.
- The bootstrap context marker goes in the project's `.work/`, not in devenv.
- Do not hardcode technology choices in this skill. Every file generated must trace back to a resolved rule.
- If no rules are resolved, do not guess a stack. Stop and tell the user.
