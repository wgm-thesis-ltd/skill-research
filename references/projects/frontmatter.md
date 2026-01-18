# Frontmatter Status Schemas

YAML frontmatter schemas for research project, job, and task notes.

## Research Project Frontmatter

```yaml
---
# Required
type: research-project
title: "Human-readable project title"
vault_root: "projects/[domain]/[topic]"

# Research Definition
questions:
  primary: "Main research question"
  secondary:
    - "Supporting question 1"
    - "Supporting question 2"

scope:
  in_scope:
    - "Topic/area included"
  out_of_scope:
    - "Topic/area excluded"
  time_horizon: "e.g., 2020-2025, all time, last 5 years"

# Configuration
base_mode: exploratory | systematic | explanatory | comparative | investigative | synthesis | rapid
secondary_modes:
  - "optional secondary mode"

# Context
pinned_docs:
  - "[[reference-doc-1]]"
  - "[[reference-doc-2]]"

stakeholders:
  - name: "Stakeholder name"
    role: "Their interest/role"

# Status
status: active | paused | completed | archived
created: 2026-01-18
updated: 2026-01-18

# Standard
tags:
  - research
  - project
  - "[domain-tag]"
---
```

## Research Job Frontmatter

```yaml
---
# Required
type: research-job
title: "Research Plan: [Focus Area]"
project: "[[parent-project-note]]"

# Status
status: pending | in_progress | blocked | completed
started: 2026-01-18
completed: null

# Methodology
mode: "primary mode for this job"
search_strategy:
  databases:
    - "Google Scholar"
    - "Semantic Scholar"
  terms:
    - "search term 1"
    - "search term 2"
  
quality_criteria:
  - "Peer-reviewed sources preferred"
  - "Published after 2020"

# Phases (becomes tasks)
phases:
  - name: "Phase 1: Survey"
    status: completed | in_progress | pending
    checkpoint: "[[checkpoint-phase1]]"
  - name: "Phase 2: Analysis"
    status: pending
    checkpoint: null

# Dependencies
depends_on:
  - "[[other-job-note]]"
blocks:
  - "[[downstream-job-note]]"

# Output
output_format: "report | synthesis | decision-matrix | annotated-bibliography"
audience: "Who will read this"
citation_style: "APA | Chicago | informal"

# Standard
tags:
  - research
  - job
  - "[topic-tag]"
---
```

## Research Task Frontmatter

```yaml
---
# Required
type: research-task
title: "[Phase Name] Checkpoint"
job: "[[parent-job-note]]"

# Status
status: pending | in_progress | review | revision | completed
created: 2026-01-18
completed: null

# Research State
iteration_count: 3
phase_number: 1

# Review Gate
review_requested: 2026-01-18T14:30:00
review_completed: null
reviewer_notes: null

# Findings Summary (populated at checkpoint)
findings_count: 5
sources_count: 12
confidence: high | medium | low

# Links
research_plan: "[[parent-job-note]]"
previous_checkpoint: "[[checkpoint-prev]]"
next_checkpoint: null

# Standard
tags:
  - research
  - task
  - checkpoint
---
```

## Status Definitions

### Project Status
| Status | Meaning |
|--------|---------|
| `active` | Currently being worked on |
| `paused` | Temporarily suspended |
| `completed` | All jobs finished |
| `archived` | Moved to archive, read-only |

### Job Status
| Status | Meaning |
|--------|---------|
| `pending` | Not yet started, may have dependencies |
| `in_progress` | Currently being executed |
| `blocked` | Waiting on dependency |
| `completed` | All phases/tasks done |

### Task Status
| Status | Meaning |
|--------|---------|
| `pending` | Not yet started |
| `in_progress` | Currently being worked |
| `review` | Checkpoint created, awaiting approval |
| `revision` | Feedback received, being revised |
| `completed` | Approved and done |

## Status Transitions

### Task Status Flow
```
pending → in_progress → review → completed
                          ↓
                      revision
                          ↓
                     in_progress
```

### Valid Transitions
| From | To | Trigger |
|------|-----|---------|
| pending | in_progress | Work begins |
| in_progress | review | Checkpoint created |
| review | completed | User approves |
| review | revision | User requests changes |
| revision | in_progress | Revision starts |
| in_progress | review | Revision complete |

## MDB Operations

### Update Status
```
mdb:update_note_frontmatter
  path: "projects/research/topic/checkpoint.md"
  frontmatter:
    status: "review"
    review_requested: "2026-01-18T14:30:00"
```

### Query by Status
```
mdb:find query="type:research-task status:review"
```

### Query by Project
```
mdb:find query="type:research-job project:[[project-name]]"
```

## Validation Rules

1. `type` must be one of: research-project, research-job, research-task
2. `status` must be valid for the type
3. `project` link required for jobs
4. `job` link required for tasks
5. `vault_root` must be valid path for projects
6. `phases` array required for jobs
