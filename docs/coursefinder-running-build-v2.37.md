# CourseFinder Running Build v2.37

**Status:** CURRENT RUNNING BUILD  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-running-build-v2.36.md`  
**Architecture:** `docs/coursefinder-database-architecture-v2.10.34.md`  
**Master plan:** `docs/coursefinder-master-project-plan-v1.33.md`  
**Admin/PIM design:** `docs/coursefinder-admin-pim-design-decisions-v1.10.md`

## Build delta

The serial data gate remains `M1-L1-AU-CRICOS-COMPLETENESS`. The bounded `M1-L2-AU-COURSE-FACTS` pre-stage from v2.36 remains deferred and unapplied until that prerequisite passes.

In parallel, **M1-PIM-HARDENING has passed** its operational/security gate on `coursefinder_Pilot` without changing canonical Provider/Course identity or Search admission.

## Serial AU state retained

- Providers: 1,546
- active Courses: 26,648
- missing mapped Study Level: 2,281
- missing canonical campus relationship: 34
- Search Documents: 33,105
- Search `has_fee=true`: 0

The v2.36 Course Facts pre-stage remains valid:
- exact CRICOS-coded Provider/Course mapping only;
- Provider-current tuition semantics kept separate from CRICOS registered fees;
- temporary Layer 2 catalogue rows removed after UAT;
- source qualification remains deferred;
- `apply_admitted=false` and `search_admitted=false`.

## M1-PIM-HARDENING — PASS

Implemented and verified:
- one promoted browser read RPC: `public.admin_read(text,jsonb)`;
- `public.admin_read` is `SECURITY INVOKER`;
- private role-enforcing implementation uses `security.current_role_rank()`;
- all legacy `public.ui_*` `SECURITY DEFINER` bridges are no longer executable by `anon` or `authenticated`;
- obsolete public compatibility views are no longer readable/writable by browser roles;
- Provider/Course/Campus detail exposes governed source/evidence/history context;
- Completeness/readiness is shown as governance state and remains separate from Search admission;
- Scholarship detail preserves relational identifiers/cycles/windows/scopes/criteria/tiers/coverage;
- CRICOS registered-total-course fees and current Provider fees are separate API/UI concepts;
- evidence Storage remains private with no generic browser object policy.

Role thresholds:
- Viewer+ — Dashboard, Provider, Course, Campus, Completeness and Scholarship reads;
- Curator+ — Evidence and Review Queue;
- Pipeline Operator+ — Jobs and Regulatory Sources;
- PIM Admin+ — Attribute/PIM governance;
- Platform Admin — privileged Layer 1 controls remain separately governed.

Detailed UAT: `docs/uat/m1-pim-hardening-gate-2026-08-19.md`.

## Fee provenance UAT

On an AU CRICOS Course with Layer 1 fee data, governed Course detail returned:
- `cricos_registered`: 3 rows;
- basis: `registered_total_course`;
- `provider_current`: 0 rows.

The Admin UX therefore shows the CRICOS amount as regulatory total-course cost and an explicit empty state for current Provider fee. It does not annualise, substitute or relabel the CRICOS value.

## Security advisor posture

The previous browser-executable SECURITY DEFINER warnings are cleared.

Remaining security-advisor classes:
- INFO `rls_enabled_no_policy` on closed internal schemas — retained as intentional deny-by-default architecture; browser roles have no direct internal table grants;
- WARN leaked-password protection disabled — the owning Supabase organisation is on Free, while that Auth control requires Pro or above, so it is unsupported on the current plan rather than waived.

## Repository / migration parity

- `supabase/production-migrations/055_pim_operational_security_gate.sql`
- `src/supabase.js`
- `src/main.jsx`
- `docs/coursefinder-admin-pim-design-decisions-v1.10.md`
- `docs/uat/m1-pim-hardening-gate-2026-08-19.md`

## Current gates

**Serial immediate primary:** `M1-L1-AU-CRICOS-COMPLETENESS`.

Only after it passes may `M1-L2-AU-COURSE-FACTS` reactivate authoritative source capture and APPLY UAT.

**Parallel Admin/PIM lane:** `M1-PIM-HARDENING` — **PASS / complete**.
