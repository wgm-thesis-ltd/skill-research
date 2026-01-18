# MDB Backend Implementation

Primary backend using mdb MCP server for full vault integration.

## Detection

```
At session start:
1. Check if mdb tools are available (mdb:get_note, mdb:create_note, etc.)
2. If available: MDB backend active
3. Verify project working directory exists
```

## Tool Mapping

| Backoffice Operation | MDB Tool | Notes |
|----------------------|----------|-------|
| `create_document` | `mdb:create_note` | Full frontmatter support |
| `get_document` | `mdb:get_note` | Returns parsed frontmatter |
| `update_document` | `mdb:update_note` | Supports append mode |
| `update_frontmatter` | `mdb:update_note_frontmatter` | Merge semantics |
| `find_documents` | `mdb:find` | Semantic + structured search |
| `list_directory` | `mdb:get_note` (dir) | Directory listing mode |
| `verify_path` | `mdb:get_note` | Check for success/error |
| `version_document` | `mdb:create_note` | Copy with incremented name |

## Operation Implementations

### create_document

```
[Backoffice: create_document]
Path: checkpoints/checkpoint-phase1.md
Working dir: projects/research/quantum-coherence

Implementation:
  mdb:create_note
    path: "projects/research/quantum-coherence/checkpoints/checkpoint-phase1.md"
    content: |
      ---
      type: research-task
      status: review
      ...
      ---
      # Phase 1 Checkpoint
      ...
```

### get_document

```
[Backoffice: get_document]
Path: research-plan.md

Implementation:
  mdb:get_note
    path: "projects/research/quantum-coherence/research-plan.md"
  
Returns:
  - Full content
  - Parsed frontmatter object
  - Metadata (created, modified dates)
```

### update_document

```
[Backoffice: update_document]
Path: checkpoint-phase1.md
Operation: append
Content: "## Additional Findings\n..."

Implementation:
  mdb:update_note
    path: "..."
    mode: append
    content: [new content]
```

### update_frontmatter

```
[Backoffice: update_frontmatter]
Path: checkpoint-phase1.md
Fields: {status: "completed", completed: "2026-01-18"}

Implementation:
  mdb:update_note_frontmatter
    path: "..."
    frontmatter: {status: "completed", completed: "2026-01-18"}
    
Note: Merges with existing frontmatter, doesn't replace entirely
```

### find_documents

```
[Backoffice: find_documents]
Type: research-task
Status: review

Implementation:
  mdb:find
    query: "type:research-task status:review"
    
Returns: List of matching documents with:
  - path
  - title (from frontmatter)
  - snippet (content preview)
  - frontmatter fields
```

### version_document

```
[Backoffice: version_document]
Path: research-plan.md
Reason: "Incorporating Phase 2 feedback"

Implementation:
  1. mdb:get_note path="research-plan.md"
  2. Determine next version number (check for .1.md, .2.md, etc.)
  3. mdb:create_note 
       path="research-plan.2.md"
       content=[original with updated version frontmatter]
  4. mdb:update_note_frontmatter
       path="research-plan.md"
       frontmatter: {latest_version: "[[research-plan.2]]"}
```

## MDB-Specific Features

### Full Project Hierarchy

With MDB backend:
- Projects, Jobs, Tasks fully supported
- Wikilinks resolve bidirectionally
- Backlinks maintained automatically
- Status transitions can trigger workflows

### Semantic Search

```
mdb:find query="quantum coherence mechanisms"
```
Returns semantically similar documents, not just keyword matches.

### Frontmatter Validation

MDB may enforce schemas:
- Required fields for types
- Valid status values
- Date formats
- Reference integrity

### Real-Time Sync

Changes via mdb:create_note and mdb:update_note are immediately:
- Written to vault
- Available for search
- Visible in Obsidian

## Status Display

When MDB backend activates:

```
[Research Skill: MDB backend active]
Working directory: projects/research/quantum-coherence
Project: [[quantum-coherence-project]]
Full mdb-projects integration available.
Capabilities: semantic search ✓, project hierarchy ✓, wikilinks ✓
```

## Error Handling

If mdb operation fails:

```
[Backoffice: create_document FAILED]
Error: Path not writable / Note already exists / ...

Recovery options:
1. Retry with different path
2. Fall back to Local backend for this operation
3. Report to user for manual intervention
```

## Exporting for Offline

When user needs offline work:

```
[Preparing offline export]
1. mdb:find project documents
2. For each: mdb:get_note → write to local workspace
3. Create manifest.json
4. Package as ZIP
5. Mark documents: _sync_status: exported
```

See `offline-sync.md` for full export/import workflow.
