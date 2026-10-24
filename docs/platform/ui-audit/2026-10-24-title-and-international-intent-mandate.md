# Mandate — title verification (NZ) and international-intent pages (AU)

| | |
|---|---|
| Raised | Platform Admin, 24 Oct 2026 19:05 (Melbourne) |
| Status | **Recorded; queued behind the `target_only` chain (audit → O10 → R2).** The audit was produced 24 Oct 19:40 (`docs/platform/nz-enrichment-brief/2026-10-24-target-only-audit.md`); O10 is with the Platform Admin |
| Change control | CF-CHG-20260915-247; this file is the decision record |
| Hard rules | No course is ever deleted. Unverifiable courses are QUARANTINED (off the website, status change, reversible) only through count-guarded paste files the Platform Admin applies. No auto-quarantine. Every quarantine, alias or variant write carries provenance (who, what, quote, when). Budget within the existing search cap and Firecrawl daily budget; similarity threshold and batch size are settings keys |

## Defect 1 — NZ: register titles vs what providers publish (example: Otago)

1. **Quantify first (read-only):** for NZ active courses, register title vs the bound page's title/heading; similarity distribution; count below a threshold; the worst 20 with both titles quoted. Decides the approach before any writes.
2. **Verify pass** (courses below threshold): AI judges against the provider's published pages (stored copies first; Firecrawl search/map on the provider domain for the exact title only where storage is silent). Three outcomes, each with an evidence quote:
   - FOUND (variant: abbreviation, reordering, branding) → keep; record the published title as an alias; the binding is not churned.
   - NOT FOUND (on the register, not offered on the site to internationals) → quarantine candidate. First fed to the zero-yield flow's `page_rejections` / re-find (the right page may sit under another title); only after re-find fails does it reach Layer 4 as "not offered".
   - PAGE STATES IT → keep, note.
3. **Human gate:** Layer 4 items with both titles, the AI's quote and verdict; the Platform Admin decides removals in batches.
4. **Budget:** NZ providers by course count; settings keys for the similarity threshold and batch size.

## Defect 2 — AU: links must land on the international-intent page (example: Monash)

1. **Detect** (stored copies first): AI identifies pages whose primary content is domestic with an international entry point (button, tab, link). Quantify per provider before acting; Monash-family (multi-tab course pages) first.
2. **Resolve, in order:** (a) derive the international URL (the button's href, same site) and re-bind through the standard bind → reidentify → re-read chain; (b) where no international variant exists, annotate the course (confirm the reader captures international intent; fix if not); (c) flag for Layer 4.
3. **Readers:** fee, English and intake readers prefer international-stated values where a page carries both (quote-on-page keeps provenance). Check today's readers; fix any that take the domestic value silently.
4. Same budget discipline and settings keys as Defect 1.

## Cross-cutting

- Both flows **consume** `page_rejections` (S1 semantics) and do not duplicate the zero-yield flow.
- Sequencing: Defect 1 quantification and Defect 2 detection may run in parallel (read-only); writes wait for batch approvals.
- Contract tests: title-variant alias recording; international-variant re-bind chain; reader international preference.

## Division of labour vs the zero-yield flow (draft; confirmed when built)

| Flow | Question it answers | Input | Output |
|---|---|---|---|
| Zero-yield (v2.15.338) | "Is this bound page the wrong page?" (a read admits nothing) | Bound pages with no admitted values | `page_rejections` + re-find |
| Defect 1 title verification | "Does this course exist as the provider publishes it?" | Register title vs page title below threshold | Alias (FOUND), note (STATES IT), or → `page_rejections`/re-find, then Layer 4 "not offered" |
| Defect 2 international intent | "Is this the right variant of a correct page?" | Bound pages that are right but domestic-first | Re-bind to the international URL, annotation, or Layer 4 |

Neither new flow decides that a page is wrong on its own evidence: a wrong page goes to `page_rejections` and the zero-yield/S1 re-find, as today.

## Output owed (when the chain clears)

1. Both quantifications with samples. 2. Designs with settings keys and budget estimates. 3. Layer 4 proposal batches with evidence quotes. 4. This division-of-labour note, confirmed. 5. Anything blocked (expected: batch decisions only).
