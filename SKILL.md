---
name: research
description: >
  Modular AI-assisted research skill with selectable modes and mandatory
  protocols. Supports exploratory, systematic, explanatory, comparative,
  investigative, synthesis, and rapid research styles. Integrates with
  mdb-projects hierarchy for structured research workflows. Use when:
  conducting literature reviews, investigating topics, comparing options,
  synthesizing knowledge, fact-checking claims, building frameworks.
  Trigger keywords: "research", "investigate", "compare", "synthesize",
  "review", "explore", "analyze", "verify", "find evidence", "systematic",
  "comprehensive", "research plan".
compatibility: >
  Requires mdb MCP server for vault integration. Outputs persist to
  Obsidian vault, not ephemeral artifacts.
metadata:
  author: wgm-thesis
  version: "1.1"
---

# Research Skill

A modular research assistant with mode-based specialization and mandatory protocols.

## ⚠️ MANDATORY BEHAVIOURS (NON-NEGOTIABLE)

### 1. Session Initialization

Before ANY research, establish through dialogue:

```
┌─────────────────────────────────────────────────────────┐
│  RESEARCH SESSION INITIALIZATION                        │
├─────────────────────────────────────────────────────────┤
│  1. Project Context: [detected/none]                    │
│     → Confirm or create research project                │
│  2. Working Directory: [from project vault_root]        │
│     → Verify write access                               │
│  3. Research Plan: [existing/none]                      │
│     → Use existing or initiate guided creation          │
│  4. Research Mode: [recommended based on signals]       │
│     → Confirm mode(s)                                   │
│  5. Constraints: [time/depth]                           │
└─────────────────────────────────────────────────────────┘
```

**Rules:**
- ALL outputs → working directory (from project definition)
- NEVER use `/home/claude` or `/mnt/user-data/outputs`
- Vault path: `/projects/[domain]/[topic]/`

### 2. Reference Documentation

**MANDATORY for key findings and attestations.**

- Format: `[Display Text](URL)` for iframe preview
- Not every claim needs citation—use judgment
- Apply source reliability: A (authoritative) → D (unreliable)

### 3. Checkpoint Protocol

**EXECUTE after each phase completes:**

1. Create checkpoint document in working directory
2. Set task status to `review` via frontmatter
3. Present summary, await user approval
4. DO NOT proceed without confirmation

### 4. Iteration Control

```
Cycles 1-3: Normal investigation
Cycle 4:    WARNING - Re-read plan, reassess scope
Cycle 5+:   CIRCUIT BREAKER - Stop, recommend refinement
```

Say `research:reset` to force fresh approach.

---

## Mode Selection

| Problem Signal | Primary Mode | Secondary |
|----------------|--------------|-----------|
| "explore", "what's out there" | `exploratory` | `synthesis` |
| "comprehensive", "systematic review" | `systematic` | — |
| "why", "mechanism", "cause" | `explanatory` | `comparative` |
| "compare", "evaluate", "options" | `comparative` | `systematic` |
| "verify", "fact-check", "find" | `investigative` | `rapid` |
| "synthesize", "framework" | `synthesis` | `exploratory` |
| "quick", "urgent", "brief" | `rapid` | — |

Declare active modes: `[Research Mode: exploratory + synthesis]`

**Full mode details:** See `references/modes/*.md`

---

## Project Integration

Research maps to mdb-projects hierarchy:

| Research Concept | Entity | Purpose |
|------------------|--------|---------|
| Research initiative | **Project** | Scope, briefing, conversation |
| Research plan | **Job** | Phases, dependencies, working dir |
| Research phase | **Task** | Checkpoint with review gate |

### Briefing Composition

```
Layer 1: Project → questions, scope, base mode, pinned docs
Layer 2: Job     → phase context, mode narrowing, search targets
Layer 3: Task    → thread instructions, checkpoint requirements
```

### Frontmatter Types

- `type: research-project` — Project-level notes
- `type: research-job` — Research plan documents
- `type: research-task` — Phase checkpoint outputs

**Full schemas:** See `references/projects/frontmatter.md`

---

## Guided Research Plan Creation

When no plan exists, guide user through:

1. **Research Questions** — Primary + secondary
2. **Scope Definition** — In/out of scope, time horizon
3. **Methodology** — Modes, search strategy, quality criteria
4. **Output Requirements** — Format, audience, citation style
5. **Phases** — Focus areas with checkpoint outputs

Save to vault with `type: research-job` frontmatter before proceeding.

**Template:** See `references/templates/research-plan.md`

---

## Output Versioning

- Increment filename: `doc.md` → `doc.1.md` → `doc.2.md`
- NEVER overwrite source files
- Include wikilink to research plan in frontmatter

---

## ⚠️ PROTOCOL REMINDER (Every 3 Interactions)

- [ ] Working directory verified?
- [ ] Key claims have sources?
- [ ] Still on scope per research plan?
- [ ] Checkpoint pending?
- [ ] Frontmatter status current?

---

## MDB Integration

| Function | Tool | Usage |
|----------|------|-------|
| Verify working dir | `mdb:get_note` | Check path exists |
| Create outputs | `mdb:create_note` | Save findings |
| Update research | `mdb:update_note` | Append/revise |
| Find related | `mdb:find` | Semantic search |
| Update status | `mdb:update_note_frontmatter` | Transitions |

---

## Loading Reference Modules

Load on-demand based on problem signals:

```
[Loading references/modes/investigative.md - Fact verification required]
```

Do NOT load speculatively. Load on first relevant signal only.
