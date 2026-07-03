# Hooks example: checkable conventions

Prose rules ask the model to follow a convention; hooks *enforce* it. Instructions can get dropped under context pressure — hooks always run. Anything a command can check (lint, typecheck, tests) belongs here, not in a rule file. See the "Rules vs hooks" section in [docs/rules.md](../../docs/rules.md).

## The template

[`settings.json.example`](settings.json.example) runs a check after every file edit. Merge it into your project's `.claude/settings.json` and replace `your-check-command`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "sh -c 'out=$(your-check-command 2>&1) || { echo \"$out\" >&2; exit 2; }'"
          }
        ]
      }
    ]
  }
}
```

What each part does:

- **`PostToolUse`** — fires after a tool call succeeds. Use `PreToolUse` instead to check *before* a change lands.
- **`matcher`** — regex over tool names; `Edit|Write` means "after any file edit or write." Leave it out to fire on every tool.
- **`command`** — the wrapper captures the check's output, stays **silent on success** (exit 0, no output), and on failure prints the output to stderr and exits **2**.

## Why silent-on-success matters

The exit-code contract: exit `0` = pass (output not shown to the model), exit `2` = blocking failure (stderr is fed back to the model so it can fix the problem). Surfacing only failures is deliberate — success messages after every edit crowd the context window with noise ("context-efficient backpressure"). The model hears from the hook only when something needs fixing.

## Adapting it

Replace `your-check-command` with your project's check, e.g. `npm run lint --silent`, `tsc --noEmit`, `cargo check`, or a script that runs only the checks relevant to the changed file (the hook receives JSON on stdin with the tool input, including the file path — see the [hooks documentation](https://docs.claude.com/en/docs/claude-code/hooks) for the payload schema). Keep the check fast: it runs after every edit.
