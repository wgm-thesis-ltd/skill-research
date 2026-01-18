# /research-init

Initialize a research session with proper project context and working directory.

## Usage

```
/research-init [topic]
```

## What This Command Does

1. **Detects or creates project context**
   - Searches vault for existing research project matching topic
   - Offers to create new research project if none found

2. **Validates working directory**
   - Checks project's vault_root exists
   - Creates figures/ subdirectory if needed
   - Verifies write access via mdb:create_note test

3. **Checks for existing research plan**
   - Searches for `type: research-job` notes in working directory
   - If found, offers to continue or create new plan

4. **Initiates guided plan creation** (if no plan)
   - Research questions
   - Scope definition
   - Methodology selection
   - Output requirements
   - Phase planning

5. **Confirms research mode**
   - Analyzes topic for mode signals
   - Recommends primary + secondary modes
   - User confirms or specifies alternatives

## Example

```
/research-init vortex dynamics particle mass derivation

Searching for existing project...
Found: projects/research/vortex-dynamics (type: research-project)

Working directory: projects/research/vortex-dynamics
✓ Directory exists
✓ Write access confirmed

Existing research plans:
1. research-plan-mass-hierarchy.md (status: completed)
2. research-plan-vacuum-structure.md (status: in_progress)

Continue with "research-plan-vacuum-structure.md"? [Y/n]

Detected signals: "particle", "mass", "derivation"
Recommended modes: explanatory + systematic

Ready to begin research. [Research Mode: explanatory + systematic]
```

## Prerequisites

- mdb MCP server must be available
- Vault must be accessible
