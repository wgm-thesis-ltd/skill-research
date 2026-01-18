---
name: research
description: >
  Modular AI-assisted research skill with selectable modes and mandatory
  protocols. Supports exploratory, systematic, explanatory, comparative,
  investigative, synthesis, and rapid research styles. Integrates with
  mdb-projects hierarchy when available; falls back to local storage with
  manual sync workflow when mdb unavailable. Use when: conducting literature
  reviews, investigating topics, comparing options, synthesizing knowledge,
  fact-checking claims, building frameworks.
  Trigger keywords: "research", "investigate", "compare", "synthesize",
  "review", "explore", "analyze", "verify", "find evidence", "systematic",
  "comprehensive", "research plan".
compatibility: >
  Works with or without mdb MCP server. Primary: mdb for full vault
  integration. Fallback: local storage with export/import sync workflow.
  Document operations abstracted through backoffice interface.
metadata:
  author: wgm-thesis
  version: "1.2"
---

# Research Skill

A modular research assistant with mode-based specialization and mandatory protocols.

## ⚠️ MANDATORY BEHAVIOURS (NON-NEGOTIABLE)

### 0. Backend Detection

Before session initialization, detect available backend:

```
┌─────────────────────────────────────────────────────────┐
│  BACKEND DETECTION                                      │
├─────────────────────────────────────────────────────────┤
│  Check: mdb MCP server available?                       │
│  ├─→ YES: Backend = MDB (full integration)              │
│  │        Working dir = vault path                      │
│  │                                                      │
│  └─→ NO:  Backend = Local (session storage)             │
│           Working dir = /home/claude/research-workspace │
│           ⚠ Semantic search unavailable                 │
│           ⚠ Manual export required for persistence      │
│                                                         │
│  Check: Offline export package uploaded?                │
│  └─→ YES: Load manifest, continue from export           │
└─────────────────────────────────────────────────────────┘
```

Display backend status: `[Research Skill: {MDB|Local} backend active]`

**Backend details:** See `references/backoffice/*.md`

### 1. Session Initialization

Before ANY research, establish through dialogue:

```
┌─────────────────────────────────────────────────────────┐
│  RESEARCH SESSION INITIALIZATION                        │
├─────────────────────────────────────────────────────────┤
│  0. Backend: [MDB/Local] — [capabilities summary]       │
│  1. Project Context: [detected/none]                    │
│     → Confirm or create research project                │
│  2. Working Directory: [from backend]                   │
│     → Verify write access                               │
│  3. Research Plan: [existing/none]                      │
│     → Use existing or initiate guided creation          │
│  4. Research Mode: [recommended based on signals]       │
│     → Confirm mode(s)                                   │
│  5. Constraints: [time/depth]                           │
└─────────────────────────────────────────────────────────┘
```

**Working Directory Rules:**

| Backend | Working Directory | Persistence |
|---------|-------------------|-------------|
| MDB | `projects/[domain]/[topic]/` | Real-time to vault |
| Local | `/home/claude/research-workspace/[project]/` | Export required |

- ALL outputs → working directory
- Local backend: present files for download at checkpoints

### 2. Reference Documentation

**MANDATORY for key findings and attestations.**

- Format: `[Display Text](URL)` for iframe preview
- Not every claim needs citation—use judgment
- Apply source reliability: A (authoritative) → D (unreliable)

**Reference Development by Backend:**

| Backend | Primary Sources |
|---------|-----------------|
| MDB | Vault documents, web search, uploads |
| Local | Web search, user prompts, uploads, conversation context |

Local mode: Capture references in standard format for later vault import.

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

- [ ] Backend status confirmed?
- [ ] Working directory verified?
- [ ] Key claims have sources?
- [ ] Still on scope per research plan?
- [ ] Checkpoint pending?
- [ ] Frontmatter status current?
- [ ] (Local) Export needed for persistence?

---

## Backoffice Integration

Document operations are abstracted through the backoffice interface.
Backend implementation provides concrete behavior.

### Abstract Operations

| Operation | Purpose | Reminder |
|-----------|---------|----------|
| `create_document` | Create with frontmatter | Verify path, type, status |
| `get_document` | Retrieve content + frontmatter | May be stale if offline |
| `update_document` | Modify content | Consider versioning first |
| `update_frontmatter` | Change status fields | Valid transitions only |
| `find_documents` | Search by query/type/status | Local: pattern only |
| `version_document` | Create versioned copy | doc.md → doc.1.md |

### Backend Implementations

**MDB Backend:**
```
create_document  → mdb:create_note
get_document     → mdb:get_note
update_document  → mdb:update_note
find_documents   → mdb:find (semantic search)
```

**Local Backend:**
```
create_document  → create_file (manual YAML)
get_document     → view (parse frontmatter)
update_document  → str_replace / create_file
find_documents   → bash grep/find (patterns only)
```

### Behavioral Reminders

Backoffice operations inject protocol reminders:

```
[Backoffice: create_document]
Reminder: Verify path within working directory, 
          frontmatter includes type and status.
Proceeding...
```

**Full interface:** See `references/backoffice/interface.md`

---

## Offline Sync Workflow

For users with mdb who need disconnected work:

```
1. EXPORT    → Package project for local work
2. WORK      → Local backend, changes tracked
3. PACKAGE   → Create import bundle with changes
4. MERGE     → Re-import to mdb (separate process)
```

**Commands:**
- "Export for offline work" → Create download package
- "Continue offline research" + upload → Resume from export
- "Package changes for sync" → Create import bundle

**Full workflow:** See `references/backoffice/offline-sync.md`

---

## Loading Reference Modules

Load on-demand based on problem signals:

```
[Loading references/modes/investigative.md - Fact verification required]
```

Do NOT load speculatively. Load on first relevant signal only.
