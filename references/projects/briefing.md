# Briefing Composition

How context flows from project → job → task to create research briefings.

## Composition Layers

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: PROJECT                                       │
│  - Research questions                                   │
│  - Scope boundaries                                     │
│  - Base mode                                            │
│  - Pinned documents                                     │
│  - Working directory                                    │
├─────────────────────────────────────────────────────────┤
│  Layer 2: JOB                                           │
│  - Phase context                                        │
│  - Mode narrowing/override                              │
│  - Search strategy                                      │
│  - Quality criteria                                     │
│  - Output requirements                                  │
├─────────────────────────────────────────────────────────┤
│  Layer 3: TASK                                          │
│  - Thread-specific instructions                         │
│  - Checkpoint requirements                              │
│  - Iteration state                                      │
│  - Previous findings                                    │
└─────────────────────────────────────────────────────────┘
```

## Composition Modes

### Inherit (Default)
Child layer receives parent value unchanged.

```yaml
# Project
base_mode: systematic

# Job (inherits)
mode: systematic  # same as parent
```

### Extend
Child layer adds to parent value.

```yaml
# Project
scope:
  in_scope:
    - "Quantum coherence"

# Job (extends)
scope:
  in_scope:
    - "Quantum coherence"      # inherited
    - "Photosynthesis only"    # added
```

### Override
Child layer replaces parent value.

```yaml
# Project
base_mode: systematic

# Job (overrides)
mode: investigative  # replaces for this job
mode_override: true
```

## Composition Algorithm

```
function compose_briefing(task):
    job = get_note(task.job)
    project = get_note(job.project)
    
    briefing = {}
    
    # Layer 1: Project base
    briefing.questions = project.questions
    briefing.scope = project.scope
    briefing.mode = project.base_mode
    briefing.working_dir = project.vault_root
    briefing.pinned = project.pinned_docs
    
    # Layer 2: Job refinement
    if job.mode_override:
        briefing.mode = job.mode
    briefing.scope = merge(briefing.scope, job.scope)
    briefing.search = job.search_strategy
    briefing.quality = job.quality_criteria
    briefing.output = job.output_format
    
    # Layer 3: Task specifics
    briefing.phase = job.phases[task.phase_number]
    briefing.iteration = task.iteration_count
    briefing.previous = load_if_exists(task.previous_checkpoint)
    
    return briefing
```

## Context Budget

Target: Stay within model context limits while providing useful briefing.

| Component | Typical Tokens | Max Tokens |
|-----------|----------------|------------|
| Project context | 200-500 | 1000 |
| Job context | 300-800 | 1500 |
| Task context | 100-300 | 500 |
| Previous checkpoint | 500-1500 | 3000 |
| Pinned documents | 1000-5000 | 10000 |
| **Total briefing** | **2000-8000** | **16000** |

### Truncation Priority

If over budget, truncate in this order:
1. Pinned documents (summarize or skip)
2. Previous checkpoint (summarize findings only)
3. Job search strategy details
4. Project secondary questions

Never truncate:
- Primary research question
- Current scope boundaries
- Working directory
- Current phase definition

## Pinned Document Handling

Pinned docs provide standing context:

```yaml
# In project frontmatter
pinned_docs:
  - path: "[[methodology-guide]]"
    include: full          # full | summary | reference_only
  - path: "[[domain-glossary]]"
    include: summary
  - path: "[[prior-research]]"
    include: reference_only
```

### Include Modes
- `full`: Load entire document into context
- `summary`: Load only first section or description
- `reference_only`: Just note it exists, load on demand

## Briefing Output Format

```markdown
## Research Briefing

### Project: [Title]
**Primary Question:** [question]
**Scope:** [in scope] | NOT: [out of scope]
**Working Directory:** [vault_root]

### Current Job: [Title]
**Mode:** [mode]
**Phase:** [N] of [total] - [phase name]
**Search Strategy:** [summary]

### Task Context
**Status:** [status]
**Iteration:** [N]
**Previous Findings:** [summary if exists]

### Instructions
[Phase-specific guidance]

### Pinned References
- [[doc1]] - [why pinned]
- [[doc2]] - [why pinned]
```

## Session Initialization

At research session start:

1. Detect or select project
2. Load project briefing (Layer 1)
3. Find active job or create new
4. Load job briefing (Layer 2)
5. Find current task or create new
6. Load task context (Layer 3)
7. Compose full briefing
8. Present to user for confirmation

## MDB Operations

### Load Briefing Chain
```
# Get task
task = mdb:get_note(task_path)

# Get job
job = mdb:get_note(task.frontmatter.job)

# Get project
project = mdb:get_note(job.frontmatter.project)

# Get pinned docs
for doc in project.frontmatter.pinned_docs:
    if doc.include == "full":
        content = mdb:get_note(doc.path)
```

### Find Active Work
```
# Find projects with active status
mdb:find query="type:research-project status:active"

# Find in-progress jobs for project
mdb:find query="type:research-job project:[[name]] status:in_progress"

# Find tasks awaiting review
mdb:find query="type:research-task status:review"
```
