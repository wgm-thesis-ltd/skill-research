# Versioning Protocol

Rules for managing document versions in the vault during research.

## Core Rule

**NEVER overwrite source files.**

All modifications create new versions, preserving history.

## Version Numbering

### Pattern
```
filename.md      → Original
filename.1.md    → First revision
filename.2.md    → Second revision
filename.N.md    → Nth revision
```

### Examples
```
research-plan.md
research-plan.1.md
research-plan.2.md

literature-review.md
literature-review.1.md
```

## When to Create New Version

**CREATE new version when:**
- Significant content changes (not typos)
- Incorporating feedback from checkpoint review
- Major structural reorganization
- Synthesizing new findings into existing doc
- Any change that should be recoverable

**DON'T version for:**
- Typo fixes (edit in place)
- Minor formatting
- Adding tags to frontmatter
- Status updates

## Version Frontmatter

Each versioned document includes:

```yaml
---
title: "Document Title"
version: 2
previous_version: "[[filename.1]]"
versioned_from: "[[filename]]"
version_date: 2026-01-18
version_reason: "Incorporated Phase 2 findings"
---
```

## MDB Operations

### Creating New Version

```
# 1. Read current version
mdb:get_note path="working_dir/doc.md"

# 2. Determine next version number
# Check for existing versions: doc.1.md, doc.2.md, etc.

# 3. Create new version
mdb:create_note 
  path="working_dir/doc.2.md"
  content=[modified content with version frontmatter]

# 4. Update original to note latest version
mdb:update_note_frontmatter
  path="working_dir/doc.md"
  frontmatter: { latest_version: "[[doc.2]]" }
```

### Version Discovery

To find all versions of a document:
```
mdb:find query="versioned_from:[[filename]]"
```

## Version Chain

Maintain bidirectional links:

```
doc.md
  └── latest_version: [[doc.2]]

doc.1.md
  ├── previous_version: null (or [[doc]])
  ├── versioned_from: [[doc]]
  └── next_version: [[doc.2]]

doc.2.md
  ├── previous_version: [[doc.1]]
  ├── versioned_from: [[doc]]
  └── next_version: null (current)
```

## Research Plan Versioning

Research plans follow same pattern but with additional metadata:

```yaml
---
type: research-job
title: "Research Plan: Topic"
version: 1
status: in_progress
phases:
  - name: "Phase 1"
    status: completed
  - name: "Phase 2"
    status: in_progress
---
```

When plan changes significantly:
1. Create new version (research-plan.1.md)
2. Update phase statuses
3. Note what changed in version_reason

## Checkpoint Versioning

Checkpoints typically don't need versioning—each checkpoint is 
a unique point in time. But if a checkpoint is revised:

```
checkpoint-phase1-2026-01-18.md      → Original
checkpoint-phase1-2026-01-18.1.md    → Revised after feedback
```

## Conflict Resolution

If version numbers conflict:
1. Check existing files in directory
2. Use next available number
3. If uncertain, use timestamp suffix:
   `doc.2.20260118-1430.md`

## Cleanup

Old versions are NOT automatically deleted. Archive periodically:

```
# Move old versions to archive
mv working_dir/doc.1.md working_dir/archive/
mv working_dir/doc.2.md working_dir/archive/
```

Keep at minimum:
- Original document
- Current/latest version
- Any version with unique content not in later versions

## Anti-Patterns

**DON'T:**
- Overwrite files without versioning
- Delete old versions during active research
- Create versions for trivial changes
- Forget to update version links
- Use inconsistent naming patterns
