# CF-CHG-20260910-093 — Scheduled Workflow Orchestrator

**Status:** ACTIVE — UQ CONSEQUENTIAL ACCEPTANCE BLOCKED / CODEX PENDING  
**Initiated:** 2026-09-10 AEST  
**Reconciled:** 2026-09-12 AEST  
**Category:** 30-admin-pim-ux  
**Parent:** CF-CHG-20260910-092  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Active Pilot PR:** #72 (`m245/cf093-async-discovery-20260912`)  
**PR head:** `692ba7ef93e19d833963d96dab2558b340eaea17`  
**Visible accepted release:** v2.15.78

## Objective

Complete the bounded Scheduled Tasks run-on-demand contract for large AU Course Facts scopes without weakening Layer 1 authority, Layer 2 deterministic Evidence truth, Layer 3 Evidence/profile/model/revalidation governance, Layer 4 human resolution, Search/Publication separation or rank/ACL boundaries.

## Preserved authority and security boundaries

- Browser scheduler reads/actions remain on governed rank-gated RPC contracts.
- Layer 1 identity and source authority are unchanged.
- Layer 2 acquisition/discovery remains deterministic and Evidence-preserving.
- Layer 3 is not a generic scheduler side effect; it remains Evidence/profile/model/revalidation governed.
- Layer 4 remains explicit human resolution.
- Search/Publication and Website/Zoho admission are separate governed boundaries.
- No execution policies, source profiles or routes may be manufactured to obtain a PASS.
- No applied migration may be rewritten or retimestamped.

## Current repository / CI / deployment truth — 12 Sep 2026

Pilot PR #72 is open/draft and mergeable at exact head `692ba7ef93e19d833963d96dab2558b340eaea17` against main `63c7107cfce2d8f607fc378af4881d0ba28ca879`.

- Pilot Frontend Build `34657854675`: **PASS**.
- Cloudflare branch/commit preview for `692ba7e`: **deployment successful**.
- No Codex review submission or Codex review comment is present for PR #72 at reconciliation time.
- Therefore the exact-head Codex gate remains independently **BLOCKED/PENDING**.

PR #72 carries five forward-only async-discovery migrations plus targeted UAT. Pilot runtime already contains the same forward capability under immutable applied migration identities:

- `20260911231544` — `cf_093_scheduler_preview_bound_async_discovery`
- `20260911231600` — `cf_093_scheduler_async_binding_found_state_fix`
- `20260911231845` — `cf_093_scheduler_async_binding_cancel_failclosed`
- `20260911232205` — `cf_093_scheduler_retry_context_and_token_chain`
- `20260911232239` — `cf_093_scheduler_bound_discovery_context_retry`

PR source currently names the corresponding files `20260912010000` through `20260912010400`. The applied runtime identities are immutable. **Merge remains blocked until repository migration identity/currentness is reconciled without rewriting or retimestamping the applied Pilot history.**

## UQ 382-course consequential acceptance — FAILED CLOSED

Target: The University of Queensland, University scope, 382 Courses, existing qualified Course Facts profile `au-uq-course-catalogue`.

Fresh Preview token: `df7affe7-8d65-4527-a834-e8ac879afb06`.

Preview result:

- executable: true;
- catalogue: 382;
- queueable: 156;
- discovery: 226;
- invalid profile gaps: 0;
- execution-policy gaps: 0;
- route gaps: 0;
- oversized-profile gaps: 0;
- discovery-config gaps: 0;
- unsupported discovery: 0;
- exact scope fingerprint: `a048e79d19df8ceeb954f89aa3c5f9d7`.

Run-now governance reason: `CF-093 UQ 382-course consequential acceptance`.

The run was a real fresh dispatch, not recent-dispatch dedupe. Preview-bound historical-retry hardening worked: all 226 discovery Courses were retried after binding activation and prior unsuccessful dispositions remained retained Evidence.

Latest post-binding disposition by Course:

| Disposition | Courses |
|---|---:|
| current_page_not_found | 115 |
| identity_mismatch | 79 |
| ambiguous | 27 |
| likely_match with selected current URL | 5 |
| **Total** | **226** |

Seven bounded `layer2_discovery` Jobs processed the discovery set using the governed ordered profile routes. The final continuation was pg_net request `5759`, HTTP 500, worker `layer2-scope-discover-scheduled-v1.3.3`:

`layer2_scope_profile_batch_service: scheduler async discovery did not produce a current selected URL for every preview-bound discovery course`

This is the correct fail-closed result: no deterministic Layer 2 batch handoff occurred because every Preview-bound discovery Course did not have a selected current URL. The active binding has no `handoff_started_at` value. No direct status mutation or bypass was used.

### Classification

The former zero-progress defect is corrected: historical failed discovery dispositions no longer permanently suppress governed retry. The consequential acceptance now exposes a separate **source/profile/discovery qualification blocker**. A large proportion of UQ Courses still fail first-party search/result identity confirmation even though some current official program URLs can be found and five Courses passed CRICOS/detail verification.

Do not lower identity confirmation, treat ambiguous candidates as selected, fabricate URLs, or bypass the all-discovery-current requirement merely to pass acceptance.

## RMIT and Layer 3 disposition

RMIT 500-course proof is **NOT RUN** because the user-directed sequence requires UQ PASS first.

Generic scheduler Layer 3 remains disabled. Current Pilot Layer 3 runtime still has an existing pilot-qualified Course Evidence interpretation profile (`openrouter-free-router-v1`) for `course_description`, `official_course_url`, `delivery_mode` and `duration`, with benchmark ref `a8e4b6c8-8a7b-45b4-a8df-c5a3bb4e8407`. Its live-provider UAT marker remains pending. Because UQ deterministic Layer 2 handoff did not complete, this acceptance did not invoke generic Layer 3.

## Next qualification wave

After UQ and RMIT consequential proof is clean, qualify the next AU manual wave through normal source-profile / execution-policy / discovery-config governance in this order:

1. Monash University
2. The University of Melbourne
3. Australian National University
4. University of Technology Sydney
5. The University of Western Australia
6. The University of Sydney
7. UNSW Sydney

Do not create policies/config merely because a cohort member is in this wave.

## Exact next gate

1. Reconcile PR #72 migration source identities to the immutable Pilot-applied identities without changing applied runtime history.
2. Qualify/correct UQ first-party discovery/search and exact identity-confirmation behaviour using retained Evidence and real official-source examples; preserve fail-closed semantics.
3. Complete targeted regression proving historical retry remains enabled only for an active exact Preview binding.
4. Run a new UQ Preview only after the current failed binding is no longer active under the governed contract; rerun the full 382-course consequential acceptance.
5. On UQ PASS: prove same-token replay and fresh-preview recent-dispatch dedupe, then run RMIT 500-course proof.
6. Inspect resulting Layer 2 Evidence/Jobs, then perform only the existing Layer 3 profile/model/revalidation acceptance applicable to eligible Evidence.
7. Obtain fresh Codex review for the final exact PR head and require CI/UAT/runtime acceptance clean before merge/deploy.

## Rollback / recovery

- Do not delete or rewrite Pilot migration history.
- Do not delete failed UQ discovery Evidence or historical dispositions.
- Any runtime function correction must be a new forward migration.
- PR #72 remains unmerged; accepted Pilot main and visible release remain unchanged.
- M2.5 remains paused; no Production Supabase project exists.
