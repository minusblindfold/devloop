# Rule packs

Ready-made rule sets for devloop. A pack is just a directory of `.md` rule files — installing one is a copy:

```bash
cp examples/rule-packs/spring-boot-web/*.md yourproject/devloop/rules/
```

Skills discover the rules automatically and apply them by keyword match — a task about services pulls in `service.md`, not `testing.md`. Edit the copied files freely; they're yours now. The rule format is documented in [docs/rules.md](../../docs/rules.md).

## Available packs

| Pack | Description |
|------|-------------|
| `spring-boot-web` | Spring Boot + Thymeleaf + PostgreSQL web app patterns: controllers, services, repositories, security, templates, and testing. |
| `_template` | Skeleton for writing your own pack. Start with `stack.md`, add one file per concern. |

## Writing your own

Copy `_template/`, rename it, and follow its README. Keep prose rules for patterns and judgment; put anything a command can check (lint, typecheck, tests) in a hook instead — see [examples/hooks/](../hooks/).
