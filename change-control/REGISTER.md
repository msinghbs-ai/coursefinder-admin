# CourseFinder Change Control Register

**Status:** AUTHORITATIVE INDEX  
**Effective:** 23 August 2026

This file indexes material CourseFinder changes. Detailed records live in category folders under `/change-control/`.

## Current gate summary

> **M1-PIM-FINALISATION:** controls `001`, `005`–`015` are **CLOSED / PASS**. Accepted PIM Admin remains v2.12.
>
> **M1-PIPELINE-OPS:** `CF-CHG-20260821-016` is **CLOSED / PASS**. Pipeline Ops v1.0 remains accepted.
>
> **M1-EVIDENCE-UX:** `CF-CHG-20260821-017` is **CLOSED / PASS**. Evidence v1.0 remains the accepted private Evidence/provenance workspace.
>
> **M1-DATA-QUALITY-READINESS:** `CF-CHG-20260821-018` is **CLOSED / PASS**. Data Quality v1.0 semantics remain accepted.
>
> **M1-UAT-HARNESS:** `CF-CHG-20260822-019` is **CLOSED / PASS**. Final deployed run `32600027592` passed 3/3 tests on both desktop and mobile and publishes SHA-bound commit statuses.
>
> **ACCESS ADMIN:** `CF-CHG-20260822-020` is **CLOSED / PASS**. Access Admin v1.0 is accepted for create/invite, role replacement, non-Platform-Admin expiry, disable/re-enable, audit and lockout protection.
>
> **DATA QUALITY CONCURRENT HARDENING:** `CF-CHG-20260823-021` is **CLOSED / PASS**. Aggregate readiness uses private timestamped snapshots refreshed every 15 minutes; exceptions remain live/paged; mobile Data Quality scrolling is accepted.
>
> **LEAKED PASSWORD PROTECTION:** `CF-CHG-20260823-022` is **DEFERRED FOR PILOT — MANDATORY PRODUCTION GO-LIVE GATE**. Pilot may retain the documented Free-plan warning as a bounded non-production exception. Production must use an eligible Supabase plan, enable leaked-password protection and pass Auth/RBAC UAT before production security sign-off/cutover.

| Change ID | Category | Title | Initiated | Status | UI / capability | Record |
|---|---|---|---|---|---|---|
| CF-CHG-20260820-001 | 30-admin-pim-ux | PIM field semantics, fee presentation and Admin Guide | 20 Aug 2026 | CLOSED / PASS | PIM semantics retained through v2.12 | `30-admin-pim-ux/CF-CHG-20260820-001-pim-field-semantics-fees-admin-guide.md` |
| CF-CHG-20260820-002 | 40-layer2-enrichment | UQ Course Facts coverage expansion | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-002-uq-course-facts-coverage-expansion.md` |
| CF-CHG-20260820-003 | 40-layer2-enrichment | QUT Course Facts acquisition deferred | 20 Aug 2026 | DEFERRED | N/A | `40-layer2-enrichment/CF-CHG-20260820-003-qut-course-facts-acquisition-deferred.md` |
| CF-CHG-20260820-004 | 40-layer2-enrichment | UQ Course Facts coverage expansion v3 | 20 Aug 2026 | CLOSED / PASS | N/A | `40-layer2-enrichment/CF-CHG-20260820-004-uq-course-facts-coverage-expansion-v3.md` |
| CF-CHG-20260820-005 | 30-admin-pim-ux | Restore Insights / Enrichment and governed read boundary | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-005-restore-insights-enrichment-governed-read.md` |
| CF-CHG-20260820-006 | 30-admin-pim-ux | Evidence provenance workspace completeness/semantics | 20 Aug 2026 | CLOSED / PASS | Evidence baseline | `30-admin-pim-ux/CF-CHG-20260820-006-evidence-provenance-workspace.md` |
| CF-CHG-20260820-007 | 30-admin-pim-ux | Catalogue paging and exact identity search | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-007-catalogue-paging-exact-identity-search.md` |
| CF-CHG-20260820-008 | 30-admin-pim-ux | Provider / Course / Campus geography semantics | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-008-provider-course-campus-geography-semantics.md` |
| CF-CHG-20260820-009 | 30-admin-pim-ux | Intake and English requirement semantics | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-009-intake-english-requirement-semantics.md` |
| CF-CHG-20260820-010 | 30-admin-pim-ux | Course taxonomy source lineage | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-010-course-taxonomy-source-lineage.md` |
| CF-CHG-20260820-011 | 30-admin-pim-ux | Scholarship compound eligibility/cycle/scope semantics | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-011-scholarship-compound-semantics.md` |
| CF-CHG-20260820-012 | 30-admin-pim-ux | Course lifecycle, publication, readiness and Search state | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-012-course-lifecycle-publication-readiness-search-state.md` |
| CF-CHG-20260820-013 | 30-admin-pim-ux | Admin operations role boundary and safe Sources projection | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-013-operations-role-boundary.md` |
| CF-CHG-20260820-014 | 30-admin-pim-ux | PIM Attribute Options and Completeness Profile governance | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-014-pim-attribute-option-completeness-governance.md` |
| CF-CHG-20260820-015 | 30-admin-pim-ux | PIM operational UI/browser acceptance finalisation | 20 Aug 2026 | CLOSED / PASS | PIM v2.12 | `30-admin-pim-ux/CF-CHG-20260820-015-pim-operational-ui-browser-acceptance.md` |
| CF-CHG-20260821-016 | 80-uat-release-operations | M1 Pipeline Operations governance/acceptance | 21 Aug 2026 | CLOSED / PASS | Pipeline Ops v1.0 | `80-uat-release-operations/CF-CHG-20260821-016-m1-pipeline-ops-governance-baseline.md` |
| CF-CHG-20260821-017 | 30-admin-pim-ux | M1 Evidence UX operational workspace | 21 Aug 2026 | CLOSED / PASS | Evidence v1.0 | `30-admin-pim-ux/CF-CHG-20260821-017-m1-evidence-ux-operational-workspace.md` |
| CF-CHG-20260821-018 | 30-admin-pim-ux | M1 Data Quality Readiness operational gate | 21 Aug 2026 | CLOSED / PASS | Data Quality v1.0 | `30-admin-pim-ux/CF-CHG-20260821-018-m1-data-quality-readiness.md` |
| CF-CHG-20260822-019 | 80-uat-release-operations | M1 UAT Harness automated operational acceptance | 22 Aug 2026 | **CLOSED / PASS** | UAT Harness v1.0 | `80-uat-release-operations/CF-CHG-20260822-019-m1-uat-harness.md` |
| CF-CHG-20260822-020 | 70-security-platform | Admin user and role management | 22 Aug 2026 | **CLOSED / PASS** | Access Admin v1.0 | `70-security-platform/CF-CHG-20260822-020-admin-user-role-management.md` |
| CF-CHG-20260823-021 | 80-uat-release-operations | Data Quality overview snapshot and concurrent UAT hardening | 23 Aug 2026 | **CLOSED / PASS** | Data Quality v1.0 operational hardening | `80-uat-release-operations/CF-CHG-20260823-021-data-quality-overview-snapshot.md` |
| CF-CHG-20260823-022 | 70-security-platform | Supabase leaked password protection | 23 Aug 2026 | **DEFERRED FOR PILOT — PRODUCTION GATE** | Supabase Auth hardening | `70-security-platform/CF-CHG-20260823-022-supabase-leaked-password-protection.md` |

## Current programme baseline

- Master Project Plan: `docs/coursefinder-master-project-plan-v1.61.md`;
- Pilot-to-Production Plan: `docs/coursefinder-pilot-to-production-project-plan-v1.10.md`;
- Running Build: `docs/coursefinder-running-build-v2.63.md`;
- Architecture: `docs/coursefinder-database-architecture-v2.10.39.md`;
- Admin/PIM design decisions: `docs/coursefinder-admin-pim-design-decisions-v1.13.md`;
- Admin operating guide: `docs/coursefinder-pim-admin-guide-v1.14.md`;
- Data Quality semantic contract: `docs/coursefinder-data-quality-readiness-contract-v1.0.md`;
- UAT Harness technical acceptance: `docs/uat/coursefinder-m1-uat-harness-technical-acceptance-2026-08-22.md`;
- Access Admin technical UAT: `docs/uat/coursefinder-access-admin-v1-technical-acceptance-2026-08-22.md`;
- Access Admin deployed evidence: `docs/uat/coursefinder-access-admin-v1-deployed-browser-evidence-2026-08-22.md`;
- Production leaked-password gate decision: `docs/uat/coursefinder-supabase-leaked-password-protection-production-gate-2026-08-23.md`.

## Accepted runtime authority

Pilot:

`msinghbs-ai/Coursefinder-Pilot@e877e3e28cd281ff3751a70bc500eeb0d8f31963`

Runtime marker:

`PIM Admin v2.12 · Pipeline Ops v1.0 · Evidence v1.0 · Data Quality v1.0 · Access Admin v1.0 · governed`

Final deployed automated UAT:

- run `32600027592`;
- desktop 3/3 PASS, artefact `9482641524`;
- mobile 3/3 PASS, artefact `9482641597`;
- exact-SHA desktop/mobile commit statuses: success;
- final runtime evidence: 0 HTTP 5xx / 0 HTTP 4xx / 0 console/page errors.

## Preserved technical/semantic baseline

- AU: 1,546 Providers / 26,648 Courses;
- NZ: 409 Providers / 6,457 Courses;
- AU+NZ: 1,955 Providers / 33,105 Courses;
- all-country Courses: 43,461;
- Search projection: 33,105 Course documents;
- regulatory fee: 26,326 present / 191 source-null / 6,457 not-applicable / 131 zero;
- browser read boundary: `public.admin_read(text,jsonb)`;
- Evidence minimum rank 3; Pipeline minimum rank 4; Access Admin rank 6;
- Search admission remains distinct from publication;
- no PIM v2.13 release is claimed.

The Pilot Supabase leaked-password-protection warning is an explicitly documented temporary exception under `CF-CHG-20260823-022`. It is **not** considered resolved and is **not transferable to Production**. Production security sign-off/cutover requires this control to be enabled and UAT-proven.