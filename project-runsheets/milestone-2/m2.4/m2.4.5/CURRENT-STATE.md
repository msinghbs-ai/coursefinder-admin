# M2.4.5 CURRENT STATE

**Status:** ACTIVE / PRE-PRODUCTION HARDENING — CF-093 LARGE-UNIVERSITY ACCEPTANCE BLOCKED  
**Reconciled:** 2026-09-12 AEST  
**Accepted Pilot main:** `63c7107cfce2d8f607fc378af4881d0ba28ca879`  
**Visible accepted release:** v2.15.78  
**Pilot Supabase:** `fxcwkweaxjtknorudmwp`  
**Production:** not provisioned; M2.5 remains PAUSED at P0

## Active implementation candidate

- Pilot PR #72: `CF-093: complete Preview-bound async Layer 2 discovery`.
- Branch: `m245/cf093-async-discovery-20260912`.
- Exact head: `692ba7ef93e19d833963d96dab2558b340eaea17`.
- Base main: `63c7107cfce2d8f607fc378af4881d0ba28ca879`.
- PR state: OPEN / DRAFT / mergeable.
- Pilot Frontend Build `34657854675`: PASS.
- Cloudflare exact-head branch/commit preview: deployed successfully.
- Fresh Codex review for PR #72 exact head: no result present; merge gate remains pending.

## Pilot migration/runtime reconciliation

Pilot runtime already contains the PR #72 async-discovery capability under immutable applied migration identities:

- `20260911231544` `cf_093_scheduler_preview_bound_async_discovery`
- `20260911231600` `cf_093_scheduler_async_binding_found_state_fix`
- `20260911231845` `cf_093_scheduler_async_binding_cancel_failclosed`
- `20260911232205` `cf_093_scheduler_retry_context_and_token_chain`
- `20260911232239` `cf_093_scheduler_bound_discovery_context_retry`

PR #72 source currently uses `20260912010000`–`20260912010400` filenames for those logical changes. Runtime history must not be rewritten or retimestamped. Repository migration identity/currentness must be reconciled before merge.

## UQ 382-course consequential acceptance — FAILED CLOSED

Fresh governed Preview token: `df7affe7-8d65-4527-a834-e8ac879afb06`.

Preview proved:

- 382 scoped Courses;
- 156 queueable;
- 226 discovery;
- executable=true;
- zero invalid-profile, execution-policy, route, oversize, unsupported-discovery or discovery-config gaps;
- scope fingerprint `a048e79d19df8ceeb954f89aa3c5f9d7`.

A fresh Run now was dispatched after the 10-minute recent-dispatch window had cleared. This was not a deduplicated replay.

The forward retry hardening worked: all 226 discovery Courses were retried despite historical unsuccessful dispositions, with history retained. Final latest post-binding disposition by Course:

| Disposition | Courses |
|---|---:|
| current_page_not_found | 115 |
| identity_mismatch | 79 |
| ambiguous | 27 |
| likely_match / selected current URL | 5 |
| **Total** | **226** |

Seven bounded `layer2_discovery` Jobs processed the retry set. pg_net requests `5753`–`5758` returned HTTP 200; terminal request `5759` returned HTTP 500:

`layer2_scope_profile_batch_service: scheduler async discovery did not produce a current selected URL for every preview-bound discovery course`

No deterministic Layer 2 batch handoff occurred. The binding remains fail-closed with no `handoff_started_at`. There is no public/security scheduler-cancel RPC, so no direct table mutation was used to force cancellation.

### Defect classification

The former zero-progress condition caused by treating historical unsuccessful dispositions as permanently attempted is corrected. The new consequential run exposes a separate UQ source-profile/discovery/identity qualification problem. The accepted security/identity rule is not to be weakened to convert ambiguous/mismatched candidates into selected URLs.

## RMIT and Layer 3

- RMIT 500-course acceptance: **NOT RUN** because UQ did not pass.
- Generic scheduler Layer 3 remains disabled.
- Existing pilot-qualified Course Layer 3 profile `openrouter-free-router-v1` remains limited to its governed task classes and benchmark/revalidation contract; live-provider UAT is still a separate gate.
- No Layer 3 invocation was made from the failed UQ scheduler run.

## Next AU qualification wave

After UQ and RMIT pass, prepare normal qualification in this order without fabricated config:

1. Monash University
2. The University of Melbourne
3. Australian National University
4. University of Technology Sydney
5. The University of Western Australia
6. The University of Sydney
7. UNSW Sydney

## Exact next gate

1. Reconcile PR #72 repository migration identities with immutable applied Pilot history.
2. Use retained UQ discovery Jobs/Evidence and official first-party examples to qualify/correct the UQ discovery/search and identity-confirmation contract.
3. Preserve exact Preview binding, historical retry, CRICOS/detail verification and fail-closed all-discovery-current semantics.
4. When the failed binding is no longer active under the governed contract, run a new UQ 382-course Preview and consequential acceptance.
5. Only on UQ PASS: same-token replay + fresh-preview dedupe, then RMIT 500-course proof.
6. Only after clean Layer 2 proof: bounded Layer 3 acceptance through the existing profile/model/revalidation contract.
7. Require exact-head Codex + CI/UAT/runtime acceptance before merge/deploy.

## Standing boundaries

M2.4.4 remains CLOSED/PASS/FROZEN. Layer 1 authority, deterministic Layer 2 Evidence truth, Layer 3 revalidation governance, Layer 4 human resolution and Search/Publication separation remain unchanged. No Production Supabase project exists.
