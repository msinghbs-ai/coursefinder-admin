# M1-PIM-HARDENING Gate UAT — 19 August 2026

**Gate:** PASS  
**Target:** `coursefinder_Pilot` (`fxcwkweaxjtknorudmwp`, Mumbai)  
**Identity posture:** Provider/Course canonical identity unchanged.

## Implemented gate controls

- Browser catalogue/PIM reads now enter through `public.admin_read(text,jsonb)` only.
- `public.admin_read` is `SECURITY INVOKER` and delegates to a private `security.admin_read_impl` implementation.
- Every legacy `public.ui_*` `SECURITY DEFINER` bridge is no longer executable by `anon` or `authenticated`; service role only.
- Server-side application-role checks are enforced by `security.current_role_rank()`.
- Role thresholds:
  - Viewer+ — Dashboard, Provider, Course, Campus, Completeness and Scholarship catalogue/detail.
  - Curator+ — Evidence and Review Queue.
  - Pipeline Operator+ — Jobs and Regulatory Sources.
  - PIM Admin+ — Attribute/PIM governance.
  - Platform Admin — existing Layer 1 privileged controls remain separately governed.
- Legacy browser compatibility views have no `anon` or `authenticated` privileges; service-role SELECT only.
- Evidence Storage bucket remains private and has no browser object policies.
- Course detail separates `cricos_registered` fee observations from `provider_current` fee observations.

## Functional UAT

| Test | Expected | Result |
|---|---|---|
| Viewer reads Dashboard | Allowed | PASS |
| Viewer reads Evidence | Denied | PASS |
| Viewer reads Attributes | Denied | PASS |
| Curator reads Evidence | Allowed | PASS |
| Curator reads Jobs | Denied | PASS |
| Pipeline Operator reads Jobs | Allowed | PASS |
| Pipeline Operator reads Attributes | Denied | PASS |
| PIM Admin reads Attributes | Allowed | PASS |
| Platform Admin reads Scholarship relational detail | Allowed | PASS |
| Scholarship detail returns relational scope/tier data | Structured relational result | PASS |
| AU Course fee provenance | CRICOS and Provider-current separated | PASS |
| Compatibility views available to authenticated browser role | No | PASS |
| Legacy `public.ui_*` SECURITY DEFINER executable by authenticated | No | PASS |
| Legacy `public.ui_courses_decision_page` executable by anon | No | PASS |

## Fee provenance UAT

Sample AU Course: `Bachelor of Veterinary Science (Honours) [End-on]`.

Returned by governed Course detail:
- `cricos_registered`: 3 observations;
- first basis: `registered_total_course`;
- includes `estimated_total_course_cost`;
- `provider_current`: 0 observations.

This is the required behaviour. CRICOS registered total-course cost is not annualised or relabelled as the Provider's current fee.

## Security advisor result

After hardening, the earlier browser-executable SECURITY DEFINER warnings are absent.

Remaining advisor classes:
- INFO — RLS enabled with no policy on closed internal schemas. This is intentional deny-by-default architecture; authenticated browser roles have no direct table privileges.
- WARN — leaked-password protection disabled. The owning Supabase organisation is on the Free plan; leaked-password protection is a Pro-and-above Auth feature and is therefore not supported on the current plan.

## Storage / RLS posture

- `evidence` bucket: private (`public=false`).
- File limit: 50 MB.
- Browser Storage policies: none.
- Internal catalogue/PIM/pipeline/scholarship tables remain RLS-protected and have no direct authenticated SELECT grants.

## Repository parity

- `supabase/production-migrations/055_pim_operational_security_gate.sql`
- `src/supabase.js` routes reads through `admin_read`.
- `src/main.jsx` adds role-aware navigation and Provider/Course/Campus/Scholarship detail, evidence/history, completeness/readiness and fee provenance presentation.

## Gate decision

**PASS.**

M1-PIM-HARDENING may run in parallel with the serial ingestion lane. This gate does not promote any enrichment fact into Search and does not change canonical Provider/Course identity.
