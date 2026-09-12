# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — LARGE-UNIVERSITY L2 ACCEPTANCE PASS / CODEX + L3 GATES PENDING  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-12 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**PR head:** `81a8ae3b24063970d5571b6d8bb177b9c6c7e07a`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Preserved authority and security boundaries

- Browser scheduler reads/actions remain rank-gated governed RPCs.
- Layer 1 identity/source authority remains unchanged.
- Layer 2 discovery/acquisition is deterministic and Evidence-preserving.
- Terminal discovery negatives are accepted only as `current_page_not_found`, `ambiguous` or `identity_mismatch`; no URL is manufactured.
- `layer3_required` is an L2 terminal disposition only; generic scheduler Layer 3 remains prohibited.
- Search/Publication remains a separate governed boundary.
- No execution policy, source profile, route or identity threshold was fabricated/relaxed for acceptance.
- Applied migration history was not rewritten or retimestamped.

## Repository / CI / deployment truth

PR #72 remains OPEN / DRAFT / mergeable against accepted main `63c7107...`.

- Exact PR head: `81a8ae3b24063970d5571b6d8bb177b9c6c7e07a`.
- Exact-head Pilot Frontend Build `34672122160`: **PASS**.
- Cloudflare exact-head branch/commit preview: **deployment successful**.
- Exact-head Codex review: **not present / pending**; merge remains blocked.
- Visible accepted release remains v2.15.78; no Production deployment.

Forward runtime migration identities are retained in the Pilot repository; immutable applied history was not rewritten. The branch also carries forward terminal-negative freshness/accounting and completion-anchored dedupe corrections plus targeted regression coverage.

## UQ 382-course acceptance — PASS

Accepted Preview token: `6fe9b130-c821-4da2-916f-ffea8126cc93`.

Final bound discovery scope: 376 Courses.

| Discovery outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 245 |
| Governed terminal negative | 131 |
| Transient / unattempted | 0 |
| **Total** | **376** |

Deterministic Layer 2 handoff:

- batch `eee74644-9b2e-45b8-b0f7-20c4e5c587d4`;
- target 251 = 6 prior queueable + 245 selected discovery URLs;
- terminal result: 248 `resolved_l2` + 3 `layer3_required`;
- no generic Layer 3 job was invoked;
- no Search/Publication admission was authorised.

Same-token replay passed. A fresh-Preview dedupe test exposed that the recent-dispatch horizon was anchored to original dispatch time; the unintended duplicate was cancelled through the governed lifecycle with 0 processed items. A forward-only correction now anchors completed/partial executions to completion time and excludes cancelled batches. Fresh-Preview dedupe retest passed and reused the prior execution.

## RMIT 500-course acceptance — L2 PASS

Fresh Preview token: `c3e73796-d2d3-486e-b3a4-83afc54b806d`.

Preview:

- scope: 500 Courses;
- queueable: 261;
- Preview-bound discovery: 239;
- executable: true;
- profile/policy/route/oversize/discovery-config gaps: 0;
- scope fingerprint: `14ff4e15dd39bc46f785f4e03ca3b3dc`.

Discovery initially terminated fail-closed on pg_net request `5965` with 15 courses still transient/unattempted. The exact remainder was 10 unattempted plus 5 transient `candidate` outcomes. The accepted active-binding retry contract was used to redispatch only those 15; no profile or matching threshold changed.

Request `5966` processed all 15 with 0 failures and completed the bound discovery set:

| Discovery outcome | Courses |
|---|---:|
| CRICOS-verified selected current URL | 2 |
| Governed terminal negative | 237 |
| Transient / unattempted | 0 |
| **Total** | **239** |

Handoff started deterministic Layer 2 batch `c8a33237-d2b5-47c3-a02b-2676cb6b820f` for 263 targets = 261 prior queueable + 2 selected discovery URLs.

Terminal deterministic L2 result at `2026-09-12 06:11:31.218367Z`:

| L2 item status | Count |
|---|---:|
| `resolved_l2` | 213 |
| `layer3_required` | 50 |
| **Total** | **263** |

Batch status is `partial` because 50 items require separately governed Layer 3 interpretation. During the deterministic window the job ledger contained exactly 263 succeeded `layer2_acquisition_v2` jobs and no Layer 3 job types. `pipeline.search_refresh_signals` recorded 0 signals during the batch window. Runtime handoff metadata explicitly records `canonical_mutation_authorised=false` and `search_publication_authorised=false`.

Observed RMIT metrics are retained in `SYSTEM-METRICS.md`; they are evidence, not SLAs.

## Remaining acceptance gates

1. Complete RMIT same-token replay + fresh-Preview recent-dispatch dedupe through the authenticated scheduler surface; do not simulate/bypass browser identity merely to obtain a PASS.
2. Inspect the eligible `layer3_required` Evidence from UQ/RMIT and run only the existing qualified Course Layer 3 Evidence/profile/model/revalidation contract.
3. Keep generic scheduler Layer 3 disabled; preserve Layer 4 and Search/Publication separation.
4. Obtain fresh Codex review for final exact PR head and retain exact-head CI/UAT/runtime green before merge.
5. Only after those gates are clean may PR #72 be merged or a new accepted visible release be considered.

## Next AU qualification wave

After the UQ/RMIT acceptance and bounded Layer 3 gate are clean, qualify through normal source-profile / execution-policy / discovery-config governance in this order:

1. Monash University
2. The University of Melbourne
3. Australian National University
4. University of Technology Sydney
5. The University of Western Australia
6. The University of Sydney
7. UNSW Sydney

Cohort membership is not authority to manufacture missing configuration.

## Rollback / recovery

- Retain all failed/retry Evidence and immutable migration history.
- Any further runtime correction must be a new forward migration.
- PR #72 remains unmerged and draft.
- Accepted Pilot main and visible release remain unchanged.
- M2.5 remains paused; no Production Supabase project exists.
