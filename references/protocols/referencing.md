# Referencing Protocol

Guidelines for citing sources and managing references in research outputs.

## Core Principles

1. **Key findings need sources** — Not every claim, but important ones
2. **Use judgment** — Balance thoroughness with readability
3. **Prefer authoritative** — Primary sources over secondary
4. **Enable verification** — Reader should be able to check claims

## Reference Format

### Inline References (Preferred)

```markdown
According to [Author Name](URL), the phenomenon occurs when...

The study found significant effects [Source](URL).

This aligns with earlier findings [Paper Title](https://doi.org/...).
```

### Footnote Style (For Dense Citations)

```markdown
The mechanism involves three stages.[^1]

[^1]: [Author (Year). Title](URL)
```

### Reference Section (For Comprehensive Lists)

```markdown
## References

1. Author, A. (2024). [Title](URL). *Journal*, Vol(Issue).
2. Author, B. (2023). [Title](URL). Publisher.
```

## Source Reliability Levels

| Level | Description | Usage |
|-------|-------------|-------|
| **A** | Authoritative — Peer-reviewed, official records, primary sources | Cite directly, high confidence |
| **B** | Reliable — Quality journalism, documented research, expert analysis | Cite with context |
| **C** | Mixed — Blogs, forums, Wikipedia, unknown provenance | Must corroborate |
| **D** | Unreliable — Anonymous, known bias, unverified claims | Flag explicitly if used |

## When to Cite

**ALWAYS cite:**
- Specific statistics or data points
- Direct claims attributed to sources
- Controversial or surprising assertions
- Technical definitions from authoritative sources
- Quotes or paraphrases

**JUDGMENT call:**
- Common knowledge in the field
- Synthesized conclusions from multiple sources
- General background information

**DON'T need citation:**
- Logical deductions you're making
- Your own analysis or framework
- Widely accepted facts

## Source Selection Hierarchy

1. **Primary sources** — Original research, official documents
2. **Peer-reviewed** — Academic journals, conference proceedings
3. **Institutional** — Government reports, org publications
4. **Quality journalism** — Major outlets with editorial standards
5. **Expert blogs** — Known experts in field
6. **General web** — Use with corroboration

## URL Best Practices

### Prefer Stable URLs
- DOIs: `https://doi.org/10.1234/...`
- Archive links: `https://web.archive.org/...`
- Institutional: `.edu`, `.gov`, `.org`

### Avoid
- URL shorteners
- Session-specific URLs
- Paywalled without noting it

### Format for Iframe Preview
```markdown
[Display Text](https://example.com/article)
```
This format enables iframe preview in supporting interfaces.

## Citation Density Guidelines

| Research Mode | Citation Density |
|---------------|------------------|
| Systematic | High — Every key finding cited |
| Investigative | High — Evidence chain documented |
| Explanatory | Medium — Key mechanisms cited |
| Comparative | Medium — Data points cited |
| Synthesis | Medium — Source integration noted |
| Exploratory | Low-Medium — Key discoveries cited |
| Rapid | Low — Primary source noted |

## Managing Large Reference Sets

For research with many sources:

```markdown
## Key Sources (Most Important)
- [Source 1](URL) — Why it's key
- [Source 2](URL) — Why it's key

## Supporting Sources
- [Source 3](URL)
- [Source 4](URL)

## Sources Consulted But Not Cited
[List if useful for transparency]
```

## Quality Checks

Before finalizing:
- [ ] Key claims have sources?
- [ ] URLs are functional?
- [ ] Source reliability appropriate to claim?
- [ ] No orphaned footnotes?
- [ ] Reference format consistent?
