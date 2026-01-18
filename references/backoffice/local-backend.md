# Local Backend Implementation

Fallback backend using computer tools for session-local storage.
Used when mdb MCP server is unavailable.

## Detection

```
At session start:
1. Check if mdb tools are available
2. If unavailable: Local backend active
3. Check for existing workspace or create new
4. Check for import package (offline continuation)
```

## Working Directory

```
/home/claude/research-workspace/
├── [project-name]/
│   ├── _project.md           # Project definition
│   ├── research-plan.md
│   ├── checkpoints/
│   │   ├── checkpoint-phase1.md
│   │   └── checkpoint-phase2.md
│   ├── drafts/
│   ├── sources/
│   └── manifest.json         # If working from export
└── _exports/                 # Packaged exports for download
```

## Tool Mapping

| Backoffice Operation | Local Tools | Notes |
|----------------------|-------------|-------|
| `create_document` | `create_file` | Manual YAML formatting |
| `get_document` | `view` | Manual frontmatter parsing |
| `update_document` | `str_replace` / `create_file` | Depends on complexity |
| `update_frontmatter` | `str_replace` | Target YAML block |
| `find_documents` | `bash` (grep/find) | Pattern matching only |
| `list_directory` | `view` | Directory mode |
| `verify_path` | `bash` (test) | File system check |
| `version_document` | `bash` (cp) + metadata | Manual process |

## Operation Implementations

### create_document

```
[Backoffice: create_document]
Path: checkpoints/checkpoint-phase1.md
Working dir: /home/claude/research-workspace/quantum-coherence

Implementation:
  create_file
    path: "/home/claude/research-workspace/quantum-coherence/checkpoints/checkpoint-phase1.md"
    content: |
      ---
      type: research-task
      title: "Phase 1 Checkpoint"
      job: "research-plan.md"
      status: review
      created: 2026-01-18
      _local_mode: true
      _sync_status: pending
      ---
      
      # Phase 1 Checkpoint
      ...
```

Note: `_local_mode` and `_sync_status` added automatically.

### get_document

```
[Backoffice: get_document]
Path: research-plan.md

Implementation:
  view
    path: "/home/claude/research-workspace/quantum-coherence/research-plan.md"
    
Post-processing:
  1. Extract YAML frontmatter (between --- markers)
  2. Parse YAML to object
  3. Return {content, frontmatter}
```

### update_document

For simple appends:
```
[Backoffice: update_document]
Operation: append

Implementation:
  view [path] → get current content
  create_file [path] → write current + new content
```

For section replacement:
```
[Backoffice: update_document]
Operation: replace_section
Section: "## Key Findings"

Implementation:
  str_replace
    path: [path]
    old_str: [existing section content]
    new_str: [new section content]
```

### update_frontmatter

```
[Backoffice: update_frontmatter]
Path: checkpoint-phase1.md
Fields: {status: "completed"}

Implementation:
  1. view [path] → get content
  2. Parse existing frontmatter
  3. Merge new fields
  4. str_replace old frontmatter block with updated
  
Or if complex:
  1. Read full file
  2. Update frontmatter in memory
  3. Rewrite entire file with create_file
```

### find_documents

```
[Backoffice: find_documents]
Type: research-task
Status: review

Implementation:
  bash: grep -rl "type: research-task" /home/claude/research-workspace/[project]/ | 
        xargs grep -l "status: review"
        
Or for path pattern:
  bash: find /home/claude/research-workspace/[project]/ -name "checkpoint-*.md"

Note: No semantic search available. Returns file paths only.
      Must read each file to get title/snippet.
```

### list_directory

```
[Backoffice: list_directory]
Path: checkpoints/

Implementation:
  view
    path: "/home/claude/research-workspace/quantum-coherence/checkpoints"
    
Returns directory listing.
```

### verify_path

```
[Backoffice: verify_path]
Path: checkpoints/

Implementation:
  bash: test -d "/home/claude/research-workspace/quantum-coherence/checkpoints" && 
        test -w "/home/claude/research-workspace/quantum-coherence/checkpoints"
```

### version_document

```
[Backoffice: version_document]
Path: research-plan.md
Reason: "Incorporating feedback"

Implementation:
  1. bash: ls research-plan.*.md | sort -V | tail -1
     → Determine highest existing version
  2. bash: cp research-plan.md research-plan.2.md
  3. str_replace in research-plan.2.md:
     - Update version frontmatter
     - Add previous_version link
  4. str_replace in research-plan.md:
     - Add latest_version field
```

## Local-Specific Frontmatter

Documents created locally include:

```yaml
---
type: research-task
title: "Phase 1 Checkpoint"
job: "research-plan.md"      # Local path, not wikilink
status: review
created: 2026-01-18
_local_mode: true            # Marks as locally created
_sync_status: pending        # pending | exported | merged
_export_batch: null          # Set when exported
---
```

## Reference Development

Without mdb, references come from:

### 1. User Prompting
```
User: The key paper is Smith et al. 2023 on quantum biology

[Adding to sources]
- Smith et al. (2023). [Quantum Biology Review] — User provided
```

### 2. Web Search
```
[web_search: quantum coherence photosynthesis]
Found: [Article Title](https://example.com/article)

[Adding to sources]
- [Article Title](https://example.com/article) — Reliability: B
```

### 3. Uploaded Documents
```
User uploads: smith-2023-quantum-biology.pdf

[Processing /mnt/user-data/uploads/smith-2023-quantum-biology.pdf]
[Extracting key findings...]

[Adding to sources]
- Smith et al. (2023). Quantum Biology Review — Uploaded document
```

### 4. Conversation Context
```
[Synthesizing from conversation]
Based on our discussion, key points include:
- [Finding from earlier exchange]
```

## Status Display

When Local backend activates:

```
[Research Skill: Local backend active]
Working directory: /home/claude/research-workspace/quantum-coherence
Note: Documents are session-local. Download outputs to persist.

Capabilities:
  ✓ Document creation and editing
  ✓ Frontmatter management  
  ✓ Checkpointing workflow
  ✗ Semantic search (pattern matching only)
  ✗ Wikilink resolution
  ○ Version tracking (manual)
  
To persist your work, ask me to "package for download".
```

## Presenting Files to User

Local documents should be made available for download:

```
[Packaging research outputs]

present_files:
  - /home/claude/research-workspace/quantum-coherence/research-plan.md
  - /home/claude/research-workspace/quantum-coherence/checkpoints/checkpoint-phase1.md

Or as ZIP:
  bash: cd /home/claude/research-workspace && zip -r quantum-coherence.zip quantum-coherence/
  present_files: [quantum-coherence.zip]
```

## Limitations

| Capability | Status | Workaround |
|------------|--------|------------|
| Semantic search | ✗ | Use grep patterns, filenames |
| Wikilinks | ✗ | Store as text, resolve on import |
| Project hierarchy | ○ | Structure maintained, not enforced |
| Real-time persist | ✗ | Explicit download required |
| Cross-references | ✗ | Manual links only |
| Backlinks | ✗ | Forward links only |

## Error Handling

```
[Backoffice: create_document FAILED]
Error: Permission denied / Path too long / ...

Recovery:
1. Check working directory exists
2. Simplify path if needed
3. Report to user
```

## Transitioning to MDB

When user later has mdb available:

1. Upload local workspace or export package
2. Run import process (separate skill/manual)
3. Resolve `_local_mode` documents
4. Convert local paths to wikilinks
5. Integrate into project hierarchy
