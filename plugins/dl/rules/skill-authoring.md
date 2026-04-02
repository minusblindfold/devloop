---
keywords: [skill, skills, SKILL.md, instruction, prompt, workflow, plugin]
scope: always
---
# Skill Authoring Rules

> Principles for writing and modifying devloop skill files, derived from the QRISPY analysis.

## Instruction budget

- Each skill file must stay under 40 imperative instructions. Models follow ~150-200 instructions consistently across an entire session; skills share that budget with CLAUDE.md, system prompt, tools, and MCP overhead.
- Count actual imperative sentences, not lines. A template in a code block counts as 1 instruction total, not per-heading.
- If a skill is over budget, cut structural and template instructions first. Never cut behavioral instructions — these are the ones that affect output quality (collaborative exploration, two-pass review, task isolation, deviation tracking).

## Compression patterns

When reducing instruction count, apply these in order of ROI:

1. **Merge create/re-entry checklists** — One checklist with conditional branches ("If re-entry: read existing artifact. If new: gather context.") replaces two separate checklists. Saves 4-8 instructions.
2. **Consolidate gate instructions** — Multi-step gates ("verify artifact exists; write if missing; update marker stage; update marker date") become a single compound instruction.
3. **Simplify artifact templates** — Strip field descriptions from templates. Section headings alone are sufficient — models know what `## Decisions` means.

## Structural vs behavioral

- **Behavioral instructions** affect output quality. Examples: how brainstorm explores ideas, how review separates concerns into two passes, how implement tracks deviations. Preserve these.
- **Structural instructions** are checklists, gates, markers, wrap-ups. These are the primary cut target when a skill is over budget.
- **Template instructions** are artifact format specs. Secondary cut target — headings alone carry meaning.

## Artifact chaining

- Each skill produces a markdown artifact that becomes the next skill's input. This is the core reliability mechanism — static artifacts survive context compaction.
- Never break the chain: brainstorm -> research -> plan -> design -> implement -> review.
- Hard dependencies must be enforced with gate checks (e.g., implement refuses to start without a design file).

## Vertical slicing

- Plan tasks must be vertically sliced — each task delivers a testable end-to-end slice through the stack, not a horizontal layer.
- Prohibit standalone "create all models" or "set up database schema" tasks. Each task should touch all relevant layers.
- Each task should include a test expectation, not a separate "add tests" task at the end.

## Separation of concerns

- Research produces facts, not opinions. When research knows what's being built, it injects implementation opinions into what should be objective findings.
- Brainstorm owns decisions. Research queries come from brainstorm to keep research targeted.
- Design is the primary review checkpoint. Plan gets a spot-check; design gets full review before implementation.

## Review gates

- Use distinct language for different gate strengths. "Spot-check" for plan (lightweight). "Primary checkpoint — must be reviewed before implementation" for design (heavyweight).
- Don't use identical wording for gates of different importance — it flattens them to equal weight.
