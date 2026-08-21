# CourseFinder M1-EVIDENCE-UX Technical Acceptance — 21 August 2026

**Change Control:** `CF-CHG-20260821-017`  
**Release:** PIM Admin v2.12 + Pipeline Ops v1.0 + Evidence v1.0  
**Pilot PR:** `msinghbs-ai/Coursefinder-Pilot#14`  
**Final candidate head:** `89c1c35ac7b10047588440c78820d5d5b2acc5ad`  
**Merged Pilot head:** `d036fa64c190db98ed44c33fe265d0b47860f97e`  
**Status:** **PASS — promoted after authenticated browser, role/security, deployment and performance acceptance**

## 1. Reconciliation

PASS.

The Evidence branch was synchronised with the accepted Pipeline Ops mainline before final UAT. The release retains the Pipeline Ops runtime entry point and accepted server-side Evidence entity-impact optimisation.

No accepted parallel work was overwritten.

## 2. Source/build/deployment

| Gate | Result |
|---|---|
| Evidence source isolated and reviewed in PR #14 | PASS |
| Pipeline Ops coexistence reconciled | PASS |
| GitHub `Pilot Frontend Build` run #99 / `32439107994` | PASS |
| Cloudflare Workers candidate deployment for `89c1c35a` | PASS |
| Candidate branch/commit preview produced and browser-tested | PASS |
| PR #14 promotion to Pilot `main` | PASS — merged as `d036fa64c190db98ed44c33fe265d0b47860f97e` |

The browser-tested candidate tree was promoted only after Pilot `main` was rechecked for incompatible parallel movement.

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

One cold Evidence-list execution measured ~3.64 seconds before buffers warmed. The immediate repeat measured ~55.7 ms. The cold result is retained as real evidence; the UI provides loading state rather than presenting a blank screen.

The prior legacy bulk observation expansion for the 103,315-observation snapshot took ~17.6 seconds. PIM v2.12 does not invoke that path automatically above 500 observations.

## 5. Role/security

| Check | Result |
|---|---|
| `public.admin_read` remains SECURITY INVOKER | PASS |
| rank-3 Curator can read Evidence | PASS |
| authenticated identity with no CourseFinder role | denied, SQLSTATE 42501 — PASS |
| UI hides Evidence below Curator rank 3 | PASS — source review |
| authenticated Platform Admin browser access | PASS — operator UAT |
| Evidence private Storage boundary retained | PASS |
| browser contract avoids raw private object path as an access mechanism | PASS |
| service-role credential remains server-side | PASS |
| signed object access expiry | 60 seconds |
| broad browser internal-schema CRUD introduced | No |

The Curator acceptance check was performed transactionally by resolving role rank 3 and reading one Evidence row through `public.admin_read`; the transaction was rolled back after the test. A separate authenticated no-role identity was rejected with SQLSTATE 42501. Because the server is the authority boundary and navigation is rank-gated, no Platform Admin role mutation or throwaway lower-role account was required merely to reproduce the same denial in presentation state.

Browser/network UAT additionally observed normal `admin_read` requests returning HTTP 200, `admin-evidence-access` CORS preflights returning HTTP 204 and signed-access fetches returning HTTP 200. The operator confirmed no private Storage/service-role credential exposure in inspected browser responses.

## 6. Functional scope

Source/build/browser review confirms implementation and acceptance for:

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
- signed preview/download invocation;
- Country-aware Source filter options.

The Country-aware Source defect found during browser UAT was corrected under the same Change Control. Server metadata now carries `country_code` for all 43 Evidence sources through:

`20260821021205 — m1_evidence_ux_country_source_filter_v1`

Browser re-test proved Australia exposes Australian sources only and Canada exposes Canadian sources only, while result rows remain correctly scoped.

## 7. Authenticated browser acceptance

| UAT item | Result |
|---|---|
| 1. role boundary | PASS — server denial below rank 3 + Curator rank-3 success + rank-gated navigation + authenticated Platform Admin browser |
| 2. authorised Evidence list/filter/paging interaction | PASS — operator confirmed; Country→Source defect corrected and re-tested |
| 3. canonical → Evidence deep-link interaction | PASS — operator confirmed |
| 4. evidence-bearing fee/intake/English → exact artifact interaction | PASS — operator confirmed |
| 5. Evidence → canonical return interaction | PASS — operator confirmed |
| 6. high-volume drawer user-perceived load behaviour | PASS — operator confirmed |
| 7. signed preview/download browser behaviour | PASS — operator confirmed |
| 8. no private Storage/service-role credential exposure in browser runtime/network | PASS — operator confirmed; network evidence observed |
| 9. Country-aware Source filter and remaining filter interaction | PASS — AU/CA browser re-test confirmed contextual options |
| 10. responsive desktop/narrow layout and no material overlap | PASS — operator confirmed |

Responsive acceptance showed the v2.12 / Pipeline Ops v1.0 / Evidence v1.0 candidate at narrow browser width with the Evidence drawer usable, Close / Preview / Download controls reachable, horizontally bounded lineage, vertically scrollable detail, stacked metadata cards and no material overlap or trapped controls.

## 8. Promotion and final verdict

Pilot `main` was rechecked before promotion and had not advanced incompatibly since the final candidate build.

PR #14 was promoted successfully and merged as:

`d036fa64c190db98ed44c33fe265d0b47860f97e`

Accepted release marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · governed`

**FINAL VERDICT: PASS.**

M1-EVIDENCE-UX has passed reconciliation, current-volume performance, role/security, CI, Cloudflare candidate deployment and authenticated browser acceptance. `CF-CHG-20260821-017` is CLOSED / PASS, PIM Admin Guide v1.11 is current, and programme governance advances to Master Project Plan v1.57 / Running Build v2.60.
