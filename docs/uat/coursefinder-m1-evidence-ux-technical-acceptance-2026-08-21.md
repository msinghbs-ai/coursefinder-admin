# CourseFinder M1-EVIDENCE-UX Technical Acceptance — 21 August 2026

**Change Control:** `CF-CHG-20260821-017`  
**Candidate:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0  
**Pilot PR:** `msinghbs-ai/Coursefinder-Pilot#14`  
**Candidate head:** `ab682a561a3121c1ca51c0fd3d9b427c539eb049`  
**Status:** **BLOCKED — authenticated interactive browser acceptance outstanding**

## 1. Reconciliation

PASS.

The Evidence branch was synchronised with the accepted Pipeline Ops mainline before final UAT. The candidate retains the Pipeline Ops runtime entry point and accepted server-side Evidence entity-impact optimisation.

No accepted parallel work was intentionally overwritten.

## 2. Source/build/deployment

| Gate | Result |
|---|---|
| Evidence candidate source isolated in PR #14 | PASS |
| Pipeline Ops coexistence reconciled | PASS |
| GitHub `Pilot Frontend Build` run #97 / `32432274493` | PASS |
| Cloudflare Workers PR deployment for `ab682a56` | PASS |
| Candidate branch/commit preview produced | PASS |

Cloudflare's PR integration reported a successful deployment for the reconciled commit and produced both commit and branch preview URLs.

## 3. Live Evidence corpus

Observed current corpus:

- 1,567 Evidence artifacts;
- 43 represented sources;
- 1,113 represented acquisition jobs;
- 387 artifacts with extraction;
- 1,180 missing-extraction artifacts;
- one artifact with source-null observations;
- 1,540 private Storage objects;
- a largest observed regulatory artifact with 103,315 observations/entity links.

Claims/reviews/conflicts/supersession remain legitimate empty-state areas where the Pilot has no persisted rows.

## 4. Performance

Current post-Pipeline-Ops measurements:

| Operation | Result |
|---|---:|
| `admin_read('evidence_page')`, 50 rows, warm | ~55.7 ms |
| `admin_read('evidence_detail')`, high-volume artifact | ~181.0 ms |
| `security.admin_evidence_entities`, first 100 of 103,315 links | ~459.1 ms |
| Entity-link temp spill | 0 temp blocks |

One cold Evidence-list execution measured ~3.64 seconds before buffers warmed. The immediate repeat measured ~55.7 ms. The cold result is retained as real evidence; the candidate provides loading state rather than presenting a blank screen.

The prior legacy bulk observation expansion for the 103,315-observation snapshot took ~17.6 seconds. Candidate v2.12 does not invoke that path automatically above 500 observations.

## 5. Role/security

| Check | Result |
|---|---|
| `public.admin_read` remains SECURITY INVOKER | PASS |
| rank-3 Curator can read Evidence | PASS |
| authenticated identity with no CourseFinder role | denied, SQLSTATE 42501 — PASS |
| Evidence private Storage boundary retained | PASS |
| browser contract avoids raw private object path | PASS by source/server contract review |
| service-role credential remains server-side | PASS |
| signed object access expiry | 60 seconds |
| broad browser internal-schema CRUD introduced | No |

The Curator acceptance check was performed transactionally by resolving role rank 3 and reading one Evidence row through `public.admin_read`; the transaction was rolled back after the test.

## 6. Functional candidate scope

Source/build review confirms implementation for:

- full operational filters;
- Evidence grid/detail lineage;
- Source and acquisition-job context;
- content hash/snapshot/storage metadata;
- observation and entity lineage;
- explicit source-null/missing-extraction/stale/conflict/rejected/superseded states;
- Change Control/review empty states;
- canonical entity → Evidence navigation;
- Evidence → canonical navigation;
- exact nested value → Evidence navigation when an `evidence_id` exists;
- high-volume observation guard;
- signed preview/download invocation.

## 7. Remaining authenticated browser gate

The following require a signed-in interactive browser/session against the Cloudflare candidate runtime and have not been claimed as completed by this technical environment:

1. role <3 navigation/RPC denial observed from the actual browser;
2. Curator Evidence list/filter/paging interaction;
3. canonical → Evidence deep-link interaction;
4. evidence-bearing fee/intake/English → exact artifact interaction where data exists;
5. Evidence → canonical return interaction;
6. high-volume drawer user-perceived load behaviour;
7. signed preview/download browser/network behaviour;
8. no private Storage path/service-role credential in browser network/runtime;
9. responsive desktop/narrow layout interaction;
10. no unexplained browser 4xx/5xx/stale-request interaction regression.

The available environment can inspect repository source, CI, Cloudflare deployment evidence and live authenticated server contracts, but it does not provide an interactive authenticated browser/session to execute this final gate.

## 8. Verdict

**BLOCKED WITH EVIDENCE.**

All executable technical gates pass. Do not promote PR #14 to accepted production solely on this document. Complete the authenticated interactive browser gate, then update `CF-CHG-20260821-017`, this UAT document, the Change Control Register and PIM Admin Guide v1.11 to CLOSED / PASS before production acceptance.
