# Backoffice Interface

The research skill delegates all document operations through this abstraction layer.
A backend implementation (MDB or Local) provides the concrete behavior.

## Why This Exists

1. **Decoupling** — Research workflow doesn't depend on specific storage
2. **Graceful degradation** — Skill works without mdb, with reduced capability
3. **Behavioral reminders** — Operations can inject protocol checks
4. **Offline support** — Export/import workflow for disconnected work

## Operations

### create_document

Create a new document with content and frontmatter.

```
Input:
  path: string          # Relative to working directory
  content: string       # Markdown body
  frontmatter: object   # YAML fields

Output:
  success: boolean
  path: string          # Actual path created
  error?: string

Reminder: "Verify: path within working directory, frontmatter 
           includes type and status, wikilink to research plan."
```

### get_document

Retrieve document content and parsed frontmatter.

```
Input:
  path: string

Output:
  success: boolean
  content: string
  frontmatter: object
  error?: string

Reminder: "Content may be stale if working offline from mdb."
```

### update_document

Modify document content.

```
Input:
  path: string
  operation: "append" | "replace_section" | "full_replace"
  content: string
  section?: string      # Heading for replace_section

Output:
  success: boolean
  error?: string

Reminder: "For significant changes, version_document first."
```

### update_frontmatter

Modify frontmatter fields (merge semantics).

```
Input:
  path: string
  fields: object        # Fields to update

Output:
  success: boolean
  error?: string

Reminder: "Valid transitions: pending→in_progress→review→completed.
           Setting 'review' triggers checkpoint protocol."
```

### find_documents

Search for documents by various criteria.

```
Input:
  query?: string        # Semantic/keyword (MDB only)
  type?: string         # Frontmatter type
  status?: string       # Frontmatter status
  path_pattern?: string # Glob pattern

Output:
  success: boolean
  documents: [{path, title, type, status, snippet}]
  error?: string

Reminder: "Local backend: semantic search unavailable, 
           prefer path_pattern."
```

### list_directory

List contents of a directory.

```
Input:
  path: string

Output:
  success: boolean
  files: [{name, type, path}]
  error?: string
```

### verify_path

Check if path exists and is writable.

```
Input:
  path: string

Output:
  exists: boolean
  writable: boolean
  error?: string
```

### version_document

Create versioned copy before modification.

```
Input:
  path: string
  reason: string

Output:
  success: boolean
  new_path: string      # e.g., doc.1.md
  error?: string

Reminder: "Pattern: doc.md → doc.1.md → doc.2.md.
           Update version frontmatter fields."
```

## Using the Interface

In skill operations, call backoffice abstractly:

```
[Backoffice: create_document]
Path: checkpoints/checkpoint-phase1.md
Frontmatter: {type: research-task, status: review, ...}
Content: [checkpoint content]

→ Backend executes appropriate implementation
→ Reminder displayed if relevant
→ Result returned
```

## Backend Detection

At session start:

```
1. Check for mdb MCP server availability
2. Set active backend (MDB or Local)
3. Display backend status to user
4. Adjust capability expectations
```

## Capability Matrix

| Operation | MDB | Local |
|-----------|-----|-------|
| create_document | ✓ Full | ✓ Full |
| get_document | ✓ Full | ✓ Full |
| update_document | ✓ Full | ✓ Full |
| update_frontmatter | ✓ Validated | ○ Format only |
| find_documents (semantic) | ✓ Full | ✗ None |
| find_documents (pattern) | ✓ Full | ✓ Full |
| version_document | ✓ Full | ✓ Manual |

Legend: ✓ Full, ○ Partial, ✗ Unavailable
