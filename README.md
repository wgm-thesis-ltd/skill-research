# skill-research

A modular research skill for AI-assisted investigation, synthesis, and analysis tasks.

## What It Does

This skill teaches Claude systematic research workflows with:

* **Mode-based specialization** — 7 research modes for different problem types
* **Mandatory protocols** — Working directory, checkpointing, reference management
* **Iteration control** — Circuit breaker prevents endless research loops
* **Project integration** — Maps to mdb-projects hierarchy (Project → Job → Task)
* **Vault persistence** — All outputs saved to Obsidian vault, not ephemeral artifacts

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

## Prerequisites

### MDB MCP Server

This skill requires the mdb MCP server for Obsidian vault integration:

```bash
# Verify mdb is available
claude mcp list | grep mdb
```

The skill uses mdb tools for:
- Creating and updating research outputs
- Semantic search across vault
- Frontmatter status management
- Working directory validation

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

### Manual Commands

- **Reset session:** Say `research:reset` to force fresh approach
- **Load mode:** "Load the investigative module"

## File Structure

```
skill-research/
├── SKILL.md                    # Core instructions (< 500 lines)
├── README.md                   # This file
├── commands/
│   └── research-init.md        # Slash command for setup
├── scripts/
│   └── validate-setup.sh       # Environment verification
└── references/
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
    │   └── versioning.md       # MDB versioning rules
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
| SKILL.md | ~500 | Always on activation |
| Mode references | ~300-500 | On-demand |
| Protocol references | ~200-300 | On-demand |
| Templates | 0 | Used, not read |

Typical session: ~1000-1500 tokens (core + 1-2 modules)

## Workflow Overview

### 1. Session Initialization

Before any research, the skill establishes:
- Project context (existing or new)
- Working directory (from project definition)
- Research plan (existing or guided creation)
- Active research modes
- Session constraints (time, depth)

### 2. Research Execution

- Modes loaded on-demand based on signals
- References documented for key findings
- Iteration counter tracks search cycles
- Circuit breaker at 5 cycles

### 3. Checkpointing

After each phase:
- Checkpoint document created in working directory
- Task status set to `review`
- Summary presented to user
- Explicit approval required before continuing

### 4. Output Management

- All outputs to vault working directory
- Filename versioning: `doc.md` → `doc.1.md`
- Wikilinks back to research plan
- Never overwrite source files

## Project Integration

Research activities map to mdb-projects:

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

## License

Apache-2.0

## Related

- [mdb-projects specification](../mdbrain/specs/mdb-projects-specification.md)
- [skill-web-debug](https://github.com/wgm-thesis-ltd/skill-web-debug) — Similar modular skill pattern
