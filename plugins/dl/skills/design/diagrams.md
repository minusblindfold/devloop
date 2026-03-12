# Diagrams reference for /design

Diagrams exist to give a reader an at-a-glance feel for the implementation plan — what exists, how it connects, and how it moves. Only include diagrams that add clarity; omit them for trivial tasks.

## Format rules

- Mermaid `.mmd` files only.
- Use `graph TD` or `sequenceDiagram` only.
- One diagram per file. Name must share the design file's prefix: `YYYY-MM-DD-<feature-slug>-<type>.mmd`, where `YYYY-MM-DD-<feature-slug>` is the design filename with `-design.md` stripped. Example: design `2026-03-04-my-feature-design.md` → diagram `2026-03-04-my-feature-arch.mmd`.
- List in the doc under `## Diagrams`; do not embed code inline.

## Diagram types

### High-level architecture (`graph TD`)

Shows the major components of the system and how they relate. Use when the feature introduces or significantly changes system structure.

```
graph TD
    Client --> API
    API --> Service
    Service --> DB
```

### Data flow (`graph TD`)

Shows how data moves through the system — inputs, transformations, outputs, and storage. Use when data shape or routing is central to the design.

```
graph TD
    Input --> Validate
    Validate --> Transform
    Transform --> Store
    Transform --> Respond
```

### Component design (`graph TD`)

Shows the internal structure of a specific module or service — subcomponents, responsibilities, and boundaries. Use when a single component is complex enough to warrant its own breakdown.

```
graph TD
    subgraph Processor
        Parser --> Validator
        Validator --> Executor
    end
```

### Sequence / interaction (`sequenceDiagram`)

Shows step-by-step interactions between actors or services over time. Use when timing, ordering, or multi-party coordination matters.

```
sequenceDiagram
    Client->>API: request
    API->>Service: process
    Service-->>API: result
    API-->>Client: response
```

## Choosing diagrams

Pick the types that best illuminate the tasks in the plan. A feature can warrant more than one — for example, an architecture diagram plus a sequence diagram if both the structure and the interaction flow are non-obvious. Don't create a diagram just to have one.
