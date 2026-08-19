# CourseFinder Admin / PIM Design Decisions v1.10

**Status:** AUTHORITATIVE CROSS-CHAT UX / OPERATING CONTRACT  
**Date:** 19 August 2026  
**Supersedes:** `docs/coursefinder-admin-pim-design-decisions-v1.9.md`

v1.10 retains all accepted v1.9 UX decisions and adds the M1-PIM-HARDENING operational/security contract.

## Governed browser data boundary

The Admin browser must not query canonical/internal schemas or legacy compatibility views directly.

The browser read boundary is:

`Supabase Auth session → public.admin_read (SECURITY INVOKER) → private security.admin_read_impl → governed internal read bridge → canonical/relational tables`

Rules:
- `public.admin_read` is the only promoted browser read RPC for this Admin generation.
- Browser-executable public RPCs must not use `SECURITY DEFINER`.
- Privileged implementation functions live outside the public browser API surface and must enforce server-side CourseFinder roles.
- Legacy `public.ui_*` SECURITY DEFINER bridges are service-role only.
- Obsolete compatibility views are not granted to `anon` or `authenticated`.
- Client-side role-aware navigation is presentation only; SQL role enforcement is authoritative.

## Role-aware Admin workspaces

Minimum role rank:
- Viewer — Dashboard, Providers, Courses, Campuses, Completeness/readiness and Scholarships.
- Curator — Evidence and Review Queue.
- Pipeline Operator — Jobs and Regulatory Sources.
- PIM Admin — Attribute families/groups/options and completeness-profile governance.
- Platform Admin — privileged Layer 1 operational controls under their separate service/admin contracts.

A lower-ranked role must receive a server-side permission failure even if it manually calls the RPC.

## Provider / Course / Campus detail

Provider, Course and Campus rows must support governed detail views without changing canonical identity.

Detail presentation should expose, where available:
- stable identity/key and authoritative identifiers;
- lifecycle/publication state;
- source identity and source URL;
- evidence artifact references and content hashes;
- validity / last-verified timestamps and history context;
- related Courses/Campuses/Providers as relational links rather than copied identity.

## Fee semantics

Course detail must present regulatory and provider-current fees as separate concepts.

### CRICOS registered course cost

`catalogue.course_fees.basis = 'registered_total_course'`

Presentation requirements:
- label explicitly as CRICOS registered total-course cost / regulatory fee;
- preserve `fee_type`, amount, currency, fee year, audience, source snapshot and evidence;
- never annualise this value;
- never present it as the Provider's current published tuition fee.

### Current Provider fee

Provider-current observations are shown separately and retain their published fee year/basis, campus/intake scope, source and evidence.

If no Provider-current observation exists, show an explicit empty state. Do not substitute a CRICOS registered amount.

## Completeness and readiness

Admin completeness/readiness is a governance view, not automatic Search admission.

The UI may show operational core readiness from governed presence signals such as registration, structure, fee, intake, English and description, but must state that this does not itself publish the Course to Search.

Regulatory completeness, publication readiness and Search admission remain distinct concepts.

## Scholarship relational UX

Scholarships remain relational entities. Detail/workspace UX should surface the governed structure rather than flatten it into Course fields:
- identifiers;
- offering cycles;
- application windows;
- scopes;
- criterion groups and criteria;
- award tiers;
- coverage;
- evidence/source state.

Scholarship identity or eligibility must not redefine Provider/Course identity.

## Evidence / Storage posture

The evidence bucket remains private. No generic browser Storage object policy is required for this gate.

Admin evidence visibility is mediated through governed metadata/read APIs. Future signed-object access, if required, must be explicitly authorised and time-bound rather than making the bucket public.

## Security gate evidence

Authoritative UAT: `docs/uat/m1-pim-hardening-gate-2026-08-19.md`.

The gate passed with browser SECURITY DEFINER exposure retired. Supabase leaked-password protection is recorded as unsupported on the current Free organisation plan rather than silently waived.
