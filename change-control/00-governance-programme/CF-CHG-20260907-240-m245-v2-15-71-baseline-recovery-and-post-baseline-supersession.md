# CF-CHG-20260907-240 — M2.4.5 v2.15.71 Baseline Recovery and Post-Baseline Supersession

**Status:** APPLIED — SOURCE BASELINE RESET / FRESH UI PASS / RUNTIME RECONCILIATION OPEN  
**Milestone:** M2.4.5  
**Date:** 7 September 2026  
**Authority:** User-directed recovery decision

## Decision

CourseFinder Pilot source is recovered to the last independently evidenced stable visible release before the subsequent recovery chain:

- visible release: **v2.15.71**;
- baseline commit: `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84`;
- baseline change: `CF-228 align deployed release currentness to v2.15.71`;
- historical Frontend Build `34033957287`: PASS;
- historical deployed UAT `34033957268`: PASS.

The prior restart target `8bc6960d05e5521ff6ae44ad0ee49e7c07ef80ff` / v2.15.72 is superseded by this decision.

## Fresh restored-source proof

After restoring Pilot `main` to `c9dbbfb...`:

- Frontend Build `34085535964`: **PASS**;
- deployed targeted UAT `34085535954`: **PASS**;
- deployed head: `c9dbbfb0f1bdbe63c28d68a27077357797b2ae84`;
- visible/source release target: **v2.15.71**.

This proves the restored UI/source is deployable and functionally passes the current targeted gate. It does not prove database migration parity because the Pilot database still contains later migrations.

## Preserved forensic history

The former Pilot main head was preserved before reset:

- former head: `fbf7cca96d9f64d1d95db4ccc780399549ebde4d`;
- forensic branch: `forensic/post-v2-15-71-scrapped-20260907`;
- previously retained recovery branch: `recovery/cf238-cf239-forensic-20260907`;
- previously retained v2.15.72 baseline branch: `recovery/m245-stable-baseline-20260907`;
- previously retained v2.15.66 investigation branch: `recovery/m245-v2-15-66-20260907`.

No forensic branch or failed UAT evidence is to be deleted or rewritten.

## Superseded post-v2.15.71 source range

Git comparison from `c9dbbfb...` to `fbf7cca...` reports **54 commits ahead / 0 behind**. All 54 commits are now **SUPERSEDED FOR REBUILD PURPOSES**. They remain available only as forensic/reference material and are not accepted as current M2.4.5 implementation.

The superseded range starts with `0e1e1e4069945565d74f47aba2261e9cb1885a8d` and extends through `fbf7cca96d9f64d1d95db4ccc780399549ebde4d`.

## Database drift beyond v2.15.71

The current Pilot Supabase migration history contains the following migrations that are absent from the restored v2.15.71 source baseline:

- `20260906205708` — `cf231_qs_inline_evidence_context`;
- `20260906235448` — `cf_232_layer_status_summary_role_safe_layer3_count`;
- `20260907002955` — `cf_235_layer4_public_wrapper_security_hardening`;
- `20260907003322` — `cf_236_preproduction_rpc_security_hardening`;
- `20260907023220` — `cf_239_m245_bounded_runtime_performance_recovery`;
- `20260907024414` — `cf_239_targeted_performance_recovery_followup`;
- `20260907024936` — `cf_239_layer2_overview_index_headroom`.

Therefore the current database is not migration-parity-equivalent to v2.15.71 even though the restored UI currently passes targeted deployed UAT.

## CF-231 inspection

`cf231_qs_inline_evidence_context` replaces only `public.svc_ranking_import_control_context(uuid)`.

Observed properties:
- remains `SECURITY DEFINER`;
- fixed search path `pg_catalog, ranking, pipeline`;
- EXECUTE denied to `public`, `anon`, and `authenticated`;
- EXECUTE granted only to `service_role`;
- adds retained inline QS Evidence payload lookup from `pipeline.evidence_artifacts.metadata->>'cf212_stage_1'` when `storage_path` uses `inline://`;
- adds source-resolution logic preferring exact edition then multi-year family.

Assessment: **LOW-RISK FUNCTIONAL CORRECTION / NOT PART OF BASELINE.** It does not expand browser authority. Because it is service-only and the restored UI already passes with it present, immediate rollback is not justified. Retain temporarily, but requalify separately if ranking acquisition is reintroduced.

## CF-232 inspection

`cf_232_layer_status_summary_role_safe_layer3_count` replaces `security.admin_layer_status_summary()`.

Observed properties:
- remains `SECURITY DEFINER`;
- requires authenticated identity and CourseFinder role rank >= 1;
- removes an internal call to curator-only `security.layer3_evidence_candidates_impl(200)` which caused rank-1 users to receive HTTP 500;
- directly counts the same eligible Layer 3 evidence population without weakening the curator-only detail helper;
- no publication/data authority change.

Assessment: **BENEFICIAL ROLE-SAFETY CORRECTION / RECOMMEND RETAIN.** Reverting would knowingly restore a rank-1 HTTP 500 defect. It should be treated as a candidate retained compatibility correction, not as accepted v2.15.71 baseline functionality.

## CF-235 inspection

`cf_235_layer4_public_wrapper_security_hardening` moves fifteen privileged Layer 4 implementations from exposed `public` into non-exposed `l4_api` and recreates same-signature public `SECURITY INVOKER` wrappers.

Observed live runtime properties:
- privileged implementations remain `SECURITY DEFINER` in `l4_api`;
- public wrappers are `SECURITY INVOKER`;
- `anon` EXECUTE is denied;
- `authenticated` and `service_role` EXECUTE are allowed;
- public RPC names/signatures are preserved;
- no intended Layer 4 decision, publication, scope-rule or confirmation semantics changed.

Assessment: **SECURITY HARDENING / STRONGLY RECOMMEND RETAIN.** Reverting would deliberately move privileged SECURITY DEFINER implementations back into exposed `public`, which is a security regression. This hardening should survive baseline recovery unless a targeted compatibility test proves otherwise.

## CF-236 inspection

`cf_236_preproduction_rpc_security_hardening` moves five Scholarship/statistics privileged implementations into non-exposed `admin_api`, recreates same-signature public `SECURITY INVOKER` wrappers, and fixes two Scholarship normalisation function search paths.

Observed live runtime properties:
- privileged implementations remain `SECURITY DEFINER` in `admin_api`;
- public wrappers are `SECURITY INVOKER`;
- `anon` EXECUTE is denied;
- `authenticated` and `service_role` EXECUTE are allowed;
- public signatures remain stable;
- `scholarship.normalise_first_party_url(text)` and `scholarship.normalise_title(text)` use fixed `pg_catalog` search paths.

Assessment: **SECURITY HARDENING / STRONGLY RECOMMEND RETAIN.** Rolling this back would recreate public SECURITY DEFINER exposure and mutable-search-path warnings without restoring any necessary v2.15.71 UI behaviour.

## CF-239 inspection and classification

CF-239 introduced a new Evidence default fast helper, Layer 2 overview helper, dispatcher rewrites, ACL follow-up, JIT-off execution and twelve supporting indexes. Several indexes are materially used in current plans.

Acceptance history:
- CF-238 bounded integration failed before CF-239;
- first CF-239 targeted recovery also failed;
- later CF-239 targeted performance run passed but retained a 3022 ms first-attempt course detail measurement;
- re-nominated bounded integration `34077935830` ultimately completed **FAILURE**.

Assessment: **SUPERSEDED / NOT ACCEPTED AS A UNIT.** Do not use either CF-239 or the immediately pre-CF-239 checkpoint as a safe baseline. Its individual indexes/helpers may later be reintroduced only after exact profiling and isolated proof.

## Current runtime security posture

Fresh Supabase Security Advisor after restored v2.15.71 UI deployment and with CF-231/232/235/236/239 still live reports only INFO-level `rls_enabled_no_policy` notices across the existing private-by-default/RPC-mediated schema pattern. No WARN/ERROR security advisor findings are present.

The INFO notices must not be 'fixed' by introducing permissive RLS policies without a separate governed decision.

## Retention/reversion recommendation

| Change | Classification | Recommendation |
|---|---|---|
| CF-231 | service-only ranking functional correction | RETAIN TEMPORARILY; requalify with ranking work |
| CF-232 | role-safe Layer Status correction | RETAIN |
| CF-235 | Layer 4 RPC security hardening | RETAIN |
| CF-236 | Scholarship/statistics RPC security hardening | RETAIN |
| CF-239 helper/dispatcher changes | failed recovery unit | REVERT/REBUILD FORWARD after isolated proof |
| CF-239 indexes | mixed, several actively used | DO NOT BULK DROP; assess index-by-index during forward reversion |

## Safe boundary decision

There is no trustworthy migration-version rollback point after v2.15.71 that should simply be labelled safe.

The accepted boundary is therefore **logical rather than a raw migration number**:

1. **Source/UI baseline:** v2.15.71 / `c9dbbfb...` — SAFE and freshly proven.
2. **Retained compatible runtime hardening/corrections:** CF-231, CF-232, CF-235, CF-236 — retained provisionally for safety/security, not promoted as baseline features.
3. **CF-239:** superseded and excluded from accepted baseline; remove its dispatcher/helper behaviour through explicit forward reconciliation rather than migration-history deletion.
4. **CF-239 indexes:** retain until exact query-plan review proves which can be safely dropped.

No destructive migration-history deletion is authorised. Any rollback must be an explicit forward reconciliation migration preserving canonical data and Evidence.

## Next governed action

Prepare a forward CF-241 runtime reconciliation that:

- restores `public.admin_read('evidence_page',...)` and `layer2_ops_overview` to the pre-CF-239 governed implementations;
- removes CF-239-only helper execution paths without touching canonical data;
- preserves CF-231, CF-232, CF-235 and CF-236 security/compatibility corrections;
- initially leaves CF-239 indexes in place, then tests planner usage and latency before considering index removals;
- runs targeted Evidence + Layer 2 + core performance proof against restored v2.15.71 UI;
- only after targeted PASS proceeds to bounded integration.

Production remains untouched. M2.5 remains paused.
