# CF-CHG-20260905-185–194 — Scholarship Queue Truth & Semantic Reconciliation Hardening

**Status:** IMPLEMENTED / RUNTIME PASS — REPO RECONCILED  
**Milestone:** M2.4.5  
**Area:** Layer 2 Scholarship acquisition, Evidence, reconciliation and canonical unpublished promotion

## Why

The first AU scale wave proved that a broad `international` URL cue is not sufficient to identify an individual Scholarship. Historical `detail_ready` rows also overstated executable work because many already had captured/applied first-party Evidence. The hardening sequence prevents duplicate acquisition and blocks catalogues, navigation, finance/support pages, sponsor hubs and supporting documents from entering canonical Scholarship reconciliation.

## Runtime sequence

- **CF-185** — terms/conditions and supporting-document terminal exclusion.
- **CF-186** — batch service hardened to discovered-only + first-party host + individual Scholarship semantics + international qualification; same-provider captured/applied source-record reuse; no publication.
- **CF-187** — generic collection reconciliation cleanup.
- **CF-188** — HTML entity/title cleanup before reconciliation.
- **CF-189** — queue truth reconciliation: already evidenced `detail_ready` rows become acquired and obsolete queued/running work closes as skipped-success.
- **CF-190** — structural candidate trigger for obvious support/navigation/catalogue exclusions.
- **CF-191** — entity-aware terminal guard and generic-title-first reconciliation view.
- **CF-192** — filter, domestic, fee guidance, conditions/guide, malformed HTML and other non-individual source records retained as unmapped Evidence.
- **CF-193** — information/funding hubs retained as Evidence only.
- **CF-194** — current-state queue closure after reconciliation.

## Acceptance evidence

Post-sequence Pilot state on 5 Sep 2026:

- canonical international Scholarships: **263**;
- published Scholarships: **0**;
- the prior 59 apparent `detail_ready` rows were reconciled to eight true fetch gaps, then to one already-evidenced UOW Australia Awards row, and finally to zero executable stale work under CF-194;
- strict CF-171 apply processed **16** verified first-party individual records, created **15** new unpublished roots and linked **1** existing root;
- **23** generic/support records were reclassified away from canonical application;
- no generic/navigation source record was observed applied as canonical during the gate review;
- no Search, Website, Zoho or broad Publication authority was added.

## Replay / repository reconciliation

Pilot migration identities `20260905005145` through `20260905022138` are restored in the Pilot repository. CF-185, CF-187 and CF-188 are explicitly retained as historical reconciliation markers where the exact intermediate live statement was not recoverable; their final behaviour is encoded by the later replay-safe guards. CF-186 contains the replay-safe current hardened service body rather than pretending an unavailable intermediate body is exact.

## Governance boundary

1. Landscape/catalogue discovery never proves an individual Scholarship.
2. Automatic detail acquisition requires an active discovered candidate, first-party university host, Scholarship semantics and international qualification.
3. Supporting documents, search/filter pages, finance/loan pages, domestic pages and information hubs remain Evidence/review context.
4. Existing same-provider captured/applied Evidence is reused; it is not fetched again merely because a historical candidate still says `detail_ready`.
5. Verified detail reconciliation may create/link **unpublished** canonical roots only.
6. Publication remains a separate governed decision.
7. CF-102 Provider Logo behaviour is unchanged.
