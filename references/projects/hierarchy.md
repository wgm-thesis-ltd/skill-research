# Project Hierarchy Integration

How research activities map to the mdb-projects structure.

## Conceptual Mapping

| Research Concept | mdb-projects Entity | Purpose |
|------------------|---------------------|---------|
| Research initiative | **Project** | Overall scope, briefing, working directory |
| Research plan | **Job** | Phases, methodology, dependencies |
| Research phase | **Task** | Individual checkpoint with review gate |

## Visual Hierarchy

```
Project: "Literature Review on Quantum Coherence"
│
├── briefing.md (project-level context)
├── working_root: projects/research/quantum-coherence/
│
├── Job: "Phase 1 - Foundational Papers"
│   ├── research-plan-foundations.md
│   ├── Task: "Survey 1990-2000 literature"
│   │   └── checkpoint-foundations-survey.md
│   └── Task: "Identify key frameworks"
│       └── checkpoint-frameworks.md
│
├── Job: "Phase 2 - Modern Developments"
│   ├── research-plan-modern.md
│   └── Task: "Review 2020-2025 papers"
│       └── checkpoint-modern-review.md
│
└── Job: "Final Synthesis"
    ├── research-plan-synthesis.md
    └── Task: "Integration report"
        └── final-synthesis.md
```

## Project Level

**Purpose:** Define overall research initiative scope

**Contains:**
- Research questions (primary + secondary)
- Scope boundaries (in/out)
- Base research mode
- Working directory (vault_root)
- Pinned reference documents
- Stakeholder context

**Frontmatter type:** `research-project`

**Example:**
```yaml
type: research-project
title: "Quantum Coherence Literature Review"
vault_root: projects/research/quantum-coherence
questions:
  primary: "What mechanisms maintain quantum coherence in biological systems?"
  secondary:
    - "What timescales are involved?"
    - "What experimental evidence exists?"
scope:
  in_scope:
    - Photosynthesis coherence
    - Avian navigation
  out_of_scope:
    - Quantum computing applications
base_mode: systematic
```

## Job Level

**Purpose:** Define a research plan with phases

**Contains:**
- Phase definitions
- Methodology specification
- Mode narrowing for this job
- Search strategy
- Dependencies on other jobs
- Output requirements

**Frontmatter type:** `research-job`

**Example:**
```yaml
type: research-job
title: "Research Plan: Foundational Papers"
project: "[[quantum-coherence-project]]"
status: in_progress
mode: systematic
phases:
  - name: "Literature survey"
    status: completed
  - name: "Framework identification"
    status: in_progress
  - name: "Gap analysis"
    status: pending
```

## Task Level

**Purpose:** Individual research phase with checkpoint

**Contains:**
- Phase-specific instructions
- Checkpoint output
- Status for review gate
- Iteration count
- Findings and sources

**Frontmatter type:** `research-task`

**Example:**
```yaml
type: research-task
title: "Phase 1 Checkpoint: Literature Survey"
job: "[[research-plan-foundations]]"
status: review
iteration_count: 3
```

## Status Flow

```
Project: active
    │
    ├── Job: in_progress
    │   ├── Task: completed ✓
    │   ├── Task: review ← awaiting approval
    │   └── Task: pending
    │
    └── Job: pending (depends on above)
```

## Working Directory Rules

1. Project defines `vault_root`
2. All jobs inherit this root
3. All tasks output to this root
4. Subdirectories allowed: `vault_root/phase1/`, `vault_root/figures/`

**NEVER output to:**
- `/home/claude/`
- `/mnt/user-data/outputs/`
- Outside the project's vault_root

## Navigation

### Finding Project Context
```
mdb:find query="type:research-project [topic keywords]"
```

### Finding Jobs for Project
```
mdb:find query="type:research-job project:[[project-name]]"
```

### Finding Tasks for Job
```
mdb:find query="type:research-task job:[[job-name]]"
```

## Cross-References

Research outputs link back to their hierarchy:

```markdown
---
type: research-task
job: "[[research-plan-foundations]]"
project: "[[quantum-coherence-project]]"
---

# Checkpoint: Literature Survey

This checkpoint is part of [[research-plan-foundations]], 
within the [[quantum-coherence-project]].
```

## Integration Benefits

1. **Recovery:** Can resume interrupted research by loading project context
2. **Audit trail:** Full history of research phases and decisions
3. **Scope control:** Project boundaries prevent drift
4. **Collaboration:** Clear handoff points at checkpoints
5. **Reuse:** Research plans can template future work
