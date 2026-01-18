# Offline Sync Workflow

Process for exporting from mdb, working locally, and re-importing.

## Overview

```
┌─────────────┐    Export    ┌─────────────┐    Work     ┌─────────────┐
│  MDB Vault  │ ──────────→  │   Local     │ ─────────→  │   Local     │
│  (online)   │              │  Workspace  │             │  (modified) │
└─────────────┘              └─────────────┘             └─────────────┘
       ↑                                                        │
       │                      Package                           │
       └──────────────────────────────────────────────────────←─┘
                              Merge (separate process)
```

## Phase 1: Export from MDB

### Trigger

User requests offline work:
- "I need to work on this offline"
- "Export this project for local work"
- "I'll be traveling without internet"

### Process

```
1. IDENTIFY SCOPE
   - Confirm project/job to export
   - List documents to include
   
2. RETRIEVE DOCUMENTS
   For each document in scope:
     mdb:get_note → content + frontmatter
     
3. WRITE TO LOCAL WORKSPACE
   Create: /home/claude/research-workspace/[project]/
   Write each document preserving structure
   
4. ADD SYNC METADATA
   Add to each document frontmatter:
     _sync_status: exported
     _export_batch: "[timestamp-id]"
     _mdb_path: "[original vault path]"
   
5. CREATE MANIFEST
   manifest.json with:
     - Export ID
     - Export timestamp
     - Source project
     - Document list with paths and hashes
   
6. PACKAGE
   ZIP the workspace directory
   Include manifest at root
   
7. PRESENT FOR DOWNLOAD
   present_files: [export.zip]
```

### Manifest Format

```json
{
  "export_id": "2026-01-18-quantum-001",
  "export_date": "2026-01-18T10:30:00Z",
  "source_backend": "mdb",
  "project": {
    "name": "quantum-coherence",
    "mdb_path": "projects/research/quantum-coherence"
  },
  "documents": [
    {
      "local_path": "research-plan.md",
      "mdb_path": "projects/research/quantum-coherence/research-plan.md",
      "version_at_export": 2,
      "frontmatter_hash": "abc123def456",
      "content_hash": "789xyz..."
    },
    {
      "local_path": "checkpoints/checkpoint-phase1.md",
      "mdb_path": "projects/research/quantum-coherence/checkpoints/checkpoint-phase1.md",
      "version_at_export": 1,
      "frontmatter_hash": "...",
      "content_hash": "..."
    }
  ],
  "export_options": {
    "include_completed": true,
    "include_archived": false
  }
}
```

### User Communication

```
[Preparing offline export: quantum-coherence]

Documents to export:
  ✓ research-plan.md
  ✓ checkpoints/checkpoint-phase1.md
  ✓ checkpoints/checkpoint-phase2.md
  ✓ sources/literature-notes.md

Creating export package...

[Download: quantum-coherence-offline-2026-01-18.zip]

To continue working offline:
1. Download this package
2. When ready to work, upload it and say "continue offline research"
3. When done, ask me to "package changes for sync"
```

## Phase 2: Working Offline

### Loading Export Package

When user uploads a previous export:

```
1. DETECT PACKAGE
   Check /mnt/user-data/uploads/ for ZIP with manifest.json
   
2. EXTRACT
   Unzip to /home/claude/research-workspace/
   
3. VERIFY MANIFEST
   Confirm all listed documents present
   
4. SET BACKEND MODE
   Backend: Local (offline mode)
   Source export: [export_id]
   
5. DISPLAY STATUS
   "Continuing from export [id]. Changes will be tracked."
```

### During Offline Work

Research continues normally using Local backend.

Changes tracked via frontmatter:

```yaml
# Existing document modified:
_sync_status: modified        # Changed from 'exported'
_modified_date: 2026-01-19
_changes: ["Updated Phase 2 findings", "Added new source"]

# New document created:
_sync_status: created
_local_mode: true
_export_batch: "2026-01-18-quantum-001"  # Links to source export
```

### Change Detection

Track changes automatically:
- New files: `_sync_status: created`
- Modified files: Compare content hash to manifest
- Deleted files: File in manifest but missing (rare, usually just not exported)

## Phase 3: Package for Re-Import

### Trigger

User ready to sync back:
- "Package my changes for sync"
- "I'm back online, prepare import"
- "Create sync package"

### Process

```
1. IDENTIFY CHANGES
   Compare current workspace to original manifest:
     - New documents (not in manifest)
     - Modified documents (hash changed)
     - Status changes (frontmatter updated)
   
2. CREATE IMPORT MANIFEST
   import-manifest.json with:
     - Original export reference
     - List of changes with types
     - Conflict indicators
   
3. PACKAGE CHANGED FILES
   Include only:
     - New documents
     - Modified documents
     - Original manifest (for reference)
     - Import manifest
   
4. PRESENT FOR DOWNLOAD
   present_files: [import-package.zip]
   
5. PROVIDE INSTRUCTIONS
   How to complete the merge in mdb environment
```

### Import Manifest Format

```json
{
  "import_id": "2026-01-19-quantum-import-001",
  "import_date": "2026-01-19T16:45:00Z",
  "source_export": "2026-01-18-quantum-001",
  "changes": [
    {
      "path": "research-plan.md",
      "change_type": "modified",
      "original_hash": "abc123",
      "new_hash": "def456",
      "sections_changed": ["Phase 2", "Phase 3"],
      "conflict_risk": "low"
    },
    {
      "path": "checkpoints/checkpoint-phase3.md",
      "change_type": "created",
      "new_hash": "xyz789"
    },
    {
      "path": "checkpoints/checkpoint-phase2.md",
      "change_type": "status_only",
      "old_status": "review",
      "new_status": "completed"
    }
  ],
  "summary": {
    "modified": 1,
    "created": 1,
    "status_changes": 1,
    "total_changes": 3
  }
}
```

### User Communication

```
[Preparing sync package]

Changes detected:
  Modified: research-plan.md (Phase 2, Phase 3 sections)
  Created:  checkpoints/checkpoint-phase3.md
  Status:   checkpoint-phase2.md (review → completed)

[Download: quantum-coherence-import-2026-01-19.zip]

To complete sync:
1. Download this package
2. In your mdb environment, upload and run merge process
3. Review any conflicts (research-plan.md has low conflict risk)
4. Confirm merged documents
```

## Phase 4: Merge (Separate Process)

The research skill's responsibility ends at producing the import package.

Merge is handled by:
- Manual user merge in Obsidian
- Separate merge skill/tool
- mdb import utility

### Merge Considerations

**For modified documents:**
- If mdb version unchanged since export → Safe to overwrite
- If mdb version changed → Conflict resolution needed
- Use content hashes to detect real conflicts vs. formatting

**For new documents:**
- Convert local paths to vault paths
- Convert path references to wikilinks
- Add to project hierarchy
- Remove `_local_mode` flag

**For status changes:**
- Apply if no conflicting status change in mdb
- Flag for review if status diverged

### Post-Merge Cleanup

After successful merge:
```yaml
# Clear local tracking fields
_local_mode: null          # Remove
_sync_status: merged       # Or remove entirely
_export_batch: null        # Remove
_mdb_path: null            # Remove (now canonical)
```

## Error Handling

### Export Failures

```
[Export failed: Document not found]
Document "sources/old-notes.md" listed in project but not accessible.

Options:
1. Skip this document and continue
2. Cancel export
```

### Import Package Validation

```
[Import package validation]
⚠ Warning: manifest.json missing content hashes
  → Will mark all documents as potentially modified

⚠ Warning: 2 documents in manifest not found in package
  → These will not be updated: [list]
```

### Conflict Detection

```
[Potential conflict detected]
research-plan.md was modified both locally and in mdb since export.

Local changes:
  - Updated Phase 2 findings
  
MDB changes (detected from hash mismatch):
  - Unknown (would need mdb access to compare)

Recommendation: Review carefully during merge.
Conflict risk: Medium
```

## Commands

| User Says | Action |
|-----------|--------|
| "Export for offline work" | Start Phase 1 |
| "Continue offline research" + upload | Start Phase 2 |
| "Package changes for sync" | Start Phase 3 |
| "What's my sync status?" | Show change summary |
