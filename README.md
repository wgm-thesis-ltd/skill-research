# skill-research

A modular research skill for AI-assisted investigation, synthesis, and analysis tasks.

## What It Does

This skill teaches Claude systematic research workflows with:

* **Mode-based specialization** — 7 research modes for different problem types
* **Mandatory protocols** — Working directory, checkpointing, reference management
* **Iteration control** — Circuit breaker prevents endless research loops
* **Project integration** — Maps to mdb-projects hierarchy (Project → Job → Task)
* **Backend abstraction** — Works with mdb vault or local storage with graceful degradation
* **Offline workflow** — Export/import cycle for disconnected work

### Research Modes

| Mode | When to Use | Output Type |
|------|-------------|-------------|
| `exploratory` | Unknown territory, early investigation | Landscape maps |
| `systematic` | Exhaustive coverage, evidence synthesis | Complete evidence base |
| `explanatory` | Understanding why, causal mechanisms | Mechanism models |
| `comparative` | Choosing between options, trade-offs | Decision matrices |
| `investigative` | Establishing facts, verification | Verified claims |
| `synthesis` | Integrating knowledge, frameworks | Integrated models |
| `rapid` | Time pressure, quick answers | Quick summaries |

## Backends

The skill abstracts document operations through a backoffice interface, with two backend implementations:

| Backend | When Used | Capabilities |
|---------|-----------|--------------|
| **MDB** (primary) | mdb MCP server available | Full vault integration, semantic search, wikilinks, real-time persistence |
| **Local** (fallback) | No mdb available | Session storage, pattern search only, manual export required |

The skill detects the available backend automatically at session start and displays:
```
[Research Skill: MDB backend active]
```
or
```
[Research Skill: Local backend active]
Note: Documents are session-local. Download outputs to persist.
```

### Capability Comparison

| Capability | MDB | Local |
|------------|-----|-------|
| Semantic search | ✓ | ✗ (pattern only) |
| Project hierarchy | ✓ | ○ (structure only) |
| Wikilink resolution | ✓ | ✗ (text only) |
| Real-time persistence | ✓ | ✗ (export required) |
| Frontmatter validation | ✓ | ○ (format only) |

## Prerequisites

### With MDB (Recommended)

For full functionality, use the mdb MCP server for Obsidian vault integration:

```bash
# Verify mdb is available
claude mcp list | grep mdb
```

### Without MDB

The skill works without mdb using local storage. Limitations:
- No semantic search (pattern matching only)
- Documents are session-local (must export to persist)
- Wikilinks stored as text (not resolved)
- References developed through web search, uploads, and conversation

## Installation

### Claude Code

```bash
# Clone the repository
git clone https://github.com/wgm-thesis-ltd/skill-research.git

# Install the skill
claude skill install ./skill-research/
```

### Claude.ai (Web/Desktop/Mobile)

1. Go to **Settings → Capabilities → Skills**
2. Click **Upload skill**
3. Upload the `skill-research.skill` file (or ZIP the folder)
4. Toggle the skill **On**

## Usage

The skill activates automatically when you mention research-related terms:

```
"Research the history of vortex dynamics"
"Compare these three frameworks"
"Investigate why this pattern emerges"
"Synthesize the literature on quantum coherence"
```

### Explicit Invocation

```
"Use skill-research with systematic and comparative modes"
"Use skill-research to create a research plan"
```

### Commands

| Command | Action |
|---------|--------|
| `research:reset` | Force fresh approach, reset iteration counter |
| "Export for offline work" | Package project for disconnected work |
| "Continue offline research" + upload | Resume from export package |
| "Package changes for sync" | Create import bundle for mdb merge |

## Offline Workflow

For users with mdb who need disconnected work:

```
1. EXPORT    → "Export for offline work"
             → Download ZIP package

2. WORK      → Upload package in new session
             → Local backend activates
             → Changes tracked in frontmatter

3. PACKAGE   → "Package changes for sync"
             → Download import bundle

4. MERGE     → Upload to mdb environment
             → Merge process (separate)
```

The skill tracks changes via frontmatter fields (`_local_mode`, `_sync_status`) for clean re-import.

## File Structure

```
skill-research/
├── SKILL.md                    # Core instructions (~280 lines)
├── README.md                   # This file
├── commands/
│   └── research-init.md        # Slash command for setup
├── scripts/
│   └── validate-setup.sh       # Environment verification
└── references/
    ├── backoffice/
    │   ├── interface.md        # Abstract operations
    │   ├── mdb-backend.md      # MDB implementation
    │   ├── local-backend.md    # Local implementation
    │   └── offline-sync.md     # Export/import workflow
    ├── modes/
    │   ├── exploratory.md      # Divergent research patterns
    │   ├── systematic.md       # PRISMA-style methodology
    │   ├── explanatory.md      # Causal/mechanism research
    │   ├── comparative.md      # Comparison frameworks
    │   ├── investigative.md    # OSINT/fact-finding
    │   ├── synthesis.md        # Integration patterns
    │   └── rapid.md            # Time-constrained research
    ├── protocols/
    │   ├── checkpoint.md       # Checkpoint details
    │   ├── referencing.md      # Citation management
    │   └── versioning.md       # Versioning rules
    ├── projects/
    │   ├── hierarchy.md        # Project → Job → Task mapping
    │   ├── frontmatter.md      # Status schemas
    │   └── briefing.md         # Composition algorithm
    └── templates/
        ├── research-plan.md    # Plan template
        ├── research-project.md # Project template
        ├── phase-checkpoint.md # Checkpoint template
        └── final-synthesis.md  # Report template
```

### Context Efficiency

| Component | Tokens | When Loaded |
|-----------|--------|-------------|
| SKILL.md | ~600 | Always on activation |
| Mode references | ~300-500 | On-demand per mode |
| Backoffice references | ~300-400 | On backend detection |
| Protocol references | ~200-300 | On-demand |
| Templates | 0 | Used, not read |

Typical session: ~1200-1800 tokens (core + backend + 1-2 modes)

## Workflow Overview

### 1. Backend Detection

Before initialization, the skill detects available backend:
- Check for mdb MCP server → MDB backend
- No mdb → Local backend
- Uploaded export package → Offline continuation mode

### 2. Session Initialization

Before any research, the skill establishes:
- Backend status and capabilities
- Project context (existing or new)
- Working directory (vault path or local workspace)
- Research plan (existing or guided creation)
- Active research modes
- Session constraints (time, depth)

### 3. Research Execution

- Modes loaded on-demand based on signals
- References documented for key findings
- Iteration counter tracks search cycles
- Circuit breaker at 5 cycles
- Backoffice operations inject behavioral reminders

### 4. Checkpointing

After each phase:
- Checkpoint document created in working directory
- Task status set to `review` via frontmatter
- Summary presented to user
- Explicit approval required before continuing
- (Local backend) Files presented for download

### 5. Output Management

- All outputs to working directory
- Filename versioning: `doc.md` → `doc.1.md`
- Links back to research plan
- Never overwrite source files

## Project Integration

Research activities map to mdb-projects hierarchy:

```
Project: "Vortex Dynamics Literature Review"
├── Job: "Phase 1 - Foundational Papers"
│   ├── Task: "Survey pre-2000 literature"
│   └── Task: "Phase 1 Checkpoint"
├── Job: "Phase 2 - Modern Developments"
│   └── Task: "Phase 2 Checkpoint"
└── Job: "Final Synthesis"
    └── Task: "Integration Report"
```

When using Local backend, this structure is maintained in frontmatter for later import to mdb.

## License

Apache-2.0

## Related

- [mdb-projects specification](https://github.com/wgm-thesis-ltd/mdbrain) — Project hierarchy reference
- [skill-web-debug](https://github.com/wgm-thesis-ltd/skill-web-debug) — Similar modular skill pattern
