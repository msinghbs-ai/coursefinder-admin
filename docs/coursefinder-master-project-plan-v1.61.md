# CourseFinder Master Project Plan v1.61

**Status:** **AUTHORITATIVE PROGRAMME GOVERNANCE — PILOT ACCEPTED / PRODUCTION SECURITY GATE DEFINED**  
**Supersedes:** `docs/coursefinder-master-project-plan-v1.60.md`  
**Last consolidated:** 23 August 2026 11:40 AEST  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.39.md`  
**Running build:** `docs/coursefinder-running-build-v2.63.md`  
**Pilot-to-Production Plan:** `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`  
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
- Supabase leaked-password protection (`CF-CHG-20260823-022`) — **DEFERRED FOR PILOT / MANDATORY PRODUCTION GO-LIVE GATE**.

Accepted operational journey remains:

`Layer 1 Regulatory → Layer 2 Deterministic/Structured Enrichment → Layer 3 AI Suggestions → Layer 4 Human Resolution → Search Admission → Publication`

No security/release decision collapses these authority boundaries.

## Current accepted implementation authority

Pilot:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Visible runtime marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

PIM Admin remains v2.12.

## Pilot security exception — leaked-password protection

The current Pilot Supabase organisation remains on Free and the security advisor reports:

`auth_leaked_password_protection — Leaked Password Protection Disabled`

Supabase currently documents leaked-password protection as available on Pro Plan and above.

Programme decision:

- do not upgrade the Pilot solely for this control;
- retain the warning as a documented bounded non-production exception;
- do not represent the warning as fixed or the control as enabled;
- do not copy this exception into Production acceptance.

This decision does not invalidate the accepted Pilot runtime/UAT gates and does not change application/database behaviour.

## Mandatory Production security gate

CourseFinder Production must not receive final security sign-off or cutover approval until `CF-CHG-20260823-022` passes against the Production environment.

Required evidence includes:

1. Production Supabase project/environment identity recorded;
2. eligible plan/entitlement confirmed;
3. **Prevent use of leaked passwords** enabled in Supabase Auth;
4. Production security advisor no longer reports `auth_leaked_password_protection`;
5. controlled leaked-password rejection proven without retaining the password value;
6. compliant governed UAT identity authentication PASS;
7. Access Admin/RBAC regression PASS;
8. Production UAT evidence retained and linked to the Production cutover record.

An accepted Pilot exception does not satisfy or waive the Production gate.

See Pilot-to-Production Project Plan v1.10.

## Data Quality accepted model retained

CourseFinder reports readiness by governed domain rather than one authoritative equal-weight completeness percentage.

States remain:

`present / source_null / not_applicable / zero / suppressed / not_yet_enriched / stale / ambiguous / rejected`.

Present and legitimate zero are ready; not-applicable is excluded from the denominator. Missing later enrichment is not-yet-enriched. Source-null requires source-governed evidence. No value is manufactured to improve completeness.

Aggregate readiness remains served from a private timestamped AU+NZ/AU/NZ snapshot refreshed every 15 minutes. Exception drill-down remains live and bounded/paged.

## Access Admin accepted model

Platform Admin rank 6 retains governed Users & Roles administration for user create/invite, role assignment/replacement, non-Platform-Admin expiry, disable/re-enable and private access-audit review.

Privileged Auth operations remain mediated by a JWT-protected server boundary; service-role credentials remain server-side. Server invariants prevent self-lockout and last-Platform-Admin removal/disablement.

Production must revalidate this behaviour against Production identities during the Production security gate.

## Automated release acceptance

Pilot `main` promotion automatically runs authenticated deployed acceptance on desktop and mobile and publishes SHA-bound statuses.

Final accepted Pilot run:

`32600027592`

- desktop: 3/3 PASS;
- mobile / Pixel 7: 3/3 PASS;
- 0 HTTP 5xx;
- 0 HTTP 4xx;
- 0 console/page errors.

The existing Pilot gate remains accepted. Production candidate deployment must receive its own environment-specific release/security acceptance before cutover.

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

## Architecture position

Database Architecture v2.10.39 remains authoritative. `CF-CHG-022` changes environment/release policy only; no schema, canonical identity, RPC, Search/publication or UI contract changed.

Therefore this decision does **not** bump Database Architecture, Running Build, Admin/PIM Decisions, PIM Admin Guide or visible UI version.

## Governing references

- `CF-CHG-20260821-018` — Data Quality v1.0 — CLOSED / PASS;
- `CF-CHG-20260822-019` — UAT Harness v1.0 — CLOSED / PASS;
- `CF-CHG-20260822-020` — Access Admin v1.0 — CLOSED / PASS;
- `CF-CHG-20260823-021` — Data Quality snapshot/concurrent hardening — CLOSED / PASS;
- `CF-CHG-20260823-022` — leaked-password protection — DEFERRED FOR PILOT / PRODUCTION GATE;
- Pilot-to-Production Project Plan v1.10;
- Database Architecture v2.10.39;
- Running Build v2.63;
- Admin/PIM Design Decisions v1.13;
- PIM Admin Guide v1.14.

## Baseline for subsequent work

Use:

- Master Project Plan v1.61;
- Pilot-to-Production Project Plan v1.10;
- Running Build v2.63;
- Database Architecture v2.10.39;
- Admin/PIM Design Decisions v1.13;
- PIM Admin Guide v1.14;
- Pilot `e877e3e28cd281ff3751a70bc500eeb0d8f31963`.

The current Pilot leaked-password warning is accepted only as a documented non-production exception. **Production cutover remains contingent on `CF-CHG-022` PASS.**