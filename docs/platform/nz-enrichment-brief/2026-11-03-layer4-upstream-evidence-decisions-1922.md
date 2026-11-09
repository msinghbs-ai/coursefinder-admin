# Platform Admin decisions — Layer 4 upstream evidence (3 November 2026, 19:22 AEDT)

**Applies to:** `2026-11-03-layer4-upstream-evidence-claude-prompt.md`. **Review:** `2026-11-03-layer4-upstream-evidence-prompt-review.md`.

| # | Question | Decision |
|---|---|---|
| 1 | Who submits decisions on the 24 refs | Claude submits, using a list the Platform Admin approves item by item. ChatGPT's reviewer pauses on those refs. |
| 2 | How an agent's decision is recorded | Each reason states "submitted by Claude, approved by Platform Admin" with the batch ID. |
| 3 | Firecrawl allowance for evidence recovery | Superseded at 19:23, see below. |
| 4 | Other kinds while University description is aligned | Continue. The stop applies to University description only. |

Scope adopted from the review unless changed: the 24 refs and their root causes, then a resume point. Evidence, approval and admission gates are unchanged.

## Update, 19:23 AEDT (decision 3)

Platform Admin, verbatim: "keep on using firecrawl credit as you need it, keep storing the page as above layers does as evidence. if it runs out i'll increase the credit on firecrawl platform"

Effect: Firecrawl reads needed for this evidence recovery are approved with no fixed cap. Reads run through the platform's own read paths so each page is stored as evidence in the normal way. Stored evidence is still checked first, to avoid repeat reads. AI re-checks, bulk approval, direct SQL admission and all other gates are unchanged. Live balance at 19:18: 2,844 credits.
