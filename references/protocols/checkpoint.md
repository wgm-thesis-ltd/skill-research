# Checkpoint Protocol

Checkpoints are mandatory gates between research phases. They ensure quality, 
maintain user control, and create recoverable state.

## When to Checkpoint

**MANDATORY checkpoints:**
- After each phase defined in research plan completes
- Before transitioning to a new research mode
- When iteration counter reaches warning threshold (cycle 4)
- Before any synthesis or final deliverable

**OPTIONAL checkpoints:**
- After significant unexpected findings
- When scope appears to be drifting
- At natural breakpoints in long sessions

## Checkpoint Process

```
1. CREATE DOCUMENT
   - Save checkpoint to working directory
   - Filename: checkpoint-[phase]-[YYYY-MM-DD].md
   - Include full frontmatter
   
2. UPDATE STATUS
   - Set task status to "review" via frontmatter
   - Link back to research plan
   
3. PRESENT SUMMARY
   - Show key findings
   - State confidence levels
   - Note any scope changes
   - Identify next steps
   
4. AWAIT APPROVAL
   - Explicit user confirmation required
   - "Proceed", "Continue", "Approved" etc.
   
5. PROCEED OR REVISE
   - If approved: continue to next phase
   - If revision requested: address feedback first
```

## Checkpoint Document Structure

```markdown
---
type: research-task
title: "[Phase Name] Checkpoint"
research_plan: "[[research-plan-filename]]"
phase: [phase number]
status: review
created: [ISO date]
iteration_count: [N]
tags:
  - research
  - checkpoint
---

# [Phase Name] Checkpoint

## Summary
[2-3 sentence overview of phase findings]

## Key Findings

### Finding 1: [Title]
[Description]
- Evidence: [Source]
- Confidence: [High/Medium/Low]

### Finding 2: [Title]
[Description]
- Evidence: [Source]
- Confidence: [High/Medium/Low]

## Sources Consulted
- [Source 1](URL) — [Brief note]
- [Source 2](URL) — [Brief note]

## Scope Notes
- In scope: [What was covered]
- Deferred: [What was postponed]
- Scope drift: [Any changes from plan]

## Open Questions
- [Question that emerged]
- [Question that emerged]

## Recommended Next Steps
1. [Next action]
2. [Next action]

## Approval Request
Ready to proceed to [next phase]?
Please confirm to continue.
```

## Status Transitions

```
draft → in_progress → review → [approved] → completed
                        ↓
                    [revision requested]
                        ↓
                    in_progress (revised)
```

## Approval Phrases

Accept any of these as approval:
- "Proceed" / "Continue" / "Go ahead"
- "Approved" / "Looks good" / "LGTM"
- "Yes" / "OK" / "Confirmed"
- "Next phase" / "Move on"

Request revision on:
- "Wait" / "Hold" / "Stop"
- "Revise" / "Change" / "Update"
- "Go back" / "Redo"
- Any substantive feedback or questions

## MDB Integration

```
# Create checkpoint
mdb:create_note
  path: [working_dir]/checkpoint-phase1-2026-01-18.md
  content: [checkpoint content]

# Update status to review
mdb:update_note_frontmatter
  path: [checkpoint path]
  frontmatter: { status: "review" }

# After approval, update to completed
mdb:update_note_frontmatter
  path: [checkpoint path]
  frontmatter: { status: "completed" }
```

## Recovery from Interruption

If session interrupted mid-research:
1. Check working directory for most recent checkpoint
2. Load checkpoint to restore context
3. Review status (review = awaiting approval, in_progress = continue)
4. Resume from appropriate point

## Anti-Patterns

**DON'T:**
- Skip checkpoints to "save time"
- Auto-approve your own checkpoints
- Create checkpoints without saving to vault
- Proceed without explicit user approval
- Ignore revision requests
