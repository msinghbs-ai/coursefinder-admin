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

## Recovery sequence

1. Apply source-backed DB optimisation and indexes to Pilot.
2. Re-measure `evidence_page`, `layer_status_summary`, `platform_health` and concurrent admin-read behaviour against the unchanged 3000 ms/zero-5xx contracts.
3. Run the affected targeted deployed UAT only.
4. If targeted proof passes, re-nominate the bounded desktop+mobile integration gate.
5. Release/version-source reconciliation remains blocked until functional gates pass.

## Non-goals

- No Production change.
- No publication/search authority change.
- No role/rank change.
- No relaxation of UAT budgets or error assertions.
- No M2.5 reopening.
