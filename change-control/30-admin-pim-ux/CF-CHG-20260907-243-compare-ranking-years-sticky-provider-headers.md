# CF-CHG-20260907-243 — Compare ranking years and sticky Provider headers

**Status:** CLOSED / PASS  
**Date:** 7 September 2026  
**Milestone:** M2.4.5  
**Scope:** Pilot Admin UI only  

## Trigger

User UAT identified three Compare UI defects after v2.15.73 acceptance:

1. QS and THE did not present clearly independent ranking-year controls in their own ranking sections.
2. The shared `Current snapshot` / `Multi-year trend` controls still applied to the QILT/PRISMS comparison experience and were not required.
3. University/Provider identity headers did not remain reliably frozen while QILT and PRISMS comparison content scrolled.

## Correction

- Removed the shared snapshot/trend mode from Compare.
- QILT retains an explicit year selector.
- QS and THE now render as independent ranking sections.
- Each ranking system has its own edition selector and its own `Multi-year` option.
- Changing QS edition does not change THE edition, and vice versa.
- Single-edition selection renders the selected publisher observation; `Multi-year` renders that publisher's retained edition history.
- QILT and PRISMS University/Provider identity headers are explicitly sticky while comparison content scrolls.
- Ranking Provider identity headers use the same sticky identity treatment.

## Semantics preserved

No database migration or read-contract change was required. The correction does not alter:

- QILT source grain or outcome semantics;
- PRISMS source grain or student-flow semantics;
- QS/THE ranking identity, edition or Provider-equivalence semantics;
- Evidence or source attribution;
- role/rank, RLS or private Storage boundaries;
- publication, Search, Website or Zoho admission;
- Production configuration or runtime.

## Implementation and acceptance

Functional bugfix merged to Pilot `main`:

- `ab8126c06359d480cd1fe7552ab61ce4da760302`

Functional candidate evidence:

- focused contract/build run `34097212144`: PASS;
- normal PR build/browser smoke `34097318178`: PASS;
- deployed Cloudflare UAT `34097458830`: PASS.

Post-functional release-currentness synchronization:

- visible release: **v2.15.74**;
- final Pilot `main`: `0475dc5dc88a7f3b568a5151e6fd8d94af411924`;
- merged-head frontend build/browser smoke `34097989443`: PASS;
- merged-head deployed Cloudflare UAT/currentness `34097989441`: PASS.

The deployed workflow's separate mobile sub-gate was not selected by the targeted resolver; this change is a focused Compare correction and does not alter the previously accepted responsive foundation.

## Rollback

If rollback is required, revert the functional Compare commit and the subsequent v2.15.74 release-currentness commit together, returning to the accepted v2.15.73 state. No database rollback is required.

## Boundaries

- CF-241 remains reserved for the separate CF-239 forward runtime reconciliation.
- CF-242 remains the accepted v2.15.73 Scholarship/Statistics/Rankings/Provider Compare package.
- M2.4.5 remains active for its other recorded pre-production gates.
- M2.5 remains paused at P0.
- Production was not touched.
