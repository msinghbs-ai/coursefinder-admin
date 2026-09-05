# CF-CHG-20260906-219 — Scholarship Acquisition Coverage Wave

**Status:** ACTIVE / BOUNDED PILOT EXECUTION  
**Milestone:** M2.4.5 — Scholarship Acquisition & PIM Completion  
**Date:** 6 September 2026

## Review baseline

Repository/runtime review confirms H3 Scholarship PIM grid/filter/order maturity is already CLOSED / TARGETED PASS under CF-208. H4 Scheduler/Jobs and H5/H6 source-backed candidate/publication controls are also closed. The remaining Scholarship priority is acquisition/coverage rather than another PIM-grid implementation.

Live Pilot baseline immediately before this wave:

- canonical Scholarships: 273 across 90 Providers;
- published: 0 (publication remains intentionally disabled);
- candidate records: 1,359 across 46 Providers;
- first-party Evidence acquired: 95 records across 17 Providers;
- candidate needs-review: 515;
- candidate acquired: 168;
- AU country scope: 1,546 Providers, 22 executable governed first-party Scholarship catalogue profiles;
- NZ country scope: 409 Providers, 0 executable Scholarship catalogue profiles.

## Decision

Proceed with the existing governed country/university Scholarship acquisition contract rather than create another scraper control plane.

Execution order:

1. Run a bounded AU acquisition wave across the 22 already-qualified first-party Scholarship catalogue profiles.
2. Preserve Evidence-first catalogue → candidate/detail workflow and existing semantic exclusion/reconciliation gates.
3. Do not authorise publication, Search admission or consumer cutover.
4. Use the existing scheduler/job lease/recovery controls; no generic replay/reset bypass.
5. Treat NZ as a source-profile qualification gap: do not dispatch until first-party Scholarship catalogue sources/routes are qualified.
6. Measure candidate/Evidence/canonical deltas after the wave and prioritise provider-specific detail acquisition from the resulting queue.

## Pilot execution

Request ID: `0d5df8f9-894f-476c-b68d-2b83b2a3dc90`.

Start result:

- 22 jobs queued;
- first dispatch: 20;
- follow-up scheduler tick dispatched remaining 2;
- no dispatch failures or retry exhaustion at dispatch stage;
- publication_changed = false.

Observed during execution:

- 21/22 Provider jobs succeeded at the latest check;
- University of Wollongong remained running at that checkpoint with no recorded error;
- candidate population increased from 1,359 to 1,554 while the wave was still settling;
- first-party catalogue Evidence was captured for the qualified providers through existing shared-fetch/Evidence lineage;
- examples of source-backed catalogue fanout observed: ANU, CDU, Charles Sturt, Curtin, Deakin, Federation, Flinders, Griffith, Macquarie, Monash, QUT, RMIT, Swinburne, Melbourne, UQ, Sydney, UWA, UTS and UNSW.

The catalogue wave may discover candidate scholarship links without immediately creating canonical Scholarship rows. That is expected: candidate detail qualification/reconciliation remains a separate governed step.

## Security / publication boundary

- Existing service-role acquisition service is used; browser users do not receive direct private-schema table access.
- Canonical mutation remains governed by the established Scholarship detail/reconciliation workflow.
- Publication is explicitly not authorised by this wave.
- No Production Supabase resource is created or modified.

## Next gate

CF-219 closes only after:

1. all 22 AU jobs are terminal or deliberately recovered;
2. post-wave Provider/candidate/Evidence totals are reconciled;
3. high-value candidate-detail queue is identified and executed in bounded provider cohorts;
4. NZ first-party Scholarship catalogue profile qualification plan is recorded;
5. targeted runtime/UAT evidence confirms no publication side effect and truthful Jobs/Admin statistics.
