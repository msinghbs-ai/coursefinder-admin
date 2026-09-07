# CF-CHG-20260907-239 — M2.4.5 CF-238 Performance, Runtime & Navigation Recovery

**Status:** ACTIVE / TARGETED RECOVERY  
**Milestone:** M2.4.5  
**Type:** RECOVERY / PERFORMANCE / RUNTIME / UAT CONTRACT RECONCILIATION  
**Date:** 7 September 2026

## Trigger

CF-238 bounded deployed integration run `34070394953` failed on desktop. The failed artifact was retained and inspected rather than rerun unchanged.

Recovered evidence identified three bounded defects:

1. `evidence_page` exceeded the governed 3000 ms RPC budget (`3544 ms` observed).
2. concurrent Administration reads produced PostgreSQL `57014 canceling statement due to statement timeout` as HTTP 500 for `dashboard`, `layer_status_summary`, `courses_page` and `platform_health`.
3. the permanent navigation helper still expected the superseded Administration label `Layer 2 sources`; current governed IA v1.6 / CF-089 requires `Extraction Profiles` while retaining the `layer2-sources` route key and backend contracts.

## Governing decisions

- Do **not** increase RPC budgets or statement timeout.
- Do **not** hide/swallow HTTP 500 responses.
- Do **not** revert the CF-089 `Extraction Profiles` terminology merely to satisfy a stale test label.
- Preserve Evidence operational-status, conflict, freshness, extraction-state, lineage, storage and role semantics.
- Preserve public `admin_read` signatures and role/rank authority.
- Optimise the default Evidence page by bounding enrichment to the requested page before expensive lineage/conflict work, with the existing generic Evidence implementation retained as the fallback for filtered/non-default requests.
- Add only supporting read indexes required by the existing 24-hour health/status projections; no data semantics change.
- Update the UAT navigation helper to the governed `Extraction Profiles` label. This is contract reconciliation, not weakening acceptance.

## Targeted recovery evidence — first CF-239 proof

Deployed targeted run `34076738567`, job `101604244225`, against Pilot commit `4a706d78c2d79eb4e236997bea288b7b8afe1cea` ran the permanent `performance-deployed.spec.mjs` suite.

Result: **2 PASS / 2 FAIL**.

- PASS — exact CRICOS lookup/detail/paging/browser-back interaction.
- PASS — common laptop/desktop width containment.
- FAIL — `evidence_page` returned HTTP `403` although its database work was fast. This proved an ACL call-chain defect, not a latency defect.
- FAIL — `layer2_ops_overview` remained above the governed `3000 ms` ceiling: `4654 ms`, then `5235 ms` on retry.

The failed run was not promoted and bounded integration was not re-nominated.

## Root-cause refinement

### Evidence 403 — implementation/security integration defect

`public.admin_read` remains `SECURITY INVOKER`. The new private Evidence fast helper had been routed correctly but did not carry the authenticated EXECUTE privilege required by that invoker chain. The helper itself retained its authentication/rank checks. The correction grants EXECUTE only to `authenticated` and `service_role` and keeps `public`/`anon` denied.

Lesson: an optimisation is not valid merely because the private SQL path is fast; the complete deployed caller → dispatcher → private-helper ACL chain must be verified before UAT nomination.

### Layer 2 overview — performance implementation defect

Profiling showed the accepted Layer 2 overview semantics were not the problem. Its large JSON projection repeatedly touched provider-attempt/run-item/evidence/course-discovery data and incurred material planning/JIT and buffer overhead. Disabling JIT materially reduced execution time but direct timing still sat too close to the `3000 ms` ceiling to provide deployed headroom.

The final recovery therefore preserves the existing governed projection and adds exact-predicate/covering indexes for its real predicates instead of rewriting the response semantics or increasing the budget.

A specific planner lesson was recorded: a logically similar partial-index predicate is not sufficient evidence that PostgreSQL can use it. The index predicate must be checked against the exact query form. In this incident, `metadata->>'layer'='2'` was not treated as an adequate substitute for the production predicate `coalesce(metadata->>'layer','')='2'` for recovery acceptance.

### Navigation label — contract/UAT defect

The stale test expectation was reconciled to the governed CF-089 label `Extraction Profiles`. The accepted route key/backend contracts were retained. Product terminology was not reverted to make the test pass.

## Corrective changes applied to Pilot runtime

The following source-backed migrations are confirmed applied in the Pilot Supabase runtime:

- `20260907023220` — `cf_239_m245_bounded_runtime_performance_recovery`
- `20260907024414` — `cf_239_targeted_performance_recovery_followup`
- `20260907024936` — `cf_239_layer2_overview_index_headroom`

The final headroom migration adds only indexes matching existing read predicates:

- Layer-2 Evidence summary index matching `coalesce(metadata->>'layer','')='2'`.
- selected course-discovery URL/course index.
- covering Layer-2 provider-attempt overview index.

No canonical data, Layer semantics, publication authority, role rank, API signature, payload budget or RPC budget was changed.

A direct unauthenticated SQL attempt to execute `security.admin_layer2_ops_read(...)` after deployment correctly returned `42501 authentication required`. That guard is retained and is not bypassed for benchmarking; the deployed authenticated browser/RPC test remains the acceptance authority.

## Lessons learned / permanent prevention controls

These lessons are now also embedded in the authoritative cross-chat Troubleshooting, Bug-Fix & Recovery Protocol so they apply to future CourseFinder recovery work:

1. Validate the full ACL call chain before routing an exposed invoker to a new private helper: intended authenticated EXECUTE, helper-level auth/rank enforcement, and explicit anon/public denial.
2. Profile the exact production query and predicate before creating a performance index; confirm actual use with `EXPLAIN (ANALYZE, BUFFERS)` where the governed auth boundary permits it.
3. Treat a performance budget as the acceptance ceiling, not the engineering target. A database result barely under `3000 ms` is not enough headroom for deployed RPC/browser execution.
4. Inspect JIT/planning time, buffer hits, repeated scans and wide-row work before rewriting a governed response contract.
5. Prefer planner/index/JIT corrections that preserve accepted semantics over duplicate or simplified projections.
6. Repository source is not deployed truth. Confirm every required migration/function/config change is present in runtime before spending another UAT run.
7. After a failed run, make one material corrective change and run the smallest intended proof; do not use repeated unchanged reruns as diagnosis.
8. Prove security and performance together whenever a read-path helper or dispatcher changes.
9. Do not spend bounded/full desktop+mobile acceptance capacity until the exact targeted defect gate passes.
10. When a test expectation is proven stale, reconcile the test to governed semantics; never weaken accepted product/data/security semantics for a green result.
11. Record failed run IDs, insufficient intermediate fixes and final deployed migration identities while the recovery is open so later chats do not repeat the same investigation.
12. Verify the intended execution/tool action before repeated operations; avoid noisy repeated reads when one schema/action discovery would resolve the next step.

## Recovery sequence

1. Apply source-backed DB optimisation and indexes to Pilot. — **DONE**
2. Re-measure affected paths against unchanged 3000 ms/zero-5xx contracts. — **TARGETED DEPLOYED PROOF REQUIRED**
3. Run the affected targeted deployed UAT only. — **NEXT GATE**
4. If targeted proof passes, re-nominate the bounded desktop+mobile integration gate.
5. Release/version-source reconciliation remains blocked until functional gates pass.

## Current gate state

- CF-239 targeted performance/security gate: **OPEN** pending a fresh deployed authenticated performance run after migration `20260907024936`.
- CF-238 bounded desktop+mobile integration: **OPEN / NOT RE-NOMINATED**.
- Release/version synchronisation: **BLOCKED until functional gates pass**.
- Production: **unchanged**.

## Rollback / reversion

The final headroom change is non-destructive and index-only. Its three indexes can be dropped if regression evidence requires reversion. The Evidence helper ACL/dispatcher correction can be reverted to the prior source-backed migration state. No canonical data mutation or authority change is required for rollback.

## Non-goals

- No Production change.
- No publication/search authority change.
- No role/rank change.
- No relaxation of UAT budgets or error assertions.
- No M2.5 reopening.
