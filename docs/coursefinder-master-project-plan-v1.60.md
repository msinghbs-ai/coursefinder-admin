# CourseFinder Master Project Plan v1.60

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — AUTOMATED DEPLOYED UAT + ACCESS ADMIN ACCEPTED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.59.md`  
**Last consolidated:** 23 August 2026 07:39 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.39.md`  
**Running build:** `docs/coursefinder-running-build-v2.63.md`  
**Admin/PIM decisions:** `docs/coursefinder-admin-pim-design-decisions-v1.13.md`  
**Admin Guide:** `docs/coursefinder-pim-admin-guide-v1.14.md`

## Current programme position

- M1-PIM-FINALISATION — **CLOSED / PASS**.
- M1-PIPELINE-OPS (`CF-CHG-20260821-016`) — **CLOSED / PASS**.
- M1-EVIDENCE-UX (`CF-CHG-20260821-017`) — **CLOSED / PASS**.
- M1-DATA-QUALITY-READINESS (`CF-CHG-20260821-018`) — **CLOSED / PASS**.
- M1-UAT-HARNESS (`CF-CHG-20260822-019`) — **CLOSED / PASS**.
- Access Admin v1.0 (`CF-CHG-20260822-020`) — **CLOSED / PASS**.
- Data Quality concurrent/snapshot hardening (`CF-CHG-20260823-021`) — **CLOSED / PASS**.

Accepted operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

No release-control or Access Admin change collapses these authority boundaries.

## Current accepted implementation authority

Pilot:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Visible runtime marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

PIM Admin remains v2.12.

## Data Quality accepted model retained

CourseFinder reports readiness by governed domain rather than one authoritative equal-weight completeness percentage.

States remain:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`.

Present and legitimate zero are ready; not-applicable is excluded from the denominator. Missing later enrichment is not-yet-enriched. Source-null requires source-governed evidence. No value is manufactured to improve completeness.

### Aggregate execution

Aggregate readiness is now served from a private timestamped AU+NZ/AU/NZ snapshot refreshed every 15 minutes. Exception drill-down remains live and bounded/paged. The UI exposes snapshot computation/freshness.

This is an operational execution change only; accepted readiness semantics/counts remain unchanged.

## Access Admin accepted model

Platform Admin rank 6 now has a governed Users & Roles workspace for:

- user invite/create;
- governed role assignment/replacement;
- non-Platform-Admin role expiry;
- account disable/re-enable;
- private access-audit review.

Privileged Auth operations are mediated by a JWT-protected Edge Function. The service-role key remains server-side. Highest active unexpired role remains the authorization model.

Server invariants prevent self-lockout and last-Platform-Admin removal/disablement.

## Automated release acceptance

Pilot `main` promotion now automatically runs authenticated deployed acceptance on desktop and mobile and publishes SHA-bound statuses.

Final accepted run:

`32600027592`

- desktop: 3/3 PASS;
- mobile / Pixel 7: 3/3 PASS;
- 0 HTTP 5xx;
- 0 HTTP 4xx;
- 0 console/page errors;
- retained desktop/mobile evidence artefacts.

The critical path proves:

`login → Data Quality → regulatory fee → Source-null 191 → all four pages → canonical Course → private CRICOS Regulatory Snapshot Evidence`.

Desktop success cannot substitute for mobile success where responsive operation is in scope.

## Accepted technical baselines

- AU Providers / Courses: 1,546 / 26,648;
- NZ Providers / Courses: 409 / 6,457;
- AU+NZ Providers / Courses: 1,955 / 33,105;
- all-country Courses: 43,461;
- Campuses: 3,922;
- Scholarships: 4;
- Search Course Documents: 33,105;
- regulatory-fee states: 26,326 present / 191 source-null / 6,457 not-applicable / 131 zero;
- accepted AU Layer 1 adapter: `layer1-au-depth-v1.6.0`.

## Current architecture position

Database Architecture v2.10.39 records:

- existing `public.admin_read` browser boundary;
- private Access Admin audit/service helpers;
- JWT-protected privileged identity-management boundary;
- private Data Quality aggregate snapshot storage;
- server-side 15-minute snapshot scheduling;
- bounded Dashboard recent-activity execution.

Canonical Provider/Course/Campus/Scholarship identity and Search/publication semantics remain unchanged.

## Release performance position

The original cold Data Quality aggregate could exceed the authenticated 8-second statement timeout. The solution was architectural separation of heavy aggregate computation, not increasing the browser timeout.

Representative accepted browser reads are now well below the timeout, including while the scheduled snapshot recomputation is active.

## Governing references

- `CF-CHG-20260821-018` — Data Quality v1.0 — CLOSED / PASS;
- `CF-CHG-20260822-019` — UAT Harness v1.0 — CLOSED / PASS;
- `CF-CHG-20260822-020` — Access Admin v1.0 — CLOSED / PASS;
- `CF-CHG-20260823-021` — Data Quality snapshot/concurrent hardening — CLOSED / PASS;
- Database Architecture v2.10.39;
- Running Build v2.63;
- Admin/PIM Design Decisions v1.13;
- PIM Admin Guide v1.14.

## Baseline for subsequent work

Use:

- Master Project Plan v1.60;
- Running Build v2.63;
- Database Architecture v2.10.39;
- Admin/PIM Design Decisions v1.13;
- PIM Admin Guide v1.14;
- Pilot `e877e3e28cd281ff3751a70bc500eeb0d8f31963`.

Future work must preserve the now-accepted automatic desktop/mobile release gate. A failing governed fixture is investigated; it is not silently rewritten or waived.
