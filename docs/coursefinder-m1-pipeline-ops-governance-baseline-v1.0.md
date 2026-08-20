# CourseFinder M1-PIPELINE-OPS Governance Baseline v1.0

**Status:** **AUTHORITATIVE WORKSTREAM ENTRY POINT — GOVERNANCE BLOCKER RESOLVED**  
**Date:** 21 August 2026  
**Change Control:** `CF-CHG-20260821-016`

## Purpose

This document fixes the exact starting baseline for `M1-PIPELINE-OPS` so the workstream does not rely on stale chat context or contradictory predecessor status text.

## Exact read order

Read these current documents before any Pipeline Operations implementation:

1. `PROJECT_INSTRUCTIONS.md`
2. `change-control/README.md`
3. `change-control/REGISTER.md`
4. `docs/coursefinder-master-project-plan-v1.55.md`
5. `docs/coursefinder-running-build-v2.58.md`
6. `docs/coursefinder-database-architecture-v2.10.38.md`
7. `docs/coursefinder-admin-pim-design-decisions-v1.10.md`
8. `docs/coursefinder-pim-admin-guide-v1.9.md`
9. `docs/uat/coursefinder-pim-admin-v2.11-final-browser-acceptance-2026-08-20.md`
10. `change-control/80-uat-release-operations/CF-CHG-20260821-016-m1-pipeline-ops-governance-baseline.md`

## Current implementation references

At this handoff:

- governance/migration mirror repository: `msinghbs-ai/coursefinder-admin`;
- deployed Pilot UI repository: `msinghbs-ai/Coursefinder-Pilot`;
- accepted deployed Pilot head: `b3867cc89bbfd3f76def01993a70868318016ef0`;
- accepted visible release marker: `PIM Admin v2.11 · governed`.

The workstream must recheck both repositories and live Supabase immediately before any material change. These references are a starting point, not permission to overwrite newer parallel work.

## Supersession and historical-status rules

The following documents are still useful evidence but are **not** the current status authority:

- `docs/coursefinder-pim-admin-guide-v1.8.md` — contains pre-v2.11 deployed-browser blocker text; superseded by v1.9;
- `docs/uat/coursefinder-m1-pim-finalisation-uat-2026-08-20.md` — valid technical point-in-time UAT, but its browser-BLOCKED verdict predates and is superseded for current status by the final v2.11 browser acceptance UAT;
- predecessor Admin/PIM Change Controls containing old browser-pending language — the common PIM browser gate was closed by `CF-CHG-20260820-015`; any residual Pipeline-specific acceptance is carried by `CF-CHG-20260821-016`.

Historical evidence must not be deleted merely because a later gate supersedes its status.

## Overlapping Change Control state

| Change | Current state | Pipeline Ops effect |
|---|---|---|
| `CF-CHG-20260820-006` Evidence provenance | CLOSED / PASS | preserve private Evidence/provenance semantics when linking Source/Job/Evidence |
| `CF-CHG-20260820-013` Operations role boundary | CLOSED / PASS | inherit rank-4 Pipeline Operator boundary and safe Sources projection; residual Pipeline-specific acceptance transferred to `016` |
| `CF-CHG-20260820-015` PIM finalisation/browser acceptance | CLOSED / PASS | inherit deployed v2.11, `admin_read`, security and browser-runtime baseline |
| `CF-CHG-20260821-016` M1 Pipeline Ops | PROPOSED — baseline resolved | owns new Pipeline Operations changes and their UAT |

There is no competing open `M1-PIPELINE-OPS` Change Control on `main` at this baseline.

## Accepted Pipeline security/read boundary

The current accepted contract is:

```text
Authenticated Admin browser
  -> public.admin_read(operation, args)
  -> server-side role/rank checks
  -> bounded Pipeline operational reads
```

For Pipeline Control / Jobs / Sources the minimum role is Pipeline Operator, rank 4.

The browser must not receive hidden source credentials/adapter secrets and must not regain broad direct execution of legacy `public.ui_*` SECURITY DEFINER helpers.

## Multi-workstream dispatcher rule

`public.admin_read` is a shared integration point. Database Architecture v2.10.38 explicitly requires replacement/extension migrations to preserve independently accepted Evidence and Pipeline routed branches rather than silently overwriting unrelated operations.

Any Pipeline Ops dispatcher change must therefore prove composition with the currently accepted route set.

## Pipeline action boundary

Current accepted PIM documentation provides read-oriented Pipeline visibility. Retry, replay, cancel, schedule, enable/disable, source mutation or other operational writes are not implicitly authorised by the existing read contract.

If added, each action requires:

- explicit governed server action;
- Pipeline Operator or stricter server-side role check as appropriate;
- deterministic/idempotent or explicitly replay-safe behaviour;
- audit/change-history evidence;
- disabled/busy/double-click protection;
- bounded error/retry UX;
- no direct browser canonical mutation.

## Workstream state

**Governance baseline: RESOLVED.**  
**M1-PIPELINE-OPS: READY FOR CURRENT-STATE TECHNICAL RECONCILIATION.**

No production Pipeline or permission change has been made by this governance reconciliation.
