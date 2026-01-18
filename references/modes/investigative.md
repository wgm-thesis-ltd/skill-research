# Investigative Research Mode

**When:** Establishing facts, verification, due diligence, OSINT
**Cognitive Style:** Skeptical, verifying, triangulating
**Output:** Verified claims, evidence chains, confidence assessments

## Characteristics

- Skeptical stance—verify before accepting
- Triangulate from multiple independent sources
- Apply source reliability assessment
- Document chain of evidence
- Distinguish fact from inference from speculation
- Consider motivation and bias of sources

## 6W+2H Framework

For each key claim, establish:

| Question | Purpose |
|----------|---------|
| **Who** | Actors, stakeholders, sources |
| **What** | Events, actions, outcomes |
| **When** | Timeline, sequence, dates |
| **Where** | Locations, jurisdictions |
| **Why** | Motivations, causes |
| **Which** | Specific details, identifiers |
| **How** | Methods, processes, mechanisms |
| **How much** | Quantities, values, extent |

## Source Reliability Matrix

| Level | Description | Examples | Treatment |
|-------|-------------|----------|-----------|
| **A** | Authoritative | Official records, peer-reviewed | Cite directly |
| **B** | Generally reliable | Quality journalism, documented research | Cite with context |
| **C** | Questionable | Blogs, forums, unknown provenance | Must corroborate |
| **D** | Unreliable | Anonymous, known bias, unverified | Flag explicitly |

## Verification Protocol

```
1. IDENTIFY CLAIM
   - What specific assertion needs verification?
   - Who made the claim originally?
   
2. SOURCE ASSESSMENT
   - What is the source's reliability level?
   - What is their potential bias/motivation?
   
3. TRIANGULATION
   - Can this be verified from independent sources?
   - Do sources have shared origin? (not truly independent)
   
4. EVIDENCE CHAIN
   - What is the chain from primary evidence to claim?
   - How many steps removed are we?
   
5. CONFIDENCE ASSIGNMENT
   - How confident are we in this claim?
   - What would change our confidence?
```

## Evidence Documentation Template

```markdown
## Investigation: [Topic]

### Claim Under Investigation
"[Specific claim being verified]"

### Evidence Chain
| # | Evidence | Source | Reliability | Supports/Contradicts |
|---|----------|--------|-------------|----------------------|
| 1 | [Evidence] | [Source] | A/B/C/D | Supports |
| 2 | [Evidence] | [Source] | A/B/C/D | Supports |
| 3 | [Evidence] | [Source] | A/B/C/D | Contradicts |

### Source Independence
- Sources 1 and 2: [Independent / Share origin]
- Source 3: [Independent / Share origin]

### Confidence Assessment
- Claim status: **Verified** / Likely / Uncertain / Unlikely / Refuted
- Confidence: [High/Medium/Low]
- Key evidence: [What most supports conclusion]
- Key uncertainty: [What would change assessment]
```

## Red Flags

Watch for:
- Single source for key claim
- Sources citing each other circularly
- Anonymous or untraceable sources
- Claim benefits source's interests
- Extraordinary claim without extraordinary evidence
- Claim contradicts established facts without explanation

## Output Structure

```markdown
## Investigative Report: [Topic]

### Summary of Findings
[Key verified facts in 2-3 sentences]

### Verified Facts
1. [Fact] — Confidence: High
   - Evidence: [Source A, Source B]
   
2. [Fact] — Confidence: Medium
   - Evidence: [Source]
   - Caveat: [Limitation]

### Unverified Claims
- [Claim]: Could not verify because [reason]

### Contradictory Information
- [Source A] says X, [Source B] says Y
- Assessment: [Which is more credible and why]

### Open Questions
- [What remains unknown]

### Methodology
[How investigation was conducted]
```

## When to Use

- Fact-checking
- Due diligence
- Background research
- Verification of claims
- OSINT analysis

## Combines Well With

- `explanatory` — After establishing facts, explain mechanisms
- `rapid` — Quick verification with triangulation
- `systematic` — When comprehensive fact-finding needed
